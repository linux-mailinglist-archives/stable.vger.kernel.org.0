Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7BE6D0C9F
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 19:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbjC3RWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 13:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbjC3RWO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 13:22:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC32271E;
        Thu, 30 Mar 2023 10:22:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0F3C6212C;
        Thu, 30 Mar 2023 17:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E420AC433D2;
        Thu, 30 Mar 2023 17:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680196932;
        bh=fZPnfu92Rq3aIzhUFMP8IFZHanGjLY5xrcS8GTjlINE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tVSz90ic8Xfq8q6+j57xz4YMGH6kEtB50yuMck2D7nMzwogt86I5D/Dm/I+4m/Ra+
         sxyx7ieCiAy2B+Zfca6U/oRaY6vG31YdrXl7FnH4Qp9UM719EDx1tftqjQ4FHg8dQk
         3rEkNhmZCvvk0BTqFqLAruU7A4Cr0A4L6ohszl0R9NPyCQTPx80/TaQZRp4QBLUQ05
         hJ+Wxr9Rf2hjqjzadddfOXVhhpsMvSABa/dvi2F/HpkE2niavG3jNPArub52NCThB0
         woefFTwse08B+38KDyFDBY87+hR2DvgCGcg7YZCDy3V5emmZ/FI7wIX6PqJrp4/DUS
         L2c0Na/jpqcXw==
Date:   Thu, 30 Mar 2023 10:22:10 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <20230330172210.GB881@sol.localdomain>
References: <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com>
 <Y/0wMiOwoeLcFefc@sashalap>
 <Y/01z4EJNfioId1d@casper.infradead.org>
 <Y/1QV9mQ31wbqFnp@sashalap>
 <ZCTS4Yc44DN+cqcX@gmail.com>
 <ZCWXM5onHfLbcIDN@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCWXM5onHfLbcIDN@sashalap>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 30, 2023 at 10:05:39AM -0400, Sasha Levin wrote:
> On Thu, Mar 30, 2023 at 12:08:01AM +0000, Eric Biggers wrote:
> > Hi Sasha,
> > 
> > On Mon, Feb 27, 2023 at 07:52:39PM -0500, Sasha Levin wrote:
> > > > Sasha, 7 days is too short.  People have to be allowed to take holiday.
> > > 
> > > That's true, and I don't have strong objections to making it longer. How
> > > often did it happen though? We don't end up getting too many replies
> > > past the 7 day window.
> > > 
> > > I'll bump it to 14 days for a few months and see if it changes anything.
> > 
> > I see that for recent AUTOSEL patches you're still using 7 days.  In fact, it
> > seems you may have even decreased it further to 5 days:
> > 
> >    Sent Mar 14: https://lore.kernel.org/stable/20230314124435.471553-2-sashal@kernel.org
> >    Commited Mar 19: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/commit/?id=69aaf98f41593b95c012d91b3e5adeb8360b4b8d
> > 
> > Any update on your plan to increase it to 14 days?
> 
> The commit you've pointed to was merged into Linus's tree on Feb 28th,
> and the first LTS tree that it was released in went out on March 22nd.
> 
> Quoting the concern you've raised around the process:
> 
> > BTW, another cause of this is that the commit (66f99628eb24) was AUTOSEL'd after
> > only being in mainline for 4 days, and *released* in all LTS kernels after only
> > being in mainline for 12 days.  Surely that's a timeline befitting a critical
> > security vulnerability, not some random neural-network-selected commit that
> > wasn't even fixing anything?
> 
> So now there's at least 14 days between mainline inclusion and a release
> in an LTS kernel, does that not conform with what you thought I'd be
> doing?

Not quite.  There are actually two different time periods:

1. The time from mainline to release
2. The time from AUTOSEL email to release

(1) is a superset of (2), but concerns were raised about *both* time periods
being too short.  Especially (1), but also (2) because reviewers can miss the
7-day review e.g. if they are on vacation for a week.  Yes, they can of course
miss non-AUTOSEL patches too, *if* they happen to get merged quickly enough
(most kernel patches take several weeks just to get to mainline).  But, AUTOSEL
patches are known to be low quality submissions that really need that review.

I'm glad to hear that you've increased (1) to 14 days!  However, that does not
address (2).  It also does not feel like much of a difference, since 12 days for
(1) already seemed too short.

To be honest, I hesitate a bit to give you a precise suggestion, as it's liable
to be used to push back on future suggestions as "this is what people agreed on
before".  (Just as you did in this thread, with saying 7 days had been agreed on
before.)  And it's not like there are any magic numbers -- we just know that the
current periods seem to be too short.  But, for a simple change, I think
increasing (2) to 14 days would be reasonable, as that automatically gives 14
days for (1) too.  If it isn't too much trouble to separate the periods, though,
it would also be reasonable to choose something a bit higher for (1), like 18-21
days, and something a bit lower for (2), like 10-12 days.

- Eric
