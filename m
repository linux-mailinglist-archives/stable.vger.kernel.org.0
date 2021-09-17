Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C80D40EF8E
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243500AbhIQCgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242848AbhIQCgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:36:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9CC561164;
        Fri, 17 Sep 2021 02:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846087;
        bh=lERD2q2Bl3YqPIJL9b6mEqEa7dG5EZcffThjaffYEHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F6pGHbj6WP+pU4111wlf0E+Cusyi1etq8PNyjty3POridmpx3zBJP3l7nFCgxRfBE
         JmqWEd5+aJEc3wGJdGHtOiIShIsAZPwAbNBpEqEVmfNPMwyMFBpj6/pnXuOUA0kxg2
         4B93shvAddDP0q443Yu/Mo1//TFi75vheSFMVmPJsjIhqqe4gmPkX2Fg3demYoLuyK
         CJ/XKBVySQoSGweH6DNgdiOeIcKf6yqzUOPdtt0gwTnbO3FM4WBCpt8JiJib7g49gq
         BlcpHoLnO76dHUMnUKRLPsT6EWshxzlWpykiw35LDzylF32U4eFUNd966iJJSCp6k8
         85hID9vAQKh9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu-Tung Chang <mtwget@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, a.zummo@towertech.it,
        linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 7/8] rtc: rx8010: select REGMAP_I2C
Date:   Thu, 16 Sep 2021 22:34:32 -0400
Message-Id: <20210917023437.816574-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023437.816574-1-sashal@kernel.org>
References: <20210917023437.816574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu-Tung Chang <mtwget@gmail.com>

[ Upstream commit 0c45d3e24ef3d3d87c5e0077b8f38d1372af7176 ]

The rtc-rx8010 uses the I2C regmap but doesn't select it in Kconfig so
depending on the configuration the build may fail. Fix it.

Signed-off-by: Yu-Tung Chang <mtwget@gmail.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210830052532.40356-1-mtwget@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 33e4ecd6c665..54cf5ec8f401 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -624,6 +624,7 @@ config RTC_DRV_FM3130
 
 config RTC_DRV_RX8010
 	tristate "Epson RX8010SJ"
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for the Epson RX8010SJ RTC
 	  chip.
-- 
2.30.2

