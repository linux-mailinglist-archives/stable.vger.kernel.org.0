Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A74465785E
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfF0Awl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:52:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727711AbfF0AdO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:33:14 -0400
Received: from localhost (unknown [116.247.127.123])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D94C121738;
        Thu, 27 Jun 2019 00:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595593;
        bh=fTJuPthQ2s2US+KiLhkZmKtQNFKUEeqBq/zoEs7uY4E=;
        h=Date:From:To:Cc:Subject:From;
        b=NTkBDROXrubU4vvujZdeUc3SJO1y9fIvQq/ip6wYA51w9zIL+bY01tuLOWI80qjVE
         jA0UlGgP5K123omPrvNfBXarqplkT5OKPiD2VsL1U2X3yziRW1rLurZqFxC4ncTYNB
         ntfvRYz7l2vx2q05STeFLiO8g0ZsvTy+IMms6oog=
Date:   Thu, 27 Jun 2019 08:33:06 +0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.131
Message-ID: <20190627003306.GA10859@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 4.14.131 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile              |    2 +-
 net/ipv4/tcp_output.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Eric Dumazet (1):
      tcp: refine memory limit test in tcp_fragment()

Greg Kroah-Hartman (1):
      Linux 4.14.131


--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0UDsIACgkQONu9yGCS
aT7vPQ//T79ObYHkdMLGHE0qA/PTjvKftfKkDrbnvcVjtJOPcJpt3s+E5WK/2vwe
pPVw8yXS0cVRlGhhl5rHvcg2MsObZo+l3Zi8xXqNpcUHyqk0h0ynNlpIYuzlVzZg
0PH4144tl5X9MPx0wuHkYJnKkTi3Z8UL/qWlM5oNQHJwZmz1Gk5aZL1YhyR1s3A0
QrRMbLHxasndv1foDoNKZd6Kpn9gfb6ofs7R+8o2ab6aZMzyYP3MyazCJFEuuFe3
mzU6zzMafESCTcwm0k5IiyrHSxzbDKJqPfmklu3KAQbqYwPkIKxtUVOygdRghQg4
NJEv9mRNXrkAgDC09hFVN3ZvuTa7+sD4pBv5t2CEylhjcyLLXC5UmMniQTsG/e0r
/bdI/0MrnSThYsRLQLU5mFNiYf47jiJURM8qDrLrvWeH1YtM27h3rd6hLVsFIdud
Arsyw5gIRj2Q0Q6oqJ8l0QX10ugYbQ8Gyjsb0NrwmWdZ+XEViZcBRFvc8U/2tGk7
rnSbFdrjTxXx95EYFQeGznxOW9zOIlD43+4/vvFGHexPvgf6q5wOsBTZ1TTruJPA
HBvogCL1ggnvUrlPQjGKCQXmDqi5DyJzDZ2Z1WZkG0FI55aLIKHqYIorm/RvITYT
KNI5rBgy8hjlC4rlPRYxHj6w115mIrM3j0XfqgcyM9luyfhXWNA=
=P+N6
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
