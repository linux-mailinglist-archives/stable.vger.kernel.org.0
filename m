Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071664AC23A
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 16:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243347AbiBGO7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 09:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242588AbiBGOlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 09:41:05 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7681C0401C3
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 06:41:03 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 550185C0115;
        Mon,  7 Feb 2022 09:41:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 07 Feb 2022 09:41:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; bh=+lJ33xleRKOxYezu+GjqZOCVsgCAhz
        TPRKmBFqo7eGE=; b=mPvJBaL33bZil8VeBATiKIJQgpKuOtX9BOSjJpeqxN8yA+
        KWvA+Ln2oJMKOIUJVNkKvsptFuIKdKEFKZjPrv/lFcwyLxN7V+GnCMEgljlOGAX2
        ufBfKayY1cJjTK4PNn0dDx8oljo311T8a/7wlan9i4n7bm8lDgLdDhZ3hDWAKHn4
        rUKAji9sdnbNwvmQ9wWxnErFaCzxCas40XLVCmvFRXnSKXyE8ePJ5iXODjNOWwU1
        lUImM6xaDb4I9qq1H8NxHHsdIdEbqC8OyFez1FXSx6QgpcFMuIihr6ZjCzPfOCrU
        HTSBa8ZJ3so09rXazMHF+z0jY+/M3RHuKe1y6Utw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+lJ33x
        leRKOxYezu+GjqZOCVsgCAhzTPRKmBFqo7eGE=; b=LEOYrKK0CHZcufrEbiC1/I
        30XIKuSLRS5Qk1Tt8mthxSx6lWXFeUks1ntuZbER1iRwhUh4MTN7feoG+U/bs5o9
        wt2DLkoJthClhsYvB4x/sCvRuUJhB2Heb7ye0QumIhNypX7KqolojgKf2r+pqaNO
        LzJMEmssOZz8fus+qtngR7oCVUOu8AsTwSzaODLkKlUCuh5KFBNRvtQM7VgTNZQw
        I0sdwZh+KjM016wxJMTPKIKnd3JIy2nDYgtKn8ygtvyFp4o0YALC/VjBvKG6KII3
        pnze3zV5uyQVMPT9JIo5T68L6UjushmlzOTgr/WtS32r9pUzCp58ft1RT4jAGMJA
        ==
X-ME-Sender: <xms:fy8BYsr--Pewk7ggzCUEwkDS42ZY6BrQaQUEAxqgrs_J3rLfuDeGKw>
    <xme:fy8BYioUHKBQmAMSRpglWTqLZfcsZGVr3lWg14V9HDMjBfnSTOfr3Td3kjlrm-_I2
    tkJ7VfGnRE6jqGhvUc>
X-ME-Received: <xmr:fy8BYhOqKmA2AuVF0TGt7raINL_4B7Wjmlwj7vOpNLtObHlSOlktVoo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheehgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomheplfhirgiguhhn
    ucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenucggtf
    frrghtthgvrhhnpeejiefhgfetleekleffudektdehvedujedvgeekkeejfefhhffhtedu
    tefgtdffueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:fy8BYj7oXs9XElQzu4s-cpam3DS49ebitvIyh8I17eCjiBsV2_lduw>
    <xmx:fy8BYr5afKkMgJituB-92JQgVZWWvKQvljAr5M-KEJm5iRWJNxiQqw>
    <xmx:fy8BYjjzh8_XGqt3LcEcvnWgYUG0PStC_QCh8TXqtUxsAZdUZnjf4Q>
    <xmx:fy8BYtmHVgWELEXuk1jzDcB2SP8aNpTIIl0lFc7M_2S0tWnTrRVXqg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Feb 2022 09:41:02 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH for-4.9 1/2] kbuild: clamp SUBLEVEL to 255
Date:   Mon,  7 Feb 2022 14:40:51 +0000
Message-Id: <20220207144052.235533-2-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207144052.235533-1-jiaxun.yang@flygoat.com>
References: <20220207144052.235533-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Levin <sashal@kernel.org>

commit 9b82f13e7ef316cdc0a8858f1349f4defce3f9e0 upstream.

Right now if SUBLEVEL becomes larger than 255 it will overflow into the
territory of PATCHLEVEL, causing havoc in userspace that tests for
specific kernel version.

While userspace code tests for MAJOR and PATCHLEVEL, it doesn't test
SUBLEVEL at any point as ABI changes don't happen in the context of
stable tree.

Thus, to avoid overflows, simply clamp SUBLEVEL to it's maximum value in
the context of LINUX_VERSION_CODE. This does not affect "make
kernelversion" and such.

Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
[jiaxun.yang@flygoat.com: Stable backport]
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 Makefile | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 99d37c23495e..c86dfa5b27bb 100644
--- a/Makefile
+++ b/Makefile
@@ -1140,9 +1140,15 @@ define filechk_utsrelease.h
 endef
 
 define filechk_version.h
-	(echo \#define LINUX_VERSION_CODE $(shell                         \
-	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255); \
-	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
+	if [ $(SUBLEVEL) -gt 255 ]; then                                 \
+		echo \#define LINUX_VERSION_CODE $(shell                 \
+		expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255); \
+	else                                                             \
+		echo \#define LINUX_VERSION_CODE $(shell                 \
+		expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + $(SUBLEVEL)); \
+	fi;                                                              \
+	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) +  \
+	((c) > 255 ? 255 : (c)))'
 endef
 
 $(version_h): $(srctree)/Makefile FORCE
-- 
2.35.1

