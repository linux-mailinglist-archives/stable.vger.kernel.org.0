Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D3C6BCA10
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 09:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbjCPIxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 04:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjCPIwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 04:52:43 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1EAB6D00;
        Thu, 16 Mar 2023 01:51:55 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 278841C0E45; Thu, 16 Mar 2023 09:51:12 +0100 (CET)
Date:   Thu, 16 Mar 2023 09:51:11 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Missing patches in 4.19? was Re: [PATCH 4.19 00/39] 4.19.278-rc1
 review
Message-ID: <ZBLYf4KZYj62HuHX@duo.ucw.cz>
References: <20230315115721.234756306@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="hfoho1475IXJp3mD"
Content-Disposition: inline
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--hfoho1475IXJp3mD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Pseudo-Shortlog of commits:

There is something missing here.

In 5.10-rc we have:

de365066382ce0dbbf3b7189128ccc16e4eae198 net: caif: Fix use-after-free in c=
fusbl_device_notify()

4.14-rc has:

921b052b636c72fbb97c50bd0be33bd7358ab374 net: caif: Fix use-after-free in c=
fusbl_device_notify()

But I don't see corresponding patch in 4.19.

More than one patch may be affected:

 |70cec8eec 9781e9 .: 5.10| net: caif: Fix use-after-free in cfusbl_device_=
notify()
 |f690886b9 9781e9 .: 4.14| net: caif: Fix use-after-free in cfusbl_device_=
notify()
 |98e6078de 11f180 .: 5.10| nfc: fdp: add null check of devm_kmalloc_array =
in fdp_nci_i2c_read_device_properties
 |012961752 11f180 .: 4.14| nfc: fdp: add null check of devm_kmalloc_array =
in fdp_nci_i2c_read_device_properties
 |b4e4d4931 693aa2 o: 5.10| ila: do not generate empty messages in ila_xlat=
_nl_cmd_get_mapping()
 |f2b350c04 693aa2 o: 4.14| ila: do not generate empty messages in ila_xlat=
_nl_cmd_get_mapping()

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--hfoho1475IXJp3mD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZBLYfwAKCRAw5/Bqldv6
8kBPAKCcpVZshDaytTYFTfpkxrsnpLxRFgCgoSk1P5lcFn5Weu1vWhhhtsdPgvI=
=132h
-----END PGP SIGNATURE-----

--hfoho1475IXJp3mD--
