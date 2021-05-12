Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECC837BB25
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhELKq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:46:27 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:33237 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230145AbhELKq0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:46:26 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 5EF9212F6;
        Wed, 12 May 2021 06:45:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 12 May 2021 06:45:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=sUiFF3
        UFQwcAdoqcv5CES51WhEpqMD95KZ2NLuxV0Ww=; b=GJcCH98/sI71hGGQl1hMKH
        UVU17OCMUq3dolFxOYTvv7YAz+nwnrm2Es9f8fNK3DdlfpXGhSNy02a9bjyJrnXZ
        FfLmxJVUhth+s+pyYK5MqSpNVE1JOJyisNg5MkTnjWcgTOkCigJPoU5Y3qv6/QdQ
        3WEyvtEaStCHMm1GChrlDA+6JLxsPjztWmRa49VrufqG/TG6Wq/l+ZYJevL3qNj9
        LQkJgIiZkbvAIxQTmfCjDguI9D99MzTlReBrdKUwZQiQBu/pNZXiNcVD/Jf6osxs
        R9VJNdF8KJiS/5YPotyMnaCZC816VjM0nKu3nho7YWo3os+FHkn9Y8b9TgV2XLEQ
        ==
X-ME-Sender: <xms:vLGbYPsBZdY9Cvd42rdFFY3POC08H8zQD5j4JmZJ-5YwrYenzEYtRQ>
    <xme:vLGbYAd2I84XlLgf99MlHbgezPGWPMS205iz_z2aGR0qnmMkWSBA-dwzEOYUv4q_q
    1NFLWO0kM2yyw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:vLGbYCzj93gtknCiMaUxxIUnDhdjeAdweyNCnznvqONRd8z4OqXh4Q>
    <xmx:vLGbYOOtGBGuGsAkBEbkRY5jfbax8U4_gz72xxYc41IRpYRDV2OlRA>
    <xmx:vLGbYP-_Q9dtPh2LA_foIIohsLFrBJhXud_dWnC2bP2_J7PD1_gjjA>
    <xmx:vbGbYMG5td9trc6k-N1jAw8ORpCGAr7ncf0TlbMMSEmscXc_QaUQkwizgFM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:45:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: VMX: Truncate GPR value for DR and CR reads in !64-bit" failed to apply to 4.4-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:45:15 +0200
Message-ID: <162081631543150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d8971344f5739a9cc53f91f1f593ddd82265b93b Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 21 Apr 2021 19:21:23 -0700
Subject: [PATCH] KVM: VMX: Truncate GPR value for DR and CR reads in !64-bit
 mode

Drop bits 63:32 when storing a DR/CR to a GPR when the vCPU is not in
64-bit mode.  Per the SDM:

  The operand size for these instructions is always 32 bits in non-64-bit
  modes, regardless of the operand-size attribute.

CR8 technically isn't affected as CR8 isn't accessible outside of 64-bit
mode, but fix it up for consistency and to allow for future cleanup.

Fixes: 6aa8b732ca01 ("[PATCH] kvm: userspace interface")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422022128.3464144-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index edc23c77be32..64354b009fe0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5121,12 +5121,12 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 		case 3:
 			WARN_ON_ONCE(enable_unrestricted_guest);
 			val = kvm_read_cr3(vcpu);
-			kvm_register_write(vcpu, reg, val);
+			kvm_register_writel(vcpu, reg, val);
 			trace_kvm_cr_read(cr, val);
 			return kvm_skip_emulated_instruction(vcpu);
 		case 8:
 			val = kvm_get_cr8(vcpu);
-			kvm_register_write(vcpu, reg, val);
+			kvm_register_writel(vcpu, reg, val);
 			trace_kvm_cr_read(cr, val);
 			return kvm_skip_emulated_instruction(vcpu);
 		}
@@ -5199,7 +5199,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 		unsigned long val;
 
 		kvm_get_dr(vcpu, dr, &val);
-		kvm_register_write(vcpu, reg, val);
+		kvm_register_writel(vcpu, reg, val);
 		err = 0;
 	} else {
 		err = kvm_set_dr(vcpu, dr, kvm_register_readl(vcpu, reg));

