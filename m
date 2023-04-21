Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33E56EB50F
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 00:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbjDUWkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 18:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234156AbjDUWkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 18:40:15 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0815C2109
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 15:39:59 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 024F43200B52;
        Fri, 21 Apr 2023 18:39:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 21 Apr 2023 18:39:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1682116797; x=1682203197; bh=TmkOUny2H8
        ZJBO5YzHpa8xVac29n/gccTrYoDX0+qRw=; b=AHGg2HyB7yxgMcbqjuFuR6Krlh
        4ozgtggXt8mFtL1tpeUXuaDKG1Sfq6DGk+67X3424WTN1WT0Sm/ut8C0VyfW6FwQ
        mo33ipKLCERbRjFoZN2MDlV1yLnW7x+8XAdlEbfpr6OttSV44b0O1ry5qx8Pc2qo
        3OAKQQwlwKuHJlTjMc5W8O7rhuzUWbjzjMozdHKokDJxSZCLf0qRPyy6JtPeLI/x
        wjAnHOk4PSFNHZ6fVP7LeVx22AnVoStticU54PyX0xbzq9RuhmL9MIWXbhd2CoPO
        lDQQDkTrLEaIPIA3MIiIG9c+7Hg0Vy0gVcLke66QmlOiatcqdS/vaTaWqCUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682116797; x=1682203197; bh=TmkOUny2H8ZJB
        O5YzHpa8xVac29n/gccTrYoDX0+qRw=; b=LJeUVpNjBGwetpgufd52a/I8Scsc5
        xQRXAORSHWkTByrC4PwesNpMNXhHB47flv6SMTLB2R0aWr3dEIKQsjKJsj/NnzOy
        uUVvk48/fRm5VE7OFke4CmKW8pWwASGlf3wvAc983QyRRi4H1p9RliU888RqUcWp
        fAVuXn5eBpQ0dsX8VZPzuMgF3jn5KcibyYCP1NFHpyYa8++yoxPm5Ws5ZIaJCpHi
        KIgAT6TE4HoRWL0qoSgff36rnp8UDQ1y/AYd4HCPbA4nsqt5Mz5ny0ROhM/lHuSZ
        m7oh0935PIHlMtLGZI/9yvu7N04Gajis7r+kbVYChDHlDo1uhDA7A6IvA==
X-ME-Sender: <xms:vRBDZHUfkZqjHbNVLJofErEujGuVYI1ehWs16bL8xn6l5_8fpCCXMg>
    <xme:vRBDZPme3--M_59L-xoqy8RQY-pq0pP_B-XyAI11dmBOQJ_6YrdJptSRKdZrys7eD
    IXnP_fhRlxuVkytsA>
X-ME-Received: <xmr:vRBDZDa-9n1fMdYbaQpa2MNmP9SdMzZ-s6UXVxuGxqNd7m3Li15KlAvIuMjxwNBLVcuJ5UWHk77boxm6eqdgjgQ-S89ZJrMiog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedthedguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomheptehlhihsshgr
    ucftohhsshcuoehhihesrghlhihsshgrrdhisheqnecuggftrfgrthhtvghrnhepueefie
    dvheffveegieejjeevgfejjeduveekffeiveeuvedvtedvhfelieeutdfgnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehhihesrghlhihsshgrrdhish
X-ME-Proxy: <xmx:vRBDZCXtnsMjzCyMGlf-aqML8kSpfpF5lcCXDpqL0oULate36XhUjA>
    <xmx:vRBDZBn7GQRuUqruPG0CiKJ7IgPe9GHOkElRlQHHnhKmx6UjoxJ3qg>
    <xmx:vRBDZPf7msAUuc9uvMCQJVVPyTRUxf8x8SV7RnrMgqEXS56UhiFb6Q>
    <xmx:vRBDZPZLiS0JBYJvaea-pkiESp6DX403f_SqGuUhZrcGxeKpn78vVw>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Apr 2023 18:39:56 -0400 (EDT)
Received: by x220.qyliss.net (Postfix, from userid 1000)
        id 4DAE33598; Fri, 21 Apr 2023 22:39:55 +0000 (UTC)
From:   Alyssa Ross <hi@alyssa.is>
To:     stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Cc:     Nick Cao <nickcao@nichi.co>, Ingo Molnar <mingo@kernel.org>,
        Pingfan Liu <kernelfans@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Steve Wahl <steve.wahl@hpe.com>,
        Dave Young <dyoung@redhat.com>, Alyssa Ross <hi@alyssa.is>
Subject: [PATCH 4.19.y,5.4.y] x86/purgatory: Don't generate debug info for purgatory.ro
Date:   Fri, 21 Apr 2023 22:39:44 +0000
Message-Id: <20230421223944.1236652-1-hi@alyssa.is>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pingfan Liu <kernelfans@gmail.com>

Purgatory.ro is a standalone binary that is not linked against the rest of
the kernel.  Its image is copied into an array that is linked to the
kernel, and from there kexec relocates it wherever it desires.

Unlike the debug info for vmlinux, which can be used for analyzing crash
such info is useless in purgatory.ro. And discarding them can save about
200K space.

 Original:
   259080  kexec-purgatory.o
 Stripped debug info:
    29152  kexec-purgatory.o

Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Steve Wahl <steve.wahl@hpe.com>
Acked-by: Dave Young <dyoung@redhat.com>
Link: https://lore.kernel.org/r/1596433788-3784-1-git-send-email-kernelfans@gmail.com
(cherry picked from commit 52416ffcf823ee11aa19792715664ab94757f111)
[Alyssa: fixed for LLVM_IAS=1 by adding -g to AFLAGS_REMOVE_*]
Signed-off-by: Alyssa Ross <hi@alyssa.is>
---
 arch/x86/purgatory/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 9733d1cc791d..969d2b2eb7d7 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -27,7 +27,7 @@ KCOV_INSTRUMENT := n
 # make up the standalone purgatory.ro
 
 PURGATORY_CFLAGS_REMOVE := -mcmodel=kernel
-PURGATORY_CFLAGS := -mcmodel=large -ffreestanding -fno-zero-initialized-in-bss
+PURGATORY_CFLAGS := -mcmodel=large -ffreestanding -fno-zero-initialized-in-bss -g0
 PURGATORY_CFLAGS += $(DISABLE_STACKLEAK_PLUGIN) -DDISABLE_BRANCH_PROFILING
 
 # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
@@ -58,6 +58,9 @@ CFLAGS_sha256.o			+= $(PURGATORY_CFLAGS)
 CFLAGS_REMOVE_string.o		+= $(PURGATORY_CFLAGS_REMOVE)
 CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
 
+AFLAGS_REMOVE_setup-x86_$(BITS).o	+= -g -Wa,-gdwarf-2
+AFLAGS_REMOVE_entry64.o			+= -g -Wa,-gdwarf-2
+
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
 
-- 
2.37.1

