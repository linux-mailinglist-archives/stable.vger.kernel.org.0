Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3E75798F7
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 13:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237377AbiGSL5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 07:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237195AbiGSL4n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 07:56:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C2B43E65;
        Tue, 19 Jul 2022 04:56:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD5ACB81B29;
        Tue, 19 Jul 2022 11:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0141EC341C6;
        Tue, 19 Jul 2022 11:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231780;
        bh=MofyTgR5TuxoZnswRez1E2HDuvLM2lHPDa5O62yVi1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l1ZHtL2/HhXKq/LZFcL33wKf3Y078rtSLXyTK2FJVPPlDx4jxpmZcZAZWGNd+A5EQ
         lEZsCIP9Nq0fy/3pTacK7t32k5kyPdlX6k2NeqO0wQZ6GaHdFsY4PvtNYUyyao0EoZ
         daN48DDCx5eb8hokTO2Mz6QGOYyeOTdqAddlnngI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucien Buchmann <lucien.buchmann@gmx.net>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 23/28] USB: serial: ftdi_sio: add Belimo device ids
Date:   Tue, 19 Jul 2022 13:54:01 +0200
Message-Id: <20220719114458.330845479@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114455.701304968@linuxfoundation.org>
References: <20220719114455.701304968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucien Buchmann <lucien.buchmann@gmx.net>

commit 7c239a071d1f04b7137789810807b4108d475c72 upstream.

Those two product ids are known.

Signed-off-by: Lucien Buchmann <lucien.buchmann@gmx.net>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ftdi_sio.c     |    3 +++
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 9 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1018,6 +1018,9 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(FTDI_VID, CHETCO_SEASMART_DISPLAY_PID) },
 	{ USB_DEVICE(FTDI_VID, CHETCO_SEASMART_LITE_PID) },
 	{ USB_DEVICE(FTDI_VID, CHETCO_SEASMART_ANALOG_PID) },
+	/* Belimo Automation devices */
+	{ USB_DEVICE(FTDI_VID, BELIMO_ZTH_PID) },
+	{ USB_DEVICE(FTDI_VID, BELIMO_ZIP_PID) },
 	/* ICP DAS I-756xU devices */
 	{ USB_DEVICE(ICPDAS_VID, ICPDAS_I7560U_PID) },
 	{ USB_DEVICE(ICPDAS_VID, ICPDAS_I7561U_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1568,6 +1568,12 @@
 #define CHETCO_SEASMART_ANALOG_PID	0xA5AF /* SeaSmart Analog Adapter */
 
 /*
+ * Belimo Automation
+ */
+#define BELIMO_ZTH_PID			0x8050
+#define BELIMO_ZIP_PID			0xC811
+
+/*
  * Unjo AB
  */
 #define UNJO_VID			0x22B7


