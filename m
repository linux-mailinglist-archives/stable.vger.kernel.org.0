Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00937377FC2
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 11:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhEJJrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 05:47:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230093AbhEJJrz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 05:47:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B54960FDA;
        Mon, 10 May 2021 09:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620640010;
        bh=21GdrFSAMQTXMFVqvxpKiSR1Lz6xlfRm4Wzori0Wuyg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=caotaLPrm2BobhTu6NiJSLEk3GWqQuWfa8ZP7fUS671MX7PbGKUGdv7/M4475rDTp
         tRAqHDBN/yQ1rI+qYO75gU7VUYwJj2Kp5d1gey/kBNzt2xgMJzVoxNSTwkPW7N1hep
         xJd3RgAJKFL8qo2E9HocZdWhTrhxYevXfV3LSANM=
Date:   Mon, 10 May 2021 11:46:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@armlinux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>,
        Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Desaulniers <ndesaulniers@gooogle.com>,
        Joe Perches <joe@perches.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH stable 5.10 0/3] ARM FDT relocation backports
Message-ID: <YJkBCMUpKUax0idB@kroah.com>
References: <20210509173029.1653182-1-f.fainelli@gmail.com>
 <CAMj1kXGt1zrRQused3xgXzhQYfDchgH325iRDCZrx+7o1+bUnA@mail.gmail.com>
 <5f8fed97-8c73-73b0-6576-bf3fbcdb1440@gmail.com>
 <YJjkOLg/Ivo2kMOS@kroah.com>
 <CACRpkdb+4OFpsJAPkEjTBBf_+VTUvKkzsDb9xaSOxqhNSWkeeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdb+4OFpsJAPkEjTBBf_+VTUvKkzsDb9xaSOxqhNSWkeeg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 10, 2021 at 11:37:01AM +0200, Linus Walleij wrote:
> On Mon, May 10, 2021 at 9:43 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Sun, May 09, 2021 at 06:22:05PM -0700, Florian Fainelli wrote:
> 
> > > This does not qualify as a regression in that it has never worked for
> > > the specific platform that I have shown above until your 3 commits came
> > > in and fixed that particular FDT placement. To me this qualifies as a
> > > bug fix, and given that the 3 (now 4) commits applied without hunks, it
> > > seems reasonable to me to back port those to stable.
> >
> > As this isn't a regression, why not just use 5.12 on these platforms?
> > Why is 5.4 and 5.10 needed?
> 
> Actually I think it *is* a regression, but not a common one. The bug that
> Ard is fixing can appear when the kernel grows over a certain size.
> 
> If a user compile in a new set of functionality and the kernel size
> reach a tripping point so that the DTB ends up just outside the 1:1
> lowmem map, disaster strikes.
> 
> This has been a long standing mysterious bug for people using
> attached device trees.

Ok, then feel free to ack them when they get resubmitted.

thanks,

greg k-h
