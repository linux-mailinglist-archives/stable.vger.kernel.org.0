Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F783E4B08
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 19:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbhHIRlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 13:41:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234473AbhHIRlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 13:41:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD06C6056B;
        Mon,  9 Aug 2021 17:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628530844;
        bh=AC0vGPhRmMgiiJoeZSopqQbR7kThYig95r8nOjwReFQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AoIiCFIoHIJZOci3atO3Os3+MYkP0yqT6e6PlIADmIamlE4imPcsbJEv1l867PS21
         mpVNrtdAqfUfx2od89RZlABGxL8CqFAtbLbgjWSkm4dYL/YeplA6Mb+uP6UOUgwGLl
         F+gQHcHkeohhrK9PuSvt0dfZ5vH7i53Vo/XERKBY=
Date:   Mon, 9 Aug 2021 19:40:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Willy Tarreau <w@1wt.eu>, "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] pipe: increase minimum default pipe size
 to 2 pages" failed to apply to 4.4-stable tree
Message-ID: <YRFomYOJvuJx8VTT@kroah.com>
References: <162850274511123@kroah.com>
 <CAHk-=wg9Ar-XBVQ860-TLA-eo8N=UYO8DQ5Ye0rBBuiwzv_N_A@mail.gmail.com>
 <YRFXe06Eih48qlD7@kroah.com>
 <CAHk-=wh5E7qqooGiqHJ3U2=PBFPs1UKuXMcoNi+3mQ4wZDha7g@mail.gmail.com>
 <CAHk-=whoV+SNzvOLSOOfM=Gj3m7A81Y4TYd2qtSO3soStiWxFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whoV+SNzvOLSOOfM=Gj3m7A81Y4TYd2qtSO3soStiWxFQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 09, 2021 at 09:46:42AM -0700, Linus Torvalds wrote:
> On Mon, Aug 9, 2021 at 9:36 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Oh, I guess I have to actually download the stable tree. Normally I
> > only keep the main tree git around..
> 
> Ok, so it does the accounting a bit differently - after allocating
> them rather than before - but it actually ends up being a simpler
> patch because of that.
> 
> I think it ends up like the attached.
> 
> UNTESTED.
> 
> I'm not 100% convinced we need to backport this that far anyway, but
> whatever. Nobody sane runs something like a build server on 4.4.

{sigh}

I wish.

> Nobody sane should run 4.4 at all, of course.

Oh I really wish.  4.4 is sticking around in some situations for a very
long time for odd reasons, and build servers look to be one of them (a
very large cloud company seems enamored with that kernel for some
reason...)


>  fs/pipe.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)

This looks good to me, I'll queue it up in a bit as it's more
descriptive than Alex's backport.

Thanks for this!

greg k-h
