Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827403F8CA9
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 19:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243157AbhHZRE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 13:04:56 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:44107 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229986AbhHZRE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 13:04:56 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id CD5D63200936;
        Thu, 26 Aug 2021 13:04:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 26 Aug 2021 13:04:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=CTG8y+
        c/tcgdmRwNHm6OdItlKpgJ5dHJdci3GZ1+H3o=; b=k40fEJitOfb15NIxBwIXcV
        92cjJLnLkhxBk6uoOLfedGCU4FCwsn7Nn80dRJ/KXEV1H+/5FNfc1el4GGuwvMTL
        d4MY4Lw5RwLLGuXKEjGRPvoAFsCoEfa2tMgEHL2CffAHNY/FPONnpu/3+AhP3P5A
        GiH8lAT6bW6oKpmG9sLoY2iHGetQFqPjUdQNofoY2j3P8+tupzYDIOdGSnkQp1/i
        B6i1gnK+i6tje33Bklx9sUKFRbMLb8mHXm/H7viyBBtFhslpjnthNR+8lNvAZ/6E
        nygDJWncbuStrjCPuAWaXr4He2YLOPW2VFZXeYy93gg9OxpW5O9eGiNB8ZrYtcoA
        ==
X-ME-Sender: <xms:hsknYXuv_xvCmavWZRCqrxiscb13V8EM-AJDWwoXO9N-0iscL2zX1A>
    <xme:hsknYYdV4FrDRG6BPnqy_nrkyS8BPbhX9DB7imew7V_lhAjWf9lDw3omSndhrsS_t
    Fnf90Jwd3XvPQ>
X-ME-Received: <xmr:hsknYawMMCCKNKbrJISYhvCSvAkmy0srQ7ueGBaKdNHYuTe3aOEhKhFsk8hAfmAjVoifNtaFmU5rYfrEWc_oxdGPK80YfcaRmIg65iN_bUsyHP_V_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudduuddguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofggtghogfesthekredtredtjeenucfhrhhomhepofgrrhgv
    khcuofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinh
    hvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepteeg
    teekueekfffhjeeuleduheettdekueeitdfggfdthfevfeeuieeihfduheegnecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrrhhmrghrvghk
    sehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:hsknYWNZS_uWkRx0sXK9CwyhRwKacxQFe6tvDBLiMrDNfsmzuC77RA>
    <xmx:hsknYX_F6y5ty83HpqEbHxsRdFZNNinOzXvuqWU9SHtkEXlbrjlFwg>
    <xmx:hsknYWXNzYHikqRRG-5IZTRpRF2C-iTJNphOy1VmlPFFNWHW3lSpjQ>
    <xmx:h8knYSn9S4GIuEw2YDXgeihqrcy7k3ka0ytzvuj0SnH4d82xIEmtrA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Aug 2021 13:04:05 -0400 (EDT)
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
Subject: [PATCH v2] PCI/MSI: Skip masking MSI-X on Xen PV
Date:   Thu, 26 Aug 2021 19:03:42 +0200
Message-Id: <20210826170342.135172-1-marmarek@invisiblethingslab.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Invisible Things Lab
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When running as Xen PV guest, masking MSI-X is a responsibility of the
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

There is pci_msi_ignore_mask variable for bypassing MSI(-X) masking on Xen
PV, but msix_mask_all() missed checking it. Add the check there too.

Fixes: 7d5ec3d36123 ("PCI/MSI: Mask all unused MSI-X entries")
Cc: stable@vger.kernel.org
Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
---
Cc: xen-devel@lists.xenproject.org

Changes in v2:
- update commit message (MSI -> MSI-X)
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

