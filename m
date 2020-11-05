Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC392A8243
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 16:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730854AbgKEPdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 10:33:33 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:46643 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730660AbgKEPdd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 10:33:33 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id C0285D70;
        Thu,  5 Nov 2020 10:33:30 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 05 Nov 2020 10:33:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=RWnlXF
        gmqfrMr//UuefpUEF8PT8HBWzGk68cYQ941mo=; b=Fbxf5DNtMtyCalSC2pQR6c
        3a2AhTo6bL30dib7DlOP7NavKBt9kmy9IJeNoAIMxlC2iaM1WzAL8za68UMwODbg
        4+KLUCs1PaGZVhxtxO4odOgF8mefDrc6mMt4iRd0WH1epLJQrMVcUxDBppS4TRYH
        aDBlh6FBwYzAg/HyG3aWbVPl+dsCJhiJw19r3DdA0+d2k0Xs4pVHGCvswGELd5M7
        4huJEauDmpxpZwFE4EYU6zbqFrs0nprI3zDQ8+KGDQzLv58t9SJ06qfPJQ0BOgkU
        2c/DoJV1t7+6p7CwebHI+SM9kC1w5aaBK0mVxjltpR6aTo1ThBZhDYqu2Oop9GqQ
        ==
X-ME-Sender: <xms:ShukXzdeFePMW_k759GIIrjuTkJwvQkDRftfO--6OuI2lY49Tc2kQQ>
    <xme:ShukX5OjaLfVdoXETGQlpTsypmAcueD7EpQnyuyuQgVcTIJgLVqX3weEtI81z8wuu
    vC46z5yutDcQw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtjedgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ShukX8gPaFfecYSrBI_IeM9ZneaOBM-oCMItIcesJWxgPSxUJJpAMg>
    <xmx:ShukX0_Uv_ZmEovyWjAJ5kKC1O99bOSL5J64NaoBz1BOArSKtxfJ-A>
    <xmx:ShukX_sjhN9I_0iW_L4uZWUIo7Q9FxxEEtcqi6FSTLdUpS70BkXyPg>
    <xmx:ShukX46Vc7dYRdqJq0CYr2iYBbScH7rbDiCjvI0sO7R21VdANYadg8hmmCo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9EB3D3280391;
        Thu,  5 Nov 2020 10:33:29 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Wait for CSB entries on Tigerlake" failed to apply to 5.4-stable tree
To:     chris@chris-wilson.co.uk, mika.kuoppala@linux.intel.com,
        rodrigo.vivi@intel.com, yu.bruce.chang@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 05 Nov 2020 16:34:18 +0100
Message-ID: <16045904582658@kroah.com>
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

From 4a9bb58aba6db4eba2a8b3aa1edc415c94a669a8 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Tue, 15 Sep 2020 14:49:21 +0100
Subject: [PATCH] drm/i915/gt: Wait for CSB entries on Tigerlake

On Tigerlake, we are seeing a repeat of commit d8f505311717 ("drm/i915/icl:
Forcibly evict stale csb entries") where, presumably, due to a missing
Global Observation Point synchronisation, the write pointer of the CSB
ringbuffer is updated _prior_ to the contents of the ringbuffer. That is
we see the GPU report more context-switch entries for us to parse, but
those entries have not been written, leading us to process stale events,
and eventually report a hung GPU.

However, this effect appears to be much more severe than we previously
saw on Icelake (though it might be best if we try the same approach
there as well and measure), and Bruce suggested the good idea of resetting
the CSB entry after use so that we can detect when it has been updated by
the GPU. By instrumenting how long that may be, we can set a reliable
upper bound for how long we should wait for:

    513 late, avg of 61 retries (590 ns), max of 1061 retries (10099 ns)

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2045
References: d8f505311717 ("drm/i915/icl: Forcibly evict stale csb entries")
References: HSDES#22011327657, HSDES#1508287568
Suggested-by: Bruce Chang <yu.bruce.chang@intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Bruce Chang <yu.bruce.chang@intel.com>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: stable@vger.kernel.org # v5.4
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200915134923.30088-2-chris@chris-wilson.co.uk
(cherry picked from commit 233c1ae3c83f21046c6c4083da904163ece8f110)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 1a7bbbb16356..a32aabce7901 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -2497,9 +2497,22 @@ invalidate_csb_entries(const u64 *first, const u64 *last)
  */
 static inline bool gen12_csb_parse(const u64 *csb)
 {
-	u64 entry = READ_ONCE(*csb);
-	bool ctx_away_valid = GEN12_CSB_CTX_VALID(upper_32_bits(entry));
-	bool new_queue =
+	bool ctx_away_valid;
+	bool new_queue;
+	u64 entry;
+
+	/* HSD#22011248461 */
+	entry = READ_ONCE(*csb);
+	if (unlikely(entry == -1)) {
+		preempt_disable();
+		if (wait_for_atomic_us((entry = READ_ONCE(*csb)) != -1, 50))
+			GEM_WARN_ON("50us CSB timeout");
+		preempt_enable();
+	}
+	WRITE_ONCE(*(u64 *)csb, -1);
+
+	ctx_away_valid = GEN12_CSB_CTX_VALID(upper_32_bits(entry));
+	new_queue =
 		lower_32_bits(entry) & GEN12_CTX_STATUS_SWITCHED_TO_NEW_QUEUE;
 
 	/*
@@ -4006,6 +4019,8 @@ static void reset_csb_pointers(struct intel_engine_cs *engine)
 	WRITE_ONCE(*execlists->csb_write, reset_value);
 	wmb(); /* Make sure this is visible to HW (paranoia?) */
 
+	/* Check that the GPU does indeed update the CSB entries! */
+	memset(execlists->csb_status, -1, (reset_value + 1) * sizeof(u64));
 	invalidate_csb_entries(&execlists->csb_status[0],
 			       &execlists->csb_status[reset_value]);
 

