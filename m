Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A5724652A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 13:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHQLJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 07:09:46 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:43487 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726585AbgHQLJZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 07:09:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id C2A48194175C;
        Mon, 17 Aug 2020 07:09:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 07:09:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=RCOu2M
        f26lT168huwmc9byCsSDtEYwfUg8GJfY7n6Kw=; b=TYQcrvhKZl7p0JYENH1zcq
        1fSFbJB0lnUeAL9rDmF5uVIVT6OEoXGoSaaOuHAbsFXH4L3mkPUgh5thf3C2a5gM
        HqmJcYyjeyZaNQ1ijio3OztuUF2/uo7x1s+r7vYUSWvivGGSSWwdJYEAvRqPC82R
        ypx2c9/iIbqCHJ3yrtHP2K45CdO4im8nhniDqweSKJXEt0wgPlTtOvWoERAL+ZkP
        Bra9wIjRl3OAaPOdCrxOjIS0fjAgMsvSEKzYNukWjvpLxOHPQv/EenlbqGcEsiwA
        NEST0T31SXr+J1MMFM6mdBybdtSbz+QeKcErCGulGAyUSgqC9vWCFMB3HoSpqKTA
        ==
X-ME-Sender: <xms:ZGU6X2fDlriFZiCC14iSFo0KfjodMpMlUIY0LxMKgA9bt7vc6TIKZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ZGU6XwPZqcgoF3CfV8MfZTr6qkiwSiDnfTR9eQDCjFpV1efcfV6PzA>
    <xmx:ZGU6X3hwbqnGTMH9wqgoWCJ8cZglhFslnthhVwM0L_KtGRsy3n5kqg>
    <xmx:ZGU6Xz8flWBtgCC3QjVdx4aEukf8b-7jy3QARCLj4ZFcvni2NtYt2g>
    <xmx:ZGU6Xz4J4QVTiUWbS-3zgJJdpOHguxSceXJ4avjcKqVGzMxh0cDksw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0DED83060067;
        Mon, 17 Aug 2020 07:09:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] cpufreq: intel_pstate: Fix EPP setting via sysfs in active" failed to apply to 5.8-stable tree
To:     rafael.j.wysocki@intel.com, currojerez@riseup.net,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 13:09:44 +0200
Message-ID: <159766258411099@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.8-stable tree.
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

