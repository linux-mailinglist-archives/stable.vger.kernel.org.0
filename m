Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563033BB275
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbhGDXPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233492AbhGDXO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9D6D61941;
        Sun,  4 Jul 2021 23:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440196;
        bh=Da050tis89NjJusNn/tyP2Jxv0QPnmJ1/hwd8rD8adE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SgLmRNBgwFfPHjkP0nZugFOrsT64oN7mNBUMJNGWXUdZa/UxR5nFW/pXwVuF59y/S
         +IAWG0vHQ4TIyS3XGImh0SvUxDGhpCrlczPAB7g6fkSXpp+kcksN6zqfs10znqxiiW
         1TQAO1Zn3ugAsA3k68P9vz1iWfIwxaU25BxGP2FMUm0SRw+5uUChBEw+hx8kNEzMB4
         dKdLBOWtJWqU/CGQzTFf+DJT60YBQjuUWixcKT9QkCe/WoO6R3zMiSzTZ2ZmFnq17c
         b3j/cYWmgdkjOfxoqgRJFDMsA0Rqzb8JfvY7LAPNOHr/KfuQo0wHTxt4Qv/WUHfL0V
         xUCnoDnu566yg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 14/50] crypto: nx - add missing MODULE_DEVICE_TABLE
Date:   Sun,  4 Jul 2021 19:09:02 -0400
Message-Id: <20210704230938.1490742-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230938.1490742-1-sashal@kernel.org>
References: <20210704230938.1490742-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit 06676aa1f455c74e3ad1624cea3acb9ed2ef71ae ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/nx/nx-842-pseries.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index 2de5e3672e42..258c5e38a551 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -1071,6 +1071,7 @@ static const struct vio_device_id nx842_vio_driver_ids[] = {
 	{"ibm,compression-v1", "ibm,compression"},
 	{"", ""},
 };
+MODULE_DEVICE_TABLE(vio, nx842_vio_driver_ids);
 
 static struct vio_driver nx842_vio_driver = {
 	.name = KBUILD_MODNAME,
-- 
2.30.2

