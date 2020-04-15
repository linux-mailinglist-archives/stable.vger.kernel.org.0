Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C531AA29D
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505647AbgDOM62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897172AbgDOLgo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:36:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A290E20775;
        Wed, 15 Apr 2020 11:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950598;
        bh=SkYy+KuoP2SP8ufyYCYQvRtjgVmVX+j4n9Gx1vxC/lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zb5ngSV3/PjQTGcx/1HFKXN+Zhx8/wD+Hi+YvroKk2YFcWKF1/JtxlGbg9qumCYOr
         jCogursQK+jUsnTgHofbf0KX8YiWS6JXhIatfM19hGPawHC/6GeacDJIC6HZysIFPY
         u6zrkOOyiYt+slKIdecXYThh/mtMS2pCA+xS6ykE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gayatri Kammela <gayatri.kammela@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 094/129] ACPI: Update Tiger Lake ACPI device IDs
Date:   Wed, 15 Apr 2020 07:34:09 -0400
Message-Id: <20200415113445.11881-94-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gayatri Kammela <gayatri.kammela@intel.com>

[ Upstream commit b62c770fee699a137359e1f1da9bf14a7f348567 ]

Tiger Lake's new unique ACPI device IDs for DPTF and fan drivers are not
valid as the IDs are missing 'C'. Fix the IDs by updating them.

After the update, the new IDs should now look like
INT1047 --> INTC1047
INT1040 --> INTC1040
INT1043 --> INTC1043
INT1044 --> INTC1044

Fixes: 55cfe6a5c582 ("ACPI: DPTF: Add Tiger Lake ACPI device IDs")
Fixes: c248dfe7e0ca ("ACPI: fan: Add Tiger Lake ACPI device ID")
Suggested-by: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/device_pm.c            | 2 +-
 drivers/acpi/dptf/dptf_power.c      | 2 +-
 drivers/acpi/dptf/int340x_thermal.c | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index b64c62bfcea56..b2263ec67b432 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -1321,8 +1321,8 @@ int acpi_dev_pm_attach(struct device *dev, bool power_on)
 	 */
 	static const struct acpi_device_id special_pm_ids[] = {
 		{"PNP0C0B", }, /* Generic ACPI fan */
-		{"INT1044", }, /* Fan for Tiger Lake generation */
 		{"INT3404", }, /* Fan */
+		{"INTC1044", }, /* Fan for Tiger Lake generation */
 		{}
 	};
 	struct acpi_device *adev = ACPI_COMPANION(dev);
diff --git a/drivers/acpi/dptf/dptf_power.c b/drivers/acpi/dptf/dptf_power.c
index 387f27ef3368b..e4e8b75d39f09 100644
--- a/drivers/acpi/dptf/dptf_power.c
+++ b/drivers/acpi/dptf/dptf_power.c
@@ -97,8 +97,8 @@ static int dptf_power_remove(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id int3407_device_ids[] = {
-	{"INT1047", 0},
 	{"INT3407", 0},
+	{"INTC1047", 0},
 	{"", 0},
 };
 MODULE_DEVICE_TABLE(acpi, int3407_device_ids);
diff --git a/drivers/acpi/dptf/int340x_thermal.c b/drivers/acpi/dptf/int340x_thermal.c
index 1ec7b6900662c..bc71a6a603345 100644
--- a/drivers/acpi/dptf/int340x_thermal.c
+++ b/drivers/acpi/dptf/int340x_thermal.c
@@ -13,10 +13,6 @@
 
 #define INT3401_DEVICE 0X01
 static const struct acpi_device_id int340x_thermal_device_ids[] = {
-	{"INT1040"},
-	{"INT1043"},
-	{"INT1044"},
-	{"INT1047"},
 	{"INT3400"},
 	{"INT3401", INT3401_DEVICE},
 	{"INT3402"},
@@ -28,6 +24,10 @@ static const struct acpi_device_id int340x_thermal_device_ids[] = {
 	{"INT3409"},
 	{"INT340A"},
 	{"INT340B"},
+	{"INTC1040"},
+	{"INTC1043"},
+	{"INTC1044"},
+	{"INTC1047"},
 	{""},
 };
 
-- 
2.20.1

