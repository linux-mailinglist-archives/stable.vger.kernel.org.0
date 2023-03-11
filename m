Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920026B5FC1
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 19:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjCKS1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 13:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjCKS1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 13:27:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCDC65073;
        Sat, 11 Mar 2023 10:27:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC9F0B80066;
        Sat, 11 Mar 2023 18:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DD9C433EF;
        Sat, 11 Mar 2023 18:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678559219;
        bh=3iAyDZpKshk7IQK0fRZAxsKNdS+J95Uq6fH2Y9EK6m8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ya+6c/AuJSmcJpRuWc9J8bv+IXsrNpldfMmGz5925Z+SPMX87AAVuyQ5Mz2tZjb9N
         xtLpRHLzD/xfcnpxJWK5SkskLlnZcX5KZS8tT5tPLQPfArxuz2FjpKM0zhwZ8amMuN
         FqwHXQq+DgKXXi0a47pqIeswfNCQI08aG0hNgLggN7rifSI65I+4pTzeMOLVvwGRNk
         SpO9VD0MKmS1Y11k9N9MHPpZcwS52KbRrHvGynlv3geUwp2KIP61uMRlw2p5Y0YLam
         PgY5meLbvRxYs7V2Z6JndLLTueJ9x7+fnhIqGq+Y1ruk5wK8Ul9bB1v7mAlWb1HTfi
         k+IA/T9fhx9pA==
Date:   Sat, 11 Mar 2023 13:26:57 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZAzH8Ve05SRLYPnR@sashalap>
References: <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZAy+3f1/xfl6dWpI@sol.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 09:48:13AM -0800, Eric Biggers wrote:
>On Sat, Mar 11, 2023 at 11:16:44AM -0500, Theodore Ts'o wrote:
>> On Sat, Mar 11, 2023 at 09:06:08AM -0500, Sasha Levin wrote:
>> >
>> > I suppose that if I had a way to know if a certain a commit is part of a
>> > series, I could either take all of it or none of it, but I don't think I
>> > have a way of doing that by looking at a commit in Linus' tree
>> > (suggestions welcome, I'm happy to implement them).
>>
>> Well, this is why I think it is a good idea to have a link to the
>> patch series in lore.  I know Linus doesn't like it, claiming it
>> doesn't add any value, but I have to disagree.  It adds two bits of
>> value.
>>
>
>So, earlier I was going to go into more detail about some of my ideas, before
>Sasha and Greg started stonewalling with "patches welcome" (i.e. "I'm refusing
>to do my job") and various silly arguments about why nothing should be changed.
>But I suppose the worst thing that can happen is that that just continues, so
>here it goes:

"job"? do you think I'm paid to do this work? Why would I stonewall
improvements to the process?

I'm getting a bunch of suggestions and complaints that I'm not implementing
those suggestions fast enough on my spare time.

>One of the first things I would do if I was maintaining the stable kernels is to
>set up a way to automatically run searches on the mailing lists, and then take
>advantage of that in the stable process in various ways.  Not having that is the
>root cause of a lot of the issues with the current process, IMO.

"if I was maintaining the stable kernels" - why is this rellevant? give
us the tool you've proposed below and we'll be happy to use it. Heck,
don't give it to us, use it to review the patches we're sending out for
review and let us know if we've missed anything.

>Now that lore exists, this might be trivial: it could be done just by hammering
>lore.kernel.org with queries https://lore.kernel.org/linux-fsdevel/?q=query from
>a Python script.
>
>Of course, there's a chance that won't scale to multiple queries for each one of
>thousands of stable commits, or at least won't be friendly to the kernel.org
>admins.  In that case, what can be done is to download down all emails from all
>lists, using lore's git mirrors or Atom feeds, and index them locally.  (Note:
>if the complete history is inconveniently large, then just indexing the last
>year or so would work nearly as well.)
>
>Then once that is in place, that could be used in various ways.  For example,
>given a git commit, it's possible to search by email subject to get to the
>original patch, *even if the git commit does not have a Link tag*.  And it can
>be automatically checked whether it's part of a patch series, and if so, whether
>all the patches in the series are being backported or just some.
>
>This could also be used to check for mentions of a commit on the mailing list
>that potentially indicate a regression report, which is one of the issues we
>discussed earlier.  I'm not sure what the optimal search criteria would be, but
>one option would be something like "messages that contain the commit title or
>commit ID and are dated to after the commit being committed".  There might need
>to be some exclusions added to that.
>
>This could also be used to automatically find the AUTOSEL email, if one exists,
>and check whether it's been replied to or not.
>
>The purpose of all these mailing list searches would be to generate a list of
>potential issues with backporting each commit, which would then undergo brief
>human review.  Once issues are reviewed, that state would be persisted, so that
>if the script gets run again, it would only show *new* information based on new
>mailing list emails that have not already been reviewed.  That's needed because
>these issues need to be checked for when the patch is initially proposed for
>stable as well as slightly later, before the actual release happens.
>
>If the stable maintainers have no time for doing *any* human review themselves
>(again, I do not know what their requirements are on how much time they can
>spend per patch), then instead an email with the list of potential issues could
>be generated and sent to stable@vger.kernel.org for review by others.
>
>Anyway, that's my idea.  I know the response will be either "that won't work" or
>"patches welcome", or a mix of both, but that's it.

I've been playing with this in the past - I had a bot that looks at the
mailing lists for patches that are tagged for stable, and attempts to
apply/build then on the multiple trees to verify that it works and send
a reply back if something goes wrong, asking for a backport.

It gets a bit tricky as there's no way to go back from a commit to the
initial submission, you start hitting issues like:

- Patches get re-sent multiple times (think stuff like tip trees,
reviews from other maintainers, etc).
- Different versions of patches - for example, v1 was a single patch
and in v2 it became multiple patches.

I'm not arguing against your idea, I'm just saying that it's not
trivial. An incomplete work here simply won't scale to the thousands of
patches that flow in the trees, and won't be as useful. I don't think
that this is trivial as you suggest.

If you disagree, and really think it's trivial, take 5 minutes to write
something up? please?

-- 
Thanks,
Sasha
