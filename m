Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4F3376669
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 15:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbhEGNwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 09:52:19 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:43449 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233394AbhEGNwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 09:52:18 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4CFCB1941D60;
        Fri,  7 May 2021 09:51:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 07 May 2021 09:51:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=vKb0uZ
        J8nxUA7NjoA0e61DrB75hjJ1qzoltwq1nBcgk=; b=D4raahuw/cYUq5bTMzzOuy
        u2SOEChs/Kn9sDdz3Gf7NqFwFasVVO+aMOPUK+Oy5EACXyIn8SbHf3YUO+MbwP4P
        VjstEegaXb1Zpti55lJA8VIZOU4Glw5twSDTfz9CRIpQQUEQzYzMeK2jQCfK43nG
        kGAZd26J+vLq2NO+Fun37hjtRWjmZwanSBMrN/yRJ0M9RTacyko1QoDRy/pRD4s/
        cWVKSeZNAihPWLDrxVbE8JOecjJFDQLI8bwIp9hXzTWEid9JEauJ3vRhlrETdBpR
        068wFRtc60vrVW9stJMc8ohLf0O9hO8h82agDoHeWmkA6eSzUp8wqkaq2UXMrGeQ
        ==
X-ME-Sender: <xms:1EWVYEAiQT1qytKUj-3sf1nWH4YV2xEL-75bM0yY181UpxlDo50slA>
    <xme:1EWVYGgxd_SannnvbWNUo5qXKqVy0_03sPj8Bpnub4x5HnGgWkgQy7jQ5MKf3RCqD
    iYYlasSE7JlPA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegvddgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:1EWVYHnRY-AQC1W7PyFa4ooaXbuYDnFFeoDP4Re9F-4ckUU1dGFcCA>
    <xmx:1EWVYKxSIoeXBfWiFc-PVIH2fWlxCwnYq4FaKaZYhHisUP7f9rap0w>
    <xmx:1EWVYJR_t_qrtWZyaWb1wwjCmoTUUmLDhZpBHxZrqGfAX2KeJqbWMw>
    <xmx:1EWVYEMp2baF_PdbRCgzuK3jisPGx8OQsFVD9UQGiG2g3s97qAZ0gQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri,  7 May 2021 09:51:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ftrace: Handle commands when closing set_ftrace_filter file" failed to apply to 4.14-stable tree
To:     rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 May 2021 15:51:13 +0200
Message-ID: <16203954739926@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8c9af478c06bb1ab1422f90d8ecbc53defd44bc3 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Wed, 5 May 2021 10:38:24 -0400
Subject: [PATCH] ftrace: Handle commands when closing set_ftrace_filter file

 # echo switch_mm:traceoff > /sys/kernel/tracing/set_ftrace_filter

will cause switch_mm to stop tracing by the traceoff command.

 # echo -n switch_mm:traceoff > /sys/kernel/tracing/set_ftrace_filter

does nothing.

The reason is that the parsing in the write function only processes
commands if it finished parsing (there is white space written after the
command). That's to handle:

 write(fd, "switch_mm:", 10);
 write(fd, "traceoff", 8);

cases, where the command is broken over multiple writes.

The problem is if the file descriptor is closed, then the write call is
not processed, and the command needs to be processed in the release code.
The release code can handle matching of functions, but does not handle
commands.

Cc: stable@vger.kernel.org
Fixes: eda1e32855656 ("tracing: handle broken names in ftrace filter")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 057e962ca5ce..c57508445faa 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5591,7 +5591,10 @@ int ftrace_regex_release(struct inode *inode, struct file *file)
 
 	parser = &iter->parser;
 	if (trace_parser_loaded(parser)) {
-		ftrace_match_records(iter->hash, parser->buffer, parser->idx);
+		int enable = !(iter->flags & FTRACE_ITER_NOTRACE);
+
+		ftrace_process_regex(iter, parser->buffer,
+				     parser->idx, enable);
 	}
 
 	trace_parser_put(parser);

