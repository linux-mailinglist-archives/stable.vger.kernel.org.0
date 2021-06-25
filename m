Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480BA3B4390
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 14:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhFYMte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 08:49:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhFYMte (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Jun 2021 08:49:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FB9F6193A;
        Fri, 25 Jun 2021 12:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624625233;
        bh=FZXUHyZcqitdVOml9HZSNoGP/q8GXo+kGnotZDKbLXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oSsGIO04ccCFmvGOAgXV0swJgneYwHG/RhrQqKhlfZUv1sU4MK4wFTnrNds65puCG
         jzNRVnuuxUOJB1xmyUjF/25/mcW0Mvoo1IgbJkzqQs+x7UEPxdlM1HdOXw0bQ3i8I5
         zgb7L0ANXIlgfGoTbc6eiBr8rMBc0sqG5nV+KHcecYLDY7cCQzgmtkRXVaKJhtirOg
         2wxY2rXNBJMQLhEtZ8R8djrZpmPt0vzoVOom3vLsI30tnqDhyRMAu2IFY9EzKlBNCF
         VYQQ+rI8+tv/onquAV/D3zGRc9VSCoaKe2PkD3JUeuKqgBsQmyM35GDX/qf6q3cBgs
         hWfanb8Kj/SWg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lwlEo-0000Ec-CS; Fri, 25 Jun 2021 14:47:14 +0200
Date:   Fri, 25 Jun 2021 14:47:14 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Wolfram Sang <wsa@kernel.org>
Cc:     linux-i2c@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+9d7dadd15b8819d73f41@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] i2c: robotfuzz-osif: fix control-request directions
Message-ID: <YNXQUkaGOyg4AN2G@hovoldconsulting.com>
References: <20210524090912.3989-1-johan@kernel.org>
 <YNL2NLSpBQqnc2bH@hovoldconsulting.com>
 <YNTmqcrYb9KzW8Zh@kunai>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wLtWFzcEsnVb05WS"
Content-Disposition: inline
In-Reply-To: <YNTmqcrYb9KzW8Zh@kunai>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wLtWFzcEsnVb05WS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 24, 2021 at 10:10:17PM +0200, Wolfram Sang wrote:

> Sorry, I thought Andrew was the maintainer of this driver and was
> waiting for his ack. But he is not, this driver is unmaintained. So, I
> trust you and picked it up now.
>=20
> Applied to for-current, thanks!

Perfect, thanks!

Johan

--wLtWFzcEsnVb05WS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQQHbPq+cpGvN/peuzMLxc3C7H1lCAUCYNXQTQAKCRALxc3C7H1l
CKGVAQCPI0qfCKxYhHx64ZOYAW3DDrzFhJIMXSUY0zzG0wjp3gEAu/5kmoaimUsX
7DUTKIKtgcwrDMJ2P4ugizbEzPWCuAE=
=x5Za
-----END PGP SIGNATURE-----

--wLtWFzcEsnVb05WS--
