Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273C0227029
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgGTVH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:07:27 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:39206 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgGTVH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 17:07:27 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D94031C0BE2; Mon, 20 Jul 2020 23:07:25 +0200 (CEST)
Date:   Mon, 20 Jul 2020 23:07:22 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 041/133] Revert "usb/ohci-platform: Fix a warning
 when hibernating"
Message-ID: <20200720210722.GA11552@amd>
References: <20200720152803.732195882@linuxfoundation.org>
 <20200720152805.704517976@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <20200720152805.704517976@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!
On Mon 2020-07-20 17:36:28, Greg Kroah-Hartman wrote:
> This reverts commit c83258a757687ffccce37ed73dba56cc6d4b8a1b.
>=20
> Eugeniu Rosca writes:
>=20
> On Thu, Jul 09, 2020 at 09:00:23AM +0200, Eugeniu Rosca wrote:
> >After integrating v4.14.186 commit 5410d158ca2a50 ("usb/ehci-platform:
> >Set PM runtime as active on resume") into downstream v4.14.x, we started
> >to consistently experience below panic [1] on every second s2ram of
> >R-Car H3 Salvator-X Renesas reference board.
> >
> >After some investigations, we concluded the following:
> > - the issue does not exist in vanilla v5.8-rc4+
> > - [bisecting shows that] the panic on v4.14.186 is caused by the lack
> >   of v5.6-rc1 commit 987351e1ea7772 ("phy: core: Add consumer device
> >   link support"). Getting evidence for that is easy. Reverting
> >   987351e1ea7772 in vanilla leads to a similar backtrace [2].
> >
> >Questions:
> > - Backporting 987351e1ea7772 ("phy: core: Add consumer device
> >   link support") to v4.14.187 looks challenging enough, so probably not
> >   worth it. Anybody to contradict this?

I'm not sure about v4.14.187, but backport to v4.19 is quite simple
(just ignore single non-existing file) and passes basic testing.

Would that be better solution for 4.19 and newer?

> > - Assuming no plans to backport the missing mainline commit to v4.14.x,
> >   should the following three v4.14.186 commits be reverted on v4.14.x?
> >   * baef809ea497a4 ("usb/ohci-platform: Fix a warning when hibernating")
> >   * 9f33eff4958885 ("usb/xhci-plat: Set PM runtime as active on resume")
> >   * 5410d158ca2a50 ("usb/ehci-platform: Set PM runtime as active on res=
ume")

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8WB4oACgkQMOfwapXb+vKCXQCgmMJbj/q/X85kLcSkTWrKywOT
7zMAn1rPDePz2FZ2R/tmn5rmAIVw50Bs
=qsSw
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
