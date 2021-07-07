Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752833BE837
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 14:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhGGMui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 08:50:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231553AbhGGMui (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Jul 2021 08:50:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7FF861C73;
        Wed,  7 Jul 2021 12:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625662078;
        bh=0IWhJpUOVWhoNE4/iBF0fjtby+K3qDFe963p+2vsU1s=;
        h=From:To:Cc:Subject:Date:From;
        b=Y5yx8mY+STDnNsDwMAiSpzDjvGZJ5lc8AuQJJyDULCqhL80hCqZ8KeC6EG2aiLrAD
         LfUSIzl6uw4r6V/wqVqn4/w7K9ROIGdvXud6Jx9l7Z++eyeGoZ6ENhcP2GSiJ5Hwt/
         +hOnyMm6wLkuCNWAUjR8tL7ujUn9HIWd5vOWOPbfPZMd8BlDjbmgJOInUDRAZuJlfo
         8TyUzCpz7lx/JFwEpAMYUvQtJCEiZ6l/UqxI+46GtqWilEMGRbZFYYAyS+VUA5PIcF
         b4ywxGDa2RzfUYzMcL47LJdrvPYmDdRdvDjmN6MWdiKuYAT89hBMX7dKH4LeJfv6CL
         HQiUus14k+2ug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Linux 5.12.15
Date:   Wed,  7 Jul 2021 08:47:55 -0400
Message-Id: <20210707124756.2443365-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I'm announcing the release of the 5.12.15 kernel.

All users of the 5.12 kernel series must upgrade.

The updated 5.12.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.12.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary


Thanks,
Sasha

- ------------


 Makefile                             |  2 +-
 arch/x86/include/asm/kvm_host.h      |  1 +
 arch/x86/kvm/mmu/mmu.c               |  1 +
 drivers/gpio/Kconfig                 |  2 ++
 drivers/gpio/gpio-mxc.c              |  2 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c |  4 ++--
 drivers/s390/crypto/vfio_ap_ops.c    | 10 ----------
 drivers/scsi/sr.c                    |  2 ++
 8 files changed, 10 insertions(+), 14 deletions(-)

Christian König (1):
      drm/nouveau: fix dma_address check for CPU/GPU sync

Johannes Berg (1):
      gpio: AMD8111 and TQMX86 require HAS_IOPORT_MAP

Loic Poulain (1):
      gpio: mxc: Fix disabled interrupt wake-up support

ManYi Li (1):
      scsi: sr: Return appropriate error code when disk is ejected

Sasha Levin (1):
      Linux 5.12.15

Sean Christopherson (1):
      Revert "KVM: x86/mmu: Drop kvm_mmu_extended_role.cr4_la57 hack"

Tony Krowiak (1):
      s390/vfio-ap: clean up mdev resources when remove callback invoked

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAmDlonYACgkQ3qZv95d3
LNxTRQ/+KvXQgHRTDTcMYUU3hj6OkXbR2t/oz2lsWKdXFPqirN9TF5D0S7El1Xh7
PKhQmvozwKiJhfwE3J0QYmIkce5rm/DL2tcvrBHo4O1L883/xv5rd4St2JBHJ4ns
B3BgJ7VwdsxtVU8d2Rgogpxawwh4Tf1peSL08UwXgh3rF4554O9N6OuuSydFX552
Bd01LBkdmEhj0Wm1ma1WF5u86Pk/W8BYhtrUlcmpydAMnz3s5X459e8wSbKbP7Mp
vtPOx9MltRaqKRcyVH1Yb5Ryy6Q/TBKWtFfB9hnlMcU7VYAVCRxKxEFuMhia7ZES
DcmF8XRQx9+mnbvOlRXv0BMVSHbfbg9OjfZklCKJ6kTcyTODvCMx395UBVxNbiMB
pvc3XNUxx8bmO/LwzfP+7Bw74AQumpVMnS4aJkffaOPRxvep32NJ2QZUgU/nIs2Y
9EaToL+srZljcnCfR/KmCvpBbAuJp6cEcrd3SxhuSj42/1O/xa8tM+DflyoDUNXu
/EUbSt2ncGdcGy0DmLyIkV31YcWosdS9LIrqAjozbJXjaEdvfk9l0XxOvgb0udJF
MIEjrSmz7voMkd+8D1RjejzztcbCXNx8OhJNreOvCWaRrVSGv8+qtFOcKDAEKc4Q
dML5t7hGeusLY+KQ592vdGG0RAUpka6q/q48Pp70/jF0PS4GyhU=
=gaYx
-----END PGP SIGNATURE-----
