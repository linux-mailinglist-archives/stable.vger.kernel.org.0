Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3D6447362
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 15:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhKGPBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Nov 2021 10:01:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhKGPBu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Nov 2021 10:01:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0364B61359;
        Sun,  7 Nov 2021 14:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636297147;
        bh=L5crLXK0tzyf9RlK+s3mlhA1kG1qkfnPo/+AMVibCA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eZaOlte5zJhowS1k5o6q61BixB61/HB34vHqeCejospviOJVPh0XosTrJSbtcDdA6
         6bF+z+wE24kCU4k7M7w+Oe+QHb25Cr6mc1CS6ovmhRAraasdinpPKCSV7sWr3/CXJ/
         HEU108aO7pASMhX8xxfcLALmce5PO9qwopPQgSNk=
Date:   Sun, 7 Nov 2021 15:59:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 5.14.y-stable: Missing sound fixes from 5.15
Message-ID: <YYfpuF8Q9cDA3Wap@kroah.com>
References: <s5hfssbgfa1.wl-tiwai@suse.de>
 <YYfnd9YojggYJTUf@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYfnd9YojggYJTUf@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 07, 2021 at 03:49:27PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Nov 05, 2021 at 09:47:34AM +0100, Takashi Iwai wrote:
> > Hi Greg,
> > 
> > could you cherry-pick the following three commits to 5.14.y tree?
> > The Cc-to-stable was missing on those, although they should have been
> > picked up.
> > 
> > cbea6e5a7772b7a5b80baa8f98fd77853487fd2a
> >     ALSA: pcm: Check mmap capability of runtime dma buffer at first
> > 0899a7a23047f106c06888769d6cd6ff43d7395f
> >     ALSA: pci: rme: Set up buffer type properly
> > 4d9e9153f1c64d91a125c6967bc0bfb0bb653ea0
> >     ALSA: pci: cs46xx: Fix set up buffer type properly
> > 
> > They are needed only for 5.14.y, not for older versions.
> > 
> > The relevant bug report is found at:
> >   https://bugzilla.kernel.org/show_bug.cgi?id=214947
> 
> All now queued up, thanks.

Oops, nope, one of these broke the build.  I'll respond to the broken
patch.

thanks,

greg k-h
