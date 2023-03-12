Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5E96B67BC
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 16:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjCLP5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 11:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCLP5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 11:57:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF11460B2;
        Sun, 12 Mar 2023 08:57:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BDD7B80CC4;
        Sun, 12 Mar 2023 15:57:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B79C433EF;
        Sun, 12 Mar 2023 15:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678636667;
        bh=1uxe93o7qi7Xy5NGoZEHi0mnvCyAsZ/Qk475MpkflzE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c+P01p8KPf1zWfpCCXIAssbm3xoJAP7ueXrErj5E/moYV06evLdDekutN/egTy02t
         6OTFdT/gzniIxyBTQahuuGQSz87asOoXTznppxxLS2aA2fsvi+8UXKCxWmnvY6ptWk
         mKWO0dDi1l0wivYf2EK2uAX4LWaVB11WHmK12CIg8kZpM2EFBeicY776c9wg4Suo+t
         T4KHGF7knPTYGDqLy6hN2DNaLxvpnYSYCx/cNKPexpsNqrDvGPD5gpjv6nLAPp1Gdv
         Xu1W23i3xWVay4PxTG2NHI1f8YKqD4l1ps5B+j4Ik+VWNxIXpCmodDvMJIe0NM2WTn
         PFVDoAvi7gZBQ==
Date:   Sun, 12 Mar 2023 11:57:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, Willy Tarreau <w@1wt.eu>,
        Theodore Ts'o <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: Re: AUTOSEL process
Message-ID: <ZA32eqeSBBhgfRFx@sashalap>
References: <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzJltJaydwjCN6E@1wt.eu>
 <ZAzVbzthi8IfptFZ@sol.localdomain>
 <ZAzghyeiac3Zh8Hh@1wt.eu>
 <ZAzqSeus4iqCOf1O@sol.localdomain>
 <ZA1V4MbG6U3wP6q6@1wt.eu>
 <ZA1hdkrOKLG697RG@sol.localdomain>
 <CAOQ4uxiJPvKh5VzoP=9xamFfU78r3J25pwW6GQyAUN7YPJk=dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxiJPvKh5VzoP=9xamFfU78r3J25pwW6GQyAUN7YPJk=dQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 12, 2023 at 09:42:59AM +0200, Amir Goldstein wrote:
>On Sun, Mar 12, 2023 at 7:41 AM Eric Biggers <ebiggers@kernel.org> wrote:
>>
>...
>> I mean, "patches welcome" is a bit pointless when there is nothing to patch, is
>> it not?  Even Sasha's stable-tools, which he finally gave a link to, does not

"finally" being all the way back in 2015
(https://lkml.org/lkml/2015/11/9/422), and getting no contributions from
3rd parties for the next 7 years.

Really, we're not pushing back on ideas, we're just saying that this is
something has happened before ("open up your scripts so we can
reuse/improve") and getting nowhere.

>> include anything related to AUTOSEL.  It seems AUTOSEL is still closed source.

Not as much as closed source as a complete mess on a VM I'm afraid to
lose.

I didn't really want to try and invest the effort into extracting it out
becuase:

1. It's one of the first things I did when I started learning about
neural networks, and in practice it's inefficient and could use a
massive overhaul (or rewrite). For example, it currently has ~15k
inputs, which means that it needs a beefy GPU to be able to run on (it
won't run on your home GPU)..

2. At that time I wasn't familiar with coding for NN either, so it's a
mess of LUA code to run under Torch (yes, not even pytorch).

3. It's very tied to how VMs on Azure operate, and could use a lot of
abstraction.

So really, I'd much rather invest effort into rewriting this mess rather
than digging it out of the crevices of the VM it's sitting in.

>> BTW, I already did something similar "off to the side" a few years ago when I
>> wrote a script to keep track of and prioritize syzbot reports from
>> https://syzkaller.appspot.com/, and generate per-subsystem reminder emails.
>>
>> I eventually ended up abandoning that, because doing something off to the side
>> is not very effective and is hard to keep up with.  The right approach is to
>> make improvements to the "upstream" process (which was syzbot in that case), not
>> to bolt something on to the side to try to fix it after the fact.
>>
>> So I hope people can understand where I'm coming from, with hoping that what the
>> stable maintainers are doing can just be improved directly, without first
>> building something from scratch off to the side as that is just not a good way
>> to do things.  But sure, if that's the only option to get anything nontrivial
>> changed, I'll try to do it.
>>
>
>Eric,
>
>Did you consider working to improve or add functionality to b4?

FTR, I'm happy to shift investment into tooling for stable maintenance
into b4.

-- 
Thanks,
Sasha
