Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2784429013D
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405852AbgJPJLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:11:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405837AbgJPJLY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:11:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B61B20872;
        Fri, 16 Oct 2020 09:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839484;
        bh=/UysN2AnYmczg2KD5D8HsfKr2UsfaKckj+vtchLRbi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qxs5lYxsXxOzNp7zckFY8lrNJXrYeOjCBhbrNa19u7tjWXx5TK4n0PIRQueoCIeXR
         Fn3NaUri57ZMuNpG+hjta5z1wjmltMtmID1iMoKZavSLcqx5hjPYpIcLyXqWblvqiW
         z0Ate4I7j0uJN1OMwiUctzxzBBZVHtILr1Q95PRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wilken Gottwalt <wilken.gottwalt@mailbox.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.8 08/14] USB: serial: option: add Cellient MPL200 card
Date:   Fri, 16 Oct 2020 11:07:53 +0200
Message-Id: <20201016090437.569227451@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.153175229@linuxfoundation.org>
References: <20201016090437.153175229@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wilken Gottwalt <wilken.gottwalt@mailbox.org>

commit 3e765cab8abe7f84cb80d4a7a973fc97d5742647 upstream.

Add usb ids of the Cellient MPL200 card.

Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/3db5418fe9e516f4b290736c5a199c9796025e3c.1601715478.git.wilken.gottwalt@mailbox.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -528,6 +528,7 @@ static void option_instat_callback(struc
 /* Cellient products */
 #define CELLIENT_VENDOR_ID			0x2692
 #define CELLIENT_PRODUCT_MEN200			0x9005
+#define CELLIENT_PRODUCT_MPL200			0x9025
 
 /* Hyundai Petatel Inc. products */
 #define PETATEL_VENDOR_ID			0x1ff4
@@ -1982,6 +1983,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x02, 0x01) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MEN200) },
+	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MPL200),
+	  .driver_info = RSVD(1) | RSVD(4) },
 	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T_600A) },
 	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T_600E) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(TPLINK_VENDOR_ID, TPLINK_PRODUCT_LTE, 0xff, 0x00, 0x00) },	/* TP-Link LTE Module */


