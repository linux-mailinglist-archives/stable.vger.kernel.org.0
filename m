Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF77811CF
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbfHEF46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:56:58 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37793 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfHEF46 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:56:58 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id CE6BD20A14;
        Mon,  5 Aug 2019 01:56:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:56:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=XXkI2G
        PVoRS5QJd4aqhzzkaimGK4iFA46AvGhUHRqII=; b=0B1/rwJBd2PTqRb9Xd1RZa
        mwXZO46lAVgF93ED7oKQla7Ei3H5cg86OMpb2/WcIO+n6io/x1jgdkjfiPQwofzw
        WECHF+IDOzw05vlP2AnlY2vvpOWTRRlVK7m+eaTFgYh0ko0+Sj3B/bWMYwH9oeup
        gf80p33IJTH39h66KYlcb6zZn1JAMPS70R4tUtrg4u00Lvm68TRjithNPcSnnNQe
        HO8AcSP7TAMsgTanoOmpBhCpJ2luC1wKE3Xw4XFXqVlGiP5LjhZDLDMUOKg8/UnO
        CRu3vAUxK8w+gdBv/lSdFLfeSqJqsaEqXH+2ffl+5Z/8fe/+7irN0sgLYbZf7j+w
        ==
X-ME-Sender: <xms:KcVHXfQaR9wmEsHHoeob0ICap02rJYMIzU_OaoIPLvOo8vv18wv7YA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:KcVHXYj0P_humFBZBaa6TbpAZRe61CzHiKLp1eUcDaG4QLq5Y1jH4g>
    <xmx:KcVHXZ29YN0XaC7PYY9kCdLqbySTxeLthZbB2PXpbqXJ2YAXEBcOjg>
    <xmx:KcVHXXCEHCE9Xfep_X2NZtqBd9Vzf7ZmhQfrhOJAuoK1zdq0OndDow>
    <xmx:KcVHXaGqKISuvhFdk6hL9CMy-JKcLtyIOFtgF2p4n-uzowrpPrI8hA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4DB1A380083;
        Mon,  5 Aug 2019 01:56:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: whitelist PS_(DEPTH|INVOCATION)_COUNT" failed to apply to 5.2-stable tree
To:     lionel.g.landwerlin@intel.com, chris@chris-wilson.co.uk,
        jani.nikula@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:56:55 +0200
Message-ID: <1564984615248173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6ce5bfe936ac31d5c52c4b1328d0bfda5f97e7ca Mon Sep 17 00:00:00 2001
From: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Date: Fri, 28 Jun 2019 15:07:19 +0300
Subject: [PATCH] drm/i915: whitelist PS_(DEPTH|INVOCATION)_COUNT

CFL:C0+ changed the status of those registers which are now
blacklisted by default.

This is breaking a number of CTS tests on GL & Vulkan :

  KHR-GL45.pipeline_statistics_query_tests_ARB.functional_fragment_shader_invocations (GL)

  dEQP-VK.query_pool.statistics_query.fragment_shader_invocations.* (Vulkan)

v2: Only use one whitelist entry (Lionel)

Bspec: 14091
Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc: stable@vger.kernel.org # 6883eab27481: drm/i915: Support flags in whitlist WAs
Cc: stable@vger.kernel.org
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20190628120720.21682-3-lionel.g.landwerlin@intel.com
(cherry picked from commit 2c903da50f5a9522b134e488bd0f92646c46f3c0)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 50c0060509a6..b26c3549429e 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1098,10 +1098,25 @@ static void glk_whitelist_build(struct intel_engine_cs *engine)
 
 static void cfl_whitelist_build(struct intel_engine_cs *engine)
 {
+	struct i915_wa_list *w = &engine->whitelist;
+
 	if (engine->class != RENDER_CLASS)
 		return;
 
-	gen9_whitelist_build(&engine->whitelist);
+	gen9_whitelist_build(w);
+
+	/*
+	 * WaAllowPMDepthAndInvocationCountAccessFromUMD:cfl,whl,cml,aml
+	 *
+	 * This covers 4 register which are next to one another :
+	 *   - PS_INVOCATION_COUNT
+	 *   - PS_INVOCATION_COUNT_UDW
+	 *   - PS_DEPTH_COUNT
+	 *   - PS_DEPTH_COUNT_UDW
+	 */
+	whitelist_reg_ext(w, PS_INVOCATION_COUNT,
+			  RING_FORCE_TO_NONPRIV_RD |
+			  RING_FORCE_TO_NONPRIV_RANGE_4);
 }
 
 static void cnl_whitelist_build(struct intel_engine_cs *engine)

