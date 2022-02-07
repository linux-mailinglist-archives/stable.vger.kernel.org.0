Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD1F4AC238
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 16:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237959AbiBGO7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 09:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345332AbiBGOkK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 09:40:10 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25F7C0401C2
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 06:40:09 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 260D35C01A1;
        Mon,  7 Feb 2022 09:40:09 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 07 Feb 2022 09:40:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; bh=LeB8RhvoZHTP4q4oKEhrLAQ4+ZbCF3
        kRe7STXyT7ytM=; b=G6Sc9zyr/mA1YfNKQeXA4m4yJUg37y0R13PZv2lTDzRge7
        orSgsHMxJbCLuYTNIHz5EeIbx3uVM/Dkd9j2QDE3QPWYg+yvElCdGdNDXtjhbI5O
        V5sh5T8IhY6CZsbcRvL4X9Y/2FeucnzsWpTGjE5fkR61HiyQK6datFnElvfo8ohv
        IpR8/j67zdaZGv8H8HwCdBHKUlsVLf0nL6zl0HwyaDqWb60zLhPaXh/USb4OMV9x
        s5CyDFSkdl7VyLA6CxOCUu5flU3aJZ7cob3rX2kxvNTzj4IiA9tuICBtrV7rTyZs
        LHIFDos/k/brUsCgbJVu+QtWf43pVAh/k6bWCa/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LeB8Rh
        voZHTP4q4oKEhrLAQ4+ZbCF3kRe7STXyT7ytM=; b=f+YSAHwzhv62/HatJ6kd6E
        rzN7FQa9HRpFuOPPugbCY/YlDmjTeYxCVvXcfi+x4UPh8SwiBZXXSlOlkGuRc0zD
        u6VbggJtx2Yskuw82CuHgsfubQe93foGnqPSxelBEWwbQHrr+cES98TMz0mpEaP6
        0rgl57B9dChvgeimRDIfBvBZjQIoEHsbwFt4kg5UmM6J77chPryoRFPKrtLVD/LZ
        hq+NczCm9e5y5YVuz+o6KCHK8/vfW4D9CI+acIau4zw0o7igVPaPqAly50e/3ggK
        DRn/0s5WULJyI5DqfTEO2uWLY69bwQmeTPJ4pFk59bQuVjw5sy/owGR8Dn52vIFA
        ==
X-ME-Sender: <xms:SS8BYsk0rRMOHkY58MkmLyA0t4cJbjxvnGKLnWACIFpR60fIjJ-kaQ>
    <xme:SS8BYr0rbj1S4L6kRia4bEAfq8JRrgIASPcvC3vk67bOYg79Esamlb_sDfPaj83CL
    9Fhyh2l6J5AvId8-jk>
X-ME-Received: <xmr:SS8BYqrF0FL1-caUkJ118--PjXzGtaS1xpBgM4Chxyj1iOfrNYfwm-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheehgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomheplfhirgiguhhn
    ucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenucggtf
    frrghtthgvrhhnpeejiefhgfetleekleffudektdehvedujedvgeekkeejfefhhffhtedu
    tefgtdffueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:SS8BYolRFr7wgBWXrASufzVoJtEa44jCotjMmXAbGvlOvf4n2mE9ig>
    <xmx:SS8BYq2RUTG8aTz31TscDrC68JFelLRy_9HZNmd6E4EmYJVdkNkGMQ>
    <xmx:SS8BYvsQ_xrkXzWPp-oKxaYPiug_EunxLzzBrolZdzzq8fcm-w3Qgg>
    <xmx:SS8BYvx6XCUfp-7v5GlcwoaAPAS4U5lSd2rCqzIAo4JB7X2OzFyQeA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Feb 2022 09:40:08 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH for-4.14 1/2] kbuild: clamp SUBLEVEL to 255
Date:   Mon,  7 Feb 2022 14:39:56 +0000
Message-Id: <20220207143957.235063-2-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207143957.235063-1-jiaxun.yang@flygoat.com>
References: <20220207143957.235063-1-jiaxun.yang@flygoat.com>
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
index c5508214fa1f..addf1d22bf83 100644
--- a/Makefile
+++ b/Makefile
@@ -1161,9 +1161,15 @@ define filechk_utsrelease.h
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

