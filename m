Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6174D32805D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 15:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236223AbhCAOKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 09:10:21 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:60297 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236202AbhCAOKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 09:10:11 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6B39019422D0;
        Mon,  1 Mar 2021 09:08:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 09:08:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=cH89vD
        IKTyiCvJ2AwrhpvuC4VAuj5np2uu8YSJzX+Ko=; b=vrCJLXR+31yeZyXtoWB2QN
        Msr5S2mJ4CDKKIn/luz7p9ZLSiQP09oixJnz/XiWNrcLdNqxTpuX4OE+0MYILpwF
        uqhla0IqYfnbxudNgJ6AL8PgeLyn6rTFtq2x0H3ZMccWJEOooNbWckcwYit5PpJ4
        K9npehm05+xfyRssk8w6rrMELBrZKJOlXCfk5MDgIbeBxjUqF0tEzUrnahAkdlz4
        EqNoOk9pm1RDvlro+zsJ45tnzXD4MWlx/XIbZuIBqi4GOvgNdPzOkuOnZsn81h6c
        NTRlVdGAa+1f0E4w0yFLhTTQUEja7EQMwUyMy7Kt4SJojQsz8Z+dCDWZ618sWSjw
        ==
X-ME-Sender: <xms:dvU8YATIf6cdo4nbXf0fr9D7pR74GOtKuQq1KRjlpGNI6q1NeZ47Eg>
    <xme:dvU8YNzdwUK9Yx3a8hMxcJO-kcECUHweq3gB7CB9n-2x0liL4kT8hv9vigbV5XeBJ
    ejlybTvbt2bgw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtudeuje
    fhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghen
    ucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:dvU8YN12D-A2pBbbw2QDuUnN_nhYfyBY-6_qGoq3EuzykBhgM5uOag>
    <xmx:dvU8YECW_8m4PeNPhCIEp6RyCDaIG3FSrNMS7kZDLaz8MiIwnuI2Vw>
    <xmx:dvU8YJg9FOL1rUjQ_V1BnXHW4FkIPALzxeoRcfbaref3SN6H2xz8oA>
    <xmx:d_U8YHYzlyuCKM9XE2i4VzmjEKkFsg2BQbKPyzy8hc9paSGxpAfDlA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 39A0A108005F;
        Mon,  1 Mar 2021 09:08:54 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915: Disable atomics in L3 for gen9" failed to apply to 5.10-stable tree
To:     chris@chris-wilson.co.uk, jason@jlekstrand.net,
        jason@jlesktrand.net, joonas.lahtinen@linux.intel.com,
        mika.kuoppala@linux.intel.com, rodrigo.vivi@intel.com,
        tvrtko.ursulin@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 15:08:52 +0100
Message-ID: <161460773212463@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 58586680ffadc37636120d9f59955aa5f7a32b7d Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Mon, 25 Jan 2021 22:01:52 +0000
Subject: [PATCH] drm/i915: Disable atomics in L3 for gen9

Enabling atomic operations in L3 leads to unrecoverable GPU hangs, as
the machine stops responding milliseconds after receipt of the reset
request [GDRT]. By disabling the cached atomics, the hang do not occur
and we presume the GPU would reset normally for similar hangs.

Sadly this is a shotgun approach, but since the impact is critical it is
better to err on the safe side and work back from there.

Reported-by: Jason Ekstrand <jason@jlekstrand.net>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=110998
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jason Ekstrand <jason@jlekstrand.net>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Reviewed-by: Jason Ekstrand <jason@jlesktrand.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20210125220152.24070-1-chris@chris-wilson.co.uk
Cc: stable@vger.kernel.org
(cherry picked from commit b267c7ae0ad5b437b068f46919b17f85000154b4)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 3fdcd5ff71dd..ec366cf9ef56 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1834,6 +1834,14 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 		wa_write_or(wal,
 			    GEN8_L3SQCREG4,
 			    GEN8_LQSC_FLUSH_COHERENT_LINES);
+
+		/* Disable atomics in L3 to prevent unrecoverable hangs */
+		wa_write_clr_set(wal, GEN9_SCRATCH_LNCF1,
+				 GEN9_LNCF_NONIA_COHERENT_ATOMICS_ENABLE, 0);
+		wa_write_clr_set(wal, GEN8_L3SQCREG4,
+				 GEN8_LQSQ_NONIA_COHERENT_ATOMICS_ENABLE, 0);
+		wa_write_clr_set(wal, GEN9_SCRATCH1,
+				 EVICTION_PERF_FIX_ENABLE, 0);
 	}
 
 	if (IS_HASWELL(i915)) {
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 598abd2f5b5f..7146cd0f3256 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -8225,6 +8225,7 @@ enum {
 #define  GEN11_LQSC_CLEAN_EVICT_DISABLE		(1 << 6)
 #define  GEN8_LQSC_RO_PERF_DIS			(1 << 27)
 #define  GEN8_LQSC_FLUSH_COHERENT_LINES		(1 << 21)
+#define  GEN8_LQSQ_NONIA_COHERENT_ATOMICS_ENABLE REG_BIT(22)
 
 /* GEN8 chicken */
 #define HDC_CHICKEN0				_MMIO(0x7300)
@@ -12107,6 +12108,12 @@ enum skl_power_gate {
 #define __GEN11_VCS2_MOCS0	0x10000
 #define GEN11_MFX2_MOCS(i)	_MMIO(__GEN11_VCS2_MOCS0 + (i) * 4)
 
+#define GEN9_SCRATCH_LNCF1		_MMIO(0xb008)
+#define   GEN9_LNCF_NONIA_COHERENT_ATOMICS_ENABLE REG_BIT(0)
+
+#define GEN9_SCRATCH1			_MMIO(0xb11c)
+#define   EVICTION_PERF_FIX_ENABLE	REG_BIT(8)
+
 #define GEN10_SCRATCH_LNCF2		_MMIO(0xb0a0)
 #define   PMFLUSHDONE_LNICRSDROP	(1 << 20)
 #define   PMFLUSH_GAPL3UNBLOCK		(1 << 21)

