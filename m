Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA0D47AC5E
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234375AbhLTOnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbhLTOlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:41:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC8AC061376;
        Mon, 20 Dec 2021 06:41:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CC186119C;
        Mon, 20 Dec 2021 14:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31380C36AE8;
        Mon, 20 Dec 2021 14:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011279;
        bh=T00b3qHIvJqSZfWRbcobjwdLWi4yChbMrZGbF2isnis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQALO+fSS+GD5CzLUHpy0haeTOA2JEPamyVwQlxZIbh0Y1sp868YPGqrId/amgJww
         t4c0gIpd7ubZrgLJO4xG28bkDR13JG9IvHj2qSncZmwof3btxMleAglCYRZYnkj+QL
         LdZ/pLc2VKHB1dtiywsg6ruz/SCkOA/UQGFgzk4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alyssa Ross <hi@alyssa.is>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/56] dmaengine: st_fdma: fix MODULE_ALIAS
Date:   Mon, 20 Dec 2021 15:34:14 +0100
Message-Id: <20211220143024.141769083@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143023.451982183@linuxfoundation.org>
References: <20211220143023.451982183@linuxfoundation.org>
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
index bfb79bd0c6de5..087d22ba8a2f6 100644
--- a/drivers/dma/st_fdma.c
+++ b/drivers/dma/st_fdma.c
@@ -886,4 +886,4 @@ MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("STMicroelectronics FDMA engine driver");
 MODULE_AUTHOR("Ludovic.barre <Ludovic.barre@st.com>");
 MODULE_AUTHOR("Peter Griffin <peter.griffin@linaro.org>");
-MODULE_ALIAS("platform: " DRIVER_NAME);
+MODULE_ALIAS("platform:" DRIVER_NAME);
-- 
2.33.0



