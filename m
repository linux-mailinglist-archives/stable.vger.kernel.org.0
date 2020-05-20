Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E6F1DA835
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 04:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgETCsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 22:48:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbgETCsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 22:48:42 -0400
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33FCB20578;
        Wed, 20 May 2020 02:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589942922;
        bh=PgpVdWU0GNMRchnHmpGiYCiQjyaUTn2pzx382J/j+gY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hpq85SNwch7/Gzo34hPTmn+TNxynle/kDED3bfOky0+zVRpNN5axZE8mKSgu4km1L
         YGikQ61RMufrW4q7leUjfYIPbml+U8wytN/7hgMzhiI238MeSaH/jRwo/bqRzKpu58
         uoXS+UjeoOFg119Od8jXwLW6h5J2UPHykMWuWAlI=
Date:   Wed, 20 May 2020 10:48:36 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Sebastian Reichel <sebastian.reichel@collabora.com>
Cc:     Sebastian Reichel <sre@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@collabora.com,
        Robert Beckett <bob.beckett@collabora.com>,
        stable@vger.kernel.org, Ian Ray <ian.ray@ge.com>
Subject: Re: [PATCHv1] ARM: dts/imx6q-bx50v3: Set display interface clock
 parents
Message-ID: <20200520024835.GS11739@dragon>
References: <20200514170236.24814-1-sebastian.reichel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514170236.24814-1-sebastian.reichel@collabora.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 14, 2020 at 07:02:37PM +0200, Sebastian Reichel wrote:
> From: Robert Beckett <bob.beckett@collabora.com>
> 
> Avoid LDB and IPU DI clocks both using the same parent. LDB requires
> pasthrough clock to avoid breaking timing while IPU DI does not.
> 
> Force IPU DI clocks to use IMX6QDL_CLK_PLL2_PFD0_352M as parent
> and LDB to use IMX6QDL_CLK_PLL5_VIDEO_DIV.
> 
> This fixes an issue where attempting atomic modeset while using
> HDMI and display port at the same time causes LDB clock programming
> to destroy the programming of HDMI that was done during the same
> modeset.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
> [Use IMX6QDL_CLK_PLL2_PFD0_352M instead of IMX6QDL_CLK_PLL2_PFD2_396M
>  originally chosen by Robert Beckett to avoid affecting eMMC clock
>  by DRM atomic updates]
> Signed-off-by: Ian Ray <ian.ray@ge.com>
> [Squash Robert's and Ian's commits for bisectability, update patch
>  description and add stable tag]
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>

Applied, thanks.
