Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97A426B60DB
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 22:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjCKVOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 16:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCKVOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 16:14:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9A941096;
        Sat, 11 Mar 2023 13:14:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E917B80B37;
        Sat, 11 Mar 2023 21:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B867CC433D2;
        Sat, 11 Mar 2023 21:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678569279;
        bh=Usxa5LuHSmLnfgl7De23RRJX0tgoeIGUzPYdQGCkm1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tLINkYFwV3rH6R3eqi3rIb8iZ+zkar3FpKzeVucsBPtvn8jdDbUWfLnXqjctzjH37
         ryjgzoW3yhKTOr9lGBgqLXUxtDnMIbDxwO3n7L7xizNIqeQuQb296huMlPQXXWIDfc
         enLwAWqNAtcphkAeXAKOVy/QRAq4NKzeklzIobppTd4f29CJeAJtyu60saTpfVUW2A
         T+BS4JoBsT01RGKenq0FquSj6bG2v9ZbPweSn5/tyDs7Un0aAKf0i8zDgOIIyTButE
         X9rAen323VZEyRRaIk0aJa8MjZiQAsbNTXzuBuEGPAw0GxN4vFF8gOU1w8xG0QRv0r
         dJZ6u/Mv2+Wmw==
Date:   Sat, 11 Mar 2023 16:14:37 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZAzvPR1zev3tFJoH@sashalap>
References: <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzH8Ve05SRLYPnR@sashalap>
 <ZAzOgw8Ui4kh1Z3D@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZAzOgw8Ui4kh1Z3D@sol.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 10:54:59AM -0800, Eric Biggers wrote:
>On Sat, Mar 11, 2023 at 01:26:57PM -0500, Sasha Levin wrote:
>>
>> "job"? do you think I'm paid to do this work?
>
>> Why would I stonewall improvements to the process?
>>
>> I'm getting a bunch of suggestions and complaints that I'm not implementing
>> those suggestions fast enough on my spare time.
>>
>> > One of the first things I would do if I was maintaining the stable kernels is to
>> > set up a way to automatically run searches on the mailing lists, and then take
>> > advantage of that in the stable process in various ways.  Not having that is the
>> > root cause of a lot of the issues with the current process, IMO.
>>
>> "if I was maintaining the stable kernels" - why is this rellevant? give
>> us the tool you've proposed below and we'll be happy to use it. Heck,
>> don't give it to us, use it to review the patches we're sending out for
>> review and let us know if we've missed anything.
>
>It's kind of a stretch to claim that maintaining the stable kernels is not part
>of your and Greg's jobs.  But anyway, the real problem is that it's currently
>very hard for others to contribute, given the unique role the stable maintainers
>have and the lack of documentation about it.  Each of the two maintainers has
>their own scripts, and it is not clear how they use them and what processes they
>follow.  (Even just stable-kernel-rules.rst is totally incorrect these days.)
>Actually I still don't even know where your scripts are!  They are not in
>stable-queue/scripts, it seems those are only Greg's scripts?  And if I built
>something, how do I know you would even use it?  You likely have all sorts of
>requirements that I don't even know about.

https://kernel.googlesource.com/pub/scm/linux/kernel/git/sashal/stable-tools/

I've last updated it about two years ago, but really it's not out of
date - it just doesn't get that many changes at this point.

This is a mess we want to solve too: having a single repository with
tools for "maintaining stable kernel trees" would be ideal and awesome,
but it's quite the lift.

We ended up with different scripts because we started trying to solve
different issues, and ended up converging into the same tree: even now,
each of us handles different subsection of commits going into the kernel
tree, we just end up pushing them into the same stable branch at the
end.

>>
>> I've been playing with this in the past - I had a bot that looks at the
>> mailing lists for patches that are tagged for stable, and attempts to
>> apply/build then on the multiple trees to verify that it works and send
>> a reply back if something goes wrong, asking for a backport.
>>
>> It gets a bit tricky as there's no way to go back from a commit to the
>> initial submission, you start hitting issues like:
>>
>> - Patches get re-sent multiple times (think stuff like tip trees,
>> reviews from other maintainers, etc).
>> - Different versions of patches - for example, v1 was a single patch
>> and in v2 it became multiple patches.
>>
>> I'm not arguing against your idea, I'm just saying that it's not
>> trivial. An incomplete work here simply won't scale to the thousands of
>> patches that flow in the trees, and won't be as useful. I don't think
>> that this is trivial as you suggest.
>
>There are obviously going to be edge cases; another one is commits that show up
>in git without ever having been sent to the mailing list.  I don't think they
>actually matter very much, though.  Worst case, we miss some things, but still
>find everything else.

Consider the opposite, which I just saw earlier today with a commit that
was tagged for stable: https://lore.kernel.org/all/20230217022200.3092987-1-yukuai1@huaweicloud.com/

Here, commit 1/2 reverts a previously broken fix, and is not marked for
stable. Commit 2/2 applies the proper fix, but won't apply cleanly or
correctly unless you have patch 1/2.

In this case you need both commits in the series, rather than none of
them, otherwise you leave the trees broken.

>>
>> If you disagree, and really think it's trivial, take 5 minutes to write
>> something up? please?
>
>I never said that it's "trivial" or that it would take only 5 minutes; that's
>just silly.  Just that this is possible and it's what needs to be done.
>
>If you don't have time, you should instead be helping ensure that the work gets
>done by someone else (internship, GSoC project, etc.).

My personal experience with this approach was that:

1. It ends up being more effort mentoring someone who is unfamailiar
with this work rather than doing it myself.

2. There are very *very* few people who want to be doing this: to begin
with the kernel is one of the less popular areas to get into, and on top
of that the stable tree work is even worse because you do "maintenance"
rather than write new shiny features.

>And yes, I am interested in contributing, but as I mentioned I think you need to
>first acknowledge that there is a problem, fix your attitude of immediately
>pushing back on everything, and make it easier for people to contribute.

I don't think we disagree that the process is broken: this is one of the
reasons we went away from trying to support 6 year LTS kernels.

However, we are not pushing back on ideas, we are asking for a hand in
improving the process: we've been getting drive-by comments quite often,
but when it comes to be doing the actual work people are quite reluctant
to help.

If you want to sit down and scope out initial set of work around tooling
to help here I'm more than happy to do that: I'm planning to be both in
OSS and LPC if you want to do it in person, along with anyone else
interested in helping out.

-- 
Thanks,
Sasha
