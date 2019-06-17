Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8BF748B61
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 20:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfFQSIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 14:08:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfFQSIj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 14:08:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D6A5208C0;
        Mon, 17 Jun 2019 18:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560794918;
        bh=Lvr889B16IxEwxbPq6dr+N2XE/Edny7aTZB+wbBtlA0=;
        h=Date:From:To:Cc:Subject:From;
        b=zek+vnU/Yv7dG+DDevyVjmfnhLhj6dzi1338ozuKMaFxqLkw96G4n0YhIZ0WQkgIH
         2LMvG0KFSgYtvIEfD+1TJ+T4UowTdluSXmoIlc7Pl9cMiwXYhI2hhMqWPbYo8J42X/
         6+46l5dyXZ6oHwTscwjV1TakIHwqmNxrQcX7wLjU=
Date:   Mon, 17 Jun 2019 20:08:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.182
Message-ID: <20190617180836.GA16672@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 4.9.182 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/ip-sysctl.txt |    8 ++++++++
 Makefile                               |    2 +-
 include/linux/tcp.h                    |    3 +++
 include/net/netns/ipv4.h               |    1 +
 include/net/tcp.h                      |    2 ++
 include/uapi/linux/snmp.h              |    1 +
 net/ipv4/proc.c                        |    1 +
 net/ipv4/sysctl_net_ipv4.c             |   11 +++++++++++
 net/ipv4/tcp.c                         |    1 +
 net/ipv4/tcp_input.c                   |   32 ++++++++++++++++++++++++--------
 net/ipv4/tcp_ipv4.c                    |    1 +
 net/ipv4/tcp_output.c                  |    8 ++++++--
 net/ipv4/tcp_timer.c                   |    1 +
 13 files changed, 61 insertions(+), 11 deletions(-)

Eric Dumazet (5):
      tcp: reduce tcp_fastretrans_alert() verbosity
      tcp: limit payload size of sacked skbs
      tcp: tcp_fragment() should apply sane memory limits
      tcp: add tcp_min_snd_mss sysctl
      tcp: enforce tcp_min_snd_mss in tcp_mtu_probing()

Greg Kroah-Hartman (1):
      Linux 4.9.182


--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0H1yQACgkQONu9yGCS
aT79WQ/9Hob64aMdUZ3bX//qra4vWZvbTQiialnXahrniKuRagKGhKVyyJe2dJ8b
5mkuyFBvfqYxMhygjj3C4RMELte4t/1y/74E7V8zdTJJnmcEyeIgImPa8pJdXNy7
oP/1PUAw9Ghf+EMr/ByZD5L3o1QTgzWO0/7PbASfC3KhOZpxHvpt1q5GR+xtMBPh
jCAEThCV+VKSvxvmQ9V2o6oG0K+SS8/BNS29wZBqrVGa7t3MqYKfUFjovXaj+s99
Tn1YHrG0Uj+l7ECQiW1KIqameBdkuw0sQkD3dm5VRwiccTQoFnm0JOUUcKXpbqEy
oC37S8qHxmWfUAMijbfWaJYu6uLz/YKBsvy9+Tq0Bx7U+lxUEFRk9N1vQCOkojai
/dFG8v97cFxroF7Eoqqr1cqyF0FJyg0Y7OBjwr8RWcrU79eql+5TT9qMQ94h7Pcz
Xk1bkZmtjsNaVPZn16LWDzdZnKGGgfRq4sVywJeWRVjqPzzRPQxUOLoDz/s0JwFy
MzTPm44+wHkkFaHyhfTsfpvpXwgFYERQWGxg6ITVCPdSXgKbPnTiQUeboFZwTf5y
KrstTddylSGfIAuhrnUzyX2SY1qxwf9gojo4HxOxhwCz9Oj/cxVe1tBnpjDDgUHR
avl40x0GCZwR4wb+jQH1LcsvcHLKsKClxDYtcmp5OxRhvwNeH1M=
=1RNv
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
