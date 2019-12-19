Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D56BD125CE7
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 09:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfLSIpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 03:45:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:48950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726498AbfLSIpP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 03:45:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA83424650;
        Thu, 19 Dec 2019 08:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576745115;
        bh=ebmEwzDC7ZpLE1nCj3BibTOu5Z0b5CGmQ4BasrHpczc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kRiZ/ka1in/I3VGhK5+b7ZzqS9CfKduRHGFBrC/7eB9UDBe18ZarWdqy9AbmUCEr6
         6qG1NjAgGYGu99tbYV68om7c6LMy0DNI2sxUrT0CIx+PXAdeL/s4Y1KyOtXKyUyb5l
         43RoVtLMq/biHW/o739ObSbEzpufh5/q+gccFTZw=
Date:   Thu, 19 Dec 2019 09:45:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>
Subject: Re: [PATCH 5.4 00/37] 5.4.5-stable review
Message-ID: <20191219084513.GB1027830@kroah.com>
References: <20191217200721.741054904@linuxfoundation.org>
 <CAMuHMdU92QPEi9bYnzG4z_EVimstZ1u_gubuaWxwZVaDca+OGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdU92QPEi9bYnzG4z_EVimstZ1u_gubuaWxwZVaDca+OGg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 18, 2019 at 10:02:53PM +0100, Geert Uytterhoeven wrote:
> Hi Greg,
> 
> On Tue, Dec 17, 2019 at 9:10 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 5.4.5 release.
> > There are 37 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> > Yoshiki Komachi <komachi.yoshiki@gmail.com>
> >     cls_flower: Fix the behavior using port ranges with hw-offload
> 
> Given I bisected a WARNING to this commit, it's probably safer to not
> backport it to stable yet.
> 
> So far no response to my report
> https://lore.kernel.org/lkml/CAMuHMdXKNMgAQHAE4f-0=srAZtDNUPB6Hmdm277XTgukrtiJ4Q@mail.gmail.com/
> 
> Given it's networking, it could be an endian issue, manifesting on big
> endian systems only.

If this gets reverted in Linus's tree, let me know the commit and I'll
do the same in the stable trees.

thanks,

greg k-h
