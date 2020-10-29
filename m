Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB7429E6DA
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 10:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgJ2JFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 05:05:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbgJ2JF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 05:05:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60816206D9;
        Thu, 29 Oct 2020 09:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603962326;
        bh=WPb74h6lvAWlCa3YeLzOmzAf2EWgvcUgXm6+yiZ8h6s=;
        h=From:To:Cc:Subject:Date:From;
        b=H2GC1WIUKuoJ5kc0qwU2YPW/zWVn0BSjiqN8u9pDbxggQNh3zaCqGELIAUrUYLeao
         EgZ6LOq0ynwba/Y/X2vtMPmAupY/gHchjkwnHLKXyrz+YiDmvBPijF+gx6eyOOVTKb
         E4ooTzmBN6MTZ0ae8OYvx0/63Kva4o6wPtydfGPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.203
Date:   Thu, 29 Oct 2020 10:06:11 +0100
Message-Id: <160396237119880@kroah.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.203 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt                |    2 
 Documentation/networking/ip-sysctl.txt                         |    4 
 Makefile                                                       |    2 
 arch/arc/plat-hsdk/Kconfig                                     |    1 
 arch/arm/boot/dts/owl-s500.dtsi                                |    6 
 arch/arm/mm/cache-l2x0.c                                       |   16 +
 arch/arm64/boot/dts/qcom/msm8916.dtsi                          |    4 
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi                         |    4 
 arch/powerpc/include/asm/reg.h                                 |    2 
 arch/powerpc/kernel/tau_6xx.c                                  |   82 ++-----
 arch/powerpc/perf/hv-gpci-requests.h                           |    6 
 arch/powerpc/perf/isa207-common.c                              |   10 
 arch/powerpc/platforms/Kconfig                                 |    9 
 arch/powerpc/platforms/powernv/opal-dump.c                     |   50 ++--
 arch/powerpc/platforms/pseries/rng.c                           |    1 
 arch/powerpc/sysdev/xics/icp-hv.c                              |    1 
 arch/x86/kernel/fpu/init.c                                     |   30 ++
 arch/x86/kvm/emulate.c                                         |    2 
 arch/x86/kvm/mmu.c                                             |    1 
 arch/x86/kvm/svm.c                                             |    1 
 crypto/algif_aead.c                                            |    7 
 crypto/algif_skcipher.c                                        |    2 
 drivers/android/binder.c                                       |   35 ---
 drivers/bluetooth/hci_ldisc.c                                  |    1 
 drivers/bluetooth/hci_serdev.c                                 |    2 
 drivers/clk/at91/clk-main.c                                    |   11 -
 drivers/clk/bcm/clk-bcm2835.c                                  |    4 
 drivers/cpufreq/powernv-cpufreq.c                              |    9 
 drivers/crypto/ccp/ccp-ops.c                                   |    2 
 drivers/crypto/ixp4xx_crypto.c                                 |    2 
 drivers/crypto/mediatek/mtk-platform.c                         |    8 
 drivers/crypto/omap-sham.c                                     |    3 
 drivers/edac/i5100_edac.c                                      |   11 -
 drivers/gpu/drm/gma500/cdv_intel_dp.c                          |    2 
 drivers/gpu/drm/virtio/virtgpu_kms.c                           |    2 
 drivers/gpu/drm/virtio/virtgpu_vq.c                            |   10 
 drivers/hid/hid-input.c                                        |    4 
 drivers/hid/hid-roccat-kone.c                                  |   23 +-
 drivers/i2c/busses/Kconfig                                     |    1 
 drivers/i2c/i2c-core-acpi.c                                    |   11 -
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c                     |    1 
 drivers/infiniband/hw/mlx4/cm.c                                |    3 
 drivers/infiniband/hw/mlx4/mad.c                               |   34 ++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h                           |    2 
 drivers/infiniband/hw/qedr/main.c                              |    2 
 drivers/infiniband/sw/rdmavt/vt.c                              |    4 
 drivers/input/keyboard/ep93xx_keypad.c                         |    4 
 drivers/input/keyboard/omap4-keypad.c                          |    6 
 drivers/input/keyboard/twl4030_keypad.c                        |    8 
 drivers/input/serio/sun4i-ps2.c                                |    9 
 drivers/input/touchscreen/imx6ul_tsc.c                         |   27 +-
 drivers/input/touchscreen/stmfts.c                             |    2 
 drivers/mailbox/mailbox.c                                      |   12 -
 drivers/media/firewire/firedtv-fw.c                            |    6 
 drivers/media/i2c/m5mols/m5mols_core.c                         |    3 
 drivers/media/i2c/tc358743.c                                   |    2 
 drivers/media/pci/bt8xx/bttv-driver.c                          |   13 -
 drivers/media/pci/saa7134/saa7134-tvaudio.c                    |    3 
 drivers/media/platform/exynos4-is/fimc-isp.c                   |    4 
 drivers/media/platform/exynos4-is/fimc-lite.c                  |    2 
 drivers/media/platform/exynos4-is/media-dev.c                  |    8 
 drivers/media/platform/exynos4-is/mipi-csis.c                  |    4 
 drivers/media/platform/mx2_emmaprp.c                           |    7 
 drivers/media/platform/omap3isp/isp.c                          |    6 
 drivers/media/platform/qcom/venus/core.c                       |    5 
 drivers/media/platform/rcar-fcp.c                              |    4 
 drivers/media/platform/s3c-camif/camif-core.c                  |    5 
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c                    |    4 
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c                  |    3 
 drivers/media/platform/sti/delta/delta-v4l2.c                  |    4 
 drivers/media/platform/sti/hva/hva-hw.c                        |    4 
 drivers/media/platform/ti-vpe/vpe.c                            |    2 
 drivers/media/platform/vsp1/vsp1_drv.c                         |   11 -
 drivers/media/rc/ati_remote.c                                  |    4 
 drivers/media/tuners/tuner-simple.c                            |    5 
 drivers/media/usb/uvc/uvc_entity.c                             |   35 +++
 drivers/media/usb/uvc/uvc_v4l2.c                               |   30 ++
 drivers/memory/fsl-corenet-cf.c                                |    6 
 drivers/memory/omap-gpmc.c                                     |    4 
 drivers/mfd/rtsx_pcr.c                                         |    4 
 drivers/mfd/sm501.c                                            |    8 
 drivers/misc/eeprom/at25.c                                     |    2 
 drivers/misc/mic/scif/scif_rma.c                               |    4 
 drivers/misc/mic/vop/vop_main.c                                |    2 
 drivers/misc/mic/vop/vop_vringh.c                              |   24 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c                        |   10 
 drivers/mmc/core/sdio_cis.c                                    |    3 
 drivers/mtd/lpddr/lpddr2_nvm.c                                 |   35 +--
 drivers/mtd/mtdoops.c                                          |   11 -
 drivers/net/can/flexcan.c                                      |   34 ++-
 drivers/net/ethernet/cisco/enic/enic.h                         |    1 
 drivers/net/ethernet/cisco/enic/enic_api.c                     |    6 
 drivers/net/ethernet/cisco/enic/enic_main.c                    |   27 +-
 drivers/net/ethernet/ibm/ibmveth.c                             |   19 +
 drivers/net/ethernet/korina.c                                  |    3 
 drivers/net/ethernet/mellanox/mlx4/en_rx.c                     |    3 
 drivers/net/ethernet/mellanox/mlx4/en_tx.c                     |    2 
 drivers/net/ethernet/realtek/r8169.c                           |  108 +++++-----
 drivers/net/usb/qmi_wwan.c                                     |    1 
 drivers/net/wan/hdlc.c                                         |   10 
 drivers/net/wan/hdlc_raw_eth.c                                 |    1 
 drivers/net/wireless/ath/ath10k/htt_rx.c                       |    8 
 drivers/net/wireless/ath/ath10k/mac.c                          |    2 
 drivers/net/wireless/ath/ath6kl/main.c                         |    3 
 drivers/net/wireless/ath/ath6kl/wmi.c                          |    5 
 drivers/net/wireless/ath/ath9k/hif_usb.c                       |   19 +
 drivers/net/wireless/ath/ath9k/htc_hst.c                       |    2 
 drivers/net/wireless/ath/wcn36xx/main.c                        |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c        |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c      |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c |    4 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c              |    9 
 drivers/net/wireless/marvell/mwifiex/scan.c                    |    2 
 drivers/net/wireless/marvell/mwifiex/sdio.c                    |    2 
 drivers/net/wireless/marvell/mwifiex/usb.c                     |    3 
 drivers/net/wireless/quantenna/qtnfmac/commands.c              |    2 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c          |   10 
 drivers/ntb/hw/amd/ntb_hw_amd.c                                |    1 
 drivers/nvme/target/core.c                                     |    3 
 drivers/pci/host/pcie-iproc-msi.c                              |   13 -
 drivers/perf/xgene_pmu.c                                       |   32 +-
 drivers/pinctrl/pinctrl-mcp23s08.c                             |   24 +-
 drivers/pwm/pwm-lpss.c                                         |    7 
 drivers/rapidio/devices/rio_mport_cdev.c                       |   18 +
 drivers/regulator/core.c                                       |   21 +
 drivers/scsi/be2iscsi/be_main.c                                |    4 
 drivers/scsi/csiostor/csio_hw.c                                |    2 
 drivers/scsi/ibmvscsi/ibmvfc.c                                 |    1 
 drivers/scsi/mvumi.c                                           |    1 
 drivers/scsi/qedi/qedi_fw.c                                    |   23 +-
 drivers/scsi/qedi/qedi_iscsi.c                                 |    2 
 drivers/scsi/qla4xxx/ql4_os.c                                  |    2 
 drivers/scsi/ufs/ufs-qcom.c                                    |    5 
 drivers/tty/hvc/hvcs.c                                         |   14 -
 drivers/tty/ipwireless/network.c                               |    4 
 drivers/tty/ipwireless/tty.c                                   |    2 
 drivers/tty/pty.c                                              |    2 
 drivers/tty/serial/Kconfig                                     |    1 
 drivers/tty/serial/fsl_lpuart.c                                |    2 
 drivers/usb/class/cdc-acm.c                                    |   23 ++
 drivers/usb/class/cdc-wdm.c                                    |   72 +++++-
 drivers/usb/core/urb.c                                         |   89 +++++---
 drivers/usb/dwc2/gadget.c                                      |   40 +++
 drivers/usb/dwc2/params.c                                      |    2 
 drivers/usb/gadget/function/f_ncm.c                            |    8 
 drivers/usb/gadget/function/f_printer.c                        |   16 +
 drivers/usb/gadget/function/u_ether.c                          |    2 
 drivers/usb/host/ohci-hcd.c                                    |   16 -
 drivers/vfio/pci/vfio_pci_intrs.c                              |    4 
 drivers/vfio/vfio_iommu_type1.c                                |    3 
 drivers/video/backlight/sky81452-backlight.c                   |    1 
 drivers/video/fbdev/sis/init.c                                 |   11 -
 drivers/video/fbdev/vga16fb.c                                  |   14 -
 drivers/virt/fsl_hypervisor.c                                  |   17 -
 fs/cifs/asn1.c                                                 |   16 -
 fs/cifs/smb2ops.c                                              |    2 
 fs/dlm/config.c                                                |    3 
 fs/ext4/fsmap.c                                                |    3 
 fs/f2fs/sysfs.c                                                |    1 
 fs/ntfs/inode.c                                                |    6 
 fs/proc/base.c                                                 |    3 
 fs/quota/quota_v2.c                                            |    1 
 fs/ramfs/file-nommu.c                                          |    2 
 fs/reiserfs/inode.c                                            |    3 
 fs/reiserfs/super.c                                            |    8 
 fs/udf/inode.c                                                 |   25 +-
 fs/udf/super.c                                                 |    6 
 fs/xfs/xfs_fsmap.c                                             |    3 
 fs/xfs/xfs_rtalloc.c                                           |   11 +
 include/linux/oom.h                                            |    1 
 include/linux/overflow.h                                       |    1 
 include/linux/sched/coredump.h                                 |    1 
 include/net/ip.h                                               |    6 
 include/scsi/scsi_common.h                                     |    7 
 include/trace/events/target.h                                  |   12 -
 include/uapi/linux/perf_event.h                                |    2 
 kernel/debug/kdb/kdb_io.c                                      |    8 
 kernel/fork.c                                                  |   21 +
 kernel/power/hibernate.c                                       |   11 -
 lib/crc32.c                                                    |    2 
 mm/memcontrol.c                                                |    5 
 mm/oom_kill.c                                                  |    2 
 net/bluetooth/l2cap_sock.c                                     |    7 
 net/ipv4/icmp.c                                                |    7 
 net/ipv4/route.c                                               |    4 
 net/ipv4/tcp_input.c                                           |    2 
 net/mac80211/cfg.c                                             |    3 
 net/mac80211/sta_info.c                                        |    4 
 net/netfilter/ipvs/ip_vs_ctl.c                                 |    7 
 net/nfc/netlink.c                                              |    2 
 net/tipc/msg.c                                                 |    3 
 net/wireless/nl80211.c                                         |    5 
 samples/mic/mpssd/mpssd.c                                      |    4 
 security/integrity/ima/ima_crypto.c                            |    2 
 sound/core/seq/oss/seq_oss.c                                   |    7 
 sound/firewire/bebob/bebob_hwdep.c                             |    3 
 sound/soc/qcom/lpass-cpu.c                                     |   16 -
 sound/soc/qcom/lpass-platform.c                                |    3 
 tools/perf/util/intel-pt.c                                     |    8 
 199 files changed, 1207 insertions(+), 631 deletions(-)

Abhishek Pandit-Subedi (1):
      Bluetooth: Only mark socket zapped after unlocking

Adam Goode (1):
      media: uvcvideo: Ensure all probed info is returned to v4l2

Aditya Pakki (1):
      media: st-delta: Fix reference count leak in delta_run_work

Adrian Hunter (1):
      perf intel-pt: Fix "context_switch event has no tid" error

Al Grant (1):
      perf: correct SNOOPX field offset

Alex Dewar (1):
      VMCI: check return value of get_user_pages_fast() for errors

Alex Williamson (1):
      vfio/pci: Clear token on bypass registration failure

Alexander Aring (1):
      fs: dlm: fix configfs memory leak

Arnd Bergmann (1):
      mtd: lpddr: fix excessive stack usage with clang

Artem Savkov (1):
      pty: do tty_flip_buffer_push without port->lock in pty_write

Arvind Sankar (1):
      x86/fpu: Allow multiple bits in clearcpuid= parameter

Athira Rajeev (1):
      powerpc/perf: Exclude pmc5/6 from the irrelevant PMU group constraints

Brooke Basile (1):
      ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill_anchored_urbs()

Bryan O'Donoghue (1):
      wcn36xx: Fix reported 802.11n rx_highest rate wcn3660/wcn3680

Can Guo (1):
      scsi: ufs: ufs-qcom: Fix race conditions caused by ufs_qcom_testbus_config()

Chris Chiu (1):
      rtl8xxxu: prevent potential memory leak

Christian Eggers (1):
      eeprom: at25: set minimum read/write access stride to 1

Christoph Hellwig (1):
      PM: hibernate: remove the bogus call to get_gendisk() in software_resume()

Christophe JAILLET (3):
      crypto: ixp4xx - Fix the size used in a 'dma_free_coherent()' call
      mwifiex: Do not use GFP_KERNEL in atomic context
      scsi: qla4xxx: Fix an error handling path in 'qla4xxx_get_host_stats()'

Claudiu Beznea (1):
      clk: at91: clk-main: update key before writing AT91_CKGR_MOR

Colin Ian King (3):
      video: fbdev: vga16fb: fix setting of pixclock because a pass-by-value error
      qtnfmac: fix resource leaks on unsupported iftype error return path
      IB/rdmavt: Fix sizeof mismatch

Cong Wang (1):
      tipc: fix the skb_unshare() in tipc_buf_append()

Cristian Ciocaltea (1):
      ARM: dts: owl-s500: Fix incorrect PPI interrupt specifiers

Dan Carpenter (10):
      ALSA: bebob: potential info leak in hwdep_read()
      cifs: remove bogus debug code
      ath6kl: prevent potential array overflow in ath6kl_add_new_sta()
      ath9k: Fix potential out of bounds in ath9k_htc_txcompletion_cb()
      HID: roccat: add bounds checking in kone_sysfs_write_settings()
      ath6kl: wmi: prevent a shift wrapping bug in ath6kl_wmi_delete_pstream_cmd()
      mfd: sm501: Fix leaks in probe()
      scsi: be2iscsi: Fix a theoretical leak in beiscsi_create_eqs()
      Input: imx6ul_tsc - clean up some errors in imx6ul_tsc_resume()
      memory: omap-gpmc: Fix a couple off by ones

Daniel Thompson (1):
      kdb: Fix pager search for multi-line strings

Darrick J. Wong (3):
      xfs: limit entries returned when counting fsmap records
      ext4: limit entries returned when counting fsmap records
      xfs: make sure the rt allocator doesn't run off the end

David Ahern (1):
      ipv4: Restore flowi4_oif update before call to xfrm_lookup_route

David Wilder (2):
      ibmveth: Switch order of ibmveth_helper calls.
      ibmveth: Identify ingress large send packets.

Defang Bo (1):
      nfc: Ensure presence of NFC_ATTR_FIRMWARE_NAME attribute in nfc_genl_fw_download()

Dinghao Liu (8):
      EDAC/i5100: Fix error handling order in i5100_init_one()
      media: omap3isp: Fix memleak in isp_probe
      media: mx2_emmaprp: Fix memleak in emmaprp_probe
      media: vsp1: Fix runtime PM imbalance on error
      media: platform: s3c-camif: Fix runtime PM imbalance on error
      media: platform: sti: hva: Fix runtime PM imbalance on error
      media: bdisp: Fix runtime PM imbalance on error
      media: venus: core: Fix runtime PM imbalance in venus_probe

Dirk Behme (1):
      i2c: rcar: Auto select RESET_CONTROLLER

Dmitry Torokhov (1):
      HID: hid-input: fix stylus battery reporting

Doug Horn (1):
      Fix use after free in get_capset_info callback.

Eli Billauer (1):
      usb: core: Solve race condition in anchor cleanup functions

Emmanuel Grumbach (1):
      iwlwifi: mvm: split a print to avoid a WARNING in ROC

Eric Biggers (1):
      reiserfs: only call unlock_new_inode() if I_NEW

Eric Dumazet (2):
      icmp: randomize the global rate limiter
      quota: clear padding in v2r1_mem2diskdqb()

Finn Thain (3):
      powerpc/tau: Use appropriate temperature sample interval
      powerpc/tau: Remove duplicated set_thresholds() call
      powerpc/tau: Disable TAU between measurements

Greg Kroah-Hartman (1):
      Linux 4.14.203

Guillaume Tucker (1):
      ARM: 9007/1: l2c: fix prefetch bits init in L2X0_AUX_CTRL using DT values

Hamish Martin (1):
      usb: ohci: Default to per-port over-current protection

Hans de Goede (3):
      pwm: lpss: Fix off by one error in base_unit math in pwm_lpss_prepare()
      pwm: lpss: Add range limit check for the base_unit register value
      i2c: core: Restore acpi_walk_dep_device_list() getting called after registering the ACPI i2c devs

Heiner Kallweit (1):
      r8169: fix data corruption issue on RTL8402

Herbert Xu (2):
      crypto: algif_aead - Do not set MAY_BACKLOG on the async path
      crypto: algif_skcipher - EBUSY on aio should be an error

Håkon Bugge (2):
      IB/mlx4: Fix starvation in paravirt mux/demux
      IB/mlx4: Adjust delayed work when a dup is observed

Jamie Iles (1):
      f2fs: wait for sysfs kobject removal before freeing f2fs_sb_info

Jan Kara (3):
      udf: Limit sparing table size
      udf: Avoid accessing uninitialized data on failed inode read
      reiserfs: Fix memory leak in reiserfs_parse_options()

Jassi Brar (1):
      mailbox: avoid timer start from callback

Jing Xiangfeng (3):
      rapidio: fix the missed put_device() for rio_mport_add_riodev
      scsi: mvumi: Fix error return in mvumi_io_attach()
      scsi: ibmvfc: Fix error return in ibmvfc_probe()

Joakim Zhang (1):
      can: flexcan: flexcan_chip_stop(): add error handling and propagate error value

Johan Hovold (1):
      USB: cdc-acm: handle broken union descriptors

Johannes Berg (1):
      nl80211: fix non-split wiphy information

Jonathan Lemon (1):
      mlx4: handle non-napi callers to napi_poll

Kaige Li (1):
      NTB: hw: amd: fix an issue about leak system resources

Kajol Jain (1):
      powerpc/perf/hv-gpci: Fix starting index value

Keita Suzuki (2):
      misc: rtsx: Fix memory leak in rtsx_pci_probe
      brcmsmac: fix memory leak in wlc_phy_attach_lcnphy

Krzysztof Kozlowski (5):
      Input: ep93xx_keypad - fix handling of platform_get_irq() error
      Input: omap4-keypad - fix handling of platform_get_irq() error
      Input: twl4030_keypad - fix handling of platform_get_irq() error
      Input: sun4i-ps2 - fix handling of platform_get_irq() error
      memory: fsl-corenet-cf: Fix handling of platform_get_irq() error

Laurent Pinchart (1):
      media: uvcvideo: Set media controller entity functions

Leon Romanovsky (1):
      overflow: Include header file with SIZE_MAX declaration

Lijun Ou (1):
      RDMA/hns: Set the unsupported wr opcode

Lorenzo Colitti (3):
      usb: gadget: f_ncm: fix ncm_bitrate for SuperSpeed and above.
      usb: gadget: u_ether: enable qmult on SuperSpeed Plus as well
      usb: gadget: f_ncm: allow using NCM in SuperSpeed Plus gadgets.

Maciej Żenczykowski (1):
      net/ipv4: always honour route mtu during forwarding

Mark Salter (1):
      drivers/perf: xgene_pmu: Fix uninitialized resource struct

Mark Tomlinson (2):
      mtd: mtdoops: Don't write panic data twice
      PCI: iproc: Set affinity mask on MSI interrupts

Matthew Wilcox (Oracle) (1):
      ramfs: fix nommu mmap with gaps in the page cache

Mauro Carvalho Chehab (1):
      media: saa7134: avoid a shift overflow

Michal Kalderon (1):
      RDMA/qedr: Fix use of uninitialized field

Michal Simek (1):
      arm64: dts: zynqmp: Remove additional compatible string for i2c IPs

Michał Mirosław (1):
      regulator: resolve supply after creating regulator

Minas Harutyunyan (1):
      usb: dwc2: Fix INTR OUT transfers in DDMA mode.

Mukesh Ojha (1):
      powerpc/powernv/opal-dump : Use IRQ_HANDLED instead of numbers in interrupt handler

Nathan Chancellor (1):
      usb: dwc2: Fix parameter type in function pointer prototype

Navid Emamdoost (1):
      clk: bcm2835: add missing release if devm_clk_hw_register fails

Neal Cardwell (1):
      tcp: fix to update snd_wl1 in bulk receiver fast path

Necip Fazil Yildiran (1):
      arc: plat-hsdk: fix kconfig dependency warning when !RESET_CONTROLLER

Nicholas Mc Guire (2):
      powerpc/pseries: Fix missing of_node_put() in rng_init()
      powerpc/icp-hv: Fix missing of_node_put() in success path

Nilesh Javali (2):
      scsi: qedi: Protect active command list to avoid list corruption
      scsi: qedi: Fix list_del corruption while removing active I/O

Oliver Neukum (2):
      media: ati_remote: sanity check for both endpoints
      USB: cdc-wdm: Make wdm_flush() interruptible and add wdm_fsync().

Pali Rohár (1):
      mmc: sdio: Check for CISTPL_VERS_1 buffer size

Pavel Machek (2):
      crypto: ccp - fix error handling
      media: firewire: fix memory leak

Peilin Ye (1):
      ipvs: Fix uninit-value in do_ip_vs_set_ctl()

Peng Fan (1):
      tty: serial: fsl_lpuart: fix lpuart32_poll_get_char

Qiushi Wu (7):
      media: platform: fcp: Fix a reference count leak.
      media: s5p-mfc: Fix a reference count leak
      media: ti-vpe: Fix a missing check and reference count leak
      media: sti: Fix reference count leaks
      media: exynos4-is: Fix several reference count leaks due to pm_runtime_get_sync
      media: exynos4-is: Fix a reference count leak due to pm_runtime_get_sync
      media: exynos4-is: Fix a reference count leak

Ralph Campbell (1):
      mm/memcg: fix device private memcg accounting

Robert Hoo (1):
      KVM: x86: emulating RDPID failure shall return #UD rather than #GP

Roberto Sassu (1):
      ima: Don't ignore errors from crypto_shash_update()

Rohit kumar (2):
      ASoC: qcom: lpass-platform: fix memory leak
      ASoC: qcom: lpass-cpu: fix concurrency issue

Roman Bolshakov (1):
      scsi: target: core: Add CONTROL field for trace events

Rustam Kovhaev (1):
      ntfs: add check for mft record size in superblock

Samuel Holland (1):
      Bluetooth: hci_uart: Cancel init work before unregistering

Sean Christopherson (1):
      KVM: x86/mmu: Commit zap of remaining invalid pages when recovering lpages

Sherry Sun (2):
      mic: vop: copy data to kernel space then write to io memory
      misc: vop: add round_up(x,4) for vring_size to avoid kernel panic

Shyam Prasad N (1):
      cifs: Return the error from crypt_message when enc/dec key not found.

Souptick Joarder (3):
      drivers/virt/fsl_hypervisor: Fix error handling path
      misc: mic: scif: Fix error handling path
      rapidio: fix error handling path

Srikar Dronamraju (1):
      cpufreq: powernv: Fix frame-size-overflow in powernv_cpufreq_reboot_notifier

Stephan Gerhold (1):
      arm64: dts: qcom: msm8916: Fix MDP/DSI interrupts

Suravee Suthikulpanit (1):
      KVM: SVM: Initialize prev_ga_tag before use

Suren Baghdasaryan (1):
      mm, oom_adj: don't loop through tasks in __set_oom_adj when not necessary

Sylwester Nawrocki (1):
      media: Revert "media: exynos4-is: Add missed check for pinctrl_lookup_state()"

Takashi Iwai (1):
      ALSA: seq: oss: Avoid mutex lock for a long-time ioctl

Tero Kristo (1):
      crypto: omap-sham - fix digcnt register handling with export/import

Tetsuo Handa (1):
      mwifiex: don't call del_timer_sync() on uninitialized timer

Thomas Gleixner (1):
      net: enic: Cure the enic api locking trainwreck

Thomas Pedersen (1):
      mac80211: handle lack of sband->bitrates in rates

Thomas Preston (2):
      pinctrl: mcp23s08: Fix mcp23x17_regmap initialiser
      pinctrl: mcp23s08: Fix mcp23x17 precious range

Tianjia Zhang (2):
      crypto: mediatek - Fix wrong return value in mtk_desc_ring_alloc()
      scsi: csiostor: Fix wrong return value in csio_hw_prep_fw()

Tobias Jordan (1):
      lib/crc32.c: fix trivial typo in preprocessor condition

Todd Kjos (1):
      binder: fix UAF when releasing todo list

Tom Rix (7):
      media: tuner-simple: fix regression in simple_set_radio_freq
      media: m5mols: Check function pointer in m5mols_sensor_power
      media: tc358743: initialize variable
      brcmfmac: check ndev pointer
      drm/gma500: fix error check
      video: fbdev: sis: fix null ptr dereference
      mwifiex: fix double free

Tong Zhang (2):
      tty: serial: earlycon dependency
      tty: ipwireless: fix error handling

Tyrel Datwyler (1):
      tty: hvcs: Don't NULL tty->driver_data until hvcs_cleanup()

Valentin Vidic (2):
      net: korina: fix kfree of rx/tx descriptor array
      net: korina: cast KSEG0 address to pointer in kfree

Vasant Hegde (1):
      powerpc/powernv/dump: Fix race while processing OPAL dump

Venkateswara Naralasetty (1):
      ath10k: provide survey info as accumulated data

Vincent Mailhol (1):
      usb: cdc-acm: add quirk to blacklist ETAS ES58X devices

Wang Yufen (1):
      brcm80211: fix possible memleak in brcmf_proto_msgbuf_attach

Wilken Gottwalt (1):
      net: usb: qmi_wwan: add Cellient MPL200 card

Xiaoliang Pang (1):
      cypto: mediatek - fix leaks in mtk_desc_ring_alloc

Xiaolong Huang (1):
      media: media/pci: prevent memory leak in bttv_probe

Xiaoyang Xu (1):
      vfio iommu type1: Fix memory leak in vfio_iommu_type1_pin_pages

Xie He (2):
      net: hdlc: In hdlc_rcv, check to make sure dev is an HDLC device
      net: hdlc_raw_eth: Clear the IFF_TX_SKB_SHARING flag after calling ether_setup

YueHaibing (1):
      Input: stmfts - fix a & vs && typo

Zekun Shen (1):
      ath10k: check idx validity in __ath10k_htt_rx_ring_fill_n()

Zqiang (1):
      usb: gadget: function: printer: fix use-after-free in __lock_acquire

dinghao.liu@zju.edu.cn (1):
      backlight: sky81452-backlight: Fix refcount imbalance on error

zhenwei pi (1):
      nvmet: fix uninitialized work for zero kato

