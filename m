Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39DCB6437BB
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 23:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbiLEWJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 17:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiLEWJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 17:09:58 -0500
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B7BE02A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 14:09:57 -0800 (PST)
Received: from 213.219.160.184.adsl.dyn.edpnet.net ([213.219.160.184] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1p2Jet-0006gQ-Si; Mon, 05 Dec 2022 23:09:55 +0100
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1p2Jet-000jRl-0l;
        Mon, 05 Dec 2022 23:09:55 +0100
Date:   Mon, 5 Dec 2022 23:09:55 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: [PATCH 4.14 0/2] x86/speculation: Regression fixes
Message-ID: <Y45sM5Dg6Y6YQIBZ@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eAaM57oZbv+ueLBh"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 213.219.160.184
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--eAaM57oZbv+ueLBh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Fix two regressions introudced by recent speculation mitigations
on the 4.14 branch:

- Crash on older 32-bit processors
- Build warning from objtool

Ben.

Ben Hutchings (1):
  Revert "x86/speculation: Change FILL_RETURN_BUFFER to work with
    objtool"

Peter Zijlstra (1):
  x86/nospec: Fix i386 RSB stuffing

 arch/x86/include/asm/nospec-branch.h | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)


--eAaM57oZbv+ueLBh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmOObCoACgkQ57/I7JWG
EQlSBg//cf+S1TZMFZMwlyZDsL0XcdPoGFiK8uh5wFyzMQ4OGdUsFEcL4cRtHCih
UZpUVnfgJ24cK7+QHu6oYYQOUO7YZoRx/S6OHVyXKgJULiMNvk63NlMbrZscz++4
mXRnQ3X5c2vfz6LJQjefiTrPpHFV2L/2eUn8vM+pjEDKug819/VG/8MyFXgtsXAj
rSD4Db2ZwSUTxdvUII38V41OqVz7ubck788q4kLmo6a4SsKBEH3RUSsuRgfTYBIx
KRzzSrVAiN1bfK/dvktrXqKPtOWS4aa/tUjPVPSPu3LgHLSFMrKwiS7Rrw4gWBVL
pnTQEmhjY04I4GTZkn3UctoJeSpz9IROLFXXAvv/9uTrDxxKVBnrk5VVxs7umCIk
ywt3wDdXOTEI2M5+6x6z88M5Vf0OtAqOn9IPXW1TR2/nKR9uMROXAZ2lCyzpazBF
Qu3Z1aWbTbC/HJJJoIgiPnBEMwDNAl3l9vcYWk2Q+Npr0ZLH87hryPLLG0pXDYxM
N5XXAxiN5YXfLzPK5mlkGRJ8RIcbC8HvDOjI9zko1crjx8iils2QK4ujjbOzmcbV
yqg20b4Q2W5M5CQBOdqgumhzRAtEWkU+GEGf0W6TToTSWm8TE6Cj/VS0rC+hWeGM
1rDS/I4FnCiyTpnwCr2AV+YsJtRKYLeQcXmLxlJZ+tpH2CZF78w=
=tNfH
-----END PGP SIGNATURE-----

--eAaM57oZbv+ueLBh--
