Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB334544399
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 08:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiFIGML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 02:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiFIGMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 02:12:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7E8311;
        Wed,  8 Jun 2022 23:12:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48E5CB82B7D;
        Thu,  9 Jun 2022 06:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A051C34115;
        Thu,  9 Jun 2022 06:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654755127;
        bh=yrf+XMowdN86hTFMul+QRd9Y7ZdOwxfAcXmRBAGod9s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NlnWs42vfbZqU5peAH8ah/RPgZr+erlgSvcjAr0TvgpKnUT6YRnIgdZdnIyGWJaUL
         2LfByU9Befcc5ABFz5ee6W6VtrXoWgl3I2NvKWXxDBSsa6CQmJ6UV75XDPabW4QQd1
         pRRCNjlZFaFWh+KV3oAMu0MIS+M50sZ9jr4qaI3B7j/NVR0p+3qXEGM9VLtkSjURnG
         SpNWHwaib72mXm4UuGRUV4o7JPPjtwtRzGA4l5l1vbi7T+ECkdtkndYSYm8RPY9O4p
         JRhod6SMUoPCdDqnLYoCRyOkpw4iHv2VRawGhiV6qjGlN0qDHE1N7Vt85Af5d4ccft
         olq4NKg+00VsQ==
Date:   Thu, 9 Jun 2022 11:42:02 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Peter Robinson <pbrobinson@gmail.com>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Anson Huang <Anson.Huang@nxp.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Robin Gong <yibin.gong@nxp.com>,
        "Angus Ainslie (Purism)" <angus@akkea.ca>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] dmaengine: imx-sdma: Allow imx8m for imx7 FW revs
Message-ID: <YqGPMqRGa58lkRNT@matsya>
References: <20220606161034.3544803-1-pbrobinson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606161034.3544803-1-pbrobinson@gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06-06-22, 17:10, Peter Robinson wrote:
> The revision of the imx-sdma IP that is in the i.MX8M series is the
> same is that as that in the i.MX7 series but the imx7d MODULE_FIRMWARE
> directive is wrapped in a condiditional which means it's not defined
> when built for aarch64 SOC_IMX8M platforms and hence you get the
> following errors when the driver loads on imx8m devices:
> 
> imx-sdma 302c0000.dma-controller: Direct firmware load for imx/sdma/sdma-imx7d.bin failed with error -2
> imx-sdma 302c0000.dma-controller: external firmware not found, using ROM firmware
> 
> Add the SOC_IMX8M into the check so the firmware can load on i.MX8.

Applied, thanks

-- 
~Vinod
