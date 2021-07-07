Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63BF3BE840
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 14:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhGGMvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 08:51:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231623AbhGGMvB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Jul 2021 08:51:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A116261CBA;
        Wed,  7 Jul 2021 12:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625662101;
        bh=MmbUoPoU6UIB2VkVAMcXcHYxy72riIJMJsaRoqhL6hs=;
        h=From:To:Cc:Subject:Date:From;
        b=QwzW0M80aNECORMO/OcTvzDdii9Y7pb2wAUFmUf8zsnLnYdIBHpLDnemrVO99EzYw
         FapcILDKT+zt80L40CuxFS0P7+5xG83/XD046vVocYBaixgZDAagtxI1WbFrUzWm62
         Rs4F12U35uwF370zARJu21Da3vU0vHP/ciit1AdTrrZwDAquOddc1ioHB2QsTeYvpx
         iUTDiZovKBg704+VX88acys9fImWNliFu4UOPjMxotSY0bUQFjXeEnt0e/yD/TL/0F
         R1ghg8EE0jzSclcdHg85zXPEXc8buS+3IbuicgqTSI2IcyYbVUaPXUbeu3eJ8zUcrY
         saDRUfd1CMfTg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Linux 5.10.48
Date:   Wed,  7 Jul 2021 08:48:18 -0400
Message-Id: <20210707124819.2443474-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I'm announcing the release of the 5.10.48 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary


Thanks,
Sasha

- ------------


 Makefile                             | 2 +-
 arch/x86/include/asm/kvm_host.h      | 1 +
 arch/x86/kvm/mmu/mmu.c               | 1 +
 drivers/gpio/Kconfig                 | 2 ++
 drivers/gpio/gpio-mxc.c              | 2 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c | 4 ++--
 drivers/infiniband/hw/mlx5/fs.c      | 7 +++++++
 drivers/scsi/sr.c                    | 2 ++
 8 files changed, 17 insertions(+), 4 deletions(-)

Christian König (1):
      drm/nouveau: fix dma_address check for CPU/GPU sync

Johannes Berg (1):
      gpio: AMD8111 and TQMX86 require HAS_IOPORT_MAP

Loic Poulain (1):
      gpio: mxc: Fix disabled interrupt wake-up support

ManYi Li (1):
      scsi: sr: Return appropriate error code when disk is ejected

Mark Bloch (1):
      RDMA/mlx5: Block FDB rules when not in switchdev mode

Sasha Levin (1):
      Linux 5.10.48

Sean Christopherson (1):
      Revert "KVM: x86/mmu: Drop kvm_mmu_extended_role.cr4_la57 hack"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAmDloocACgkQ3qZv95d3
LNxeRQ/9HzdDMiAxylshAGkKq+cx9Wxk3LdksMUWwfskZKnCs5rwCWT3zSafGDdX
bePEtdVsFGBEnKc0SZ2O/kR0plG967vGUSllB27QYa/e+QTCQt2JIn4X8J+s64hj
XS1Z39+sXYy6YNjam2DgPrG9nEDJLNkxO7E/4hhcPhToDXKtn2Zk+ZBpp3qVPOJa
cW/OXRSm0dlDWvDs8ELOzLoPpI67BMXUI+GhROZOgPP97aADbC2Tucy8QtAJilFa
jb5a8vZhvYIzmnKLcKNc+bACpbPtNyRq4glO/AeGlQHCIyZe06D5+fGQNU5r5oCy
DaViYl6sx/TpHHqSBcTnMmhCIbo5KPYvyMiYKlhEieAQDbuQX7VZSVRo2IANOqm3
yvX3A7vRRF5Pbvg2dGhubLlhB9tsP67/j9AZ14B5IIjapQAoLct19F1W5C7ochHr
CNyUAmusfneXyLb9ZOW1GRiP1oSiOB5NZMF380ObSqxQUP0YoH7A/H9YMGiiScyl
5jZzJ/bbQzQIjz72eyVca88wEWtpJynQDRTqRRbm3OPZ3C6OSXsOIB0X7RRfM/EF
PMMS7hH5INPvpsMvurgyHsUtlDm8JBe3nQUchf3bhqPHsRVJqwfO9IpCjwym1/o9
g7gVvaSl5airLyVJf8k4Q8WMNywkD92g8xE9Al51Rk3dn4uNYJk=
=4Xvv
-----END PGP SIGNATURE-----
