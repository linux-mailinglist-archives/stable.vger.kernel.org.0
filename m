Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876AB69679B
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 16:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbjBNPIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 10:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjBNPIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 10:08:21 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BED317176;
        Tue, 14 Feb 2023 07:08:20 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4CE1A5C00E9;
        Tue, 14 Feb 2023 10:08:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 14 Feb 2023 10:08:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1676387298; x=
        1676473698; bh=elzZ43LKNtskgQb+dtRg8bbRNCKz8uQV13+HixszXXw=; b=N
        110Tcn9D2Uj0Uv03GzqmQSFJnlv3ur3LQcVWbYZ/mMfCHfkioAgPnzJFgSsfHMEG
        ar/abhLEF8DAKi58gPlkJGAkfZ836ualJblNnaxznOLV6xi2vX3pDfHd6SBn2LD+
        R3a2kLuaYyPjQuDOAjDEXSW9/dvJ02mCTkwbSM6Os7W7f3MDIgno9OKUlpRsZCBv
        u+bP0DeVmGTmgNruxUpdmHzpnA9t263x1MFY6fq+5UONkIZFkccl/E+eIzlV8s9l
        fZtidTL0kWZFg20AS36Bh7G6ogR6+7YhQt/tf0L9LjxAIL43Dfw9RG/plpB1wNvD
        g3knDshKS0JjwkPOQ7htA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1676387298; x=1676473698; bh=elzZ43LKNtskgQb+dtRg8bbRNCKz
        8uQV13+HixszXXw=; b=FF+oibrueivLy4Vkd4Ee9TmjKrL8N18HpPdXEv7Uyv6E
        a4PjO6MeUiO/Ugs/VmQ1XWYax50qok+pTJ4APDD3gcj/G0NY4rp3brpL2szW3Ncn
        fK3+8tpOavrIF0x6xOB++W02Kx7vDNi3Vsx5IzaF2fAPHRv36wrbkTY3UZiZcgfT
        66zWouod/15ZlWMEM0Oy1xB5KzqyKcuPDE0rZWZFZWiG0PQgVI/CcY2iaZ7lj2C6
        9Ok9ahKPAJL8VYOlxPd9gFLlw/+34ISbqdYtptwmoB18JIW2sQINQYuU2sx8vjbk
        r4lm16DPq+bQKnuHUdE2UT1yhf0/GoPGBbYEscOPVw==
X-ME-Sender: <xms:4aPrY_zIE4m6fyiPmdBpU5VWU_1DGrNLSodizUxHlHPrDH5YRM8VaA>
    <xme:4aPrY3QXRTySyuTn71tf-7sFM7bluB1PSEhHoc5Kf6ySyuvmVu1KBVwrs68vYCxm3
    hpGfNOjt_cunp0>
X-ME-Received: <xmr:4aPrY5WMzeomYNeKCP0zdTWUdbmk7HdoZq-xDr2DF3PgEmg-00j3FAsq5aI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeifedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepffgvmhhi
    ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
    hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepvdejteegkefhteduhffgteffgeff
    gfduvdfghfffieefieekkedtheegteehffelnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
    lhgrsgdrtghomh
X-ME-Proxy: <xmx:4aPrY5glErqjNlL9ZTrCi1xOU70F9nHcxTY__PgPHH3fty_Owb4ihA>
    <xmx:4aPrYxBW5Dv-WsVOVdDn7rWCaEfaBELi8d4P0f7E-WLDWT_M2DL1Jw>
    <xmx:4aPrYyKhMV3_QN2MXR3zZWQxh735QYr_iTcuyaH3_RqcawMxF7crAw>
    <xmx:4qPrY89nKyQPWTtyfKiEIzzOoZSiVleZBRPpNHReY1C-J4Ppneh8hg>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Feb 2023 10:08:16 -0500 (EST)
Date:   Tue, 14 Feb 2023 10:08:14 -0500
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc:     Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xen: speed up grant-table reclaim
Message-ID: <Y+uj3ynQ6JN+NOn1@itl-email>
References: <20230207021033.1797-1-demi@invisiblethingslab.com>
 <5fdc17c1-4222-aea2-c1d1-be8b15b7f523@suse.com>
 <Y+qlPYi20cP0yXnE@itl-email>
 <763838a9-acd5-b330-6165-6c288973d51c@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="DbwWERBYmiTeYpZW"
Content-Disposition: inline
In-Reply-To: <763838a9-acd5-b330-6165-6c288973d51c@suse.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--DbwWERBYmiTeYpZW
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Feb 2023 10:08:14 -0500
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] xen: speed up grant-table reclaim

On Tue, Feb 14, 2023 at 08:51:09AM +0100, Juergen Gross wrote:
> On 13.02.23 22:01, Demi Marie Obenour wrote:
> > On Mon, Feb 13, 2023 at 10:26:11AM +0100, Juergen Gross wrote:
> > > On 07.02.23 03:10, Demi Marie Obenour wrote:
> > > > When a grant entry is still in use by the remote domain, Linux must=
 put
> > > > it on a deferred list.  Normally, this list is very short, because
> > > > the PV network and block protocols expect the backend to unmap the =
grant
> > > > first.  However, Qubes OS's GUI protocol is subject to the constrai=
nts
> > > > of the X Window System, and as such winds up with the frontend unma=
pping
> > > > the window first.  As a result, the list can grow very large, resul=
ting
> > > > in a massive memory leak and eventual VM freeze.
> > > >=20
> > > > Fix this problem by bumping the number of entries that the VM will
> > > > attempt to free at each iteration to 10000.  This is an ugly hack t=
hat
> > > > may well make a denial of service easier, but for Qubes OS that is =
less
> > > > bad than the problem Qubes OS users are facing today.
> > >=20
> > > > There really
> > > > needs to be a way for a frontend to be notified when the backend has
> > > > unmapped the grants.
> > >=20
> > > Please remove this sentence from the commit message, or move it below=
 the
> > > "---" marker.
> >=20
> > Will fix in v2.
> >=20
> > > There are still some flag bits unallocated in struct grant_entry_v1 or
> > > struct grant_entry_header. You could suggest some patches for Xen to =
use
> > > one of the bits as a marker to get an event from the hypervisor if a
> > > grant with such a bit set has been unmapped.
> >=20
> > That is indeed a good idea.  There are other problems with the grant
> > interface as well, but those can be dealt with later.
> >=20
> > > I have no idea, whether such an interface would be accepted by the
> > > maintainers, though.
> > >=20
> > > > Additionally, a module parameter is provided to
> > > > allow tuning the reclaim speed.
> > > >=20
> > > > The code previously used printk(KERN_DEBUG) whenever it had to defer
> > > > reclaiming a page because the grant was still mapped.  This resulte=
d in
> > > > a large volume of log messages that bothered users.  Use pr_debug
> > > > instead, which suppresses the messages by default.  Developers can
> > > > enable them using the dynamic debug mechanism.
> > > >=20
> > > > Fixes: QubesOS/qubes-issues#7410 (memory leak)
> > > > Fixes: QubesOS/qubes-issues#7359 (excessive logging)
> > > > Fixes: 569ca5b3f94c ("xen/gnttab: add deferred freeing logic")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
> > > > ---
> > > > Anyone have suggestions for improving the grant mechanism?  Argo is=
n't
> > > > a good option, as in the GUI protocol there are substantial perform=
ance
> > > > wins to be had by using true shared memory.  Resending as I forgot =
the
> > > > Signed-off-by on the first submission.  Sorry about that.
> > > >=20
> > > >    drivers/xen/grant-table.c | 2 +-
> > > >    1 file changed, 1 insertion(+), 1 deletion(-)
> > > >=20
> > > > diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> > > > index 5c83d41..2c2faa7 100644
> > > > --- a/drivers/xen/grant-table.c
> > > > +++ b/drivers/xen/grant-table.c
> > > > @@ -355,14 +355,20 @@
> > > >    static void gnttab_handle_deferred(struct timer_list *);
> > > >    static DEFINE_TIMER(deferred_timer, gnttab_handle_deferred);
> > > > +static atomic64_t deferred_count;
> > > > +static atomic64_t leaked_count;
> > > > +static unsigned int free_per_iteration =3D 10000;
> > >=20
> > > As you are adding a kernel parameter to change this value, please set=
 the
> > > default to a value not potentially causing any DoS problems. Qubes OS=
 can
> > > still use a higher value then.
> >=20
> > Do you have any suggestions?  I don=E2=80=99t know if this is actually =
a DoS
> > concern anymore.  Shrinking the interval between iterations would be.
>=20
> Why don't you use today's value of 10 for the default?

Will do.  I now remember that the DoS concern is that the kernel could
be made to use excess CPU trying and failing to reclaim memory.

> > > > +
> > > >    static void gnttab_handle_deferred(struct timer_list *unused)
> > > >    {
> > > > -	unsigned int nr =3D 10;
> > > > +	unsigned int nr =3D READ_ONCE(free_per_iteration);
> > >=20
> > > I don't see why you are needing READ_ONCE() here.
> >=20
> > free_per_iteration can be concurrently modified via sysfs.
>=20
> My remark was based on the wrong assumption that ignore_limit could be
> dropped.

Even if ignore_limit could not be dropped, READ_ONCE is still necessary
to avoid a data race.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--DbwWERBYmiTeYpZW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmPro98ACgkQsoi1X/+c
IsEScg//XbsDTP2xk1rqtM2Zbnp1eJEceVGpdrVFez4q3RFLWctIb9YSYiagJbQ5
R4zqEJ/PbwpciLBko88l/elC4UrdlJbKN/d4Fo6/nBVNQMVHbpYOgz5DSEQ0Njzs
Y0k15KZ3yxBvJ18PdF6y+IE+fgCBfx64VqNZKdllFcM7YOOed3d5F/wn/AiaHhag
lGbFfCphhR6jrRhry2GUauK+akrbJB7LPH/j1vA0Q1kjZTHA982Py2GWfFb/SaoC
9k6Diyrbeis9Wsu+qya39wHF4+UOExV2eaD6YYUBr2/6prikGe9f7lp/W9SrZi3V
h9agm9hIvM8HTaIVi6pZuUNoSDik5/ws+g9DY0DurGeRkhjb4Vq5ctofXsBR/WmB
BJWJYVs2whBRefrZDsNfsApvfvfj37PWwjMC8JE6uYtijglY6l2DsDfKYNjzTPPq
UcMeCQczTxQFrBUCct1cMT00FeBQRms8gcYk4eBjpj9be7omcMcJORYFQ/ty0NXO
Tm9imaZAqEJ0NmTkTYbe3zHYaiLUVi34e2QUyZBonM4An9DKPslOsFq2NhuBkltm
fn48SvAm5T6239eFjfZKGZ4BZs2KbQb/6uqQbUkddGOZR46knHonUWoLo8QpjExj
R3BGygcamJdqvlzDBD7swX7y5oDSAApKMPtM4DgaeNH92megoHA=
=Yk/p
-----END PGP SIGNATURE-----

--DbwWERBYmiTeYpZW--
