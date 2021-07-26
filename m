Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374BB3D6259
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236638AbhGZPfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234170AbhGZPdz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:33:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADCAF60F5D;
        Mon, 26 Jul 2021 16:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316049;
        bh=Sk9ESvFqQXzqMJEwSDYDELk/U/zXa6XKevWibCeGais=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RS9uoXavAiYogsiEbcLVoC2WP3APmPdn18t5DSOvErN7YNemKn71fjVMP03mpuXYR
         TsrtrBdY9daAseyt7YPTkOGSR9ZwFBCkMcKChbp7QQi+ESpVC8kjtHI6J2NOUGxyBG
         RDMt8PW7IOE8i+y+pWCn750p+FgkjeBft/1xJoGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Keeping <john@metanate.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.13 168/223] USB: serial: cp210x: add ID for CEL EM3588 USB ZigBee stick
Date:   Mon, 26 Jul 2021 17:39:20 +0200
Message-Id: <20210726153851.703398421@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Keeping <john@metanate.com>

commit d6a206e60124a9759dd7f6dfb86b0e1d3b1df82e upstream.

Add the USB serial device ID for the CEL ZigBee EM3588 radio stick.

Signed-off-by: John Keeping <john@metanate.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -155,6 +155,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x89A4) }, /* CESINEL FTBC Flexible Thyristor Bridge Controller */
 	{ USB_DEVICE(0x10C4, 0x89FB) }, /* Qivicon ZigBee USB Radio Stick */
 	{ USB_DEVICE(0x10C4, 0x8A2A) }, /* HubZ dual ZigBee and Z-Wave dongle */
+	{ USB_DEVICE(0x10C4, 0x8A5B) }, /* CEL EM3588 ZigBee USB Stick */
 	{ USB_DEVICE(0x10C4, 0x8A5E) }, /* CEL EM3588 ZigBee USB Stick Long Range */
 	{ USB_DEVICE(0x10C4, 0x8B34) }, /* Qivicon ZigBee USB Radio Stick */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */


