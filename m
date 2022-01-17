Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571E9490E32
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242686AbiAQRHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:07:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52996 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242671AbiAQRFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:05:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FA93B810A2;
        Mon, 17 Jan 2022 17:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CE5C36AEC;
        Mon, 17 Jan 2022 17:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439139;
        bh=esUmQol+H/4d9Hgo8Aa5Ag4uakS/BpjuUbGvpirtm4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZBq7eRcabCWQchi1HED75c9NJXYBS27W0nuG3q3P5OrxIJDz9CO1fkXEfAeKWy3p
         zrBEWTqQbpO8UzPbujwAw0/AggKlM2K5dgwVOUepaP0oWPqmcnKJyeGPcOix4QKdag
         4ThOgr80lqsl5GCaweLRRqTgsUHDaYXIfO26BPTmiDc9Ru9SrKoc745w/joQmlMXKh
         b+Rs5tud5ruRVPZmGda9dZKFwgRmYAXw4bDs+bksq7LriLzApCv3cIPNQhaEkdHSMD
         SeEyxK1ztlsuS0NO1jMnToexyq/JRxwnYGCIpUP2GWmvfel1o2iYfTm5mgjAXfwqBr
         asqbKA4NF497g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 18/21] i2c: designware-pci: Fix to change data types of hcnt and lcnt parameters
Date:   Mon, 17 Jan 2022 12:04:50 -0500
Message-Id: <20220117170454.1472347-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170454.1472347-1-sashal@kernel.org>
References: <20220117170454.1472347-1-sashal@kernel.org>
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
index 05b35ac33ce33..735326e5eb8cf 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -37,10 +37,10 @@ enum dw_pci_ctl_id_t {
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

