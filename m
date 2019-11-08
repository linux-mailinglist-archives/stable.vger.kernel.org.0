Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7C3F48B7
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389339AbfKHLof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:44:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732402AbfKHLof (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:44:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01AAF222C2;
        Fri,  8 Nov 2019 11:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213474;
        bh=zgHqDerHD9mq/I9eqXtCLJJAz7f74cQc2mKojojxA2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZmzr76nBjGmFzQMqxkLrb6GGNjHrscit3n8xtE2z659QzZKopbWLU6KRfDjKTPw4
         0F0Jfe980SEEtGO9YdNM0ARe0jYZCbobKv1jfXqTcwEHIGjNLcZONqeumQDEnAhrNs
         rkfZQqybg+SWG6S8wfT4924u7iuaImBspvsLRzOE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 057/103] dmaengine: dma-jz4780: Don't depend on MACH_JZ4780
Date:   Fri,  8 Nov 2019 06:42:22 -0500
Message-Id: <20191108114310.14363-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit c558ecd21c852c97ff98dc6c61f715ba420ec251 ]

If we make this driver depend on MACH_JZ4780, that means it can be
enabled only if we're building a kernel specially crafted for a
JZ4780-based board, while most GNU/Linux distributions will want one
generic MIPS kernel that works on multiple boards.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index fadc4d8783bd8..79b809dbfda01 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -143,7 +143,7 @@ config DMA_JZ4740
 
 config DMA_JZ4780
 	tristate "JZ4780 DMA support"
-	depends on MACH_JZ4780 || COMPILE_TEST
+	depends on MIPS || COMPILE_TEST
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 	help
-- 
2.20.1

