Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A115F4BAB55
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 21:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243344AbiBQU4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 15:56:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240200AbiBQU4I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 15:56:08 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A4F606E5;
        Thu, 17 Feb 2022 12:55:52 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E819C1C0B7F; Thu, 17 Feb 2022 21:55:50 +0100 (CET)
Date:   Thu, 17 Feb 2022 21:55:50 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz
Subject: Re: Linux 4.4.302
Message-ID: <20220217205550.GA21004@duo.ucw.cz>
References: <1643877137240249@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <1643877137240249@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I'm announcing the release of the 4.4.302 kernel.
>=20
> This kernel branch is now END-OF-LIFE.  It will not be getting any more
> updates from the kernel stable team, and will most likely quickly become
> insecure and out-of-date.  Do not use it anymore unless you really know
> what you are doing.
>=20
> Note, the CIP project at https://www.cip-project.org/ is considering to
> maintain the 4.4 branch in a limited capability going forward.  If you
> really need to use this kernel version, please contact them.

Yes, please; feel free to contact us.

Greg, we'll likely keep maintaining "stable 4.4.X" separately from
"stable + changes for cip hardware, aka 4.4.X-cipY". Would it be okay
if we simply kept tagging those kernels as 4.4.303 / 4.4.304 / ...?

CIP project is committed to maintain 4.4.x kernel till January of 2027
[1]. We are maintaining -cip branch [2], that is stable kernel with about
1000 of patches to support our reference hardware [3] and -cip-rt
branch, with is merge of -rt and -cip trees.

If you for some reason need 4.4.x with bug and security fixes, and are
running similar hardware to our reference hardware (x86-64 and armv7),
-cip tree may be good base for that work. Testing of the -cip tree is
welcome, as is joining the CIP project.

[1] https://wiki.linuxfoundation.org/civilinfrastructureplatform/start
[2] https://git.kernel.org/pub/scm/linux/kernel/git/cip/linux-cip.git/log/?=
h=3Dlinux-4.4.y-cip-rt
[3] https://wiki.linuxfoundation.org/civilinfrastructureplatform/ciptesting=
/cipreferencehardware

?

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYg62VgAKCRAw5/Bqldv6
8svPAJ9oyTmXmVpzTa4Y3RErN1DL0drAOwCeIqGtwfW2Z/Q+CKWknCN1cxQ3PKI=
=npnk
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
