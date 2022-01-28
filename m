Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A3549F333
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 06:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237160AbiA1F7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 00:59:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59340 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235697AbiA1F7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 00:59:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A452E61904
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 05:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1F7C340E0;
        Fri, 28 Jan 2022 05:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643349579;
        bh=BMwpxi2Slj2A0pmA1rPpAJbC4z/DUMXWm3wK1KhpVOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AVN2GmXkNSN8HjKpb3Khso2fnbCBqRnCLCzkqNw+eMNf0BBPhz+o7QL6VOTOk5R/T
         /xPcHmpxvhqMWK3xlfvb4YSp3vGqOqSCFQNfem1B/ooBzTqSmyS9MODUqalW045Zu1
         DIUR+y1XQTkRtbGxNLgXLjAPD5IYDEPSAtPU3KnKv7y9CeN2xyh/SvIkBVf48STmPt
         cNGRvggW5hml9JBIB7fkjAz8W0bFWf46hDtnW1q0F+xvEb9Ewcn5T6YiFdfsdD3ivp
         3TYRF1E+27h6cb7nVXDHNv+0XKR/LDbOh6r6Jna2pRBjD2SbRRoUBQulwGnSI/Tt7J
         7kE07oD7DbNCg==
Date:   Fri, 28 Jan 2022 13:59:33 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: imx23-evk: Remove MX23_PAD_SSP1_DETECT from
 hog group
Message-ID: <20220128055933.GC4686@dragon>
References: <20211227161402.2523009-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227161402.2523009-1-festevam@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 27, 2021 at 01:14:02PM -0300, Fabio Estevam wrote:
> Currently, SD card fails to mount due to the following pinctrl error:
> 
> [   11.170000] imx23-pinctrl 80018000.pinctrl: pin SSP1_DETECT already requested by 80018000.pinctrl; cannot claim for 80010000.spi
> [   11.180000] imx23-pinctrl 80018000.pinctrl: pin-65 (80010000.spi) status -22
> [   11.190000] imx23-pinctrl 80018000.pinctrl: could not request pin 65 (SSP1_DETECT) from group mmc0-pins-fixup.0  on device 80018000.pinctrl
> [   11.200000] mxs-mmc 80010000.spi: Error applying setting, reverse things back
> 
> Fix it by removing the MX23_PAD_SSP1_DETECT pin from the hog group as it
> is already been used by the mmc0-pins-fixup pinctrl group.
> 
> With this change the rootfs can be mounted and the imx23-evk board can
> boot successfully.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: bc3875f1a61e ("ARM: dts: mxs: modify mx23/mx28 dts files to use pinctrl headers")
> Signed-off-by: Fabio Estevam <festevam@gmail.com>

Applied, thanks!
