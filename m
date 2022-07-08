Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF54D56C41C
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 01:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239647AbiGHSqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 14:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239664AbiGHSqe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 14:46:34 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A074564DB
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 11:46:33 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id u14so26938239ljh.2
        for <stable@vger.kernel.org>; Fri, 08 Jul 2022 11:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AywsF34aW6peeQqt+AuRdJSzR1Z6sROzmk7TMOMZ7HU=;
        b=KxrVRVXLA97NYrR809AmAMspBGaxgBwAJ85wWRTOJAHOjmQupiMq4EsgaIpO2RJnSP
         xNLkIdAS3QI26cREqidNpNafvSxnRh7WyvnteufAR6aJy+SojQ374WLht1Yu3ztDvCZX
         772Y9Vq5+0h2FPivyfFVJ6BdwJKkd9KicIN18X7h47qlq6R/A/WnzfkzjCdnxhF5n209
         +QnpLiT+lBouUkFxT5byZ5zRoEtacHSa6kO/YrrpzwSMqPxO9D4vWbXHKc9cxWzvLJq+
         m6IBwDVtMOZerg89Hkrqy1fBHOZNgYlIZsuzwA3cscUXWesM7l5WQ68fznonB4beDbOB
         6/Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AywsF34aW6peeQqt+AuRdJSzR1Z6sROzmk7TMOMZ7HU=;
        b=6ToJXCE4QxXag0DBNQHr+WIhhVb/MDqdZBHwPLyjkZX5ZMXq+ethDI25ZNeoDWu686
         NuAXyCw4oi33lqphELYuMi29lKDfjhRnh7+am7b6HyrYujQjGUsiNKXU+ID6WtHrKjkh
         ino14P/jpDf4KKHUjjW/KSpKoVAJDsNdJ/iegkDDcHxeps1IIgvgJg7gm+2q33a4Qekk
         0WAfwP0LNpuv5ab6QbC2Su9vMfJKslXzpThoycUmzKl43fdJdlSwjtTI7xTf0v7J3UBP
         G0HDbqmDsBH5DeC/u1ZFPBzdZon2/dBU/2xaQMXWyakKQSza5IM+2ydk3py/tcsskHys
         qLdw==
X-Gm-Message-State: AJIora/02XAKkVW0r7+V3BDOvuivcB4rUGRSzSAa5t6t4+JONoGbeEVA
        tyG9CScKvmkMn4X0yr+r5gAHXYkuVAootg==
X-Google-Smtp-Source: AGRyM1vMg0DBdPOh5522Q8ylhdpi+rBW3+tKAeGZXxAiBYyayxzVRNep/NrQKjwePbhpmKFw9lTf5A==
X-Received: by 2002:a05:651c:244:b0:255:32c8:dd42 with SMTP id x4-20020a05651c024400b0025532c8dd42mr2545648ljn.101.1657305991551;
        Fri, 08 Jul 2022 11:46:31 -0700 (PDT)
Received: from freke.kvaser.se (rota.kvaser.com. [195.22.86.90])
        by smtp.gmail.com with ESMTPSA id 23-20020a2e1557000000b0025d4d4b4edbsm1159917ljv.34.2022.07.08.11.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 11:46:31 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     stable@vger.kernel.org, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH 4.9 1/4] can: kvaser_usb: Add struct kvaser_usb_dev_cfg
Date:   Fri,  8 Jul 2022 20:45:53 +0200
Message-Id: <20220708184556.280751-2-extja@kvaser.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708184556.280751-1-extja@kvaser.com>
References: <20220708184556.280751-1-extja@kvaser.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add struct kvaser_usb_dev_cfg to ease backporting of upstream commits:
49f274c72357 (can: kvaser_usb: replace run-time checks with struct kvaser_usb_driver_info)
e6c80e601053 (can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression)
b3b6df2c56d8 (can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits)

Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
---
 drivers/net/can/usb/kvaser_usb.c | 76 ++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 24 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
index 5ab088d02fba..103601395e07 100644
--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -31,10 +31,6 @@
 #define USB_SEND_TIMEOUT		1000 /* msecs */
 #define USB_RECV_TIMEOUT		1000 /* msecs */
 #define RX_BUFFER_SIZE			3072
-#define KVASER_USB_CAN_CLOCK_8MHZ	8000000
-#define KVASER_USB_CAN_CLOCK_16MHZ	16000000
-#define KVASER_USB_CAN_CLOCK_24MHZ	24000000
-#define KVASER_USB_CAN_CLOCK_32MHZ	32000000
 #define MAX_NET_DEVICES			3
 #define MAX_USBCAN_NET_DEVICES		2
 
@@ -465,6 +461,7 @@ struct kvaser_usb_tx_urb_context {
 struct kvaser_usb {
 	struct usb_device *udev;
 	struct kvaser_usb_net_priv *nets[MAX_NET_DEVICES];
+	const struct kvaser_usb_dev_cfg *cfg;
 
 	struct usb_endpoint_descriptor *bulk_in, *bulk_out;
 	struct usb_anchor rx_submitted;
@@ -481,8 +478,6 @@ struct kvaser_usb {
 	bool rxinitdone;
 	void *rxbuf[MAX_RX_URBS];
 	dma_addr_t rxbuf_dma[MAX_RX_URBS];
-
-	struct can_clock clock;
 };
 
 struct kvaser_usb_net_priv {
@@ -501,6 +496,51 @@ struct kvaser_usb_net_priv {
 	struct kvaser_usb_tx_urb_context tx_contexts[];
 };
 
+struct kvaser_usb_dev_cfg {
+	const struct can_clock clock;
+	const struct can_bittiming_const * const bittiming_const;
+};
+
+static const struct can_bittiming_const kvaser_usb_bittiming_const = {
+	.name = "kvaser_usb",
+	.tseg1_min = KVASER_USB_TSEG1_MIN,
+	.tseg1_max = KVASER_USB_TSEG1_MAX,
+	.tseg2_min = KVASER_USB_TSEG2_MIN,
+	.tseg2_max = KVASER_USB_TSEG2_MAX,
+	.sjw_max = KVASER_USB_SJW_MAX,
+	.brp_min = KVASER_USB_BRP_MIN,
+	.brp_max = KVASER_USB_BRP_MAX,
+	.brp_inc = KVASER_USB_BRP_INC,
+};
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_8mhz = {
+	.clock = {
+		.freq = 8000000,
+	},
+	.bittiming_const = &kvaser_usb_bittiming_const,
+};
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_16mhz = {
+	.clock = {
+		.freq = 16000000,
+	},
+	.bittiming_const = &kvaser_usb_bittiming_const,
+};
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_24mhz = {
+	.clock = {
+		.freq = 24000000,
+	},
+	.bittiming_const = &kvaser_usb_bittiming_const,
+};
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_32mhz = {
+	.clock = {
+		.freq = 32000000,
+	},
+	.bittiming_const = &kvaser_usb_bittiming_const,
+};
+
 static const struct usb_device_id kvaser_usb_table[] = {
 	/* Leaf family IDs */
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_DEVEL_PRODUCT_ID) },
@@ -673,13 +713,13 @@ static void kvaser_usb_get_software_info_leaf(struct kvaser_usb *dev,
 
 	switch (sw_options & KVASER_USB_LEAF_SWOPTION_FREQ_MASK) {
 	case KVASER_USB_LEAF_SWOPTION_FREQ_16_MHZ_CLK:
-		dev->clock.freq = KVASER_USB_CAN_CLOCK_16MHZ;
+		dev->cfg = &kvaser_usb_leaf_dev_cfg_16mhz;
 		break;
 	case KVASER_USB_LEAF_SWOPTION_FREQ_24_MHZ_CLK:
-		dev->clock.freq = KVASER_USB_CAN_CLOCK_24MHZ;
+		dev->cfg = &kvaser_usb_leaf_dev_cfg_24mhz;
 		break;
 	case KVASER_USB_LEAF_SWOPTION_FREQ_32_MHZ_CLK:
-		dev->clock.freq = KVASER_USB_CAN_CLOCK_32MHZ;
+		dev->cfg = &kvaser_usb_leaf_dev_cfg_32mhz;
 		break;
 	}
 }
@@ -705,7 +745,7 @@ static int kvaser_usb_get_software_info(struct kvaser_usb *dev)
 		dev->fw_version = le32_to_cpu(msg.u.usbcan.softinfo.fw_version);
 		dev->max_tx_urbs =
 			le16_to_cpu(msg.u.usbcan.softinfo.max_outstanding_tx);
-		dev->clock.freq = KVASER_USB_CAN_CLOCK_8MHZ;
+		dev->cfg = &kvaser_usb_leaf_dev_cfg_8mhz;
 		break;
 	}
 
@@ -1829,18 +1869,6 @@ static const struct net_device_ops kvaser_usb_netdev_ops = {
 	.ndo_change_mtu = can_change_mtu,
 };
 
-static const struct can_bittiming_const kvaser_usb_bittiming_const = {
-	.name = "kvaser_usb",
-	.tseg1_min = KVASER_USB_TSEG1_MIN,
-	.tseg1_max = KVASER_USB_TSEG1_MAX,
-	.tseg2_min = KVASER_USB_TSEG2_MIN,
-	.tseg2_max = KVASER_USB_TSEG2_MAX,
-	.sjw_max = KVASER_USB_SJW_MAX,
-	.brp_min = KVASER_USB_BRP_MIN,
-	.brp_max = KVASER_USB_BRP_MAX,
-	.brp_inc = KVASER_USB_BRP_INC,
-};
-
 static int kvaser_usb_set_bittiming(struct net_device *netdev)
 {
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
@@ -1957,8 +1985,8 @@ static int kvaser_usb_init_one(struct usb_interface *intf,
 	kvaser_usb_reset_tx_urb_contexts(priv);
 
 	priv->can.state = CAN_STATE_STOPPED;
-	priv->can.clock.freq = dev->clock.freq;
-	priv->can.bittiming_const = &kvaser_usb_bittiming_const;
+	priv->can.clock.freq = dev->cfg->clock.freq;
+	priv->can.bittiming_const = dev->cfg->bittiming_const;
 	priv->can.do_set_bittiming = kvaser_usb_set_bittiming;
 	priv->can.do_set_mode = kvaser_usb_set_mode;
 	if (id->driver_info & KVASER_HAS_TXRX_ERRORS)
-- 
2.36.1

