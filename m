Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 585D5646AB
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 15:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbfGJNAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 09:00:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727239AbfGJNAc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 09:00:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E1172084B;
        Wed, 10 Jul 2019 13:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562763630;
        bh=a/IH8u+1hOqVyfLpvJLFtEvF5EhwNwhrcjUA6fyrJU0=;
        h=Date:From:To:Cc:Subject:From;
        b=q5Sqn1xXq5aeZ+Jq+92ZXoQR+trqWO5Brw3NaNxGMu3tq+iqLJ2p1pXJADCBDIrtH
         8i4cDgolrv+BNwsPB3Cf5UK4I676X427UaD1cw7NXLv0YHNVuA7zKlIkPaVm9SKFq1
         P83vIByKWT8iEAwerSGiVHltumCO14cuOJpDAa5M=
Date:   Wed, 10 Jul 2019 15:00:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.1.17
Message-ID: <20190710130027.GA17677@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.1.17 kernel.

All users of the 5.1 kernel series must upgrade.

The updated 5.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                    |    2=20
 arch/arm/boot/dts/armada-xp-98dx3236.dtsi                   |    8 ++
 arch/arm64/include/asm/tlbflush.h                           |    3=20
 arch/arm64/kernel/module.c                                  |    8 +-
 arch/mips/Makefile                                          |    3=20
 arch/mips/mm/mmap.c                                         |    2=20
 arch/mips/mm/tlbex.c                                        |   29 +++++--
 arch/s390/include/asm/pgtable.h                             |   33 ++++----
 arch/x86/include/asm/intel-family.h                         |    3=20
 arch/x86/kernel/ftrace.c                                    |    3=20
 arch/x86/kvm/lapic.c                                        |    2=20
 arch/x86/kvm/x86.c                                          |    6 -
 crypto/cryptd.c                                             |    1=20
 crypto/crypto_user_base.c                                   |    3=20
 drivers/dma/dma-jz4780.c                                    |    5 -
 drivers/dma/imx-sdma.c                                      |    4 -
 drivers/dma/qcom/bam_dma.c                                  |    3=20
 drivers/gpio/gpio-pca953x.c                                 |    3=20
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                       |   19 ----
 drivers/gpu/drm/amd/powerplay/hwmgr/hwmgr.c                 |    2=20
 drivers/gpu/drm/amd/powerplay/hwmgr/process_pptables_v1_0.c |    4 -
 drivers/gpu/drm/amd/powerplay/inc/hwmgr.h                   |    1=20
 drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smumgr.c     |    4 +
 drivers/gpu/drm/drm_panel_orientation_quirks.c              |   32 ++++++++
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c                       |    7 +
 drivers/gpu/drm/i915/intel_ringbuffer.c                     |    6 -
 drivers/gpu/drm/imx/ipuv3-crtc.c                            |    6 -
 drivers/gpu/drm/mediatek/mtk_drm_drv.c                      |    8 --
 drivers/gpu/drm/mediatek/mtk_dsi.c                          |   12 ++-
 drivers/gpu/drm/virtio/virtgpu_vq.c                         |    2=20
 drivers/hid/hid-a4tech.c                                    |   11 ++
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c                    |    8 ++
 drivers/i2c/busses/i2c-pca-platform.c                       |    3=20
 drivers/iommu/intel-pasid.c                                 |    2=20
 drivers/platform/mellanox/mlxreg-hotplug.c                  |    1=20
 drivers/platform/x86/asus-nb-wmi.c                          |    8 ++
 drivers/platform/x86/asus-wmi.c                             |    2=20
 drivers/platform/x86/asus-wmi.h                             |    1=20
 drivers/platform/x86/intel-vbtn.c                           |   16 +++-
 drivers/platform/x86/mlx-platform.c                         |    2=20
 drivers/scsi/hpsa.c                                         |    7 +
 drivers/scsi/hpsa_cmd.h                                     |    1=20
 drivers/spi/spi-bitbang.c                                   |    2=20
 drivers/target/target_core_iblock.c                         |    2=20
 drivers/tty/rocket.c                                        |    2=20
 drivers/usb/dwc2/gadget.c                                   |   20 +++--
 drivers/usb/gadget/udc/fusb300_udc.c                        |    5 +
 drivers/usb/gadget/udc/lpc32xx_udc.c                        |    3=20
 fs/Kconfig                                                  |    1=20
 fs/aio.c                                                    |   28 +++++--
 fs/btrfs/dev-replace.c                                      |   26 ++++--
 fs/btrfs/volumes.c                                          |    5 +
 fs/btrfs/volumes.h                                          |    5 +
 fs/dax.c                                                    |    9 +-
 fs/eventpoll.c                                              |    4 -
 fs/io_uring.c                                               |    2=20
 fs/nfsd/nfs4state.c                                         |    2=20
 fs/select.c                                                 |   18 +---
 fs/userfaultfd.c                                            |   42 ++++++-=
---
 include/linux/signal.h                                      |    2=20
 kernel/cgroup/cpuset.c                                      |   15 +++
 kernel/livepatch/core.c                                     |    6 +
 kernel/ptrace.c                                             |    4 -
 kernel/signal.c                                             |    5 -
 kernel/trace/ftrace.c                                       |   12 +--
 kernel/trace/trace.c                                        |   10 +-
 lib/idr.c                                                   |   14 +++
 lib/mpi/mpi-pow.c                                           |    6 -
 mm/mlock.c                                                  |    4 -
 mm/page_io.c                                                |   13 ++-
 mm/vmscan.c                                                 |   27 +++----
 net/bluetooth/l2cap_core.c                                  |    2=20
 net/netfilter/nf_flow_table_ip.c                            |    3=20
 net/netfilter/nft_flow_offload.c                            |   31 +++++---
 net/sunrpc/xprtrdma/svc_rdma_transport.c                    |    7 +
 scripts/decode_stacktrace.sh                                |    2=20
 sound/core/seq/oss/seq_oss_ioctl.c                          |    2=20
 sound/core/seq/oss/seq_oss_rw.c                             |    2=20
 sound/firewire/amdtp-am824.c                                |    2=20
 sound/hda/ext/hdac_ext_bus.c                                |    1=20
 sound/pci/hda/hda_codec.c                                   |    9 ++
 sound/pci/hda/patch_realtek.c                               |    8 +-
 sound/soc/codecs/ak4458.c                                   |   18 ++--
 sound/soc/codecs/cs4265.c                                   |    2=20
 sound/soc/codecs/max98090.c                                 |   16 ++++
 sound/soc/codecs/rt274.c                                    |    3=20
 sound/soc/codecs/rt5670.c                                   |   12 +++
 sound/soc/intel/atom/sst/sst_pvt.c                          |    4 -
 sound/soc/intel/boards/bytcht_es8316.c                      |    2=20
 sound/soc/intel/boards/cht_bsw_max98090_ti.c                |    2=20
 sound/soc/intel/boards/cht_bsw_nau8824.c                    |    2=20
 sound/soc/intel/boards/cht_bsw_rt5672.c                     |    2=20
 sound/soc/intel/common/soc-acpi-intel-byt-match.c           |   17 ++++
 sound/soc/soc-core.c                                        |   29 +++----
 sound/soc/soc-pcm.c                                         |    3=20
 sound/soc/sunxi/sun4i-i2s.c                                 |    6 +
 sound/usb/line6/pcm.c                                       |    5 +
 sound/usb/mixer_quirks.c                                    |    4 -
 tools/testing/radix-tree/idr-test.c                         |   46 +++++++=
+++++
 99 files changed, 569 insertions(+), 253 deletions(-)

Alex Deucher (1):
      drm/amdgpu/gfx9: use reset default for PA_SC_FIFO_SIZE

Alex Levin (1):
      ASoC: Intel: sst: fix kmalloc call with wrong flags

Alexandre Belloni (1):
      usb: gadget: udc: lpc32xx: allocate descriptor with GFP_ATOMIC

Amadeusz S=C5=82awi=C5=84ski (2):
      ALSA: hdac: fix memory release for SST and SOF drivers
      SoC: rt274: Fix internal jack assignment in set_jack callback

Andrzej Pietrasiewicz (1):
      usb: gadget: dwc2: fix zlp handling

Ard Biesheuvel (1):
      arm64: kaslr: keep modules inside module region when KASAN is enabled

B=C5=82a=C5=BCej Szczygie=C5=82 (1):
      HID: a4tech: fix horizontal scrolling

Cedric Hombourger (1):
      MIPS: have "plain" make calls build dtbs for selected platforms

Chris Wilson (1):
      drm/i915/ringbuffer: EMIT_INVALIDATE *before* switch context

Chuck Lever (1):
      svcrdma: Ignore source port when computing DRC hash

Colin Ian King (2):
      ALSA: seq: fix incorrect order of dest_client/dest_ports arguments
      ALSA: usb-audio: fix sign unintended sign extension on left shifts

Dan Carpenter (1):
      dmaengine: jz4780: Fix an endian bug in IRQ handler

Dennis Wassenberg (1):
      ALSA: hda/realtek - Change front mic location for Lenovo M710q

Dmitry Korotin (1):
      MIPS: Add missing EHB in mtc0 -> mfc0 sequence.

Don Brace (1):
      scsi: hpsa: correct ioaccel2 chaining

Eiichi Tsukata (1):
      tracing/snapshot: Resize spare buffer if size changed

Eric Biggers (2):
      crypto: user - prevent operating on larval algorithms
      fs/userfaultfd.c: disable irqs for fault_pending and event locks

Evan Quan (1):
      drm/amd/powerplay: use hardware fan control if no powerplay fan table

Florian Westphal (4):
      netfilter: nf_flow_table: ignore DF bit setting
      netfilter: nft_flow_offload: set liberal tracking mode for tcp
      netfilter: nft_flow_offload: don't offload when sequence numbers need=
 adjustment
      netfilter: nft_flow_offload: IPCB is only valid for ipv4 family

Geert Uytterhoeven (1):
      fs: VALIDATE_FS_PARSER should default to n

Gerd Hoffmann (1):
      drm/virtio: move drm_connector_update_edid_property() call

Greg Kroah-Hartman (1):
      Linux 5.1.17

H. Nikolaus Schaller (1):
      gpio: pca953x: hack to fix 24 bit gpio expanders

Hans de Goede (3):
      drm: panel-orientation-quirks: Add quirk for GPD pocket2
      drm: panel-orientation-quirks: Add quirk for GPD MicroPC
      platform/x86: asus-wmi: Only Tell EC the OS will handle display hotke=
ys from asus_nb_wmi

Hauke Mehrtens (1):
      MIPS: Fix bounds check virt_addr_valid

Herbert Xu (1):
      lib/mpi: Fix karactx leak in mpi_powm

Hsin-Yi Wang (5):
      drm/mediatek: fix unbind functions
      drm/mediatek: unbind components in mtk_drm_unbind()
      drm/mediatek: call drm_atomic_helper_shutdown() when unbinding driver
      drm/mediatek: clear num_pipes when unbind driver
      drm/mediatek: call mtk_dsi_stop() after mtk_drm_crtc_atomic_disable()

Jan Kara (1):
      dax: Fix xarray entry association for mixed mappings

Jann Horn (1):
      ptrace: Fix ->ptracer_cred handling for PTRACE_TRACEME

Joel Savitz (1):
      cpuset: restore sanity to cpuset_cpus_allowed_fallback()

Josh Poimboeuf (1):
      module: Fix livepatch/ftrace module text permissions race

Joshua Scott (1):
      ARM: dts: armada-xp-98dx3236: Switch to armada-38x-uart serial node

Kai-Heng Feng (1):
      HID: i2c-hid: add iBall Aer3 to descriptor override

Kan Liang (1):
      x86/CPU: Add more Icelake model numbers

Kov=C3=A1cs Tam=C3=A1s (1):
      ASoC: Intel: Baytrail: add quirk for Aegex 10 (RU2) tablet

Libin Yang (1):
      ASoC: soc-pcm: BE dai needs prepare when pause release after resume

Linus Torvalds (1):
      tty: rocket: fix incorrect forward declaration of 'rp_init()'

Linus Walleij (1):
      i2c: pca-platform: Fix GPIO lookup code

Lu Baolu (1):
      iommu/vt-d: Set the right field for Page Walk Snoop

Lucas Stach (1):
      drm/etnaviv: add missing failure path to destroy suballoc

Lyude Paul (1):
      drm/amdgpu: Don't skip display settings in hwmgr_resume()

Manuel Traut (1):
      scripts/decode_stacktrace.sh: prefix addr2line with $CROSS_COMPILE

Marcus Cooper (2):
      ASoC: sun4i-i2s: Fix sun8i tx channel offset mask
      ASoC: sun4i-i2s: Add offset to RX channel select

Martin Schwidefsky (1):
      s390/mm: fix pxd_bad with folded page tables

Mathew King (1):
      platform/x86: intel-vbtn: Report switch events when event wakes device

Matias Karhumaa (1):
      Bluetooth: Fix faulty expression for minimum encryption key size check

Matt Flax (1):
      ASoC : cs4265 : readable register too low

Matthew Wilcox (Oracle) (1):
      idr: Fix idr_get_next race with idr_remove

Nikolay Borisov (1):
      btrfs: Ensure replaced device doesn't have pending chunk allocation

Oleg Nesterov (2):
      signal: remove the wrong signal_pending() check in restore_user_sigma=
sk()
      swap_readpage(): avoid blk_wake_io_task() if !synchronous

Paolo Bonzini (1):
      KVM: x86: degrade WARN to pr_warn_ratelimited

Paul Menzel (1):
      nfsd: Fix overflow causing non-working mounts on 1 TB machines

Petr Mladek (1):
      ftrace/x86: Remove possible deadlock between register_kprobe() and ft=
race_run_update_code()

Pierre-Louis Bossart (4):
      ASoC: Intel: cht_bsw_max98090: fix kernel oops with platform_name ove=
rride
      ASoC: Intel: bytcht_es8316: fix kernel oops with platform_name overri=
de
      ASoC: Intel: cht_bsw_nau8824: fix kernel oops with platform_name over=
ride
      ASoC: Intel: cht_bsw_rt5672: fix kernel oops with platform_name overr=
ide

Ranjani Sridharan (3):
      ASoC: core: lock client_mutex while removing link components
      ASoC: hda: fix unbalanced codec dev refcount for HDA_DEV_ASOC
      ASoC: core: Fix deadlock in snd_soc_instantiate_card()

Richard Sailer (1):
      ALSA: hda/realtek: Add quirks for several Clevo notebook barebones

Robert Beckett (2):
      drm/imx: notify drm core before sending event during crtc disable
      drm/imx: only send event on crtc disable if kept disabled

Robin Gong (1):
      dmaengine: imx-sdma: remove BD_INTR for channel0

Roman Bolshakov (1):
      scsi: target/iblock: Fix overrun in WRITE SAME emulation

Shakeel Butt (1):
      mm/vmscan.c: prevent useless kswapd loops

Sricharan R (1):
      dmaengine: qcom: bam_dma: Fix completed descriptors count

Takashi Iwai (1):
      ALSA: line6: Fix write on zero-sized buffer

Takashi Sakamoto (1):
      ALSA: firewire-lib/fireworks: fix miss detection of received MIDI mes=
sages

Tzung-Bi Shih (1):
      ASoC: core: move DAI pre-links initiation to snd_soc_instantiate_card

Vadim Pasternak (2):
      platform/x86: mlx-platform: Fix parent device in i2c-mux-reg device r=
egistration
      platform/mellanox: mlxreg-hotplug: Add devm_free_irq call to remove f=
low

Vasily Gorbik (1):
      tracing: avoid build warning with HAVE_NOP_MCOUNT

Vincent Whitchurch (1):
      crypto: cryptd - Fix skcipher instance memory leak

Viorel Suman (2):
      ASoC: ak4458: add return value for ak4458_probe
      ASoC: ak4458: rstn_control - return a non-zero on error only

Wanpeng Li (1):
      KVM: LAPIC: Fix pending interrupt in IRR blocked by software disable =
LAPIC

Wei Li (1):
      ftrace: Fix NULL pointer dereference in free_ftrace_func_mapper()

Will Deacon (1):
      arm64: tlbflush: Ensure start/end of address range are aligned to str=
ide

Young Xiao (1):
      usb: gadget: fusb300_udc: Fix memory leak of fusb300->ep[i]

Yu-Hsuan Hsu (1):
      ASoC: max98090: remove 24-bit format support if RJ is 0

YueHaibing (1):
      spi: bitbang: Fix NULL pointer dereference in spi_unregister_master

swkhack (1):
      mm/mlock.c: change count_mm_mlocked_page_nr return type


--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0l4WsACgkQONu9yGCS
aT4VhBAAi+OPRgBcRLcZP8ww4vZ0NBoRJOvKkPs6PMFNc9FgQRLkPyroI8x38WJa
pmS3HMIl1BuOcrrXMYp9+6TFLzr36KhRpr2+FxlFybER/9x8FWKwyHS7INrXufhM
hztUoP7uGbct055xinAXXI56H5b6Ki6Wx9tenUADhpn9vInojWy5+MEk+jL4bSYJ
Phdxbn1MO9U6cUu5Sx3z1BQxElIhruaKbTpRhy1PMB0nQ8V9p9zKEfGziwxfuiE7
iRVRp3/M3faOCbxIjixVeKVLGccnKJCViNAQUjlvxlKQT7TWYnF9+4KNZxRrvybr
mAG9YCcZEKK3g3rEjgW+gdnP/GtuU80IYu92F+KODlXVV5dDD4lSTCL25sLhA2MH
4BrJrqqxyH5HVWO9krfkr0b8TB0k098Rs4BPsJLBZufCwDg/yUdUXCV/gzfT/tfU
+C3payWcIxrsKiFFcyKuSSmEcsOHWJVXxatHQ4vaADu7eElnmIvZuszdtQ252BRW
xyjqacjcqWBq4l8L0oa0pmH3xk18LGJ1hYzZRCB0joIuBOMKkMkM/b4CKno+LMGE
xfqjhNP0yhzgjF5fUaccc36d3OQeNSpD+MWsK98r7c7nUsjSzHP3OG0TTXT7xZTN
6pSrTXIBz+OM7ejwGWVSkzjz6tCcveSmTHf0kW55O3dvvAg/IfM=
=gtGm
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
