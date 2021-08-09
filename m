Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC563E4CA3
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 21:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbhHITEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 15:04:31 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:34780 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235845AbhHITEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 15:04:30 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 179J46sr023728;
        Mon, 9 Aug 2021 21:04:06 +0200
Date:   Mon, 9 Aug 2021 21:04:06 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] pipe: increase minimum default pipe size
 to 2 pages" failed to apply to 4.4-stable tree
Message-ID: <20210809190406.GA23706@1wt.eu>
References: <162850274511123@kroah.com>
 <CAHk-=wg9Ar-XBVQ860-TLA-eo8N=UYO8DQ5Ye0rBBuiwzv_N_A@mail.gmail.com>
 <YRFXe06Eih48qlD7@kroah.com>
 <CAHk-=wh5E7qqooGiqHJ3U2=PBFPs1UKuXMcoNi+3mQ4wZDha7g@mail.gmail.com>
 <CAHk-=whoV+SNzvOLSOOfM=Gj3m7A81Y4TYd2qtSO3soStiWxFQ@mail.gmail.com>
 <YRFomYOJvuJx8VTT@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRFomYOJvuJx8VTT@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 09, 2021 at 07:40:41PM +0200, Greg Kroah-Hartman wrote:
> >  fs/pipe.c | 17 ++++++++++++++++-
> >  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> This looks good to me, I'll queue it up in a bit as it's more
> descriptive than Alex's backport.

Greg, do you *really* want to backport it to 4.4 ? I mean, if nobody
faces this issue in 4.4 I can see more risks with the fix that without
for systems with low memory (or manually tuned memory usage).

Willy
