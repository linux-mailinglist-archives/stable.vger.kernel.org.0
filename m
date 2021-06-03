Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A5639A76F
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhFCRLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:11:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232245AbhFCRK6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31C9B61405;
        Thu,  3 Jun 2021 17:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740154;
        bh=KQj6+Mec5t1lduI9hVJiOB+XDnYJwpycELEWfMg/2Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thUonD4FN4bE1UXEFB6QG9V5WhLhcH1qhmSlE8UBTt+D7wqFy9MC1p4wmHB83jNb4
         iS8ZL7M/S5IXF5j0XPDIqbCxDiH1DPi70H55DEkTTJy8jOJf934j+JhnT4YJMo4CNr
         uxKmcf6orm5v3oMvTYAGLoSd+LNt0++VRIKfBToa1IzwTRfrwxmce786AacK/j6DcN
         lUzwwzzUENOIldpbddpPBQrNjn+qrIghrfinkeZEyHClk/wmfQs+wopGFqrmxlEHL8
         yrloPhgIAouHGwHvMS9930U1JZmQMIS71K/Kh17x2w0keAQaCK3BcwAmE9PnSpyiSg
         Jh6EO74xhREDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 36/39] nvme-tcp: remove incorrect Kconfig dep in BLK_DEV_NVME
Date:   Thu,  3 Jun 2021 13:08:26 -0400
Message-Id: <20210603170829.3168708-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170829.3168708-1-sashal@kernel.org>
References: <20210603170829.3168708-1-sashal@kernel.org>
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
index a44d49d63968..494675aeaaad 100644
--- a/drivers/nvme/host/Kconfig
+++ b/drivers/nvme/host/Kconfig
@@ -71,7 +71,8 @@ config NVME_FC
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

