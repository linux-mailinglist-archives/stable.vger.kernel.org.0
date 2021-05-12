Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FBB37BAF4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhELKlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:41:42 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:58071 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230149AbhELKll (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:41:41 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id E8D6A12F2;
        Wed, 12 May 2021 06:40:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 12 May 2021 06:40:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=2vDFx3
        ZTIYN3u82bXvOKgcM48OGAy6LUBsFM3O1d+9s=; b=KtqESm3T0KRtqVS9HwVCYN
        /A6fSBSXjtM5RfRbClMnAYgUd0zyTD3O6KEKrSFTwC9gYE7I+MrsyrgY9c5pV+DM
        5rCDDKsIKApXHPud8qNxruZYyt4ljpcW5OdthX2O1BJKyR+CsEeB21xjcjIwUU6j
        67ioHc8ykiIh1Dt0jHJbKtJ6uALH7UmvHsLu15eHxPWHvIEwpLYFusX5xYzQ4mfe
        HzEVIlYWT3v+ldq+ZLlSG0O8rQ2c5XTTstNSklA44H6MaPKTxACGuAWbYKYPoFDA
        OapF58/fhJYVQKFkrD286wjouxBMIryejMu7K5HGFSF9wNN6y0xsZ8QUjKHOPfDw
        ==
X-ME-Sender: <xms:n7CbYHdiMbGrev3nGBxI-quKkt8JXj_iR03OxoZdcSlhhIgGpxGBSA>
    <xme:n7CbYNPyJxAcHPghTZHKjm6N4WXBF1wJ0EDDn3psDQjdG70KGcvuqRfKvU36SUPEE
    xI3zT4MboRFMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:n7CbYAhOEJHoeJQ4F6fWnxPC1boOAL24qgmXFxmG2YK5h3WIrEbq6A>
    <xmx:n7CbYI_VT47K9vyMbCEu_1JY4amVAwOLjMjTtM_TbDo2Ce_99Ww1kw>
    <xmx:n7CbYDss9G8icISGqqeKcJADdVwBOnzsc134qeg2PhoW3kxFzq3RAw>
    <xmx:n7CbYB0kBjt67o-AEuIJ5YQ7plegdzvw9iD-lkTUYfdTsWjKXtxmX0QRzyM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:40:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: X86: Do not yield to self" failed to apply to 4.19-stable tree
To:     wanpengli@tencent.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:40:17 +0200
Message-ID: <1620816017255126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a1fa4cbd53d9bc7bb0eaa7bcf7c8a5904372a4ec Mon Sep 17 00:00:00 2001
From: Wanpeng Li <wanpengli@tencent.com>
Date: Fri, 9 Apr 2021 12:18:31 +0800
Subject: [PATCH] KVM: X86: Do not yield to self

If the target is self we do not need to yield, we can avoid malicious
guest to play this.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1617941911-5338-3-git-send-email-wanpengli@tencent.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 05a4bce181d7..66d2ab074a5f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8228,6 +8228,10 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 	if (!target || !READ_ONCE(target->ready))
 		goto no_yield;
 
+	/* Ignore requests to yield to self */
+	if (vcpu == target)
+		goto no_yield;
+
 	if (kvm_vcpu_yield_to(target) <= 0)
 		goto no_yield;
 

