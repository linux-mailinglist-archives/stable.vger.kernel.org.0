Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF9526EB513
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 00:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbjDUWlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 18:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbjDUWlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 18:41:20 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1209C
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 15:41:20 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 1020A3200B55;
        Fri, 21 Apr 2023 18:41:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 21 Apr 2023 18:41:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1682116878; x=1682203278; bh=1kh8t26JkS
        mbErDo9uC1FuKeILj7exfAhclANym2Ftw=; b=jPxPWy+IY9xC/GAfmbT6nU7qC9
        8EM6/8wcu33h7V18W9aurUP7u7P4k/zvLs6D1iT9VtfQiHOjS2uEmgFnhKtrMDYu
        ZzpI0CWYyMA+7FpuUjlcSJTT2rHL4bUKZ/M0pePH7Jx2+bp0F6iX067SLtGJEHHp
        hLTuUCwYzVm2VOtO/jQLrh310AX8hqT61BIfze+plrltkdrcIm/Q33BjFjqSnTPM
        kMAAGal0yWSQRIGQWZxdUcBLbfdJgEiIIiUhml+P1Anvd/jZaT9yn5N6B3pGxXx9
        f6XSBsvmkrxJNt7n4Zg/lF2967t7Z4cc5OTEiA8XiHF7Tq74HHpGsFPsqsJg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682116878; x=1682203278; bh=1kh8t26JkSmbE
        rDo9uC1FuKeILj7exfAhclANym2Ftw=; b=gvjV3prS4Fj4m2usFhxQ9uFYaU/j6
        QywScyh5/9SdK3tLcoAb9+F+P245v9nG/t9pXe5gqs5rQi9DM+7shAXxJ9l8ST+S
        UDCJH50WTvzGGQkgunwCneePA3N7ZQBjTpiBSjbDq2uv+RapSfSUBfiSWtAcKLy6
        /QmZlR6dHoSPIvnjtGtY01k1XG4vMYzVMV/Mz2cw0TDqyy0nhiL/cLJfbhXf3UlQ
        eUWz9WtDvV+jALbfVyWfZ2YSWGKNTYNF2nYE2a5lu1ho88L3MnfFhPReHeGchuzY
        mFYOqvppeXNgz7F8XRxRcTa4U107hu1QzcNFV75n+/+vOdgcoTBYxttRQ==
X-ME-Sender: <xms:DRFDZErvvVpy2hdOnkdVIJTA8IyD9balNz_iAW3JcjTu-Se8koZwVQ>
    <xme:DRFDZKp6CVQD57jQx69XnTYRcKXJzYXmyxOlrjf1u_5erexS8rYUvp5vVSqEG-HVM
    xrWH6aKctlAljytUw>
X-ME-Received: <xmr:DRFDZJNOVsTH-PajH5GwTFE11WeTYKV4CjVzzMTCGrTSFKKsL0YnM_vBwhQlVUJNAX83oc8_zlWlPysUg-17Gp7vJRBwRM2Dwg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedthedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomheptehlhihsshgr
    ucftohhsshcuoehhihesrghlhihsshgrrdhisheqnecuggftrfgrthhtvghrnhepueefie
    dvheffveegieejjeevgfejjeduveekffeiveeuvedvtedvhfelieeutdfgnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehhihesrghlhihsshgrrdhish
X-ME-Proxy: <xmx:DhFDZL7yvlEmnjcW3Cy4OAZU01vDUiFw067AXV2PTVbfstaYPPZhUA>
    <xmx:DhFDZD7TzyPyxg_ohTKCFdY-M6vCEg2GKTpu9Gn7-3alCI8I5_nQrw>
    <xmx:DhFDZLhBVfl8PMSV40EgctTn4F87hmMF_W52S6xq7Q7dvfStPTtz5Q>
    <xmx:DhFDZAu7DV-VviSApOw0jgTd5SHl424olyB_Ilcx7BtKNDF0tgBzyg>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Apr 2023 18:41:17 -0400 (EDT)
Received: by x220.qyliss.net (Postfix, from userid 1000)
        id 79BEE359A; Fri, 21 Apr 2023 22:41:16 +0000 (UTC)
From:   Alyssa Ross <hi@alyssa.is>
To:     stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Cc:     Nick Cao <nickcao@nichi.co>, Ingo Molnar <mingo@kernel.org>,
        Pingfan Liu <kernelfans@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Steve Wahl <steve.wahl@hpe.com>,
        Dave Young <dyoung@redhat.com>, Alyssa Ross <hi@alyssa.is>
Subject: [PATCH v4.14] x86/purgatory: Don't generate debug info for purgatory.ro
Date:   Fri, 21 Apr 2023 22:40:48 +0000
Message-Id: <20230421224048.1236703-1-hi@alyssa.is>
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
Signed-off-by: Alyssa Ross <hi@alyssa.is>
---
 arch/x86/purgatory/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 2f15a2ac4209..2040ddb824c2 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -20,6 +20,9 @@ KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initia
 KBUILD_CFLAGS += -m$(BITS)
 KBUILD_CFLAGS += $(call cc-option,-fno-PIE)
 
+AFLAGS_REMOVE_setup-x86_$(BITS).o	+= -Wa,-gdwarf-2
+AFLAGS_REMOVE_entry64.o			+= -Wa,-gdwarf-2
+
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
 
-- 
2.37.1

