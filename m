Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BD4246BE8
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388336AbgHQQEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:04:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388332AbgHQQEh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:04:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F3B020772;
        Mon, 17 Aug 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680277;
        bh=EqM+gLh7D3odZQRkGC9GZ7RNw+ABm4SgeE8Cenu11Gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnoLinNpduvqEKNGydBXE4cTwacLU5jXkxVAaWygH9M5Zeu88pYFdw1Dp8pNEf/Yh
         DrR3Oflz9EopTwEQPPJ31fV2X6kHSubIDf5B11P5r4ZGVhb/FwZlGdCxHIRnuURQT2
         Cp/s1EFlVaXILzW1g1UvGgJ+rRvqBzH12RETdl3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/270] btmrvl: Fix firmware filename for sd8977 chipset
Date:   Mon, 17 Aug 2020 17:14:56 +0200
Message-Id: <20200817143800.508686793@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit dbec3af5f13b88a96e31f252957ae1a82484a923 ]

Firmware for sd8977 chipset is distributed by Marvell package and also as
part of the linux-firmware repository in filename sdsd8977_combo_v2.bin.

This patch fixes mwifiex driver to load correct firmware file for sd8977.

Fixes: 8c57983bf7a79 ("Bluetooth: btmrvl: add support for sd8977 chipset")
Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: Ganapathi Bhat <ganapathi.bhat@nxp.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmrvl_sdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index 0f3a020703ab2..7aa2c94720bc5 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -328,7 +328,7 @@ static const struct btmrvl_sdio_device btmrvl_sdio_sd8897 = {
 
 static const struct btmrvl_sdio_device btmrvl_sdio_sd8977 = {
 	.helper         = NULL,
-	.firmware       = "mrvl/sd8977_uapsta.bin",
+	.firmware       = "mrvl/sdsd8977_combo_v2.bin",
 	.reg            = &btmrvl_reg_8977,
 	.support_pscan_win_report = true,
 	.sd_blksz_fw_dl = 256,
@@ -1831,6 +1831,6 @@ MODULE_FIRMWARE("mrvl/sd8787_uapsta.bin");
 MODULE_FIRMWARE("mrvl/sd8797_uapsta.bin");
 MODULE_FIRMWARE("mrvl/sd8887_uapsta.bin");
 MODULE_FIRMWARE("mrvl/sd8897_uapsta.bin");
-MODULE_FIRMWARE("mrvl/sd8977_uapsta.bin");
+MODULE_FIRMWARE("mrvl/sdsd8977_combo_v2.bin");
 MODULE_FIRMWARE("mrvl/sd8987_uapsta.bin");
 MODULE_FIRMWARE("mrvl/sd8997_uapsta.bin");
-- 
2.25.1



