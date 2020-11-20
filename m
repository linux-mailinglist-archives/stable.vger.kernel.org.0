Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8382BA89A
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgKTLGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:06:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728433AbgKTLGp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:06:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9165A2222F;
        Fri, 20 Nov 2020 11:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870403;
        bh=mhwq9ZnCQPYBv6TgsKy3PVBeNOl7gK9R3k1tN5wCTzE=;
        h=From:To:Cc:Subject:Date:From;
        b=C4vr5UrnVCsX0mpPKp1FlXVE0ziEyRE3BAu3+y8r+nEXFb771L9cvAxPjxkvG7lzQ
         E2e2wx5rS7r57t+PsHkzdCU9N1khw1psbfdUi9dOpnBCabKAGVHlRIoJjnrKbJCz4Y
         1sA/axJPqdqMyUqFtEMutfPI8lcZ1U5uemjQatvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.4 00/17] 5.4.79-rc1 review
Date:   Fri, 20 Nov 2020 12:03:27 +0100
Message-Id: <20201120104541.058449969@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.79-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.79-rc1
X-KernelTest-Deadline: 2020-11-22T10:45+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.79 release.
There are 17 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.79-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.79-rc1

Nick Desaulniers <ndesaulniers@google.com>
    ACPI: GED: fix -Wformat

David Edmondson <david.edmondson@oracle.com>
    KVM: x86: clflushopt should be treated as a no-op by emulation

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: proc: can_remove_proc(): silence remove_proc_entry warning

Johannes Berg <johannes.berg@intel.com>
    mac80211: always wind down STA state

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: sunkbd - avoid use-after-free in teardown paths

Hauke Mehrtens <hauke@hauke-m.de>
    net: lantiq: Add locking for TX DMA channel

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/8xx: Always fault when _PAGE_ACCESSED is not set

Eran Ben Elisha <eranbe@nvidia.com>
    net/mlx5: Add retry mechanism to the command entry index allocation

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx5: Fix a race when moving command interface to events mode

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx5: poll cmd EQ in case of command timeout

Parav Pandit <parav@mellanox.com>
    net/mlx5: Use async EQ setup cleanup helpers for multiple EQs

Sudip Mukherjee <sudipm.mukherjee@gmail.com>
    MIPS: PCI: Fix MIPS build

Daniel Axtens <dja@axtens.net>
    selftests/powerpc: entry flush test

Michael Ellerman <mpe@ellerman.id.au>
    powerpc: Only include kup-radix.h for 64-bit Book3S

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: flush L1D after user accesses

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: flush L1D on kernel entry

Russell Currey <ruscur@russell.cc>
    selftests/powerpc: rfi_flush: disable entry flush if present


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   7 +
 Makefile                                           |   4 +-
 arch/mips/pci/pci-xtalk-bridge.c                   |   2 +-
 arch/powerpc/include/asm/book3s/64/kup-radix.h     |  29 ++--
 arch/powerpc/include/asm/exception-64s.h           |  12 +-
 arch/powerpc/include/asm/feature-fixups.h          |  19 +++
 arch/powerpc/include/asm/kup.h                     |  27 +++-
 arch/powerpc/include/asm/security_features.h       |   7 +
 arch/powerpc/include/asm/setup.h                   |   4 +
 arch/powerpc/kernel/exceptions-64s.S               |  88 +++++------
 arch/powerpc/kernel/head_8xx.S                     |  14 +-
 arch/powerpc/kernel/setup_64.c                     | 122 ++++++++++++++-
 arch/powerpc/kernel/vmlinux.lds.S                  |  14 ++
 arch/powerpc/lib/feature-fixups.c                  | 104 +++++++++++++
 arch/powerpc/platforms/powernv/setup.c             |  17 +++
 arch/powerpc/platforms/pseries/setup.c             |   8 +
 arch/x86/kvm/emulate.c                             |   8 +-
 drivers/acpi/evged.c                               |   2 +-
 drivers/input/keyboard/sunkbd.c                    |  41 +++++-
 drivers/net/ethernet/lantiq_xrx200.c               |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 109 ++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       | 157 +++++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h   |   2 +
 include/linux/mlx5/driver.h                        |   6 +
 net/can/proc.c                                     |   6 +-
 net/mac80211/sta_info.c                            |  18 +++
 .../testing/selftests/powerpc/security/.gitignore  |   1 +
 tools/testing/selftests/powerpc/security/Makefile  |   2 +-
 .../selftests/powerpc/security/entry_flush.c       | 163 +++++++++++++++++++++
 .../testing/selftests/powerpc/security/rfi_flush.c |  35 ++++-
 30 files changed, 857 insertions(+), 173 deletions(-)


