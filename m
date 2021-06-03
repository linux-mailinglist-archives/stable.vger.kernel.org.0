Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4675E39A6DC
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhFCRJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:09:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231160AbhFCRJi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:09:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE711613F6;
        Thu,  3 Jun 2021 17:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740073;
        bh=UtaTbqjqvTZDE1FmFEJXLNETUsHxwA5ZfmWH+yUhYX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=go1GS4Ni7z2L8i+XlGkNyir9fopruZEVPoUtkWS1LhQvxVN7p56CweDSU3nPog7z3
         +DkpjjGwjIguhBbkNqeqczdWVAzb7VazYf5gsbPgILKt5hfaS3a6vRApXrNb2wuGOD
         lRNSmi5JWO/0z2ksRDO0IbI412MXsYL9Xitj2TIRCcWf11iDO6D72Hnwbm9aUkadbv
         rzhJVqZ06meJn+skyVaw3EpCCqhNVqyMla5kXkPeldL8w9cTLe4Vxm3KOEE6UK8omI
         3bJFQleEu3jCKfcdeqsfjs3opx9qXXb4+abejdP3oAY+Ejope6CuzupvB237a9iIQH
         ZVOU7ghzzFlKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 15/43] ASoC: sti-sas: add missing MODULE_DEVICE_TABLE
Date:   Thu,  3 Jun 2021 13:07:05 -0400
Message-Id: <20210603170734.3168284-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170734.3168284-1-sashal@kernel.org>
References: <20210603170734.3168284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit e072b2671606c77538d6a4dd5dda80b508cb4816 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Link: https://lore.kernel.org/r/1620789145-14936-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sti-sas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/sti-sas.c b/sound/soc/codecs/sti-sas.c
index ec9933b054ad..423daac9d5a9 100644
--- a/sound/soc/codecs/sti-sas.c
+++ b/sound/soc/codecs/sti-sas.c
@@ -411,6 +411,7 @@ static const struct of_device_id sti_sas_dev_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, sti_sas_dev_match);
 
 static int sti_sas_driver_probe(struct platform_device *pdev)
 {
-- 
2.30.2

