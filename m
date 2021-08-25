Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC3F3F7834
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 17:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240766AbhHYPYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 11:24:52 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:43269 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237885AbhHYPYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 11:24:52 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id EBFB432009C8;
        Wed, 25 Aug 2021 11:24:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 25 Aug 2021 11:24:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm3; bh=pzf5dy4nTAF2+w5eLed+KU37zwDC8
        vtvZByWxoRUimg=; b=HBrbZMsl3xdHw9TIx+ZlNgWEefspwUTPrjbo4qJYFTHhR
        xh1HFxLVO7Man6hKZZWY3vY9BVHW+Ao8pgs/7kTvVnJ8U6U+gd8mZHKwwlTutbf2
        vFYgA+bJKPEIOIhnksBzLe3aB8+lAynIjGMyL9iXv3GVEQem6cyUUVx2g35x9hsG
        TARb1Ge3UMql0cmzhG149ntVQXvwVgAGepm4U1xLFXS9rDGCHN7fx0GpU7xl/zHK
        f5IMvg8lY8hCjymrSe8vgIkZtFZQdszqHkNrVPZm1aEYPxQJnLOIEw+RPxMBo6FT
        J4v3OqGhFoalr2+B11IDBkgv+DUlgmcSASAfPhB0Q==
X-ME-Sender: <xms:lWAmYZTl_Ljbt52yHtkNX27St99fzaBltSzbXrKpAwFSVYjVrqNq7w>
    <xme:lWAmYSzUVj47s7HSeyqfe1rOnp1-XuBWrHYTMLnAGe5gtYqcWWLsNgOu-iiABO3Bw
    SX6fPE3e07WJg>
X-ME-Received: <xmr:lWAmYe02iEUqWp1ExnivSNTOU28Mp-4F_GWzKUGatP3Be6sonNuTKKErYWBH8Uc5_2AxiyOlvDhehoLGCnKmhyObtS8fMOcr>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtledgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfggtggusehgtderredttdejnecuhfhrohhmpeforghrvghkucfo
    rghrtgiihihkohifshhkihdqifpkrhgvtghkihcuoehmrghrmhgrrhgvkhesihhnvhhish
    hisghlvghthhhinhhgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpedtudfgtedu
    veduieevvefgteeujeelgffggffhhffhhedtffeffefgudeugeefhfenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrghrmhgrrhgvkhesihhn
    vhhishhisghlvghthhhinhhgshhlrggsrdgtohhm
X-ME-Proxy: <xmx:lWAmYRC9t2lW4IhYwF2sl8NdhHKmy7e3npMXHvoCqnD7Ls5lGoBCgw>
    <xmx:lWAmYSikG35vAoApuFehGylVqOChAYhnpHasf99lXFuPsLF4JIMwCA>
    <xmx:lWAmYVpxBw1_WG6u1I_2_h26fCv94GBA0T7u9bLpLS_zTFE51bPMqQ>
    <xmx:lWAmYTvoBnsgUd4tK_Y4DwByeTqJxu3YsxRksMAa9kwtXqPPlRwd-A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Aug 2021 11:24:04 -0400 (EDT)
Date:   Wed, 25 Aug 2021 17:24:00 +0200
From:   Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     xen-devel <xen-devel@lists.xenproject.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     linux-pci@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.kernel.dev
Subject: Kernel panic in __pci_enable_msix_range on Xen PV with PCI
 passthrough
Message-ID: <YSZgkQY1B+WNH50r@mail-itl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="S94iANMFyPadWqU9"
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--S94iANMFyPadWqU9
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Aug 2021 17:24:00 +0200
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: xen-devel <xen-devel@lists.xenproject.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, stable@vger.kernel.org,
	regressions@lists.kernel.dev
Subject: Kernel panic in __pci_enable_msix_range on Xen PV with PCI
 passthrough

Hi,

On recent kernel I get kernel panic when starting a Xen PV domain with
PCI devices assigned. This happens on 5.10.60 (worked on .54) and
5.4.142 (worked on .136):=20

[   13.683009] pcifront pci-0: claiming resource 0000:00:00.0/0
[   13.683042] pcifront pci-0: claiming resource 0000:00:00.0/1
[   13.683049] pcifront pci-0: claiming resource 0000:00:00.0/2
[   13.683055] pcifront pci-0: claiming resource 0000:00:00.0/3
[   13.683061] pcifront pci-0: claiming resource 0000:00:00.0/6
[   14.036142] e1000e: Intel(R) PRO/1000 Network Driver
[   14.036179] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[   14.036982] e1000e 0000:00:00.0: Xen PCI mapped GSI11 to IRQ13
[   14.044561] e1000e 0000:00:00.0: Interrupt Throttling Rate (ints/sec) se=
t to dynamic conservative mode
[   14.045188] BUG: unable to handle page fault for address: ffffc900406910=
0c
[   14.045197] #PF: supervisor write access in kernel mode
[   14.045202] #PF: error_code(0x0003) - permissions violation
[   14.045211] PGD 18f1c067 P4D 18f1c067 PUD 4dbd067 PMD 4fba067 PTE 801000=
00febd4075
[   14.045227] Oops: 0003 [#1] SMP NOPTI
[   14.045234] CPU: 0 PID: 234 Comm: kworker/0:2 Tainted: G        W       =
  5.14.0-rc7-1.fc32.qubes.x86_64 #15
[   14.045245] Workqueue: events work_for_cpu_fn
[   14.045259] RIP: e030:__pci_enable_msix_range.part.0+0x26b/0x5f0
[   14.045271] Code: 2f 96 ff 48 89 44 24 28 48 89 c7 48 85 c0 0f 84 f6 01 =
00 00 45 0f b7 f6 48 8d 40 0c ba 01 00 00 00 49 c1 e6 04 4a 8d 4c 37 1c <89=
> 10 48 83 c0 10 48 39 c1 75 f5 41 0f b6 44 24 6a 84 c0 0f 84 48
[   14.045284] RSP: e02b:ffffc9004018bd50 EFLAGS: 00010212
[   14.045290] RAX: ffffc9004069100c RBX: ffff88800ed412f8 RCX: ffffc900406=
9105c
[   14.045296] RDX: 0000000000000001 RSI: 00000000000febd4 RDI: ffffc900406=
91000
[   14.045302] RBP: 0000000000000003 R08: 0000000000000000 R09: 00000000feb=
d404f
[   14.045308] R10: 0000000000007ff0 R11: ffff88800ee8ae40 R12: ffff88800ed=
41000
[   14.045313] R13: 0000000000000000 R14: 0000000000000040 R15: 00000000feb=
a0000
[   14.045393] FS:  0000000000000000(0000) GS:ffff888018400000(0000) knlGS:=
0000000000000000
[   14.045401] CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
[   14.045407] CR2: ffff8000007f5ea0 CR3: 0000000012f6a000 CR4: 00000000000=
00660
[   14.045420] Call Trace:
[   14.045431]  e1000e_set_interrupt_capability+0xbf/0xd0 [e1000e]
[   14.045479]  e1000_probe+0x41f/0xdb0 [e1000e]
[   14.045506]  local_pci_probe+0x42/0x80
[   14.045515]  work_for_cpu_fn+0x16/0x20
[   14.045522]  process_one_work+0x1ec/0x390
[   14.045529]  worker_thread+0x53/0x3e0
[   14.045534]  ? process_one_work+0x390/0x390
[   14.045540]  kthread+0x127/0x150
[   14.045548]  ? set_kthread_struct+0x40/0x40
[   14.045554]  ret_from_fork+0x22/0x30
[   14.045565] Modules linked in: e1000e(+) edac_mce_amd rfkill xen_pcifron=
t pcspkr xt_REDIRECT ip6table_filter ip6table_mangle ip6table_raw ip6_table=
s ipt_REJECT nf_reject_ipv4 xt_state xt_conntrack iptable_filter iptable_ma=
ngle iptable_raw xt_MASQUERADE iptable_nat nf_nat nf_conntrack nf_defrag_ip=
v6 nf_defrag_ipv4 xen_scsiback target_core_mod xen_netback xen_privcmd xen_=
gntdev xen_gntalloc xen_blkback xen_evtchn fuse drm bpf_preload ip_tables o=
verlay xen_blkfront
[   14.045620] CR2: ffffc9004069100c
[   14.045627] ---[ end trace 307f5bb3bd9f30b4 ]---
[   14.045632] RIP: e030:__pci_enable_msix_range.part.0+0x26b/0x5f0
[   14.045640] Code: 2f 96 ff 48 89 44 24 28 48 89 c7 48 85 c0 0f 84 f6 01 =
00 00 45 0f b7 f6 48 8d 40 0c ba 01 00 00 00 49 c1 e6 04 4a 8d 4c 37 1c <89=
> 10 48 83 c0 10 48 39 c1 75 f5 41 0f b6 44 24 6a 84 c0 0f 84 48
[   14.045652] RSP: e02b:ffffc9004018bd50 EFLAGS: 00010212
[   14.045657] RAX: ffffc9004069100c RBX: ffff88800ed412f8 RCX: ffffc900406=
9105c
[   14.045663] RDX: 0000000000000001 RSI: 00000000000febd4 RDI: ffffc900406=
91000
[   14.045668] RBP: 0000000000000003 R08: 0000000000000000 R09: 00000000feb=
d404f
[   14.045674] R10: 0000000000007ff0 R11: ffff88800ee8ae40 R12: ffff88800ed=
41000
[   14.045679] R13: 0000000000000000 R14: 0000000000000040 R15: 00000000feb=
a0000
[   14.045698] FS:  0000000000000000(0000) GS:ffff888018400000(0000) knlGS:=
0000000000000000
[   14.045706] CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
[   14.045711] CR2: ffff8000007f5ea0 CR3: 0000000012f6a000 CR4: 00000000000=
00660
[   14.045718] Kernel panic - not syncing: Fatal exception
[   14.045726] Kernel Offset: disabled

I've bisected it down to this commit:

    commit 7d5ec3d3612396dc6d4b76366d20ab9fc06f399f
    Author: Thomas Gleixner <tglx@linutronix.de>
    Date:   Thu Jul 29 23:51:41 2021 +0200

        PCI/MSI: Mask all unused MSI-X entries

I can reliably reproduce it on Xen 4.14 and Xen 4.8, so I don't think
Xen version matters here.

Any idea how to fix it?

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--S94iANMFyPadWqU9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmEmYJEACgkQ24/THMrX
1ywWwgf+IRlDcK/qRBb2AQfZhSFfm8ulkd5niXLYT0IX4JI6nD5BrL5nii278/e0
pwelOA1DTS5468v1rGNc0QQ9IhQf4yOYCMloueldPiyeETHfE21TQVyRy4sv7r7T
Jbawg+wJvgHOkwAxn3PDb5xlk8Cl1wuBCw8A7b6CcbF7tTgwxWIqvVemhOtUDft1
hBD8HsH46tAhueDzhmmOn6A9Njj1YXhUnzFtLzwc8QL/3ow2VqUAhxRaa7VV31ov
Zh14JfJ5+evQ7+v2twEOmrU9bvH8o+2DX7K3QiVOerIQXOPMl+xmMOOxv+nFnkPL
wUUs2QnRfH9cs/vz+4YSWCGv0o6l7w==
=FJ2V
-----END PGP SIGNATURE-----

--S94iANMFyPadWqU9--
