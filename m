Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3DB4AE06B
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 19:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbiBHSLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 13:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344326AbiBHSLg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 13:11:36 -0500
X-Greylist: delayed 364 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 10:11:35 PST
Received: from bluehome.net (bluehome.net [96.66.250.149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33BAC061576
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 10:11:35 -0800 (PST)
Received: from valencia (valencia.lan [10.0.0.17])
        by bluehome.net (Postfix) with ESMTPSA id B5D9F4B400F5;
        Tue,  8 Feb 2022 10:05:30 -0800 (PST)
Date:   Tue, 8 Feb 2022 10:05:29 -0800
From:   Jason Self <jason@bluehome.net>
To:     Stefan Agner <stefan@agner.ch>,
        Greg KH <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: Regression/boot failure on 5.16.3
Message-ID: <20220208100529.41d1b4d7@valencia>
In-Reply-To: <00b41f5de94fca5ef995ab2c95def4aa@agner.ch>
References: <20220203161959.3edf1d6e@valencia>
 <00b41f5de94fca5ef995ab2c95def4aa@agner.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/.p8=5FGObjCkfRNZclWLeLR"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/.p8=5FGObjCkfRNZclWLeLR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 08 Feb 2022 09:50:59 +0100
Stefan Agner <stefan@agner.ch> wrote:

> On 2022-02-04 01:19, Jason Self wrote:
>  [...] =20
>=20
> I have several reports of Intel NUC 10th/11th gen not booting/crashing
> during boot after updating to 5.10.96 (from 5.10.91). At least one
> stack trace shows iwl_dealloc_ucode in the call path. The below
> commit is part of 5.10.96 So this regression seems to not only affect
> 5.16 series.
>=20
> Link:
> https://github.com/home-assistant/operating-system/issues/1739#issuecomme=
nt-1032013069

Yes, it does appear to affect multiple versions; at least 5.17-rc2,
5.16, 5.15, and as you say 5.10.

I can confirm that this patch addresses it on 5.16:
https://lore.kernel.org/stable/YgJSEEmRDKKG+3lT@mail-itl/T/#t

It appears desirable to apply the patch to all of the stable versions
that need it, after it's gone into Linus's tree to also address the
matter with the upcoming 5.17 series.




--Sig_/.p8=5FGObjCkfRNZclWLeLR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE9hGpCP+hZcaZWE7UnQ2zG1RaMZgFAmICsOkACgkQnQ2zG1Ra
MZjQhRAAsKpXEay/33jSXanEJw6G2RDCU9xDyimKRcos7wYiewuumJhlRKynO2ZB
w5nt+qwF4h9gZ/PCiJpGPDsv56D3ga/riXctEgk1taL7teJVbYbFzPs9UzszYQcs
GhU0uDtrs7WNzNFOY/luT/Ew8MpXayilxbcyYrSCXvKkJIoqsJpd8i6CEkVFAwJm
9OI3umDnHrM1gCPe33vxA+bCmUcNr+BzlByTQJqcTD7FFQOgECBnvfQ2ibYIYXuS
WqK4jajVVwFb2Xky7GFu9C7SlaNaHlUSVf94JKj4vg+/9rrHqTAFeqpznjbPWaCO
rwN6tXWqOT9ALVR99rApaSLJ7Kl1r1K8PtPZpC9jjl2TFIeyZmpfwpSPnlxebdB0
QG34E265KkSKfcwoQQdyUhzJiVB8N5MJBX1Gayf3l+xh2FYByrP6KXOQKB6gCKE0
eKhhesUmb0UynCaHrm0wkyrnVvLEbhb2U32/ozeeepfaecLEc7Jc+Zwx/aQ+J7QH
Jfy7smGiD+zgB9Q4W8MmqmXr3QXAiBpSLXOhk79GZx7lIfPuAj4oyvk1I0+r4VmQ
O3imf7iUhVYnFbZKQA8kkyVs3LWwnV4CCxm5db873MpdGw1iDfl53MKcI3dArRvf
AyNWMr/ZNEh8AiFFQTMh9dB6y+HLH2Qfs82akktIyeHhyG6LsPM=
=r3zt
-----END PGP SIGNATURE-----

--Sig_/.p8=5FGObjCkfRNZclWLeLR--
