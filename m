Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B707B1AA345
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505956AbgDONGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:06:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897102AbgDOLgB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:36:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 288502076D;
        Wed, 15 Apr 2020 11:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950561;
        bh=VQEL4zYdQmOL2lvORooDfGkshP55G+pqZwAq3XpfnQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJ95WQwd7d4Ir6vhQHTcwmrkeIResCnzFbmL8O3g92hQpg66vt57hzCExbaGQfdrj
         /pfAJzzaV/OBB6Dnp3WuoV3zX1lm5q4tHnkRcm5HLQxvt19IScSIuGrP++XskmP7hZ
         61kVFEu5fA1tyzU44BiuQ484h/NP0VUivZC+LoY8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gayatri Kammela <gayatri.kammela@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 065/129] platform/x86: intel-hid: fix: Update Tiger Lake ACPI device ID
Date:   Wed, 15 Apr 2020 07:33:40 -0400
Message-Id: <20200415113445.11881-65-sashal@kernel.org>
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

[ Upstream commit d5764dc597467664a1a70ab66a2314a011aeccd4 ]

Tiger Lake's new unique ACPI device IDs for intel-hid driver is not
valid because of missing 'C' in the ID. Fix the ID by updating it.

After the update, the new ID should now look like
INT1051 --> INTC1051

Fixes: bdd11b654035 ("platform/x86: intel-hid: Add Tiger Lake ACPI device ID")
Suggested-by: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-hid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel-hid.c b/drivers/platform/x86/intel-hid.c
index 43d590250228c..9c0e6e0fabdff 100644
--- a/drivers/platform/x86/intel-hid.c
+++ b/drivers/platform/x86/intel-hid.c
@@ -19,8 +19,8 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Alex Hung");
 
 static const struct acpi_device_id intel_hid_ids[] = {
-	{"INT1051", 0},
 	{"INT33D5", 0},
+	{"INTC1051", 0},
 	{"", 0},
 };
 
-- 
2.20.1

