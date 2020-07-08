Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E019F218C08
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 17:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730447AbgGHPla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 11:41:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730442AbgGHPla (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 11:41:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6686A20836;
        Wed,  8 Jul 2020 15:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594222890;
        bh=oQm2Jqtg4xH78lirey/DSRUlvvhxX/QamPy7sFyu/tE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxVPRiXyUpqy8XWpybm9Uk4tUnusNEL/h/YUYM9F8mh+fG/2By0s4//YWPkmk83uh
         WRER9olIDLn+ufi0tU63BJfppSSYMS+80L69CSsVMU9SOxoEIQajmUEPcWsWTdsX3I
         0S9ivGEF8NuRtlnFIdrzqEbsXrk7KLj68d2ieEYI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 10/30] ACPI: DPTF: Add battery participant for TigerLake
Date:   Wed,  8 Jul 2020 11:40:56 -0400
Message-Id: <20200708154116.3199728-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708154116.3199728-1-sashal@kernel.org>
References: <20200708154116.3199728-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 1e05daca83bb42cde569f75f3bd7c8828b1ef30f ]

Add DPTF battery participant ACPI ID for platforms based on the Intel
TigerLake SoC.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
[ rjw: Changelog ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/dptf/dptf_power.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/dptf/dptf_power.c b/drivers/acpi/dptf/dptf_power.c
index e4e8b75d39f09..8b42f529047e9 100644
--- a/drivers/acpi/dptf/dptf_power.c
+++ b/drivers/acpi/dptf/dptf_power.c
@@ -99,6 +99,7 @@ static int dptf_power_remove(struct platform_device *pdev)
 static const struct acpi_device_id int3407_device_ids[] = {
 	{"INT3407", 0},
 	{"INTC1047", 0},
+	{"INTC1050", 0},
 	{"", 0},
 };
 MODULE_DEVICE_TABLE(acpi, int3407_device_ids);
-- 
2.25.1

