Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11BF96B5DBB
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 17:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjCKQRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 11:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjCKQRO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 11:17:14 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5737E5D762
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 08:17:13 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 32BGGi06006833
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 11 Mar 2023 11:16:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1678551406; bh=pk7UJBZS0pGO5djHQvl6UDLseuYPhzAM+aRfDFea3mY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=ojGDog63lbcLBbNtVq7le5fyHKms9oOWTDO4oSVK8AKNS6zOLnVgMsVwDPn9ARvHJ
         0pezOmtlmVrjSaqLEMvjCAh4k4l5ZwMtLBlF/XhK5idJVIs3h881Ktw1OM66OVOipA
         Ba9t2BEYTNDxEDBHhc0yH4LseE/Ej3evoXgUz1+nyQNxv5LqkfXs5Mv74ok1NSgsn9
         HQWreuksic4PHmm+8n/2kl9cHR6zT38D8Q6w1zkB/9OA1ZEVczJw706IXrKUOTfkPj
         WhHAbzv8fzoa1xAYxJOFrEzYEmAzI1WSXwH0KP91vz8+4j0LTQD9kAGw+5fPBn9Dry
         6vo0GSLFaSl1g==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 5EC5315C45B9; Sat, 11 Mar 2023 11:16:44 -0500 (EST)
Date:   Sat, 11 Mar 2023 11:16:44 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <20230311161644.GH860405@mit.edu>
References: <Y/rbGxq8oAEsW28j@sol.localdomain>
 <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAyK0KM6JmVOvQWy@sashalap>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 09:06:08AM -0500, Sasha Levin wrote:
> 
> I suppose that if I had a way to know if a certain a commit is part of a
> series, I could either take all of it or none of it, but I don't think I
> have a way of doing that by looking at a commit in Linus' tree
> (suggestions welcome, I'm happy to implement them).

Well, this is why I think it is a good idea to have a link to the
patch series in lore.  I know Linus doesn't like it, claiming it
doesn't add any value, but I have to disagree.  It adds two bits of
value.

First, if there is any discussion on the review of the patch before it
goes in, the lore link gives you access to that --- and if people have
a back-lick in the cover letter of version N to the cover letter of
version N-1, it allows someone doing code archeology to find all of
the discussions around the patch series in the lore archives.

Secondly, the lore link will allow you to figure out whether or not
the patch is part of a series; b4 can figure this out by looking at
the in-reply-to headers, and lore will chain the patch series
together, so if the commit contains a lore link to the patch, the
AUTOSEL script could use that to find out whether the patch is part of
the series.

And this is really easy to do.  All you need is the following in
.git/hooks/applypatch-msg:

#!/bin/sh
# For .git/hooks/applypatch-msg
#
. git-sh-setup
perl -pi -e 's|^Message-Id:\s*<?([^>]+)>?$|Link: https://lore.kernel.org/r/$1|g;' "$1"
test -x "$GIT_DIR/hooks/commit-msg" &&
	exec "$GIT_DIR/hooks/commit-msg" ${1+"$@"}
:

Cheers,

						- Ted

P.S.  There was a recent patch series where I noticed that I would be
screwed if AUTOSEL would only take patch 2/2 and not patch 1/2.  I
dealt with that though by adding an explicit "Cc: stable@kernel.org".
So that's the other way to avoid breakage; if people were universally
careful about adding "Cc: stable@kernel.org" tags, then we wouldn't
need AUTOSEL at all.

And this is another place where I break with commonly received wisdom
about "Thou Shalt Never, Never Rewind The Git Branch".  Personally, if
I find that I missed a Cc: stable tag, rewinding the branch to add
edit the trailers is *far* better a tradeoff than adhering to some
religious rule about never rewinding git branches.  Of course, I can
get away with that since I don't have people basing their branches on
my branch.  But I've seen people who will self-righteously proclaim
non-rewinding git branches as the One True Way to do git, and I
profoundly disagree with that point of view.

