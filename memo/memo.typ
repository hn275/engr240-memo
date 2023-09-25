#show link: underline
#align(
    left,
    text(
        font: "Nimbus Sans",
        24pt
    )[*Memorandum*]
)

#grid(
    columns: (60pt, 1fr),
    align(left)[
        TO: \
        FROM: \
        DATE: \
        SUBJECT:
    ],
    align(left)[
        Dr. Kate Skipsey \
        Hal Nguyen \
        September 24#super[th], 2023 \
        Enhancing Web Services API
    ]
)

#line(length: 100%)

#set text(11pt)
After exploring Ocean Networks Canada's Web services API, I've discorvered some 
vulnerabilities, as well as issues with accessibilities with the front facing client. I have 
created this memorandum to address the mentioned issues, as well as providing some possible
solutions.

#set text(14pt)
= Client's Profile

#set text(11pt)
Ocean Networks Canada (ONC) is an not-for-profit society, hosted and owned by University of 
Victoria. ONC provides ocean data observed from various equipments, making ocean intelligence
accessible to the public.

One of the many ways for ONC to make this possible is through their Web Services API 
(Ocean Data 3.0 portal). While it is a valuable tool, the developer experience could still be 
improved, as well as the security of the web infrastructure.

#set text(14pt)
= Problem Definition

#set text(11pt)
To enhance the Web Services API, the problem can be defined as following:
- Need statement: To improve the web interface, and to enhance the current 
  #link("https://www.cloudflare.com/learning/bots/what-is-rate-limiting/")[rate limiter] [1].
- Goal statement: The targeted consumers are software developers/engineers, and data scientists.
  Having a documentations is crucial for all API consumers alike. Since this service is completely
  free, it should also have sufficient protection against malicious agents, starting with prevention
  of 
  #link("https://www.cloudflare.com/learning/ddos/what-is-a-ddos-attack/")[Denial-of-Service attack]
  (DDoS) [2].
- Objectives:
  - Documentations: Improving the API consumers experience with transparent documentations.
  - Accessibility: Reasonable contrast for documentation portal.
  - Web Security: The rate limiting mechanism protects against site scrapers and bots.
- Constraints:
  - Funding: Software developers are expensive, even for small changes.
  - Backwards Compatibility: Any changes happened to the API will need to be able to maintain 
    backwards compatibility (not introduce any breaking changes to the current consumers).

#set text(14pt)
= Solutions

#set text(11pt)
These are 3 solutions provided for the 3 mentioned issues, respectively: documentation, 
accessibility, and security.
#pagebreak()

== Documentations

In order to consume the API, you need to obtain an API key from OCN, and with each request, this 
secret key has to be attached to the request targeted URLs in form of query parameters, for example
the following request will returns all locations that OCN has their equipments active:

#set align(center)
#block(
  fill: luma(230),
  inset: 8pt,
  radius: 4pt,
  "https://data.oceannetworks.ca/api/locations?token=<your-secret-api-key>"
)

#set align(left)
When first landing on the #link("https://data.oceannetworks.ca/OpenAPI")[documentations site], the
"Before you get started" section should mention how to:
+ Obtain the secret API key,
+ How to attach this key to each request (request header, URL parameters, etc etc..),
+ The base URL for each services ("data.oceannetworks.ca/api").



== Accessibility

Increasing the contrast by having a darker color on the text. The two figures below show an example
of what the current site looks like (Figure 1), and what it could be (Figure 2):

#set align(center)
#figure(
    image( "./ocnissue.png", width: 50%),
    caption: [Current site implementation.],
)
#figure(
    image( "./ocnissue-resolved.png", width: 50%),
    caption: [Suggested site implementation.],
)
#set align(left)

== Security

The current rate limiter implementation is done with a session ID, assigned via HTTP cookie, 
which protects the infrastructure from attackers who are on a web browsers. However, a #link("https://github.com/hn275/engr240-memo/blob/main/memo/main.go")[script] can 
be written in a such way that on each request, while having the same API key, does not encapsulate 
the HTTP cookie, and thus allow the attacker to make as many request as they like, which would 
overload the server, and thus preventing other users from consuming this service.

A better solution for rate limiting is to *index each request by the API key* instead of their
session ID, this will now eliminates the thread of DDoS on both browsers or individual scripts.

#set text(14pt)
= References

#set text(11pt)
#grid(
    columns: (20pt, 100%),
    align(left)[
        [1] \
            \
        [2] \
    ],
    align(left)[
        "What is Rate Limiting?", Cloud Flare Learning, https://www.cloudflare.com/learning/bots/what-is-rate-limiting/, (accessed Sep. 24#super[th], 2023). \
        "What is a DDos attack?", Cloud Flare Learning, https://www.cloudflare.com/learning/ddos/what-is-a-ddos-attack/, (accessed Sep. 24#super[th], 2023). \
    ]
)
