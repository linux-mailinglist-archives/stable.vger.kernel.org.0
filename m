Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98EBE22EECC
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbgG0OKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729921AbgG0OKv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:10:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53A2A2173E;
        Mon, 27 Jul 2020 14:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859050;
        bh=YtDnHAVbA9/a5sdIs/kcn/Sqz1wweEJKvU0Wv/lqQr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZp0zrg0KKNwdiVe9wwWeIiopG5NvovxWnPOj1PQ4amf9Tsv0Voh1LVGJVy82nwBI
         9jmdHMg1UfrVKc+P9V5Eql9x/HpPxvygyNkGpq+JgBTLgJcTf0P7kEqLbD2BpjK5WY
         /TN7lUgemyrnqD7ZfNQr+UspI2TTPdUv3nzxCT/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Tony Lindgren <tony@atomide.com>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 48/86] Input: add `SW_MACHINE_COVER`
Date:   Mon, 27 Jul 2020 16:04:22 +0200
Message-Id: <20200727134916.823991118@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Merlijn Wajer <merlijn@wizzup.org>

[ Upstream commit c463bb2a8f8d7d97aa414bf7714fc77e9d3b10df ]

This event code represents the state of a removable cover of a device.
Value 0 means that the cover is open or removed, value 1 means that the
cover is closed.

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Merlijn Wajer <merlijn@wizzup.org>
Link: https://lore.kernel.org/r/20200612125402.18393-2-merlijn@wizzup.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mod_devicetable.h        | 2 +-
 include/uapi/linux/input-event-codes.h | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 84e4e20352d9f..610cdf8082f2e 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -299,7 +299,7 @@ struct pcmcia_device_id {
 #define INPUT_DEVICE_ID_LED_MAX		0x0f
 #define INPUT_DEVICE_ID_SND_MAX		0x07
 #define INPUT_DEVICE_ID_FF_MAX		0x7f
-#define INPUT_DEVICE_ID_SW_MAX		0x0f
+#define INPUT_DEVICE_ID_SW_MAX		0x10
 #define INPUT_DEVICE_ID_PROP_MAX	0x1f
 
 #define INPUT_DEVICE_ID_MATCH_BUS	1
diff --git a/include/uapi/linux/input-event-codes.h b/include/uapi/linux/input-event-codes.h
index 61a5799b440b9..c3e84f7c8261a 100644
--- a/include/uapi/linux/input-event-codes.h
+++ b/include/uapi/linux/input-event-codes.h
@@ -795,7 +795,8 @@
 #define SW_LINEIN_INSERT	0x0d  /* set = inserted */
 #define SW_MUTE_DEVICE		0x0e  /* set = device disabled */
 #define SW_PEN_INSERTED		0x0f  /* set = pen inserted */
-#define SW_MAX			0x0f
+#define SW_MACHINE_COVER	0x10  /* set = cover closed */
+#define SW_MAX			0x10
 #define SW_CNT			(SW_MAX+1)
 
 /*
-- 
2.25.1



