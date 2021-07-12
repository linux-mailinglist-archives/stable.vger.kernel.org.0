Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4884E3C4508
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbhGLGXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:23:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234335AbhGLGWF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:22:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5A636113C;
        Mon, 12 Jul 2021 06:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070736;
        bh=JJ1V97vq16aNg1y9OaEdVi3sKSD3+ZhWA7kaZn4/U6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tsy6mQpQVu/+Fobeb5B7PXHrAvJqQJtkoa65H4W0JIGoR+HFFLhXRw2oN7tj19tGy
         mYsYPV3uC1X+bb8dUcZOgZFdolllPBxXVW2ZXEfAzKEoxvLrNAAw/JiPytKCS7lhps
         coC1UOZxgiFNPE62HodCAHQP33Rx4gkQh5VMrqJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/348] regulator: uniphier: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 12 Jul 2021 08:07:39 +0200
Message-Id: <20210712060711.879421451@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit d019f38a1af3c6015cde6a47951a3ec43beeed80 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Link: https://lore.kernel.org/r/1620705198-104566-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/uniphier-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/uniphier-regulator.c b/drivers/regulator/uniphier-regulator.c
index 2311924c3103..2904c7bb4767 100644
--- a/drivers/regulator/uniphier-regulator.c
+++ b/drivers/regulator/uniphier-regulator.c
@@ -203,6 +203,7 @@ static const struct of_device_id uniphier_regulator_match[] = {
 	},
 	{ /* Sentinel */ },
 };
+MODULE_DEVICE_TABLE(of, uniphier_regulator_match);
 
 static struct platform_driver uniphier_regulator_driver = {
 	.probe = uniphier_regulator_probe,
-- 
2.30.2



