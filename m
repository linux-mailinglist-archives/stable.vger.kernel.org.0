Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3E82476C8
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404313AbgHQTlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729700AbgHQPYx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:24:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EFD023104;
        Mon, 17 Aug 2020 15:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677892;
        bh=YlRh3B+yB1gO6DwsQEz0MDfmSprSyUwxCReZ80FBhQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nwEEZw/ePNXayjdMN49n2ujnYfeMlZPm1S1wfyqRPOhpAS+wdCYXmRl+bLgsumiE1
         23oSwSvgT37w2GhVgzxlEgO284tQD3WJgim9QXhi5QpjkbGrwMnaxlekU94gXrD2T4
         MZOU1ZJWCndoqonP2qJaViT0rxf8ceki23VI7+e0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 146/464] mwifiex: Fix firmware filename for sd8997 chipset
Date:   Mon, 17 Aug 2020 17:11:39 +0200
Message-Id: <20200817143840.804900058@linuxfoundation.org>
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

[ Upstream commit 2e1fcac52a9ea53e5a13a585d48a29a0fb4a9daf ]

Firmware for sd8997 chipset is distributed by Marvell package and also as
part of the linux-firmware repository in filename sdsd8997_combo_v4.bin.

This patch fixes mwifiex driver to load correct firmware file for sd8997.

Fixes: 6d85ef00d9dfe ("mwifiex: add support for 8997 chipset")
Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: Ganapathi Bhat <ganapathi.bhat@nxp.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/sdio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.h b/drivers/net/wireless/marvell/mwifiex/sdio.h
index 0cac2296ed53c..8b476b007c5e2 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.h
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
@@ -38,7 +38,7 @@
 #define SD8801_DEFAULT_FW_NAME "mrvl/sd8801_uapsta.bin"
 #define SD8977_DEFAULT_FW_NAME "mrvl/sdsd8977_combo_v2.bin"
 #define SD8987_DEFAULT_FW_NAME "mrvl/sd8987_uapsta.bin"
-#define SD8997_DEFAULT_FW_NAME "mrvl/sd8997_uapsta.bin"
+#define SD8997_DEFAULT_FW_NAME "mrvl/sdsd8997_combo_v4.bin"
 
 #define BLOCK_MODE	1
 #define BYTE_MODE	0
-- 
2.25.1



