Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD3AD174C75
	for <lists+stable@lfdr.de>; Sun,  1 Mar 2020 10:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgCAJhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Mar 2020 04:37:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726744AbgCAJhB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Mar 2020 04:37:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BA9D214DB;
        Sun,  1 Mar 2020 09:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583055420;
        bh=8EdPuQJ4UrWuQRNnAsLtJLST7URnxGh+3XZn8Mhsicw=;
        h=Date:From:To:Cc:Subject:From;
        b=u0zx7h8vHR5/Rpu/q9paKZ1XyaFEh9WHVHCnTi2x3pMJmw5kmpXY05//fW1bjnkgH
         EP0V/Z0LQLXDWg3w6GYMyHsrcFUQNj9AEhHT4vng4Ep+jByWtg8er6C/Z8PGu+PL/+
         v0X36yLsdhVQMXK0JoZJOK4IsM4oP3wzOq22A3pk=
Date:   Sun, 1 Mar 2020 10:36:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.107
Message-ID: <20200301093657.GA1009684@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.107 kernel.

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

 MAINTAINERS                                    |    2=20
 Makefile                                       |    2=20
 arch/powerpc/kernel/signal.c                   |   17 +
 arch/powerpc/kernel/signal_32.c                |   28 +-
 arch/powerpc/kernel/signal_64.c                |   22 -
 arch/s390/include/asm/page.h                   |    2=20
 arch/x86/include/asm/kvm_host.h                |    2=20
 arch/x86/include/asm/msr-index.h               |    2=20
 arch/x86/kernel/cpu/amd.c                      |   14 +
 arch/x86/kernel/cpu/mcheck/mce_amd.c           |   50 ++--
 arch/x86/kvm/irq_comm.c                        |    2=20
 arch/x86/kvm/lapic.c                           |    9=20
 arch/x86/kvm/svm.c                             |    7=20
 arch/x86/kvm/vmx.c                             |  112 +++++++--
 drivers/ata/ahci.c                             |    7=20
 drivers/ata/libata-core.c                      |   21 +
 drivers/block/floppy.c                         |    7=20
 drivers/char/random.c                          |    5=20
 drivers/dma/imx-sdma.c                         |   19 -
 drivers/gpu/drm/amd/amdgpu/soc15.c             |    7=20
 drivers/gpu/drm/nouveau/dispnv50/wndw.c        |    2=20
 drivers/infiniband/ulp/isert/ib_isert.c        |   12 +
 drivers/iommu/qcom_iommu.c                     |   28 +-
 drivers/nvme/host/multipath.c                  |    1=20
 drivers/staging/android/ashmem.c               |   28 ++
 drivers/staging/greybus/audio_manager.c        |    2=20
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c |    4=20
 drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c |    5=20
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c |    4=20
 drivers/staging/vt6656/dpc.c                   |    2=20
 drivers/target/iscsi/iscsi_target.c            |   16 -
 drivers/thunderbolt/switch.c                   |    7=20
 drivers/tty/serdev/serdev-ttyport.c            |    6=20
 drivers/tty/serial/8250/8250_aspeed_vuart.c    |    1=20
 drivers/tty/serial/8250/8250_core.c            |    5=20
 drivers/tty/serial/8250/8250_of.c              |    1=20
 drivers/tty/serial/8250/8250_port.c            |    4=20
 drivers/tty/serial/atmel_serial.c              |    3=20
 drivers/tty/serial/imx.c                       |    2=20
 drivers/tty/serial/qcom_geni_serial.c          |  284 +++++++++++---------=
-----
 drivers/tty/tty_port.c                         |    5=20
 drivers/tty/vt/selection.c                     |    9=20
 drivers/tty/vt/vt.c                            |   15 +
 drivers/tty/vt/vt_ioctl.c                      |   17 -
 drivers/usb/core/config.c                      |   11=20
 drivers/usb/core/hub.c                         |   20 +
 drivers/usb/core/hub.h                         |    1=20
 drivers/usb/core/quirks.c                      |   40 +++
 drivers/usb/core/usb.h                         |    3=20
 drivers/usb/dwc2/gadget.c                      |   40 ++-
 drivers/usb/dwc3/gadget.c                      |    3=20
 drivers/usb/gadget/composite.c                 |    8=20
 drivers/usb/host/xhci-hub.c                    |   25 +-
 drivers/usb/host/xhci-mem.c                    |   71 ++++--
 drivers/usb/host/xhci-pci.c                    |   10=20
 drivers/usb/host/xhci-ring.c                   |   60 +++--
 drivers/usb/host/xhci.h                        |   16 +
 drivers/usb/misc/iowarrior.c                   |   31 ++
 drivers/usb/storage/uas.c                      |   23 +-
 drivers/xen/preempt.c                          |    4=20
 fs/btrfs/disk-io.c                             |    2=20
 fs/btrfs/inode.c                               |   16 +
 fs/btrfs/ordered-data.c                        |    7=20
 fs/ecryptfs/crypto.c                           |    6=20
 fs/ecryptfs/keystore.c                         |    2=20
 fs/ecryptfs/messaging.c                        |    1=20
 fs/ext4/balloc.c                               |   14 -
 fs/ext4/ext4.h                                 |   39 ++-
 fs/ext4/ialloc.c                               |   23 +-
 fs/ext4/inode.c                                |   16 -
 fs/ext4/mballoc.c                              |   61 +++--
 fs/ext4/migrate.c                              |   27 +-
 fs/ext4/namei.c                                |    1=20
 fs/ext4/resize.c                               |   62 ++++-
 fs/ext4/super.c                                |  113 ++++++---
 fs/jbd2/transaction.c                          |    8=20
 include/linux/intel-svm.h                      |    2=20
 include/linux/irqdomain.h                      |    2=20
 include/linux/libata.h                         |    1=20
 include/linux/tty.h                            |    2=20
 include/linux/usb/quirks.h                     |    3=20
 include/scsi/iscsi_proto.h                     |    1=20
 include/sound/rawmidi.h                        |    6=20
 ipc/sem.c                                      |    6=20
 kernel/bpf/offload.c                           |    2=20
 kernel/irq/internals.h                         |    2=20
 kernel/irq/manage.c                            |   18 -
 kernel/irq/proc.c                              |   22 +
 lib/stackdepot.c                               |    8=20
 mm/memcontrol.c                                |    4=20
 mm/vmscan.c                                    |    9=20
 net/netfilter/xt_hashlimit.c                   |   10=20
 net/rxrpc/call_object.c                        |   22 +
 sound/core/seq/seq_clientmgr.c                 |    4=20
 sound/core/seq/seq_queue.c                     |   29 +-
 sound/core/seq/seq_timer.c                     |   13 -
 sound/core/seq/seq_timer.h                     |    3=20
 sound/hda/hdmi_chmap.c                         |    2=20
 sound/pci/hda/hda_codec.c                      |    2=20
 sound/pci/hda/hda_eld.c                        |    2=20
 sound/pci/hda/hda_sysfs.c                      |    4=20
 sound/pci/hda/patch_realtek.c                  |    2=20
 sound/soc/sunxi/sun8i-codec.c                  |    3=20
 103 files changed, 1169 insertions(+), 579 deletions(-)

Aditya Pakki (1):
      ecryptfs: replace BUG_ON with error handling code

Alan Stern (1):
      USB: hub: Don't record a connect-change event during reset-resume

Alex Deucher (1):
      drm/amdgpu/soc15: fix xclk for raven

Alexander Potapenko (1):
      lib/stackdepot.c: fix global out-of-bounds in stack_slabs

Andy Shevchenko (1):
      serial: 8250: Check UPF_IRQ_SHARED in advance

Anurag Kumar Vulisha (1):
      usb: dwc3: gadget: Check for IOC/LST bit in TRB->ctrl fields

Bart Van Assche (2):
      scsi: Revert "RDMA/isert: Fix a recently introduced regression relate=
d to logout"
      scsi: Revert "target: iscsi: Wait for all commands to finish before f=
reeing a session"

Borislav Petkov (1):
      x86/mce/amd: Publish the bank pointer only after setup has succeeded

Colin Ian King (1):
      staging: rtl8723bs: fix copy of overlapping memory

Cong Wang (1):
      netfilter: xt_hashlimit: limit the max size of hashtable

Dan Carpenter (1):
      staging: greybus: use after free in gb_audio_manager_remove_all()

David Howells (1):
      rxrpc: Fix call RCU cleanup using non-bh-safe locks

EJ Hsu (1):
      usb: uas: fix a plug & unplug racing

Eric Biggers (2):
      ext4: rename s_journal_flag_rwsem to s_writepages_rwsem
      ext4: fix race between writepages and enabling EXT4_EXTENTS_FL

Eric Dumazet (1):
      vt: vt_ioctl: fix race in VT_RESIZEX

Filipe Manana (1):
      Btrfs: fix btrfs_wait_ordered_range() so that it waits for all ordere=
d extents

Fugang Duan (1):
      tty: serial: imx: setup the correct sg entry for tx dma

Gavin Shan (1):
      mm/vmscan.c: don't round up scan size for online memory cgroup

Greg Kroah-Hartman (6):
      USB: misc: iowarrior: add support for 2 OEMed devices
      USB: misc: iowarrior: add support for the 28 and 28L devices
      USB: misc: iowarrior: add support for the 100 device
      Revert "dmaengine: imx-sdma: Fix memory leak"
      Revert "char/random: silence a lockdep splat with printk()"
      Linux 4.19.107

Gustavo Luiz Duarte (1):
      powerpc/tm: Fix clearing MSR[TS] in current when reclaiming on signal=
 delivery

Hardik Gajjar (1):
      USB: hub: Fix the broken detection of USB3 device in SMSC hub

Ioanna Alifieraki (1):
      Revert "ipc,sem: remove uneeded sem_undo_list lock usage in exit_sem(=
)"

Jack Pham (1):
      usb: gadget: composite: Fix bMaxPower for SuperSpeedPlus

Jan Kara (1):
      ext4: fix mount failure with quota configured as module

Jani Nikula (1):
      MAINTAINERS: Update drm/i915 bug filing URL

Jiri Slaby (1):
      vt: selection, handle pending signals in paste_selection

Joerg Roedel (1):
      iommu/vt-d: Fix compile warning from intel-svm.h

Johan Hovold (3):
      USB: core: add endpoint-blacklist quirk
      USB: quirks: blacklist duplicate ep on Sound Devices USBPre2
      serdev: ttyport: restore client ops on deregistration

Johannes Krude (1):
      bpf, offload: Replace bitwise AND by logical AND in bpf_prog_offload_=
info_fill

Josef Bacik (3):
      btrfs: fix bytes_may_use underflow in prealloc error condtition
      btrfs: reset fs_root to NULL on error in open_ctree
      btrfs: do not check delayed items are empty for single transaction cl=
eanup

Kim Phillips (1):
      x86/cpu/amd: Enable the fixed Instructions Retired counter IRPERF

Larry Finger (4):
      staging: rtl8188eu: Fix potential security hole
      staging: rtl8188eu: Fix potential overuse of kernel memory
      staging: rtl8723bs: Fix potential security hole
      staging: rtl8723bs: Fix potential overuse of kernel memory

Linus Torvalds (1):
      floppy: check FDC index for errors before assigning it

Logan Gunthorpe (1):
      nvme-multipath: Fix memory leak with ana_log_buf

Lyude Paul (1):
      drm/nouveau/kms/gv100-: Re-set LUT after clearing for modesets

Malcolm Priestley (1):
      staging: vt6656: fix sign of rx_dbm to bb_pre_ed_rssi.

Mathias Nyman (4):
      xhci: Force Maximum Packet size for Full-speed bulk devices to valid =
range.
      xhci: fix runtime pm enabling for quirky Intel hosts
      xhci: Fix memory leak when caching protocol extended capability PSI t=
ables - take 2
      xhci: apply XHCI_PME_STUCK_QUIRK to Intel Comet Lake platforms

Miaohe Lin (2):
      KVM: x86: don't notify userspace IOAPIC on edge-triggered interrupt E=
OI
      KVM: apic: avoid calculating pending eoi from an uninitialized val

Mika Westerberg (1):
      thunderbolt: Prevent crash if non-active NVMem file is read

Minas Harutyunyan (2):
      usb: dwc2: Fix SET/CLEAR_FEATURE and GET_STATUS flows
      usb: dwc2: Fix in ISOC request length checking

Nathan Chancellor (1):
      s390/mm: Explicitly compare PAGE_DEFAULT_KEY against zero in storage_=
key_init_range

Nicolas Ferre (1):
      tty/serial: atmel: manage shutdown in case of RS485 or ISO7816 mode

Nicolas Pitre (1):
      vt: fix scrollback flushing on background consoles

Oliver Upton (2):
      KVM: nVMX: Refactor IO bitmap checks into helper function
      KVM: nVMX: Check IO instruction VM-exit conditions

Paolo Bonzini (1):
      KVM: nVMX: Don't emulate instructions in guest mode

Peter Chen (1):
      usb: host: xhci: update event ring dequeue pointer on purpose

Prabhakar Kushwaha (1):
      ata: ahci: Add shutdown to freeze hardware resources of ahci

Qian Cai (1):
      ext4: fix a data race in EXT4_I(inode)->i_disksize

Richard Dodd (1):
      USB: Fix novation SourceControl XL after suspend

Robin Murphy (1):
      iommu/qcom: Fix bogus detach logic

Ryan Case (5):
      tty: serial: qcom_geni_serial: Fix UART hang
      tty: serial: qcom_geni_serial: Remove interrupt storm
      tty: serial: qcom_geni_serial: Remove use of *_relaxed() and mb()
      tty: serial: qcom_geni_serial: Remove set_rfr_wm() and related variab=
les
      tty: serial: qcom_geni_serial: Remove xfer_mode variable

Samuel Holland (1):
      ASoC: sun8i-codec: Fix setting DAI data format

Shijie Luo (1):
      ext4: add cond_resched() to __ext4_find_entry()

Suraj Jitindar Singh (2):
      ext4: fix potential race between s_group_info online resizing and acc=
ess
      ext4: fix potential race between s_flex_groups online resizing and ac=
cess

Suren Baghdasaryan (1):
      staging: android: ashmem: Disallow ashmem memory from being remapped

Takashi Iwai (6):
      ALSA: hda: Use scnprintf() for printing texts for sysfs/procfs
      ALSA: hda/realtek - Apply quirk for MSI GP63, too
      ALSA: hda/realtek - Apply quirk for yet another MSI laptop
      ALSA: rawmidi: Avoid bit fields for state flags
      ALSA: seq: Avoid concurrent access to queue flags
      ALSA: seq: Fix concurrent access to queue current tick/time

Theodore Ts'o (1):
      ext4: fix potential race between online resizing and write operations

Thomas Gleixner (3):
      x86/mce/amd: Fix kobject lifetime
      genirq/proc: Reject invalid affinity masks (again)
      xen: Enable interrupts when calling _cond_resched()

Vasily Averin (1):
      mm/memcontrol.c: lost css_put in memcg_expand_shrinker_maps()

Vitaly Kuznetsov (1):
      KVM: nVMX: handle nested posted interrupts when apicv is disabled for=
 L1

Wenwen Wang (2):
      ecryptfs: fix a memory leak bug in parse_tag_1_packet()
      ecryptfs: fix a memory leak bug in ecryptfs_init_messaging()

Zenghui Yu (1):
      genirq/irqdomain: Make sure all irq domain flags are distinct

satya priya (1):
      tty: serial: qcom_geni_serial: Fix RX cancel command failure

wangyan (1):
      jbd2: fix ocfs2 corrupt when clearing block group bits


--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5bgjkACgkQONu9yGCS
aT7t5RAAp5btz8IiCdn4im7CUe9yQtOKgj6zVyNGzB6qB1y4g7yNgMRzrvtNA6g4
+SMdUEMahcVpwX8Qqx94WuK2DyXMXeR8Ou3FG4iGQav0se2x+YH1Tx4T/GzL/98I
gkMFRFZq1zivlq+K9INpVJtosca9Vpb4TjytcsA0UD9VYJ8pQxD3nPuh+b2w5ulL
rf2vgkoEG9LNfqlA2a+Kwvsf8lHZsQYlTCZtjyLM0EqtapaNE4TNuycOw1SDVo+B
49lsUv/2Dct60j7aR8dnkVmilJLHJ/rxPJwTZI4/61TKTcBVxfU53iMQKbojVMhx
AQS6ifFUv1jTMwkhXa3iSbjhaoFSUrlFuPLP4RPqZnP+Hiyt50o2kmtS0UBllFj5
D88wpIKjbFyxvBNtZ8IeMBErrsd3gaDUNse8c8LKRNMhcJNNMPur5FNP+D2YmLDJ
/M3/0nkPKPV3pD1/D/gB22Zs7iddiEP5vjbFgVpenuwxWFCYpetxZ+XcLfXRplOV
WITbP7g95VRzo1tKeJ6AMxVs1d5VMc8P8ps81SPJjpiDkWbcMYLoDBeZ3hoFVOSY
KMkE8AKBgQV8lEYbouAQLAXu06c2Sai8iO1Zc0d1eBXb6aaY97It79djrAq5XExY
hnWrqngw/+Qy2mrWKdXoblhvqzag9MtOLBmqVCxKqK8Q3gUOoc4=
=GAYL
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
