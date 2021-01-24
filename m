Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6685301C42
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbhAXNeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:34:44 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:60967 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbhAXNen (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 08:34:43 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 5D10EE14;
        Sun, 24 Jan 2021 08:33:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 Jan 2021 08:33:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=etr+kT
        GJzq7QATnXqdTCBNd4PY9c+ucEzXtrYMUQheM=; b=X00iY6n70yjz4IO6kLArCP
        6m2KiGa9YJoGoU7iZjI/hHc2Ds3PpODQhyDHnfBum6oMrqHRRWEii1qMVpAgNYfW
        EIM05E3zOOKsGDkKYSoQoGXcW0/wIJVe6bYj5Klf8nPkpFaG+kdR2QfO2HaQMigO
        Vg+bmulCiS0/rPKMqQAWSCVBO4Qyym6PAX5BaaNkx40MypeZRqh29Du6u1hKdd+9
        AxskilXEC38c7EY97jqTwUCBxLEHET3wH8jHHdpUoTIhB4S+IXRWfYqNjge5s7u8
        +2c06QSDAf1KfU3xnbA9TmufpNcwNS8XB9YgDBT5TYbN3g7104e4viNTHxFTPshQ
        ==
X-ME-Sender: <xms:LncNYAcaCK6NmqvMi_UiNl4D9hcvvxqGytc6v9q7fjm9pT4T3e_PwA>
    <xme:LncNYCN7P7mmPDa1uxawShDf69AQzKOhJdfg50oWjew5ubfkxmbDph4BLexnbaVPP
    kc8Jn9toXxpsw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtudeuje
    fhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghen
    ucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:LncNYBg4Tb7pd3Mi7CgpMU4Ev8l2J8IKJCEUy8vR1cnhk9XVSvfIwA>
    <xmx:LncNYF_eSTJKDYOp6imb2qF_FQF8DOolKZALaIg-Jza3IB_o_-YZHQ>
    <xmx:LncNYMvMFGWvRUJ7vd5ccV9o-7Hifs7adv5oqD2mxT0ySajAb7QKOQ>
    <xmx:LncNYIKNP5ci9ouWAk-9nGORhS68Pgb53gD_bKmuRdX6-USEsk9Sg7ZOhiw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3890C1080059;
        Sun, 24 Jan 2021 08:33:34 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Prevent use of engine->wa_ctx after error" failed to apply to 4.19-stable tree
To:     chris@chris-wilson.co.uk, jani.nikula@intel.com,
        matthew.d.roper@intel.com, mika.kuoppala@linux.intel.com,
        stable@vger.kernel.org, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Jan 2021 14:33:33 +0100
Message-ID: <161149521310278@kroah.com>
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

From 488751a0ef9b5ce572c47301ce62d54fc6b5a74d Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Mon, 18 Jan 2021 09:53:32 +0000
Subject: [PATCH] drm/i915/gt: Prevent use of engine->wa_ctx after error

On error we unpin and free the wa_ctx.vma, but do not clear any of the
derived flags. During lrc_init, we look at the flags and attempt to
dereference the wa_ctx.vma if they are set. To protect the error path
where we try to limp along without the wa_ctx, make sure we clear those
flags!

Reported-by: Matt Roper <matthew.d.roper@intel.com>
Fixes: 604a8f6f1e33 ("drm/i915/lrc: Only enable per-context and per-bb buffers if set")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v4.15+
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210108204026.20682-1-chris@chris-wilson.co.uk
(cherry-picked from 5b4dc95cf7f573e927fbbd406ebe54225d41b9b2)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210118095332.458813-1-chris@chris-wilson.co.uk

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 7614a3d24fca..26c7d0a50585 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -3988,6 +3988,9 @@ static int lrc_setup_wa_ctx(struct intel_engine_cs *engine)
 static void lrc_destroy_wa_ctx(struct intel_engine_cs *engine)
 {
 	i915_vma_unpin_and_release(&engine->wa_ctx.vma, 0);
+
+	/* Called on error unwind, clear all flags to prevent further use */
+	memset(&engine->wa_ctx, 0, sizeof(engine->wa_ctx));
 }
 
 typedef u32 *(*wa_bb_func_t)(struct intel_engine_cs *engine, u32 *batch);

