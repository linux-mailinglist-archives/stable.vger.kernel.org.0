Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2020036ADF7
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhDZHkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:40:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233243AbhDZHjS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:39:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22D98613AA;
        Mon, 26 Apr 2021 07:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422620;
        bh=wEREYH772sfHaHnRTTVFf5eRCFWxbRRd0Mac/e3XFaQ=;
        h=From:To:Cc:Subject:Date:From;
        b=s4SfSyPCpZOPBJuPipjasihJMsVqhKou+QmYJFPKjFpjgZSiq0HviOFJ5ccFrAWjy
         YYxUOiEEr/CVOUm2borJ6NXxPsduo2xTXjh6yJQ0AD8o6g7DCVRMcx6f0mzCIa3ZhC
         AYOP9F77RnTYoiCSKWUZsQprd4RxIh6SH0au4xTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/57] 4.19.189-rc1 review
Date:   Mon, 26 Apr 2021 09:28:57 +0200
Message-Id: <20210426072820.568997499@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.189-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.189-rc1
X-KernelTest-Deadline: 2021-04-28T07:28+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.189 release.
There are 57 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.189-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.189-rc1

Mike Galbraith <efault@gmx.de>
    x86/crash: Fix crash_setup_memmap_entries() out-of-bounds access

John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
    ia64: tools: remove duplicate definition of ia64_mf() on ia64

Randy Dunlap <rdunlap@infradead.org>
    ia64: fix discontig.c section mismatches

Wan Jiabing <wanjiabing@vivo.com>
    cavium/liquidio: Fix duplicate argument

Michael Brown <mbrown@fensystems.co.uk>
    xen-netback: Check for hotplug-status existence before watching

Vasily Gorbik <gor@linux.ibm.com>
    s390/entry: save the caller of psw_idle

Phillip Potter <phil@philpotter.co.uk>
    net: geneve: check skb is large enough for IPv4/IPv6 header

Tony Lindgren <tony@atomide.com>
    ARM: dts: Fix swapped mmc order for omap3

Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
    HID: wacom: Assign boolean values to a bool variable

Jia-Ju Bai <baijiaju1990@gmail.com>
    HID: alps: fix error return code in alps_input_configured()

Shou-Chieh Hsu <shouchieh@chromium.org>
    HID: google: add don USB id

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Remove uncore extra PCI dev HSWEP_PCI_PCU_3

Ali Saidi <alisaidi@amazon.com>
    locking/qrwlock: Fix ordering in queued_write_lock_slowpath()

Yuanyuan Zhong <yzhong@purestorage.com>
    pinctrl: lewisburg: Update number of pins in community

Linus Torvalds <torvalds@linux-foundation.org>
    gup: document and work around "COW can break either way" issue

Pali Rohár <pali@kernel.org>
    net: phy: marvell: fix detection of PHY on Topaz switches

Fredrik Strupe <fredrik@strupe.net>
    ARM: 9071/1: uprobes: Don't hook on thumb instructions

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: footbridge: fix PCI interrupt mapping

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

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: conntrack: do not print icmpv6 as unknown via /proc

Jolly Shah <jollys@google.com>
    scsi: libsas: Reset num_scatter if libata marks qc as NODATA

Nathan Chancellor <nathan@kernel.org>
    arm64: alternatives: Move length validation in alternative_{insn, endif}

Peter Collingbourne <pcc@google.com>
    arm64: fix inline asm in load_unaligned_zeropad()

Linus Torvalds <torvalds@linux-foundation.org>
    readdir: make sure to verify directory entry for legacy interfaces too

Jaegeuk Kim <jaegeuk@google.com>
    dm verity fec: fix misaligned RS roots IO

Ping Cheng <pinglinux@gmail.com>
    HID: wacom: set EV_KEY and EV_ABS only for non-HID_GENERIC type of devices

Arnd Bergmann <arnd@arndb.de>
    Input: i8042 - fix Pegatron C15B ID entry

Caleb Connolly <caleb@connolly.tech>
    Input: s6sy761 - fix coordinate read bit shift

Seevalamuthu Mariappan <seevalam@codeaurora.org>
    mac80211: clear sta->fast_rx when STA removed from 4-addr VLAN

Guenter Roeck <linux@roeck-us.net>
    pcnet32: Use pci_resource_len to validate PCI resource

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for add llsec seclevel

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: stop dump llsec seclevels for monitors

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for add llsec devkey

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: stop dump llsec devkeys for monitors

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for add llsec dev

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: stop dump llsec devs for monitors

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: stop dump llsec keys for monitors

Martin Wilck <mwilck@suse.com>
    scsi: scsi_transport_srp: Don't block target in SRP_PORT_LOST state

Alexander Shiyan <shc_work@mail.ru>
    ASoC: fsl_esai: Fix TDM slot setup for I2S mode

Rob Clark <robdclark@chromium.org>
    drm/msm: Fix a5xx/a6xx timestamps

Arnd Bergmann <arnd@arndb.de>
    ARM: keystone: fix integer overflow warning

Tong Zhu <zhutong@amazon.com>
    neighbour: Disregard DEAD dst in neigh_update

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


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arc/kernel/signal.c                           |  4 +-
 arch/arm/boot/dts/omap3.dtsi                       |  3 ++
 arch/arm/boot/dts/omap4.dtsi                       |  5 ++
 arch/arm/boot/dts/omap44xx-clocks.dtsi             |  8 ---
 arch/arm/boot/dts/omap5.dtsi                       |  5 ++
 arch/arm/mach-footbridge/cats-pci.c                |  4 +-
 arch/arm/mach-footbridge/ebsa285-pci.c             |  4 +-
 arch/arm/mach-footbridge/netwinder-pci.c           |  2 +-
 arch/arm/mach-footbridge/personal-pci.c            |  5 +-
 arch/arm/mach-keystone/keystone.c                  |  4 +-
 arch/arm/probes/uprobes/core.c                     |  4 +-
 arch/arm64/include/asm/alternative.h               |  8 +--
 arch/arm64/include/asm/word-at-a-time.h            | 10 ++--
 arch/ia64/mm/discontig.c                           |  6 +--
 arch/s390/kernel/entry.S                           |  1 +
 arch/x86/events/intel/uncore_snbep.c               | 61 +++++++++-------------
 arch/x86/kernel/crash.c                            |  2 +-
 drivers/dma/dw/Kconfig                             |  2 +
 drivers/gpio/gpiolib-sysfs.c                       |  8 +++
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |  4 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  4 +-
 drivers/hid/hid-alps.c                             |  1 +
 drivers/hid/hid-google-hammer.c                    |  2 +
 drivers/hid/hid-ids.h                              |  1 +
 drivers/hid/wacom_wac.c                            |  8 ++-
 drivers/input/keyboard/nspire-keypad.c             | 56 +++++++++++---------
 drivers/input/serio/i8042-x86ia64io.h              |  1 +
 drivers/input/touchscreen/s6sy761.c                |  4 +-
 drivers/md/dm-verity-fec.c                         | 11 ++--
 drivers/md/dm-verity-fec.h                         |  1 +
 drivers/net/dsa/mv88e6xxx/chip.c                   | 30 +++++------
 drivers/net/ethernet/amd/pcnet32.c                 |  5 +-
 drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h |  2 +-
 drivers/net/ethernet/davicom/dm9000.c              |  6 ++-
 drivers/net/ethernet/ibm/ibmvnic.c                 | 14 +----
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  6 +++
 drivers/net/geneve.c                               |  6 +++
 drivers/net/phy/marvell.c                          | 28 ++++++++--
 drivers/net/xen-netback/xenbus.c                   | 12 +++--
 drivers/pinctrl/intel/pinctrl-lewisburg.c          |  6 +--
 drivers/scsi/libsas/sas_ata.c                      |  9 ++--
 drivers/scsi/scsi_transport_srp.c                  |  2 +-
 fs/readdir.c                                       |  6 +++
 include/linux/marvell_phy.h                        |  5 +-
 kernel/locking/lockdep.c                           |  3 +-
 kernel/locking/qrwlock.c                           |  7 +--
 mm/gup.c                                           | 44 +++++++++++++---
 mm/huge_memory.c                                   |  7 ++-
 net/core/neighbour.c                               |  2 +-
 net/ieee802154/nl802154.c                          | 29 ++++++++++
 net/ipv6/ip6_tunnel.c                              | 10 ++++
 net/ipv6/sit.c                                     |  4 +-
 net/mac80211/cfg.c                                 |  4 +-
 net/netfilter/nf_conntrack_standalone.c            |  1 +
 net/netfilter/nft_limit.c                          |  4 +-
 net/sctp/socket.c                                  | 13 ++---
 sound/soc/fsl/fsl_esai.c                           |  8 +--
 tools/arch/ia64/include/asm/barrier.h              |  3 --
 59 files changed, 322 insertions(+), 197 deletions(-)


