Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434223E55A2
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 10:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229474AbhHJIjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 04:39:44 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:34790 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhHJIjn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 04:39:43 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 17A8dE76028568;
        Tue, 10 Aug 2021 10:39:14 +0200
Date:   Tue, 10 Aug 2021 10:39:14 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] pipe: increase minimum default pipe size
 to 2 pages" failed to apply to 4.4-stable tree
Message-ID: <20210810083914.GB27554@1wt.eu>
References: <162850274511123@kroah.com>
 <CAHk-=wg9Ar-XBVQ860-TLA-eo8N=UYO8DQ5Ye0rBBuiwzv_N_A@mail.gmail.com>
 <YRFXe06Eih48qlD7@kroah.com>
 <CAHk-=wh5E7qqooGiqHJ3U2=PBFPs1UKuXMcoNi+3mQ4wZDha7g@mail.gmail.com>
 <CAHk-=whoV+SNzvOLSOOfM=Gj3m7A81Y4TYd2qtSO3soStiWxFQ@mail.gmail.com>
 <YRFomYOJvuJx8VTT@kroah.com>
 <20210809190406.GA23706@1wt.eu>
 <YRIilQUgbcejSREr@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRIilQUgbcejSREr@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 10, 2021 at 08:54:13AM +0200, Greg Kroah-Hartman wrote:
> > Greg, do you *really* want to backport it to 4.4 ? I mean, if nobody
> > faces this issue in 4.4 I can see more risks with the fix that without
> > for systems with low memory (or manually tuned memory usage).
> 
> I always prefer to merge "known fixes" to the stable kernel trees as
> somehow once one person hits a bug, everyone hits it, no matter how long
> it was in hiding :)
> 
> The additional memory usage here seems low to me, and we backported the
> needed accounting changes there a long time ago, and we know that 4.4.y
> is being used for build servers as well as other huge hosting providers.
> The "tiny" systems that might be on 4.4 are not really updating
> themselves to newer kernels from what I can tell.

I agree that someone sticking to 4.4 surely doesn't want to update.

> So I would prefer to take this patch, but am always willing to revert it
> if someone reports problems with it,

In this case I agree, given that such a problem, if any, would be quick
to notice.

Thanks,
Willy
