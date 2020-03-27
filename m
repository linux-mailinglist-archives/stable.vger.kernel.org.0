Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9D0B196080
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 22:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgC0Vdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 17:33:51 -0400
Received: from mga06.intel.com ([134.134.136.31]:35671 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727752AbgC0Vds (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Mar 2020 17:33:48 -0400
IronPort-SDR: Cj/snYa5YIDwey0gUFAlHmUV8eOkC7dKE70tG5LsVGalEmajOv5K/TlpiCSg54mgV4hx4qS4m/
 K5igVRWfI85g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2020 14:33:46 -0700
IronPort-SDR: QV0idHdOO3eUSXMDTdPL7gJ86uFFyQ68HPZPSYWopg9BGWCweS8u+sCcnAAyymJP3dRJYMC520
 HtWcyoifaPWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,313,1580803200"; 
   d="scan'208";a="358607264"
Received: from gayuk-dev-mach.sc.intel.com ([10.3.79.171])
  by fmsmga001.fm.intel.com with ESMTP; 27 Mar 2020 14:33:47 -0700
From:   Gayatri Kammela <gayatri.kammela@intel.com>
To:     linux-pm@vger.kernel.org
Cc:     platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        lenb@kernel.org, dvhart@infradead.org, alex.hung@canonical.com,
        rui.zhang@intel.com, daniel.lezcano@linaro.org,
        amit.kucheria@verdurent.com, mika.westerberg@intel.com,
        peterz@infradead.org, charles.d.prestopine@intel.com,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        "5 . 6+" <stable@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v2 3/3] thermal: int340x_thermal: fix: Update Tiger Lake ACPI device IDs
Date:   Fri, 27 Mar 2020 14:28:21 -0700
Message-Id: <24125c0777458384f5b4449cafb5115b9985e3bd.1585343507.git.gayatri.kammela@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585343507.git.gayatri.kammela@intel.com>
References: <cover.1585343507.git.gayatri.kammela@intel.com>
In-Reply-To: <cover.1585343507.git.gayatri.kammela@intel.com>
References: <cover.1585343507.git.gayatri.kammela@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tiger Lake's new unique ACPI device IDs for Intel thermal driver are not
valid because of missing 'C' in the IDs. Fix the IDs by updating them.

After the update, the new IDs should now look like
INT1040 --> INTC1040
INT1043 --> INTC1043

Fixes: 9b1b5535dfc9 ("thermal: int340x_thermal: Add Tiger Lake ACPI device IDs")
Cc: 5.6+ <stable@vger.kernel.org> # 5.6+
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Suggested-by: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
---
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 2 +-
 drivers/thermal/intel/int340x_thermal/int3403_thermal.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index efae0c02d898..71a9877b85a5 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -369,7 +369,7 @@ static int int3400_thermal_remove(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id int3400_thermal_match[] = {
-	{"INT1040", 0},
+	{"INTC1040", 0},
 	{"INT3400", 0},
 	{}
 };
diff --git a/drivers/thermal/intel/int340x_thermal/int3403_thermal.c b/drivers/thermal/intel/int340x_thermal/int3403_thermal.c
index aeece1e136a5..3849d5869609 100644
--- a/drivers/thermal/intel/int340x_thermal/int3403_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3403_thermal.c
@@ -282,7 +282,7 @@ static int int3403_remove(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id int3403_device_ids[] = {
-	{"INT1043", 0},
+	{"INTC1043", 0},
 	{"INT3403", 0},
 	{"", 0},
 };
-- 
2.17.1

