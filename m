Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9821A6B596D
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 09:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjCKIMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 03:12:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCKIMT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 03:12:19 -0500
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B454913F686;
        Sat, 11 Mar 2023 00:12:17 -0800 (PST)
Received: (from willy@localhost)
        by mail.home.local (8.17.1/8.17.1/Submit) id 32B8BYKR026215;
        Sat, 11 Mar 2023 09:11:34 +0100
Date:   Sat, 11 Mar 2023 09:11:34 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZAw3tt9xISOdb5sS@1wt.eu>
References: <20230226034256.771769-12-sashal@kernel.org>
 <Y/rbGxq8oAEsW28j@sol.localdomain>
 <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAwe95meyCiv6qc4@casper.infradead.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 06:25:59AM +0000, Matthew Wilcox wrote:
> On Tue, Mar 07, 2023 at 09:45:24PM +0000, Eric Biggers wrote:
> > On Tue, Mar 07, 2023 at 10:18:35PM +0100, Pavel Machek wrote:
> > > I believe that -stable would be more useful without AUTOSEL process.
> > 
> > There has to be a way to ensure that security fixes that weren't properly tagged
> > make it to stable anyway.  So, AUTOSEL is necessary, at least in some form.  I
> > think that debating *whether it should exist* is a distraction from what's
> > actually important, which is that the current AUTOSEL process has some specific
> > problems, and these specific problems need to be fixed...
> 
> I agree with you, that we need autosel and we also need autosel to
> be better.  I actually see Pavel's mail as a datapoint (or "anecdote",
> if you will) in support of that; the autosel process currently works
> so badly that a long-time contributor thinks it's worse than nothing.
> 
> Sasha, what do you need to help you make this better?

One would probably need to define "better" and "so badly". As a user
of -stable kernels, I consider that they've got much better over the
last years. A lot of processes have improved everywhere even before
the release, but I do think that autosel is part of what generally
gives a chance to some useful and desired fixed (e.g. in drivers) to
be backported and save some users unneeded headaches.

In fact I think that the reason for the negative perception is that
patches that it picks are visible, and it's easy to think "WTF" when
seeing one of them. Previously, these patches were not proposed, so
nobody knew they were missing. It happened to plenty of us to spend
some time trying to spot why a stable kernel would occasionally fail
on a machine, and discovering in the process that mainline did work
because it contained a fix that was never backported. This is
frustrating but there's noone to blame for failing to pick that patch
(and the patch's author should not be blamed either since for small
compatibility stuff it's probably common to see first-timers who are
not yet at ease with the process).

Here the patches are CCed to their authors before being merged. They
get a chance to be reviewed and rejected. Granted, maybe sometimes they
could be subject to a longer delay or be sent to certain lists. Maybe.
But I do think that the complaints in fact reflect a process that's not
as broken as some think, precisely because it allows people to complain
when something is going wrong. The previous process didn't permit that.
For this alone it's a progress.

Willy
