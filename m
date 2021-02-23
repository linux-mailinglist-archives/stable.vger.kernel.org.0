Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4B9322BCA
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 14:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhBWN61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 08:58:27 -0500
Received: from mga17.intel.com ([192.55.52.151]:9324 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231289AbhBWN6Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 08:58:25 -0500
IronPort-SDR: 08Yeid8KigwxNWulzem8t+rUKxG2iMBKDHRDwLZvd/4O9Cb8+U0JFjcLbUVAGksz6wKL4ADxuS
 WS/63ZQmzCRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9903"; a="164654205"
X-IronPort-AV: E=Sophos;i="5.81,200,1610438400"; 
   d="scan'208";a="164654205"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2021 05:56:40 -0800
IronPort-SDR: /XFIQ9IV8nihQncWL7YNeoblHYQW0/8NDZLO6lrJCaU3fGfEe1dXJxEa6stv2jYGEPLAkE4krx
 lUjUUwj3vJAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,200,1610438400"; 
   d="scan'208";a="423631898"
Received: from marshy.an.intel.com ([10.122.105.143])
  by fmsmga004.fm.intel.com with ESMTP; 23 Feb 2021 05:56:39 -0800
From:   richard.gong@linux.intel.com
To:     gregkh@linuxfoundation.org
Cc:     mdf@kernel.org, trix@redhat.com, linux-kernel@vger.kernel.org,
        Richard Gong <richard.gong@intel.com>,
        "# 5 . 9+" <stable@vger.kernel.org>
Subject: [PATCHv3] firmware: stratix10-svc: reset COMMAND_RECONFIG_FLAG_PARTIAL to 0
Date:   Tue, 23 Feb 2021 08:15:59 -0600
Message-Id: <1614089759-12658-1-git-send-email-richard.gong@linux.intel.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Gong <richard.gong@intel.com>

Clean up COMMAND_RECONFIG_FLAG_PARTIAL flag by resetting it to 0, which
aligns with the firmware settings.

Cc: <stable@vger.kernel.org> # 5.9+
Fixes: 36847f9e3e56 ("firmware: stratix10-svc: correct reconfig flag and timeout values")
Signed-off-by: Richard Gong <richard.gong@intel.com>
---
v3: correct the missing item in the Fixes subject line
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

