Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364C650F55A
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238712AbiDZIql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345769AbiDZIoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:44:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E98814A6;
        Tue, 26 Apr 2022 01:33:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EC2A618C1;
        Tue, 26 Apr 2022 08:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30AEC385A0;
        Tue, 26 Apr 2022 08:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962014;
        bh=eH0X6uSGx6zw3muRRa6GZW8vqoA9WbNrkIYEW8XdQUQ=;
        h=From:To:Cc:Subject:Date:From;
        b=t64v0xvwy0x3KlGTi857+qRFBn72DmLPSFlHA2n4hssQyepLIdR+vNSb3DJKs3f5d
         N5vd8PxiU+DeoqHrkOXNno2wgYdWXkgKtm/gJhVFdZWB2HWzp4ubZ12+dIBnd2R8KL
         1foHjrc1gKd/Mos0+OY3o1tAHRSX+iDeUR6pIJQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/86] 5.10.113-rc1 review
Date:   Tue, 26 Apr 2022 10:20:28 +0200
Message-Id: <20220426081741.202366502@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.113-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.113-rc1
X-KernelTest-Deadline: 2022-04-28T08:17+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.113 release.
There are 86 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.113-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.113-rc1

Marek Vasut <marex@denx.de>
    Revert "net: micrel: fix KS8851_MLL Kconfig"

Khazhismel Kumykov <khazhy@google.com>
    block/compat_ioctl: fix range check in BLKGETSIZE

Lee Jones <lee.jones@linaro.org>
    staging: ion: Prevent incorrect reference counting behavour

Tudor Ambarus <tudor.ambarus@microchip.com>
    spi: atmel-quadspi: Fix the buswidth adjustment between spi-mem and controller

Ye Bin <yebin10@huawei.com>
    jbd2: fix a potential race while discarding reserved buffers after an abort

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: stop timeout monitoring when no first frame was sent

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

Leo Yan <leo.yan@linaro.org>
    perf report: Set PERF_SAMPLE_DATA_SRC bit for Arm SPE event

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

Manuel Ullmann <labre@posteo.de>
    net: atlantic: invert deep par in pm functions, preventing null derefs

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

Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
    EDAC/synopsys: Read the error count from the correct register

Christoph Hellwig <hch@lst.de>
    nvme-pci: disable namespace identifiers for Qemu controllers

Christoph Hellwig <hch@lst.de>
    nvme: add a quirk to disable namespace identifiers

Mikulas Patocka <mpatocka@redhat.com>
    stat: fix inconsistency between struct stat and struct compat_stat

Mike Christie <michael.christie@oracle.com>
    scsi: qedi: Fix failed disconnect handling

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

Borislav Petkov <bp@suse.de>
    ALSA: usb-audio: Fix undefined behavior due to shift overflowing the constant

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    platform/x86: samsung-laptop: Fix an unsigned comparison which can never be negative

Sameer Pujar <spujar@nvidia.com>
    reset: tegra-bpmp: Restore Handle errors in BPMP response

Kees Cook <keescook@chromium.org>
    ARM: vexpress/spc: Avoid negative array index when !SMP

Muchun Song <songmuchun@bytedance.com>
    arm64: mm: fix p?d_leaf()

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/mm: Remove [PUD|PMD]_TABLE_BIT from [pud|pmd]_bad()

Ido Schimmel <idosch@nvidia.com>
    selftests: mlxsw: vxlan_flooding: Prevent flooding of unwanted packets

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: add RO check for wq max_transfer_size write

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: add RO check for wq max_batch_size write

Kevin Hao <haokexin@gmail.com>
    net: stmmac: Use readl_poll_timeout_atomic() in atomic state

Eric Dumazet <edumazet@google.com>
    netlink: reset network and mac headers in netlink_dump()

Eric Dumazet <edumazet@google.com>
    ipv6: make ip6_rt_gc_expire an atomic_t

David Ahern <dsahern@kernel.org>
    l3mdev: l3mdev_master_upper_ifindex_by_index_rcu should be using netdev_master_upper_dev_get_rcu

Eric Dumazet <edumazet@google.com>
    net/sched: cls_u32: fix possible leak in u32_init_knode()

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

Sasha Neftin <sasha.neftin@intel.com>
    igc: Fix BUG: scheduling while atomic

Sasha Neftin <sasha.neftin@intel.com>
    igc: Fix infinite loop in release_swfw_sync

Sabrina Dubroca <sd@queasysnail.net>
    esp: limit skb_page_frag_refill use to a single page

Allen-KH Cheng <allen-kh.cheng@mediatek.com>
    spi: spi-mtk-nor: initialize spi controller after resume

zhangqilong <zhangqilong3@huawei.com>
    dmaengine: mediatek:Fix PM usage reference leak of mtk_uart_apdma_alloc_chan_resources

Miaoqian Lin <linmq006@gmail.com>
    dmaengine: imx-sdma: Fix error checking in sdma_event_remap

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wcd934x: do not switch off SIDO Buck when codec is in use

Miaoqian Lin <linmq006@gmail.com>
    ASoC: msm8916-wcd-digital: Check failure for devm_snd_soc_register_component

Mark Brown <broonie@kernel.org>
    ASoC: atmel: Remove system clock tree configuration for at91sam9g20ek

Jiazi Li <jqqlijiazi@gmail.com>
    dm: fix mempool NULL pointer race when completing IO

Tim Crawford <tcrawford@system76.com>
    ALSA: hda/realtek: Add quirk for Clevo NP70PNP

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Clear MIDI port active flag after draining

Eric Dumazet <edumazet@google.com>
    net/sched: cls_u32: fix netns refcount changes in u32_change()

Bob Peterson <rpeterso@redhat.com>
    gfs2: assign rgrp glock before compute_bitstructs

Adrian Hunter <adrian.hunter@intel.com>
    perf tools: Fix segfault accessing sample_id xyarray

Daniel Bristot de Oliveira <bristot@kernel.org>
    tracing: Dump stacktrace trigger to the corresponding instance

Xiongwei Song <sxwjean@gmail.com>
    mm: page_alloc: fix building error on -Werror=array-compare

Kees Cook <keescook@chromium.org>
    etherdevice: Adjust ether_addr* prototypes to silence -Wstringop-overead


-------------

Diffstat:

 Documentation/filesystems/ext4/attributes.rst      |  2 +-
 Makefile                                           |  4 +-
 arch/arc/kernel/entry.S                            |  1 +
 arch/arm/mach-vexpress/spc.c                       |  2 +-
 arch/arm64/boot/dts/freescale/imx8mm-var-som.dtsi  |  8 +--
 arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi  |  8 +--
 arch/arm64/include/asm/pgtable.h                   |  9 ++-
 arch/powerpc/kvm/book3s_64_vio.c                   | 45 +++++++-------
 arch/powerpc/kvm/book3s_64_vio_hv.c                | 44 +++++++-------
 arch/powerpc/perf/power9-pmu.c                     |  8 +--
 arch/x86/include/asm/compat.h                      |  6 +-
 arch/xtensa/kernel/coprocessor.S                   |  4 +-
 arch/xtensa/kernel/jump_label.c                    |  2 +-
 block/ioctl.c                                      |  2 +-
 drivers/ata/pata_marvell.c                         |  2 +
 drivers/dma/at_xdmac.c                             | 12 ++--
 drivers/dma/idxd/sysfs.c                           |  6 ++
 drivers/dma/imx-sdma.c                             |  4 +-
 drivers/dma/mediatek/mtk-uart-apdma.c              |  9 ++-
 drivers/edac/synopsys_edac.c                       | 16 +++--
 drivers/gpio/gpiolib.c                             |  4 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c         |  3 +
 .../gpu/drm/panel/panel-raspberrypi-touchscreen.c  | 13 +++-
 drivers/gpu/drm/vc4/vc4_dsi.c                      |  2 +-
 drivers/md/dm.c                                    | 17 +++---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |  8 +--
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |  8 +--
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c    | 24 ++++----
 drivers/net/ethernet/cadence/macb_main.c           |  8 +++
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |  8 ++-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |  4 +-
 drivers/net/ethernet/intel/igc/igc_i225.c          | 11 +++-
 drivers/net/ethernet/intel/igc/igc_phy.c           |  4 +-
 drivers/net/ethernet/micrel/Kconfig                |  1 -
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |  4 +-
 drivers/net/vxlan.c                                |  4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |  2 +-
 drivers/nvme/host/core.c                           | 24 ++++++--
 drivers/nvme/host/nvme.h                           |  5 ++
 drivers/nvme/host/pci.c                            |  5 +-
 drivers/perf/arm_pmu.c                             | 10 ++--
 drivers/platform/x86/samsung-laptop.c              |  2 -
 drivers/reset/tegra/reset-bpmp.c                   |  9 ++-
 drivers/scsi/qedi/qedi_iscsi.c                     | 69 +++++++++++-----------
 drivers/spi/atmel-quadspi.c                        |  3 +
 drivers/spi/spi-mtk-nor.c                          | 12 +++-
 drivers/staging/android/ion/ion.c                  |  3 +
 fs/cifs/cifsfs.c                                   |  2 +-
 fs/ext4/ext4.h                                     |  6 +-
 fs/ext4/extents.c                                  | 32 +++++++---
 fs/ext4/inode.c                                    | 18 +++++-
 fs/ext4/namei.c                                    |  4 +-
 fs/ext4/page-io.c                                  |  4 +-
 fs/ext4/super.c                                    | 19 ++++--
 fs/gfs2/rgrp.c                                     |  9 +--
 fs/hugetlbfs/inode.c                               |  9 +--
 fs/jbd2/commit.c                                   |  4 +-
 fs/stat.c                                          | 19 +++---
 include/linux/etherdevice.h                        |  5 +-
 include/linux/sched.h                              |  1 +
 include/linux/sched/mm.h                           |  8 +++
 include/net/esp.h                                  |  2 -
 include/net/netns/ipv6.h                           |  4 +-
 kernel/events/core.c                               |  2 +-
 kernel/events/internal.h                           |  5 ++
 kernel/events/ring_buffer.c                        |  5 --
 kernel/sched/fair.c                                | 10 ++--
 kernel/trace/trace_events_trigger.c                |  9 ++-
 mm/mmap.c                                          |  8 ---
 mm/mmu_notifier.c                                  | 14 ++++-
 mm/oom_kill.c                                      | 54 ++++++++++++-----
 mm/page_alloc.c                                    |  2 +-
 net/can/isotp.c                                    | 10 +++-
 net/ipv4/esp4.c                                    |  5 +-
 net/ipv6/esp6.c                                    |  5 +-
 net/ipv6/ip6_gre.c                                 | 14 +++--
 net/ipv6/route.c                                   | 11 ++--
 net/l3mdev/l3mdev.c                                |  2 +-
 net/netlink/af_netlink.c                           |  7 +++
 net/openvswitch/flow_netlink.c                     |  2 +-
 net/packet/af_packet.c                             | 13 ++--
 net/rxrpc/net_ns.c                                 |  2 +
 net/sched/cls_u32.c                                | 24 ++++----
 net/smc/af_smc.c                                   |  4 +-
 sound/pci/hda/patch_realtek.c                      |  1 +
 sound/soc/atmel/sam9g20_wm8731.c                   | 61 -------------------
 sound/soc/codecs/msm8916-wcd-digital.c             |  9 ++-
 sound/soc/codecs/wcd934x.c                         | 26 +-------
 sound/soc/soc-dapm.c                               |  6 +-
 sound/usb/midi.c                                   |  1 +
 sound/usb/usbaudio.h                               |  2 +-
 tools/lib/perf/evlist.c                            |  3 +-
 tools/perf/builtin-report.c                        | 14 +++++
 .../selftests/drivers/net/mlxsw/vxlan_flooding.sh  | 17 ++++++
 95 files changed, 562 insertions(+), 395 deletions(-)


