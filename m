Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE22351EB9A
	for <lists+stable@lfdr.de>; Sun,  8 May 2022 06:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbiEHEoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 May 2022 00:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiEHEoh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 May 2022 00:44:37 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3D7E0D4
        for <stable@vger.kernel.org>; Sat,  7 May 2022 21:40:48 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 686EF5C005F;
        Sun,  8 May 2022 00:40:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 08 May 2022 00:40:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; t=1651984846; x=1652071246; bh=N
        ew1kHAYn2RAULfL2ULXIJxNYWlQQiUEdCVT1uKZn6k=; b=r42uasgFii/DdMNXv
        Scw/IFsoZnWMWairAZPWq7pyAPtq2X+y4XfMMo4VM3/GyyLsqqedCFUTJT6UA1xc
        0evtOG4ZyhgHjhOgvfXATD9wFEumms2xfP4xW9unnqrPcl4gwikQGjQXB/gpb9Y4
        xvWw3PIsqytkV69MAfLOrhO6kaLhvSZ9olQ/+LUu87V1hX/Ky33gfKcaJ+MOxVjh
        LhFViyXIqn/hvhu/P1noc4T6XU4eOARuYbHJ8vxKxXzEZRd3Sc8g2a9STeF92kR1
        +npv9oU2Oxevn/aIbAoeM5Kq9fUlP0LvHwXNUYxvJFAPMosdjwIBW8PNwaBYeP05
        0fOcQ==
X-ME-Sender: <xms:zkl3Yk1_srdPr0GUuI3ixxsCouG3f8hNJr4x-HVEY7aJFpeiYmDCJQ>
    <xme:zkl3YvF9Uf7O8NOg9sHrBnZ6fYI7kf5RrvL03xrCWJxRe96Ot6vmb9ZVAfLNY7JPF
    xCF-SkIVnb_czY>
X-ME-Received: <xmr:zkl3Ys59ZY9ive8kExBtGs7f-fSNfSq_wytrOSNfWUB7ck57G0zJStIQbM_0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeeigdekhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfggtggujgesghdtreertddtvdenucfhrhhomhepffgvmhhiucfo
    rghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhnghhslh
    grsgdrtghomheqnecuggftrfgrthhtvghrnhepieelkeetleegieeufedvffeifeefveeg
    gfeutdehteevteefueehhfduhfetfeehnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhslhgr
    sgdrtghomh
X-ME-Proxy: <xmx:zkl3Yt0QCSCuNfEQx7_3yh1ZIGavCuVJMHCjtMfImWZnMV6TiAUYig>
    <xmx:zkl3YnGAAjfoK2h3mu23wK6QuMnaF0AN-wunbKm52nlIlVglRQE5sw>
    <xmx:zkl3Ym_SiJLD3A3mkfRxxbn82Mc6nRPWa07TMQl0nNEB-lweYRmIdg>
    <xmx:zkl3YsTKOCE2xyhJiP97esEF_hJn90blYVDYvnVawDHLh_h0fI8FKA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 8 May 2022 00:40:45 -0400 (EDT)
Date:   Sun, 8 May 2022 00:40:25 -0400
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>
Cc:     dm-devel@redhat.com, Milan Broz <gmazyland@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v2] dm-crypt: make printing of the key
 constant-time
Message-ID: <YndJzCY5sZG3k5q5@itl-email>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cOu/gkykmDr07wxN"
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2204250851320.1699@file01.intranet.prod.int.rdu2.redhat.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cOu/gkykmDr07wxN
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Sun, 8 May 2022 00:40:25 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com, Milan Broz <gmazyland@gmail.com>,
	stable@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v2] dm-crypt: make printing of the key
 constant-time

Nit: did you mean CC: stable@vger.kernel.org (colon instead of
semicolon)?  Also, would it be better to avoid using the formatting
built-in to DMEMIT()?  Finally, are there any architectures for which
gcc or clang make this non-constant-time?
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--cOu/gkykmDr07wxN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmJ3ScsACgkQsoi1X/+c
IsGt3RAA2hU0+iLv18E6gyonqnEFcAw1qMWO8eVBJ/J/zUiYSBile1ubZOESzt2T
9ic5zo6o1U34u+8g0O5kKAvtXPWZIsXEILA5Bs8rKPtWYRDy/0yfJdqDJ7tEtCjR
YIEH04j3EHVdYU4VznizQ3G2OYuhFXv1TaD9TGONlwHLtwx8fBSmpixFRxcvscol
GOQrpWT1CgYzr2zju5MpAEAOeTTAkKqDBYIgPwhOglfQ2KHKPn+Ao4nDiGVUPIvb
lLuKodoaMvxcx3vNqIGkL/lL0ivJwoqwNhDBq+UT5fA8id9Rtskh4kwYv/B+3PRm
9pAMsldNCtLMWbf7Vtcf2dfTOfqifZ/FMf14Cw2LvgA0rn3lINdM39N/Pd6LngMm
qvXxy8Ot2G8NWb9BK7ZkbzB7yHA7xnTdREfk8eFF7FYyJFWi4SDqryUqjm11FSa0
3fvUXUSUooFk1tgIIqXVDFUB8kzQjZ5TP3c47vTabKQubwHxmdYuAwM4U3dxN27B
J0nURU67xlup/r5A/7siPVteNjQ7KfkT4MVHL2WW6bOSQrsyutqqIiEFvbYkp5Ug
e/e6/vWB3GTfnAPRX+b1NNLcuFOMRi0Q5qv9IPa4SMJf9vP8YtAcRikjNrhyITf+
s5Y0gCb2vup7fHeOC6a7ac4wj7NbN0O1vvEnsBKENq3ufjLBtsg=
=pKVN
-----END PGP SIGNATURE-----

--cOu/gkykmDr07wxN--
