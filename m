Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C096C811D0
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfHEF5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:57:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45569 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfHEF5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:57:13 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2056320F44;
        Mon,  5 Aug 2019 01:57:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:57:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=w7xmNq
        kbKScilxTcMhgkK/gTm0LhPodHW5a4wEs5KQI=; b=gXeeRMC98VuNuhRmNuEEHg
        M83l1Cf26z4t55KY08rNlqV9bolBKjC6ei+8U3/DzW0IHGVpiFx0X1p4WrQkAz+p
        SGNIQO5440UQwCNRjp960xKE1ko1Z9Pl4clDbW+HQCT7EfGA2DyJjRZ3/Sfl5f89
        K1syMSeKOX3ZGJB1gTQsYF6zjCrfY3YyWlOfSSHtGTULRMeSml+VgFps0mj/79sV
        fvcl4um3Grj5u+4B3wFWjtlhnbLtNyG/Btokw8C4GMVEtKTPguFmMutrpWM9Uxye
        CaGzMsSVil+OuGprRlYvD/RTYTBPr6jojRHEqqsfDGwiKm2CqJxyg9S3WQe+YnRw
        ==
X-ME-Sender: <xms:N8VHXUgOOHFiKmFBNcT8orMpscrUieVpmhFBP-_Qnw42ZyqTbB9X8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:N8VHXe2vuzHGZSHxqjpWIdiWy1q-RRntMKXTxzEHL1JytUPbbnBcgw>
    <xmx:N8VHXd3_2R8dA4fW0iwMv8X5gFIu62y09pw08IK4nmQvTAWDC-99Tw>
    <xmx:N8VHXWdJkLnkR2BbRtJnZ3guzSc1iESOaG4_nreZyXBkhcXzqKksGA>
    <xmx:OMVHXRNF21y-YCEXCM1GTrQdHTBM7IgjyoH7a7VCTWKSxNcF_evCmg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7CFB3380084;
        Mon,  5 Aug 2019 01:57:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Disable SAMPLER_STATE prefetching on all Gen11" failed to apply to 5.2-stable tree
To:     kenneth@whitecape.org, chris@chris-wilson.co.uk,
        jani.nikula@intel.com, mika.kuoppala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:57:10 +0200
Message-ID: <156498463086244@kroah.com>
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

From 248f883db61283b4f5a1c92a5e27277377b09f16 Mon Sep 17 00:00:00 2001
From: Kenneth Graunke <kenneth@whitecape.org>
Date: Tue, 25 Jun 2019 10:06:55 +0100
Subject: [PATCH] drm/i915: Disable SAMPLER_STATE prefetching on all Gen11
 steppings.

The Demand Prefetch workaround (binding table prefetching) only applies
to Icelake A0/B0.  But the Sampler Prefetch workaround needs to be
applied to all Gen11 steppings, according to a programming note in the
SARCHKMD documentation.

Using the Intel Gallium driver, I have seen intermittent failures in
the dEQP-GLES31.functional.copy_image.non_compressed.* tests.  After
applying this workaround, the tests reliably pass.

v2: Remove the overlap with a pre-production w/a

BSpec: 9663
Signed-off-by: Kenneth Graunke <kenneth@whitecape.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@vger.kernel.org
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190625090655.19220-1-chris@chris-wilson.co.uk
(cherry picked from commit f9a393875d3af13cc3267477746608dadb7f17c1)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 15e90fd2cfdc..50c0060509a6 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1258,8 +1258,12 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 		if (IS_ICL_REVID(i915, ICL_REVID_A0, ICL_REVID_B0))
 			wa_write_or(wal,
 				    GEN7_SARCHKMD,
-				    GEN7_DISABLE_DEMAND_PREFETCH |
-				    GEN7_DISABLE_SAMPLER_PREFETCH);
+				    GEN7_DISABLE_DEMAND_PREFETCH);
+
+		/* Wa_1606682166:icl */
+		wa_write_or(wal,
+			    GEN7_SARCHKMD,
+			    GEN7_DISABLE_SAMPLER_PREFETCH);
 	}
 
 	if (IS_GEN_RANGE(i915, 9, 11)) {

