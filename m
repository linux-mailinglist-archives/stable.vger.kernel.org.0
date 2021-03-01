Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6F7328049
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 15:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbhCAOIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 09:08:35 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:47637 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236031AbhCAOIX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 09:08:23 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id C684F1940EF0;
        Mon,  1 Mar 2021 09:07:04 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 01 Mar 2021 09:07:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=gTw6oI
        KOgZa7rOUuwx06O+8v1pPHUJo71+PhMI5BXmg=; b=qn/mGVvOPO/EeLEHihQRhl
        yvr3YamarHARHMUYzpZFqfMPCYp+jYP11laso8PR7uMcrVhoy7b3VsxBudXqaVc/
        oF3dt/FP+SkOQMxZ1WA2uAkTU4WRCEaYX8Z9kBFMQTW16NMCJqr1YtOwIr8jXCHU
        I3lt5SC7h65WUnkYa5dmsEPDplNinDRxyBJSHuyXM8FN5MIr1z7z3Hq6JvNN+vht
        tQNlvJn2RvYqXXZxgHGhJZ/yFKqnuZ7sITV8z2nsoZXVNnhPE8APT4TvY9oNipdF
        bKjFFemW39glhy9WBcfgkA51xyCn2epmSV4HYQOe/yyifAlPpzTjMRqxps474LBQ
        ==
X-ME-Sender: <xms:B_U8YId3doEWTGmpcK_y1i6xKbp5mCAh9Ht8qYQY_iFfbCBFs7d90A>
    <xme:B_U8YNc2xgVzdySRqKVbPyECz4aW_hVZCAaYm_URmLtKyPhkVg1lMjPvEvaPeannG
    zsCwE1CPx5A0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtudeuje
    fhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghen
    ucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:B_U8YC8HqXNGuxpTT1E8HFbKSOYSNe1ZgmFEHErgO5LF2m0fMi08ng>
    <xmx:B_U8YJnEIecDQUnZcdKT8Jxwv5nOkLoMKwXoH98S-QFcw_OfWX_d7w>
    <xmx:B_U8YE-sn7UGq-siYI8rwAt3US-nrpHOSqZTlN04sjx_3CGUhzjLLQ>
    <xmx:CPU8YPGwQ_diucILMzgA48m8aP5zChEKBDOQLA_OJRCx2VotXA39YA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B3F6024005D;
        Mon,  1 Mar 2021 09:07:03 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Ignore repeated attempts to suspend request flow" failed to apply to 5.11-stable tree
To:     chris@chris-wilson.co.uk, mika.kuoppala@linux.intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 15:07:02 +0100
Message-ID: <161460762224897@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From b969540500bce60cf1cdfff5464388af32b9a553 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Fri, 4 Dec 2020 15:12:31 +0000
Subject: [PATCH] drm/i915/gt: Ignore repeated attempts to suspend request flow
 across reset

Before reseting the engine, we suspend the execution of the guilty
request, so that we can continue execution with a new context while we
slowly compress the captured error state for the guilty context. However,
if the reset fails, we will promptly attempt to reset the same request
again, and discover the ongoing capture. Ignore the second attempt to
suspend and capture the same request.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1168
Fixes: 32ff621fd744 ("drm/i915/gt: Allow temporary suspension of inflight requests")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v5.7+
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201204151234.19729-1-chris@chris-wilson.co.uk

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 43703efb36d1..1d209a8a95e8 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -2823,6 +2823,9 @@ static void __execlists_hold(struct i915_request *rq)
 static bool execlists_hold(struct intel_engine_cs *engine,
 			   struct i915_request *rq)
 {
+	if (i915_request_on_hold(rq))
+		return false;
+
 	spin_lock_irq(&engine->active.lock);
 
 	if (i915_request_completed(rq)) { /* too late! */

