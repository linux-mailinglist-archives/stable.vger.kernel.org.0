Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6FC26BF1F
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 10:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgIPIYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 04:24:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgIPIYg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 04:24:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FA8820872;
        Wed, 16 Sep 2020 08:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600244676;
        bh=zPhvVqTz0Z81Pvv9qTb/O+koD5jHaLdOlDZDhXxlZDo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0UstnE+3LvFJK3WLYoC13EAGhug1zVobuzEIGquyLWByBxnNssMKMs4KDBbC2LpMY
         dSMFO7Cvx/R7hkz8ZzVFOX1Y4z5xvUsCwqix6hCgHOJDgd++CtmRKyU9NwEujtkqj4
         nRTW9OmekNVIv466ClynPCy5ExDNkD8IgvuI55N4=
Date:   Wed, 16 Sep 2020 10:25:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     jikos@suse.cz, vojtech@suse.cz, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Yuan Ming <yuanmingbuaa@gmail.com>,
        Willy Tarreau <w@1wt.eu>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.19 66/78] fbcon: remove soft scrollback code
Message-ID: <20200916082510.GB509119@kroah.com>
References: <20200915140633.552502750@linuxfoundation.org>
 <20200915140636.861676717@linuxfoundation.org>
 <20200916075759.GC32537@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916075759.GC32537@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 09:57:59AM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Linus Torvalds <torvalds@linux-foundation.org>
> > 
> > commit 50145474f6ef4a9c19205b173da6264a644c7489 upstream.
> > 
> > This (and the VGA soft scrollback) turns out to have various nasty small
> > special cases that nobody really is willing to fight.  The soft
> > scrollback code was really useful a few decades ago when you typically
> > used the console interactively as the main way to interact with the
> > machine, but that just isn't the case any more.
> > 
> > So it's not worth dragging along.
> 
> It is still useful.
> 
> In particular, kernel is now very verbose, so important messages
> during bootup scroll away. It is way bigger deal when you can no
> longer get to them using shift-pageup.
> 
> fsck is rather verbose, too, and there's no easy way to run that under
> X terminal... and yes, that makes scrollback very useful, too.
> 
> So, I believe we'll need to fix this. I guess I could do it. I also
> guess I'll not have to, because SuSE or RedHat will want to fix it.
> 
> Anyway, this really should not be merged into stable.

It's merged into the stable trees that _I_ have to maintain.  If you
want to revert it for trees you maintain and wish to keep secure, that's
up to you.  But it's something that I _STRONGLY_ do not advise doing.

See the email recently on oss-devel for one such reason why this was
removed...

good luck!

greg k-h
