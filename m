Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB4B3136EA
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbhBHPRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:17:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:55686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233338AbhBHPMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:12:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59F5964EF5;
        Mon,  8 Feb 2021 15:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796964;
        bh=nWE8prE+g082V2ukI4f+8bi9yIYRgdKWnNSP6749RXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sH5mw3Yv8uZBYepYiQwCQzebRuteEcDYyK25PaF4AEZc+C2n1FI4qj+umJuQu0rml
         xSdNobiojcDPjpWQTuRmSlmBhbyjkSHsjWO2s3szh5ihIcqtL2ItobC5RSGumkkZ3O
         REmz0JBKKtWpTgbsmqDshUcdNqI/VdgLg59e/US4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chenxin Jin <bg4akv@hotmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 02/65] USB: serial: cp210x: add new VID/PID for supporting Teraoka AD2000
Date:   Mon,  8 Feb 2021 16:00:34 +0100
Message-Id: <20210208145810.332494144@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chenxin Jin <bg4akv@hotmail.com>

commit 43377df70480f82919032eb09832e9646a8a5efb upstream.

Teraoka AD2000 uses the CP210x driver, but the chip VID/PID is
customized with 0988/0578. We need the driver to support the new
VID/PID.

Signed-off-by: Chenxin Jin <bg4akv@hotmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -61,6 +61,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x08e6, 0x5501) }, /* Gemalto Prox-PU/CU contactless smartcard reader */
 	{ USB_DEVICE(0x08FD, 0x000A) }, /* Digianswer A/S , ZigBee/802.15.4 MAC Device */
 	{ USB_DEVICE(0x0908, 0x01FF) }, /* Siemens RUGGEDCOM USB Serial Console */
+	{ USB_DEVICE(0x0988, 0x0578) }, /* Teraoka AD2000 */
 	{ USB_DEVICE(0x0B00, 0x3070) }, /* Ingenico 3070 */
 	{ USB_DEVICE(0x0BED, 0x1100) }, /* MEI (TM) Cashflow-SC Bill/Voucher Acceptor */
 	{ USB_DEVICE(0x0BED, 0x1101) }, /* MEI series 2000 Combo Acceptor */


