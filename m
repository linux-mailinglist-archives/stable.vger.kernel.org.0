Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1590E2F0B89
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 04:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbhAKDme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 22:42:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:59806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbhAKDmd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Jan 2021 22:42:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95A3021973;
        Mon, 11 Jan 2021 03:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610336513;
        bh=JEC0JJK9kzFgywbhRhmF7OgYYFTKs87qJ6fj7W7/NSo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YbwkMegFAJhMsW9SVNY/Ivq3sbLr+jFJcNBZYETKNUpMwsuJcpPLwKpgpBasKeywq
         V29VlxDk9RYe5Juc+wSGm8wiiTiVURX6kNpqiyboVkPQxdGPg/aV0veqtD+azHhqnW
         neAOc/sPnErhMewJB8aF0GroSkkCIZwybrk5CHXGb52tNrUGrSWcnuFMjPXMw/oDIr
         xiiNCI15wHpOvtXjLzX0iXVey1Yb4GSXqR1P/SrYiw49RcEjmcU8ClgfyFmjPLRnHs
         JEzSum8mMVtOkalr/R7EYyDcRYOhDG+WmA4tgXtzLHFF0twq2v4jm+Uj5jlIsVqeQz
         YqxPoi966lmWg==
Date:   Mon, 11 Jan 2021 11:41:48 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Koen Vandeputte <koen.vandeputte@citymesh.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Koen Vandeputte <koen.vandeputte@ncentric.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Fabio Estevam <festevam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: imx6qdl-gw52xx: fix duplicate regulator naming
Message-ID: <20210111034147.GE28365@dragon>
References: <20210107091906.7843-1-koen.vandeputte@ncentric.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107091906.7843-1-koen.vandeputte@ncentric.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 10:19:06AM +0100, Koen Vandeputte wrote:
> 2 regulator descriptions carry identical naming.
> 
> This leads to following boot warning:
> [    0.173138] debugfs: Directory 'vdd1p8' with parent 'regulator' already present!
> 
> Fix this by renaming the one used for audio.
> 
> Fixes: 5051bff33102 ("ARM: dts: imx: ventana: add LTC3676 PMIC support")
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> Signed-off-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
> Cc: Fabio Estevam <festevam@gmail.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Shawn Guo <shawnguo@kernel.org>
> Cc: NXP Linux Team <linux-imx@nxp.com>
> Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
> Cc: stable@vger.kernel.org # v4.11

Applied, thanks.
