Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC93D2578DA
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 14:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgHaMBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 08:01:45 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:47887 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726384AbgHaMBo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 08:01:44 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id D6D6E6F0;
        Mon, 31 Aug 2020 08:01:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 31 Aug 2020 08:01:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=t1PEoN
        m3zqh+fVU/a+jtfDbUB/nE1x18fFB5tiBmmJk=; b=jPKGhZePBAkcp2WjgV2j8y
        d4UG2F3oGs+5SLV4eylCBa9ISJxZpZZ9e+1q+pLfZBwpzYXGYiLHVwnNLOWHnY4/
        prS4EwYDx365W9MWqXqnX7q88kz9OtfrzzgiGG3QFwRS2wJIu0svo44TpJXIgeNE
        2qtnreSxzVa2WDUhyf8tFwgnM3HUqZbGJ5goXsGAH0UXSUp43x/NNXA+YnDJ7Ka9
        lL29kkfuyVPTXeykz7tLXmRBqfYYJJCAAr7YS+XHkyHCeAS0jcyl8fxrIdQbhxIL
        40fkF+rxuRsjlrbv7LCwj12dux06tgCEoSEVPCHLGiCaPFEd+pWMOSs5ZCcWFNwg
        ==
X-ME-Sender: <xms:peZMX3FPbpSlIdeLQpPKFpJZT2BQ9OvQqIYJ6wWNoE3GNpiJzti5vw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefhedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:peZMX0V1edBKw1sBaYhO7xoCb9Uje819y8eHQ56f7gI0pnF9hgm6cQ>
    <xmx:peZMX5JED8y2TdOV4uBaDrEiIwwWy-yICFx2dSoOjeD10HVbB1NoYg>
    <xmx:peZMX1HKlrEgAsgYPE475GIT_dRF_kIMvqtHWYVX6cFdagLTSYeWrA>
    <xmx:puZMX_JyQpcjBv3wfscPgDPki_tIRPneazrSrEvXJqDnL23QkM5FHnbRVqc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D704430600A9;
        Mon, 31 Aug 2020 08:01:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Fix cmd parser desc matching with masks" failed to apply to 5.4-stable tree
To:     mika.kuoppala@linux.intel.com, chris.p.wilson@intel.com,
        chris@chris-wilson.co.uk, jani.nikula@intel.com,
        jon.bloomfield@intel.com, mbenes@suse.cz, nstange@suse.de,
        tiwai@suse.de, tyhicks@canonical.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 14:01:49 +0200
Message-ID: <15988753095578@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From e5f10d6385cda083037915c12b130887c8831d2b Mon Sep 17 00:00:00 2001
From: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Date: Mon, 17 Aug 2020 22:59:26 +0300
Subject: [PATCH] drm/i915: Fix cmd parser desc matching with masks

Our variety of defined gpu commands have the actual
command id field and possibly length and flags applied.

We did start to apply the mask during initialization of
the cmd descriptors but forgot to also apply it on comparisons.

Fix comparisons in order to properly deny access with
associated commands.

v2: fix lri with correct mask (Chris)

References: 926abff21a8f ("drm/i915/cmdparser: Ignore Length operands during command matching")
Reported-by: Nicolai Stange <nstange@suse.de>
Cc: stable@vger.kernel.org # v5.4+
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Tyler Hicks <tyhicks@canonical.com>
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Cc: Chris Wilson <chris.p.wilson@intel.com>
Signed-off-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20200817195926.12671-1-mika.kuoppala@linux.intel.com
(cherry picked from commit 3b4efa148da36f158cce3f662e831af2834b8e0f)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/i915_cmd_parser.c b/drivers/gpu/drm/i915/i915_cmd_parser.c
index 372354d33f55..5ac4a999f05a 100644
--- a/drivers/gpu/drm/i915/i915_cmd_parser.c
+++ b/drivers/gpu/drm/i915/i915_cmd_parser.c
@@ -1204,6 +1204,12 @@ static u32 *copy_batch(struct drm_i915_gem_object *dst_obj,
 	return dst;
 }
 
+static inline bool cmd_desc_is(const struct drm_i915_cmd_descriptor * const desc,
+			       const u32 cmd)
+{
+	return desc->cmd.value == (cmd & desc->cmd.mask);
+}
+
 static bool check_cmd(const struct intel_engine_cs *engine,
 		      const struct drm_i915_cmd_descriptor *desc,
 		      const u32 *cmd, u32 length)
@@ -1242,19 +1248,19 @@ static bool check_cmd(const struct intel_engine_cs *engine,
 			 * allowed mask/value pair given in the whitelist entry.
 			 */
 			if (reg->mask) {
-				if (desc->cmd.value == MI_LOAD_REGISTER_MEM) {
+				if (cmd_desc_is(desc, MI_LOAD_REGISTER_MEM)) {
 					DRM_DEBUG("CMD: Rejected LRM to masked register 0x%08X\n",
 						  reg_addr);
 					return false;
 				}
 
-				if (desc->cmd.value == MI_LOAD_REGISTER_REG) {
+				if (cmd_desc_is(desc, MI_LOAD_REGISTER_REG)) {
 					DRM_DEBUG("CMD: Rejected LRR to masked register 0x%08X\n",
 						  reg_addr);
 					return false;
 				}
 
-				if (desc->cmd.value == MI_LOAD_REGISTER_IMM(1) &&
+				if (cmd_desc_is(desc, MI_LOAD_REGISTER_IMM(1)) &&
 				    (offset + 2 > length ||
 				     (cmd[offset + 1] & reg->mask) != reg->value)) {
 					DRM_DEBUG("CMD: Rejected LRI to masked register 0x%08X\n",
@@ -1478,7 +1484,7 @@ int intel_engine_cmd_parser(struct intel_engine_cs *engine,
 			break;
 		}
 
-		if (desc->cmd.value == MI_BATCH_BUFFER_START) {
+		if (cmd_desc_is(desc, MI_BATCH_BUFFER_START)) {
 			ret = check_bbstart(cmd, offset, length, batch_length,
 					    batch_addr, shadow_addr,
 					    jump_whitelist);

