Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC06C4989FF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245653AbiAXS7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344293AbiAXS4n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:56:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AD7C0617B9;
        Mon, 24 Jan 2022 10:54:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CD81B81233;
        Mon, 24 Jan 2022 18:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9055CC340E7;
        Mon, 24 Jan 2022 18:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050450;
        bh=acYIa2DHDSiyTToTyPnjGfQq3nXl/LCD7YZBPa9Qvbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ed95+sCVgf3u0JemdpE3qG10G7OtOXzPxG+6vIlHVes4Mi7aRXeBLeXmGDFpAFdC/
         5knPvhW9VgO4KK0f1BnKqdQI/LEHCKXyGP1IsEGVpeXabfE1BZphmHybuFfBySjEwZ
         vPXzz3zuw6RBrdLu2liK6a/F9osY4rmMYJ75ThHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wolfram Sang <wsa@kernel.org>,
        Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 093/114] i2c: designware-pci: Fix to change data types of hcnt and lcnt parameters
Date:   Mon, 24 Jan 2022 19:43:08 +0100
Message-Id: <20220124183929.981431091@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



