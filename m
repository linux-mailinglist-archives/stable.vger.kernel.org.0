Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A27B2A5007
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 20:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbgKCTXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 14:23:01 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:47869 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725957AbgKCTXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 14:23:01 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 59B231942731;
        Tue,  3 Nov 2020 14:23:00 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 14:23:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=/AeCff
        c9z7+e7zu+YaIscVPKDQMIweOueptuE1xUpq8=; b=NVaLBNWnktLCNrLgSmOr5e
        XCUmJDSkM5hWPfxGJFGHRT6xadTPt10lcpuEC3ju4KLHmMvGKhKPhjsLEjtTyFnm
        J7XMf9C4lcA9QF1euz9dLfj0no8weRO1OAuQ0LtHOnsOWEWAy+CFvkg4qFDqVM3W
        sR5/0bLCt2ct1kMLAVmIfcuIcw/H5EFRxGA0+wuI27xcQ3HIbfjY3lwXhP54bhQm
        jKpeFZvWq2ZcBKtPx/WQEcJzbkiRtBzXQD6B1mscDPGlBkdPVEEHq+Rj9jMlKCCS
        /O1EUPHSGOtsMLDO7pIjynTavnugRW2ZboIcHccNZv9i9MzCgB5hZJGQOvfYM7+w
        ==
X-ME-Sender: <xms:E66hX1XbC1rJVbUVKyvA-Bcrt-XWathxCLSKJUK8ooa30W9mNRGXsg>
    <xme:E66hX1ndbC4nwSPO9rmjeWNqReT9AkZ7j8QE5cYFiBHcBepTsCZLjiESO9bRhrzi1
    3snilCrQ3ab3g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:E66hXxaNpMZTnDOCEjvn1eY3ocDXpOnoey_fHjELaoKbu9EqvwShEQ>
    <xmx:E66hX4VC_dP8181V-3ihKoODdjLT3uXR76NjO7_LxYaID5ngxJukyQ>
    <xmx:E66hX_mUeLGCdABwYi2ZfenmJlnbxLzyubGMU6KnZi2HyTM8ywyQCA>
    <xmx:FK6hX3s5hvNZl3lDOkiZ2Sl_e50lNRd1_p1f9XdmJa2f1FaCJf26SQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 921433280115;
        Tue,  3 Nov 2020 14:22:59 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: arm64: Force PTE mapping on fault resulting in a device" failed to apply to 5.4-stable tree
To:     sashukla@nvidia.com, gshan@redhat.com, maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 20:22:58 +0100
Message-ID: <160443137851161@kroah.com>
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

From 91a2c34b7d6fadc9c5d9433c620ea4c32ee7cae8 Mon Sep 17 00:00:00 2001
From: Santosh Shukla <sashukla@nvidia.com>
Date: Mon, 26 Oct 2020 16:54:07 +0530
Subject: [PATCH] KVM: arm64: Force PTE mapping on fault resulting in a device
 mapping

VFIO allows a device driver to resolve a fault by mapping a MMIO
range. This can be subsequently result in user_mem_abort() to
try and compute a huge mapping based on the MMIO pfn, which is
a sure recipe for things to go wrong.

Instead, force a PTE mapping when the pfn faulted in has a device
mapping.

Fixes: 6d674e28f642 ("KVM: arm/arm64: Properly handle faulting of device mappings")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Santosh Shukla <sashukla@nvidia.com>
[maz: rewritten commit message]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1603711447-11998-2-git-send-email-sashukla@nvidia.com

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e431d2d8e368..c7c6df6309d5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -851,6 +851,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	if (kvm_is_device_pfn(pfn)) {
 		device = true;
+		force_pte = true;
 	} else if (logging_active && !write_fault) {
 		/*
 		 * Only actually map the page as writable if this was a write

