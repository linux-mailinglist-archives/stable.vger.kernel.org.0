Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3073FDA506
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 07:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732174AbfJQFNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 01:13:52 -0400
Received: from mout.gmx.net ([212.227.17.20]:39353 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728999AbfJQFNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Oct 2019 01:13:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1571289230;
        bh=J7FP3t4JMdLSDPBp9qhs5mJ2AV+f9hOJR9uxZdxXzLA=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=VJMgi6kE+NXdhNh9mDCgofv9eQEjnZj8sBRZTXq+O8iQGblTj3/fiUjKpsCtQrtjR
         yz/zuJ5CDgIsPDqfKYpnF4q8c8aGjM92sRNrYGIV56pFLRxWFxpBcCOKwrx+50Hb1F
         G2+CGQeyXPiLYy8tfhZLIOpK5KVpEty9qLaqG6LA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.184.228]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MZktj-1iW89B16xT-00WmA8; Thu, 17
 Oct 2019 07:13:50 +0200
Subject: Re: [PATCH] parisc/pci: Switch LBA PCI bus from Hard Fail to Soft
 Fail mode
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20191014192901.GA13704@ls3530.fritz.box>
 <20191016211843.GC856391@kroah.com>
From:   Helge Deller <deller@gmx.de>
Message-ID: <ae03cfe5-b9d0-e05d-5c54-80ee3f91fbc4@gmx.de>
Date:   Thu, 17 Oct 2019 07:13:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191016211843.GC856391@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:luEjPkmLLs0jR2yzivFV3wI1jTqbUsoHqJ31Qu7kayfC8t7rtGQ
 W1PXJnr8vzhDitzR/wfa8epuBXMwtiux25q5AcSfjhV3eImMapyL9bQRvTxiYcwvaS0i4Al
 XdaU5urv7+OzogjJyXZzR4KpOgoM2KXzSho6/+bQqazWN3R//PRyXLyWuKeZIFv49A7wbE3
 UGRB3klH1lXyyDan2ozzQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:d7QIWvSRtkE=:EhafhxMAlH8WVJRkveEFuX
 sOKeWRwBHB1u9E4yOBiW+3yVxN3OZd4Abw3Ji4J0zxFWtiobjaoaF2k7CTYovVj3pe5DUpdxb
 Ab/aHumgivhP2s7vEG2F75W09B3zYEfDP8nKpGdfw/4lOxKC3RmCb5tp980xH4OH2b8I1FYjf
 MzQkSTbS6Sg5243HmHihWP60tiFesIMuX3ITOeIdyickdElzZf6fn9+Hnwi3rOIVSWNC4L7WR
 IYdWfrLjSg4/55rYpH40qkVJj7+pSS3hWsa7GTD45zSNYuEX2mgL5ehVahdrGpbFS/71FLb0T
 JhCUdS2uu1uNxae7nvOEtrFPoyu3hOHHI8LgvAZoOLZlX4iHPN4265OCUXRiJFdCQKOTj5iJE
 5LWAeiXrwwgyBCP13IWUqXqlev3m7tH0a+gGQdVguvj8NVZu6FtH7K69bLunWl8Shb6D7y0CC
 LSWDgX/hGOJXkbNtKj0erygUJeUjFEgELp53QfbaYYRwvDzn0f4z+yP+f/fmbFN+CeYTQoPvZ
 kFOPKqzLwRqhLcEnhLKAI1himWjbHsAd3SqwA4ywAE5r8sl3iXXyaMvwQKsH1Gs4t2IsWtwa/
 Xjz2uqKnXTC3m7YDusJmBi8j429tZ3Jln7GYO3uK/3jBnd8KXg4KRZ6ebbf4xg14Lrm/qB87q
 xpbyCn0Stjz56iSnI7KESwjHpLvW1l2OVyLIjF9z3rbwth+17iWc62suhBAU82c/govg9mL78
 rwRHq9Sq9IDNDAXarTL7LPlFRPod9m30k+7sIxzW5F3+EdYVkamlzVWFBk4Rd+AzA1Vy3Qca3
 ZyYuLsv4J8nlelzNx/CGqcRPtEvoypDRvPJK/R5t7Fl2Ft+lP7fplUUWZ3/jix65Z4Z7hUvyE
 bS5i3oihUQw8iB2fM17Xrt+QT2KgoYLI230mDJyCPZY69BECSmZ+Bjur9OG/RANB4XYbnqfjl
 k/LYHO3c3suZcmvp0+ES26pkAfSSMCJa9Jwf8BOiIZVdhqRKPK3Qil2CFvETWLKcypOv5yaqH
 ceTFKEu5cvMINOcQ2CezzreZcNHZamk3XEpQ7ZUoVkrKDfyVw6QjCrKZBkfyM73RtxMqOg8Fx
 EE4hFsgorn4PRuf5cWqv5KId3CX9tAv4j/4KLcpbQwwdF3t7/umGhY+ww9ntT/76D3d3lWQuT
 FWXZZFWS6/KVB+DL3edaptqh5mpzPxhlXyCnnEZkJ1tYxp3lO+C1iakwvLwHkTPJ3e2Oa3Qpk
 QOX4YkSJ6gsRbAQifukHa1sKp2zbgw+6OxEL2gw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 16.10.19 23:18, Greg KH wrote:
> On Mon, Oct 14, 2019 at 09:29:01PM +0200, Helge Deller wrote:
>> can you please add the patch below into all stable kernels up until (an=
d
>> including) kernel 4.16 ?
>>
>> It's upstream patch b845f66f78bf which was merged in kernel 4.17.
>>
>
> It's already there, it was released in the following kernel releases:
> 	3.18.111 4.4.134 4.9.104 4.14.45 4.16.13 4.17

Ah, great!

> So are you sure it is still needed?

Yes. I double-checked.
The last report I got was from a debian-installer.
It used a Debian kernel "4.16.5-1", which didn't had the patch in, so
I sent this mail to get it backported.
Nice to see that it's in. Now "only" the debian install kernel needs updat=
e.

Thanks!
Helge
