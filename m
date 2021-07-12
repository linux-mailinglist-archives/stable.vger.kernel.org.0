Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA613C4834
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbhGLGgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:36:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236249AbhGLGf1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:35:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 417D26115A;
        Mon, 12 Jul 2021 06:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071552;
        bh=Da050tis89NjJusNn/tyP2Jxv0QPnmJ1/hwd8rD8adE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oXzOCjn4EqQQjedfTP2Y6COe7iU4DJSM9iCaHiALpNl1w5F1spyxtAYFQoVYefEBk
         dl4iecCgp/pK262QIEqqtHnBDe9/t/Wl0wFcA1DNzd0KiXwUa7LwNCMtmEhHb2nUHK
         AWcxS6O3m01QVSxbl/myd7kbMHtGY7fKGPUi7XOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Bixuan Cui <cuibixuan@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/593] crypto: nx - add missing MODULE_DEVICE_TABLE
Date:   Mon, 12 Jul 2021 08:04:40 +0200
Message-Id: <20210712060856.359673519@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



