Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFD03AE75C
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 12:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhFUKnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 06:43:17 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:57499 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230393AbhFUKnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 06:43:16 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 423041940ADB;
        Mon, 21 Jun 2021 06:41:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 21 Jun 2021 06:41:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=cAutOw
        oHC9ZfZAk8iIhwHWrblhJp6LGmTH9Fa03NcmI=; b=RW4XQPleVfQSD0jW1oCQtr
        LZC9UmhzoMK4DP4flX7Zywde6+7AsOFOyq12i88n6doLsHRBmHyWubjSZtY3wlIB
        B6mNQA1TlEpD4T4BxKOUW2lAhPT9C7pjCe9oT4snx2+2IUW2W4OZ0Oss4nggoW/x
        EHFYnt2j3CjKgg6aMGcVeAbX9hZtOv8tfb91pKMx0mTJ+QNN9Knv9tK+erAZDDZr
        Fwq/nssGO6c8bM/3WVtOSqz/ANH/gqsGMj4WML0me4LFTuVDeTVje8CiMkUl/f9M
        myAHdo3b2ZcuKc+tYI6iRLE7i6FT87IEwETbwwBk7bpre95toRWUrmd46aF24azw
        ==
X-ME-Sender: <xms:vWzQYKgxgd_av90LAzD1JuAhS2PhsAqqzEGlom8APXqa5BFU5W8oHA>
    <xme:vWzQYLAwdfvIezyEdZYIwiRYaQNLDW_PrzjnHLsxNb4kByetrhZ6vM21LX90v1pGn
    MFqOP0CZsb4tw>
X-ME-Received: <xmr:vWzQYCEzRNRtr_RWSRg5KLwzOQH8GY8WIE36j20gw8I9n-_aPKPU0-NfRfJKdjAV5SGiPG8YtR_gNIOQbS9BFmaU2lvtEgdv>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:vWzQYDTXSKyPlqGMDEYYbhP0HEGRYm5wagGKpUjWHhko_HN6wmYBEw>
    <xmx:vWzQYHwdkIRQMoizr8GH3A-KMDopY3VzpyWl9Aw1PjSm7R7LxlhpLQ>
    <xmx:vWzQYB6SECNjzYcdCE8Wzkw7ydBWIUW5bHzo-A62bgq7HyZ5cWFPUg>
    <xmx:vWzQYFYznsPa0PY5hGeugl38CEQ2rR0cp4Z9gGKvgHugjLah8zR6RQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 06:41:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tracing: Do not stop recording cmdlines when tracing is off" failed to apply to 4.4-stable tree
To:     rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 12:40:58 +0200
Message-ID: <16242720581176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

