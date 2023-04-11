Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355156DDBFB
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 15:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjDKNYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 09:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDKNYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 09:24:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7AB49DC
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 06:24:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 438F462641
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 13:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540C7C433D2;
        Tue, 11 Apr 2023 13:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681219447;
        bh=dvsDfvWALW2YLUl8lV9H9xJZst4br6aQch6+aUMx1BQ=;
        h=Subject:To:Cc:From:Date:From;
        b=SlFvOhn6o9CQzPUIkYAzDeu2kD9FTbwxG6zQU3HG3sQIS5Czj57MBySIk2CN2wuDl
         H7FHwwhpM9Rb1YXlJfA2EyHyAxxepc9AaE4/oWnrTqFMRxTn0H9LyEKSzDxq6gVota
         U7SvsEvbGkD23FjI/DCmuZVCNpqXhSM+xmP4jenk=
Subject: FAILED: patch "[PATCH] drm/i915: fix race condition UAF in" failed to apply to 5.10-stable tree
To:     lm0963hack@gmail.com, andi.shyti@linux.intel.com,
        jani.nikula@intel.com, stable@vger.kernel.org,
        tvrtko.ursulin@intel.com, umesh.nerlige.ramappa@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 15:24:02 +0200
Message-ID: <2023041102-expenses-unwoven-6355@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x dc30c011469165d57af9adac5baff7d767d20e5c
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041102-expenses-unwoven-6355@gregkh' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

dc30c0114691 ("drm/i915: fix race condition UAF in i915_perf_add_config_ioctl")
2fec539112e8 ("i915/perf: Replace DRM_DEBUG with driver specific drm_dbg call")
046d1660daee ("drm/i915/gem: Return an error ptr from context_lookup")
a4839cb1137b ("drm/i915: Stop manually RCU banging in reset_stats_ioctl (v2)")
651e7d48577a ("drm/i915: replace IS_GEN and friends with GRAPHICS_VER")
ec2b1485a065 ("drm/i915/dmc: s/HAS_CSR/HAS_DMC")
c24760cf42c3 ("drm/i915/dmc: s/intel_csr/intel_dmc")
93e7e61eb448 ("drm/i915/display: rename display version macros")
4df9c1ae7a4b ("drm/i915: rename display.version to display.ver")
6c51f288b41f ("drm/i915: Don't use {skl, cnl}_hpd_pin() for bxt/glk")
0fe6637d9852 ("drm/i915: Restore lost glk ccs w/a")
87b8c3bc8d27 ("drm/i915: Restore lost glk FBC 16bpp w/a")
2446e1d6433b ("drm/i915/display: Eliminate IS_GEN9_{BC,LP}")
9c0fed84d575 ("Merge tag 'drm-intel-next-2021-04-01' of git://anongit.freedesktop.org/drm/drm-intel into drm-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dc30c011469165d57af9adac5baff7d767d20e5c Mon Sep 17 00:00:00 2001
From: Min Li <lm0963hack@gmail.com>
Date: Tue, 28 Mar 2023 17:36:27 +0800
Subject: [PATCH] drm/i915: fix race condition UAF in
 i915_perf_add_config_ioctl

Userspace can guess the id value and try to race oa_config object creation
with config remove, resulting in a use-after-free if we dereference the
object after unlocking the metrics_lock.  For that reason, unlocking the
metrics_lock must be done after we are done dereferencing the object.

Signed-off-by: Min Li <lm0963hack@gmail.com>
Fixes: f89823c21224 ("drm/i915/perf: Implement I915_PERF_ADD/REMOVE_CONFIG interface")
Cc: <stable@vger.kernel.org> # v4.14+
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230328093627.5067-1-lm0963hack@gmail.com
[tursulin: Manually added stable tag.]
(cherry picked from commit 49f6f6483b652108bcb73accd0204a464b922395)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index 283a4a3c6862..004074936300 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -4638,13 +4638,13 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
 		err = oa_config->id;
 		goto sysfs_err;
 	}
-
-	mutex_unlock(&perf->metrics_lock);
+	id = oa_config->id;
 
 	drm_dbg(&perf->i915->drm,
 		"Added config %s id=%i\n", oa_config->uuid, oa_config->id);
+	mutex_unlock(&perf->metrics_lock);
 
-	return oa_config->id;
+	return id;
 
 sysfs_err:
 	mutex_unlock(&perf->metrics_lock);

