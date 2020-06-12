Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84DE1F7780
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 13:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgFLLvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 07:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725791AbgFLLvU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jun 2020 07:51:20 -0400
Received: from localhost (p54b33104.dip0.t-ipconnect.de [84.179.49.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED897207D8;
        Fri, 12 Jun 2020 11:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591962679;
        bh=4SU7cE5K1zuUDgcSqNx4a6863ycbWxNzjj6+RY5JyS4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BkdqVphjX1fv36AiWfuo2mhxrD9X8RnCZZRgbLw6LVw7pofACnD2PF9cW8ZQXuUEo
         vF6eZ+/C5O4ujSsMH+4vPZfQgQb1EOa7TQ/ofyezZIhqzglD8/VdscYUTZSnV+tk/4
         V6wgTeI0gGoYt77aXLKX+10YRZe/Ece1AJjYAedk=
Date:   Fri, 12 Jun 2020 13:51:16 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: imx: Fix external abort on early interrupt
Message-ID: <20200612115116.GA18557@ninjato>
References: <1591796802-23504-1-git-send-email-krzk@kernel.org>
 <20200612090517.GA3030@ninjato>
 <20200612092941.GA25990@pi3>
 <20200612095604.GA17763@ninjato>
 <20200612102113.GA26056@pi3>
 <20200612103149.2onoflu5qgwaooli@pengutronix.de>
 <20200612103949.GB26056@pi3>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <20200612103949.GB26056@pi3>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> This basically kills the concept of devm for interrupts. Some other

It only works when you can ensure you have all interrupts disabled (and
none pending) in remove() or the error paths of probe() etc.


--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl7jbDAACgkQFA3kzBSg
KbYmdg//RW9DluIKVfF71z6Q72EfwO+kHdqZsli+39eCQGi+J2lBHJpJXsWzim+B
FXD88zlC2PC0Jg/svBtzq9t4FfmxA/YJH/rwUrr/2f6HYR7dXLfxFJDc+o2j5hFX
mgHPY9Ol+5l8R8jBDMO87i5Z/Dk8CRcEoiIMnfpnbFjhRdlR3hNxfwQV0u+yLQ5A
bHfcm3trfqSZooJtfAwoxY0LsrgAcStKVuNKqCS9676Vr5ah11BFGKaklQYNEWRG
0t5Xnkf6QSVbIHfVj20h70nvTPK4YP+quTs2GDcl/pYXESIduY1qxsbjfSXigi3H
27Dbu+Vzu1gLaoem3zFgxefBl6JdYsBmoQYPPGiOmayseWg2VTDJrHpgTs7eu2uM
6o8d3MA4g56sQJocsGSOMvStqu8xEVJ/V5kt6lDR0j7Ue9rhtXZRiDw6/DW3Gmro
s1BiEX3UwvwXqdGK9z1j+q/skFd3noXVY/goYsxqwwoyO+uMnhy6tW7HCJvse8e+
ojfwLkXX2Lu4+12+MnDhWEsa/jCEL2ozQC0tU594l5FLU5VYQCetAM7XnUfbDqDF
B17Ro5HH5+WhaAWwUkWUO5jaVtRe6w0e9P2ChQocQjktjoLNzVPXX8x2vzGGQUrl
CaGs+J26V4mod0xqhOZkACLpdBUJwb0Ji2/C1ewgBxXkcLofM+4=
=6fqc
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
