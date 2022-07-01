Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E18562B2D
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 08:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbiGAGCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 02:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbiGAGCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 02:02:31 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7658C6B819
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 23:02:30 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D0C335C0144;
        Fri,  1 Jul 2022 02:02:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 01 Jul 2022 02:02:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1656655349; x=
        1656741749; bh=wYH+5idjnaYEDi0fQMCML0U5b5ym8CcDG6Nq6PKCwGg=; b=a
        ub/cYtRrhu/KE9H92XuMWeCHUn3gq5JAgpWIqwV0SlcV8lqluiEdt+0X7ElruGr+
        EQlPkHv6YYtZ3Z4nUHTOzbRJqZtA/xPLoZ98diRlH0BASm7CjAmocmCClwFxRd4R
        /ZxVq5g2BRAgiAa4O21tMi5OowrtddnwSKmqnkhq/WTH1nQagFvAslZwNL7MdW+b
        DenjsLYpjWVxo7Q2JPB1abV+R5WsUIrQfQTffe0NQmLFHpr/iQxGLxkpihPSDWP3
        p+2oYR7PFtYgwjKnEPoIFMjXYj15Ozkej0JkKNF3DJkMBv1bKPrA9/l+VRXcj33i
        PMliC6DYaCEpz/nEM+j4A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1656655349; x=1656741749; bh=wYH+5idjnaYEDi0fQMCML0U5b5ym
        8CcDG6Nq6PKCwGg=; b=voxQ6KijTNSqKElS77lVhi2EzhwTGMm5wUQB/aebD0cb
        S0LYqPdhN6fW8C/AhJsvaF4n6iP8tReMtCF4s3pVFF0oRW2U2WTcV0fmmajrgKhL
        MW/qIM0okoQ24NP2/TsbWb3va9LSiCjmwsPHEa6Xzmel9AjZvCbJGH7dbY4JXAj2
        OW75b/CPAlQUJ1tPrgPz7SqR7FpjA1idKlrcYlF0K1RTgrq75NFWCuETf9C7Q/6D
        0vysx//asA57G8xbdwbm4ebPji49T3uwwGoj1eGyJTZzSueNkMZenJ//JnlOlbjB
        CoP1eOp2e65QVCY7JcKfqi6VaqqByTBd7BKLXv7i8A==
X-ME-Sender: <xms:9Y2-Yh3N8RsIolle5VjJfjGSz9zr2HTdZOr_FFTnMqYdaH0mFWup5w>
    <xme:9Y2-YoF_7qjluxbX-ZKGCSevjXfIn9f8zsOote0AAKiokO32DdlSk4AfXx_ALMbqI
    tQ2OKZTDVtDcsA>
X-ME-Received: <xmr:9Y2-Yh6IZpR3SI2zFHi5EfK6c9EBzSI60Qy-22lo8f6FbdnVgPo8GY_cLkYl>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudehvddguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesghdtreertddtvdenucfhrhhomhepffgvmhhi
    ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
    hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnheptdeigeehudegjeelteehveehveef
    ieehiefhfefgtdduhfdtjedtkeevffefteffnecuffhomhgrihhnpehgihhthhhusgdrtg
    homhdpkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtg
    homh
X-ME-Proxy: <xmx:9Y2-Yu1UfhIp9Uy4MO83p3HgBiSLVUgA4iIVpkA5eCNHQlkt-1h2PQ>
    <xmx:9Y2-YkHb1mxCEcITaxRc1lcsHsVH-oJYx2PoghylsHVtlDec0RZM2w>
    <xmx:9Y2-Yv9cSl9TvvLwzbhFcpV__IKxil6mWFDzM3ViMMwNke1fS_upbg>
    <xmx:9Y2-YuMwoG2nVwbTogm4yVVZDMQnt9m62oqU8w1pF3mYkzNl_9pRTw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 1 Jul 2022 02:02:29 -0400 (EDT)
Date:   Fri, 1 Jul 2022 02:02:26 -0400
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Juergen Gross <jgross@suse.com>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xen developer discussion <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH 5.10] xen/gntdev: Avoid blocking in unmap_grant_pages()
Message-ID: <Yr6N87QcWTm9SAwR@itl-email>
Mail-Followup-To: Demi Marie Obenour <demi@invisiblethingslab.com>,
        Juergen Gross <jgross@suse.com>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xen developer discussion <xen-devel@lists.xenproject.org>
References: <20220627181006.1954-1-demi@invisiblethingslab.com>
 <Yr2KKpWSiuzOQr7v@kroah.com>
 <5136812e-e296-4acb-cafd-f189c4013ed3@suse.com>
 <Yr3VQaM0NBcIV2Kl@itl-email>
 <1c3bfe41-b86d-660c-6ccf-17777d1a5801@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Niq2cF0LcwVvL5C2"
Content-Disposition: inline
In-Reply-To: <1c3bfe41-b86d-660c-6ccf-17777d1a5801@suse.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Niq2cF0LcwVvL5C2
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Fri, 1 Jul 2022 02:02:26 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Juergen Gross <jgross@suse.com>, Greg KH <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	Xen developer discussion <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH 5.10] xen/gntdev: Avoid blocking in unmap_grant_pages()

On Fri, Jul 01, 2022 at 07:56:28AM +0200, Juergen Gross wrote:
> On 30.06.22 18:54, Demi Marie Obenour wrote:
> > On Thu, Jun 30, 2022 at 03:16:41PM +0200, Juergen Gross wrote:
> > > On 30.06.22 13:34, Greg KH wrote:
> > > > On Mon, Jun 27, 2022 at 02:10:02PM -0400, Demi Marie Obenour wrote:
> > > > > commit dbe97cff7dd9f0f75c524afdd55ad46be3d15295 upstream
> > > > >=20
> > > > > unmap_grant_pages() currently waits for the pages to no longer be=
 used.
> > > > > In https://github.com/QubesOS/qubes-issues/issues/7481, this lead=
 to a
> > > > > deadlock against i915: i915 was waiting for gntdev's MMU notifier=
 to
> > > > > finish, while gntdev was waiting for i915 to free its pages.  I a=
lso
> > > > > believe this is responsible for various deadlocks I have experien=
ced in
> > > > > the past.
> > > > >=20
> > > > > Avoid these problems by making unmap_grant_pages async.  This req=
uires
> > > > > making it return void, as any errors will not be available when t=
he
> > > > > function returns.  Fortunately, the only use of the return value =
is a
> > > > > WARN_ON(), which can be replaced by a WARN_ON when the error is
> > > > > detected.  Additionally, a failed call will not prevent further c=
alls
> > > > > from being made, but this is harmless.
> > > > >=20
> > > > > Because unmap_grant_pages is now async, the grant handle will be =
sent to
> > > > > INVALID_GRANT_HANDLE too late to prevent multiple unmaps of the s=
ame
> > > > > handle.  Instead, a separate bool array is allocated for this pur=
pose.
> > > > > This wastes memory, but stuffing this information in padding byte=
s is
> > > > > too fragile.  Furthermore, it is necessary to grab a reference to=
 the
> > > > > map before making the asynchronous call, and release the referenc=
e when
> > > > > the call returns.
> > > > >=20
> > > > > It is also necessary to guard against reentrancy in gntdev_map_pu=
t(),
> > > > > and to handle the case where userspace tries to map a mapping who=
se
> > > > > contents have not all been freed yet.
> > > > >=20
> > > > > Fixes: 745282256c75 ("xen/gntdev: safely unmap grants in case the=
y are still in use")
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
> > > > > Reviewed-by: Juergen Gross <jgross@suse.com>
> > > > > Link: https://lore.kernel.org/r/20220622022726.2538-1-demi@invisi=
blethingslab.com
> > > > > Signed-off-by: Juergen Gross <jgross@suse.com>
> > > > > ---
> > > > >    drivers/xen/gntdev-common.h |   7 ++
> > > > >    drivers/xen/gntdev.c        | 142 +++++++++++++++++++++++++---=
--------
> > > > >    2 files changed, 106 insertions(+), 43 deletions(-)
> > > >=20
> > > > All now queued up, thanks.
> > >=20
> > > Sorry, but I think at least the version for 5.10 is fishy, as it remo=
ves
> > > the tests for successful allocations of add->map_ops and add->unmap_o=
ps.
> >=20
> > That is definitely a bug; I will send another version (without your
> > Reviewed-by).
> >=20
> > > I need to do a thorough review of the patches (the "Reviewed-by:" tag=
 in
> > > the patches is the one for the upstream patch).
> >=20
> > Yeah, that was my fault, sorry.
> >=20
> > > Greg, can you please wait for my explicit "okay" for the backports?
> >=20
> > Confirming that these patches do need review before they can be applied.
> > Juergen, would you mind making sure that the upstream patch was also
> > correct for 5.15 and 5.18?  It applied cleanly, but that is no guarantee
> > of correctness.
>=20
> Those two are fine.

Thanks!  I re-sent the 5.10 patch; hopefully the others are good.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--Niq2cF0LcwVvL5C2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmK+jfMACgkQsoi1X/+c
IsHbZg/+P9onGYM5Pr4XcVDzf96AxARCkyw3tShzc4Vu1UyfnwV7uvhQF6+3VJMF
IXOBJK3ebOsMgh0/eVvoXLKhn68n5K47xIIJPrtdglOCAYolvrG0G5yMvi2wQOWg
1xt1ryu4GXR6z2Cwpt8St3vYgFq9hycztQ2vWXRwKDAdrOWac+BCrEwZQC9pRnRl
fDYmSzXMXkOlQUrlZ4njowv0ZbcMybRI9IQZ6dDhcWfSycaHj9kh8grybuPMZnmt
Q+BRpHbvi9gbpJFcDmsk8EsqHj4lUdLDjY/yve5ndIxVev3QLp2JwIL+tB2oXqgl
YXkhEqHNHwwuHo/H5RTfT1ds7KzutJjE0vMR6eket824fLrIVXuIw09aighpY1Vg
GFoB9B1RckmYmo1ZzmtWJusrkPBcbRkeWzydZYfXum71D3uxa1lkhxSUH+BzjiCp
B6y5BkBad8ruRh7qZHgt17kto99oodQgCP2WHUFjupoe0nc8roJJ2dNAWz8UIZOd
BW3vUFSf4tY5gY06vWlw7Ux8g8fWwInLlwF370LVDUMmIzNsLJAYk0RDTbMPdpNy
KZj0hsI7S0A/YuSMd/0CCo2TZg/KRI0UM38Z4UPtCl2KcDdxSZSRdTqDQs0isRSe
ZcmSlwQOIGs3i2tfS4vjpOV1B8zn6hjbdYcoMRv3MIFUyxBYvqI=
=VEPi
-----END PGP SIGNATURE-----

--Niq2cF0LcwVvL5C2--
