Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4233E49CA
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 18:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhHIQ2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 12:28:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhHIQ2B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 12:28:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD8C360F11;
        Mon,  9 Aug 2021 16:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628526461;
        bh=jUTu+v/hY+2YeDAd99B3I79h7+RNApNgQvsIlyb0rf4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gW5DlC/SyP1aVCDsW26lrDGJdyYztyXXUDZ7XNSXxZm3JgedeIXIDRobiQ0vJz0D3
         pQEs0ay1nwv/xUwmj8onwGPWe345U5sZgaBHZjF9bCWiEqjkd60Mz2+za/dPowu8nV
         TdU7+G5BkqFXBPfmEytsivGU0sRsfZgbC3I2NXH0=
Date:   Mon, 9 Aug 2021 18:27:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Cc:     "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] pipe: increase minimum default pipe size
 to 2 pages" failed to apply to 4.4-stable tree
Message-ID: <YRFXe06Eih48qlD7@kroah.com>
References: <162850274511123@kroah.com>
 <CAHk-=wg9Ar-XBVQ860-TLA-eo8N=UYO8DQ5Ye0rBBuiwzv_N_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg9Ar-XBVQ860-TLA-eo8N=UYO8DQ5Ye0rBBuiwzv_N_A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 09, 2021 at 09:23:00AM -0700, Linus Torvalds wrote:
> On Mon, Aug 9, 2021 at 2:52 AM <gregkh@linuxfoundation.org> wrote:
> >
> > The patch below does not apply to the 4.4-stable tree.
> 
> It shouldn't.
> 
> The pipe buffer accounting and soft limits that introduced the whole
> "limp along with limited pipe buffers" behavior that this fixes was
> introduced by
> 
> > Fixes: 759c01142a ("pipe: limit the per-user amount of pages allocated in pipes")
> 
> ..which made it into 4.5.
> 
> So 4.4 is unaffected and doesn't want this patch.

But that commit showed up in 4.4.13 as fa6d0ba12a8e ("pipe: limit the
per-user amount of pages allocated in pipes") which is why I asked about
this.  The code didn't look similar at all, so I couldn't easily figure
out the backport myself :(

Willy, any ideas?

thanks,

greg k-h
