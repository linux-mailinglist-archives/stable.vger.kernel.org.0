Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E63C3CDF76
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343555AbhGSPK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344058AbhGSPI4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:08:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82FED61222;
        Mon, 19 Jul 2021 15:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709715;
        bh=xDDqPtISmtoJbD92SaB2g1bXCd4plRfczxuEqxbeOlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rqjEchvjK7DqSJL3nLR0MWN32wqvLpNCWFSgGIlPZqsH/GGzT7B7D2+8Pb8qQnwcs
         OcP0ymveHsnUIr1DK1qrkOgteT19wACIJJ/8pDUkVuV6lBHuJYNqsarg2DtXShTsMD
         PWyHprBkQuF7hPv1ymNg2kXQ057sekM+SzOYFr5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/149] power: supply: sc27xx: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:52:57 +0200
Message-Id: <20210719144917.690120140@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 603fcfb9d4ec1cad8d66d3bb37f3613afa8a661a ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/sc27xx_fuel_gauge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/sc27xx_fuel_gauge.c b/drivers/power/supply/sc27xx_fuel_gauge.c
index bc8f5bda5762..5e5bcdbf2e69 100644
--- a/drivers/power/supply/sc27xx_fuel_gauge.c
+++ b/drivers/power/supply/sc27xx_fuel_gauge.c
@@ -1215,6 +1215,7 @@ static const struct of_device_id sc27xx_fgu_of_match[] = {
 	{ .compatible = "sprd,sc2731-fgu", },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, sc27xx_fgu_of_match);
 
 static struct platform_driver sc27xx_fgu_driver = {
 	.probe = sc27xx_fgu_probe,
-- 
2.30.2



