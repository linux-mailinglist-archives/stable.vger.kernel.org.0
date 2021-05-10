Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E08377D5C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 09:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhEJHpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 03:45:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhEJHpA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 03:45:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72FEB61432;
        Mon, 10 May 2021 07:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620632635;
        bh=YceyRvX1NNA1NSeo7fUGpx6VBE/Ls+2Bt+2HbYnKf20=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bJFIaEz1MiWXCTWqZGUuZSncMfFFxSU926DEulZPSQyuS5RikCVA84oqlr3i4/9F8
         ohv6r3+xWA6kEHswpHwzN04Nv0hMsq7DK8Iy95nwtqJgE2nQQZ6PsDthEqoKXoHo0T
         ZPJH2pA4NF/V/JQSd9kRIi5RgTrGjmR04QCssQh0=
Date:   Mon, 10 May 2021 09:43:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@armlinux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>,
        Linus Walleij <linus.walleij@linaro.org>,
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
Message-ID: <YJjkOLg/Ivo2kMOS@kroah.com>
References: <20210509173029.1653182-1-f.fainelli@gmail.com>
 <CAMj1kXGt1zrRQused3xgXzhQYfDchgH325iRDCZrx+7o1+bUnA@mail.gmail.com>
 <5f8fed97-8c73-73b0-6576-bf3fbcdb1440@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f8fed97-8c73-73b0-6576-bf3fbcdb1440@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 09, 2021 at 06:22:05PM -0700, Florian Fainelli wrote:
> 
> 
> On 5/9/2021 12:17 PM, Ard Biesheuvel wrote:
> > On Sun, 9 May 2021 at 19:30, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >>
> >> Hi Greg, Sasha,
> >>
> >> These patches were not marked with a Fixes: tag but they do fix booting
> >> ARM 32-bit platforms that have specific FDT placement and would cause
> >> boot failures like these:
> >>
> > 
> > I don't have any objections to backporting these changes, but it would
> > be helpful if you could explain why this is a regression. Also, you'll
> > need to pull in the following patch as well
> 
> This does not qualify as a regression in that it has never worked for
> the specific platform that I have shown above until your 3 commits came
> in and fixed that particular FDT placement. To me this qualifies as a
> bug fix, and given that the 3 (now 4) commits applied without hunks, it
> seems reasonable to me to back port those to stable.

As this isn't a regression, why not just use 5.12 on these platforms?
Why is 5.4 and 5.10 needed?

thanks,

greg k-h
