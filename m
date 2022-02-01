Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0925E4A5A61
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 11:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbiBAKoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 05:44:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58298 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbiBAKoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 05:44:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42A0D614DC;
        Tue,  1 Feb 2022 10:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB2BC340ED;
        Tue,  1 Feb 2022 10:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643712247;
        bh=Sr/xJ/zkGk830k1xHWi1d7aXDQK5hf8tSKnBh/dmt2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8J9bAwf+8m3h7StnLUBrtZhlnXi9Y875sfPp4CbGxj6+oLEqO+bWI8p1h/h1C4Z6
         7uvj+cGA49uB1irkIkvI9YH/xQndKzFvtznewqW+J+0kRx9bxgm5c8x3GpxP/PGrv3
         UolN2wTjfHPQ2YWAV379XohlFX4SMHKc4bA1uToX7d9Khl9osqXXiy1nKyfFsK2Slv
         qTuTW4BnRaEYIbJi028nH5iywJI9h70tZ5Oo+DWBnlOYfZUKxZOM91BoaMQqzGY8s5
         aAYxVCs0xcVBdVyV+HQ3GJy2edwTkT/MjjWOalPQwxSrB9QI8rcKVyYEaBzsudHeGA
         sIiBmO9xVyGDg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nEqdb-0002hU-Mn; Tue, 01 Feb 2022 11:43:51 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     "Russell, Scott" <Scott.Russell2@ncr.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/2] USB: serial: cp210x: add CPI Bulk Coin Recycler id
Date:   Tue,  1 Feb 2022 11:42:53 +0100
Message-Id: <20220201104253.10345-3-johan@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220201104253.10345-1-johan@kernel.org>
References: <20220201104253.10345-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add the device id for the Crane Payment Innovation / Money Controls Bulk
Coin Recycler:

	https://www.cranepi.com/en/system/files/Support/OM_BCR_EN_V1-04_0.pdf

Reported-by: Scott Russell <Scott.Russell2@ncr.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/cp210x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 5172e7ac16fd..a27f7efcec6a 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -69,6 +69,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x0FCF, 0x1004) }, /* Dynastream ANT2USB */
 	{ USB_DEVICE(0x0FCF, 0x1006) }, /* Dynastream ANT development board */
 	{ USB_DEVICE(0x0FDE, 0xCA05) }, /* OWL Wireless Electricity Monitor CM-160 */
+	{ USB_DEVICE(0x106F, 0x0003) },	/* CPI / Money Controls Bulk Coin Recycler */
 	{ USB_DEVICE(0x10A6, 0xAA26) }, /* Knock-off DCU-11 cable */
 	{ USB_DEVICE(0x10AB, 0x10C5) }, /* Siemens MC60 Cable */
 	{ USB_DEVICE(0x10B5, 0xAC70) }, /* Nokia CA-42 USB */
-- 
2.34.1

