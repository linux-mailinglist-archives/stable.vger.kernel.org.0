Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE99F1C36C2
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 12:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgEDKXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 06:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbgEDKXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 06:23:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB1EA206E6;
        Mon,  4 May 2020 10:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588587813;
        bh=4AVmzmpueCc0HIA61O1vtU4oG1hKwTErXqacU5miKVw=;
        h=Date:From:To:Cc:Subject:From;
        b=urSR0F6JXDw8cuSQzOGDf+Q0b9YI8HmoE+ywELbZ58MmcO9qoYNHSJ6771UZXieS/
         h6oYK+KMa02gkXXfrKIv2pFLGu0YA/4dNbJqDTGMfM8UHh9CdRV4R//SxpaRaw49RE
         pgbZYRkWAaNuaUyAt0lLnN4ICz9Cm6dcWLXlwtPc=
Date:   Mon, 4 May 2020 12:23:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.38
Message-ID: <20200504102331.GA1457780@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 5.4.38 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                   |    2 +-
 sound/soc/meson/axg-card.c |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

Greg Kroah-Hartman (2):
      Revert "ASoC: meson: axg-card: fix codec-to-codec link setup"
      Linux 5.4.38


--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6v7SIACgkQONu9yGCS
aT6LOxAAwm+Hk7dgQWJUPQBKSRTFhBHpbPT13lKnnmVF8SKxu9VRjKYp33ve/oep
QMEYbq53zzNRksaom5BjgOxyoDn1nlSjIjzYOgteCrhWDiD4O5bKmX3/ABCNki8i
u4pAvMxfmvhuM3g1cW9ZlVyv6NCtaN9dFCNrxtDyOr3xWxOEGyARDEM/6K8l/zbi
DFsG6jTP1F5meU4llMcCSf5GahrY744x/Gn1nCOlTEf4/oXyYV90HmTcnt8kw935
yDi7iqLv02AhZpjVs6XAlYIkpaqF9rP6nSmxxMXZCRGsOErQRE4HY92SZzoEFDMG
X2NMdwwhUhkbEZDb356Hfd7JwoCrx36uFSc+lNEmuJFceAPqiDFL2079iOf3a0A3
RWRfBO741Lw31ww9OgarEqHk6dp+nZGI242i6dsUBNQ/43wf0Ts5QPmFGAOTzctx
qAMoVyqm2kSJ5tZDgCqS0nuAw3inwR7EqV+7eAM57ijTGPHH927ZkML3H/DPsXM9
2lZtvdOOGAJQkmBlyI9XuuIehnflGay7+gRG3Cya73kfB9wlCfNs40ARUCCZqjDI
pkPWEfNzcXkLYNJr8zD8E2u8g/VlehJIrtvfv051Cix9Uyq1bvnxSYKlE5rG9iDv
/GDVLKFNnPVd4pzaYJ4kbZ91iD8tjO6B7d7kGUhWvvm4GSrsX3k=
=hgwf
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
