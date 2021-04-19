Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86EC23643AC
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240099AbhDSNVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240612AbhDSNS6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:18:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 502D6613B2;
        Mon, 19 Apr 2021 13:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838108;
        bh=VgjBWQjMflWPUy5+fFxjQiMqIhTODQiTEhqvG5HyNsM=;
        h=From:To:Cc:Subject:Date:From;
        b=jW3k9MNXGYxXmV5DJ98GUuAFNwNBbDYx6MsWuxN5/5QA/jsfIievsKbOn4LyivOFY
         hFrmdzIqWszyquhhz8crECTBVznEPtthr5QFN2zLa7fabHo7Es+0NQMdiVSTDMe4Ih
         J1uODuRNjeNyigP5FnXyUCrXpJ/KtXX1qgtwEf8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 000/103] 5.10.32-rc1 review
Date:   Mon, 19 Apr 2021 15:05:11 +0200
Message-Id: <20210419130527.791982064@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.32-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.32-rc1
X-KernelTest-Deadline: 2021-04-21T13:05+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.32 release.
There are 103 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.32-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.32-rc1

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Move sanitize_val_alu out of op switch

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Improve verifier error messages for users

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Rework ptr_limit into alu_limit and add common error path

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mte: Ensure TIF_MTE_ASYNC_FAULT is set atomically

Fredrik Strupe <fredrik@strupe.net>
    ARM: 9071/1: uprobes: Don't hook on thumb instructions

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Move off_reg into sanitize_ptr_alu

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Ensure off_reg has no mixed signed bounds for all types

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: don't advertise pause in jumbo mode

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: tweak max read request size for newer chips also in jumbo mtu mode

Reiji Watanabe <reijiw@google.com>
    KVM: VMX: Don't use vcpu->run->internal.ndata as an array index

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Convert vcpu_vmx.exit_reason to a union

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Use correct permission flag for mixed signed bounds arithmetic

Jernej Skrabec <jernej.skrabec@siol.net>
    arm64: dts: allwinner: h6: beelink-gs1: Remove ext. 32 kHz osc reference

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: Fix SD card CD GPIO for SOPine systems

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix uninitialized sr_inst

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: footbridge: fix PCI interrupt mapping

Vladimir Murzin <vladimir.murzin@arm.com>
    ARM: 9069/1: NOMMU: Fix conversion for_each_membock() to for_each_mem_range()

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix warning for omap_init_time_of()

Eric Dumazet <edumazet@google.com>
    gro: ensure frag0 meets IP header alignment

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    ch_ktls: do not send snd_una update to TCB in middle

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    ch_ktls: tcb close causes tls connection failure

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    ch_ktls: fix device connection close

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    ch_ktls: Fix kernel panic

Lijun Pan <lijunp213@gmail.com>
    ibmvnic: remove duplicate napi_schedule call in open function

Lijun Pan <lijunp213@gmail.com>
    ibmvnic: remove duplicate napi_schedule call in do_reset function

Lijun Pan <lijunp213@gmail.com>
    ibmvnic: avoid calling napi_disable() twice

John Paul Adrian Glaubitz <glaubitz () physik ! fu-berlin ! de>
    ia64: tools: remove inclusion of ia64-specific version of errno.h header

Randy Dunlap <rdunlap@infradead.org>
    ia64: remove duplicate entries in generic_defconfig

Jakub Kicinski <kuba@kernel.org>
    ethtool: pause: make sure we init driver stats

Jason Xing <xingwanli@kuaishou.com>
    i40e: fix the panic when running bpf in xdpdrv mode

Jonathon Reinhart <jonathon.reinhart@gmail.com>
    net: Make tcp_allowed_congestion_control readonly in non-init netns

Christophe Leroy <christophe.leroy@csgroup.eu>
    mm: ptdump: fix build failure

Hristo Venev <hristo@venev.name>
    net: ip6_tunnel: Unregister catch-all devices

Hristo Venev <hristo@venev.name>
    net: sit: Unregister catch-all devices

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: davicom: Fix regulator not turned off on failed probe

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Fix setting of RS FEC mode

Eric Dumazet <edumazet@google.com>
    netfilter: nft_limit: avoid possible divide error in nft_limit_init

wenxu <wenxu@ucloud.cn>
    net/mlx5e: fix ingress_ifindex check in mlx5e_flower_parse_meta

Claudiu Beznea <claudiu.beznea@microchip.com>
    net: macb: fix the restore of cmp registers

Ciara Loftus <ciara.loftus@intel.com>
    libbpf: Fix potential NULL pointer dereference

Florian Westphal <fw@strlen.de>
    netfilter: arp_tables: add pre_exit hook for table unregister

Florian Westphal <fw@strlen.de>
    netfilter: bridge: add pre_exit hooks for ebtable unregistration

Vaibhav Jain <vaibhav@linux.ibm.com>
    libnvdimm/region: Fix nvdimm_has_flush() to handle ND_REGION_ASYNC

Colin Ian King <colin.king@canonical.com>
    ice: Fix potential infinite loop when using u8 loop counter

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: conntrack: do not print icmpv6 as unknown via /proc

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: fix NAT IPv6 offload mangling

Yongxin Liu <yongxin.liu@windriver.com>
    ixgbe: fix unbalanced device enable/disable in suspend/resume

Jolly Shah <jollys@google.com>
    scsi: libsas: Reset num_scatter if libata marks qc as NODATA

Kefeng Wang <wangkefeng.wang@huawei.com>
    riscv: Fix spelling mistake "SPARSEMEM" to "SPARSMEM"

Christian A. Ehrhardt <lk@c--e.de>
    vfio/pci: Add missing range check in vfio_pci_mmap

Nathan Chancellor <nathan@kernel.org>
    arm64: alternatives: Move length validation in alternative_{insn, endif}

Peter Collingbourne <pcc@google.com>
    arm64: fix inline asm in load_unaligned_zeropad()

Linus Torvalds <torvalds@linux-foundation.org>
    readdir: make sure to verify directory entry for legacy interfaces too

Jaegeuk Kim <jaegeuk@kernel.org>
    dm verity fec: fix misaligned RS roots IO

Ping Cheng <pinglinux@gmail.com>
    HID: wacom: set EV_KEY and EV_ABS only for non-HID_GENERIC type of devices

Arnd Bergmann <arnd@arndb.de>
    Input: i8042 - fix Pegatron C15B ID entry

Caleb Connolly <caleb@connolly.tech>
    Input: s6sy761 - fix coordinate read bit shift

Julian Braha <julianbraha@gmail.com>
    lib: fix kconfig dependency on ARCH_WANT_FRAME_POINTERS

A. Cody Schuffelen <schuffelen@google.com>
    virt_wifi: Return micros for BSS TSF values

Seevalamuthu Mariappan <seevalam@codeaurora.org>
    mac80211: clear sta->fast_rx when STA removed from 4-addr VLAN

Zheng Yongjun <zhengyongjun3@huawei.com>
    net: tipc: Fix spelling errors in net/tipc module

Aditya Pakki <pakki001@umn.edu>
    net/rds: Avoid potential use after free in rds_send_remove_from_sock

Guenter Roeck <linux@roeck-us.net>
    pcnet32: Use pci_resource_len to validate PCI resource

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for add llsec seclevel

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: stop dump llsec seclevels for monitors

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for del llsec devkey

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for add llsec devkey

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: stop dump llsec devkeys for monitors

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for del llsec dev

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for add llsec dev

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: stop dump llsec devs for monitors

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for del llsec key

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for add llsec key

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: stop dump llsec keys for monitors

Matt Chen <matt.chen@intel.com>
    iwlwifi: add support for Qu with AX201 device

Martin Wilck <mwilck@suse.com>
    scsi: scsi_transport_srp: Don't block target in SRP_PORT_LOST state

Alexander Shiyan <shc_work@mail.ru>
    ASoC: fsl_esai: Fix TDM slot setup for I2S mode

Rob Clark <robdclark@chromium.org>
    drm/msm: Fix a5xx/a6xx timestamps

Arnd Bergmann <arnd@arndb.de>
    ARM: omap1: fix building with clang IAS

Arnd Bergmann <arnd@arndb.de>
    ARM: keystone: fix integer overflow warning

Tong Zhu <zhutong@amazon.com>
    neighbour: Disregard DEAD dst in neigh_update

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    gpu/xen: Fix a use after free in xen_drm_drv_init

Ryan Lee <ryans.lee@maximintegrated.com>
    ASoC: max98373: Added 30ms turn on/off time delay

Ryan Lee <ryans.lee@maximintegrated.com>
    ASoC: max98373: Changed amp shutdown register as volatile

Xin Long <lucien.xin@gmail.com>
    xfrm: BEET mode doesn't support fragments for inner packets

Jiri Kosina <jkosina@suse.cz>
    iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_enqueue_hcmd()

Wang Qing <wangqing@vivo.com>
    arc: kernel: Return -EFAULT if copy_to_user() fails

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    lockdep: Add a missing initialization hint to the "INFO: Trying to register non-static key" message

Tony Lindgren <tony@atomide.com>
    ARM: dts: Fix moving mmc devices with aliases for omap4 & 5

Tony Lindgren <tony@atomide.com>
    ARM: dts: Drop duplicate sha2md5_fck to fix clk_disable race

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: x86: Call acpi_boot_table_init() after acpi_table_upgrade()

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix wq cleanup of WQCFG registers

Dan Carpenter <dan.carpenter@oracle.com>
    dmaengine: plx_dma: add a missing put_device() on error path

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    dmaengine: Fix a double free in dma_async_device_register

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: dw: Make it dependent to HAS_IOMEM

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix wq size store permission state

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix opcap sysfs attribute output

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix delta_rec and crc size field for completion record

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: Fix clobbering of SWERR overflow bit on writeback

Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
    gpio: sysfs: Obey valid_mask

Fabian Vogt <fabian@ritter-vogt.de>
    Input: nspire-keypad - enable interrupts only when opened

Hauke Mehrtens <hauke@hauke-m.de>
    mtd: rawnand: mtk: Fix WAITRDY break condition and timeout

Or Cohen <orcohen@paloaltonetworks.com>
    net/sctp: fix race condition in sctp_destroy_sock


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arc/kernel/signal.c                           |   4 +-
 arch/arm/boot/dts/omap4.dtsi                       |   5 +
 arch/arm/boot/dts/omap44xx-clocks.dtsi             |   8 --
 arch/arm/boot/dts/omap5.dtsi                       |   5 +
 arch/arm/mach-footbridge/cats-pci.c                |   4 +-
 arch/arm/mach-footbridge/ebsa285-pci.c             |   4 +-
 arch/arm/mach-footbridge/netwinder-pci.c           |   2 +-
 arch/arm/mach-footbridge/personal-pci.c            |   5 +-
 arch/arm/mach-keystone/keystone.c                  |   4 +-
 arch/arm/mach-omap1/ams-delta-fiq-handler.S        |   1 +
 arch/arm/mach-omap2/board-generic.c                |   2 +-
 arch/arm/mach-omap2/sr_device.c                    |   2 +-
 arch/arm/mm/pmsa-v7.c                              |   4 +-
 arch/arm/mm/pmsa-v8.c                              |   4 +-
 arch/arm/probes/uprobes/core.c                     |   4 +-
 arch/arm64/Kconfig                                 |   6 +-
 .../boot/dts/allwinner/sun50i-a64-pine64-lts.dts   |   4 +
 .../boot/dts/allwinner/sun50i-a64-sopine.dtsi      |   2 +-
 .../boot/dts/allwinner/sun50i-h6-beelink-gs1.dts   |   4 -
 arch/arm64/include/asm/alternative.h               |   8 +-
 arch/arm64/include/asm/word-at-a-time.h            |  10 +-
 arch/arm64/kernel/entry.S                          |  10 +-
 arch/ia64/configs/generic_defconfig                |   2 -
 arch/riscv/Kconfig                                 |   2 +-
 arch/x86/kernel/setup.c                            |   5 +-
 arch/x86/kvm/vmx/nested.c                          |  42 ++++---
 arch/x86/kvm/vmx/vmx.c                             |  78 ++++++------
 arch/x86/kvm/vmx/vmx.h                             |  25 +++-
 drivers/dma/dmaengine.c                            |   1 +
 drivers/dma/dw/Kconfig                             |   2 +
 drivers/dma/idxd/device.c                          |  35 ++++--
 drivers/dma/idxd/idxd.h                            |   1 +
 drivers/dma/idxd/irq.c                             |   4 +-
 drivers/dma/idxd/sysfs.c                           |  19 +--
 drivers/dma/plx_dma.c                              |  18 +--
 drivers/gpio/gpiolib-sysfs.c                       |   8 ++
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |   4 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   4 +-
 drivers/gpu/drm/xen/xen_drm_front.c                |   6 +-
 drivers/hid/wacom_wac.c                            |   6 +-
 drivers/input/keyboard/nspire-keypad.c             |  56 +++++----
 drivers/input/serio/i8042-x86ia64io.h              |   1 +
 drivers/input/touchscreen/s6sy761.c                |   4 +-
 drivers/md/dm-verity-fec.c                         |  11 +-
 drivers/md/dm-verity-fec.h                         |   1 +
 drivers/mtd/nand/raw/mtk_nand.c                    |   4 +-
 drivers/net/ethernet/amd/pcnet32.c                 |   5 +-
 drivers/net/ethernet/cadence/macb_main.c           |   2 +-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c      | 102 ++-------------
 drivers/net/ethernet/davicom/dm9000.c              |   6 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  14 +--
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   6 +
 drivers/net/ethernet/intel/ice/ice_dcb.c           |   4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  |  23 +---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   3 +
 drivers/net/ethernet/realtek/r8169_main.c          |  18 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   1 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   7 +-
 drivers/net/wireless/virt_wifi.c                   |   5 +-
 drivers/nvdimm/region_devs.c                       |   9 +-
 drivers/scsi/libsas/sas_ata.c                      |   9 +-
 drivers/scsi/scsi_transport_srp.c                  |   2 +-
 drivers/vfio/pci/vfio_pci.c                        |   4 +-
 fs/readdir.c                                       |   6 +
 include/linux/netfilter_arp/arp_tables.h           |   5 +-
 include/linux/netfilter_bridge/ebtables.h          |   5 +-
 include/uapi/linux/idxd.h                          |   4 +-
 kernel/bpf/verifier.c                              | 138 ++++++++++++++-------
 kernel/locking/lockdep.c                           |   3 +-
 lib/Kconfig.debug                                  |   6 +-
 mm/ptdump.c                                        |   2 +-
 net/bridge/netfilter/ebtable_broute.c              |   8 +-
 net/bridge/netfilter/ebtable_filter.c              |   8 +-
 net/bridge/netfilter/ebtable_nat.c                 |   8 +-
 net/bridge/netfilter/ebtables.c                    |  30 ++++-
 net/core/dev.c                                     |   3 +-
 net/core/neighbour.c                               |   2 +-
 net/ethtool/pause.c                                |   8 +-
 net/ieee802154/nl802154.c                          |  41 ++++++
 net/ipv4/netfilter/arp_tables.c                    |   9 +-
 net/ipv4/netfilter/arptable_filter.c               |  10 +-
 net/ipv4/sysctl_net_ipv4.c                         |  16 ++-
 net/ipv6/ip6_tunnel.c                              |  10 ++
 net/ipv6/sit.c                                     |   4 +-
 net/mac80211/cfg.c                                 |   4 +-
 net/netfilter/nf_conntrack_standalone.c            |   1 +
 net/netfilter/nf_flow_table_offload.c              |   6 +-
 net/netfilter/nft_limit.c                          |   4 +-
 net/rds/message.c                                  |   1 +
 net/rds/send.c                                     |   2 +-
 net/sctp/socket.c                                  |  13 +-
 net/tipc/bearer.h                                  |   6 +-
 net/tipc/net.c                                     |   2 +-
 net/tipc/node.c                                    |   2 +-
 net/xfrm/xfrm_output.c                             |  13 ++
 sound/soc/codecs/max98373-i2c.c                    |   1 +
 sound/soc/codecs/max98373-sdw.c                    |   1 +
 sound/soc/codecs/max98373.c                        |   2 +
 sound/soc/fsl/fsl_esai.c                           |   8 +-
 tools/include/uapi/asm/errno.h                     |   2 -
 tools/lib/bpf/xsk.c                                |   5 +-
 103 files changed, 641 insertions(+), 428 deletions(-)


