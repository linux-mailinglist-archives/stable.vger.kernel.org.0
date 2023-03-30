Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E81C6D0904
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 17:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbjC3PD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 11:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbjC3PD2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 11:03:28 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310DF83E7
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 08:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680188607; x=1711724607;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EB4IcROu/Bbudj/12rNTSJg1SQU6r9r2SB+TIfUZgos=;
  b=IiGq9e88pwA4DUOYzQzjRHRSuK21JUZgYnvx8dP6ppXUzAF+7S+fp3K1
   z33hcVWEigCuJykB2W/036LXm5wv9Ft+6EndMhg7LmCQABf9bXaNuH5xw
   Frgm8X8msPdODcEpQX8pLV/YomekhjDPeIuuBjrDKEPdY05A6IIZqJz84
   ogNeoknGB/+/DdoxXNGIup4eWxSuTs6O1nley8XDYR564+AjDMKBMJG5t
   h4jFWOpYrRe02m7i+ff7OCE4JJ8VyZEiaD6SLkgfZWszwLTHPaa55Tdtb
   7E+te2ZCfct0VucJrZNNHOJreyE/20KYKAjatkh7H+WDfVAa0ScWbDHfw
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="329707355"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="329707355"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 08:02:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="930750506"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="930750506"
Received: from chaitanya.iind.intel.com (HELO DUT-2a59.iind.intel.com) ([10.190.239.113])
  by fmsmga006.fm.intel.com with ESMTP; 30 Mar 2023 08:02:06 -0700
From:   Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     uma.shankar@intel.com,
        Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/color: Fix typo for Plane CSC indexes
Date:   Thu, 30 Mar 2023 20:31:04 +0530
Message-Id: <20230330150104.2923519-1-chaitanya.kumar.borah@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=AC_FROM_MANY_DOTS,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Replace _PLANE_INPUT_CSC_RY_GY_2_* with _PLANE_CSC_RY_GY_2_*
for Plane CSC

Fixes: 6eba56f64d5d ("drm/i915/pxp: black pixels on pxp disabled")

Cc: <stable@vger.kernel.org>

Signed-off-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
---
 drivers/gpu/drm/i915/i915_reg.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 8e4aca888b7a..85885b01e6ac 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -7496,8 +7496,8 @@ enum skl_power_gate {
 
 #define _PLANE_CSC_RY_GY_1(pipe)	_PIPE(pipe, _PLANE_CSC_RY_GY_1_A, \
 					      _PLANE_CSC_RY_GY_1_B)
-#define _PLANE_CSC_RY_GY_2(pipe)	_PIPE(pipe, _PLANE_INPUT_CSC_RY_GY_2_A, \
-					      _PLANE_INPUT_CSC_RY_GY_2_B)
+#define _PLANE_CSC_RY_GY_2(pipe)	_PIPE(pipe, _PLANE_CSC_RY_GY_2_A, \
+					      _PLANE_CSC_RY_GY_2_B)
 #define PLANE_CSC_COEFF(pipe, plane, index)	_MMIO_PLANE(plane, \
 							    _PLANE_CSC_RY_GY_1(pipe) +  (index) * 4, \
 							    _PLANE_CSC_RY_GY_2(pipe) + (index) * 4)
-- 
2.25.1

