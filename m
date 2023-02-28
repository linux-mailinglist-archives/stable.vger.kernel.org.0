Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029D16A51DB
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 04:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjB1Dli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 22:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjB1Dli (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 22:41:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4328E2449A;
        Mon, 27 Feb 2023 19:41:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA5E360F3C;
        Tue, 28 Feb 2023 03:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01092C433EF;
        Tue, 28 Feb 2023 03:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677555693;
        bh=qcl5s+6qbcUh8zwwiI9CIOUOSuOTjBUsfdsDbpRaWYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CtOhzqmfZavm5+CHMTdRk5MOZUZE73VL0dvBcb+B9KDPuFwaRilQc/8Xe4UTnDCnW
         3MTSqxezZMkZxQaADnlDlEeqZsd8kADqEQAZKKRLAVX+mHdYJ/CHpanAGW03dIFbg9
         p4MNBwlqlwHowhOtFYTQfy+GHgKUS03IGe81A2W5fBFqpDHIpsnUJLGqOug3EFQOGf
         OMKtLnb97EYhozD6dmgFAw8u6AUcxYtyI+LKW7GPY6JwQLa36eGdH9XPKQNGna1Tyt
         bmzfBOmbcFkxDS6CkkdZWSQVbqxKsBqkVrI8ZnFC61zDE/9SItIeUaO0jYp58Kar07
         yjo1l27O6n6Bw==
Date:   Mon, 27 Feb 2023 19:41:31 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/136zpJSWx96YEe@sol.localdomain>
References: <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com>
 <Y/0wMiOwoeLcFefc@sashalap>
 <Y/1LlA5WogOAPBNv@gmail.com>
 <Y/1em4ygHgSjIYau@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/1em4ygHgSjIYau@sashalap>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 27, 2023 at 08:53:31PM -0500, Sasha Levin wrote:
> > 
> > I'm shocked that these are the statistics you use to claim the current AUTOSEL
> > process is working.  I think they actually show quite the opposite!
> > 
> > First, since many AUTOSEL commits aren't actually fixes but nearly all
> > stable-tagged commits *are* fixes, the rate of regressions per commit would need
> > to be lower for AUTOSEL commits than for stable-tagged commits in order for
> > AUTOSEL commits to have the same rate of regressions *per fix*.  Your numbers
> > suggest a similar regression rate *per commit*.  Thus, AUTOSEL probably
> > introduces more regressions *per fix* than stable-tagged commits.
> 
> Interesting claim. How many of the AUTOSEL commits are "actual" fixes?
> How do you know if a commit is a fix for anything or not?
> 
> Could you try and back claims with some evidence?
> 
> Yes, in a perfect world where we know if a commit is a fix we could
> avoid introducing regressions into the stable trees. Heck, maybe we could
> even stop writing buggy code to begin with?

Are you seriously trying to claim that a random commit your neural network
picked up is just as likely to be a fix as a commit that the author explicitly
tagged as a fix and/or for stable?

That's quite an extraordinary claim, and it's not true from my experience.  Lots
of AUTOSEL patches that get Cc'ed to me, if I'm familiar enough with the area to
understand fairly well whether the patch is a "fix", are not actually fixes.  Or
are very borderline "fixes" that don't meet stable criteria.  (Note, I generally
only bother responding to AUTOSEL if I think a patch is actually going to cause
a problem.  So a lack of response isn't necessarily agreement that a patch is
really suitable for stable...)

Oh sorry, personal experience is not "evidence".  Please disregard my invalid
non-evidence-based opinion.

> > (Of course, stable-tagged commits sometimes have missing prerequisite bugs too.
> > But it's expected to be at a lower rate, since the original developers and
> > maintainers are directly involved in adding the stable tags.  These are the
> > people who are more familiar than anyone else with prerequisites.)
> 
> You'd be surprised. There is documentation around how one would annotate
> dependencies for stable tagged commits, something along the lines of:
> 
> 	cc: stable@kernel.org # dep1 dep2
> 
> Grep through the git log and see how often this is actually used.

Well, probably more common is that prerequisites are in the same patchset, and
the prerequisites are tagged for stable too.  Whereas AUTOSEL often just picks
patch X of N.  Also, developers and maintainers who tag patches for stable are
probably more likely to help with the stable process in general and make sure
patches are backported correctly...

Anyway, the point is, AUTOSEL needs to be fixed to stop inappropriately
cherry-picking patch X of N so often.

> > a multi-patch series, and if so are earlier patches needed as prerequisites".
> > There also needs to be more soak time in mainline, and more review time.
> 
> Tricky bit with mainline/review time is that very few of our users
> actually run -rc trees.
> 
> We end up hitting many of the regressions because the commits actually
> end up in stable trees. Should it work that way? No, but our testing
> story around -rc releases is quite lacking.

Well, in the bug that affected me, it *was* found on mainline almost
immediately.  It just took a bit longer than the extremely aggressive 7-day
AUTOSEL period to be fixed.

Oh sorry again, one example is not "evidence".  Please disregard my invalid
non-evidence-based opinion.

> I'm not sure how feedback in the form of "this sucks but I'm sure it
> could be much better" is useful.

I've already given you some specific suggestions.

I can't force you to listen to them, of course.

- Eric
