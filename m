Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50DE23C8C48
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbhGNTle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:41:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232419AbhGNTlb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:41:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDC7E613D6;
        Wed, 14 Jul 2021 19:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291519;
        bh=oYfTxqLGVBT5yg+xMwCwpdKCTFpfJ5wd+O/hqJoewfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDOEL3HDnvdkfg0GgeT1Rogxj+wB62549G5BO48PERFx/bnTN+FgbetGh1b9M6XYw
         c6pDxfirHqhCi46PctRLRksp3Viid6aqDL2buVpqr5nzxtyG/YrKzf9XybeE7hEMLr
         oCf2TInAAJ+4I4Q2bwc9fjugrw/zqr7BjZyOE5W+ZQWo5A8DbQE8WW3VU8I67YlrN5
         nmyZ3MkY0mDh/xqQLSa+t0gEyO+MvpN+x0i9BG6kipnc6A3lmyPZr/lCm01MV2Cr20
         86S+gY47isYeSSD9snuUtEozaaznm9QEBoOeHnOyocqHHoTRMSEK406jK/weJHx2hc
         NElvxEiq3cE+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 026/108] soc: mediatek: add missing MODULE_DEVICE_TABLE
Date:   Wed, 14 Jul 2021 15:36:38 -0400
Message-Id: <20210714193800.52097-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit ba96de3ae5a7e2121cac80053b277eb2ab51a0ae ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Link: https://lore.kernel.org/r/1620705350-104687-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-devapc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/mediatek/mtk-devapc.c b/drivers/soc/mediatek/mtk-devapc.c
index f1cea041dc5a..7c65ad3d1f8a 100644
--- a/drivers/soc/mediatek/mtk-devapc.c
+++ b/drivers/soc/mediatek/mtk-devapc.c
@@ -234,6 +234,7 @@ static const struct of_device_id mtk_devapc_dt_match[] = {
 	}, {
 	},
 };
+MODULE_DEVICE_TABLE(of, mtk_devapc_dt_match);
 
 static int mtk_devapc_probe(struct platform_device *pdev)
 {
-- 
2.30.2

