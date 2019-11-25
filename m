Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2B6108BF5
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 11:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbfKYKm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 05:42:56 -0500
Received: from mail.fireflyinternet.com ([109.228.58.192]:60419 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727516AbfKYKm4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 05:42:56 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 19327691-1500050 
        for multiple; Mon, 25 Nov 2019 10:42:52 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Martin Peres <martin.peres@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Jani Nikula <jani.nikula@intel.com>, stable@vger.kernel.org
Subject: [PATCH] drm/i915: Update bug URL to point at gitlab issues
Date:   Mon, 25 Nov 2019 10:42:48 +0000
Message-Id: <20191125104248.1690891-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We are moving our issue tracking over from bugs.fd.o to gitlab.fd.o, so
update the user instructions accordingly.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Martin Peres <martin.peres@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/i915_gpu_error.c | 2 +-
 drivers/gpu/drm/i915/i915_utils.c     | 3 +--
 drivers/gpu/drm/i915/i915_utils.h     | 2 ++
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gpu_error.c b/drivers/gpu/drm/i915/i915_gpu_error.c
index 2b30a45fa25c..1cf53fd4fe66 100644
--- a/drivers/gpu/drm/i915/i915_gpu_error.c
+++ b/drivers/gpu/drm/i915/i915_gpu_error.c
@@ -1817,7 +1817,7 @@ void i915_capture_error_state(struct drm_i915_private *i915,
 	if (!xchg(&warned, true) &&
 	    ktime_get_real_seconds() - DRIVER_TIMESTAMP < DAY_AS_SECONDS(180)) {
 		pr_info("GPU hangs can indicate a bug anywhere in the entire gfx stack, including userspace.\n");
-		pr_info("Please file a _new_ bug report on bugs.freedesktop.org against DRI -> DRM/Intel\n");
+		pr_info("Please file a _new_ bug report on " FDO_BUG_URL "\n");
 		pr_info("drm/i915 developers can then reassign to the right component if it's not a kernel issue.\n");
 		pr_info("The GPU crash dump is required to analyze GPU hangs, so please always attach it.\n");
 		pr_info("GPU crash dump saved to /sys/class/drm/card%d/error\n",
diff --git a/drivers/gpu/drm/i915/i915_utils.c b/drivers/gpu/drm/i915/i915_utils.c
index c47261ae86ea..9b68b21becf1 100644
--- a/drivers/gpu/drm/i915/i915_utils.c
+++ b/drivers/gpu/drm/i915/i915_utils.c
@@ -8,8 +8,7 @@
 #include "i915_drv.h"
 #include "i915_utils.h"
 
-#define FDO_BUG_URL "https://bugs.freedesktop.org/enter_bug.cgi?product=DRI"
-#define FDO_BUG_MSG "Please file a bug at " FDO_BUG_URL " against DRM/Intel " \
+#define FDO_BUG_MSG "Please file a bug at " FDO_BUG_URL \
 		    "providing the dmesg log by booting with drm.debug=0xf"
 
 void
diff --git a/drivers/gpu/drm/i915/i915_utils.h b/drivers/gpu/drm/i915/i915_utils.h
index 04139ba1191e..13674b016092 100644
--- a/drivers/gpu/drm/i915/i915_utils.h
+++ b/drivers/gpu/drm/i915/i915_utils.h
@@ -34,6 +34,8 @@
 struct drm_i915_private;
 struct timer_list;
 
+#define FDO_BUG_URL "https://gitlab.freedesktop.org/drm/intel/issues/new?"
+
 #undef WARN_ON
 /* Many gcc seem to no see through this and fall over :( */
 #if 0
-- 
2.24.0

