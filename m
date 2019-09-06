Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3DEAB9A3
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 15:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389610AbfIFNrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 09:47:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbfIFNrR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Sep 2019 09:47:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA5D5206B8;
        Fri,  6 Sep 2019 13:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567777635;
        bh=qJLIc182bYDc/hoUYiJtcyKD9MEGxYmOaZkCX12cuDQ=;
        h=Date:From:To:Cc:Subject:From;
        b=WlEs2fwXHf5Fd6rIB5GsxWm1jWNd3hRkfFnB/Ff6iSFMUg9yMVWh35si2OiBa4xM8
         kLRE4IDza+MlktSPuDKF0KsSDKgOqNRW7wfVSLj+GLfqFyXfu/kJkn2oL/EwBWj+iD
         D2zZrN6OKlyPCeF2z4GtGENAh7hf04gjHOsOeXVs=
Date:   Fri, 6 Sep 2019 15:47:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.70
Message-ID: <20190906134713.GA7160@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.70 kernel.

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

 Makefile                                           |    2=20
 arch/arm64/kernel/cpufeature.c                     |   14 +++
 arch/powerpc/kvm/book3s_64_vio.c                   |    6 +
 arch/powerpc/kvm/book3s_64_vio_hv.c                |    6 +
 arch/x86/kernel/apic/apic.c                        |    4 +
 arch/x86/kernel/apic/bigsmp_32.c                   |   24 ------
 arch/x86/kernel/ptrace.c                           |    3=20
 arch/x86/kernel/uprobes.c                          |   17 ++--
 arch/x86/kvm/lapic.c                               |    5 +
 arch/x86/kvm/x86.c                                 |    9 +-
 drivers/auxdisplay/panel.c                         |    2=20
 drivers/block/xen-blkback/xenbus.c                 |    6 -
 drivers/bus/hisi_lpc.c                             |   47 +++++++++++--
 drivers/crypto/ccp/ccp-dev.c                       |    8 ++
 drivers/dma/ste_dma40.c                            |    4 -
 drivers/dma/stm32-mdma.c                           |    2=20
 drivers/dma/ti/omap-dma.c                          |    4 -
 drivers/fsi/fsi-scom.c                             |    8 --
 drivers/gpu/drm/amd/amdgpu/amdgpu_atpx_handler.c   |    1=20
 drivers/gpu/drm/ast/ast_main.c                     |    5 +
 drivers/gpu/drm/ast/ast_mode.c                     |    2=20
 drivers/gpu/drm/ast/ast_post.c                     |    2=20
 drivers/gpu/drm/bridge/ti-tfp410.c                 |    7 +
 drivers/gpu/drm/i915/i915_drv.c                    |    6 +
 drivers/gpu/drm/i915/i915_vgpu.c                   |    3=20
 drivers/gpu/drm/i915/intel_device_info.c           |    2=20
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |   34 ++++-----
 drivers/hwtracing/intel_th/pci.c                   |   10 ++
 drivers/hwtracing/stm/core.c                       |    1=20
 drivers/i2c/busses/i2c-emev2.c                     |   16 +++-
 drivers/i2c/busses/i2c-piix4.c                     |   12 +--
 drivers/i2c/busses/i2c-rcar.c                      |   11 +--
 drivers/iommu/dma-iommu.c                          |    2=20
 drivers/media/platform/omap/omap_vout_vrfb.c       |    3=20
 drivers/misc/mei/hw-me-regs.h                      |    2=20
 drivers/misc/mei/pci-me.c                          |    2=20
 drivers/misc/vmw_vmci/vmci_doorbell.c              |    6 +
 drivers/mmc/core/sd.c                              |    6 +
 drivers/mmc/host/sdhci-of-at91.c                   |    3=20
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |    4 -
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |    2=20
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |    4 -
 drivers/nvme/host/core.c                           |    6 +
 drivers/nvme/host/multipath.c                      |   30 ++++++++
 drivers/nvme/host/nvme.h                           |   12 +++
 drivers/nvme/host/pci.c                            |    3=20
 drivers/nvme/target/loop.c                         |    8 ++
 drivers/scsi/ufs/unipro.h                          |    2=20
 drivers/soundwire/cadence_master.c                 |    8 +-
 drivers/usb/chipidea/udc.c                         |   32 ++++++--
 drivers/usb/class/cdc-wdm.c                        |   16 +++-
 drivers/usb/core/hcd-pci.c                         |   30 ++------
 drivers/usb/gadget/composite.c                     |    1=20
 drivers/usb/gadget/function/f_mass_storage.c       |   28 +++++--
 drivers/usb/host/fotg210-hcd.c                     |    4 +
 drivers/usb/host/ohci-hcd.c                        |   15 +++-
 drivers/usb/host/xhci-rcar.c                       |    2=20
 drivers/usb/storage/realtek_cr.c                   |   15 ++--
 drivers/usb/storage/unusual_devs.h                 |    2=20
 drivers/usb/typec/tcpm.c                           |    2=20
 drivers/watchdog/bcm2835_wdt.c                     |    1=20
 fs/afs/cmservice.c                                 |   10 --
 fs/afs/dir.c                                       |    3=20
 fs/afs/file.c                                      |   12 +--
 fs/afs/vlclient.c                                  |   11 +--
 fs/nfs/direct.c                                    |   34 +++++----
 fs/nfs/pagelist.c                                  |   32 ++++----
 fs/nfs/read.c                                      |    2=20
 fs/nfs/write.c                                     |   11 ++-
 include/linux/logic_pio.h                          |    1=20
 include/linux/nfs_page.h                           |   10 ++
 include/linux/nfs_xdr.h                            |    2=20
 kernel/trace/ftrace.c                              |   17 ++++
 lib/logic_pio.c                                    |   73 +++++++++++++++-=
----
 mm/zsmalloc.c                                      |    2=20
 net/core/stream.c                                  |   16 ++--
 net/ipv4/icmp.c                                    |    8 +-
 net/ipv6/addrconf.c                                |    3=20
 net/ipv6/route.c                                   |    2=20
 net/mac80211/cfg.c                                 |    9 +-
 net/mac80211/rx.c                                  |    6 -
 net/smc/smc_tx.c                                   |    6 -
 net/tls/tls_main.c                                 |    2=20
 net/tls/tls_sw.c                                   |   10 +-
 net/wireless/reg.c                                 |    2=20
 sound/core/seq/seq_clientmgr.c                     |    3=20
 sound/core/seq/seq_fifo.c                          |   17 ++++
 sound/core/seq/seq_fifo.h                          |    2=20
 sound/pci/hda/patch_conexant.c                     |   17 ++--
 sound/soc/soc-core.c                               |    7 -
 sound/usb/line6/pcm.c                              |   18 ++---
 sound/usb/mixer.c                                  |   36 +++++++---
 sound/usb/mixer_quirks.c                           |    8 +-
 sound/usb/pcm.c                                    |    1=20
 tools/hv/hv_kvp_daemon.c                           |    2=20
 tools/hv/hv_vss_daemon.c                           |    2=20
 tools/hv/lsvmbus                                   |   75 +++++++++++-----=
-----
 virt/kvm/arm/vgic/vgic-mmio.c                      |   18 +++++
 virt/kvm/arm/vgic/vgic-v2.c                        |    5 +
 virt/kvm/arm/vgic/vgic-v3.c                        |    5 +
 virt/kvm/arm/vgic/vgic.c                           |    7 +
 101 files changed, 700 insertions(+), 341 deletions(-)

Adrian Vladu (2):
      tools: hv: fixed Python pep8/flake8 warnings for lsvmbus
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

Anthony Iliopoulos (1):
      nvme-multipath: revalidate nvme_ns_head gendisk in nvme_validate_ns

Arnd Bergmann (1):
      dmaengine: ste_dma40: fix unneeded variable warning

Bandan Das (2):
      x86/apic: Do not initialize LDR and DFR for bigsmp
      x86/apic: Include the LDR when clearing out APIC registers

Benjamin Herrenschmidt (2):
      usb: gadget: composite: Clear "suspended" on reset/disconnect
      usb: gadget: mass_storage: Fix races between fsg_disable and fsg_set_=
alt

Colin Ian King (1):
      typec: tcpm: fix a typo in the comparison of pdo_max_voltage

David Ahern (1):
      ipv6: Default fib6_type to RTN_UNICAST when not set

David Howells (2):
      afs: Fix the CB.ProbeUuid service handler to reply correctly
      afs: Only update d_fsdata if different in afs_d_revalidate()

Denis Kenzior (2):
      mac80211: Don't memset RXCB prior to PAE intercept
      mac80211: Correctly set noencrypt for PAE frames

Ding Xiang (1):
      stm class: Fix a double free of stm_source_device

Eddie James (1):
      fsi: scom: Don't abort operations for minor errors

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
      Linux 4.19.70

Hangbin Liu (2):
      ipv6/addrconf: allow adding multicast addr if IFA_F_MCAUTOJOIN is set
      ipv4/icmp: fix rt dst dev null pointer dereference

Hans Ulli Kroll (1):
      usb: host: fotg2: restart hcd after port reset

Hans Verkuil (1):
      omap-dma/omap_vout_vrfb: fix off-by-one fi value

Henk van der Laan (1):
      usb-storage: Add new JMS567 revision to unusual_devs

Heyi Guo (1):
      KVM: arm/arm64: vgic: Fix potential deadlock when ap_list is long

Hodaszi, Robert (1):
      Revert "cfg80211: fix processing world regdomain when non modular"

Jakub Kicinski (1):
      net/tls: swap sk_write_space on close

Jason Baron (1):
      net/smc: make sure EPOLLOUT is raised

Jeronimo Borque (1):
      ALSA: hda - Fixes inverted Conexant GPIO mic mute led

Jia-Ju Bai (2):
      fs: afs: Fix a possible null-pointer dereference in afs_put_read()
      dmaengine: stm32-mdma: Fix a possible null-pointer dereference in stm=
32_mdma_irq_handler()

Johannes Berg (1):
      mac80211: fix possible sta leak

John Fastabend (1):
      net: tls, fix sk_write_space NULL write when tx disabled

John Garry (5):
      lib: logic_pio: Fix RCU usage
      lib: logic_pio: Avoid possible overlap for unregistering regions
      lib: logic_pio: Add logic_pio_unregister_range()
      bus: hisi_lpc: Unregister logical PIO range to avoid potential use-af=
ter-free
      bus: hisi_lpc: Add .remove method to avoid driver unbind crash

Jyri Sarha (1):
      drm/tilcdc: Register cpufreq notifier after we have initialized crtc

Kai-Heng Feng (3):
      USB: storage: ums-realtek: Update module parameter description for au=
to_delink_en
      USB: storage: ums-realtek: Whitelist auto-delink support
      drm/amdgpu: Add APTX quirk for Dell Latitude 5495

Keith Busch (1):
      nvme-pci: Fix async probe remove race

Lionel Landwerlin (1):
      drm/i915: fix broadwell EU computation

Logan Gunthorpe (1):
      nvmet-loop: Flush nvme_delete_wq when removing the port

Lyude Paul (1):
      drm/i915: Call dma_set_max_seg_size() in i915_driver_hw_probe()

Marc Dionne (1):
      afs: Fix loop index mixup in afs_deliver_vl_get_entry_by_name_u()

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

Pierre-Louis Bossart (2):
      soundwire: cadence_master: fix register definition for SLAVE_STATE
      soundwire: cadence_master: fix definitions for INTSTAT0/1

Radim Krcmar (1):
      kvm: x86: skip populating logical dest map if apic is not sw enabled

Robin Murphy (1):
      iommu/dma: Handle SG length overflow better

Sagi Grimberg (1):
      nvme: fix a possible deadlock when passthru commands sent to a multip=
ath device

Schmid, Carsten (1):
      usb: hcd: use managed device resources

Sean Christopherson (1):
      KVM: x86: Don't update RIP or do single-step on faulting emulation

Sebastian Mayr (1):
      uprobes/x86: Fix detection of 32-bit user mode

Stanislaw Gruszka (1):
      mt76: mt76x0u: do not reset radio on resume

Stefan Wahren (1):
      watchdog: bcm2835_wdt: Fix module autoload

Steven Rostedt (VMware) (1):
      ftrace: Check for empty hash and comment the race with registering pr=
obes

Takashi Iwai (5):
      ALSA: usb-audio: Check mixer unit bitmap yet more strictly
      ALSA: line6: Fix memory leak at line6_init_pcm() error path
      ALSA: seq: Fix potential concurrent access to the deleted pool
      ALSA: usb-audio: Fix invalid NULL check in snd_emuusb_set_samplerate()
      ALSA: usb-audio: Add implicit fb quirk for Behringer UFX1604

Tomas Winkler (1):
      mei: me: add Tiger Lake point LP device ID

Tomi Valkeinen (1):
      drm/bridge: tfp410: fix memleak in get_modes()

Trond Myklebust (4):
      NFS: Clean up list moves of struct nfs_page
      NFSv4/pnfs: Fix a page lock leak in nfs_pageio_resend()
      NFS: Pass error information to the pgio error cleanup routine
      NFS: Ensure O_DIRECT reports an error if the bytes read/written is 0

Ulf Hansson (1):
      mmc: core: Fix init of SD cards reporting an invalid VDD range

Vakul Garg (1):
      net/tls: Fixed return value when tls_complete_pending_work() fails

Wenwen Wang (1):
      xen/blkback: fix memory leaks

Will Deacon (1):
      arm64: cpufeature: Don't treat granule sizes as strict

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


--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1yY2EACgkQONu9yGCS
aT6NxhAAgYi+vcypp2K+C1pdPpO6QGQ/h2pJOj2wHtUI+JDeoWBmEAvLXUrLeWZ4
gSK9d/DN3BQai6echUM3IMxfu3dW8n1H7jRcDwOaJ6utsxxQq4Kz/PlwrsDjvZ/p
Bw7CDVI9L7Fx/qx1nnCIYapp1ErcediC/Nk30lmCSQZp250X0+iAbpA2hxFW8EV6
SmiGLLp1c06F3GQf1EX8ady/vrkP/AcvWMkDMFQNMNJWMsbGwlOS9dMrggR/+EDg
hgVZH0AjMCE3ClHBbk+D6oPbYjlomw9dTrZO8VP0CIieZT6ozQhPz44ooJyBCoap
FVLt/ZasVmcucK03j96Fz863JZeHLBPgZ6yIQmFm9iO7KfCv7RdC5QHdmBqgBFfU
wcp2WL48vc1KUSoHp5MnacCaifLXgdDaYgHo71+00zL+JsS5tYNFkqoHbjTAVUmj
hfhk2JS/TpPOltk8KmOaqdIlcBfOys/PBRDGI9HuRyrh/wNcBOM0b12y6Hc+TJOw
XqNBewYJxCBrug7FqTTq6DHxZVuPhG6FQgRnw3RUNMJ0t3x/R/1Srvvw7khMJmmY
8JSPr/WXQW9ybaqqN3tAEN7Uc94bCgaZnhmgjZ0bGn7N49rNvl8ukvLh+mlGZv3c
GLlNGR8cO4jZ+A2NR+CpdGzdMc1zl56C7gkpXby3CddNJHC45Yk=
=UAgi
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
