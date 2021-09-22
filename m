Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06E9413FEC
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 05:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhIVDLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 23:11:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230054AbhIVDLm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 23:11:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 338E06115A;
        Wed, 22 Sep 2021 03:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632280213;
        bh=J1psIMGqDoCGY/wA/7a4LXaG/x8eaRWB1lWYLAav++I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a+UMh2xk81CUjeCVM+L3g/s11gHMu6F9WSOyAAJ0BM29EdMUmsbCLaG/aCAMO+KLv
         Hi7bmdA/s2YMay0sOGwLjzYEeQWZv1YdeRb+2izwJ2a04r8W5qb4VFq6kilNeJpYBy
         3/oBF1HtlwQZ2zZ94+CGHWInxdvJwGKDhXJEYx0XmHKiYLWKao96RHqL+d4fWWkiz1
         +lrOqAavkH9xeDbMIOuYEH32G1POzpmaWoUHCW7Cp7FEWSDnDALz+CslEHgtg4wkT5
         X62IL+BzxPZQ+nJfAuTX+NlRdGwHlFlxfXB/mO+pupMEy7qhi2HNnEBmjhiyFpcKtz
         uyp2dd44VnmTA==
Date:   Wed, 22 Sep 2021 11:10:07 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Michal =?utf-8?B?Vm9rw6HEjQ==?= <michal.vokac@ysoft.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pavel Machek <pavel@ucw.cz>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: dts: imx6dl-yapp4: Fix lp5562 LED driver probe
Message-ID: <20210922031006.GH10217@dragon>
References: <20210818070209.1540451-1-michal.vokac@ysoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210818070209.1540451-1-michal.vokac@ysoft.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 18, 2021 at 09:02:08AM +0200, Michal Vokáč wrote:
> Since the LED multicolor framework support was added in commit
> 92a81562e695 ("leds: lp55xx: Add multicolor framework support to lp55xx")
> LEDs on this platform stopped working.
> 
> Author of the framework attempted to accommodate this DT to the
> framework in commit b86d3d21cd4c ("ARM: dts: imx6dl-yapp4: Add reg property
> to the lp5562 channel node") but that is not sufficient. A color property
> is now required even if the multicolor framework is not used, otherwise
> the driver probe fails:
> 
>   lp5562: probe of 1-0030 failed with error -22
> 
> Add the color property to fix this.
> 
> Fixes: 92a81562e695 ("leds: lp55xx: Add multicolor framework support to lp55xx")
> Cc: <stable@vger.kernel.org>
> Cc: linux-leds@vger.kernel.org
> Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>

Applied both, thanks!
