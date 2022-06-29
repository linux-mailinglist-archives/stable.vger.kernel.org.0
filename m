Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB31560859
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 20:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbiF2SDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 14:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbiF2SCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 14:02:46 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CD83DA44;
        Wed, 29 Jun 2022 11:02:44 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id a15so15779907pfv.13;
        Wed, 29 Jun 2022 11:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1CUR8O9fHhSNAhX4q/Xzc+ql6Bnj76byUj4wK9Q15Ic=;
        b=BOlmhCIKv0vVPmYiJDK0UHIuu3bPKssJRXLdiTh01hYbD/a8Np09+wRdfy/pid7060
         22uJuozwU0r94af9bRurSyraxAJXSeFbdTOCm04l6saOb+eW3cUK352xUKdoXz+QKsC0
         RxegzZkSnbCFKFHqoPvoCfX+5cOunNpTsaz2p2cMdktDsar3mCYGVjieqcC1yX7o4c//
         eVDkmvzmqn0VPqt7Hiai6MPpSoYtzbMv1GsOjKsHW+GhXbrYHudM9dhPgqDRG6hpxJfV
         fok7yNxAxF8mRETtNmFaTYWq1rteHjQXnS2GABzeXqkdVOnZcxcR3SWkkS0qz7/vxT9n
         76Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1CUR8O9fHhSNAhX4q/Xzc+ql6Bnj76byUj4wK9Q15Ic=;
        b=X8Dx6aA4r+Kzcfc0lZwWS0Mn8jegRCbFAjApvrwwVKDMQen5utK7fd6e+oYLoqGE4P
         GdApgsqCzGYhxDpBXXxjg7Dsbkl9id+5OpPKr2d8mKMqNWhXFLqOSVHg2fgmZcLkIl/O
         p4yzdlw+Fu2tTopOmuVqC7DOZs3RdmDx1uwsS2pkfaBIwbviCBMVHu5rzRIRO+R5f3bo
         VflbQ/X9dzG2+YZ6Mkozi6H27VVNXua0QlZ/mukZhmPLmwRm5N5MtpmBsPice1EU+2ic
         0g8nCnPbVqNo6XyqV6eZXW++I2Dx8cORWEbtAPktJPKi1YdaD0uTGcjZncwXueVwvdZQ
         IlYQ==
X-Gm-Message-State: AJIora8B1H81NwISKuX6Vdq299J3Z0kho4KYLCdyFXX6r/Vc5U//osIT
        dGF2tj2qcOm7gpW3iHQyvVyvJi1OmQI=
X-Google-Smtp-Source: AGRyM1utBpfI/DNVRcDg003dQGaUDHs79iNtpeZDewPznsipYT5mnhUsGrYN4xh56aC+dz96nt6cnQ==
X-Received: by 2002:a63:2a8d:0:b0:40c:9b5f:13d3 with SMTP id q135-20020a632a8d000000b0040c9b5f13d3mr3849554pgq.465.1656525764047;
        Wed, 29 Jun 2022 11:02:44 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s7-20020a17090302c700b00168e83eda56sm11736371plk.3.2022.06.29.11.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 11:02:43 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jian Cai <caij2003@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Stefan Agner <stefan@agner.ch>,
        Nicolas Pitre <nico@fluxnic.net>,
        Andre Przywara <andre.przywara@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-kernel@vger.kernel.org (open list),
        linux-crypto@vger.kernel.org (open list:CRYPTO API),
        linux-omap@vger.kernel.org (open list:OMAP2+ SUPPORT),
        clang-built-linux@googlegroups.com (open list:CLANG/LLVM BUILD SUPPORT),
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH stable 5.4 03/11] ARM: 8971/1: replace the sole use of a symbol with its definition
Date:   Wed, 29 Jun 2022 11:02:19 -0700
Message-Id: <20220629180227.3408104-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629180227.3408104-1-f.fainelli@gmail.com>
References: <20220629180227.3408104-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Cai <caij2003@gmail.com>

commit a780e485b5768e78aef087502499714901b68cc4 upstream

ALT_UP_B macro sets symbol up_b_offset via .equ to an expression
involving another symbol. The macro gets expanded twice when
arch/arm/kernel/sleep.S is assembled, creating a scenario where
up_b_offset is set to another expression involving symbols while its
current value is based on symbols. LLVM integrated assembler does not
allow such cases, and based on the documentation of binutils, "Values
that are based on expressions involving other symbols are allowed, but
some targets may restrict this to only being done once per assembly", so
it may be better to avoid such cases as it is not clearly stated which
targets should support or disallow them. The fix in this case is simple,
as up_b_offset has only one use, so we can replace the use with the
definition and get rid of up_b_offset.

 Link:https://github.com/ClangBuiltLinux/linux/issues/920

 Reviewed-by: Stefan Agner <stefan@agner.ch>

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Jian Cai <caij2003@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/include/asm/assembler.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 6b3e64e19fb6..70e1c23feedb 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -279,10 +279,9 @@
 	.endif							;\
 	.popsection
 #define ALT_UP_B(label)					\
-	.equ	up_b_offset, label - 9998b			;\
 	.pushsection ".alt.smp.init", "a"			;\
 	.long	9998b						;\
-	W(b)	. + up_b_offset					;\
+	W(b)	. + (label - 9998b)					;\
 	.popsection
 #else
 #define ALT_SMP(instr...)
-- 
2.25.1

