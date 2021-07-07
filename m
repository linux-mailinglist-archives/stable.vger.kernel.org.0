Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FBE3BE844
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 14:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbhGGMvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 08:51:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231696AbhGGMvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Jul 2021 08:51:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0121661CBA;
        Wed,  7 Jul 2021 12:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625662110;
        bh=0RC3E3ae+rfUs1h+OgZcJb1GWK6Xb95duNQPMcdah9s=;
        h=From:To:Cc:Subject:Date:From;
        b=tPtSw5i4hNWBe5fOZO7yBE7aAc2mgZ65ZQqvHA19nXodEe7kLfXq1+l88kcOH5qj2
         6V3PbzNAduu5vErQED1geAvKf4M8B7BiNF38odF+YabRngwcILJavp8eSxl9B8bg/q
         qYn+5slkPyC97FxCqPpWmatURskHGFzSMXd/sk5n6MH8267c77MM7TH+vsXatMcMYV
         Id7EzApsiGzv8Of4KnbVj1iS5tqxvbNLzW1iNkiUjcUtqZXMr4NxnnZhWs5ocWRg0S
         xMobKJalcO91CumaNkUbr1utQ8WBqndgTVwoJCCmRXx/vDUnaKjoomB1Lv4i1fs0tb
         5JOkWnkb2icKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Linux 5.4.130
Date:   Wed,  7 Jul 2021 08:48:27 -0400
Message-Id: <20210707124828.2443579-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I'm announcing the release of the 5.4.130 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary


Thanks,
Sasha

- ------------


 Makefile                                      | 2 +-
 drivers/gpio/Kconfig                          | 2 ++
 drivers/gpu/drm/nouveau/nouveau_bo.c          | 4 ++--
 drivers/infiniband/hw/mlx5/flow.c             | 8 ++++++++
 drivers/scsi/sr.c                             | 2 ++
 security/integrity/platform_certs/load_uefi.c | 5 -----
 6 files changed, 15 insertions(+), 8 deletions(-)

Christian König (1):
      drm/nouveau: fix dma_address check for CPU/GPU sync

Johannes Berg (1):
      gpio: AMD8111 and TQMX86 require HAS_IOPORT_MAP

ManYi Li (1):
      scsi: sr: Return appropriate error code when disk is ejected

Mark Bloch (1):
      RDMA/mlx5: Block FDB rules when not in switchdev mode

Sasha Levin (1):
      Linux 5.4.130

YueHaibing (1):
      x86/efi: remove unused variables

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAmDlopkACgkQ3qZv95d3
LNxXEg//cOzICk7j6/qzijKVxiuJC3YBJ99U05fap7EjShpomDrxs9q4yhbOeBAn
Q7GdF8XDa4si/32T0fAojLKLWMvGN6gwjIm1mKFPcSte2lLiO3KnlQubjdo2dwJi
VFtmkMd+Op+77WhzFBpEYRiFisnzg4376eQIp/rzxC64faVkbp8mobtq0KCTIvqv
OT05R1Z/DMR2pl5vI1ho592oVvl4FbWWZJRcTc05RAzdPpOsFqmJZkIua5Q0GQzo
iovxwsVz7cH7RMcXIQ65emuNFIFlB1qfKfA1VR/WPxuj/gmtOJth2mU0+BO5qSYK
9z1mbCUFjEDjgI2dBshNzlKIERoo6tExWiy6BOmuQyf5KTzJLpaLtLXvxygak6GB
FT3rGmcV85ec4wAgHeFgBeEJWyMgmgiNopx0intVkNwhx7Ulsg3aB8vrMwn+QJSN
2kPA/rip8VEignB2wzw0o/0yiAp2tjszcpwTFVIjo7JnfzjDyhzANdslEFu+yjUm
FomT+mXe/yGfoKHl8YqXYaVntu/YGbocd2pGg5337zwFimR88YfVpfAezTmnrg8L
8xI8q7v3b8vcXzxCbLE801tMuU1gKFj9m7/DAWp+F/ak9jV0M7lelnpGF3lr4DDP
3MU6J+Y4faiC2LT6KcRaBkoPXPXVdYjH9yYA+l8jwaAbDK3fFCE=
=60Aw
-----END PGP SIGNATURE-----
