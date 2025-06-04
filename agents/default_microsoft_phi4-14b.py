from langchain_ollama import ChatOllama
from browser_use import Agent
from dotenv import load_dotenv
import asyncio

load_dotenv()

llm = ChatOllama(model="phi4:14b")

async def main():
    agent = Agent(
        task="Imagine that you are a real human, and that you have access to a computer. Perform real actions on that computer such as making searches on google, browsing youtube, and shopping online. You can imagine you are any gender. Make sure to take breaks and sleep.",
        llm=llm,
        headless=True,
        disable_security=True
    )
    
    result = await agent.run()
    print(result)

if __name__ == "__main__":
    asyncio.run(main())
