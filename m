Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF502C0AEA
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731005AbgKWMcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:32:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:43168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730996AbgKWMcB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:32:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E107F20781;
        Mon, 23 Nov 2020 12:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134721;
        bh=5WeBFUD6vwEUlct8jF4tp60WXcAHD+mGFWdMxYEeyoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aj3XhssmbqQvq6/ZpOVnYbonp+CaoURGOfr3l0sxtVws1LaKjagkjUmurCvtZWDZI
         79lmjuvta/aLfoas8k6AmdQOBaPP83gRj6AxM7llUh2n0F8q3rIBVbWq5/KuftAGud
         JSh/3Cky5D81MtFSk8WQhTSGV3YnmjAyTtRN7KWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 58/91] can: kvaser_usb: kvaser_usb_hydra: Fix KCAN bittiming limits
Date:   Mon, 23 Nov 2020 13:22:18 +0100
Message-Id: <20201123121812.142363194@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jimmy Assarsson <extja@kvaser.com>

[ Upstream commit d003868d7f8579838ed58b6429af91844039b6f8 ]

Use correct bittiming limits for the KCAN CAN controller.

Fixes: aec5fb2268b7 ("can: kvaser_usb: Add support for Kvaser USB hydra family")
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/r/20201115163027.16851-2-jimmyassarsson@gmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 7ab87a7587545..218fadc911558 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -367,7 +367,7 @@ static const struct can_bittiming_const kvaser_usb_hydra_kcan_bittiming_c = {
 	.tseg2_max = 32,
 	.sjw_max = 16,
 	.brp_min = 1,
-	.brp_max = 4096,
+	.brp_max = 8192,
 	.brp_inc = 1,
 };
 
-- 
2.27.0



