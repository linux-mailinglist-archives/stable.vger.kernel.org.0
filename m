Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99154AC239
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 16:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244813AbiBGO7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 09:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236124AbiBGOi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 09:38:26 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9E7C0401C6
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 06:38:26 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A2DF05C0135;
        Mon,  7 Feb 2022 09:38:25 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 07 Feb 2022 09:38:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; bh=9/8Eo13UkmfQtAr+86AYQJfdev0V9L
        Ui+iNPM9OI0MU=; b=CLVcbiRT3bGDGPVmVzriZSsfHiEzDPo4SvYBog/ltj+pqv
        Bx5qdmnqo3ASIzUpw5+gPxS7FGDcnRjD2++4N97MGWmH9ptaUntePZAhRoEyhTmY
        Oo7C9deF2jfqZWKwejI0+hUjI+cCR5LuSP+ZoYUKhB8Zf4Zm9l2PK9wGxeJkBVTm
        LfHBEKem0mUXSrV2jx5bYAYzQc2q9oFbpJNcCwMKbhLFn0TjLB9SAs7oKYfKHgix
        ffsM56rLn0znXycTshH0Cf0bbjJzHoXlBr6apjhuZRZDg+NMuOOVjCQZTgycqKep
        yCQS+2ZKoKqPlo5L3UVrd4kiemYEt7iSz8cW05ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=9/8Eo1
        3UkmfQtAr+86AYQJfdev0V9LUi+iNPM9OI0MU=; b=Wzhf+jUB1HkGtPD5Y0T+MU
        wmt3yiutsy3m2FHOKGxUUXVysjT2AWHteNVOKdIGfbqWnBzluEzw7Dfui5Cz8jTX
        +26il6nI0OSsZhOocKpyQlmUjKkmAnSI0VPMfD8A2sMyjDmc/LHI/yt8dEwEEIys
        P4BLu4xBxezJx4u4jKvvFGbAleZcdzUXu2rAzddeIWlQWRLBTrxvJPAZuqMo+oAH
        oGAXyQESVpeqwAE5vaGoN0upEdT53tzIVLOkzXgenNM1iW/8WTQMIv5nZJjao+Te
        aToihwdJBRdJ4Vl/8Ni05oFhGtbpNzCnrr11lWGpFu2m3iOJQySTCpSDcVKglpXA
        ==
X-ME-Sender: <xms:4S4BYscfSW_4lL18Pvj3W7FbDEafI8lWFZEOvE7VQRTsD-PXOGHhYA>
    <xme:4S4BYuNtGTozcut0AJJRv4DvnDIEYyN1PJb5zXEXR_2zuNFqRpDjy-6dcC-cJCTPr
    XkwIdeIj4hWydatPUc>
X-ME-Received: <xmr:4S4BYtgTMrSNoxFOQZrZ-79Sg0DuPwyFZcqkC2EQSFtUedsjESMuVLE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheehgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomheplfhirgiguhhn
    ucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenucggtf
    frrghtthgvrhhnpeejiefhgfetleekleffudektdehvedujedvgeekkeejfefhhffhtedu
    tefgtdffueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:4S4BYh_vKZdTOeY3g4fNpZPjqY5cPBnfkbQvQYDJu-41i7brjE1guQ>
    <xmx:4S4BYotuiJhxp_OXzQorZKDolIXFADC25qPpH8EXR13VbtJ1bR3eNw>
    <xmx:4S4BYoGPcng_hhI_0RWY3qzxowD7dNP1PC12qaWr4brxJovSLeT6VQ>
    <xmx:4S4BYkIEM3CMGnmRfjOJOZYF9v5WepKt9iEk8flVEIv68mbk48dQwg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Feb 2022 09:38:24 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH for-4.19 1/2] kbuild: clamp SUBLEVEL to 255
Date:   Mon,  7 Feb 2022 14:38:13 +0000
Message-Id: <20220207143814.234615-2-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207143814.234615-1-jiaxun.yang@flygoat.com>
References: <20220207143814.234615-1-jiaxun.yang@flygoat.com>
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
index 1e9652cb9c1f..ab70e3305a1b 100644
--- a/Makefile
+++ b/Makefile
@@ -1157,9 +1157,15 @@ define filechk_utsrelease.h
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
 
 $(version_h): FORCE
-- 
2.35.1

