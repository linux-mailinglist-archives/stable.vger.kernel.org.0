Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6F76A6842
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 08:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjCAHkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 02:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCAHkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 02:40:21 -0500
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 499275BB3;
        Tue, 28 Feb 2023 23:40:18 -0800 (PST)
Received: (from willy@localhost)
        by mail.home.local (8.17.1/8.17.1/Submit) id 3217e3eT030901;
        Wed, 1 Mar 2023 08:40:03 +0100
Date:   Wed, 1 Mar 2023 08:40:03 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Slade Watkins <srw@sladewatkins.net>,
        Sasha Levin <sashal@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/8BU4cyySwQZSII@1wt.eu>
References: <Y/0wMiOwoeLcFefc@sashalap>
 <Y/1LlA5WogOAPBNv@gmail.com>
 <Y/1em4ygHgSjIYau@sashalap>
 <Y/136zpJSWx96YEe@sol.localdomain>
 <CAOQ4uxietbePiWgw8aOZiZ+YT=5vYVdPH=ChnBkU_KCaHGv+1w@mail.gmail.com>
 <Y/3lV0P9h+FxmjyF@kroah.com>
 <8caf1c23-54e7-6357-29b0-4f7ddf8f16d2@sladewatkins.net>
 <Y/7fFHv3dU6osd6x@sol.localdomain>
 <Y/7sLcCtsk9oqZH0@kroah.com>
 <Y/79Tfn5kFIItUDD@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/79Tfn5kFIItUDD@sol.localdomain>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_FILL_THIS_FORM_SHORT autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 28, 2023 at 11:22:53PM -0800, Eric Biggers wrote:
> On Wed, Mar 01, 2023 at 07:09:49AM +0100, Greg KH wrote:
> > 
> > Why would the FAILED emails want to go to a mailing list?  If the people
> > that were part of making the patch don't want to respond to a FAILED
> > email, why would anyone on the mailing list?
> 
> The same reason we use mailing lists for kernel development at all instead of
> just sending patches directly to the MAINTAINERS.

I'm personally seeing a difference between reviewing patches on a mailing
list to help someone polish it, and commenting on its suitability for
stable once it's got merged, from someone not having participated to its
inclusion. All such patches are already sent to stable@ which many of
those of us interested in having a look are already subscribed to, and
which most often just triggers a quick glance depending on areas of
interest. I hardly see anyone just curious about a patch ask "are you
sure ?".

I could possibly understand the value of sending the failed ones to a
list, in case someone with more time available than the author wants to
give it a try. But again they're already sent to stable@. It's just that
it might be possible that more interested parties are on other lists.
But again I'm not fully convinced.

> > But hey, I'll be glad to take a change to my script to add that
> > functionality if you want to make it, it's here:
> > 	https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/scripts/bad_stable
> > 
> 
> Ah, the classic "patches welcome".
> 
> Unfortunately, I don't think that can work very well for scripts that are only
> ever used by at most two people -- you and Sasha.  Many even just by you,
> apparently, as I see your name, email address, home directory, etc. hardcoded in
> the scripts.

But it's going into a dead end. You are the one saying that changes
are easy, suggesting to use get_maintainers.pl, so easy that you can't
try to adapt them in existing stuff. Even without modifying existing
scripts, if you are really interested by such features, why not at least
try to run your idea over a whole series, figure how long it takes, how
accurate it seems to be, adjust the output to remove unwanted noise and
propose for review a few lines that seem to do the job for you ?

> (BTW, where are the scripts Sasha uses for AUTOSEL?)

Maybe they're even uglier and he doesn't want to show them. The ones
I was using to sort out 3.10 patches were totally ugly and full of
heuristics, with lines that I would comment/uncomment along operations
to refine the selection and I definitely wasn't going to post that
anywhere. They were looking a bit like a commented extract of my
.history. I'm sure over time Sasha has a much cleaner and repeatable
process but maybe it involves parts that are not stabilized, that
he's not proud of, or even tools contributed by coworkers that we
don't necessarily need to know about and where he hardly sees how
anyone could bring any help.

Willy
