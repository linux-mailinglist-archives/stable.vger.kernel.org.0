Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA78327F9E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235792AbhCANgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:36:20 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:47953 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235806AbhCANfl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:35:41 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 189D71941F8B;
        Mon,  1 Mar 2021 08:34:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 01 Mar 2021 08:34:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=iGl8aZ
        nsiVrsy68cS10jqTjr3zza7MoSYvU3xOmaoUA=; b=tEHe3Aw5c2sd+KGO3PkvjN
        t+pN3FdhKsWCK0WEhOUY7OG5UFuiBaCSoKoZo6raMj7PsBpEtdVsHoWjL3k/PJn0
        60trTlAvHPA/esRs2XhqFPIDhrqTOkAsJbGJ6mA3LLWuP16m7zqpNNcCGvA3Q8YY
        bvdPbPCm6mSfjNQxB0XQcORQ4za4LRW1vsviePw9PGSwlpZx187wcMPuzhyCgTgL
        cJAcu930MVgk4E/H0EmRhUMOPKpV6VyJAPfyuNQ8TPfr8qrC8i3tFGgi++idGcFc
        jEshb9pJfjNeQdymc/dGt36cegIIXow7v2SBQwJEi6rSeOzjTmdaySw1+w53O4Fg
        ==
X-ME-Sender: <xms:eO08YKc4pIXFWVDQTd_smQ7HtRSZsNRIgyl0mmupmpWXmeTDYankuQ>
    <xme:eO08YIce6x5fmihHsT-dJ46ttI_L3qI1_3vIi9-dh_qLJBDl4hix7_98EQ2cNqaB9
    EOpKD0MZazO1g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:eO08YGg2qF9ZZYAytcAYWRzlXyO1DPeIpXEhlMnv0lfoFBkS5gRY_g>
    <xmx:eO08YMSjX0JB2NeNtc4NBTR2jSijP4fTsOXPpJddO-lMreRW6kvhfA>
    <xmx:eO08YPxxHvlMOSoKKXflsCWOboQyDu_Tu7Dt0xef5UuWkylAOf9bHg>
    <xmx:eu08YCPNKcu-uPvT9zXv4F9epp_0LD63OiF-xxm3B08Us6XpFtNdVw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 564731080067;
        Mon,  1 Mar 2021 08:34:48 -0500 (EST)
Subject: FAILED: patch "[PATCH] cpufreq: intel_pstate: Change intel_pstate_get_hwp_max()" failed to apply to 4.19-stable tree
To:     rafael.j.wysocki@intel.com, yu.c.chen@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:34:39 +0100
Message-ID: <161460567913047@kroah.com>
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

From a45ee4d4e13b0e35a8ec7ea0bf9267243d57b302 Mon Sep 17 00:00:00 2001
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Thu, 7 Jan 2021 19:43:30 +0100
Subject: [PATCH] cpufreq: intel_pstate: Change intel_pstate_get_hwp_max()
 argument

All of the callers of intel_pstate_get_hwp_max() access the struct
cpudata object that corresponds to the given CPU already and the
function itself needs to access that object (in order to update
hwp_cap_cached), so modify the code to pass a struct cpudata pointer
to it instead of the CPU number.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Chen Yu <yu.c.chen@intel.com>

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 74bf54e6c993..3eb63daf2523 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -819,13 +819,13 @@ static struct freq_attr *hwp_cpufreq_attrs[] = {
 	NULL,
 };
 
-static void intel_pstate_get_hwp_max(unsigned int cpu, int *phy_max,
+static void intel_pstate_get_hwp_max(struct cpudata *cpu, int *phy_max,
 				     int *current_max)
 {
 	u64 cap;
 
-	rdmsrl_on_cpu(cpu, MSR_HWP_CAPABILITIES, &cap);
-	WRITE_ONCE(all_cpu_data[cpu]->hwp_cap_cached, cap);
+	rdmsrl_on_cpu(cpu->cpu, MSR_HWP_CAPABILITIES, &cap);
+	WRITE_ONCE(cpu->hwp_cap_cached, cap);
 	if (global.no_turbo || global.turbo_disabled)
 		*current_max = HWP_GUARANTEED_PERF(cap);
 	else
@@ -1213,7 +1213,7 @@ static void update_qos_request(enum freq_qos_req_type type)
 			continue;
 
 		if (hwp_active)
-			intel_pstate_get_hwp_max(i, &turbo_max, &max_state);
+			intel_pstate_get_hwp_max(cpu, &turbo_max, &max_state);
 		else
 			turbo_max = cpu->pstate.turbo_pstate;
 
@@ -1723,7 +1723,7 @@ static void intel_pstate_get_cpu_pstates(struct cpudata *cpu)
 	if (hwp_active && !hwp_mode_bdw) {
 		unsigned int phy_max, current_max;
 
-		intel_pstate_get_hwp_max(cpu->cpu, &phy_max, &current_max);
+		intel_pstate_get_hwp_max(cpu, &phy_max, &current_max);
 		cpu->pstate.turbo_freq = phy_max * cpu->pstate.scaling;
 		cpu->pstate.turbo_pstate = phy_max;
 	} else {
@@ -2208,7 +2208,7 @@ static void intel_pstate_update_perf_limits(struct cpudata *cpu,
 	 * rather than pure ratios.
 	 */
 	if (hwp_active) {
-		intel_pstate_get_hwp_max(cpu->cpu, &turbo_max, &max_state);
+		intel_pstate_get_hwp_max(cpu, &turbo_max, &max_state);
 	} else {
 		max_state = global.no_turbo || global.turbo_disabled ?
 			cpu->pstate.max_pstate : cpu->pstate.turbo_pstate;
@@ -2323,7 +2323,7 @@ static void intel_pstate_verify_cpu_policy(struct cpudata *cpu,
 	if (hwp_active) {
 		int max_state, turbo_max;
 
-		intel_pstate_get_hwp_max(cpu->cpu, &turbo_max, &max_state);
+		intel_pstate_get_hwp_max(cpu, &turbo_max, &max_state);
 		max_freq = max_state * cpu->pstate.scaling;
 	} else {
 		max_freq = intel_pstate_get_max_freq(cpu);
@@ -2710,7 +2710,7 @@ static int intel_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	if (hwp_active) {
 		u64 value;
 
-		intel_pstate_get_hwp_max(policy->cpu, &turbo_max, &max_state);
+		intel_pstate_get_hwp_max(cpu, &turbo_max, &max_state);
 		policy->transition_delay_us = INTEL_CPUFREQ_TRANSITION_DELAY_HWP;
 		rdmsrl_on_cpu(cpu->cpu, MSR_HWP_REQUEST, &value);
 		WRITE_ONCE(cpu->hwp_req_cached, value);

