Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4DC3BCBDE
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhGFLRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232152AbhGFLRk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:17:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B18561C31;
        Tue,  6 Jul 2021 11:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570102;
        bh=BbBjFFzx3hsiDDbjqsIrvBKyNqlKdtuOHcXFoZnj/iU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O624hqqLgA570iwgW2WjtsupLOOUMPWSxIgXSWHKt0ecgBb1LTMuSb9mvkHfHClAm
         Vq2w3bT0EeJkzAwSDxcayWJVBqDYulWq0mfj1t2S/N60ZS3DZOk/6dgW8z/FxKoyJB
         0L9oHXDGC/3bz+N9w/vaxWlHFkSeQlkRR84xdxJ3TL/cyb4NpFi4fxogiQ5LsIkrFj
         hAl6RGSuopvSMoc6SpSi1XRguFRNA7eD6jIGL7IwXLHG1FfWfXO+aogs8/+RkGnSwn
         6vNnRud67e3xNjctsZm33dZrpIqJKglKfdUgIlNg2KeQq/66OvG5KSMjPZlmFryHTK
         i8wAtQxpVlnTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 036/189] pinctrl: equilibrium: Add missing MODULE_DEVICE_TABLE
Date:   Tue,  6 Jul 2021 07:11:36 -0400
Message-Id: <20210706111409.2058071-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit d7f444499d6faf9a6ae3b27ec094109528d2b9a7 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Link: https://lore.kernel.org/r/20210508031502.53637-1-cuibixuan@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-equilibrium.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-equilibrium.c b/drivers/pinctrl/pinctrl-equilibrium.c
index a194d8089b6f..38cc20fa9d5a 100644
--- a/drivers/pinctrl/pinctrl-equilibrium.c
+++ b/drivers/pinctrl/pinctrl-equilibrium.c
@@ -939,6 +939,7 @@ static const struct of_device_id eqbr_pinctrl_dt_match[] = {
 	{ .compatible = "intel,lgm-io" },
 	{}
 };
+MODULE_DEVICE_TABLE(of, eqbr_pinctrl_dt_match);
 
 static struct platform_driver eqbr_pinctrl_driver = {
 	.probe	= eqbr_pinctrl_probe,
-- 
2.30.2

