Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C676EB514
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 00:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbjDUWmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 18:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbjDUWmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 18:42:31 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AB81725
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 15:42:30 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id A258E3200AB7;
        Fri, 21 Apr 2023 18:33:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 21 Apr 2023 18:33:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1682116432; x=1682202832; bh=EPIxBjWukU
        6SKb2BNCKjEgPXaYGqNdyR8YDlqlKxyKA=; b=jCZziuFTutgIZogPuGyDx8kB3K
        IjF1FVgR3fJN4Rr0lyWUl1RZ2x+VOojxxyUXeQupyHMule77y5TpQkBzGvuq2nxo
        38upF5tJ/dfbzeVCLd4GrSURtBAHInF7YhtZJiLVZGaKpnNrhS8Zuz6vypGNMtw8
        FB8gOdXZ7NX6p/+my9eNiwkxmTUdLfvwzm6UHZf7G5R3FJ+3OpDowqw58OUawbsH
        DXwRc9oA0b25IcA8VvFCqm8r2Nl12EQV748R1Y0899L1W+29F6deRP4FGHhqvxS8
        J8HSECff5wcKyU4Z1kD1spcQzj3GWBOw+RcxVtpZ5GYdvCzyNR4/fQ1lM+vQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682116432; x=1682202832; bh=EPIxBjWukU6SK
        b2BNCKjEgPXaYGqNdyR8YDlqlKxyKA=; b=Q4fzqVyGGm2l66/rTZNyb8M0NdFy5
        rAzOTIYwW5ffBVFKMHaXVCkiYxr3Eo25TJg3aX6IZ2T5rhpT+xz0rf7fwNJ6+o/x
        xCTLJKZPmDb5URmgd0O8AHa3vVf2ay9DLohMriQo3SqkxJwqXrcMVN+2KmZ4InSl
        +PBCYispUiaRzwR4mZTEkKKprDoGhL+6awZBnTnohVtzI7iDoQg8HdtXZRDZO+Bb
        dFeGHwde/qtgvNWMRcNdJ9vAzJIhafVl417OIXAHqAOkNmidK9CcTFvekQ4bA3e7
        wJIGOrIChCACvFgcNSFrHjuf0GREE23pSWr/WDHICIJ+EA+vxuzz1SPYw==
X-ME-Sender: <xms:Tw9DZNovVCWHFxOVSqrYvqzS92Ttu5Qc6Xdfco75o61XHVwwMSbs-g>
    <xme:Tw9DZPpXxPjYoMbySsLQwRvg_v0Ucckfqmf8ApWonss73rDTgH5Jj5NzwD4JczUVh
    sEEyGVLE7KmtmdpUw>
X-ME-Received: <xmr:Tw9DZKNpfDA81uGfu7bMqYBVHz23HGHSKtkBVehAXc2X9RPKUMz7lDpxpGc19XSxpq6lNPruRdVPsRGgckmli8mG7AV4Ah4mMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedthedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomheptehlhihsshgr
    ucftohhsshcuoehhihesrghlhihsshgrrdhisheqnecuggftrfgrthhtvghrnhepheekgf
    dtveettdekuddugeeugfdujeehuefgleegtedthfffudfhheduhfduuefhnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhephhhisegrlhihshhsrg
    drihhs
X-ME-Proxy: <xmx:Tw9DZI7YCG3C0qkTZa_sUVjS-30UjSOu-Ba1qkXIKMtHWtjaepnz_A>
    <xmx:Tw9DZM6Mf2I--D0G2xh6PosAB2HUmJ8wchb6aCE4kRnt98c3MZ6N_w>
    <xmx:Tw9DZAiknnvxPtzMcRSo5EempFCFiMKS2h7rvXr2N-gJKFAPR3FK4Q>
    <xmx:UA9DZKmCJAoBpQfapZJ_vG0PPJDTNKyj_5T4NGvT6y1HW049SWLp0g>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Apr 2023 18:33:51 -0400 (EDT)
Received: by x220.qyliss.net (Postfix, from userid 1000)
        id 4E28B3596; Fri, 21 Apr 2023 22:33:50 +0000 (UTC)
From:   Alyssa Ross <hi@alyssa.is>
To:     stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Cc:     Nick Cao <nickcao@nichi.co>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alyssa Ross <hi@alyssa.is>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 5.10.y] x86/purgatory: fix disabling debug info
Date:   Fri, 21 Apr 2023 22:33:33 +0000
Message-Id: <20230421223333.1229240-1-hi@alyssa.is>
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

This is based on upstream commit
d83806c4c0cc ("purgatory: fix disabling debug info"), but adapted to
the linker flags used in 5.10.y.

Since 3a260e9844c9, the linker flags can contain -g instead of
-Wa,-gdwarf-2 (when using the LLVM assembler).  As a result, in that
case, debug info was being generated for the purgatory objects, even
though the intention was that it not be.

Fixes: 3a260e9844c9 ("Makefile.debug: re-enable debug info for .S files")
Signed-off-by: Alyssa Ross <hi@alyssa.is>
Cc: stable@vger.kernel.org
Cc: Nick Desaulniers <ndesaulniers@google.com>
---
 arch/x86/purgatory/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 95ea17a9d20c..ebaf329a2368 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -64,8 +64,7 @@ CFLAGS_sha256.o			+= $(PURGATORY_CFLAGS)
 CFLAGS_REMOVE_string.o		+= $(PURGATORY_CFLAGS_REMOVE)
 CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
 
-AFLAGS_REMOVE_setup-x86_$(BITS).o	+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_entry64.o			+= -Wa,-gdwarf-2
+asflags-remove-y		+= -g -Wa,-gdwarf-2
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
-- 
2.37.1

