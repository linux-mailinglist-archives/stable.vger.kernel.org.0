Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA401E1890
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 02:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgEZAuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 20:50:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:44536 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgEZAuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 May 2020 20:50:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7A4ABACF9;
        Tue, 26 May 2020 00:50:38 +0000 (UTC)
From:   NeilBrown <neilb@suse.de>
To:     Sasha Levin <sashal@kernel.org>, Sasha Levin <sashal@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>
Date:   Tue, 26 May 2020 10:50:28 +1000
Cc:     linux-nfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] sunrpc: clean up properly in gss_mech_unregister()
In-Reply-To: <20200526002354.9717F20706@mail.kernel.org>
References: <159011289300.29107.18158467549734203675.stgit@noble> <20200526002354.9717F20706@mail.kernel.org>
Message-ID: <87h7w38qp7.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, May 26 2020, Sasha Levin wrote:

> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: 2.6.=
12+
>
> The bot has tested the following trees: v5.6.14, v5.4.42, v4.19.124, v4.1=
4.181, v4.9.224, v4.4.224.
>
> v5.6.14: Build OK!
> v5.4.42: Build OK!
> v4.19.124: Build OK!
> v4.14.181: Build OK!
> v4.9.224: Build OK!
> v4.4.224: Failed to apply! Possible dependencies:
>     302d3deb2068 ("xprtrdma: Prevent inline overflow")
>     65b80179f9b8 ("xprtrdma: No direct data placement with krb5i and krb5=
p")
>     94f58c58c0b4 ("xprtrdma: Allow Read list and Reply chunk simultaneous=
ly")
>     cce6deeb56aa ("xprtrdma: Avoid using Write list for small NFS READ re=
quests")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

The conflict is trivial - this patch adds a field (domain) to 'struct pf_de=
sc"
which at the time didn't have an expected field (datatouch).
You can merge it manually or ask me when the time comes and I'll provide
a backport.
(65b80179f9b8 is the textual dependency, but it is no a semantic
dependency).

NeilBrown


>
> --=20
> Thanks
> Sasha

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl7MZ9QACgkQOeye3VZi
gbkc6w//Yposwa91CI/f19ju2RmVFvTW3CtVRnOleIM6ikaLP3yINaFNIfcOHtvr
g6j3dGVZ+LW0mFDuvUgGCrUiME/lZdIlqJKUM3Ja52z37DynpV2AxTZLcFRllhAL
adszJbWCJs75mteou/FokyDAR7FeXpnxPg8A/rL7J7NU6s7eCocRKSxxZQeqJr2G
w8wATKVtefG8X+GqFxtoJCcqSXevOeHZvgYUE7NxhWo6v7hHNvgI1kbuAT4eEWac
HVLjIUtxSOGvnz4UgnSJj26kB9TcY5zvVD/PWZ01Iac8xx72/8b16IBK/Ga+jfal
Qac/pLg4nWy19FBV8QBPQBZlL1PxRtfh0GZxemosVw+DSA7A+BtTZxoGkY0eEHG3
mOnQzCZ9HM4PzLkptPy2oxDHz9M/FS/N6QqX4NyBuxBxSVCOncD0Xjv0T5e449+5
dYWKTaiH2I6Ztq8ideBONP1nuQK+WY8gmk63tMKKGi2QQt8xfdoCQRnj/DL7Kd89
BqVLQQqB60a6cKB3mkTfeSB8vMO6WvHam6waOAuzxDJ2D476Fzx9zYg58M26IFtZ
8lwQhhnhseq+ULgqukp54BiwWP/Frc5ZyeC49hkxfvtX+Myxw05uYCK4/TMUJgOY
8vlbo/pqgrDaVrbRlGlTXivob94nSOtS731ddESZQ7bZnu2THsk=
=Zwc7
-----END PGP SIGNATURE-----
--=-=-=--
