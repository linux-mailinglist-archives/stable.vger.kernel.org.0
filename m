Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F19313063
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 12:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbhBHLNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 06:13:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:54722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233040AbhBHLHz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 06:07:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE48764E27;
        Mon,  8 Feb 2021 11:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612782432;
        bh=iNz25lqTtECkfTzIVjy65dV8mvsnHN1rEtlEFa/LfKQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K/of858JWmtgjPhAxevnKuqQd/eao/90qnYDfFgmD3tQrFlwFgztoGIXQVYiNh5Hd
         lSS4EhrfcAOBsS2DqeLnbFBycXZE25AUtLOyaafR9iXuPcNBecKRfIAL19GssfLUxP
         dJqLL4MzBWU6o+QWM78q5+cfE8dJyDSgwT8mAKG0UKtRfjWBJKDGokNjdZwaqp9v/X
         U1pNHMq0FvpYfTYC57pFgykV0asFxCfxw0JbBvaejaKwqRp99o4bs3vUWD0am2qveZ
         naqkM0+MxgSavZyfJIsFYI+B0hAaLTzzooxW21H/hqOR6FuwloIUKjflT25d/KDax9
         YjsJLKCA90zRw==
Received: by pali.im (Postfix)
        id 73A449E0; Mon,  8 Feb 2021 12:07:09 +0100 (CET)
Date:   Mon, 8 Feb 2021 12:07:09 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     mathias.nyman@linux.intel.com, stable@vger.kernel.org,
        tmn505@gmail.com, yoshihiro.shimoda.uh@renesas.com
Subject: Re: FAILED: patch "[PATCH] usb: host: xhci: mvebu: make USB 3.0 PHY
 optional for Armada" failed to apply to 5.4-stable tree
Message-ID: <20210208110709.2ce5h3fdm3ftipcf@pali>
References: <1612711854148237@kroah.com>
 <20210207155621.m4or6ktctyqnejhk@pali>
 <YCEN8PptcWpl5PvW@kroah.com>
 <YCEPdBfsxpWSdSar@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YCEPdBfsxpWSdSar@kroah.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday 08 February 2021 11:16:20 Greg KH wrote:
> On Mon, Feb 08, 2021 at 11:09:52AM +0100, Greg KH wrote:
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
> Nope, of_phy_put(phy) is not present in 5.4, so it needs a "real"
> backport.
> 
> Can you do that?

Ok, I will look at it.

> thanks,
> 
> greg k-h
> 
