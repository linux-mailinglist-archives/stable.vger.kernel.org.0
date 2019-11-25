Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A91C8108CB7
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 12:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfKYLRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 06:17:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:38018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727453AbfKYLRP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 06:17:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 916002082F;
        Mon, 25 Nov 2019 11:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574680635;
        bh=5d/75wH2tGCwXryhVDMgLnW4LNtocSL/BSIvLTbJhXI=;
        h=Date:From:To:Cc:Subject:From;
        b=NotGeBzOp5XgQ2R+2iT+JD5LPN/aCTqYzRWFPvzVr0Vt0bZIklvm0ZK/J9KV4SU42
         UD1u6C/r5s2MXJfrN6QZ9MC0sCTBNCbVwjb1CjBTQjRfHaggTiEzltsv4vW/d4ykhY
         bP6TYMkII+gcJISMW+NNCLa67WL6mgCWiYjinTPI=
Date:   Mon, 25 Nov 2019 12:17:12 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.3.13
Message-ID: <20191125111712.GA2573919@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.3.13 kernel.

All users of the 5.3 kernel series must upgrade.

The updated 5.3.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.3.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                          |    2=20
 arch/arm64/lib/clear_user.S       |    1=20
 arch/arm64/lib/copy_from_user.S   |    1=20
 arch/arm64/lib/copy_in_user.S     |    1=20
 arch/arm64/lib/copy_to_user.S     |    1=20
 block/bfq-iosched.c               |   32 ++++++++++--
 drivers/net/usb/cdc_ncm.c         |    2=20
 drivers/video/fbdev/core/fbmon.c  |   96 ---------------------------------=
-----
 drivers/video/fbdev/core/modedb.c |   57 ----------------------
 include/linux/fb.h                |    3 -
 mm/memory_hotplug.c               |   74 +++++++----------------------
 11 files changed, 52 insertions(+), 218 deletions(-)

Dan Carpenter (1):
      net: cdc_ncm: Signedness bug in cdc_ncm_set_dgram_size()

Daniel Vetter (1):
      fbdev: Ditch fb_edid_add_monspecs

David Hildenbrand (2):
      mm/memory_hotplug: don't access uninitialized memmaps in shrink_pgdat=
_span()
      mm/memory_hotplug: fix updating the node span

Greg Kroah-Hartman (1):
      Linux 5.3.13

Paolo Valente (1):
      block, bfq: deschedule empty bfq_queues not referred by any process

Pavel Tatashin (1):
      arm64: uaccess: Ensure PAN is re-enabled after unhandled uaccess fault


--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3buDUACgkQONu9yGCS
aT7qPQ//XnBGeRLL/Y2ZfTU7UT3onSvDOpeMvjtVQXtsfBFYEr6bkXsSYz1W/21y
2Wl7pS/q43MoIfY3zK+Tj0h9UjRm+2Pa3m1HGynVm3pW5QhsUsvVMXP6zfJOGb+p
Dg7xe4Hm4Zbi1qtKMbjQtSdUA/mn9NIJlk5Qr3AYfLpucWvcvczv5zgfOwblIKRr
3xZmzpCw8fl43j+Qi+aKhXatnKwkQpuEsxgkFrpTi/6GSHoAFi/e0g0MgC13DoVy
mdB37RlQ7Edg+/fmc89sHZUDhxv7t9n36U8J3hoHl5vGFme5Up4RcNBdGwFrjo57
MoVhf/9QmCgq8RmYHedLWGg1CYkRn8Tzpg+Y4TqX9PVoLBAsfd6pRNz5nxnb951C
k6ehnBtNsuOM2WokGgwIbtgrjhHoGl4L3io/ICAq9MOYla9BKJbSxj3qndszeiGy
n3XwtKrLDNevv1LQFt6E2NdqiHpR8iCQauP9Ej4vF49tZT3krB5F6MOntKSMw2Os
sc3Di3oKpYXHbQRJmFOcGa9xTR4iGHrE9Yu/5I61saknAvF/GcPeONB6TdhDGDiH
lLkjb/cizuJI0nZ1/FFO+RfL3JCPh9uLgCK4G/vm3yrjs9jrPZh1n/PBADceX6LB
1zyTSdM8b1irpugiOB1WfTzfJCLhQvIQqo8htBsTt5wM72LEZrQ=
=C3r6
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
