Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD63648B65
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 20:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfFQSJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 14:09:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfFQSJB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 14:09:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AC50208C0;
        Mon, 17 Jun 2019 18:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560794940;
        bh=X/0CfO8h4yFzacuXbIAHDGHZkFSKS0XbcG0epnFH92g=;
        h=Date:From:To:Cc:Subject:From;
        b=nuxFKkPeX9YbjWhKsV/Ibft/m6aj+dtY0X86Quq7yRgfaChQ8iVxvuqJc0EwVD9ts
         xPOzeRLfOBf3UM2VVlWsiUxE8FJX6cpcqi4exILudI7hnuyGd1WIP4NFMhsZMV2zTe
         yA+NKXtutCKiNiUOWh99/FzkIF2mOHpbPcQJQslc=
Date:   Mon, 17 Jun 2019 20:08:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.127
Message-ID: <20190617180858.GA16756@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 4.14.127 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/ip-sysctl.txt |    8 ++++++++
 Makefile                               |    2 +-
 include/linux/tcp.h                    |    4 ++++
 include/net/netns/ipv4.h               |    1 +
 include/net/tcp.h                      |    2 ++
 include/uapi/linux/snmp.h              |    1 +
 net/ipv4/proc.c                        |    1 +
 net/ipv4/sysctl_net_ipv4.c             |   11 +++++++++++
 net/ipv4/tcp.c                         |    1 +
 net/ipv4/tcp_input.c                   |   32 ++++++++++++++++++++++++--------
 net/ipv4/tcp_ipv4.c                    |    1 +
 net/ipv4/tcp_output.c                  |   10 +++++++---
 net/ipv4/tcp_timer.c                   |    1 +
 13 files changed, 63 insertions(+), 12 deletions(-)

Eric Dumazet (5):
      tcp: reduce tcp_fastretrans_alert() verbosity
      tcp: limit payload size of sacked skbs
      tcp: tcp_fragment() should apply sane memory limits
      tcp: add tcp_min_snd_mss sysctl
      tcp: enforce tcp_min_snd_mss in tcp_mtu_probing()

Greg Kroah-Hartman (1):
      Linux 4.14.127


--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0H1zoACgkQONu9yGCS
aT5yDQ/8CZOi52wM7NcdihqOdVS+M3at6Ibdz5RQEVdju6jmAc8v25Z1RQsvBgfK
tQbXWcWHd0XNX9Kk7klRlHPkmyh6PdmbjBC5EiywGZFnxsmrJrZEepQ/AkA7c8bC
/s9esM768AlCvhKdG2lRv2ARY8wEsIm3QCk5AQ7HjwuYoUPwqu7RiYbI7mwHtOCw
Eek6p00YZh77IJu7bgJwP1xWuNT2DLc5v6iO3vF140LI9Q3HJRZtp7WLXF0HnOnX
gQ8JYo0UfsIyLaB8OetESM/6FQ2sLJTR7N45HIdxNx+Az5U8cxQ+yZIucH4VinvQ
EuPcqy0s/up7XqbhQJS6XyJNQNoldy7J8dk+LQ31ccfQYynXz/Iraug7+ktWZUyO
pKaSloqip6DrxBwPXKFiZA59Gz2rPElH3PLLH2KmVeQaslH6kG2mIZfoMZkvVbo/
XqecgSiJTXC1POvlJIeCJTVNcSOGQaasXn2zDxqtz79ojUpZGLK4E8kw9oix7saT
UvN6ho2NEKW/l5tnXw65pwzSYN0sHgt12t6iOdIa5s+2cLb70faT6Mo2rYkEKNfc
VNf4uhf50hSnslX0NdQbCVF5fb5uHUHP6ach3Nl6uHCSj4axR0a75xCYXcLSWYI7
bDavjuf3NFVc6LHMrZID7djGExsWzwKrg5tmNPMsnALLlCxEOZI=
=WOe0
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
