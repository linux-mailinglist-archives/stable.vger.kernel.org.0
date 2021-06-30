Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8963C3B834C
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 15:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbhF3Nmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 09:42:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234723AbhF3Nmv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 09:42:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3505561426;
        Wed, 30 Jun 2021 13:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625060422;
        bh=5QDXh383qyRGSxQt4UN8XTBC9PKCSj030PzS/foW1kc=;
        h=From:To:Cc:Subject:Date:From;
        b=AlJjenpBy1Yzh/6qvSTU88xV7KoxbgWWtQJAKBsH492Lv88xC27h9f0rIWjwTpd+Y
         SZdgoqSlvO8hlYw7n3rCCHojVeM5pSWlMOvwhATbS/ngSEXHxZDM+0W6e/iOauUxRS
         Wn2bQtyHNW8wrjr6h+C9SbBq6DUqlkx2mEGSHghSGFkwu+/SiC+j8lT/2Ub7Jw61tV
         POnId2iZVE5Aoia9dfbgskppHBoyrpXufUrUFUGlgIS/2FhOGYeXZHBUq5Xh8e7Cjg
         FJ1H8cpdCk2ILImYIcoD9/rMrsW3VFsynOrvnSVzfdgGprnDDc3G3w6oQiJNW/PX4E
         jY4YvsWv4TEgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Linux 5.10.47
Date:   Wed, 30 Jun 2021 09:40:19 -0400
Message-Id: <20210630134020.478257-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I'm announcing the release of the 5.10.47 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary


Thanks,
Sasha



-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAmDcdEIACgkQ3qZv95d3
LNyCpw/+K96+1ahen7kcs2rt3783nti4S33dpn7vKXeD6B2i5IhdqlFk3aCDqshh
aMoy8kNgtXb90GdgPobfWQGJt+1MMBfgxDd38VhqdBovOM1JNkCrVfrrv1lPmw/C
QUAiwxHeOd7why2UUMJaXb7xsAv/ircK+zi5sVImpf6NCgXeKaJOB74kFYH7VI+R
6LRPBWuOpDc3As1I1MOoC0tIXWI7YCictecr1LTDi75REu58x64ty0HN/b6Gj/Io
Y3EGlTe8GRIsChDAArYScCTYCixyN2pj/Loc7vlZUCHb3puQShO4bSNyPsykYxfR
HMB5F5Jf1HaKN0im5rel1sKd2hn0/tWwla8orRIWubXhBPrSxqsJJn642h2o7ZZN
8axd1K8Gd+zpqHZjjl4mYtcJo3A7Cj71r9XGVmfVMowTLs5wiX/30h98PfevlGGv
mj+ybjue3Gypk3ZTaHRifRLDh5KzTJNSMxm1YJcJ7IhsTBsgQXDMuInSgkSG32yz
Ggk/xj+GU4ob43EU92hSc4Cbh6zSUnQ2ac5vQAeKyYqKtAmEGL+hCf3Mnatk0ItS
UUnwXPflRB1eCbI3JFYZ5A0Igp+60WMARjRWb/MbWX1kwMOKlZKl9fUjfeJV6b3e
xURPJruLnZelsIXS8L9Nx1SWu51HnVhhf7D/58CDByqnBCq6oaQ=
=b4hI
-----END PGP SIGNATURE-----
