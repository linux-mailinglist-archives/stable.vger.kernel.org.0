Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54FE31027FB
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 16:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfKSPXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 10:23:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46242 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726637AbfKSPXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 10:23:41 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iX5Lt-0007Sx-88; Tue, 19 Nov 2019 15:23:37 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iX5Ls-0006Si-Ru; Tue, 19 Nov 2019 15:23:36 +0000
Message-ID: <2962b899411bcb9c1463310dd3d5eda733bf4b63.camel@decadent.org.uk>
Subject: Re: [PATCH AUTOSEL 4.20 072/117] btrfs: alloc_chunk: fix more DUP
 stripe size handling
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        Sasha Levin <sashal@kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date:   Tue, 19 Nov 2019 15:23:31 +0000
In-Reply-To: <84061712-32b6-35b7-eb1f-27eb9f85fd11@mendix.com>
References: <20190108192628.121270-1-sashal@kernel.org>
         <20190108192628.121270-72-sashal@kernel.org>
         <783ccf1f-65df-d388-079c-9449d4319c27@mendix.com>
         <20190123143732.GL202535@sasha-vm>
         <cb62ab8d-7d6f-de02-2912-3d9391a2bbb2@mendix.com>
         <20190123181805.GM202535@sasha-vm>
         <84061712-32b6-35b7-eb1f-27eb9f85fd11@mendix.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-kMH/KTWFcu9xkthxoQQ2"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-kMH/KTWFcu9xkthxoQQ2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-01-23 at 19:32 +0000, Hans van Kranenburg wrote:
[...]
> For 3.16.y it also first needs a little part of b8b93addde from David
> Sterba, which is a collection of coding style changes in quite some
> places. After that 793ff2c88c6 and then baf92114c7 apply cleanly, only
> touch that single part of the code and end up with the right thing.
>=20
> I attached 3.16.y-WIP-partially-apply-b8b93addde.patch as quick and
> dirty example, please let me know how this should be done properly.
>=20
> For 4.4, 4.9 and 4.14, first 793ff2c88c6 and then baf92114c7 indeed also
> end up with the right thing. I just tried that here.

I've belatedly queued up the required changes for 3.16, thanks.

Ben.

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice - John Levine



--=-kMH/KTWFcu9xkthxoQQ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3UCPMACgkQ57/I7JWG
EQkRexAAvNvLIEUL5XuEtxfH//0tW9T2ku6MYy5ONh8XvltoGrI8hy4FOCYmiGXp
EZLobTTjCDlQfk4cyj4Ep8e04yv3/0ZSCKnTYgRQgwB5qZanB5fo3c6OMH49UiqL
nih34ht8AW+JOZAPvr285zSrlp/8Ooi7NtRU9gvdTDO9mqU2k8nJxRjOTMm2Y2AL
17NTuHcxJJYh4+BNWgtn6L+1hOEV9K0PzFLuys+nWiTnZcDN39EF78kFCuCgWHfA
pRobX1PuuJoFnOisVnNH4rSAGKHAR2mgj/ke34qy3hhYL59MUmAKjg8kyVHUhl6Q
CxyqQmPf4Ryag9re+8zK7g+IB096OcoT5arKxLyffiCSwaIpXSYqdHa0GaMdpSRS
nvhe4iZFm+Ie6res16o0x5wj9UC0tOk+CwvzgUqHc9UxrL0zJoL1rGmb5ezzAKU+
4WhODiFhJP1bXairgknahxRqCtKEOCrdCdb1LbGZmPLdgtsxX5L6IbYxFEE9WQBN
Ac/ys+vjIEOfhPDgrUcX2lu+sSr9NFX+3tZuDQOLwYUCPPsdypWmNsCJyz/Snxb1
jWB98nZPVGvvQuG1qursHEH9JM1yCeQjIyjt6BGLDBLApX8N3ncNQnjECyLYFnnM
5K0/IzpiFfuNvYHCw6EjuPS/pO7hnu08Ree4Ty9iZlVvvIXywR0=
=LWIb
-----END PGP SIGNATURE-----

--=-kMH/KTWFcu9xkthxoQQ2--
