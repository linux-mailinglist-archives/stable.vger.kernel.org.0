Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0708A3A6219
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbhFNKzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:55:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234597AbhFNKx2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:53:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59EC461414;
        Mon, 14 Jun 2021 10:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667195;
        bh=ZcE9PpXHCn4O0oMyM7g8LoUcwic1ehwjmPutK4onjzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQy29Tso3q27MpFueOAFAvU1ZeGyfn/YNoGEpfSo6l3VtM/XQbwNsI+3Dabzb1Ex0
         /doW/0VIZdZ2J8KB0fArpBpL1VDmi5SzvanngMDdz6hory/nGDj2uBEp2T/18eRF5U
         +YhnPwfROYrqEJ+VNqK0z1v8gI0U1KBUYJWrhaCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 30/84] nvme-tcp: remove incorrect Kconfig dep in BLK_DEV_NVME
Date:   Mon, 14 Jun 2021 12:27:08 +0200
Message-Id: <20210614102647.384311667@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



