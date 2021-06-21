Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB703AE75F
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 12:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhFUKnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 06:43:24 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:41787 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230496AbhFUKnX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 06:43:23 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 164731940174;
        Mon, 21 Jun 2021 06:41:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 21 Jun 2021 06:41:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=gjI5ff
        QdxQ+b3q+tOkeQkWW2Na4EykCvwDEC6aSijoY=; b=wcur9kO/JVOrfjP6TEuSg1
        86TXslhu4LNNI3mNbfZ1yUeaoyIA1386m5z7rvVmu11zxtFyLbOEwIxZ4u81BAc0
        svYWSHnu5+DJfijK4cisdVTPHRhkQZyM/Ku8qSvK57rWYECFXzEENFpF1Ntqw6M/
        FAcl/j6Ey+cpyMmkCsqCNYhmP39Ed8I56gS3m67AaI6qHW1te8Q/kYNC1brsV7Wr
        6KXW4qBMSuV4hf4eKNH8fhaGrrsT9PfkUM8t2acgjYkLhZ+S4JlyyliK77AbXZyn
        NyAlWyMhCDonJB4k6NYif31ymZML9l2FjHsdj5uAwbMhQiM9O9pzH42R9opUpLcg
        ==
X-ME-Sender: <xms:xGzQYDkdW1yHDPg6dalsjMGEo68La4vrCD2F15_lvC0WLsylthWzxw>
    <xme:xGzQYG3DjtWxrj884y5wnSijbcmVJ_mROzhJrrdocFf8yw6ZzEItgWDuOGiNd2Lwx
    crPQ-cHi_iNkw>
X-ME-Received: <xmr:xGzQYJp7Odc7gkJwm6FCZ7FccUTZhkKwInRpOdVWxK938x98P_tz3S90316Fs2rWaPOKg0K61imFe3ZEPzGNZG-NiOhbxycO>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:xGzQYLloYQsHXc5d6u08EMlDrdthxME1jWzuOR4fnl8bef8vzE1GIA>
    <xmx:xGzQYB2RX5FBtkdeua3WexoSwMabYBHJBnv_hNovXm_6UAaAlrZwAQ>
    <xmx:xGzQYKtzsy80C_3hwR3N5JbC7OiLjlZAAJ4V81CmEP0YsB1g5qLXWg>
    <xmx:xWzQYO-xvB1nyVqtWUXB4NmEnLMGWFC6pqbJ3aUOGZaZLCEyRbK11g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 06:41:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tracing: Do not stop recording cmdlines when tracing is off" failed to apply to 4.9-stable tree
To:     rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 12:40:59 +0200
Message-ID: <1624272059104109@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 85550c83da421fb12dc1816c45012e1e638d2b38 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Thu, 17 Jun 2021 13:47:25 -0400
Subject: [PATCH] tracing: Do not stop recording cmdlines when tracing is off

The saved_cmdlines is used to map pids to the task name, such that the
output of the tracing does not just show pids, but also gives a human
readable name for the task.

If the name is not mapped, the output looks like this:

    <...>-1316          [005] ...2   132.044039: ...

Instead of this:

    gnome-shell-1316    [005] ...2   132.044039: ...

The names are updated when tracing is running, but are skipped if tracing
is stopped. Unfortunately, this stops the recording of the names if the
top level tracer is stopped, and not if there's other tracers active.

The recording of a name only happens when a new event is written into a
ring buffer, so there is no need to test if tracing is on or not. If
tracing is off, then no event is written and no need to test if tracing is
off or not.

Remove the check, as it hides the names of tasks for events in the
instance buffers.

Cc: stable@vger.kernel.org
Fixes: 7ffbd48d5cab2 ("tracing: Cache comms only after an event occurred")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9299057feb56..e220b37e29c6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2486,8 +2486,6 @@ static bool tracing_record_taskinfo_skip(int flags)
 {
 	if (unlikely(!(flags & (TRACE_RECORD_CMDLINE | TRACE_RECORD_TGID))))
 		return true;
-	if (atomic_read(&trace_record_taskinfo_disabled) || !tracing_is_on())
-		return true;
 	if (!__this_cpu_read(trace_taskinfo_save))
 		return true;
 	return false;

