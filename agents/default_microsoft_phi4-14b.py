import os
from langchain_ollama import ChatOllama
from browser_use import Agent
from browser_use.browser.session import BrowserSession
from dotenv import load_dotenv
import asyncio

load_dotenv()

# Set environment variable to disable Chromium sandbox
os.environ['CHROME_DEVEL_SANDBOX'] = '/usr/lib/chromium-browser/chrome-sandbox'

llm = ChatOllama(model="phi4:14b")

async def main():
    # Create a browser session with no-sandbox arguments
    browser_session = BrowserSession(
        headless=True,
        args=[
            '--no-sandbox',
            '--disable-setuid-sandbox', 
            '--disable-dev-shm-usage',
            '--disable-extensions',
            '--disable-gpu'
            ]
    )
        
    agent = Agent(
        task="Imagine that you are a real human, and that you have access to a computer. Perform real actions on that computer such as making searches on google, browsing youtube, and shopping online. You can imagine you are any gender. Make sure to take breaks and sleep.",
        llm=llm,
        browser_session=browser_session
    )

    
    result = await agent.run()
    print(result)

if __name__ == "__main__":
    asyncio.run(main())
