Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA0D4FA4A8
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfKMBzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:55:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:47480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729224AbfKMBzn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 696AE22470;
        Wed, 13 Nov 2019 01:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610143;
        bh=aAogisomJAHBocZEBIP1KMLQHK4sE4B/orKaVsSdVfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQ2sOKTNxveslVe53O5CgPsuTFrIDy8G2IEl0g+rCqXoZWxDhHm8hFWzr9XZqTasb
         Z9ezEfUAWiebcqXIYkK/a/RiBNlYG1Q1m0GvrAznGHlIcTwPxfRVSVwJTKhEUt9v2g
         MIE1Ulyhu1BKA2l24ih28j/BDArHPDhUx5pqLD5o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 189/209] hwmon: (nct6775) Fix names of DIMM temperature sources
Date:   Tue, 12 Nov 2019 20:50:05 -0500
Message-Id: <20191113015025.9685-189-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 3be8c9d103534fadc72b3e174613f37aa19fa423 ]

For NCT6795D and NCT6796D, the DIMM temperature sources are named
"Agent[01] Dimm [01]" per datasheet. Match names in datasheets to
avoid confusion.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/nct6775.c b/drivers/hwmon/nct6775.c
index eba692cddbdee..559101a1c1367 100644
--- a/drivers/hwmon/nct6775.c
+++ b/drivers/hwmon/nct6775.c
@@ -704,10 +704,10 @@ static const char *const nct6795_temp_label[] = {
 	"PCH_CHIP_TEMP",
 	"PCH_CPU_TEMP",
 	"PCH_MCH_TEMP",
-	"PCH_DIM0_TEMP",
-	"PCH_DIM1_TEMP",
-	"PCH_DIM2_TEMP",
-	"PCH_DIM3_TEMP",
+	"Agent0 Dimm0",
+	"Agent0 Dimm1",
+	"Agent1 Dimm0",
+	"Agent1 Dimm1",
 	"BYTE_TEMP0",
 	"BYTE_TEMP1",
 	"PECI Agent 0 Calibration",
@@ -742,10 +742,10 @@ static const char *const nct6796_temp_label[] = {
 	"PCH_CHIP_TEMP",
 	"PCH_CPU_TEMP",
 	"PCH_MCH_TEMP",
-	"PCH_DIM0_TEMP",
-	"PCH_DIM1_TEMP",
-	"PCH_DIM2_TEMP",
-	"PCH_DIM3_TEMP",
+	"Agent0 Dimm0",
+	"Agent0 Dimm1",
+	"Agent1 Dimm0",
+	"Agent1 Dimm1",
 	"BYTE_TEMP0",
 	"BYTE_TEMP1",
 	"PECI Agent 0 Calibration",
-- 
2.20.1

