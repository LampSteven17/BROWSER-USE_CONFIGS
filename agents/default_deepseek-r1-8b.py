from langchain_ollama import ChatOllama
from browser_use import Agent
from dotenv import load_dotenv
load_dotenv()

import asyncio

llm = ChatOllama(model="deepseek-r1:8b")

async def main():
    agent = Agent(
        task="Imagine that you are a real human, and that you have access to a computer. Perform real actions on that computer such as making searches on google, browsing youtube, and shopping online. You can imagine you are any gender. Make sure to take breaks and sleep.",
        llm=llm,
        
        # Add browser configuration to fix sandboxing issue
        browser_config={
            'headless': True,
            'args': [
                '--no-sandbox',
                '--disable-dev-shm-usage',
                '--disable-setuid-sandbox'
            ]
        }
    )
    result = await agent.run()
    print(result)

asyncio.run(main())
