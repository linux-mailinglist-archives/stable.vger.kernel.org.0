Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC603108CBD
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 12:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfKYLRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 06:17:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:38226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbfKYLRr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 06:17:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 778AF2084D;
        Mon, 25 Nov 2019 11:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574680664;
        bh=IrEpW/PlUSsg/Ns1F9yKqTXtWaZtNQfmdpkmmbLMapg=;
        h=Date:From:To:Cc:Subject:From;
        b=Gv/7+lXjqkqeRt7NN8S09suKaHtzfkDPSeX1NSP2lzW35K/jt5Yp0GnEIL4LXpU3M
         Kj84menW3H0c7WlCRtHd8Gb2zVr0EOAjF24WwIvZU8E+dUaU3YHYE/C4zN9ocDbttW
         AlnSaWvVo2bqMcyDGhjlKUFOZgjgAbRNCf4QCP5A=
Date:   Mon, 25 Nov 2019 12:17:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.86
Message-ID: <20191125111741.GA2574093@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.86 kernel.

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

 Makefile                                                      |    2=20
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts                     |    8=20
 arch/arm/boot/dts/at91-sama5d4_xplained.dts                   |    2=20
 arch/arm/boot/dts/at91sam9x5cm.dtsi                           |    2=20
 arch/arm/boot/dts/dra7.dtsi                                   |    2=20
 arch/arm/boot/dts/omap5-board-common.dtsi                     |    5=20
 arch/arm/boot/dts/sun8i-h3-bananapi-m2-plus.dts               |    2=20
 arch/arm/boot/dts/sunxi-h3-h5.dtsi                            |    2=20
 arch/arm/kernel/entry-common.S                                |    9=20
 arch/arm64/lib/clear_user.S                                   |    1=20
 arch/arm64/lib/copy_from_user.S                               |    1=20
 arch/arm64/lib/copy_in_user.S                                 |    1=20
 arch/arm64/lib/copy_to_user.S                                 |    1=20
 arch/arm64/mm/numa.c                                          |    2=20
 arch/powerpc/kernel/time.c                                    |   19=20
 arch/powerpc/kvm/book3s.c                                     |    3=20
 arch/powerpc/kvm/book3s_64_vio.c                              |    8=20
 arch/powerpc/kvm/book3s_64_vio_hv.c                           |    6=20
 arch/powerpc/mm/tlb-radix.c                                   |    1=20
 arch/powerpc/platforms/pseries/dtl.c                          |    4=20
 arch/powerpc/sysdev/xive/common.c                             |    7=20
 arch/s390/boot/Makefile                                       |    1=20
 arch/s390/boot/compressed/Makefile                            |    1=20
 arch/s390/kernel/Makefile                                     |    2=20
 arch/s390/kernel/vdso32/Makefile                              |    3=20
 arch/s390/kernel/vdso64/Makefile                              |    3=20
 arch/s390/lib/Makefile                                        |    4=20
 arch/x86/Kconfig                                              |    3=20
 arch/x86/include/asm/kexec.h                                  |    2=20
 arch/x86/kernel/cpu/intel_rdt.c                               |    2=20
 arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c                   |    2=20
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c                      |  112 ++
 arch/x86/kernel/ptrace.c                                      |   62 -
 arch/x86/mm/dump_pagetables.c                                 |   35=20
 arch/x86/net/bpf_jit_comp32.c                                 |  524 +++--=
-----
 arch/x86/pci/fixup.c                                          |   12=20
 arch/x86/power/hibernate_64.c                                 |   11=20
 drivers/acpi/acpi_lpss.c                                      |   74 +
 drivers/acpi/acpica/acevents.h                                |    2=20
 drivers/acpi/acpica/aclocal.h                                 |    2=20
 drivers/acpi/acpica/evregion.c                                |   17=20
 drivers/acpi/acpica/evrgnini.c                                |    6=20
 drivers/acpi/acpica/evxfregn.c                                |    1=20
 drivers/acpi/osl.c                                            |    1=20
 drivers/acpi/sbshc.c                                          |    2=20
 drivers/ata/Kconfig                                           |    3=20
 drivers/ata/pata_ep93xx.c                                     |    8=20
 drivers/clk/Makefile                                          |    1=20
 drivers/clk/keystone/Kconfig                                  |    2=20
 drivers/clk/samsung/clk-cpu.c                                 |    6=20
 drivers/clk/samsung/clk-cpu.h                                 |    2=20
 drivers/clk/samsung/clk-exynos5420.c                          |    3=20
 drivers/clk/samsung/clk-exynos5433.c                          |    2=20
 drivers/clocksource/sh_cmt.c                                  |   78 -
 drivers/cpuidle/governors/menu.c                              |   10=20
 drivers/cpuidle/poll_state.c                                  |    6=20
 drivers/crypto/mxs-dcp.c                                      |   80 +
 drivers/devfreq/devfreq.c                                     |  104 +
 drivers/dma/ioat/init.c                                       |    7=20
 drivers/dma/sh/rcar-dmac.c                                    |    3=20
 drivers/dma/timb_dma.c                                        |    2=20
 drivers/gpio/gpio-syscon.c                                    |    2=20
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c                         |    2=20
 drivers/hwmon/ina3221.c                                       |    6=20
 drivers/hwmon/k10temp.c                                       |    5=20
 drivers/hwmon/nct6775.c                                       |   16=20
 drivers/hwmon/npcm750-pwm-fan.c                               |    2=20
 drivers/hwmon/pwm-fan.c                                       |    8=20
 drivers/i2c/busses/Kconfig                                    |    7=20
 drivers/i2c/busses/i2c-mt65xx.c                               |    8=20
 drivers/i2c/busses/i2c-omap.c                                 |    8=20
 drivers/i2c/busses/i2c-qup.c                                  |   14=20
 drivers/i2c/busses/i2c-tegra.c                                |    4=20
 drivers/i2c/busses/i2c-zx2967.c                               |    8=20
 drivers/infiniband/hw/hfi1/mad.c                              |    4=20
 drivers/infiniband/hw/hns/hns_roce_device.h                   |    2=20
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                    |    4=20
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h                    |    2=20
 drivers/infiniband/hw/hns/hns_roce_qp.c                       |   29=20
 drivers/infiniband/hw/mthca/mthca_main.c                      |    3=20
 drivers/infiniband/sw/rxe/rxe_srq.c                           |   10=20
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c              |    3=20
 drivers/input/touchscreen/silead.c                            |   13=20
 drivers/input/touchscreen/st1232.c                            |    1=20
 drivers/iommu/arm-smmu-v3.c                                   |    8=20
 drivers/iommu/io-pgtable-arm.c                                |    9=20
 drivers/irqchip/irq-mvebu-icu.c                               |    2=20
 drivers/lightnvm/pblk-core.c                                  |   32=20
 drivers/lightnvm/pblk-init.c                                  |   10=20
 drivers/lightnvm/pblk-sysfs.c                                 |    3=20
 drivers/md/bcache/super.c                                     |    6=20
 drivers/md/md.c                                               |   22=20
 drivers/media/cec/cec-pin.c                                   |   20=20
 drivers/media/i2c/adv748x/adv748x-core.c                      |   25=20
 drivers/media/i2c/adv748x/adv748x-csi2.c                      |   18=20
 drivers/media/i2c/adv748x/adv748x.h                           |    2=20
 drivers/media/i2c/dw9714.c                                    |    3=20
 drivers/media/i2c/dw9807-vcm.c                                |    3=20
 drivers/media/i2c/ov5640.c                                    |    7=20
 drivers/media/pci/cx18/cx18-driver.c                          |    2=20
 drivers/media/platform/davinci/isif.c                         |    3=20
 drivers/media/platform/pxa_camera.c                           |    2=20
 drivers/media/platform/qcom/venus/vdec.c                      |    3=20
 drivers/media/platform/rcar-vin/rcar-core.c                   |    1=20
 drivers/media/rc/ir-rc6-decoder.c                             |    9=20
 drivers/media/usb/cx231xx/cx231xx-video.c                     |    2=20
 drivers/mfd/ti_am335x_tscadc.c                                |   13=20
 drivers/misc/cxl/guest.c                                      |    2=20
 drivers/mmc/host/mmci.c                                       |   27=20
 drivers/mmc/host/mmci.h                                       |    6=20
 drivers/mmc/host/renesas_sdhi_internal_dmac.c                 |    9=20
 drivers/mmc/host/tmio_mmc_core.c                              |    5=20
 drivers/mtd/devices/m25p80.c                                  |   23=20
 drivers/mtd/maps/physmap_of_core.c                            |   27=20
 drivers/mtd/nand/raw/sh_flctl.c                               |    4=20
 drivers/mtd/spi-nor/cadence-quadspi.c                         |    4=20
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c             |    6=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c                |    4=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.h                |    2=20
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c               |  109 --
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h               |    2=20
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c            |    2=20
 drivers/net/ethernet/intel/ice/ice_switch.c                   |   14=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                 |   24=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c      |    9=20
 drivers/net/ethernet/qlogic/qed/qed_ll2.c                     |   13=20
 drivers/net/usb/cdc_ncm.c                                     |    2=20
 drivers/net/wireless/ath/ath10k/core.h                        |    1=20
 drivers/net/wireless/ath/ath10k/mac.c                         |    2=20
 drivers/net/wireless/ath/ath10k/wmi.c                         |   19=20
 drivers/net/wireless/ath/ath10k/wmi.h                         |    8=20
 drivers/net/wireless/ath/ath9k/common-spectral.c              |    2=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c        |   26=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.h        |    2=20
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c                   |    4=20
 drivers/net/wireless/mediatek/mt76/mac80211.c                 |    6=20
 drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c       |    4=20
 drivers/net/wireless/mediatek/mt76/mt76x2_pci.c               |    1=20
 drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c        |    4=20
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c             |   25=20
 drivers/net/wireless/quantenna/qtnfmac/commands.c             |    6=20
 drivers/net/wireless/quantenna/qtnfmac/core.c                 |   16=20
 drivers/net/wireless/quantenna/qtnfmac/core.h                 |    1=20
 drivers/net/wireless/quantenna/qtnfmac/qlink.h                |    2=20
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c |    6=20
 drivers/net/xen-netback/interface.c                           |    3=20
 drivers/nvme/host/lightnvm.c                                  |    3=20
 drivers/opp/core.c                                            |   23=20
 drivers/opp/cpu.c                                             |    2=20
 drivers/opp/opp.h                                             |    2=20
 drivers/pinctrl/pinctrl-gemini.c                              |   47=20
 drivers/platform/x86/mlx-platform.c                           |    2=20
 drivers/remoteproc/qcom_q6v5.c                                |    3=20
 drivers/remoteproc/remoteproc_sysfs.c                         |    5=20
 drivers/reset/core.c                                          |   15=20
 drivers/rpmsg/qcom_glink_smem.c                               |   12=20
 drivers/s390/char/Makefile                                    |    1=20
 drivers/scsi/arcmsr/arcmsr_hba.c                              |    6=20
 drivers/soc/fsl/qbman/bman_portal.c                           |   10=20
 drivers/spi/spi-fsl-lpspi.c                                   |    2=20
 drivers/spi/spi-mt65xx.c                                      |    4=20
 drivers/spi/spi-rockchip.c                                    |    3=20
 drivers/spi/spidev.c                                          |    8=20
 drivers/tee/optee/core.c                                      |    4=20
 drivers/usb/dwc2/params.c                                     |    1=20
 drivers/usb/dwc3/gadget.c                                     |   29=20
 drivers/usb/gadget/udc/fotg210-udc.c                          |    2=20
 drivers/usb/serial/cypress_m8.c                               |    2=20
 drivers/video/backlight/lm3639_bl.c                           |    6=20
 drivers/video/fbdev/Kconfig                                   |   34=20
 drivers/video/fbdev/atmel_lcdfb.c                             |   43=20
 drivers/video/fbdev/core/fbmon.c                              |   96 -
 drivers/video/fbdev/core/modedb.c                             |   57 -
 drivers/video/fbdev/sbuslib.c                                 |   28=20
 drivers/watchdog/renesas_wdt.c                                |    1=20
 drivers/watchdog/sama5d4_wdt.c                                |    6=20
 drivers/watchdog/w83627hf_wdt.c                               |    8=20
 drivers/watchdog/watchdog_dev.c                               |   10=20
 fs/ext4/namei.c                                               |    2=20
 fs/f2fs/gc.c                                                  |    2=20
 fs/f2fs/super.c                                               |    1=20
 fs/gfs2/incore.h                                              |    1=20
 fs/gfs2/log.c                                                 |    7=20
 fs/gfs2/super.c                                               |    2=20
 fs/gfs2/util.c                                                |   13=20
 fs/nfs/delegation.c                                           |    6=20
 fs/orangefs/orangefs-sysfs.c                                  |    2=20
 fs/proc/vmcore.c                                              |   10=20
 include/linux/cpuidle.h                                       |    1=20
 include/linux/fb.h                                            |    3=20
 include/linux/platform_data/dma-ep93xx.h                      |    2=20
 include/linux/sunrpc/sched.h                                  |    2=20
 include/rdma/ib_verbs.h                                       |    2=20
 kernel/bpf/btf.c                                              |    3=20
 kernel/cpu.c                                                  |    1=20
 kernel/kexec_core.c                                           |    6=20
 kernel/printk/printk.c                                        |   42=20
 lib/idr.c                                                     |   15=20
 mm/memory_hotplug.c                                           |   77 -
 net/core/dev.c                                                |   14=20
 net/ipv4/tcp.c                                                |    4=20
 net/ipv4/tcp_input.c                                          |   27=20
 net/ipv4/tcp_output.c                                         |   25=20
 net/mac80211/rc80211_minstrel_ht.c                            |   20=20
 net/netfilter/nft_compat.c                                    |   24=20
 net/openvswitch/vport-internal_dev.c                          |    5=20
 net/sched/sch_generic.c                                       |   14=20
 net/sunrpc/sched.c                                            |  109 +-
 net/sunrpc/xprt.c                                             |   14=20
 net/sunrpc/xprtrdma/transport.c                               |    6=20
 net/sunrpc/xprtsock.c                                         |   10=20
 net/wireless/nl80211.c                                        |    2=20
 net/xdp/xdp_umem.c                                            |   11=20
 net/xdp/xsk.c                                                 |   13=20
 net/xfrm/xfrm_input.c                                         |    2=20
 samples/mei/mei-amt-version.c                                 |    2=20
 sound/hda/ext/hdac_ext_controller.c                           |   22=20
 sound/pci/hda/patch_ca0132.c                                  |    8=20
 sound/pci/hda/patch_sigmatel.c                                |   20=20
 sound/soc/qcom/qdsp6/q6asm-dai.c                              |    5=20
 tools/pci/pcitest.c                                           |    7=20
 tools/testing/radix-tree/idr-test.c                           |   52=20
 tools/testing/selftests/net/forwarding/lib.sh                 |    2=20
 tools/testing/selftests/net/tls.c                             |   20=20
 tools/testing/selftests/tc-testing/bpf/Makefile               |   29=20
 tools/testing/selftests/tc-testing/bpf/action.c               |   23=20
 tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json  |   16=20
 tools/testing/selftests/tc-testing/tdc_config.py              |    4=20
 virt/kvm/arm/mmu.c                                            |    3=20
 229 files changed, 1884 insertions(+), 1391 deletions(-)

Alan Mikhak (1):
      tools: PCI: Fix broken pcitest compilation

Alexey Kardashevskiy (1):
      KVM: PPC: Inform the userspace about TCE update failures

Andrew Zaborowski (1):
      nl80211: Fix a GET_KEY reply attribute

Andy Lutomirski (1):
      x86/fsgsbase/64: Fix ptrace() to read the FS/GS base accurately

Anirudh Venkataramanan (1):
      ice: Fix forward to queue group logic

Anshuman Khandual (1):
      arm64/numa: Report correct memblock range for the dummy node

Anton Blanchard (1):
      powerpc/time: Use clockevents_register_device(), fixing an issue with=
 large decrementer

Arun Kumar Neelakantam (1):
      rpmsg: glink: smem: Support rx peak for size less than 4 bytes

Ben Greear (1):
      ath10k: fix vdev-start timeout on error

Bjorn Helgaas (1):
      x86/kexec: Correct KEXEC_BACKUP_SRC_END off-by-one error

Bj=F6rn T=F6pel (1):
      xsk: proper AF_XDP socket teardown ordering

Bob Moore (1):
      ACPICA: Never run _REG on system_memory and system_IO

Bob Peterson (1):
      gfs2: slow the deluge of io error messages

Borislav Petkov (3):
      cpu/SMT: State SMT is disabled even with nosmt and without "=3Dforce"
      x86/olpc: Fix build error with CONFIG_MFD_CS5535=3Dm
      proc/vmcore: Fix i386 build error of missing copy_oldmem_page_encrypt=
ed()

Cameron Kaiser (1):
      KVM: PPC: Book3S PR: Exiting split hack mode needs to fixup both PC a=
nd LR

Chen Yu (1):
      PM / hibernate: Check the success of generating md5 digest before hib=
ernation

Chen-Yu Tsai (1):
      ARM: dts: sun8i: h3: bpi-m2-plus: Fix address for external RGMII Ethe=
rnet PHY

Chuck Lever (1):
      sunrpc: Fix connect metrics

Chung-Hsien Hsu (2):
      brcmfmac: reduce timeout for action frame scan
      brcmfmac: fix full timeout waiting for action frame on-channel tx

Colin Ian King (3):
      media: cx231xx: fix potential sign-extension overflow on large shift
      orangefs: rate limit the client not running info message
      scsi: arcmsr: clean up clang warning on extraneous parentheses

Connor McAdams (1):
      ALSA: hda/ca0132 - Fix input effect controls for desktop cards

Dan Carpenter (5):
      net: cdc_ncm: Signedness bug in cdc_ncm_set_dgram_size()
      mei: samples: fix a signedness bug in amt_host_if_call()
      ASoC: qdsp6: q6asm-dai: checking NULL vs IS_ERR()
      fbdev: sbuslib: use checked version of put_user()
      fbdev: sbuslib: integer overflow in sbusfb_ioctl_helper()

Daniel Vetter (1):
      fbdev: Ditch fb_edid_add_monspecs

David Hildenbrand (2):
      mm/memory_hotplug: don't access uninitialized memmaps in shrink_pgdat=
_span()
      mm/memory_hotplug: fix updating the node span

Davide Caratti (1):
      tc-testing: fix build of eBPF programs

Dennis Dalessandro (1):
      IB/hfi1: Ensure ucast_dlid access doesnt exceed bounds

Enric Balletbo i Serra (2):
      PM / devfreq: Fix devfreq_add_device() when drivers are built as modu=
les.
      PM / devfreq: Fix static checker warning in try_then_request_governor

Eric Dumazet (1):
      net: sched: avoid writing on noop_qdisc

Fabrizio Castro (1):
      mmc: renesas_sdhi_internal_dmac: Whitelist r8a774a1

Felix Fietkau (5):
      mt76x2: disable WLAN core before probe
      mt76: fix handling ps-poll frames
      mac80211: minstrel: fix using short preamble CCK rates on HT clients
      mac80211: minstrel: fix CCK rate group streams value
      mac80211: minstrel: fix sampling/reporting of CCK rates in HT mode

Florian Fainelli (2):
      ata: ahci_brcm: Allow using driver or DSL SoCs
      i2c: brcmstb: Allow enabling the driver on DSL SoCs

Gabriel Krisman Bertazi (1):
      ext4: fix build error when DX_DEBUG is defined

Geert Uytterhoeven (1):
      reset: Fix potential use-after-free in __of_reset_control_get()

Greg Kroah-Hartman (2):
      Revert "OPP: Protect dev_list with opp_table lock"
      Linux 4.19.86

Guenter Roeck (3):
      watchdog: w83627hf_wdt: Support NCT6796D, NCT6797D, NCT6798D
      hwmon: (k10temp) Support all Family 15h Model 6xh and Model 7xh proce=
ssors
      hwmon: (nct6775) Fix names of DIMM temperature sources

Gustavo Pimentel (1):
      tools: PCI: Fix compilation warnings

H. Nikolaus Schaller (1):
      ARM: dts: omap5: enable OTG role for DWC3 controller

Hans Holmberg (1):
      lightnvm: pblk: fix write amplificiation calculation

Hans Verkuil (1):
      media: cec-gpio: select correct Signal Free Time

Hans de Goede (3):
      ACPI / LPSS: Make acpi_lpss_find_device() also find PCI devices
      ACPI / LPSS: Resume BYT/CHT I2C controllers from resume_noirq
      ACPI / LPSS: Use acpi_lpss_* instead of acpi_subsys_* functions for h=
ibernate

He Zhe (2):
      printk: Correct wrong casting
      printk: Give error on attempt to set log buffer length to over 2G

Hieu Tran Dang (1):
      spi: fsl-lpspi: Prevent FIFO under/overrun by default

Hsin-Yi Wang (1):
      i2c: mediatek: modify threshold passed to i2c_get_dma_safe_msg_buf()

Huazhong Tan (1):
      net: hns3: Fix loss of coal configuration while doing reset

Hugues Fruchet (1):
      media: ov5640: fix framerate update

Huibin Hong (1):
      spi: rockchip: initialize dma_slave_config properly

Ido Schimmel (1):
      mlxsw: spectrum_switchdev: Check notification relevance based on uppe=
r device

Igor Mitsyanko (1):
      qtnfmac: request userspace to do OBSS scanning if FW can not

Jacopo Mondi (1):
      media: i2c: adv748x: Support probing a single output

Jaegeuk Kim (2):
      f2fs: return correct errno in f2fs_gc
      f2fs: keep lazytime on remount

Javier Gonz=E1lez (3):
      lightnvm: pblk: guarantee emeta on line close
      lightnvm: pblk: guarantee mw_cunits on read buffer
      lightnvm: do no update csecs and sos on 1.2

Jesper Dangaard Brouer (1):
      net: fix generic XDP to handle if eth header was mangled

Jia-Ju Bai (1):
      usb: gadget: udc: fotg210-udc: Fix a sleep-in-atomic-context bug in f=
otg210_get_status()

Jian Shen (1):
      net: hns3: Fix for rx vlan id handle to support Rev 0x21 hardware

Johan Hovold (1):
      USB: serial: cypress_m8: fix interrupt-out transfer length

Jon Derrick (1):
      x86/PCI: Apply VMD's AERSID fixup generically

Joonyoung Shim (1):
      clk: samsung: exynos5420: Define CLK_SECKEY gate clock only or Exynos=
5420

Jordan Crouse (1):
      msm/gpu/a6xx: Force of_dma_configure to setup DMA for GMU

Julia Lawall (1):
      tee: optee: add missing of_node_put after of_device_is_available

Julian Sax (1):
      Input: silead - try firmware reload after unsuccessful resume

Keyon Jie (1):
      ALSA: hda: Fix mismatch for register mask and value in ext controller.

Kun Yi (1):
      hwmon: (npcm-750-pwm-fan) Change initial pwm target to 255

Laurentiu Tudor (1):
      soc: fsl: bman_portals: defer probe after bman's probe

Leilk Liu (1):
      spi: mediatek: use correct mata->xfer_len when in fifo transfer

Li RongQing (1):
      xfrm: use correct size to initialise sp->ovec

Lianbo Jiang (1):
      kexec: Allocate decrypted control pages for kdump if SME is enabled

Lijun Ou (4):
      RDMA/hns: Bugfix for reserved qp number
      RDMA/hns: Submit bad wr when post send wr exception
      RDMA/hns: Bugfix for CM test
      RDMA/hns: Limit the size of extend sge of sq

Linus Walleij (2):
      pinctrl: gemini: Mask and set properly
      pinctrl: gemini: Fix up TVC clock group

Lorenzo Bianconi (1):
      mt76x2: fix tx power configuration for VHT mcs 9

Ludovic Barre (1):
      mmc: mmci: expand startbiterr to irqmask and error check

Luke Nelson (2):
      bpf, x32: Fix bug with ALU64 {LSH, RSH, ARSH} BPF_X shift by 0
      bpf, x32: Fix bug with ALU64 {LSH, RSH, ARSH} BPF_K shift by 0

Marek Szyprowski (2):
      clk: samsung: Use NOIRQ stage for Exynos5433 clocks suspend/resume
      clk: samsung: Use clk_hw API for calling clk framework from clk notif=
iers

Marek Vasut (1):
      gpio: syscon: Fix possible NULL ptr usage

Martin Kepplinger (1):
      Input: st1232 - set INPUT_PROP_DIRECT property

Masaharu Hayakawa (1):
      mmc: tmio: Fix SCC error detection

Matias Bj=F8rling (2):
      lightnvm: pblk: fix rqd.error return value in pblk_blk_erase_sync
      lightnvm: pblk: fix incorrect min_write_pgs

Matthew Wilcox (Oracle) (1):
      idr: Fix idr_get_next race with idr_remove

Matthias Kaehlcke (1):
      PM / devfreq: Fix handling of min/max_freq =3D=3D 0

Matthias Reichl (1):
      media: rc: ir-rc6-decoder: enable toggle bit for Kathrein RCU-676 rem=
ote

Michael Ellerman (1):
      powerpc/time: Fix clockevent_decrementer initalisation for PR KVM

Michael J. Ruhl (1):
      IB/hfi1: Error path MAD response size is incorrect

Michael Pobega (1):
      ALSA: hda/sigmatel - Disable automute for Elo VuPoint

Miquel Raynal (1):
      irqchip/irq-mvebu-icu: Fix wrong private data retrieval

Nathan Chancellor (15):
      rtlwifi: btcoex: Use proper enumerated types for Wi-Fi only interface
      dmaengine: ep93xx: Return proper enum in ep93xx_dma_chan_direction
      dmaengine: timb_dma: Use proper enum in td_prep_slave_sg
      cxgb4: Use proper enum in cxgb4_dcb_handle_fw_update
      cxgb4: Use proper enum in IEEE_FAUX_SYNC
      mtd: rawnand: sh_flctl: Use proper enum for flctl_dma_fifo0_transfer
      i40e: Use proper enum in i40e_ndo_set_vf_link_state
      IB/mlx4: Avoid implicit enumerated type conversion
      ata: ep93xx: Use proper enums for directions
      qed: Avoid implicit enum conversion in qed_ooo_submit_tx_buffers
      media: pxa_camera: Fix check for pdev->dev.of_node
      platform/x86: mlx-platform: Properly use mlxplat_mlxcpld_msn201x_items
      media: cx18: Don't check for address of video_dev
      mtd: spi-nor: cadence-quadspi: Use proper enum for dma_[un]map_single
      backlight: lm3639: Unconditionally call led_classdev_unregister

Naveen N. Rao (2):
      powerpc/pseries: Fix DTL buffer registration
      powerpc/pseries: Fix how we iterate over the DTL entries

NeilBrown (1):
      md: allow metadata updates while suspending an array - fix

Nicholas Piggin (1):
      powerpc/64s/radix: Explicitly flush ERAT with local LPID invalidation

Nicolin Chen (1):
      hwmon: (ina3221) Fix INA3221_CONFIG_MODE macros

Niklas S=F6derlund (2):
      media: rcar-vin: fix redeclaration of symbol
      mmc: renesas_sdhi_internal_dmac: set scatter/gather max segment size

Nishanth Menon (1):
      clk: keystone: Enable TISCI clocks if K3_ARCH

Olga Kornievskaia (1):
      NFSv4.x: fix lock recovery during delegation recall

Pablo Neira Ayuso (1):
      netfilter: nft_compat: do not dump private area

Pavel Tatashin (1):
      arm64: uaccess: Ensure PAN is re-enabled after unhandled uaccess fault

Petr Machata (1):
      selftests: forwarding: Have lldpad_app_wait_set() wait for unknown, t=
oo

Petr Mladek (1):
      printk: Do not miss new messages when replaying the log

Philipp Rossak (1):
      ARM: dts: sun8i: h3-h5: ir register size should be the whole memory b=
lock

Radoslaw Tyl (2):
      ixgbe: Fix ixgbe TX hangs with XDP_TX beyond queue limit
      ixgbe: Fix crash with VFs and flow director on interface flap

Radu Solea (2):
      crypto: mxs-dcp - Fix SHA null hashes and output length
      crypto: mxs-dcp - Fix AES issues

Rafael J. Wysocki (1):
      cpuidle: menu: Fix wakeup statistics updates for polling state

Rajmohan Mani (1):
      media: dw9714: Fix error handling in probe function

Rami Rosen (1):
      dmaengine: ioat: fix prototype of ioat_enumerate_channels

Randy Dunlap (1):
      fbdev: fix broken menu dependencies

Reinette Chatre (3):
      x86/intel_rdt: Introduce utility to obtain CDP peer
      x86/intel_rdt: CBM overlap should also check for overlap with CDP peer
      x86/resctrl: Fix rdt_find_domain() return value and checks

Ricardo Ribalda Delgado (1):
      mtd: physmap_of: Release resources on error

Robin Murphy (1):
      iommu/io-pgtable-arm: Fix race handling in split_blk_unmap()

Roger Quadros (1):
      ARM: dts: omap5: Fix dual-role mode on Super-Speed port

Romain Izard (1):
      watchdog: sama5d4: fix timeout-sec usage

Ronald Tschal=E4r (1):
      ACPI / SBS: Fix rare oops when removing modules

Sakari Ailus (1):
      media: dw9807-vcm: Fix probe error handling

Sam Ravnborg (1):
      atmel_lcdfb: support native-mode display-timings

Sara Sharon (1):
      iwlwifi: mvm: don't send keys when entering D3

Sergei Shtylyov (2):
      clocksource/drivers/sh_cmt: Fixup for 64-bit machines
      clocksource/drivers/sh_cmt: Fix clocksource width for 32-bit machines

Sergey Matyukevich (3):
      qtnfmac: pass sgi rate info flag to wireless core
      qtnfmac: inform wireless core about supported extended capabilities
      qtnfmac: drop error reports for out-of-bounds key indexes

Sergey Senozhatsky (1):
      printk: CON_PRINTBUFFER console registration is a bit racy

Shenghui Wang (2):
      bcache: account size of buckets used in uuid write to ca->meta_sector=
s_written
      bcache: recal cached_dev_sectors on detach

Sibi Sankar (1):
      remoteproc: qcom: q6v5: Fix a race condition on fatal crash

Simon Wunderlich (1):
      ath9k: fix reporting calculated new FFT upper max

SolidHal (1):
      usb: dwc2: disable power_down on rockchip devices

Suman Anna (1):
      remoteproc: Check for NULL firmwares in sysfs interface

Suzuki K Poulose (1):
      kvm: arm/arm64: Fix stage2_flush_memslot for 4 level page table

Takeshi Saito (1):
      mmc: tmio: fix SCC error handling to avoid false positive CRC error

Thierry Reding (1):
      hwmon: (pwm-fan) Silence error on probe deferral

Thinh Nguyen (1):
      usb: dwc3: gadget: Check ENBLSLPM before sending ep command

Thomas Gleixner (1):
      x86/mm: Do not warn about PCI BIOS W+X mappings

Tim Smith (1):
      GFS2: Flush the GFS2 delete workqueue before stopping the kernel thre=
ads

Timothy E Baldwin (1):
      ARM: 8802/1: Call syscall_trace_exit even when system call skipped

Trent Piepho (1):
      spi: spidev: Fix OF tree warning logic

Trond Myklebust (1):
      SUNRPC: Fix priority queue fairness

Tudor Ambarus (3):
      ARM: dts: at91: sama5d4_xplained: fix addressable nand flash size
      ARM: dts: at91: at91sam9x5cm: fix addressable nand flash size
      ARM: dts: at91: sama5d2_ptc_ek: fix bootloader env offsets

Vakul Garg (1):
      selftests/tls: Fix recv(MSG_PEEK) & splice() test cases

Vasily Gorbik (3):
      s390/kasan: avoid vdso instrumentation
      s390/kasan: avoid instrumentation of early C code
      s390/kasan: avoid user access code instrumentation

Vasundhara Volam (1):
      bnxt_en: return proper error when FW returns HWRM_ERR_CODE_RESOURCE_A=
CCESS_DENIED

Vignesh R (2):
      ARM: dts: dra7: Enable workaround for errata i870 in PCIe host mode
      mfd: ti_am335x_tscadc: Keep ADC interface on if child is wakeup capab=
le

Vikash Garodia (1):
      media: venus: vdec: fix decoded data size

Vincent Donnefort (1):
      PM / devfreq: stopping the governor before device_unregister()

Viresh Kumar (1):
      OPP: Return error on error from dev_pm_opp_get_opp_count()

Wang YanQing (2):
      bpf, x32: Fix bug for BPF_ALU64 | BPF_NEG
      bpf, x32: Fix bug for BPF_JMP | {BPF_JSGT, BPF_JSLE, BPF_JSLT, BPF_JS=
GE}

Wei Yongjun (2):
      IB/mthca: Fix error return code in __mthca_init_one()
      lightnvm: pblk: fix error handling of pblk_lines_init()

Wenwen Wang (2):
      media: isif: fix a NULL pointer dereference bug
      bpf: btf: Fix a missing check bug

Wolfram Sang (7):
      watchdog: core: fix null pointer dereference when releasing cdev
      watchdog: renesas_wdt: stop when unregistering
      i2c: omap: use core to detect 'no zero length' quirk
      i2c: qup: use core to detect 'no zero length' quirk
      i2c: tegra: use core to detect 'no zero length' quirk
      i2c: zx2967: use core to detect 'no zero length' quirk
      dmaengine: rcar-dmac: set scatter/gather max segment size

Yogesh Gaur (1):
      mtd: devices: m25p80: Make sure WRITE_EN is issued before each write

Yuchung Cheng (2):
      tcp: up initial rmem to 128KB and SYN rwin to around 64KB
      tcp: start receiver buffer autotuning sooner

YueHaibing (2):
      net: ovs: fix return type of ndo_start_xmit function
      net: xen-netback: fix return type of ndo_start_xmit function

Yunsheng Lin (1):
      net: hns3: Fix for netdev not up problem when setting mtu

Zhen Lei (1):
      iommu/arm-smmu-v3: Fix unexpected CMD_SYNC timeout

Zhoujie Wu (1):
      lightnvm: pblk: consider max hw sectors supported for max_write_pgs

Zhu Yanjun (1):
      IB/rxe: avoid srq memory leak

zhong jiang (2):
      powerpc/xive: Move a dereference below a NULL test
      misc: cxl: Fix possible null pointer dereference


--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3buFUACgkQONu9yGCS
aT4ouA//dPtboTTtbHbdIVs8AHe2r+blH2ghooE7dCGKvWi1rz5USRc2Ik504154
bjeX4cdw5WO0goynHvyJUToy3wETRrJEVFEMVIi+sVdaMtL8JL/BIcIRqFWN15k0
4QhQ8cfVZVcy8yraQKxO6tpBMxoGzyDR7hjgjni+Hda64v4cG0GSDXTtraWo4WrK
YFvQ78baexH8QFwBbL6h6hM7UC8rb6dqeW3qq4I1AeQ+xW+SLXtAnZmEVDKaO1yH
Kv9am8CoOT35bRl2lIpxjbUNRJ6oVz8NP2xtMMwbg5wR5UDVmvtygaXdmEAJU3y1
lRBZEy24tTfJb60y1pMWkZkkimfEiOlH6wC4nxxDzf1qvZd4G7cCWHxiYXhsp2pe
yZZVtNAV9mfFM/yrSv9iCHC8PD+QtwPwZHMQDQOH6K9uB2U3NUoxdjeB/vhOHsMa
2QC4/klL1dE8F+KIey00rwtDkpP70uqPFPzyXdMIqrEhVezBgOfLY/zLIYVIw9Oq
pjyicjPjhDusNQ8CEtk7jfa9eRQEGV3GMkHtn2dNxCZQ6WjyEwTYmrm9rJxB15P9
27GzPTxoDwv03J+beNFMJ4nKBCypzbz1yzbIOiaIfyUjiXmaw9TykfS+fz/CY5OI
g8wexiCCBkGAzV/43IJVieVySd14nCpoYiso5HZdobwxkRi8gUo=
=bS8K
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
