Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3758AF540D
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 19:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfKHSxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:53:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:50622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732632AbfKHSxu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:53:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 155912178F;
        Fri,  8 Nov 2019 18:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239228;
        bh=FzYIPp5nwqOQVjismqwhXZRrHO+7PVam12mEDWsJeZ8=;
        h=From:To:Cc:Subject:Date:From;
        b=I16t1BCGh9wwJEItOXRXiUYWS2abICuuxVEN/UxSd+47WCOqjRAzj3fzOi48l0sQp
         C88qvRLFR4o1EIA93uSUOkKrklaaJoW5ecaRdJudXuJHVSk4NNlC7F1XPrHlJ4zYGY
         01e5kyq1z4VJVHulpzsaDaXHa+b04Omu1xlKC9ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/75] 4.4.200-stable review
Date:   Fri,  8 Nov 2019 19:49:17 +0100
Message-Id: <20191108174708.135680837@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.200-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.200-rc1
X-KernelTest-Deadline: 2019-11-10T17:48+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.200 release.
There are 75 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun 10 Nov 2019 05:42:11 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.200-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.200-rc1

zhangyi (F) <yi.zhang@huawei.com>
    fs/dcache: move security_d_instantiate() behind attaching dentry to inode

Petr Vorel <pvorel@suse.cz>
    alarmtimer: Change remaining ENOTSUPP to EOPNOTSUPP

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: fix the cockup in the previous patch

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: ensure that processor vtables is not lost after boot

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: spectre-v2: per-CPU vtables to work around big.Little systems

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: add PROC_VTABLE and PROC_TABLE macros

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: clean up per-processor check_bugs method call

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: split out processor lookup

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: make lookup_processor_type() non-__init

Julien Thierry <julien.thierry@arm.com>
    ARM: 8810/1: vfp: Fix wrong assignement to ufp_exc

Julien Thierry <julien.thierry@arm.com>
    ARM: 8796/1: spectre-v1,v1.1: provide helpers for address sanitization

Julien Thierry <julien.thierry@arm.com>
    ARM: 8795/1: spectre-v1.1: use put_user() for __put_user()

Julien Thierry <julien.thierry@arm.com>
    ARM: 8794/1: uaccess: Prevent speculative use of the current addr_limit

Julien Thierry <julien.thierry@arm.com>
    ARM: 8793/1: signal: replace __put_user_error with __put_user

Julien Thierry <julien.thierry@arm.com>
    ARM: 8792/1: oabi-compat: copy oabi events using __copy_to_user()

Julien Thierry <julien.thierry@arm.com>
    ARM: 8791/1: vfp: use __copy_to_user() when saving VFP state

Julien Thierry <julien.thierry@arm.com>
    ARM: 8789/1: signal: copy registers using __copy_to_user()

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: spectre-v1: mitigate user accesses

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: spectre-v1: use get_user() for __get_user()

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: use __inttype() in get_user()

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: oabi-compat: copy semops using __copy_from_user()

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: vfp: use __copy_from_user() when restoring VFP state

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: signal: copy registers using __copy_from_user()

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: spectre-v1: fix syscall entry

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: spectre-v1: add array_index_mask_nospec() implementation

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: spectre-v1: add speculation barrier (csdb) macros

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: spectre-v2: warn about incorrect context switching functions

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: spectre-v2: add firmware based hardening

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: spectre-v2: harden user aborts in kernel space

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: spectre-v2: add Cortex A8 and A15 validation of the IBE bit

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: spectre-v2: harden branch predictor on context switches

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: spectre: add Kconfig symbol for CPUs vulnerable to Spectre

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: bugs: add support for per-processor bug checking

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: bugs: hook processor bug checking into SMP and suspend paths

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: bugs: prepare processor bug infrastructure

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: add more CPU part numbers for Cortex and Brahma B15 CPUs

Marc Zyngier <marc.zyngier@arm.com>
    arm/arm64: smccc-1.1: Handle function result as parameters

Marc Zyngier <marc.zyngier@arm.com>
    arm/arm64: smccc-1.1: Make return values unsigned long

Marc Zyngier <marc.zyngier@arm.com>
    arm/arm64: smccc: Add SMCCC-specific return codes

Marc Zyngier <marc.zyngier@arm.com>
    arm/arm64: smccc: Implement SMCCC v1.1 inline primitive

Marc Zyngier <marc.zyngier@arm.com>
    arm/arm64: smccc: Make function identifiers an unsigned quantity

Marc Zyngier <marc.zyngier@arm.com>
    firmware/psci: Expose SMCCC version through psci_ops

Marc Zyngier <marc.zyngier@arm.com>
    firmware/psci: Expose PSCI conduit

Marc Zyngier <marc.zyngier@arm.com>
    arm64: KVM: Report SMCCC_ARCH_WORKAROUND_1 BP hardening support

Marc Zyngier <marc.zyngier@arm.com>
    arm/arm64: KVM: Advertise SMCCC v1.1

Vladimir Murzin <vladimir.murzin@arm.com>
    ARM: Move system register accessors to asm/cp15.h

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: uaccess: remove put_user() code duplication

Jens Wiklander <jens.wiklander@linaro.org>
    ARM: 8481/2: drivers: psci: replace psci firmware calls

Jens Wiklander <jens.wiklander@linaro.org>
    ARM: 8480/2: arm64: add implementation for arm-smccc

Jens Wiklander <jens.wiklander@linaro.org>
    ARM: 8479/2: add implementation for arm-smccc

Jens Wiklander <jens.wiklander@linaro.org>
    ARM: 8478/2: arm/arm64: add arm-smccc

Andrey Ryabinin <ryabinin.a.a@gmail.com>
    ARM: 8051/1: put_user: fix possible data corruption in put_user

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    dmaengine: qcom: bam_dma: Fix resource leak

Eric Dumazet <edumazet@google.com>
    net/flow_dissector: switch to siphash

Eric Dumazet <edumazet@google.com>
    inet: stop leaking jiffies on the wire

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx4_core: Dynamically set guaranteed amount of counters per VF

Xin Long <lucien.xin@gmail.com>
    vxlan: check tun_info options_len properly

Eric Dumazet <edumazet@google.com>
    net: add READ_ONCE() annotation in __skb_wait_for_more_packets()

zhanglin <zhang.lin16@zte.com.cn>
    net: Zeroing the structure ethtool_wolinfo in ethtool_get_wol()

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    net: hisilicon: Fix ping latency when deal with high throughput

Tejun Heo <tj@kernel.org>
    net: fix sk_page_frag() recursion from memory reclaim

Eric Dumazet <edumazet@google.com>
    dccp: do not leak jiffies on the wire

Dave Wysochanski <dwysocha@redhat.com>
    cifs: Fix cifsInodeInfo lock_sem deadlock when reconnect occurs

Jonas Gorski <jonas.gorski@gmail.com>
    MIPS: bmips: mark exception vectors as char arrays

Navid Emamdoost <navid.emamdoost@gmail.com>
    of: unittest: fix memory leak in unittest_data_add

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: core: Do not overwrite CDB byte 1

Yunfeng Ye <yeyunfeng@huawei.com>
    perf kmem: Fix memory leak in compact_gfp_flags()

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    scsi: fix kconfig dependency warning related to 53C700_LE_ON_BE

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    scsi: sni_53c710: fix compilation error

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: mm: fix alignment handler faults under memory pressure

Adam Ford <aford173@gmail.com>
    ARM: dts: logicpd-torpedo-som: Remove twl_keypad

Robin Murphy <robin.murphy@arm.com>
    ASoc: rockchip: i2s: Fix RPM imbalance

Yizhuo <yzhai003@ucr.edu>
    regulator: pfuze100-regulator: Variable "val" in pfuze100_regulator_probe() could be uninitialized

Axel Lin <axel.lin@ingics.com>
    regulator: ti-abb: Fix timeout in ti_abb_wait_txdone/ti_abb_clear_all_txdone

Seth Forshee <seth.forshee@canonical.com>
    kbuild: add -fcf-protection=none when using retpoline flags


-------------

Diffstat:

 Makefile                                           |  10 +-
 arch/arm/Kconfig                                   |   3 +-
 arch/arm/boot/dts/logicpd-torpedo-som.dtsi         |   4 +
 arch/arm/include/asm/arch_gicv3.h                  |  27 +-
 arch/arm/include/asm/assembler.h                   |  23 ++
 arch/arm/include/asm/barrier.h                     |  34 +++
 arch/arm/include/asm/bugs.h                        |   6 +-
 arch/arm/include/asm/cp15.h                        |  18 ++
 arch/arm/include/asm/cputype.h                     |   9 +
 arch/arm/include/asm/proc-fns.h                    |  65 ++++-
 arch/arm/include/asm/system_misc.h                 |  15 ++
 arch/arm/include/asm/thread_info.h                 |   8 +-
 arch/arm/include/asm/uaccess.h                     | 177 ++++++++-----
 arch/arm/kernel/Makefile                           |   4 +-
 arch/arm/kernel/armksyms.c                         |   6 +
 arch/arm/kernel/bugs.c                             |  18 ++
 arch/arm/kernel/entry-common.S                     |  18 +-
 arch/arm/kernel/entry-header.S                     |  25 ++
 arch/arm/kernel/head-common.S                      |   6 +-
 arch/arm/kernel/psci-call.S                        |  31 ---
 arch/arm/kernel/setup.c                            |  40 +--
 arch/arm/kernel/signal.c                           | 125 ++++-----
 arch/arm/kernel/smccc-call.S                       |  62 +++++
 arch/arm/kernel/smp.c                              |  36 +++
 arch/arm/kernel/suspend.c                          |   2 +
 arch/arm/kernel/sys_oabi-compat.c                  |  16 +-
 arch/arm/lib/copy_from_user.S                      |   5 +
 arch/arm/mm/Kconfig                                |  23 ++
 arch/arm/mm/Makefile                               |   2 +-
 arch/arm/mm/alignment.c                            |  44 +++-
 arch/arm/mm/fault.c                                |   3 +
 arch/arm/mm/proc-macros.S                          |  13 +-
 arch/arm/mm/proc-v7-2level.S                       |   6 -
 arch/arm/mm/proc-v7-bugs.c                         | 161 ++++++++++++
 arch/arm/mm/proc-v7.S                              | 154 ++++++++---
 arch/arm/vfp/vfpmodule.c                           |  37 ++-
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/kernel/Makefile                         |   4 +-
 arch/arm64/kernel/arm64ksyms.c                     |   5 +
 arch/arm64/kernel/asm-offsets.c                    |   3 +
 arch/arm64/kernel/psci-call.S                      |  28 --
 arch/arm64/kernel/smccc-call.S                     |  43 ++++
 arch/mips/bcm63xx/prom.c                           |   2 +-
 arch/mips/include/asm/bmips.h                      |  10 +-
 arch/mips/kernel/smp-bmips.c                       |   8 +-
 drivers/dma/qcom_bam_dma.c                         |  14 +
 drivers/firmware/Kconfig                           |   3 +
 drivers/firmware/psci.c                            |  78 +++++-
 drivers/net/ethernet/hisilicon/hip04_eth.c         |  15 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  42 +--
 drivers/net/vxlan.c                                |   5 +-
 drivers/of/unittest.c                              |   1 +
 drivers/regulator/pfuze100-regulator.c             |   8 +-
 drivers/regulator/ti-abb-regulator.c               |  26 +-
 drivers/scsi/Kconfig                               |   2 +-
 drivers/scsi/sni_53c710.c                          |   4 +-
 drivers/target/target_core_device.c                |  21 --
 fs/cifs/cifsglob.h                                 |   5 +
 fs/cifs/cifsproto.h                                |   1 +
 fs/cifs/file.c                                     |  23 +-
 fs/cifs/smb2file.c                                 |   2 +-
 fs/dcache.c                                        |   2 +-
 include/linux/arm-smccc.h                          | 283 +++++++++++++++++++++
 include/linux/gfp.h                                |  23 ++
 include/linux/psci.h                               |  13 +
 include/linux/skbuff.h                             |   3 +-
 include/net/flow_dissector.h                       |   3 +-
 include/net/sock.h                                 |  11 +-
 kernel/time/alarmtimer.c                           |   4 +-
 net/core/datagram.c                                |   2 +-
 net/core/ethtool.c                                 |   4 +-
 net/core/flow_dissector.c                          |  48 ++--
 net/dccp/ipv4.c                                    |   4 +-
 net/ipv4/datagram.c                                |   2 +-
 net/ipv4/tcp_ipv4.c                                |   4 +-
 net/sched/sch_fq_codel.c                           |   6 +-
 net/sched/sch_hhf.c                                |   8 +-
 net/sched/sch_sfb.c                                |  13 +-
 net/sched/sch_sfq.c                                |  14 +-
 net/sctp/socket.c                                  |   2 +-
 sound/soc/rockchip/rockchip_i2s.c                  |   2 +-
 tools/perf/builtin-kmem.c                          |   1 +
 82 files changed, 1556 insertions(+), 486 deletions(-)


