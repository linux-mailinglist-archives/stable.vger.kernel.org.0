Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051F5328051
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 15:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236127AbhCAOJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 09:09:06 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:38417 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236064AbhCAOIl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 09:08:41 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id F409019422BB;
        Mon,  1 Mar 2021 09:07:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 09:07:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rPl0+s
        EDNIL44YjDvSJ4oDWtpMR9scApCY7RmO5r3yc=; b=SSUSOCeMWbwErEeiTbyHAj
        Pa8r/DTUAOa+oeGXbdEbRpgPE9y74AHsfQlIe7T7dgVzzrJpkR0Ul3baW4a/m6ng
        ieb/FFBPKa1N7nuVRltdZP0VwBQpn5m+aexMyvV+8IIPN26IEvZV0YGyAIyl2YI9
        /KMfK0iCHrhkVCb2LCJgTEixYSl1Il1lLbhm8caVb6YRYbOag7D8CjvBQscViPqu
        eit8oZuiewFjd7pV9eXltuxZEJpaNk2WK12BQ+ofwzWvPqZU/4+I6ZO+DK9nwNQR
        RZ2GhIKG1VHLlWIcPE5hIJqg++9kAnbRIVZoqIA6A6vt54UUCZSZ85A9YJXOuLNg
        ==
X-ME-Sender: <xms:NPU8YGWLsS9eTAwibX8lkUe8B9VWwNzdtH9m1n9TgllQX3D-TxR4Pw>
    <xme:NPU8YCk05zA39FhqnU9SDp8UzKedhtHcssFFeFtHSLdGdoXTqZCccH2sGvZuukwHx
    P43p56WadTKEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtudeuje
    fhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghen
    ucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:NfU8YKZjeiajkQSY2w8lQbYZ2Q-Y2WHYsp1N3gOahQThmyV8MHELOw>
    <xmx:NfU8YNX9jm2ngvNLF7u388Dgq5-M-yE9IvSOQsL6aKLspyyO3KNTHw>
    <xmx:NfU8YAk2jxAANbq8yNd-9drYmuDEqNlDyG_Wt8iTYmyXgmZN3tK70Q>
    <xmx:NfU8YHsP9qLvfxLdrmhxJz_TSzhlVbppd-bUXH0GXboyHAw-xIZ_aw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A5CE31080054;
        Mon,  1 Mar 2021 09:07:48 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Ignore repeated attempts to suspend request flow" failed to apply to 5.10-stable tree
To:     chris@chris-wilson.co.uk, mika.kuoppala@linux.intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 15:07:41 +0100
Message-ID: <161460766115637@kroah.com>
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

