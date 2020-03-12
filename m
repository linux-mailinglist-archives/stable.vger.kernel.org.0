Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B89183C2B
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 23:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgCLWOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 18:14:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbgCLWOX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 18:14:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 198B820637;
        Thu, 12 Mar 2020 22:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584051262;
        bh=GBOWp1excelsGfYtuop1MkCB1jEvoxIySoG6OH1kuRk=;
        h=Date:From:To:Cc:Subject:From;
        b=FR3G8G94QFd5w+dpma9CkIeYCEwypvtWkkyz7vNYfxX/A4EAMSME03VvrUgGJZDlN
         mrI7LBOROLqPKwLeckZSEzFoNNEw5b68Js4Hcsdk6Q3+U3IZgnVWpZ9arEvLB7QDi6
         av5YeQhgtZtf2bT7IhXZadgIMN9CUXt7y8CHrCHM=
Date:   Thu, 12 Mar 2020 23:14:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.109
Message-ID: <20200312221420.GA616752@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.109 kernel.

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

 Makefile                                             |    2=20
 arch/arm/boot/dts/am437x-idk-evm.dts                 |    4 -
 arch/arm/boot/dts/dra76x.dtsi                        |    5 +
 arch/arm/boot/dts/imx6qdl-phytec-phycore-som.dtsi    |    1=20
 arch/arm/boot/dts/imx7-colibri.dtsi                  |    1=20
 arch/arm/boot/dts/ls1021a.dtsi                       |    4 -
 arch/arm/mach-imx/Makefile                           |    2=20
 arch/arm/mach-imx/common.h                           |    4 -
 arch/arm/mach-imx/resume-imx6.S                      |   24 ++++++
 arch/arm/mach-imx/suspend-imx6.S                     |   14 ---
 arch/powerpc/kernel/cputable.c                       |    4 -
 arch/s390/Makefile                                   |    2=20
 arch/s390/boot/Makefile                              |    2=20
 arch/s390/include/asm/qdio.h                         |    2=20
 arch/x86/boot/compressed/kaslr_64.c                  |    3=20
 arch/x86/kernel/cpu/common.c                         |    2=20
 arch/x86/platform/efi/efi_64.c                       |   70 ++++++++++++--=
-----
 arch/x86/xen/enlighten_pv.c                          |    7 +
 drivers/dma/coh901318.c                              |    4 -
 drivers/dma/imx-sdma.c                               |   56 ++++++++++-----
 drivers/dma/tegra20-apb-dma.c                        |    6 -
 drivers/edac/amd64_edac.c                            |    1=20
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c            |    4 -
 drivers/gpu/drm/msm/dsi/dsi_manager.c                |    7 +
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c                |    4 -
 drivers/gpu/drm/msm/dsi/pll/dsi_pll_10nm.c           |    6 +
 drivers/gpu/drm/sun4i/sun8i_mixer.c                  |   68 ++++++++++++++=
+---
 drivers/gpu/drm/sun4i/sun8i_vi_layer.c               |   24 ++----
 drivers/hwmon/adt7462.c                              |    2=20
 drivers/infiniband/core/cm.c                         |    1=20
 drivers/infiniband/core/iwcm.c                       |    4 -
 drivers/infiniband/core/security.c                   |   14 ++-
 drivers/infiniband/hw/hfi1/verbs.c                   |    4 -
 drivers/infiniband/hw/qib/qib_verbs.c                |    2=20
 drivers/md/dm-cache-target.c                         |    4 -
 drivers/md/dm-integrity.c                            |   27 ++++---
 drivers/md/dm-writecache.c                           |   14 ++-
 drivers/md/dm.c                                      |    1=20
 drivers/media/v4l2-core/v4l2-mem2mem.c               |    4 -
 drivers/net/dsa/b53/b53_common.c                     |    3=20
 drivers/net/dsa/bcm_sf2.c                            |    3=20
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c    |   62 ++++++++++++++=
++
 drivers/net/ethernet/cavium/thunder/thunder_bgx.h    |    9 ++
 drivers/net/ethernet/intel/ice/ice_ethtool.c         |    7 -
 drivers/net/ethernet/micrel/ks8851_mll.c             |   53 ++------------
 drivers/nvme/host/core.c                             |    2=20
 drivers/phy/motorola/phy-mapphone-mdm6600.c          |   27 ++++++-
 drivers/s390/cio/blacklist.c                         |    5 -
 drivers/s390/cio/qdio_setup.c                        |    3=20
 drivers/s390/net/qeth_core_main.c                    |   23 ++----
 drivers/scsi/megaraid/megaraid_sas_fusion.c          |    5 -
 drivers/scsi/pm8001/pm8001_sas.c                     |    6 +
 drivers/scsi/pm8001/pm80xx_hwi.c                     |    2=20
 drivers/scsi/pm8001/pm80xx_hwi.h                     |    2=20
 drivers/spi/spi-bcm63xx-hsspi.c                      |    1=20
 drivers/tty/serial/8250/8250_exar.c                  |   33 ++++++++
 drivers/tty/serial/ar933x_uart.c                     |    8 ++
 drivers/tty/serial/mvebu-uart.c                      |    2=20
 drivers/tty/vt/selection.c                           |   26 ++++++-
 drivers/tty/vt/vt.c                                  |    2=20
 drivers/usb/core/hub.c                               |    8 +-
 drivers/usb/core/port.c                              |   10 ++
 drivers/usb/core/quirks.c                            |    3=20
 drivers/usb/dwc3/gadget.c                            |    9 ++
 drivers/usb/gadget/composite.c                       |   24 ++++--
 drivers/usb/gadget/function/f_fs.c                   |    5 -
 drivers/usb/gadget/function/u_serial.c               |    4 -
 drivers/usb/storage/unusual_devs.h                   |    6 +
 drivers/video/console/vgacon.c                       |    3=20
 drivers/watchdog/da9062_wdt.c                        |    7 -
 fs/cifs/inode.c                                      |    6 +
 fs/fat/inode.c                                       |   19 +----
 kernel/kprobes.c                                     |   67 +++++++++++---=
----
 mm/huge_memory.c                                     |    3=20
 mm/mprotect.c                                        |   38 +++++++++-
 sound/hda/ext/hdac_ext_controller.c                  |    9 +-
 sound/pci/hda/patch_realtek.c                        |    5 +
 sound/soc/codecs/pcm512x.c                           |    8 +-
 sound/soc/intel/skylake/skl-debug.c                  |   32 ++++----
 sound/soc/soc-dapm.c                                 |    2=20
 sound/soc/soc-pcm.c                                  |   16 ++--
 sound/soc/soc-topology.c                             |   17 ++--
 tools/testing/selftests/lib.mk                       |   23 +++---
 tools/testing/selftests/net/forwarding/mirror_gre.sh |   25 +++---
 84 files changed, 697 insertions(+), 346 deletions(-)

Ahmad Fatoum (1):
      ARM: imx: build v7_cpu_resume() unconditionally

Ard Biesheuvel (2):
      efi/x86: Align GUIDs to their size in the mixed mode runtime wrapper
      efi/x86: Handle by-ref arguments covering multiple pages in mixed mode

Bernard Metzler (1):
      RDMA/iwcm: Fix iwcm work deallocation

Brian Masney (1):
      drm/msm/mdp5: rate limit pp done timeout warnings

Charles Keepax (1):
      ASoC: dapm: Correct DAPM handling of active widgets during shutdown

Christian Lachner (1):
      ALSA: hda/realtek - Fix silent output on Gigabyte X570 Aorus Master

Christophe JAILLET (1):
      spi: bcm63xx-hsspi: Really keep pll clk enabled

Dan Carpenter (2):
      hwmon: (adt7462) Fix an error return in ADT7462_REG_VOLT()
      dmaengine: coh901318: Fix a double lock bug in dma_tc_handle()

Dan Lazewatsky (1):
      usb: quirks: add NO_LPM quirk for Logitech Screen Share

Daniel Golle (1):
      serial: ar933x_uart: set UART_CS_{RX,TX}_READY_ORIDE

Deepak Ukey (1):
      scsi: pm80xx: Fixed kernel panic during error recovery for SATA drive

Dennis Dalessandro (1):
      IB/hfi1, qib: Ensure RCU is locked when accessing list

Desnes A. Nunes do Rosario (1):
      powerpc: fix hardware PMU exception bug on PowerVM compatibility mode=
 systems

Dmitry Osipenko (2):
      dmaengine: tegra-apb: Fix use-after-free
      dmaengine: tegra-apb: Prevent race conditions of tasklet vs free list

Dragos Tarcatu (2):
      ASoC: topology: Fix memleak in soc_tplg_link_elems_load()
      ASoC: topology: Fix memleak in soc_tplg_manifest_load()

Eugeniu Rosca (3):
      usb: core: hub: fix unhandled return by employing a void function
      usb: core: hub: do error out if usb_autopm_get_interface() fails
      usb: core: port: do error out if usb_autopm_get_interface() fails

Faiz Abbas (1):
      arm: dts: dra76x: Fix mmc3 max-frequency

Florian Fainelli (2):
      net: dsa: bcm_sf2: Forcibly configure IMP port for 1Gb/sec
      net: dsa: b53: Ensure the default VID is untagged

Greg Kroah-Hartman (1):
      Linux 4.19.109

H.J. Lu (1):
      x86/boot/compressed: Don't declare __force_order in kaslr_64.c

Hangbin Liu (1):
      selftests: forwarding: use proto icmp for {gretap, ip6gretap}_mac tes=
ting

Hans Verkuil (1):
      media: v4l2-mem2mem.c: fix broken links

Harigovindan P (2):
      drm/msm/dsi: save pll state before dsi host is powered off
      drm/msm/dsi/pll: call vco set rate explicitly

Huang Ying (1):
      mm: fix possible PMD dirty bit lost in set_pmd_migration_entry()

Hui Wang (1):
      ALSA: hda/realtek - Fix a regression for mute led on Lenovo Carbon X1

Jack Pham (1):
      usb: gadget: composite: Support more than 500mA MaxPower

Jason Gunthorpe (1):
      RMDA/cm: Fix missing ib_cm_destroy_id() in ib_cm_insert_listen()

Jay Dolan (1):
      serial: 8250_exar: add support for ACCES cards

Jernej Skrabec (2):
      drm/sun4i: Fix DE2 VI layer format support
      drm/sun4i: de2/de3: Remove unsupported VI layer formats

Jim Lin (1):
      usb: storage: Add quirk for Samsung Fit flash

Jiri Benc (1):
      selftests: fix too long argument

Jiri Slaby (3):
      vt: selection, close sel_buffer race
      vt: selection, push console lock down
      vt: selection, push sel_lock up

John Stultz (1):
      drm: msm: Fix return type of dsi_mgr_connector_mode_valid for kCFI

Julian Wiedmann (1):
      s390/qdio: fill SL with absolute addresses

Kai Vehmanen (1):
      ALSA: hda: do not override bus codec_mask in link_get()

Kailang Yang (1):
      ALSA: hda/realtek - Add Headset Mic supported

Kees Cook (1):
      x86/xen: Distribute switch variables for initialization

Keith Busch (1):
      nvme: Fix uninitialized-variable warning

Lars-Peter Clausen (1):
      usb: gadget: ffs: ffs_aio_cancel(): Save/restore IRQ flags

Maor Gottlieb (1):
      RDMA/core: Fix pkey and port assignment in get_new_pps

Marco Felsch (2):
      watchdog: da9062: do not ping the hw during stop()
      ARM: dts: imx6: phycore-som: fix emmc supply

Marek Vasut (3):
      net: ks8851-ml: Remove 8-bit bus accessors
      net: ks8851-ml: Fix 16-bit data access
      net: ks8851-ml: Fix 16-bit IO operation

Masahiro Yamada (1):
      s390: make 'install' not depend on vmlinux

Masami Hiramatsu (1):
      kprobes: Fix optimize_kprobe()/unoptimize_kprobe() cancellation logic

Matthias Reichl (1):
      ASoC: pcm512x: Fix unbalanced regulator enable call in probe error pa=
th

Mel Gorman (1):
      mm, numa: fix bad pmd by atomically check for pmd_trans_huge when mar=
king page tables prot_numa

Michal Swiatkowski (1):
      ice: Don't tell the OS that link is going down

Mikulas Patocka (4):
      dm cache: fix a crash due to incorrect work item cancelling
      dm: report suspended device during destroy
      dm writecache: verify watermark during resume
      dm integrity: fix a deadlock due to offloading to an incorrect workqu=
eue

Nathan Chancellor (1):
      RDMA/core: Fix use of logical OR in get_new_pps

OGAWA Hirofumi (1):
      fat: fix uninit-memory access for partial initialized inode

Oleksandr Suvorov (1):
      ARM: dts: imx7-colibri: Fix frequency for sd/mmc

Pratham Pratap (1):
      usb: dwc3: gadget: Update chain bit correctly when using sg list

Ronnie Sahlberg (1):
      cifs: don't leak -EAGAIN for stat() during reconnect

Sean Christopherson (1):
      x86/pkeys: Manually set X86_FEATURE_OSPKE to preserve existing changes

Sergey Organov (1):
      usb: gadget: serial: fix Tx stall after buffer overflow

Suman Anna (1):
      ARM: dts: am437x-idk-evm: Fix incorrect OPP node names

Takashi Iwai (3):
      ASoC: intel: skl: Fix pin debug prints
      ASoC: intel: skl: Fix possible buffer overflow in debug outputs
      ASoC: pcm: Fix possible buffer overflow in dpcm state sysfs output

Tim Harvey (1):
      net: thunderx: workaround BGX TX Underflow issue

Tomas Henzl (1):
      scsi: megaraid_sas: silence a warning

Tony Lindgren (2):
      phy: mapphone-mdm6600: Fix timeouts by adding wake-up handling
      phy: mapphone-mdm6600: Fix write timeouts with shorter GPIO toggle in=
terval

Vasily Averin (1):
      s390/cio: cio_ignore_proc_seq_next should increase position index

Vinod Koul (1):
      dmaengine: imx-sdma: remove dma_slave_config direction usage and leav=
e sdma_event_enable()

Vladimir Oltean (1):
      ARM: dts: ls1021a: Restore MDIO compatible to gianfar

Yazen Ghannam (1):
      EDAC/amd64: Set grain per DIMM

Zhang Xiaoxu (1):
      vgacon: Fix a UAF in vgacon_invert_region

tangbin (1):
      tty:serial:mvebu-uart:fix a wrong return


--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5qtDwACgkQONu9yGCS
aT5YphAArFVS8HOk8y4YtY19RHemEyvaFfO+YnBE+ZH9lFSV/OVDe9LEzJQDmI+T
DCBsYCF+NJKwR23rCbNsV8DvgJWWCwndP/IDvA0Sdpm7KNE3CBJb2Yt9QqXz+8jk
CHil6bCPb4XWZ0Gp89Nr1J7I34p4HSN/FRbrSzrTzBGb3f4CQ9PfbTRGj+XtHQxA
1bfFoo92mexyex1AfUaXLPvV/5day7yv5QQ8oLQrWTPZI1jdYLAva73wpAPDoERm
h8Tr7hoWzMMaZ/Wru09lqTvTmBz+tGVO2g1PMP2sm/MuA2EuckeU4zOeUklzV0td
iIVmrrKRRSpf8W9RkyrdDjB7AjTuDsmTk/CV8CdLA8U8lF6F40nPOZySY85xjsDe
DuRF0pQnZczh+YqZsQl97LO07TBvziCY1PONUzuU/jI7OExDjZm+FgN/SpRUy0PL
7P55Z4lwxc+sBZe5nHSbvgKAOOSz7H9MUJ+kfMu6A6Oe5JOtX5pPM0RTg6n2vmdI
n7yOFb5+n2pF1O093wvola6YXvu0RlSouKPs5bsj9M9um7p8qhC0SWJtInr3jJNT
FxSZ8DvFnzV6szXdYE9To5W+T5Rb+IIqCIAfY8e2ICh4SV5W86BR/KGGj8PX5iaW
amwqL9BDSxV6ljbcoEBJT8cpoA8dqOQLYDiLx2gQEum3rJRXhxI=
=b6ex
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
