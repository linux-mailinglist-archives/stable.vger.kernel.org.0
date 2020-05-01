Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A964B1C1300
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgEAN0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:26:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729184AbgEAN0J (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:26:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 789CA2495C;
        Fri,  1 May 2020 13:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339568;
        bh=7sIjFwst6s3p63WthfN6bA9Lj1cHZ+10OxwwnLvN4I0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnUb41sDzOtqb4TNiytj3A9MW8hGvSJxWFiNjBF8BMVTvFJXD5DlpTDeXedXZyScc
         em0o5FaxynDgwBNBAGZUFHPtvON2rcSTo8csVH97pI8rWuQ080i8w0+LppRMAjfWnl
         ak/virzCEwZZbLADJOUDyBIrHrnREV0SnQBIVZQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Cox <jonathan@jdcox.net>
Subject: [PATCH 4.4 31/70] USB: Add USB_QUIRK_DELAY_CTRL_MSG and USB_QUIRK_DELAY_INIT for Corsair K70 RGB RAPIDFIRE
Date:   Fri,  1 May 2020 15:21:19 +0200
Message-Id: <20200501131523.938466228@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.302599262@linuxfoundation.org>
References: <20200501131513.302599262@linuxfoundation.org>
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


