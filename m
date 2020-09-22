Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68995274B37
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 23:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgIVVdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 17:33:12 -0400
Received: from ozlabs.org ([203.11.71.1]:52447 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgIVVdL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 17:33:11 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Bwvg927w2z9sTg;
        Wed, 23 Sep 2020 07:33:09 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1600810389;
        bh=wdaIEO+NuHUYwLpv/caHA6S1lErLvoGUgiPFyjBDdNU=;
        h=Date:From:To:Cc:Subject:From;
        b=LcUA41eaoLoTg7M9Y4r8KmLOszHLOpoT0HokW4COwjatiDHdEsw/XJ7xfFNfMBIV3
         t/3gahFAqfuTRqAysGuLjy2ERlWoqoJT+CCR8NRRX2tnh2H8Sg6QHsjAEufNdD3+4u
         g3lfMZrBN/CFKJb9GxwIL89msTlIZQ6R5v2+6V2W0zy8qZt3/Q+BH5+qd0C4RrRT6S
         V9QwUkrc8XJb2Z6j4qYB0u8RGlUG1nZHGf7J1Kuv/vhkTwHcpLek4wYEduW3m/w6Qb
         tkG/7Wtw50t/NKjLfZ6/ZBkYpnKLQBA45qhsm4b99CtzKFjhyBg9hcdbEd+FwL5/cU
         xa/UU1An5T0Mg==
Date:   Wed, 23 Sep 2020 07:33:08 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lewis Huang <Lewis.Huang@amd.com>, <stable@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the amdgpu tree
Message-ID: <20200923073308.44199aa0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/UBZ+T/RBVZZ0A.7PbcncqWa";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/UBZ+T/RBVZZ0A.7PbcncqWa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  bc6058294cb2 ("drm/amd/display: [FIX] update clock under two conditions")

Fixes tag

  Fixes: 06f9b1475d98 ("drm/amd/display: update clock when non-seamless boo=
t stream exist")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: 598c13b21e25 ("drm/amd/display: update clock when non-seamless boot =
stream exist")

--=20
Cheers,
Stephen Rothwell

--Sig_/UBZ+T/RBVZZ0A.7PbcncqWa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9qbZQACgkQAVBC80lX
0GwJXQf/S/TG9Dxb3GfR6LgyvSB8AIzpaS2Zr9Q0zQWXsazu3OuF0h95DMFHlCjo
S+3EukqZxlxGz6V1vIuAsxGzjefqhih+7JhdhWPaGjnuWEQs5r2C7W6mLKo/Tzv8
c2JjTvGr60QUqCTUiY22A0xeYEvWWo21JzFuIJcERYKsv8k9xQrr4/yJrVm1LRBm
oGfV3q0G+Yb1YA2o9e2M61w3DLbrbpoIS4ovTi+Ga7ZZlyGIKjJX+XqYmrEiQY4i
+DOEJySyrV87BaGcx6PZOY4auO3+kfVroNeXw6PkSAIHz3nqorbH+kSzAG2j1576
cS3wyCqx8rTRCgn9wMJd8Wag626ZrA==
=pglL
-----END PGP SIGNATURE-----

--Sig_/UBZ+T/RBVZZ0A.7PbcncqWa--
