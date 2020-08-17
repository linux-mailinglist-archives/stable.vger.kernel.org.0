Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796C12476C6
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404310AbgHQTln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:41:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729683AbgHQPZB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:25:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DABBC22B4B;
        Mon, 17 Aug 2020 15:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677900;
        bh=u7LJ+6e/2RuN3iPKQN1Z468NNxSIyzVHmukKgUVZ9hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vcHq5W7wPXR54WETEpLzF4lxJVSEl62R6w0k+vAs++RBdDAE4UQYb6pYuJhXn4hJA
         MFiyEQhGvVxsZzKjLXl2C6uBzaqnPtI5esUHX68anbppQSfEJkGameDwojkvHtVQl0
         Z0pV4BULj9zH/KxMSkBGin2AptQ/nerzPB+Urh/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 148/464] btmrvl: Fix firmware filename for sd8997 chipset
Date:   Mon, 17 Aug 2020 17:11:41 +0200
Message-Id: <20200817143840.899557428@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 00eb0cb36fad53315047af12e83c643d3a2c2e49 ]

Firmware for sd8997 chipset is distributed by Marvell package and also as
part of the linux-firmware repository in filename sdsd8997_combo_v4.bin.

This patch fixes mwifiex driver to load correct firmware file for sd8997.

Fixes: f0ef67485f591 ("Bluetooth: btmrvl: add sd8997 chipset support")
Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: Ganapathi Bhat <ganapathi.bhat@nxp.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmrvl_sdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index fa11c3443583a..64ee799c17612 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -346,7 +346,7 @@ static const struct btmrvl_sdio_device btmrvl_sdio_sd8987 = {
 
 static const struct btmrvl_sdio_device btmrvl_sdio_sd8997 = {
 	.helper         = NULL,
-	.firmware       = "mrvl/sd8997_uapsta.bin",
+	.firmware       = "mrvl/sdsd8997_combo_v4.bin",
 	.reg            = &btmrvl_reg_8997,
 	.support_pscan_win_report = true,
 	.sd_blksz_fw_dl = 256,
@@ -1833,4 +1833,4 @@ MODULE_FIRMWARE("mrvl/sd8887_uapsta.bin");
 MODULE_FIRMWARE("mrvl/sd8897_uapsta.bin");
 MODULE_FIRMWARE("mrvl/sdsd8977_combo_v2.bin");
 MODULE_FIRMWARE("mrvl/sd8987_uapsta.bin");
-MODULE_FIRMWARE("mrvl/sd8997_uapsta.bin");
+MODULE_FIRMWARE("mrvl/sdsd8997_combo_v4.bin");
-- 
2.25.1



