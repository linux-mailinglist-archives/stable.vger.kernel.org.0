Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3C6646CD3
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 11:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiLHKcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 05:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiLHKbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 05:31:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF1E7E405;
        Thu,  8 Dec 2022 02:31:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F96561E8D;
        Thu,  8 Dec 2022 10:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CDAC433D6;
        Thu,  8 Dec 2022 10:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670495473;
        bh=yu9G5rrqopWIxnrh/KdSE/dGvTZfw66eAADNFSgvOQQ=;
        h=From:To:Cc:Subject:Date:From;
        b=2jQM+mcbjOOIUxWueRX13euTk21hTRo/5IKpaSFTfmigc0tikWoHzOG/EVQU9jLyt
         hGsb98fTsVwPYQrmdLn0xVuCVuAgpcWsOVLJdZJS6SgLtiATS3WpsOAG9GTnJMJubX
         knRImsm3bynK160ZFR3+rMk18PqEKCHjGLb82Y24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.268
Date:   Thu,  8 Dec 2022 11:31:03 +0100
Message-Id: <167049546351218@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.268 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                 |    2 
 arch/arm/boot/dts/am335x-pcm-953.dtsi                    |   28 ++---
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi              |    9 +
 arch/arm/mach-mxs/mach-mxs.c                             |    4 
 arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts      |    2 
 arch/arm64/kernel/cpu_errata.c                           |   24 +++--
 arch/mips/include/asm/fw/fw.h                            |    2 
 arch/mips/pic32/pic32mzda/early_console.c                |   13 +-
 arch/mips/pic32/pic32mzda/init.c                         |    2 
 arch/nios2/boot/Makefile                                 |    2 
 arch/riscv/kernel/vdso/Makefile                          |    3 
 arch/riscv/kernel/vdso/vdso.lds.S                        |    2 
 arch/s390/kernel/crash_dump.c                            |    2 
 arch/x86/include/asm/cpufeatures.h                       |    1 
 arch/x86/include/asm/nospec-branch.h                     |   12 +-
 arch/x86/kernel/cpu/bugs.c                               |   21 ++--
 arch/x86/kernel/cpu/tsx.c                                |   33 ++----
 arch/x86/kernel/process.c                                |    2 
 arch/x86/mm/ioremap.c                                    |    8 +
 arch/x86/power/cpu.c                                     |   23 +++-
 drivers/bus/sunxi-rsb.c                                  |   29 ++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c                  |    8 -
 drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c  |    3 
 drivers/gpu/drm/drm_panel_orientation_quirks.c           |    6 +
 drivers/hv/channel_mgmt.c                                |    6 +
 drivers/hv/vmbus_drv.c                                   |    1 
 drivers/hwmon/coretemp.c                                 |    9 +
 drivers/hwmon/i5500_temp.c                               |    2 
 drivers/hwmon/ibmpex.c                                   |    1 
 drivers/iio/health/afe4403.c                             |    5 -
 drivers/iio/health/afe4404.c                             |   12 +-
 drivers/iio/industrialio-sw-trigger.c                    |    6 +
 drivers/iio/light/Kconfig                                |    2 
 drivers/iio/light/apds9960.c                             |   12 +-
 drivers/iio/pressure/ms5611.h                            |   18 +--
 drivers/iio/pressure/ms5611_core.c                       |   56 ++++++-----
 drivers/iio/pressure/ms5611_i2c.c                        |   11 --
 drivers/iio/pressure/ms5611_spi.c                        |   17 +--
 drivers/input/mouse/synaptics.c                          |    1 
 drivers/iommu/dmar.c                                     |    1 
 drivers/md/dm-integrity.c                                |    7 -
 drivers/mmc/host/sdhci.c                                 |   71 ++++++++++++---
 drivers/mmc/host/sdhci.h                                 |   12 +-
 drivers/net/can/cc770/cc770_isa.c                        |   10 +-
 drivers/net/can/sja1000/sja1000_isa.c                    |   10 +-
 drivers/net/dsa/lan9303-core.c                           |    2 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c        |   12 +-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c        |    4 
 drivers/net/ethernet/mellanox/mlx4/qp.c                  |    3 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c            |    4 
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c |    2 
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c     |    6 +
 drivers/net/ethernet/qlogic/qla3xxx.c                    |    1 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c      |    4 
 drivers/net/ethernet/renesas/ravb_main.c                 |    1 
 drivers/net/ntb_netdev.c                                 |    9 +
 drivers/net/phy/phy_device.c                             |    1 
 drivers/net/tun.c                                        |    4 
 drivers/net/usb/qmi_wwan.c                               |    1 
 drivers/net/wireless/mac80211_hwsim.c                    |    5 +
 drivers/nfc/st-nci/se.c                                  |    6 -
 drivers/nvme/host/core.c                                 |    6 +
 drivers/of/property.c                                    |    4 
 drivers/pinctrl/intel/pinctrl-intel.c                    |   27 +++++
 drivers/pinctrl/pinctrl-single.c                         |    2 
 drivers/platform/x86/acer-wmi.c                          |    9 +
 drivers/platform/x86/asus-wmi.c                          |    2 
 drivers/platform/x86/hp-wmi.c                            |    3 
 drivers/s390/block/dasd_eckd.c                           |    6 -
 drivers/spi/spi-imx.c                                    |    3 
 drivers/spi/spi-stm32.c                                  |    2 
 drivers/tty/serial/8250/8250_omap.c                      |    7 -
 drivers/xen/platform-pci.c                               |    7 +
 fs/btrfs/ioctl.c                                         |   23 ++--
 fs/btrfs/qgroup.c                                        |    9 -
 fs/ceph/snap.c                                           |   31 ++++--
 fs/nilfs2/dat.c                                          |    7 +
 fs/nilfs2/sufile.c                                       |    8 +
 include/linux/mmdebug.h                                  |    2 
 include/uapi/linux/audit.h                               |    2 
 ipc/sem.c                                                |    3 
 kernel/sysctl.c                                          |   30 +++---
 lib/Kconfig.debug                                        |   14 ++
 mm/frame_vector.c                                        |   31 +-----
 net/9p/trans_fd.c                                        |    6 +
 net/bluetooth/l2cap_core.c                               |   13 ++
 net/dccp/ipv4.c                                          |    2 
 net/dccp/ipv6.c                                          |    2 
 net/hsr/hsr_forward.c                                    |    5 -
 net/ipv4/Kconfig                                         |   10 ++
 net/ipv4/inet_hashtables.c                               |   10 +-
 net/ipv4/tcp_ipv4.c                                      |    2 
 net/ipv6/ipv6_sockglue.c                                 |    7 +
 net/ipv6/tcp_ipv6.c                                      |    2 
 net/ipv6/xfrm6_policy.c                                  |    6 +
 net/key/af_key.c                                         |   32 ++++--
 net/mac80211/mesh_pathtbl.c                              |    2 
 net/nfc/nci/core.c                                       |    2 
 net/nfc/nci/data.c                                       |    4 
 net/packet/af_packet.c                                   |    6 -
 net/tipc/discover.c                                      |    5 -
 net/tipc/topsrv.c                                        |   20 ++--
 scripts/faddr2line                                       |    7 -
 sound/soc/codecs/sgtl5000.c                              |    1 
 sound/soc/soc-ops.c                                      |    2 
 tools/vm/slabinfo-gnuplot.sh                             |    4 
 106 files changed, 621 insertions(+), 343 deletions(-)

Adrian Hunter (1):
      mmc: sdhci: Fix voltage switch delay

Alejandro Concepción Rodríguez (1):
      iio: light: apds9960: fix wrong register for gesture gain

Aman Dhoot (1):
      Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode

Anand Jain (3):
      btrfs: free btrfs_path before copying fspath to userspace
      btrfs: free btrfs_path before copying subvol info to userspace
      btrfs: free btrfs_path before copying inodes to userspace

Andy Shevchenko (1):
      pinctrl: intel: Save and restore pins in "direct IRQ" mode

Ben Hutchings (1):
      Revert "x86/speculation: Change FILL_RETURN_BUFFER to work with objtool"

Chen Zhongjin (3):
      xfrm: Fix ignored return value in xfrm6_init()
      iio: core: Fix entry not deleted when iio_register_sw_trigger_type() fails
      nilfs2: fix nilfs_sufile_mark_dirty() not set segment usage as dirty

ChenXiaoSong (1):
      btrfs: qgroup: fix sleep from invalid context bug in btrfs_qgroup_inherit()

Christian König (1):
      drm/amdgpu: always register an MMU notifier for userptr

Detlev Casanova (1):
      ASoC: sgtl5000: Reset the CHIP_CLK_CTRL reg on remove

Dominik Haller (1):
      ARM: dts: am335x-pcm-953: Define fixed regulators in root node

Duoming Zhou (1):
      qlcnic: fix sleep-in-atomic-context bugs caused by msleep

Enrico Sau (1):
      net: usb: qmi_wwan: add Telit 0x103a composition

Frieder Schrempf (1):
      spi: spi-imx: Fix spi_bus_clk if requested clock is higher than input clock

Gaosheng Cui (2):
      audit: fix undefined behavior in bit shift for AUDIT_BIT
      hwmon: (ibmpex) Fix possible UAF when ibmpex_register_bmc() fails

Gleb Mazovetskiy (1):
      tcp: configurable source port perturb table size

Greg Kroah-Hartman (1):
      Linux 4.19.268

Guenter Roeck (1):
      xtensa: increase size of gcc stack frame check

Hans de Goede (2):
      drm: panel-orientation-quirks: Add quirk for Acer Switch V 10 (SW5-017)
      platform/x86: acer-wmi: Enable SW_TABLET_MODE on Switch V 10 (SW5-017)

Heiko Carstens (1):
      s390/crashdump: fix TOD programmable field size

Helge Deller (2):
      parisc: Increase size of gcc stack frame check
      parisc: Increase FRAME_WARN to 2048 bytes on parisc

Herbert Xu (1):
      af_key: Fix send_acquire race with pfkey_register

Jakob Unterwurzacher (1):
      arm64: dts: rockchip: lower rk3399-puma-haikou SD controller clock frequency

James Morse (2):
      arm64: Fix panic() when Spectre-v2 causes Spectre-BHB to re-allocate KVM vectors
      arm64: errata: Fix KVM Spectre-v2 mitigation selection for Cortex-A57/A72

Jann Horn (1):
      ipc/sem: Fix dangling sem_array access in semtimedop race

Jason A. Donenfeld (1):
      MIPS: pic32: treat port as signed integer

Jerry Ray (1):
      dsa: lan9303: Correct stat name

Jonas Jelonek (1):
      wifi: mac80211_hwsim: fix debugfs attribute ps with rc table support

Josef Bacik (1):
      btrfs: free btrfs_path before copying root refs to userspace

Kai-Heng Feng (1):
      platform/x86: hp-wmi: Ignore Smart Experience App event

Keith Busch (1):
      nvme: restrict management ioctls to admin

Kuniyuki Iwashima (2):
      dccp/tcp: Reset saddr on failure after inet6?_hash_connect().
      tcp/udp: Fix memory leak in ipv6_renew_options().

Lars-Peter Clausen (1):
      iio: ms5611: Simplify IO callback parameters

Lee Jones (1):
      Kconfig.debug: provide a little extra FRAME_WARN leeway when KASAN is enabled

Lin Ma (1):
      nfc/nci: fix race with opening and closing

Linus Torvalds (3):
      proc: avoid integer type confusion in get_proc_long
      proc: proc_skip_spaces() shouldn't think it is working on C strings
      v4l2: don't fall back to follow_pfn() if pin_user_pages_fast() fails

Liu Shixin (1):
      NFC: nci: fix memory leak in nci_rx_data_packet()

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix accepting connection request for invalid SPSM

Lukas Wunner (1):
      serial: 8250: 8250_omap: Avoid RS485 RTS glitch on ->set_termios()

Lyude Paul (1):
      drm/amd/dc/dce120: Fix audio register mapping, stop triggering KASAN

Mark Brown (1):
      ASoC: ops: Fix bounds check for _sx controls

Martin Faltesek (2):
      nfc: st-nci: fix incorrect validating logic in EVT_TRANSACTION
      nfc: st-nci: fix memory leaks in EVT_TRANSACTION

Masahiro Yamada (1):
      mmc: sdhci: use FIELD_GET for preset value bit masks

Maxim Korotkov (1):
      pinctrl: single: Fix potential division by zero

Michael Grzeschik (1):
      ARM: dts: at91: sam9g20ek: enable udc vbus gpio pinctrl

Michael Kelley (1):
      x86/ioremap: Fix page aligned size calculation in __ioremap_caller()

Mikulas Patocka (1):
      dm integrity: flush the journal on suspend

Mitja Spes (1):
      iio: pressure: ms5611: fixed value compensation bug

Moshe Shemesh (1):
      net/mlx5: Fix FW tracer timestamp calculation

Nathan Chancellor (2):
      RISC-V: vdso: Do not add missing symbols to version section in linker script
      mm: Fix '.data.once' orphan section warning

Nicolas Cavallari (1):
      wifi: mac80211: Fix ack frame idr leak when mesh has no route

Paul Gazzillo (1):
      iio: light: rpr0521: add missing Kconfig dependencies

Pawan Gupta (3):
      x86/bugs: Make sure MSR_SPEC_CTRL is updated properly upon resume from S3
      x86/tsx: Add a feature bit for TSX control MSR support
      x86/pm: Add enumeration check before spec MSRs save/restore setup

Peter Kosyh (1):
      net/mlx4: Check retval of mlx4_bitmap_init

Phil Auld (1):
      hwmon: (coretemp) Check for null before removing sysfs attrs

Randy Dunlap (1):
      nios2: add FORCE for vmlinuz.gz

Samuel Holland (1):
      bus: sunxi-rsb: Support atomic transfers

Sean Nyekjaer (1):
      spi: stm32: fix stm32_spi_prepare_mbr() that halves spi clk for every run

Shigeru Yoshida (1):
      net: tun: Fix use-after-free in tun_detach()

Srikar Dronamraju (1):
      scripts/faddr2line: Fix regression in name resolution on ppc64le

Stefan Haberland (1):
      s390/dasd: fix no record found for raw_track_access

Steven Rostedt (Google) (1):
      error-injection: Add prompt for function error injection

Tiezhu Yang (1):
      tools/vm/slabinfo-gnuplot: use "grep -E" instead of "egrep"

Wang Hai (2):
      net: pch_gbe: fix potential memleak in pch_gbe_tx_queue()
      net/9p: Fix a potential socket leak in p9_socket_open

Wei Yongjun (2):
      iio: health: afe4403: Fix oob read in afe4403_read_raw
      iio: health: afe4404: Fix oob read in afe4404_[read|write]_raw

Willem de Bruijn (1):
      packet: do not set TP_STATUS_CSUM_VALID on CHECKSUM_COMPLETE

Xin Long (2):
      tipc: set con sock in tipc_conn_alloc
      tipc: add an extra conn_get in tipc_conn_alloc

Xiongfeng Wang (2):
      platform/x86: asus-wmi: add missing pci_dev_put() in asus_wmi_set_xusb2pr()
      iommu/vt-d: Fix PCI device refcount leak in dmar_dev_scope_init()

Xiubo Li (2):
      ceph: do not update snapshot context when there is no new snapshot
      ceph: avoid putting the realm twice when decoding snaps fails

Yang Yingliang (8):
      net: pch_gbe: fix pci device refcount leak while module exiting
      Drivers: hv: vmbus: fix double free in the error path of vmbus_add_channel_work()
      Drivers: hv: vmbus: fix possible memory leak in vmbus_device_register()
      bnx2x: fix pci device refcount leak in bnx2x_vf_is_pcie_pending()
      hwmon: (i5500_temp) fix missing pci_disable_device()
      of: property: decrement node refcount in of_fwnode_get_reference_args()
      net: phy: fix null-ptr-deref while probe() failed
      hwmon: (coretemp) fix pci device refcount leak in nv1a_ram_new()

Yoshihiro Shimoda (1):
      net: ethernet: renesas: ravb: Fix promiscuous mode after system resumed

Yu Liao (1):
      net: thunderx: Fix the ACPI memory leak

Yuan Can (1):
      net: net_netdev: Fix error handling in ntb_netdev_init_module()

YueHaibing (3):
      tipc: check skb_linearize() return value in tipc_disc_rcv()
      net/mlx5: Fix uninitialized variable bug in outlen_write()
      net: hsr: Fix potential use-after-free

Zhang Changzhong (3):
      net/qla3xxx: fix potential memleak in ql3xxx_send()
      can: sja1000_isa: sja1000_isa_probe(): add missing free_sja1000dev()
      can: cc770: cc770_isa_probe(): add missing free_cc770dev()

ZhangPeng (1):
      nilfs2: fix NULL pointer dereference in nilfs_palloc_commit_free_entry()

Zheng Yongjun (1):
      ARM: mxs: fix memory leak in mxs_machine_init()

Zhengchao Shao (1):
      9p/fd: fix issue of list_del corruption in p9_fd_cancel()

ruanjinjie (1):
      xen/platform-pci: add missing free_irq() in error path

