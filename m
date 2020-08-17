Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D39424652B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 13:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgHQLJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 07:09:53 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:58357 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726651AbgHQLJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 07:09:42 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 82F281941759;
        Mon, 17 Aug 2020 07:09:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 07:09:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2bwsjD
        kQXTrVFuwRZ+EapVLwJzEX0m/imeOYba+cZwo=; b=uGbsjlvRf5qKCMaykNFsth
        9efQ8whCyKGvmkKdZNCO3RM5cuNhmfNw2c/U8fx30Q+ewLrdkSCw6BeYKm9quxQl
        9cU+b63sX47BxdO14SGeurMPhNI/cbZpbHfJNQ3ieSqL6fCPaF+fIMLTObAXEY6o
        isXWITvhmcc3I2F7YzouY/Qrhm/h8ZXtt8YVydYeZ7r+3TTmkz4JxsHuGYA/9CeE
        yAHcS2ycyYitsB4cm1F0PR8MJab+2WhU+b+wlKLrC2uZ1FUSDGn44dkpiy9MmX0b
        34EyXJU0kPuvdrsJ4YGBb4Kojjjq3fYHcElt0MqywfudFcsYJGRjmQrGG+hiHNtQ
        ==
X-ME-Sender: <xms:ZmU6X029ic5o6XP9jfz-4os9D9uBJVRXk5aS9C64SOlgnj-4fRXWAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ZmU6X_HjqkHb-HnsDBNNQqRReRZIfZ44B7Vs9_zJsjXx5eOmLxhUyA>
    <xmx:ZmU6X87rGZY8MfKMJo_wZ1Tdewrh29pjEO-hKrhGr-rF9tRrTP8wsA>
    <xmx:ZmU6X93mr33F1tQMCCncCAlcZ3w_zCZdHRlgeYwlgQ4Ey8jkfcvyEw>
    <xmx:ZmU6X-xDM6s8qk80Bb24NxaU1Ek5zSxdRCyOsjp-Qn0rySlGCfk9Gw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1F913306005F;
        Mon, 17 Aug 2020 07:09:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] cpufreq: intel_pstate: Fix EPP setting via sysfs in active" failed to apply to 5.7-stable tree
To:     rafael.j.wysocki@intel.com, currojerez@riseup.net,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 13:09:45 +0200
Message-ID: <159766258520746@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From de002c55cadfc2f6cdf0ed427526f6085d240238 Mon Sep 17 00:00:00 2001
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Tue, 28 Jul 2020 19:09:32 +0200
Subject: [PATCH] cpufreq: intel_pstate: Fix EPP setting via sysfs in active
 mode

Because intel_pstate_set_energy_pref_index() reads and writes the
MSR_HWP_REQUEST register without using the cached value of it used by
intel_pstate_hwp_boost_up() and intel_pstate_hwp_boost_down(), those
functions may overwrite the value written by it and so the EPP value
set via sysfs may be lost.

To avoid that, make intel_pstate_set_energy_pref_index() take the
cached value of MSR_HWP_REQUEST just like the other two routines
mentioned above and update it with the new EPP value coming from
user space in addition to updating the MSR.

Note that the MSR itself still needs to be updated too in case
hwp_boost is unset or the boosting mechanism is not active at the
EPP change time.

Fixes: e0efd5be63e8 ("cpufreq: intel_pstate: Add HWP boost utility and sched util hooks")
Reported-by: Francisco Jerez <currojerez@riseup.net>
Cc: 4.18+ <stable@vger.kernel.org> # 4.18+: 3da97d4db8ee cpufreq: intel_pstate: Rearrange ...
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Francisco Jerez <currojerez@riseup.net>

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index c55f6e35a1e3..7f5d81931483 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -650,11 +650,12 @@ static int intel_pstate_set_energy_pref_index(struct cpudata *cpu_data,
 		epp = cpu_data->epp_default;
 
 	if (boot_cpu_has(X86_FEATURE_HWP_EPP)) {
-		u64 value;
-
-		ret = rdmsrl_on_cpu(cpu_data->cpu, MSR_HWP_REQUEST, &value);
-		if (ret)
-			return ret;
+		/*
+		 * Use the cached HWP Request MSR value, because the register
+		 * itself may be updated by intel_pstate_hwp_boost_up() or
+		 * intel_pstate_hwp_boost_down() at any time.
+		 */
+		u64 value = READ_ONCE(cpu_data->hwp_req_cached);
 
 		value &= ~GENMASK_ULL(31, 24);
 
@@ -664,6 +665,12 @@ static int intel_pstate_set_energy_pref_index(struct cpudata *cpu_data,
 			epp = epp_values[pref_index - 1];
 
 		value |= (u64)epp << 24;
+		/*
+		 * The only other updater of hwp_req_cached in the active mode,
+		 * intel_pstate_hwp_set(), is called under the same lock as this
+		 * function, so it cannot run in parallel with the update below.
+		 */
+		WRITE_ONCE(cpu_data->hwp_req_cached, value);
 		ret = wrmsrl_on_cpu(cpu_data->cpu, MSR_HWP_REQUEST, value);
 	} else {
 		if (epp == -EINVAL)

