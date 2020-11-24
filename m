Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51062C2D64
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 17:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390637AbgKXQvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 11:51:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:53890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390612AbgKXQvs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Nov 2020 11:51:48 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6047820715;
        Tue, 24 Nov 2020 16:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606236706;
        bh=wHPyALQo9FuK1LWysy0G8FV/wP+wKJi3Pl8IRppXt08=;
        h=From:To:Cc:Subject:Date:From;
        b=rQR7PPIm8RB5aL45LEnr6LNNqRfsDyjq5gi1rVsl/2568OSSX7+kWDSCyxk1HnzPY
         YHAiFDMa6aFVNq4AAC1i2FaXPP0D7wWRblOtF2o4Y9GQZh4as6srra2VYxLyhbe/g/
         n75hUi4V0inJ8SEe68mTkWAJTInubyXi2qhPiWEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.160
Date:   Tue, 24 Nov 2020 17:51:37 +0100
Message-Id: <1606236697116179@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.160 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                   |    2 
 arch/arm/boot/dts/imx50-evk.dts                            |    2 
 arch/arm/boot/dts/imx6qdl-udoo.dtsi                        |    2 
 arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts               |    2 
 arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts           |    2 
 arch/arm/boot/dts/sun8i-h3-orangepi-pc-plus.dts            |    5 -
 arch/arm/boot/dts/sun8i-h3-orangepi-plus2e.dts             |    2 
 arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts          |    2 
 arch/arm64/boot/dts/allwinner/sun50i-a64-bananapi-m64.dts  |    2 
 arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dts   |    2 
 arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts   |    2 
 arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-prime.dts |    2 
 arch/arm64/kernel/psci.c                                   |    5 -
 arch/mips/alchemy/common/clock.c                           |    9 +
 arch/mips/mm/tlb-r4k.c                                     |    1 
 arch/s390/kernel/perf_cpum_sf.c                            |    2 
 arch/x86/kernel/cpu/microcode/intel.c                      |   63 ++-----------
 arch/x86/platform/efi/efi_64.c                             |   24 ++--
 arch/xtensa/mm/cache.c                                     |   14 ++
 drivers/acpi/button.c                                      |   13 ++
 drivers/atm/nicstar.c                                      |    2 
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c                      |    1 
 drivers/iio/accel/kxcjk-1013.c                             |   51 +++++++++-
 drivers/input/misc/adxl34x.c                               |    2 
 drivers/input/touchscreen/Kconfig                          |    1 
 drivers/net/can/dev.c                                      |    2 
 drivers/net/can/m_can/m_can.c                              |    4 
 drivers/net/can/ti_hecc.c                                  |   13 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c          |    2 
 drivers/net/can/usb/mcba_usb.c                             |    4 
 drivers/net/can/usb/peak_usb/pcan_usb_core.c               |    4 
 drivers/net/dsa/mv88e6xxx/global1_vtu.c                    |   59 ++++++++++--
 drivers/net/ethernet/broadcom/b44.c                        |    3 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c          |    2 
 drivers/net/ethernet/faraday/ftgmac100.c                   |    4 
 drivers/net/ethernet/mellanox/mlx4/fw.c                    |    6 -
 drivers/net/ethernet/mellanox/mlx4/fw.h                    |    4 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          |   15 +--
 drivers/net/ethernet/mellanox/mlxsw/core.c                 |    3 
 drivers/net/ethernet/microchip/lan743x_main.c              |   13 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c                |   12 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c      |    3 
 drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c       |    5 +
 drivers/net/geneve.c                                       |    3 
 drivers/net/usb/qmi_wwan.c                                 |    2 
 drivers/pinctrl/pinctrl-rockchip.c                         |    2 
 drivers/regulator/core.c                                   |   38 ++++---
 drivers/regulator/pfuze100-regulator.c                     |   13 +-
 drivers/regulator/ti-abb-regulator.c                       |   12 ++
 drivers/s390/block/dasd.c                                  |    6 +
 drivers/scsi/ufs/ufshcd.c                                  |    6 -
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c               |    1 
 drivers/staging/speakup/spk_ttyio.c                        |   12 ++
 drivers/tty/serial/imx.c                                   |   20 ----
 fs/efivarfs/super.c                                        |    1 
 fs/ext4/ext4.h                                             |    3 
 fs/libfs.c                                                 |    6 -
 fs/super.c                                                 |   33 ------
 fs/xfs/libxfs/xfs_rmap_btree.c                             |   16 +--
 fs/xfs/scrub/bmap.c                                        |    8 -
 fs/xfs/scrub/btree.c                                       |   45 +++++----
 include/net/ip_tunnels.h                                   |    7 -
 kernel/fail_function.c                                     |    5 -
 kernel/ptrace.c                                            |   16 +--
 kernel/seccomp.c                                           |    5 -
 mm/huge_memory.c                                           |    9 -
 mm/page_alloc.c                                            |    5 +
 net/bridge/br_device.c                                     |    1 
 net/can/af_can.c                                           |   38 +++++--
 net/core/devlink.c                                         |    6 -
 net/core/netpoll.c                                         |   22 +++-
 net/ipv4/inet_diag.c                                       |    4 
 net/ipv4/tcp_bbr.c                                         |    2 
 net/ipv6/ah6.c                                             |    3 
 net/mac80211/rc80211_minstrel.c                            |   27 +----
 net/mac80211/rc80211_minstrel.h                            |    1 
 net/mac80211/sta_info.c                                    |   14 --
 net/ncsi/ncsi-manage.c                                     |    5 -
 net/ncsi/ncsi-netlink.c                                    |   22 ----
 net/ncsi/ncsi-netlink.h                                    |    3 
 net/netlabel/netlabel_unlabeled.c                          |   17 ++-
 net/sctp/input.c                                           |    4 
 net/sctp/sm_sideeffect.c                                   |    4 
 net/sctp/transport.c                                       |    2 
 net/x25/af_x25.c                                           |    1 
 sound/core/control.c                                       |    2 
 sound/firewire/fireworks/fireworks_transaction.c           |    4 
 sound/pci/hda/patch_realtek.c                              |   50 ++++++++++
 sound/pci/mixart/mixart_core.c                             |    5 -
 sound/soc/qcom/lpass-platform.c                            |    5 -
 sound/usb/quirks.c                                         |   10 +-
 tools/perf/builtin-lock.c                                  |    2 
 tools/testing/selftests/kvm/include/x86.h                  |    2 
 tools/testing/selftests/kvm/lib/x86.c                      |    3 
 94 files changed, 528 insertions(+), 378 deletions(-)

Aaron Lewis (1):
      selftests: kvm: Fix the segment descriptor layout to match the actual layout

Alejandro Concepcion Rodriguez (1):
      can: dev: can_restart(): post buffer from the right context

Anant Thazhemadam (2):
      can: af_can: prevent potential access of uninitialized member in can_rcv()
      can: af_can: prevent potential access of uninitialized member in canfd_rcv()

Arvind Sankar (1):
      efi/x86: Free efi_pgd with free_pages()

Aya Levin (1):
      net/mlx4_core: Fix init_hca fields offset

Brian O'Keefe (1):
      staging: rtl8723bs: Add 024c:0627 to the list of SDIO device-ids

Can Guo (1):
      scsi: ufs: Fix unbalanced scsi_block_reqs_cnt caused by ufshcd_hold()

Chen Yu (1):
      x86/microcode/intel: Check patch signature before saving microcode for early loading

Chen-Yu Tsai (4):
      Revert "arm: sun8i: orangepi-pc-plus: Set EMAC activity LEDs to active high"
      ARM: dts: sun8i: h3: orangepi-plus2e: Enable RGMII RX/TX delay on Ethernet PHY
      ARM: dts: sun8i: a83t: Enable both RGMII RX/TX delay on Ethernet PHY
      arm64: dts: allwinner: a64: bananapi-m64: Enable RGMII RX/TX delay on PHY

Colin Ian King (1):
      can: peak_usb: fix potential integer overflow on shift of a int

Dan Carpenter (2):
      Input: adxl34x - clean up a data type in adxl34x_probe()
      ALSA: firewire: Clean up a locking issue in copy_resp_to_buf()

Darrick J. Wong (4):
      vfs: remove lockdep bogosity in __sb_start_write
      xfs: fix the minrecs logic when dealing with inode root child blocks
      xfs: strengthen rmap record flags checking
      xfs: revert "xfs: fix rmap key and record comparison functions"

Dongli Zhang (1):
      page_frag: Recover from memory pressure

Edwin Peer (1):
      bnxt_en: read EEPROM A2h address using page 0

Fabio Estevam (1):
      ARM: dts: imx50-evk: Fix the chip select 1 IOMUX

Felix Fietkau (2):
      mac80211: minstrel: remove deferred sampling code
      mac80211: minstrel: fix tx status processing corner case

Filip Moc (1):
      net: usb: qmi_wwan: Set DTR quirk for MR400

Florian Fainelli (1):
      net: Have netpoll bring-up DSA management interface

Fugang Duan (1):
      tty: serial: imx: keep console clocks always on

Gerald Schaefer (1):
      mm/userfaultfd: do not access vma->vm_mm after calling handle_userfault()

Greg Kroah-Hartman (1):
      Linux 4.19.160

Hans de Goede (3):
      ACPI: button: Add DMI quirk for Medion Akoya E2228T
      iio: accel: kxcjk1013: Replace is_smo8500_device with an acpi_type enum
      iio: accel: kxcjk1013: Add support for KIOX010A ACPI DSM for setting tablet-mode

Heiner Kallweit (1):
      net: bridge: add missing counters to ndo_get_stats64 callback

Ido Schimmel (1):
      mlxsw: core: Use variable timeout for EMAD retries

Jan Kara (1):
      ext4: fix bogus warning in ext4_update_dx_flag()

Jernej Skrabec (3):
      arm64: dts: allwinner: a64: Pine64 Plus: Fix ethernet node
      arm64: dts: allwinner: h5: OrangePi PC2: Fix ethernet node
      ARM: dts: sun8i: r40: bananapi-m2-ultra: Fix ethernet node

Jianqun Xu (1):
      pinctrl: rockchip: enable gpio pclk for rockchip_gpio_to_irq

Jimmy Assarsson (1):
      can: kvaser_usb: kvaser_usb_hydra: Fix KCAN bittiming limits

Joakim Tjernlund (1):
      ALSA: usb-audio: Add delay quirk for all Logitech USB devices

Joel Stanley (2):
      net/ncsi: Fix netlink registration
      net: ftgmac100: Fix crash when removing driver

Johannes Berg (1):
      mac80211: free sta in sta_info_insert_finish() on errors

Leo Yan (1):
      perf lock: Don't free "lock_seq_stat" if read_count isn't zero

Luo Meng (1):
      fail_function: Remove a redundant mutex unlock

Marc Kleine-Budde (1):
      can: mcba_usb: mcba_usb_start_xmit(): first fill skb, then pass to can_put_echo_skb()

Max Filippov (1):
      xtensa: disable preemption around cache alias management calls

Michał Mirosław (3):
      regulator: fix memory leak with repeated set_machine_constraints()
      regulator: avoid resolve_supply() infinite recursion
      regulator: workaround self-referent regulators

Mickaël Salaün (2):
      ptrace: Set PF_SUPERPRIV when checking capability
      seccomp: Set PF_SUPERPRIV when checking capability

Necip Fazil Yildiran (1):
      Input: resistive-adc-touch - fix kconfig dependency on IIO_BUFFER

Nenad Peric (1):
      arm64: dts: allwinner: h5: OrangePi Prime: Fix ethernet node

Nishanth Menon (1):
      regulator: ti-abb: Fix array out of bound read access on the first transition

Paul Moore (2):
      netlabel: fix our progress tracking in netlbl_unlabel_staticlist()
      netlabel: fix an uninitialized warning in netlbl_unlabel_staticlist()

PeiSen Hou (1):
      ALSA: hda/realtek: Add some Clove SSID in the ALC293(ALC1220)

Randy Dunlap (1):
      MIPS: export has_transparent_hugepage() for modules

Ryan Sharpelletti (1):
      tcp: only postpone PROBE_RTT if RTT is < current min_rtt estimate

Samuel Thibault (1):
      speakup: Do not let the line discipline be used several times

Sean Nyekjaer (1):
      regulator: pfuze100: limit pfuze-support-disable-sw to pfuze{100,200}

Sebastian Andrzej Siewior (1):
      atm: nicstar: Unmap DMA on send error

Sergey Matyukevich (1):
      arm: dts: imx6qdl-udoo: fix rgmii phy-mode for ksz9031 phy

Srinivasa Rao Mandadapu (1):
      ASoC: qcom: lpass-platform: Fix memory leak

Stefan Haberland (1):
      s390/dasd: fix null pointer dereference for ERP requests

Subash Abhinov Kasiviswanathan (1):
      net: qualcomm: rmnet: Fix incorrect receive packet handling during cleanup

Sven Van Asbroeck (2):
      lan743x: fix issue causing intermittent kernel log warnings
      lan743x: prevent entire kernel HANG on open, for some platforms

Takashi Iwai (1):
      ALSA: mixart: Fix mutex deadlock

Takashi Sakamoto (1):
      ALSA: ctl: fix error path at adding user-defined element set

Thomas Richter (1):
      s390/cpum_sf.c: fix file permission for cpum_sfb_size

Tobias Waldekranz (1):
      net: dsa: mv88e6xxx: Avoid VTU corruption on 6097

Vamshi K Sthambamkadi (1):
      efivarfs: fix memory leak in efivarfs_create()

Vladyslav Tarasiuk (1):
      net/mlx5: Disable QoS when min_rates on all VFs are zero

Wang Hai (2):
      devlink: Add missing genlmsg_cancel() in devlink_nl_sb_port_pool_fill()
      inet_diag: Fix error path to cancel the meseage in inet_req_diag_fill()

Will Deacon (1):
      arm64: psci: Avoid printing in cpu_psci_cpu_die()

Wu Bo (1):
      can: m_can: m_can_handle_state_change(): fix state change

Xie He (1):
      net: x25: Increase refcnt of "struct x25_neigh" in x25_rx_call_request

Xin Long (1):
      sctp: change to hold/put transport for proto_unreach_timer

Xiongfeng Wang (1):
      drm/sun4i: dw-hdmi: fix error return code in sun8i_dw_hdmi_bind()

Yi-Hung Wei (1):
      ip_tunnels: Set tunnel option flag when tunnel metadata is present

Yicong Yang (1):
      libfs: fix error cast of negative value in simple_attr_write()

Zhang Changzhong (4):
      ah6: fix error return code in ah6_input()
      net: b44: fix error return code in b44_init_one()
      qed: fix error return code in qed_iwarp_ll2_start()
      qlcnic: fix error return code in qlcnic_83xx_restart_hw()

Zhang Qilong (2):
      can: ti_hecc: Fix memleak in ti_hecc_probe
      MIPS: Alchemy: Fix memleak in alchemy_clk_setup_cpu

