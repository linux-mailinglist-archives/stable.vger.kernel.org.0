Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D8B2A8245
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 16:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731180AbgKEPdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 10:33:40 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51213 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731089AbgKEPdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 10:33:39 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id AD425BDC;
        Thu,  5 Nov 2020 10:33:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 05 Nov 2020 10:33:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=mfL1KS
        TtGVyb9S5h7AkFs1XohQbr1SKzfQuapf2G7e0=; b=eoU5PFLX9yPnEDODPHARhD
        RuBZm966ixW9f0NmqKXJe6Fg75rsNr9sCiSuETk+5OFwPnA9bwliHdeCmLET0iZC
        kjLBzUYQTOo2+KxDoi7Ly8jHlxv2qxLwDZlpp/eACRcAnEUGB/jt82yfoM4epM6F
        Fen88QG/DhonPos+j5pgmU03oOt/MLTDAo/1+hbOpfNAWkYtKLxuhOJeU8GBgTHA
        T7TXRscdUoSGyLyGKApdl10ZyoWwf/OMgd+RyjrvAfFhY6cyXC4JZXWjLhbFh3lI
        W/dr+5uIef8UV+1Xr5C2GujFSrhho+lbLGi99R9Wjd7G82krLbqb0oTmWLmU/3dQ
        ==
X-ME-Sender: <xms:UhukX9UcHIymE7SzT0JbBcs1WEbATO6TuoqQO9Dbasdt9cHhOf4dDw>
    <xme:UhukX9nAMXw_bcpeEOmTNBjMHUnQq8wx4qE1_H-cuwufw_-u5EsD0U41wt42XoBf4
    7Y1-a7pekY_WA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtjedgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:UhukX5Zq3oHD-tgJjyQzED289rJvpkE8H20oDwMd0GMGYjorbfbAxw>
    <xmx:UhukXwWSobpyJspFXGToLRXhDu6ZPJANw4BmjmdbvTfLuz-2bTr6Cw>
    <xmx:UhukX3lu287Hf6uE8hsUrHscQ_AcWeKaWFZnP_cje5XrWCQfD4kD1w>
    <xmx:UhukX8xxLs9vMR6k9i1oCrWHMOLA4i5IrgXUAB79GYoGEhee4Qn6LVQ3pBo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B4A1F306005F;
        Thu,  5 Nov 2020 10:33:37 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Wait for CSB entries on Tigerlake" failed to apply to 5.9-stable tree
To:     chris@chris-wilson.co.uk, mika.kuoppala@linux.intel.com,
        rodrigo.vivi@intel.com, yu.bruce.chang@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 05 Nov 2020 16:34:19 +0100
Message-ID: <16045904598766@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
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
 

