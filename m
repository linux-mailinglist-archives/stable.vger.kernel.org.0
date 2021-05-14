Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C475F380D30
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 17:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbhENPeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 11:34:20 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:56449 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234906AbhENPeR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 11:34:17 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id DC0641940B4C;
        Fri, 14 May 2021 11:33:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 14 May 2021 11:33:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Apstax
        E4Soz0+HU0Dwu7o/MRZtVzNyIxAPZf4DZS9m8=; b=V6vJWM8SG6G0GXB9i22STV
        TK+h85PPJvIQzcr+3WqPPGb2B7lOwTifSl1h+RpWtVcc51ImbK3aWXSXiPrGCKv5
        ob2nrACGc85fnOXRpak1RA7Lb9x9gxiG4hZWKfZVMNxliGcNDMvK5uLrPN3/EJfv
        fbn8C+93c3g5jJGZ6BfuMrfG4+aaWYI7kzU/ylux2Fdk8c0O53InzgRPZS7NzAV/
        zF2wQI+R9RhnY/anbbNiezbsgnddy+Zuk//10LqMvjceDCms/dc0W9+gznv5BHka
        mRuwOphiqYBFAC9aQzENflBZXUx2F48BeSPjK8J2uqAxNLMB6zSU4e6FU16FXH0Q
        ==
X-ME-Sender: <xms:MJieYDbPnqGk3aZr-goqrwl-z16e8zp2G_mkOZL_UI9VidVUE4DHRQ>
    <xme:MJieYCbahqC6Y0kqx2pC2LOdLgmMUr3j8345CIQHDuBkgo-UVju2hJdBair0SW6b3
    Ia6xUOaIlbkFQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehjedgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:MJieYF9e0Yc78NWSTiASDDV7JIvr-tCxMYC4Ndb1QFEbot3LvakgUw>
    <xmx:MJieYJr0ZZUkcz7n_VSloREK9eW6Y3-rNHrab0YGpBrkvZpJFYXAyw>
    <xmx:MJieYOpFZ3wryIQqwPbCX4JIevf5nPL4inviGOReZAI7ZfcveYkiqg>
    <xmx:MJieYBUtw0l9eR_sZ5NAXVLo5oiJp-Crl4Q3GIjVMz_YUd32mCnNFg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri, 14 May 2021 11:33:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PM: runtime: Fix unpaired parent child_count for force_resume" failed to apply to 4.19-stable tree
To:     tony@atomide.com, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org, tomi.valkeinen@ideasonboard.com,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 14 May 2021 17:33:01 +0200
Message-ID: <1621006381199160@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c745253e2a691a40c66790defe85c104a887e14a Mon Sep 17 00:00:00 2001
From: Tony Lindgren <tony@atomide.com>
Date: Wed, 5 May 2021 14:09:15 +0300
Subject: [PATCH] PM: runtime: Fix unpaired parent child_count for force_resume

As pm_runtime_need_not_resume() relies also on usage_count, it can return
a different value in pm_runtime_force_suspend() compared to when called in
pm_runtime_force_resume(). Different return values can happen if anything
calls PM runtime functions in between, and causes the parent child_count
to increase on every resume.

So far I've seen the issue only for omapdrm that does complicated things
with PM runtime calls during system suspend for legacy reasons:

omap_atomic_commit_tail() for omapdrm.0
 dispc_runtime_get()
  wakes up 58000000.dss as it's the dispc parent
   dispc_runtime_resume()
    rpm_resume() increases parent child_count
 dispc_runtime_put() won't idle, PM runtime suspend blocked
pm_runtime_force_suspend() for 58000000.dss, !pm_runtime_need_not_resume()
 __update_runtime_status()
system suspended
pm_runtime_force_resume() for 58000000.dss, pm_runtime_need_not_resume()
 pm_runtime_enable() only called because of pm_runtime_need_not_resume()
omap_atomic_commit_tail() for omapdrm.0
 dispc_runtime_get()
  wakes up 58000000.dss as it's the dispc parent
   dispc_runtime_resume()
    rpm_resume() increases parent child_count
 dispc_runtime_put() won't idle, PM runtime suspend blocked
...
rpm_suspend for 58000000.dss but parent child_count is now unbalanced

Let's fix the issue by adding a flag for needs_force_resume and use it in
pm_runtime_force_resume() instead of pm_runtime_need_not_resume().

Additionally omapdrm system suspend could be simplified later on to avoid
lots of unnecessary PM runtime calls and the complexity it adds. The
driver can just use internal functions that are shared between the PM
runtime and system suspend related functions.

Fixes: 4918e1f87c5f ("PM / runtime: Rework pm_runtime_force_suspend/resume()")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Tested-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Cc: 4.16+ <stable@vger.kernel.org> # 4.16+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 1fc1a992f90c..b570848d23e0 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1637,6 +1637,7 @@ void pm_runtime_init(struct device *dev)
 	dev->power.request_pending = false;
 	dev->power.request = RPM_REQ_NONE;
 	dev->power.deferred_resume = false;
+	dev->power.needs_force_resume = 0;
 	INIT_WORK(&dev->power.work, pm_runtime_work);
 
 	dev->power.timer_expires = 0;
@@ -1804,10 +1805,12 @@ int pm_runtime_force_suspend(struct device *dev)
 	 * its parent, but set its status to RPM_SUSPENDED anyway in case this
 	 * function will be called again for it in the meantime.
 	 */
-	if (pm_runtime_need_not_resume(dev))
+	if (pm_runtime_need_not_resume(dev)) {
 		pm_runtime_set_suspended(dev);
-	else
+	} else {
 		__update_runtime_status(dev, RPM_SUSPENDED);
+		dev->power.needs_force_resume = 1;
+	}
 
 	return 0;
 
@@ -1834,7 +1837,7 @@ int pm_runtime_force_resume(struct device *dev)
 	int (*callback)(struct device *);
 	int ret = 0;
 
-	if (!pm_runtime_status_suspended(dev) || pm_runtime_need_not_resume(dev))
+	if (!pm_runtime_status_suspended(dev) || !dev->power.needs_force_resume)
 		goto out;
 
 	/*
@@ -1853,6 +1856,7 @@ int pm_runtime_force_resume(struct device *dev)
 
 	pm_runtime_mark_last_busy(dev);
 out:
+	dev->power.needs_force_resume = 0;
 	pm_runtime_enable(dev);
 	return ret;
 }
diff --git a/include/linux/pm.h b/include/linux/pm.h
index c9657408fee1..1d8209c09686 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -601,6 +601,7 @@ struct dev_pm_info {
 	unsigned int		idle_notification:1;
 	unsigned int		request_pending:1;
 	unsigned int		deferred_resume:1;
+	unsigned int		needs_force_resume:1;
 	unsigned int		runtime_auto:1;
 	bool			ignore_children:1;
 	unsigned int		no_callbacks:1;

