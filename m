Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A21150F4AA
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345007AbiDZIgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345209AbiDZIfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:35:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B57E814A5;
        Tue, 26 Apr 2022 01:28:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3B2F7CE1BB4;
        Tue, 26 Apr 2022 08:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02E9C385A0;
        Tue, 26 Apr 2022 08:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961722;
        bh=hHGCXXl8tbvXU47GG66UAu326D6Dd7Wr3AyGix2AUrI=;
        h=From:To:Cc:Subject:Date:From;
        b=eov/G+ZaRyFykqOReiOXi3cPagB0m56EN3KJadigl9U6ed26aKyjp32kaeNgZ9IP0
         duhe1Nxs7EhMraC/vOtEuGMRPAyWevf5p3BvBkKf6SZsiONyFiXm/hOJgqvRw5ZLuT
         sEdmWs544AHt0deY6uu6wc+MY5KxuSpMCt1f07vQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/62] 5.4.191-rc1 review
Date:   Tue, 26 Apr 2022 10:20:40 +0200
Message-Id: <20220426081737.209637816@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.191-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.191-rc1
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

This is the start of the stable review cycle for the 5.4.191 release.
There are 62 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.191-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.191-rc1

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

Rob Herring <robh@kernel.org>
    arm_pmu: Validate single/group leader events

Sergey Matyukevich <sergey.matyukevich@synopsys.com>
    ARC: entry: fix syscall_trace_exit argument

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Fix possible overflow in LTR decoding

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    ASoC: soc-dapm: fix two incorrect uses of list iterator

Paolo Valerio <pvalerio@redhat.com>
    openvswitch: fix OOB access in reserve_sfa_size()

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix a7 clobbering in coprocessor context load/store

Guo Ren <guoren@linux.alibaba.com>
    xtensa: patch_text: Fixup last cpu should be master

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

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    dma: at_xdmac: fix a missing check on list iterator

Zheyu Ma <zheyuma97@gmail.com>
    ata: pata_marvell: Check the 'bmdma_addr' beforing reading

Nico Pache <npache@redhat.com>
    oom_kill.c: futex: delay the OOM reaper to allow time for proper futex cleanup

Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
    EDAC/synopsys: Read the error count from the correct register

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

David Howells <dhowells@redhat.com>
    cifs: Check the IOCB_DIRECT flag, not O_DIRECT

Hongbin Wang <wh_bin@126.com>
    vxlan: fix error return code in vxlan_fdb_append

Borislav Petkov <bp@suse.de>
    ALSA: usb-audio: Fix undefined behavior due to shift overflowing the constant

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    platform/x86: samsung-laptop: Fix an unsigned comparison which can never be negative

Sameer Pujar <spujar@nvidia.com>
    reset: tegra-bpmp: Restore Handle errors in BPMP response

Kees Cook <keescook@chromium.org>
    ARM: vexpress/spc: Avoid negative array index when !SMP

Ido Schimmel <idosch@nvidia.com>
    selftests: mlxsw: vxlan_flooding: Prevent flooding of unwanted packets

Eric Dumazet <edumazet@google.com>
    netlink: reset network and mac headers in netlink_dump()

David Ahern <dsahern@kernel.org>
    l3mdev: l3mdev_master_upper_ifindex_by_index_rcu should be using netdev_master_upper_dev_get_rcu

Eric Dumazet <edumazet@google.com>
    net/sched: cls_u32: fix possible leak in u32_init_knode()

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

zhangqilong <zhangqilong3@huawei.com>
    dmaengine: mediatek:Fix PM usage reference leak of mtk_uart_apdma_alloc_chan_resources

Miaoqian Lin <linmq006@gmail.com>
    dmaengine: imx-sdma: Fix error checking in sdma_event_remap

Miaoqian Lin <linmq006@gmail.com>
    ASoC: msm8916-wcd-digital: Check failure for devm_snd_soc_register_component

Mark Brown <broonie@kernel.org>
    ASoC: atmel: Remove system clock tree configuration for at91sam9g20ek

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Clear MIDI port active flag after draining

Kuniyuki Iwashima <kuniyu@amazon.co.jp>
    tcp: Fix potential use-after-free due to double kfree()

Eric Dumazet <edumazet@google.com>
    net/sched: cls_u32: fix netns refcount changes in u32_change()

Ricardo Dias <rdias@singlestore.com>
    tcp: fix race condition when creating child sockets from syncookies

Bob Peterson <rpeterso@redhat.com>
    gfs2: assign rgrp glock before compute_bitstructs

Hangyu Hua <hbh25y@gmail.com>
    can: usb_8dev: usb_8dev_start_xmit(): fix double dev_kfree_skb() in error path

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
 arch/powerpc/kvm/book3s_64_vio.c                   | 45 +++++++-------
 arch/powerpc/kvm/book3s_64_vio_hv.c                | 44 +++++++-------
 arch/powerpc/perf/power9-pmu.c                     |  8 +--
 arch/x86/include/asm/compat.h                      |  6 +-
 arch/xtensa/kernel/coprocessor.S                   |  4 +-
 arch/xtensa/kernel/jump_label.c                    |  2 +-
 block/compat_ioctl.c                               |  2 +-
 drivers/ata/pata_marvell.c                         |  2 +
 drivers/dma/at_xdmac.c                             | 12 ++--
 drivers/dma/imx-sdma.c                             |  4 +-
 drivers/dma/mediatek/mtk-uart-apdma.c              |  9 ++-
 drivers/edac/synopsys_edac.c                       | 16 +++--
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c         |  3 +
 .../gpu/drm/panel/panel-raspberrypi-touchscreen.c  | 13 +++-
 drivers/gpu/drm/vc4/vc4_dsi.c                      |  2 +-
 drivers/net/can/usb/usb_8dev.c                     | 30 +++++-----
 drivers/net/ethernet/cadence/macb_main.c           |  8 +++
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |  8 ++-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |  4 +-
 drivers/net/ethernet/intel/igc/igc_i225.c          | 11 +++-
 drivers/net/ethernet/intel/igc/igc_phy.c           |  4 +-
 drivers/net/ethernet/micrel/Kconfig                |  1 -
 drivers/net/vxlan.c                                |  4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |  2 +-
 drivers/perf/arm_pmu.c                             | 10 ++--
 drivers/platform/x86/samsung-laptop.c              |  2 -
 drivers/reset/tegra/reset-bpmp.c                   |  9 ++-
 drivers/scsi/qedi/qedi_iscsi.c                     | 69 +++++++++++-----------
 drivers/spi/atmel-quadspi.c                        |  3 +
 drivers/staging/android/ion/ion.c                  |  3 +
 fs/cifs/cifsfs.c                                   |  2 +-
 fs/ext4/ext4.h                                     |  4 ++
 fs/ext4/inode.c                                    | 11 +++-
 fs/ext4/namei.c                                    |  4 +-
 fs/ext4/page-io.c                                  |  4 +-
 fs/ext4/super.c                                    | 19 ++++--
 fs/gfs2/rgrp.c                                     |  9 +--
 fs/jbd2/commit.c                                   |  4 +-
 fs/stat.c                                          | 19 +++---
 include/linux/etherdevice.h                        |  5 +-
 include/linux/sched.h                              |  1 +
 include/net/inet_hashtables.h                      |  5 +-
 kernel/trace/trace_events_trigger.c                |  9 ++-
 mm/oom_kill.c                                      | 54 ++++++++++++-----
 mm/page_alloc.c                                    |  2 +-
 net/dccp/ipv4.c                                    |  2 +-
 net/dccp/ipv6.c                                    |  2 +-
 net/ipv4/inet_connection_sock.c                    |  2 +-
 net/ipv4/inet_hashtables.c                         | 68 ++++++++++++++++++---
 net/ipv4/tcp_ipv4.c                                | 13 +++-
 net/ipv6/tcp_ipv6.c                                | 13 +++-
 net/l3mdev/l3mdev.c                                |  2 +-
 net/netlink/af_netlink.c                           |  7 +++
 net/openvswitch/flow_netlink.c                     |  2 +-
 net/packet/af_packet.c                             | 13 ++--
 net/rxrpc/net_ns.c                                 |  2 +
 net/sched/cls_u32.c                                | 24 ++++----
 net/smc/af_smc.c                                   |  4 +-
 sound/soc/atmel/sam9g20_wm8731.c                   | 61 -------------------
 sound/soc/codecs/msm8916-wcd-digital.c             |  9 ++-
 sound/soc/soc-dapm.c                               |  6 +-
 sound/usb/midi.c                                   |  1 +
 sound/usb/usbaudio.h                               |  2 +-
 .../selftests/drivers/net/mlxsw/vxlan_flooding.sh  | 17 ++++++
 69 files changed, 460 insertions(+), 293 deletions(-)


