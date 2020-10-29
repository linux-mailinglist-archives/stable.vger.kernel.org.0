Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1300E29E938
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 11:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgJ2KnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 06:43:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgJ2KnE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 06:43:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B0ED20731;
        Thu, 29 Oct 2020 10:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603968171;
        bh=YMDHy+VZujo6YW/b+r0f0KL9g73yHw0OBFFrNln3P54=;
        h=From:To:Cc:Subject:Date:From;
        b=HAe4zrAoMhDyWyOnLFSwn7LUqzJyMHDOhSLFLaZ27BuZ5MyG8TQ0nTkuvUGk56gMH
         60+n9RqLoEaKqgIUUidSryDBZYeoPGv/bED+oRMipgaV+fAIg3+WKpcwYNCuRUNPpi
         uKLRzPQZzTmn+1Qja74CpsMK+LEhLDs9whgQMD60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.153
Date:   Thu, 29 Oct 2020 11:43:40 +0100
Message-Id: <160396822019115@kroah.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.153 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt         |    2 
 Documentation/networking/ip-sysctl.txt                  |    4 
 Makefile                                                |    2 
 arch/arc/plat-hsdk/Kconfig                              |    1 
 arch/arm/mm/cache-l2x0.c                                |   16 
 arch/powerpc/include/asm/drmem.h                        |   18 -
 arch/powerpc/include/asm/reg.h                          |    2 
 arch/powerpc/kernel/tau_6xx.c                           |   55 +--
 arch/powerpc/platforms/pseries/rng.c                    |    1 
 arch/powerpc/sysdev/xics/icp-hv.c                       |    1 
 arch/x86/events/amd/iommu.c                             |    2 
 arch/x86/kernel/fpu/init.c                              |   30 +
 arch/x86/kernel/nmi.c                                   |    5 
 arch/x86/kvm/mmu.c                                      |    1 
 arch/x86/kvm/svm.c                                      |    1 
 crypto/algif_aead.c                                     |    7 
 crypto/algif_skcipher.c                                 |    2 
 drivers/android/binder.c                                |   35 --
 drivers/bluetooth/hci_ldisc.c                           |    1 
 drivers/bluetooth/hci_serdev.c                          |    2 
 drivers/cpufreq/armada-37xx-cpufreq.c                   |    6 
 drivers/crypto/chelsio/chtls/chtls_cm.c                 |    3 
 drivers/crypto/chelsio/chtls/chtls_io.c                 |    5 
 drivers/crypto/ixp4xx_crypto.c                          |    2 
 drivers/crypto/mediatek/mtk-platform.c                  |    8 
 drivers/crypto/omap-sham.c                              |    3 
 drivers/crypto/picoxcell_crypto.c                       |    9 
 drivers/edac/i5100_edac.c                               |   11 
 drivers/edac/ti_edac.c                                  |    3 
 drivers/gpu/drm/gma500/cdv_intel_dp.c                   |    2 
 drivers/hid/hid-input.c                                 |    4 
 drivers/hid/hid-roccat-kone.c                           |   23 -
 drivers/hwmon/pmbus/max34440.c                          |    3 
 drivers/infiniband/core/ucma.c                          |    6 
 drivers/infiniband/hw/mlx4/cm.c                         |    3 
 drivers/infiniband/hw/mlx4/mad.c                        |   34 +
 drivers/infiniband/hw/mlx4/mlx4_ib.h                    |    2 
 drivers/infiniband/hw/qedr/main.c                       |    2 
 drivers/infiniband/hw/qedr/verbs.c                      |    2 
 drivers/media/i2c/m5mols/m5mols_core.c                  |    3 
 drivers/media/i2c/tc358743.c                            |   14 
 drivers/media/platform/exynos4-is/media-dev.c           |    4 
 drivers/media/platform/mx2_emmaprp.c                    |    7 
 drivers/media/platform/omap3isp/isp.c                   |    6 
 drivers/media/platform/qcom/camss/camss-csiphy.c        |    4 
 drivers/media/platform/rcar-fcp.c                       |    4 
 drivers/media/platform/rcar-vin/rcar-dma.c              |    4 
 drivers/media/platform/rockchip/rga/rga-buf.c           |    1 
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c             |    4 
 drivers/media/platform/stm32/stm32-dcmi.c               |    4 
 drivers/media/platform/ti-vpe/vpe.c                     |    2 
 drivers/media/tuners/tuner-simple.c                     |    5 
 drivers/media/usb/uvc/uvc_ctrl.c                        |    6 
 drivers/media/usb/uvc/uvc_entity.c                      |   35 ++
 drivers/mfd/sm501.c                                     |    8 
 drivers/misc/mic/scif/scif_rma.c                        |    4 
 drivers/misc/vmw_vmci/vmci_queue_pair.c                 |   10 
 drivers/mtd/lpddr/lpddr2_nvm.c                          |   35 +-
 drivers/mtd/mtdoops.c                                   |   11 
 drivers/net/dsa/realtek-smi.h                           |    4 
 drivers/net/dsa/rtl8366.c                               |  280 ++++++++--------
 drivers/net/dsa/rtl8366rb.c                             |    2 
 drivers/net/ethernet/cisco/enic/enic.h                  |    1 
 drivers/net/ethernet/cisco/enic/enic_api.c              |    6 
 drivers/net/ethernet/cisco/enic/enic_main.c             |   27 +
 drivers/net/ethernet/freescale/fec_main.c               |   35 +-
 drivers/net/ethernet/ibm/ibmveth.c                      |   19 -
 drivers/net/ethernet/korina.c                           |    3 
 drivers/net/ethernet/mellanox/mlx4/en_rx.c              |    3 
 drivers/net/ethernet/mellanox/mlx4/en_tx.c              |    2 
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c     |    5 
 drivers/net/ethernet/realtek/r8169.c                    |   54 +--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       |   33 -
 drivers/net/usb/qmi_wwan.c                              |    1 
 drivers/net/wan/hdlc.c                                  |   10 
 drivers/net/wan/hdlc_raw_eth.c                          |    1 
 drivers/net/wireless/ath/ath10k/ce.c                    |    2 
 drivers/net/wireless/ath/ath10k/mac.c                   |    2 
 drivers/net/wireless/ath/ath6kl/main.c                  |    3 
 drivers/net/wireless/ath/ath6kl/wmi.c                   |    5 
 drivers/net/wireless/ath/ath9k/htc_hst.c                |    2 
 drivers/net/wireless/ath/wcn36xx/main.c                 |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c |    2 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c       |    9 
 drivers/net/wireless/marvell/mwifiex/scan.c             |    2 
 drivers/net/wireless/marvell/mwifiex/sdio.c             |    2 
 drivers/net/wireless/quantenna/qtnfmac/commands.c       |    2 
 drivers/perf/xgene_pmu.c                                |   32 -
 drivers/pinctrl/bcm/Kconfig                             |    1 
 drivers/pinctrl/pinctrl-mcp23s08.c                      |   24 -
 drivers/platform/x86/mlx-platform.c                     |   15 
 drivers/pwm/pwm-lpss.c                                  |    7 
 drivers/regulator/core.c                                |   21 -
 drivers/scsi/be2iscsi/be_main.c                         |    4 
 drivers/scsi/csiostor/csio_hw.c                         |    2 
 drivers/scsi/qla2xxx/qla_nvme.c                         |    2 
 drivers/scsi/qla4xxx/ql4_os.c                           |    2 
 drivers/slimbus/core.c                                  |    6 
 drivers/slimbus/qcom-ngd-ctrl.c                         |    4 
 drivers/spi/spi-s3c64xx.c                               |   52 ++
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c       |    2 
 drivers/target/target_core_user.c                       |    2 
 drivers/tty/hvc/hvcs.c                                  |   14 
 drivers/tty/pty.c                                       |    2 
 drivers/tty/serial/Kconfig                              |    1 
 drivers/usb/dwc2/gadget.c                               |   40 +-
 drivers/usb/dwc2/params.c                               |    2 
 drivers/usb/gadget/function/f_ncm.c                     |    6 
 drivers/usb/gadget/function/u_ether.c                   |    2 
 drivers/video/backlight/sky81452-backlight.c            |    1 
 drivers/video/fbdev/aty/radeon_base.c                   |    2 
 drivers/video/fbdev/sis/init.c                          |   11 
 drivers/video/fbdev/vga16fb.c                           |   14 
 drivers/virt/fsl_hypervisor.c                           |   17 
 fs/cifs/asn1.c                                          |   16 
 fs/cifs/smb2ops.c                                       |    2 
 fs/proc/base.c                                          |    3 
 fs/quota/quota_v2.c                                     |    1 
 fs/xfs/libxfs/xfs_rtbitmap.c                            |   11 
 fs/xfs/xfs_fsmap.c                                      |    3 
 include/linux/oom.h                                     |    1 
 include/linux/sched/coredump.h                          |    1 
 include/net/ip.h                                        |    6 
 include/net/netfilter/nf_log.h                          |    1 
 kernel/fork.c                                           |   21 +
 mm/memcontrol.c                                         |    5 
 mm/oom_kill.c                                           |    2 
 net/ipv4/icmp.c                                         |    7 
 net/ipv4/netfilter/nf_log_arp.c                         |   19 -
 net/ipv4/netfilter/nf_log_ipv4.c                        |    6 
 net/ipv4/route.c                                        |    4 
 net/ipv4/tcp_input.c                                    |    2 
 net/ipv6/ip6_fib.c                                      |    4 
 net/ipv6/netfilter/nf_log_ipv6.c                        |    8 
 net/netfilter/ipvs/ip_vs_xmit.c                         |    6 
 net/netfilter/nf_log_common.c                           |   12 
 net/nfc/netlink.c                                       |    2 
 net/sched/act_tunnel_key.c                              |    2 
 net/smc/smc_core.c                                      |    2 
 net/tipc/msg.c                                          |    3 
 net/tls/tls_device.c                                    |   11 
 net/wireless/nl80211.c                                  |    5 
 security/integrity/ima/ima_crypto.c                     |    2 
 sound/core/seq/oss/seq_oss.c                            |    7 
 sound/firewire/bebob/bebob_hwdep.c                      |    3 
 sound/pci/hda/patch_realtek.c                           |   42 ++
 sound/soc/qcom/lpass-cpu.c                              |   16 
 sound/soc/qcom/lpass-platform.c                         |    3 
 148 files changed, 970 insertions(+), 566 deletions(-)

Alex Dewar (1):
      VMCI: check return value of get_user_pages_fast() for errors

Arnd Bergmann (1):
      mtd: lpddr: fix excessive stack usage with clang

Artem Savkov (1):
      pty: do tty_flip_buffer_push without port->lock in pty_write

Arvind Sankar (1):
      x86/fpu: Allow multiple bits in clearcpuid= parameter

Bryan O'Donoghue (1):
      wcn36xx: Fix reported 802.11n rx_highest rate wcn3660/wcn3680

Christophe JAILLET (5):
      crypto: ixp4xx - Fix the size used in a 'dma_free_coherent()' call
      ath10k: Fix the size used in a 'dma_free_coherent()' call in an error handling path
      mwifiex: Do not use GFP_KERNEL in atomic context
      staging: rtl8192u: Do not use GFP_KERNEL in atomic context
      scsi: qla4xxx: Fix an error handling path in 'qla4xxx_get_host_stats()'

Colin Ian King (3):
      x86/events/amd/iommu: Fix sizeof mismatch
      video: fbdev: vga16fb: fix setting of pixclock because a pass-by-value error
      qtnfmac: fix resource leaks on unsupported iftype error return path

Cong Wang (1):
      tipc: fix the skb_unshare() in tipc_buf_append()

Dan Carpenter (8):
      ALSA: bebob: potential info leak in hwdep_read()
      cifs: remove bogus debug code
      ath6kl: prevent potential array overflow in ath6kl_add_new_sta()
      ath9k: Fix potential out of bounds in ath9k_htc_txcompletion_cb()
      HID: roccat: add bounds checking in kone_sysfs_write_settings()
      ath6kl: wmi: prevent a shift wrapping bug in ath6kl_wmi_delete_pstream_cmd()
      mfd: sm501: Fix leaks in probe()
      scsi: be2iscsi: Fix a theoretical leak in beiscsi_create_eqs()

Darrick J. Wong (2):
      xfs: limit entries returned when counting fsmap records
      xfs: fix high key handling in the rt allocator's query_range function

David Ahern (1):
      ipv4: Restore flowi4_oif update before call to xfrm_lookup_route

David Wilder (2):
      ibmveth: Switch order of ibmveth_helper calls.
      ibmveth: Identify ingress large send packets.

Davide Caratti (1):
      net/sched: act_tunnel_key: fix OOB write in case of IPv6 ERSPAN tunnels

Defang Bo (1):
      nfc: Ensure presence of NFC_ATTR_FIRMWARE_NAME attribute in nfc_genl_fw_download()

Dinghao Liu (4):
      EDAC/i5100: Fix error handling order in i5100_init_one()
      media: omap3isp: Fix memleak in isp_probe
      media: mx2_emmaprp: Fix memleak in emmaprp_probe
      video: fbdev: radeon: Fix memleak in radeonfb_pci_register

Dmitry Torokhov (1):
      HID: hid-input: fix stylus battery reporting

Emmanuel Grumbach (1):
      iwlwifi: mvm: split a print to avoid a WARNING in ROC

Eran Ben Elisha (1):
      net/mlx5: Don't call timecounter cyc2time directly from 1PPS flow

Eric Dumazet (2):
      icmp: randomize the global rate limiter
      quota: clear padding in v2r1_mem2diskdqb()

Finn Thain (3):
      powerpc/tau: Use appropriate temperature sample interval
      powerpc/tau: Convert from timer to workqueue
      powerpc/tau: Remove duplicated set_thresholds() call

Greg Kroah-Hartman (1):
      Linux 4.19.153

Guenter Roeck (1):
      hwmon: (pmbus/max34440) Fix status register reads for MAX344{51,60,61}

Guillaume Tucker (1):
      ARM: 9007/1: l2c: fix prefetch bits init in L2X0_AUX_CTRL using DT values

Hans de Goede (2):
      pwm: lpss: Fix off by one error in base_unit math in pwm_lpss_prepare()
      pwm: lpss: Add range limit check for the base_unit register value

Heiner Kallweit (2):
      r8169: fix data corruption issue on RTL8402
      r8169: fix operation under forced interrupt threading

Herbert Xu (2):
      crypto: algif_aead - Do not set MAY_BACKLOG on the async path
      crypto: algif_skcipher - EBUSY on aio should be an error

Håkon Bugge (2):
      IB/mlx4: Fix starvation in paravirt mux/demux
      IB/mlx4: Adjust delayed work when a dup is observed

Jason Gunthorpe (2):
      RDMA/ucma: Fix locking for ctx->events_reported
      RDMA/ucma: Add missing locking around rdma_leave_multicast()

Jian-Hong Pan (1):
      ALSA: hda/realtek: Enable audio jacks of ASUS D700SA with ALC887

Johannes Berg (1):
      nl80211: fix non-split wiphy information

John Donnelly (1):
      scsi: target: tcmu: Fix warning: 'page' may be used uninitialized

Jonathan Lemon (1):
      mlx4: handle non-napi callers to napi_poll

Julian Anastasov (1):
      ipvs: clear skb->tstamp in forwarding path

Karsten Graul (1):
      net/smc: fix valid DMBE buffer sizes

Krzysztof Kozlowski (1):
      EDAC/ti: Fix handling of platform_get_irq() error

Laurent Pinchart (2):
      media: uvcvideo: Set media controller entity functions
      media: uvcvideo: Silence shift-out-of-bounds warning

Libing Zhou (1):
      x86/nmi: Fix nmi_handle() duration miscalculation

Linus Walleij (4):
      net: dsa: rtl8366: Check validity of passed VLANs
      net: dsa: rtl8366: Refactor VLAN/PVID init
      net: dsa: rtl8366: Skip PVID setting if not requested
      net: dsa: rtl8366rb: Support all 4096 VLANs

Lorenzo Colitti (2):
      usb: gadget: f_ncm: fix ncm_bitrate for SuperSpeed and above.
      usb: gadget: u_ether: enable qmult on SuperSpeed Plus as well

Maciej Żenczykowski (1):
      net/ipv4: always honour route mtu during forwarding

Madhuparna Bhowmik (1):
      crypto: picoxcell - Fix potential race condition bug

Marek Vasut (2):
      net: fec: Fix phy_device lookup for phy_reset_after_clk_enable()
      net: fec: Fix PHY init after phy_reset_after_clk_enable()

Mark Salter (1):
      drivers/perf: xgene_pmu: Fix uninitialized resource struct

Mark Tomlinson (1):
      mtd: mtdoops: Don't write panic data twice

Michal Kalderon (2):
      RDMA/qedr: Fix use of uninitialized field
      RDMA/qedr: Fix inline size returned for iWARP

Michał Mirosław (1):
      regulator: resolve supply after creating regulator

Minas Harutyunyan (1):
      usb: dwc2: Fix INTR OUT transfers in DDMA mode.

Nathan Chancellor (1):
      usb: dwc2: Fix parameter type in function pointer prototype

Nathan Lynch (1):
      powerpc/pseries: explicitly reschedule during drmem_lmb list traversal

Neal Cardwell (1):
      tcp: fix to update snd_wl1 in bulk receiver fast path

Necip Fazil Yildiran (2):
      pinctrl: bcm: fix kconfig dependency warning when !GPIOLIB
      arc: plat-hsdk: fix kconfig dependency warning when !RESET_CONTROLLER

Nicholas Mc Guire (2):
      powerpc/pseries: Fix missing of_node_put() in rng_init()
      powerpc/icp-hv: Fix missing of_node_put() in success path

Ong Boon Leong (1):
      net: stmmac: use netif_tx_start|stop_all_queues() function

Pablo Neira Ayuso (1):
      netfilter: nf_log: missing vlan offload tag and proto

Pali Rohár (1):
      cpufreq: armada-37xx: Add missing MODULE_DEVICE_TABLE

Qiushi Wu (7):
      media: rcar-vin: Fix a reference count leak.
      media: rockchip/rga: Fix a reference count leak.
      media: platform: fcp: Fix a reference count leak.
      media: camss: Fix a reference count leak.
      media: s5p-mfc: Fix a reference count leak
      media: stm32-dcmi: Fix a reference count leak
      media: ti-vpe: Fix a missing check and reference count leak

Ralph Campbell (1):
      mm/memcg: fix device private memcg accounting

Roberto Sassu (1):
      ima: Don't ignore errors from crypto_shash_update()

Rohit Maheshwari (1):
      net/tls: sendfile fails with ktls offload

Rohit kumar (2):
      ASoC: qcom: lpass-platform: fix memory leak
      ASoC: qcom: lpass-cpu: fix concurrency issue

Samuel Holland (1):
      Bluetooth: hci_uart: Cancel init work before unregistering

Sean Christopherson (1):
      KVM: x86/mmu: Commit zap of remaining invalid pages when recovering lpages

Shyam Prasad N (1):
      cifs: Return the error from crypt_message when enc/dec key not found.

Souptick Joarder (2):
      drivers/virt/fsl_hypervisor: Fix error handling path
      misc: mic: scif: Fix error handling path

Srinivas Kandagatla (3):
      slimbus: core: check get_addr before removing laddr ida
      slimbus: core: do not enter to clock pause mode in core
      slimbus: qcom-ngd-ctrl: disable ngd in qmi server down callback

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

Thomas Gleixner (1):
      net: enic: Cure the enic api locking trainwreck

Thomas Preston (2):
      pinctrl: mcp23s08: Fix mcp23x17_regmap initialiser
      pinctrl: mcp23s08: Fix mcp23x17 precious range

Tianjia Zhang (3):
      crypto: mediatek - Fix wrong return value in mtk_desc_ring_alloc()
      scsi: qla2xxx: Fix wrong return value in qla_nvme_register_hba()
      scsi: csiostor: Fix wrong return value in csio_hw_prep_fw()

Todd Kjos (1):
      binder: fix UAF when releasing todo list

Tom Rix (8):
      media: tuner-simple: fix regression in simple_set_radio_freq
      media: m5mols: Check function pointer in m5mols_sensor_power
      media: tc358743: initialize variable
      media: tc358743: cleanup tc358743_cec_isr
      brcmfmac: check ndev pointer
      drm/gma500: fix error check
      video: fbdev: sis: fix null ptr dereference
      mwifiex: fix double free

Tong Zhang (1):
      tty: serial: earlycon dependency

Tyrel Datwyler (1):
      tty: hvcs: Don't NULL tty->driver_data until hvcs_cleanup()

Vadim Pasternak (1):
      platform/x86: mlx-platform: Remove PSU EEPROM configuration

Valentin Vidic (1):
      net: korina: fix kfree of rx/tx descriptor array

Venkateswara Naralasetty (1):
      ath10k: provide survey info as accumulated data

Vinay Kumar Yadav (3):
      chelsio/chtls: fix socket lock
      chelsio/chtls: correct netdevice for vlan interface
      chelsio/chtls: correct function return and return type

Wilken Gottwalt (1):
      net: usb: qmi_wwan: add Cellient MPL200 card

Xiaoliang Pang (1):
      cypto: mediatek - fix leaks in mtk_desc_ring_alloc

Xie He (2):
      net: hdlc: In hdlc_rcv, check to make sure dev is an HDLC device
      net: hdlc_raw_eth: Clear the IFF_TX_SKB_SHARING flag after calling ether_setup

Yonghong Song (1):
      net: fix pos incrementment in ipv6_route_seq_next

dinghao.liu@zju.edu.cn (1):
      backlight: sky81452-backlight: Fix refcount imbalance on error

Łukasz Stelmach (2):
      spi: spi-s3c64xx: swap s3c64xx_spi_set_cs() and s3c64xx_enable_datapath()
      spi: spi-s3c64xx: Check return values

