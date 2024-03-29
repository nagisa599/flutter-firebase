const VERCEL_TOKEN = process.env.VERCEL_TOKEN;
const BRANCH_NAME = process.env.BRANCH_NAME;
const VERCEL_PROJECT_ID = process.env.VERCEL_PROJECT_ID;

// ES モジュールをロードするための動的インポート
const fetch = (...args) =>
  import("node-fetch").then(({ default: fetch }) => fetch(...args));

const getDeployments = async () => {
  try {
    const response = await fetch(
      `https://api.vercel.com/v6/deployments?projectId=${VERCEL_PROJECT_ID}`,
      {
        headers: { Authorization: `Bearer ${VERCEL_TOKEN}` },
      }
    );
    const { deployments } = await response.json();
    console.log(deployments);
    return deployments;
  } catch (error) {
    console.error(error);
  }
};

const removeDeployment = async (id) => {
  try {
    const response = await fetch(
      `https://api.vercel.com/v13/deployments/${id}`,
      {
        method: "DELETE",
        headers: { Authorization: `Bearer ${VERCEL_TOKEN}` },
      }
    );
    if (!response.ok) {
      console.error(`Error: ${response.statusText}`);
    }
    const data = await response.json(); // または response.text() で生のレスポンスを確認
    console.log("Response data:", data);

  } catch (error) {
    console.error("Request failed:", error);
  }
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
