Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B2E212720
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 16:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbgGBOzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 10:55:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35340 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728179AbgGBOzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 10:55:16 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jr0cL-00041y-B2; Thu, 02 Jul 2020 15:55:13 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jr0cK-000K4u-Tu; Thu, 02 Jul 2020 15:55:12 +0100
Message-ID: <514c425e2b4dca71a11b0c669746d3122f7039a5.camel@decadent.org.uk>
Subject: 3.16 EOL
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Denis Grigorev <d.grigorev@omprussia.ru>, stable@vger.kernel.org
Date:   Thu, 02 Jul 2020 15:55:04 +0100
In-Reply-To: <20200702073919.GG1073011@kroah.com>
References: <20200630153641.21004-1-d.grigorev@omprussia.ru>
         <1bf72bc1ace92609fec953daf17342e1d2d48394.camel@decadent.org.uk>
         <20200702073919.GG1073011@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-zXRV5HqilW7nSufmqUZv"
User-Agent: Evolution 3.36.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-zXRV5HqilW7nSufmqUZv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2020-07-02 at 09:39 +0200, Greg KH wrote:
> On Thu, Jul 02, 2020 at 12:31:01AM +0100, Ben Hutchings wrote:
> > On Tue, 2020-06-30 at 18:36 +0300, Denis Grigorev wrote:
> > > This series of commits fixes a problem with closing l2cap connection
> > > if socket has unACKed frames. Due an to an infinite loop in l2cap_wai=
t_ack
> > > the userspace process gets stuck in close() and then the kernel crash=
es
> > > with the following report:
> > >=20
> > > Call trace:
> > > [<ffffffc000ace0b4>] l2cap_do_send+0x2c/0xec
> > > [<ffffffc000acf5f8>] l2cap_send_sframe+0x178/0x260
> > > [<ffffffc000acf740>] l2cap_send_rr_or_rnr+0x60/0x84
> > > [<ffffffc000acf980>] l2cap_ack_timeout+0x60/0xac
> > > [<ffffffc0000b35b8>] process_one_work+0x140/0x384
> > > [<ffffffc0000b393c>] worker_thread+0x140/0x4e4
> > > [<ffffffc0000b8c48>] kthread+0xdc/0xf0
> > >=20
> > > All kernels below v4.3 are affected.
> > [...]
> >=20
> > Thanks for your work, but I'm afraid the 3.16-stable branch is no
> > longer being maintained (as of today).
>=20
> Want me to mark it EOL and remove it from the release table on
> kernel.org now?

I was about to send that patch myself, but you're welcome to do so.

Thanks again for all your assistance with releasing updates for 3.2 and
3.16 over the past 8 years.

Ben.

--=20
Ben Hutchings
It is a miracle that curiosity survives formal education.
                                                      - Albert Einstein



--=-zXRV5HqilW7nSufmqUZv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl799UkACgkQ57/I7JWG
EQlh4RAAq/lYEGqGHCjBB1d2fJdPyu38WuTaGhM9OkyZXCZLAmqleOP7gnLAq6E6
+Xg2BFDpugOGa5vFnxWLIXE7YE8VBHHfYlZWPpMcmxE47AaMwZCCOVdyJ1/jjorw
EeeMjzXUtx268tyc6vOfgm5mEULl/8ev+eLXAY61dP1kmSgNkcEYsDXddM3/dE2r
bQs67bYqhD8ClX3QRy5+qcai2KRK1vSM6EWlEGkzXGk5uYiXil4r/xp+CgOgfPXX
xswBjH3JnH+eVEv36KDz1eJT1lhhyOmyMSEDcy0cYTQRGLhlyOjlsojy5HAp2Zgj
dXPq55tTrYdTMFo6wIGh/VsWUxRbIefbJGbizmM+XvIaS/xmq/iJAkf7HDtTVO7o
ytX/4YrHeqOoKBCukW4M9vsv6EoyaW6FTGCBOHw0thigwxvm+TyTkO3koyr/d4UC
4R4kECX67iqFIuNjDESKUx8G2K3k3BLoqsAcptePT3x5pSxgtLyiQzZOxKidG09y
CRFRXFFKlCuediL55Rx93SpfsUUVD6Pp+G6XktPoLVBooXNf/8+S0/JRrMcuzro1
O0i0l6iwZKuhmxEc8Bh53iCW0SWIcScOmkn2g/CP8hHBOFsbOj0EjaOsac4ku1KD
OnTNnFm84gZc/D6NfgOivGe1pRzKRUot5KAO96desh8I524rTBI=
=45vz
-----END PGP SIGNATURE-----

--=-zXRV5HqilW7nSufmqUZv--
