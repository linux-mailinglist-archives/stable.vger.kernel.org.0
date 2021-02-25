Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540A0324C16
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 09:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhBYIcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 03:32:39 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:52467 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235859AbhBYIci (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 03:32:38 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 2225CB11;
        Thu, 25 Feb 2021 03:31:33 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 25 Feb 2021 03:31:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wDHqr1
        0VRxxNmcAPAHsbeS+HCvS8V0AWXqY3iFiVblw=; b=nQc2iMGSR/5blmcX2ggAss
        TKIlbOKBCEhuYY93l+iuIrQXZU3SxKSG+yrzdisEB6DP6VW9Ln0cVAuifgwFJ34p
        yUnXabRGgcQ0tTM5e0q9i0eqIHVX9cwM3tumJEmmnyhoUSsHWR7Y5RmDeMvCNHBc
        4RzJgqI2iG4qDdvsdHN38UBtg2jrDjLgjtj/NY3ft33KkpuWv6mgtw1KnL87k02i
        qSWIP9YH4r3V65PbCoIWxa/3HTE73TSQjH9zT4gzKC1XM3Uu5TDIx4gUSRPHZP72
        0NWK4kRugnYOZyDdohqkl2jcpIy87qsr2jq082GRH5BXVhtLVBUYNBgQrekLM7tg
        ==
X-ME-Sender: <xms:ZGA3YL23sVmHpRLOCxKjTKF9fIhcfC7l-_I6kfZa5HculoFJhqh5nQ>
    <xme:ZGA3YKCKcIyaPc-Med7l-7QEVcswT1cLmc1sJfIDukF7uqxtAEzJ6x5aPKOewGrCL
    fjcarMqLBNg4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeekgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:ZGA3YIy7GxXutA_fEwZ4Ydd5oPcc_itylxOGxdnpJBM6BNhGLkmhHg>
    <xmx:ZGA3YImPCfY5DJzxMUGf9_poUZC11RG36ZOssJ20nCh0FjEOG-PI2g>
    <xmx:ZGA3YNE8Uoj78KA1QKzmzBhyGdu11NhcKafekptB3IT_M2pZe2kWfA>
    <xmx:ZGA3YLlhr3qL4k2c309oNlHcdzKTFUONlXP_gQQTwVhDfy8xlMhStG7JeiY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4542B108005C;
        Thu, 25 Feb 2021 03:31:32 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: x86: Set so called 'reserved CR3 bits in LM mask' at" failed to apply to 5.11-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Feb 2021 09:31:22 +0100
Message-ID: <1614241882121167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f156abec725f945f9884bc6a5bd0dccb5aac16a8 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 3 Feb 2021 16:01:06 -0800
Subject: [PATCH] KVM: x86: Set so called 'reserved CR3 bits in LM mask' at
 vCPU reset

Set cr3_lm_rsvd_bits, which is effectively an invalid GPA mask, at vCPU
reset.  The reserved bits check needs to be done even if userspace never
configures the guest's CPUID model.

Cc: stable@vger.kernel.org
Fixes: 0107973a80ad ("KVM: x86: Introduce cr3_lm_rsvd_bits in kvm_vcpu_arch")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210204000117.3303214-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 838ce5e9814b..10414a78b951 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10080,6 +10080,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	fx_init(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
+	vcpu->arch.cr3_lm_rsvd_bits = rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
 
 	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
 

