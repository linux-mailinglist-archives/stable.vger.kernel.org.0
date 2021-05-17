Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71E7382748
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbhEQIo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:44:59 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:45299 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230312AbhEQIo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 04:44:59 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 0AAB69F6;
        Mon, 17 May 2021 04:43:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 17 May 2021 04:43:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=9B2vcI
        5EUqaicVYhuVLRQjw+X73lXq28p+vIeQOSpj8=; b=C1GJMT2lrbVPpa5vWeb/sK
        Cvo98TvRMejVpjTG6aSMkYyj+c9M30D3L2oqZMNun5Pv83cg8/blI6VngM/C7ev9
        DNS6l/BIr+1iaPF705uUOtiTB4pvZAedikwtzKO1KZYu3heJuGTv0JEXhLi/vAML
        DJxCPzKwO5hbVuMeboOYi2yRn7ZVK9wxcU8vCzSY8W4r8m5eW9ibjgWQqEgID9Fb
        cz0s/lc/vUBrjdn6CcJnPmwD1NijMOZGHniKK8fJQUk5TtvjW5KnjZVQQ0djdZWs
        K4dnwsUCKWjIA4Hxe/kCcXxjEh9pGp7wefXnwfIt2fPzcmbnm1PwdazbsG9Nczmw
        ==
X-ME-Sender: <xms:viyiYGz0U0YrVvCfAq5d6fpxL6-avF4HZJp8ihms1Zai8zRmIw9Fbg>
    <xme:viyiYCQ23qIPJUU4rkWxLs9GN33Pin6UqgwyRhJiylj7NEmCJlpYx8nuSDrY9FIvZ
    ZhsL9XnELRz_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:viyiYIW90RWVjRgjX7iOoN2jsTgjo77f-ZOi0FOlM2-3oihu2GS2pw>
    <xmx:viyiYMibEgyiVGG6xHfrX3qQQuC0ZnNw5H2R8OR07b7McAyW_GkjWA>
    <xmx:viyiYIDIhSRwWHRQII1WJOyUCi7qp9xR93NKraJPsWX_LRkAoP1Gvg>
    <xmx:viyiYLNlEQR8DbUef1lqubEhebMHrIVNt_jnE-96YOW_QGrijFaVhnV1AeA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 04:43:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: VMX: Do not advertise RDPID if ENABLE_RDTSCP control is" failed to apply to 5.4-stable tree
To:     seanjc@google.com, jmattson@google.com, pbonzini@redhat.com,
        reijiw@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 10:43:40 +0200
Message-ID: <162124102054144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8aec21c04caa2000f91cf8822ae0811e4b0c3971 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 4 May 2021 10:17:20 -0700
Subject: [PATCH] KVM: VMX: Do not advertise RDPID if ENABLE_RDTSCP control is
 unsupported

Clear KVM's RDPID capability if the ENABLE_RDTSCP secondary exec control is
unsupported.  Despite being enumerated in a separate CPUID flag, RDPID is
bundled under the same VMCS control as RDTSCP and will #UD in VMX non-root
if ENABLE_RDTSCP is not enabled.

Fixes: 41cd02c6f7f6 ("kvm: x86: Expose RDPID in KVM_GET_SUPPORTED_CPUID")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210504171734.1434054-2-seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cbe0cdade38a..46573b862638 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7377,9 +7377,11 @@ static __init void vmx_set_cpu_caps(void)
 	if (!cpu_has_vmx_xsaves())
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
 
-	/* CPUID 0x80000001 */
-	if (!cpu_has_vmx_rdtscp())
+	/* CPUID 0x80000001 and 0x7 (RDPID) */
+	if (!cpu_has_vmx_rdtscp()) {
 		kvm_cpu_cap_clear(X86_FEATURE_RDTSCP);
+		kvm_cpu_cap_clear(X86_FEATURE_RDPID);
+	}
 
 	if (cpu_has_vmx_waitpkg())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);

