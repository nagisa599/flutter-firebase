const fetch = require("node-fetch");
const VERCEL_TOKEN = process.env.VERCEL_TOKEN;
const BRANCH_NAME = process.env.BRANCH_NAME;

const getDeployments = async () => {
  const response = await fetch(
    `https://api.vercel.com/v6/deployments?teamId=YOUR_TEAM_ID`,
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
  const targetDeployments = deployments.filter((d) => d.name === BRANCH_NAME);

  for (const deployment of targetDeployments) {
    console.log(`Removing deployment: ${deployment.url}`);
    await removeDeployment(deployment.uid);
  }
};

run().catch(console.error);
