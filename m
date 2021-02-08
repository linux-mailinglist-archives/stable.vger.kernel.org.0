Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8F531397D
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 17:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhBHQcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 11:32:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234337AbhBHQcP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 11:32:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E361664D87;
        Mon,  8 Feb 2021 16:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612801894;
        bh=yyHs6znB+J1IBzI0jOI4gTfS/Sj+kD6jdg5kWz3NQ0w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2czwAuFn1pMV31PAfzqgf9LMnbVTGmeE2Vhgbc+mxCOifcTchsCudIzOaxzRWLThd
         oIDM7T0gH6RWgp2kL8o/MJG4hhjpMMLHOA8CEgY+EteRnvXVtX1nxLlt4Dz4EScaCM
         efHVRZU+drHyqUlxnxlKC6mDG8JS2B5FYV8Sy6GE=
Date:   Mon, 8 Feb 2021 17:31:31 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Avi Kivity <avi@scylladb.com>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz
Subject: Re: Linux 4.9.256
Message-ID: <YCFnY/OAW4E/wUoh@kroah.com>
References: <1612535085125226@kroah.com>
 <23a28990-c465-f813-52a4-f7f3db007f9d@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23a28990-c465-f813-52a4-f7f3db007f9d@scylladb.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 05:50:21PM +0200, Avi Kivity wrote:
> On 05/02/2021 16.26, Greg Kroah-Hartman wrote:
> > I'm announcing the release of the 4.9.256 kernel.
> > 
> > This, and the 4.4.256 release are a little bit "different" than normal.
> > 
> > This contains only 1 patch, just the version bump from .255 to .256 which ends
> > up causing the userspace-visable LINUX_VERSION_CODE to behave a bit differently
> > than normal due to the "overflow".
> > 
> > With this release, KERNEL_VERSION(4, 9, 256) is the same as KERNEL_VERSION(4, 10, 0).
> 
> 
> I think this is a bad idea. Many kernel features can only be discovered by
> checking the kernel version. If a feature was introduced in 4.10, then an
> application can be tricked into thinking a 4.9 kernel has it.
> 
> 
> IMO, better to stop LINUX_VERSION_CODE at 255 and introduce a
> LINUX_VERSION_CODE_IMPROVED that has more bits for patchlevel.

We are going to stop LINUX_VERSION_CODE at 255 now, see the posted
patches from Sasha, I think we are now ok.

thanks,

greg k-h
