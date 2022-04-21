Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E0550A533
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 18:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiDUQ1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 12:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390695AbiDUQZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 12:25:16 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3383D21E39
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 09:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650558146; x=1682094146;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Dd3U04lBJYe22WeEnN5HOe73I8xIok7aZHehpXnvuEw=;
  b=Waw8XQ8Tko+JWD3bhQBsQFtYQ/mn2u+ADKSNrIZ0DrxOUzdGbmIil+La
   Ltbqm9bWthk0bsEckZjv8IJcFXtZ1BUmFCexwQsHMrZ5Jgar3OHV/P2I3
   5cv77tPFyLCAp5hPbwzrHIk8k0RUclIh/1HMljnvYBg8zNmM7yLV/imMn
   a/wwa5Z/MvJL0oHlXjKKlxUd/5GaZQzs8d6cCHvrubwEntfYRd6OtB13z
   gZhN3rvR2fmJfbNGMSNW9fLQPx0MLwY5AYKaDqEAaAGzBhQtWvUuMc7d5
   GNG+YvqSRsEcqE8GjACf5s4vYgz4pTe1ekX9VRn1OIZHjesc32rQwodIv
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="251724726"
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="251724726"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 09:22:25 -0700
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="530375250"
Received: from ideak-desk.fi.intel.com ([10.237.72.175])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 09:22:24 -0700
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915: Fix SEL_FETCH_PLANE_*(PIPE_B+) register addresses
Date:   Thu, 21 Apr 2022 19:22:21 +0300
Message-Id: <20220421162221.2261895-1-imre.deak@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix typo in the _SEL_FETCH_PLANE_BASE_1_B register base address.

Fixes: a5523e2ff074a5 ("drm/i915: Add PSR2 selective fetch registers")
References: https://gitlab.freedesktop.org/drm/intel/-/issues/5400
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: <stable@vger.kernel.org> # v5.9+
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/i915/i915_reg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 04d86cb6224fc..0ca6517b4595a 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -5172,7 +5172,7 @@
 #define _SEL_FETCH_PLANE_BASE_6_A		0x70940
 #define _SEL_FETCH_PLANE_BASE_7_A		0x70960
 #define _SEL_FETCH_PLANE_BASE_CUR_A		0x70880
-#define _SEL_FETCH_PLANE_BASE_1_B		0x70990
+#define _SEL_FETCH_PLANE_BASE_1_B		0x71890
 
 #define _SEL_FETCH_PLANE_BASE_A(plane) _PICK(plane, \
 					     _SEL_FETCH_PLANE_BASE_1_A, \
-- 
2.30.2

