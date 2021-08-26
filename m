Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11D13F8945
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 15:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241640AbhHZNpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 09:45:02 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:48773 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237433AbhHZNpC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 09:45:02 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id E976B320091E;
        Thu, 26 Aug 2021 09:44:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 26 Aug 2021 09:44:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=WXkphg
        Sznvbe0cwinig1Log1T5d//3hovaBCb47o4oA=; b=v5BfsVUM1wAk/pHl5RGehs
        NUC7chBUMMZZ3qSXN/EF4YmzrildowrB8+xsW+ElYfd0lxvcnlybMP8EN9wybGQh
        t36rqG/KMHpcZi3+9Ts53VPwJgVi7Aqh3dvcSco999mjBnRJ/ps0c0wKQ7XJCOzp
        mSi6W7Y2NcUZV3TZ8BY5U39833R+z+s+t1evcJq6O7P6ylmeboglqhnCeT20dLUl
        oueq/zwOIkvBNr/1Ui0p0N/FHcAn4xNg3fXkSqGI5QSSS57pmzz1r+EFNzoxrzxN
        R3y2hWakKPfaiRKPgbL6kkO7jQ2uSBwEo3k+ez2jUZRo2AiQnk1i2kjFSmYZzxeQ
        ==
X-ME-Sender: <xms:q5onYW5cyE3UTFAaYFISaosi_ShZ-5Nc42e1bn3rZPIg-TMUE_l4DQ>
    <xme:q5onYf5KuALetlGf6KxkdRykU7IWxM3qF9LtoIDg1xgkyGYaa_ZpG6SlnUqaJbVCR
    Tu6nEGAfiiSvQ>
X-ME-Received: <xmr:q5onYVd6YBmcEgQ8Dxx4toyFe-D1tPpUPEWL19PSTHfDKjATSnASkRvhvxDfHBxm8ytSC4txXhJYREbUMyUxr74-fYCeZZcibsLJUvdrvR3Rshw7yg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudduuddgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffogggtohfgsehtkeertdertdejnecuhfhrohhmpeforghrvghk
    ucforghrtgiihihkohifshhkihdqifpkrhgvtghkihcuoehmrghrmhgrrhgvkhesihhnvh
    hishhisghlvghthhhinhhgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeetgeet
    keeukeffhfejueeludehtedtkeeuiedtgffgtdfhveefueeiiefhudehgeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrghrmhgrrhgvkhes
    ihhnvhhishhisghlvghthhhinhhgshhlrggsrdgtohhm
X-ME-Proxy: <xmx:q5onYTKtFfvgVY5slAcG3Tfj_ZSBp34r0g6gwnv1MKKmwa1309Up1w>
    <xmx:q5onYaJuMaTC4YcyU80j7HP_CAEbqM5HVnPQYTb8_Fq7Hl6Qgeq6uQ>
    <xmx:q5onYUxDsEyiT47N3Ne0RiO5sJuD63DlSNbvgHMo-EQDg1OxhAYucg>
    <xmx:rJonYcg3ZnjlxxIep_3zVTyFHTJ5AIaSqpYIO7OBDFrRz4d19cqfrQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Aug 2021 09:44:10 -0400 (EDT)
From:   =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, stable@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-pci@vger.kernel.org (open list:PCI SUBSYSTEM)
Subject: [PATCH] PCI/MSI: skip masking MSI on Xen PV
Date:   Thu, 26 Aug 2021 15:43:37 +0200
Message-Id: <20210826134337.134767-1-marmarek@invisiblethingslab.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Invisible Things Lab
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When running as Xen PV guest, masking MSI is a responsibility of the
hypervisor. Guest has no write access to relevant BAR at all - when it
tries to, it results in a crash like this:

    BUG: unable to handle page fault for address: ffffc9004069100c
    #PF: supervisor write access in kernel mode
    #PF: error_code(0x0003) - permissions violation
    PGD 18f1c067 P4D 18f1c067 PUD 4dbd067 PMD 4fba067 PTE 80100000febd4075
    Oops: 0003 [#1] SMP NOPTI
    CPU: 0 PID: 234 Comm: kworker/0:2 Tainted: G        W         5.14.0-rc7-1.fc32.qubes.x86_64 #15
    Workqueue: events work_for_cpu_fn
    RIP: e030:__pci_enable_msix_range.part.0+0x26b/0x5f0
    Code: 2f 96 ff 48 89 44 24 28 48 89 c7 48 85 c0 0f 84 f6 01 00 00 45 0f b7 f6 48 8d 40 0c ba 01 00 00 00 49 c1 e6 04 4a 8d 4c 37 1c <89> 10 48 83 c0 10 48 39 c1 75 f5 41 0f b6 44 24 6a 84 c0 0f 84 48
    RSP: e02b:ffffc9004018bd50 EFLAGS: 00010212
    RAX: ffffc9004069100c RBX: ffff88800ed412f8 RCX: ffffc9004069105c
    RDX: 0000000000000001 RSI: 00000000000febd4 RDI: ffffc90040691000
    RBP: 0000000000000003 R08: 0000000000000000 R09: 00000000febd404f
    R10: 0000000000007ff0 R11: ffff88800ee8ae40 R12: ffff88800ed41000
    R13: 0000000000000000 R14: 0000000000000040 R15: 00000000feba0000
    FS:  0000000000000000(0000) GS:ffff888018400000(0000) knlGS:0000000000000000
    CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: ffff8000007f5ea0 CR3: 0000000012f6a000 CR4: 0000000000000660
    Call Trace:
     e1000e_set_interrupt_capability+0xbf/0xd0 [e1000e]
     e1000_probe+0x41f/0xdb0 [e1000e]
     local_pci_probe+0x42/0x80
    (...)

There is pci_msi_ignore_mask variable for bypassing MSI masking on Xen
PV, but msix_mask_all() missed checking it. Add the check there too.

Fixes: 7d5ec3d36123 ("PCI/MSI: Mask all unused MSI-X entries")
Cc: stable@vger.kernel.org
Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
---
Cc: xen-devel@lists.xenproject.org
---
 drivers/pci/msi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index e5e75331b415..3a9f4f8ad8f9 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -776,6 +776,9 @@ static void msix_mask_all(void __iomem *base, int tsize)
 	u32 ctrl = PCI_MSIX_ENTRY_CTRL_MASKBIT;
 	int i;
 
+	if (pci_msi_ignore_mask)
+		return;
+
 	for (i = 0; i < tsize; i++, base += PCI_MSIX_ENTRY_SIZE)
 		writel(ctrl, base + PCI_MSIX_ENTRY_VECTOR_CTRL);
 }
-- 
2.31.1

