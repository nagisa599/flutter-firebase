const fetch = (...args) =>
  import("node-fetch").then(({ default: fetch }) => fetch(...args));

const getDeployments = async () => {
  const response = await fetch(
    `https://api.vercel.com/v6/deployments?projectId=${process.env.VERCEL_PROJECT_ID}`,
    {
      headers: { Authorization: `Bearer ${process.env.VERCEL_TOKEN}` },
    }
  );
  const { deployments } = await response.json();
  return deployments.filter(
    (d) => d.meta.githubCommitRef === process.env.GITHUB_REF_NAME
  );
};

const removeDeployment = async (id) => {
  await fetch(`https://api.vercel.com/v13/deployments/${id}`, {
    method: "DELETE",
    headers: { Authorization: `Bearer ${process.env.VERCEL_TOKEN}` },
  });
};

(async () => {
  const deployments = await getDeployments();
  for (const deployment of deployments) {
    console.log(`Removing deployment: ${deployment.url}`);
    await removeDeployment(deployment.uid);
  }
})().catch(console.error);
