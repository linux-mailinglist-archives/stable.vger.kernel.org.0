Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4F5D191108
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgCXNN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:13:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727752AbgCXNNZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:13:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E69FE20B80;
        Tue, 24 Mar 2020 13:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055605;
        bh=cWF3WUe2wPdnGgifyfwwVAofNRCsrR9G7UqKaQgj4Gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+t6PUq/vxPxYQ41TZnScuyhKYG63inwPDa4jGWmZ9e+ZH163tGaFSnxj4rVv0GyQ
         7pC4T07UytQV7F3qZu8swMBracxIHd+svbv5Cv+MgFl0qu4POZM3dXZ01A+Qc3CCJ7
         nU+baa4cF+wRm/kd6noiXsMgk42fbtRxCSXH4RiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Straube <straube.linux@gmail.com>
Subject: [PATCH 4.19 37/65] staging: rtl8188eu: Add device id for MERCUSYS MW150US v2
Date:   Tue, 24 Mar 2020 14:10:58 +0100
Message-Id: <20200324130801.912227286@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130756.679112147@linuxfoundation.org>
References: <20200324130756.679112147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Straube <straube.linux@gmail.com>

commit bb5786b9286c253557a0115bc8d21879e61b7b94 upstream.

This device was added to the stand-alone driver on github.
Add it to the staging driver as well.

Link: https://github.com/lwfinger/rtl8188eu/commit/2141f244c3e7
Signed-off-by: Michael Straube <straube.linux@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200312093652.13918-1-straube.linux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -38,6 +38,7 @@ static const struct usb_device_id rtw_us
 	{USB_DEVICE(0x2001, 0x331B)}, /* D-Link DWA-121 rev B1 */
 	{USB_DEVICE(0x2357, 0x010c)}, /* TP-Link TL-WN722N v2 */
 	{USB_DEVICE(0x2357, 0x0111)}, /* TP-Link TL-WN727N v5.21 */
+	{USB_DEVICE(0x2C4E, 0x0102)}, /* MERCUSYS MW150US v2 */
 	{USB_DEVICE(0x0df6, 0x0076)}, /* Sitecom N150 v2 */
 	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0xffef)}, /* Rosewill RNX-N150NUB */
 	{}	/* Terminating entry */


