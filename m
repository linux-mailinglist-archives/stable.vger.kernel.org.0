Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 996A36A4C60
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 21:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjB0Uj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 15:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjB0UjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 15:39:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C93422DEC;
        Mon, 27 Feb 2023 12:39:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E3A6ACE115B;
        Mon, 27 Feb 2023 20:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D5CC433D2;
        Mon, 27 Feb 2023 20:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677530356;
        bh=vU0SzPPftW1Pk2q0BkvhVj0n+YleexbfpMDKgqWko8A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XfhECdkIewZ88wJ2x3gOyDZv4y2QxQmyyeNMETFZxZG8a1NO7U4gcS1n713GRALYO
         Uv9Q1IuCvV6vrsH2fjq3x7ThsShZojLxqNl+LF2y+ijIbAsk/VP4+GvLLvtCYaKOq9
         p7bVKX/fylCy9/I39WzVHmjOgbCPcSdgqC6mCkqgWr6xqLk+uR2Unt/MOubmX8qwnx
         tr4VO3L2kqb/GMVF5FfrQjnENprdtUo2FG8BTAJmQhLIv0z4bGqZDsnMBa8qzRitkU
         OPDvZKzUgkMzPu8zptnBU3xmh/FlcsCrWRCLl+L2ObnaYX7HOGtUnCnP1P0dEyy887
         +MdF3zbDmPfmQ==
Date:   Mon, 27 Feb 2023 15:39:14 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/0U8tpNkgePu00M@sashalap>
References: <20230226034256.771769-1-sashal@kernel.org>
 <20230226034256.771769-12-sashal@kernel.org>
 <Y/rbGxq8oAEsW28j@sol.localdomain>
 <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y/zxKOBTLXFjSVyI@sol.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 27, 2023 at 10:06:32AM -0800, Eric Biggers wrote:
>On Mon, Feb 27, 2023 at 09:47:48AM -0800, Eric Biggers wrote:
>> > > > Of course, it's not just me that AUTOSEL isn't working for.  So, you'll still
>> > > > continue backporting random commits that I have to spend hours bisecting, e.g.
>> > > > https://lore.kernel.org/stable/20220921155332.234913-7-sashal@kernel.org.
>> > > >
>> > > > But at least I won't have to deal with this garbage for my own commits.
>> > > >
>> > > > Now, I'm not sure I'll get a response to this --- I received no response to my
>> > > > last AUTOSEL question at
>> > > > https://lore.kernel.org/stable/Y1DTFiP12ws04eOM@sol.localdomain.  So to
>> > > > hopefully entice you to actually do something, I'm also letting you know that I
>> > > > won't be reviewing any AUTOSEL mails for my commits anymore.
>> > > >
>> > >
>> > > The really annoying thing is that someone even replied to your AUTOSEL email for
>> > > that broken patch and told you it is broken
>> > > (https://lore.kernel.org/stable/d91aaff1-470f-cfdf-41cf-031eea9d6aca@mailbox.org),
>> > > and ***you ignored it and applied the patch anyway***.
>> > >
>> > > Why are you even sending these emails if you are ignoring feedback anyway?
>> >
>> > I obviously didn't ignore it on purpose, right?
>> >
>>
>> I don't know, is it obvious?  You've said in the past that sometimes you'd like
>> to backport a commit even if the maintainer objects and/or it is known buggy.
>> https://lore.kernel.org/stable/d91aaff1-470f-cfdf-41cf-031eea9d6aca@mailbox.org
>> also didn't explicitly say "Don't backport this" but instead "This patch has
>> issues", so maybe that made a difference?

 From what I gather I missed the reply - I would not blindly ignore a
maintainer.

>> Anyway, the fact is that it happened.  And if it happened in the one bug that I
>> happened to look at because it personally affected me and I spent hours
>> bisecting, it probably is happening in lots of other cases too.  So it seems the
>> process is not working...

This one is tricky, becuase we also end up taking a lot of commits that
do fix real bugs, and were never tagged for stable or even had a fixes
tag.

Maybe I should run the numbers again, but when we compared regression
rates of stable tagged releases and AUTOSEL ones, it was fairly
identical.

>> Separately from responses to the AUTOSEL email, it also seems that you aren't
>> checking for any reported regressions or pending fixes for a commit before
>> backporting it.  Simply searching lore for the commit title
>> https://lore.kernel.org/all/?q=%22drm%2Famdgpu%3A+use+dirty+framebuffer+helper%22
>> would have turned up the bug report
>> https://lore.kernel.org/dri-devel/20220918120926.10322-1-user@am64/ that
>> bisected a regression to that commit, as well as a patch that Fixes that commit:
>> https://lore.kernel.org/all/20220920130832.2214101-1-alexander.deucher@amd.com/
>> Both of these existed before you even sent the AUTOSEL email!

I would love to have a way to automatically grep lore for reported
issues that are pinpointed to a given commit. I'm hoping that Thorsten's
regression tracker could be used that way soon enough.

>> So to summarize, that buggy commit was backported even though:
>>
>>   * There were no indications that it was a bug fix (and thus potentially
>>     suitable for stable) in the first place.
>>   * On the AUTOSEL thread, someone told you the commit is broken.
>>   * There was already a thread that reported a regression caused by the commit.
>>     Easily findable via lore search.
>>   * There was also already a pending patch that Fixes the commit.  Again easily
>>     findable via lore search.
>>
>> So it seems a *lot* of things went wrong, no?  Why?  If so many things can go
>> wrong, it's not just a "mistake" but rather the process is the problem...
>
>BTW, another cause of this is that the commit (66f99628eb24) was AUTOSEL'd after
>only being in mainline for 4 days, and *released* in all LTS kernels after only
>being in mainline for 12 days.  Surely that's a timeline befitting a critical
>security vulnerability, not some random neural-network-selected commit that
>wasn't even fixing anything?

I would love to have a mechanism that tells me with 100% confidence if a
given commit fixes a bug or not, could you provide me with one?

w.r.t timelines, this is something that was discussed on the mailing
list a few years ago where we decided that giving AUTOSEL commits 7 days
of soaking time is sufficient, if anything changed we can have this
discussion again.

Note, however, that it's not enough to keep pointing at a tiny set and
using it to suggest that the entire process is broken. How many AUTOSEL
commits introduced a regression? How many -stable tagged ones did? How
many bugs did AUTOSEL commits fix?

-- 
Thanks,
Sasha
