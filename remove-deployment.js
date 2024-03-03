const VERCEL_TOKEN = process.env.VERCEL_TOKEN;
const BRANCH_NAME = process.env.BRANCH_NAME;
const VERCEL_PROJECT_ID = process.env.VERCEL_PROJECT_ID;

// ES モジュールをロードするための動的インポート
const fetch = (...args) =>
  import("node-fetch").then(({ default: fetch }) => fetch(...args));

const getDeployments = async () => {
  const response = await fetch(
    `https://api.vercel.com/v6/deployments?projectId=${VERCEL_PROJECT_ID}`,
    {
      headers: { Authorization: `Bearer ${VERCEL_TOKEN}` },
    }
  );
  const { deployments } = await response.json();
  return deployments;
};

const removeDeployment = async (id) => {
  await fetch(`https://api.vercel.com/v13/deployments/${id}`, {
    method: "DELETE",
    headers: { Authorization: `Bearer ${VERCEL_TOKEN}` },
  });
};

const run = async () => {
  const deployments = await getDeployments();
  console.log("aaa", deployments[0].meta.githubCommitMessage);
  console.log("bbb", deployments[0]);
  console.log(BRANCH_NAME);
  const targetDeployments = deployments.filter((d) =>
    d.meta.githubCommitMessage.includes(BRANCH_NAME)
  );
  console.log("targetDeployments", targetDeployments);
  for (const deployment of targetDeployments) {
    console.log(`Removing deployment: ${deployment.url}`);
    await removeDeployment(deployment.uid);
  }
};

run().catch(console.error);
