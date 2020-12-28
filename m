Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B902E3DAB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391826AbgL1OSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:18:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:53562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2501960AbgL1OS1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:18:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDE0321D94;
        Mon, 28 Dec 2020 14:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165067;
        bh=aKx1Z4Hdhd3pDjbh2VxLNFIu8djoWJafUHFWAisL7ZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8+pJOHkbJseufkThbHOyxWgmPCs/ZZXwIVWbnPEOJ9TXzl/pJIpLPIxBlKk2Sci5
         vFXXG2fg49WpCl0ETpBm9oGOrKzTwmjsfXt5d/h/0EFxZ+e+xsTchgo9Ks5ArtAFMs
         EerRToFNfZYy57IQSn1cL1O4LuABJz+ZEJfwsuJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tzung-Bi Shih <tzungbi@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 398/717] remoteproc/mediatek: change MT8192 CFG register base
Date:   Mon, 28 Dec 2020 13:46:36 +0100
Message-Id: <20201228125040.068695495@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tzung-Bi Shih <tzungbi@google.com>

[ Upstream commit 0a441514bc2b8a48ebe23c2dcb9feee6351d45b6 ]

The correct MT8192 CFG register base is 0x20000 off.  Changes the
registers accordingly.

Fixes: fd0b6c1ff85a ("remoteproc/mediatek: Add support for mt8192 SCP")
Signed-off-by: Tzung-Bi Shih <tzungbi@google.com>
Link: https://lore.kernel.org/r/20201210054109.587795-1-tzungbi@google.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/mtk_common.h | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/remoteproc/mtk_common.h b/drivers/remoteproc/mtk_common.h
index 47b4561443a94..f2bcc9d9fda65 100644
--- a/drivers/remoteproc/mtk_common.h
+++ b/drivers/remoteproc/mtk_common.h
@@ -32,22 +32,22 @@
 #define MT8183_SCP_CACHESIZE_8KB	BIT(8)
 #define MT8183_SCP_CACHE_CON_WAYEN	BIT(10)
 
-#define MT8192_L2TCM_SRAM_PD_0		0x210C0
-#define MT8192_L2TCM_SRAM_PD_1		0x210C4
-#define MT8192_L2TCM_SRAM_PD_2		0x210C8
-#define MT8192_L1TCM_SRAM_PDN		0x2102C
-#define MT8192_CPU0_SRAM_PD		0x21080
-
-#define MT8192_SCP2APMCU_IPC_SET	0x24080
-#define MT8192_SCP2APMCU_IPC_CLR	0x24084
+#define MT8192_L2TCM_SRAM_PD_0		0x10C0
+#define MT8192_L2TCM_SRAM_PD_1		0x10C4
+#define MT8192_L2TCM_SRAM_PD_2		0x10C8
+#define MT8192_L1TCM_SRAM_PDN		0x102C
+#define MT8192_CPU0_SRAM_PD		0x1080
+
+#define MT8192_SCP2APMCU_IPC_SET	0x4080
+#define MT8192_SCP2APMCU_IPC_CLR	0x4084
 #define MT8192_SCP_IPC_INT_BIT		BIT(0)
-#define MT8192_SCP2SPM_IPC_CLR		0x24094
-#define MT8192_GIPC_IN_SET		0x24098
+#define MT8192_SCP2SPM_IPC_CLR		0x4094
+#define MT8192_GIPC_IN_SET		0x4098
 #define MT8192_HOST_IPC_INT_BIT		BIT(0)
 
-#define MT8192_CORE0_SW_RSTN_CLR	0x30000
-#define MT8192_CORE0_SW_RSTN_SET	0x30004
-#define MT8192_CORE0_WDT_CFG		0x30034
+#define MT8192_CORE0_SW_RSTN_CLR	0x10000
+#define MT8192_CORE0_SW_RSTN_SET	0x10004
+#define MT8192_CORE0_WDT_CFG		0x10034
 
 #define SCP_FW_VER_LEN			32
 #define SCP_SHARE_BUFFER_SIZE		288
-- 
2.27.0



