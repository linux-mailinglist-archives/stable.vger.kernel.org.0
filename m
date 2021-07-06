Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DB53BD103
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237975AbhGFLh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:37:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235226AbhGFLb2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:31:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF1C261CD2;
        Tue,  6 Jul 2021 11:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570549;
        bh=54JwrYKmyebOQcU6kiScVFvJq22l5JE8GEnssN0hO2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=baB6nErPz2+dHsSEp5fvAKH3CjSsLFca8e8QGb2vkKAYzlbnUVUsqvp9Q2Gw9a7n0
         xb1KHPJ3pjXzekqRLMP3hDt3HN8ooThCwsrRsxDfZqOCmz/M9zt3gfnt4Tj1g662QH
         upjKu8OE65679l0Gn2tkiulfWwhPN7L13gcBqakF9b+Q13zfiJLGoL5plEj4zqL/53
         BL61qj+TiVM13j5adIhqde4qeTAH3MYp4f67sin3cwnqMHFPZBPTaEFHRZcaIHkKt4
         Bg21iZFYuSKlkltt3ScN047cISjfxU85EX2VDqsety82Nd2aJufD/HUd373zltUDaY
         nfszt2HwPW/Zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 019/137] drm/bridge: lt9611: Add missing MODULE_DEVICE_TABLE
Date:   Tue,  6 Jul 2021 07:20:05 -0400
Message-Id: <20210706112203.2062605-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 8d0b1fe81e18eb66a2d4406386760795fe0d77d9 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1620801955-19188-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt9611.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/lontium-lt9611.c b/drivers/gpu/drm/bridge/lontium-lt9611.c
index d734d9402c35..c1926154eda8 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611.c
@@ -1209,6 +1209,7 @@ static struct i2c_device_id lt9611_id[] = {
 	{ "lontium,lt9611", 0 },
 	{}
 };
+MODULE_DEVICE_TABLE(i2c, lt9611_id);
 
 static const struct of_device_id lt9611_match_table[] = {
 	{ .compatible = "lontium,lt9611" },
-- 
2.30.2

