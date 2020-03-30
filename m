Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B24197B97
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 14:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbgC3MLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 08:11:50 -0400
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:51313 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729996AbgC3MLu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 08:11:50 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 72A954B2;
        Mon, 30 Mar 2020 08:11:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 30 Mar 2020 08:11:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mr9BuW
        uhoi5sSI0hU2GQHVOfqteXFqaxIWvV9A6MaXM=; b=hAfve7q/qX3reyKlFzTeC2
        LYRG7Pk1WgbP26kQMwuOUMPksDmJLMXBubzmmMHb1N3XYwjalYjRPqfDL0U7hgiX
        549piSnurvbsvaxceIYWUKMwmDUOhLA1JmMuQB0rtzrv2RHvZtuwUX//YmHc65D/
        lu9uAgCoshaGhZ2OBJ+3yqLtZ+2mwkb5gi3pcqzz4G+6nhTNYAY2NtPB+iXMfWeo
        ReJnAU7U7fZAa5Y3C6La4QA3IB/PoEQ35KotGLH2E2h5gRLClTFojbnS/ElTnHAw
        yS2nYdAm5azS6FilB6w3GZUXKDQ/xPevYQqS7gn2m0TAu5fUBYn9Sv0BcRt7N7UQ
        ==
X-ME-Sender: <xms:A-KBXvdXhRqfpYAiYeOYVxwVRK3Lw0qs35cY0dBJ8n1z-v3vBgpCCg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:A-KBXpf6fC-KwnRu5sZWBJEJTcqnM-cIc3xnDjAp2DCmoOaRglUPug>
    <xmx:A-KBXsFP33jaOpoMMS32uzGpNgDnACDR8R7WOBataRgm_kzU_KINtA>
    <xmx:A-KBXgFs1FSXwch-mnfqw8QBt259FKE0ztj6AxTF1GXyWbFmC_ZP8g>
    <xmx:BOKBXvNZnM1Hp8zsroYS1lDslK2mXXOiwOsDQ9E9u4SqtOlqIb7hSAfeQaM>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AA905306C9BE;
        Mon, 30 Mar 2020 08:11:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tools: Let O= makes handle a relative path with -C option" failed to apply to 4.9-stable tree
To:     mhiramat@kernel.org, acme@redhat.com, akpm@linux-foundation.org,
        bp@alien8.de, geert@linux-m68k.org, jolsa@redhat.com,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        peterz@infradead.org, rdunlap@infradead.org, rostedt@goodmis.org,
        sashal@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 30 Mar 2020 14:11:36 +0200
Message-ID: <1585570296177156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From be40920fbf1003c38ccdc02b571e01a75d890c82 Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Sat, 7 Mar 2020 03:32:58 +0900
Subject: [PATCH] tools: Let O= makes handle a relative path with -C option

When I tried to compile tools/perf from the top directory with the -C
option, the O= option didn't work correctly if I passed a relative path:

  $ make O=BUILD -C tools/perf/
  make: Entering directory '/home/mhiramat/ksrc/linux/tools/perf'
    BUILD:   Doing 'make -j8' parallel build
  ../scripts/Makefile.include:4: *** O=/home/mhiramat/ksrc/linux/tools/perf/BUILD does not exist.  Stop.
  make: *** [Makefile:70: all] Error 2
  make: Leaving directory '/home/mhiramat/ksrc/linux/tools/perf'

The O= directory existence check failed because the check script ran in
the build target directory instead of the directory where I ran the make
command.

To fix that, once change directory to $(PWD) and check O= directory,
since the PWD is set to where the make command runs.

Fixes: c883122acc0d ("perf tools: Let O= makes handle relative paths")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/158351957799.3363.15269768530697526765.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7902a5681fc8..b8fc7d972be9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -35,7 +35,7 @@ endif
 # Only pass canonical directory names as the output directory:
 #
 ifneq ($(O),)
-  FULL_O := $(shell readlink -f $(O) || echo $(O))
+  FULL_O := $(shell cd $(PWD); readlink -f $(O) || echo $(O))
 endif
 
 #
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index ded7a950dc40..6d2f3a1b2249 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 ifneq ($(O),)
 ifeq ($(origin O), command line)
-	dummy := $(if $(shell test -d $(O) || echo $(O)),$(error O=$(O) does not exist),)
-	ABSOLUTE_O := $(shell cd $(O) ; pwd)
+	dummy := $(if $(shell cd $(PWD); test -d $(O) || echo $(O)),$(error O=$(O) does not exist),)
+	ABSOLUTE_O := $(shell cd $(PWD); cd $(O) ; pwd)
 	OUTPUT := $(ABSOLUTE_O)/$(if $(subdir),$(subdir)/)
 	COMMAND_O := O=$(ABSOLUTE_O)
 ifeq ($(objtree),)

