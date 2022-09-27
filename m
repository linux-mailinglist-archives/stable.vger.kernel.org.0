Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695CB5EC8A3
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 17:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbiI0Pxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 11:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiI0Px2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 11:53:28 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A577EF0BD;
        Tue, 27 Sep 2022 08:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664294005; x=1695830005;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IaAGbY0JsRoUJU8GIoSz2tvxLIx08Rf5u8xC9fKhoqo=;
  b=k1UgPOYksUnVJ1/5phYZx8s7WHNAIDYH5VGXgUu2TuqIHP+Fx83XZSBW
   0GEfq0tHzS2fV+hwOMZTiK7HyssajkJDcW71xaMAsW30degU5q9aubbDy
   kggpDHhd4bVuXhI65Qjz8E0VIyF3pYmCtIxrJztzYaACEqTncbAr/6rf9
   Stm7vKajL4MiC7gQe2Ecaprc2w+N2WjcIfN3bkJD3FDXYVd9jiSy9DgdL
   bNdeWsnPfyaxcq10wBIqSTYE4UxfWxKrPDY//G4fNYDTjhQALzN4QUk6D
   lWLXZFH8UIjmAg8OjnxOX8Nkg8guBAgAoVLF56OErdmKOC2bbuwlzwB7l
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="365395776"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="365395776"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 08:53:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="950335523"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="950335523"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 27 Sep 2022 08:53:22 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id E290FF7; Tue, 27 Sep 2022 18:53:40 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Felipe Balbi <balbi@kernel.org>, Ferry Toth <fntoth@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/2] Revert "USB: fixup for merge issue with "usb: dwc3: Don't switch OTG -> peripheral if extcon is present""
Date:   Tue, 27 Sep 2022 18:53:31 +0300
Message-Id: <20220927155332.10762-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
References: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 8bd6b8c4b1009d7d2662138d6bdc6fe58a9274c5.

Prerequisite revert for the reverting of the original commit 0f0101719138.

Fixes: 8bd6b8c4b100 ("USB: fixup for merge issue with "usb: dwc3: Don't switch OTG -> peripheral if extcon is present"")
Fixes: 0f0101719138 ("usb: dwc3: Don't switch OTG -> peripheral if extcon is present")
Reported-by: Ferry Toth <fntoth@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Ferry Toth <fntoth@gmail.com> # for Merrifield
---
 drivers/usb/dwc3/core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index d0237b30c9be..c2b463469d51 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1684,8 +1684,13 @@ static struct extcon_dev *dwc3_get_extcon(struct dwc3 *dwc)
 	 * This device property is for kernel internal use only and
 	 * is expected to be set by the glue code.
 	 */
-	if (device_property_read_string(dev, "linux,extcon-name", &name) == 0)
-		return extcon_get_extcon_dev(name);
+	if (device_property_read_string(dev, "linux,extcon-name", &name) == 0) {
+		edev = extcon_get_extcon_dev(name);
+		if (!edev)
+			return ERR_PTR(-EPROBE_DEFER);
+
+		return edev;
+	}
 
 	/*
 	 * Try to get an extcon device from the USB PHY controller's "port"
-- 
2.35.1

