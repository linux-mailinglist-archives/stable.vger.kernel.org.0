Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E727C192FA4
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 18:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgCYRoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 13:44:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727541AbgCYRoY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Mar 2020 13:44:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C74BB2074D;
        Wed, 25 Mar 2020 17:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585158263;
        bh=f0GHT+VwKPXcpLO2tFDzBlY3ksBNxm1eV2wCt/Syk70=;
        h=Date:From:To:Cc:Subject:From;
        b=jPNJ0wVBIYofWK3hgRw1X36T1a+dqRxWmQGXKjafBU9cKOo18+T/m7Q6mL4Pbp824
         zNa4v3tlA0fJpZ3Qk+YqSJdMyhMYsvEKq4dFl8buyzVrjlsCMNCOXQwzAtxN2UmTPy
         eJ4b9FeB8Tb7eLSnJsa2xZMXXYHlQHj7xPlcnNmM=
Date:   Wed, 25 Mar 2020 18:44:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.5.13
Message-ID: <20200325174421.GA3764758@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 5.5.13 kernel.

All users of the 5.5 kernel series must upgrade.

The updated 5.5.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.5.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile               |    2 +-
 drivers/base/core.c    |    4 +++-
 include/linux/device.h |   11 +++++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

Greg Kroah-Hartman (1):
      Linux 5.5.13

Saravana Kannan (2):
      driver core: Add dev_has_sync_state()
      driver core: Skip unnecessary work when device doesn't have sync_state()


--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl57mHQACgkQONu9yGCS
aT7NVw/+Kgw+jvFiLGLUEjg/AF3tWGmGiOapqLI5t48LpSwgnPx3nN+4oR9CNKNu
zXd9uoOlGxmrJlxhQHpAqiT6eYbSTfcksTfKuxHnGB1jW81M9vzvIJ3p2W7osouB
Ia1A0ZzPP49XWRwSelhDVWC3JCeBcyL9QSgRPsuJDMK8lTj+btWbYCmL9kYrb2GS
ncVoxwpuKNDpHQTunUb8lueHbqpzMUo9Idd1M2EYqCzyxpOt2TOOSazGpWQ4Cy3y
LIIi6Ktvb3TmTWXrpNb0xwY4H/TJrZNyTo4DMMgBUDo7D/Udz5nLIXbMe6gRLsYS
MUKqF+8aA+x6eeK2wFalfkZ6baVIuTSQhITRFbAEB0FNa5ReHQuVQEIx81zJzixb
sM52MWxvAlWmSkxKFhGuxUHqcR2PbHZXwgVyBgNNIJLGmsAX35y82dpJqteRc3Dd
GTYk8xUVCMyIvRj6vIkQ53CHZ3q5LmJGY8HPUoOjrM7kWiZ/mOVZHAMZXKprS3w/
q6aNGyyUE/+qSwKo1CYEG+KWXx0Xv6FtStaBWni7k2oe53o5WdF8tQwrdopueNdc
pir5792+kg8TfcbtiwSCQxqFordlPNt3+pJGJQMd0HSNiht+Y2U8zttyMb0O++Z6
iy+BL6KlK1kGPwNffr5V2jFM2vRc0Z7WkNH8/RXagbt5ccA6iyo=
=vhks
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
