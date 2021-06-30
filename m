Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0045A3B806B
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 11:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhF3JzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 05:55:00 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:39694 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233886AbhF3Jy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 05:54:59 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A55911FE5F;
        Wed, 30 Jun 2021 09:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625046750; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ltRNr4B+l+889GdS96xK+Aj1swrLWkljO+/5u65nZ+o=;
        b=yC8h05yh5z+mhlMRV0MCRFL3ZZcPyaHerVoKb2IaV/tENGTd0Scm+8f1nq+I33koUy0MN3
        E+N3gX8Mslt3C3d61aBIplImn84a9BekdgtSbVtk1TzqFgREGHaI7ro/iKelnZzrjIrDTP
        XkIUuCaERUenH8KdR8Dydc4DFyMjQyA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625046750;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ltRNr4B+l+889GdS96xK+Aj1swrLWkljO+/5u65nZ+o=;
        b=caHLNKFpGID7jvvXi0keBYMW+/xBCH0CCDRDzAIu2v17ufPqGSpiWg7TTTdrB1dXGcUXu7
        l/lnML+hv0hvZlAQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 5936311906;
        Wed, 30 Jun 2021 09:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625046750; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ltRNr4B+l+889GdS96xK+Aj1swrLWkljO+/5u65nZ+o=;
        b=yC8h05yh5z+mhlMRV0MCRFL3ZZcPyaHerVoKb2IaV/tENGTd0Scm+8f1nq+I33koUy0MN3
        E+N3gX8Mslt3C3d61aBIplImn84a9BekdgtSbVtk1TzqFgREGHaI7ro/iKelnZzrjIrDTP
        XkIUuCaERUenH8KdR8Dydc4DFyMjQyA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625046750;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ltRNr4B+l+889GdS96xK+Aj1swrLWkljO+/5u65nZ+o=;
        b=caHLNKFpGID7jvvXi0keBYMW+/xBCH0CCDRDzAIu2v17ufPqGSpiWg7TTTdrB1dXGcUXu7
        l/lnML+hv0hvZlAQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id mLPWFN4+3GBKcwAALh3uQQ
        (envelope-from <tzimmermann@suse.de>); Wed, 30 Jun 2021 09:52:30 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch,
        chris@chris-wilson.co.uk, mika.kuoppala@linux.intel.com,
        matthew.brost@intel.com, maarten.lankhorst@linux.intel.com,
        lucas.demarchi@intel.com, ville.syrjala@linux.intel.com
Cc:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>, stable@vger.kernel.org
Subject: [PATCH v3 2/2] drm/i915: Drop all references to DRM IRQ midlayer
Date:   Wed, 30 Jun 2021 11:52:28 +0200
Message-Id: <20210630095228.6665-3-tzimmermann@suse.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210630095228.6665-1-tzimmermann@suse.de>
References: <20210630095228.6665-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Remove all references to DRM's IRQ midlayer. i915 uses Linux' interrupt
functions directly.

v2:
	* also remove an outdated comment
	* move IRQ fix into separate patch
	* update Fixes tag (Daniel)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: b318b82455bd ("drm/i915: Nuke drm_driver irq vfuncs")
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.4+
---
 drivers/gpu/drm/i915/i915_drv.c | 1 -
 drivers/gpu/drm/i915/i915_irq.c | 5 -----
 2 files changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 850b499c71c8..73de45472f60 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -42,7 +42,6 @@
 #include <drm/drm_aperture.h>
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_ioctl.h>
-#include <drm/drm_irq.h>
 #include <drm/drm_managed.h>
 #include <drm/drm_probe_helper.h>
 
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 2203dca19895..1d4c683c9de9 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -33,7 +33,6 @@
 #include <linux/sysrq.h>
 
 #include <drm/drm_drv.h>
-#include <drm/drm_irq.h>
 
 #include "display/intel_de.h"
 #include "display/intel_display_types.h"
@@ -4564,10 +4563,6 @@ void intel_runtime_pm_enable_interrupts(struct drm_i915_private *dev_priv)
 
 bool intel_irqs_enabled(struct drm_i915_private *dev_priv)
 {
-	/*
-	 * We only use drm_irq_uninstall() at unload and VT switch, so
-	 * this is the only thing we need to check.
-	 */
 	return dev_priv->runtime_pm.irqs_enabled;
 }
 
-- 
2.32.0

