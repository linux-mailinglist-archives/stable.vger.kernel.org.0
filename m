Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8020A396290
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbhEaO5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:57:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232212AbhEaOzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:55:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB84661938;
        Mon, 31 May 2021 13:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469590;
        bh=KV0Xdxu8Dkl/vXMKiCns9Jvm8GcHeLevV3LpsKI29eY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qy00dyjmdjAGFTZ6oRdecipoOOKS7dPaqLjtOiAB/z64akfcRxfh3yfe9oQZpO+wG
         Opf61la3YLUySbUNJ7DBary2DCdP72SWkqx9qbjQ2dF7zYyR/90lOcC+DxrPt2E7lW
         ZVEGOdIcmjma47XqrU/GiBLFrLzmdkm17QwEL45A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Bixuan Cui <cuibixuan@huawei.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 257/296] iommu/virtio: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 31 May 2021 15:15:12 +0200
Message-Id: <20210531130712.394435405@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit 382d91fc0f4f1b13f8a0dcbf7145f4f175b71a18 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Fixes: fa4afd78ea12 ("iommu/virtio: Build virtio-iommu as module")
Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Link: https://lore.kernel.org/r/20210508031451.53493-1-cuibixuan@huawei.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/virtio-iommu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index 2bfdd5734844..81dea4caf561 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -1138,6 +1138,7 @@ static struct virtio_device_id id_table[] = {
 	{ VIRTIO_ID_IOMMU, VIRTIO_DEV_ANY_ID },
 	{ 0 },
 };
+MODULE_DEVICE_TABLE(virtio, id_table);
 
 static struct virtio_driver virtio_iommu_drv = {
 	.driver.name		= KBUILD_MODNAME,
-- 
2.30.2



