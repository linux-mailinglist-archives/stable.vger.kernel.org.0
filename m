Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2C7186A81
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 13:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730918AbgCPMDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 08:03:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730845AbgCPMDy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Mar 2020 08:03:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BC3320663;
        Mon, 16 Mar 2020 12:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584360234;
        bh=Ao5Ufi67EBcvrXC7ckGJZo7PFl03jsXdBJ0BnJUCpYM=;
        h=Date:From:To:Cc:Subject:From;
        b=V7uBJrET/I1l6cJmdpEF4zuBtW2oQPL23DFerce5GDJ5SmZBI/zmrFyMzJQ/QsZsn
         5skG7cPPSzvwS9p0Lys5Hu3moWbfi+aWu4dIGoVLFbtf93K7XEKdZo6ji8qEKowbUw
         OVxGViUKa/VYwIsjmPjPIYQu9TiBT3uktquIO6yU=
Date:   Mon, 16 Mar 2020 13:03:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.110
Message-ID: <20200316120351.GA3735485@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 4.19.110 kernel.

This fixes a problem in 4.19.109 in the KVM subsystem.  If you use KVM,
you are strongly encouraged to upgrade.  If not, no big deal, you can
ignore this release.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile           |    2 +-
 arch/x86/kvm/svm.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Greg Kroah-Hartman (2):
      KVM: SVM: fix up incorrect backport
      Linux 4.19.110


--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5vayQACgkQONu9yGCS
aT793Q//UgYX230OzVujfRA80rNeQd2PlAH2wcoR/wHYLj2bAp1MIB2e5UX1uPyQ
iXAm9BHL3vkupsxNVnTj5sD9/hDoacaOlwyqMRStvU/H0XuScq17Yec5e1wBLH9+
eTdz48Xl75nmoocG40Hgb4+JkAnuLPR2R2RqPUa6dIqOswrU8oArgZOox5rCjVA6
v6r2N4KfVPHHnPg09WidAeRhPB1k6lMrXQbaQk0X2nYV0n2dNlq02vw4MCN7ckku
qdy2LZycqwiR0aeJTb9KiJ9MKcU8eHOSC2RsEVGL1rFUC4OLS4rDoB9ROXFViFn5
yxxQM5dG3pJ0sXs9MW3ONTirjhYz0WIHrjdTy+PZ0Qh7gq/hzcX7RITRNuOXUaF0
TXW0BPfGrelipCHB11ObzKRjaDxOMRlJYbtSY+WH/oaLkpCJswIpLiLwHszwHq7n
W3IvdgpRBbeO+uor1g6lFn6SgH7DRG8ZegCqUoWPQ/zO1ziT56xu241eFx6I6XJm
b7K2E6A6ESG9R+YQK0XZttrsEDxPTLvOa6ZP/GsjRuf2n6PGVPReGC4QyQvw9hoZ
+oMaihMeBih5cdSt/QOs7wEMVWPydabzVFGeCnfLXB+Bm2xsui+B79Dzv4YwKIQ1
YvmsRo6dV43n2IkevAWPJFj7QvaBY6B4gb0WpSYGGmkGfWgIly8=
=DgXC
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
