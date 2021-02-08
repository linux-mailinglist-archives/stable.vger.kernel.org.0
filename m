Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63AF5313129
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 12:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhBHLnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 06:43:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:36714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232573AbhBHLjs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 06:39:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2E4D64E40;
        Mon,  8 Feb 2021 11:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612784347;
        bh=a4r5uzhe+W40QfBxBdHzqmTIeXrjs4qDjNpia/+gJag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JmuqOjOO0I8hX3UWaH0d9y4GIZ/M3thZByYEVae7U5N9kI+GoNJRGdwfMxEwC7ERs
         TYOfmiafy1MH8xR07/0t4twEFP4g4pQMRkSGA0ROG/QPW+2PlSq8Xt2banOr8lzExv
         HqPeADXGJOgg+TLiPEJ9fktP/qb4z+IfpMDi3XPg=
Date:   Mon, 8 Feb 2021 12:39:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     mathias.nyman@linux.intel.com, stable@vger.kernel.org,
        tmn505@gmail.com, yoshihiro.shimoda.uh@renesas.com
Subject: Re: FAILED: patch "[PATCH] usb: host: xhci: mvebu: make USB 3.0 PHY
 optional for Armada" failed to apply to 5.4-stable tree
Message-ID: <YCEi2IdUuDio03U4@kroah.com>
References: <1612711854148237@kroah.com>
 <20210207155621.m4or6ktctyqnejhk@pali>
 <YCEN8PptcWpl5PvW@kroah.com>
 <20210208110623.3i3vfrc3l7wd5iqx@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210208110623.3i3vfrc3l7wd5iqx@pali>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 12:06:23PM +0100, Pali Rohár wrote:
> On Monday 08 February 2021 11:09:52 Greg KH wrote:
> > On Sun, Feb 07, 2021 at 04:56:21PM +0100, Pali Rohár wrote:
> > > On Sunday 07 February 2021 16:30:54 gregkh@linuxfoundation.org wrote:
> > > > The patch below does not apply to the 5.4-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > ...
> > > > Fixes: bd3d25b07342 ("arm64: dts: marvell: armada-37xx: link USB hosts with their PHYs")
> > > > Cc: <stable@vger.kernel.org> # 5.1+: ea17a0f153af: phy: marvell: comphy: Convert internal SMCC firmware return codes to errno
> > > > Cc: <stable@vger.kernel.org> # 5.1+: f768e718911e: usb: host: xhci-plat: add priv quirk for skip PHY initialization
> > > 
> > > Hello Greg! Seems that you have forgot to apply some dependency patches.
> > 
> > You are right, I had one, not the other, now fixed up...
> 
> Ok, great!
> 
> Btw, I have just one question: Is there some bot / machine which parses
> these Fixes and Cc lines where are written required patch dependences?
> Or such patch with dependences needs to be handled manually?

I do it manually.  But it's pretty easy, normally I notice this, but for
the USB patches I just blew through them as I "thought" I knew better :)
