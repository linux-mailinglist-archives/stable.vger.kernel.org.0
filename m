Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5F2811CE
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfHEF4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:56:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34803 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfHEF4c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:56:32 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A046920F44;
        Mon,  5 Aug 2019 01:56:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:56:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Qpf0E4
        awRIal0eSm4cGeAvfiCZRg4FKwrtsQmsxxvF8=; b=aMqULZw1dN5kW/QN2Oqlcj
        92qSbU4rhH3mhksLzmWP+BaX/b5CXFW9WQD63EIJ+0YEouHQMjY8wjZHU1zE76Iw
        2YSIJNJ0TL8KoP5hV66UZ1ZaO/NE4xX+keo4/WfZiD0DYfNd+EITrtIfGs0eByUK
        BWcpFwjJHKSDpLMPsue2yTBcrD60IvqFJc6Yt+7eF5I56B6IuBXocPXOmtnLWiBx
        V+ak19wMA4oDOVpIwu+DuQMC8bPAzh8DsB8gx0iyjRerFVOl7a0YFUg6kb+h2ozY
        G/Gx4JSv80BjUJC+vu8JvLbx/NoNZvqQqlqG69zTKnhnNmV/Kx40Xex9tXBRVUcg
        ==
X-ME-Sender: <xms:DsVHXVEMCh_vDJgVvjEenuy28Jymz6ae5Ec5geInEbF7xYePfQNRww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:DsVHXUUi7UvNPnZBHdqWqUmz43Na_rscNoOmMwbsqMWFcBPPuIDoww>
    <xmx:DsVHXdwjnPYFDNXWb19GUFkj2QOiCOOIM27EXvYR0hvAzyExqGlOEQ>
    <xmx:DsVHXZTqOgDNitOjXxC-Z07J4pSH2P0MsGZn3IZm5VvkC-iz_keGLg>
    <xmx:D8VHXaUt8T7Rq3YgjtmXE4JmMYRjk_A46b_WRI1_zLdnczhPBJDcRw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 87A3A80062;
        Mon,  5 Aug 2019 01:56:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/icl: whitelist PS_(DEPTH|INVOCATION)_COUNT" failed to apply to 5.2-stable tree
To:     lionel.g.landwerlin@intel.com, anuj.phogat@gmail.com,
        chris@chris-wilson.co.uk, jani.nikula@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:56:29 +0200
Message-ID: <156498458920255@kroah.com>
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

From cf8f9aa1eda7d916bd23f6b8c226404deb11690c Mon Sep 17 00:00:00 2001
From: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Date: Fri, 28 Jun 2019 15:07:20 +0300
Subject: [PATCH] drm/i915/icl: whitelist PS_(DEPTH|INVOCATION)_COUNT

The same tests failing on CFL+ platforms are also failing on ICL.
Documentation doesn't list the
WaAllowPMDepthAndInvocationCountAccessFromUMD workaround for ICL but
applying it fixes the same tests as CFL.

v2: Use only one whitelist entry (Lionel)

Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Tested-by: Anuj Phogat <anuj.phogat@gmail.com>
Cc: stable@vger.kernel.org # 6883eab27481: drm/i915: Support flags in whitlist WAs
Cc: stable@vger.kernel.org
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20190628120720.21682-4-lionel.g.landwerlin@intel.com
(cherry picked from commit 3fe0107e45ab396342497e06b8924cdd485cde3b)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index b26c3549429e..98dfb086320f 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1144,6 +1144,19 @@ static void icl_whitelist_build(struct intel_engine_cs *engine)
 
 		/* WaEnableStateCacheRedirectToCS:icl */
 		whitelist_reg(w, GEN9_SLICE_COMMON_ECO_CHICKEN1);
+
+		/*
+		 * WaAllowPMDepthAndInvocationCountAccessFromUMD:icl
+		 *
+		 * This covers 4 register which are next to one another :
+		 *   - PS_INVOCATION_COUNT
+		 *   - PS_INVOCATION_COUNT_UDW
+		 *   - PS_DEPTH_COUNT
+		 *   - PS_DEPTH_COUNT_UDW
+		 */
+		whitelist_reg_ext(w, PS_INVOCATION_COUNT,
+				  RING_FORCE_TO_NONPRIV_RD |
+				  RING_FORCE_TO_NONPRIV_RANGE_4);
 		break;
 
 	case VIDEO_DECODE_CLASS:

