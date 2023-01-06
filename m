Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176FA66094C
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 23:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjAFWJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 17:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234216AbjAFWJF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 17:09:05 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A44D84BDD
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 14:09:04 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 073F45C0113;
        Fri,  6 Jan 2023 17:09:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 06 Jan 2023 17:09:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tyhicks.com; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1673042944; x=1673129344; bh=Aj
        9ybdm3ZySJ8AExNZKhMb8mwIMaF3vekQTkVDndhAI=; b=qoMMlsy/UWod6tLfzg
        q7EWpndhzTg7tYUMSncwdkakr30F6hWcML086dsAa/4T0A7R9LP914E6oIA3+1oG
        y709vAoK5RwQ1x/qTHYd/AS3ydAwRTC7/SS9kI6ForoNG9T0gVrcjp3FXAu1XihQ
        k0gq5tHCfX4L5XydhIGQJIv+oxjkkUk6lhj7lbAEwlKcmoZFAfI54FKMVe9C3Qkr
        1kveMzAbf0oXt14J6NiVUKTepQsX8l4fFNLuai9Z9I7wsGv6XutrWxKakOTeCXte
        Lq45ObGb6g1Q/X3rWrOMGrMBSoYiRKhfBpCu7dOnI5RMTNLjZh795BjMdIAKQCWi
        o8VA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1673042944; x=1673129344; bh=Aj9ybdm3ZySJ8
        AExNZKhMb8mwIMaF3vekQTkVDndhAI=; b=RhkJ64a6G6Xnc5PkzoTPdvzNuy/SP
        2tvRGvJ8nv++moaI8uGUZa9cOICMp/vzkajfH5qcFJ44ryVC+roP9mGWnpeBVaod
        I9kySBYqHQqsuWoXVjIv4PLs+ZRPYpPccgdPgdV1/BnFWAh2wF1hF918TRIlYKzM
        J3Fktx9WB8q/P2CTTd8lLQox9NwQSezgGrQ/0pGheyNeueeo9y5TO/8hY9BiT5Ee
        /mz6+MoyqojMChu5v+32SU9XIFMWTeUeSyHCPBKZO1Wu9Xv866O/Zqed427KVSPb
        UTOiqzNmr90FR9+6tDgW6slx5CEQfe/3oP0EkIzDiIFsnwKaS1f1T20Ew==
X-ME-Sender: <xms:_5u4YyhB2bAm7plfDzHv-1sCUIpdcvLSttShN0ty9QYNzZUvn-bBBA>
    <xme:_5u4YzDK4IU4lxIPQLpoKS2vTzbH379Nlai6k3sRWz9mZw3txNIQQcPLaubMguBbY
    GbZcNkR0PHCUmabEHM>
X-ME-Received: <xmr:_5u4Y6GO_fFBLU_icMuv6I98jSgmLu8Dz25TwYiJD2JwRLZrymHA_z7Z6A8LODpM5c3gtq85tVal>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrkedtgdduheejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepvfihlhgv
    rhcujfhitghkshcuoegtohguvgesthihhhhitghkshdrtghomheqnecuggftrfgrthhtvg
    hrnhepteefieekkeeiueeiheffieegteffkeehtdetgeekheeggfffveefgeehvedtjeeh
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheptghoug
    gvsehthihhihgtkhhsrdgtohhm
X-ME-Proxy: <xmx:_5u4Y7TMaTaLEJ_PVdN_QQgixF__MVTE1W22DeVkIh0h-8eO1t_68g>
    <xmx:_5u4Y_ykKUPoQNld4zbjc8O7DVYHcYX1pJDdb4KLgpbJ9MyBjNt_Kg>
    <xmx:_5u4Y55DLCQLhXqFCX_2TyN9NmASe3JO5pdbhHffA47CQkt55jrZ1w>
    <xmx:AJy4Y6_VDZ92D1EVrGEt7cPcODZSPHBimxuNREmparVCi5_STNEq-A>
Feedback-ID: i78e14604:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Jan 2023 17:09:03 -0500 (EST)
From:   Tyler Hicks <code@tyhicks.com>
To:     stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 5.4 2/2] selftests: set the BUILD variable to absolute path
Date:   Fri,  6 Jan 2023 16:08:44 -0600
Message-Id: <20230106220844.763870-3-code@tyhicks.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230106220844.763870-1-code@tyhicks.com>
References: <20230106220844.763870-1-code@tyhicks.com>
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
index 0eb5567bb94a..40ee6f57af78 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -85,19 +85,27 @@ ifdef building_out_of_srctree
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

