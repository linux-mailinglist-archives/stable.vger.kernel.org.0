Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7C0172F33
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 14:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfGXMvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 08:51:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43148 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbfGXMvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 08:51:07 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hqGjX-0007C6-5M; Wed, 24 Jul 2019 13:51:03 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hqGjW-0003X1-VM; Wed, 24 Jul 2019 13:51:02 +0100
Message-ID: <0f96662a082d664137b59c99c35ec53502af0e2f.camel@decadent.org.uk>
Subject: Linux 3.16.71
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc:     lwn@lwn.net
Date:   Wed, 24 Jul 2019 13:51:02 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-0LS3j1Q5BMWzPz041AlG"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-0LS3j1Q5BMWzPz041AlG
Content-Type: multipart/mixed; boundary="=-8KywcB3WfJcNrADA1MEG"


--=-8KywcB3WfJcNrADA1MEG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.16.71 kernel.

All users of the 3.16 kernel series should upgrade.

The updated 3.16.y git tree can be found at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
.git linux-3.16.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.gi=
t

The diff from 3.16.70 is attached to this message.

Ben.

------------

 Makefile        | 2 +-
 kernel/ptrace.c | 4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

Ben Hutchings (1):
      Linux 3.16.71

Jann Horn (1):
      ptrace: Fix ->ptracer_cred handling for PTRACE_TRACEME

--=20
Ben Hutchings
compatible: Gracefully accepts erroneous data from any source



--=-8KywcB3WfJcNrADA1MEG
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.16.71.patch"
Content-Disposition: attachment; filename="linux-3.16.71.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Makefile b/Makefile
index 9e2a3acb26cf..c2c6a3580e8a 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 16
-SUBLEVEL =3D 70
+SUBLEVEL =3D 71
 EXTRAVERSION =3D
 NAME =3D Museum of Fishiegoodies
=20
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 694e650e962d..22beef3e2160 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -80,9 +80,7 @@ void __ptrace_link(struct task_struct *child, struct task=
_struct *new_parent,
  */
 static void ptrace_link(struct task_struct *child, struct task_struct *new=
_parent)
 {
-	rcu_read_lock();
-	__ptrace_link(child, new_parent, __task_cred(new_parent));
-	rcu_read_unlock();
+	__ptrace_link(child, new_parent, current_cred());
 }
=20
 /**
=0D
--=-8KywcB3WfJcNrADA1MEG--

--=-0LS3j1Q5BMWzPz041AlG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl04VDYACgkQ57/I7JWG
EQmotw/+NRhlDG9wBun8zSv+THx66WJRVainNbWWZB5W40DnFr7yiITiuJLmFnay
9I4b+TP3HKzUDz4zy8GJNAxd5b+N0eyfpvTPcVj78fPz1jp9NKMJb9utq2leyzQq
Cg5+I2NycaCLVuf6OowiYsTKgryLVViJ6TJgHsXkfTHdEmZiBWpQ5qk1S6ROm7Sz
TB8n1JxGjGAHp1f/mgz5i3XAjWtDeuCFT3OZjqrnOZ0nUFb37F658MiOcpazPu3p
vWaluFbmgzmXtzqQB14jSxTx1jTtJqXz6XX51kkJ4r9B0rG724aZ+dlb66ngm0He
3s+050vRMqfMkdtn5UShOmCAGFCiS2ntVSv/olYoWHkJ5Vb+BkJyDoVy1KPZxTHD
8eGPxMPzluuEaNaHkosOFK6fxSJv6/0XfCmYuqBpdyNt7YETlNRlwDCAH5xgEU8I
q3CuwEbgaA0BYrOS+Z0X2pmHkTfBrp9icfIxUka1AL3d+UJ3hrPecKSdSJEVXckG
YPyJrhqQQINODWiEwTSFc8FSa85riQvaR0rWDdF6mES9JYOHgmkxEzobJnmzs3gr
7CUg9yn/zz78PKbr8MpzFf1OxgUALlWvpZOfxBMuvQYJOxm9FJApqes4Ta+32JBd
ywK6sm+mkkN+udpk7zN5H9Z4jKo+02IMxsQ6hE9cbxjtf4elTf8=
=GKAq
-----END PGP SIGNATURE-----

--=-0LS3j1Q5BMWzPz041AlG--
