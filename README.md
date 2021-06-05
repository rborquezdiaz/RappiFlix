# RappiFlix
A quick glimpse of the next great streaming service! (A small essay on the VIPER architecture). PS. I added a small easter egg somewhere in the app, see if you can find it haha.

## Architecture (VIPER & Application Layers)

Regarding application layers, it will be much easier to explain this using the VIPER architecture of this project. There are 5 individual protocols that set the overall blueprints of how the application should behave. This generates a streamlined flow of data, that makes it possible to uphold the Single Responsability Principle of Clean Coding. These protocols are what I like to call Viper Core and my own simplified interpretation of the VIPER architecture:

### AnyView ###

This will always be the last step on the flow of Data through the app. All ``UIViewControllers`` in the application should conform to this protocol, as it allows communication to its corresponding presenter. It contains three different functions that allow the reception of the generic ``AnyEntity`` models; it's generic enough so that any kind of data can be received, but it can also be overriden as necessary to handle any situation. These functions are:

* func update(with entity : AnyEntity)
* func update(with entityArray : [AnyEntity])
* func update(with errorMessage : String)

### AnyInteractor ###

This protocol might seem empty at first glance, but its importance is better reflected on the classes that conform to it. By having access to the presenter as well, it's really flexible to adapt it as required. This protocol's classes main responsability is requesting the necessary data from the backend service and reacting accordingly. The keywork here is **requesting**, since it won't do the fetching itself. 

This class requests help to the ``NetworkManager``, which is responsible of actually building the request (in this case, a ``ServerRequest``which has been specifically adapted to work for the MovieDB API.)

Another really important helper class that works with the interactor is the ``CacheCentral`` class. This is the Singleton that makes it possible to cache different entities through the app and allows functionality even when offline. 

### AnyPresenter ###

The idea behind this protocol is the communication between AnyInteractor and AnyView. This is usually splitted between two protocols, one for informing of UI events happening on the View and another one for passing back the data requested by the Interactor; but for the sake of building a generic architecture that's flexible and easy to adapt it's contained inside the AnyPresenter protocol. (Please note, that I do believe this is in line with the **Single Responsability Principle**, because it main responsability remains the same: passing data.)

### AnyEntity ###

This one is my favorite and the one I put most of my thoughts on. On one hand, since **entities** in the VIPER are usually the same as the **Model** in other architectures (MVVM for example), the first thing that came to mind was inheritance. However, the more I thought about it, the more I wanted to make a POP (Protocol Oriented Programming) solution instead of an OOP one. The reason being is I wanted it to remain flexible and generic, but I also wanted it to create a strong foundation on what other entities should be and what they should be capable of doing.

I finally came upon the solution through the ``Codable`` protocol, but I made my own custom implementation, with the capability of turning the ``ÀnyEntity`` models into dictionaries, data, or anything that could be needed by the API. 

### AnyRouter ###

The main responsability of this protocol is to establish a connection between the different parts of the architecture so that navigation is very streamlined through the app. This is the protocol that I'd like to put more thought on in the future, since navigation is inherently bound to ``ViewControllers`` in ``Swift``, and at least on this iteration on the project, it's still relatively reliant on the view.


## Single Responsability Principle

This is what I like to call the core of the Clean Code principles. If you've ever used an architecture like MVC or ever worked with Procedural Programming, you know how easy it is to end up with massive classes that end up doing a lot of everything. Like I mentioned before, it's even worse that in the case of ``iOS``, controllers are inherently bound to a view already (I use XIBs for this very reason). This should be the number one focus of any developer.

## Clean Code (What it means for me)

As I mentioned before, the single responsability principle should be a developer compass in the decision making process of an ever growing architecture. When you begin a new project, is very easy to have an idea behind every single decision you make. But it's a dangerous road, because the bigger a project gets, the easier it is to deviate from the right path. Which brings me to some of what I consider some of the best coding practices.

The first one being DRY, don't repeat yourself. This means, that if you ever need to use code you've already written, make sure you externalize and generalize it so that other classes can make use of it. Another important one is leaving comments whenever you can. You don't always have the opportunity to do so, but it's polite to do so when you know a particular functionality is complicated and you are not working alone on the project.

And then, there's my golden rule: KEEP IT SIMPLE. I personally feel that a lot of developers like to show off by overengineering solutions to a problem. Keeping things simple is a talent and something that should always be strived for. If your fellow developers can read your code, understand it and then add something extra to it, you've done your job right.

