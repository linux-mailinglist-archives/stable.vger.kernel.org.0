Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D468AA8E3
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbfIEQYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:24:43 -0400
Received: from sauhun.de ([88.99.104.3]:58922 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728815AbfIEQYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Sep 2019 12:24:43 -0400
Received: from localhost (p54B335F6.dip0.t-ipconnect.de [84.179.53.246])
        by pokefinder.org (Postfix) with ESMTPSA id 835902C00C0;
        Thu,  5 Sep 2019 18:24:40 +0200 (CEST)
Date:   Thu, 5 Sep 2019 18:24:40 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     stable@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: Re: [BACKPORT 4.14.y 00/18] Backport candidate from TI 4.14 product
 kernel
Message-ID: <20190905162440.GB3695@kunai>
References: <20190905161759.28036-1-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mojUlQ0s9EVzWg2t"
Content-Disposition: inline
In-Reply-To: <20190905161759.28036-1-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mojUlQ0s9EVzWg2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 05, 2019 at 10:17:41AM -0600, Mathieu Poirier wrote:
> These patches are backport candidates picked out of TI's 4.14.y tree [1],
> with most of them already found in the 4.19.y stable tree.

Could you please update your scripting that only the cover-letter and
I2C related patches will be sent to the I2C mailing list?


--mojUlQ0s9EVzWg2t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl1xNscACgkQFA3kzBSg
KbbSXA//Qr7qcTKeYW+0LEBOI7jVtHAd2WvUvM5Dd4cDxWi9xFJLp3mq9RHpUp2n
C+TcMxlcW7slL8ffeERAPOV3hF+IOWkWiMg+9VUHgK2MvWf+fd3wcmBC/8Cn4DQ3
B8582lHxQQcVy6jYAvgxkojUFDRrVNS0nSb0Vfb8am062q1DIkiilFqdNPNFoGWy
UMV6JnawALcKyWVHftb8p66KvJ0SRMNdm36It3CDQhr4ZBRnuLkZD5HN0QKljKYp
0iFy2yoJnsnTZKmtuEetjVNM01avU8wE0CY9gUb3Oi0xQUfPkqOgQ3WtmeolsOLQ
PriFq6j8Xt4knqOjVhkyPFpfm1uedxeqNF8uUtRL+r0Fm7ytDTwsGashc7so4D0O
s1oOEKDeYT6EOVBVC/4oxYJmIeRk6PX8qeyt6+7dz4MEkfrR+yWr10zOFr7wX6Bh
xmDd5nGeWLVCUnRWaXmph+QTjUlmsP/bKDuTtpkVSuM5X5y62NYpZ7WqsQV2Hob9
NsYPtS4xag5ak71KlvQRVpqaK8Lzgna0qHrXrk9gynDOYpoN+bUsBf+JNfRCKCOa
RO1DDv2S35m+mFLoS5Ddxo/j2urW36sfuLuUmdGcR3oxovCNcgUyG+CRIDJTwnFn
HVVbHqEnxF7f+gw6CiKqAdhye4IWXYWxYbK4hKWi540R8iLVI6g=
=3bwX
-----END PGP SIGNATURE-----

--mojUlQ0s9EVzWg2t--
