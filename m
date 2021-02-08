Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2567E31364A
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhBHPIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:08:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231627AbhBHPFx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:05:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D83164ED0;
        Mon,  8 Feb 2021 15:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796664;
        bh=xKA8XGGgGzH2wNtruguMYvvPBBIjJGh1db20RDugZOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CM28Zln+tih6LJevAA7vK21150YdAmJH5m93YGLJsPRmwknbXnNZunOTyUZ3KTc4J
         Wa5zWCC6cciTfShWKUI6JNQ35A/g/o/eYW51bnIvmFk8g3HQRAy1oNnMIFHE6qZyb1
         MU/15PshgLIl7GxjcCSyTx5G2HRFt1bMS/3bdR4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chenxin Jin <bg4akv@hotmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 20/43] USB: serial: cp210x: add new VID/PID for supporting Teraoka AD2000
Date:   Mon,  8 Feb 2021 16:00:46 +0100
Message-Id: <20210208145807.138074488@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.281758651@linuxfoundation.org>
References: <20210208145806.281758651@linuxfoundation.org>
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
@@ -58,6 +58,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x08e6, 0x5501) }, /* Gemalto Prox-PU/CU contactless smartcard reader */
 	{ USB_DEVICE(0x08FD, 0x000A) }, /* Digianswer A/S , ZigBee/802.15.4 MAC Device */
 	{ USB_DEVICE(0x0908, 0x01FF) }, /* Siemens RUGGEDCOM USB Serial Console */
+	{ USB_DEVICE(0x0988, 0x0578) }, /* Teraoka AD2000 */
 	{ USB_DEVICE(0x0B00, 0x3070) }, /* Ingenico 3070 */
 	{ USB_DEVICE(0x0BED, 0x1100) }, /* MEI (TM) Cashflow-SC Bill/Voucher Acceptor */
 	{ USB_DEVICE(0x0BED, 0x1101) }, /* MEI series 2000 Combo Acceptor */


