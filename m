Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2E53F8C53
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 18:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243062AbhHZQhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 12:37:46 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:59887 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229810AbhHZQhp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 12:37:45 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 919A33200908;
        Thu, 26 Aug 2021 12:36:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 26 Aug 2021 12:36:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=yYEwwc
        i3uRQTQkaHdsGqHyiBUeZ/HRPtYaMLjP83/ls=; b=Wsl4PzLBjpQXqnxAyO2evN
        pekTtCakPJXg5dJQrepGgvbetDDR60jbcdqhtXY1DzAubc6bOqm3UNSXxm6cSse4
        +YLG50XE7JOi8nI9p04FPKfHUtZ8i2MU9F4xSHZR4fXAyc0WVn1NaIYM2hXPulgp
        YdA11bcy3V9Kn0Y7JajcPohPwpGnZhaWo4jIyvpo/L9iCX3vTq5rJ7lASkJz0xZ9
        wJ3/GXgKdOY7bLXGAYaQkr4t50xOoAco7GpXYxv8KltZ2uvlNApibO/vFqZBn54g
        uVuuejinOT5qBG7XsokzmznF/ZGqLahPcWZnej3qzhCN+sTfdfaGEgwXrVlu7Xtw
        ==
X-ME-Sender: <xms:JsMnYXLSwAYPB4c30dT9TsqJV6ZS-DRvVd2G7uZVXB0vLbK1lJ2i8Q>
    <xme:JsMnYbIiOkIgQhUAz6bJdcP-H1C3I58D1XRqShi-Z6kjjazL-mFZ2vmIyfyLcNhF6
    AsE3I1GTKgJDg>
X-ME-Received: <xmr:JsMnYfsJZb129RbKiuZDblnqbBa_6LwohLuYLvmFK--uJWlhVrGVoi0mPZEveEPaCVpLtQWxWVTMp20lF0RQJXW1ssJSm88b>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudduuddguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepofgrrhgv
    khcuofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinh
    hvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepteev
    ffeigffhkefhgfegfeffhfegveeikeettdfhheevieehieeitddugeefteffnecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrrhhmrghrvghk
    sehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:JsMnYQYuRI2sAEeNqtezAHT9_6Opggb-1E_3wgoEbD3JGqhnCbEzKw>
    <xmx:JsMnYebALEUgWxDQcojMXJDMWuGVbxGf8rV831MpSWmmv7U55z2q5w>
    <xmx:JsMnYUBiS3LNqEaSuEiKlSbN4UyM3P3fpOj5d1kOENWXfASl2qjmDw>
    <xmx:KMMnYVwgWcpec221yO2uY0tUeyoduTja213Lg59jD42o2Z3K0A7ZcA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Aug 2021 12:36:53 -0400 (EDT)
Date:   Thu, 26 Aug 2021 18:36:49 +0200
From:   Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] PCI/MSI: skip masking MSI on Xen PV
Message-ID: <YSfDIkAmTu+PM4nE@mail-itl>
References: <20210826134337.134767-1-marmarek@invisiblethingslab.com>
 <20210826145532.GA3673811@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="b0V9eJgHdI52l5FP"
Content-Disposition: inline
In-Reply-To: <20210826145532.GA3673811@bjorn-Precision-5520>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--b0V9eJgHdI52l5FP
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Aug 2021 18:36:49 +0200
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	xen-devel@lists.xenproject.org, Bjorn Helgaas <bhelgaas@google.com>,
	Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	"open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] PCI/MSI: skip masking MSI on Xen PV

On Thu, Aug 26, 2021 at 09:55:32AM -0500, Bjorn Helgaas wrote:
> If/when you repost this, please run "git log --oneline
> drivers/pci/msi.c" and follow the convention of capitalizing the
> subject line.
>=20
> Also, I think this patch refers specifically to MSI-X, not MSI, so
> please update the subject line and the "masking MSI" below to reflect
> that.

Sure, thanks for pointing this out. Is the patch otherwise ok? Should I
post v2 with just updated commit message?

> On Thu, Aug 26, 2021 at 03:43:37PM +0200, Marek Marczykowski-G=C3=B3recki=
 wrote:
> > When running as Xen PV guest, masking MSI is a responsibility of the
> > hypervisor. Guest has no write access to relevant BAR at all - when it
> > tries to, it results in a crash like this:
> >=20
> >     BUG: unable to handle page fault for address: ffffc9004069100c
> >     #PF: supervisor write access in kernel mode
> >     #PF: error_code(0x0003) - permissions violation
> >     PGD 18f1c067 P4D 18f1c067 PUD 4dbd067 PMD 4fba067 PTE 80100000febd4=
075
> >     Oops: 0003 [#1] SMP NOPTI
> >     CPU: 0 PID: 234 Comm: kworker/0:2 Tainted: G        W         5.14.=
0-rc7-1.fc32.qubes.x86_64 #15
> >     Workqueue: events work_for_cpu_fn
> >     RIP: e030:__pci_enable_msix_range.part.0+0x26b/0x5f0
> >     Code: 2f 96 ff 48 89 44 24 28 48 89 c7 48 85 c0 0f 84 f6 01 00 00 4=
5 0f b7 f6 48 8d 40 0c ba 01 00 00 00 49 c1 e6 04 4a 8d 4c 37 1c <89> 10 48=
 83 c0 10 48 39 c1 75 f5 41 0f b6 44 24 6a 84 c0 0f 84 48
> >     RSP: e02b:ffffc9004018bd50 EFLAGS: 00010212
> >     RAX: ffffc9004069100c RBX: ffff88800ed412f8 RCX: ffffc9004069105c
> >     RDX: 0000000000000001 RSI: 00000000000febd4 RDI: ffffc90040691000
> >     RBP: 0000000000000003 R08: 0000000000000000 R09: 00000000febd404f
> >     R10: 0000000000007ff0 R11: ffff88800ee8ae40 R12: ffff88800ed41000
> >     R13: 0000000000000000 R14: 0000000000000040 R15: 00000000feba0000
> >     FS:  0000000000000000(0000) GS:ffff888018400000(0000) knlGS:0000000=
000000000
> >     CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
> >     CR2: ffff8000007f5ea0 CR3: 0000000012f6a000 CR4: 0000000000000660
> >     Call Trace:
> >      e1000e_set_interrupt_capability+0xbf/0xd0 [e1000e]
> >      e1000_probe+0x41f/0xdb0 [e1000e]
> >      local_pci_probe+0x42/0x80
> >     (...)
> >=20
> > There is pci_msi_ignore_mask variable for bypassing MSI masking on Xen
> > PV, but msix_mask_all() missed checking it. Add the check there too.
> >=20
> > Fixes: 7d5ec3d36123 ("PCI/MSI: Mask all unused MSI-X entries")
> > Cc: stable@vger.kernel.org
>=20
> 7d5ec3d36123 appeared in v5.14-rc6, so if this fix is merged before
> v5.14, the stable tag will be unnecessary.  But we are running out of
> time there.

7d5ec3d36123 was already backported to stable branches (at least 5.10
and 5.4), and in fact this is how I discovered the issue...

> > Signed-off-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblething=
slab.com>
> > ---
> > Cc: xen-devel@lists.xenproject.org
> > ---
> >  drivers/pci/msi.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >=20
> > diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> > index e5e75331b415..3a9f4f8ad8f9 100644
> > --- a/drivers/pci/msi.c
> > +++ b/drivers/pci/msi.c
> > @@ -776,6 +776,9 @@ static void msix_mask_all(void __iomem *base, int t=
size)
> >  	u32 ctrl =3D PCI_MSIX_ENTRY_CTRL_MASKBIT;
> >  	int i;
> > =20
> > +	if (pci_msi_ignore_mask)
> > +		return;
> > +
> >  	for (i =3D 0; i < tsize; i++, base +=3D PCI_MSIX_ENTRY_SIZE)
> >  		writel(ctrl, base + PCI_MSIX_ENTRY_VECTOR_CTRL);
> >  }
> > --=20
> > 2.31.1
> >=20

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--b0V9eJgHdI52l5FP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmEnwyIACgkQ24/THMrX
1yztUgf/R8Ay9RDGpYN9nIdA5U27TRR+liuaY7wnSAx6QKDd1uA1UderIbCQESwQ
gV4SNG0KfY2TpjEQahVGTzOI5uDvxTIDULHMcIq00Kc/geUTW7+IpdoIqCGLeyCG
RjgChfOfwGR6K5cTj/LIl7mdI1KNarNZyUr8lozTRuilKfFL86sL2hMVX6RZWNYh
/dseexqYP87WvmzoCBBXb+zqGIDqNv4ieth2QnEZo67bnmrRltEUw9JESRx4hA5W
kypQtmWnNEWDKWwoEV3CWSg/pPn1Zurvy70LA8FzmhKyyP+wT/IAP2lofHRPSDPV
vU8+0HJWQAOvDxlKIa/ZqtCz5F0n7Q==
=eVt6
-----END PGP SIGNATURE-----

--b0V9eJgHdI52l5FP--
