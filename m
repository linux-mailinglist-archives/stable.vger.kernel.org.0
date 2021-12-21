Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED6D47B912
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 04:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbhLUDll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 22:41:41 -0500
Received: from mout.gmx.net ([212.227.15.15]:36507 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230157AbhLUDll (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Dec 2021 22:41:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1640058099;
        bh=tVINHS4jvwne6uYKSUagzwIrKVOdLTF2oyFSnxZAS/8=;
        h=X-UI-Sender-Class:Date:From:To:Subject:Cc;
        b=jezU1LvuwnncplP0HhhaCmg0drKyYfORLzAtc5Bi4CavgRsrE2EPEePPfeQ4At9KT
         LlTkH1FTnVsqrMmVJZmqGg9WQkr3bwJzSRLWWLgk2HT1S0u0IfCXNp3OqE0rd+IhOU
         rv7BAL7F0rIZb6V395MrZeEAyFsmula8xahm6/5g=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.33.110]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MvbFs-1mAR0v2TUU-00siC2; Tue, 21
 Dec 2021 04:41:39 +0100
Message-ID: <056cc6ea-3556-7d79-1b23-43c8defcab33@gmx.de>
Date:   Tue, 21 Dec 2021 04:41:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.15 000/177] 5.15.11-rc1 review
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:HJXhn8qA3aOK2z7xNVj3ar+/WGQhS3LQ7e0Tu3ftZnD8f7ckIZv
 6PbP33AxdLRJiY0SQJp5XgHXeTqMEWeqf4D0Mnnyxzd/dgks1WAWMU/TpQb+KfKJcJ/81sp
 sAULvIaRaLO9PmPRd1xxKuoSI5mj07vsAKnqGKTJvZU8dMjXAdBxwJvLfnQyYH0G3IuOBua
 EUJCRk9E7oaGG1m/Ju0zw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6eASxNzuEVs=:WR3grzz9VGBE6Vh45PQSWz
 RHxLG+EkATJ0d9zzHMmaXL2sSNYhnIlQx7Qyam/2s40zkVq9HQMaAkMKchXIs9luVVcgWX/Yi
 UR86ZuhivJBI3XY+37MDMfJjU1QphkklDB9s0UfDMTzKsjkqSozVFhb7/UIpMW/DfJ6husALZ
 QhRyI92274umswri8DLSEtPE5ig3fOkWX3JlhYZ6jJHG1+f+XzdnxrpDx9q1iZT3gn7ZZ3Pfv
 cG6S7q3fijObLqNZaXsm96ynfO1nbO7OklKOtSloK/thBqsXth4ZtGi7yXYTP4AEhk8UZa/2z
 Fl8/aCl5i+jDhlEEB531kmIuoj93pUA2AUAoD7I+L2JVAUIYmUleygH845j4aYYDiczZL62R7
 +bpWi8yM3yjUeD0BwasSZ1p5eEYLh8atgJyH4/J2OuO5mP4DGPY/t9KPpTf66eoj4H6owT4kA
 4UNWpfPlBOb/jSmOIWFi1kOjaKflA49HeBPoC/r6Ne6/bxW2E14oPkDwlrp2kOkrgJpDEexT3
 CeTz9lzmzrBJylS72jm44W6ftSf7c6bv4INOEc9nOYsz7ru49YMwKG5f7cv4p0yIDyNzLVsHF
 VAEhybyfYRIjRQLZJwK35Xv2X4oYSFFbC83GFL2qXtjvw3fDizdUtZSJQraUQewZ18/IxyO43
 AOzlFuV5Lhy4FZSyklP2ZaxVj//H1XHbQBBcD8PxGIRvzSkagGIT73RZyIFltH7fcaAB6ycSS
 RcHnHGNQCbEvP4hljwIa2YZU6rGTVqevAriRQ7///L8IyVliKn5M7uJIhGE6lHPJRbVuaV1rT
 2cVpXRVWpYZDDRER4wXZDRzPQ9iJPd6FAbDflqOCMINn3euPGs5J/06+/JumhDyQkdtTnNtvH
 YvUduD/4YLO3nA78sJ+jlLvAzr9gO4UnfujG8jYDR9tpSdZNOrRSmIHl+MAfxPWgQnfwVyfK2
 NhZ84KmMv4lk358aqclERVC99/loL6TALcTIjbjSfHJch2AOhVYf0UAcUZqItjvX13lHYuk/5
 Wo8hnqTb9GQP9taTPo3xibExvbtNctUle9gTdq3HME19Z2yvVQS2fmru1Gf4rZl34Lq6lsP9V
 iF7vP2aPpWencQ=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.15.11-rc1  successfully compiled, booted and suspended on an x86_64
(Intel i5-11400, Fedora 35)

Tested-by: Ronald Warsow <rwarsow@gmx.de>


Thanks

Ronald
