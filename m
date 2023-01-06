Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C65066094B
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 23:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjAFWJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 17:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236874AbjAFWJF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 17:09:05 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93EA85C89
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 14:09:02 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 21D165C0040;
        Fri,  6 Jan 2023 17:09:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 06 Jan 2023 17:09:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tyhicks.com; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1673042942; x=1673129342; bh=DR
        l3U7j6XeoFmbMgTs9nbhHSGgYGcb/OMcRIjQxS7OY=; b=iQz//GCQlcAVmgFrXb
        iOi4Z6sj4IitON2HwFL45tEPii6QUAATV5x+rrGAD0VT5U2vWDkP8RlUJn9DQ/Qi
        SgzCd7GxUhA0DdrKjXhVN2XsHqFZxO9do/KNzC/6BZZtS+6LPZVryLVg/QQET/7M
        Gb2bZiqoJq8omQqWExNHPB1+Uun+Qfc2sGbNtRX/XEJh08j/kYMAFKI9K1Dy0NPk
        UVtXmrJqO/DpIY7Kpn4d9cPKAjdsEcnMISZa04KwYeydLqtUuYRNUQvYcYj9coZG
        jWH8XXi9WystPBOcwc6PNpn9CtZjUarPxlUnjMU/z9uK7/nOt3tFgbXoRMcuc8s1
        LZ3Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1673042942; x=1673129342; bh=DRl3U7j6XeoFm
        bMgTs9nbhHSGgYGcb/OMcRIjQxS7OY=; b=Z9dgVlh3LbUVxsOn2D/wgMJpulHgv
        W9lRraMbVLRsMJU84xxz/OWUAw/TJs02A50HoepDjoj0u6oj320gilMbj3LSrBe8
        OsW17p613kxyFIClnMdgIK/enSSqOw2EjRhkbBjuoj7nFW2xzM5aPdXPmbdrmyQx
        ssXDK+adDRXmzAOVjOfZGuPah89pSyJEZSQkqngmSsMNNWofzbUa2C8L1fqlWayx
        F3U0uFnNIDwRzFjHuLGYOTGBpBlq9fdFBWIIMgrkvsD3ZFhbAsYFaAeMIrUOG2OX
        NJ3PS4ckGPWf91H1MnMDjOV8xi59Zy1Fvg91pk+KStMwBGzdVOEi4SmTw==
X-ME-Sender: <xms:_Zu4Y7LlfEr1DznaiXlESE1vO_fgLwz8nfWxnVoOUjiJmUVBtS55HA>
    <xme:_Zu4Y_LUmVGyXda75zcP5qY5K91xg5DACgAZSbAQvKG1aJrTJZ5NLBKZyNFov7YO_
    AI6d7AFnJPiIPfiCdo>
X-ME-Received: <xmr:_Zu4YztvSRb64Z8uUSqiW8LrKweK85Q-ibDBR2IXQJoxIWK-9krlJvw0dc-X8jCzp69XUgOxsb5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrkedtgdduheejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepvfihlhgv
    rhcujfhitghkshcuoegtohguvgesthihhhhitghkshdrtghomheqnecuggftrfgrthhtvg
    hrnhepteefieekkeeiueeiheffieegteffkeehtdetgeekheeggfffveefgeehvedtjeeh
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheptghoug
    gvsehthihhihgtkhhsrdgtohhm
X-ME-Proxy: <xmx:_Zu4Y0bKenCOehWy-aHc1bJ3rAqRZscWPAlVOcnrP6pZIs_VlVGC8w>
    <xmx:_Zu4YybIzp4iGXaDSA9vNsUqwCpOSkLEFwcUFaLWWGdXL0tTvpofIQ>
    <xmx:_Zu4Y4D4y12ChG6PN_bBZGFFQkaCV-O4ambqngNemg4pLz7TB-Z-6g>
    <xmx:_pu4Yxl0QCs82S7BrnljISkDey9G-isrFXbcdbkrsIX0sURabo3jLg>
Feedback-ID: i78e14604:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Jan 2023 17:09:01 -0500 (EST)
From:   Tyler Hicks <code@tyhicks.com>
To:     stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 5.4 1/2] selftests: Fix kselftest O=objdir build from cluttering top level objdir
Date:   Fri,  6 Jan 2023 16:08:43 -0600
Message-Id: <20230106220844.763870-2-code@tyhicks.com>
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

From: Shuah Khan <skhan@linuxfoundation.org>

commit 29e911ef7b706215caf02a82b0d3076611d6abe8 upstream.

make kselftest-all O=objdir builds create generated objects in objdir.
This clutters the top level directory with kselftest objects. Fix it
to create sub-directory under objdir for kselftest objects.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Tyler Hicks (Microsoft) <code@tyhicks.com>
---
 tools/testing/selftests/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 612f6757015d..0eb5567bb94a 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -78,7 +78,7 @@ override LDFLAGS =
 override MAKEFLAGS =
 endif
 
-# Append kselftest to KBUILD_OUTPUT to avoid cluttering
+# Append kselftest to KBUILD_OUTPUT and O to avoid cluttering
 # KBUILD_OUTPUT with selftest objects and headers installed
 # by selftests Makefile or lib.mk.
 ifdef building_out_of_srctree
@@ -86,7 +86,7 @@ override LDFLAGS =
 endif
 
 ifneq ($(O),)
-	BUILD := $(O)
+	BUILD := $(O)/kselftest
 else
 	ifneq ($(KBUILD_OUTPUT),)
 		BUILD := $(KBUILD_OUTPUT)/kselftest
-- 
2.34.1

