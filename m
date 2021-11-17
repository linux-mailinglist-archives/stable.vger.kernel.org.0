Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DE9454E88
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 21:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhKQUaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 15:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbhKQUaV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 15:30:21 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD59C061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 12:27:22 -0800 (PST)
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id B6BC481761;
        Wed, 17 Nov 2021 21:27:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1637180839;
        bh=E6OHKbLIfVxAnyWlhjaxbLPSxsh5Vtrn9miSH8gfCv0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Tv3huxwUnYbs7zv11zAOYLQkmovB725OMWh5TAYKHwU6+BWwG0TKcZy/ddyMCvqKb
         dKoYXYBl6Nvsy8OeG6tRIjIt6Byz0hIpuOtFqrVRBF5SjrePyiqONp5KmqZCZB59a1
         MBNJ1lkxGr+nbKUiaSDFyMmtm8mS7Qe3UFSisL5AdJOnW4QQpIgovNCeeDYAmHWzyN
         inJb6I4C33ctOuZZLEukPMz5KEbv0p5pkh/iS+Acq/0vPenzu8kMOVxdR0ZHAyRtYS
         hyVPULhjp0YS2TRecKHyHy4zaBZzP2xwdB1ixRFT/ANhgv5nG2qpmf5FHwox11zP/c
         jJ8TOhWdfQGGg==
Subject: Re: [PATCH] Bluetooth: btusb: Add support for TP-Link UB500 Adapter
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Szabolcs Sipos <labuwx@balfug.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>
References: <aa3f6986-1e9b-4aaa-e498-fd99385f4063@denx.de>
 <YWPrSHGbno3dODKr@kroah.com>
 <62685363-e1b3-bc97-431e-a7c8faccb78d@balfug.com>
 <YZP6CL+CDMyzQ6aA@kroah.com> <5931c469-c0bf-4e93-e7e3-443b5ca60fb3@denx.de>
 <YZSixJVYJxE7COuy@kroah.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <182bce57-8a46-9631-3ecf-7eb7a89593ce@denx.de>
Date:   Wed, 17 Nov 2021 21:27:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YZSixJVYJxE7COuy@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/17/21 7:35 AM, Greg Kroah-Hartman wrote:
> On Tue, Nov 16, 2021 at 08:58:15PM +0100, Marek Vasut wrote:
>> On 11/16/21 7:35 PM, Greg Kroah-Hartman wrote:
>>> On Tue, Nov 16, 2021 at 06:41:08PM +0100, Szabolcs Sipos wrote:
>>>> On 10/11/21 09:44, Greg Kroah-Hartman wrote:
>>>>> On Sun, Oct 10, 2021 at 10:59:06PM +0200, Marek Vasut wrote:
>>>>>> Hello everyone,
>>>>>>
>>>>>> The following new device USB ID has landed in linux-next recently:
>>>>>>
>>>>>> 4fd6d4907961 ("Bluetooth: btusb: Add support for TP-Link UB500 Adapter")
>>>>>>
>>>>>> It would be nice if it could be backported to stable. I verified it works on
>>>>>> 5.14.y as a simple cherry-pick .
>>>>>
>>>>> A patch needs to be in Linus's tree before we can add it to the stable
>>>>> releases.  Please let us know when it gets there and we will be glad to
>>>>> pick it up.
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>
>>>> Hello Greg,
>>>>
>>>> The patch has reached Linus's tree:
>>>> 4fd6d4907961 ("Bluetooth: btusb: Add support for TP-Link UB500 Adapter")
>>>>
>>>> Could you please add it to stable (5.15.y)?
>>>
>>> I will queue it up for the next set of kernels after the current ones are
>>> released.
>>
>> btw while you're bringing it up, is there some sure-fire method I can use to
>> verify the patch is in Linus tree, besides having a separate checkout of
>> that tree ?
> 
> Without the tree/branch checked out?  Not that I know of, sorry.

I have a local checkout of Linus tree, except I also have other remotes 
in it, that's what I meant.

>> I usually have both Linus tree as origin and next in one git tree, so I was
>> wondering if there is a recommended way to avoid mistakes like the one I
>> made above (and checking at git.kernel.org apparently also has its
>> downsides).
> 
> Having both in one git tree is fine.  Just switch between branches (one
> that tracks Linus's and one that tracks linux-next) and you can see what
> is happening in each of them.

I can do some "git log linus/master | grep the-commit" , but that does 
not seem to be the most efficient approach, or is it ?

> There's other "tricks" to see if patches have been added to branches by
> adding them to a branch and then rebasing and seeing the end result, but
> those get tricky to try to explain in simple emails...

Some sort of git-cherry-pick and git-rebase ?

All right
