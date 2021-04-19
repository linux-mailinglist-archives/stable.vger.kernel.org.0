Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A79364422
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242213AbhDSNZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241750AbhDSNYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:24:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C31E61412;
        Mon, 19 Apr 2021 13:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838353;
        bh=OQR2QyFkJbpj6BoAjAx/oZztS1ysD2283ML5Ly0xNHQ=;
        h=From:To:Cc:Subject:Date:From;
        b=sipOO1SEQjPASIPqmyHpNuYFYNDAfSP0tPxP+XHTCDAwTWEwF0kLZcMWAa82o/gcl
         M8HTt5rh8gDC+f8NCF+sKmeM4CK4Vo4eMl2LUWjxtmrxBY5dAx4yW218JxTnsjTjZO
         BJ9xHXlx6zTAyKgCcysWQf/kbVOokRyWDdKeipWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/73] 5.4.114-rc1 review
Date:   Mon, 19 Apr 2021 15:05:51 +0200
Message-Id: <20210419130523.802169214@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.114-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.114-rc1
X-KernelTest-Deadline: 2021-04-21T13:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.114 release.
There are 73 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.114-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.114-rc1

Pali Rohár <pali@kernel.org>
    net: phy: marvell: fix detection of PHY on Topaz switches

Fredrik Strupe <fredrik@strupe.net>
    ARM: 9071/1: uprobes: Don't hook on thumb instructions

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: don't advertise pause in jumbo mode

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: tweak max read request size for newer chips also in jumbo mtu mode

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: improve rtl_jumbo_config

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix performance regression related to PCIe max read request size

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: simplify setting PCI_EXP_DEVCTL_NOSNOOP_EN

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: remove fiddling with the PCIe max read request size

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: Fix SD card CD GPIO for SOPine systems

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: footbridge: fix PCI interrupt mapping

Eric Dumazet <edumazet@google.com>
    gro: ensure frag0 meets IP header alignment

Lijun Pan <lijunp213@gmail.com>
    ibmvnic: remove duplicate napi_schedule call in open function

Lijun Pan <lijunp213@gmail.com>
    ibmvnic: remove duplicate napi_schedule call in do_reset function

Lijun Pan <lijunp213@gmail.com>
    ibmvnic: avoid calling napi_disable() twice

Jason Xing <xingwanli@kuaishou.com>
    i40e: fix the panic when running bpf in xdpdrv mode

Hristo Venev <hristo@venev.name>
    net: ip6_tunnel: Unregister catch-all devices

Hristo Venev <hristo@venev.name>
    net: sit: Unregister catch-all devices

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: davicom: Fix regulator not turned off on failed probe

Eric Dumazet <edumazet@google.com>
    netfilter: nft_limit: avoid possible divide error in nft_limit_init

Claudiu Beznea <claudiu.beznea@microchip.com>
    net: macb: fix the restore of cmp registers

Florian Westphal <fw@strlen.de>
    netfilter: arp_tables: add pre_exit hook for table unregister

Florian Westphal <fw@strlen.de>
    netfilter: bridge: add pre_exit hooks for ebtable unregistration

Vaibhav Jain <vaibhav@linux.ibm.com>
    libnvdimm/region: Fix nvdimm_has_flush() to handle ND_REGION_ASYNC

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: conntrack: do not print icmpv6 as unknown via /proc

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

Ryan Lee <ryans.lee@maximintegrated.com>
    ASoC: max98373: Added 30ms turn on/off time delay

Wang Qing <wangqing@vivo.com>
    arc: kernel: Return -EFAULT if copy_to_user() fails

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    lockdep: Add a missing initialization hint to the "INFO: Trying to register non-static key" message

Tony Lindgren <tony@atomide.com>
    ARM: dts: Fix moving mmc devices with aliases for omap4 & 5

Tony Lindgren <tony@atomide.com>
    ARM: dts: Drop duplicate sha2md5_fck to fix clk_disable race

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: dw: Make it dependent to HAS_IOMEM

Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
    gpio: sysfs: Obey valid_mask

Fabian Vogt <fabian@ritter-vogt.de>
    Input: nspire-keypad - enable interrupts only when opened

Or Cohen <orcohen@paloaltonetworks.com>
    net/sctp: fix race condition in sctp_destroy_sock

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix fabric scan hang

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix stuck login session using prli_pend_timer

Shyam Sundar <ssundar@marvell.com>
    scsi: qla2xxx: Add a shadow variable to hold disc_state history of fcport

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Retry PLOGI on FC-NVMe PRLI failure

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix device connect issues in P2P configuration

Michael Hernandez <mhernandez@marvell.com>
    scsi: qla2xxx: Dual FCP-NVMe target port support

Sasha Levin <sashal@kernel.org>
    Revert "scsi: qla2xxx: Fix stuck login session using prli_pend_timer"

Sasha Levin <sashal@kernel.org>
    Revert "scsi: qla2xxx: Retry PLOGI on FC-NVMe PRLI failure"


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
 arch/arm/probes/uprobes/core.c                     |   4 +-
 .../boot/dts/allwinner/sun50i-a64-pine64-lts.dts   |   4 +
 .../boot/dts/allwinner/sun50i-a64-sopine.dtsi      |   2 +-
 arch/arm64/include/asm/alternative.h               |   8 +-
 arch/arm64/include/asm/word-at-a-time.h            |  10 +-
 arch/riscv/Kconfig                                 |   2 +-
 drivers/dma/dw/Kconfig                             |   2 +
 drivers/gpio/gpiolib-sysfs.c                       |   8 ++
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |   4 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   4 +-
 drivers/hid/wacom_wac.c                            |   6 +-
 drivers/input/keyboard/nspire-keypad.c             |  56 ++++----
 drivers/input/serio/i8042-x86ia64io.h              |   1 +
 drivers/input/touchscreen/s6sy761.c                |   4 +-
 drivers/md/dm-verity-fec.c                         |  11 +-
 drivers/md/dm-verity-fec.h                         |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |  30 ++---
 drivers/net/ethernet/amd/pcnet32.c                 |   5 +-
 drivers/net/ethernet/cadence/macb_main.c           |   2 +-
 drivers/net/ethernet/davicom/dm9000.c              |   6 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  14 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   6 +
 drivers/net/ethernet/realtek/r8169_main.c          | 141 +++++++--------------
 drivers/net/phy/marvell.c                          |  29 ++++-
 drivers/net/wireless/virt_wifi.c                   |   5 +-
 drivers/nvdimm/region_devs.c                       |   9 +-
 drivers/scsi/libsas/sas_ata.c                      |   9 +-
 drivers/scsi/qla2xxx/qla_dbg.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_def.h                     |  40 +++++-
 drivers/scsi/qla2xxx/qla_fw.h                      |   2 +
 drivers/scsi/qla2xxx/qla_gbl.h                     |   3 +
 drivers/scsi/qla2xxx/qla_gs.c                      |  44 ++++---
 drivers/scsi/qla2xxx/qla_init.c                    | 133 +++++++++++--------
 drivers/scsi/qla2xxx/qla_inline.h                  |  36 ++++++
 drivers/scsi/qla2xxx/qla_iocb.c                    |  53 ++++++--
 drivers/scsi/qla2xxx/qla_mbx.c                     |  11 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  19 ++-
 drivers/scsi/qla2xxx/qla_target.c                  |  11 +-
 drivers/scsi/scsi_transport_srp.c                  |   2 +-
 drivers/vfio/pci/vfio_pci.c                        |   4 +-
 fs/readdir.c                                       |   6 +
 include/linux/marvell_phy.h                        |   5 +-
 include/linux/netfilter_arp/arp_tables.h           |   5 +-
 include/linux/netfilter_bridge/ebtables.h          |   5 +-
 kernel/locking/lockdep.c                           |   3 +-
 net/bridge/netfilter/ebtable_broute.c              |   8 +-
 net/bridge/netfilter/ebtable_filter.c              |   8 +-
 net/bridge/netfilter/ebtable_nat.c                 |   8 +-
 net/bridge/netfilter/ebtables.c                    |  30 ++++-
 net/core/dev.c                                     |   3 +-
 net/core/neighbour.c                               |   2 +-
 net/ieee802154/nl802154.c                          |  41 ++++++
 net/ipv4/netfilter/arp_tables.c                    |   9 +-
 net/ipv4/netfilter/arptable_filter.c               |  10 +-
 net/ipv6/ip6_tunnel.c                              |  10 ++
 net/ipv6/sit.c                                     |   4 +-
 net/mac80211/cfg.c                                 |   4 +-
 net/netfilter/nf_conntrack_standalone.c            |   1 +
 net/netfilter/nft_limit.c                          |   4 +-
 net/rds/message.c                                  |   1 +
 net/rds/send.c                                     |   2 +-
 net/sctp/socket.c                                  |  13 +-
 net/tipc/bearer.h                                  |   6 +-
 net/tipc/net.c                                     |   2 +-
 net/tipc/node.c                                    |   2 +-
 sound/soc/codecs/max98373.c                        |   2 +
 sound/soc/fsl/fsl_esai.c                           |   8 +-
 78 files changed, 625 insertions(+), 366 deletions(-)


