Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB9B3A44A
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 10:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfFIIOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 04:14:12 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40492 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727552AbfFIIOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 04:14:11 -0400
Received: by mail-pg1-f195.google.com with SMTP id d30so3375911pgm.7;
        Sun, 09 Jun 2019 01:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hfbEm2zRDmR8xVA6iHI+xHbBF572jWCG5r05bnq/s+w=;
        b=Q7f5oO7XPr8LIRQrkdZVIwgeGnlMT16TPwbgF2qy1v9BiX51HdKrJMnmbzgj7DuEnZ
         iicdnuqBRM2Rkp+26fZ9YmUrX+pPSoOUu/fSB2eWZSi5DfaEMirj3+sv+ndTQLoYYfN4
         lNxW9CVrpNMFIlNCSWBvP7t1fyObe+dnGqGV8ZiFqGgF+c8mS5/ij3+K2e6Sc3Oy6AaU
         4OygCf/BATblVPRzBxWvmUuDVsvaocHmKVCTB/OLFWU7Vwmmqi+gqzXfU0d4PnMP2K0x
         aYDJvow7bDo+/TJ2QCcM37GhQprOqYEelPljwuYhkcxL2WBxAOjjjyRFvlTIK3RvpPG0
         hgag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hfbEm2zRDmR8xVA6iHI+xHbBF572jWCG5r05bnq/s+w=;
        b=REokKYTNbCy2WirCq7Qb13tKevrG8C5cdi1G1tZOt6yrKFC6d0zC6Y14BERoGqI0ah
         UmoeZqg+gCQFWZ4oRtD+GgkbqlWvLY7uyqEDfwwsA1G6f1k3l/Z9sFqhL+SI8+YTiKkC
         N88zfIvszkzRSnyAD5Tr7oxt7LD2SKi3Te1AFMQr6teT8STHxB+V89cjkDo2KcqV1t3s
         t0RTEPylcjCUcc5zc+4zXcL7I5C/WYdNsLfdigDmp7Y1ftLWrZkafbp70BGDwSoXGcWt
         pRsE3fKi2RpVx9Xg515Pw38yxRd33yQW81o2p4e0NJCHLSO+ej/tJh9SAt92WmLJy2Hn
         8KEw==
X-Gm-Message-State: APjAAAUfCUpYkqMiDFGvwvXvICz62eeKRAOIAcxMob3xLTedW/7c+FUd
        t/W3/EgVGv6qzLbdaAvuN88=
X-Google-Smtp-Source: APXvYqwTK8MvrMnJ9NIHIyEE5WOWy7DKGNdrUTfs4C9pIocMHV26Ju4XxvsgN7Y1/4eXp8d7nBsQeA==
X-Received: by 2002:a17:90a:9385:: with SMTP id q5mr14811061pjo.126.1560068050808;
        Sun, 09 Jun 2019 01:14:10 -0700 (PDT)
Received: from Gentoo ([103.231.91.70])
        by smtp.gmail.com with ESMTPSA id a186sm6558261pfa.188.2019.06.09.01.14.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 01:14:09 -0700 (PDT)
Date:   Sun, 9 Jun 2019 13:43:48 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.1.8
Message-ID: <20190609081348.GA5853@Gentoo>
References: <20190609073855.GA10088@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <20190609073855.GA10088@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Thanks, a bunch Greg!

On 09:38 Sun 09 Jun , Greg KH wrote:
>I'm announcing the release of the 5.1.8 kernel.
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
> Documentation/admin-guide/cgroup-v2.rst                            |    9
> Documentation/conf.py                                              |    2
> Documentation/sphinx/kerneldoc.py                                  |   44=
 ++
> Documentation/sphinx/kernellog.py                                  |   28=
 +
> Documentation/sphinx/kfigure.py                                    |   40=
 +-
> Makefile                                                           |    2
> arch/arm64/kernel/sys.c                                            |    2
> arch/arm64/kernel/traps.c                                          |    5
> arch/mips/kvm/mips.c                                               |    3
> arch/powerpc/kernel/kexec_elf_64.c                                 |    6
> arch/powerpc/kvm/book3s_hv.c                                       |    8
> arch/powerpc/kvm/book3s_xive.c                                     |    4
> arch/powerpc/kvm/powerpc.c                                         |    3
> arch/powerpc/perf/core-book3s.c                                    |    6
> arch/powerpc/perf/power8-pmu.c                                     |    3
> arch/powerpc/perf/power9-pmu.c                                     |    3
> arch/s390/crypto/aes_s390.c                                        |  156=
 +++++++---
> arch/s390/crypto/des_s390.c                                        |    7
> arch/s390/kvm/kvm-s390.c                                           |    1
> arch/sparc/mm/ultra.S                                              |    4
> arch/x86/kernel/ima_arch.c                                         |    5
> arch/x86/kernel/kprobes/core.c                                     |   24=
 +
> arch/x86/kernel/vmlinux.lds.S                                      |    6
> arch/x86/kvm/x86.c                                                 |    3
> drivers/clk/imx/clk-imx8mm.c                                       |   12
> drivers/gpu/drm/drm_atomic_uapi.c                                  |   32=
 +-
> drivers/gpu/drm/drm_crtc.c                                         |    4
> drivers/gpu/drm/drm_crtc_internal.h                                |    1
> drivers/gpu/drm/drm_fb_helper.c                                    |    4
> drivers/gpu/drm/drm_gem_cma_helper.c                               |    8
> drivers/gpu/drm/drm_mode_config.c                                  |    5
> drivers/gpu/drm/drm_mode_object.c                                  |    5
> drivers/gpu/drm/drm_plane.c                                        |    8
> drivers/gpu/drm/imx/ipuv3-plane.c                                  |   13
> drivers/gpu/drm/imx/ipuv3-plane.h                                  |    1
> drivers/gpu/drm/nouveau/include/nvkm/subdev/i2c.h                  |    2
> drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c                      |   26=
 +
> drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.h                      |    2
> drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c                     |   15
> drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.c                      |   21=
 +
> drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.h                      |    1
> drivers/gpu/drm/rockchip/rockchip_drm_drv.c                        |    9
> drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c                             |   29=
 +
> drivers/gpu/drm/tegra/gem.c                                        |    4
> drivers/gpu/drm/vmwgfx/ttm_object.c                                |    2
> drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                                |    8
> drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c                            |   13
> drivers/i2c/busses/i2c-mlxcpld.c                                   |    2
> drivers/i2c/busses/i2c-synquacer.c                                 |    2
> drivers/iio/adc/npcm_adc.c                                         |    2
> drivers/iio/adc/ti-ads124s08.c                                     |    2
> drivers/iio/adc/ti-ads8688.c                                       |    2
> drivers/iio/dac/ds4424.c                                           |    2
> drivers/media/usb/siano/smsusb.c                                   |   33=
 +-
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c            |   11
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h            |    6
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c            |    4
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c        |   16=
 -
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h        |    3
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c           |   10
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h           |    3
> drivers/s390/scsi/zfcp_ext.h                                       |    1
> drivers/s390/scsi/zfcp_scsi.c                                      |    9
> drivers/s390/scsi/zfcp_sysfs.c                                     |   55=
 +++
> drivers/s390/scsi/zfcp_unit.c                                      |    8
> drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c |    9
> drivers/staging/wlan-ng/hfa384x_usb.c                              |    3
> drivers/tty/serial/max310x.c                                       |    2
> drivers/tty/serial/msm_serial.c                                    |    5
> drivers/tty/serial/sh-sci.c                                        |    7
> drivers/tty/vt/vt.c                                                |   11
> drivers/usb/core/config.c                                          |    4
> drivers/usb/core/quirks.c                                          |    3
> drivers/usb/host/xhci-ring.c                                       |   17=
 -
> drivers/usb/host/xhci.c                                            |   24=
 -
> drivers/usb/misc/rio500.c                                          |   41=
 ++
> drivers/usb/misc/sisusbvga/sisusb.c                                |   15
> drivers/usb/usbip/stub_dev.c                                       |   75=
 +++-
> drivers/video/fbdev/core/fbcon.c                                   |    2
> fs/btrfs/inode.c                                                   |   14
> fs/btrfs/qgroup.c                                                  |    8
> fs/btrfs/relocation.c                                              |   27=
 +
> fs/btrfs/send.c                                                    |    6
> fs/btrfs/tree-log.c                                                |   20=
 -
> fs/btrfs/zstd.c                                                    |   20=
 -
> fs/cifs/file.c                                                     |    4
> fs/cifs/smb2pdu.c                                                  |    3
> fs/lockd/xdr.c                                                     |    4
> fs/lockd/xdr4.c                                                    |    4
> include/linux/bitops.h                                             |   16=
 -
> include/linux/cgroup-defs.h                                        |    5
> include/linux/list_lru.h                                           |    1
> include/linux/memcontrol.h                                         |   10
> kernel/cgroup/cgroup.c                                             |   16=
 -
> kernel/signal.c                                                    |    2
> kernel/trace/trace_events_filter.c                                 |    8
> mm/compaction.c                                                    |    2
> mm/kasan/common.c                                                  |    2
> mm/list_lru.c                                                      |    8
> scripts/gcc-plugins/gcc-common.h                                   |    4
> security/integrity/evm/evm_crypto.c                                |    3
> security/integrity/ima/ima_policy.c                                |   28=
 +
> sound/pci/hda/patch_realtek.c                                      |   18=
 -
> sound/usb/line6/driver.c                                           |   12
> sound/usb/line6/driver.h                                           |    4
> sound/usb/line6/toneport.c                                         |   15
> virt/kvm/arm/arm.c                                                 |    3
> virt/kvm/kvm_main.c                                                |    2
> 108 files changed, 912 insertions(+), 345 deletions(-)
>
>Alan Stern (3):
>      USB: Fix slab-out-of-bounds write in usb_get_bos_descriptor
>      media: usb: siano: Fix general protection fault in smsusb
>      media: usb: siano: Fix false-positive "uninitialized variable" warni=
ng
>
>Andrey Smirnov (1):
>      xhci: Convert xhci_handshake() to use readl_poll_timeout_atomic()
>
>Benjamin Coddington (1):
>      Revert "lockd: Show pid of lockd for remote locks"
>
>Carsten Schmid (1):
>      usb: xhci: avoid null pointer deref when bos field is NULL
>
>Catalin Marinas (1):
>      arm64: Fix the arm64_personality() syscall wrapper redirection
>
>Chris Down (1):
>      mm, memcg: consider subtrees in memory.events
>
>Colin Ian King (1):
>      cifs: fix memory leak of pneg_inbuf on -EOPNOTSUPP ioctl case
>
>C=E9dric Le Goater (1):
>      KVM: PPC: Book3S HV: XIVE: Do not clear IRQ data of passthrough inte=
rrupts
>
>Dan Carpenter (1):
>      staging: vc04_services: prevent integer overflow in create_pagelist()
>
>Daniel Vetter (2):
>      drm/atomic: Wire file_priv through for property changes
>      drm/lease: Make sure implicit planes are leased
>
>Deepak Rawat (1):
>      drm: Expose "FB_DAMAGE_CLIPS" property to atomic aware user-space on=
ly
>
>Dennis Zhou (1):
>      btrfs: correct zstd workspace manager lock to use spin_lock_bh()
>
>Dmitry Osipenko (1):
>      drm/tegra: gem: Fix CPU-cache maintenance for BO's allocated using g=
et_pages()
>
>Eric W. Biederman (1):
>      signal/arm64: Use force_sig not force_sig_fault for SIGKILL
>
>Fabio Estevam (1):
>      xhci: Use %zu for printing size_t type
>
>Filipe Manana (4):
>      Btrfs: fix wrong ctime and mtime of a directory after log replay
>      Btrfs: fix race updating log root item during fsync
>      Btrfs: fix fsync not persisting changed attributes of a directory
>      Btrfs: incremental send, fix file corruption when no-holes feature i=
s enabled
>
>George G. Davis (1):
>      serial: sh-sci: disable DMA for uart_console
>
>Greg Kroah-Hartman (2):
>      Revert "x86/build: Move _etext to actual end of .text"
>      Linux 5.1.8
>
>Grzegorz Halat (1):
>      vt/fbcon: deinitialize resources in visual_init() after failed memor=
y allocation
>
>Harald Freudenberger (2):
>      s390/crypto: fix gcm-aes-s390 selftest failures
>      s390/crypto: fix possible sleep during spinlock aquired
>
>Henry Lin (1):
>      xhci: update bounce buffer with correct sg num
>
>Hui Wang (1):
>      ALSA: hda/realtek - Improve the headset mic for Acer Aspire laptops
>
>James Clarke (1):
>      sparc64: Fix regression in non-hypervisor TLB flush xcall
>
>Jernej Skrabec (2):
>      drm/sun4i: Fix sun8i HDMI PHY clock initialization
>      drm/sun4i: Fix sun8i HDMI PHY configuration for > 148.5 MHz
>
>Jiri Slaby (1):
>      memcg: make it work on sparse non-0-node systems
>
>Joe Burmeister (1):
>      tty: max310x: Fix external crystal register setup
>
>Jonathan Corbet (3):
>      docs: Fix conf.py for Sphinx 2.0
>      doc: Cope with the deprecation of AutoReporter
>      doc: Cope with Sphinx logging deprecations
>
>Jorge Ramirez-Ortiz (1):
>      tty: serial: msm_serial: Fix XON/XOFF
>
>Kailang Yang (1):
>      ALSA: hda/realtek - Set default power save node to 0
>
>Kees Cook (1):
>      gcc-plugins: Fix build failures under Darwin host
>
>Lyude Paul (1):
>      drm/nouveau/i2c: Disable i2c bus access after ->fini()
>
>Masahisa Kojima (1):
>      i2c: synquacer: fix synquacer_i2c_doxfer() return value
>
>Mauro Carvalho Chehab (1):
>      media: smsusb: better handle optional alignment
>
>Maximilian Luz (1):
>      USB: Add LPM quirk for Surface Dock GigE adapter
>
>Nadav Amit (1):
>      x86/kprobes: Set instruction page as executable
>
>Nathan Chancellor (1):
>      kasan: initialize tag to 0xff in __kasan_kmalloc
>
>Noralf Tr=F8nnes (2):
>      drm/fb-helper: generic: Call drm_client_add() after setup is done
>      drm/cma-helper: Fix drm_gem_cma_free_object()
>
>Oliver Neukum (3):
>      USB: sisusbvga: fix oops in error path of sisusb_probe
>      USB: rio500: refuse more than one device at a time
>      USB: rio500: fix memory leak in close after disconnect
>
>Paul Mackerras (1):
>      KVM: PPC: Book3S HV: Fix lockdep warning when entering guest on POWE=
R9
>
>Peng Fan (1):
>      clk: imx: imx8mm: fix int pll clk gate
>
>Petr Vorel (1):
>      ima: fix wrong signed policy requirement when not appraising
>
>Philipp Zabel (1):
>      drm/imx: ipuv3-plane: fix atomic update status query for non-plus i.=
MX6Q
>
>Piotr Figiel (1):
>      brcmfmac: fix NULL pointer derefence during USB disconnect
>
>Qu Wenruo (2):
>      btrfs: qgroup: Check bg while resuming relocation to avoid NULL poin=
ter dereference
>      btrfs: reloc: Also queue orphan reloc tree for cleanup to avoid BUG_=
ON()
>
>Rasmus Villemoes (1):
>      include/linux/bitops.h: sanitize rotate primitives
>
>Ravi Bangoria (1):
>      powerpc/perf: Fix MMCRA corruption by bhrb_filter
>
>Roberto Bergantinos Corpas (1):
>      CIFS: cifs_read_allocate_pages: don't iterate through whole page arr=
ay on ENOMEM
>
>Roberto Sassu (2):
>      ima: show rules with IMA_INMASK correctly
>      evm: check hash algorithm passed to init_desc()
>
>Ruslan Babayev (1):
>      iio: dac: ds4422/ds4424 fix chip verification
>
>Scott Wood (1):
>      x86/ima: Check EFI_RUNTIME_SERVICES before using
>
>Sean Nyekjaer (1):
>      iio: adc: ti-ads8688: fix timestamp is not updated in buffer
>
>Shuah Khan (2):
>      usbip: usbip_host: fix BUG: sleeping function called from invalid co=
ntext
>      usbip: usbip_host: fix stub_dev lock context imbalance regression
>
>Steffen Maier (2):
>      scsi: zfcp: fix missing zfcp_port reference put on -EBUSY from port_=
remove
>      scsi: zfcp: fix to prevent port_remove with pure auto scan LUNs (onl=
y sdevs)
>
>Suraj Jitindar Singh (1):
>      KVM: PPC: Book3S HV: Restore SPRG3 in kvmhv_p9_guest_entry()
>
>Suzuki K Poulose (1):
>      mm, compaction: make sure we isolate a valid PFN
>
>Takashi Iwai (1):
>      ALSA: line6: Assure canceling delayed work at disconnection
>
>Thiago Jung Bauermann (1):
>      powerpc/kexec: Fix loading of kernel + initramfs with kexec_file_loa=
d()
>
>Thomas Hellstrom (3):
>      drm/vmwgfx: Fix user space handle equal to zero
>      drm/vmwgfx: Fix compat mode shader operation
>      drm/vmwgfx: Don't send drm sysfs hotplug events on initial master set
>
>Thomas Huth (1):
>      KVM: s390: Do not report unusabled IDs via KVM_CAP_MAX_VCPU_ID
>
>Tim Collier (1):
>      staging: wlan-ng: fix adapter initialization failure
>
>Tomas Bortoli (1):
>      tracing: Avoid memory leak in predicate_parse()
>
>Tomer Maimon (1):
>      iio: adc: modify NPCM ADC read reference voltage
>
>Vadim Pasternak (1):
>      i2c: mlxcpld: Fix wrong initialization order in probe
>
>Vicente Bergas (1):
>      drm/rockchip: shutdown drm subsystem on shutdown
>
>Vincent Stehl=E9 (1):
>      iio: adc: ads124: avoid buffer overflow
>
>Zhenliang Wei (1):
>      kernel/signal.c: trace_signal_deliver when signal_group_exit
>



--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAlz8v7gACgkQsjqdtxFL
KRULNggAghrlNR80aP9GhDuRVInY4yXDp7CStvc3Psu2dq+JX9R8bwzICA6zvazZ
tNmw2Mdb/90QCeFBRE7YAnS7JBzaLxN+/ZtC5IbYrwSQ3HSn47hYiw5mdZvWRkmo
/1Wtq6tAeNt1qp1h75xbcL97OqKstKkBB2lUeRmx/R5/OqveVyeJkchFZKJdPYfE
cyMlzTubGXeCvkFrg1SA7KQC4hXxRvBpvOn2K/IwEJOP2w2JqPCCH/mTakxcgRud
92+eEVgCb64RFpjsY8ba9TuAkpWNhFx4RGUbo9XZ+BFFFq3go+o4i54bYY7PoOVF
hXWkalmRz/YEoDONnx/4KnqcwKzwDA==
=mGA0
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
