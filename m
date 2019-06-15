Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 966604709B
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 17:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbfFOPHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 11:07:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:32944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfFOPHm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Jun 2019 11:07:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 749FA20866;
        Sat, 15 Jun 2019 15:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560611261;
        bh=d7JAiSTnjT7JuOEFfCcVtPBIwYxbDI8IQ3wRGwBqPcg=;
        h=Date:From:To:Cc:Subject:From;
        b=MmaCVNblWEQaI4auYhh/W/anImSsJsMWqm3gOjMgCLccK8FYWVa20014Qm06trVYl
         Chblp0PC2B1UkDvejZRaGZpr/OPgVItqCj6ZWfxP//Nv/Ew4PfUraSsaJrzcoynQ+h
         6zBNvxMWVk03lHIDPGy0cvB/Py5XMQDWaCFiL2gg=
Date:   Sat, 15 Jun 2019 17:07:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.126
Message-ID: <20190615150738.GA1796@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.126 kernel.

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

 Makefile                                         |    2 -
 arch/arm/boot/dts/exynos5420-arndale-octa.dts    |    2 +
 arch/arm/boot/dts/imx50.dtsi                     |    2 -
 arch/arm/boot/dts/imx51.dtsi                     |    2 -
 arch/arm/boot/dts/imx53.dtsi                     |    2 -
 arch/arm/boot/dts/imx6qdl.dtsi                   |    2 -
 arch/arm/boot/dts/imx6sl.dtsi                    |    2 -
 arch/arm/boot/dts/imx6sx.dtsi                    |    2 -
 arch/arm/boot/dts/imx6ul.dtsi                    |    2 -
 arch/arm/boot/dts/imx7s.dtsi                     |    4 +--
 arch/arm/include/asm/hardirq.h                   |    1=20
 arch/arm/kernel/smp.c                            |    6 +++-
 arch/arm/mach-exynos/suspend.c                   |   19 ++++++++++++++
 arch/um/kernel/time.c                            |    2 -
 arch/x86/events/intel/core.c                     |    2 -
 arch/x86/pci/irq.c                               |   10 ++++++-
 block/bfq-iosched.c                              |    2 +
 block/blk-core.c                                 |    1=20
 block/blk-mq.c                                   |    2 +
 drivers/clk/rockchip/clk-rk3288.c                |   11 ++++++++
 drivers/dma/idma64.c                             |    6 +++-
 drivers/dma/idma64.h                             |    2 +
 drivers/edac/Kconfig                             |    4 +--
 drivers/gpio/gpio-omap.c                         |   25 +++++++++++++------
 drivers/gpio/gpio-vf610.c                        |   26 +++++++++----------
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c     |    6 ++--
 drivers/gpu/drm/drm_atomic_helper.c              |   10 +++++++
 drivers/gpu/drm/nouveau/Kconfig                  |   13 ---------
 drivers/gpu/drm/nouveau/nouveau_drm.c            |    7 +----
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c    |   11 ++++++--
 drivers/iommu/intel-iommu.c                      |    7 +++--
 drivers/mfd/intel-lpss.c                         |    3 ++
 drivers/mfd/tps65912-spi.c                       |    1=20
 drivers/mfd/twl6040.c                            |   13 +++++++++
 drivers/misc/pci_endpoint_test.c                 |    1=20
 drivers/mmc/host/mmci.c                          |    5 ++-
 drivers/nvme/host/pci.c                          |    5 +++
 drivers/nvmem/core.c                             |   15 +++++++----
 drivers/pci/dwc/pci-keystone.c                   |    4 +++
 drivers/pci/host/pcie-rcar.c                     |   10 +++++--
 drivers/pci/host/pcie-xilinx.c                   |   12 +++++++--
 drivers/pci/hotplug/rpadlpar_core.c              |    4 +++
 drivers/platform/chrome/cros_ec_proto.c          |   11 ++++++++
 drivers/platform/x86/intel_pmc_ipc.c             |    6 +++-
 drivers/power/supply/max14656_charger_detector.c |   14 +++++-----
 drivers/pwm/core.c                               |   10 +++----
 drivers/pwm/pwm-meson.c                          |   25 +++++++++++++------
 drivers/pwm/pwm-tiehrpwm.c                       |    2 +
 drivers/pwm/sysfs.c                              |   14 ----------
 drivers/rapidio/rio_cm.c                         |    8 ++++++
 drivers/soc/mediatek/mtk-pmic-wrap.c             |    2 -
 drivers/soc/rockchip/grf.c                       |    2 +
 drivers/spi/spi-pxa2xx.c                         |    7 -----
 drivers/staging/typec/fusb302/fusb302.c          |    2 +
 drivers/thermal/qcom/tsens.c                     |    3 +-
 drivers/thermal/rcar_gen3_thermal.c              |    3 ++
 drivers/tty/serial/8250/8250_dw.c                |    4 +--
 drivers/vfio/vfio.c                              |   30 +++++++-----------=
-----
 drivers/video/fbdev/hgafb.c                      |    2 +
 drivers/video/fbdev/imsttfb.c                    |    5 +++
 drivers/watchdog/Kconfig                         |    1=20
 drivers/watchdog/imx2_wdt.c                      |    4 ++-
 fs/configfs/dir.c                                |   17 +++++++++----
 fs/f2fs/f2fs.h                                   |   12 +++++++--
 fs/f2fs/inode.c                                  |    1=20
 fs/f2fs/recovery.c                               |   10 ++++++-
 fs/f2fs/segment.h                                |    3 --
 fs/fat/file.c                                    |   11 ++++++--
 fs/fuse/dev.c                                    |    2 -
 fs/nfsd/vfs.h                                    |    5 +++
 include/drm/drm_modeset_helper_vtables.h         |    8 ++++++
 include/linux/pwm.h                              |    5 ---
 include/net/bluetooth/hci_core.h                 |    3 --
 ipc/mqueue.c                                     |   10 ++++++-
 ipc/msgutil.c                                    |    6 ++++
 kernel/sys.c                                     |    2 -
 kernel/sysctl.c                                  |    6 +++-
 kernel/time/ntp.c                                |    2 -
 mm/Kconfig                                       |    2 -
 mm/cma.c                                         |   23 ++++++++++-------
 mm/cma_debug.c                                   |    2 -
 mm/hugetlb.c                                     |   21 ++++++++++++----
 mm/page_alloc.c                                  |    6 +++-
 mm/percpu.c                                      |    9 +++++-
 mm/slab.c                                        |    6 +++-
 net/bluetooth/hci_conn.c                         |    8 ------
 sound/core/seq/seq_ports.c                       |    2 -
 sound/pci/hda/hda_intel.c                        |    6 ++--
 tools/objtool/check.c                            |    8 +++---
 89 files changed, 408 insertions(+), 211 deletions(-)

Amit Kucheria (1):
      drivers: thermal: tsens: Don't print error message on -EPROBE_DEFER

Andrey Smirnov (9):
      ARM: dts: imx51: Specify IMX5_CLK_IPG as "ahb" clock to SDMA
      ARM: dts: imx50: Specify IMX5_CLK_IPG as "ahb" clock to SDMA
      ARM: dts: imx53: Specify IMX5_CLK_IPG as "ahb" clock to SDMA
      ARM: dts: imx6sx: Specify IMX6SX_CLK_IPG as "ahb" clock to SDMA
      ARM: dts: imx7d: Specify IMX7D_CLK_IPG as "ipg" clock to SDMA
      ARM: dts: imx6ul: Specify IMX6UL_CLK_IPG as "ipg" clock to SDMA
      ARM: dts: imx6sx: Specify IMX6SX_CLK_IPG as "ipg" clock to SDMA
      ARM: dts: imx6qdl: Specify IMX6QDL_CLK_IPG as "ipg" clock to SDMA
      gpio: vf610: Do not share irq_chip

Andy Shevchenko (1):
      dmaengine: idma64: Use actual device for DMA transfers

Arnd Bergmann (1):
      ARM: prevent tracing IPI_CPU_BACKTRACE

Ben Skeggs (1):
      drm/nouveau/disp/dp: respect sink limits when selecting failsafe link=
 configuration

Binbin Wu (1):
      mfd: intel-lpss: Set the device in reset state when init

Chao Yu (4):
      f2fs: fix to avoid panic in do_recover_data()
      f2fs: fix to clear dirty inode in error path of f2fs_iget()
      f2fs: fix to avoid panic in dec_valid_block_count()
      f2fs: fix to do sanity check on valid block count of segment

Christian Brauner (1):
      sysctl: return -EINVAL if val violates minmax

Christoph Vogtl=C3=A4nder (1):
      pwm: tiehrpwm: Update shadow register for disabling PWMs

Cyrill Gorcunov (1):
      kernel/sys.c: prctl: fix false positive in validate_prctl_map()

Daniel Gomez (1):
      mfd: tps65912-spi: Add missing of table registration

Dennis Zhou (1):
      percpu: do not search past bitmap when allocating an area

Douglas Anderson (2):
      clk: rockchip: Turn on "aclk_dmac1" for suspend on rk3288
      soc: rockchip: Set the proper PWM for rk3288

Enrico Granata (1):
      platform/chrome: cros_ec_proto: check for NULL transfer function

Farhan Ali (1):
      vfio: Fix WARNING "do not call blocking ops when !TASK_RUNNING"

Georg Hofmann (1):
      watchdog: imx2_wdt: Fix set_timeout for big timeout values

Greg Kroah-Hartman (3):
      Revert "Bluetooth: Align minimum encryption key size for LE and BR/ED=
R connections"
      Revert "drm/nouveau: add kconfig option to turn off nouveau legacy co=
ntexts. (v3)"
      Linux 4.14.126

Hans de Goede (1):
      usb: typec: fusb302: Check vconn is off when we start toggling

Helen Koike (1):
      drm: don't block fb changes for async plane updates

Hou Tao (1):
      fs/fat/file.c: issue flush after the writeback of FAT

J. Bruce Fields (1):
      nfsd: allow fh_want_write to be called twice

Jiada Wang (1):
      thermal: rcar_gen3_thermal: disable interrupt in .remove

John Sperbeck (1):
      percpu: remove spurious lock dependency between percpu and sched

Jorge Ramirez-Ortiz (1):
      nvmem: core: fix read buffer in place

Josh Poimboeuf (1):
      objtool: Don't use ignore flag for fake jumps

Junxiao Chang (1):
      platform/x86: intel_pmc_ipc: adding error handling

J=C3=A9r=C3=B4me Glisse (1):
      mm/hmm: select mmu notifier when selecting HMM

Kangjie Lu (5):
      rapidio: fix a NULL pointer dereference when create_workqueue() fails
      PCI: rcar: Fix a potential NULL pointer dereference
      video: hgafb: fix potential NULL pointer dereference
      video: imsttfb: fix potential NULL pointer dereferences
      PCI: xilinx: Check for __get_free_pages() failure

Keith Busch (1):
      nvme-pci: unquiesce admin queue on shutdown

Kirill Smelkov (1):
      fuse: retrieve: cap requested size to negotiated max_write

Kishon Vijay Abraham I (2):
      misc: pci_endpoint_test: Fix test_reg_bar to be updated in pci_endpoi=
nt_test
      PCI: keystone: Prevent ARM32 specific code to be compiled for ARM64

Krzysztof Kozlowski (1):
      ARM: dts: exynos: Always enable necessary APIO_1V8 and ABB_1V8 regula=
tors on Arndale Octa

Li Rongqing (1):
      ipc: prevent lockup on alloc_msg and free_msg

Linxu Fang (1):
      mem-hotplug: fix node spanned pages when we have a node with only ZON=
E_MOVABLE

Lu Baolu (1):
      iommu/vt-d: Set intel_iommu_gfx_mapped correctly

Ludovic Barre (1):
      mmc: mmci: Prevent polling for busy detection in IRQ context

Maciej =C5=BBenczykowski (1):
      uml: fix a boot splat wrt use of cpu_all_mask

Marek Szyprowski (1):
      ARM: exynos: Fix undefined instruction during Exynos5422 resume

Marek Vasut (1):
      PCI: rcar: Fix 64bit MSI message address handling

Martin Blumenstingl (1):
      pwm: meson: Use the spin-lock only to protect register modifications

Matt Redfearn (1):
      drm/bridge: adv7511: Fix low refresh rate selection

Michael Ellerman (1):
      EDAC/mpc85xx: Prevent building as a module

Mike Kravetz (1):
      hugetlbfs: on restore reserve error path retain subpool reservation

Ming Lei (1):
      blk-mq: move cancel of requeue_work into blk_mq_release

Miroslav Lichvar (1):
      ntp: Allow TAI-UTC offset to be set to zero

Nathan Chancellor (1):
      soc: mediatek: pwrap: Zero initialize rdata in pwrap_init_cipher

Paolo Valente (1):
      block, bfq: increase idling for weight-raised queues

Phong Hoang (1):
      pwm: Fix deadlock warning when removing PWM device

Qian Cai (1):
      mm/slab.c: fix an infinite loop in leaks_show()

Stephane Eranian (1):
      perf/x86/intel: Allow PEBS multi-entry in watermark mode

Sven Van Asbroeck (1):
      power: supply: max14656: fix potential use-before-alloc

Takashi Iwai (2):
      ALSA: hda - Register irq handler after the chip initialization
      ALSA: seq: Cover unsubscribe_port() in list_mutex

Tony Lindgren (2):
      mfd: twl6040: Fix device init errors for ACCCTL register
      gpio: gpio-omap: add check for off wake capable gpios

Tyrel Datwyler (1):
      PCI: rpadlpar: Fix leaked device_node references in add/remove paths

Vladimir Zapolskiy (1):
      watchdog: fix compile time error of pretimeout governors

Wenwen Wang (1):
      x86/PCI: Fix PCI IRQ routing table memory leak

Yue Hu (3):
      mm/cma.c: fix crash on CMA allocation if bitmap allocation fails
      mm/cma.c: fix the bitmap status to show failed allocation reason
      mm/cma_debug.c: fix the break condition in cma_maxchunk_get()

YueHaibing (1):
      configfs: fix possible use-after-free in configfs_register_group


--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0FCbcACgkQONu9yGCS
aT7GBg//c0jrQ4mKbr8ItZp1L/ELSEFATx3j1XgdUVgTyFHMfSQyngzk4Rifk41M
ZQkA3B05di6d7bR6eweuu54iXMRBQ17xLvE0fGyBSeRDd87dI7M5ZNCzfcV9ZJtU
BNduQdNWfL6o5idJETaCn1SbNgfKHqZU8x5sFAGUJKbvZhOfVw9opqgTNmMGgikT
ydUF+CwsyhFu7jEEEANfcqs+YunBkMMkbUN+A7yYiWLT7r6ZKyCW6XNWS7BBT9GK
Pyyp7rdRMpaVB9MaemH0ycuuliSirWnV7jeXthnqJ228qYWRcbESstxa9tCTowjX
f+d/BtQ4qEkinVc9TwYx9QGtax7efiigICanutvf2Z+s1wp6JdbwJWKl7QFRiigB
xZ+M8wIYgDeNUqWSqSyuiEh+MoOkAXaRspNsNsNYqrf2swo6hjSz6UabmLXayT+0
bvyA474IZl6fw1HFkLft2hNXYwGj7jc/4YmtGvWD0PMHsgdpYKQXEWmktzJtGOQm
JJb4XLipGeDY0BSPblY95D1ldntpxmrvRYYsSRDf5grm9eANZsiliq91Xc689U5J
j9vCmByOaF+zTQkhEN5/nGDJLNYWOTcpTD9LTplNIAVOkXOTMWqIRW8fo0Vhn/fS
AK651IohdWbDYETeajgW357JG/Bm50FXDTkyU1W5KE4ofW/llkA=
=xZVc
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
