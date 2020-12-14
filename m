Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F266A2D9986
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 15:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439751AbgLNOM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 09:12:58 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:34731 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727458AbgLNOM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 09:12:58 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 47F191941320;
        Mon, 14 Dec 2020 09:12:12 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 14 Dec 2020 09:12:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=dWmRja
        gCtjAQqzxfQjgOy13WFZDOiRS88W8VD2k8z4Q=; b=GSwHoO8SweHiU11euXPH/J
        S/8rZ5nr19cOC1EyTjJSF/a20e7WnqlmSWt4kGhRrgWslb7a9RcGn/C9hPTSFm0S
        LJfEFr4xbQNZ1sG+KlXSRS90mLB9M7t0YOKbmM7C4p6BpVMCwgB5aJRWjT36m9YJ
        qNxqz0fAt/cuXy40DFauTd8WUvPqxkjJDcZVf0d5CMZooc44SYip8gH8JtpKCo/D
        OQ34g2bh08lqW6pJxpUaS6W4nimU2QCOIbuJj2yrL3BV2WrICeKcOwGgIxjA4eHD
        zNdmeDOYGPC62GTGWFMirHlAgivhsrdUL37BKWcZH2E8nIVKl5iCLcmBWG1WzSbw
        ==
X-ME-Sender: <xms:u3LXX849fDPyIlrYBa491tuPto8VQFp6lnERegz0DaBPKK_taDM3mw>
    <xme:u3LXX96AS3EDpxqRztDnzUIVRtlPv30TdIqowD7EHpZYKmP9CFp4XwppQEgkf45Dt
    CwfOFUbvomrVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:u3LXX7eq9Vp0kRPBL0s2PuiGy5Ay6cpX2sewMfIWCQZ6swZjIYKjlg>
    <xmx:u3LXXxKGkclM5swYBtvSncV05bQlgUoeseUbfSNQ5--08fVvl_5sTw>
    <xmx:u3LXXwIGRgKdNe_eNTqF9cJ69Hs8_K4Hc2Cuefqi9wbdbyy1cRAkcA>
    <xmx:vHLXX6iB-AdEwJQraUsIyXg7Tws8G4e4AybbjUcG-jpYFfHA4B0qcw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 415D7240057;
        Mon, 14 Dec 2020 09:12:11 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Declare gen9 has 64 mocs entries!" failed to apply to 5.4-stable tree
To:     chris@chris-wilson.co.uk, rodrigo.vivi@intel.com,
        stable@vger.kernel.org, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Dec 2020 15:13:17 +0100
Message-ID: <160795519763219@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7c5c15dffe1e3c42f44735ce9552afb7207f1584 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Fri, 27 Nov 2020 10:25:40 +0000
Subject: [PATCH] drm/i915/gt: Declare gen9 has 64 mocs entries!

We checked the table size against a hardcoded number of entries, and
that number was excluding the special mocs registers at the end.

Fixes: 777a7717d60c ("drm/i915/gt: Program mocs:63 for cache eviction on gen9")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v4.3+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201127102540.13117-1-chris@chris-wilson.co.uk
(cherry picked from commit 444fbf5d7058099447c5366ba8bb60d610aeb44b)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[backported and updated the Fixes sha]

diff --git a/drivers/gpu/drm/i915/gt/intel_mocs.c b/drivers/gpu/drm/i915/gt/intel_mocs.c
index 4f74706967fd..413dadfac2d1 100644
--- a/drivers/gpu/drm/i915/gt/intel_mocs.c
+++ b/drivers/gpu/drm/i915/gt/intel_mocs.c
@@ -59,8 +59,7 @@ struct drm_i915_mocs_table {
 #define _L3_CACHEABILITY(value)	((value) << 4)
 
 /* Helper defines */
-#define GEN9_NUM_MOCS_ENTRIES	62  /* 62 out of 64 - 63 & 64 are reserved. */
-#define GEN11_NUM_MOCS_ENTRIES	64  /* 63-64 are reserved, but configured. */
+#define GEN9_NUM_MOCS_ENTRIES	64  /* 63-64 are reserved, but configured. */
 
 /* (e)LLC caching options */
 /*
@@ -328,11 +327,11 @@ static unsigned int get_mocs_settings(const struct drm_i915_private *i915,
 	if (INTEL_GEN(i915) >= 12) {
 		table->size  = ARRAY_SIZE(tgl_mocs_table);
 		table->table = tgl_mocs_table;
-		table->n_entries = GEN11_NUM_MOCS_ENTRIES;
+		table->n_entries = GEN9_NUM_MOCS_ENTRIES;
 	} else if (IS_GEN(i915, 11)) {
 		table->size  = ARRAY_SIZE(icl_mocs_table);
 		table->table = icl_mocs_table;
-		table->n_entries = GEN11_NUM_MOCS_ENTRIES;
+		table->n_entries = GEN9_NUM_MOCS_ENTRIES;
 	} else if (IS_GEN9_BC(i915) || IS_CANNONLAKE(i915)) {
 		table->size  = ARRAY_SIZE(skl_mocs_table);
 		table->n_entries = GEN9_NUM_MOCS_ENTRIES;

