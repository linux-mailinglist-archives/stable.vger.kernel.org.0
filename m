Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BADE752182D
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbiEJNdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244157AbiEJNcj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:32:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3289236758;
        Tue, 10 May 2022 06:24:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F34D5B81DA9;
        Tue, 10 May 2022 13:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F26C385A6;
        Tue, 10 May 2022 13:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189049;
        bh=w8HH2Si18AnzWnnKEtan5BKvjchqHsV5zOUW5a1IZd0=;
        h=From:To:Cc:Subject:Date:From;
        b=M2ZSuZRUc43IVhdbY+HsKgFeR+hb+FloXQMZ9D1AMoaR5RSIP1Y13rYzTzZ8f8G5y
         Sa7P9Myfhh0MBB08Bp5N7z5ekKbw7pCmpwWQjEnrewl8O22dPwJenzm9jjrXEiQOFc
         32yr+l1sRq3lezqzZ/dxpUQIsGxtrSgAWt/rHocI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/52] 5.4.193-rc1 review
Date:   Tue, 10 May 2022 15:07:29 +0200
Message-Id: <20220510130729.852544477@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.193-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.193-rc1
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

This is the start of the stable review cycle for the 5.4.193 release.
There are 52 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.193-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.193-rc1

Ricky WU <ricky_wu@realtek.com>
    mmc: rtsx: add 74 Clocks in power on flow

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix reading MSI interrupt number

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Clear all MSIs at setup

Mike Snitzer <snitzer@redhat.com>
    dm: interlock pending dm_io and dm_wait_for_bios_completion

Jiazi Li <jqqlijiazi@gmail.com>
    dm: fix mempool NULL pointer race when completing IO

Eric Dumazet <edumazet@google.com>
    tcp: make sure treq->af_specific is initialized

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix potential AB/BA lock with buffer_mutex and mmap_lock

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix races among concurrent prealloc proc writes

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix races among concurrent prepare and hw_params/hw_free calls

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix races among concurrent read/write and buffer changes

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix races among concurrent hw_params and hw_free calls

Minchan Kim <minchan@kernel.org>
    mm: fix unexpected zeroed page mapping with zram swap

Haimin Zhang <tcs.kernel@gmail.com>
    block-map: add __GFP_ZERO flag for alloc_page in function bio_copy_kern

j.nixdorf@avm.de <j.nixdorf@avm.de>
    net: ipv6: ensure we call ipv6_mc_down() at most once

Wanpeng Li <wanpengli@tencent.com>
    KVM: LAPIC: Enable timer posted-interrupt only when mwait/hlt is advertised

Wanpeng Li <wanpengli@tencent.com>
    x86/kvm: Preserve BSP MSR_KVM_POLL_CONTROL across suspend/resume

Sandipan Das <sandipan.das@amd.com>
    kvm: x86/cpuid: Only provide CPUID leaf 0xA if host has architectural PMU

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Don't invalidate inode attributes on delegation return

Felix Kuehling <Felix.Kuehling@amd.com>
    drm/amdkfd: Use drm_priv to pass VM from KFD to amdgpu

Eric Dumazet <edumazet@google.com>
    net: igmp: respect RCU rules in ip_mc_source() and ip_mc_msfilter()

Filipe Manana <fdmanana@suse.com>
    btrfs: always log symlinks in full mode

Sergey Shtylyov <s.shtylyov@omp.ru>
    smsc911x: allow using IRQ0

Somnath Kotur <somnath.kotur@broadcom.com>
    bnxt_en: Fix possible bnxt_open() failure caused by wrong RFS flag

Ido Schimmel <idosch@nvidia.com>
    selftests: mirror_gre_bridge_1q: Avoid changing PVID while interface is operational

Shravya Kumbham <shravya.kumbham@xilinx.com>
    net: emaclite: Add error handling for of_address_to_resource()

Yang Yingliang <yangyingliang@huawei.com>
    net: stmmac: dwmac-sun8i: add missing of_node_put() in sun8i_dwmac_register_mdio_mux()

Yang Yingliang <yangyingliang@huawei.com>
    net: ethernet: mediatek: add missing of_node_put() in mtk_sgmii_init()

Cheng Xu <chengyou@linux.alibaba.com>
    RDMA/siw: Fix a condition race issue in MPA request processing

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    ASoC: dmaengine: Restore NULL prepare_slave_config() callback

Armin Wolf <W_Armin@gmx.de>
    hwmon: (adt7470) Fix warning on module removal

Duoming Zhou <duoming@zju.edu.cn>
    NFC: netlink: fix sleep in atomic bug when firmware download timeout

Duoming Zhou <duoming@zju.edu.cn>
    nfc: nfcmrvl: main: reorder destructive operations in nfcmrvl_nci_unregister_dev to avoid bugs

Duoming Zhou <duoming@zju.edu.cn>
    nfc: replace improper check device_is_registered() in netlink related functions

Daniel Hellstrom <daniel@gaisler.com>
    can: grcan: use ofdev->dev when allocating DMA memory

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
    ASoC: meson: Fix event generation for G12A tohdmi mux

Mark Brown <broonie@kernel.org>
    ASoC: wm8958: Fix change notifications for DSP controls

Mark Brown <broonie@kernel.org>
    ASoC: da7219: Fix change notifications for tone generator frequency

Thomas Pfaff <tpfaff@pcs.com>
    genirq: Synchronize interrupt thread startup

Vegard Nossum <vegard.nossum@oracle.com>
    ACPICA: Always create namespace nodes using acpi_ns_create_node()

Niels Dossche <dossche.niels@gmail.com>
    firewire: core: extend card->lock in fw_core_handle_bus_reset

Jakob Koschel <jakobkoschel@gmail.com>
    firewire: remove check of list iterator against head past the loop body

Chengfeng Ye <cyeaa@connect.ust.hk>
    firewire: fix potential uaf in outbound_phy_packet_callback()

Trond Myklebust <trond.myklebust@hammerspace.com>
    Revert "SUNRPC: attempt AF_LOCAL connect on setup"

Andrei Lalaev <andrei.lalaev@emlid.com>
    gpiolib: of: fix bounds check for 'gpio-reserved-ranges'

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: fireworks: fix wrong return count shorter than expected by 4 bytes

Helge Deller <deller@gmx.de>
    parisc: Merge model and model name into one line in /proc/cpuinfo

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Fix CP0 counter erratum detection for R4k CPUs


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/mips/include/asm/timex.h                      |   8 +-
 arch/mips/kernel/time.c                            |  11 +--
 arch/parisc/kernel/processor.c                     |   3 +-
 arch/x86/kernel/kvm.c                              |  13 +++
 arch/x86/kvm/cpuid.c                               |   5 +
 arch/x86/kvm/lapic.c                               |   3 +-
 block/bio.c                                        |   2 +-
 drivers/acpi/acpica/nsaccess.c                     |   3 +-
 drivers/firewire/core-card.c                       |   3 +
 drivers/firewire/core-cdev.c                       |   4 +-
 drivers/firewire/core-topology.c                   |   9 +-
 drivers/firewire/core-transaction.c                |  30 +++---
 drivers/firewire/sbp2.c                            |  13 +--
 drivers/gpio/gpiolib-of.c                          |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |  10 +-
 drivers/hwmon/adt7470.c                            |   4 +-
 drivers/infiniband/sw/siw/siw_cm.c                 |   7 +-
 drivers/md/dm.c                                    |  25 +++--
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |  31 ++++--
 drivers/net/can/grcan.c                            |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   9 +-
 drivers/net/ethernet/mediatek/mtk_sgmii.c          |   1 +
 drivers/net/ethernet/smsc/smsc911x.c               |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   1 +
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |  15 ++-
 drivers/nfc/nfcmrvl/main.c                         |   2 +-
 drivers/pci/controller/pci-aardvark.c              |  16 ++-
 drivers/s390/block/dasd.c                          |  18 +++-
 drivers/s390/block/dasd_eckd.c                     |  28 ++++--
 drivers/s390/block/dasd_int.h                      |  14 +++
 fs/btrfs/tree-log.c                                |  14 ++-
 fs/nfs/nfs4proc.c                                  |  12 ++-
 include/net/tcp.h                                  |   5 +
 include/sound/pcm.h                                |   2 +
 kernel/irq/internals.h                             |   2 +
 kernel/irq/irqdesc.c                               |   2 +
 kernel/irq/manage.c                                |  39 ++++++--
 mm/page_io.c                                       |  54 ----------
 net/ipv4/igmp.c                                    |   9 +-
 net/ipv4/syncookies.c                              |   1 +
 net/ipv4/tcp_ipv4.c                                |   2 +-
 net/ipv6/addrconf.c                                |   8 +-
 net/ipv6/syncookies.c                              |   1 +
 net/ipv6/tcp_ipv6.c                                |   2 +-
 net/nfc/core.c                                     |  29 +++---
 net/nfc/netlink.c                                  |   4 +-
 net/sunrpc/xprtsock.c                              |   3 -
 sound/core/pcm.c                                   |   3 +
 sound/core/pcm_lib.c                               |   5 +
 sound/core/pcm_memory.c                            |  11 ++-
 sound/core/pcm_native.c                            | 110 +++++++++++++++------
 sound/firewire/fireworks/fireworks_hwdep.c         |   1 +
 sound/soc/codecs/da7219.c                          |  14 ++-
 sound/soc/codecs/wm8958-dsp2.c                     |   8 +-
 sound/soc/meson/g12a-tohdmitx.c                    |   2 +-
 sound/soc/soc-generic-dmaengine-pcm.c              |   6 +-
 .../net/forwarding/mirror_gre_bridge_1q.sh         |   3 +
 58 files changed, 409 insertions(+), 247 deletions(-)


