Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF03F3C3C7D
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhGKMoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:44:14 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:49799 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhGKMoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:44:14 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 7E5A71AC0F92;
        Sun, 11 Jul 2021 08:41:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 11 Jul 2021 08:41:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=O2CBmn
        cRJWk+L/CnDzHdJLQXPkLh5NmMRHIsI2CZRTU=; b=dG8grwf0vAS0RaTHYfmXOo
        tuVAkEB+D3HNOejCt53zxpIjdEgPK8vZQfSCc0+QPqd34fn+Cnondn7T6wd1hVqZ
        3HVqcjm04HlF04cuUi6HOqlIDQoKLNrU3k4L11HLpWOVC3llEwBmkwzj8yENRjdU
        qVIcvlOmyOAgzKB3ZpVHJO0er4nKMSu/yEd1FgsfzKYQUvBaoMTfTaUeif8rIMv/
        I1yIb64zBK2CuyjDzl13d4Qn2L301c80A9x1kjSqp2Bi6s+3x8Wmrfwo5+ubYBJg
        Rg/28bOh9zW/DDPobZewF3LBEbB5pqO7J8coW7uSaj84T11xhMEEtD+VGZsgNl+w
        ==
X-ME-Sender: <xms:9-bqYBH2yb1uNip3HreTH_6PS_tQucO23F-urVUpKdpNVc3oANohlg>
    <xme:9-bqYGUnsx8ByTwO5xJ4PvLyY3BLciI97kRC7WCcXHpG09-vOUfoRtyS4491KRXYi
    2Y82EYY0b09Hg>
X-ME-Received: <xmr:9-bqYDLcKFOOM8Q38oYzkrYHwjwt8EDXMhWc56a5AMRXiiHDtQFHWspDI4-WNsdvP_vbAKW4AbPUJ7E92ll1Ak2baw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:9-bqYHEZNr3IBfwzXowy9h84pmAoBm_ojahIi-3aOBZuEntTNlZ-Fg>
    <xmx:9-bqYHUfVNlXxk0cT233eIYSLe22hM9T52Oj67yiQhxp7veOH2Sw-w>
    <xmx:9-bqYCMf1xMxxahoKr7hSvJWRsjxqdWHy2c-YyThSOcaro_Qfb9hTg>
    <xmx:9-bqYOeBcvXTGqcoN59041IURgdrCMELDIr7DVxVaDR8aju5RVGnowVaNRU>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:41:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Use MMU's role to detect CR4.SMEP value in" failed to apply to 4.9-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:41:25 +0200
Message-ID: <1626007285118248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ef318b9edf66a082f23d00d79b70c17b4c055a26 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 22 Jun 2021 10:56:49 -0700
Subject: [PATCH] KVM: x86/mmu: Use MMU's role to detect CR4.SMEP value in
 nested NPT walk

Use the MMU's role to get its effective SMEP value when injecting a fault
into the guest.  When walking L1's (nested) NPT while L2 is active, vCPU
state will reflect L2, whereas NPT uses the host's (L1 in this case) CR0,
CR4, EFER, etc...  If L1 and L2 have different settings for SMEP and
L1 does not have EFER.NX=1, this can result in an incorrect PFEC.FETCH
when injecting #NPF.

Fixes: e57d4a356ad3 ("KVM: Add instruction fetch checking when walking guest page table")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210622175739.3610207-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 823a5919f9fa..52fffd68b522 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -471,8 +471,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 
 error:
 	errcode |= write_fault | user_fault;
-	if (fetch_fault && (mmu->nx ||
-			    kvm_read_cr4_bits(vcpu, X86_CR4_SMEP)))
+	if (fetch_fault && (mmu->nx || mmu->mmu_role.ext.cr4_smep))
 		errcode |= PFERR_FETCH_MASK;
 
 	walker->fault.vector = PF_VECTOR;

