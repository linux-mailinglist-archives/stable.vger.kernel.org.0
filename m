Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393CE50F6E7
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345565AbiDZJBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346240AbiDZI7q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:59:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47513D1E0;
        Tue, 26 Apr 2022 01:43:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49CB861326;
        Tue, 26 Apr 2022 08:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22A8C385AC;
        Tue, 26 Apr 2022 08:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962582;
        bh=cFqLgKO7Ax/avt7ZUG2RnEnBv9Sm1MpedTgEet2C9x8=;
        h=From:To:Cc:Subject:Date:From;
        b=R87eQSrUO1bSyM34BWmc7MGVeTVyZ+fjdb5SRDG0nlUnGyfJVPxYZY35JHSKq4XB8
         H9Ms+qfmznYU5aWB9m0gsQxAIhAJJyNAzgKppJEjlGmUp/hZT6Bvehl7VxIg2U8+xp
         Gj8pmdPw4VIgqlf+3vNeU0vswf4xOXMcvmcb6cb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.17 000/146] 5.17.5-rc1 review
Date:   Tue, 26 Apr 2022 10:19:55 +0200
Message-Id: <20220426081750.051179617@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.5-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.17.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.17.5-rc1
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

This is the start of the stable review cycle for the 5.17.5 release.
There are 146 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.5-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.17.5-rc1

Alex Elder <elder@linaro.org>
    arm64: dts: qcom: add IPA qcom,qmp property

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix leaks on IOPOLL and CQE_SKIP

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: topology: cleanup dailinks on widget unload

Tudor Ambarus <tudor.ambarus@microchip.com>
    spi: atmel-quadspi: Fix the buswidth adjustment between spi-mem and controller

Ye Bin <yebin10@huawei.com>
    jbd2: fix a potential race while discarding reserved buffers after an abort

Theodore Ts'o <tytso@mit.edu>
    ext4: update the cached overhead value in the superblock

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

Mingwei Zhang <mizhang@google.com>
    KVM: SVM: Flush when freeing encrypted pages even on SME_COHERENT CPUs

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Simplify and harden helper to flush SEV guest page(s)

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Defer APICv updates while L2 is active until L1 is active

Sean Christopherson <seanjc@google.com>
    KVM: x86: Pend KVM_REQ_APICV_UPDATE during vCPU creation to fix a race

Sean Christopherson <seanjc@google.com>
    KVM: x86: Don't re-acquire SRCU lock in complete_emulated_io()

Like Xu <likexu@tencent.com>
    KVM: x86/pmu: Update AMD PMC sample period to fix guest NMI-watchdog

Rob Herring <robh@kernel.org>
    arm_pmu: Validate single/group leader events

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Fix gem refcounting and memory evictions

Sergey Matyukevich <sergey.matyukevich@synopsys.com>
    ARC: entry: fix syscall_trace_exit argument

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    codecs: rt5682s: fix an incorrect NULL check on list iterator

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Fix possible overflow in LTR decoding

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    ASoC: soc-dapm: fix two incorrect uses of list iterator

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    ASoC: rt5682: fix an incorrect NULL check on list iterator

Mario Limonciello <mario.limonciello@amd.com>
    gpio: Request interrupts after IRQ is initialized

Paolo Valerio <pvalerio@redhat.com>
    openvswitch: fix OOB access in reserve_sfa_size()

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix a7 clobbering in coprocessor context load/store

Guo Ren <guoren@kernel.org>
    xtensa: patch_text: Fixup last cpu should be master

Paulo Alcantara <pc@cjr.nz>
    cifs: use correct lock type in cifs_reconnect()

Paulo Alcantara <pc@cjr.nz>
    cifs: fix NULL ptr dereference in refresh_mounts()

Christian Brauner <brauner@kernel.org>
    fs: fix acl translation

Leo Yan <leo.yan@linaro.org>
    perf report: Set PERF_SAMPLE_DATA_SRC bit for Arm SPE event

Leo Yan <leo.yan@linaro.org>
    perf script: Always allow field 'data_src' for auxtrace

Miaoqian Lin <linmq006@gmail.com>
    arm/xen: Fix some refcount leaks

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Fix power10 event alternatives

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Fix power9 event alternatives

Miaoqian Lin <linmq006@gmail.com>
    drm/vc4: Use pm_runtime_resume_and_get to fix pm_runtime_get_sync() usage

Alexey Kardashevskiy <aik@ozlabs.ru>
    KVM: PPC: Fix TCE handling for VFIO

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/time: Always set decrementer in timer_interrupt()

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

Jens Axboe <axboe@kernel.dk>
    io_uring: free iovec if file assignment fails

Christian König <christian.koenig@amd.com>
    drm/radeon: fix logic inversion in radeon_sync_resv

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

Zqiang <qiang1.zhang@intel.com>
    irq_work: use kasan_record_aux_stack_noalloc() record callstack

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

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: hyper-v: Avoid writing to TSC page without an active vCPU

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

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: hda: intel-dsp-config: update AlderLake PCI IDs

Oliver Upton <oupton@google.com>
    selftests: KVM: Free the GIC FD when cleaning up in arch_timer

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

Rob Clark <robdclark@chromium.org>
    drm/msm/gpu: Remove mutex from wait_event condition

Rob Clark <robdclark@chromium.org>
    drm/msm/gpu: Rename runtime suspend/resume functions

Matthew Wilcox (Oracle) <willy@infradead.org>
    XArray: Disallow sibling entries of nodes

Muchun Song <songmuchun@bytedance.com>
    arm64: mm: fix p?d_leaf()

Nadav Amit <namit@vmware.com>
    userfaultfd: mark uffd_wp regardless of VM_WRITE flag

Ido Schimmel <idosch@nvidia.com>
    selftests: mlxsw: vxlan_flooding_ipv6: Prevent flooding of unwanted packets

Ido Schimmel <idosch@nvidia.com>
    selftests: mlxsw: vxlan_flooding: Prevent flooding of unwanted packets

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: skip clearing device context when device is read-only

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: add RO check for wq max_transfer_size write

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: add RO check for wq max_batch_size write

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix retry value to be constant for duration of function call

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: match type for retries var in idxd_enqcmds()

Kevin Hao <haokexin@gmail.com>
    net: stmmac: Use readl_poll_timeout_atomic() in atomic state

Atish Patra <atishp@rivosinc.com>
    RISC-V: KVM: Restrict the extensions that can be disabled

Atish Patra <atishp@rivosinc.com>
    RISC-V: KVM: Remove 's' & 'u' as valid ISA extension

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

Jianglei Nie <niejianglei2021@163.com>
    ice: Fix memory leak in ice_get_orom_civd_data()

Wojciech Drewek <wojciech.drewek@intel.com>
    ice: fix crash in switchdev mode

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: allow creating VFs for !CONFIG_NET_SWITCHDEV

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

Richard Fitzgerald <rf@opensource.cirrus.com>
    firmware: cs_dsp: Fix overrun of unterminated control name string

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

Maurizio Avogadro <mavoga@gmail.com>
    ALSA: usb-audio: add mapping for MSI MAG X570S Torpedo MAX.

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Clear MIDI port active flag after draining

Eric Dumazet <edumazet@google.com>
    net/sched: cls_u32: fix netns refcount changes in u32_change()

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: scsi_get_lba() error fix

Bob Peterson <rpeterso@redhat.com>
    gfs2: assign rgrp glock before compute_bitstructs

Khazhismel Kumykov <khazhy@google.com>
    block/compat_ioctl: fix range check in BLKGETSIZE

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Only set PSR version when valid

Adrian Hunter <adrian.hunter@intel.com>
    perf tools: Fix segfault accessing sample_id xyarray

Kees Cook <keescook@chromium.org>
    etherdevice: Adjust ether_addr* prototypes to silence -Wstringop-overead


-------------

Diffstat:

 Documentation/filesystems/ext4/attributes.rst      |  2 +-
 Makefile                                           |  4 +-
 arch/arc/kernel/entry.S                            |  1 +
 arch/arm/mach-vexpress/spc.c                       |  2 +-
 arch/arm/xen/enlighten.c                           |  9 ++-
 arch/arm64/boot/dts/freescale/imx8mm-var-som.dtsi  |  8 +--
 arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi  |  8 +--
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |  2 +
 arch/arm64/boot/dts/qcom/sc7280.dtsi               |  2 +
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |  2 +
 arch/arm64/include/asm/pgtable.h                   |  4 +-
 arch/powerpc/kernel/time.c                         | 29 +++++----
 arch/powerpc/kvm/book3s_64_vio.c                   | 45 +++++++-------
 arch/powerpc/kvm/book3s_64_vio_hv.c                | 44 +++++++-------
 arch/powerpc/perf/power10-pmu.c                    |  2 +-
 arch/powerpc/perf/power9-pmu.c                     |  8 +--
 arch/riscv/kvm/vcpu.c                              | 21 ++++---
 arch/x86/include/asm/compat.h                      |  6 +-
 arch/x86/include/asm/kvm_host.h                    |  4 +-
 arch/x86/kvm/hyperv.c                              | 40 +++---------
 arch/x86/kvm/hyperv.h                              |  2 +-
 arch/x86/kvm/pmu.h                                 |  9 +++
 arch/x86/kvm/svm/pmu.c                             |  1 +
 arch/x86/kvm/svm/sev.c                             | 61 ++++++++-----------
 arch/x86/kvm/vmx/nested.c                          |  5 ++
 arch/x86/kvm/vmx/pmu_intel.c                       |  8 +--
 arch/x86/kvm/vmx/vmx.c                             |  5 ++
 arch/x86/kvm/vmx/vmx.h                             |  1 +
 arch/x86/kvm/x86.c                                 | 29 +++++----
 arch/xtensa/kernel/coprocessor.S                   |  4 +-
 arch/xtensa/kernel/jump_label.c                    |  2 +-
 block/ioctl.c                                      |  2 +-
 drivers/ata/pata_marvell.c                         |  2 +
 drivers/dma/at_xdmac.c                             | 12 ++--
 drivers/dma/dw-edma/dw-edma-v0-core.c              |  7 ++-
 drivers/dma/idxd/device.c                          |  6 +-
 drivers/dma/idxd/submit.c                          |  5 +-
 drivers/dma/idxd/sysfs.c                           |  6 ++
 drivers/dma/imx-sdma.c                             | 32 +++++-----
 drivers/dma/mediatek/mtk-uart-apdma.c              |  9 ++-
 drivers/edac/synopsys_edac.c                       | 16 +++--
 drivers/firmware/cirrus/cs_dsp.c                   |  3 +-
 drivers/gpio/gpiolib.c                             |  4 +-
 drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c      |  4 ++
 drivers/gpu/drm/i915/display/intel_psr.c           | 38 ++++++------
 drivers/gpu/drm/msm/adreno/adreno_device.c         | 17 ++----
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c         |  3 +
 drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c  |  2 +
 .../gpu/drm/panel/panel-raspberrypi-touchscreen.c  | 13 +++-
 drivers/gpu/drm/radeon/radeon_sync.c               |  2 +-
 drivers/gpu/drm/vc4/vc4_dsi.c                      |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c                 | 43 ++++++-------
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |  8 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c            |  7 ++-
 drivers/input/keyboard/omap4-keypad.c              |  2 +-
 drivers/net/ethernet/Kconfig                       | 26 ++++----
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |  8 +--
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |  8 +--
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c    | 24 ++++----
 drivers/net/ethernet/cadence/macb_main.c           |  8 +++
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |  8 ++-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |  4 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c       |  3 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.h       |  2 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c           |  1 +
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
 drivers/scsi/qedi/qedi_iscsi.c                     | 69 +++++++++++----------
 drivers/scsi/scsi_transport_iscsi.c                | 71 +++++++++++-----------
 drivers/scsi/sr_ioctl.c                            | 15 ++++-
 drivers/scsi/ufs/ufshcd.c                          |  5 +-
 drivers/spi/atmel-quadspi.c                        |  3 +
 drivers/spi/spi-cadence-quadspi.c                  | 19 +++++-
 drivers/spi/spi-mtk-nor.c                          | 12 +++-
 fs/cifs/cifsfs.c                                   |  2 +-
 fs/cifs/connect.c                                  | 11 +++-
 fs/cifs/dfs_cache.c                                | 19 +++---
 fs/ext4/ext4.h                                     |  7 ++-
 fs/ext4/extents.c                                  | 32 +++++++---
 fs/ext4/inode.c                                    | 18 +++++-
 fs/ext4/ioctl.c                                    | 16 +++++
 fs/ext4/namei.c                                    |  4 +-
 fs/ext4/page-io.c                                  |  4 +-
 fs/ext4/super.c                                    | 21 +++++--
 fs/gfs2/rgrp.c                                     |  9 +--
 fs/hugetlbfs/inode.c                               |  9 +--
 fs/io_uring.c                                      | 11 ++--
 fs/jbd2/commit.c                                   |  4 +-
 fs/namei.c                                         | 22 +++----
 fs/posix_acl.c                                     | 10 +++
 fs/stat.c                                          | 19 +++---
 fs/xattr.c                                         |  6 +-
 include/linux/etherdevice.h                        |  5 +-
 include/linux/memcontrol.h                         |  5 ++
 include/linux/posix_acl_xattr.h                    |  4 ++
 include/linux/sched.h                              |  1 +
 include/linux/sched/mm.h                           |  8 +++
 include/net/esp.h                                  |  2 -
 include/net/netns/ipv6.h                           |  4 +-
 include/scsi/libiscsi.h                            |  9 +--
 include/scsi/scsi_transport_iscsi.h                |  2 +-
 kernel/events/core.c                               |  2 +-
 kernel/events/internal.h                           |  5 ++
 kernel/events/ring_buffer.c                        |  5 --
 kernel/irq_work.c                                  |  2 +-
 kernel/sched/fair.c                                | 10 +--
 lib/xarray.c                                       |  2 +
 mm/memcontrol.c                                    | 12 +++-
 mm/memory-failure.c                                | 13 ++++
 mm/mmap.c                                          |  8 ---
 mm/mmu_notifier.c                                  | 14 ++++-
 mm/oom_kill.c                                      | 54 +++++++++++-----
 mm/userfaultfd.c                                   | 15 +++--
 mm/workingset.c                                    |  2 +-
 net/can/isotp.c                                    | 10 ++-
 net/dsa/tag_hellcreek.c                            |  8 +++
 net/ipv4/esp4.c                                    |  5 +-
 net/ipv6/esp6.c                                    |  5 +-
 net/ipv6/ip6_gre.c                                 | 14 +++--
 net/ipv6/route.c                                   | 11 ++--
 net/l3mdev/l3mdev.c                                |  2 +-
 net/netlink/af_netlink.c                           |  7 +++
 net/openvswitch/flow_netlink.c                     |  2 +-
 net/packet/af_packet.c                             | 13 ++--
 net/rxrpc/net_ns.c                                 |  2 +
 net/sched/cls_u32.c                                | 24 +++++---
 net/smc/af_smc.c                                   |  4 +-
 sound/hda/intel-dsp-config.c                       | 18 +++++-
 sound/pci/hda/patch_hdmi.c                         |  6 +-
 sound/pci/hda/patch_realtek.c                      |  1 +
 sound/soc/atmel/sam9g20_wm8731.c                   | 61 -------------------
 sound/soc/codecs/msm8916-wcd-digital.c             |  9 ++-
 sound/soc/codecs/rk817_codec.c                     |  2 +-
 sound/soc/codecs/rt5682.c                          | 11 ++--
 sound/soc/codecs/rt5682s.c                         | 11 ++--
 sound/soc/codecs/wcd934x.c                         | 26 +-------
 sound/soc/soc-dapm.c                               |  6 +-
 sound/soc/soc-topology.c                           |  4 +-
 sound/soc/sof/topology.c                           | 43 +++++++++++++
 sound/usb/midi.c                                   |  1 +
 sound/usb/mixer_maps.c                             |  4 ++
 sound/usb/usbaudio.h                               |  2 +-
 tools/lib/perf/evlist.c                            |  3 +-
 tools/perf/builtin-report.c                        | 14 +++++
 tools/perf/builtin-script.c                        |  2 +-
 .../net/mlxsw/spectrum-2/vxlan_flooding_ipv6.sh    | 17 ++++++
 .../selftests/drivers/net/mlxsw/vxlan_flooding.sh  | 17 ++++++
 tools/testing/selftests/kvm/aarch64/arch_timer.c   | 15 +++--
 166 files changed, 1110 insertions(+), 725 deletions(-)


