Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156B7340AFF
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 18:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhCRRGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 13:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232075AbhCRRGa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 13:06:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 192BF64E05;
        Thu, 18 Mar 2021 17:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616087189;
        bh=OzZeeyt4+qWh1o9X9pVDpQhFygFpUpjHT7O44d2R7VI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j2k3mtD+SkCvCuLJKSvwIWCkwUXM71oF/UEPqqC9+BNlYIxOAhZOcVGzS5TedF+VK
         Rign6nQIk1dE+B4+7k0Y8j+Zn0we0Ypgoc+9ZNhdQw6GNcWztRcEUAhS+gqHWGealW
         7jll/tzCOvEF/7dRKTdFZTb1u/wSP7ue5Iap6IABrB0TvfGNnWNljWbgfHuVrCqjbm
         8cscrweKkvFFa7ew80RWlgu+AbZWF9G27mAKGIaJaiCYtE+5L4YumE6p7ktsmcWUru
         4/jgin9BJ/BYiw7OqZXOBIAP3MQfVRKQa9iDYIDjuVc2bT+FK4dDc/VDvl/d8YBB5y
         UdQrd+fkSPQ0Q==
Date:   Thu, 18 Mar 2021 18:06:23 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     =?utf-8?B?5ZGo55Cw5p2wIChaaG91IFlhbmppZSk=?= 
        <zhouyanjie@wanyeetech.com>
Cc:     paul@crapouillou.net, stable@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, sernia.zhou@foxmail.com
Subject: Re: [PATCH] I2C: JZ4780: Fix bug for Ingenic X1000.
Message-ID: <20210318170623.GA1961@ninjato>
References: <1616084743-112402-1-git-send-email-zhouyanjie@wanyeetech.com>
 <1616084743-112402-2-git-send-email-zhouyanjie@wanyeetech.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <1616084743-112402-2-git-send-email-zhouyanjie@wanyeetech.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 19, 2021 at 12:25:43AM +0800, =E5=91=A8=E7=90=B0=E6=9D=B0 (Zhou=
 Yanjie) wrote:
> Only send "X1000_I2C_DC_STOP" when last byte, or it will cause
> error when I2C write operation.

Any write operation? I wonder then why nobody noticed before?

> -			while ((i2c_sta & JZ4780_I2C_STA_TFNF) &&
> -					(i2c->wt_len > 0)) {
> +			while ((i2c_sta & JZ4780_I2C_STA_TFNF) && (i2c->wt_len > 0)) {

This is a cosmetic change only IIUC. Shouldn't be in a bugfix.


--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmBTiIsACgkQFA3kzBSg
KbY+aA/9E48TYsKg+GY+0vucmpH6GdNoif7CStt7jwLYr5O6SEdo04WRdKLf1NAK
mpJUVbIPlUbnZGiKgMASumG8hLl8/qO6288k0PxdZ25c8QJM8/mVIklq26/jQiZq
rtHnD6yAUq11IkbeUKY5ClbncPelktYbxyNV4D7Hc2060DK9HoUxu7E7mf8Onbla
bOkkfAwHfXIwQGJvopU0uZsxdgQngp7yuYjTOj0y5XlWjOeDP3mZuwMffNO8DuDS
2+rPPp5mUz6maVA1byioWyhuH4R8OpTAOFdsDiA4lnNunjPzkfCWETlzM38cdUTk
1CrSCiOVg4GnaJ7u0ZcCrJqx0I0F4zkHZtCVBohRETi/dIvEHIxBteHkLXzZV1oB
/ASSY0Gzn7/HZ61AwqVV22aWI3BNYMhqALvBkScvLiuTuW0c4K2fEGZZt12U4guh
9Hzjje0cIU+msNJzvZstO6k3iC8PDU56bKcRKx34JrlQsEWZbkHlkp1iziJJBPn+
NIqo+16JcA7SLBgITX4pW5RvWHYtlPBRyaWK3qwqZkA1jbPfvsz/+jInUWb56WSZ
2ZkNTwi+v7rTropAg5NyH+u6rMACFGVmyDPoh6R90fghtD4TMhiAPDOyuiZaAlXt
2J/Y9toxI8Q3Y+PtNKWWKm4JV+2ToEFVu4hdMD5ag7IKG1G4ZOw=
=f8EZ
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
