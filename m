Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE6112DA8C
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 18:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfLaRYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 12:24:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:55898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbfLaRY3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Dec 2019 12:24:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 765DF206DB;
        Tue, 31 Dec 2019 17:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577813068;
        bh=BxiRm41jzoBv7VaVacS0W3K45Y8gsw86W7t+ZK5tNXs=;
        h=Date:From:To:Cc:Subject:From;
        b=0A7FBv4rdmDmpG4TOz+2jdKrx6IG8b2Kg49llDIEePSxYZYWuMARhcwIOL/FqFBgF
         IREYFGLJ4Pf24qIfWzxJljam6csUTGlybA2WV1a2h8b7/S53jZc/G3NRGgW0Nfdi9Q
         3VHJTwPqqouVR1m3tAabb+4sBlOkSI2cYWd3b/GM=
Date:   Tue, 31 Dec 2019 18:24:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.92
Message-ID: <20191231172425.GA2374203@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.92 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                     |    2=20
 arch/arm64/kernel/psci.c                                     |   15 +-
 arch/arm64/kvm/sys_regs.c                                    |    5=20
 arch/mips/include/asm/pgtable-64.h                           |    9 -
 arch/powerpc/include/asm/spinlock.h                          |    4=20
 arch/powerpc/kernel/irq.c                                    |    4=20
 arch/powerpc/platforms/pseries/setup.c                       |    7=20
 arch/s390/include/asm/pgalloc.h                              |   16 +-
 arch/s390/include/asm/timex.h                                |   16 +-
 arch/s390/kernel/dis.c                                       |   13 -
 arch/sh/include/cpu-sh4/cpu/sh7734.h                         |    2=20
 arch/x86/include/asm/crash.h                                 |    2=20
 arch/x86/include/asm/fixmap.h                                |    2=20
 arch/x86/include/asm/syscall_wrapper.h                       |   23 +--
 arch/x86/kernel/apic/io_apic.c                               |    9 -
 arch/x86/kernel/cpu/mcheck/mce_amd.c                         |    4=20
 arch/x86/kernel/cpu/mcheck/therm_throt.c                     |    2=20
 arch/x86/lib/x86-opcode-map.txt                              |   18 +-
 arch/x86/mm/pgtable.c                                        |    4=20
 drivers/acpi/button.c                                        |   11 +
 drivers/ata/libata-core.c                                    |    3=20
 drivers/block/loop.c                                         |   26 ++-
 drivers/block/nbd.c                                          |    6=20
 drivers/char/hw_random/omap3-rom-rng.c                       |    3=20
 drivers/char/ipmi/ipmi_msghandler.c                          |   23 ++-
 drivers/cpufreq/cpufreq.c                                    |    7=20
 drivers/crypto/atmel-aes.c                                   |   18 +-
 drivers/crypto/atmel-authenc.h                               |    2=20
 drivers/crypto/atmel-sha.c                                   |    2=20
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c                    |   22 +--
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c                      |   12 -
 drivers/crypto/virtio/virtio_crypto_algs.c                   |   12 +
 drivers/crypto/vmx/Makefile                                  |    6=20
 drivers/edac/ghes_edac.c                                     |   10 +
 drivers/extcon/extcon-sm5502.c                               |    4=20
 drivers/extcon/extcon-sm5502.h                               |    2=20
 drivers/fsi/fsi-core.c                                       |   31 +++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_test.c                     |    2=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c                       |   12 +
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                        |    3=20
 drivers/gpu/drm/amd/amdgpu/si_ih.c                           |    3=20
 drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c                   |    5=20
 drivers/gpu/drm/amd/display/dc/core/dc_link.c                |    2=20
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c             |    1=20
 drivers/gpu/drm/bridge/analogix-anx78xx.c                    |    8 -
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c                    |   12 +
 drivers/gpu/drm/drm_vblank.c                                 |    6=20
 drivers/gpu/drm/gma500/oaktrail_crtc.c                       |    2=20
 drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c        |    1=20
 drivers/gpu/drm/panel/panel-sitronix-st7789v.c               |    1=20
 drivers/gpu/drm/tegra/sor.c                                  |    5=20
 drivers/gpu/host1x/job.c                                     |   11 -
 drivers/hwtracing/intel_th/pci.c                             |   10 +
 drivers/iio/adc/dln2-adc.c                                   |   20 +-
 drivers/iio/adc/max1027.c                                    |    8 +
 drivers/iio/dac/Kconfig                                      |    4=20
 drivers/iio/dac/ad5446.c                                     |    6=20
 drivers/iio/light/bh1750.c                                   |    4=20
 drivers/infiniband/hw/qedr/verbs.c                           |   12 +
 drivers/infiniband/ulp/iser/iscsi_iser.c                     |    1=20
 drivers/md/bcache/alloc.c                                    |    5=20
 drivers/md/bcache/bcache.h                                   |    2=20
 drivers/md/bcache/super.c                                    |   51 +++++--
 drivers/md/md-bitmap.c                                       |    2=20
 drivers/media/i2c/ov2659.c                                   |   18 +-
 drivers/media/i2c/ov6650.c                                   |   42 +++--
 drivers/media/i2c/smiapp/smiapp-core.c                       |   12 +
 drivers/media/pci/cx88/cx88-video.c                          |   11 -
 drivers/media/platform/am437x/am437x-vpfe.c                  |    4=20
 drivers/media/platform/qcom/venus/core.c                     |    9 -
 drivers/media/platform/qcom/venus/hfi_venus.c                |    6=20
 drivers/media/platform/rcar_drif.c                           |    1=20
 drivers/media/platform/ti-vpe/vpdma.h                        |    1=20
 drivers/media/platform/ti-vpe/vpe.c                          |   52 +++++--
 drivers/media/radio/si470x/radio-si470x-i2c.c                |    2=20
 drivers/media/usb/b2c2/flexcop-usb.c                         |    8 -
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c                     |    9 -
 drivers/media/v4l2-core/v4l2-ioctl.c                         |   33 ++--
 drivers/mmc/host/mtk-sd.c                                    |    2=20
 drivers/mmc/host/sdhci-msm.c                                 |   28 ++-
 drivers/mmc/host/sdhci-of-esdhc.c                            |    7=20
 drivers/mmc/host/sdhci-pci-core.c                            |   10 +
 drivers/mmc/host/sdhci.c                                     |   11 -
 drivers/mmc/host/sdhci.h                                     |    2=20
 drivers/mmc/host/tmio_mmc_core.c                             |    2=20
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c             |    6=20
 drivers/net/dsa/Kconfig                                      |    1=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c            |   16 +-
 drivers/net/ethernet/cortina/gemini.c                        |    2=20
 drivers/net/ethernet/hisilicon/hip04_eth.c                   |    2=20
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c              |    3=20
 drivers/net/ethernet/intel/i40e/i40e_main.c                  |   10 -
 drivers/net/ethernet/intel/ice/ice_controlq.c                |    2=20
 drivers/net/ethernet/intel/ice/ice_controlq.h                |    5=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                |    3=20
 drivers/net/ethernet/qlogic/qede/qede_filter.c               |    2=20
 drivers/net/ethernet/qlogic/qede/qede_main.c                 |    4=20
 drivers/net/ethernet/qlogic/qla3xxx.c                        |    8 -
 drivers/net/ethernet/ti/cpsw_ale.c                           |    2=20
 drivers/net/fjes/fjes_main.c                                 |    3=20
 drivers/net/phy/dp83867.c                                    |   15 +-
 drivers/net/phy/phy_device.c                                 |    4=20
 drivers/net/tun.c                                            |    4=20
 drivers/net/usb/lan78xx.c                                    |    1=20
 drivers/net/wireless/ath/ath10k/coredump.c                   |   11 +
 drivers/net/wireless/ath/ath10k/mac.c                        |   26 +--
 drivers/net/wireless/ath/ath10k/txrx.c                       |    2=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c      |    5=20
 drivers/net/wireless/intel/iwlwifi/dvm/led.c                 |    3=20
 drivers/net/wireless/intel/iwlwifi/mvm/led.c                 |    3=20
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c                  |    3=20
 drivers/net/wireless/marvell/libertas/if_sdio.c              |    5=20
 drivers/net/wireless/marvell/mwifiex/pcie.c                  |    5=20
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h             |    1=20
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c       |    1=20
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c        |    3=20
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c          |    2=20
 drivers/net/wireless/realtek/rtlwifi/usb.c                   |    5=20
 drivers/nvme/host/core.c                                     |   12 +
 drivers/nvmem/imx-ocotp.c                                    |    4=20
 drivers/parport/share.c                                      |   21 ++
 drivers/phy/qualcomm/phy-qcom-usb-hs.c                       |    7=20
 drivers/pinctrl/devicetree.c                                 |   25 ++-
 drivers/pinctrl/pinctrl-amd.c                                |    3=20
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                          |    4=20
 drivers/platform/x86/hp-wmi.c                                |    2=20
 drivers/regulator/max8907-regulator.c                        |   15 +-
 drivers/soundwire/intel.c                                    |   10 +
 drivers/spi/spi-img-spfi.c                                   |    2=20
 drivers/spi/spi-pxa2xx.c                                     |    6=20
 drivers/spi/spi-sprd-adi.c                                   |    3=20
 drivers/spi/spi-st-ssc4.c                                    |    3=20
 drivers/spi/spi-tegra20-slink.c                              |    5=20
 drivers/spi/spidev.c                                         |    3=20
 drivers/staging/comedi/drivers/gsc_hpdi.c                    |   10 +
 drivers/staging/fbtft/fbtft-core.c                           |    2=20
 drivers/staging/rtl8188eu/core/rtw_xmit.c                    |    4=20
 drivers/staging/rtl8192u/r8192U_core.c                       |   17 +-
 drivers/usb/core/devio.c                                     |   15 +-
 drivers/usb/host/ehci-q.c                                    |   13 +
 drivers/usb/host/xhci-pci.c                                  |    2=20
 drivers/usb/renesas_usbhs/common.h                           |    3=20
 drivers/usb/renesas_usbhs/mod_gadget.c                       |   12 +
 drivers/usb/usbip/usbip_common.c                             |    3=20
 drivers/usb/usbip/vhci_rx.c                                  |   13 +
 drivers/xen/Kconfig                                          |    3=20
 fs/btrfs/async-thread.c                                      |   56 ++++++-
 fs/btrfs/ctree.c                                             |    2=20
 fs/btrfs/ctree.h                                             |    2=20
 fs/btrfs/disk-io.c                                           |    2=20
 fs/btrfs/extent-tree.c                                       |    7=20
 fs/btrfs/extent_io.c                                         |    6=20
 fs/btrfs/file-item.c                                         |    7=20
 fs/btrfs/inode.c                                             |   12 -
 fs/btrfs/ioctl.c                                             |   10 +
 fs/btrfs/reada.c                                             |   10 -
 fs/btrfs/relocation.c                                        |    1=20
 fs/btrfs/scrub.c                                             |    3=20
 fs/btrfs/send.c                                              |    6=20
 fs/btrfs/tests/free-space-tree-tests.c                       |    4=20
 fs/btrfs/tests/qgroup-tests.c                                |    4=20
 fs/btrfs/tree-log.c                                          |   52 ++++++-
 fs/btrfs/uuid-tree.c                                         |    2=20
 fs/ext4/dir.c                                                |    5=20
 fs/ext4/inode.c                                              |    4=20
 fs/ext4/namei.c                                              |   32 ++--
 include/drm/drm_dp_mst_helper.h                              |    2=20
 include/linux/cpufreq.h                                      |   11 -
 include/linux/ipmi_smi.h                                     |   12 +
 include/linux/miscdevice.h                                   |    1=20
 include/linux/mod_devicetable.h                              |    4=20
 include/linux/sched/cpufreq.h                                |    3=20
 include/net/dst.h                                            |    2=20
 include/trace/events/wbt.h                                   |   12 +
 include/uapi/linux/cec-funcs.h                               |    6=20
 kernel/bpf/stackmap.c                                        |    7=20
 kernel/sched/cpufreq.c                                       |   18 ++
 kernel/sched/cpufreq_schedutil.c                             |    8 -
 kernel/trace/trace.c                                         |    2=20
 kernel/trace/trace_kprobe.c                                  |   27 +++
 net/bluetooth/hci_conn.c                                     |    8 +
 net/bluetooth/hci_core.c                                     |   13 +
 net/bluetooth/hci_request.c                                  |    9 +
 net/mac80211/status.c                                        |    3=20
 net/nfc/nci/uart.c                                           |    2=20
 net/packet/af_packet.c                                       |    3=20
 net/rfkill/core.c                                            |    9 -
 net/sctp/protocol.c                                          |    5=20
 samples/pktgen/functions.sh                                  |   17 +-
 sound/core/pcm_native.c                                      |    4=20
 sound/core/timer.c                                           |   10 +
 sound/pci/hda/patch_ca0132.c                                 |   23 ++-
 sound/soc/codecs/rt5677.c                                    |    1=20
 sound/soc/codecs/wm2200.c                                    |    5=20
 sound/soc/codecs/wm5100.c                                    |    2=20
 sound/soc/codecs/wm8904.c                                    |    1=20
 sound/soc/intel/boards/bytcr_rt5640.c                        |   10 -
 sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c          |    3=20
 tools/lib/bpf/libbpf.c                                       |   14 +
 tools/lib/subcmd/Makefile                                    |    4=20
 tools/lib/traceevent/parse-filter.c                          |    9 -
 tools/objtool/arch/x86/lib/x86-opcode-map.txt                |   18 +-
 tools/perf/builtin-report.c                                  |    7=20
 tools/perf/pmu-events/jevents.c                              |   13 +
 tools/perf/tests/bp_signal.c                                 |   15 --
 tools/perf/tests/task-exit.c                                 |    1=20
 tools/perf/util/dwarf-aux.c                                  |   80 ++++++=
+++--
 tools/perf/util/dwarf-aux.h                                  |    3=20
 tools/perf/util/parse-events.c                               |   26 ++-
 tools/perf/util/probe-finder.c                               |   45 +++++-
 tools/power/cpupower/utils/idle_monitor/hsw_ext_idle.c       |    1=20
 tools/testing/selftests/bpf/cgroup_helpers.c                 |    2=20
 tools/testing/selftests/net/forwarding/router_bridge_vlan.sh |    2=20
 213 files changed, 1407 insertions(+), 519 deletions(-)

Adrian Hunter (3):
      x86/insn: Add some Intel instructions to the opcode map
      mmc: sdhci: Workaround broken command queuing on Intel GLK
      mmc: sdhci: Add a quirk for broken command queuing

Alexander Shishkin (2):
      intel_th: pci: Add Comet Lake PCH-V support
      intel_th: pci: Add Elkhart Lake SOC support

Alexandru Ardelean (1):
      iio: dln2-adc: fix iio_triggered_buffer_postenable() position

Allen Pais (2):
      libertas: fix a potential NULL pointer dereference
      drm/amdkfd: fix a potential NULL pointer dereference (v2)

Anand Jain (1):
      btrfs: send: remove WARN_ON for readonly mount

Andrea Righi (1):
      bcache: fix deadlock in bcache_allocator

Andrew Jeffery (1):
      fsi: core: Fix small accesses and unaligned offsets via sysfs

Andy Shevchenko (1):
      fbtft: Make sure string is NULL terminated

Anilkumar Kolli (1):
      ath10k: fix backtrace on coredump

Ard Biesheuvel (1):
      crypto: virtio - deal with unsupported input sizes

Bart Van Assche (1):
      block: Fix writeback throttling W=3D1 compiler warnings

Ben Dooks (Codethink) (2):
      Bluetooth: missed cpu_to_le16 conversion in hci_init4_req
      pinctrl: amd: fix __iomem annotation in amd_gpio_irq_handler()

Ben Greear (1):
      ath10k: fix offchannel tx failure when no ath10k_mac_tx_frm_has_freq

Ben Hutchings (1):
      net: qlogic: Fix error paths in ql_alloc_large_buffers()

Ben Zhang (1):
      ASoC: rt5677: Mark reg RT5677_PWR_ANLG2 as volatile

Benjamin Berg (1):
      x86/mce: Lower throttling MCE messages' priority to warning

Benoit Parrot (10):
      media: am437x-vpfe: Setting STD to current value is not an error
      media: i2c: ov2659: fix s_stream return value
      media: i2c: ov2659: Fix missing 720p register config
      media: ti-vpe: vpe: Fix Motion Vector vpdma stride
      media: ti-vpe: vpe: fix a v4l2-compliance warning about invalid pixel=
 format
      media: ti-vpe: vpe: fix a v4l2-compliance failure about frame sequenc=
e number
      media: ti-vpe: vpe: Make sure YUYV is set as default format
      media: ti-vpe: vpe: fix a v4l2-compliance failure causing a kernel pa=
nic
      media: ti-vpe: vpe: ensure buffers are cleaned up properly in abort c=
ases
      media: ti-vpe: vpe: fix a v4l2-compliance failure about invalid sizei=
mage

Bjorn Andersson (1):
      ath10k: Correct error handling of dma_map_single()

Brian Masney (1):
      drm/bridge: analogix-anx78xx: silence -EPROBE_DEFER warnings

Chaotian Jing (1):
      mmc: mediatek: fix CMD_TA to 2 for MT8173 HS200/HS400 mode

Chris Chiu (1):
      rtl8xxxu: fix RTL8723BU connection failure issue after warm reboot

Christian K=C3=B6nig (1):
      drm/amdgpu: grab the id mgr lock while accessing passid_mapping

Christophe JAILLET (1):
      media: cx88: Fix some error handling path in 'cx8800_initdev()'

Christophe Leroy (1):
      powerpc/irq: fix stack overflow verification

Chuhong Yuan (7):
      fjes: fix missed check in fjes_acpi_add
      media: si470x-i2c: add missed operations in remove
      spi: pxa2xx: Add missed security checks
      spi: tegra20-slink: add missed clk_unprepare
      ASoC: wm2200: add missed operations in remove and probe failure
      spi: st-ssc4: add missed pm_runtime_disable
      ASoC: wm5100: add missed pm_runtime_disable

Colin Ian King (1):
      drm/amdgpu: fix uninitialized variable pasid_mapping_needed

Coly Li (1):
      bcache: fix static checker warning in bcache_device_free()

Connor Kuehl (1):
      staging: rtl8188eu: fix possible null dereference

Corentin Labbe (1):
      crypto: sun4i-ss - Fix 64-bit size_t warnings on sun4i-ss-hash.c

Corey Minyard (1):
      ipmi: Don't allow device module unload when in use

Cristian Birsan (1):
      net: usb: lan78xx: Fix suspend/resume PHY register access error

Dan Carpenter (2):
      btrfs: return error pointer from alloc_test_extent_buffer
      ext4: unlock on error in ext4_expand_extra_isize()

Daniel Kurtz (1):
      drm/bridge: dw-hdmi: Restore audio when setting a mode

Daniel T. Lee (1):
      samples: pktgen: fix proc_cmd command result check logic

Darrick J. Wong (1):
      loop: fix no-unmap write-zeroes request behavior

David Galiffi (1):
      drm/amd/display: Fix dongle_caps containing stale information.

Eduard Hasenleithner (1):
      nvme: Discard workaround for non-conformant devices

Erkka Talvitie (1):
      USB: EHCI: Do not return -EPIPE when hub is disconnected

Eugeniu Rosca (1):
      mmc: tmio: Add MMC_CAP_ERASE to allow erase/discard/trim requests

Faiz Abbas (2):
      Revert "mmc: sdhci: Fix incorrect switch to HS mode"
      mmc: sdhci: Update the tuning failed messages to pr_debug level

Filipe Manana (2):
      Btrfs: fix missing data checksums after replaying a log tree
      Btrfs: fix removal logic of the tree mod log that leads to use-after-=
free issues

Geert Uytterhoeven (2):
      net: dst: Force 4-byte alignment of dst_metrics
      pinctrl: sh-pfc: sh7734: Fix duplicate TCLK1_B

Gerald Schaefer (1):
      s390/mm: add mm_pxd_folded() checks to pxd_free()

Greg Kroah-Hartman (1):
      Linux 4.19.92

Grygorii Strashko (2):
      net: phy: dp83867: enable robust auto-mdix
      net: ethernet: ti: ale: clean ale tbl on init and intf restart

Guenter Roeck (1):
      usb: xhci: Fix build warning seen with CONFIG_PM=3Dn

Guoqing Jiang (1):
      md/bitmap: avoid race window between md_bitmap_resize and bitmap_file=
_clear_bit

Hans Verkuil (1):
      media: cec-funcs.h: add status_req checks

Hans de Goede (3):
      ACPI: button: Add DMI quirk for Medion Akoya E2215T
      ASoC: Intel: bytcr_rt5640: Update quirk for Acer Switch 10 SW5-012 2-=
in-1
      platform/x86: hp-wmi: Make buffer for HPWMI_FEATURE2_QUERY 128 bytes

Hawking Zhang (1):
      drm/amdgpu: disallow direct upload save restore list from gfx driver

Heiko Carstens (1):
      s390/time: ensure get_clock_monotonic() returns monotonic values

Herbert Xu (2):
      crypto: atmel - Fix authenc support when it is set to m
      crypto: sun4i-ss - Fix 64-bit size_t warnings

Hewenliang (1):
      libtraceevent: Fix memory leakage in copy_filter_type

Ian Abbott (1):
      staging: comedi: gsc_hpdi: check dma_alloc_coherent() return value

Ian Rogers (2):
      perf tools: Splice events onto evlist even on error
      perf parse: If pmu configuration fails free terms

Ido Schimmel (1):
      selftests: forwarding: Delete IPv6 address at the end

Ilya Leoshkevich (1):
      s390/disassembler: don't hide instruction addresses

Ingo Rohloff (1):
      usb: usbfs: Suppress problematic bind and unbind uevents.

Ivan Khoronzhuk (1):
      selftests/bpf: Correct path to include msg + path

James Clark (1):
      libsubcmd: Use -O0 with DEBUG=3D1

Jan Kara (2):
      ext4: fix ext4_empty_dir() for directories with holes
      ext4: check for directory entries too close to block end

Janusz Krzysztofik (3):
      media: ov6650: Fix crop rectangle alignment not passed back
      media: ov6650: Fix stored frame format not in sync with hardware
      media: ov6650: Fix stored crop rectangle not in sync with hardware

Jason Gunthorpe (1):
      xen/gntdev: Use select for DMA_SHARED_BUFFER

Jia-Ju Bai (1):
      net: nfc: nci: fix a possible sleep-in-atomic-context bug in nci_uart=
_tty_receive()

Jiangfeng Xiao (1):
      net: hisilicon: Fix a BUG trigered by wrong bytes_compl

Jin Yao (1):
      perf report: Add warning when libunwind not compiled in

Johannes Berg (1):
      iwlwifi: check kasprintf() return value

John Garry (1):
      libata: Ensure ata_port probe has completed before detach

Josef Bacik (6):
      btrfs: don't double lock the subvol_sem for rename exchange
      btrfs: do not call synchronize_srcu() in inode_tree_del
      btrfs: abort transaction after failed inode updates in create_subvol
      btrfs: skip log replay on orphaned roots
      btrfs: do not leak reloc root if we fail to read the fs root
      btrfs: handle ENOENT in btrfs_uuid_tree_iterate

Kangjie Lu (2):
      drm/gma500: fix memory disclosures due to uninitialized bytes
      media: rcar_drif: fix a memory disclosure

Konstantin Khlebnikov (1):
      x86/MCE/AMD: Do not use rdmsr_safe_on_cpu() in smca_configure()

Krzysztof Wilczynski (1):
      iio: light: bh1750: Resolve compiler warning and make code more reada=
ble

Laurent Pinchart (1):
      drm/panel: Add missing drm_panel_init() in panel drivers

Leo Yan (2):
      perf test: Report failure for mmap events
      perf tests: Disable bp_signal testing for arm64

Lianbo Jiang (1):
      x86/crash: Add a forward declaration of struct kimage

Lingling Xu (1):
      spi: sprd: adi: Add missing lock protection when rebooting

Loic Poulain (1):
      media: venus: core: Fix msm8996 frequency table

Lucas Stach (1):
      nvmem: imx-ocotp: reset error status on probe

Luiz Augusto von Dentz (1):
      Bluetooth: Fix advertising duplicated flags

Lukasz Majewski (1):
      spi: Add call to spi_slave_abort() function when spidev driver is rel=
eased

Manish Chopra (3):
      qede: Disable hardware gro when xdp prog is installed
      qede: Fix multicast mac configuration
      bnx2x: Fix PF-VF communication over multi-cos queues.

Manjunath Patil (1):
      ixgbe: protect TX timestamping from API misuse

Mao Wenan (2):
      af_packet: set defaule value for tmo
      net: dsa: LAN9303: select REGMAP when LAN9303 enable

Marcel Holtmann (1):
      rfkill: allocate static minor

Masami Hiramatsu (14):
      perf probe: Fix to find range-only function instance
      perf probe: Fix to list probe event with correct line number
      perf probe: Walk function lines in lexical blocks
      perf probe: Fix to probe an inline function which has no entry pc
      perf probe: Fix to show ranges of variables in functions without entr=
y_pc
      perf probe: Fix to show inlined function callsite without entry_pc
      perf probe: Fix to probe a function which has no entry pc
      perf probe: Skip overlapped location on searching variables
      perf probe: Return a better scope DIE if there is no best scope
      perf probe: Fix to show calling lines of inlined functions
      perf probe: Skip end-of-sequence and non statement lines
      perf probe: Filter out instances except for inlined subroutine and su=
bprogram
      tracing/kprobe: Check whether the non-suffixed symbol is notrace
      perf probe: Fix to show function entry line as probe-able

Matthias Kaehlcke (1):
      drm/bridge: dw-hdmi: Refuse DDC/CI transfers on the internal I2C cont=
roller

Mattijs Korpershoek (1):
      Bluetooth: hci_core: fix init for HCI_USER_CHANNEL

Max Gurtovoy (1):
      IB/iser: bound protection_sg size by data_sg size

Miaoqing Pan (1):
      ath10k: fix get invalid tx rate for Mesh metric

Michael Ellerman (1):
      crypto: vmx - Avoid weird build failures

Michael Walle (1):
      ASoC: wm8904: fix regcache handling

Michal Kalderon (1):
      RDMA/qedr: Fix memory leak in user qp and mr

Mike Christie (1):
      nbd: fix shutdown and recv work deadlock v2

Mike Isely (1):
      media: pvrusb2: Fix oops on tear-down when radio support is not prese=
nt

Mike Rapoport (1):
      mips: fix build when "48 bits virtual memory" is enabled

Miquel Raynal (1):
      iio: adc: max1027: Reset the device at probe time

Mitch Williams (1):
      ice: delay less

Nathan Chancellor (1):
      tools/power/cpupower: Fix initializer override in hsw_ext_cstates

Navid Emamdoost (4):
      net: gemini: Fix memory leak in gmac_setup_txqs
      staging: rtl8192u: fix multiple memory leaks on error path
      rtlwifi: prevent memory leak in rtl_usb_probe
      mwifiex: pcie: Fix memory leak in mwifiex_pcie_init_evt_ring

Nicholas Nunley (1):
      i40e: initialize ITRN registers with correct values

Omar Sandoval (4):
      btrfs: don't prematurely free work in end_workqueue_fn()
      btrfs: don't prematurely free work in run_ordered_work()
      btrfs: don't prematurely free work in reada_start_machine_worker()
      btrfs: don't prematurely free work in scrub_missing_raid56_worker()

Pan Bian (2):
      spi: img-spfi: fix potential double release
      drm/amdgpu: fix potential double drop fence reference

Petar Penkov (1):
      tun: fix data-race in gro_normal_list()

Pierre-Louis Bossart (1):
      soundwire: intel: fix PDI/stream mapping for Bulk

Ping-Ke Shih (1):
      rtlwifi: fix memory leak in rtl92c_set_fw_rsvdpagepkt()

Rafael J. Wysocki (1):
      cpufreq: Avoid leaving stale IRQ work items during CPU offline

Rafa=C5=82 Mi=C5=82ecki (1):
      brcmfmac: remove monitor interface when detaching

Rasmus Villemoes (1):
      mmc: sdhci-of-esdhc: Revert "mmc: sdhci-of-esdhc: add erratum A-00920=
4 support"

Robert Richter (1):
      EDAC/ghes: Fix grain calculation

Rodrigo Siqueira (1):
      drm/drm_vblank: Change EINVAL by the correct errno

Russell King (2):
      mod_devicetable: fix PHY module format
      net: phy: initialise phydev speed and duplex sanely

Sakari Ailus (1):
      media: smiapp: Register sensor after enabling runtime PM on the device

Sam Bobroff (1):
      drm/amdgpu: fix bad DMA from INTERRUPT_CNTL2

Sami Tolvanen (2):
      syscalls/x86: Use the correct function type in SYSCALL_DEFINE0
      x86/mm: Use the correct function type for native_set_fixmap()

Sean Paul (1):
      drm: mst: Fix query_payload ack reply struct

Song Liu (1):
      bpf/stackmap: Fix deadlock with rq_lock in bpf_get_stack()

Srikar Dronamraju (1):
      powerpc/vcpu: Assume dedicated processors as non-preempt

Stanimir Varbanov (1):
      media: venus: Fix occasionally failures to suspend

Stefan Popa (1):
      iio: dac: ad5446: Add support for new AD5600 DAC

Stephan Gerhold (2):
      extcon: sm5502: Reset registers during initialization
      phy: qcom-usb-hs: Fix extcon double register after power cycle

Sudip Mukherjee (1):
      parport: load lowlevel driver if ports not found

Suwan Kim (2):
      usbip: Fix receive error in vhci-hcd when using scatter-gather
      usbip: Fix error path of vhci_recv_ret_submit()

Sven Schnelle (1):
      s390/ftrace: fix endless recursion in function_graph tracer

Szymon Janc (1):
      Bluetooth: Workaround directed advertising bug in Broadcom controllers

Takashi Iwai (5):
      ALSA: pcm: Avoid possible info leaks from PCM stream buffers
      ALSA: hda/ca0132 - Keep power on during processing DSP response
      ALSA: hda/ca0132 - Avoid endless loop
      ALSA: hda/ca0132 - Fix work handling in delayed HP detection
      ALSA: timer: Limit max amount of slave instances

Thierry Reding (2):
      drm/tegra: sor: Use correct SOR index on Tegra210
      gpu: host1x: Allocate gather copy for host1x

Thomas Gleixner (1):
      x86/ioapic: Prevent inconsistent state when moving an interrupt

Thomas Pedersen (1):
      mac80211: consider QoS Null frames for STA_NULLFUNC_ACKED

Toke H=C3=B8iland-J=C3=B8rgensen (1):
      libbpf: Fix error handling in bpf_map__reuse_fd()

Tony Lindgren (1):
      hwrng: omap3-rom - Call clk_disable_unprepare() on exit only if not i=
dled

Vandana BN (1):
      media: v4l2-core: fix touch support in v4l_g_fmt

Veerabhadrarao Badiganti (1):
      mmc: sdhci-msm: Correct the offset and value for DDR_CONFIG register

Veeraiyan Chidambaram (1):
      usb: renesas_usbhs: add suspend event support in gadget mode

Viresh Kumar (1):
      cpufreq: Register drivers only after CPU devices have been registered

Wang Xuerui (1):
      iwlwifi: mvm: fix unaligned read of rx_pkt_status

Will Deacon (2):
      pinctrl: devicetree: Avoid taking direct reference to device name str=
ing
      KVM: arm64: Ensure 'params' is initialised when looking up sys regist=
er

Xiaolong Huang (1):
      can: kvaser_usb: kvaser_usb_leaf: Fix some info-leaks to USB devices

Xin Long (1):
      sctp: fully initialize v4 addr in some functions

Yang Yingliang (1):
      media: flexcop-usb: fix NULL-ptr deref in flexcop_usb_transfer_init()

Yangbo Lu (1):
      mmc: sdhci-of-esdhc: fix P2020 errata handling

Yazen Ghannam (1):
      x86/MCE/AMD: Allow Reserved types to be overwritten in smca_banks[]

Yizhuo (1):
      regulator: max8907: Fix the usage of uninitialized variable in max890=
7_regulator_probe()

Yu-Hsuan Hsu (1):
      ASoC: Intel: kbl_rt5663_rt5514_max98927: Add dmic format constraint

Yuming Han (1):
      tracing: use kvcalloc for tgid_map array allocation

Yunfeng Ye (2):
      arm64: psci: Reduce the waiting time for cpu_psci_cpu_kill()
      perf jevents: Fix resource leak in process_mapfile() and main()

Yunsheng Lin (1):
      net: hns3: add struct netdev_queue debug info for TX timeout


--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4LhEkACgkQONu9yGCS
aT65MhAAx03KmR8iKlSAfvsdyazKFDrL6RNQnq7BkbtoNCVOV8/WTWc/N+dZb+OR
ZEsJWIkzcUHuDtrrrJ2W69j4/xUAbHBa37dgV/KXPBg6yqV1v1kq3zC2WpjUsX9C
vG4OnpulkWNHOCiFP+mK2JS4gAUy3wVCi52NzfIqJoOSTiXlB+RmqIxfTjCiOWkx
/HSpTAZVuBeUSOacfDYYfj7JUWC4w61QTtdxa7KHfUwqvAITJDIm9jQEOwwfNoZo
TwsNkZ2xu5J8u4TtIMrDDMEs3W6djp6C5LsrRShKzvFwA0Gu26m4cHfcy0Z8ZeO4
pvj71WwDtUFkYKvciINt1hsSeXBRGbjFytIuRYOX3fJto/E0yEZbYTAc84339W6A
e9QZBm68QImrrN6cREdlRjhjRedreO1XAjhnOfOS/5Rc0i1hqRPPB/E+ICZfg7DC
bD45AgyBs4IqxuyWJw/8bwPihiItpHXUHOiEI0xf6dlYQov7hc9Ii/50mwA/mAWR
p6f6Mg3N2FojuI3otJ1Uk7z2Qja4ioJ6WX3scxDvqOCs9fzOGooezRJjNsR6l0Cj
GAcuZvCW2/5Xd14HdkjAamPO3IY+xNINYa6QQ6IUqHSa7xm+ZiPj/K87jqfCbvmm
4f9WiK+SiS26/FV4K4QpXYeVxIVhmq9/9Pivy497pp2b8dKcg/g=
=tL9M
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
