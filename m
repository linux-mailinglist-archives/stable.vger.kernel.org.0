Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1374424FD74
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 14:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgHXMHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 08:07:42 -0400
Received: from www.zeus03.de ([194.117.254.33]:42514 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgHXMHl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 08:07:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=FdR4jm5F5Z57/fNoP7GbP3o8BTe0
        1SeGyFzr5uf+Mjc=; b=2x55aK2z+U98UaGg0Qz0QZq2rgYhAt60zNi3Br6OvhWo
        etczisSRyJJ3G6jpG40qxnu7dTTPS5wqPh3YAfrPqi6cbI+rTOfp81pCylJF5YqM
        uQ/wDtmQHKfIGsQroTAGiDIBtOWpV8asDAZYug1WBBspXLMkqP34SVZ2kcl9/NU=
Received: (qmail 1869772 invoked from network); 24 Aug 2020 14:07:38 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 24 Aug 2020 14:07:38 +0200
X-UD-Smtp-Session: l3s3148p1@3jPJbp6tvIAgAwDPXwQSAE8ZH2VjqKES
Date:   Mon, 24 Aug 2020 14:07:35 +0200
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Eugeniu Rosca <erosca@de.adit-jv.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Eugeniu Rosca <roscaeugeniu@gmail.com>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Andy Lowe <andy_lowe@mentor.com>
Subject: Re: [PATCH] i2c: i2c-rcar: Auto select RESET_CONTROLLER
Message-ID: <20200824120734.GA2500@ninjato>
References: <20200824062623.9346-1-erosca@de.adit-jv.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <20200824062623.9346-1-erosca@de.adit-jv.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> +	select RESET_CONTROLLER

Only needed for Gen3, so 'if ARCH_RCAR_GEN3'?


--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl9DrYMACgkQFA3kzBSg
KbbSZQ/+PhuTLW6kqCSCd55WdUymNIJPFUzPNEyQa59oRhx0DHZsP+KfEVlV/zug
vhM8gpwTWCenzuydgeV2f1tFI4lVYKNF3ER1ukl5hQI9QTjKarodaEnC3i40D5vN
8JW1hIPl0KD1R/5mSr7/D7qEAZxPenNkmsrjN85pMz0BhYP4lV8If4pxf3BBPWqO
kG27YT/jt4mfAeAEabP9iEJobaJaPEiZ7YPfkH53a/bttg1JZW+60BNfh4D9nD7+
FwbfjyJ5dj6K3xdmpffs4hFqavKq/xO3drIvf+ALQ5AqD4i55YRWGpJai93VVtiu
45t7guU1HCPcxIPphJCBSHODV0xuOoEcWOuvpelnd/+dJyeYZ4u0rsu8EEEdJpKt
8tJSTqruY7Q+/GhAqk/J6pTc/wOjA//s6RCbreQPXIggsWg1H9u0/nWEVKEoVjhJ
bgIcaDrpMocnw5maTQ95pS+ni4ekDbJ+i/H/tUSGWS/rS4wZYYVfFW+NOjyF0UpC
FXz42WfpyaDNrTywaX1zU7W4nNUtYOC/ZnHE+P7jBWSD7pj7JRBCKHkWRKXZaM7+
ET1ymMRV/T/6vgQqbFP+xCU6+HWV9diauWfo5UFEms39F3fjJS944ucw60m8e8kf
T/HSvjWKefoY7D2QbsXJ0/izOBc5be05f9a/ycHiBK+/XkEkf24=
=b6JU
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
