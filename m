Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4DE47ACBF
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbhLTOqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:46:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50940 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbhLTOoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:44:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B69BDB80EF1;
        Mon, 20 Dec 2021 14:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA574C36AEA;
        Mon, 20 Dec 2021 14:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011451;
        bh=uYzN3QOkhwmsq9zrNHALrJIuEIJNsHcGDRsdNYW3B/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOh0LoSaKwHLfAII75nYtmjUHUMVjoXakwqe7Je4Kly2NzoyVFBgtyTjE1T+fkBE/
         +piikeS854if3/xjkRcYrnahmVpDMD7jPDd51Vk2EFK2KYmccoHSd2a0iiL8HAlIBe
         EPtVJDKxw0HKiihlEFHpmljIXzrr+XLUGNQ019M8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alyssa Ross <hi@alyssa.is>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 25/71] dmaengine: st_fdma: fix MODULE_ALIAS
Date:   Mon, 20 Dec 2021 15:34:14 +0100
Message-Id: <20211220143026.530314292@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alyssa Ross <hi@alyssa.is>

[ Upstream commit 822c9f2b833c53fc67e8adf6f63ecc3ea24d502c ]

modprobe can't handle spaces in aliases.

Fixes: 6b4cd727eaf1 ("dmaengine: st_fdma: Add STMicroelectronics FDMA engine driver support")
Signed-off-by: Alyssa Ross <hi@alyssa.is>
Link: https://lore.kernel.org/r/20211125154441.2626214-1-hi@alyssa.is
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/st_fdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/st_fdma.c b/drivers/dma/st_fdma.c
index 67087dbe2f9fa..f7393c19a1ba3 100644
--- a/drivers/dma/st_fdma.c
+++ b/drivers/dma/st_fdma.c
@@ -873,4 +873,4 @@ MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("STMicroelectronics FDMA engine driver");
 MODULE_AUTHOR("Ludovic.barre <Ludovic.barre@st.com>");
 MODULE_AUTHOR("Peter Griffin <peter.griffin@linaro.org>");
-MODULE_ALIAS("platform: " DRIVER_NAME);
+MODULE_ALIAS("platform:" DRIVER_NAME);
-- 
2.33.0



