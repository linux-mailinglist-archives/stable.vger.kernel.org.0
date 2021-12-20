Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4D347AF71
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240145AbhLTPMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbhLTPKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:10:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6836CC0A88DF;
        Mon, 20 Dec 2021 06:56:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 264B8B80EA3;
        Mon, 20 Dec 2021 14:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612FCC36AE8;
        Mon, 20 Dec 2021 14:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012164;
        bh=Wq4yc2NzsUsSm2s8V09YEZ2CdcT3pR+3UCU+Yj+DouY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txSmDi72q8R7WPu/fb79Wsxx8pIGMNQjPq4+y8NaVBeHVI71I8Wj3OvJ4T7o9BrD5
         jGYDZIaEPPGXF5mQGhA4H9mcIOTgh+0DqRGZBlgpGZU7aFmuIkNEU+n+Tr0u6YxRz/
         plQLbxfr/UltafTOsHr9w4WoGTW4gtcERJ3OWusA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alyssa Ross <hi@alyssa.is>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/177] dmaengine: st_fdma: fix MODULE_ALIAS
Date:   Mon, 20 Dec 2021 15:33:41 +0100
Message-Id: <20211220143042.498258287@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
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
index 962b6e05287b5..d95c421877fb7 100644
--- a/drivers/dma/st_fdma.c
+++ b/drivers/dma/st_fdma.c
@@ -874,4 +874,4 @@ MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("STMicroelectronics FDMA engine driver");
 MODULE_AUTHOR("Ludovic.barre <Ludovic.barre@st.com>");
 MODULE_AUTHOR("Peter Griffin <peter.griffin@linaro.org>");
-MODULE_ALIAS("platform: " DRIVER_NAME);
+MODULE_ALIAS("platform:" DRIVER_NAME);
-- 
2.33.0



