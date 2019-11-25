Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C58CC108CC3
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 12:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbfKYLSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 06:18:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbfKYLSO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 06:18:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFB2B2082F;
        Mon, 25 Nov 2019 11:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574680691;
        bh=TbHcND/US3RqYJCB/vWq/eqyGBjYlQ9Wr+exwfqjxLE=;
        h=Date:From:To:Cc:Subject:From;
        b=r9dFfGiKLTQ7WmoIEBcSKekcLDvHX/NBA4TOsre/ipGsQZZmk2CbSzyalNN6UaCeE
         OlhMBA5Y1nsbDYzSh7Ri1WQ00jWOWQtxlq5x3ejTCCXjddFFnGS6JiaTSc3/RuIziM
         mG5Jg1BTE60v4uxPah+CJNWikPuSgcNOy7Eb6i2g=
Date:   Mon, 25 Nov 2019 12:18:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.156
Message-ID: <20191125111809.GA2574234@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.156 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                 |    2=20
 arch/arm/boot/dts/at91-sama5d4_xplained.dts              |    2=20
 arch/arm/boot/dts/at91sam9x5cm.dtsi                      |    2=20
 arch/arm/boot/dts/dra7.dtsi                              |    2=20
 arch/arm/boot/dts/omap5-board-common.dtsi                |    5=20
 arch/arm/boot/dts/sunxi-h3-h5.dtsi                       |    2=20
 arch/arm/kernel/entry-common.S                           |    9 -
 arch/arm64/lib/clear_user.S                              |    1=20
 arch/arm64/lib/copy_from_user.S                          |    1=20
 arch/arm64/lib/copy_in_user.S                            |    1=20
 arch/arm64/lib/copy_to_user.S                            |    1=20
 arch/arm64/mm/numa.c                                     |    2=20
 arch/powerpc/kernel/time.c                               |   19 --
 arch/powerpc/kvm/book3s.c                                |    3=20
 arch/powerpc/kvm/book3s_64_vio.c                         |    8 -
 arch/powerpc/kvm/book3s_64_vio_hv.c                      |    6=20
 arch/powerpc/platforms/pseries/dtl.c                     |    4=20
 arch/powerpc/sysdev/xive/common.c                        |    7=20
 arch/s390/kernel/vdso32/Makefile                         |    3=20
 arch/s390/kernel/vdso64/Makefile                         |    3=20
 arch/x86/Kconfig                                         |    3=20
 arch/x86/include/asm/kexec.h                             |    2=20
 arch/x86/kernel/ptrace.c                                 |   62 +++++++-
 arch/x86/power/hibernate_64.c                            |   11 -
 drivers/acpi/acpica/acevents.h                           |    2=20
 drivers/acpi/acpica/aclocal.h                            |    2=20
 drivers/acpi/acpica/evregion.c                           |   17 ++
 drivers/acpi/acpica/evrgnini.c                           |    6=20
 drivers/acpi/acpica/evxfregn.c                           |    1=20
 drivers/acpi/osl.c                                       |    1=20
 drivers/acpi/sbshc.c                                     |    2=20
 drivers/ata/Kconfig                                      |    3=20
 drivers/ata/pata_ep93xx.c                                |    8 -
 drivers/base/power/opp/core.c                            |   21 --
 drivers/base/power/opp/cpu.c                             |    2=20
 drivers/base/power/opp/opp.h                             |    2=20
 drivers/clk/Makefile                                     |    1=20
 drivers/clk/keystone/Kconfig                             |    2=20
 drivers/clk/samsung/clk-cpu.c                            |    6=20
 drivers/clk/samsung/clk-cpu.h                            |    2=20
 drivers/clk/samsung/clk-exynos5420.c                     |    3=20
 drivers/clocksource/sh_cmt.c                             |   78 ++++------
 drivers/crypto/mxs-dcp.c                                 |   80 +++++++++--
 drivers/dma/ioat/init.c                                  |    7=20
 drivers/dma/sh/rcar-dmac.c                               |    3=20
 drivers/dma/timb_dma.c                                   |    2=20
 drivers/gpio/gpio-syscon.c                               |    2=20
 drivers/hwmon/ina3221.c                                  |    6=20
 drivers/hwmon/pwm-fan.c                                  |    8 -
 drivers/i2c/busses/Kconfig                               |    7=20
 drivers/infiniband/hw/mthca/mthca_main.c                 |    3=20
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c         |    3=20
 drivers/input/touchscreen/silead.c                       |   13 +
 drivers/input/touchscreen/st1232.c                       |    1=20
 drivers/iommu/io-pgtable-arm.c                           |    9 -
 drivers/irqchip/irq-mvebu-icu.c                          |    2=20
 drivers/md/bcache/super.c                                |    1=20
 drivers/md/md.c                                          |   22 +--
 drivers/media/cec/cec-pin.c                              |   20 ++
 drivers/media/i2c/adv748x/adv748x-core.c                 |   25 +++
 drivers/media/i2c/adv748x/adv748x-csi2.c                 |   18 --
 drivers/media/i2c/adv748x/adv748x.h                      |    2=20
 drivers/media/i2c/dw9714.c                               |    3=20
 drivers/media/platform/davinci/isif.c                    |    3=20
 drivers/media/platform/pxa_camera.c                      |    2=20
 drivers/media/rc/ir-rc6-decoder.c                        |    9 -
 drivers/media/usb/cx231xx/cx231xx-video.c                |    2=20
 drivers/mfd/ti_am335x_tscadc.c                           |   13 +
 drivers/misc/cxl/guest.c                                 |    2=20
 drivers/mmc/host/tmio_mmc_core.c                         |    5=20
 drivers/mtd/maps/physmap_of_core.c                       |   27 ---
 drivers/mtd/nand/sh_flctl.c                              |    4=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c           |    4=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.h           |    2=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_enet.c   |    8 -
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c       |    2=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c            |   24 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c |    9 +
 drivers/net/usb/cdc_ncm.c                                |    2=20
 drivers/net/wireless/ath/ath10k/core.h                   |    1=20
 drivers/net/wireless/ath/ath10k/mac.c                    |    2=20
 drivers/net/wireless/ath/ath10k/wmi.c                    |   19 ++
 drivers/net/wireless/ath/ath10k/wmi.h                    |    8 -
 drivers/net/wireless/ath/ath9k/common-spectral.c         |    2=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c   |   26 ++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.h   |    2=20
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c              |    4=20
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c        |   13 +
 drivers/net/wireless/quantenna/qtnfmac/commands.c        |    3=20
 drivers/net/xen-netback/interface.c                      |    3=20
 drivers/pinctrl/pinctrl-gemini.c                         |   47 +++++-
 drivers/remoteproc/remoteproc_sysfs.c                    |    5=20
 drivers/reset/core.c                                     |   15 +-
 drivers/spi/spi-fsl-lpspi.c                              |    2=20
 drivers/spi/spi-mt65xx.c                                 |    4=20
 drivers/spi/spi-rockchip.c                               |    3=20
 drivers/spi/spidev.c                                     |    8 -
 drivers/tee/optee/core.c                                 |    4=20
 drivers/usb/dwc3/gadget.c                                |   29 ++-
 drivers/usb/gadget/udc/fotg210-udc.c                     |    2=20
 drivers/usb/serial/cypress_m8.c                          |    2=20
 drivers/video/backlight/lm3639_bl.c                      |    6=20
 drivers/video/fbdev/core/fbmon.c                         |   95 ----------=
---
 drivers/video/fbdev/core/modedb.c                        |   57 -------
 drivers/video/fbdev/sbuslib.c                            |   28 +--
 drivers/watchdog/w83627hf_wdt.c                          |    8 -
 fs/ext4/namei.c                                          |    2=20
 fs/f2fs/gc.c                                             |    2=20
 fs/gfs2/super.c                                          |    2=20
 fs/nfs/delegation.c                                      |    6=20
 fs/orangefs/orangefs-sysfs.c                             |    2=20
 fs/proc/vmcore.c                                         |   10 +
 include/linux/fb.h                                       |    3=20
 include/linux/platform_data/dma-ep93xx.h                 |    2=20
 include/linux/sunrpc/sched.h                             |    2=20
 include/rdma/ib_verbs.h                                  |    2=20
 kernel/cpu.c                                             |    1=20
 kernel/kexec_core.c                                      |    6=20
 kernel/printk/printk.c                                   |   18 +-
 lib/idr.c                                                |   20 ++
 mm/memory_hotplug.c                                      |   77 ++--------
 net/mac80211/rc80211_minstrel_ht.c                       |   20 +-
 net/netfilter/nft_compat.c                               |   24 +++
 net/openvswitch/vport-internal_dev.c                     |    5=20
 net/sunrpc/sched.c                                       |  109 +++++++---=
-----
 net/sunrpc/xprt.c                                        |   14 -
 net/sunrpc/xprtrdma/transport.c                          |    6=20
 net/sunrpc/xprtsock.c                                    |   10 -
 net/wireless/nl80211.c                                   |    2=20
 net/xfrm/xfrm_input.c                                    |    2=20
 samples/mei/mei-amt-version.c                            |    2=20
 sound/pci/hda/patch_sigmatel.c                           |   20 ++
 tools/pci/pcitest.c                                      |    7=20
 tools/testing/radix-tree/idr-test.c                      |   52 +++++++
 virt/kvm/arm/mmu.c                                       |    3=20
 135 files changed, 856 insertions(+), 648 deletions(-)

Alan Mikhak (1):
      tools: PCI: Fix broken pcitest compilation

Alexey Kardashevskiy (1):
      KVM: PPC: Inform the userspace about TCE update failures

Andrew Zaborowski (1):
      nl80211: Fix a GET_KEY reply attribute

Andy Lutomirski (1):
      x86/fsgsbase/64: Fix ptrace() to read the FS/GS base accurately

Anshuman Khandual (1):
      arm64/numa: Report correct memblock range for the dummy node

Anton Blanchard (1):
      powerpc/time: Use clockevents_register_device(), fixing an issue with=
 large decrementer

Ben Greear (1):
      ath10k: fix vdev-start timeout on error

Bjorn Helgaas (1):
      x86/kexec: Correct KEXEC_BACKUP_SRC_END off-by-one error

Bob Moore (1):
      ACPICA: Never run _REG on system_memory and system_IO

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

Chuck Lever (1):
      sunrpc: Fix connect metrics

Chung-Hsien Hsu (2):
      brcmfmac: reduce timeout for action frame scan
      brcmfmac: fix full timeout waiting for action frame on-channel tx

Colin Ian King (2):
      media: cx231xx: fix potential sign-extension overflow on large shift
      orangefs: rate limit the client not running info message

Dan Carpenter (4):
      net: cdc_ncm: Signedness bug in cdc_ncm_set_dgram_size()
      mei: samples: fix a signedness bug in amt_host_if_call()
      fbdev: sbuslib: use checked version of put_user()
      fbdev: sbuslib: integer overflow in sbusfb_ioctl_helper()

Daniel Vetter (1):
      fbdev: Ditch fb_edid_add_monspecs

David Hildenbrand (2):
      mm/memory_hotplug: don't access uninitialized memmaps in shrink_pgdat=
_span()
      mm/memory_hotplug: fix updating the node span

Dennis Dalessandro (1):
      IB/hfi1: Ensure ucast_dlid access doesnt exceed bounds

Felix Fietkau (3):
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
      Linux 4.14.156

Guenter Roeck (1):
      watchdog: w83627hf_wdt: Support NCT6796D, NCT6797D, NCT6798D

Gustavo Pimentel (1):
      tools: PCI: Fix compilation warnings

H. Nikolaus Schaller (1):
      ARM: dts: omap5: enable OTG role for DWC3 controller

Hans Verkuil (1):
      media: cec-gpio: select correct Signal Free Time

He Zhe (1):
      printk: Give error on attempt to set log buffer length to over 2G

Hieu Tran Dang (1):
      spi: fsl-lpspi: Prevent FIFO under/overrun by default

Huibin Hong (1):
      spi: rockchip: initialize dma_slave_config properly

Ido Schimmel (1):
      mlxsw: spectrum_switchdev: Check notification relevance based on uppe=
r device

Jacopo Mondi (1):
      media: i2c: adv748x: Support probing a single output

Jaegeuk Kim (1):
      f2fs: return correct errno in f2fs_gc

Jia-Ju Bai (1):
      usb: gadget: udc: fotg210-udc: Fix a sleep-in-atomic-context bug in f=
otg210_get_status()

Johan Hovold (1):
      USB: serial: cypress_m8: fix interrupt-out transfer length

Joonyoung Shim (1):
      clk: samsung: exynos5420: Define CLK_SECKEY gate clock only or Exynos=
5420

Julia Lawall (1):
      tee: optee: add missing of_node_put after of_device_is_available

Julian Sax (1):
      Input: silead - try firmware reload after unsuccessful resume

Leilk Liu (1):
      spi: mediatek: use correct mata->xfer_len when in fifo transfer

Li RongQing (1):
      xfrm: use correct size to initialise sp->ovec

Lianbo Jiang (1):
      kexec: Allocate decrypted control pages for kdump if SME is enabled

Linus Walleij (2):
      pinctrl: gemini: Mask and set properly
      pinctrl: gemini: Fix up TVC clock group

Marek Szyprowski (1):
      clk: samsung: Use clk_hw API for calling clk framework from clk notif=
iers

Marek Vasut (1):
      gpio: syscon: Fix possible NULL ptr usage

Martin Kepplinger (1):
      Input: st1232 - set INPUT_PROP_DIRECT property

Masaharu Hayakawa (1):
      mmc: tmio: Fix SCC error detection

Matthew Wilcox (Oracle) (1):
      idr: Fix idr_get_next race with idr_remove

Matthias Reichl (1):
      media: rc: ir-rc6-decoder: enable toggle bit for Kathrein RCU-676 rem=
ote

Michael Ellerman (1):
      powerpc/time: Fix clockevent_decrementer initalisation for PR KVM

Michael Pobega (1):
      ALSA: hda/sigmatel - Disable automute for Elo VuPoint

Miquel Raynal (1):
      irqchip/irq-mvebu-icu: Fix wrong private data retrieval

Nathan Chancellor (10):
      dmaengine: ep93xx: Return proper enum in ep93xx_dma_chan_direction
      dmaengine: timb_dma: Use proper enum in td_prep_slave_sg
      cxgb4: Use proper enum in cxgb4_dcb_handle_fw_update
      cxgb4: Use proper enum in IEEE_FAUX_SYNC
      mtd: rawnand: sh_flctl: Use proper enum for flctl_dma_fifo0_transfer
      i40e: Use proper enum in i40e_ndo_set_vf_link_state
      IB/mlx4: Avoid implicit enumerated type conversion
      ata: ep93xx: Use proper enums for directions
      media: pxa_camera: Fix check for pdev->dev.of_node
      backlight: lm3639: Unconditionally call led_classdev_unregister

Naveen N. Rao (2):
      powerpc/pseries: Fix DTL buffer registration
      powerpc/pseries: Fix how we iterate over the DTL entries

NeilBrown (1):
      md: allow metadata updates while suspending an array - fix

Nicolin Chen (1):
      hwmon: (ina3221) Fix INA3221_CONFIG_MODE macros

Nishanth Menon (1):
      clk: keystone: Enable TISCI clocks if K3_ARCH

Olga Kornievskaia (1):
      NFSv4.x: fix lock recovery during delegation recall

Pablo Neira Ayuso (1):
      netfilter: nft_compat: do not dump private area

Pavel Tatashin (1):
      arm64: uaccess: Ensure PAN is re-enabled after unhandled uaccess fault

Philipp Rossak (1):
      ARM: dts: sun8i: h3-h5: ir register size should be the whole memory b=
lock

Radoslaw Tyl (2):
      ixgbe: Fix ixgbe TX hangs with XDP_TX beyond queue limit
      ixgbe: Fix crash with VFs and flow director on interface flap

Radu Solea (2):
      crypto: mxs-dcp - Fix SHA null hashes and output length
      crypto: mxs-dcp - Fix AES issues

Rajmohan Mani (1):
      media: dw9714: Fix error handling in probe function

Rami Rosen (1):
      dmaengine: ioat: fix prototype of ioat_enumerate_channels

Ricardo Ribalda Delgado (1):
      mtd: physmap_of: Release resources on error

Robin Murphy (1):
      iommu/io-pgtable-arm: Fix race handling in split_blk_unmap()

Roger Quadros (1):
      ARM: dts: omap5: Fix dual-role mode on Super-Speed port

Ronald Tschal=E4r (1):
      ACPI / SBS: Fix rare oops when removing modules

Sara Sharon (1):
      iwlwifi: mvm: don't send keys when entering D3

Sergei Shtylyov (2):
      clocksource/drivers/sh_cmt: Fixup for 64-bit machines
      clocksource/drivers/sh_cmt: Fix clocksource width for 32-bit machines

Sergey Matyukevich (2):
      qtnfmac: pass sgi rate info flag to wireless core
      qtnfmac: drop error reports for out-of-bounds key indexes

Shenghui Wang (1):
      bcache: recal cached_dev_sectors on detach

Simon Wunderlich (1):
      ath9k: fix reporting calculated new FFT upper max

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

Tim Smith (1):
      GFS2: Flush the GFS2 delete workqueue before stopping the kernel thre=
ads

Timothy E Baldwin (1):
      ARM: 8802/1: Call syscall_trace_exit even when system call skipped

Trent Piepho (1):
      spi: spidev: Fix OF tree warning logic

Trond Myklebust (1):
      SUNRPC: Fix priority queue fairness

Tudor Ambarus (2):
      ARM: dts: at91: sama5d4_xplained: fix addressable nand flash size
      ARM: dts: at91: at91sam9x5cm: fix addressable nand flash size

Vasily Gorbik (1):
      s390/kasan: avoid vdso instrumentation

Vignesh R (2):
      ARM: dts: dra7: Enable workaround for errata i870 in PCIe host mode
      mfd: ti_am335x_tscadc: Keep ADC interface on if child is wakeup capab=
le

Wei Yongjun (1):
      IB/mthca: Fix error return code in __mthca_init_one()

Wenwen Wang (1):
      media: isif: fix a NULL pointer dereference bug

Wolfram Sang (1):
      dmaengine: rcar-dmac: set scatter/gather max segment size

YueHaibing (2):
      net: ovs: fix return type of ndo_start_xmit function
      net: xen-netback: fix return type of ndo_start_xmit function

Yunsheng Lin (1):
      net: hns3: Fix for netdev not up problem when setting mtu

zhong jiang (2):
      powerpc/xive: Move a dereference below a NULL test
      misc: cxl: Fix possible null pointer dereference


--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3buHAACgkQONu9yGCS
aT58pg//abFTlt1HlFLWapRRrdj8XQKqR/e7QsJNtJBZz6RDY+S4249GxYdiLOHo
GlEtrl0Ez6zIJdzbZhTWknayQD1SpCSGsl0i9TS6/jaEK1sCKCnBLBPsE4zCm++m
tk0lLiomhYuQH/c08+GZL6VSIl6mfya6xYGSsz2UAi47Ug2alrLkGGqoYfxzKBZO
f5NNdN2kFuJznF2ZpyvB6nGnXbX31wj/6IYmpbHPoIi6u7RSveZpMNsOeuRCrOf1
Rf3LJ4PLNSlPYDiOvJSRNqmaEXhxjV9rV5+ljjIK03jw+DMwQSWOq6L71IZUvgnv
+ZhPPUzo+t9d0Kk46BJIxnBH1OybxxhvoxXA/wugP3u/nJjFEAPNRCiHJ7wVFJJt
8cFSPy97bJRs/fPuaEI2bBthjz393OP2OCtIsQOqAEbx7oPMPsLxbneBaa+2tmJ0
RVcEu1nI0+lhq8nViOen7aG87ZAGr+rHBKnnqrpZiL5D0fmVHqBYIcSuaYphk+n6
b5P9HTEdfKch595b0ODH/u4ToGPQOP17ReSFroj6A1/rG4Yo+QdZoBNBv2UHxWhQ
6R4V0erJEAnMVa9emnkTfquKSTIuGNFVZZY2k+/6PuLv3qYrNfFJXhASovyiDnmi
SyB8FAbO7kaWnQMdCJP8/7N4jg0ARPb59fYfQ9RbRP74A/chxak=
=q8/h
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
