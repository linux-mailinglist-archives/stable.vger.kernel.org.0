Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97064B04FF
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 22:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbfIKUsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 16:48:47 -0400
Received: from anholt.net ([50.246.234.109]:39966 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729327AbfIKUsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 16:48:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by anholt.net (Postfix) with ESMTP id B20CF10A37A2;
        Wed, 11 Sep 2019 13:48:46 -0700 (PDT)
X-Virus-Scanned: Debian amavisd-new at anholt.net
Received: from anholt.net ([127.0.0.1])
        by localhost (kingsolver.anholt.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id QFhPKD3VB0id; Wed, 11 Sep 2019 13:48:45 -0700 (PDT)
Received: from eliezer.anholt.net (localhost [127.0.0.1])
        by anholt.net (Postfix) with ESMTP id 70C5D10A379E;
        Wed, 11 Sep 2019 13:48:45 -0700 (PDT)
Received: by eliezer.anholt.net (Postfix, from userid 1000)
        id A112E2FE2E27; Wed, 11 Sep 2019 13:48:46 -0700 (PDT)
From:   Eric Anholt <eric@anholt.net>
To:     Stefan Wahren <wahrenst@gmx.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        boris.brezillon@bootlin.com
Cc:     bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, Stefan Wahren <wahrenst@gmx.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH] Revert "ARM: bcm283x: Switch V3D over to using the PM driver instead of firmware."
In-Reply-To: <1567957493-4567-1-git-send-email-wahrenst@gmx.net>
References: <1567957493-4567-1-git-send-email-wahrenst@gmx.net>
User-Agent: Notmuch/0.22.2+1~gb0bcfaa (http://notmuchmail.org) Emacs/26.1 (x86_64-pc-linux-gnu)
Date:   Wed, 11 Sep 2019 13:48:46 -0700
Message-ID: <87ftl2lftd.fsf@anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain

Stefan Wahren <wahrenst@gmx.net> writes:

> Since release of the new BCM2835 PM driver there has been several reports
> of V3D probing issues. This is caused by timeouts during powering-up the
> GRAFX PM domain:
>
>   bcm2835-power: Timeout waiting for grafx power OK
>
> I was able to reproduce this reliable on my Raspberry Pi 3B+ after setting
> force_turbo=1 in the firmware configuration. Since there are no issues
> using the firmware PM driver with the same setup, there must be an issue
> in the BCM2835 PM driver.
>
> Unfortunately there hasn't been much progress in identifying the root cause
> since June (mostly in the lack of documentation), so i decided to switch
> back until the issue in the BCM2835 PM driver is fixed.
>
> Link: https://github.com/raspberrypi/linux/issues/3046
> Fixes: e1dc2b2e1bef (" ARM: bcm283x: Switch V3D over to using the PM driver instead of firmware.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>

Acked-by: Eric Anholt <eric@anholt.net>

I wish someone with firmware source had the time to look into why using
open source drivers to drive this hardware was failing, but I don't have
that time or code any more.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAl15Xa4ACgkQtdYpNtH8
nui29hAAghQUxmPKCpEEJiONuOiuIC7ozMT9p5wZ2f3fdWyJdDFBBLGldPea7SgA
mjNWZ2dk4yUEY2BFKVjoeMCCs3KMdiuqzi+6kkAaK21zflRA1A65Vw65/tfyvzdw
iKL24+/dAH9A0k+UcZZ5ujptijaOCdnxif1lc4+hyADe1Oxw5E8Be8d9GvadZwaU
mOG+16Sf0U3OcbGOvfPndIrHeKHgDpVN+U0MNUlEx1HMh7yfXT0QtK7iSwabjWZF
FJ27WGqPaEo3+LMGCOSj5TEA72B08oEvl0nbl562dFWT6mau3R9DiCEZcWNODMhZ
YAZ+fxJR3MeHsr8KdxH1p6Z9eDNCxaa9LOz6+Tmn5SEUlaMdiNFi84FjMgct9JoK
3O1h8tzijpjvifSvwa1r4jVNMi3y+8vIZ+RTyGCTB9yoye0Hs+zJgtSu3vbjs6Nz
Scd3TjCslZBPlm7TpSAFCyIowuMOGmWASq0eoOxRBMGTQYPLorqR+llenYOCbtEC
l9Vx3WdoPgH2Zd+Hof9Jn7ZDwDrtyFXkOsFwSmoRkVzPTH9u108rTX8+AkyxDybt
CvhnFGxUg2cOTTTIUoDYFpxQN7bTzjIqq7iu5iVQlXzq9js5/TovcdA6jO9u5B4N
2fVQGEGrfJeWZM0ICoVDaILnEHdASZYD/s3nbIq4/Jkrmu40MMc=
=vNM5
-----END PGP SIGNATURE-----
--=-=-=--
