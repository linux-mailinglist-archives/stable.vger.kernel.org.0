Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384206D079A
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 16:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbjC3OGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 10:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbjC3OGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 10:06:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC7FA24C;
        Thu, 30 Mar 2023 07:05:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7AADB828DB;
        Thu, 30 Mar 2023 14:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BC3C433EF;
        Thu, 30 Mar 2023 14:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680185140;
        bh=ikg8qiR7nBa2PRNCu8Z3IJ4C8dnARVXjCIBgmd1F9PY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DVLrZwY4vDNZ6xGY4ILb+A95a0eEV0cCUDMv10gcdwu0AVH1qP1a746mZg7i9fC6X
         fJjLl9UJhFwfgq1B2O20/hbjPZhTkm7NDjqX7doGEO008m9wzpLknPt95I+mIgJvLi
         1emk0f2qeDmp3GFvtaROlXkI1pEn+rFjI/cMrIrwTdGNcMDEVirZ7aLTTFxvEPXrNm
         L9aoAbwbbBnxnf88HzB2ChyIKZxFK+yVNfe8FzNEPUDyOrgliQTwdxDfEev8PHGZ8H
         COTdSjP/l63oe610O3iNj1ChSK12oEU6XpBBNhQhSBAGTExruAdhhgqs/XFr+fJLOr
         ENkeD9Q/HrDFQ==
Date:   Thu, 30 Mar 2023 10:05:39 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZCWXM5onHfLbcIDN@sashalap>
References: <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com>
 <Y/0wMiOwoeLcFefc@sashalap>
 <Y/01z4EJNfioId1d@casper.infradead.org>
 <Y/1QV9mQ31wbqFnp@sashalap>
 <ZCTS4Yc44DN+cqcX@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZCTS4Yc44DN+cqcX@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 30, 2023 at 12:08:01AM +0000, Eric Biggers wrote:
>Hi Sasha,
>
>On Mon, Feb 27, 2023 at 07:52:39PM -0500, Sasha Levin wrote:
>> > Sasha, 7 days is too short.  People have to be allowed to take holiday.
>>
>> That's true, and I don't have strong objections to making it longer. How
>> often did it happen though? We don't end up getting too many replies
>> past the 7 day window.
>>
>> I'll bump it to 14 days for a few months and see if it changes anything.
>
>I see that for recent AUTOSEL patches you're still using 7 days.  In fact, it
>seems you may have even decreased it further to 5 days:
>
>    Sent Mar 14: https://lore.kernel.org/stable/20230314124435.471553-2-sashal@kernel.org
>    Commited Mar 19: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/commit/?id=69aaf98f41593b95c012d91b3e5adeb8360b4b8d
>
>Any update on your plan to increase it to 14 days?

The commit you've pointed to was merged into Linus's tree on Feb 28th,
and the first LTS tree that it was released in went out on March 22nd.

Quoting the concern you've raised around the process:

> BTW, another cause of this is that the commit (66f99628eb24) was AUTOSEL'd after
> only being in mainline for 4 days, and *released* in all LTS kernels after only
> being in mainline for 12 days.  Surely that's a timeline befitting a critical
> security vulnerability, not some random neural-network-selected commit that
> wasn't even fixing anything?

So now there's at least 14 days between mainline inclusion and a release
in an LTS kernel, does that not conform with what you thought I'd be
doing?

Most of that additional time comes in the form of me going over the tree
and sending AUTOSEL mails a bit later, so I would be able to also pick
follow-up fixes as they come in (and drop stuff that were reverted).

As a side note, inclusion into the stable-queue which you've pointed to
above is a few steps before a release - it's mostly a cheap way for us
to get mileage out of bots that run on the queue and address issues - it
doesn't mean that the commit is released.

-- 
Thanks,
Sasha
