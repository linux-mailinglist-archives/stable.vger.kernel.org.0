Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC42B3CA6A5
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239105AbhGOStm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:49:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240184AbhGOStV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:49:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 549DB613DF;
        Thu, 15 Jul 2021 18:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374786;
        bh=54JwrYKmyebOQcU6kiScVFvJq22l5JE8GEnssN0hO2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=de+cKeoHeaHdoTiRObTSBfN+bnqixzzjAZyBxaVlE8VmmmNocZ6IUjRSLLwzsT7LZ
         uxNJWCmYyOnxJHY27RXRCWqi4lBQURAzqdI3q8yiECjwhfbrZmW1BErXkMvbk5I+gK
         FLCXTay6nQtjwlcfc3+1GdOarNg+pwoXtQm8LQu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/215] drm/bridge: lt9611: Add missing MODULE_DEVICE_TABLE
Date:   Thu, 15 Jul 2021 20:36:30 +0200
Message-Id: <20210715182601.935762774@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



