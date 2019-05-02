Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8866312071
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 18:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfEBQns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 12:43:48 -0400
Received: from sauhun.de ([88.99.104.3]:55814 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726572AbfEBQns (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 12:43:48 -0400
Received: from localhost (p5486CF77.dip0.t-ipconnect.de [84.134.207.119])
        by pokefinder.org (Postfix) with ESMTPSA id 7078E2CF690;
        Thu,  2 May 2019 18:43:46 +0200 (CEST)
Date:   Thu, 2 May 2019 18:43:46 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc:     linux-i2c@vger.kernel.org, Keijo Vaara <ferdasyn@rocketmail.com>,
        linux-input@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] i2c: Prevent runtime suspend of adapter when Host Notify
 is required
Message-ID: <20190502164346.GE11535@kunai>
References: <20190430142322.15013-1-jarkko.nikula@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lkTb+7nhmha7W+c3"
Content-Disposition: inline
In-Reply-To: <20190430142322.15013-1-jarkko.nikula@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--lkTb+7nhmha7W+c3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 30, 2019 at 05:23:22PM +0300, Jarkko Nikula wrote:
> Multiple users have reported their Synaptics touchpad has stopped
> working between v4.20.1 and v4.20.2 when using SMBus interface.
>=20
> The culprit for this appeared to be commit c5eb1190074c ("PCI / PM: Allow
> runtime PM without callback functions") that fixed the runtime PM for
> i2c-i801 SMBus adapter. Those Synaptics touchpad are using i2c-i801
> for SMBus communication and testing showed they are able to get back
> working by preventing the runtime suspend of adapter.
>=20
> Normally when i2c-i801 SMBus adapter transmits with the client it resumes
> before operation and autosuspends after.
>=20
> However, if client requires SMBus Host Notify protocol, what those
> Synaptics touchpads do, then the host adapter must not go to runtime
> suspend since then it cannot process incoming SMBus Host Notify commands
> the client may send.
>=20
> Fix this by keeping I2C/SMBus adapter active in case client requires
> Host Notify.
>=20
> Reported-by: Keijo Vaara <ferdasyn@rocketmail.com>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D203297
> Fixes: c5eb1190074c ("PCI / PM: Allow runtime PM without callback functio=
ns")
> Cc: stable@vger.kernel.org # v4.20+
> Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>

Applied to for-current-fixed, thanks!


--lkTb+7nhmha7W+c3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlzLHkIACgkQFA3kzBSg
KbapUw/9HnAdtGdXtSUvcCCDZyaj63rtRr7jniT8OaAnIjxxSc0xYa8lH5ZnXbSy
igBMbL7aluqtHG3T3RkiNdAaT2FIs4le5jWfH7ypxBz2nr8XlUuSayA/ogrSm1XU
uhLKNoPamnouY90dpuvu8wUej8WS9sSPHVayu1AYKYTDOnVYwl3cqPnmQw7DzdWg
SXJZ7MyfpzTm0S9QBUtzWFkFaty2DtyuWwf7rDo18crnJo+DqslztO1By81Xc41p
GFScFOBvHXdyY38eHMrDo851sns2WHPeoTox3x3Un0oXHEYg1m67urD1+xK13oOf
AETuz8kwfeXc/z1hrsv4b9jCKFgYUOXStOc4o/Ig6R6R9Y2rEJi141hLoVEBhv0x
y2jDsB4RCbsF5pTcJ+L98QCEb1XihELU3VoYvx2HwpgIgbqh/0OgQpqwof2XSMyd
97XrZf9rCAMLeOyElPat5j7EUPPsw1o2ebf2921lJYfTDjIQyp8pRsLcH967zX4d
sjtcmRACBgDqdMF/DsShHr25mTJtEg47dvoUWLx98uDj2ryDMdkZmgMhVooAs21t
fjE/oJ8jTZURPiMoHhs6rEx0FgoUN0KgpOf5rMMY92SzB5NdnCdHVteZuIklgQZw
52S/MxLZpMPWxPfw7qtWWssSdd1+qIKHn0fCAsMZIoNLgBJGDN4=
=m1ON
-----END PGP SIGNATURE-----

--lkTb+7nhmha7W+c3--
