Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED256A4936
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 19:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjB0SHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 13:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjB0SHE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 13:07:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0872056D;
        Mon, 27 Feb 2023 10:06:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2223E60EDF;
        Mon, 27 Feb 2023 18:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6246AC433EF;
        Mon, 27 Feb 2023 18:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677521194;
        bh=JhSKZuNe1LHVdeT72By6CTmUnBqeBs8R1l200nUc/Vk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wa4TGvGB4AQao0XFjMjip5Y5auJsyYJQe+Utd1HW2pIORhUm3TZu3wLkn/z3VldFk
         l6NakzzGjsZSDpsasYDcCBTn5OPeTmEV2FEx03r5knQ1UJdU65sRYrDyTrt/PRwY4Z
         pNn0aVuMA9QXFFtkvbMW2yjLSW1OU+pE0EGwCXR8j4YbtxzCxnUgoYXXA3W0mh/ZfS
         CASP0mtbWA1d19YDHCbI3lrLgWSxeMCSFixBfcuqKZNK8aK+4X3xV4FoqemTYVJ1fq
         vdzPE2fUNIQaqx9pLhPl4sYh7eOc53nIf2CPxTSw1riyiREi2jC0XybTJoae9stYgY
         TFY3aEHYsZUig==
Date:   Mon, 27 Feb 2023 10:06:32 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/zxKOBTLXFjSVyI@sol.localdomain>
References: <20230226034256.771769-1-sashal@kernel.org>
 <20230226034256.771769-12-sashal@kernel.org>
 <Y/rbGxq8oAEsW28j@sol.localdomain>
 <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/zswi91axMN8OsA@sol.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 27, 2023 at 09:47:48AM -0800, Eric Biggers wrote:
> > > > Of course, it's not just me that AUTOSEL isn't working for.  So, you'll still
> > > > continue backporting random commits that I have to spend hours bisecting, e.g.
> > > > https://lore.kernel.org/stable/20220921155332.234913-7-sashal@kernel.org.
> > > > 
> > > > But at least I won't have to deal with this garbage for my own commits.
> > > > 
> > > > Now, I'm not sure I'll get a response to this --- I received no response to my
> > > > last AUTOSEL question at
> > > > https://lore.kernel.org/stable/Y1DTFiP12ws04eOM@sol.localdomain.  So to
> > > > hopefully entice you to actually do something, I'm also letting you know that I
> > > > won't be reviewing any AUTOSEL mails for my commits anymore.
> > > > 
> > > 
> > > The really annoying thing is that someone even replied to your AUTOSEL email for
> > > that broken patch and told you it is broken
> > > (https://lore.kernel.org/stable/d91aaff1-470f-cfdf-41cf-031eea9d6aca@mailbox.org),
> > > and ***you ignored it and applied the patch anyway***.
> > > 
> > > Why are you even sending these emails if you are ignoring feedback anyway?
> > 
> > I obviously didn't ignore it on purpose, right?
> > 
> 
> I don't know, is it obvious?  You've said in the past that sometimes you'd like
> to backport a commit even if the maintainer objects and/or it is known buggy.
> https://lore.kernel.org/stable/d91aaff1-470f-cfdf-41cf-031eea9d6aca@mailbox.org
> also didn't explicitly say "Don't backport this" but instead "This patch has
> issues", so maybe that made a difference?
> 
> Anyway, the fact is that it happened.  And if it happened in the one bug that I
> happened to look at because it personally affected me and I spent hours
> bisecting, it probably is happening in lots of other cases too.  So it seems the
> process is not working...
> 
> Separately from responses to the AUTOSEL email, it also seems that you aren't
> checking for any reported regressions or pending fixes for a commit before
> backporting it.  Simply searching lore for the commit title
> https://lore.kernel.org/all/?q=%22drm%2Famdgpu%3A+use+dirty+framebuffer+helper%22
> would have turned up the bug report
> https://lore.kernel.org/dri-devel/20220918120926.10322-1-user@am64/ that
> bisected a regression to that commit, as well as a patch that Fixes that commit:
> https://lore.kernel.org/all/20220920130832.2214101-1-alexander.deucher@amd.com/
> Both of these existed before you even sent the AUTOSEL email!
> 
> So to summarize, that buggy commit was backported even though:
> 
>   * There were no indications that it was a bug fix (and thus potentially
>     suitable for stable) in the first place.
>   * On the AUTOSEL thread, someone told you the commit is broken.
>   * There was already a thread that reported a regression caused by the commit.
>     Easily findable via lore search.
>   * There was also already a pending patch that Fixes the commit.  Again easily
>     findable via lore search.
> 
> So it seems a *lot* of things went wrong, no?  Why?  If so many things can go
> wrong, it's not just a "mistake" but rather the process is the problem...

BTW, another cause of this is that the commit (66f99628eb24) was AUTOSEL'd after
only being in mainline for 4 days, and *released* in all LTS kernels after only
being in mainline for 12 days.  Surely that's a timeline befitting a critical
security vulnerability, not some random neural-network-selected commit that
wasn't even fixing anything?

- Eric
