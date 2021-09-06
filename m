Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C184015DA
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 06:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbhIFFAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 01:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbhIFFAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 01:00:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2181D60EC0;
        Mon,  6 Sep 2021 04:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630904372;
        bh=nB9iGvGFSpf7zMHpIKvQPMA38krX00c3u1nNi0FvqWE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kZYL5I/DwYJqfcNs83QIKtuirXxDy6JYU0hERQy2EjsFWUogJ9RQtn6z1eXz5874U
         vkqbiCs8kjQAZP/Lyn8AEcDjsSlEPoE4pXsoF+s81+S4KVn2MCSUYp7nbRicrwv+WY
         x1Gt+N6oAgse7YbpkJIC4QyoTVnd9q4eA8ix3CyM=
Date:   Mon, 6 Sep 2021 06:59:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     wim <wim@djo.tudelft.nl>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kernel-4.9.270 crash
Message-ID: <YTWgKo4idyocDuCD@kroah.com>
References: <20210904235231.GA31607@djo.tudelft.nl>
 <20210905190045.GA10991@djo.tudelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210905190045.GA10991@djo.tudelft.nl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 05, 2021 at 09:00:45PM +0200, wim wrote:
> On Sun, Sep 05, 2021 at 01:52:31AM +0200, wim wrote:
> > 
> > Hello Greg,
> > 
> > from kernel-4.9.270 up until now (4.9.282) I experience kernel crashes upon
> > loading a GPU module.
> > It happens on two out of at least six different machines.
> > I can't believe that I'm the only one where that happens, but since the bug
> > is still there twelve versions later, I need to report this.
> > 
> > I run Gentoo with vanilla kernels.
> > Upon loading i915.ko (automatically or manually) my laptop freezes until
> > power-down. (Note that other machines using i915.ko have no problems here.)
> > It's an Asus laptop with Intel chipset with a peculiarity:
> > 
> >  00:02.0 VGA compatible controller: Intel Corporation HD Graphics 620 (rev 02)
> >  01:00.0 3D controller: NVIDIA Corporation GM108M [GeForce 940MX] (rev a2)
> > 
> > (It uses Intel natively and nobody knows how to make use of that Nvidia chip)
> > 
> > 
> > On an AMD desktop I get the same crash upon loading of nouveau.ko .
> > 
> > Something ugly must have been introduced in kernel-4.9.270 .
> > Strace modprobe .. only prints two lines on the screen.
> > Strace modprobe .. 2>&1 > file produces only an empty file.
> > 
> > Any ideas?

Do you have any kernel log messages when these crashes happen?

Can you use 'git bisect' to track down the offending commit?

And why are you stuck on 4.9.y for these machines?  Why not use 5.10 or
newer?

thanks,

greg k-h
