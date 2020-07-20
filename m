Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF3C225628
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 05:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgGTD0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jul 2020 23:26:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbgGTD0m (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Jul 2020 23:26:42 -0400
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7980D20734;
        Mon, 20 Jul 2020 03:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595215601;
        bh=3vn9rZSLTQj5C4sEUB9yrej0wTjYfvGDXM+nwjtSmXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mnUbnuNe9lZEbr3a54uN4kl8oF1XTayMmqC4vBHEZjHyJud1deBdGMcF7P8sKLPo6
         C6pxbT4nsrdZ+vFOnZ9822OgeLwmeiWSR1H3N2ER4f6/zPtPt5hj48it3LpyAFGTsl
         BiMPFtFikv8wWTONPzn5BQwvUHvHteWjgTnzv90w=
Date:   Mon, 20 Jul 2020 11:26:32 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Suniel Mahesh <sunil@amarulasolutions.com>
Cc:     robh+dt@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, gregkh@linuxfoundation.org,
        sashal@kernel.org, jagan@amarulasolutions.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-amarula@amarulasolutions.com,
        Michael Trimarchi <michael@amarulasolutions.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] ARM: dts: imx6qdl-icore: Fix OTG_ID pin and sdcard
 detect
Message-ID: <20200720032632.GM11560@dragon>
References: <20200711135925.GG21277@dragon>
 <1594973032-29671-1-git-send-email-sunil@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594973032-29671-1-git-send-email-sunil@amarulasolutions.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 17, 2020 at 01:33:52PM +0530, Suniel Mahesh wrote:
> From: Michael Trimarchi <michael@amarulasolutions.com>
> 
> The current pin muxing scheme muxes GPIO_1 pad for USB_OTG_ID
> because of which when card is inserted, usb otg is enumerated
> and the card is never detected.
> 
> [   64.492645] cfg80211: failed to load regulatory.db
> [   64.492657] imx-sdma 20ec000.sdma: external firmware not found, using ROM firmware
> [   76.343711] ci_hdrc ci_hdrc.0: EHCI Host Controller
> [   76.349742] ci_hdrc ci_hdrc.0: new USB bus registered, assigned bus number 2
> [   76.388862] ci_hdrc ci_hdrc.0: USB 2.0 started, EHCI 1.00
> [   76.396650] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.08
> [   76.405412] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   76.412763] usb usb2: Product: EHCI Host Controller
> [   76.417666] usb usb2: Manufacturer: Linux 5.8.0-rc1-next-20200618 ehci_hcd
> [   76.424623] usb usb2: SerialNumber: ci_hdrc.0
> [   76.431755] hub 2-0:1.0: USB hub found
> [   76.435862] hub 2-0:1.0: 1 port detected
> 
> The TRM mentions GPIO_1 pad should be muxed/assigned for card detect
> and ENET_RX_ER pad for USB_OTG_ID for proper operation.
> 
> This patch fixes pin muxing as per TRM and is tested on a
> i.Core 1.5 MX6 DL SOM.
> 
> [   22.449165] mmc0: host does not support reading read-only switch, assuming write-enable
> [   22.459992] mmc0: new high speed SDHC card at address 0001
> [   22.469725] mmcblk0: mmc0:0001 EB1QT 29.8 GiB
> [   22.478856]  mmcblk0: p1 p2
> 
> Fixes: 6df11287f7c9 ("ARM: dts: imx6q: Add Engicam i.CoreM6 Quad/Dual initial support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> Signed-off-by: Suniel Mahesh <sunil@amarulasolutions.com>

Applied, thanks.
