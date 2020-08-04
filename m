Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA5023B4FE
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 08:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgHDG1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 02:27:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgHDG1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Aug 2020 02:27:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E8E220722;
        Tue,  4 Aug 2020 06:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596522431;
        bh=IvrH29WdGtxMFIn5ySm4LGK30X2HSz7nGv3SvQ/gEKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=einDYKvxcAQMRBAuTmaZ6Yr+SFlu4pSLfWCYvxIjL22q43CWKJFkSq4ju7S5azsoG
         FVErSzwmnMjnA1T22Lrx/Tbelx6jcFAwTihxxzHNheBhkUcLVRRnBXhPW8ZypR3dzw
         /3wTU4o6Uy0GApqnMUH+M9Yriofb/QWXPthFKU38=
Date:   Tue, 4 Aug 2020 08:27:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Nathan Huckleberry <nhuck15@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH 2/4] ARM: backtrace-clang: add fixup for lr dereference
Message-ID: <20200804062707.GB696690@kroah.com>
References: <20200730205112.2099429-3-ndesaulniers@google.com>
 <20200801231815.7817920829@mail.kernel.org>
 <CAKwvOdnNud7L9YUmJYDOb71nq+v1+rjSMMbGwkcMZwt6Qr8OxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdnNud7L9YUmJYDOb71nq+v1+rjSMMbGwkcMZwt6Qr8OxA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 03, 2020 at 11:13:04AM -0700, Nick Desaulniers wrote:
> On Sat, Aug 1, 2020 at 4:18 PM Sasha Levin <sashal@kernel.org> wrote:
> >
> > Hi
> >
> > [This is an automated email]
> >
> > This commit has been processed because it contains a "Fixes:" tag
> > fixing commit: 6dc5fd93b2f1 ("ARM: 8900/1: UNWINDER_FRAME_POINTER implementation for Clang").
> >
> > The bot has tested the following trees: v5.7.11, v5.4.54.
> >
> > v5.7.11: Failed to apply! Possible dependencies:
> >     5489ab50c227 ("arm/asm: add loglvl to c_backtrace()")
> >     99c56f602183 ("ARM: backtrace-clang: check for NULL lr")
> >
> > v5.4.54: Failed to apply! Possible dependencies:
> >     40ff1ddb5570 ("ARM: 8948/1: Prevent OOB access in stacktrace")
> >     5489ab50c227 ("arm/asm: add loglvl to c_backtrace()")
> >     99c56f602183 ("ARM: backtrace-clang: check for NULL lr")
> >
> >
> > NOTE: The patch will not be queued to stable trees until it is upstream.
> >
> > How should we proceed with this patch?
> 
> Ah, ok, I'll provide manual backports then once this hits mainline.
> In that case, should I drop the explicit `Cc: stable...` tag?

No, it's good to have it there as then you get the automatic email
saying it failed to apply :)

thanks,

greg k-h
