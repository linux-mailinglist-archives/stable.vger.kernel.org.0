Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F30F490EA9
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243445AbiAQRL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:11:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53484 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243041AbiAQRIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:08:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98650B81163;
        Mon, 17 Jan 2022 17:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7536CC36B03;
        Mon, 17 Jan 2022 17:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439299;
        bh=acYIa2DHDSiyTToTyPnjGfQq3nXl/LCD7YZBPa9Qvbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXonZqlQJ68Q5XI3BKAxPgyvjfCS4oG1uxBp40XlSZlwEFyI2ZCYWVcZD9FzUzAFJ
         YbpbxnKM0LDxUdlWC1X/I7sWGgV91PqUrMkncXJPdFI6yKvTbsLjtwHL9UPEb6L7zw
         tBznVuZ993awGE2Z+91g40EngyUxRVWsBtOB8GsTSWsqkBkPWNhWGpVtqbWEI2rta7
         Ae3cML0fsbt7ftRZMiPtc8pBb7T7o2nOk3EuiWk2CvXkTLhmoptsC2So4QtnN1ntLM
         Xpab9gusSXz/168XPEiKt/LaSNUXuiBaULhYc3YSDFWuCSgG24JyujERXe+QOyJtc7
         AMBv14zMKWuzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 10/12] i2c: designware-pci: Fix to change data types of hcnt and lcnt parameters
Date:   Mon, 17 Jan 2022 12:07:54 -0500
Message-Id: <20220117170757.1473318-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170757.1473318-1-sashal@kernel.org>
References: <20220117170757.1473318-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>

[ Upstream commit d52097010078c1844348dc0e467305e5f90fd317 ]

The data type of hcnt and lcnt in the struct dw_i2c_dev is of type u16.
It's better to have same data type in struct dw_scl_sda_cfg as well.

Reported-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index 1543d35d228df..6831883741215 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -53,10 +53,10 @@ enum dw_pci_ctl_id_t {
 };
 
 struct dw_scl_sda_cfg {
-	u32 ss_hcnt;
-	u32 fs_hcnt;
-	u32 ss_lcnt;
-	u32 fs_lcnt;
+	u16 ss_hcnt;
+	u16 fs_hcnt;
+	u16 ss_lcnt;
+	u16 fs_lcnt;
 	u32 sda_hold;
 };
 
-- 
2.34.1

