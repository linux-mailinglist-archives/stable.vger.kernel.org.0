Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEEE43BBBCC
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 13:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhGELCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 07:02:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231290AbhGELCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 07:02:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EC6D6135B;
        Mon,  5 Jul 2021 10:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482799;
        bh=doELrBf17KOzOhFD8w5jYXGQQLW6Vw7Yyk7YsskabtI=;
        h=From:To:Cc:Subject:Date:From;
        b=qWBTyrf5SjoYJ4RiNrHf118b24s/EQ38GQ7AzKdMgg+IOPw3v82DweAzVskLy7ADj
         CkzDZL0wfAUBNyJYJYUV/gIn9Krs6Ko9YP7NDOnmCwU15SDs/bHXsdBjUwG1DVD/y5
         FeG2lusPAQa+oEyNcbFcBRSgE8B3ZgaRmCfJF4f27FpngghvQlEdVduOuq4wy8Qsf5
         khbUbNjeIT5CjBSnbRFC3Tal3Jm2z1vfYJpv4KZCUY5d4aTPoe6vhgh/yA4IwZNYBE
         XQanRnQjzIfgUiQA8BHYN8Lw55STDxfZd//KKUnJ+/5Sr0Jauev6NT0qPBT9q+khuI
         euGFkquQHlSCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de
Subject: [PATCH 5.10 0/7] 5.10.48-rc1 review
Date:   Mon,  5 Jul 2021 06:59:50 -0400
Message-Id: <20210705105957.1513284-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.48-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.48-rc1
X-KernelTest-Deadline: 2021-07-07T10:59+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is the start of the stable review cycle for the 5.10.48 release.
There are 7 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 07 Jul 2021 10:59:49 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.10.y&id2=v5.10.47
or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

Thanks,
Sasha

-------------
Pseudo-Shortlog of commits:

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
  Linux 5.10.48-rc1

Sean Christopherson (1):
  Revert "KVM: x86/mmu: Drop kvm_mmu_extended_role.cr4_la57 hack"

 Makefile                             | 4 ++--
 arch/x86/include/asm/kvm_host.h      | 1 +
 arch/x86/kvm/mmu/mmu.c               | 1 +
 drivers/gpio/Kconfig                 | 2 ++
 drivers/gpio/gpio-mxc.c              | 2 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c | 4 ++--
 drivers/infiniband/hw/mlx5/fs.c      | 7 +++++++
 drivers/scsi/sr.c                    | 2 ++
 8 files changed, 18 insertions(+), 5 deletions(-)

-- 
2.30.2

