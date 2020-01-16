Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5673E13E112
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbgAPQrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:47:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:57484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729961AbgAPQrh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:47:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDE262073A;
        Thu, 16 Jan 2020 16:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193256;
        bh=dhhbX6ij0FJ90/04ldXUev7Hfd1P56CKr8nC90spKuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWLYANuVHV71kOBMubun2ntCMkaiOoRpjantoyXimskyY3drGEFqclLSMM2MTfgji
         FwdLh9FkQsCj0cz21epq2aPRuEWbK9cloZP6pXlG+wKt1KkZsAMahy9PTw8yn3Ku0r
         9ueR9UkrFOEEMZnN3r1kYRHvwCvG55+SszTUEaf8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 056/205] regulator: bd70528: Add MODULE_ALIAS to allow module auto loading
Date:   Thu, 16 Jan 2020 11:40:31 -0500
Message-Id: <20200116164300.6705-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>

[ Upstream commit 55d5f62c3fa005a6a8010363d7d1855909ceefbc ]

The bd70528 regulator driver is probed by MFD driver. Add MODULE_ALIAS
in order to allow udev to load the module when MFD sub-device cell for
regulators is added.

Fixes: 99ea37bd1e7d7 ("regulator: bd70528: Support ROHM BD70528 regulator block")
Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Link: https://lore.kernel.org/r/20191023121452.GA1812@localhost.localdomain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/bd70528-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/bd70528-regulator.c b/drivers/regulator/bd70528-regulator.c
index 6041839ec38c..5bf8a2dc5fe7 100644
--- a/drivers/regulator/bd70528-regulator.c
+++ b/drivers/regulator/bd70528-regulator.c
@@ -285,3 +285,4 @@ module_platform_driver(bd70528_regulator);
 MODULE_AUTHOR("Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>");
 MODULE_DESCRIPTION("BD70528 voltage regulator driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:bd70528-pmic");
-- 
2.20.1

