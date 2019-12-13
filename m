Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1414611E0DE
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 10:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfLMJfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 04:35:04 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:57596 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbfLMJfE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 04:35:04 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4A6B61C246E; Fri, 13 Dec 2019 10:35:02 +0100 (CET)
Date:   Fri, 13 Dec 2019 10:35:01 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 099/243] usb: dwc3: debugfs: Properly print/set link
 state for HS
Message-ID: <20191213093501.GA27976@amd>
References: <20191211150339.185439726@linuxfoundation.org>
 <20191211150345.799359877@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <20191211150345.799359877@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2019-12-11 16:04:21, Greg Kroah-Hartman wrote:
> From: Thinh Nguyen <thinh.nguyen@synopsys.com>
>=20
> [ Upstream commit 0d36dede457873404becd7c9cb9d0f2bcfd0dcd9 ]
>=20
> Highspeed device and below has different state names than superspeed and
> higher. Add proper checks and printouts of link states for highspeed and
> below.

This is debugfs, so I don't believe it was suitable for stable in the
first place, but....


> +	case DWC3_LINK_STATE_RESUME:
> +		return "Resume";
> +	default:
> +		return "UNKNOWN link state\n";
> +	}

You may want to delete \n here, it will be duplicated if this ever
triggers.

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3zW0UACgkQMOfwapXb+vICpQCfQHzNyEi8pbT+Xw6OnRhG7h07
jKIAnjd/cwx9RAtSs75/JPIETKGhNhwn
=D5ZS
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
