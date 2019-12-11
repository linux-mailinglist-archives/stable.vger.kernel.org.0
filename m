Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE20D11BFC1
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 23:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfLKWZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 17:25:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58338 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726345AbfLKWZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 17:25:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ifAQO-0008Ev-F5; Wed, 11 Dec 2019 22:25:40 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ifAQO-0000Ph-2w; Wed, 11 Dec 2019 22:25:40 +0000
Message-ID: <6be50392b6128f7cd654c342dc6157a97ccb3d8d.camel@decadent.org.uk>
Subject: [stable] KVM: x86: fix out-of-bounds write in
 KVM_GET_EMULATED_CPUID (CVE-2019-19332)
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 11 Dec 2019 22:25:34 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-PatrCYJ+8KhVglHuyvPY"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-PatrCYJ+8KhVglHuyvPY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pick:

commit 433f4ba1904100da65a311033f17a9bf586b287e
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed Dec 4 10:28:54 2019 +0100

    KVM: x86: fix out-of-bounds write in KVM_GET_EMULATED_CPUID (CVE-2019-1=
9332)

for all stable branches.

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                       - Robert Coveyou



--=-PatrCYJ+8KhVglHuyvPY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3xbN4ACgkQ57/I7JWG
EQleSRAAmpKsAv7IXknS+rglJZZckHPhM7TRzejCzsDZWxtUnqwP1oc4Y8FEke3p
UvBpXklsTKrVEbZSB30PMSJEENLWx6L5o3fOPtfSgV9xwIlVjxBxzElnDc/jx39B
yYaBmqhuSGT1hxV2z0sF5TmwMbauyDbA5+Dpb1XdJ5KhPYuKBDr805IdGfZ9eIye
w/sw6dnPvpoySZ8wiOZYO8cgPhXdHVbZxWnLNPsaZOx7IkdtpdmfeOCUQZs8VXhD
KA+EecdfJEem7QPMVemN5TpfQpRhX3TuHnB3P8w8/V37LPSuVxG7zltaMwAZu9DV
aTcPusxwce7dM2ATaTHUX0I8pEaIYZxNudqOwTjpG09fwUCIAajCBY/Zs+Ba6aLt
X/47m2GLdAyIrKMdSAlrXYhYBFOl65Y4/KCncOBo5R9QYYaW4A45z95aeSbPaXCf
WB+kCryBJIJRvwWHaMcGEpzOqVUdEwOFs5KyArg0Y8hYEajyJq7IVO1FsyhSG7Fd
Sysg87QXhGg/S+WXWeIzGMhzuRNGIGu2gDkr4mFB4b3AP11dP1e9+a88T+xep//I
gtnvMEWSFuJcTZIU+t9bEjrRqzeAGKqOmHmRSBdp4dzBdXuY/XpTAE60X17O/9za
ejwhsiLXuRlKzkmxuLOIG3QMsOcHsfT7S8kRGyEt0E9sS7AeUVw=
=zlPe
-----END PGP SIGNATURE-----

--=-PatrCYJ+8KhVglHuyvPY--
