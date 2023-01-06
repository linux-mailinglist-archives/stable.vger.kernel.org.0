Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8712D660949
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 23:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235901AbjAFWJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 17:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236478AbjAFWIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 17:08:44 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC07584BD6
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 14:08:41 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 33BA35C0040;
        Fri,  6 Jan 2023 17:08:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 06 Jan 2023 17:08:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tyhicks.com; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1673042921; x=1673129321; bh=X+
        7+v+mgu7P0PjY0BmeY5WER7aSL4TAy5EaTuduUugI=; b=xwdafgL60a8dCAIKvQ
        /dZAk3dCyU2jEaTVmRJ/+/U0uTjFfkt948ZbymLK74v3u2Yfd67QVssO7Xfjv//s
        lSTHRKkGCiGNIECmRGrmin7RdYJL4x2b6q8P1VICgyBWt1G18PGSggxQycKpm/CS
        Bou5clwnDfHxNwc3hEgj8WkPrOjQ8LRkvbn+jOuWgBVUo+gH/4wPFYUXQxekTjdZ
        eezTza9ZAmHsM/N4BNnfGGA3dkMfiFupnuwQdOyrcEpctos+JTUyBUJSe+oIrq9X
        96Y27/0I0Tqa80oGCaA3M67DX8KWd+Q+tXUhPVScTFMA4OIq4X+lqBlvxH/xhXai
        mbZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1673042921; x=1673129321; bh=X+7+v+mgu7P0P
        jY0BmeY5WER7aSL4TAy5EaTuduUugI=; b=VHO8ABlNnPDT3g/JzUU+Lbtju7xr/
        YrUKDqE6BBT3bQxXancPL8EO60zUY+Ht7e7z/yaWaSD2ySfNIbmHGPvF//2kQuWp
        iMFnR1IQBYfuLXdD6pNtt30IbjJ/BRIdvZHYPB0SjJOw6/BDlU6AxtkYlyVHnotd
        X7iFG0CgGxYRuyhcM+ZPS0J0wZyjMoG/vXmMVRJZhIDMX1+/3z8GieyfrIHDDxV1
        W17O4qAuNGAyIcGA/x0bKKlSS6C76NB2L9QWdB7lf0b18R9M8HuGXGC2T3ISIadK
        PbIalIDC7cmVWW8Thcky7iBeeCKI3MKBaWxySrcRI/P9FYSdEzbimtQ5Q==
X-ME-Sender: <xms:6Zu4Y4Klj6nWUjsipVnX7n5H3z0Guzgx-ueYHfOqMgX9CTUAPifYiQ>
    <xme:6Zu4Y4Jgqthy1TxnkjU70iauF_3O6RgHz7lLJVU7uk0y25m9nEOjPktJj-G6H061K
    EuDNSFQ5_DiHEV-HNg>
X-ME-Received: <xmr:6Zu4Y4s7eP63sZ1NVWJak4seGKCsMNEnedj0yWGxl8J6Vxj8DyFZokaT3bQfriHQAICkpkb3qDes>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrkedtgdduheejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepvfihlhgv
    rhcujfhitghkshcuoegtohguvgesthihhhhitghkshdrtghomheqnecuggftrfgrthhtvg
    hrnhepteefieekkeeiueeiheffieegteffkeehtdetgeekheeggfffveefgeehvedtjeeh
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheptghoug
    gvsehthihhihgtkhhsrdgtohhm
X-ME-Proxy: <xmx:6Zu4Y1aotxEBuOMcRX-agysHvSTo92gz8Lno2-3gABdcgzOdmdF5gA>
    <xmx:6Zu4Y_a0-4uLp_mWIaKqN_kb99cE2K9hwBs2YFv7xO1fpQLEfG8ePw>
    <xmx:6Zu4YxCtb2bTMkqpSGqvV5vbx-wZVcHmGzdF-jyhBsMWFj8Vgch8Jw>
    <xmx:6Zu4Y-kqMA8gTf9KMKsMd7IueFh4qTA_P9k_CLidZAY7suVvyF_jAg>
Feedback-ID: i78e14604:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Jan 2023 17:08:40 -0500 (EST)
From:   Tyler Hicks <code@tyhicks.com>
To:     stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 5.15 5.10 1/1] selftests: set the BUILD variable to absolute path
Date:   Fri,  6 Jan 2023 16:08:16 -0600
Message-Id: <20230106220816.763835-2-code@tyhicks.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230106220816.763835-1-code@tyhicks.com>
References: <20230106220816.763835-1-code@tyhicks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

commit 5ad51ab618de5d05f4e692ebabeb6fe6289aaa57 upstream.

The build of kselftests fails if relative path is specified through
KBUILD_OUTPUT or O=<path> method. BUILD variable is used to determine
the path of the output objects. When make is run from other directories
with relative paths, the exact path of the build objects is ambiguous
and build fails.

	make[1]: Entering directory '/home/usama/repos/kernel/linux_mainline2/tools/testing/selftests/alsa'
	gcc     mixer-test.c -L/usr/lib/x86_64-linux-gnu -lasound  -o build/kselftest/alsa/mixer-test
	/usr/bin/ld: cannot open output file build/kselftest/alsa/mixer-test

Set the BUILD variable to the absolute path of the output directory.
Make the logic readable and easy to follow. Use spaces instead of tabs
for indentation as if with tab indentation is considered recipe in make.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Tyler Hicks (Microsoft) <code@tyhicks.com>
---
 tools/testing/selftests/Makefile | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 14206d1d1efe..56a4873a343c 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -114,19 +114,27 @@ ifdef building_out_of_srctree
 override LDFLAGS =
 endif
 
-ifneq ($(O),)
-	BUILD := $(O)/kselftest
+top_srcdir ?= ../../..
+
+ifeq ("$(origin O)", "command line")
+  KBUILD_OUTPUT := $(O)
+endif
+
+ifneq ($(KBUILD_OUTPUT),)
+  # Make's built-in functions such as $(abspath ...), $(realpath ...) cannot
+  # expand a shell special character '~'. We use a somewhat tedious way here.
+  abs_objtree := $(shell cd $(top_srcdir) && mkdir -p $(KBUILD_OUTPUT) && cd $(KBUILD_OUTPUT) && pwd)
+  $(if $(abs_objtree),, \
+    $(error failed to create output directory "$(KBUILD_OUTPUT)"))
+  # $(realpath ...) resolves symlinks
+  abs_objtree := $(realpath $(abs_objtree))
+  BUILD := $(abs_objtree)/kselftest
 else
-	ifneq ($(KBUILD_OUTPUT),)
-		BUILD := $(KBUILD_OUTPUT)/kselftest
-	else
-		BUILD := $(shell pwd)
-		DEFAULT_INSTALL_HDR_PATH := 1
-	endif
+  BUILD := $(CURDIR)
+  DEFAULT_INSTALL_HDR_PATH := 1
 endif
 
 # Prepare for headers install
-top_srcdir ?= ../../..
 include $(top_srcdir)/scripts/subarch.include
 ARCH           ?= $(SUBARCH)
 export KSFT_KHDR_INSTALL_DONE := 1
-- 
2.34.1

