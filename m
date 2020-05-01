Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D47E1C157E
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbgEAN2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:28:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729678AbgEAN2q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:28:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC0E024954;
        Fri,  1 May 2020 13:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339726;
        bh=7sIjFwst6s3p63WthfN6bA9Lj1cHZ+10OxwwnLvN4I0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDni1j+QEi8XL3G3L+Y9fG1KTV0IXviJfnZhKzDEkK4m2zkxw9ze+LiEkY6M4z9O1
         BsOnuK9lOk+GU7mfJT+aL1iIv+pDkLlKUwT1kqt34/neuit52sMtkqLe8CqgI/jna+
         iHgQpzuzvzF1GSnZdFhPZE/QRlOnA6unsAlzxPy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Cox <jonathan@jdcox.net>
Subject: [PATCH 4.9 35/80] USB: Add USB_QUIRK_DELAY_CTRL_MSG and USB_QUIRK_DELAY_INIT for Corsair K70 RGB RAPIDFIRE
Date:   Fri,  1 May 2020 15:21:29 +0200
Message-Id: <20200501131525.181185691@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
References: <20200501131513.810761598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cox <jonathan@jdcox.net>

commit be34a5854b4606bd7a160ad3cb43415d623596c7 upstream.

The Corsair K70 RGB RAPIDFIRE needs the USB_QUIRK_DELAY_INIT and
USB_QUIRK_DELAY_CTRL_MSG to function or it will randomly not
respond on boot, just like other Corsair keyboards

Signed-off-by: Jonathan Cox <jonathan@jdcox.net>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200410212427.2886-1-jonathan@jdcox.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -272,6 +272,10 @@ static const struct usb_device_id usb_qu
 	/* Corsair K70 LUX */
 	{ USB_DEVICE(0x1b1c, 0x1b36), .driver_info = USB_QUIRK_DELAY_INIT },
 
+	/* Corsair K70 RGB RAPDIFIRE */
+	{ USB_DEVICE(0x1b1c, 0x1b38), .driver_info = USB_QUIRK_DELAY_INIT |
+	  USB_QUIRK_DELAY_CTRL_MSG },
+
 	/* MIDI keyboard WORLDE MINI */
 	{ USB_DEVICE(0x1c75, 0x0204), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },


