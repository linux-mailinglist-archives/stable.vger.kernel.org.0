Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB7F4A5A5E
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 11:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbiBAKoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 05:44:12 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:40168 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiBAKoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 05:44:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 26442CE17D8;
        Tue,  1 Feb 2022 10:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A19BC340EB;
        Tue,  1 Feb 2022 10:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643712247;
        bh=Yk+UtAtINcb8fBUEs7TwV7zT7+wbtfW/rCBydpitFdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jP/06+A9SOj6+fzgLr9lzRIOppVS2cYIHpKqZVQBD28tRBC0Br1+CaLW/HdEoG7Ct
         p3iB0Qb1Bc8LnqQbyvgbhAxIz/tsm4fYnpZrSRO8EGMUNDPw67QXb2D77sxClVUkUV
         PZUkUVS+g95VR/G1H22s0hdrLKiOEQ02EhjgBMjTl63h2U9OjqIqPEwkipgp0/tC6n
         zbqEGVDfbMvQGrkR2Kng1WcBh5CMwrCen57rcr4MFkiZd/qeNxu1RM/QdrwScfzlt/
         dqRu1VCB/ZiZu25SXc7US3WORMcN0yluiAqvsZ9nSddckIv9TyN5LYyKK8n80jAHNM
         sBp4qvDn0uJfA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nEqdb-0002hS-KF; Tue, 01 Feb 2022 11:43:51 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     "Russell, Scott" <Scott.Russell2@ncr.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/2] USB: serial: cp210x: add NCR Retail IO box id
Date:   Tue,  1 Feb 2022 11:42:52 +0100
Message-Id: <20220201104253.10345-2-johan@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220201104253.10345-1-johan@kernel.org>
References: <20220201104253.10345-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add the device id for NCR's Retail IO box (CP2105) used in NCR FastLane
SelfServ Checkout - R6C:

	https://www.ncr.com/product-catalog/ncr-fastlane-selfserv-checkout-r6c

Reported-by: Scott Russell <Scott.Russell2@ncr.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/cp210x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 8a60c0d56863..5172e7ac16fd 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -51,6 +51,7 @@ static void cp210x_enable_event_mode(struct usb_serial_port *port);
 static void cp210x_disable_event_mode(struct usb_serial_port *port);
 
 static const struct usb_device_id id_table[] = {
+	{ USB_DEVICE(0x0404, 0x034C) },	/* NCR Retail IO Box */
 	{ USB_DEVICE(0x045B, 0x0053) }, /* Renesas RX610 RX-Stick */
 	{ USB_DEVICE(0x0471, 0x066A) }, /* AKTAKOM ACE-1001 cable */
 	{ USB_DEVICE(0x0489, 0xE000) }, /* Pirelli Broadband S.p.A, DP-L10 SIP/GSM Mobile */
-- 
2.34.1

