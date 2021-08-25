Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE2D3F795A
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 17:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241020AbhHYPsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 11:48:24 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:51517 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240346AbhHYPsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 11:48:24 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id B7C123200A6C;
        Wed, 25 Aug 2021 11:47:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 25 Aug 2021 11:47:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=BoSnXW
        S8mU+1JCDpl0UuSY3m92Z3MGmGN3O28yBbY5Q=; b=P3k9+zdKpjWTRVsbzSaf7m
        kFVRsUVEeITIggRtlv95fL6ZKD0W77ZIT2k96eJ3dq1xhVqETaJJsuCX50TZv+15
        OedN/5vf2jwqGtmuTDYA6v0y7Eknj6p32ynDgwICgduQCAMSuaS/at2aJJNwD/c5
        w7loSpnC0/+lRT10DNlUYaTwdI3DReHC1NqaJ7YWMlSSz5ylZPpzyjxWvKpoKv3p
        yDbN6qMGHR4/2LZhOxe9JS8x6f4AC/7IxY52r0F8dYdK5JydfYPg3c2sWSgzU/tm
        ffYejFFbbhlFhkFGIQJOm4ru0EiZcxRBOLHVXhrRFCEuj2MfilQX1unwWQlOrtVA
        ==
X-ME-Sender: <xms:GGYmYbzE-TiwA8Muv5rKS8ETQfIoZB5HJFz3Zx7wxKFTYmRlutk3pw>
    <xme:GGYmYTTIX1b4nTP2rQe7Z4MXX2ajoAAuLPn9-oBwBpFiNAiFG6rYcK4CNT2LwLAz6
    d7rgyYgpLvuZw>
X-ME-Received: <xmr:GGYmYVVO93MenC9H4KUVbEZ5X4W-uAr6FOKIFOkDw6M72P21e4Mg3sBBsWIgy6lzCPXEdIFuLc27Y-xvahCW9F6eNQfKFtOG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtledgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeforghrvghk
    ucforghrtgiihihkohifshhkihdqifpkrhgvtghkihcuoehmrghrmhgrrhgvkhesihhnvh
    hishhisghlvghthhhinhhgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeetveff
    iefghfekhffggeeffffhgeevieektedthfehveeiheeiiedtudegfeetffenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrghrmhgrrhgvkhes
    ihhnvhhishhisghlvghthhhinhhgshhlrggsrdgtohhm
X-ME-Proxy: <xmx:GGYmYVgk7MFLgNnLnWD8DiCGwXpPe7nBmvUrQojNhnsBqijiH0MkCw>
    <xmx:GGYmYdBNlsdNhhepiRM4Rj_8oR9LXUAnDyYU717K4S3m6On-6euMTg>
    <xmx:GGYmYeKdjqFNWP86Xm2olkhf7LnDpIq4yNsb3dwaL-OjVnrBZdPqOQ>
    <xmx:GWYmYY99lbQYMMvTVsYJV8UxUnB_DXcYbZFPK6WC040SWhWodvYu_A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Aug 2021 11:47:35 -0400 (EDT)
Date:   Wed, 25 Aug 2021 17:47:31 +0200
From:   Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     Jan Beulich <jbeulich@suse.com>
Cc:     linux-pci@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.kernel.dev,
        xen-devel <xen-devel@lists.xenproject.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: Kernel panic in __pci_enable_msix_range on Xen PV with PCI
 passthrough
Message-ID: <YSZmFMeVeO4Bupn+@mail-itl>
References: <YSZgkQY1B+WNH50r@mail-itl>
 <3e72345b-d0e1-7856-de51-e74714474724@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8xMIAefavZOKlE9D"
Content-Disposition: inline
In-Reply-To: <3e72345b-d0e1-7856-de51-e74714474724@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8xMIAefavZOKlE9D
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Aug 2021 17:47:31 +0200
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Jan Beulich <jbeulich@suse.com>
Cc: linux-pci@vger.kernel.org, stable@vger.kernel.org,
	regressions@lists.kernel.dev,
	xen-devel <xen-devel@lists.xenproject.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: Kernel panic in __pci_enable_msix_range on Xen PV with PCI
 passthrough

On Wed, Aug 25, 2021 at 05:33:54PM +0200, Jan Beulich wrote:
> On 25.08.2021 17:24, Marek Marczykowski-G=C3=B3recki wrote:
> > On recent kernel I get kernel panic when starting a Xen PV domain with
> > PCI devices assigned. This happens on 5.10.60 (worked on .54) and
> > 5.4.142 (worked on .136):=20
> >=20
> > [   13.683009] pcifront pci-0: claiming resource 0000:00:00.0/0
> > [   13.683042] pcifront pci-0: claiming resource 0000:00:00.0/1
> > [   13.683049] pcifront pci-0: claiming resource 0000:00:00.0/2
> > [   13.683055] pcifront pci-0: claiming resource 0000:00:00.0/3
> > [   13.683061] pcifront pci-0: claiming resource 0000:00:00.0/6
> > [   14.036142] e1000e: Intel(R) PRO/1000 Network Driver
> > [   14.036179] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
> > [   14.036982] e1000e 0000:00:00.0: Xen PCI mapped GSI11 to IRQ13
> > [   14.044561] e1000e 0000:00:00.0: Interrupt Throttling Rate (ints/sec=
) set to dynamic conservative mode
> > [   14.045188] BUG: unable to handle page fault for address: ffffc90040=
69100c
> > [   14.045197] #PF: supervisor write access in kernel mode
> > [   14.045202] #PF: error_code(0x0003) - permissions violation
> > [   14.045211] PGD 18f1c067 P4D 18f1c067 PUD 4dbd067 PMD 4fba067 PTE 80=
100000febd4075
>=20
> I'm curious what lives at physical address FEBD4000.=20

This is a third BAR of this device, related to MSI-X:

00:04.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Conne=
ction
        Subsystem: Intel Corporation Device 0000
        Physical Slot: 4
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at feb80000 (32-bit, non-prefetchable) [size=3D128=
K]
        Region 1: Memory at feba0000 (32-bit, non-prefetchable) [size=3D128=
K]
        Region 2: I/O ports at c080 [size=3D32]
        Region 3: Memory at febd4000 (32-bit, non-prefetchable) [size=3D16K]
        Expansion ROM at feb40000 [disabled] [size=3D256K]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2=
-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [d0] MSI: Enable- Count=3D1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [e0] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64n=
s, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- Slo=
tPowerLimit 0.000W
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- T=
ransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Exit La=
tency L0s <64ns
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes, Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s (ok), Width x1 (ok)
                        TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Capabilities: [a0] MSI-X: Enable- Count=3D5 Masked-
                Vector table: BAR=3D3 offset=3D00000000
                PBA: BAR=3D3 offset=3D00002000
        Kernel driver in use: pciback
        Kernel modules: e1000e

> The maximum verbosity
> hypervisor log may also have a hint as to why this is a read-only PTE.

I'll try, if that still makes sense.

> > [   14.045227] Oops: 0003 [#1] SMP NOPTI
> > [   14.045234] CPU: 0 PID: 234 Comm: kworker/0:2 Tainted: G        W   =
      5.14.0-rc7-1.fc32.qubes.x86_64 #15
> > [   14.045245] Workqueue: events work_for_cpu_fn
> > [   14.045259] RIP: e030:__pci_enable_msix_range.part.0+0x26b/0x5f0
> > [   14.045271] Code: 2f 96 ff 48 89 44 24 28 48 89 c7 48 85 c0 0f 84 f6=
 01 00 00 45 0f b7 f6 48 8d 40 0c ba 01 00 00 00 49 c1 e6 04 4a 8d 4c 37 1c=
 <89> 10 48 83 c0 10 48 39 c1 75 f5 41 0f b6 44 24 6a 84 c0 0f 84 48
> > [   14.045284] RSP: e02b:ffffc9004018bd50 EFLAGS: 00010212
> > [   14.045290] RAX: ffffc9004069100c RBX: ffff88800ed412f8 RCX: ffffc90=
04069105c
> > [   14.045296] RDX: 0000000000000001 RSI: 00000000000febd4 RDI: ffffc90=
040691000
> > [   14.045302] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000=
0febd404f
> > [   14.045308] R10: 0000000000007ff0 R11: ffff88800ee8ae40 R12: ffff888=
00ed41000
> > [   14.045313] R13: 0000000000000000 R14: 0000000000000040 R15: 0000000=
0feba0000
> > [   14.045393] FS:  0000000000000000(0000) GS:ffff888018400000(0000) kn=
lGS:0000000000000000
> > [   14.045401] CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   14.045407] CR2: ffff8000007f5ea0 CR3: 0000000012f6a000 CR4: 0000000=
000000660
> > [   14.045420] Call Trace:
> > [   14.045431]  e1000e_set_interrupt_capability+0xbf/0xd0 [e1000e]
> > [   14.045479]  e1000_probe+0x41f/0xdb0 [e1000e]
>=20
> Otoh, from this it's pretty clear it's not a device Xen may have found
> a need to access for its own purposes. If aforementioned address covers
> (or is adjacent to) the MSI-X table of a device drive by this driver,
> then it would also be helpful to know how many MSI-X entries the device
> reports its table can have.

See above.

Does PCI passthrough for on PV support MSI-X at all?
If so, I guess the issue is the kernel trying to write directly, instead
of via some hypercall, right?

> > [   14.045506]  local_pci_probe+0x42/0x80
> > [   14.045515]  work_for_cpu_fn+0x16/0x20
> > [   14.045522]  process_one_work+0x1ec/0x390
> > [   14.045529]  worker_thread+0x53/0x3e0
> > [   14.045534]  ? process_one_work+0x390/0x390
> > [   14.045540]  kthread+0x127/0x150
> > [   14.045548]  ? set_kthread_struct+0x40/0x40
> > [   14.045554]  ret_from_fork+0x22/0x30
> > [   14.045565] Modules linked in: e1000e(+) edac_mce_amd rfkill xen_pci=
front pcspkr xt_REDIRECT ip6table_filter ip6table_mangle ip6table_raw ip6_t=
ables ipt_REJECT nf_reject_ipv4 xt_state xt_conntrack iptable_filter iptabl=
e_mangle iptable_raw xt_MASQUERADE iptable_nat nf_nat nf_conntrack nf_defra=
g_ipv6 nf_defrag_ipv4 xen_scsiback target_core_mod xen_netback xen_privcmd =
xen_gntdev xen_gntalloc xen_blkback xen_evtchn fuse drm bpf_preload ip_tabl=
es overlay xen_blkfront
> > [   14.045620] CR2: ffffc9004069100c
> > [   14.045627] ---[ end trace 307f5bb3bd9f30b4 ]---
> > [   14.045632] RIP: e030:__pci_enable_msix_range.part.0+0x26b/0x5f0
> > [   14.045640] Code: 2f 96 ff 48 89 44 24 28 48 89 c7 48 85 c0 0f 84 f6=
 01 00 00 45 0f b7 f6 48 8d 40 0c ba 01 00 00 00 49 c1 e6 04 4a 8d 4c 37 1c=
 <89> 10 48 83 c0 10 48 39 c1 75 f5 41 0f b6 44 24 6a 84 c0 0f 84 48
> > [   14.045652] RSP: e02b:ffffc9004018bd50 EFLAGS: 00010212
> > [   14.045657] RAX: ffffc9004069100c RBX: ffff88800ed412f8 RCX: ffffc90=
04069105c
> > [   14.045663] RDX: 0000000000000001 RSI: 00000000000febd4 RDI: ffffc90=
040691000
> > [   14.045668] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000=
0febd404f
> > [   14.045674] R10: 0000000000007ff0 R11: ffff88800ee8ae40 R12: ffff888=
00ed41000
> > [   14.045679] R13: 0000000000000000 R14: 0000000000000040 R15: 0000000=
0feba0000
> > [   14.045698] FS:  0000000000000000(0000) GS:ffff888018400000(0000) kn=
lGS:0000000000000000
> > [   14.045706] CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   14.045711] CR2: ffff8000007f5ea0 CR3: 0000000012f6a000 CR4: 0000000=
000000660
> > [   14.045718] Kernel panic - not syncing: Fatal exception
> > [   14.045726] Kernel Offset: disabled
> >=20
> > I've bisected it down to this commit:
> >=20
> >     commit 7d5ec3d3612396dc6d4b76366d20ab9fc06f399f
> >     Author: Thomas Gleixner <tglx@linutronix.de>
> >     Date:   Thu Jul 29 23:51:41 2021 +0200
> >=20
> >         PCI/MSI: Mask all unused MSI-X entries
> >=20
> > I can reliably reproduce it on Xen 4.14 and Xen 4.8, so I don't think
> > Xen version matters here.
> >=20
> > Any idea how to fix it?
> >=20
>=20

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--8xMIAefavZOKlE9D
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmEmZhQACgkQ24/THMrX
1yxUwgf6Ahtp5CfcE/z/WQ4w2r+jxDaGhQ5Nfi52oRYdFrkHqARkB6r96xmOTodz
jlk+B7R8BcRwAmmhmD8xpgN153pPps0zH1CeWnr3X8/fYYNXAurtpMy2pmSVWjPW
hV7nvmrEi2SRU+Gzmis3pNXOZ2/kLQtvnvaWn5JzolNH+Y2ytnaxdHYLFnxzHsZX
0Fq+/If50Dr8ENqmlVO7hxnZ4Ouh8pyVMlCLWQsZuKaCT6HjRoFQ1o+RlTBzILdv
C4v/RnhaizcS18OXXKr/p9K7F95BEdX6vRGHjlmHNmp46K4UEGP2Rn6xhEeSCgqu
bLzOF4pmEYrQaIy1mNuI3kbqdVAsbQ==
=6drH
-----END PGP SIGNATURE-----

--8xMIAefavZOKlE9D--
