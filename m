Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C273336A1A3
	for <lists+stable@lfdr.de>; Sat, 24 Apr 2021 16:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbhDXOkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Apr 2021 10:40:05 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:46687 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229848AbhDXOkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Apr 2021 10:40:04 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 13F111940717;
        Sat, 24 Apr 2021 10:39:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 24 Apr 2021 10:39:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=g+9VkY
        lffTWm8g6AnXVo880q3nTZB0FTxynLE4PyAQ4=; b=EaEEP4XwrKTRg5jCh+rwhL
        vjSy0MOSMOfauvGY9kWwuQrUrOwX2ytaGhAWUEKYiAbuXlty//ML4d7pcLIcSJoc
        u4W0uBTnhNVfEs1P8e8vOkZPS8vTLaZxB33FTv0M+5f0FkampNayN1h32YWPIwyR
        C8dwHF2/XfNhEWjPcZnAwiqZXVthCrFnXSGpOlSHVE4MLrhYlHRvcSSnxVI1Y4Dn
        LkMb0vg+/zzR0KdjTPLDSlIaSUlXsoDhECUO1Qbf/bq+FEDnxxhyCZxjJlQZ+r4f
        XOG+fVLn20URGAC9KYhnR9FCiFWGFfJ8PozOjH2kHOpVcptJSJkg2L0NqXc69OfQ
        ==
X-ME-Sender: <xms:nC2EYIdXOrmUcgpXAkgreLj2ChOujgECMzfpGV2-8468i2NWOZciDA>
    <xme:nC2EYOh5hqiFXsHvjIAlSI30HHXsl3oF2QR3gWS4R_HE1uAu0N55962rmh738P21f
    poooBDKGTo5BA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:nC2EYIoKPQB_h7mXx7EyIDoxEqBgM4hTZQrmm7zy4ZWvWWgeLVGoMg>
    <xmx:nC2EYGFwfwapAhS16ZGAQSLwOACY767osICrac17vt9F4okymyPNOw>
    <xmx:nC2EYKkHJC8M88Wh_Zb-w7bSV86MiDTYQY7iq_pTLqOg9VemeC4Reg>
    <xmx:nS2EYAGtA9sKIRBDPfuuWlrxsym8LwSdFpoktI2gFu3b9_tQ-2GEhQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 76AD71080064;
        Sat, 24 Apr 2021 10:39:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Fix modesetting in case of unexpected AUX timeouts" failed to apply to 5.11-stable tree
To:     imre.deak@intel.com, rodrigo.vivi@intel.com,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Apr 2021 16:39:22 +0200
Message-ID: <16192751626819@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d2b9935d65dab6e92beb33c150c1a6ded14ab670 Mon Sep 17 00:00:00 2001
From: Imre Deak <imre.deak@intel.com>
Date: Tue, 13 Apr 2021 02:24:12 +0300
Subject: [PATCH] drm/i915: Fix modesetting in case of unexpected AUX timeouts
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In case AUX failures happen unexpectedly during a modeset, the driver
should still complete the modeset. In particular the driver should
perform the link training sequence steps even in case of an AUX failure,
as this sequence also includes port initialization steps. Not doing that
can leave the port/pipe in a broken state and lead for instance to a
flip done timeout.

Fix this by continuing with link training (in a no-LTTPR mode) if the
DPRX DPCD readout failed for some reason at the beginning of link
training. After a successful connector detection we already have the
DPCD read out and cached, so the failed repeated read for it should not
cause a problem. Note that a partial AUX read could in theory partly
overwrite the cached DPCD (and return error) but this overwrite should
not happen if the returned values are corrupted (due to a timeout or
some other IO error).

Kudos to Ville to root cause the problem.

Fixes: 7dffbdedb96a ("drm/i915: Disable LTTPR support when the DPCD rev < 1.4")
References: https://gitlab.freedesktop.org/drm/intel/-/issues/3308
Cc: stable@vger.kernel.org # 5.11
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210412232413.2755054-1-imre.deak@intel.com
(cherry picked from commit e42e7e585984b85b0fb9dd1fefc85ee4800ca629)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[adjusted Fixes: tag]

diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
index be6ac0dd846e..2ed309534e97 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -848,7 +848,8 @@ void intel_dp_start_link_train(struct intel_dp *intel_dp,
 	int lttpr_count = intel_dp_init_lttpr_and_dprx_caps(intel_dp);
 
 	if (lttpr_count < 0)
-		return;
+		/* Still continue with enabling the port and link training. */
+		lttpr_count = 0;
 
 	if (!intel_dp_link_train_all_phys(intel_dp, crtc_state, lttpr_count))
 		intel_dp_schedule_fallback_link_training(intel_dp, crtc_state);

