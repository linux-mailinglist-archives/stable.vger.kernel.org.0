Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6684E28C4
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348534AbiCUOAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348867AbiCUN6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:58:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E00A32EC0;
        Mon, 21 Mar 2022 06:56:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7253F612E7;
        Mon, 21 Mar 2022 13:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48082C340E8;
        Mon, 21 Mar 2022 13:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647870980;
        bh=GIySdX0GoUtoMhXCOfMx1UfFLtCaYOMsX8yWqXSSXQ8=;
        h=From:To:Cc:Subject:Date:From;
        b=oJuysbjZeWh1cwTjbrddVjjWqBN9zjuPFg5yzQbNjDaMi1tzAhxZlhNSWaAxH16me
         QHKJpg/AumfO4VfGFMa63lRpwQtaj19kR5hinqmB5GFq8QQc2T2nIVabxntYFa3Glj
         fsy58aJmeozrYykfYd4i7LPCy+U197koCLmPsoYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.19 00/57] 4.19.236-rc1 review
Date:   Mon, 21 Mar 2022 14:51:41 +0100
Message-Id: <20220321133221.984120927@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.236-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.236-rc1
X-KernelTest-Deadline: 2022-03-23T13:32+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.236 release.
There are 57 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.236-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.236-rc1

Michael Petlan <mpetlan@redhat.com>
    perf symbols: Fix symbol size calculation condition

Pavel Skripkin <paskripkin@gmail.com>
    Input: aiptek - properly check endpoint type

Alan Stern <stern@rowland.harvard.edu>
    usb: gadget: Fix use-after-free bug by not setting udc->dev.driver

Dan Carpenter <dan.carpenter@oracle.com>
    usb: gadget: rndis: prevent integer overflow in rndis_set_response()

Miaoqian Lin <linmq006@gmail.com>
    net: dsa: Add missing of_node_put() in dsa_port_parse_of

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    net: handle ARPHRD_PIMREG in dev_is_mac_header_xmit()

Marek Vasut <marex@denx.de>
    drm/panel: simple: Fix Innolux G070Y2-L01 BPP settings

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    hv_netvsc: Add check for kvmalloc_array

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    atm: eni: Add check for dma_map_single

Eric Dumazet <edumazet@google.com>
    net/packet: fix slab-out-of-bounds access in packet_recvmsg()

Randy Dunlap <rdunlap@infradead.org>
    efi: fix return value of __setup handlers

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix crash when initialize filecheck kobj fails

Brian Masney <bmasney@redhat.com>
    crypto: qcom-rng - ensure buffer for generate is completely filled

James Morse <james.morse@arm.com>
    arm64: Use the clearbhb instruction in mitigations

Joey Gouly <joey.gouly@arm.com>
    arm64: add ID_AA64ISAR2_EL1 sys register

James Morse <james.morse@arm.com>
    KVM: arm64: Allow SMCCC_ARCH_WORKAROUND_3 to be discovered and migrated

James Morse <james.morse@arm.com>
    arm64: Mitigate spectre style branch history side channels

James Morse <james.morse@arm.com>
    KVM: arm64: Add templates for BHB mitigation sequences

James Morse <james.morse@arm.com>
    arm64: proton-pack: Report Spectre-BHB vulnerabilities as part of Spectre-v2

James Morse <james.morse@arm.com>
    arm64: Add percpu vectors for EL1

James Morse <james.morse@arm.com>
    arm64: entry: Add macro for reading symbol addresses from the trampoline

James Morse <james.morse@arm.com>
    arm64: entry: Add vectors that have the bhb mitigation sequences

James Morse <james.morse@arm.com>
    arm64: entry: Add non-kpti __bp_harden_el1_vectors for mitigations

James Morse <james.morse@arm.com>
    arm64: entry: Allow the trampoline text to occupy multiple pages

James Morse <james.morse@arm.com>
    arm64: entry: Make the kpti trampoline's kpti sequence optional

James Morse <james.morse@arm.com>
    arm64: entry: Move trampoline macros out of ifdef'd section

James Morse <james.morse@arm.com>
    arm64: entry: Don't assume tramp_vectors is the start of the vectors

James Morse <james.morse@arm.com>
    arm64: entry: Allow tramp_alias to access symbols after the 4K boundary

James Morse <james.morse@arm.com>
    arm64: entry: Move the trampoline data page before the text page

James Morse <james.morse@arm.com>
    arm64: entry: Free up another register on kpti's tramp_exit path

James Morse <james.morse@arm.com>
    arm64: entry: Make the trampoline cleanup optional

James Morse <james.morse@arm.com>
    arm64: entry.S: Add ventry overflow sanity checks

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64: Add Cortex-X2 CPU part definition

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: Add Neoverse-N2, Cortex-A710 CPU part definition

Rob Herring <robh@kernel.org>
    arm64: Add part number for Arm Cortex-A77

Lucas Wei <lucaswei@google.com>
    fs: sysfs_emit: Remove PAGE_SIZE alignment check

liqiong <liqiong@nfschina.com>
    mm: fix dereference a null pointer in migrate[_huge]_page_move_mapping()

Zhang Qiao <zhangqiao22@huawei.com>
    cpuset: Fix unsafe lock order between cpuset lock and cpuslock

Valentin Schneider <valentin.schneider@arm.com>
    ia64: ensure proper NUMA distance and possible map initialization

Dietmar Eggemann <dietmar.eggemann@arm.com>
    sched/topology: Fix sched_domain_topology_level alloc in sched_init_numa()

Valentin Schneider <valentin.schneider@arm.com>
    sched/topology: Make sched_init_numa() use a set for the deduplicating sort

Chengming Zhou <zhouchengming@bytedance.com>
    kselftest/vm: fix tests build with old libc

Niels Dossche <dossche.niels@gmail.com>
    sfc: extend the locking on mcdi->seqno

Eric Dumazet <edumazet@google.com>
    tcp: make tcp_read_sock() more robust

Sreeramya Soratkal <quic_ssramya@quicinc.com>
    nl80211: Update bss channel on channel switch for P2P_CLIENT

Jia-Ju Bai <baijiaju1990@gmail.com>
    atm: firestream: check the return value of ioremap() in fs_init()

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    can: rcar_canfd: rcar_canfd_channel_probe(): register the CAN device when fully ready

Julian Braha <julianbraha@gmail.com>
    ARM: 9178/1: fix unmet dependency on BITREVERSE for HAVE_ARCH_BITREVERSE

Alexander Lobakin <alobakin@pm.me>
    MIPS: smp: fill in sibling and core maps earlier

Corentin Labbe <clabbe@baylibre.com>
    ARM: dts: rockchip: fix a typo on rk3288 crypto-controller

Sascha Hauer <s.hauer@pengutronix.de>
    arm64: dts: rockchip: reorder rk3399 hdmi clocks

Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
    arm64: dts: rockchip: fix rk3399-puma eMMC HS400 signal integrity

Yan Yan <evitayan@google.com>
    xfrm: Fix xfrm migrate issues when address family changes

Yan Yan <evitayan@google.com>
    xfrm: Check if_id in xfrm_migrate

Xin Long <lucien.xin@gmail.com>
    sctp: fix the processing for INIT_ACK chunk

Xin Long <lucien.xin@gmail.com>
    sctp: fix the processing for INIT chunk

Kai Lueke <kailueke@linux.microsoft.com>
    Revert "xfrm: state and policy should fail if XFRMA_IF_ID 0"


-------------

Diffstat:

 Makefile                                      |   4 +-
 arch/arm/boot/dts/rk3288.dtsi                 |   2 +-
 arch/arm/include/asm/kvm_host.h               |   7 +
 arch/arm64/Kconfig                            |   9 +
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi |   6 +
 arch/arm64/boot/dts/rockchip/rk3399.dtsi      |   6 +-
 arch/arm64/include/asm/assembler.h            |  34 +++
 arch/arm64/include/asm/cpu.h                  |   1 +
 arch/arm64/include/asm/cpucaps.h              |   3 +-
 arch/arm64/include/asm/cpufeature.h           |  39 +++
 arch/arm64/include/asm/cputype.h              |  16 ++
 arch/arm64/include/asm/fixmap.h               |   6 +-
 arch/arm64/include/asm/kvm_host.h             |   5 +
 arch/arm64/include/asm/kvm_mmu.h              |   6 +-
 arch/arm64/include/asm/mmu.h                  |   8 +-
 arch/arm64/include/asm/sections.h             |   5 +
 arch/arm64/include/asm/sysreg.h               |   5 +
 arch/arm64/include/asm/vectors.h              |  74 +++++
 arch/arm64/kernel/cpu_errata.c                | 381 +++++++++++++++++++++++++-
 arch/arm64/kernel/cpufeature.c                |  21 ++
 arch/arm64/kernel/cpuinfo.c                   |   1 +
 arch/arm64/kernel/entry.S                     | 213 ++++++++++----
 arch/arm64/kernel/vmlinux.lds.S               |   2 +-
 arch/arm64/kvm/hyp/hyp-entry.S                |  64 +++++
 arch/arm64/kvm/hyp/switch.c                   |   8 +-
 arch/arm64/kvm/sys_regs.c                     |   2 +-
 arch/arm64/mm/mmu.c                           |  12 +-
 arch/ia64/kernel/acpi.c                       |   7 +-
 arch/mips/kernel/smp.c                        |   6 +-
 drivers/atm/eni.c                             |   2 +
 drivers/atm/firestream.c                      |   2 +
 drivers/crypto/qcom-rng.c                     |  17 +-
 drivers/firmware/efi/apple-properties.c       |   2 +-
 drivers/firmware/efi/efi.c                    |   2 +-
 drivers/gpu/drm/panel/panel-simple.c          |   2 +-
 drivers/input/tablet/aiptek.c                 |  10 +-
 drivers/net/can/rcar/rcar_canfd.c             |   6 +-
 drivers/net/ethernet/sfc/mcdi.c               |   2 +-
 drivers/net/hyperv/netvsc_drv.c               |   3 +
 drivers/usb/gadget/function/rndis.c           |   1 +
 drivers/usb/gadget/udc/core.c                 |   3 -
 fs/ocfs2/super.c                              |  22 +-
 fs/sysfs/file.c                               |   3 +-
 include/linux/arm-smccc.h                     |   7 +
 include/linux/if_arp.h                        |   1 +
 include/linux/topology.h                      |   1 +
 include/net/xfrm.h                            |   5 +-
 kernel/cgroup/cpuset.c                        |   8 +-
 kernel/sched/topology.c                       |  99 ++++---
 lib/Kconfig                                   |   1 -
 mm/migrate.c                                  |   8 +
 net/dsa/dsa2.c                                |   1 +
 net/ipv4/tcp.c                                |  10 +-
 net/key/af_key.c                              |   2 +-
 net/packet/af_packet.c                        |  11 +-
 net/sctp/sm_statefuns.c                       | 108 +++++---
 net/wireless/nl80211.c                        |   3 +-
 net/xfrm/xfrm_policy.c                        |  14 +-
 net/xfrm/xfrm_state.c                         |  15 +-
 net/xfrm/xfrm_user.c                          |  27 +-
 tools/perf/util/symbol.c                      |   2 +-
 tools/testing/selftests/vm/userfaultfd.c      |   1 +
 virt/kvm/arm/psci.c                           |  12 +
 63 files changed, 1112 insertions(+), 254 deletions(-)


