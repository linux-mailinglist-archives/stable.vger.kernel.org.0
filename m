Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 206001361C5
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 21:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730304AbgAIU1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 15:27:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:46718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730289AbgAIU1T (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jan 2020 15:27:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0BEC206ED;
        Thu,  9 Jan 2020 20:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578601639;
        bh=1Kxn0W9HOmtfwzP9pJ+qAOertJWVT6zsMDQwuf7JnTo=;
        h=Date:From:To:Cc:Subject:From;
        b=ToB67fm/N1Qu8XFj/olIWHjgQHZ31gVLuAwH6QMw05y9/VBBKDCzNotlFPokqxTOw
         MiCrw/ILY9OjdBiowlkdiqBh2h9lPpT1OLBYU398OIQcwaMp0jnSL2wRldKlLCV2ZX
         HniHTtpeE0a+CZDOqRYvZZzKIT1iEpJo4DIlpkeM=
Date:   Thu, 9 Jan 2020 21:27:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.10
Message-ID: <20200109202717.GA7962@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 5.4.10 kernel.

Only powerpc users need to update from 5.4.9, there was a missing patch
in that release that is in here.  Sorry for the confusion.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile              |    2 +-
 arch/powerpc/mm/mem.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Aneesh Kumar K.V (1):
      powerpc/pmem: Fix kernel crash due to wrong range value usage in flush_dcache_range

Greg Kroah-Hartman (1):
      Linux 5.4.10


--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4XjKQACgkQONu9yGCS
aT4tUxAAkNd7HLc8ZhlQIjx32vZ0azgvsI5WoJ4f5Sr8+cimmXkWVDWFINXt8HTb
Za6yY+pQPk39LoB7MqZKQ552weS7Lr4m5by+IY996xg49L8cu/jtib+q2/18oHNn
rqok3KP+pUEXNzbdIXXfoPdVCWvGqwZJ0E/eH9zXZM3R3K7T0tf9WBM+a1LfaJBk
trQHKN2U56GcQJW269djsqRWGE84lhHbuvKhH7p6CgpSPiF0t/lA5gVsFZ2UJHIP
2Sl5KEZVeu85FPARKNWV3Fm/UEfNsdCCsMAr2CEJz6NpVnoQvHQcCLG9XFCBjrmF
1S1Thp+hhDamEUtIpX4VJmXrdBRiQDELg2OfB6eAcLJAqRLTeqSfLjXyTPZcETtw
ezLx2JGj9JQWR7FQpt++321dXjscydVokl5wdWJGmKRWlbrXNv8VFh1N4Q28xrlW
ryhm/ypdJsoO5keLWsiEg0l0/7w4eZcKaSvYLdpP/d8oFjHc2QO7TR4qtyQ+Q3KB
nHWIUOMYvNNovDOY8JNEc2JLOE/SsCjIb4AZ666fFlO/Eop27K6XsvkTpuDzsaTZ
hLBtWvc0EdFVUV/x3KUxrt7wZRgMruubpgU/Lkje53DRxTrVCvx7KYk2ZtIb8z+F
GF9tFmqK+Jxmosh4hlyGUKyfPBio648tirnndxRwXa+ZHZxSNWU=
=treM
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
