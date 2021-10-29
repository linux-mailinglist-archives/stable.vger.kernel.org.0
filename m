Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD62440559
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 00:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhJ2WVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 18:21:17 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43997 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230325AbhJ2WVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 18:21:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 2160A5C0174;
        Fri, 29 Oct 2021 18:18:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 29 Oct 2021 18:18:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4qxxtO
        1Z9+doNE2lABc+fvUK72/uISVCrks1lvW+WaQ=; b=U5wIDMy9uUT4rPkdJzu3Ck
        Vne/wo+YL2pw2A6hlvjAPM7U+p5Ao9iWAv/pdxLwvOdBbiMLP/L4i9KNDs5HApJw
        m61aVwctXZzCvllmHjyPl0Av8/RPMf3vC69nsxXw2INHcRgRicicbSnoV/veZsq/
        tmT3qvX9P7k9XasR2xbrgNcMoGq4/95usFoAiZSsYEHSpamdt9gpWFt3+6RokMkC
        P3Kn2YQxP57Mn3Wd2+dMiN8AH5WVmKO1r6oKBj1k4Zxkm8skgUxfzQ4M90/r1kvq
        WQuasfyxF3WH1xQy/CZ5OL6uI9H/qDsxnTQlCUTmL72IRX6Zh2JL0szocIuCY2ag
        ==
X-ME-Sender: <xms:RnN8YVspSbaCdxkzQxj_CWkz-4xDZaLS84iF9I49mrRzlbP-dm8QuA>
    <xme:RnN8Yed5KKrfUGd1F2hxhG5Idyf_TbLaXq5Imm1vTwfk9V66yYr-F1x-RkIBsPnGC
    U3xVUNrE8zezg>
X-ME-Received: <xmr:RnN8YYzJFXtCMjSIk2xkdCtu16WZmbBAqnyUubva2doDuCoJTIwGxnhil9V0oyiGwmcrpLWtzbsi8ETf0I05enOmQ5GFfmMq>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdegiedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeforghrvghk
    ucforghrtgiihihkohifshhkihdqifpkrhgvtghkihcuoehmrghrmhgrrhgvkhesihhnvh
    hishhisghlvghthhhinhhgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeetveff
    iefghfekhffggeeffffhgeevieektedthfehveeiheeiiedtudegfeetffenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrghrmhgrrhgvkhes
    ihhnvhhishhisghlvghthhhinhhgshhlrggsrdgtohhm
X-ME-Proxy: <xmx:RnN8YcMETnWD4FGYftpSXHPRXmAmETOloQqWxW5JYZhNIoWuGsryhA>
    <xmx:RnN8YV_9hsQJXna6sbtqbcakQU2Z38U7REQtaFA0rkFVs5K0xSHLig>
    <xmx:RnN8YcXXl2v-ip88bcdV0P8QWkfttpeQ2K35ii3MdcSOWmLLxelD_Q>
    <xmx:R3N8YQaRt51VKEqxyUVd2Kvug-m2qdqQ3SGLmCc0iY_YYFx_yhH89w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 Oct 2021 18:18:45 -0400 (EDT)
Date:   Sat, 30 Oct 2021 00:18:42 +0200
From:   Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] xen/balloon: add late_initcall_sync() for initial
 ballooning done
Message-ID: <YXxzQhPvgAOkhGg/@mail-itl>
References: <20211029142049.25198-1-jgross@suse.com>
 <11956c14-f1f7-70f0-40a6-aad31a264af6@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xKPG9ePjWpG+ScdL"
Content-Disposition: inline
In-Reply-To: <11956c14-f1f7-70f0-40a6-aad31a264af6@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xKPG9ePjWpG+ScdL
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Sat, 30 Oct 2021 00:18:42 +0200
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
	linux-kernel@vger.kernel.org,
	Stefano Stabellini <sstabellini@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3] xen/balloon: add late_initcall_sync() for initial
 ballooning done

On Fri, Oct 29, 2021 at 05:46:18PM -0400, Boris Ostrovsky wrote:
>=20
> On 10/29/21 10:20 AM, Juergen Gross wrote:
> > --- a/Documentation/ABI/stable/sysfs-devices-system-xen_memory
> > +++ b/Documentation/ABI/stable/sysfs-devices-system-xen_memory
> > @@ -84,3 +84,13 @@ Description:
> >   		Control scrubbing pages before returning them to Xen for others dom=
ains
> >   		use. Can be set with xen_scrub_pages cmdline
> >   		parameter. Default value controlled with CONFIG_XEN_SCRUB_PAGES_DEF=
AULT.
> > +
> > +What:		/sys/devices/system/xen_memory/xen_memory0/boot_timeout
> > +Date:		November 2021
> > +KernelVersion:	5.16
> > +Contact:	xen-devel@lists.xenproject.org
> > +Description:
> > +		The time (in seconds) to wait before giving up to boot in case
> > +		initial ballooning fails to free enough memory. Applies only
> > +		when running as HVM or PVH guest and started with less memory
> > +		configured than allowed at max.
>=20
>=20
> How is this going to be used? We only need this during boot.
>=20
>=20
> > -		state =3D update_schedule(state);
> > +		balloon_state =3D update_schedule(balloon_state);
>=20
>=20
> Now that balloon_state has whole file scope it can probably be updated in=
side update_schedule().
>=20
>=20
> > +	while ((credit =3D current_credit()) < 0) {
> > +		if (credit !=3D last_credit) {
> > +			last_changed =3D jiffies;
> > +			last_credit =3D credit;
> > +		}
> > +		if (balloon_state =3D=3D BP_ECANCELED) {
>=20
>=20
> What about other states? We are really waiting for BP_DONE, aren't we?

BP_DONE is set also as an intermediate step:

                       balloon_state =3D decrease_reservation(n_pages,
                                                            GFP_BALLOON);
                       if (balloon_state =3D=3D BP_DONE && n_pages !=3D -cr=
edit &&
                            n_pages < totalreserve_pages)
                               balloon_state =3D BP_EAGAIN;

It would be bad to finish waiting in this case.

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--xKPG9ePjWpG+ScdL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmF8c0IACgkQ24/THMrX
1yxlhwf+OIifFECv8WTtmwBHvacvFlHzQBwagjrD83H3pw7ACJBLikt5YbfqVNBT
VzYMegSAbgXVjURqPQgJefIylOcwwY+dk26sQS+6S5YtRZdJZX9z9GSNuqBxQzAv
Sa1FNKGAuHyEdAgV23cPo5v4AdgIwbwV2NjPorIeOyVK1oOnvn+59SakN91TtmM9
GGvgNCkzd8KpSG2dswucJqrRvR8Ng8Y/Vskg0QSdS5MKWgth64xWU6raTgyi8vSE
2HjxLH8HYZM/kk+ZSUP2E3snLsJGHNnkwC15qFT1ui2EH/bJeqVSqJHWhBJ2bflH
wbHj/ikVIoFBqMHXf8FJDsRqPzkBSg==
=pMDf
-----END PGP SIGNATURE-----

--xKPG9ePjWpG+ScdL--
