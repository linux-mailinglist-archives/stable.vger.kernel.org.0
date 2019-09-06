Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E587AB998
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 15:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393440AbfIFNqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 09:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732304AbfIFNqk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Sep 2019 09:46:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E531206B8;
        Fri,  6 Sep 2019 13:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567777598;
        bh=1AHny5Z+S7Fs1Ir4SyP5g6dvJofLwzDB3MjQyEJ8y4M=;
        h=Date:From:To:Cc:Subject:From;
        b=JZo/igVuKOWdMfRM+CuU8Hfi4W6m2VDJG9brDsNXEjE0O5ErfP1KOJRwSRLpcwAiS
         bUUHuFUtqVmr8arzLJOaaizXMDioDq1yFquimjzKOv9Ses31vdpzm0yEoyi0Dx6ePb
         KU5NfbblyO2v5F+9LGU4ljg+8fwpTRhlDkBs1uYw=
Date:   Fri, 6 Sep 2019 15:46:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.142
Message-ID: <20190906134636.GA7038@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.142 kernel.

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

 Makefile                                     |    2 -
 arch/powerpc/kvm/book3s_64_vio.c             |    6 +++-
 arch/powerpc/kvm/book3s_64_vio_hv.c          |    6 +++-
 arch/x86/kernel/apic/apic.c                  |    4 +++
 arch/x86/kernel/apic/bigsmp_32.c             |   24 +------------------
 arch/x86/kernel/ptrace.c                     |    3 --
 arch/x86/kernel/uprobes.c                    |   17 +++++++------
 arch/x86/kvm/lapic.c                         |    5 +++
 arch/x86/kvm/x86.c                           |    9 +++----
 drivers/auxdisplay/panel.c                   |    2 +
 drivers/block/xen-blkback/xenbus.c           |    6 ++--
 drivers/crypto/ccp/ccp-dev.c                 |    8 ++++++
 drivers/dma/ste_dma40.c                      |    4 +--
 drivers/gpu/drm/ast/ast_main.c               |    5 +++
 drivers/gpu/drm/ast/ast_mode.c               |    2 -
 drivers/gpu/drm/ast/ast_post.c               |    2 -
 drivers/gpu/drm/bridge/ti-tfp410.c           |    7 ++++-
 drivers/gpu/drm/i915/i915_vgpu.c             |    3 ++
 drivers/gpu/drm/tilcdc/tilcdc_drv.c          |   34 +++++++++++++---------=
-----
 drivers/hwtracing/intel_th/pci.c             |   10 +++++++
 drivers/hwtracing/stm/core.c                 |    1=20
 drivers/i2c/busses/i2c-emev2.c               |   16 +++++++++---
 drivers/i2c/busses/i2c-piix4.c               |   12 +++------
 drivers/i2c/busses/i2c-rcar.c                |   11 +++++---
 drivers/iommu/dma-iommu.c                    |    2 -
 drivers/misc/vmw_vmci/vmci_doorbell.c        |    6 +++-
 drivers/mmc/core/sd.c                        |    6 ++++
 drivers/mmc/host/sdhci-of-at91.c             |    3 ++
 drivers/scsi/ufs/unipro.h                    |    2 -
 drivers/usb/chipidea/udc.c                   |   32 +++++++++++++++++++---=
---
 drivers/usb/class/cdc-wdm.c                  |   16 +++++++++---
 drivers/usb/gadget/composite.c               |    1=20
 drivers/usb/gadget/function/f_mass_storage.c |   28 ++++++++++++++--------
 drivers/usb/host/fotg210-hcd.c               |    4 +++
 drivers/usb/host/ohci-hcd.c                  |   15 +++++++++--
 drivers/usb/host/xhci-rcar.c                 |    2 -
 drivers/usb/storage/realtek_cr.c             |   15 +++++++----
 drivers/usb/storage/unusual_devs.h           |    2 -
 drivers/watchdog/bcm2835_wdt.c               |    1=20
 fs/nfs/direct.c                              |   34 ++++++++++++++++------=
-----
 fs/nfs/pagelist.c                            |   32 ++++++++++++----------=
---
 fs/nfs/read.c                                |    2 -
 fs/nfs/write.c                               |   11 +++++++-
 include/linux/nfs_page.h                     |   10 +++++++
 include/linux/nfs_xdr.h                      |    2 -
 include/net/tcp.h                            |    4 +++
 kernel/trace/ftrace.c                        |   17 +++++++++++++
 mm/zsmalloc.c                                |    2 +
 net/core/stream.c                            |   16 +++++++-----
 net/mac80211/cfg.c                           |    9 +++----
 net/smc/smc_tx.c                             |    6 +---
 net/wireless/reg.c                           |    2 -
 sound/core/seq/seq_clientmgr.c               |    3 --
 sound/core/seq/seq_fifo.c                    |   17 +++++++++++++
 sound/core/seq/seq_fifo.h                    |    2 +
 sound/soc/soc-core.c                         |    7 +----
 sound/usb/line6/pcm.c                        |   18 +++++++-------
 sound/usb/mixer.c                            |   30 +++++++++++++++++++----
 tools/hv/hv_kvp_daemon.c                     |    2 +
 tools/hv/hv_vss_daemon.c                     |    2 +
 virt/kvm/arm/vgic/vgic-mmio.c                |   18 ++++++++++++++
 virt/kvm/arm/vgic/vgic-v2.c                  |    5 +++
 virt/kvm/arm/vgic/vgic-v3.c                  |    5 +++
 virt/kvm/arm/vgic/vgic.c                     |    7 +++++
 64 files changed, 406 insertions(+), 191 deletions(-)

Adrian Vladu (1):
      tools: hv: fix KVP and VSS daemons exit code

Alexander Shishkin (2):
      intel_th: pci: Add support for another Lewisburg PCH
      intel_th: pci: Add Tiger Lake support

Alexey Kardashevskiy (1):
      KVM: PPC: Book3S: Fix incorrect guest-to-user-translation error handl=
ing

Andrew Cooks (1):
      i2c: piix4: Fix port selection for AMD Family 16h Model 30h

Andrew Morton (1):
      mm/zsmalloc.c: fix build when CONFIG_COMPACTION=3Dn

Arnd Bergmann (1):
      dmaengine: ste_dma40: fix unneeded variable warning

Bandan Das (2):
      x86/apic: Do not initialize LDR and DFR for bigsmp
      x86/apic: Include the LDR when clearing out APIC registers

Benjamin Herrenschmidt (2):
      usb: gadget: composite: Clear "suspended" on reset/disconnect
      usb: gadget: mass_storage: Fix races between fsg_disable and fsg_set_=
alt

Ding Xiang (1):
      stm class: Fix a double free of stm_source_device

Eric Dumazet (1):
      tcp: make sure EPOLLOUT wont be missed

Eugen Hristev (1):
      mmc: sdhci-of-at91: add quirk for broken HS200

Gary R Hook (1):
      crypto: ccp - Ignore unconfigured CCP device on suspend/resume

Geert Uytterhoeven (1):
      usb: host: xhci: rcar: Fix typo in compatible string matching

Greg Kroah-Hartman (3):
      x86/ptrace: fix up botched merge of spectrev1 fix
      Revert "ASoC: Fail card instantiation if DAI format setup fails"
      Linux 4.14.142

Hans Ulli Kroll (1):
      usb: host: fotg2: restart hcd after port reset

Henk van der Laan (1):
      usb-storage: Add new JMS567 revision to unusual_devs

Heyi Guo (1):
      KVM: arm/arm64: vgic: Fix potential deadlock when ap_list is long

Hodaszi, Robert (1):
      Revert "cfg80211: fix processing world regdomain when non modular"

Hui Peng (2):
      ALSA: usb-audio: Fix a stack buffer overflow bug in check_input_term
      ALSA: usb-audio: Fix an OOB bug in parse_audio_mixer_unit

Jason Baron (1):
      net/smc: make sure EPOLLOUT is raised

Johannes Berg (1):
      mac80211: fix possible sta leak

Jyri Sarha (1):
      drm/tilcdc: Register cpufreq notifier after we have initialized crtc

Kai-Heng Feng (2):
      USB: storage: ums-realtek: Update module parameter description for au=
to_delink_en
      USB: storage: ums-realtek: Whitelist auto-delink support

Marc Zyngier (1):
      KVM: arm/arm64: vgic-v2: Handle SGI bits in GICD_I{S,C}PENDR0 as WI

Nadav Amit (1):
      VMCI: Release resource if the work is already queued

Naveen N. Rao (2):
      ftrace: Fix NULL pointer dereference in t_probe_next()
      ftrace: Check for successful allocation of hash

Oliver Neukum (1):
      USB: cdc-wdm: fix race between write and disconnect due to flag abuse

Pedro Sousa (1):
      scsi: ufs: Fix RX_TERMINATION_FORCE_ENABLE define value

Peter Chen (1):
      usb: chipidea: udc: don't do hardware access if gadget has stopped

Radim Krcmar (1):
      kvm: x86: skip populating logical dest map if apic is not sw enabled

Robin Murphy (1):
      iommu/dma: Handle SG length overflow better

Sean Christopherson (1):
      KVM: x86: Don't update RIP or do single-step on faulting emulation

Sebastian Mayr (1):
      uprobes/x86: Fix detection of 32-bit user mode

Stefan Wahren (1):
      watchdog: bcm2835_wdt: Fix module autoload

Steven Rostedt (VMware) (1):
      ftrace: Check for empty hash and comment the race with registering pr=
obes

Takashi Iwai (2):
      ALSA: line6: Fix memory leak at line6_init_pcm() error path
      ALSA: seq: Fix potential concurrent access to the deleted pool

Tim Froidcoeur (1):
      tcp: fix tcp_rtx_queue_tail in case of empty retransmit queue

Tomi Valkeinen (1):
      drm/bridge: tfp410: fix memleak in get_modes()

Trond Myklebust (4):
      NFS: Clean up list moves of struct nfs_page
      NFSv4/pnfs: Fix a page lock leak in nfs_pageio_resend()
      NFS: Pass error information to the pgio error cleanup routine
      NFS: Ensure O_DIRECT reports an error if the bytes read/written is 0

Ulf Hansson (1):
      mmc: core: Fix init of SD cards reporting an invalid VDD range

Wenwen Wang (1):
      xen/blkback: fix memory leaks

Wolfram Sang (2):
      i2c: rcar: avoid race when unregistering slave client
      i2c: emev2: avoid race when unregistering slave client

Xiong Zhang (1):
      drm/i915: Don't deballoon unused ggtt drm_mm_node in linux guest

Y.C. Chen (1):
      drm/ast: Fixed reboot test may cause system hanged

Yoshihiro Shimoda (1):
      usb: host: ohci: fix a race condition between shutdown and irq

zhengbin (1):
      auxdisplay: panel: need to delete scan_timer when misc_register fails=
 in panel_attach


--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1yYzwACgkQONu9yGCS
aT7SrxAAuLnhV88C/KAsmiLzTZKTldHVW2qwVzeOERkj9AKOwiTrCkBCrMZbdOkG
0Q7YuTOCwzA0AKXTinZsWdzYzLamGn4V6pYEdF/VLItQNSYYk6RO7jqOGXab8PyL
V3IO5UZCIxSyCxdvbGP0AOtQXAusS4R/HsE0A9D+8fvf/VJ1QjaDfelNlxlpDqW+
El2Ix3pa3o3YdUGLNbnnaqDl/V+VluDWzULFU/nguZlH93/txfzClSawTR7Cf0U2
4N6IKwMFubLCFhNko4u6ulCBti6y+siYKAjlz6M5Z/bAvCn6Q5lOQy0CROYwbqJ/
zNGXpaSqrrdh/rz3BqTd2COgCqqHl9a1SOWgGECwfVvrzM7ZxQ9/YVOaGVz0SJ2d
fFMMNnb6tivIJ1t8wFpc6g6kUka9HRapdeojhoBjE9yvxDykXkI8Iuj0Y6OwpKLj
/8BvmDZV1L3gGsKbDZmsISXQGvS2M9kb2MHmva+gFRiLwRVnK8vkhDojLcX8lffz
CxulXBwEIu2Q05Gd4ve/s8tzR/gauKMdOiM53ntOi5rZaw9CnFbZ32ul8Z/aEVIb
K+BK+1RjSfwcqiPfCLbIYY0ntywDf6dkCrpivxBda70dUP/nNVu/kdjUu5/sWzXd
WS/eTHFK/15KdWUZu7Z1+wZEuO/E3CjHMSRc6vtyHk9v5wDAVrw=
=a9IG
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
