Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44E11BA7D7
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 17:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbgD0PVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 11:21:37 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:52137 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727833AbgD0PVg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 11:21:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8DD9D19406C9;
        Mon, 27 Apr 2020 11:21:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 27 Apr 2020 11:21:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=GoKz4E
        1WRZDyO1l83YJkF+8N2G9FwcGqgq9/v7IcGHM=; b=DX3aZdrdkddfhQl2mvzePX
        YPWV+XyskTkm9LojEunQJs5o3wKsRZyIoI3+m4mirHIJUKp/FC5S1FJWNYvFnkBD
        ioj5+1MIf11gvP4q2rlD1WI60PCeu/YZQ9z8HLL9tH4Ex7KoS547GTaON2AaZPWQ
        6l4fUkKVrpcDc51zt3SNrvLTmQIktvnHK8NNAEDcxDiQy0+4YKJIuGGu6tSnLxrR
        v7PSz2DEVYnYO46kH6mXPzBrWt4nKjAfHWat1XEoSX//ZmDMf0VGhN87GLCpY4BH
        egGtTKWITBv3yBmgXWyZn7x8lZMyPqegbcJAkn6GtDdN6zO8CCvjK2jTJ30cJ8qw
        ==
X-ME-Sender: <xms:fvimXgb7qbHLFFw1TrbAqLNrOmmuDGIAHKMPP5sBN4cXYFkTEsdREA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdekhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepkeefrdekie
    drkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:fvimXqYubK2SGkEF4Otg68oKVpq-N7jm_aUzMPCV7Pl5ZDFHar1mRA>
    <xmx:fvimXnMhbnKS5bnEdpDOTUzUlg5R4SlcD7jSyekHM9aBZQ1iC0o2Aw>
    <xmx:fvimXorGsN0IojVO35lvXk7koKIFJOF1UCiR1x4wdlLWxPkpkt7CLA>
    <xmx:f_imXkdSkjif6zKT7tqEuLrvQOCJ1lfiIUJg0ARz7f2LmLaOSslgmg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 61C533065E7E;
        Mon, 27 Apr 2020 11:21:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Update PMINTRMSK holding fw" failed to apply to 5.6-stable tree
To:     chris@chris-wilson.co.uk, andi.shyti@intel.com,
        currojerez@riseup.net, mika.kuoppala@linux.intel.com,
        rodrigo.vivi@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Apr 2020 17:21:33 +0200
Message-ID: <1588000893237103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e1eb075c5051987fbbadbc0fb8211679df657721 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Wed, 15 Apr 2020 18:03:18 +0100
Subject: [PATCH] drm/i915/gt: Update PMINTRMSK holding fw

If we use a non-forcewaked write to PMINTRMSK, it does not take effect
until much later, if at all, causing a loss of RPS interrupts and no GPU
reclocking, leaving the GPU running at the wrong frequency for long
periods of time.

Reported-by: Francisco Jerez <currojerez@riseup.net>
Suggested-by: Francisco Jerez <currojerez@riseup.net>
Fixes: 35cc7f32c298 ("drm/i915/gt: Use non-forcewake writes for RPS")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Francisco Jerez <currojerez@riseup.net>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Andi Shyti <andi.shyti@intel.com>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Reviewed-by: Andi Shyti <andi.shyti@intel.com>
Reviewed-by: Francisco Jerez <currojerez@riseup.net>
Cc: <stable@vger.kernel.org> # v5.6+
Link: https://patchwork.freedesktop.org/patch/msgid/20200415170318.16771-2-chris@chris-wilson.co.uk
(cherry picked from commit a080bd994c4023042a2b605c65fa10a25933f636)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_rps.c b/drivers/gpu/drm/i915/gt/intel_rps.c
index cfaf141bac4d..19542fd9e207 100644
--- a/drivers/gpu/drm/i915/gt/intel_rps.c
+++ b/drivers/gpu/drm/i915/gt/intel_rps.c
@@ -81,13 +81,14 @@ static void rps_enable_interrupts(struct intel_rps *rps)
 		events = (GEN6_PM_RP_UP_THRESHOLD |
 			  GEN6_PM_RP_DOWN_THRESHOLD |
 			  GEN6_PM_RP_DOWN_TIMEOUT);
-
 	WRITE_ONCE(rps->pm_events, events);
+
 	spin_lock_irq(&gt->irq_lock);
 	gen6_gt_pm_enable_irq(gt, rps->pm_events);
 	spin_unlock_irq(&gt->irq_lock);
 
-	set(gt->uncore, GEN6_PMINTRMSK, rps_pm_mask(rps, rps->cur_freq));
+	intel_uncore_write(gt->uncore,
+			   GEN6_PMINTRMSK, rps_pm_mask(rps, rps->last_freq));
 }
 
 static void gen6_rps_reset_interrupts(struct intel_rps *rps)
@@ -120,7 +121,9 @@ static void rps_disable_interrupts(struct intel_rps *rps)
 	struct intel_gt *gt = rps_to_gt(rps);
 
 	WRITE_ONCE(rps->pm_events, 0);
-	set(gt->uncore, GEN6_PMINTRMSK, rps_pm_sanitize_mask(rps, ~0u));
+
+	intel_uncore_write(gt->uncore,
+			   GEN6_PMINTRMSK, rps_pm_sanitize_mask(rps, ~0u));
 
 	spin_lock_irq(&gt->irq_lock);
 	gen6_gt_pm_disable_irq(gt, GEN6_PM_RPS_EVENTS);

