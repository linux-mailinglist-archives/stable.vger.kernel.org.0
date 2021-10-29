Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF45343FA52
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 11:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbhJ2J7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 05:59:51 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55779 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231579AbhJ2J7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 05:59:51 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 3B5E95C0220;
        Fri, 29 Oct 2021 05:57:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 29 Oct 2021 05:57:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=3/Egfh
        4X+ZdPXzTj4EaqMgbhEWAl0zPu3cQnawCwVO4=; b=kCKWYV9uq+QIfP4Qg3wcFm
        fELenkkPgPvNOALaIoR2v1v9PE2h0vWPGYl/PKkJu8sdlHc9LXSFTc3ZR2gV/KIk
        BruKbAMKQ5qO+TXVGFLdA+PnyXT87Xk3/GGeHjbwzJ09Aqc1yThs4ZuQaEwDeBai
        Iod1ItadzdcoI+cpV5gxJCVOJjIM9mog4bzakYfkY8UjQ3FZ67hBKL7hqJhS5meS
        qqmUx1SyowR5LF1LOXwwxPFsr+lP2/KCO8q0A16PIRtWHjhtT1yjE1eBPyaRtT8P
        u12vnRprhMeV8RiMpylj5uF7FrVMFApaYUDtNcGbPmK+N2O+0Gm30J2N73YNaExg
        ==
X-ME-Sender: <xms:gsV7YarWpM9MY6o510lBTf4K0-d5szn528oVZFE1MFdPagX9xpjUgA>
    <xme:gsV7YYo-uhoBOjjBdNY6S-WzLoZRjUtxmI4DQ0dLgCekOQAqDYU7EgPxJ7Hmginhh
    016Kv2pA5kMsw>
X-ME-Received: <xmr:gsV7YfP0FACiTRy27rcEo7gqjY0Zu4SRBq-cMnsa6wEAmlJTwUwe9AymhpO6HSxtHatB2SC3DuCLFVH2Ho1STBMWekRQlqho>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdeghedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeforghrvghk
    ucforghrtgiihihkohifshhkihdqifpkrhgvtghkihcuoehmrghrmhgrrhgvkhesihhnvh
    hishhisghlvghthhhinhhgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeehvedv
    ueevheekhefhvefggffgvedugeetuefgleeivdehgfeuieeugfetteeiffenucffohhmrg
    hinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhepmhgrrhhmrghrvghksehinhhvihhsihgslhgvthhhihhnghhslh
    grsgdrtghomh
X-ME-Proxy: <xmx:gsV7YZ4J5qvDuhzPuhwl4RnOcRfeeSyS43IBvoGw7Jk4pfB3ZjKLbQ>
    <xmx:gsV7YZ7QgfuWVZN4d_b2jxUZQBEiMvHvf3SaWX9ahoyB17vZ1h-2Aw>
    <xmx:gsV7YZhjQo79qUec-ty7DQuRGDTPoG069hAEfwx80kQWrHEgWTUx7A>
    <xmx:gsV7YTmkCkUjV_Pr-NigJ3MjXbO85CG6RQAHYymRQnJCMp1z_KjnCw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 Oct 2021 05:57:20 -0400 (EDT)
Date:   Fri, 29 Oct 2021 11:57:17 +0200
From:   Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] xen/balloon: add late_initcall_sync() for initial
 ballooning done
Message-ID: <YXvFfRKuD574hulr@mail-itl>
References: <20211028105952.10011-1-jgross@suse.com>
 <YXsFO2TMRiJTQM2q@mail-itl>
 <27e7619a-a797-5c46-9f9f-015ab488e31c@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qlvPDcy0Ybnk1Q+S"
Content-Disposition: inline
In-Reply-To: <27e7619a-a797-5c46-9f9f-015ab488e31c@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qlvPDcy0Ybnk1Q+S
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Fri, 29 Oct 2021 11:57:17 +0200
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Juergen Gross <jgross@suse.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Stefano Stabellini <sstabellini@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] xen/balloon: add late_initcall_sync() for initial
 ballooning done

On Fri, Oct 29, 2021 at 06:48:44AM +0200, Juergen Gross wrote:
> On 28.10.21 22:16, Marek Marczykowski-G=C3=B3recki wrote:
> > On Thu, Oct 28, 2021 at 12:59:52PM +0200, Juergen Gross wrote:
> > > When running as PVH or HVM guest with actual memory < max memory the
> > > hypervisor is using "populate on demand" in order to allow the guest
> > > to balloon down from its maximum memory size. For this to work
> > > correctly the guest must not touch more memory pages than its target
> > > memory size as otherwise the PoD cache will be exhausted and the guest
> > > is crashed as a result of that.
> > >=20
> > > In extreme cases ballooning down might not be finished today before
> > > the init process is started, which can consume lots of memory.
> > >=20
> > > In order to avoid random boot crashes in such cases, add a late init
> > > call to wait for ballooning down having finished for PVH/HVM guests.
> > >=20
> > > Cc: <stable@vger.kernel.org>
> > > Reported-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblething=
slab.com>
> > > Signed-off-by: Juergen Gross <jgross@suse.com>
> >=20
> > It may happen that initial balloon down fails (state=3D=3DBP_ECANCELED)=
=2E In
> > that case, it waits indefinitely. I think it should rather report a
> > failure (and panic? it's similar to OOM before PID 1 starts, so rather
> > hard to recover), instead of hanging.
>=20
> Okay, I can add something like that. I'm thinking of issuing a failure
> message in case of credit not having changed for 1 minute and panic()
> after two more minutes. Is this fine?

Isn't it better to get a state from balloon_thread()? If the balloon
fails it won't really try anymore (until 3600s timeout), so waiting in
that state doesn't help. And reporting the failure earlier may be more
user friendly. Or maybe there is something that could wakeup the thread
earlier, that I don't see? Hot plugging more RAM is rather unlikely at
this stage...
See my patch at [1], although rather hacky (and likely - racy).

[1] https://lore.kernel.org/xen-devel/YXFxKC4shCATB913@mail-itl/

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--qlvPDcy0Ybnk1Q+S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmF7xX0ACgkQ24/THMrX
1yxoEgf+LmB4JafdHInJTr2vAFi4q6NgWgkLEQ5VU9RFsyxR6E1Y2gFfyQClL8T5
pbWpH16scP/dnR74YMV9WfZKL5Zvza9vFTM2okm/rKjazkuPacho2xrxIJ9EPQNz
xL2XQFqi2Ma6j8RN0CePJtunyCIThttE2FFKl6BGAKCPCJKqAmMPxXnSjajQNc+6
ZKdubeSuvvlm4PKl89eyVyUrNC5QobxUlXCc7IaVRV1PEHFYrxH4pEOtsEAVfjA5
VIFzSmygyP65qWhRvLvCWHFZ8F740EypyzdNoBuhdpEfc3/O/siyFVsd1dlIdmcV
Dy823HP72V5ImM2iXpgSYCOgUjiVrQ==
=tifY
-----END PGP SIGNATURE-----

--qlvPDcy0Ybnk1Q+S--
