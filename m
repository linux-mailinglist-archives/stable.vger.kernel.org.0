Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 553D5E64F0
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 19:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfJ0Sya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 14:54:30 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40405 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbfJ0Sya (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 14:54:30 -0400
Received: by mail-pf1-f193.google.com with SMTP id x127so5075287pfb.7
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 11:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y5c5Mt7bR29kbBwAsW6izZRQG/7wSy5OrB5U8NcAADk=;
        b=P0YpL2KSV/sX5sucDdYFLbQixNl8JC6IFq/qvu1MtuNu0kBBWTApOsjZISQ84KTt+r
         r3wv3DKpJTv4UdEuKU0AZt2VC/bHwm6yWUL9mIPByyxUFpL9M3PlqAsB6NnZGBT9fRk6
         TwuueB0QYPpWTzY+xWPkvxc1eP3Z2EJL79A0iq79I+k1auHQBC43jm0TL4nunAa66Miq
         4xZhmg+RFQucv1WVg+cp+Qtq5JXq8tNZmP9+Ut7RUgEavc1jYrXhhw/X73LjJ3cM+91d
         JdvExMsQ/LJIsAs81aIqUJtZjeHY94o+L4guaEFjHxWZcsyQUD/3avvb+pj5+TF5DFtq
         04eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y5c5Mt7bR29kbBwAsW6izZRQG/7wSy5OrB5U8NcAADk=;
        b=OiQ4LwFljEyi5ja8UnqQP5wAwVwKaRV4PXccK2LovpTGjwEkwE1jOcRtJzzCFS9/1W
         9XefduyTPMFvor/PB968wfBdzOWnrd//plzaDG/BMF3lhDZyjgI/WsGeEzPCgmIpPkR2
         lN+btcIEHS1BMIjx8RgJPWqL93j4r5Os7Bikc9qYvmTyTDJIx3+W0Qwta+Z2mxOINb2P
         GsoNdGKWvV8+NfXcwRF652UxAyOXwMuZKWa9/nffAf5S7GLBXOXgoSmP9ucpVp8Xua6O
         +qjergyAIJ29pYpNPZ7L6/T9qn1qDLhyYC65oC3IySojQ20XjGi3RZkDkygDi0ymjdat
         gr1w==
X-Gm-Message-State: APjAAAUdajmA7aHbK05wpSF9w0m5mS9+2bXJRJ2Rat31DdmvzC9jgnEX
        XVuabAWLeI68TJWph//3GxG47gtmFLZULg==
X-Google-Smtp-Source: APXvYqxRv5B3a06myY9otIs45UhOXRCrHFyrwh/G+WPpqoq+dG21eDUJ29gEDt2PW95r/UTHkWceKw==
X-Received: by 2002:a17:90b:914:: with SMTP id bo20mr17326286pjb.6.1572202466940;
        Sun, 27 Oct 2019 11:54:26 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id z7sm8729741pfr.165.2019.10.27.11.54.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Oct 2019 11:54:25 -0700 (PDT)
Subject: Re: io_uring stable 5.3 backports
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
References: <efc9278b-de72-40b2-9a0a-48df0c64edc1@kernel.dk>
 <20191027085204.GA1560@sasha-vm>
 <f90a0bd3-3074-ee14-dea9-63d520bd72a2@kernel.dk>
 <20191027134832.GD1560@sasha-vm>
 <4dab77cb-0e29-15af-bb32-26ee23de3f69@kernel.dk>
 <20191027142415.GE1560@sasha-vm>
 <981a3436-e8a0-f13d-d33c-1aa53114fc64@kernel.dk>
 <20191027181057.GF1560@sasha-vm>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a08b858d-20c9-2573-c508-ce6f41aa0719@kernel.dk>
Date:   Sun, 27 Oct 2019 12:54:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191027181057.GF1560@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/27/19 12:10 PM, Sasha Levin wrote:
> On Sun, Oct 27, 2019 at 10:18:12AM -0600, Jens Axboe wrote:
>> On 10/27/19 8:24 AM, Sasha Levin wrote:
>>> On Sun, Oct 27, 2019 at 08:03:09AM -0600, Jens Axboe wrote:
>>>> On 10/27/19 7:48 AM, Sasha Levin wrote:
>>>>> On Sun, Oct 27, 2019 at 06:01:03AM -0600, Jens Axboe wrote:
>>>>>> On 10/27/19 2:52 AM, Sasha Levin wrote:
>>>>>>> On Sat, Oct 26, 2019 at 05:33:41PM -0600, Jens Axboe wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> For some reason I forgot to mark these stable, but they should go
>>>>>>>> into stable. In order of applying them, they are:
>>>>>>>>
>>>>>>>> bc808bced39f4e4b626c5ea8c63d5e41fce7205a
>>>>>>>
>>>>>>> This commit says it fixes c576666863b78 ("io_uring: optimize
>>>>>>> submit_and_wait API") which is not in the stable tree.
>>>>>>>
>>>>>>>> ef03681ae8df770745978148a7fb84796ae99cba
>>>>>>>
>>>>>>> This commit doesn't say so, but really it fixes 5262f567987d3
>>>>>>> ("io_uring: IORING_OP_TIMEOUT support") which is not in the stable tree.
>>>>>>>
>>>>>>>> a1f58ba46f794b1168d1107befcf3d4b9f9fd453
>>>>>>>
>>>>>>> Same as the commit above.
>>>>>>
>>>>>> Oh man, sorry about that, I always forget to check if all of them are in
>>>>>> 5.3. I blame the fact that I backport everything to our internal tree,
>>>>>> which is 5.2 based. But yes, you are of course right, those three can be
>>>>>> dropped.
>>>>>
>>>>> How much "secret sauce" does your internal tree have? Is it something
>>>>> we can peek into to make sure we don't miss fixes?
>>>>
>>>> There's no secret sauce in the internal tree, it's just that I backport
>>>> everything into the 5.2 version that is our newest. It's fully uptodate
>>>> with 5.4-rc and in some cases what's queued up for 5.5 as well. Hence I
>>>> sometimes forget to check what is applicable to 5.3-stable, since I have
>>>> it in our 5.2 tree...
>>>>
>>>> The internal tree is just backports. That's how we do things.
>>>
>>> Could you push it somewhere public? I could automate grabbing fixes off
>>> of it.
>>
>> There a few reasons why that hasn't been done, and none of them are
>> related to the actual code/patches in there..
>>
>> But I don't think it would help you. The io_uring branch is a mix of
>> things that have gone into the current window (and may or may not need
>> to go to stable), and things that are queued up for the next kernel
>> versions (and aren't going to stable). This will just continue to drift
>>from stable, until we respin a new kernel version internally.
> 
> My thinking here was that:
> 
> 1. I have a bunch of scripts that determine whether a given patch is
> relevant to any stable kernel branch.
> 2. I have a machine learning toy that can help me kick patches for
> review.
> 
> Running both on your tree means I can (let's say once a week) get a list
> of probably fixes that are in your tree but are not in upstream stable
> trees and might need to be there.

If you want to play with it, I can certainly create a mirror of my 5.2
based io_uring FB branch and push it somewhere. Whenever I add to the FB
branch, I'll add to the public one as well so they will stay in sync.

Only concern is that on at least on occassion, I ended up pushing a
patch to the FB repo too soon. That then results in something like this:

commit 4c5a7042904f689d981ef6faa45f6a09e8669db1
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Oct 17 16:32:06 2019 -0600

    io_uring: fixup "io_uring: fix up O_NONBLOCK handling for sockets"
    
    Matches the offending commit with upstream commit 491381ce07ca.
    
    Fixes: 0d79665c5f18 ("io_uring: fix up O_NONBLOCK handling for sockets")
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

where I commit an incremental patch to sync with the patch that went
upstream, which differed slightly from what I had committed internally.
This is the only one of those I have.

Another one I have a single commit of is where I made an error doing
conflict resolution:

commit 5d79f6ee5f2ed5d0efc6e7698abed1516cd2c416
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Oct 22 13:00:20 2019 -0600

    io_uring: fix merge error
    
    Due to a merge error, we never got 'ret' set in the common case.
    This hasn't caused any issues, and gcc is buggy and doesn't warn
    about it, but let's get it in there so we're synced with upstream.
    
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

If you're fine with that, I can make the external copy of the FB
io_uring branch match the internal one.

-- 
Jens Axboe

