Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E3839A7D3
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhFCRMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:12:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232030AbhFCRL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:11:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C079761422;
        Thu,  3 Jun 2021 17:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740195;
        bh=ZcE9PpXHCn4O0oMyM7g8LoUcwic1ehwjmPutK4onjzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eotBB3AWNP93pMClfid0fWj3unicIeqZSuw6w3LxlcvsbNOUeUzM9M6fgY7WR1Gnr
         bifcyLVR0W+kMBLFCFvKkHmV3FKRddIfsBAHpE1qmOfju3qydk3XDl87OehleL9uiS
         LRhItxmTS/9XS8HUCvwV/QXdfjtHg68cMdeyRkSAVV1QR140bcY6XJLmW+e6yAlO40
         tihSmPmV1Hh1H/t3/kQDNi5Wdd+33Jt2o8LXAaQ45/ue7efRqj1W6oR+kVdFa5dFqr
         inoGxIxQbs39QuZ8rZN3dfxcdmJvbsrabq882LFGcNLwCqEZL0FpHxWdYhPDPQtQEz
         fl1+08A5Zy8xQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 29/31] nvme-tcp: remove incorrect Kconfig dep in BLK_DEV_NVME
Date:   Thu,  3 Jun 2021 13:09:17 -0400
Message-Id: <20210603170919.3169112-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170919.3169112-1-sashal@kernel.org>
References: <20210603170919.3169112-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 042a3eaad6daeabcfaf163aa44da8ea3cf8b5496 ]

We need to select NVME_CORE.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
index 7b3f6555e67b..cf0ae71c489e 100644
--- a/drivers/nvme/host/Kconfig
+++ b/drivers/nvme/host/Kconfig
@@ -62,7 +62,8 @@ config NVME_FC
 config NVME_TCP
 	tristate "NVM Express over Fabrics TCP host driver"
 	depends on INET
-	depends on BLK_DEV_NVME
+	depends on BLOCK
+	select NVME_CORE
 	select NVME_FABRICS
 	select CRYPTO
 	select CRYPTO_CRC32C
-- 
2.30.2

