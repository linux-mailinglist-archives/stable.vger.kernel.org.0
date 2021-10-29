Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB65143FAC3
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 12:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhJ2KfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 06:35:15 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37873 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231734AbhJ2KfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 06:35:14 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id C0CCF5C01B4;
        Fri, 29 Oct 2021 06:32:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 29 Oct 2021 06:32:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=YdG730
        3DTkIoGkZP5x+x4wYzhp24+CwM+Xym9I44YWs=; b=B7QCGeJ92ZtCVMqwCNv34T
        954aDC3ascW+t0S+sUV//zWOoDdJESXwj5FSjsUPLNH0pouoyow8/sUN52I7/NoB
        C173U6lft8cSpGa7RjglbqH+z2kwmwsT1l8VNnyvplzPHdmlFn3RUP+x+vulL1xo
        bWVzROOVZBgThP9KgxPQPh+8Ppsar87MapLTrSY/n2L/47Cj3D9SqHwsZKVZcFW5
        IaVnLvNIVIWdrIa+6Ear9w3H1lcyhMPIB/1/X8okuUVfIDB8yAlJbOiy0rkMiogp
        zuBZE91zK1+Rg8mVFkYhfFk9IRBHBTwcJAxROcQt7jkFM59upaCtywi91M7rK1pQ
        ==
X-ME-Sender: <xms:zc17YVMU6GJBaTwkY-gYaNMt0lZeWwvejwWvLT_0jL9FuXivDDudbA>
    <xme:zc17YX9VjZ3Et2xs2oI0o17j5baFaCrq0JbnFMZla26KuB5MYIzQ8ZT47L6YyvQf2
    zImIom05kCQLA>
X-ME-Received: <xmr:zc17YUTZcfqTgVDM3-5QyjMkedXRf0kdkvyehgqQFer4XJ6dxqe9oSsTslR_qZ3IkC6hTDUBQIQMu_8rLe5cHMZZNversEmV>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdeghedgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtdorredttdejnecuhfhrohhmpeforghrvghk
    ucforghrtgiihihkohifshhkihdqifpkrhgvtghkihcuoehmrghrmhgrrhgvkhesihhnvh
    hishhisghlvghthhhinhhgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeeiieeh
    jeegteeggeeigffhkeekieefjeduhedvfffhiefgkefhvdevfeejffdvfeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrghrmhgrrhgvkhes
    ihhnvhhishhisghlvghthhhinhhgshhlrggsrdgtohhm
X-ME-Proxy: <xmx:zc17YRsGQHNxnsefUAzFGYPW2P2_6jMf7nGeldygoAZodjI8fGPLwQ>
    <xmx:zc17Ydef5t6pPNBKmz7vD1CkF3mgxTihbuAL0abFZaJ7fBh8J1KoUg>
    <xmx:zc17Yd3U52gwcZLtJab9z2NtqSxTu-6-ds7uCLNeY5W0gWnXpLx3Lg>
    <xmx:zc17YR4ZsW_HRv9xbHbUVL-FMkSReTPsHcEVAhwbu5Q6Zwem84CuAg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 Oct 2021 06:32:44 -0400 (EDT)
Date:   Fri, 29 Oct 2021 12:32:40 +0200
From:   Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] xen/balloon: add late_initcall_sync() for initial
 ballooning done
Message-ID: <YXvNyDjltJQrDFJr@mail-itl>
References: <20211028105952.10011-1-jgross@suse.com>
 <YXsFO2TMRiJTQM2q@mail-itl>
 <27e7619a-a797-5c46-9f9f-015ab488e31c@suse.com>
 <YXvFfRKuD574hulr@mail-itl>
 <63a474ea-9e5d-4515-ca99-1d56f52b7673@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MZykTqTxNZ8yEQ39"
Content-Disposition: inline
In-Reply-To: <63a474ea-9e5d-4515-ca99-1d56f52b7673@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MZykTqTxNZ8yEQ39
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Fri, 29 Oct 2021 12:32:40 +0200
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Juergen Gross <jgross@suse.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Stefano Stabellini <sstabellini@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] xen/balloon: add late_initcall_sync() for initial
 ballooning done

On Fri, Oct 29, 2021 at 12:22:18PM +0200, Juergen Gross wrote:
> On 29.10.21 11:57, Marek Marczykowski-G=C3=B3recki wrote:
> > On Fri, Oct 29, 2021 at 06:48:44AM +0200, Juergen Gross wrote:
> > > On 28.10.21 22:16, Marek Marczykowski-G=C3=B3recki wrote:
> > > > On Thu, Oct 28, 2021 at 12:59:52PM +0200, Juergen Gross wrote:
> > > > > When running as PVH or HVM guest with actual memory < max memory =
the
> > > > > hypervisor is using "populate on demand" in order to allow the gu=
est
> > > > > to balloon down from its maximum memory size. For this to work
> > > > > correctly the guest must not touch more memory pages than its tar=
get
> > > > > memory size as otherwise the PoD cache will be exhausted and the =
guest
> > > > > is crashed as a result of that.
> > > > >=20
> > > > > In extreme cases ballooning down might not be finished today befo=
re
> > > > > the init process is started, which can consume lots of memory.
> > > > >=20
> > > > > In order to avoid random boot crashes in such cases, add a late i=
nit
> > > > > call to wait for ballooning down having finished for PVH/HVM gues=
ts.
> > > > >=20
> > > > > Cc: <stable@vger.kernel.org>
> > > > > Reported-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblet=
hingslab.com>
> > > > > Signed-off-by: Juergen Gross <jgross@suse.com>
> > > >=20
> > > > It may happen that initial balloon down fails (state=3D=3DBP_ECANCE=
LED). In
> > > > that case, it waits indefinitely. I think it should rather report a
> > > > failure (and panic? it's similar to OOM before PID 1 starts, so rat=
her
> > > > hard to recover), instead of hanging.
> > >=20
> > > Okay, I can add something like that. I'm thinking of issuing a failure
> > > message in case of credit not having changed for 1 minute and panic()
> > > after two more minutes. Is this fine?
> >=20
> > Isn't it better to get a state from balloon_thread()? If the balloon
> > fails it won't really try anymore (until 3600s timeout), so waiting in
> > that state doesn't help. And reporting the failure earlier may be more
> > user friendly. Or maybe there is something that could wakeup the thread
> > earlier, that I don't see? Hot plugging more RAM is rather unlikely at
> > this stage...
>=20
> Waking up the thread would be easy, but probably that wouldn't really
> help.

Waking it up alone no. I was thinking what could wake it up - if
nothing, then definitely waiting wouldn't help. You explained that just
below:

> The idea was that maybe a Xen admin would see the guest not booting up
> further and then adding some more memory to the guest (this should wake
> up the balloon thread again).
>=20
> I agree that stopping to wait for ballooning to finish in case of it
> having failed is probably a sensible thing to do. Additionally I could
> add a boot parameter to control the timeout after the fail message and
> the panic().

Right, that would make sense: it's basically a time admin has to plug in
more memory to the VM.

> What do you think?

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--MZykTqTxNZ8yEQ39
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmF7zckACgkQ24/THMrX
1yzVxQf8DUP3H4Z8NAkaoDVpZJ/oOnqtiuVAYq6eLO+LusUGWgfcjgF6QoxCvMCA
yuUmLc5NaZf9LNeqxNm6v+TOeS4g1ZYgAGtU1r2WeujWFD8uXD/3v1pWyWhLTFEs
BGKjjDJDWBGVYSXh64P7UKxG9fZQH+uiEy9Agfv3Gy0PhvtH8WqpD/kTi5lN/z0G
VQ5jDWcoZgluFddglJx35OXfEEjo8qaojvbl86cYBTFuiRfrVTEo411oh8yl4cHh
sWC+L0F5cngKl6M53q+Rpo3Q5Ohabd/INmhZEGOgQ7P8VXlxhlCkVUA5bWjR1rt8
KdylFCdtRVHctkF+FWP82EqQEHjmtw==
=7a/r
-----END PGP SIGNATURE-----

--MZykTqTxNZ8yEQ39--
