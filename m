Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C24D719B177
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388516AbgDAQfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:35:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388726AbgDAQfP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:35:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BED7E20BED;
        Wed,  1 Apr 2020 16:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758915;
        bh=PKiDhAh6bWqTSeblTcYNX4Yv/k4I0MQadYvybeghczo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJLyGfbla4Qlkl3eRl/LBBR7Qwi1CsjfjycsVloFHQQrRoMkqPXYRrR1gxhgUlX8F
         mVyR2vaMS3rQF73fYheAsCsMc9bc3w4Riicn56o0ja0E0jFiZqzVBq8WLLzcR5oFc0
         iTNF/ex2c0lJPayj+pfjrbh1k/SmWVdUOZWd4btE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Straube <straube.linux@gmail.com>
Subject: [PATCH 4.9 020/102] staging: rtl8188eu: Add device id for MERCUSYS MW150US v2
Date:   Wed,  1 Apr 2020 18:17:23 +0200
Message-Id: <20200401161536.374768198@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
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
@@ -46,6 +46,7 @@ static struct usb_device_id rtw_usb_id_t
 	{USB_DEVICE(0x2001, 0x331B)}, /* D-Link DWA-121 rev B1 */
 	{USB_DEVICE(0x2357, 0x010c)}, /* TP-Link TL-WN722N v2 */
 	{USB_DEVICE(0x2357, 0x0111)}, /* TP-Link TL-WN727N v5.21 */
+	{USB_DEVICE(0x2C4E, 0x0102)}, /* MERCUSYS MW150US v2 */
 	{USB_DEVICE(0x0df6, 0x0076)}, /* Sitecom N150 v2 */
 	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0xffef)}, /* Rosewill RNX-N150NUB */
 	{}	/* Terminating entry */


