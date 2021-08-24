Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049B23F6615
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbhHXRUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240426AbhHXRSY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:18:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7792D61373;
        Tue, 24 Aug 2021 17:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824572;
        bh=GgG+GpTWX2Y9rqxgXlkgsvlfIZ+ncRyZdpXf7yGGrbY=;
        h=From:To:Cc:Subject:Date:From;
        b=eCiBHSqIVXm0lC4ot+VXt7BjTRvX3ddbUWzbD5PcQ5oevj1My3qlDxb19upCowysn
         RqUGp2fn2xHD0L++9mbL3AbetSzVj0G9iXCYQ1WOE1GH1+/Ip5xeHrY+3rgZZf2LRn
         4yitv/WcGTc8xk2Pgf9zVtlSEX9mnKsjYpOqT8ZOP7umMhTjsfcdFi1RRZRC1zAsdf
         HP+6qMZjaIcTuk2V6R9yY2mLBNMGJrz/JkzjRB5P6cK+CiZFzNeE+BTet5NWycF27w
         o0ceq9VWniKiu857/PhKxPTcQZs8kdymFt6yvF1ALu7Hx6GcWudLr1ClNB4XJKNJ7l
         Ph+mqB4kxSmuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de
Subject: [PATCH 4.19 00/84] 4.19.205-rc1 review
Date:   Tue, 24 Aug 2021 13:01:26 -0400
Message-Id: <20210824170250.710392-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is the start of the stable review cycle for the 4.19.205 release.
There are 84 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu 26 Aug 2021 05:02:47 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-4.19.y&id2=v4.19.204
or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

Thanks,
Sasha

-------------
Pseudo-Shortlog of commits:

Adrian Larumbe (1):
  dmaengine: xilinx_dma: Fix read-after-free bug when terminating
    transfers

Andy Shevchenko (1):
  ptp_pch: Restore dependency on PCI

Babu Moger (1):
  x86/resctrl: Fix default monitoring groups reporting

Bixuan Cui (1):
  genirq/msi: Ensure deactivation on teardown

Chris Lesiak (1):
  iio: humidity: hdc100x: Add margin to the conversion time

Colin Ian King (1):
  iio: adc: Fix incorrect exit of for-loop

DENG Qingfang (1):
  net: dsa: mt7530: add the missing RxUnicast MIB counter

Dan Williams (1):
  ACPI: NFIT: Fix support for virtual SPA ranges

Dave Gerlach (1):
  ARM: dts: am43x-epos-evm: Reduce i2c0 bus speed for tps65218

Dinghao Liu (1):
  net: qlcnic: add missed unlock in qlcnic_83xx_flash_read32

Dongliang Mu (4):
  ieee802154: hwsim: fix GPF in hwsim_set_edge_lqi
  ieee802154: hwsim: fix GPF in hwsim_new_edge_nl
  ipack: tpci200: fix many double free issues in tpci200_pci_probe
  ipack: tpci200: fix memory leak in the tpci200_register

Eric Dumazet (2):
  net: igmp: fix data-race in igmp_ifc_timer_expire()
  net: igmp: increase size of mr_ifc_count

Greg Kroah-Hartman (1):
  i2c: dev: zero out array used for i2c reads from userspace

Harshvardhan Jha (1):
  scsi: megaraid_mm: Fix end of loop tests for list_for_each_entry()

Ivan T. Ivanov (1):
  net: usb: lan78xx: don't modify phy_device state concurrently

Jakub Kicinski (2):
  bnxt: don't lock the tx queue from napi poll
  bnxt: disable napi before canceling DIM

Jaroslav Kysela (1):
  ALSA: hda - fix the 'Capture Switch' value change notifications

Jeff Layton (2):
  locks: print a warning when mount fails due to lack of "mand" support
  fs: warn about impending deprecation of mandatory locks

Johannes Berg (1):
  mac80211: drop data frames without key on encrypted links

Jouni Malinen (5):
  ath: Use safer key clearing with key cache entries
  ath9k: Clear key cache explicitly on disabling hardware
  ath: Export ath_hw_keysetmac()
  ath: Modify ath_key_delete() to not need full key entry
  ath9k: Postpone key cache entry deletion for TXQ frames reference it

Longpeng(Mike) (1):
  vsock/virtio: avoid potential deadlock when vsock device remove

Marcin Bachry (1):
  PCI: Increase D3 delay for AMD Renoir/Cezanne XHCI

Marek Behún (1):
  cpufreq: armada-37xx: forbid cpufreq for 1.2 GHz variant

Maxim Levitsky (2):
  KVM: nSVM: always intercept VMLOAD/VMSAVE when nested (CVE-2021-3656)
  KVM: nSVM: avoid picking up unsupported bits from L2 in int_ctl
    (CVE-2021-3653)

Maximilian Heyne (1):
  xen/events: Fix race in set_evtchn_to_irq

Nathan Chancellor (1):
  vmlinux.lds.h: Handle clang's module.{c,d}tor sections

Neal Cardwell (1):
  tcp_bbr: fix u32 wrap bug in round logic if bbr_init() called after 2B
    packets

NeilBrown (1):
  btrfs: prevent rename2 from exchanging a subvol with a directory from
    different parents

Ole Bjørn Midtbø (1):
  Bluetooth: hidp: use correct wait queue when removing ctrl_wait

Pali Rohár (1):
  ppp: Fix generating ifname when empty IFLA_IFNAME is specified

Pavel Skripkin (1):
  net: 6pack: fix slab-out-of-bounds in decode_data

Peter Ujfalusi (1):
  dmaengine: of-dma: router_xlate to return -EPROBE_DEFER if controller
    is not yet available

Pu Lehui (1):
  powerpc/kprobes: Fix kprobe Oops happens in booke

Randy Dunlap (2):
  x86/tools: Fix objdump version check again
  dccp: add do-while-0 stubs for dccp_pr_debug macros

Richard Fitzgerald (5):
  ASoC: cs42l42: Correct definition of ADC Volume control
  ASoC: cs42l42: Don't allow SND_SOC_DAIFMT_LEFT_J
  ASoC: cs42l42: Fix inversion of ADC Notch Switch control
  ASoC: cs42l42: Remove duplicate control for WNF filter frequency
  ASoC: cs42l42: Fix LRCLK frame start edge

Roi Dayan (1):
  psample: Add a fwd declaration for skbuff

Saeed Mirzamohammadi (1):
  iommu/vt-d: Fix agaw for a supported 48 bit guest address width

Saravana Kannan (2):
  net: mdio-mux: Don't ignore memory allocation errors
  net: mdio-mux: Handle -EPROBE_DEFER correctly

Sasha Levin (1):
  Linux 4.19.205-rc1

Sergey Marinkevich (1):
  netfilter: nft_exthdr: fix endianness of tcp option cast

Sreekanth Reddy (1):
  scsi: core: Avoid printing an error if target_alloc() returns -ENXIO

Srinivas Kandagatla (3):
  slimbus: messaging: start transaction ids from 1 instead of zero
  slimbus: messaging: check for valid transaction id
  slimbus: ngd: reset dma setup during runtime pm

Steven Rostedt (VMware) (1):
  tracing / histogram: Fix NULL pointer dereference on strcmp() on NULL
    event name

Sudeep Holla (1):
  ARM: dts: nomadik: Fix up interrupt controller node names

Takashi Iwai (2):
  ASoC: intel: atom: Fix reference to PCM buffer address
  ASoC: intel: atom: Fix breakage for PCM buffer address setup

Takeshi Misawa (1):
  net: Fix memory leak in ieee802154_raw_deliver

Thomas Gleixner (12):
  genirq: Provide IRQCHIP_AFFINITY_PRE_STARTUP
  x86/msi: Force affinity setup before startup
  x86/ioapic: Force affinity setup before startup
  PCI/MSI: Enable and mask MSI-X early
  PCI/MSI: Do not set invalid bits in MSI mask
  PCI/MSI: Correct misleading comments
  PCI/MSI: Use msi_mask_irq() in pci_msi_shutdown()
  PCI/MSI: Protect msi_desc::masked for multi-MSI
  PCI/MSI: Mask all unused MSI-X entries
  PCI/MSI: Enforce that MSI-X table entry is masked for update
  PCI/MSI: Enforce MSI[X] entry updates to be visible
  x86/fpu: Make init_fpstate correct with optimized XSAVE

Vincent Whitchurch (1):
  mmc: dw_mmc: Fix hang on data CRC error

Vladimir Oltean (1):
  net: dsa: lan9303: fix broken backpressure in .port_fdb_dump

Xie Yongji (1):
  vhost: Fix the calculation in vhost_overflow()

Yang Yingliang (1):
  net: bridge: fix memleak in br_add_if()

Ye Bin (1):
  scsi: scsi_dh_rdac: Avoid crash during rdac_bus_attach()

Yu Kuai (1):
  dmaengine: usb-dmac: Fix PM reference leak in usb_dmac_probe()

 .../filesystems/mandatory-locking.txt         |  10 ++
 Makefile                                      |   4 +-
 arch/arm/boot/dts/am43x-epos-evm.dts          |   2 +-
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi    |   4 +-
 arch/powerpc/kernel/kprobes.c                 |   3 +-
 arch/x86/include/asm/fpu/internal.h           |  30 ++---
 arch/x86/include/asm/svm.h                    |   2 +
 arch/x86/kernel/apic/io_apic.c                |   6 +-
 arch/x86/kernel/apic/msi.c                    |  13 +-
 arch/x86/kernel/cpu/intel_rdt_monitor.c       |  27 ++--
 arch/x86/kernel/fpu/xstate.c                  |  38 +++++-
 arch/x86/kvm/svm.c                            |  18 ++-
 arch/x86/tools/chkobjdump.awk                 |   1 +
 drivers/acpi/nfit/core.c                      |   3 +
 drivers/base/core.c                           |   1 +
 drivers/cpufreq/armada-37xx-cpufreq.c         |   6 +-
 drivers/dma/of-dma.c                          |   9 +-
 drivers/dma/sh/usb-dmac.c                     |   2 +-
 drivers/dma/xilinx/xilinx_dma.c               |  12 ++
 drivers/i2c/i2c-dev.c                         |   5 +-
 drivers/iio/adc/palmas_gpadc.c                |   4 +-
 drivers/iio/humidity/hdc100x.c                |   6 +-
 drivers/iommu/intel-iommu.c                   |   7 +-
 drivers/ipack/carriers/tpci200.c              |  60 +++++----
 drivers/mmc/host/dw_mmc.c                     |   6 +-
 drivers/net/dsa/lan9303-core.c                |  34 ++---
 drivers/net/dsa/mt7530.c                      |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  57 +++++----
 .../ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c   |   4 +-
 drivers/net/hamradio/6pack.c                  |   6 +
 drivers/net/ieee802154/mac802154_hwsim.c      |   6 +-
 drivers/net/phy/mdio-mux.c                    |  36 ++++--
 drivers/net/ppp/ppp_generic.c                 |   2 +-
 drivers/net/usb/lan78xx.c                     |  16 ++-
 drivers/net/wireless/ath/ath.h                |   3 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   2 +-
 drivers/net/wireless/ath/ath9k/hw.h           |   1 +
 drivers/net/wireless/ath/ath9k/main.c         |  95 +++++++++++++-
 drivers/net/wireless/ath/key.c                |  41 +++---
 drivers/pci/msi.c                             | 120 ++++++++++++------
 drivers/pci/quirks.c                          |   1 +
 drivers/ptp/Kconfig                           |   3 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c    |   4 +-
 drivers/scsi/megaraid/megaraid_mm.c           |  21 ++-
 drivers/scsi/scsi_scan.c                      |   3 +-
 drivers/slimbus/messaging.c                   |   7 +-
 drivers/slimbus/qcom-ngd-ctrl.c               |   5 +-
 drivers/vhost/vhost.c                         |  10 +-
 drivers/xen/events/events_base.c              |  20 ++-
 fs/btrfs/inode.c                              |  10 +-
 fs/namespace.c                                |  15 ++-
 include/asm-generic/vmlinux.lds.h             |   1 +
 include/linux/device.h                        |   1 +
 include/linux/inetdevice.h                    |   2 +-
 include/linux/irq.h                           |   2 +
 include/linux/msi.h                           |   2 +-
 include/net/psample.h                         |   2 +
 kernel/irq/chip.c                             |   5 +-
 kernel/irq/msi.c                              |  13 +-
 kernel/trace/trace_events_hist.c              |   2 +
 net/bluetooth/hidp/core.c                     |   2 +-
 net/bridge/br_if.c                            |   2 +
 net/dccp/dccp.h                               |   6 +-
 net/ieee802154/socket.c                       |   7 +-
 net/ipv4/igmp.c                               |  21 ++-
 net/ipv4/tcp_bbr.c                            |   2 +-
 net/mac80211/debugfs_sta.c                    |   1 +
 net/mac80211/key.c                            |   1 +
 net/mac80211/sta_info.h                       |   1 +
 net/mac80211/tx.c                             |  12 +-
 net/netfilter/nft_exthdr.c                    |   8 +-
 net/vmw_vsock/virtio_transport.c              |   7 +-
 sound/pci/hda/hda_generic.c                   |  10 +-
 sound/soc/codecs/cs42l42.c                    |  39 +++---
 sound/soc/intel/atom/sst-mfld-platform-pcm.c  |   3 +-
 76 files changed, 643 insertions(+), 313 deletions(-)

-- 
2.30.2

