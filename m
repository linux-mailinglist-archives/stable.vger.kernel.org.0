Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBAF657160
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 01:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiL1AKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 19:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiL1AKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 19:10:09 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64DF640E;
        Tue, 27 Dec 2022 16:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672186208; x=1703722208;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9ghHj+7n5QxlxDJTPpbTtR6onyMlMoEJnX1YQU4DYpA=;
  b=lgAfibZssH1IasVGYcDzjCAoBpYZsmtIlQKjaiCuoTG0N81Z1Sr3Rrkv
   yxMuq1eFrnvyqQCn1O96BpHGA5h3t2Mlos3vCTVhXxukULLkFeRUYtXqQ
   YxUfWARbloYpV+HnrYaELTvV4+OcRmIPPU7DtcyTW4Gd4S/Yy0gl6yREc
   85WjFZ2RoWUcZr/jc1wVyQxYqXlJOHsvM8cfhyEyyj/Jx76iEh2sidgXU
   hanTdohZfyudmgZNFUM7dtdsKxaML5EFdnIOfjTslVw+xY8NALRXxmz1r
   2/YiKwVZFOm0JQ9DU9hvwvWe9JiCoHbqkxQ3/ToufI7FvfzEwQtr6gZlT
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10573"; a="308531228"
X-IronPort-AV: E=Sophos;i="5.96,279,1665471600"; 
   d="scan'208";a="308531228"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2022 16:10:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10573"; a="795492241"
X-IronPort-AV: E=Sophos;i="5.96,279,1665471600"; 
   d="scan'208";a="795492241"
Received: from spandruv-desk.jf.intel.com ([10.54.75.8])
  by fmsmga001.fm.intel.com with ESMTP; 27 Dec 2022 16:10:07 -0800
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     rafael@kernel.org, rui.zhang@intel.com, daniel.lezcano@linaro.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] thermal/drivers/int340x: Add missing attribute for data rate base
Date:   Tue, 27 Dec 2022 16:10:05 -0800
Message-Id: <20221228001005.2690278-1-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 473be51142ad ("thermal: int340x: processor_thermal: Add RFIM
driver")'
added rfi_restriction_data_rate_base string, mmio details and
documentation, but missed adding attribute to sysfs.

Add missing sysfs attribute.

Fixes: 473be51142ad ("thermal: int340x: processor_thermal: Add RFIM driver")
Cc: stable@vger.kernel.org # v5.11+
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 .../thermal/intel/int340x_thermal/processor_thermal_rfim.c    | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
index 8c42e7662033..92ed1213fe37 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
@@ -172,6 +172,7 @@ static const struct attribute_group fivr_attribute_group = {
 RFIM_SHOW(rfi_restriction_run_busy, 1)
 RFIM_SHOW(rfi_restriction_err_code, 1)
 RFIM_SHOW(rfi_restriction_data_rate, 1)
+RFIM_SHOW(rfi_restriction_data_rate_base, 1)
 RFIM_SHOW(ddr_data_rate_point_0, 1)
 RFIM_SHOW(ddr_data_rate_point_1, 1)
 RFIM_SHOW(ddr_data_rate_point_2, 1)
@@ -181,11 +182,13 @@ RFIM_SHOW(rfi_disable, 1)
 RFIM_STORE(rfi_restriction_run_busy, 1)
 RFIM_STORE(rfi_restriction_err_code, 1)
 RFIM_STORE(rfi_restriction_data_rate, 1)
+RFIM_STORE(rfi_restriction_data_rate_base, 1)
 RFIM_STORE(rfi_disable, 1)
 
 static DEVICE_ATTR_RW(rfi_restriction_run_busy);
 static DEVICE_ATTR_RW(rfi_restriction_err_code);
 static DEVICE_ATTR_RW(rfi_restriction_data_rate);
+static DEVICE_ATTR_RW(rfi_restriction_data_rate_base);
 static DEVICE_ATTR_RO(ddr_data_rate_point_0);
 static DEVICE_ATTR_RO(ddr_data_rate_point_1);
 static DEVICE_ATTR_RO(ddr_data_rate_point_2);
@@ -248,6 +251,7 @@ static struct attribute *dvfs_attrs[] = {
 	&dev_attr_rfi_restriction_run_busy.attr,
 	&dev_attr_rfi_restriction_err_code.attr,
 	&dev_attr_rfi_restriction_data_rate.attr,
+	&dev_attr_rfi_restriction_data_rate_base.attr,
 	&dev_attr_ddr_data_rate_point_0.attr,
 	&dev_attr_ddr_data_rate_point_1.attr,
 	&dev_attr_ddr_data_rate_point_2.attr,
-- 
2.31.1

