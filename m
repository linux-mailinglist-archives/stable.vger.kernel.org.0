Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621EA3B62E3
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234556AbhF1OuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236303AbhF1OrI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:47:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ADA5600CD;
        Mon, 28 Jun 2021 14:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890991;
        bh=wkjjfAV5KoL9DB7iQquAdN9F4zar0+41usFMCad7pJ8=;
        h=From:To:Cc:Subject:Date:From;
        b=bdHVNryX92zrgx8gS1Fc0JwJoAZMOS9i65ZaCEfxya8YY4ANPukJDEfYr+70qzQ+E
         67WN0JTLoa66zK4hSGcJcH2RKs6hVsCfDZwBp7V3eNwdFHps0tVQRcrJhTxBZYbXuD
         qNqsL8f/3LK7JXj1FT+KoMvemdp8V3vpo7c2YA5mIyfwzrwoRM5WofACHBHfZ+g53G
         lA0DzdmJoON8tm+3Jr1NoLMSkr9iuarrPOlXar+CKjpHd7hojrk0yMJ//dJiV8y4Qp
         E5ANEQGHtTkrFZp1Gm8GVPpwL2QGqglX8FKwtr0Ny+emZZ+R48idHhiHFNgZL/Vwfb
         qfSc8NIbOUeGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org
Subject: [PATCH 4.14 00/88] 4.14.238-rc1 review
Date:   Mon, 28 Jun 2021 10:35:00 -0400
Message-Id: <20210628143628.33342-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is the start of the stable review cycle for the 4.14.238 release.
There are 88 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 30 Jun 2021 02:36:04 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-4.14.y&id2=v4.14.237
or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

Thanks,
Sasha

-------------
Pseudo-Shortlog of commits:

Al Viro (2):
  kernfs: deal with kernfs_fill_super() failures
  unfuck sysfs_mount()

Andrew Lunn (1):
  usb: core: hub: Disable autosuspend for Cypress CY7C65632

Andrew Morton (1):
  mm/slub.c: include swab.h

Anirudh Rayabharam (1):
  HID: usbhid: fix info leak in hid_submit_ctrl

Antti Järvinen (1):
  PCI: Mark TI C667X to avoid bus reset

Arnd Bergmann (1):
  ARM: 9081/1: fix gcc-10 thumb2-kernel regression

Bixuan Cui (1):
  HID: gt683r: add missing MODULE_DEVICE_TABLE

Bumyong Lee (1):
  dmaengine: pl330: fix wrong usage of spinlock flags in dma_cyclc

Chen Li (1):
  radeon: use memcpy_to/fromio for UVD fw upload

Chengyang Fan (1):
  net: ipv4: fix memory leak in ip_mc_add1_src

Chiqijun (1):
  PCI: Work around Huawei Intelligent NIC VF FLR erratum

Christian König (2):
  drm/nouveau: wait for moving fence after pinning v2
  drm/radeon: wait for moving fence after pinning

Christophe JAILLET (4):
  alx: Fix an error handling path in 'alx_probe()'
  qlcnic: Fix an error handling path in 'qlcnic_probe()'
  netxen_nic: Fix an error handling path in 'netxen_nic_probe()'
  be2net: Fix an error handling path in 'be_probe()'

Dan Robertson (1):
  net: ieee802154: fix null deref in parse dev addr

Dongliang Mu (1):
  net: usb: fix possible use-after-free in smsc75xx_bind

Du Cheng (1):
  cfg80211: call cfg80211_leave_ocb when switching away from OCB

Eric Dumazet (5):
  net/af_unix: fix a data-race in unix_dgram_sendmsg / unix_release_sock
  inet: use bigger hash table for IP ID generation
  inet: annotate date races around sk->sk_txhash
  net/packet: annotate accesses to po->bind
  net/packet: annotate accesses to po->ifindex

Esben Haabendal (1):
  net: ll_temac: Avoid ndo_start_xmit returning NETDEV_TX_BUSY

Fabien Dessenne (1):
  pinctrl: stm32: fix the reported number of GPIO lines per bank

Fugang Duan (1):
  net: fec_ptp: add clock rate zero check

Hannes Reinecke (3):
  nvme-loop: reset queue count to 1 in nvme_loop_destroy_io_queues()
  nvme-loop: clear NVME_LOOP_Q_LIVE when
    nvme_loop_configure_admin_queue() fails
  nvme-loop: check for NVME_LOOP_Q_LIVE in
    nvme_loop_destroy_admin_queue()

Hillf Danton (1):
  gfs2: Fix use-after-free in gfs2_glock_shrink_scan

Ido Schimmel (1):
  rtnetlink: Fix regression in bridge VLAN configuration

Jiapeng Chong (2):
  ethernet: myri10ge: Fix missing error code in myri10ge_probe()
  rtnetlink: Fix missing error code in rtnl_bridge_notify()

Jisheng Zhang (1):
  net: stmmac: dwmac1000: Fix extended MAC address registers definition

Johan Hovold (1):
  i2c: robotfuzz-osif: fix control-request directions

Johannes Berg (2):
  mac80211: remove warning in ieee80211_get_sband()
  mac80211: drop multicast fragments

Josh Triplett (1):
  net: ipconfig: Don't override command-line hostnames or domains

Kees Cook (4):
  r8152: Avoid memcpy() over-reading of ETH_SS_STATS
  sh_eth: Avoid memcpy() over-reading of ETH_SS_STATS
  r8169: Avoid memcpy() over-reading of ETH_SS_STATS
  net: qed: Fix memcpy() overflow of qed_dcbx_params()

Linyu Yuan (1):
  net: cdc_eem: fix tx fixup skb leak

Maciej Żenczykowski (1):
  net: cdc_ncm: switch to eth%d interface naming

Mark Bolhuis (1):
  HID: Add BUS_VIRTUAL to hid_connect logging

Maurizio Lombardi (1):
  scsi: target: core: Fix warning on realtime kernels

Maxim Mikityanskiy (1):
  netfilter: synproxy: Fix out of bounds when parsing TCP options

Nanyong Sun (1):
  net: ipv4: fix memory leak in netlbl_cipsov4_add_std

Nathan Chancellor (2):
  Makefile: Move -Wno-unused-but-set-variable out of GCC only block
  MIPS: generic: Update node names to avoid unit addresses

Nikolay Aleksandrov (2):
  net: bridge: fix vlan tunnel dst null pointer dereference
  net: bridge: fix vlan tunnel dst refcnt when egressing

Norbert Slusarek (1):
  can: bcm: fix infoleak in struct bcm_msg_head

Paolo Abeni (1):
  udp: fix race between close() and udp_abort()

Pavel Skripkin (6):
  net: rds: fix memory leak in rds_recvmsg
  net: hamradio: fix memory leak in mkiss_close
  net: ethernet: fix potential use-after-free in ec_bhf_remove
  can: mcba_usb: fix memory leak in mcba_usb
  net: caif: fix memory leak in ldisc_open
  nilfs2: fix memory leak in nilfs_sysfs_delete_device_group

Peter Chen (1):
  usb: dwc3: core: fix kernel panic when do reboot

Rafael J. Wysocki (1):
  Revert "PCI: PM: Do not read power state in pci_enable_device_flags()"

Randy Dunlap (2):
  dmaengine: ALTERA_MSGDMA depends on HAS_IOMEM
  dmaengine: QCOM_HIDMA_MGMT depends on HAS_IOMEM

Riwen Lu (1):
  hwmon: (scpi-hwmon) shows the negative temperature properly

Sasha Levin (1):
  Linux 4.14.238-rc1

Shanker Donthineni (1):
  PCI: Mark some NVIDIA GPUs to avoid bus reset

Sriharsha Basavapatna (1):
  PCI: Add ACS quirk for Broadcom BCM57414 NIC

Srinivas Pandruvada (1):
  HID: hid-sensor-hub: Return error for hid_set_field() failure

Steven Rostedt (VMware) (3):
  tracing: Do not stop recording cmdlines when tracing is off
  tracing: Do not stop recording comms if the trace file is being read
  tracing: Do no increment trace_clock_global() by one

Suzuki K Poulose (1):
  arm64: perf: Disable PMU while processing counter overflows

Sven Eckelmann (1):
  batman-adv: Avoid WARN_ON timing related checks

Tetsuo Handa (1):
  can: bcm/raw/isotp: use per module netdevice notifier

Thomas Gleixner (1):
  x86/fpu: Reset state for all signal restore failures

Toke Høiland-Jørgensen (1):
  icmp: don't send out ICMP messages with a source address of 0.0.0.0

Vineet Gupta (1):
  ARCv2: save ABI registers across signal handling

Yang Yingliang (1):
  dmaengine: stedma40: add missing iounmap() on error in d40_probe()

Yongqiang Liu (1):
  ARM: OMAP2+: Fix build warning when mmc_omap is not built

Zheng Yongjun (4):
  net/x25: Return the correct errno code
  net: Return the correct errno code
  fib: Return the correct errno code
  ping: Check return value of function 'ping_queue_rcv_skb'

yangerkun (1):
  mm/memory-failure: make sure wait for page writeback in memory_failure

 Makefile                                      |  7 +-
 arch/arc/include/uapi/asm/sigcontext.h        |  1 +
 arch/arc/kernel/signal.c                      | 43 +++++++++
 arch/arm/kernel/setup.c                       | 16 ++--
 arch/arm/mach-omap2/board-n8x0.c              |  2 +-
 arch/arm64/kernel/perf_event.c                | 50 ++++++-----
 arch/mips/generic/board-boston.its.S          | 10 +--
 arch/mips/generic/board-ni169445.its.S        | 10 +--
 arch/mips/generic/vmlinux.its.S               | 10 +--
 arch/x86/kernel/fpu/signal.c                  | 31 ++++---
 drivers/dma/Kconfig                           |  1 +
 drivers/dma/pl330.c                           |  6 +-
 drivers/dma/qcom/Kconfig                      |  1 +
 drivers/dma/ste_dma40.c                       |  3 +
 drivers/gpu/drm/nouveau/nouveau_prime.c       | 17 +++-
 drivers/gpu/drm/radeon/radeon_prime.c         | 16 +++-
 drivers/gpu/drm/radeon/radeon_uvd.c           |  4 +-
 drivers/hid/hid-core.c                        |  3 +
 drivers/hid/hid-gt683r.c                      |  1 +
 drivers/hid/hid-sensor-hub.c                  | 13 ++-
 drivers/hid/usbhid/hid-core.c                 |  2 +-
 drivers/hwmon/scpi-hwmon.c                    |  9 ++
 drivers/i2c/busses/i2c-robotfuzz-osif.c       |  4 +-
 drivers/net/caif/caif_serial.c                |  1 +
 drivers/net/can/usb/mcba_usb.c                | 17 +++-
 drivers/net/ethernet/atheros/alx/main.c       |  1 +
 drivers/net/ethernet/ec_bhf.c                 |  4 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |  1 +
 drivers/net/ethernet/freescale/fec_ptp.c      |  4 +
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  1 +
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |  2 +
 drivers/net/ethernet/qlogic/qed/qed_dcbx.c    |  4 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  1 +
 drivers/net/ethernet/realtek/r8169.c          |  2 +-
 drivers/net/ethernet/renesas/sh_eth.c         |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac1000.h   |  8 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   |  5 ++
 drivers/net/hamradio/mkiss.c                  |  1 +
 drivers/net/usb/cdc_eem.c                     |  2 +-
 drivers/net/usb/cdc_ncm.c                     |  2 +-
 drivers/net/usb/r8152.c                       |  2 +-
 drivers/net/usb/smsc75xx.c                    | 10 ++-
 drivers/nvme/target/loop.c                    |  5 +-
 drivers/pci/pci.c                             | 16 +++-
 drivers/pci/quirks.c                          | 89 +++++++++++++++++++
 drivers/pinctrl/stm32/pinctrl-stm32.c         |  9 +-
 drivers/target/target_core_transport.c        |  4 +-
 drivers/usb/core/hub.c                        |  7 ++
 drivers/usb/dwc3/core.c                       |  2 +-
 fs/gfs2/glock.c                               |  2 +-
 fs/kernfs/mount.c                             |  1 +
 fs/nilfs2/sysfs.c                             |  1 +
 fs/sysfs/mount.c                              |  6 +-
 include/linux/hid.h                           |  3 +-
 include/net/sock.h                            | 10 ++-
 include/uapi/linux/in.h                       |  3 +
 kernel/trace/trace.c                          | 11 ---
 kernel/trace/trace_clock.c                    |  6 +-
 mm/memory-failure.c                           |  7 +-
 mm/slub.c                                     |  1 +
 net/batman-adv/bat_iv_ogm.c                   |  4 +-
 net/bridge/br_private.h                       |  4 +-
 net/bridge/br_vlan_tunnel.c                   | 38 +++++---
 net/can/bcm.c                                 | 62 ++++++++++---
 net/can/raw.c                                 | 62 ++++++++++---
 net/compat.c                                  |  2 +-
 net/core/fib_rules.c                          |  2 +-
 net/core/rtnetlink.c                          |  4 +
 net/ieee802154/nl802154.c                     |  9 +-
 net/ipv4/cipso_ipv4.c                         |  1 +
 net/ipv4/icmp.c                               |  7 ++
 net/ipv4/igmp.c                               |  1 +
 net/ipv4/ipconfig.c                           | 13 +--
 net/ipv4/ping.c                               | 12 +--
 net/ipv4/route.c                              | 41 ++++++---
 net/ipv4/udp.c                                | 10 +++
 net/ipv6/udp.c                                |  3 +
 net/mac80211/ieee80211_i.h                    |  2 +-
 net/mac80211/rx.c                             |  9 +-
 net/netfilter/nf_synproxy_core.c              |  5 ++
 net/packet/af_packet.c                        | 32 +++----
 net/rds/recv.c                                |  2 +-
 net/unix/af_unix.c                            |  7 +-
 net/wireless/util.c                           |  3 +
 net/x25/af_x25.c                              |  2 +-
 85 files changed, 624 insertions(+), 226 deletions(-)

-- 
2.30.2

