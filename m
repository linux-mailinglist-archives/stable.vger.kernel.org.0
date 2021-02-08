Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9AB313BFA
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 18:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbhBHR7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 12:59:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:45784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235038AbhBHR6w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 12:58:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D75F964E54;
        Mon,  8 Feb 2021 17:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807091;
        bh=vGAiZrUwT+WU6ASXGFHKVVJF1pYjRAtSiGzeESLKqkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=imKYjhaeIpXbs5T3RwXb+OfEc67RCXvSQrQSSHtibHAMsvP9HbGAbXz1A+NVNv/cY
         lCkmS9fUn/+5u/vxZF3EkqMJHVueiiwWKtPXPIF8Tcmdx08ECKkMDG5ftBYtZzXSk1
         X+/RRJzcFtD5uu3sQuO7kR3jH84StvUE2NxYjWWaoMYe30Uv0oKH8GL1LvO+DZVKVM
         9wiExcHc42ZYVaa/We83bo73m77OC/UUJSlyyBhRm7mk7srlgZ76ZeE2MVCbNDCQEG
         DVGAJVBFFaIeD0MMeckOsYZO7Z5KLsC8ATuT2yzYUDRruGqzPaiYnS7XRse/uyphFa
         SSiMQLThDtaPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Bastien Nocera <hadess@hadess.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/36] Input: goodix - add support for Goodix GT9286 chip
Date:   Mon,  8 Feb 2021 12:57:33 -0500
Message-Id: <20210208175806.2091668-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175806.2091668-1-sashal@kernel.org>
References: <20210208175806.2091668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>

[ Upstream commit 2dce6db70c77bbe639f5cd9cc796fb8f2694a7d0 ]

The Goodix GT9286 is a capacitive touch sensor IC based on GT1x.

This chip can be found on a number of smartphones, including the
F(x)tec Pro 1 and the Elephone U.

This has been tested on F(x)Tec Pro1 (MSM8998).

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Link: https://lore.kernel.org/r/20210109135512.149032-2-angelogioacchino.delregno@somainline.org
Reviewed-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/goodix.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index 6612f9e2d7e83..45113767db964 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -157,6 +157,7 @@ static const struct goodix_chip_id goodix_chip_ids[] = {
 	{ .id = "5663", .data = &gt1x_chip_data },
 	{ .id = "5688", .data = &gt1x_chip_data },
 	{ .id = "917S", .data = &gt1x_chip_data },
+	{ .id = "9286", .data = &gt1x_chip_data },
 
 	{ .id = "911", .data = &gt911_chip_data },
 	{ .id = "9271", .data = &gt911_chip_data },
@@ -1445,6 +1446,7 @@ static const struct of_device_id goodix_of_match[] = {
 	{ .compatible = "goodix,gt927" },
 	{ .compatible = "goodix,gt9271" },
 	{ .compatible = "goodix,gt928" },
+	{ .compatible = "goodix,gt9286" },
 	{ .compatible = "goodix,gt967" },
 	{ }
 };
-- 
2.27.0

