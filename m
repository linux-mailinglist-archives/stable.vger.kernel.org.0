Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F008F3CDF78
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345319AbhGSPKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241461AbhGSPI5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:08:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B2576128E;
        Mon, 19 Jul 2021 15:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709717;
        bh=31Q2SxNVO6mzsD2YnuunmRyukAVykWhnb+sZHX1XplY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3452vKxwORV46DBxLDA70a+rNWSLbuwRB8zx0pjQVxjbvLEnGj86rml+FWFM0A2x
         ceaCLGOoBqH+wPKvkYyhtsOaEiaXCWl4zihLkOq5nQh3MF26TlFhaKp1u30apkJSiH
         G4na/72vAO8Z6d3NRj/qaC+vbkNHYW7W+R+3GHqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/149] power: supply: sc2731_charger: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:52:58 +0200
Message-Id: <20210719144917.896605209@linuxfoundation.org>
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

[ Upstream commit 2aac79d14d76879c8e307820b31876e315b1b242 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/sc2731_charger.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/sc2731_charger.c b/drivers/power/supply/sc2731_charger.c
index 335cb857ef30..288b79836c13 100644
--- a/drivers/power/supply/sc2731_charger.c
+++ b/drivers/power/supply/sc2731_charger.c
@@ -524,6 +524,7 @@ static const struct of_device_id sc2731_charger_of_match[] = {
 	{ .compatible = "sprd,sc2731-charger", },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, sc2731_charger_of_match);
 
 static struct platform_driver sc2731_charger_driver = {
 	.driver = {
-- 
2.30.2



