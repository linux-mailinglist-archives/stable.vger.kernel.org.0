Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56FDE99C99
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391793AbfHVRY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391789AbfHVRY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:59 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1F6F2341D;
        Thu, 22 Aug 2019 17:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494698;
        bh=cXsUr080SobksBYfBW9FDNJrCAnWHqZA/gXb0P3qIrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BCOrvp+IQWu0faL6EBnUyJ7NI7ctn2J2b4iOVZcMCAOpEByzLuBUXlSBr2Y/PSWzm
         U50KPGuqPIsUYWurQgwWRzaxySm/2VTcIHqHYsmqrDgBA3Ml8RCp+e0X1Agjf6Ctub
         O0/GvegrHcNlSWYxGp7DELVvmH6PsZaVnQCJI7gY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rogan Dawes <rogan@dawes.za.net>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 50/71] USB: serial: option: add D-Link DWM-222 device ID
Date:   Thu, 22 Aug 2019 10:19:25 -0700
Message-Id: <20190822171730.005655525@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
References: <20190822171726.131957995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rogan Dawes <rogan@dawes.za.net>

commit 552573e42aab5f75aff9bab855a9677979d9a7d5 upstream.

Add device id for D-Link DWM-222 A2.

MI_00 D-Link HS-USB Diagnostics
MI_01 D-Link HS-USB Modem
MI_02 D-Link HS-USB AT Port
MI_03 D-Link HS-USB NMEA
MI_04 D-Link HS-USB WWAN Adapter (qmi_wwan)
MI_05 USB Mass Storage Device

Cc: stable@vger.kernel.org
Signed-off-by: Rogan Dawes <rogan@dawes.za.net>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1954,6 +1954,8 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(4) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x2001, 0x7e35, 0xff),			/* D-Link DWM-222 */
 	  .driver_info = RSVD(4) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x2001, 0x7e3d, 0xff),			/* D-Link DWM-222 A2 */
+	  .driver_info = RSVD(4) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e01, 0xff, 0xff, 0xff) },	/* D-Link DWM-152/C1 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e02, 0xff, 0xff, 0xff) },	/* D-Link DWM-156/C1 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x7e11, 0xff, 0xff, 0xff) },	/* D-Link DWM-156/A3 */


