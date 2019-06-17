Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1502E48B6F
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 20:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfFQSJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 14:09:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfFQSJr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 14:09:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 175DF208C4;
        Mon, 17 Jun 2019 18:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560794986;
        bh=TbGAM+F8uxVS+h/crfcjubHKsfUmlqGpBLO06pMtopg=;
        h=Date:From:To:Cc:Subject:From;
        b=Rw34qU8g6bx8lRIZ0HRPre0kU9aKGeYB8m9Y9//jd4Qir3sPFtZpVjO3lA55+wOst
         +Vme3SkUBZ5jvrzrQGAjEJjkAHXIfKvRfDwTvgJEl7NNliiKALdQGn1H3FLdCsQ7ko
         xn0FLJ3RTB0BItfardEN/6BXeF0Ob3PtQEFLsT/8=
Date:   Mon, 17 Jun 2019 20:09:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.1.11
Message-ID: <20190617180944.GA16975@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 5.1.11 kernel.

All users of the 5.1 kernel series must upgrade.

The updated 5.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.1.y
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
 net/ipv4/tcp_input.c                   |   26 ++++++++++++++++++++------
 net/ipv4/tcp_ipv4.c                    |    1 +
 net/ipv4/tcp_output.c                  |   10 +++++++---
 net/ipv4/tcp_timer.c                   |    1 +
 13 files changed, 59 insertions(+), 10 deletions(-)

Eric Dumazet (4):
      tcp: limit payload size of sacked skbs
      tcp: tcp_fragment() should apply sane memory limits
      tcp: add tcp_min_snd_mss sysctl
      tcp: enforce tcp_min_snd_mss in tcp_mtu_probing()

Greg Kroah-Hartman (1):
      Linux 5.1.11


--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0H12gACgkQONu9yGCS
aT6s/g/9FDSYnjbHoyzsWt8wOy9/dhj1xD8zN3lOcg+jyXh0Kj7n+bwA41UomRiy
gFUNFwGZms3UkcUrTGR+4BOD/GAJ3myN/3BiW+FQUVzUtSkloYHsagfm0GQESnfd
/afg9HgiXHreH5iRvB0G4LSWnivC7N48axi3xl9yGO54jBjO7XXFNrvOf4nCG16z
VINIZ6Y2vimBPqQEa26EIKp7WFPqGDcQk220IfXSmYLt/RClVexK0Ifhim8C6+0O
rYuymNTm0GOR3UdA9aOQYmefxmfFfDVhhm3a/dpIqEYewUAr1sbqAEwiAN5WB7Od
SFRT91fTVVwa0xoGSvPO16z0fqxsSNnsgf0Zhm4+1tdSKfJIwv8nh0IgQqBQZ7gN
9z+tEyQDtSv6oPdZOFGH0zjhhwgnKnsiQuly9rrLsKbeH7wReDAG1jD3AXJRpN/M
RRFatrZrVR3SUBm+uysXK3wHOmEww/DtjSILMA1maUBrF9Jcxg7fqG72XB896Q1P
gR2e14RTGWZ1pAvTerHzr57nQwcOS5TdAJq4owfIIt72a+6y+JK6+296z0u5TiZc
Mw62rQ2QQV0MB+5QDREJSKetrDTZYFcvu9p1ob67aONk+q5tLhYCZl6EpJb6/oXq
uiy+jWZ54x15WIlqYmPD/5IAxOd+7vTco9hf1YxDSctISGDoKko=
=pqjX
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
