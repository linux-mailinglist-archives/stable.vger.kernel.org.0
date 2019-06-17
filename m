Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3765448B6A
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 20:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFQSJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 14:09:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfFQSJW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 14:09:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC041208C0;
        Mon, 17 Jun 2019 18:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560794961;
        bh=76StDr7JwEnq0s4h/8kCJzSoL+JRtCJB0DKsdEWSUCc=;
        h=Date:From:To:Cc:Subject:From;
        b=2s6CNV0jpX5O3kLrUJHQ0J+cD22/Xg9StQ9kXfMqsDYHiXiK0mJIFLLhuCwgAHDJQ
         3alCw3eJFGkFQjE5HvWRVqcXL8zbAuMpTzMcRJPTw9RYV9yigtR3ALNs3MYr62OnQm
         JXmM4EmdXIymJvyCX0sPPGJxgnOtSSAKUnJymLO8=
Date:   Mon, 17 Jun 2019 20:09:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.52
Message-ID: <20190617180919.GA16902@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 4.19.52 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
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
      Linux 4.19.52


--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0H108ACgkQONu9yGCS
aT7XmA/9H6r3RgO9iyav4XDAUdB0Op/zEYWFC+Nduv642EoaEExOu8wqZjSEmKer
FfzunTyLVwbeTh4aarZacZ/pn/DA1hvpjmXimctxcXHpnAGkYe/u757dJqWI+Vr2
Rwdk3BSPbhtcJGFLbOVsTJG5vqitOWz8vzUcGcbv530hkv0dvo/fgylraUufhRpi
Cl4f8lnWG0Y+VoWWjmFVhq8Sd3ZzzhtXLvKqwB5x5VC2ceZT8KU0UVhDgNAn5nfb
tukq6AwKfit0GBRFrg0/2Sp/gPFPKAHX7lHHae7c+wzA/XDh3vWkMmvNnL2iNvQm
Yh5F1pRC6Fo5FEfs4lr9kSY7vtCPORnd6ayvR2gKcpcBAOHmvIFJ/6uKwqV+WNEp
KoIJSjQ6DIlcTMl1rsqr/UhVp5Abiis4cdNrpWrEtycYvuO4vfi1uzlYzXYjB9P5
WYZRVoX/jQeietrUOvhZYyMnUygxrNz7jSty3JY1gLDzENcMHxrwqhZ70eA8arNf
sDU4tU/qCGaICTXveSOAEDP+d9q4hTJ8Zfj5XKSW4ebOd/QM+TG4WfYaPAJ4FzWt
RFyp+AYd4iT1yE3johGu69k7HEU4yHnP7Ge9/13LjVxRsiaQlkn1eN2OjZ7NTSKq
IO43SRUphAR80T0675WY3hnQmVVoJEj/JmcuE9hAF0fz+8qdGOs=
=MpzL
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
