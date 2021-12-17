Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D662A478C8D
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 14:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbhLQNmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 08:42:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44274 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234081AbhLQNmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 08:42:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19D9B6220F
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 13:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED098C36AE7;
        Fri, 17 Dec 2021 13:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639748571;
        bh=vpfTqs8ckBiecwCe6dQKfCOdc50Ja59HX6U/++U5DPw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aoTcCChwkasGgbdyWJszDxzCbXy+7KBLV1pd0XaOZifJn7JCk1LPtBrbfMN+0ZxP2
         uEIFUQsrLbWME7UgNXzco3ptvmHDtij5iDx8ZovXLwCZEhanyJgQUxbJL16Dxo0lMG
         sJ3SKJmQ1234LghbynutFm/IQsNN26nMu4Biuulk=
Date:   Fri, 17 Dec 2021 14:42:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: Re: two imx8m patches for 5.10.y
Message-ID: <YbyT2H+dAz06CUut@kroah.com>
References: <40c1f4ec-833f-fd3f-8a16-95d10f4a261d@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40c1f4ec-833f-fd3f-8a16-95d10f4a261d@prevas.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 16, 2021 at 02:11:36PM +0100, Rasmus Villemoes wrote:
> Hi Greg
> 
> Please include commits
> 
> 70eacf42a93a - arm64: dts: imx8m: correct assigned clocks for FEC
> 798a1807ab13 - arm64: dts: imx8mp-evk: Improve the Ethernet PHY description
> 
> in the 5.10.y -stable branch. They fix ethernet on the imx8mp-evk board
> (the first is relevant for all imx8m boards, but I've only tested on
> imx8mp-evk).

I'll take these now.

> One also needs to have the realtek_phy driver available during early
> boot (so either built in or as module in initramfs). Upstream has
> 
> 6937d8c71f69 - arm64: configs: Select REALTEK_PHY as built-in
> 
> but I'm not sure if such a defconfig change (which affects every arm64
> board, as opposed to the much more localized .dts changes) is applicable
> in -stable. We maintain our own .config anyway, so I don't need
> 6937d8c71f69 in 5.10-stable.

The defconfig change I'll leave alone.

thanks,

greg k-h
