Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DFB498E67
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354235AbiAXTlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:41:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59656 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349112AbiAXTio (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:38:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39BBFB8122F;
        Mon, 24 Jan 2022 19:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A569C340E5;
        Mon, 24 Jan 2022 19:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053122;
        bh=j8QhFAcoP5YnbewakrrigomulAjYONylTaD5Y1/NRwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zpNsqtbCGHfMTLfB0p7FMHPteZVZUdGf2S+r8v7EkBPRq5euAMngD+dLVmPdoqIRZ
         AeJfg5UB+lpV/euga+F8q2Z7KGC2O/tu/XQvA789Mtk/UjWWnhrbImZwfb4d9lB8s+
         gWcT65vc/dVYxHL2fCXgGGBwbucfw+1M/UVzVuBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 284/320] dmaengine: stm32-mdma: fix STM32_MDMA_CTBR_TSEL_MASK
Date:   Mon, 24 Jan 2022 19:44:28 +0100
Message-Id: <20220124184003.630479015@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

commit e7f110889a87307fb0fed408a5dee1707796ca04 upstream.

This patch fixes STM32_MDMA_CTBR_TSEL_MASK, which is [5:0], not [7:0].

Fixes: a4ffb13c8946 ("dmaengine: Add STM32 MDMA driver")
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20211220165827.1238097-1-amelie.delaunay@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/stm32-mdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/stm32-mdma.c
+++ b/drivers/dma/stm32-mdma.c
@@ -184,7 +184,7 @@
 #define STM32_MDMA_CTBR(x)		(0x68 + 0x40 * (x))
 #define STM32_MDMA_CTBR_DBUS		BIT(17)
 #define STM32_MDMA_CTBR_SBUS		BIT(16)
-#define STM32_MDMA_CTBR_TSEL_MASK	GENMASK(7, 0)
+#define STM32_MDMA_CTBR_TSEL_MASK	GENMASK(5, 0)
 #define STM32_MDMA_CTBR_TSEL(n)		STM32_MDMA_SET(n, \
 						      STM32_MDMA_CTBR_TSEL_MASK)
 


