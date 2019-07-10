Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE26646A7
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 15:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfGJNAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 09:00:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727421AbfGJNAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 09:00:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AE2B2084B;
        Wed, 10 Jul 2019 13:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562763608;
        bh=nW60n256p38QfKb4m+3sYjj1tSFQoPLPqtb36WqsHg0=;
        h=Date:From:To:Cc:Subject:From;
        b=wCVgOgs1SwS/QOXUod/d5LwGmGQU6wZIpHlPmpf6TP+9Ohd0NPGpe01G4CsBunoCT
         KRdP5RP9dgRjsisBgSeykEBLdIJVHN4fl9GhoSHggHR52AR6zGZDoSaZY3csYCfPcu
         pKz2fT1tvnUrv9+Co4Muu95O6vMfnbVEfMzHGaVU=
Date:   Wed, 10 Jul 2019 15:00:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.58
Message-ID: <20190710130004.GA15450@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.58 kernel.

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

 Makefile                                                    |    2=20
 arch/arm/boot/dts/armada-xp-98dx3236.dtsi                   |    8 ++
 arch/arm64/kernel/module.c                                  |    8 +-
 arch/mips/Makefile                                          |    3=20
 arch/mips/mm/mmap.c                                         |    2=20
 arch/mips/mm/tlbex.c                                        |   29 +++++---
 arch/x86/boot/compressed/head_64.S                          |    2=20
 arch/x86/include/asm/intel-family.h                         |    3=20
 arch/x86/kernel/ftrace.c                                    |    3=20
 arch/x86/kvm/lapic.c                                        |    2=20
 arch/x86/kvm/x86.c                                          |    6 -
 block/blk-core.c                                            |    5 -
 crypto/cryptd.c                                             |    1=20
 crypto/crypto_user.c                                        |    3=20
 drivers/dma/imx-sdma.c                                      |    4 -
 drivers/dma/qcom/bam_dma.c                                  |    3=20
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                       |   19 -----
 drivers/gpu/drm/amd/powerplay/hwmgr/process_pptables_v1_0.c |    4 -
 drivers/gpu/drm/amd/powerplay/inc/hwmgr.h                   |    1=20
 drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smumgr.c     |    4 +
 drivers/gpu/drm/drm_fb_helper.c                             |    6 +
 drivers/gpu/drm/drm_panel_orientation_quirks.c              |   32 +++++++=
++
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c                       |    7 +-
 drivers/gpu/drm/i915/intel_csr.c                            |   18 +++++
 drivers/gpu/drm/imx/ipuv3-crtc.c                            |    6 -
 drivers/gpu/drm/mediatek/mtk_drm_drv.c                      |    8 --
 drivers/gpu/drm/mediatek/mtk_dsi.c                          |   12 +++
 drivers/i2c/busses/i2c-pca-platform.c                       |    3=20
 drivers/md/raid0.c                                          |    2=20
 drivers/media/platform/s5p-mfc/s5p_mfc.c                    |    1=20
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c          |    5 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c              |   10 ++
 drivers/platform/mellanox/mlxreg-hotplug.c                  |    1=20
 drivers/platform/x86/asus-nb-wmi.c                          |    8 ++
 drivers/platform/x86/asus-wmi.c                             |    2=20
 drivers/platform/x86/asus-wmi.h                             |    1=20
 drivers/platform/x86/intel-vbtn.c                           |   16 ++++
 drivers/platform/x86/mlx-platform.c                         |    2=20
 drivers/scsi/hpsa.c                                         |    7 +-
 drivers/scsi/hpsa_cmd.h                                     |    1=20
 drivers/spi/spi-bitbang.c                                   |    2=20
 drivers/target/target_core_user.c                           |    3=20
 drivers/tty/rocket.c                                        |    2=20
 drivers/tty/serial/sc16is7xx.c                              |    2=20
 drivers/usb/gadget/udc/fusb300_udc.c                        |    5 +
 drivers/usb/gadget/udc/lpc32xx_udc.c                        |    3=20
 fs/btrfs/dev-replace.c                                      |   26 ++++---
 fs/btrfs/volumes.c                                          |    2=20
 fs/btrfs/volumes.h                                          |    5 +
 fs/f2fs/debug.c                                             |   19 +++--
 fs/f2fs/super.c                                             |    5 +
 fs/nfsd/nfs4state.c                                         |    2=20
 fs/userfaultfd.c                                            |   42 +++++++=
-----
 include/linux/filter.h                                      |    2=20
 include/net/ipv6_frag.h                                     |    1=20
 kernel/bpf/core.c                                           |   21 ++++--
 kernel/cgroup/cpuset.c                                      |   15 ++++
 kernel/livepatch/core.c                                     |    6 +
 kernel/ptrace.c                                             |    4 -
 kernel/trace/ftrace.c                                       |   12 ++-
 kernel/trace/trace.c                                        |   10 +-
 lib/mpi/mpi-pow.c                                           |    6 -
 mm/mlock.c                                                  |    4 -
 mm/vmscan.c                                                 |   27 ++++---
 net/bluetooth/l2cap_core.c                                  |    2=20
 net/core/sysctl_net_core.c                                  |   20 ++++-
 net/ipv6/netfilter/nf_conntrack_reasm.c                     |   22 +++---
 net/mac80211/mesh_pathtbl.c                                 |    2=20
 net/netfilter/nf_flow_table_ip.c                            |    3=20
 net/netfilter/nft_flow_offload.c                            |   31 ++++++--
 net/rds/send.c                                              |    4 -
 net/smc/af_smc.c                                            |    6 -
 net/sunrpc/xprtrdma/svc_rdma_transport.c                    |    7 +-
 scripts/decode_stacktrace.sh                                |    2=20
 sound/core/seq/oss/seq_oss_ioctl.c                          |    2=20
 sound/core/seq/oss/seq_oss_rw.c                             |    2=20
 sound/firewire/amdtp-am824.c                                |    2=20
 sound/hda/ext/hdac_ext_bus.c                                |    1=20
 sound/pci/hda/hda_codec.c                                   |    1=20
 sound/pci/hda/patch_realtek.c                               |    8 +-
 sound/soc/codecs/ak4458.c                                   |   18 +++--
 sound/soc/codecs/cs4265.c                                   |    2=20
 sound/soc/codecs/max98090.c                                 |   16 ++++
 sound/soc/codecs/rt274.c                                    |    3=20
 sound/soc/soc-pcm.c                                         |    3=20
 sound/soc/sunxi/sun4i-i2s.c                                 |    6 +
 sound/usb/line6/pcm.c                                       |    5 +
 sound/usb/mixer_quirks.c                                    |    4 -
 tools/testing/selftests/net/fib_rule_tests.sh               |    4 -
 89 files changed, 465 insertions(+), 197 deletions(-)

Alex Deucher (1):
      drm/amdgpu/gfx9: use reset default for PA_SC_FIFO_SIZE

Alexandre Belloni (1):
      usb: gadget: udc: lpc32xx: allocate descriptor with GFP_ATOMIC

Amadeusz S=C5=82awi=C5=84ski (2):
      ALSA: hdac: fix memory release for SST and SOF drivers
      SoC: rt274: Fix internal jack assignment in set_jack callback

Ard Biesheuvel (1):
      arm64: kaslr: keep modules inside module region when KASAN is enabled

Cedric Hombourger (1):
      MIPS: have "plain" make calls build dtbs for selected platforms

Chuck Lever (1):
      svcrdma: Ignore source port when computing DRC hash

Colin Ian King (3):
      ALSA: seq: fix incorrect order of dest_client/dest_ports arguments
      ALSA: usb-audio: fix sign unintended sign extension on left shifts
      net: hns: fix unsigned comparison to less than zero

Daniel Borkmann (1):
      bpf: fix bpf_jit_limit knob for PAGE_SIZE >=3D 64K

David Ahern (1):
      selftests: fib_rule_tests: Fix icmp proto with ipv6

David S. Miller (1):
      rds: Fix warning.

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

Eric Dumazet (1):
      ip6: fix skb leak in ip6frag_expire_frag_queue()

Evan Quan (1):
      drm/amd/powerplay: use hardware fan control if no powerplay fan table

Florian Westphal (4):
      netfilter: nf_flow_table: ignore DF bit setting
      netfilter: nft_flow_offload: set liberal tracking mode for tcp
      netfilter: nft_flow_offload: don't offload when sequence numbers need=
 adjustment
      netfilter: nft_flow_offload: IPCB is only valid for ipv4 family

Greg Kroah-Hartman (1):
      Linux 4.19.58

Guilherme G. Piccoli (2):
      block: Fix a NULL pointer dereference in generic_make_request()
      md/raid0: Do not bypass blocking queue entered for raid0 bios

Guillaume Nault (2):
      netfilter: ipv6: nf_defrag: fix leakage of unqueued fragments
      netfilter: ipv6: nf_defrag: accept duplicate fragments again

Guoqing Jiang (1):
      sc16is7xx: move label 'err_spi' to correct section

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

Ido Schimmel (1):
      mlxsw: spectrum: Handle VLAN device unlinking

Jaegeuk Kim (1):
      f2fs: don't access node/meta inode mapping after iput

Jann Horn (1):
      ptrace: Fix ->ptracer_cred handling for PTRACE_TRACEME

Joel Savitz (1):
      cpuset: restore sanity to cpuset_cpus_allowed_fallback()

Josh Poimboeuf (1):
      module: Fix livepatch/ftrace module text permissions race

Joshua Scott (1):
      ARM: dts: armada-xp-98dx3236: Switch to armada-38x-uart serial node

Kan Liang (1):
      x86/CPU: Add more Icelake model numbers

Kirill A. Shutemov (1):
      x86/boot/compressed/64: Do not corrupt EDX on EFER.LME=3D1 setting

Libin Yang (1):
      ASoC: soc-pcm: BE dai needs prepare when pause release after resume

Linus Torvalds (1):
      tty: rocket: fix incorrect forward declaration of 'rp_init()'

Linus Walleij (1):
      i2c: pca-platform: Fix GPIO lookup code

Lucas De Marchi (1):
      drm/i915/dmc: protect against reading random memory

Lucas Stach (1):
      drm/etnaviv: add missing failure path to destroy suballoc

Manuel Traut (1):
      scripts/decode_stacktrace.sh: prefix addr2line with $CROSS_COMPILE

Marcus Cooper (2):
      ASoC: sun4i-i2s: Fix sun8i tx channel offset mask
      ASoC: sun4i-i2s: Add offset to RX channel select

Marek Szyprowski (1):
      media: s5p-mfc: fix incorrect bus assignment in virtual child device

Mathew King (1):
      platform/x86: intel-vbtn: Report switch events when event wakes device

Matias Karhumaa (1):
      Bluetooth: Fix faulty expression for minimum encryption key size check

Matt Flax (1):
      ASoC : cs4265 : readable register too low

Nikolay Borisov (1):
      btrfs: Ensure replaced device doesn't have pending chunk allocation

Noralf Tr=C3=B8nnes (1):
      drm/fb-helper: generic: Don't take module ref for fbcon

Paolo Bonzini (1):
      KVM: x86: degrade WARN to pr_warn_ratelimited

Paul Menzel (1):
      nfsd: Fix overflow causing non-working mounts on 1 TB machines

Petr Mladek (1):
      ftrace/x86: Remove possible deadlock between register_kprobe() and ft=
race_run_update_code()

Richard Sailer (1):
      ALSA: hda/realtek: Add quirks for several Clevo notebook barebones

Robert Beckett (2):
      drm/imx: notify drm core before sending event during crtc disable
      drm/imx: only send event on crtc disable if kept disabled

Robin Gong (1):
      dmaengine: imx-sdma: remove BD_INTR for channel0

Salil Mehta (1):
      net: hns: Fixes the missing put_device in positive leg for roce reset

Shakeel Butt (1):
      mm/vmscan.c: prevent useless kswapd loops

Sricharan R (1):
      dmaengine: qcom: bam_dma: Fix completed descriptors count

Takashi Iwai (2):
      ALSA: line6: Fix write on zero-sized buffer
      ALSA: hda: Initialize power_state field properly

Takashi Sakamoto (1):
      ALSA: firewire-lib/fireworks: fix miss detection of received MIDI mes=
sages

Ursula Braun (1):
      net/smc: move unhash before release of clcsock

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

Wei Yongjun (1):
      mac80211: mesh: fix missing unlock on error in table_path_del()

Xiubo Li (1):
      scsi: tcmu: fix use after free

Young Xiao (1):
      usb: gadget: fusb300_udc: Fix memory leak of fusb300->ep[i]

Yu-Hsuan Hsu (1):
      ASoC: max98090: remove 24-bit format support if RJ is 0

YueHaibing (1):
      spi: bitbang: Fix NULL pointer dereference in spi_unregister_master

swkhack (1):
      mm/mlock.c: change count_mm_mlocked_page_nr return type


--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0l4VQACgkQONu9yGCS
aT47Jg/+KjM6G0RCidSchvpzbTGx9uAPhjcaNqlLDWQ3/3Sdf7ttJJ5Mg95pJcyK
aDou3CO2mqTGF7K5QTH+yg5Lv+0DDs+xArefXal+qQniNLmOofcQrudSGV/hK54g
PnqRCmjqmZ370oBUumqCt7aiSskA5GTydCwEfNE6aHYOXN1KrG9Gu+YXv3y2wp37
Ijpd3enZRT264ZaL2DjQmUA3iHAFR1xX+kryTys8c2N0zABaRJdBEPvJEYixCGHa
ToHq+9vGHxSocD20oT9p2aDONNnARQu0s6f9+cRFz8bEBFlAn6EC4M2cT7/Mu0me
tiTj+EEDnfol0OqTLdaEVwLDipmjTCs+b4Z7+vTXVzMH2z239iUVyTFm6xWBt/Yp
9u7K8y4LZ5etiTYBgI7If92QnFa5YQ5UOViiqvV2wdvHBsCEJNQau9NPVl4l2s/w
DGMWRYNEfpcACdEmcHAyyIqFYHzprsDZnQjEc74mmEeatrv5vqba/nDmaMLmzYrC
akJA0PYUpO3OIik8V2FGJKkb7NtN6EwhOo8u+ZxyvIZmn8yIpaMRLGLYItVnAJoI
ERza5+p87vKGG2xS0Cy0nFkoejozB9lH97VOzqgmWQSTStnIaHO6oF44TOc0lB2G
cMj5hd/BPriUze5XTaS8jd9JgNLFvExYhQeat5T4rGcTLMfII2I=
=ZvSg
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
