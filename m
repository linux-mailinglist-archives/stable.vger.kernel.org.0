Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F030057996A
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237763AbiGSMCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237957AbiGSMBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:01:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3784C4AD55;
        Tue, 19 Jul 2022 04:58:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A414BB81A2E;
        Tue, 19 Jul 2022 11:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197A9C341C6;
        Tue, 19 Jul 2022 11:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231927;
        bh=EiDmLPB+gZpuU9TL1DwhdArXNQS73PEzYil+dpzTUig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZOlCFtn5HRA8x9lBOxVKhGvODvZQ6ULYH6T59en2d7VIt7WDtAOwySljmIWSe3vD
         MwIl7Rod+m+bwQhiaxq2BMsA3FXP/83hrRp9mET5tl+LHVLJYwH0ZO5V2J9kuVsEkk
         JBOhjZIcnwUBSuS1VoCZJAvFRkfUvIzsQYmQQ9U0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucien Buchmann <lucien.buchmann@gmx.net>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 38/43] USB: serial: ftdi_sio: add Belimo device ids
Date:   Tue, 19 Jul 2022 13:54:09 +0200
Message-Id: <20220719114525.215685208@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114521.868169025@linuxfoundation.org>
References: <20220719114521.868169025@linuxfoundation.org>
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
@@ -1569,6 +1569,12 @@
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


