Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6766B632F
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 05:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjCLElU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 23:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCLElT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 23:41:19 -0500
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34DF33864A;
        Sat, 11 Mar 2023 20:41:18 -0800 (PST)
Received: (from willy@localhost)
        by mail.home.local (8.17.1/8.17.1/Submit) id 32C4f7lt032752;
        Sun, 12 Mar 2023 05:41:07 +0100
Date:   Sun, 12 Mar 2023 05:41:07 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     "'Sasha Levin'" <sashal@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: AUTOSEL process
Message-ID: <ZA1X46ClAJGc/2V7@1wt.eu>
References: <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <9ff6fe2c13434512b034823112843d4f@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ff6fe2c13434512b034823112843d4f@AcuMS.aculab.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 10:38:10PM +0000, David Laight wrote:
> ...
> > I suppose that if I had a way to know if a certain a commit is part of a
> > series, I could either take all of it or none of it, but I don't think I
> > have a way of doing that by looking at a commit in Linus' tree
> > (suggestions welcome, I'm happy to implement them).
> 
> Could something in git (eg when patches get applied) add dependencies
> between the patches in a series.
> While that won't force the entire series be added, it would ensure
> that all earlier patches are added.

I suspect that having an option to keep the message ID in the footer (a
bit like the "cherry-picked from" tag but instead "blongs to series")
could possibly help. And when no such info is present we could have
one ID generated per "git am" execution since usually if you apply an
mbox, it constitutes a series (but not always of course, though it's
not difficult to arrange series like this).

Willy
