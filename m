Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26083521945
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241252AbiEJNmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244594AbiEJNhv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:37:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6984ECC6;
        Tue, 10 May 2022 06:25:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 282B961767;
        Tue, 10 May 2022 13:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E323AC385A6;
        Tue, 10 May 2022 13:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189156;
        bh=OaS6iaCqrrj8J16UUIJbA4VimOLoOYphmNhPjhSXE4Y=;
        h=From:To:Cc:Subject:Date:From;
        b=h27MtRKWNj+EKZdH2CHgwWc21swPdmtg07pNf0Wf1cE6yebHLLuZCyT0r3YbaxKZh
         4TxWWbaAShUDjzJKxGERnp7dLjghgLlLpApLCEpQ9GT9yABBhAcRaH7QPpn2I1LvXB
         BsyqPZIRzUn3E5kG6n9dpmA8++AFyxaLrtPAlb0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/70] 5.10.115-rc1 review
Date:   Tue, 10 May 2022 15:07:19 +0200
Message-Id: <20220510130732.861729621@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.115-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.115-rc1
X-KernelTest-Deadline: 2022-05-12T13:07+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.115 release.
There are 70 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.115-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.115-rc1

Ricky WU <ricky_wu@realtek.com>
    mmc: rtsx: add 74 Clocks in power on flow

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix reading MSI interrupt number

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Clear all MSIs at setup

Mike Snitzer <snitzer@redhat.com>
    dm: interlock pending dm_io and dm_wait_for_bios_completion

Haimin Zhang <tcs.kernel@gmail.com>
    block-map: add __GFP_ZERO flag for alloc_page in function bio_copy_kern

Frederic Weisbecker <frederic@kernel.org>
    rcu: Apply callbacks processing time limit only on softirq

Frederic Weisbecker <frederic@kernel.org>
    rcu: Fix callbacks processing time limit retaining cond_resched()

Wanpeng Li <wanpengli@tencent.com>
    KVM: LAPIC: Enable timer posted-interrupt only when mwait/hlt is advertised

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86/mmu: avoid NULL-pointer dereference on page freeing bugs

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: Do not change ICR on write to APIC_SELF_IPI

Wanpeng Li <wanpengli@tencent.com>
    x86/kvm: Preserve BSP MSR_KVM_POLL_CONTROL across suspend/resume

Aya Levin <ayal@nvidia.com>
    net/mlx5: Fix slab-out-of-bounds while reading resource dump menu

Sandipan Das <sandipan.das@amd.com>
    kvm: x86/cpuid: Only provide CPUID leaf 0xA if host has architectural PMU

Eric Dumazet <edumazet@google.com>
    net: igmp: respect RCU rules in ip_mc_source() and ip_mc_msfilter()

Filipe Manana <fdmanana@suse.com>
    btrfs: always log symlinks in full mode

Sergey Shtylyov <s.shtylyov@omp.ru>
    smsc911x: allow using IRQ0

Vladimir Oltean <vladimir.oltean@nxp.com>
    selftests: ocelot: tc_flower_chains: specify conform-exceed action for policer

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix unnecessary dropping of RX packets

Somnath Kotur <somnath.kotur@broadcom.com>
    bnxt_en: Fix possible bnxt_open() failure caused by wrong RFS flag

Ido Schimmel <idosch@nvidia.com>
    selftests: mirror_gre_bridge_1q: Avoid changing PVID while interface is operational

Qiao Ma <mqaio@linux.alibaba.com>
    hinic: fix bug of wq out of bound access

Shravya Kumbham <shravya.kumbham@xilinx.com>
    net: emaclite: Add error handling for of_address_to_resource()

Yang Yingliang <yangyingliang@huawei.com>
    net: cpsw: add missing of_node_put() in cpsw_probe_dt()

Yang Yingliang <yangyingliang@huawei.com>
    net: stmmac: dwmac-sun8i: add missing of_node_put() in sun8i_dwmac_register_mdio_mux()

Yang Yingliang <yangyingliang@huawei.com>
    net: dsa: mt7530: add missing of_node_put() in mt7530_setup()

Yang Yingliang <yangyingliang@huawei.com>
    net: ethernet: mediatek: add missing of_node_put() in mtk_sgmii_init()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Don't invalidate inode attributes on delegation return

Cheng Xu <chengyou@linux.alibaba.com>
    RDMA/siw: Fix a condition race issue in MPA request processing

Jann Horn <jannh@google.com>
    selftests/seccomp: Don't call read() on TTY from background pgrp

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Avoid double clear or set of sync reset requested

Mark Zhang <markzhang@nvidia.com>
    net/mlx5e: Fix the calling of update_buffer_lossy() API

Paul Blakey <paulb@nvidia.com>
    net/mlx5e: CT: Fix queued up restore put() executing after relevant ft release

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5e: Don't match double-vlan packets if cvlan is not set

Moshe Tal <moshet@nvidia.com>
    net/mlx5e: Fix trust state reset in reload

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    ASoC: dmaengine: Restore NULL prepare_slave_config() callback

Armin Wolf <W_Armin@gmx.de>
    hwmon: (adt7470) Fix warning on module removal

Puyou Lu <puyou.lu@gmail.com>
    gpio: pca953x: fix irq_stat not updated when irq is disabled (irq_mask not set)

Duoming Zhou <duoming@zju.edu.cn>
    NFC: netlink: fix sleep in atomic bug when firmware download timeout

Duoming Zhou <duoming@zju.edu.cn>
    nfc: nfcmrvl: main: reorder destructive operations in nfcmrvl_nci_unregister_dev to avoid bugs

Duoming Zhou <duoming@zju.edu.cn>
    nfc: replace improper check device_is_registered() in netlink related functions

Andreas Larsson <andreas@gaisler.com>
    can: grcan: only use the NAPI poll budget for RX

Andreas Larsson <andreas@gaisler.com>
    can: grcan: grcan_probe(): fix broken system id check for errata workaround needs

Daniel Hellstrom <daniel@gaisler.com>
    can: grcan: use ofdev->dev when allocating DMA memory

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: remove re-binding of bound socket

Duoming Zhou <duoming@zju.edu.cn>
    can: grcan: grcan_close(): fix deadlock

Jan Höppner <hoeppner@linux.ibm.com>
    s390/dasd: Fix read inconsistency for ESE DASD devices

Jan Höppner <hoeppner@linux.ibm.com>
    s390/dasd: Fix read for ESE with blksize < 4k

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: prevent double format of tracks for ESE devices

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix data corruption for ESE devices

Mark Brown <broonie@kernel.org>
    ASoC: meson: Fix event generation for AUI CODEC mux

Mark Brown <broonie@kernel.org>
    ASoC: meson: Fix event generation for G12A tohdmi mux

Mark Brown <broonie@kernel.org>
    ASoC: meson: Fix event generation for AUI ACODEC mux

Mark Brown <broonie@kernel.org>
    ASoC: wm8958: Fix change notifications for DSP controls

Mark Brown <broonie@kernel.org>
    ASoC: da7219: Fix change notifications for tone generator frequency

Thomas Pfaff <tpfaff@pcs.com>
    genirq: Synchronize interrupt thread startup

Tan Tee Min <tee.min.tan@linux.intel.com>
    net: stmmac: disable Split Header (SPH) for Intel platforms

Niels Dossche <dossche.niels@gmail.com>
    firewire: core: extend card->lock in fw_core_handle_bus_reset

Jakob Koschel <jakobkoschel@gmail.com>
    firewire: remove check of list iterator against head past the loop body

Chengfeng Ye <cyeaa@connect.ust.hk>
    firewire: fix potential uaf in outbound_phy_packet_callback()

Trond Myklebust <trond.myklebust@hammerspace.com>
    Revert "SUNRPC: attempt AF_LOCAL connect on setup"

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Avoid reading audio pattern past AUDIO_CHANNELS_COUNT

David Stevens <stevensd@chromium.org>
    iommu/vt-d: Calculate mask for non-aligned flushes

Kyle Huey <me@kylehuey.com>
    KVM: x86/svm: Account for family 17h event renumberings in amd_pmc_perf_hw_id

Andrei Lalaev <andrei.lalaev@emlid.com>
    gpiolib: of: fix bounds check for 'gpio-reserved-ranges'

Brian Norris <briannorris@chromium.org>
    mmc: core: Set HS clock speed before sending HS CMD13

Shaik Sajida Bhanu <quic_c_sbhanu@quicinc.com>
    mmc: sdhci-msm: Reset GCC_SDCC_BCR register for SDHC

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: fireworks: fix wrong return count shorter than expected by 4 bytes

Zihao Wang <wzhd@ustc.edu>
    ALSA: hda/realtek: Add quirk for Yoga Duet 7 13ITL6 speakers

Helge Deller <deller@gmx.de>
    parisc: Merge model and model name into one line in /proc/cpuinfo

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Fix CP0 counter erratum detection for R4k CPUs


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/mips/include/asm/timex.h                      |  8 ++--
 arch/mips/kernel/time.c                            | 11 ++----
 arch/parisc/kernel/processor.c                     |  3 +-
 arch/x86/kernel/kvm.c                              | 13 ++++++
 arch/x86/kvm/cpuid.c                               |  5 +++
 arch/x86/kvm/lapic.c                               | 10 ++---
 arch/x86/kvm/mmu/mmu.c                             |  2 +
 arch/x86/kvm/svm/pmu.c                             | 28 +++++++++++--
 block/blk-map.c                                    |  2 +-
 drivers/firewire/core-card.c                       |  3 ++
 drivers/firewire/core-cdev.c                       |  4 +-
 drivers/firewire/core-topology.c                   |  9 ++---
 drivers/firewire/core-transaction.c                | 30 +++++++-------
 drivers/firewire/sbp2.c                            | 13 +++---
 drivers/gpio/gpio-pca953x.c                        |  4 +-
 drivers/gpio/gpiolib-of.c                          |  2 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |  2 +-
 drivers/hwmon/adt7470.c                            |  4 +-
 drivers/infiniband/sw/siw/siw_cm.c                 |  7 ++--
 drivers/iommu/intel/iommu.c                        | 27 +++++++++++--
 drivers/md/dm.c                                    |  8 +++-
 drivers/mmc/core/mmc.c                             | 23 +++++++++--
 drivers/mmc/host/rtsx_pci_sdmmc.c                  | 31 ++++++++++-----
 drivers/mmc/host/sdhci-msm.c                       | 42 ++++++++++++++++++++
 drivers/net/can/grcan.c                            | 46 +++++++++++-----------
 drivers/net/dsa/mt7530.c                           |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 13 +++---
 drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c    |  7 +++-
 drivers/net/ethernet/mediatek/mtk_sgmii.c          |  1 +
 .../ethernet/mellanox/mlx5/core/diag/rsc_dump.c    | 31 ++++++++++++---
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  4 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 10 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 11 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 28 ++++++++-----
 drivers/net/ethernet/smsc/smsc911x.c               |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |  1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  2 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |  5 ++-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      | 15 +++++--
 drivers/nfc/nfcmrvl/main.c                         |  2 +-
 drivers/pci/controller/pci-aardvark.c              | 16 ++++----
 drivers/s390/block/dasd.c                          | 18 +++++++--
 drivers/s390/block/dasd_eckd.c                     | 28 +++++++++----
 drivers/s390/block/dasd_int.h                      | 14 +++++++
 fs/btrfs/tree-log.c                                | 14 ++++++-
 fs/nfs/nfs4proc.c                                  | 12 +++++-
 include/linux/stmmac.h                             |  1 +
 kernel/irq/internals.h                             |  2 +
 kernel/irq/irqdesc.c                               |  2 +
 kernel/irq/manage.c                                | 39 +++++++++++++-----
 kernel/rcu/tree.c                                  | 32 ++++++++-------
 net/can/isotp.c                                    | 22 +++--------
 net/ipv4/igmp.c                                    |  9 +++--
 net/nfc/core.c                                     | 29 +++++++-------
 net/nfc/netlink.c                                  |  4 +-
 net/sunrpc/xprtsock.c                              |  3 --
 sound/firewire/fireworks/fireworks_hwdep.c         |  1 +
 sound/pci/hda/patch_realtek.c                      |  1 +
 sound/soc/codecs/da7219.c                          | 14 +++++--
 sound/soc/codecs/wm8958-dsp2.c                     |  8 ++--
 sound/soc/meson/aiu-acodec-ctrl.c                  |  2 +-
 sound/soc/meson/aiu-codec-ctrl.c                   |  2 +-
 sound/soc/meson/g12a-tohdmitx.c                    |  2 +-
 sound/soc/soc-generic-dmaengine-pcm.c              |  6 +--
 .../drivers/net/ocelot/tc_flower_chains.sh         |  2 +-
 .../net/forwarding/mirror_gre_bridge_1q.sh         |  3 ++
 tools/testing/selftests/seccomp/seccomp_bpf.c      | 10 ++---
 70 files changed, 537 insertions(+), 238 deletions(-)


