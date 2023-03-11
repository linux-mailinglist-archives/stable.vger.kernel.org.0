Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199FF6B5FDF
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 19:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjCKSzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 13:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjCKSzF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 13:55:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FED1B57E;
        Sat, 11 Mar 2023 10:55:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65443B80066;
        Sat, 11 Mar 2023 18:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE79BC433D2;
        Sat, 11 Mar 2023 18:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678560901;
        bh=N1RKlCcfEmQ0OHV1fgP6CQcp2dLFer8ChKPns56/O5I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LaFgorof/0OrTKIsG35nFDHtT7dOVFAZZuNgOZGfy3bMEaEAqPdetPZPceieLTDez
         eveFpRGZnFCOxzCEchZU6swyKj8EoPTkKLEXdvgUGSra6J/YEMFVpt/oG0w1jJrIiw
         ywxuv+wGjfhQjRWhD3olO+fZYT041OpqYE0fy1f0FXTBmiDoe+JaiVPnYO+pe9W6Ki
         B98VVjq+FmcDvqUf8UQRzMa6t9RlOHsMuyz6QuMR4KKYqI7vgsHzWmQKz1xGEqgCNZ
         T5U33rUD8e8keyZIKYbVQREbcySz4j+7+ac1dJ38v54TXDNDUibPkTRD+LD/Gx/BdL
         cHQCMrxEHmnWQ==
Date:   Sat, 11 Mar 2023 10:54:59 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZAzOgw8Ui4kh1Z3D@sol.localdomain>
References: <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzH8Ve05SRLYPnR@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAzH8Ve05SRLYPnR@sashalap>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 01:26:57PM -0500, Sasha Levin wrote:
> 
> "job"? do you think I'm paid to do this work?

> Why would I stonewall improvements to the process?
> 
> I'm getting a bunch of suggestions and complaints that I'm not implementing
> those suggestions fast enough on my spare time.
> 
> > One of the first things I would do if I was maintaining the stable kernels is to
> > set up a way to automatically run searches on the mailing lists, and then take
> > advantage of that in the stable process in various ways.  Not having that is the
> > root cause of a lot of the issues with the current process, IMO.
> 
> "if I was maintaining the stable kernels" - why is this rellevant? give
> us the tool you've proposed below and we'll be happy to use it. Heck,
> don't give it to us, use it to review the patches we're sending out for
> review and let us know if we've missed anything.

It's kind of a stretch to claim that maintaining the stable kernels is not part
of your and Greg's jobs.  But anyway, the real problem is that it's currently
very hard for others to contribute, given the unique role the stable maintainers
have and the lack of documentation about it.  Each of the two maintainers has
their own scripts, and it is not clear how they use them and what processes they
follow.  (Even just stable-kernel-rules.rst is totally incorrect these days.)
Actually I still don't even know where your scripts are!  They are not in
stable-queue/scripts, it seems those are only Greg's scripts?  And if I built
something, how do I know you would even use it?  You likely have all sorts of
requirements that I don't even know about.

> 
> I've been playing with this in the past - I had a bot that looks at the
> mailing lists for patches that are tagged for stable, and attempts to
> apply/build then on the multiple trees to verify that it works and send
> a reply back if something goes wrong, asking for a backport.
> 
> It gets a bit tricky as there's no way to go back from a commit to the
> initial submission, you start hitting issues like:
> 
> - Patches get re-sent multiple times (think stuff like tip trees,
> reviews from other maintainers, etc).
> - Different versions of patches - for example, v1 was a single patch
> and in v2 it became multiple patches.
> 
> I'm not arguing against your idea, I'm just saying that it's not
> trivial. An incomplete work here simply won't scale to the thousands of
> patches that flow in the trees, and won't be as useful. I don't think
> that this is trivial as you suggest.

There are obviously going to be edge cases; another one is commits that show up
in git without ever having been sent to the mailing list.  I don't think they
actually matter very much, though.  Worst case, we miss some things, but still
find everything else.

> 
> If you disagree, and really think it's trivial, take 5 minutes to write
> something up? please?

I never said that it's "trivial" or that it would take only 5 minutes; that's
just silly.  Just that this is possible and it's what needs to be done.

If you don't have time, you should instead be helping ensure that the work gets
done by someone else (internship, GSoC project, etc.).

And yes, I am interested in contributing, but as I mentioned I think you need to
first acknowledge that there is a problem, fix your attitude of immediately
pushing back on everything, and make it easier for people to contribute.

- Eric
