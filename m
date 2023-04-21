Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1835C6EB4AC
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 00:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbjDUW0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 18:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjDUWZ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 18:25:59 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725D41BD7
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 15:25:58 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id A8C3B3200AF6;
        Fri, 21 Apr 2023 18:25:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 21 Apr 2023 18:25:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1682115957; x=1682202357; bh=Z0vFfCVn+b
        oTFOrHz2PQ9uJfUr6+u7/+DnajHncB1Vo=; b=Y0DsA077gqjK3DlJiWgazlpCSU
        oA5CCbSXHCdWlNR46PBPnQnwdMCnb/qNvZWXvoXPSKSg/WpfdCA0ruLonH5vOdVO
        1F6zhn84qt5heWtUC/r4VEMs+jqJhS+cLkdbn7+X04XMtOTTojvODOfDAk8ukHtJ
        UJk93QjN9v258BgDr3/X7VrtrH3NXBARst5UNtXLxZGz0ezlpaqgOvh40noM7h5M
        KjQJD9ys4tjPEiToSx/XCzncG8Wk4dal5XPqP4BwVCxVk0EPz5qWxzpg/QRJMiG0
        y97s4dRKpkgXtn8cRNvYEXsAlnDGTBBjFLMiC0/YwzWM3vrVTV43Ue358SJw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682115957; x=1682202357; bh=Z0vFfCVn+boTF
        OrHz2PQ9uJfUr6+u7/+DnajHncB1Vo=; b=SQGbibEmZqiyRrJON2hVpB3sqkRCh
        DPStr78voPK8kawzCjbWasAO1dnR50AE5lgUieCVZkaEIdFtPCMRmYJlKjMII8w9
        pT9H/orHRvwaDvVXCrGeDdrcIQOfEXcSids3tb0wQwW+RzGNBfPVa/Ay42Tu/HaQ
        nzvkTWAbNrWiGDjg97IK1Qq/+OMOM8kFQfJKTAtN772KWA3Q0F0Nmgkz1mSwZNf/
        Q67hK2u5luqzyaXD3T4C/cwnLyXBKNUBZvRA7gH9iZ2DhJF1+TuAC0T/Ti14GXlV
        vZiLSDrLYNoG3OT0LAAmakw8DFZ2gyOINTXNITeLdnRs0Zi3gszSVz1Vg==
X-ME-Sender: <xms:dA1DZAXlFggQMcq4vywRqKb9h2m7I-A9YoY7_j3v60Eiqu88KMNmuw>
    <xme:dA1DZEkdFMI7LlXscSUH8x9sf5vt6_NuF2gZDjKC82GjYPasU3TV_1FNGgWBfWPPS
    eNoofJ6O0cAgTSp-Q>
X-ME-Received: <xmr:dA1DZEZmjPmgZW_XMitP5xXe04wNpRhQpxxwMH4I9HS31Gb5fHamUcXgPOmPZj2wuq0Wp_K3Bq2OazQ6vDFeRP15HlBJa0e6AA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedthedguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomheptehlhihsshgr
    ucftohhsshcuoehhihesrghlhihsshgrrdhisheqnecuggftrfgrthhtvghrnhepheekgf
    dtveettdekuddugeeugfdujeehuefgleegtedthfffudfhheduhfduuefhnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhephhhisegrlhihshhsrg
    drihhs
X-ME-Proxy: <xmx:dQ1DZPXbFaZbyRuRg4ThGMB20KBAfx9ibLEcL6P4usmtyfsfoCd0kw>
    <xmx:dQ1DZKmJDNOqvGPy_77_S6j2CcHbDRKDXS_Jry1zjtjYwWO3EBuC8g>
    <xmx:dQ1DZEcPtxZLrL9HWypTppAzHWcbqXCRb8TK3WG35kBvlzAfFLr_2A>
    <xmx:dQ1DZMh2AdT75_C0NZQgTdT7Ot_F6tAxcJ_0kexxoRu1wcZUNFv-Hg>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Apr 2023 18:25:56 -0400 (EDT)
Received: by x220.qyliss.net (Postfix, from userid 1000)
        id 6CAA13594; Fri, 21 Apr 2023 22:25:55 +0000 (UTC)
From:   Alyssa Ross <hi@alyssa.is>
To:     stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Cc:     Nick Cao <nickcao@nichi.co>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alyssa Ross <hi@alyssa.is>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 5.15.y] x86/purgatory: fix disabling debug info
Date:   Fri, 21 Apr 2023 22:25:16 +0000
Message-Id: <20230421222516.1216640-1-hi@alyssa.is>
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
the linker flags used in 5.15.y.

Since 0ee2f0567a56, the linker flags can contain -g instead of
-Wa,-gdwarf-2 (when using the LLVM assembler).  As a result, in that
case, debug info was being generated for the purgatory objects, even
though the intention was that it not be.

Fixes: 0ee2f0567a56 ("Makefile.debug: re-enable debug info for .S files")
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

