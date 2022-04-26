Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76AAF50F5E8
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345814AbiDZIw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346269AbiDZIt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:49:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C48C74BE;
        Tue, 26 Apr 2022 01:37:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 70408CE1BC3;
        Tue, 26 Apr 2022 08:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10902C385AC;
        Tue, 26 Apr 2022 08:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962275;
        bh=6/VSdsdL8uB7rBMX1127u+XlMN8peXQLkqRfwoTB0a8=;
        h=From:To:Cc:Subject:Date:From;
        b=NgaISPcGAIZ4S85NbPmg/YsetiMqyrVJq5YeJeZZqxZ0xEtwKB3vatxm835b7mt1V
         mzQCFatTTnWvRI002XRrXtni9JowhNYYuzCPYLwKl5ANVrzH6s4kfHaC9Elph/gSCf
         tXcnurt9n3l92U184KErMVtBr8z9u5J2txEhmxgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 000/124] 5.15.36-rc1 review
Date:   Tue, 26 Apr 2022 10:20:01 +0200
Message-Id: <20220426081747.286685339@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.36-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.36-rc1
X-KernelTest-Deadline: 2022-04-28T08:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.36 release.
There are 124 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.36-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.36-rc1

Alex Elder <elder@linaro.org>
    arm64: dts: qcom: add IPA qcom,qmp property

Khazhismel Kumykov <khazhy@google.com>
    block/compat_ioctl: fix range check in BLKGETSIZE

Tudor Ambarus <tudor.ambarus@microchip.com>
    spi: atmel-quadspi: Fix the buswidth adjustment between spi-mem and controller

Ye Bin <yebin10@huawei.com>
    jbd2: fix a potential race while discarding reserved buffers after an abort

Florian Westphal <fw@strlen.de>
    netfilter: nft_ct: fix use after free when attaching zone template

Theodore Ts'o <tytso@mit.edu>
    ext4: force overhead calculation if the s_overhead_cluster makes no sense

Theodore Ts'o <tytso@mit.edu>
    ext4: fix overhead calculation to account for the reserved gdt blocks

wangjianjian (C) <wangjianjian3@huawei.com>
    ext4, doc: fix incorrect h_reserved size

Tadeusz Struk <tadeusz.struk@linaro.org>
    ext4: limit length to bitmap_maxbytes - blocksize in punch_hole

Ye Bin <yebin10@huawei.com>
    ext4: fix use-after-free in ext4_search_dir

Ye Bin <yebin10@huawei.com>
    ext4: fix symlink file size not match to file content

Darrick J. Wong <djwong@kernel.org>
    ext4: fix fallocate to use file_modified to update permissions consistently

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: avoid useless indirection during conntrack destruction

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: convert to refcount_t api

Mingwei Zhang <mizhang@google.com>
    KVM: SVM: Flush when freeing encrypted pages even on SME_COHERENT CPUs

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Defer APICv updates while L2 is active until L1 is active

Sean Christopherson <seanjc@google.com>
    KVM: x86: Pend KVM_REQ_APICV_UPDATE during vCPU creation to fix a race

Like Xu <likexu@tencent.com>
    KVM: x86/pmu: Update AMD PMC sample period to fix guest NMI-watchdog

Rob Herring <robh@kernel.org>
    arm_pmu: Validate single/group leader events

Sergey Matyukevich <sergey.matyukevich@synopsys.com>
    ARC: entry: fix syscall_trace_exit argument

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Fix possible overflow in LTR decoding

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    ASoC: soc-dapm: fix two incorrect uses of list iterator

Mario Limonciello <mario.limonciello@amd.com>
    gpio: Request interrupts after IRQ is initialized

Paolo Valerio <pvalerio@redhat.com>
    openvswitch: fix OOB access in reserve_sfa_size()

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix a7 clobbering in coprocessor context load/store

Guo Ren <guoren@linux.alibaba.com>
    xtensa: patch_text: Fixup last cpu should be master

Leo Yan <leo.yan@linaro.org>
    perf report: Set PERF_SAMPLE_DATA_SRC bit for Arm SPE event

Leo Yan <leo.yan@linaro.org>
    perf script: Always allow field 'data_src' for auxtrace

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Fix power10 event alternatives

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Fix power9 event alternatives

Miaoqian Lin <linmq006@gmail.com>
    drm/vc4: Use pm_runtime_resume_and_get to fix pm_runtime_get_sync() usage

Alexey Kardashevskiy <aik@ozlabs.ru>
    KVM: PPC: Fix TCE handling for VFIO

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/panel/raspberrypi-touchscreen: Initialise the bridge in prepare

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/panel/raspberrypi-touchscreen: Avoid NULL deref if not initialised

Zhipeng Xie <xiezhipeng1@huawei.com>
    perf/core: Fix perf_mmap fail when CONFIG_PERF_USE_VMALLOC enabled

kuyo chang <kuyo.chang@mediatek.com>
    sched/pelt: Fix attach_entity_load_avg() corner case

Tom Rix <trix@redhat.com>
    scsi: sr: Do not leak information in ioctl

Miaoqian Lin <linmq006@gmail.com>
    Input: omap4-keypad - fix pm_runtime_get_sync() error checking

Manuel Ullmann <labre@posteo.de>
    net: atlantic: invert deep par in pm functions, preventing null derefs

Kevin Groeneveld <kgroeneveld@lenbrook.com>
    dmaengine: imx-sdma: fix init of uart scripts

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    dma: at_xdmac: fix a missing check on list iterator

Zheyu Ma <zheyuma97@gmail.com>
    ata: pata_marvell: Check the 'bmdma_addr' beforing reading

Alistair Popple <apopple@nvidia.com>
    mm/mmu_notifier.c: fix race in mmu_interval_notifier_remove()

Nico Pache <npache@redhat.com>
    oom_kill.c: futex: delay the OOM reaper to allow time for proper futex cleanup

Christophe Leroy <christophe.leroy@csgroup.eu>
    mm, hugetlb: allow for "high" userspace addresses

Shakeel Butt <shakeelb@google.com>
    memcg: sync flush only if periodic flush is delayed

Xu Yu <xuyu@linux.alibaba.com>
    mm/memory-failure.c: skip huge_zero_page in memory_failure()

Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
    EDAC/synopsys: Read the error count from the correct register

Christoph Hellwig <hch@lst.de>
    nvme-pci: disable namespace identifiers for Qemu controllers

Christoph Hellwig <hch@lst.de>
    nvme-pci: disable namespace identifiers for the MAXIO MAP1002/1202

Christoph Hellwig <hch@lst.de>
    nvme: add a quirk to disable namespace identifiers

NeilBrown <neilb@suse.de>
    VFS: filename_create(): fix incorrect intent.

Mikulas Patocka <mpatocka@redhat.com>
    stat: fix inconsistency between struct stat and struct compat_stat

Mike Christie <michael.christie@oracle.com>
    scsi: qedi: Fix failed disconnect handling

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix NOP handling during conn recovery

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Merge suspend fields

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Release endpoint ID when its freed

Tomas Melin <tomas.melin@vaisala.com>
    net: macb: Restart tx only if queue pointer is lagging

Xiaoke Wang <xkernel.wang@foxmail.com>
    drm/msm/mdp5: check the return of kzalloc()

Lv Ruyi <lv.ruyi@zte.com.cn>
    dpaa_eth: Fix missing of_node_put in dpaa_get_ts_info()

Borislav Petkov <bp@alien8.de>
    brcmfmac: sdio: Fix undefined behavior due to shift overflowing the constant

Borislav Petkov <bp@suse.de>
    mt76: Fix undefined behavior due to shift overflowing the constant

Kai-Heng Feng <kai.heng.feng@canonical.com>
    net: atlantic: Avoid out-of-bounds indexing

David Howells <dhowells@redhat.com>
    cifs: Check the IOCB_DIRECT flag, not O_DIRECT

Hongbin Wang <wh_bin@126.com>
    vxlan: fix error return code in vxlan_fdb_append

Rob Herring <robh@kernel.org>
    arm64: dts: imx: Fix imx8*-var-som touchscreen property sizes

Xiaoke Wang <xkernel.wang@foxmail.com>
    drm/msm/disp: check the return value of kzalloc()

Borislav Petkov <bp@suse.de>
    ALSA: usb-audio: Fix undefined behavior due to shift overflowing the constant

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    platform/x86: samsung-laptop: Fix an unsigned comparison which can never be negative

Sameer Pujar <spujar@nvidia.com>
    reset: tegra-bpmp: Restore Handle errors in BPMP response

Heiner Kallweit <hkallweit1@gmail.com>
    reset: renesas: Check return value of reset_control_deassert()

Kees Cook <keescook@chromium.org>
    ARM: vexpress/spc: Avoid negative array index when !SMP

Muchun Song <songmuchun@bytedance.com>
    arm64: mm: fix p?d_leaf()

Ido Schimmel <idosch@nvidia.com>
    selftests: mlxsw: vxlan_flooding: Prevent flooding of unwanted packets

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: skip clearing device context when device is read-only

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: add RO check for wq max_transfer_size write

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: add RO check for wq max_batch_size write

Kevin Hao <haokexin@gmail.com>
    net: stmmac: Use readl_poll_timeout_atomic() in atomic state

José Roberto de Souza <jose.souza@intel.com>
    drm/i915/display/psr: Unset enable_psr2_sel_fetch if other checks in intel_psr2_config_valid() fails

Eric Dumazet <edumazet@google.com>
    netlink: reset network and mac headers in netlink_dump()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix broken IP multicast flooding

Kurt Kanzenbach <kurt@linutronix.de>
    net: dsa: hellcreek: Calculate checksums in tagger

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: stop timeout monitoring when no first frame was sent

Eric Dumazet <edumazet@google.com>
    ipv6: make ip6_rt_gc_expire an atomic_t

David Ahern <dsahern@kernel.org>
    l3mdev: l3mdev_master_upper_ifindex_by_index_rcu should be using netdev_master_upper_dev_get_rcu

Eric Dumazet <edumazet@google.com>
    net/sched: cls_u32: fix possible leak in u32_init_knode()

Stephen Hemminger <stephen@networkplumber.org>
    net: restore alpha order to Ethernet devices in config

Peilin Ye <peilin.ye@bytedance.com>
    ip6_gre: Fix skb_under_panic in __gre6_xmit()

Peilin Ye <peilin.ye@bytedance.com>
    ip6_gre: Avoid updating tunnel->tun_hlen in __gre6_xmit()

Hangbin Liu <liuhangbin@gmail.com>
    net/packet: fix packet_sock xmit return value checking

Tony Lu <tonylu@linux.alibaba.com>
    net/smc: Fix sock leak when release after smc_shutdown()

David Howells <dhowells@redhat.com>
    rxrpc: Restore removed timer deletion

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi: fix warning about PCM count when used with SOF

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    igc: Fix suspending when PTM is active

Sasha Neftin <sasha.neftin@intel.com>
    igc: Fix BUG: scheduling while atomic

Sasha Neftin <sasha.neftin@intel.com>
    igc: Fix infinite loop in release_swfw_sync

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    spi: cadence-quadspi: fix incorrect supports_op() return value

Sabrina Dubroca <sd@queasysnail.net>
    esp: limit skb_page_frag_refill use to a single page

Allen-KH Cheng <allen-kh.cheng@mediatek.com>
    spi: spi-mtk-nor: initialize spi controller after resume

Herve Codina <herve.codina@bootlin.com>
    dmaengine: dw-edma: Fix unaligned 64bit access

zhangqilong <zhangqilong3@huawei.com>
    dmaengine: mediatek:Fix PM usage reference leak of mtk_uart_apdma_alloc_chan_resources

Miaoqian Lin <linmq006@gmail.com>
    dmaengine: imx-sdma: Fix error checking in sdma_event_remap

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix device cleanup on disable

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wcd934x: do not switch off SIDO Buck when codec is in use

Miaoqian Lin <linmq006@gmail.com>
    ASoC: msm8916-wcd-digital: Check failure for devm_snd_soc_register_component

Miaoqian Lin <linmq006@gmail.com>
    ASoC: rk817: Use devm_clk_get() in rk817_platform_probe

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: topology: Correct error handling in soc_tplg_dapm_widget_create()

Mark Brown <broonie@kernel.org>
    ASoC: atmel: Remove system clock tree configuration for at91sam9g20ek

Tim Crawford <tcrawford@system76.com>
    ALSA: hda/realtek: Add quirk for Clevo NP70PNP

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Clear MIDI port active flag after draining

Eric Dumazet <edumazet@google.com>
    net/sched: cls_u32: fix netns refcount changes in u32_change()

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: scsi_get_lba() error fix

Bob Peterson <rpeterso@redhat.com>
    gfs2: assign rgrp glock before compute_bitstructs

Marco Elver <elver@google.com>
    mm, kfence: support kmem_dump_obj() for KFENCE objects

Adrian Hunter <adrian.hunter@intel.com>
    perf tools: Fix segfault accessing sample_id xyarray

Xiongwei Song <sxwjean@gmail.com>
    mm: page_alloc: fix building error on -Werror=array-compare

Kees Cook <keescook@chromium.org>
    etherdevice: Adjust ether_addr* prototypes to silence -Wstringop-overead

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/mm: drop HAVE_ARCH_PFN_VALID

Mike Rapoport <rppt@kernel.org>
    dma-mapping: remove bogus test for pfn_valid from dma_map_resource

Darrick J. Wong <djwong@kernel.org>
    xfs: return errors in xfs_fs_sync_fs

Darrick J. Wong <djwong@kernel.org>
    vfs: make sync_filesystem return errors from ->sync_fs

Christoph Hellwig <hch@lst.de>
    block: simplify the block device syncing code

Christoph Hellwig <hch@lst.de>
    block: remove __sync_blockdev

Christoph Hellwig <hch@lst.de>
    fs: remove __sync_filesystem


-------------

Diffstat:

 Documentation/filesystems/ext4/attributes.rst      |  2 +-
 Makefile                                           |  4 +-
 arch/arc/kernel/entry.S                            |  1 +
 arch/arm/mach-vexpress/spc.c                       |  2 +-
 arch/arm64/Kconfig                                 |  1 -
 arch/arm64/boot/dts/freescale/imx8mm-var-som.dtsi  |  8 +--
 arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi  |  8 +--
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |  2 +
 arch/arm64/boot/dts/qcom/sc7280.dtsi               |  2 +
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |  2 +
 arch/arm64/include/asm/page.h                      |  1 -
 arch/arm64/include/asm/pgtable.h                   |  4 +-
 arch/arm64/mm/init.c                               | 37 -----------
 arch/powerpc/kvm/book3s_64_vio.c                   | 45 +++++++-------
 arch/powerpc/kvm/book3s_64_vio_hv.c                | 44 ++++++-------
 arch/powerpc/perf/power10-pmu.c                    |  2 +-
 arch/powerpc/perf/power9-pmu.c                     |  8 +--
 arch/x86/include/asm/compat.h                      |  6 +-
 arch/x86/kvm/pmu.h                                 |  9 +++
 arch/x86/kvm/svm/pmu.c                             |  1 +
 arch/x86/kvm/svm/sev.c                             |  9 ++-
 arch/x86/kvm/vmx/nested.c                          |  5 ++
 arch/x86/kvm/vmx/pmu_intel.c                       |  8 +--
 arch/x86/kvm/vmx/vmx.c                             |  5 ++
 arch/x86/kvm/vmx/vmx.h                             |  1 +
 arch/x86/kvm/x86.c                                 | 15 ++++-
 arch/xtensa/kernel/coprocessor.S                   |  4 +-
 arch/xtensa/kernel/jump_label.c                    |  2 +-
 block/bdev.c                                       | 28 ++++++---
 block/ioctl.c                                      |  2 +-
 drivers/ata/pata_marvell.c                         |  2 +
 drivers/dma/at_xdmac.c                             | 12 ++--
 drivers/dma/dw-edma/dw-edma-v0-core.c              |  7 ++-
 drivers/dma/idxd/device.c                          |  6 +-
 drivers/dma/idxd/sysfs.c                           |  6 ++
 drivers/dma/imx-sdma.c                             | 32 +++++-----
 drivers/dma/mediatek/mtk-uart-apdma.c              |  9 ++-
 drivers/edac/synopsys_edac.c                       | 16 +++--
 drivers/gpio/gpiolib.c                             |  4 +-
 drivers/gpu/drm/i915/display/intel_psr.c           | 38 +++++++-----
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c         |  3 +
 drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c  |  2 +
 .../gpu/drm/panel/panel-raspberrypi-touchscreen.c  | 13 +++-
 drivers/gpu/drm/vc4/vc4_dsi.c                      |  2 +-
 drivers/input/keyboard/omap4-keypad.c              |  2 +-
 drivers/net/ethernet/Kconfig                       | 26 ++++----
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |  8 +--
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |  8 +--
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c    | 24 ++++----
 drivers/net/ethernet/cadence/macb_main.c           |  8 +++
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |  8 ++-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |  4 +-
 drivers/net/ethernet/intel/igc/igc_i225.c          | 11 +++-
 drivers/net/ethernet/intel/igc/igc_phy.c           |  4 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c           | 15 ++++-
 drivers/net/ethernet/mscc/ocelot.c                 |  2 +
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |  4 +-
 drivers/net/vxlan.c                                |  4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |  2 +-
 drivers/nvme/host/core.c                           | 24 ++++++--
 drivers/nvme/host/nvme.h                           |  5 ++
 drivers/nvme/host/pci.c                            |  9 ++-
 drivers/perf/arm_pmu.c                             | 10 ++-
 drivers/platform/x86/samsung-laptop.c              |  2 -
 drivers/reset/reset-rzg2l-usbphy-ctrl.c            |  4 +-
 drivers/reset/tegra/reset-bpmp.c                   |  9 ++-
 drivers/scsi/bnx2i/bnx2i_hwi.c                     |  2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |  2 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |  6 +-
 drivers/scsi/libiscsi.c                            | 27 ++++----
 drivers/scsi/libiscsi_tcp.c                        |  2 +-
 drivers/scsi/qedi/qedi_iscsi.c                     | 69 ++++++++++-----------
 drivers/scsi/scsi_transport_iscsi.c                | 71 +++++++++++----------
 drivers/scsi/sr_ioctl.c                            | 15 ++++-
 drivers/scsi/ufs/ufshcd.c                          |  5 +-
 drivers/spi/atmel-quadspi.c                        |  3 +
 drivers/spi/spi-cadence-quadspi.c                  | 19 +++++-
 drivers/spi/spi-mtk-nor.c                          | 12 +++-
 fs/cifs/cifsfs.c                                   |  2 +-
 fs/ext4/ext4.h                                     |  6 +-
 fs/ext4/extents.c                                  | 32 +++++++---
 fs/ext4/inode.c                                    | 18 +++++-
 fs/ext4/namei.c                                    |  4 +-
 fs/ext4/page-io.c                                  |  4 +-
 fs/ext4/super.c                                    | 19 ++++--
 fs/gfs2/rgrp.c                                     |  9 +--
 fs/hugetlbfs/inode.c                               |  9 +--
 fs/internal.h                                      | 11 ----
 fs/jbd2/commit.c                                   |  4 +-
 fs/namei.c                                         | 22 +++----
 fs/stat.c                                          | 19 +++---
 fs/sync.c                                          | 72 +++++++++-------------
 fs/xfs/xfs_super.c                                 |  6 +-
 include/linux/blkdev.h                             |  9 +++
 include/linux/etherdevice.h                        |  5 +-
 include/linux/kfence.h                             | 24 ++++++++
 include/linux/memcontrol.h                         |  5 ++
 include/linux/netfilter/nf_conntrack_common.h      | 10 +--
 include/linux/sched.h                              |  1 +
 include/linux/sched/mm.h                           |  8 +++
 include/net/esp.h                                  |  2 -
 include/net/netfilter/nf_conntrack.h               |  8 ++-
 include/net/netns/ipv6.h                           |  4 +-
 include/scsi/libiscsi.h                            |  9 +--
 include/scsi/scsi_transport_iscsi.h                |  2 +-
 kernel/dma/mapping.c                               |  4 --
 kernel/events/core.c                               |  2 +-
 kernel/events/internal.h                           |  5 ++
 kernel/events/ring_buffer.c                        |  5 --
 kernel/sched/fair.c                                | 10 +--
 mm/kfence/core.c                                   | 21 -------
 mm/kfence/kfence.h                                 | 21 +++++++
 mm/kfence/report.c                                 | 47 ++++++++++++++
 mm/memcontrol.c                                    | 12 +++-
 mm/memory-failure.c                                | 13 ++++
 mm/mmap.c                                          |  8 ---
 mm/mmu_notifier.c                                  | 14 ++++-
 mm/oom_kill.c                                      | 54 +++++++++++-----
 mm/page_alloc.c                                    |  2 +-
 mm/slab.c                                          |  2 +-
 mm/slab.h                                          |  2 +-
 mm/slab_common.c                                   |  9 +++
 mm/slob.c                                          |  2 +-
 mm/slub.c                                          |  2 +-
 mm/workingset.c                                    |  2 +-
 net/can/isotp.c                                    | 10 ++-
 net/dsa/tag_hellcreek.c                            |  8 +++
 net/ipv4/esp4.c                                    |  5 +-
 net/ipv6/esp6.c                                    |  5 +-
 net/ipv6/ip6_gre.c                                 | 14 +++--
 net/ipv6/route.c                                   | 11 ++--
 net/l3mdev/l3mdev.c                                |  2 +-
 net/netfilter/nf_conntrack_core.c                  | 38 ++++++------
 net/netfilter/nf_conntrack_expect.c                |  4 +-
 net/netfilter/nf_conntrack_netlink.c               |  6 +-
 net/netfilter/nf_conntrack_standalone.c            |  4 +-
 net/netfilter/nf_flow_table_core.c                 |  2 +-
 net/netfilter/nf_synproxy_core.c                   |  1 -
 net/netfilter/nft_ct.c                             |  9 +--
 net/netfilter/xt_CT.c                              |  3 +-
 net/netlink/af_netlink.c                           |  7 +++
 net/openvswitch/conntrack.c                        |  1 -
 net/openvswitch/flow_netlink.c                     |  2 +-
 net/packet/af_packet.c                             | 13 ++--
 net/rxrpc/net_ns.c                                 |  2 +
 net/sched/act_ct.c                                 |  1 -
 net/sched/cls_u32.c                                | 24 +++++---
 net/smc/af_smc.c                                   |  4 +-
 sound/pci/hda/patch_hdmi.c                         |  6 +-
 sound/pci/hda/patch_realtek.c                      |  1 +
 sound/soc/atmel/sam9g20_wm8731.c                   | 61 ------------------
 sound/soc/codecs/msm8916-wcd-digital.c             |  9 ++-
 sound/soc/codecs/rk817_codec.c                     |  2 +-
 sound/soc/codecs/wcd934x.c                         | 26 +-------
 sound/soc/soc-dapm.c                               |  6 +-
 sound/soc/soc-topology.c                           |  4 +-
 sound/usb/midi.c                                   |  1 +
 sound/usb/usbaudio.h                               |  2 +-
 tools/lib/perf/evlist.c                            |  3 +-
 tools/perf/builtin-report.c                        | 14 +++++
 tools/perf/builtin-script.c                        |  2 +-
 .../selftests/drivers/net/mlxsw/vxlan_flooding.sh  | 17 +++++
 163 files changed, 1037 insertions(+), 702 deletions(-)


