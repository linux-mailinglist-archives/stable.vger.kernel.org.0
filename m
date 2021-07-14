Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8418E3C8C6A
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbhGNTl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:41:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233622AbhGNTlq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:41:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 829E3613D6;
        Wed, 14 Jul 2021 19:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291533;
        bh=ToHPHCSJF2WG4YeTUnEG8RVXT2dtGFwMgCE15/wD/m4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJ3RPvjkQEm4UouropyHw0Jj2KfM72WhpYIRZcKWah4OBBPtZUQsGg2uhSUAYBKZA
         jSBm5xLicdTamODP+pg3Z05eUHRGeQ5+uHoCOokf29HjAbrWgfzyWeEWtPWqC/3SLS
         JDXGYAYi2XeT74J2OYnSdGQtOOlHLCnaetcbnfk4Otw+zJiXzBbkpmlsDv60ti+oxK
         UsCyFwnWpPZJeiJPQZw8pN0pPzjsV6z3y4MJJF4v4g97mv1KLQ/V1lNjyBJNIqxdGi
         O5M4cHc8tcWT7YzdbMhWuuSqoo4ojsAuZt0JjKLdHgJZ238ZwexNvnNisWJypbmh/V
         HovDbui9G+jrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 036/108] rtc: mxc_v2: add missing MODULE_DEVICE_TABLE
Date:   Wed, 14 Jul 2021 15:36:48 -0400
Message-Id: <20210714193800.52097-36-sashal@kernel.org>
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

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit 206e04ec7539e7bfdde9aa79a7cde656c9eb308e ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210508031509.53735-1-cuibixuan@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mxc_v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-mxc_v2.c b/drivers/rtc/rtc-mxc_v2.c
index a577a74aaf75..5e0383401629 100644
--- a/drivers/rtc/rtc-mxc_v2.c
+++ b/drivers/rtc/rtc-mxc_v2.c
@@ -372,6 +372,7 @@ static const struct of_device_id mxc_ids[] = {
 	{ .compatible = "fsl,imx53-rtc", },
 	{}
 };
+MODULE_DEVICE_TABLE(of, mxc_ids);
 
 static struct platform_driver mxc_rtc_driver = {
 	.driver = {
-- 
2.30.2

