Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6B5313051
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 12:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbhBHLLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 06:11:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232912AbhBHLHU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 06:07:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DDB064E0B;
        Mon,  8 Feb 2021 11:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612782386;
        bh=qULhyR23NuUwsbxUnIDGWiuXaWGwGXu2ir/YDI4XlrA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dEISuzt/+xN3tIvBbZU6mBOPVoKxGa6jT6g9W3GBza1IZB09yWBOgzW9b2g0RA0v0
         cIa3veI+P5Cbi2AQB9cQAxd5VVmeO1PkYuIPPKj/Js2D7CSLMNDIseQQG1Rs2aKrga
         mUsudusQ2K7+ZesexRZ+qRBL92oeqrpSaq+RyFsvCBS5179dzDUOlY1Y7q7mlzfmrc
         r52pMBeiOotRAzM16P3aQipWWf+hjY37Sl/BwV0VT+5cJYLa5V/VGY8+joW9L3x1NW
         1fpeGPrLuIM6bQAP2w2tgCzsWL8KovGv2EtA5EnCmVkZuMT4lyTCVsfvc/hfnGN5JF
         yrcCUV6CZyY5g==
Received: by pali.im (Postfix)
        id 902C49E0; Mon,  8 Feb 2021 12:06:23 +0100 (CET)
Date:   Mon, 8 Feb 2021 12:06:23 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     mathias.nyman@linux.intel.com, stable@vger.kernel.org,
        tmn505@gmail.com, yoshihiro.shimoda.uh@renesas.com
Subject: Re: FAILED: patch "[PATCH] usb: host: xhci: mvebu: make USB 3.0 PHY
 optional for Armada" failed to apply to 5.4-stable tree
Message-ID: <20210208110623.3i3vfrc3l7wd5iqx@pali>
References: <1612711854148237@kroah.com>
 <20210207155621.m4or6ktctyqnejhk@pali>
 <YCEN8PptcWpl5PvW@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YCEN8PptcWpl5PvW@kroah.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday 08 February 2021 11:09:52 Greg KH wrote:
> On Sun, Feb 07, 2021 at 04:56:21PM +0100, Pali Rohár wrote:
> > On Sunday 07 February 2021 16:30:54 gregkh@linuxfoundation.org wrote:
> > > The patch below does not apply to the 5.4-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > ...
> > > Fixes: bd3d25b07342 ("arm64: dts: marvell: armada-37xx: link USB hosts with their PHYs")
> > > Cc: <stable@vger.kernel.org> # 5.1+: ea17a0f153af: phy: marvell: comphy: Convert internal SMCC firmware return codes to errno
> > > Cc: <stable@vger.kernel.org> # 5.1+: f768e718911e: usb: host: xhci-plat: add priv quirk for skip PHY initialization
> > 
> > Hello Greg! Seems that you have forgot to apply some dependency patches.
> 
> You are right, I had one, not the other, now fixed up...

Ok, great!

Btw, I have just one question: Is there some bot / machine which parses
these Fixes and Cc lines where are written required patch dependences?
Or such patch with dependences needs to be handled manually?
