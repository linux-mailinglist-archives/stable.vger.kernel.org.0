Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288E149E9D3
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245146AbiA0SKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:10:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58992 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbiA0SKB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:10:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D03AB820C9;
        Thu, 27 Jan 2022 18:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87826C340EA;
        Thu, 27 Jan 2022 18:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643306998;
        bh=j9IbMF9BlPJ89kZFxrcZWmprUehq4dbxvd0eCOYC2bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w1AX0jNTac2iypKNWwHjo1OPwwRLO5/OFk2aFEoOEb7KbHIHt1M6uNqNDbGPJOz+R
         hWrDIeVsHMZJjd+Pu9nkzaNJ8zgI4P55IQmQ48Idi2JIqVHyvj4h1hcwTlGgm2GjAn
         Sll7GO7mRLtbgX7JqX1P24SGoRxZvmbtaQzdvLUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 06/11] pinctrl: bcm2835: Match BCM7211 compatible string
Date:   Thu, 27 Jan 2022 19:09:07 +0100
Message-Id: <20220127180258.573583252@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180258.362000607@linuxfoundation.org>
References: <20220127180258.362000607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit 562c856f96d22ef1204b0a314bc52e85617199b4 upstream

The BCM7211 SoC uses the same pinconf_ops as the ones defined for the
BCM2711 SoC, match the compatible string and use the correct set of
options.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20200531001101.24945-4-f.fainelli@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/bcm/pinctrl-bcm2835.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -1134,6 +1134,10 @@ static const struct of_device_id bcm2835
 		.compatible = "brcm,bcm2711-gpio",
 		.data = &bcm2711_plat_data,
 	},
+	{
+		.compatible = "brcm,bcm7211-gpio",
+		.data = &bcm2711_plat_data,
+	},
 	{}
 };
 


