Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE6C196076
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 22:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbgC0Vdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 17:33:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:35671 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727707AbgC0Vdr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Mar 2020 17:33:47 -0400
IronPort-SDR: ot1KmXH6AQn1lAu9eb8hHERb9rRtZI0jCEkUBs+9Fq6bq0yp3FhMWbWmDBXB+Ax2V91exZ5PZb
 +ABqETwOgzJA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2020 14:33:45 -0700
IronPort-SDR: kk2WtgqAHWcEAYOmfRelHsPufuPCOIUJ1kQK3PygnBi2lOeCNupyF6LMvKg/54u3OGnmQ7RHmZ
 FH9Xszp/jXew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,313,1580803200"; 
   d="scan'208";a="358607259"
Received: from gayuk-dev-mach.sc.intel.com ([10.3.79.171])
  by fmsmga001.fm.intel.com with ESMTP; 27 Mar 2020 14:33:46 -0700
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
Subject: [PATCH v2 2/3] platform/x86: intel-hid: fix: Update Tiger Lake ACPI device ID
Date:   Fri, 27 Mar 2020 14:28:20 -0700
Message-Id: <4c2882dd12d0b3103b89c3ffd2cbee42aa22dd2d.1585343507.git.gayatri.kammela@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585343507.git.gayatri.kammela@intel.com>
References: <cover.1585343507.git.gayatri.kammela@intel.com>
In-Reply-To: <cover.1585343507.git.gayatri.kammela@intel.com>
References: <cover.1585343507.git.gayatri.kammela@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tiger Lake's new unique ACPI device IDs for intel-hid driver is not
valid because of missing 'C' in the ID. Fix the ID by updating it.

After the update, the new ID should now look like
INT1051 --> INTC1051

Fixes: bdd11b654035 ("platform/x86: intel-hid: Add Tiger Lake ACPI device ID")
Cc: 5.6+ <stable@vger.kernel.org> # 5.6+
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Suggested-by: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
---
 drivers/platform/x86/intel-hid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel-hid.c b/drivers/platform/x86/intel-hid.c
index 43d590250228..c0a4696803eb 100644
--- a/drivers/platform/x86/intel-hid.c
+++ b/drivers/platform/x86/intel-hid.c
@@ -19,7 +19,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Alex Hung");
 
 static const struct acpi_device_id intel_hid_ids[] = {
-	{"INT1051", 0},
+	{"INTC1051", 0},
 	{"INT33D5", 0},
 	{"", 0},
 };
-- 
2.17.1

