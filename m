Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24E10E6301
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 15:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfJ0OYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 10:24:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbfJ0OYT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 10:24:19 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE44A20873;
        Sun, 27 Oct 2019 14:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572186258;
        bh=S2DU1zT1UHQpmjZkeY/YWa/bvw72t8qFIf9U80qmiDc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vm/KKD7I3Co7UOysKWVPUSidbYPY2l5xdNGIXPHW/PcFQaFvK9R+kbxp59U1h5GoD
         KAD9xv1T0p4IQabbEaJdn3WCJYG6g9AShmpNpwpRDNkg/tRIJjSybXyewUV+QvhPdR
         5Clq9nT9qGV2OmlCp4A57wkXWeIP0ck2IlvzKM2I=
Date:   Sun, 27 Oct 2019 10:24:15 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: io_uring stable 5.3 backports
Message-ID: <20191027142415.GE1560@sasha-vm>
References: <efc9278b-de72-40b2-9a0a-48df0c64edc1@kernel.dk>
 <20191027085204.GA1560@sasha-vm>
 <f90a0bd3-3074-ee14-dea9-63d520bd72a2@kernel.dk>
 <20191027134832.GD1560@sasha-vm>
 <4dab77cb-0e29-15af-bb32-26ee23de3f69@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4dab77cb-0e29-15af-bb32-26ee23de3f69@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 27, 2019 at 08:03:09AM -0600, Jens Axboe wrote:
>On 10/27/19 7:48 AM, Sasha Levin wrote:
>> On Sun, Oct 27, 2019 at 06:01:03AM -0600, Jens Axboe wrote:
>>> On 10/27/19 2:52 AM, Sasha Levin wrote:
>>>> On Sat, Oct 26, 2019 at 05:33:41PM -0600, Jens Axboe wrote:
>>>>> Hi,
>>>>>
>>>>> For some reason I forgot to mark these stable, but they should go
>>>>> into stable. In order of applying them, they are:
>>>>>
>>>>> bc808bced39f4e4b626c5ea8c63d5e41fce7205a
>>>>
>>>> This commit says it fixes c576666863b78 ("io_uring: optimize
>>>> submit_and_wait API") which is not in the stable tree.
>>>>
>>>>> ef03681ae8df770745978148a7fb84796ae99cba
>>>>
>>>> This commit doesn't say so, but really it fixes 5262f567987d3
>>>> ("io_uring: IORING_OP_TIMEOUT support") which is not in the stable tree.
>>>>
>>>>> a1f58ba46f794b1168d1107befcf3d4b9f9fd453
>>>>
>>>> Same as the commit above.
>>>
>>> Oh man, sorry about that, I always forget to check if all of them are in
>>> 5.3. I blame the fact that I backport everything to our internal tree,
>>> which is 5.2 based. But yes, you are of course right, those three can be
>>> dropped.
>>
>> How much "secret sauce" does your internal tree have? Is it something
>> we can peek into to make sure we don't miss fixes?
>
>There's no secret sauce in the internal tree, it's just that I backport
>everything into the 5.2 version that is our newest. It's fully uptodate
>with 5.4-rc and in some cases what's queued up for 5.5 as well. Hence I
>sometimes forget to check what is applicable to 5.3-stable, since I have
>it in our 5.2 tree...
>
>The internal tree is just backports. That's how we do things.

Could you push it somewhere public? I could automate grabbing fixes off
of it.

-- 
Thanks,
Sasha
