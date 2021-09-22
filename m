Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7B2414773
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 13:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbhIVLOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 07:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235373AbhIVLOU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 07:14:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1952E60F23;
        Wed, 22 Sep 2021 11:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632309170;
        bh=HSd7b5UZNN86IJJN2ocXwli9AdbI3A9XvIEyDkIlkDg=;
        h=From:To:Cc:Subject:Date:From;
        b=0ObIhsBtqyCJGW5YSd1ffoFObnaUVOCnH6+e6Egqly1cJexp7sjhkycQLueXioOrh
         5tkO6cZi/XcfVxglDXYWC6VFWO+EL1Jju/xZCQQSoTDy4uMUoGaA/qjXY2KgcTlBjT
         LJnb0EeiBG1tK8W5fltCG0aDFxlftbHlJJiHvarg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.283
Date:   Wed, 22 Sep 2021 13:12:43 +0200
Message-Id: <163230916315125@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.283 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/mtd/gpmc-nand.txt        |    2 
 Makefile                                                   |    2 
 arch/arc/mm/cache.c                                        |    2 
 arch/arm/boot/compressed/Makefile                          |    2 
 arch/arm/boot/dts/tegra20-tamonten.dtsi                    |   14 -
 arch/arm/kernel/Makefile                                   |    6 
 arch/arm/kernel/return_address.c                           |    4 
 arch/arm64/boot/dts/exynos/exynos7.dtsi                    |    2 
 arch/m68k/emu/nfeth.c                                      |    4 
 arch/mips/mti-malta/malta-dtshim.c                         |    2 
 arch/openrisc/kernel/entry.S                               |    2 
 arch/parisc/kernel/signal.c                                |    6 
 arch/powerpc/boot/crt0.S                                   |    3 
 arch/powerpc/kernel/module_64.c                            |    2 
 arch/powerpc/perf/hv-gpci.c                                |    2 
 arch/s390/kernel/dis.c                                     |    2 
 arch/s390/kernel/jump_label.c                              |    2 
 arch/s390/net/bpf_jit_comp.c                               |    9 -
 arch/x86/events/amd/ibs.c                                  |    8 +
 arch/x86/kernel/reboot.c                                   |    3 
 arch/x86/kvm/x86.c                                         |    4 
 arch/x86/mm/init_64.c                                      |    6 
 arch/x86/xen/enlighten.c                                   |    7 
 arch/x86/xen/p2m.c                                         |    4 
 arch/xtensa/Kconfig                                        |    2 
 arch/xtensa/platforms/iss/console.c                        |   17 +-
 certs/Makefile                                             |    8 +
 drivers/ata/libata-core.c                                  |    6 
 drivers/ata/sata_dwc_460ex.c                               |   12 -
 drivers/base/power/wakeirq.c                               |   12 +
 drivers/base/regmap/regmap.c                               |    2 
 drivers/bcma/main.c                                        |    6 
 drivers/block/Kconfig                                      |    4 
 drivers/block/cryptoloop.c                                 |    2 
 drivers/clk/mvebu/kirkwood.c                               |    1 
 drivers/crypto/mxs-dcp.c                                   |   81 ++++++-----
 drivers/crypto/omap-sham.c                                 |    2 
 drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c       |    4 
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c         |    4 
 drivers/crypto/qat/qat_common/adf_common_drv.h             |    8 -
 drivers/crypto/qat/qat_common/adf_init.c                   |    5 
 drivers/crypto/qat/qat_common/adf_isr.c                    |    7 
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c              |    3 
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c              |   12 -
 drivers/crypto/qat/qat_common/adf_vf_isr.c                 |    7 
 drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c |    4 
 drivers/crypto/talitos.c                                   |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c                    |    2 
 drivers/gpu/drm/msm/dsi/dsi.c                              |    6 
 drivers/i2c/busses/i2c-highlander.c                        |    2 
 drivers/i2c/busses/i2c-iop3xx.c                            |    6 
 drivers/i2c/busses/i2c-mt65xx.c                            |    2 
 drivers/i2c/busses/i2c-s3c2410.c                           |    2 
 drivers/iio/dac/ad5624r_spi.c                              |   18 ++
 drivers/media/i2c/tc358743.c                               |    2 
 drivers/media/rc/rc-loopback.c                             |    2 
 drivers/media/usb/dvb-usb/nova-t-usb2.c                    |    6 
 drivers/media/usb/dvb-usb/vp702x.c                         |   12 +
 drivers/media/usb/go7007/go7007-driver.c                   |   26 ---
 drivers/media/usb/stkwebcam/stk-webcam.c                   |    6 
 drivers/media/usb/uvc/uvc_v4l2.c                           |   34 +++-
 drivers/mfd/ab8500-core.c                                  |    2 
 drivers/mfd/stmpe.c                                        |    4 
 drivers/mfd/tc3589x.c                                      |    2 
 drivers/mfd/wm8994-irq.c                                   |    2 
 drivers/misc/vmw_vmci/vmci_queue_pair.c                    |    6 
 drivers/mmc/host/dw_mmc.c                                  |    1 
 drivers/mmc/host/moxart-mmc.c                              |    1 
 drivers/mmc/host/rtsx_pci_sdmmc.c                          |   36 +++-
 drivers/mtd/nand/atmel_nand.c                              |    1 
 drivers/mtd/nand/cafe_nand.c                               |    4 
 drivers/net/dsa/b53/b53_common.c                           |    3 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c          |    2 
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c                  |    1 
 drivers/net/ethernet/qlogic/qed/qed_main.c                 |    7 
 drivers/net/ethernet/qlogic/qede/qede_main.c               |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c           |    1 
 drivers/net/ethernet/rdc/r6040.c                           |    9 +
 drivers/net/ethernet/renesas/sh_eth.c                      |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c        |   18 +-
 drivers/net/ethernet/wiznet/w5100.c                        |    2 
 drivers/net/ethernet/xilinx/ll_temac_main.c                |    4 
 drivers/net/phy/dp83640_reg.h                              |    2 
 drivers/net/usb/cdc_mbim.c                                 |    5 
 drivers/net/wireless/ath/ath.h                             |    3 
 drivers/net/wireless/ath/ath5k/mac80211-ops.c              |    2 
 drivers/net/wireless/ath/ath6kl/wmi.c                      |    4 
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c             |    3 
 drivers/net/wireless/ath/ath9k/htc_drv_main.c              |    2 
 drivers/net/wireless/ath/ath9k/hw.c                        |   12 -
 drivers/net/wireless/ath/ath9k/hw.h                        |    1 
 drivers/net/wireless/ath/ath9k/main.c                      |   95 ++++++++++++-
 drivers/net/wireless/ath/key.c                             |   41 +++--
 drivers/nvme/host/pci.c                                    |    7 
 drivers/parport/ieee1284_ops.c                             |    2 
 drivers/pci/msi.c                                          |    3 
 drivers/pci/pci.c                                          |   15 +-
 drivers/pci/quirks.c                                       |   13 -
 drivers/pci/syscall.c                                      |    4 
 drivers/pinctrl/pinctrl-single.c                           |    1 
 drivers/platform/chrome/cros_ec_proto.c                    |    9 +
 drivers/power/supply/axp288_fuel_gauge.c                   |    4 
 drivers/power/supply/max17042_battery.c                    |    8 -
 drivers/rtc/rtc-tps65910.c                                 |    2 
 drivers/scsi/BusLogic.c                                    |    4 
 drivers/soc/qcom/smsm.c                                    |   11 +
 drivers/spi/spi-pic32.c                                    |    1 
 drivers/staging/board/board.c                              |    7 
 drivers/staging/ks7010/ks7010_sdio.c                       |    2 
 drivers/tty/hvc/hvsi.c                                     |   19 ++
 drivers/tty/serial/8250/8250_pci.c                         |    2 
 drivers/tty/serial/8250/8250_port.c                        |    3 
 drivers/tty/serial/jsm/jsm_neo.c                           |    2 
 drivers/tty/serial/jsm/jsm_tty.c                           |    3 
 drivers/tty/tty_io.c                                       |    4 
 drivers/usb/gadget/composite.c                             |    8 -
 drivers/usb/gadget/function/u_ether.c                      |    5 
 drivers/usb/gadget/udc/at91_udc.c                          |    4 
 drivers/usb/gadget/udc/mv_u3d_core.c                       |   19 +-
 drivers/usb/host/ehci-orion.c                              |    8 -
 drivers/usb/host/fotg210-hcd.c                             |   41 ++---
 drivers/usb/host/fotg210.h                                 |    5 
 drivers/usb/host/ohci-tmio.c                               |    3 
 drivers/usb/host/xhci.c                                    |   24 +--
 drivers/usb/phy/phy-fsl-usb.c                              |    2 
 drivers/usb/phy/phy-isp1301.c                              |    2 
 drivers/usb/phy/phy-tahvo.c                                |    4 
 drivers/usb/phy/phy-twl6030-usb.c                          |    5 
 drivers/usb/serial/mos7720.c                               |    4 
 drivers/usb/usbip/vhci_hcd.c                               |   24 +++
 drivers/vfio/Kconfig                                       |    2 
 drivers/video/fbdev/asiliantfb.c                           |    3 
 drivers/video/fbdev/core/fbmem.c                           |    7 
 drivers/video/fbdev/kyro/fbdev.c                           |    8 +
 drivers/video/fbdev/riva/fbdev.c                           |    3 
 fs/btrfs/inode.c                                           |    2 
 fs/cifs/cifs_unicode.c                                     |    9 -
 fs/cifs/sess.c                                             |    2 
 fs/ext4/inline.c                                           |    6 
 fs/gfs2/acl.c                                              |   27 +--
 fs/gfs2/lock_dlm.c                                         |    5 
 fs/udf/misc.c                                              |   13 +
 fs/udf/super.c                                             |   25 ++-
 include/crypto/public_key.h                                |    4 
 include/linux/hugetlb.h                                    |    9 +
 include/linux/pci.h                                        |    5 
 include/linux/power/max17042_battery.h                     |    2 
 include/linux/skbuff.h                                     |    2 
 include/uapi/linux/serial_reg.h                            |    1 
 kernel/events/core.c                                       |    2 
 kernel/fork.c                                              |    1 
 kernel/pid_namespace.c                                     |    2 
 lib/test_bpf.c                                             |   13 +
 mm/kmemleak.c                                              |    2 
 mm/page_alloc.c                                            |    8 -
 net/bluetooth/cmtp/cmtp.h                                  |    2 
 net/bluetooth/hci_core.c                                   |   14 +
 net/bluetooth/hci_event.c                                  |   15 ++
 net/bluetooth/sco.c                                        |   50 +++---
 net/caif/chnl_net.c                                        |   19 --
 net/core/flow_dissector.c                                  |   12 +
 net/dccp/minisocks.c                                       |    2 
 net/ipv4/icmp.c                                            |   23 ++-
 net/ipv4/igmp.c                                            |    2 
 net/ipv4/ip_output.c                                       |    5 
 net/ipv4/route.c                                           |   46 ++++--
 net/ipv4/tcp_input.c                                       |    2 
 net/ipv4/tcp_ipv4.c                                        |    5 
 net/l2tp/l2tp_core.c                                       |    4 
 net/netlabel/netlabel_cipso_v4.c                           |   12 -
 net/netlink/af_netlink.c                                   |    4 
 net/sched/cls_flower.c                                     |    4 
 net/sunrpc/auth_gss/svcauth_gss.c                          |    2 
 net/tipc/socket.c                                          |    2 
 net/unix/af_unix.c                                         |    2 
 security/integrity/ima/ima_mok.c                           |    2 
 security/smack/smack_access.c                              |   17 +-
 sound/core/pcm_lib.c                                       |    2 
 sound/soc/intel/boards/bytcr_rt5640.c                      |    9 -
 179 files changed, 933 insertions(+), 489 deletions(-)

Adrian Bunk (1):
      bnx2x: Fix enabling network interfaces without VFs

Andreas Obergschwandtner (1):
      ARM: tegra: tamonten: Fix UART pad setting

Andrew Morton (1):
      mm/kmemleak.c: make cond_resched() rate-limiting more efficient

Andy Shevchenko (2):
      ata: sata_dwc_460ex: No need to call phy_exit() befre phy_init()
      PCI: Sync __pci_register_driver() stub for CONFIG_PCI=n

Anirudh Rayabharam (1):
      usbip: give back URBs for unsent unlink requests during cleanup

Austin Kim (1):
      IMA: remove -Wmissing-prototypes warning

Baptiste Lepers (1):
      events: Reuse value read using READ_ONCE instead of re-reading it

Ben Dooks (1):
      ARM: 8918/2: only build return_address() if needed

Bob Peterson (1):
      gfs2: Don't call dlm after protocol is unmounted

Christoph Hellwig (1):
      cryptoloop: add a deprecation warning

Christophe JAILLET (4):
      nvme-pci: Fix an error handling path in 'nvme_probe()'
      drm/msm/dsi: Fix some reference counted resource leaks
      staging: ks7010: Fix the initialization of the 'sleep_status' structure
      mtd: rawnand: cafe: Fix a resource leak in the error handling path of 'cafe_nand_probe()'

Christophe Leroy (1):
      crypto: talitos - reduce max key size for SEC1

Colin Ian King (2):
      Bluetooth: increase BTNAMSIZ to 21 chars to fix potential buffer overflow
      parport: remove non-zero check on count

Damien Le Moal (1):
      libata: fix ata_host_start()

Dan Carpenter (2):
      Bluetooth: sco: prevent information leak in sco_conn_defer_accept()
      ath6kl: wmi: fix an error code in ath6kl_wmi_sync_point()

Daniele Palmas (1):
      net: usb: cdc_mbim: avoid altsetting toggling for Telit LN920

David Heidelberg (1):
      ARM: 9105/1: atags_to_fdt: don't warn about stack size

Desmond Cheong Zhi Xi (3):
      Bluetooth: fix repeated calls to sco_sock_kill
      Bluetooth: skip invalid hci_sync_conn_complete_evt
      Bluetooth: avoid circular locks in sco_sock_connect

Ding Hui (1):
      cifs: fix wrong release in sess_alloc_buffer() failed path

Dinghao Liu (1):
      qlcnic: Remove redundant unlock in qlcnic_pinit_from_rom

Dmitry Osipenko (1):
      rtc: tps65910: Correct driver module alias

Dongliang Mu (2):
      media: dvb-usb: fix uninit-value in dvb_usb_adapter_dvb_init
      media: dvb-usb: fix uninit-value in vp702x_read_mac_addr

Eric Dumazet (3):
      ipv4: make exception cache less predictible
      net-caif: avoid user-triggerable WARN_ON(1)
      net/af_unix: fix a data-race in unix_dgram_poll

Esben Haabendal (1):
      net: ll_temac: Remove left-over debug message

Evgeny Novikov (1):
      usb: ehci-orion: Handle errors of clk_prepare_enable() in probe

Fangrui Song (1):
      powerpc/boot: Delete unneeded .globl _zimage_start

Florian Fainelli (1):
      r6040: Restore MDIO clock frequency after MAC reset

Geert Uytterhoeven (1):
      staging: board: Fix uninitialized spinlock when attaching genpd

Giovanni Cabiddu (4):
      crypto: qat - do not ignore errors from enable_vf2pf_comms()
      crypto: qat - handle both source of interrupt in VF ISR
      crypto: qat - do not export adf_iov_putmsg()
      crypto: qat - use proper type for vf_mask

Greg Kroah-Hartman (3):
      mtd: nand: atmel_nand: remove build warning in atmel_nand_remove()
      serial: 8250_pci: make setup_port() parameters explicitly unsigned
      Linux 4.9.283

Grygorii Strashko (1):
      PM / wakeirq: Enable dedicated wakeirq for suspend

Gustavo A. R. Silva (2):
      ipv4: ip_output.c: Fix out-of-bounds warning in ip_copy_addrs()
      flow_dissector: Fix out-of-bounds warnings

Hans de Goede (3):
      power: supply: axp288_fuel_gauge: Report register-address on readb / writeb errors
      libata: add ATA_HORKAGE_NO_NCQ_TRIM for Samsung 860 and 870 SSDs
      ASoC: Intel: bytcr_rt5640: Move "Platform Clock" routes to the maps for the matching in-/output

Heiko Carstens (1):
      s390/jump_label: print real address in a case of a jump label bug

Hoang Le (1):
      tipc: increase timeout in tipc_sk_enqueue()

Ilya Leoshkevich (1):
      s390/bpf: Fix 64-bit subtraction of the -0x80000000 constant

J. Bruce Fields (1):
      rpc: fix gss_svc_init cleanup on failure

Jack Pham (1):
      usb: gadget: composite: Allow bMaxPower=0 if self-powered

Jan Kara (2):
      gfs2: Don't clear SGID when inheriting ACLs
      udf: Check LVID earlier

Jason Gunthorpe (1):
      vfio: Use config not menuconfig for VFIO_NOIOMMU

Javier Martinez Canillas (1):
      usb: phy: isp1301: Fix build warning when CONFIG_OF is disabled

Jeongtae Park (1):
      regmap: fix the offset of register error log

Jiri Slaby (2):
      xtensa: ISS: don't panic in rs_init
      hvsi: don't panic on tty_register_driver failure

Johan Almbladh (2):
      bpf/tests: Fix copy-and-paste error in double word test
      bpf/tests: Do not PASS tests without actually testing the result

Jonathan Cameron (1):
      iio: dac: ad5624r: Fix incorrect handling of an optional regulator.

Jouni Malinen (5):
      ath: Use safer key clearing with key cache entries
      ath9k: Clear key cache explicitly on disabling hardware
      ath: Export ath_hw_keysetmac()
      ath: Modify ath_key_delete() to not need full key entry
      ath9k: Postpone key cache entry deletion for TXQ frames reference it

Juergen Gross (2):
      xen: fix setting of max_pfn in shared_info
      xen: reset legacy rtc flag for PV domU

Kai-Heng Feng (1):
      Bluetooth: Move shutdown callback before flushing tx and rx queue

Kajol Jain (1):
      powerpc/perf/hv-gpci: Fix counter value parsing

Kelly Devilliv (2):
      usb: host: fotg210: fix the endpoint's transactional opportunities calculation
      usb: host: fotg210: fix the actual_length of an iso packet

Kim Phillips (1):
      perf/x86/amd/ibs: Work around erratum #1197

Krzysztof Kozlowski (2):
      arm64: dts: exynos: correct GIC CPU interfaces address range on Exynos7
      power: supply: max17042: handle fails of reading status register

Krzysztof Wilczyński (1):
      PCI: Return ~0 data on pciconfig_read() CAP_SYS_ADMIN failure

Len Baker (1):
      CIFS: Fix a potencially linear read overflow

Lin, Zhenpeng (1):
      dccp: don't duplicate ccid when cloning dccp sock

Linus Walleij (1):
      clk: kirkwood: Fix a clocking boot regression

Liu Jian (1):
      igmp: Add ip_mc_list lock in ip_check_mc_rcu

Liu Zixian (1):
      mm/hugetlb: initialize hugetlb_usage in mm_init

Maciej W. Rozycki (2):
      serial: 8250: Define RX trigger levels for OxSemi 950 devices
      scsi: BusLogic: Fix missing pr_cont() use

Maciej Żenczykowski (1):
      usb: gadget: u_ether: fix a potential null pointer dereference

Marc Zyngier (1):
      mfd: Don't use irq_create_mapping() to resolve a mapping

Marco Chiappero (2):
      crypto: qat - fix reuse of completion variable
      crypto: qat - fix naming for init/shutdown VF to PF notifications

Marek Behún (2):
      PCI: Call Max Payload Size-related fixup quirks early
      PCI: Restrict ASMedia ASM1062 SATA Max Payload Size Supported

Marek Marczykowski-Górecki (1):
      PCI/MSI: Skip masking MSI-X on Xen PV

Martin KaFai Lau (1):
      tcp: seq_file: Avoid skipping sk during tcp_seek_last_pos

Mathias Nyman (1):
      Revert "USB: xhci: fix U1/U2 handling for hardware with XHCI_INTEL_HOST quirk set"

Mathieu Desnoyers (1):
      ipv4/icmp: l3mdev: Perform icmp error route lookup on source device routing table (v2)

Mauro Carvalho Chehab (1):
      media: uvc: don't do DMA on stack

Miaoqing Pan (1):
      ath9k: fix sleeping in atomic context

Michael Ellerman (1):
      powerpc/module64: Fix comment in R_PPC64_ENTRY handling

Mike Rapoport (1):
      x86/mm: Fix kern_addr_valid() to cope with existing but not present entries

Mikulas Patocka (1):
      parisc: fix crash with signals and alloca

Miquel Raynal (1):
      dt-bindings: mtd: gpmc: Fix the ECC bytes vs. OOB bytes equation

Muchun Song (1):
      mm/page_alloc: speed up the iteration of max_order

Nadezda Lutovinova (1):
      usb: gadget: mv_u3d: request_irq() after initializing UDC

Nathan Chancellor (1):
      net: ethernet: stmmac: Do not use unreachable() in ipq806x_gmac_probe()

Nguyen Dinh Phi (1):
      tty: Fix data race between tiocsti() and flush_to_ldisc()

Oleksij Rempel (1):
      MIPS: Malta: fix alignment of the devicetree buffer

Patryk Duda (1):
      platform/chrome: cros_ec_proto: Send command again when timeout occurs

Paul Blakey (1):
      net/sched: cls_flower: Use mask for addr_type

Paul Gortmaker (1):
      x86/reboot: Limit Dell Optiplex 990 quirk to early BIOS versions

Pavel Skripkin (5):
      media: stkwebcam: fix memory leak in stk_camera_probe
      m68k: emu: Fix invalid free in nfeth_cleanup()
      media: go7007: remove redundant initialization
      net: cipso: fix warnings in netlbl_cipsov4_add_std
      Bluetooth: add timeout sanity check to hci_inquiry

Philipp Zabel (1):
      tc358743: fix register i2c_rd/wr function fix

Qu Wenruo (1):
      Revert "btrfs: compression: don't try to compress if we don't have enough pages"

Rafael J. Wysocki (2):
      PCI: PM: Enable PME if it can be signaled from D3cold
      PCI: Use pci_update_current_state() in pci_enable_device_flags()

Rafał Miłecki (1):
      net: dsa: b53: Fix calculating number of switch ports

Randy Dunlap (4):
      xtensa: fix kconfig unmet dependency warning for HAVE_FUTEX_CMPXCHG
      openrisc: don't printk() unconditionally
      ptp: dp83640: don't define PAGE0
      ARC: export clear_user_page() for modules

Sean Anderson (2):
      crypto: mxs-dcp - Check for DMA mapping errors
      crypto: mxs-dcp - Use sg_mapping_iter to copy data

Sean Young (1):
      media: rc-loopback: return number of emitters rather than error

Sebastian Krzyszkowiak (1):
      power: supply: max17042_battery: fix typo in MAx17042_TOFF

Sergey Shtylyov (9):
      i2c: highlander: add IRQ check
      usb: gadget: udc: at91: add IRQ check
      usb: phy: fsl-usb: add IRQ check
      usb: phy: twl6030: add IRQ checks
      usb: host: ohci-tmio: add IRQ check
      usb: phy: tahvo: add IRQ check
      i2c: iop3xx: fix deferred probing
      i2c: s3c2410: fix IRQ check
      i2c: mt65xx: fix IRQ check

Shai Malin (2):
      qed: Fix the VF msix vectors flow
      qede: Fix memset corruption

Stefan Berger (1):
      certs: Trigger creation of RSA module signing key if it's not an RSA key

Stephan Gerhold (1):
      soc: qcom: smsm: Fix missed interrupts if state changes while masked

Stian Skjelstad (1):
      udf_get_extendedattr() had no boundary checks.

Tetsuo Handa (1):
      fbmem: don't allow too huge resolutions

Theodore Ts'o (1):
      ext4: fix race writing to an inline_data file while its xattrs are changing

Thomas Hebb (1):
      mmc: rtsx_pci: Fix long reads when clock is prescaled

Tianjia Zhang (1):
      Smack: Fix wrong semantics in smk_access_entry()

Tom Rix (1):
      USB: serial: mos7720: improve OOM-handling in read_mos_reg()

Tony Lindgren (4):
      crypto: omap-sham - clear dma flags only after omap_sham_update_dma_stop()
      spi: spi-pic32: Fix issue with uninitialized dma_slave_config
      mmc: dw_mmc: Fix issue with uninitialized dma_slave_config
      mmc: moxart: Fix issue with uninitialized dma_slave_config

Tuo Li (1):
      gpu: drm: amd: amdgpu: amdgpu_i2c: fix possible uninitialized-variable access in amdgpu_i2c_router_select_ddc_port()

Vasily Averin (1):
      memcg: enable accounting for pids in nested pid namespaces

Vasily Gorbik (1):
      s390/disassembler: correct disassembly lines alignment

Wang Hai (1):
      VMCI: fix NULL pointer dereference when unmapping queue pair

Xiyu Yang (1):
      net/l2tp: Fix reference count leak in l2tp_udp_recv_core

Yajun Deng (1):
      netlink: Deal with ESRCH error in nlmsg_notify()

Yang Li (1):
      ethtool: Fix an error code in cxgb2.c

Yang Yingliang (1):
      net: w5100: check return value after calling platform_get_resource()

Yoshihiro Shimoda (1):
      net: renesas: sh_eth: Fix freeing wrong tx descriptor

Zekun Shen (1):
      ath9k: fix OOB read ar9300_eeprom_restore_internal

Zelin Deng (1):
      KVM: x86: Update vCPU's hv_clock before back to guest when tsc_offset is adjusted

Zenghui Yu (1):
      bcma: Fix memory leak for internally-handled cores

Zhen Lei (1):
      pinctrl: single: Fix error return code in pcs_parse_bits_in_pinctrl_entry()

Zheyu Ma (5):
      video: fbdev: kyro: fix a DoS bug by restricting user input
      tty: serial: jsm: hold port lock when reporting modem line changes
      video: fbdev: asiliantfb: Error out if 'pixclock' equals zero
      video: fbdev: kyro: Error out if 'pixclock' equals zero
      video: fbdev: riva: Error out if 'pixclock' equals zero

Zubin Mithra (1):
      ALSA: pcm: fix divide error in snd_pcm_lib_ioctl

zhenggy (1):
      tcp: fix tp->undo_retrans accounting in tcp_sacktag_one()

zhenwei pi (1):
      crypto: public_key: fix overflow during implicit conversion

王贇 (1):
      net: fix NULL pointer reference in cipso_v4_doi_free

