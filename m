Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD86964829
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 16:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbfGJOVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 10:21:18 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39923 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbfGJOVS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 10:21:18 -0400
Received: by mail-pg1-f194.google.com with SMTP id u17so1340178pgi.6;
        Wed, 10 Jul 2019 07:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4LIphz64z5WNLGLmjUZIDztIgj/kf9Uxfy23kD+sLSU=;
        b=lVCuea18zXPGVhQJ539PH42Uvj5hJryVGkMJU/cJ3TXRhhg4V8tjy1cI67mSefFCgi
         wCxeVaKREyn82sedb3J3N5bOxpiNtbv/LRwwYyDcPpJhEYg/cG27fkYPi+bPDgfJPFL2
         fDRkAK8gnaJmcGHfwsw7ctP1w7jQdx7ipHU8po1Oqi/j/pOxukZDqOMrjRgu3FqxPSbs
         OeBUXlLlAuGJwe6Ye8HS+naPONRZ5z24YH0XzZbLUMJtSCYgYZLyJYuwEBuX8S/zXDUL
         AEVooNsbhU0PQ1rOTP+kpndGyNF2eHmcLTY3A0qMtgywpxx3Td+9fufQ9XsfnLdS2WUx
         MtAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4LIphz64z5WNLGLmjUZIDztIgj/kf9Uxfy23kD+sLSU=;
        b=RyWefBWPwP64h80yNQR+89f6SJsX6FE+DPK6uH2pEaXCCwqSw6G1LZYWs0bIMEBKcs
         vJQjNVA6zwiPuh3rfzdjsAFWSkX+ZHVVTOOU5lDZmTkokRQ0xJsyditfM4HDiXKRSDms
         KtGK7r/QV6TF0rCB6ntzFsZmX1QjDNovcUFVDGtpXLCQrZ5rtT2P0r7oeQkScJ4c+MGT
         2ZPYNDUpvLZ7U7fNZfRhUs54w2f0srqNoemIItPeVh5AsaiuolFLtRLtjuych1L2jpLR
         4FXbgJ6bdjs54RAh+eeiIQbevjd1rMDoy0Edd3cwddkuI6RJhK8r2InSGcvufGw1MAtU
         S+7w==
X-Gm-Message-State: APjAAAWs2k3YEDBsFO3YtsAclZmVBsbyAX5MiQrmDdquT8SBBwZ+LAXn
        0/RKQlFkbLk1SBlzmiNPqKY=
X-Google-Smtp-Source: APXvYqy2E+9pqcjFjYPvOoa0PeT09vnr3Lk5d1paMpzNSZ6Kyj9KDglAiKuPqC11RVXbAcDQBctE1g==
X-Received: by 2002:a17:90a:290b:: with SMTP id g11mr7367230pjd.122.1562768477609;
        Wed, 10 Jul 2019 07:21:17 -0700 (PDT)
Received: from ArchLinux ([103.231.90.174])
        by smtp.gmail.com with ESMTPSA id w1sm2136736pjt.30.2019.07.10.07.21.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 07:21:16 -0700 (PDT)
Date:   Wed, 10 Jul 2019 19:51:02 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.1.17
Message-ID: <20190710142102.GA10520@ArchLinux>
References: <20190710130027.GA17677@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <20190710130027.GA17677@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



Thanks,a bunch Greg!

On 15:00 Wed 10 Jul , Greg KH wrote:
>I'm announcing the release of the 5.1.17 kernel.
>
>All users of the 5.1 kernel series must upgrade.
>
>The updated 5.1.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git lin=
ux-5.1.y
>and can be browsed at the normal kernel.org git web browser:
>	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3D=
summary
>
>thanks,
>
>greg k-h
>
>------------
>
> Makefile                                                    |    2
> arch/arm/boot/dts/armada-xp-98dx3236.dtsi                   |    8 ++
> arch/arm64/include/asm/tlbflush.h                           |    3
> arch/arm64/kernel/module.c                                  |    8 +-
> arch/mips/Makefile                                          |    3
> arch/mips/mm/mmap.c                                         |    2
> arch/mips/mm/tlbex.c                                        |   29 +++++--
> arch/s390/include/asm/pgtable.h                             |   33 ++++--=
--
> arch/x86/include/asm/intel-family.h                         |    3
> arch/x86/kernel/ftrace.c                                    |    3
> arch/x86/kvm/lapic.c                                        |    2
> arch/x86/kvm/x86.c                                          |    6 -
> crypto/cryptd.c                                             |    1
> crypto/crypto_user_base.c                                   |    3
> drivers/dma/dma-jz4780.c                                    |    5 -
> drivers/dma/imx-sdma.c                                      |    4 -
> drivers/dma/qcom/bam_dma.c                                  |    3
> drivers/gpio/gpio-pca953x.c                                 |    3
> drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                       |   19 ----
> drivers/gpu/drm/amd/powerplay/hwmgr/hwmgr.c                 |    2
> drivers/gpu/drm/amd/powerplay/hwmgr/process_pptables_v1_0.c |    4 -
> drivers/gpu/drm/amd/powerplay/inc/hwmgr.h                   |    1
> drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smumgr.c     |    4 +
> drivers/gpu/drm/drm_panel_orientation_quirks.c              |   32 ++++++=
++
> drivers/gpu/drm/etnaviv/etnaviv_gpu.c                       |    7 +
> drivers/gpu/drm/i915/intel_ringbuffer.c                     |    6 -
> drivers/gpu/drm/imx/ipuv3-crtc.c                            |    6 -
> drivers/gpu/drm/mediatek/mtk_drm_drv.c                      |    8 --
> drivers/gpu/drm/mediatek/mtk_dsi.c                          |   12 ++-
> drivers/gpu/drm/virtio/virtgpu_vq.c                         |    2
> drivers/hid/hid-a4tech.c                                    |   11 ++
> drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c                    |    8 ++
> drivers/i2c/busses/i2c-pca-platform.c                       |    3
> drivers/iommu/intel-pasid.c                                 |    2
> drivers/platform/mellanox/mlxreg-hotplug.c                  |    1
> drivers/platform/x86/asus-nb-wmi.c                          |    8 ++
> drivers/platform/x86/asus-wmi.c                             |    2
> drivers/platform/x86/asus-wmi.h                             |    1
> drivers/platform/x86/intel-vbtn.c                           |   16 +++-
> drivers/platform/x86/mlx-platform.c                         |    2
> drivers/scsi/hpsa.c                                         |    7 +
> drivers/scsi/hpsa_cmd.h                                     |    1
> drivers/spi/spi-bitbang.c                                   |    2
> drivers/target/target_core_iblock.c                         |    2
> drivers/tty/rocket.c                                        |    2
> drivers/usb/dwc2/gadget.c                                   |   20 +++--
> drivers/usb/gadget/udc/fusb300_udc.c                        |    5 +
> drivers/usb/gadget/udc/lpc32xx_udc.c                        |    3
> fs/Kconfig                                                  |    1
> fs/aio.c                                                    |   28 +++++--
> fs/btrfs/dev-replace.c                                      |   26 ++++--
> fs/btrfs/volumes.c                                          |    5 +
> fs/btrfs/volumes.h                                          |    5 +
> fs/dax.c                                                    |    9 +-
> fs/eventpoll.c                                              |    4 -
> fs/io_uring.c                                               |    2
> fs/nfsd/nfs4state.c                                         |    2
> fs/select.c                                                 |   18 +---
> fs/userfaultfd.c                                            |   42 ++++++=
----
> include/linux/signal.h                                      |    2
> kernel/cgroup/cpuset.c                                      |   15 +++
> kernel/livepatch/core.c                                     |    6 +
> kernel/ptrace.c                                             |    4 -
> kernel/signal.c                                             |    5 -
> kernel/trace/ftrace.c                                       |   12 +--
> kernel/trace/trace.c                                        |   10 +-
> lib/idr.c                                                   |   14 +++
> lib/mpi/mpi-pow.c                                           |    6 -
> mm/mlock.c                                                  |    4 -
> mm/page_io.c                                                |   13 ++-
> mm/vmscan.c                                                 |   27 +++----
> net/bluetooth/l2cap_core.c                                  |    2
> net/netfilter/nf_flow_table_ip.c                            |    3
> net/netfilter/nft_flow_offload.c                            |   31 +++++-=
--
> net/sunrpc/xprtrdma/svc_rdma_transport.c                    |    7 +
> scripts/decode_stacktrace.sh                                |    2
> sound/core/seq/oss/seq_oss_ioctl.c                          |    2
> sound/core/seq/oss/seq_oss_rw.c                             |    2
> sound/firewire/amdtp-am824.c                                |    2
> sound/hda/ext/hdac_ext_bus.c                                |    1
> sound/pci/hda/hda_codec.c                                   |    9 ++
> sound/pci/hda/patch_realtek.c                               |    8 +-
> sound/soc/codecs/ak4458.c                                   |   18 ++--
> sound/soc/codecs/cs4265.c                                   |    2
> sound/soc/codecs/max98090.c                                 |   16 ++++
> sound/soc/codecs/rt274.c                                    |    3
> sound/soc/codecs/rt5670.c                                   |   12 +++
> sound/soc/intel/atom/sst/sst_pvt.c                          |    4 -
> sound/soc/intel/boards/bytcht_es8316.c                      |    2
> sound/soc/intel/boards/cht_bsw_max98090_ti.c                |    2
> sound/soc/intel/boards/cht_bsw_nau8824.c                    |    2
> sound/soc/intel/boards/cht_bsw_rt5672.c                     |    2
> sound/soc/intel/common/soc-acpi-intel-byt-match.c           |   17 ++++
> sound/soc/soc-core.c                                        |   29 +++----
> sound/soc/soc-pcm.c                                         |    3
> sound/soc/sunxi/sun4i-i2s.c                                 |    6 +
> sound/usb/line6/pcm.c                                       |    5 +
> sound/usb/mixer_quirks.c                                    |    4 -
> tools/testing/radix-tree/idr-test.c                         |   46 ++++++=
++++++
> 99 files changed, 569 insertions(+), 253 deletions(-)
>
>Alex Deucher (1):
>      drm/amdgpu/gfx9: use reset default for PA_SC_FIFO_SIZE
>
>Alex Levin (1):
>      ASoC: Intel: sst: fix kmalloc call with wrong flags
>
>Alexandre Belloni (1):
>      usb: gadget: udc: lpc32xx: allocate descriptor with GFP_ATOMIC
>
>Amadeusz S=C5=82awi=C5=84ski (2):
>      ALSA: hdac: fix memory release for SST and SOF drivers
>      SoC: rt274: Fix internal jack assignment in set_jack callback
>
>Andrzej Pietrasiewicz (1):
>      usb: gadget: dwc2: fix zlp handling
>
>Ard Biesheuvel (1):
>      arm64: kaslr: keep modules inside module region when KASAN is enabled
>
>B=C5=82a=C5=BCej Szczygie=C5=82 (1):
>      HID: a4tech: fix horizontal scrolling
>
>Cedric Hombourger (1):
>      MIPS: have "plain" make calls build dtbs for selected platforms
>
>Chris Wilson (1):
>      drm/i915/ringbuffer: EMIT_INVALIDATE *before* switch context
>
>Chuck Lever (1):
>      svcrdma: Ignore source port when computing DRC hash
>
>Colin Ian King (2):
>      ALSA: seq: fix incorrect order of dest_client/dest_ports arguments
>      ALSA: usb-audio: fix sign unintended sign extension on left shifts
>
>Dan Carpenter (1):
>      dmaengine: jz4780: Fix an endian bug in IRQ handler
>
>Dennis Wassenberg (1):
>      ALSA: hda/realtek - Change front mic location for Lenovo M710q
>
>Dmitry Korotin (1):
>      MIPS: Add missing EHB in mtc0 -> mfc0 sequence.
>
>Don Brace (1):
>      scsi: hpsa: correct ioaccel2 chaining
>
>Eiichi Tsukata (1):
>      tracing/snapshot: Resize spare buffer if size changed
>
>Eric Biggers (2):
>      crypto: user - prevent operating on larval algorithms
>      fs/userfaultfd.c: disable irqs for fault_pending and event locks
>
>Evan Quan (1):
>      drm/amd/powerplay: use hardware fan control if no powerplay fan table
>
>Florian Westphal (4):
>      netfilter: nf_flow_table: ignore DF bit setting
>      netfilter: nft_flow_offload: set liberal tracking mode for tcp
>      netfilter: nft_flow_offload: don't offload when sequence numbers nee=
d adjustment
>      netfilter: nft_flow_offload: IPCB is only valid for ipv4 family
>
>Geert Uytterhoeven (1):
>      fs: VALIDATE_FS_PARSER should default to n
>
>Gerd Hoffmann (1):
>      drm/virtio: move drm_connector_update_edid_property() call
>
>Greg Kroah-Hartman (1):
>      Linux 5.1.17
>
>H. Nikolaus Schaller (1):
>      gpio: pca953x: hack to fix 24 bit gpio expanders
>
>Hans de Goede (3):
>      drm: panel-orientation-quirks: Add quirk for GPD pocket2
>      drm: panel-orientation-quirks: Add quirk for GPD MicroPC
>      platform/x86: asus-wmi: Only Tell EC the OS will handle display hotk=
eys from asus_nb_wmi
>
>Hauke Mehrtens (1):
>      MIPS: Fix bounds check virt_addr_valid
>
>Herbert Xu (1):
>      lib/mpi: Fix karactx leak in mpi_powm
>
>Hsin-Yi Wang (5):
>      drm/mediatek: fix unbind functions
>      drm/mediatek: unbind components in mtk_drm_unbind()
>      drm/mediatek: call drm_atomic_helper_shutdown() when unbinding driver
>      drm/mediatek: clear num_pipes when unbind driver
>      drm/mediatek: call mtk_dsi_stop() after mtk_drm_crtc_atomic_disable()
>
>Jan Kara (1):
>      dax: Fix xarray entry association for mixed mappings
>
>Jann Horn (1):
>      ptrace: Fix ->ptracer_cred handling for PTRACE_TRACEME
>
>Joel Savitz (1):
>      cpuset: restore sanity to cpuset_cpus_allowed_fallback()
>
>Josh Poimboeuf (1):
>      module: Fix livepatch/ftrace module text permissions race
>
>Joshua Scott (1):
>      ARM: dts: armada-xp-98dx3236: Switch to armada-38x-uart serial node
>
>Kai-Heng Feng (1):
>      HID: i2c-hid: add iBall Aer3 to descriptor override
>
>Kan Liang (1):
>      x86/CPU: Add more Icelake model numbers
>
>Kov=C3=A1cs Tam=C3=A1s (1):
>      ASoC: Intel: Baytrail: add quirk for Aegex 10 (RU2) tablet
>
>Libin Yang (1):
>      ASoC: soc-pcm: BE dai needs prepare when pause release after resume
>
>Linus Torvalds (1):
>      tty: rocket: fix incorrect forward declaration of 'rp_init()'
>
>Linus Walleij (1):
>      i2c: pca-platform: Fix GPIO lookup code
>
>Lu Baolu (1):
>      iommu/vt-d: Set the right field for Page Walk Snoop
>
>Lucas Stach (1):
>      drm/etnaviv: add missing failure path to destroy suballoc
>
>Lyude Paul (1):
>      drm/amdgpu: Don't skip display settings in hwmgr_resume()
>
>Manuel Traut (1):
>      scripts/decode_stacktrace.sh: prefix addr2line with $CROSS_COMPILE
>
>Marcus Cooper (2):
>      ASoC: sun4i-i2s: Fix sun8i tx channel offset mask
>      ASoC: sun4i-i2s: Add offset to RX channel select
>
>Martin Schwidefsky (1):
>      s390/mm: fix pxd_bad with folded page tables
>
>Mathew King (1):
>      platform/x86: intel-vbtn: Report switch events when event wakes devi=
ce
>
>Matias Karhumaa (1):
>      Bluetooth: Fix faulty expression for minimum encryption key size che=
ck
>
>Matt Flax (1):
>      ASoC : cs4265 : readable register too low
>
>Matthew Wilcox (Oracle) (1):
>      idr: Fix idr_get_next race with idr_remove
>
>Nikolay Borisov (1):
>      btrfs: Ensure replaced device doesn't have pending chunk allocation
>
>Oleg Nesterov (2):
>      signal: remove the wrong signal_pending() check in restore_user_sigm=
ask()
>      swap_readpage(): avoid blk_wake_io_task() if !synchronous
>
>Paolo Bonzini (1):
>      KVM: x86: degrade WARN to pr_warn_ratelimited
>
>Paul Menzel (1):
>      nfsd: Fix overflow causing non-working mounts on 1 TB machines
>
>Petr Mladek (1):
>      ftrace/x86: Remove possible deadlock between register_kprobe() and f=
trace_run_update_code()
>
>Pierre-Louis Bossart (4):
>      ASoC: Intel: cht_bsw_max98090: fix kernel oops with platform_name ov=
erride
>      ASoC: Intel: bytcht_es8316: fix kernel oops with platform_name overr=
ide
>      ASoC: Intel: cht_bsw_nau8824: fix kernel oops with platform_name ove=
rride
>      ASoC: Intel: cht_bsw_rt5672: fix kernel oops with platform_name over=
ride
>
>Ranjani Sridharan (3):
>      ASoC: core: lock client_mutex while removing link components
>      ASoC: hda: fix unbalanced codec dev refcount for HDA_DEV_ASOC
>      ASoC: core: Fix deadlock in snd_soc_instantiate_card()
>
>Richard Sailer (1):
>      ALSA: hda/realtek: Add quirks for several Clevo notebook barebones
>
>Robert Beckett (2):
>      drm/imx: notify drm core before sending event during crtc disable
>      drm/imx: only send event on crtc disable if kept disabled
>
>Robin Gong (1):
>      dmaengine: imx-sdma: remove BD_INTR for channel0
>
>Roman Bolshakov (1):
>      scsi: target/iblock: Fix overrun in WRITE SAME emulation
>
>Shakeel Butt (1):
>      mm/vmscan.c: prevent useless kswapd loops
>
>Sricharan R (1):
>      dmaengine: qcom: bam_dma: Fix completed descriptors count
>
>Takashi Iwai (1):
>      ALSA: line6: Fix write on zero-sized buffer
>
>Takashi Sakamoto (1):
>      ALSA: firewire-lib/fireworks: fix miss detection of received MIDI me=
ssages
>
>Tzung-Bi Shih (1):
>      ASoC: core: move DAI pre-links initiation to snd_soc_instantiate_card
>
>Vadim Pasternak (2):
>      platform/x86: mlx-platform: Fix parent device in i2c-mux-reg device =
registration
>      platform/mellanox: mlxreg-hotplug: Add devm_free_irq call to remove =
flow
>
>Vasily Gorbik (1):
>      tracing: avoid build warning with HAVE_NOP_MCOUNT
>
>Vincent Whitchurch (1):
>      crypto: cryptd - Fix skcipher instance memory leak
>
>Viorel Suman (2):
>      ASoC: ak4458: add return value for ak4458_probe
>      ASoC: ak4458: rstn_control - return a non-zero on error only
>
>Wanpeng Li (1):
>      KVM: LAPIC: Fix pending interrupt in IRR blocked by software disable=
 LAPIC
>
>Wei Li (1):
>      ftrace: Fix NULL pointer dereference in free_ftrace_func_mapper()
>
>Will Deacon (1):
>      arm64: tlbflush: Ensure start/end of address range are aligned to st=
ride
>
>Young Xiao (1):
>      usb: gadget: fusb300_udc: Fix memory leak of fusb300->ep[i]
>
>Yu-Hsuan Hsu (1):
>      ASoC: max98090: remove 24-bit format support if RJ is 0
>
>YueHaibing (1):
>      spi: bitbang: Fix NULL pointer dereference in spi_unregister_master
>
>swkhack (1):
>      mm/mlock.c: change count_mm_mlocked_page_nr return type
>



--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl0l9EoACgkQsjqdtxFL
KRWxBwf7ByJzSDjc41LsnQmZ2U07ZtvWk9FCimRv2k+crapcwkyiW6b+TtvdoynQ
lyq66o9C+YZK2v7eop9hDqjJoi9zGtVv0qY9aJaf5xlF9/oUHyR1NfqgeNhmIbrf
4tPfgnRQ7lD0NRfmq7JcfYSnqWvb2ubbwiyJNkKy7Q8kuuGqwksNRhHH2GiGUIcp
6dy0cvm5n0/KU7z0NlCVESGVQdoF+HqiwtlKcfXnNgCukSIVYA32VCivd2Btvn8c
JcjFLMg3SjTlXktuY9VR0WpNNEoCylZBZX/AATSIsBThWamEvoupdAksw5Xt4m9i
rieXyLXuY9bTgm/XKPXTPbUhobv6uA==
=ILjO
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
