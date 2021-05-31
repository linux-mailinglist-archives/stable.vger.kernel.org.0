Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C053959E4
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 13:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhEaLuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 07:50:50 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:48669 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231245AbhEaLur (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 07:50:47 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 056D5155C;
        Mon, 31 May 2021 07:49:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 31 May 2021 07:49:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NiIwFl
        xrPsCM4ssbl3aWz8rk7WvQ2RDhJqhRQY8zUpA=; b=CueCNZ6Ze0xZhh/1zfNw8T
        1lRHGakvuR5CNlPH9nF51OoFJNnFdop+WbaMNwjNkx5dC4SpL+Vwl4/+JM8zLYON
        79LZ5LoqPV9pgt9W3yNSy9G33mZz/n/+d7diMAueJ8l1avttJt6F4hf8++U47lhT
        BlhusQkTJbAmvrw5Wwa6ndog+wTo0b62p+kt2O3tOrpFrMEeWf/F4xjisc/FlZ9O
        hvoqytS/2JWKIQP05Cmxl/XyPE2XK+LLs3ZKyIBNcWJ83G3FRBh+pNqXMOCIS7az
        Sqhr2Xq7SmAbHn6q/B4lDfMrYRC9vSAIfbaZi4A5BZUzefnQwalbV4C1Mn4r8EZg
        ==
X-ME-Sender: <xms:Ms20YLwrCYItlcKZoA2-2gVx3lkNZqP_ij-upy5u0ri1dQYa_2nk9A>
    <xme:Ms20YDSjeDy5ewcCyTjHaJadD0vpsipKTYnT1uSvI7V_OlLcbGabZ9jUdWTlaWZMG
    QdaP5Zf9sRGcg>
X-ME-Received: <xmr:Ms20YFWNTqX0vAU6ttGRzSrMtfnLA4qZsPfRuVRlXZ3ZRKUUtAgrPSPYOGTEya5ggAIbHkjaUPgSUgKU0ioKCT3rLZZZ243e>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdelfedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:Ms20YFj3qzoMFcyygEWEekqzhXFZxOq9DfylIl_ik4sNhjqaVoEFkA>
    <xmx:Ms20YNAk1Qw3kHLC_8DS9roxRHDR501TM2isUzbgS2Ulb3E_T9-XcQ>
    <xmx:Ms20YOIoesb6wVjGEYatPlr8HpZ2_UuCpd_iHNz6mQG5mgkq1Ev9dA>
    <xmx:Ms20YK6V2eGN4X7UsKlT0UcsNesfU9adAV7HM4YTJNWtPfyFb8QpXXZZxdg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 May 2021 07:49:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm64: Resolve all pending PC updates before immediate" failed to apply to 5.12-stable tree
To:     yuzenghui@huawei.com, maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 May 2021 13:49:03 +0200
Message-ID: <162246174317539@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e3e880bb1518eb10a4b4bb4344ed614d6856f190 Mon Sep 17 00:00:00 2001
From: Zenghui Yu <yuzenghui@huawei.com>
Date: Wed, 26 May 2021 22:18:31 +0800
Subject: [PATCH] KVM: arm64: Resolve all pending PC updates before immediate
 exit

Commit 26778aaa134a ("KVM: arm64: Commit pending PC adjustemnts before
returning to userspace") fixed the PC updating issue by forcing an explicit
synchronisation of the exception state on vcpu exit to userspace.

However, we forgot to take into account the case where immediate_exit is
set by userspace and KVM_RUN will exit immediately. Fix it by resolving all
pending PC updates before returning to userspace.

Since __kvm_adjust_pc() relies on a loaded vcpu context, I moved the
immediate_exit checking right after vcpu_load(). We will get some overhead
if immediate_exit is true (which should hopefully be rare).

Fixes: 26778aaa134a ("KVM: arm64: Commit pending PC adjustemnts before returning to userspace")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210526141831.1662-1-yuzenghui@huawei.com
Cc: stable@vger.kernel.org # 5.11

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1126eae27400..e720148232a0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -720,11 +720,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
-	if (run->immediate_exit)
-		return -EINTR;
-
 	vcpu_load(vcpu);
 
+	if (run->immediate_exit) {
+		ret = -EINTR;
+		goto out;
+	}
+
 	kvm_sigset_activate(vcpu);
 
 	ret = 1;
@@ -897,6 +899,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	kvm_sigset_deactivate(vcpu);
 
+out:
 	/*
 	 * In the unlikely event that we are returning to userspace
 	 * with pending exceptions or PC adjustment, commit these

