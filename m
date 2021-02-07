Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166143125A5
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 16:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhBGP5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 10:57:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:34428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhBGP5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Feb 2021 10:57:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE77E64DE1;
        Sun,  7 Feb 2021 15:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612713384;
        bh=MTBj/Qlp4Ezrf4Drdc17MAiWxSJRVOWeKXWx7yxH2PY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EHA61Z9UkL2C/iVezXww6wBH9fNt12hvPtmLIMSQBMJXITmHkkG1da2C2PeCyh9rp
         S1/n4kQngocl7+t0zErCURcNhbxZt1B5Q8M+Cq3/dgkPVxAXaMCArfVqduNuCr013r
         EgtkYcPw4Uprstd4LiaZxX7ZNveU5amdyQAMuQTqe6k+0266C/hBXVF2SPAY/aFnoj
         YFuhVVqm/hnQGnqoYjCP7QXusjUMDQoeIKrS0EjLaYPkN7rtluMfCAlSnjkmJoi+R+
         wO5YxHNmqyNmzACYONJ4JB/BrXhiSe9UVENwor2zy9DPJ092BRLZuDuzZs074CEb3K
         BQbr/9QtoSYgg==
Received: by pali.im (Postfix)
        id 567294E1; Sun,  7 Feb 2021 16:56:21 +0100 (CET)
Date:   Sun, 7 Feb 2021 16:56:21 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     mathias.nyman@linux.intel.com, stable@vger.kernel.org,
        tmn505@gmail.com, yoshihiro.shimoda.uh@renesas.com
Subject: Re: FAILED: patch "[PATCH] usb: host: xhci: mvebu: make USB 3.0 PHY
 optional for Armada" failed to apply to 5.4-stable tree
Message-ID: <20210207155621.m4or6ktctyqnejhk@pali>
References: <1612711854148237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612711854148237@kroah.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sunday 07 February 2021 16:30:54 gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
...
> Fixes: bd3d25b07342 ("arm64: dts: marvell: armada-37xx: link USB hosts with their PHYs")
> Cc: <stable@vger.kernel.org> # 5.1+: ea17a0f153af: phy: marvell: comphy: Convert internal SMCC firmware return codes to errno
> Cc: <stable@vger.kernel.org> # 5.1+: f768e718911e: usb: host: xhci-plat: add priv quirk for skip PHY initialization

Hello Greg! Seems that you have forgot to apply some dependency patches.
