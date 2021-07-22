Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C613D296B
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbhGVQD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:03:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233868AbhGVQDF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:03:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35478619FE;
        Thu, 22 Jul 2021 16:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972203;
        bh=oYfTxqLGVBT5yg+xMwCwpdKCTFpfJ5wd+O/hqJoewfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1OB+q4k0VJvTMzDxENHoBfuSCAxon/g6efiVAU2NW+ZS155QVvh6uc7iacbnGPkI
         g2vHSLinpPv1h49xX42nD0wYZYeDpaQTzgTYTdFunH8XAbZP7XCUpeHCCs7L1BHWzY
         aDTYivy0sZf8p0dVRmDB5SHyf9w6aggNjyyP0dBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 024/156] soc: mediatek: add missing MODULE_DEVICE_TABLE
Date:   Thu, 22 Jul 2021 18:29:59 +0200
Message-Id: <20210722155629.192862739@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



