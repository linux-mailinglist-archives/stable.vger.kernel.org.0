Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3536B6342
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 06:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjCLFLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 00:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjCLFK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 00:10:57 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B015FA46
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 21:10:56 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 32C59l8J010737
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Mar 2023 00:09:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1678597791; bh=qE6TvQM2AXMlAtR9s37di7EXZuuUTghNjFFnO7EhAhk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=oOMahW9M/T9BlrdY8IoLRiSgDb3un+X4NAnT60CkizavytVNJLDZIBSDopvdrXfU6
         /5L3a/RqX+cTjCWnQ26UIZJAFoJAD2HQ7WDxlDxqCsQvB5RhsYuMClmBAkg7d9ShZW
         WGlCdnE7m9TvKQpQdlwAI2xZMhyhWr09aT6pHbiEl01gTkQimvfjV630gbTkGdCCTs
         O7F1mDtCca7aKoPGot8mtYuEYs7ZjiFueRcLQ/hqzwjCaD7CBVab/n+LMOS1jYg9jh
         Y9h4VvCvoQBwvRCT9wOq8How9/+TtNrTtgV3UUzU4yfDMDNXI1LnQLeJxvofhCLi5O
         d5Tthou4/ylKA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 7ED7015C45B9; Sun, 12 Mar 2023 00:09:47 -0500 (EST)
Date:   Sun, 12 Mar 2023 00:09:47 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Willy Tarreau <w@1wt.eu>
Cc:     David Laight <David.Laight@aculab.com>,
        "'Sasha Levin'" <sashal@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: AUTOSEL process
Message-ID: <20230312050947.GK860405@mit.edu>
References: <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <9ff6fe2c13434512b034823112843d4f@AcuMS.aculab.com>
 <ZA1X46ClAJGc/2V7@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZA1X46ClAJGc/2V7@1wt.eu>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 12, 2023 at 05:41:07AM +0100, Willy Tarreau wrote:
> 
> I suspect that having an option to keep the message ID in the footer (a
> bit like the "cherry-picked from" tag but instead "blongs to series")
> could possibly help. And when no such info is present we could have
> one ID generated per "git am" execution since usually if you apply an
> mbox, it constitutes a series (but not always of course, though it's
> not difficult to arrange series like this).

As I pointed out earlier, some of us are adding the message ID in the
footer alrady, using a Link tag.  This is even documented already in
the Kernel Maintainer's Handbook, so I'm pretty sure it's not just me.  :-)

https://www.kernel.org/doc/html/latest/maintainer/configure-git.html#creating-commit-links-to-lore-kernel-org

This is quite sufficient to extract out the full patch series given a
particular patch.  The b4 python script does this this; given a single
Message-Id, it can find all of the other patches in the series.  I
won't say that it it's "trivial", but the code already exists, and you
can copy and paste it from b4.  Or just have your script shell out to
"b4 am -o /tmp/scratchdir $MSGID"

						- Ted
