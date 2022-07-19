Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20479579D04
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241587AbiGSMp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241778AbiGSMof (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:44:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDE38721E;
        Tue, 19 Jul 2022 05:17:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C33561830;
        Tue, 19 Jul 2022 12:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47688C341C6;
        Tue, 19 Jul 2022 12:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233053;
        bh=ZHDS7axaqv3eoGXc0bA8B+TANT3b2ltotVfUt2qyR04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cn/IanRQIYF4VsGr2VFkjIG34ll8BY4qzSmdD9tyuCVF2j3omuTraF9mAtFEglc/2
         jVqhjGOt02or39RJ41mM+fzEDrGk8NwMpo1IYPZh/1KJD2fH56MOYw+Qu80qRI0Z4L
         lw/ohGpG7B95mObmUYoADf+a2Q6NryjQDYPohnGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucien Buchmann <lucien.buchmann@gmx.net>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 158/167] USB: serial: ftdi_sio: add Belimo device ids
Date:   Tue, 19 Jul 2022 13:54:50 +0200
Message-Id: <20220719114711.784220801@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
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
@@ -1023,6 +1023,9 @@ static const struct usb_device_id id_tab
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


