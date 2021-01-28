Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7ED30799C
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 16:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhA1PYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 10:24:41 -0500
Received: from mga17.intel.com ([192.55.52.151]:51062 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231487AbhA1PXN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 10:23:13 -0500
IronPort-SDR: JYNNfPVLK7rJmK54oeD7K9FJ85zWoPZmfg85Ove/Kkq+k1s1KazL6+OTcJyD5o4IQh71+ME0z7
 Kp5psLnIIFsA==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="160021940"
X-IronPort-AV: E=Sophos;i="5.79,382,1602572400"; 
   d="scan'208";a="160021940"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 07:21:26 -0800
IronPort-SDR: oA41dCjYaX7ZrF3VFZ2/pAM/g6mqxi2nAYGAhIHD7WZdRK9zcLsZNwVkhoR/K2+vN11w0PyJJM
 BGBNhw/M1LtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,382,1602572400"; 
   d="scan'208";a="354211355"
Received: from marshy.an.intel.com ([10.122.105.143])
  by orsmga003.jf.intel.com with ESMTP; 28 Jan 2021 07:21:26 -0800
From:   richard.gong@linux.intel.com
To:     gregkh@linuxfoundation.org
Cc:     mdf@kernel.org, trix@redhat.com, linux-kernel@vger.kernel.org,
        Richard Gong <richard.gong@intel.com>,
        "# 5 . 9+" <stable@vger.kernel.org>
Subject: [PATCHv2] firmware: stratix10-svc: reset COMMAND_RECONFIG_FLAG_PARTIAL to 0
Date:   Thu, 28 Jan 2021 09:38:12 -0600
Message-Id: <1611848292-17882-1-git-send-email-richard.gong@linux.intel.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Gong <richard.gong@intel.com>

Clean up COMMAND_RECONFIG_FLAG_PARTIAL flag by resetting it to 0, which
aligns with the firmware settings.

Cc: <stable@vger.kernel.org> # 5.9+
Fixes: 36847f9e3e56 ("firmware: correct reconfig flag and timeout values")
Signed-off-by: Richard Gong <richard.gong@intel.com>
---
v2: add tag Cc: <stable@vger.kernel.org> # 5.9+
    add 'Fixes: ... ' line in the comment
---
 include/linux/firmware/intel/stratix10-svc-client.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/firmware/intel/stratix10-svc-client.h b/include/linux/firmware/intel/stratix10-svc-client.h
index a93d859..f843c6a 100644
--- a/include/linux/firmware/intel/stratix10-svc-client.h
+++ b/include/linux/firmware/intel/stratix10-svc-client.h
@@ -56,7 +56,7 @@
  * COMMAND_RECONFIG_FLAG_PARTIAL:
  * Set to FPGA configuration type (full or partial).
  */
-#define COMMAND_RECONFIG_FLAG_PARTIAL	1
+#define COMMAND_RECONFIG_FLAG_PARTIAL	0
 
 /**
  * Timeout settings for service clients:
-- 
2.7.4

