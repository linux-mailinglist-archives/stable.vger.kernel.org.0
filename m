Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1DD4499581
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442050AbiAXUwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:52:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47750 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391504AbiAXUsC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:48:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2F3EB81233;
        Mon, 24 Jan 2022 20:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331E2C340E5;
        Mon, 24 Jan 2022 20:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057279;
        bh=j8QhFAcoP5YnbewakrrigomulAjYONylTaD5Y1/NRwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eba9sTTyukCyzJbaU2YLo2CaDDZgZsTvPENi0+9hPxHL6YuCUIFmrQn1tQtyC2eyl
         jRpyzsa4pt6CkOPxbbJmdlL/Pje+q+orHpllS1mJC0VqyInRGJEHIjZa4goHZv4XES
         E0lxe+ywNPSC0I27hHzLdi47B9MYKeQoVwYgfsS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 753/846] dmaengine: stm32-mdma: fix STM32_MDMA_CTBR_TSEL_MASK
Date:   Mon, 24 Jan 2022 19:44:30 +0100
Message-Id: <20220124184126.948305234@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
 


