Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B79858D7F1
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 18:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfHNQV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 12:21:59 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53509 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726265AbfHNQV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 12:21:59 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2F13F21C1C;
        Wed, 14 Aug 2019 12:21:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 14 Aug 2019 12:21:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=KASTbj
        Ze6TYr9e+bOOIB3ffKkKVyLtxqtl3trE5b5y4=; b=jGMq0MYJp3pR4s7HC5N1q6
        zZncKmo5QTsbokszoDjJ4w0f6cOTuM1uZ0NlLvDumpVAxamvfV/q6uLe51kZdw7M
        IdfeTVdLTu5crnuQJOKYovQlVURgcl25k981vQ4vwpEtB2KVZPpIAG3mGr9/9toH
        /mpbUTkybKTxA2eVY6E2MmwbNEOq4+aVbAd95jQTryyhYPjZcjdT0cDVkn4AJO3V
        S5sVfPGRGzHhuhFWX6l/dLPSsuF/d3zppmaPI922nRTyGbHSRj7BUkvOD05XhcIb
        Ucb/xBSfYeBd5gs5mu0R03iPtwFPalH7bC2a6nfPGO4/OGYobrBLdro6U8KCJSAQ
        ==
X-ME-Sender: <xms:JTVUXeK0WHuen3CGJ63YrdemVzdzHJs4v-y9RrTzAkcw11tJSpruZg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvledgfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:JjVUXaYFxZSGezTyPfvKGdIdcqbXuctjsO0VVq8WOADakXF3kiw-2w>
    <xmx:JjVUXZt4qUXp5VhjD-iKAJ0UErcbQyYnCCM1WlMrRvO-qXmEpfhV7g>
    <xmx:JjVUXXulZpPK5IKJh4KpZu8QZa5rRWzaxmcqm1Tkbzp6wWYQKBEL_A>
    <xmx:JjVUXRMVSvBcJtPi-8-BW31Bzk2a_Zl_TrzTi2ctd4FF1Wx5VH7sGQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8FC4D380083;
        Wed, 14 Aug 2019 12:21:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: KVM: regmap: Fix unexpected switch fall-through" failed to apply to 5.2-stable tree
To:     anders.roxell@linaro.org, maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 14 Aug 2019 18:21:56 +0200
Message-ID: <156579971670144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3d584a3c85d6fe2cf878f220d4ad7145e7f89218 Mon Sep 17 00:00:00 2001
From: Anders Roxell <anders.roxell@linaro.org>
Date: Fri, 26 Jul 2019 13:27:05 +0200
Subject: [PATCH] arm64: KVM: regmap: Fix unexpected switch fall-through
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When fall-through warnings was enabled by default, commit d93512ef0f0e
("Makefile: Globally enable fall-through warning"), the following
warnings was starting to show up:

In file included from ../arch/arm64/include/asm/kvm_emulate.h:19,
                 from ../arch/arm64/kvm/regmap.c:13:
../arch/arm64/kvm/regmap.c: In function ‘vcpu_write_spsr32’:
../arch/arm64/include/asm/kvm_hyp.h:31:3: warning: this statement may fall
 through [-Wimplicit-fallthrough=]
   asm volatile(ALTERNATIVE(__msr_s(r##nvh, "%x0"), \
   ^~~
../arch/arm64/include/asm/kvm_hyp.h:46:31: note: in expansion of macro ‘write_sysreg_elx’
 #define write_sysreg_el1(v,r) write_sysreg_elx(v, r, _EL1, _EL12)
                               ^~~~~~~~~~~~~~~~
../arch/arm64/kvm/regmap.c:180:3: note: in expansion of macro ‘write_sysreg_el1’
   write_sysreg_el1(v, SYS_SPSR);
   ^~~~~~~~~~~~~~~~
../arch/arm64/kvm/regmap.c:181:2: note: here
  case KVM_SPSR_ABT:
  ^~~~
In file included from ../arch/arm64/include/asm/cputype.h:132,
                 from ../arch/arm64/include/asm/cache.h:8,
                 from ../include/linux/cache.h:6,
                 from ../include/linux/printk.h:9,
                 from ../include/linux/kernel.h:15,
                 from ../include/asm-generic/bug.h:18,
                 from ../arch/arm64/include/asm/bug.h:26,
                 from ../include/linux/bug.h:5,
                 from ../include/linux/mmdebug.h:5,
                 from ../include/linux/mm.h:9,
                 from ../arch/arm64/kvm/regmap.c:11:
../arch/arm64/include/asm/sysreg.h:837:2: warning: this statement may fall
 through [-Wimplicit-fallthrough=]
  asm volatile("msr " __stringify(r) ", %x0"  \
  ^~~
../arch/arm64/kvm/regmap.c:182:3: note: in expansion of macro ‘write_sysreg’
   write_sysreg(v, spsr_abt);
   ^~~~~~~~~~~~
../arch/arm64/kvm/regmap.c:183:2: note: here
  case KVM_SPSR_UND:
  ^~~~

Rework to add a 'break;' in the swich-case since it didn't have that,
leading to an interresting set of bugs.

Cc: stable@vger.kernel.org # v4.17+
Fixes: a892819560c4 ("KVM: arm64: Prepare to handle deferred save/restore of 32-bit registers")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
[maz: reworked commit message, fixed stable range]
Signed-off-by: Marc Zyngier <maz@kernel.org>

diff --git a/arch/arm64/kvm/regmap.c b/arch/arm64/kvm/regmap.c
index 0d60e4f0af66..a900181e3867 100644
--- a/arch/arm64/kvm/regmap.c
+++ b/arch/arm64/kvm/regmap.c
@@ -178,13 +178,18 @@ void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v)
 	switch (spsr_idx) {
 	case KVM_SPSR_SVC:
 		write_sysreg_el1(v, SYS_SPSR);
+		break;
 	case KVM_SPSR_ABT:
 		write_sysreg(v, spsr_abt);
+		break;
 	case KVM_SPSR_UND:
 		write_sysreg(v, spsr_und);
+		break;
 	case KVM_SPSR_IRQ:
 		write_sysreg(v, spsr_irq);
+		break;
 	case KVM_SPSR_FIQ:
 		write_sysreg(v, spsr_fiq);
+		break;
 	}
 }

