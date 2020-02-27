Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA7A171C30
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388182AbgB0OJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:09:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388200AbgB0OJq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:09:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EEBA20714;
        Thu, 27 Feb 2020 14:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812585;
        bh=baZE+gclkLql6tEsjelvIynBIWZQ0jvWWVn0n8q8Rxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tuq7FgaKf87PdmxnB74w9pvTaoAtViYndBghxtDwLQ4wkyJWsLn2QAwyFaZ8R/1eZ
         hXIrcKnZOrF17WHE+0GC38iLIvUI4k6CfWRkRAwcjxJxOgR13YUUxTPe/RvXPrGKL/
         xY/fVEhF2s0VKOuSiD5BKW9N2PG7AeVEVvcbkFFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.4 075/135] drm/i915: Update drm/i915 bug filing URL
Date:   Thu, 27 Feb 2020 14:36:55 +0100
Message-Id: <20200227132240.661052202@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

commit 7ddc7005a0aa2f43a826b71f5d6bd7d4b90f8f2a upstream.

We've moved from bugzilla to gitlab.

Cc: stable@vger.kernel.org
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200212160434.6437-2-jani.nikula@intel.com
(cherry picked from commit ddae4d7af0bbe3b2051f1603459a8b24e9a19324)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/Kconfig          |    5 ++---
 drivers/gpu/drm/i915/i915_gpu_error.c |    3 ++-
 drivers/gpu/drm/i915/i915_utils.c     |    5 ++---
 3 files changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/Kconfig
+++ b/drivers/gpu/drm/i915/Kconfig
@@ -75,9 +75,8 @@ config DRM_I915_CAPTURE_ERROR
 	help
 	  This option enables capturing the GPU state when a hang is detected.
 	  This information is vital for triaging hangs and assists in debugging.
-	  Please report any hang to
-            https://bugs.freedesktop.org/enter_bug.cgi?product=DRI
-	  for triaging.
+	  Please report any hang for triaging according to:
+	    https://gitlab.freedesktop.org/drm/intel/-/wikis/How-to-file-i915-bugs
 
 	  If in doubt, say "Y".
 
--- a/drivers/gpu/drm/i915/i915_gpu_error.c
+++ b/drivers/gpu/drm/i915/i915_gpu_error.c
@@ -1768,7 +1768,8 @@ void i915_capture_error_state(struct drm
 	if (!xchg(&warned, true) &&
 	    ktime_get_real_seconds() - DRIVER_TIMESTAMP < DAY_AS_SECONDS(180)) {
 		pr_info("GPU hangs can indicate a bug anywhere in the entire gfx stack, including userspace.\n");
-		pr_info("Please file a _new_ bug report on bugs.freedesktop.org against DRI -> DRM/Intel\n");
+		pr_info("Please file a _new_ bug report at https://gitlab.freedesktop.org/drm/intel/issues/new.\n");
+		pr_info("Please see https://gitlab.freedesktop.org/drm/intel/-/wikis/How-to-file-i915-bugs for details.\n");
 		pr_info("drm/i915 developers can then reassign to the right component if it's not a kernel issue.\n");
 		pr_info("The GPU crash dump is required to analyze GPU hangs, so please always attach it.\n");
 		pr_info("GPU crash dump saved to /sys/class/drm/card%d/error\n",
--- a/drivers/gpu/drm/i915/i915_utils.c
+++ b/drivers/gpu/drm/i915/i915_utils.c
@@ -8,9 +8,8 @@
 #include "i915_drv.h"
 #include "i915_utils.h"
 
-#define FDO_BUG_URL "https://bugs.freedesktop.org/enter_bug.cgi?product=DRI"
-#define FDO_BUG_MSG "Please file a bug at " FDO_BUG_URL " against DRM/Intel " \
-		    "providing the dmesg log by booting with drm.debug=0xf"
+#define FDO_BUG_URL "https://gitlab.freedesktop.org/drm/intel/-/wikis/How-to-file-i915-bugs"
+#define FDO_BUG_MSG "Please file a bug on drm/i915; see " FDO_BUG_URL " for details."
 
 void
 __i915_printk(struct drm_i915_private *dev_priv, const char *level,


