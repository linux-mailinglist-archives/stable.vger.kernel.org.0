Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936A53ED09C
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 10:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbhHPIwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 04:52:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235163AbhHPIwv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 04:52:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34E4261B2F;
        Mon, 16 Aug 2021 08:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629103939;
        bh=z3BRIOSt6pK3YKZwv1BQzM+dzo+AS1wIEgqgh9ZMz/w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M0APRPngBR4gUT6eyfhN4+TfW0WwXwmmWgLbLscbtihW6DchE+pIRhIlkGIQpIrZ4
         V4+MddNOF17nrSMT8IfvB9G7A74VPafqfKSWClEv5uJdI9CelFSC/FNnarxlXRnRwM
         uzzx4UL0niV29va91b2t9jXHbotwpVsypa9y6WJk=
Date:   Mon, 16 Aug 2021 10:52:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     elver@google.com, keescook@chromium.org, maskray@google.com,
        ndesaulniers@google.com, stable-commits@vger.kernel.org,
        stable@vger.kernel.org, sashal@kernel.org
Subject: Re: Patch "vmlinux.lds.h: Handle clang's module.{c,d}tor sections"
 has been added to the 5.13-stable tree
Message-ID: <YRonQXMxJWfuFXVZ@kroah.com>
References: <16290320662366@kroah.com>
 <YRmbLz1ZivIMKgc5@archlinux-ax161>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRmbLz1ZivIMKgc5@archlinux-ax161>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 15, 2021 at 03:54:39PM -0700, Nathan Chancellor wrote:
> Hi Greg,
> 
> On Sun, Aug 15, 2021 at 02:54:26PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     vmlinux.lds.h: Handle clang's module.{c,d}tor sections
> > 
> > to the 5.13-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      vmlinux.lds.h-handle-clang-s-module.-c-d-tor-sections.patch
> > and it can be found in the queue-5.13 subdirectory.
> 
> Attached are backports for 4.4 to 5.10. I am not sure if anyone is
> actually using KASAN with clang on 4.4 (ChromeOS maybe?) but it does not
> hurt to have it just in case.
> 
> I did not get any emails that the patch failed to apply on the older
> versions, I assume this is because I did just a "Cc: stable@vger.kernel.org"
> without any version or fixes tag. Is there any "official" way to notate
> that I want a particular patch applied to all supported kernel versions
> aside from adding "# v4.4+" to the Cc tag so that I can provide manual
> backports for those versions?

That comment is exactly how you should ask for that, otherwise I do a
"best effort" type of backport and just stop when it does not apply.

Or you can provide a "Fixes:" tag, which will show me exactly how far
back to apply patches, and that usually works better as it will catch
commits that get backported to older kernels.

thanks,

greg k-h
