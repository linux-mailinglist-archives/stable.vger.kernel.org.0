Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D684E36076A
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 12:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbhDOKq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 06:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231829AbhDOKq3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 06:46:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F34C260C41;
        Thu, 15 Apr 2021 10:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618483566;
        bh=h0XJJdaP0ywje2OV4eoBJiqmYkORX2w+OWwLuXNnQIQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=HhOtkdL26TjwhsGFlSyI7wmbILoWXA42yfKwy9DkXRqff6mYl82EL+8S9fQoWgB2E
         4ZOiDwd+3B/EerCPCNwd9lTfRjMndx5ASyIFbKEbTEkwsy0iuMP6ef+1pJdEOmpBC6
         tDVa5DwoYF5oEmVmD8MV1dM81vquBIeIfrZb/82+gT5KqkNAfHswAbwaH+ZZHqx1Af
         Bgd2PsxvAA7k7Yk6HIaqODkyj4xQuO61P5TmECpS8o014Ez3M5nuOzxdeS9lh11OCq
         OLvijmboZZ/tkUHBh9zluCdnI/oP0H45JroBp/oMquZsBWMm3fPiZnEySuFxcNTtBf
         gvVpDrTf1vQNg==
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: dwc3: gadget: Remove FS bInterval_m1 limitation
In-Reply-To: <5d4139ae89d810eb0a2d8577fb096fc88e87bfab.1618472454.git.Thinh.Nguyen@synopsys.com>
References: <c2049798e1bce3ea38ae59dd17bbffb43e78370c.1618447155.git.Thinh.Nguyen@synopsys.com>
 <5d4139ae89d810eb0a2d8577fb096fc88e87bfab.1618472454.git.Thinh.Nguyen@synopsys.com>
Date:   Thu, 15 Apr 2021 13:45:59 +0300
Message-ID: <87eefbomfs.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:

> The programming guide incorrectly stated that the DCFG.bInterval_m1 must
> be set to 0 when operating in fullspeed. There's no such limitation for
> all IPs. See DWC_usb3x programming guide section 3.2.2.1.
>
> Cc: <stable@vger.kernel.org>
> Fixes: a1679af85b2a ("usb: dwc3: gadget: Fix setting of DEPCFG.bInterval_=
m1")
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

thanks for updating

Acked-by: Felipe Balbi <balbi@kernel.org>

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAmB4GWcRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQbZ0w/9GNXw9VAS1OAN0I/At2oen9+YwdC0iirF
jshGh5/B4n4eU8QSSpy97E0ZItT6WCnJbxVB0Bzr26gSRsGr2GJainCae+Ek0uPg
Y7W0wHAFLSzRI6/5+PdLCknzfo29Bgh4GkkJtaaf4auZEhwvPzP7l5LWbKyftNBB
wx+RMssr734Hz/xC+hdQS23oRLt1tB8D28iOYWTaSFyq8D5OofwiYlR7dEFjqsZ1
/WLhMll2Cz935h++d9lF8ZEvWKXIdNklx3Yf+quJEaFI0HnCBBihAT69sjRWTYiY
O1IEmaN/ArUPxsJG3w/zX5pPrfzPvJb7PO8z1tHoHHwQiH4Y1yxW3lFoaDwASpsT
Z3rCX4f5eWl4UNPnreQRbZQEp2DBeynPjIG35qcYtPCuGK+eLeehNcoNqYtReYdN
CWtKbK8wx56dwLoE1qLdhFmI4RFfxcHQqgPBnmLDBSLVmF0xyok0QIb5KU7eSedS
HWvwQvRMPBkKc2pP3wIzFz72v+tHCVIWrOfSbSlStyYOCYcpbM2fj4dcP98rlGcz
Jxw7WPY3rUYBJWbls4z0Fs7Nm0vlbeJ/Dl024bMYYe0saeOxhl70WULkjPuWm2uS
Gzofd7cLrYE2qWB2iV+AXNgYkDAtdRPppxWgtPp4AdsOyH98fzYTDab5SV1uI8FS
5hjGmX1hwv0=
=7ymC
-----END PGP SIGNATURE-----
--=-=-=--
