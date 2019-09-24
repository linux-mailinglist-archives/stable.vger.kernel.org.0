Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 424F1BC553
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 11:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504419AbfIXJ6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 05:58:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36418 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2504402AbfIXJ6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 05:58:44 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iChai-0005sf-KH; Tue, 24 Sep 2019 10:58:40 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iChai-00013K-Dl; Tue, 24 Sep 2019 10:58:40 +0100
Message-ID: <f7c66b3b63fa2f085d8e352d67c2097bf331d6ed.camel@decadent.org.uk>
Subject: Linux 3.16.74
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc:     lwn@lwn.net
Date:   Tue, 24 Sep 2019 10:58:34 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-xtw+5YNuh/lG96QhUOBf"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-xtw+5YNuh/lG96QhUOBf
Content-Type: multipart/mixed; boundary="=-9HYtwmGPcZLRw9b9z1hd"


--=-9HYtwmGPcZLRw9b9z1hd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.16.74 kernel.

All users of the 3.16 kernel series should upgrade.

The updated 3.16.y git tree can be found at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
.git linux-3.16.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.gi=
t

The diff from 3.16.73 is attached to this message.

Ben.

------------

 Documentation/x86/mds.rst                         |  44 ++-------
 Makefile                                          |   2 +-
 arch/arm/boot/dts/exynos5260.dtsi                 |   2 +-
 arch/arm/crypto/aesbs-glue.c                      |   4 +
 arch/arm/mach-omap2/omap_hwmod.c                  |   2 +-
 arch/arm/plat-pxa/ssp.c                           |   6 --
 arch/arm64/include/asm/memory.h                   |   8 ++
 arch/powerpc/include/asm/reg_booke.h              |   2 +-
 arch/powerpc/platforms/83xx/usb.c                 |   4 +-
 arch/x86/crypto/crct10dif-pclmul_glue.c           |  13 +--
 arch/x86/include/asm/uaccess.h                    |   7 +-
 arch/x86/kernel/traps.c                           |   8 --
 crypto/crct10dif_generic.c                        |  11 +--
 crypto/salsa20_generic.c                          |   2 +-
 drivers/bluetooth/hci_ldisc.c                     |  10 +-
 drivers/bluetooth/hci_uart.h                      |   1 +
 drivers/clk/tegra/clk-pll.c                       |   4 +-
 drivers/gpu/drm/drm_fb_helper.c                   |  11 +--
 drivers/gpu/drm/radeon/radeon_display.c           |   4 +-
 drivers/hwmon/f71805f.c                           |  15 ++-
 drivers/hwmon/pc87427.c                           |  14 ++-
 drivers/hwmon/smsc47b397.c                        |  13 ++-
 drivers/hwmon/smsc47m1.c                          |  28 ++++--
 drivers/hwmon/vt1211.c                            |  15 ++-
 drivers/hwmon/w83627hf.c                          |  42 +++++++-
 drivers/infiniband/hw/cxgb4/cm.c                  |   2 +
 drivers/iommu/intel-iommu.c                       |   7 +-
 drivers/md/bcache/journal.c                       |  11 ++-
 drivers/md/bcache/super.c                         |  13 ++-
 drivers/media/i2c/soc_camera/ov6650.c             |   2 +
 drivers/media/pci/cx18/cx18-fileops.c             |   2 +-
 drivers/media/pci/ivtv/ivtv-fileops.c             |   2 +-
 drivers/media/platform/davinci/isif.c             |   9 --
 drivers/media/platform/davinci/vpbe.c             |   2 +-
 drivers/media/platform/omap/omap_vout.c           |  15 ++-
 drivers/media/radio/radio-raremono.c              |  30 ++++--
 drivers/media/radio/wl128x/fmdrv_common.c         |  13 ++-
 drivers/media/usb/cpia2/cpia2_usb.c               |   3 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c           |   2 +
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h           |   1 +
 drivers/media/usb/siano/smsusb.c                  |  33 ++++---
 drivers/media/usb/tlg2300/Kconfig                 |   1 +
 drivers/net/bonding/bond_options.c                |   7 --
 drivers/net/ethernet/arc/emac_main.c              |   9 +-
 drivers/net/ethernet/chelsio/cxgb3/l2t.h          |   2 +-
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c |   8 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c         |   2 +-
 drivers/net/wireless/at76c50x-usb.c               |   4 +-
 drivers/net/wireless/ath/ath6kl/wmi.c             |  10 +-
 drivers/net/wireless/mwifiex/ie.c                 |   3 +
 drivers/net/wireless/mwifiex/uap_cmd.c            |  17 +++-
 drivers/net/wireless/mwl8k.c                      |  13 ++-
 drivers/net/wireless/p54/p54pci.c                 |   3 +-
 drivers/net/wireless/p54/p54usb.c                 |  43 ++++----
 drivers/net/wireless/rsi/rsi_91x_mac80211.c       |   1 +
 drivers/pci/pcie/aspm.c                           |  49 +++++++---
 drivers/pci/quirks.c                              |  76 +++++++++++++++
 drivers/platform/x86/alienware-wmi.c              |  19 ++--
 drivers/platform/x86/sony-laptop.c                |   8 +-
 drivers/pwm/core.c                                |  10 +-
 drivers/pwm/pwm-tiehrpwm.c                        |   2 +
 drivers/pwm/sysfs.c                               |  14 +--
 drivers/rtc/interface.c                           |   7 +-
 drivers/scsi/libsas/sas_expander.c                |   2 +
 drivers/scsi/qla2xxx/qla_attr.c                   |   4 +-
 drivers/scsi/qla2xxx/qla_os.c                     |  34 ++++---
 drivers/scsi/qla4xxx/ql4_os.c                     |   2 +-
 drivers/spi/spi-rspi.c                            |  48 +++++----
 drivers/staging/comedi/drivers/dt282x.c           |   3 +-
 drivers/staging/line6/pcm.c                       |   5 +
 drivers/tty/serial/serial_core.c                  |  15 ++-
 drivers/tty/vt/keyboard.c                         |  33 +++++--
 drivers/usb/class/cdc-acm.c                       | 113 +++++++++++++++++-=
----
 drivers/usb/class/cdc-acm.h                       |   4 +
 drivers/usb/misc/rio500.c                         |  24 +++--
 drivers/usb/misc/sisusbvga/sisusb.c               |  15 +--
 drivers/usb/serial/generic.c                      |  57 ++++++++---
 drivers/usb/serial/usb-serial.c                   |  11 ++-
 drivers/vhost/vhost.c                             |   4 +-
 drivers/video/backlight/lm3630a_bl.c              |   4 +-
 drivers/virt/fsl_hypervisor.c                     |  26 ++---
 fs/ceph/super.c                                   |   7 ++
 fs/cifs/smb2ops.c                                 |  14 +--
 fs/ext4/file.c                                    |   7 ++
 fs/ext4/ioctl.c                                   |   2 +-
 fs/fuse/file.c                                    |   9 +-
 fs/gfs2/rgrp.c                                    |  12 ++-
 fs/jbd2/journal.c                                 |   4 +
 fs/nfs/nfs4state.c                                |   4 +
 fs/ocfs2/export.c                                 |  30 +++++-
 fs/xfs/xfs_super.c                                |  10 ++
 include/linux/atalk.h                             |  20 +++-
 include/linux/ieee80211.h                         |   3 +
 include/linux/mfd/da9063/registers.h              |   6 +-
 include/linux/of.h                                |   4 +-
 include/linux/pci.h                               |   2 +
 include/linux/pwm.h                               |   5 -
 include/linux/smpboot.h                           |   2 +-
 include/media/davinci/vpbe.h                      |   2 +-
 include/net/bluetooth/hci_core.h                  |   3 +
 include/net/mac80211.h                            |  13 +++
 kernel/debug/kdb/kdb_main.c                       |   2 +-
 kernel/time/ntp.c                                 |   2 +-
 kernel/trace/trace_events.c                       |   3 -
 lib/kobject_uevent.c                              |   9 +-
 net/appletalk/atalk_proc.c                        |   2 +-
 net/appletalk/ddp.c                               |  37 +++++--
 net/appletalk/sysctl_net_atalk.c                  |   5 +-
 net/bluetooth/hci_conn.c                          |  10 +-
 net/bluetooth/l2cap_core.c                        |  34 +++++--
 net/bridge/netfilter/ebtables.c                   |   4 +-
 net/ipv4/raw.c                                    |   6 +-
 net/mac80211/ieee80211_i.h                        |   3 +
 net/mac80211/mlme.c                               |  16 ++-
 net/mac80211/rx.c                                 |   2 +
 net/mac80211/tdls.c                               |  40 ++++++++
 sound/pci/hda/hda_generic.c                       |   3 +-
 sound/pci/hda/hda_generic.h                       |   1 +
 sound/pci/hda/patch_hdmi.c                        |   6 ++
 sound/pci/hda/patch_realtek.c                     |   5 +-
 sound/soc/codecs/max98090.c                       |  12 +--
 sound/soc/fsl/fsl_esai.c                          |   1 +
 sound/usb/mixer.c                                 |  36 +++++--
 tools/testing/selftests/ipc/msgque.c              |  11 ++-
 virt/kvm/coalesced_mmio.c                         |  17 ++--
 125 files changed, 1069 insertions(+), 488 deletions(-)

Alan Stern (3):
      media: usb: siano: Fix general protection fault in smsusb
      media: usb: siano: Fix false-positive "uninitialized variable" warnin=
g
      p54usb: Fix race between disconnect and firmware loading

Alexander Kochetkov (1):
      net: arc_emac: fix koops caused by sk_buff free

Andrew Vasquez (1):
      scsi: qla2xxx: Fix incorrect region-size setting in optrom SYSFS rout=
ines

Andy Lutomirski (2):
      x86/speculation/mds: Revert CPU buffer clear on double fault exit
      x86/speculation/mds: Improve CPU buffer clear documentation

Arik Nemtsov (1):
      mac80211: add API to request TDLS operation from userspace

Arnd Bergmann (3):
      scsi: qla4xxx: avoid freeing unallocated dma memory
      media: davinci-isif: avoid uninitialized variable use
      appletalk: Fix compile regression

Bart Van Assche (1):
      scsi: qla2xxx: Unregister chrdev if module initialization fails

Ben Hutchings (2):
      media: poseidon: Depend on PM_RUNTIME
      Linux 3.16.74

Bob Peterson (2):
      GFS2: Fix rgrp end rounding problem for bsize < page size
      GFS2: don't set rgrp gl_object until it's inserted into rgrp tree

Brian Masney (1):
      backlight: lm3630a: Return 0 on success in update_status functions

Christian K=C3=B6nig (1):
      drm/radeon: prefer lower reference dividers

Christoph Probst (1):
      cifs: fix strcat buffer overflow and reduce raciness in smb21_set_opl=
ock_level()

Christoph Vogtl=C3=A4nder (1):
      pwm: tiehrpwm: Update shadow register for disabling PWMs

Christophe Leroy (1):
      net: ucc_geth - fix Oops when changing number of buffers in the ring

Colin Ian King (2):
      RDMA/cxgb4: Fix null pointer dereference on alloc_skb failure
      platform/x86: alienware-wmi: fix kfree on potentially uninitialized p=
ointer

Coly Li (1):
      bcache: never set KEY_PTRS of journal key to 0 in journal_reclaim()

Dan Carpenter (11):
      media: ivtv: update *pos correctly in ivtv_read_pos()
      media: cx18: update *pos correctly in cx18_read_pos()
      media: wl128x: Fix an error code in fm_download_firmware()
      media: wl128x: prevent two potential buffer overflows
      media: pvrusb2: Prevent a buffer overflow
      media: omap_vout: potential buffer overflow in vidioc_dqbuf()
      media: davinci/vpbe: array underflow in vpbe_enum_outputs()
      platform/x86: alienware-wmi: printing the wrong error code
      kdb: do a sanity check on the cpu in kdb_per_cpu()
      drivers/virt/fsl_hypervisor.c: dereferencing error pointers in ioctl
      ath6kl: add some bounds checking

Dave Chinner (1):
      xfs: clear sb->s_fs_info on mount failure

David Ahern (1):
      ipv4: Fix raw socket lookup for local traffic

Dmitry Osipenko (1):
      clk: tegra: Fix PLLM programming on Tegra124+ when PMC overrides divi=
der

Elazar Leibovich (1):
      tracing: Fix partial reading of trace event's id file

Eric Biggers (4):
      crypto: crct10dif-generic - fix use via crypto_shash_digest()
      crypto: x86/crct10dif-pcl - fix use via crypto_shash_digest()
      crypto: salsa20 - don't access already-freed walk.iv
      crypto: arm/aes-neonbs - don't access already-freed walk.iv

Florian Westphal (1):
      netfilter: ebtables: CONFIG_COMPAT: reject trailing data after last r=
ule

Geert Uytterhoeven (2):
      spi: rspi: Fix register initialization while runtime-suspended
      spi: rspi: Fix sequencer reset during initialization

Guenter Roeck (6):
      hwmon: (f71805f) Use request_muxed_region for Super-IO accesses
      hwmon: (pc87427) Use request_muxed_region for Super-IO accesses
      hwmon: (smsc47b397) Use request_muxed_region for Super-IO accesses
      hwmon: (smsc47m1) Use request_muxed_region for Super-IO accesses
      hwmon: (w83627hf) Use request_muxed_region for Super-IO accesses
      hwmon: (vt1211) Use request_muxed_region for Super-IO accesses

Gustavo A. R. Silva (2):
      cxgb3/l2t: Fix undefined behaviour
      platform/x86: sony-laptop: Fix unintentional fall-through

Hui Peng (2):
      ALSA: usb-audio: Fix an OOB bug in parse_audio_mixer_unit
      ALSA: usb-audio: Fix a stack buffer overflow bug in check_input_term

Hui Wang (1):
      ALSA: hda/hdmi - Read the pin sense from register when repolling

Ian Abbott (1):
      staging: comedi: dt282x: fix a null pointer deref on interrupt

James Prestwood (1):
      PCI: Mark Atheros AR9462 to avoid bus reset

Janusz Krzysztofik (1):
      media: ov6650: Fix sensor possibly not detected on probe

Jarod Wilson (1):
      bonding: fix arp_validate toggling in active-backup mode

Jason Yan (1):
      scsi: libsas: delete sas port if expander discover failed

Jeff Layton (1):
      ceph: flush dirty inodes before proceeding with remount

Jiri Slaby (1):
      TTY: serial_core, add ->install

Jiufei Xue (1):
      jbd2: check superblock mapped prior to committing

Johan Hovold (3):
      USB: serial: fix initial-termios handling
      USB: cdc-acm: fix unthrottle races
      USB: serial: fix unthrottle races

Johannes Berg (1):
      mac80211: drop robust management frames from unknown TA

Jon Hunter (1):
      ASoC: max98090: Fix restore of DAPM Muxes

Julia Lawall (1):
      powerpc/83xx: Add missing of_node_put() after of_device_is_available(=
)

Kailang Yang (1):
      ALSA: hda/realtek - EAPD turn on later

Karthik D A (1):
      mwifiex: vendor_ie length check for parse WMM IEs

Kees Cook (1):
      selftests/ipc: Fix msgque compiler warnings

Kefeng Wang (1):
      Bluetooth: hci_ldisc: Postpone HCI_UART_PROTO_READY bit set in hci_ua=
rt_set_proto()

Kirill Tkhai (1):
      ext4: actually request zeroing of inode table after grow

Ladislav Michl (2):
      cdc-acm: store in and out pipes in acm structure
      cdc-acm: handle read pipe errors

Laurentiu Tudor (1):
      powerpc/booke64: set RI in default MSR

Liang Chen (1):
      bcache: fix a race between cache register and cacheset unregister

Liu Bo (1):
      fuse: honor RLIMIT_FSIZE in fuse_file_fallocate

Loic Poulain (1):
      Bluetooth: hci_ldisc: Fix null pointer derefence in case of early dat=
a

Lu Baolu (1):
      iommu/vt-d: Set intel_iommu_gfx_mapped correctly

Lukas Czerner (1):
      ext4: fix data corruption caused by overlapping unaligned and aligned=
 IO

Luke Nowakowski-Krijger (1):
      media: radio-raremono: change devm_k*alloc to k*alloc

Lyude Paul (1):
      PCI: Reset Lenovo ThinkPad P50 nvgpu at boot if necessary

Marcel Holtmann (2):
      Bluetooth: Align minimum encryption key size for LE and BR/EDR connec=
tions
      Bluetooth: Fix regression with minimum encryption key size alignment

Matias Karhumaa (1):
      Bluetooth: Fix faulty expression for minimum encryption key size chec=
k

Matt Delco (1):
      KVM: coalesced_mmio: add bounds checking

Mauro Carvalho Chehab (1):
      media: smsusb: better handle optional alignment

Miklos Szeredi (2):
      fuse: fix writepages on 32bit
      fuse: fallocate: fix return with locked inode

Miroslav Lichvar (1):
      ntp: Allow TAI-UTC offset to be set to zero

Noralf Tr=C3=B8nnes (1):
      drm/fb-helper: dpms_legacy(): Only set on connectors in use

Oliver Neukum (5):
      cdc-acm: fix race between callback and unthrottle
      USB: serial: use variable for status
      USB: rio500: refuse more than one device at a time
      media: cpia2_usb: first wake up, then free in disconnect
      USB: sisusbvga: fix oops in error path of sisusb_probe

Pan Bian (1):
      p54: drop device reference count if fails to enable device

Peter Zijlstra (1):
      x86/uaccess: Dont leak the AC flag into __put_user() argument evaluat=
ion

Petr =C5=A0tetiar (1):
      mwl8k: Fix rate_idx underflow

Phong Hoang (1):
      pwm: Fix deadlock warning when removing PWM device

Phong Tran (1):
      of: fix clang -Wunsequenced for be32_to_cpu()

Romain Izard (1):
      usb: cdc-acm: fix race during wakeup blocking TX traffic

S.j. Wang (1):
      ASoC: fsl_esai: Fix missing break in switch statement

Sanjay Konduri (1):
      rsi: add fix for crash during assertions

Sebastian Andrzej Siewior (1):
      smpboot: Place the __percpu annotation correctly

Sergei Trofimovich (1):
      tty/vt: fix write/write race in ioctl(KDSKBSENT) handler

Shuning Zhang (1):
      ocfs2: fix ocfs2 read inode data panic in ocfs2_iget

Slava Pestov (1):
      bcache: fix memory corruption in init error path

Stefan M=C3=A4tje (2):
      PCI: Factor out pcie_retrain_link() function
      PCI: Work around Pericom PCIe-to-PCI bridge Retrain Link erratum

Stephen Suryaputra (1):
      ipv4: Use return value of inet_iif() for __raw_v4_lookup in the while=
 loop

Steve Twiss (1):
      mfd: da9063: Fix OTP control register names to match datasheets for D=
A9063/63L

Stuart Menefy (1):
      ARM: dts: exynos: Fix interrupt for shared EINTs on Exynos5260

Takashi Iwai (3):
      ALSA: usb-audio: Handle the error from snd_usb_mixer_apply_create_qui=
rk()
      ALSA: hda/realtek - Fix overridden device-specific initialization
      ALSA: line6: Fix write on zero-sized buffer

Tetsuo Handa (1):
      kobject: Don't trigger kobject_uevent(KOBJ_REMOVE) twice.

Tony Lindgren (1):
      ARM: OMAP2+: Fix potentially uninitialized return value for _setup_re=
set()

Vincenzo Frascino (1):
      arm64: compat: Reduce address limit

Wen Huang (1):
      mwifiex: Fix three heap overflow at parsing element in cfg80211_ap_se=
ttings

Wenwen Wang (1):
      ALSA: usb-audio: Fix a memory leak bug

Wolfram Sang (1):
      rtc: don't reference bogus function pointer in kdoc

Yu Wang (1):
      mac80211: handle deauthentication/disassociation from TDLS peer

YueHaibing (4):
      ehea: Fix a copy-paste err in ehea_init_port_res
      ARM: pxa: ssp: Fix "WARNING: invalid free of devm_ allocated data"
      at76c50x-usb: Don't register led_trigger if usb_register_driver faile=
d
      appletalk: Fix use-after-free in atalk_proc_exit

ZhangXiaoxu (1):
      NFS4: Fix v4.0 client state corruption when mount

yongduan (1):
      vhost: make sure log_num < in_num

--=20
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                         - Albert Camus



--=-9HYtwmGPcZLRw9b9z1hd
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.16.74.patch"
Content-Disposition: attachment; filename="linux-3.16.74.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Documentation/x86/mds.rst b/Documentation/x86/mds.rst
index 534e9baa4e1d..5d4330be200f 100644
--- a/Documentation/x86/mds.rst
+++ b/Documentation/x86/mds.rst
@@ -142,45 +142,13 @@ Mitigation points
    mds_user_clear.
=20
    The mitigation is invoked in prepare_exit_to_usermode() which covers
-   most of the kernel to user space transitions. There are a few exception=
s
-   which are not invoking prepare_exit_to_usermode() on return to user
-   space. These exceptions use the paranoid exit code.
+   all but one of the kernel to user space transitions.  The exception
+   is when we return from a Non Maskable Interrupt (NMI), which is
+   handled directly in do_nmi().
=20
-   - Non Maskable Interrupt (NMI):
-
-     Access to sensible data like keys, credentials in the NMI context is
-     mostly theoretical: The CPU can do prefetching or execute a
-     misspeculated code path and thereby fetching data which might end up
-     leaking through a buffer.
-
-     But for mounting other attacks the kernel stack address of the task i=
s
-     already valuable information. So in full mitigation mode, the NMI is
-     mitigated on the return from do_nmi() to provide almost complete
-     coverage.
-
-   - Double fault (#DF):
-
-     A double fault is usually fatal, but the ESPFIX workaround, which can
-     be triggered from user space through modify_ldt(2) is a recoverable
-     double fault. #DF uses the paranoid exit path, so explicit mitigation
-     in the double fault handler is required.
-
-   - Machine Check Exception (#MC):
-
-     Another corner case is a #MC which hits between the CPU buffer clear
-     invocation and the actual return to user. As this still is in kernel
-     space it takes the paranoid exit path which does not clear the CPU
-     buffers. So the #MC handler repopulates the buffers to some
-     extent. Machine checks are not reliably controllable and the window i=
s
-     extremly small so mitigation would just tick a checkbox that this
-     theoretical corner case is covered. To keep the amount of special
-     cases small, ignore #MC.
-
-   - Debug Exception (#DB):
-
-     This takes the paranoid exit path only when the INT1 breakpoint is in
-     kernel space. #DB on a user space address takes the regular exit path=
,
-     so no extra mitigation required.
+   (The reason that NMI is special is that prepare_exit_to_usermode() can
+    enable IRQs.  In NMI context, NMIs are blocked, and we don't want to
+    enable IRQs with NMIs blocked.)
=20
=20
 2. C-State transition
diff --git a/Makefile b/Makefile
index 935fc9df7b17..e4979fd42baa 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 16
-SUBLEVEL =3D 73
+SUBLEVEL =3D 74
 EXTRAVERSION =3D
 NAME =3D Museum of Fishiegoodies
=20
diff --git a/arch/arm/boot/dts/exynos5260.dtsi b/arch/arm/boot/dts/exynos52=
60.dtsi
index 5398a60207ca..00d4a5a4bba9 100644
--- a/arch/arm/boot/dts/exynos5260.dtsi
+++ b/arch/arm/boot/dts/exynos5260.dtsi
@@ -211,7 +211,7 @@
 			wakeup-interrupt-controller {
 				compatible =3D "samsung,exynos4210-wakeup-eint";
 				interrupt-parent =3D <&gic>;
-				interrupts =3D <0 32 0>;
+				interrupts =3D <0 48 0>;
 			};
 		};
=20
diff --git a/arch/arm/crypto/aesbs-glue.c b/arch/arm/crypto/aesbs-glue.c
index 15468fbbdea3..8ef813e4c171 100644
--- a/arch/arm/crypto/aesbs-glue.c
+++ b/arch/arm/crypto/aesbs-glue.c
@@ -259,6 +259,8 @@ static int aesbs_xts_encrypt(struct blkcipher_desc *des=
c,
=20
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err =3D blkcipher_walk_virt_block(desc, &walk, 8 * AES_BLOCK_SIZE);
+	if (err)
+		return err;
=20
 	/* generate the initial tweak */
 	AES_encrypt(walk.iv, walk.iv, &ctx->twkey);
@@ -283,6 +285,8 @@ static int aesbs_xts_decrypt(struct blkcipher_desc *des=
c,
=20
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err =3D blkcipher_walk_virt_block(desc, &walk, 8 * AES_BLOCK_SIZE);
+	if (err)
+		return err;
=20
 	/* generate the initial tweak */
 	AES_encrypt(walk.iv, walk.iv, &ctx->twkey);
diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hw=
mod.c
index a0ec4616d7a5..a6987039699a 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -2617,7 +2617,7 @@ static void __init _setup_iclk_autoidle(struct omap_h=
wmod *oh)
  */
 static int __init _setup_reset(struct omap_hwmod *oh)
 {
-	int r;
+	int r =3D 0;
=20
 	if (oh->_state !=3D _HWMOD_STATE_INITIALIZED)
 		return -EINVAL;
diff --git a/arch/arm/plat-pxa/ssp.c b/arch/arm/plat-pxa/ssp.c
index cde15e6ebad3..2bd5b173294d 100644
--- a/arch/arm/plat-pxa/ssp.c
+++ b/arch/arm/plat-pxa/ssp.c
@@ -232,18 +232,12 @@ static int pxa_ssp_probe(struct platform_device *pdev=
)
=20
 static int pxa_ssp_remove(struct platform_device *pdev)
 {
-	struct resource *res;
 	struct ssp_device *ssp;
=20
 	ssp =3D platform_get_drvdata(pdev);
 	if (ssp =3D=3D NULL)
 		return -ENODEV;
=20
-	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-
-	clk_put(ssp->clk);
-
 	mutex_lock(&ssp_lock);
 	list_del(&ssp->node);
 	mutex_unlock(&ssp_lock);
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memor=
y.h
index 902eb708804a..6401f275e62f 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -53,7 +53,15 @@
 #define TASK_SIZE_64		(UL(1) << VA_BITS)
=20
 #ifdef CONFIG_COMPAT
+#ifdef CONFIG_ARM64_64K_PAGES
+/*
+ * With CONFIG_ARM64_64K_PAGES enabled, the last page is occupied
+ * by the compat vectors page.
+ */
 #define TASK_SIZE_32		UL(0x100000000)
+#else
+#define TASK_SIZE_32		(UL(0x100000000) - PAGE_SIZE)
+#endif /* CONFIG_ARM64_64K_PAGES */
 #define TASK_SIZE		(test_thread_flag(TIF_32BIT) ? \
 				TASK_SIZE_32 : TASK_SIZE_64)
 #define TASK_SIZE_OF(tsk)	(test_tsk_thread_flag(tsk, TIF_32BIT) ? \
diff --git a/arch/powerpc/include/asm/reg_booke.h b/arch/powerpc/include/as=
m/reg_booke.h
index 464f1089b532..608f8cd8ea78 100644
--- a/arch/powerpc/include/asm/reg_booke.h
+++ b/arch/powerpc/include/asm/reg_booke.h
@@ -29,7 +29,7 @@
 #if defined(CONFIG_PPC_BOOK3E_64)
 #define MSR_64BIT	MSR_CM
=20
-#define MSR_		(MSR_ME | MSR_CE)
+#define MSR_		(MSR_ME | MSR_RI | MSR_CE)
 #define MSR_KERNEL	(MSR_ | MSR_64BIT)
 #define MSR_USER32	(MSR_ | MSR_PR | MSR_EE)
 #define MSR_USER64	(MSR_USER32 | MSR_64BIT)
diff --git a/arch/powerpc/platforms/83xx/usb.c b/arch/powerpc/platforms/83x=
x/usb.c
index 1ad748bb39b4..7eb4e4c3b980 100644
--- a/arch/powerpc/platforms/83xx/usb.c
+++ b/arch/powerpc/platforms/83xx/usb.c
@@ -222,8 +222,10 @@ int mpc837x_usb_cfg(void)
 	int ret =3D 0;
=20
 	np =3D of_find_compatible_node(NULL, NULL, "fsl-usb2-dr");
-	if (!np || !of_device_is_available(np))
+	if (!np || !of_device_is_available(np)) {
+		of_node_put(np);
 		return -ENODEV;
+	}
 	prop =3D of_get_property(np, "phy_type", NULL);
=20
 	if (!prop || (strcmp(prop, "ulpi") && strcmp(prop, "serial"))) {
diff --git a/arch/x86/crypto/crct10dif-pclmul_glue.c b/arch/x86/crypto/crct=
10dif-pclmul_glue.c
index 13dbd3515256..922e80ebf570 100644
--- a/arch/x86/crypto/crct10dif-pclmul_glue.c
+++ b/arch/x86/crypto/crct10dif-pclmul_glue.c
@@ -76,15 +76,14 @@ static int chksum_final(struct shash_desc *desc, u8 *ou=
t)
 	return 0;
 }
=20
-static int __chksum_finup(__u16 *crcp, const u8 *data, unsigned int len,
-			u8 *out)
+static int __chksum_finup(__u16 crc, const u8 *data, unsigned int len, u8 =
*out)
 {
 	if (irq_fpu_usable()) {
 		kernel_fpu_begin();
-		*(__u16 *)out =3D crc_t10dif_pcl(*crcp, data, len);
+		*(__u16 *)out =3D crc_t10dif_pcl(crc, data, len);
 		kernel_fpu_end();
 	} else
-		*(__u16 *)out =3D crc_t10dif_generic(*crcp, data, len);
+		*(__u16 *)out =3D crc_t10dif_generic(crc, data, len);
 	return 0;
 }
=20
@@ -93,15 +92,13 @@ static int chksum_finup(struct shash_desc *desc, const =
u8 *data,
 {
 	struct chksum_desc_ctx *ctx =3D shash_desc_ctx(desc);
=20
-	return __chksum_finup(&ctx->crc, data, len, out);
+	return __chksum_finup(ctx->crc, data, len, out);
 }
=20
 static int chksum_digest(struct shash_desc *desc, const u8 *data,
 			 unsigned int length, u8 *out)
 {
-	struct chksum_desc_ctx *ctx =3D shash_desc_ctx(desc);
-
-	return __chksum_finup(&ctx->crc, data, length, out);
+	return __chksum_finup(0, data, length, out);
 }
=20
 static struct shash_alg alg =3D {
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.=
h
index 6778b4e078ce..e99cfcc9af9a 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -422,10 +422,11 @@ do {									\
 #define __put_user_nocheck(x, ptr, size)			\
 ({								\
 	int __pu_err;						\
-	__typeof__(*(ptr)) __pu_val;				\
-	__pu_val =3D x;						\
+	__typeof__(*(ptr)) __pu_val =3D (x);			\
+	__typeof__(ptr) __pu_ptr =3D (ptr);			\
+	__typeof__(size) __pu_size =3D (size);			\
 	__uaccess_begin();					\
-	__put_user_size(__pu_val, (ptr), (size), __pu_err, -EFAULT); \
+	__put_user_size(__pu_val, __pu_ptr, __pu_size, __pu_err, -EFAULT); \
 	__uaccess_end();					\
 	__pu_err;						\
 })
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 77a6f3b62786..57b24700c825 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -55,7 +55,6 @@
 #include <asm/fixmap.h>
 #include <asm/mach_traps.h>
 #include <asm/alternative.h>
-#include <asm/nospec-branch.h>
=20
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
@@ -260,13 +259,6 @@ dotraplinkage void do_double_fault(struct pt_regs *reg=
s, long error_code)
 		regs->ip =3D (unsigned long)general_protection;
 		regs->sp =3D (unsigned long)&normal_regs->orig_ax;
=20
-		/*
-		 * This situation can be triggered by userspace via
-		 * modify_ldt(2) and the return does not take the regular
-		 * user space exit, so a CPU buffer clear is required when
-		 * MDS mitigation is enabled.
-		 */
-		mds_user_clear_cpu_buffers();
 		return;
 	}
 #endif
diff --git a/crypto/crct10dif_generic.c b/crypto/crct10dif_generic.c
index c1229614c7e3..eed577714975 100644
--- a/crypto/crct10dif_generic.c
+++ b/crypto/crct10dif_generic.c
@@ -65,10 +65,9 @@ static int chksum_final(struct shash_desc *desc, u8 *out=
)
 	return 0;
 }
=20
-static int __chksum_finup(__u16 *crcp, const u8 *data, unsigned int len,
-			u8 *out)
+static int __chksum_finup(__u16 crc, const u8 *data, unsigned int len, u8 =
*out)
 {
-	*(__u16 *)out =3D crc_t10dif_generic(*crcp, data, len);
+	*(__u16 *)out =3D crc_t10dif_generic(crc, data, len);
 	return 0;
 }
=20
@@ -77,15 +76,13 @@ static int chksum_finup(struct shash_desc *desc, const =
u8 *data,
 {
 	struct chksum_desc_ctx *ctx =3D shash_desc_ctx(desc);
=20
-	return __chksum_finup(&ctx->crc, data, len, out);
+	return __chksum_finup(ctx->crc, data, len, out);
 }
=20
 static int chksum_digest(struct shash_desc *desc, const u8 *data,
 			 unsigned int length, u8 *out)
 {
-	struct chksum_desc_ctx *ctx =3D shash_desc_ctx(desc);
-
-	return __chksum_finup(&ctx->crc, data, length, out);
+	return __chksum_finup(0, data, length, out);
 }
=20
 static struct shash_alg alg =3D {
diff --git a/crypto/salsa20_generic.c b/crypto/salsa20_generic.c
index d7da0eea5622..319d9962552e 100644
--- a/crypto/salsa20_generic.c
+++ b/crypto/salsa20_generic.c
@@ -186,7 +186,7 @@ static int encrypt(struct blkcipher_desc *desc,
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err =3D blkcipher_walk_virt_block(desc, &walk, 64);
=20
-	salsa20_ivsetup(ctx, walk.iv);
+	salsa20_ivsetup(ctx, desc->info);
=20
 	while (walk.nbytes >=3D 64) {
 		salsa20_encrypt_bytes(ctx, walk.dst.virt.addr,
diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 9ad437053e22..d90b3d04ef31 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -225,7 +225,7 @@ static int hci_uart_flush(struct hci_dev *hdev)
 	tty_ldisc_flush(tty);
 	tty_driver_flush_buffer(tty);
=20
-	if (test_bit(HCI_UART_PROTO_SET, &hu->flags))
+	if (test_bit(HCI_UART_PROTO_READY, &hu->flags))
 		hu->proto->flush(hu);
=20
 	return 0;
@@ -342,7 +342,7 @@ static void hci_uart_tty_close(struct tty_struct *tty)
=20
 	cancel_work_sync(&hu->write_work);
=20
-	if (test_and_clear_bit(HCI_UART_PROTO_SET, &hu->flags)) {
+	if (test_and_clear_bit(HCI_UART_PROTO_READY, &hu->flags)) {
 		if (hdev) {
 			if (test_bit(HCI_UART_REGISTERED, &hu->flags))
 				hci_unregister_dev(hdev);
@@ -350,6 +350,7 @@ static void hci_uart_tty_close(struct tty_struct *tty)
 		}
 		hu->proto->close(hu);
 	}
+	clear_bit(HCI_UART_PROTO_SET, &hu->flags);
=20
 	kfree(hu);
 }
@@ -376,7 +377,7 @@ static void hci_uart_tty_wakeup(struct tty_struct *tty)
 	if (tty !=3D hu->tty)
 		return;
=20
-	if (test_bit(HCI_UART_PROTO_SET, &hu->flags))
+	if (test_bit(HCI_UART_PROTO_READY, &hu->flags))
 		hci_uart_tx_wakeup(hu);
 }
=20
@@ -399,7 +400,7 @@ static void hci_uart_tty_receive(struct tty_struct *tty=
, const u8 *data, char *f
 	if (!hu || tty !=3D hu->tty)
 		return;
=20
-	if (!test_bit(HCI_UART_PROTO_SET, &hu->flags))
+	if (!test_bit(HCI_UART_PROTO_READY, &hu->flags))
 		return;
=20
 	spin_lock(&hu->rx_lock);
@@ -483,6 +484,7 @@ static int hci_uart_set_proto(struct hci_uart *hu, int =
id)
 		return err;
 	}
=20
+	set_bit(HCI_UART_PROTO_READY, &hu->flags);
 	return 0;
 }
=20
diff --git a/drivers/bluetooth/hci_uart.h b/drivers/bluetooth/hci_uart.h
index 58e0bb8c041b..c94830240dd7 100644
--- a/drivers/bluetooth/hci_uart.h
+++ b/drivers/bluetooth/hci_uart.h
@@ -81,6 +81,7 @@ struct hci_uart {
 /* HCI_UART proto flag bits */
 #define HCI_UART_PROTO_SET	0
 #define HCI_UART_REGISTERED	1
+#define HCI_UART_PROTO_READY	2
=20
 /* TX states  */
 #define HCI_UART_SENDING	1
diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 637b62ccc91e..529967c0ee4a 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -486,8 +486,8 @@ static void _update_pll_mnp(struct tegra_clk_pll *pll,
 		pll_override_writel(val, params->pmc_divp_reg, pll);
=20
 		val =3D pll_override_readl(params->pmc_divnm_reg, pll);
-		val &=3D ~(divm_mask(pll) << div_nmp->override_divm_shift) |
-			~(divn_mask(pll) << div_nmp->override_divn_shift);
+		val &=3D ~((divm_mask(pll) << div_nmp->override_divm_shift) |
+			(divn_mask(pll) << div_nmp->override_divn_shift));
 		val |=3D (cfg->m << div_nmp->override_divm_shift) |
 			(cfg->n << div_nmp->override_divn_shift);
 		pll_override_writel(val, params->pmc_divnm_reg, pll);
diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helpe=
r.c
index ad0e612c5b57..7cb959b1e3e9 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -453,8 +453,8 @@ static void drm_fb_helper_dpms(struct fb_info *info, in=
t dpms_mode)
 {
 	struct drm_fb_helper *fb_helper =3D info->par;
 	struct drm_device *dev =3D fb_helper->dev;
-	struct drm_crtc *crtc;
 	struct drm_connector *connector;
+	struct drm_mode_set *modeset;
 	int i, j;
=20
 	/*
@@ -475,14 +475,13 @@ static void drm_fb_helper_dpms(struct fb_info *info, =
int dpms_mode)
 	}
=20
 	for (i =3D 0; i < fb_helper->crtc_count; i++) {
-		crtc =3D fb_helper->crtc_info[i].mode_set.crtc;
+		modeset =3D &fb_helper->crtc_info[i].mode_set;
=20
-		if (!crtc->enabled)
+		if (!modeset->crtc->enabled)
 			continue;
=20
-		/* Walk the connectors & encoders on this fb turning them on/off */
-		for (j =3D 0; j < fb_helper->connector_count; j++) {
-			connector =3D fb_helper->connector_info[j]->connector;
+		for (j =3D 0; j < modeset->num_connectors; j++) {
+			connector =3D modeset->connectors[j];
 			connector->funcs->dpms(connector, dpms_mode);
 			drm_object_property_set_value(&connector->base,
 				dev->mode_config.dpms_property, dpms_mode);
diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/rade=
on/radeon_display.c
index 2c5fedc69820..465548827475 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -942,12 +942,12 @@ static void avivo_get_fb_ref_div(unsigned nom, unsign=
ed den, unsigned post_div,
 	ref_div_max =3D max(min(100 / post_div, ref_div_max), 1u);
=20
 	/* get matching reference and feedback divider */
-	*ref_div =3D min(max(DIV_ROUND_CLOSEST(den, post_div), 1u), ref_div_max);
+	*ref_div =3D min(max(den/post_div, 1u), ref_div_max);
 	*fb_div =3D DIV_ROUND_CLOSEST(nom * *ref_div * post_div, den);
=20
 	/* limit fb divider to its maximum */
         if (*fb_div > fb_div_max) {
-		*ref_div =3D DIV_ROUND_CLOSEST(*ref_div * fb_div_max, *fb_div);
+		*ref_div =3D (*ref_div * fb_div_max)/(*fb_div);
 		*fb_div =3D fb_div_max;
 	}
 }
diff --git a/drivers/hwmon/f71805f.c b/drivers/hwmon/f71805f.c
index 9e57b77ecd34..c9fc6c88dc56 100644
--- a/drivers/hwmon/f71805f.c
+++ b/drivers/hwmon/f71805f.c
@@ -96,17 +96,23 @@ superio_select(int base, int ld)
 	outb(ld, base + 1);
 }
=20
-static inline void
+static inline int
 superio_enter(int base)
 {
+	if (!request_muxed_region(base, 2, DRVNAME))
+		return -EBUSY;
+
 	outb(0x87, base);
 	outb(0x87, base);
+
+	return 0;
 }
=20
 static inline void
 superio_exit(int base)
 {
 	outb(0xaa, base);
+	release_region(base, 2);
 }
=20
 /*
@@ -1562,7 +1568,7 @@ static int __init f71805f_device_add(unsigned short a=
ddress,
 static int __init f71805f_find(int sioaddr, unsigned short *address,
 			       struct f71805f_sio_data *sio_data)
 {
-	int err =3D -ENODEV;
+	int err;
 	u16 devid;
=20
 	static const char * const names[] =3D {
@@ -1570,8 +1576,11 @@ static int __init f71805f_find(int sioaddr, unsigned=
 short *address,
 		"F71872F/FG or F71806F/FG",
 	};
=20
-	superio_enter(sioaddr);
+	err =3D superio_enter(sioaddr);
+	if (err)
+		return err;
=20
+	err =3D -ENODEV;
 	devid =3D superio_inw(sioaddr, SIO_REG_MANID);
 	if (devid !=3D SIO_FINTEK_ID)
 		goto exit;
diff --git a/drivers/hwmon/pc87427.c b/drivers/hwmon/pc87427.c
index 9e4684e747ea..b0d3cede4938 100644
--- a/drivers/hwmon/pc87427.c
+++ b/drivers/hwmon/pc87427.c
@@ -106,6 +106,13 @@ static const char *logdev_str[2] =3D { DRVNAME " FMC",=
 DRVNAME " HMC" };
 #define LD_IN		1
 #define LD_TEMP		1
=20
+static inline int superio_enter(int sioaddr)
+{
+	if (!request_muxed_region(sioaddr, 2, DRVNAME))
+		return -EBUSY;
+	return 0;
+}
+
 static inline void superio_outb(int sioaddr, int reg, int val)
 {
 	outb(reg, sioaddr);
@@ -122,6 +129,7 @@ static inline void superio_exit(int sioaddr)
 {
 	outb(0x02, sioaddr);
 	outb(0x02, sioaddr + 1);
+	release_region(sioaddr, 2);
 }
=20
 /*
@@ -1221,7 +1229,11 @@ static int __init pc87427_find(int sioaddr, struct p=
c87427_sio_data *sio_data)
 {
 	u16 val;
 	u8 cfg, cfg_b;
-	int i, err =3D 0;
+	int i, err;
+
+	err =3D superio_enter(sioaddr);
+	if (err)
+		return err;
=20
 	/* Identify device */
 	val =3D force_id ? force_id : superio_inb(sioaddr, SIOREG_DEVID);
diff --git a/drivers/hwmon/smsc47b397.c b/drivers/hwmon/smsc47b397.c
index bd89e87bd6ae..9b62248bd67e 100644
--- a/drivers/hwmon/smsc47b397.c
+++ b/drivers/hwmon/smsc47b397.c
@@ -72,14 +72,19 @@ static inline void superio_select(int ld)
 	superio_outb(0x07, ld);
 }
=20
-static inline void superio_enter(void)
+static inline int superio_enter(void)
 {
+	if (!request_muxed_region(REG, 2, DRVNAME))
+		return -EBUSY;
+
 	outb(0x55, REG);
+	return 0;
 }
=20
 static inline void superio_exit(void)
 {
 	outb(0xAA, REG);
+	release_region(REG, 2);
 }
=20
 #define SUPERIO_REG_DEVID	0x20
@@ -338,8 +343,12 @@ static int __init smsc47b397_find(void)
 	u8 id, rev;
 	char *name;
 	unsigned short addr;
+	int err;
+
+	err =3D superio_enter();
+	if (err)
+		return err;
=20
-	superio_enter();
 	id =3D force_id ? force_id : superio_inb(SUPERIO_REG_DEVID);
=20
 	switch (id) {
diff --git a/drivers/hwmon/smsc47m1.c b/drivers/hwmon/smsc47m1.c
index 23a22c4eee51..8b0cebd1576e 100644
--- a/drivers/hwmon/smsc47m1.c
+++ b/drivers/hwmon/smsc47m1.c
@@ -73,16 +73,21 @@ superio_inb(int reg)
 /* logical device for fans is 0x0A */
 #define superio_select() superio_outb(0x07, 0x0A)
=20
-static inline void
+static inline int
 superio_enter(void)
 {
+	if (!request_muxed_region(REG, 2, DRVNAME))
+		return -EBUSY;
+
 	outb(0x55, REG);
+	return 0;
 }
=20
 static inline void
 superio_exit(void)
 {
 	outb(0xAA, REG);
+	release_region(REG, 2);
 }
=20
 #define SUPERIO_REG_ACT		0x30
@@ -495,8 +500,12 @@ static int __init smsc47m1_find(struct smsc47m1_sio_da=
ta *sio_data)
 {
 	u8 val;
 	unsigned short addr;
+	int err;
+
+	err =3D superio_enter();
+	if (err)
+		return err;
=20
-	superio_enter();
 	val =3D force_id ? force_id : superio_inb(SUPERIO_REG_DEVID);
=20
 	/*
@@ -572,13 +581,14 @@ static int __init smsc47m1_find(struct smsc47m1_sio_d=
ata *sio_data)
 static void smsc47m1_restore(const struct smsc47m1_sio_data *sio_data)
 {
 	if ((sio_data->activate & 0x01) =3D=3D 0) {
-		superio_enter();
-		superio_select();
-
-		pr_info("Disabling device\n");
-		superio_outb(SUPERIO_REG_ACT, sio_data->activate);
-
-		superio_exit();
+		if (!superio_enter()) {
+			superio_select();
+			pr_info("Disabling device\n");
+			superio_outb(SUPERIO_REG_ACT, sio_data->activate);
+			superio_exit();
+		} else {
+			pr_warn("Failed to disable device\n");
+		}
 	}
 }
=20
diff --git a/drivers/hwmon/vt1211.c b/drivers/hwmon/vt1211.c
index 344b22ec2553..73b9aa094007 100644
--- a/drivers/hwmon/vt1211.c
+++ b/drivers/hwmon/vt1211.c
@@ -226,15 +226,21 @@ static inline void superio_select(int sio_cip, int ld=
n)
 	outb(ldn, sio_cip + 1);
 }
=20
-static inline void superio_enter(int sio_cip)
+static inline int superio_enter(int sio_cip)
 {
+	if (!request_muxed_region(sio_cip, 2, DRVNAME))
+		return -EBUSY;
+
 	outb(0x87, sio_cip);
 	outb(0x87, sio_cip);
+
+	return 0;
 }
=20
 static inline void superio_exit(int sio_cip)
 {
 	outb(0xaa, sio_cip);
+	release_region(sio_cip, 2);
 }
=20
 /* ---------------------------------------------------------------------
@@ -1280,11 +1286,14 @@ static int __init vt1211_device_add(unsigned short =
address)
=20
 static int __init vt1211_find(int sio_cip, unsigned short *address)
 {
-	int err =3D -ENODEV;
+	int err;
 	int devid;
=20
-	superio_enter(sio_cip);
+	err =3D superio_enter(sio_cip);
+	if (err)
+		return err;
=20
+	err =3D -ENODEV;
 	devid =3D force_id ? force_id : superio_inb(sio_cip, SIO_VT1211_DEVID);
 	if (devid !=3D SIO_VT1211_ID)
 		goto EXIT;
diff --git a/drivers/hwmon/w83627hf.c b/drivers/hwmon/w83627hf.c
index c1726be3654c..39312b44f12c 100644
--- a/drivers/hwmon/w83627hf.c
+++ b/drivers/hwmon/w83627hf.c
@@ -130,17 +130,23 @@ superio_select(struct w83627hf_sio_data *sio, int ld)
 	outb(ld,  sio->sioaddr + 1);
 }
=20
-static inline void
+static inline int
 superio_enter(struct w83627hf_sio_data *sio)
 {
+	if (!request_muxed_region(sio->sioaddr, 2, DRVNAME))
+		return -EBUSY;
+
 	outb(0x87, sio->sioaddr);
 	outb(0x87, sio->sioaddr);
+
+	return 0;
 }
=20
 static inline void
 superio_exit(struct w83627hf_sio_data *sio)
 {
 	outb(0xAA, sio->sioaddr);
+	release_region(sio->sioaddr, 2);
 }
=20
 #define W627_DEVID 0x52
@@ -1273,7 +1279,7 @@ static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
 static int __init w83627hf_find(int sioaddr, unsigned short *addr,
 				struct w83627hf_sio_data *sio_data)
 {
-	int err =3D -ENODEV;
+	int err;
 	u16 val;
=20
 	static __initconst char *const names[] =3D {
@@ -1285,7 +1291,11 @@ static int __init w83627hf_find(int sioaddr, unsigne=
d short *addr,
 	};
=20
 	sio_data->sioaddr =3D sioaddr;
-	superio_enter(sio_data);
+	err =3D superio_enter(sio_data);
+	if (err)
+		return err;
+
+	err =3D -ENODEV;
 	val =3D force_id ? force_id : superio_inb(sio_data, DEVID);
 	switch (val) {
 	case W627_DEVID:
@@ -1639,9 +1649,21 @@ static int w83627thf_read_gpio5(struct platform_devi=
ce *pdev)
 	struct w83627hf_sio_data *sio_data =3D dev_get_platdata(&pdev->dev);
 	int res =3D 0xff, sel;
=20
-	superio_enter(sio_data);
+	if (superio_enter(sio_data)) {
+		/*
+		 * Some other driver reserved the address space for itself.
+		 * We don't want to fail driver instantiation because of that,
+		 * so display a warning and keep going.
+		 */
+		dev_warn(&pdev->dev,
+			 "Can not read VID data: Failed to enable SuperIO access\n");
+		return res;
+	}
+
 	superio_select(sio_data, W83627HF_LD_GPIO5);
=20
+	res =3D 0xff;
+
 	/* Make sure these GPIO pins are enabled */
 	if (!(superio_inb(sio_data, W83627THF_GPIO5_EN) & (1<<3))) {
 		dev_dbg(&pdev->dev, "GPIO5 disabled, no VID function\n");
@@ -1672,7 +1694,17 @@ static int w83687thf_read_vid(struct platform_device=
 *pdev)
 	struct w83627hf_sio_data *sio_data =3D dev_get_platdata(&pdev->dev);
 	int res =3D 0xff;
=20
-	superio_enter(sio_data);
+	if (superio_enter(sio_data)) {
+		/*
+		 * Some other driver reserved the address space for itself.
+		 * We don't want to fail driver instantiation because of that,
+		 * so display a warning and keep going.
+		 */
+		dev_warn(&pdev->dev,
+			 "Can not read VID data: Failed to enable SuperIO access\n");
+		return res;
+	}
+
 	superio_select(sio_data, W83627HF_LD_HWM);
=20
 	/* Make sure these GPIO pins are enabled */
diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4=
/cm.c
index bf488ae4dbe4..5faeb51be5c0 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -346,6 +346,8 @@ static struct sk_buff *get_skb(struct sk_buff *skb, int=
 len, gfp_t gfp)
 		skb_reset_transport_header(skb);
 	} else {
 		skb =3D alloc_skb(len, gfp);
+		if (!skb)
+			return NULL;
 	}
 	t4_set_arp_err_handler(skb, NULL, NULL);
 	return skb;
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c2a44d2ca5b6..f2e7408eb91f 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3578,9 +3578,7 @@ static void __init init_no_remapping_devices(void)
=20
 		/* This IOMMU has *only* gfx devices. Either bypass it or
 		   set the gfx_mapped flag, as appropriate */
-		if (dmar_map_gfx) {
-			intel_iommu_gfx_mapped =3D 1;
-		} else {
+		if (!dmar_map_gfx) {
 			drhd->ignored =3D 1;
 			for_each_active_dev_scope(drhd->devices,
 						  drhd->devices_cnt, i, dev)
@@ -4074,6 +4072,9 @@ int __init intel_iommu_init(void)
 		goto out_free_reserved_range;
 	}
=20
+	if (dmar_map_gfx)
+		intel_iommu_gfx_mapped =3D 1;
+
 	init_no_remapping_devices();
=20
 	ret =3D init_dmars();
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 280a1f90f772..74678696f126 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -507,11 +507,11 @@ static void journal_reclaim(struct cache_set *c)
 				  ca->sb.nr_this_dev);
 	}
=20
-	bkey_init(k);
-	SET_KEY_PTRS(k, n);
-
-	if (n)
+	if (n) {
+		bkey_init(k);
+		SET_KEY_PTRS(k, n);
 		c->journal.blocks_free =3D c->sb.bucket_size >> c->block_bits;
+	}
 out:
 	if (!journal_full(&c->journal))
 		__closure_wake_up(&c->journal.wait);
@@ -635,6 +635,9 @@ static void journal_write_unlocked(struct closure *cl)
 		ca->journal.seq[ca->journal.cur_idx] =3D w->data->seq;
 	}
=20
+	/* If KEY_PTRS(k) =3D=3D 0, this jset gets lost in air */
+	BUG_ON(i =3D=3D 0);
+
 	atomic_dec_bug(&fifo_back(&c->journal.pin));
 	bch_journal_next(&c->journal);
 	journal_reclaim(c);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e56c2880b01b..50eb75b6ee25 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1364,9 +1364,13 @@ static void cache_set_free(struct closure *cl)
 	bch_btree_cache_free(c);
 	bch_journal_free(c);
=20
+	mutex_lock(&bch_register_lock);
 	for_each_cache(ca, c, i)
-		if (ca)
+		if (ca) {
+			ca->set =3D NULL;
+			c->cache[ca->sb.nr_this_dev] =3D NULL;
 			kobject_put(&ca->kobj);
+		}
=20
 	bch_bset_sort_state_free(&c->sort);
 	free_pages((unsigned long) c->uuids, ilog2(bucket_pages(c)));
@@ -1383,7 +1387,6 @@ static void cache_set_free(struct closure *cl)
 		mempool_destroy(c->search);
 	kfree(c->devices);
=20
-	mutex_lock(&bch_register_lock);
 	list_del(&c->list);
 	mutex_unlock(&bch_register_lock);
=20
@@ -1804,8 +1807,10 @@ void bch_cache_release(struct kobject *kobj)
 	struct cache *ca =3D container_of(kobj, struct cache, kobj);
 	unsigned i;
=20
-	if (ca->set)
+	if (ca->set) {
+		BUG_ON(ca->set->cache[ca->sb.nr_this_dev] !=3D ca);
 		ca->set->cache[ca->sb.nr_this_dev] =3D NULL;
+	}
=20
 	bio_split_pool_free(&ca->bio_split_hook);
=20
@@ -1868,7 +1873,7 @@ static int cache_alloc(struct cache_sb *sb, struct ca=
che *ca)
 }
=20
 static int register_cache(struct cache_sb *sb, struct page *sb_page,
-				  struct block_device *bdev, struct cache *ca)
+				struct block_device *bdev, struct cache *ca)
 {
 	char name[BDEVNAME_SIZE];
 	const char *err =3D NULL; /* must be set for any error case */
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_=
camera/ov6650.c
index ab01598ec83f..c0e25bf55fb8 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -829,6 +829,8 @@ static int ov6650_video_probe(struct i2c_client *client=
)
 	if (ret < 0)
 		return ret;
=20
+	msleep(20);
+
 	/*
 	 * check and show product ID and manufacturer ID
 	 */
diff --git a/drivers/media/pci/cx18/cx18-fileops.c b/drivers/media/pci/cx18=
/cx18-fileops.c
index 76a3b4ac541e..441af711f5e2 100644
--- a/drivers/media/pci/cx18/cx18-fileops.c
+++ b/drivers/media/pci/cx18/cx18-fileops.c
@@ -489,7 +489,7 @@ static ssize_t cx18_read_pos(struct cx18_stream *s, cha=
r __user *ubuf,
=20
 	CX18_DEBUG_HI_FILE("read %zd from %s, got %zd\n", count, s->name, rc);
 	if (rc > 0)
-		pos +=3D rc;
+		*pos +=3D rc;
 	return rc;
 }
=20
diff --git a/drivers/media/pci/ivtv/ivtv-fileops.c b/drivers/media/pci/ivtv=
/ivtv-fileops.c
index e5ff6277ca85..d38cb158ddb3 100644
--- a/drivers/media/pci/ivtv/ivtv-fileops.c
+++ b/drivers/media/pci/ivtv/ivtv-fileops.c
@@ -420,7 +420,7 @@ static ssize_t ivtv_read_pos(struct ivtv_stream *s, cha=
r __user *ubuf, size_t co
=20
 	IVTV_DEBUG_HI_FILE("read %zd from %s, got %zd\n", count, s->name, rc);
 	if (rc > 0)
-		pos +=3D rc;
+		*pos +=3D rc;
 	return rc;
 }
=20
diff --git a/drivers/media/platform/davinci/isif.c b/drivers/media/platform=
/davinci/isif.c
index 3332cca632e5..dff781b85b24 100644
--- a/drivers/media/platform/davinci/isif.c
+++ b/drivers/media/platform/davinci/isif.c
@@ -890,9 +890,7 @@ static int isif_set_hw_if_params(struct vpfe_hw_if_para=
m *params)
 static int isif_config_ycbcr(void)
 {
 	struct isif_ycbcr_config *params =3D &isif_cfg.ycbcr;
-	struct vpss_pg_frame_size frame_size;
 	u32 modeset =3D 0, ccdcfg =3D 0;
-	struct vpss_sync_pol sync;
=20
 	dev_dbg(isif_cfg.dev, "\nStarting isif_config_ycbcr...");
=20
@@ -980,13 +978,6 @@ static int isif_config_ycbcr(void)
 		/* two fields are interleaved in memory */
 		regw(0x00000249, SDOFST);
=20
-	/* Setup test pattern if enabled */
-	if (isif_cfg.bayer.config_params.test_pat_gen) {
-		sync.ccdpg_hdpol =3D params->hd_pol;
-		sync.ccdpg_vdpol =3D params->vd_pol;
-		dm365_vpss_set_sync_pol(sync);
-		dm365_vpss_set_pg_frame_size(frame_size);
-	}
 	return 0;
 }
=20
diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform=
/davinci/vpbe.c
index 33b9660b7f77..6560762a8f7b 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -130,7 +130,7 @@ static int vpbe_enum_outputs(struct vpbe_device *vpbe_d=
ev,
 			     struct v4l2_output *output)
 {
 	struct vpbe_config *cfg =3D vpbe_dev->cfg;
-	int temp_index =3D output->index;
+	unsigned int temp_index =3D output->index;
=20
 	if (temp_index >=3D cfg->num_outputs)
 		return -EINVAL;
diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platfo=
rm/omap/omap_vout.c
index af9bb7425b34..40715ba83319 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -1596,23 +1596,20 @@ static int vidioc_dqbuf(struct file *file, void *fh=
, struct v4l2_buffer *b)
 	unsigned long size;
 	struct videobuf_buffer *vb;
=20
-	vb =3D q->bufs[b->index];
-
 	if (!vout->streaming)
 		return -EINVAL;
=20
-	if (file->f_flags & O_NONBLOCK)
-		/* Call videobuf_dqbuf for non blocking mode */
-		ret =3D videobuf_dqbuf(q, (struct v4l2_buffer *)b, 1);
-	else
-		/* Call videobuf_dqbuf for  blocking mode */
-		ret =3D videobuf_dqbuf(q, (struct v4l2_buffer *)b, 0);
+	ret =3D videobuf_dqbuf(q, b, !!(file->f_flags & O_NONBLOCK));
+	if (ret)
+		return ret;
+
+	vb =3D q->bufs[b->index];
=20
 	addr =3D (unsigned long) vout->buf_phy_addr[vb->i];
 	size =3D (unsigned long) vb->size;
 	dma_unmap_single(vout->vid_dev->v4l2_dev.dev,  addr,
 				size, DMA_TO_DEVICE);
-	return ret;
+	return 0;
 }
=20
 static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type=
 i)
diff --git a/drivers/media/radio/radio-raremono.c b/drivers/media/radio/rad=
io-raremono.c
index 7b3bdbb1be73..59c902b68940 100644
--- a/drivers/media/radio/radio-raremono.c
+++ b/drivers/media/radio/radio-raremono.c
@@ -283,6 +283,14 @@ static int vidioc_g_frequency(struct file *file, void =
*priv,
 	return 0;
 }
=20
+static void raremono_device_release(struct v4l2_device *v4l2_dev)
+{
+	struct raremono_device *radio =3D to_raremono_dev(v4l2_dev);
+
+	kfree(radio->buffer);
+	kfree(radio);
+}
+
 /* File system interface */
 static const struct v4l2_file_operations usb_raremono_fops =3D {
 	.owner		=3D THIS_MODULE,
@@ -307,12 +315,14 @@ static int usb_raremono_probe(struct usb_interface *i=
ntf,
 	struct raremono_device *radio;
 	int retval =3D 0;
=20
-	radio =3D devm_kzalloc(&intf->dev, sizeof(struct raremono_device), GFP_KE=
RNEL);
-	if (radio)
-		radio->buffer =3D devm_kmalloc(&intf->dev, BUFFER_LENGTH, GFP_KERNEL);
-
-	if (!radio || !radio->buffer)
+	radio =3D kzalloc(sizeof(*radio), GFP_KERNEL);
+	if (!radio)
+		return -ENOMEM;
+	radio->buffer =3D kmalloc(BUFFER_LENGTH, GFP_KERNEL);
+	if (!radio->buffer) {
+		kfree(radio);
 		return -ENOMEM;
+	}
=20
 	radio->usbdev =3D interface_to_usbdev(intf);
 	radio->intf =3D intf;
@@ -336,7 +346,8 @@ static int usb_raremono_probe(struct usb_interface *int=
f,
 	if (retval !=3D 3 ||
 	    (get_unaligned_be16(&radio->buffer[1]) & 0xfff) =3D=3D 0x0242) {
 		dev_info(&intf->dev, "this is not Thanko's Raremono.\n");
-		return -ENODEV;
+		retval =3D -ENODEV;
+		goto free_mem;
 	}
=20
 	dev_info(&intf->dev, "Thanko's Raremono connected: (%04X:%04X)\n",
@@ -345,7 +356,7 @@ static int usb_raremono_probe(struct usb_interface *int=
f,
 	retval =3D v4l2_device_register(&intf->dev, &radio->v4l2_dev);
 	if (retval < 0) {
 		dev_err(&intf->dev, "couldn't register v4l2_device\n");
-		return retval;
+		goto free_mem;
 	}
=20
 	mutex_init(&radio->lock);
@@ -357,6 +368,7 @@ static int usb_raremono_probe(struct usb_interface *int=
f,
 	radio->vdev.ioctl_ops =3D &usb_raremono_ioctl_ops;
 	radio->vdev.lock =3D &radio->lock;
 	radio->vdev.release =3D video_device_release_empty;
+	radio->v4l2_dev.release =3D raremono_device_release;
=20
 	usb_set_intfdata(intf, &radio->v4l2_dev);
=20
@@ -373,6 +385,10 @@ static int usb_raremono_probe(struct usb_interface *in=
tf,
 	}
 	dev_err(&intf->dev, "could not register video device\n");
 	v4l2_device_unregister(&radio->v4l2_dev);
+
+free_mem:
+	kfree(radio->buffer);
+	kfree(radio);
 	return retval;
 }
=20
diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radi=
o/wl128x/fmdrv_common.c
index 4b2e9e8298e1..d2975a3f1d02 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -494,7 +494,8 @@ int fmc_send_cmd(struct fmdev *fmdev, u8 fm_op, u16 typ=
e, void *payload,
 		return -EIO;
 	}
 	/* Send response data to caller */
-	if (response !=3D NULL && response_len !=3D NULL && evt_hdr->dlen) {
+	if (response !=3D NULL && response_len !=3D NULL && evt_hdr->dlen &&
+	    evt_hdr->dlen <=3D payload_len) {
 		/* Skip header info and copy only response data */
 		skb_pull(skb, sizeof(struct fm_event_msg_hdr));
 		memcpy(response, skb->data, evt_hdr->dlen);
@@ -590,6 +591,8 @@ static void fm_irq_handle_flag_getcmd_resp(struct fmdev=
 *fmdev)
 		return;
=20
 	fm_evt_hdr =3D (void *)skb->data;
+	if (fm_evt_hdr->dlen > sizeof(fmdev->irq_info.flag))
+		return;
=20
 	/* Skip header info and copy only response data */
 	skb_pull(skb, sizeof(struct fm_event_msg_hdr));
@@ -1278,8 +1281,9 @@ static int fm_download_firmware(struct fmdev *fmdev, =
const u8 *fw_name)
=20
 		switch (action->type) {
 		case ACTION_SEND_COMMAND:	/* Send */
-			if (fmc_send_cmd(fmdev, 0, 0, action->data,
-						action->size, NULL, NULL))
+			ret =3D fmc_send_cmd(fmdev, 0, 0, action->data,
+					   action->size, NULL, NULL);
+			if (ret)
 				goto rel_fw;
=20
 			cmd_cnt++;
@@ -1317,7 +1321,8 @@ static int load_default_rx_configuration(struct fmdev=
 *fmdev)
 /* Does FM power on sequence */
 static int fm_power_up(struct fmdev *fmdev, u8 mode)
 {
-	u16 payload, asic_id, asic_ver;
+	u16 payload;
+	__be16 asic_id =3D 0, asic_ver =3D 0;
 	int resp_len, ret;
 	u8 fw_name[50];
=20
diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/=
cpia2_usb.c
index 351a78a84c3d..41ea00ac3a87 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -884,7 +884,6 @@ static void cpia2_usb_disconnect(struct usb_interface *=
intf)
 	cpia2_unregister_camera(cam);
 	v4l2_device_disconnect(&cam->v4l2_dev);
 	mutex_unlock(&cam->v4l2_lock);
-	v4l2_device_put(&cam->v4l2_dev);
=20
 	if(cam->buffers) {
 		DBG("Wakeup waiting processes\n");
@@ -897,6 +896,8 @@ static void cpia2_usb_disconnect(struct usb_interface *=
intf)
 	DBG("Releasing interface\n");
 	usb_driver_release_interface(&cpia2_driver, intf);
=20
+	v4l2_device_put(&cam->v4l2_dev);
+
 	LOG("CPiA2 camera disconnected.\n");
 }
=20
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pv=
rusb2/pvrusb2-hdw.c
index 9623b6218214..2f78a4b9f185 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -670,6 +670,8 @@ static int ctrl_get_input(struct pvr2_ctrl *cptr,int *v=
p)
=20
 static int ctrl_check_input(struct pvr2_ctrl *cptr,int v)
 {
+	if (v < 0 || v > PVR2_CVAL_INPUT_MAX)
+		return 0;
 	return ((1 << v) & cptr->hdw->input_allowed_mask) !=3D 0;
 }
=20
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.h b/drivers/media/usb/pv=
rusb2/pvrusb2-hdw.h
index 41847076f51a..005853a66733 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
@@ -54,6 +54,7 @@
 #define PVR2_CVAL_INPUT_COMPOSITE 2
 #define PVR2_CVAL_INPUT_SVIDEO 3
 #define PVR2_CVAL_INPUT_RADIO 4
+#define PVR2_CVAL_INPUT_MAX PVR2_CVAL_INPUT_RADIO
=20
 enum pvr2_config {
 	pvr2_config_empty,    /* No configuration */
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/sms=
usb.c
index dcb8d14e5bf5..dcf044db0c1a 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -359,6 +359,7 @@ static int smsusb_init_device(struct usb_interface *int=
f, int board_id)
 	struct smsdevice_params_t params;
 	struct smsusb_device_t *dev;
 	int i, rc;
+	int align =3D 0;
=20
 	/* create device object */
 	dev =3D kzalloc(sizeof(struct smsusb_device_t), GFP_KERNEL);
@@ -372,6 +373,24 @@ static int smsusb_init_device(struct usb_interface *in=
tf, int board_id)
 	dev->udev =3D interface_to_usbdev(intf);
 	dev->state =3D SMSUSB_DISCONNECTED;
=20
+	for (i =3D 0; i < intf->cur_altsetting->desc.bNumEndpoints; i++) {
+		struct usb_endpoint_descriptor *desc =3D
+				&intf->cur_altsetting->endpoint[i].desc;
+
+		if (desc->bEndpointAddress & USB_DIR_IN) {
+			dev->in_ep =3D desc->bEndpointAddress;
+			align =3D usb_endpoint_maxp(desc) - sizeof(struct sms_msg_hdr);
+		} else {
+			dev->out_ep =3D desc->bEndpointAddress;
+		}
+	}
+
+	pr_debug("in_ep =3D %02x, out_ep =3D %02x\n", dev->in_ep, dev->out_ep);
+	if (!dev->in_ep || !dev->out_ep || align < 0) {  /* Missing endpoints? */
+		smsusb_term_device(intf);
+		return -ENODEV;
+	}
+
 	params.device_type =3D sms_get_board(board_id)->type;
=20
 	switch (params.device_type) {
@@ -386,24 +405,12 @@ static int smsusb_init_device(struct usb_interface *i=
ntf, int board_id)
 		/* fall-thru */
 	default:
 		dev->buffer_size =3D USB2_BUFFER_SIZE;
-		dev->response_alignment =3D
-		    le16_to_cpu(dev->udev->ep_in[1]->desc.wMaxPacketSize) -
-		    sizeof(struct sms_msg_hdr);
+		dev->response_alignment =3D align;
=20
 		params.flags |=3D SMS_DEVICE_FAMILY2;
 		break;
 	}
=20
-	for (i =3D 0; i < intf->cur_altsetting->desc.bNumEndpoints; i++) {
-		if (intf->cur_altsetting->endpoint[i].desc. bEndpointAddress & USB_DIR_I=
N)
-			dev->in_ep =3D intf->cur_altsetting->endpoint[i].desc.bEndpointAddress;
-		else
-			dev->out_ep =3D intf->cur_altsetting->endpoint[i].desc.bEndpointAddress=
;
-	}
-
-	sms_info("in_ep =3D %02x, out_ep =3D %02x",
-		dev->in_ep, dev->out_ep);
-
 	params.device =3D &dev->udev->dev;
 	params.buffer_size =3D dev->buffer_size;
 	params.num_buffers =3D MAX_BUFFERS;
diff --git a/drivers/media/usb/tlg2300/Kconfig b/drivers/media/usb/tlg2300/=
Kconfig
index 645d915267e6..2b41ef01848d 100644
--- a/drivers/media/usb/tlg2300/Kconfig
+++ b/drivers/media/usb/tlg2300/Kconfig
@@ -7,6 +7,7 @@ config VIDEO_TLG2300
 	select VIDEOBUF_VMALLOC
 	select SND_PCM
 	select VIDEOBUF_DVB
+	depends on PM_RUNTIME
=20
 	---help---
 	  This is a video4linux driver for Telegent tlg2300 based TV cards.
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_=
options.c
index 540e0167bf24..2097a18c68f3 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1068,13 +1068,6 @@ static int bond_option_arp_validate_set(struct bondi=
ng *bond,
 {
 	pr_info("%s: Setting arp_validate to %s (%llu)\n",
 		bond->dev->name, newval->string, newval->value);
-
-	if (bond->dev->flags & IFF_UP) {
-		if (!newval->value)
-			bond->recv_probe =3D NULL;
-		else if (bond->params.arp_interval)
-			bond->recv_probe =3D bond_arp_rcv;
-	}
 	bond->params.arp_validate =3D newval->value;
=20
 	return 0;
diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/ar=
c/emac_main.c
index 18e2faccebb0..e1128745906e 100644
--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -150,7 +150,7 @@ static void arc_emac_tx_clean(struct net_device *ndev)
 		struct sk_buff *skb =3D tx_buff->skb;
 		unsigned int info =3D le32_to_cpu(txbd->info);
=20
-		if ((info & FOR_EMAC) || !txbd->data)
+		if ((info & FOR_EMAC) || !txbd->data || !skb)
 			break;
=20
 		if (unlikely(info & (DROP | DEFR | LTCL | UFLO))) {
@@ -178,6 +178,7 @@ static void arc_emac_tx_clean(struct net_device *ndev)
=20
 		txbd->data =3D 0;
 		txbd->info =3D 0;
+		tx_buff->skb =3D NULL;
=20
 		*txbd_dirty =3D (*txbd_dirty + 1) % TX_BD_NUM;
=20
@@ -594,7 +595,6 @@ static int arc_emac_tx(struct sk_buff *skb, struct net_=
device *ndev)
 	dma_unmap_addr_set(&priv->tx_buff[*txbd_curr], addr, addr);
 	dma_unmap_len_set(&priv->tx_buff[*txbd_curr], len, len);
=20
-	priv->tx_buff[*txbd_curr].skb =3D skb;
 	priv->txbd[*txbd_curr].data =3D cpu_to_le32(addr);
=20
 	/* Make sure pointer to data buffer is set */
@@ -604,6 +604,11 @@ static int arc_emac_tx(struct sk_buff *skb, struct net=
_device *ndev)
=20
 	*info =3D cpu_to_le32(FOR_EMAC | FIRST_OR_LAST_MASK | len);
=20
+	/* Make sure info word is set */
+	wmb();
+
+	priv->tx_buff[*txbd_curr].skb =3D skb;
+
 	/* Increment index to point to the next BD */
 	*txbd_curr =3D (*txbd_curr + 1) % TX_BD_NUM;
=20
diff --git a/drivers/net/ethernet/chelsio/cxgb3/l2t.h b/drivers/net/etherne=
t/chelsio/cxgb3/l2t.h
index 8cffcdfd5678..38b5858c335a 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/l2t.h
+++ b/drivers/net/ethernet/chelsio/cxgb3/l2t.h
@@ -75,8 +75,8 @@ struct l2t_data {
 	struct l2t_entry *rover;	/* starting point for next allocation */
 	atomic_t nfree;		/* number of free entries */
 	rwlock_t lock;
-	struct l2t_entry l2tab[0];
 	struct rcu_head rcu_head;	/* to handle rcu cleanup */
+	struct l2t_entry l2tab[];
 };
=20
 typedef void (*arp_failure_handler_func)(struct t3cdev * dev,
diff --git a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c b/drivers/ne=
t/ethernet/freescale/ucc_geth_ethtool.c
index cc83350d56ba..11693f93a17d 100644
--- a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
+++ b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
@@ -253,14 +253,12 @@ uec_set_ringparam(struct net_device *netdev,
 		return -EINVAL;
 	}
=20
+	if (netif_running(netdev))
+		return -EBUSY;
+
 	ug_info->bdRingLenRx[queue] =3D ring->rx_pending;
 	ug_info->bdRingLenTx[queue] =3D ring->tx_pending;
=20
-	if (netif_running(netdev)) {
-		/* FIXME: restart automatically */
-		netdev_info(netdev, "Please re-open the interface\n");
-	}
-
 	return ret;
 }
=20
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethern=
et/ibm/ehea/ehea_main.c
index 50f9f98c0657..87f12766435c 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -1476,7 +1476,7 @@ static int ehea_init_port_res(struct ehea_port *port,=
 struct ehea_port_res *pr,
=20
 	memset(pr, 0, sizeof(struct ehea_port_res));
=20
-	pr->tx_bytes =3D rx_bytes;
+	pr->tx_bytes =3D tx_bytes;
 	pr->tx_packets =3D tx_packets;
 	pr->rx_bytes =3D rx_bytes;
 	pr->rx_packets =3D rx_packets;
diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at7=
6c50x-usb.c
index d48776e4f343..75cd631e32b2 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -2582,8 +2582,8 @@ static int __init at76_mod_init(void)
 	if (result < 0)
 		printk(KERN_ERR DRIVER_NAME
 		       ": usb_register failed (status %d)\n", result);
-
-	led_trigger_register_simple("at76_usb-tx", &ledtrig_tx);
+	else
+		led_trigger_register_simple("at76_usb-tx", &ledtrig_tx);
 	return result;
 }
=20
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/a=
th/ath6kl/wmi.c
index 4d7f9e4712e9..c2778f47ff76 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1155,6 +1155,10 @@ static int ath6kl_wmi_pstream_timeout_event_rx(struc=
t wmi *wmi, u8 *datap,
 		return -EINVAL;
=20
 	ev =3D (struct wmi_pstream_timeout_event *) datap;
+	if (ev->traffic_class >=3D WMM_NUM_AC) {
+		ath6kl_err("invalid traffic class: %d\n", ev->traffic_class);
+		return -EINVAL;
+	}
=20
 	/*
 	 * When the pstream (fat pipe =3D=3D AC) timesout, it means there were
@@ -1496,6 +1500,10 @@ static int ath6kl_wmi_cac_event_rx(struct wmi *wmi, =
u8 *datap, int len,
 		return -EINVAL;
=20
 	reply =3D (struct wmi_cac_event *) datap;
+	if (reply->ac >=3D WMM_NUM_AC) {
+		ath6kl_err("invalid AC: %d\n", reply->ac);
+		return -EINVAL;
+	}
=20
 	if ((reply->cac_indication =3D=3D CAC_INDICATION_ADMISSION_RESP) &&
 	    (reply->status_code !=3D IEEE80211_TSPEC_STATUS_ADMISS_ACCEPTED)) {
@@ -2608,7 +2616,7 @@ int ath6kl_wmi_delete_pstream_cmd(struct wmi *wmi, u8=
 if_idx, u8 traffic_class,
 	u16 active_tsids =3D 0;
 	int ret;
=20
-	if (traffic_class > 3) {
+	if (traffic_class >=3D WMM_NUM_AC) {
 		ath6kl_err("invalid traffic class: %d\n", traffic_class);
 		return -EINVAL;
 	}
diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifi=
ex/ie.c
index 69827b5f96b5..199b9263af97 100644
--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -240,6 +240,9 @@ static int mwifiex_update_vs_ie(const u8 *ies, int ies_=
len,
 		}
=20
 		vs_ie =3D (struct ieee_types_header *)vendor_ie;
+		if (le16_to_cpu(ie->ie_length) + vs_ie->len + 2 >
+			IEEE_MAX_IE_SIZE)
+			return -EINVAL;
 		memcpy(ie->ie_buffer + le16_to_cpu(ie->ie_length),
 		       vs_ie, vs_ie->len + 2);
 		le16_add_cpu(&ie->ie_length, vs_ie->len + 2);
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/=
mwifiex/uap_cmd.c
index a6a6a53cda40..0aed04027149 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -247,6 +247,8 @@ mwifiex_set_uap_rates(struct mwifiex_uap_bss_param *bss=
_cfg,
=20
 	rate_ie =3D (void *)cfg80211_find_ie(WLAN_EID_SUPP_RATES, var_pos, len);
 	if (rate_ie) {
+		if (rate_ie->len > MWIFIEX_SUPPORTED_RATES)
+			return;
 		memcpy(bss_cfg->rates, rate_ie + 1, rate_ie->len);
 		rate_len =3D rate_ie->len;
 	}
@@ -254,8 +256,11 @@ mwifiex_set_uap_rates(struct mwifiex_uap_bss_param *bs=
s_cfg,
 	rate_ie =3D (void *)cfg80211_find_ie(WLAN_EID_EXT_SUPP_RATES,
 					   params->beacon.tail,
 					   params->beacon.tail_len);
-	if (rate_ie)
+	if (rate_ie) {
+		if (rate_ie->len > MWIFIEX_SUPPORTED_RATES - rate_len)
+			return;
 		memcpy(bss_cfg->rates + rate_len, rate_ie + 1, rate_ie->len);
+	}
=20
 	return;
 }
@@ -364,7 +369,7 @@ mwifiex_set_wmm_params(struct mwifiex_private *priv,
 		       struct cfg80211_ap_settings *params)
 {
 	const u8 *vendor_ie;
-	struct ieee_types_header *wmm_ie;
+	const u8 *wmm_ie;
 	u8 wmm_oui[] =3D {0x00, 0x50, 0xf2, 0x02};
=20
 	vendor_ie =3D cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
@@ -372,9 +377,11 @@ mwifiex_set_wmm_params(struct mwifiex_private *priv,
 					    params->beacon.tail,
 					    params->beacon.tail_len);
 	if (vendor_ie) {
-		wmm_ie =3D (struct ieee_types_header *)vendor_ie;
-		memcpy(&bss_cfg->wmm_info, wmm_ie + 1,
-		       sizeof(bss_cfg->wmm_info));
+		wmm_ie =3D vendor_ie;
+		if (*(wmm_ie + 1) > sizeof(struct mwifiex_types_wmm_info))
+			return;
+		memcpy(&bss_cfg->wmm_info, wmm_ie +
+		       sizeof(struct ieee_types_header), *(wmm_ie + 1));
 		priv->wmm_enabled =3D 1;
 	} else {
 		memset(&bss_cfg->wmm_info, 0, sizeof(bss_cfg->wmm_info));
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 3c0a0a86ba12..fc4d897b1da7 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -436,6 +436,9 @@ static const struct ieee80211_rate mwl8k_rates_50[] =3D=
 {
 #define MWL8K_CMD_UPDATE_STADB		0x1123
 #define MWL8K_CMD_BASTREAM		0x1125
=20
+#define MWL8K_LEGACY_5G_RATE_OFFSET \
+	(ARRAY_SIZE(mwl8k_rates_24) - ARRAY_SIZE(mwl8k_rates_50))
+
 static const char *mwl8k_cmd_name(__le16 cmd, char *buf, int bufsize)
 {
 	u16 command =3D le16_to_cpu(cmd);
@@ -1011,8 +1014,9 @@ mwl8k_rxd_ap_process(void *_rxd, struct ieee80211_rx_=
status *status,
=20
 	if (rxd->channel > 14) {
 		status->band =3D IEEE80211_BAND_5GHZ;
-		if (!(status->flag & RX_FLAG_HT))
-			status->rate_idx -=3D 5;
+		if (!(status->flag & RX_FLAG_HT) &&
+		    status->rate_idx >=3D MWL8K_LEGACY_5G_RATE_OFFSET)
+			status->rate_idx -=3D MWL8K_LEGACY_5G_RATE_OFFSET;
 	} else {
 		status->band =3D IEEE80211_BAND_2GHZ;
 	}
@@ -1119,8 +1123,9 @@ mwl8k_rxd_sta_process(void *_rxd, struct ieee80211_rx=
_status *status,
=20
 	if (rxd->channel > 14) {
 		status->band =3D IEEE80211_BAND_5GHZ;
-		if (!(status->flag & RX_FLAG_HT))
-			status->rate_idx -=3D 5;
+		if (!(status->flag & RX_FLAG_HT) &&
+		    status->rate_idx >=3D MWL8K_LEGACY_5G_RATE_OFFSET)
+			status->rate_idx -=3D MWL8K_LEGACY_5G_RATE_OFFSET;
 	} else {
 		status->band =3D IEEE80211_BAND_2GHZ;
 	}
diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p=
54pci.c
index d411de409050..7dd61b1895db 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -551,7 +551,7 @@ static int p54p_probe(struct pci_dev *pdev,
 	err =3D pci_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "Cannot enable new PCI device\n");
-		return err;
+		goto err_put;
 	}
=20
 	mem_addr =3D pci_resource_start(pdev, 0);
@@ -636,6 +636,7 @@ static int p54p_probe(struct pci_dev *pdev,
 	pci_release_regions(pdev);
  err_disable_dev:
 	pci_disable_device(pdev);
+err_put:
 	pci_dev_put(pdev);
 	return err;
 }
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p=
54usb.c
index 043bd1c23c19..4a197a32d78c 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -33,6 +33,8 @@ MODULE_ALIAS("prism54usb");
 MODULE_FIRMWARE("isl3886usb");
 MODULE_FIRMWARE("isl3887usb");
=20
+static struct usb_driver p54u_driver;
+
 /*
  * Note:
  *
@@ -921,9 +923,9 @@ static void p54u_load_firmware_cb(const struct firmware=
 *firmware,
 {
 	struct p54u_priv *priv =3D context;
 	struct usb_device *udev =3D priv->udev;
+	struct usb_interface *intf =3D priv->intf;
 	int err;
=20
-	complete(&priv->fw_wait_load);
 	if (firmware) {
 		priv->fw =3D firmware;
 		err =3D p54u_start_ops(priv);
@@ -932,26 +934,22 @@ static void p54u_load_firmware_cb(const struct firmwa=
re *firmware,
 		dev_err(&udev->dev, "Firmware not found.\n");
 	}
=20
-	if (err) {
-		struct device *parent =3D priv->udev->dev.parent;
-
-		dev_err(&udev->dev, "failed to initialize device (%d)\n", err);
-
-		if (parent)
-			device_lock(parent);
+	complete(&priv->fw_wait_load);
+	/*
+	 * At this point p54u_disconnect may have already freed
+	 * the "priv" context. Do not use it anymore!
+	 */
+	priv =3D NULL;
=20
-		device_release_driver(&udev->dev);
-		/*
-		 * At this point p54u_disconnect has already freed
-		 * the "priv" context. Do not use it anymore!
-		 */
-		priv =3D NULL;
+	if (err) {
+		dev_err(&intf->dev, "failed to initialize device (%d)\n", err);
=20
-		if (parent)
-			device_unlock(parent);
+		usb_lock_device(udev);
+		usb_driver_release_interface(&p54u_driver, intf);
+		usb_unlock_device(udev);
 	}
=20
-	usb_put_dev(udev);
+	usb_put_intf(intf);
 }
=20
 static int p54u_load_firmware(struct ieee80211_hw *dev,
@@ -972,14 +970,14 @@ static int p54u_load_firmware(struct ieee80211_hw *de=
v,
 	dev_info(&priv->udev->dev, "Loading firmware file %s\n",
 	       p54u_fwlist[i].fw);
=20
-	usb_get_dev(udev);
+	usb_get_intf(intf);
 	err =3D request_firmware_nowait(THIS_MODULE, 1, p54u_fwlist[i].fw,
 				      device, GFP_KERNEL, priv,
 				      p54u_load_firmware_cb);
 	if (err) {
 		dev_err(&priv->udev->dev, "(p54usb) cannot load firmware %s "
 					  "(%d)!\n", p54u_fwlist[i].fw, err);
-		usb_put_dev(udev);
+		usb_put_intf(intf);
 	}
=20
 	return err;
@@ -1011,8 +1009,6 @@ static int p54u_probe(struct usb_interface *intf,
 	skb_queue_head_init(&priv->rx_queue);
 	init_usb_anchor(&priv->submitted);
=20
-	usb_get_dev(udev);
-
 	/* really lazy and simple way of figuring out if we're a 3887 */
 	/* TODO: should just stick the identification in the device table */
 	i =3D intf->altsetting->desc.bNumEndpoints;
@@ -1053,10 +1049,8 @@ static int p54u_probe(struct usb_interface *intf,
 		priv->upload_fw =3D p54u_upload_firmware_net2280;
 	}
 	err =3D p54u_load_firmware(dev, intf);
-	if (err) {
-		usb_put_dev(udev);
+	if (err)
 		p54_free_common(dev);
-	}
 	return err;
 }
=20
@@ -1072,7 +1066,6 @@ static void p54u_disconnect(struct usb_interface *int=
f)
 	wait_for_completion(&priv->fw_wait_load);
 	p54_unregister_common(dev);
=20
-	usb_put_dev(interface_to_usbdev(intf));
 	release_firmware(priv->fw);
 	p54_free_common(dev);
 }
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wire=
less/rsi/rsi_91x_mac80211.c
index 54aaeb09debf..74474a39b750 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -199,6 +199,7 @@ void rsi_mac80211_detach(struct rsi_hw *adapter)
 		ieee80211_stop_queues(hw);
 		ieee80211_unregister_hw(hw);
 		ieee80211_free_hw(hw);
+		adapter->hw =3D NULL;
 	}
=20
 	rsi_remove_dbgfs(adapter);
diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 0dc5f2bece17..e8551aa9e70f 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -175,6 +175,38 @@ static void pcie_clkpm_cap_init(struct pcie_link_state=
 *link, int blacklist)
 	link->clkpm_capable =3D (blacklist) ? 0 : capable;
 }
=20
+static bool pcie_retrain_link(struct pcie_link_state *link)
+{
+	struct pci_dev *parent =3D link->pdev;
+	unsigned long start_jiffies;
+	u16 reg16;
+
+	pcie_capability_read_word(parent, PCI_EXP_LNKCTL, &reg16);
+	reg16 |=3D PCI_EXP_LNKCTL_RL;
+	pcie_capability_write_word(parent, PCI_EXP_LNKCTL, reg16);
+	if (parent->clear_retrain_link) {
+		/*
+		 * Due to an erratum in some devices the Retrain Link bit
+		 * needs to be cleared again manually to allow the link
+		 * training to succeed.
+		 */
+		reg16 &=3D ~PCI_EXP_LNKCTL_RL;
+		pcie_capability_write_word(parent, PCI_EXP_LNKCTL, reg16);
+	}
+
+	/* Wait for link training end. Break out after waiting for timeout */
+	start_jiffies =3D jiffies;
+	for (;;) {
+		pcie_capability_read_word(parent, PCI_EXP_LNKSTA, &reg16);
+		if (!(reg16 & PCI_EXP_LNKSTA_LT))
+			break;
+		if (time_after(jiffies, start_jiffies + LINK_RETRAIN_TIMEOUT))
+			break;
+		msleep(1);
+	}
+	return !(reg16 & PCI_EXP_LNKSTA_LT);
+}
+
 /*
  * pcie_aspm_configure_common_clock: check if the 2 ends of a link
  *   could use common clock. If they are, configure them to use the
@@ -184,7 +216,6 @@ static void pcie_aspm_configure_common_clock(struct pci=
e_link_state *link)
 {
 	int same_clock =3D 1;
 	u16 reg16, parent_reg, child_reg[8];
-	unsigned long start_jiffies;
 	struct pci_dev *child, *parent =3D link->pdev;
 	struct pci_bus *linkbus =3D parent->subordinate;
 	/*
@@ -224,21 +255,7 @@ static void pcie_aspm_configure_common_clock(struct pc=
ie_link_state *link)
 		reg16 &=3D ~PCI_EXP_LNKCTL_CCC;
 	pcie_capability_write_word(parent, PCI_EXP_LNKCTL, reg16);
=20
-	/* Retrain link */
-	reg16 |=3D PCI_EXP_LNKCTL_RL;
-	pcie_capability_write_word(parent, PCI_EXP_LNKCTL, reg16);
-
-	/* Wait for link training end. Break out after waiting for timeout */
-	start_jiffies =3D jiffies;
-	for (;;) {
-		pcie_capability_read_word(parent, PCI_EXP_LNKSTA, &reg16);
-		if (!(reg16 & PCI_EXP_LNKSTA_LT))
-			break;
-		if (time_after(jiffies, start_jiffies + LINK_RETRAIN_TIMEOUT))
-			break;
-		msleep(1);
-	}
-	if (!(reg16 & PCI_EXP_LNKSTA_LT))
+	if (pcie_retrain_link(link))
 		return;
=20
 	/* Training failed. Restore common clock configurations */
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 57cc4e7d2bbc..22f4b928fbdf 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2047,6 +2047,23 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10f1,=
 quirk_disable_aspm_l0s);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10f4, quirk_disable_aspm_l0=
s);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1508, quirk_disable_aspm_l0=
s);
=20
+/*
+ * Some Pericom PCIe-to-PCI bridges in reverse mode need the PCIe Retrain
+ * Link bit cleared after starting the link retrain process to allow this
+ * process to finish.
+ *
+ * Affected devices: PI7C9X110, PI7C9X111SL, PI7C9X130.  See also the
+ * Pericom Errata Sheet PI7C9X111SLB_errata_rev1.2_102711.pdf.
+ */
+static void quirk_enable_clear_retrain_link(struct pci_dev *dev)
+{
+	dev->clear_retrain_link =3D 1;
+	dev_info(&dev->dev, "Enable PCIe Retrain Link quirk\n");
+}
+DECLARE_PCI_FIXUP_HEADER(0x12d8, 0xe110, quirk_enable_clear_retrain_link);
+DECLARE_PCI_FIXUP_HEADER(0x12d8, 0xe111, quirk_enable_clear_retrain_link);
+DECLARE_PCI_FIXUP_HEADER(0x12d8, 0xe130, quirk_enable_clear_retrain_link);
+
 static void fixup_rev1_53c810(struct pci_dev *dev)
 {
 	/* rev 1 ncr53c810 chips don't set the class at all which means
@@ -3137,6 +3154,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003=
0, quirk_no_bus_reset);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0032, quirk_no_bus_reset=
);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003c, quirk_no_bus_reset=
);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0033, quirk_no_bus_reset=
);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0034, quirk_no_bus_reset=
);
=20
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
@@ -3882,3 +3900,61 @@ void pci_dev_specific_enable_acs(struct pci_dev *dev=
)
 		}
 	}
 }
+
+/*
+ * On Lenovo Thinkpad P50 SKUs with a Nvidia Quadro M1000M, the BIOS does
+ * not always reset the secondary Nvidia GPU between reboots if the system
+ * is configured to use Hybrid Graphics mode.  This results in the GPU
+ * being left in whatever state it was in during the *previous* boot, whic=
h
+ * causes spurious interrupts from the GPU, which in turn causes us to
+ * disable the wrong IRQ and end up breaking the touchpad.  Unsurprisingly=
,
+ * this also completely breaks nouveau.
+ *
+ * Luckily, it seems a simple reset of the Nvidia GPU brings it back to a
+ * clean state and fixes all these issues.
+ *
+ * When the machine is configured in Dedicated display mode, the issue
+ * doesn't occur.  Fortunately the GPU advertises NoReset+ when in this
+ * mode, so we can detect that and avoid resetting it.
+ */
+static void quirk_reset_lenovo_thinkpad_p50_nvgpu(struct pci_dev *pdev)
+{
+	void __iomem *map;
+	int ret;
+
+	if (pdev->subsystem_vendor !=3D PCI_VENDOR_ID_LENOVO ||
+	    pdev->subsystem_device !=3D 0x222e ||
+	    !pdev->reset_fn)
+		return;
+
+	if (pci_enable_device_mem(pdev))
+		return;
+
+	/*
+	 * Based on nvkm_device_ctor() in
+	 * drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
+	 */
+	map =3D pci_iomap(pdev, 0, 0x23000);
+	if (!map) {
+		dev_err(&pdev->dev, "Can't map MMIO space\n");
+		goto out_disable;
+	}
+
+	/*
+	 * Make sure the GPU looks like it's been POSTed before resetting
+	 * it.
+	 */
+	if (ioread32(map + 0x2240c) & 0x2) {
+		dev_info(&pdev->dev, FW_BUG "GPU left initialized by EFI, resetting\n");
+		ret =3D pci_reset_function(pdev);
+		if (ret < 0)
+			dev_err(&pdev->dev, "Failed to reset GPU: %d\n", ret);
+	}
+
+	iounmap(map);
+out_disable:
+	pci_disable_device(pdev);
+}
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, 0x13b1,
+			      PCI_CLASS_DISPLAY_VGA, 8,
+			      quirk_reset_lenovo_thinkpad_p50_nvgpu);
diff --git a/drivers/platform/x86/alienware-wmi.c b/drivers/platform/x86/al=
ienware-wmi.c
index 2899727069e6..f32ecc4ad878 100644
--- a/drivers/platform/x86/alienware-wmi.c
+++ b/drivers/platform/x86/alienware-wmi.c
@@ -433,23 +433,22 @@ static acpi_status alienware_hdmi_command(struct hdmi=
_args *in_args,
=20
 	input.length =3D (acpi_size) sizeof(*in_args);
 	input.pointer =3D in_args;
-	if (out_data !=3D NULL) {
+	if (out_data) {
 		output.length =3D ACPI_ALLOCATE_BUFFER;
 		output.pointer =3D NULL;
 		status =3D wmi_evaluate_method(WMAX_CONTROL_GUID, 1,
 					     command, &input, &output);
-	} else
+		if (ACPI_SUCCESS(status)) {
+			obj =3D (union acpi_object *)output.pointer;
+			if (obj && obj->type =3D=3D ACPI_TYPE_INTEGER)
+				*out_data =3D (u32)obj->integer.value;
+		}
+		kfree(output.pointer);
+	} else {
 		status =3D wmi_evaluate_method(WMAX_CONTROL_GUID, 1,
 					     command, &input, NULL);
-
-	if (ACPI_SUCCESS(status) && out_data !=3D NULL) {
-		obj =3D (union acpi_object *)output.pointer;
-		if (obj && obj->type =3D=3D ACPI_TYPE_INTEGER)
-			*out_data =3D (u32) obj->integer.value;
 	}
-	kfree(output.pointer);
 	return status;
-
 }
=20
 static ssize_t show_hdmi_cable(struct device *dev,
@@ -495,7 +494,7 @@ static ssize_t show_hdmi_source(struct device *dev,
 			return scnprintf(buf, PAGE_SIZE,
 					 "input [gpu] unknown\n");
 	}
-	pr_err("alienware-wmi: unknown HDMI source status: %d\n", out_data);
+	pr_err("alienware-wmi: unknown HDMI source status: %u\n", status);
 	return scnprintf(buf, PAGE_SIZE, "input gpu [unknown]\n");
 }
=20
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony=
-laptop.c
index e7ff8152ef2b..87528c0ec793 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -4401,14 +4401,16 @@ sony_pic_read_possible_resource(struct acpi_resourc=
e *resource, void *context)
 			}
 			return AE_OK;
 		}
+
+	case ACPI_RESOURCE_TYPE_END_TAG:
+		return AE_OK;
+
 	default:
 		dprintk("Resource %d isn't an IRQ nor an IO port\n",
 			resource->type);
+		return AE_CTRL_TERMINATE;
=20
-	case ACPI_RESOURCE_TYPE_END_TAG:
-		return AE_OK;
 	}
-	return AE_CTRL_TERMINATE;
 }
=20
 static int sony_pic_possible_resources(struct acpi_device *device)
diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 825b5e48be08..c45de1d475a7 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -273,10 +273,12 @@ int pwmchip_add(struct pwm_chip *chip)
 	if (IS_ENABLED(CONFIG_OF))
 		of_pwmchip_add(chip);
=20
-	pwmchip_sysfs_export(chip);
-
 out:
 	mutex_unlock(&pwm_lock);
+
+	if (!ret)
+		pwmchip_sysfs_export(chip);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(pwmchip_add);
@@ -293,7 +295,7 @@ int pwmchip_remove(struct pwm_chip *chip)
 	unsigned int i;
 	int ret =3D 0;
=20
-	pwmchip_sysfs_unexport_children(chip);
+	pwmchip_sysfs_unexport(chip);
=20
 	mutex_lock(&pwm_lock);
=20
@@ -313,8 +315,6 @@ int pwmchip_remove(struct pwm_chip *chip)
=20
 	free_pwms(chip);
=20
-	pwmchip_sysfs_unexport(chip);
-
 out:
 	mutex_unlock(&pwm_lock);
 	return ret;
diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 5fa585a817d9..255285269582 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -379,6 +379,8 @@ static void ehrpwm_pwm_disable(struct pwm_chip *chip, s=
truct pwm_device *pwm)
 	}
=20
 	/* Update shadow register first before modifying active register */
+	ehrpwm_modify(pc->mmio_base, AQSFRC, AQSFRC_RLDCSF_MASK,
+		      AQSFRC_RLDCSF_ZRO);
 	ehrpwm_modify(pc->mmio_base, AQCSFRC, aqcsfrc_mask, aqcsfrc_val);
 	/*
 	 * Changes to immediate action on Action Qualifier. This puts
diff --git a/drivers/pwm/sysfs.c b/drivers/pwm/sysfs.c
index 5b64f09ce314..41f4ef9640ac 100644
--- a/drivers/pwm/sysfs.c
+++ b/drivers/pwm/sysfs.c
@@ -328,19 +328,6 @@ void pwmchip_sysfs_export(struct pwm_chip *chip)
 }
=20
 void pwmchip_sysfs_unexport(struct pwm_chip *chip)
-{
-	struct device *parent;
-
-	parent =3D class_find_device(&pwm_class, NULL, chip,
-				   pwmchip_sysfs_match);
-	if (parent) {
-		/* for class_find_device() */
-		put_device(parent);
-		device_unregister(parent);
-	}
-}
-
-void pwmchip_sysfs_unexport_children(struct pwm_chip *chip)
 {
 	struct device *parent;
 	unsigned int i;
@@ -358,6 +345,7 @@ void pwmchip_sysfs_unexport_children(struct pwm_chip *c=
hip)
 	}
=20
 	put_device(parent);
+	device_unregister(parent);
 }
=20
 static int __init pwm_sysfs_init(void)
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 05eeeb537ff8..b05517c75f5b 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -492,10 +492,9 @@ int rtc_update_irq_enable(struct rtc_device *rtc, unsi=
gned int enabled)
 	mutex_unlock(&rtc->ops_lock);
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	/*
-	 * Enable emulation if the driver did not provide
-	 * the update_irq_enable function pointer or if returned
-	 * -EINVAL to signal that it has been configured without
-	 * interrupts or that are not available at the moment.
+	 * Enable emulation if the driver returned -EINVAL to signal that it has
+	 * been configured without interrupts or they are not available at the
+	 * moment.
 	 */
 	if (err =3D=3D -EINVAL)
 		err =3D rtc_dev_update_irq_enable_emul(rtc, enabled);
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_e=
xpander.c
index 65826111d996..bee4c6c614a1 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -977,6 +977,8 @@ static struct domain_device *sas_ex_discover_expander(
 		list_del(&child->dev_list_node);
 		spin_unlock_irq(&parent->port->dev_list_lock);
 		sas_put_device(child);
+		sas_port_delete(phy->port);
+		phy->port =3D NULL;
 		return NULL;
 	}
 	list_add_tail(&child->siblings, &parent->ex_dev.children);
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_att=
r.c
index 5ef9fa6c5a91..b3deae861900 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -423,7 +423,7 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struc=
t kobject *kobj,
 		}
=20
 		ha->optrom_region_start =3D start;
-		ha->optrom_region_size =3D start + size;
+		ha->optrom_region_size =3D size;
=20
 		ha->optrom_state =3D QLA_SREADING;
 		ha->optrom_buffer =3D vmalloc(ha->optrom_region_size);
@@ -495,7 +495,7 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struc=
t kobject *kobj,
 		}
=20
 		ha->optrom_region_start =3D start;
-		ha->optrom_region_size =3D start + size;
+		ha->optrom_region_size =3D size;
=20
 		ha->optrom_state =3D QLA_SWRITING;
 		ha->optrom_buffer =3D vmalloc(ha->optrom_region_size);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 168b21dcc1bf..86ab0b1a3e16 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5775,8 +5775,7 @@ qla2x00_module_init(void)
 	/* Initialize target kmem_cache and mem_pools */
 	ret =3D qlt_init();
 	if (ret < 0) {
-		kmem_cache_destroy(srb_cachep);
-		return ret;
+		goto destroy_cache;
 	} else if (ret > 0) {
 		/*
 		 * If initiator mode is explictly disabled by qlt_init(),
@@ -5795,11 +5794,10 @@ qla2x00_module_init(void)
 	qla2xxx_transport_template =3D
 	    fc_attach_transport(&qla2xxx_transport_functions);
 	if (!qla2xxx_transport_template) {
-		kmem_cache_destroy(srb_cachep);
 		ql_log(ql_log_fatal, NULL, 0x0002,
 		    "fc_attach_transport failed...Failing load!.\n");
-		qlt_exit();
-		return -ENODEV;
+		ret =3D -ENODEV;
+		goto qlt_exit;
 	}
=20
 	apidev_major =3D register_chrdev(0, QLA2XXX_APIDEV, &apidev_fops);
@@ -5811,27 +5809,37 @@ qla2x00_module_init(void)
 	qla2xxx_transport_vport_template =3D
 	    fc_attach_transport(&qla2xxx_transport_vport_functions);
 	if (!qla2xxx_transport_vport_template) {
-		kmem_cache_destroy(srb_cachep);
-		qlt_exit();
-		fc_release_transport(qla2xxx_transport_template);
 		ql_log(ql_log_fatal, NULL, 0x0004,
 		    "fc_attach_transport vport failed...Failing load!.\n");
-		return -ENODEV;
+		ret =3D -ENODEV;
+		goto unreg_chrdev;
 	}
 	ql_log(ql_log_info, NULL, 0x0005,
 	    "QLogic Fibre Channel HBA Driver: %s.\n",
 	    qla2x00_version_str);
 	ret =3D pci_register_driver(&qla2xxx_pci_driver);
 	if (ret) {
-		kmem_cache_destroy(srb_cachep);
-		qlt_exit();
-		fc_release_transport(qla2xxx_transport_template);
-		fc_release_transport(qla2xxx_transport_vport_template);
 		ql_log(ql_log_fatal, NULL, 0x0006,
 		    "pci_register_driver failed...ret=3D%d Failing load!.\n",
 		    ret);
+		goto release_vport_transport;
 	}
 	return ret;
+
+release_vport_transport:
+	fc_release_transport(qla2xxx_transport_vport_template);
+
+unreg_chrdev:
+	if (apidev_major >=3D 0)
+		unregister_chrdev(apidev_major, QLA2XXX_APIDEV);
+	fc_release_transport(qla2xxx_transport_template);
+
+qlt_exit:
+	qlt_exit();
+
+destroy_cache:
+	kmem_cache_destroy(srb_cachep);
+	return ret;
 }
=20
 /**
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 320206376206..91bceca76aa9 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5923,7 +5923,7 @@ static int get_fw_boot_info(struct scsi_qla_host *ha,=
 uint16_t ddb_index[])
 		val =3D rd_nvram_byte(ha, sec_addr);
 		if (val & BIT_7)
 			ddb_index[1] =3D (val & 0x7f);
-
+		goto exit_boot_info;
 	} else if (is_qla80XX(ha)) {
 		buf =3D dma_alloc_coherent(&ha->pdev->dev, size,
 					 &buf_dma, GFP_KERNEL);
diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index 237ebbce8282..d9c2d3bfc50c 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -277,7 +277,8 @@ static int rspi_set_config_register(struct rspi_data *r=
spi, int access_size)
 	/* Sets parity, interrupt mask */
 	rspi_write8(rspi, 0x00, RSPI_SPCR2);
=20
-	/* Sets SPCMD */
+	/* Resets sequencer */
+	rspi_write8(rspi, 0, RSPI_SPSCR);
 	rspi->spcmd |=3D SPCMD_SPB_8_TO_16(access_size);
 	rspi_write16(rspi, rspi->spcmd, RSPI_SPCMD0);
=20
@@ -311,7 +312,8 @@ static int rspi_rz_set_config_register(struct rspi_data=
 *rspi, int access_size)
 	rspi_write8(rspi, 0x00, RSPI_SSLND);
 	rspi_write8(rspi, 0x00, RSPI_SPND);
=20
-	/* Sets SPCMD */
+	/* Resets sequencer */
+	rspi_write8(rspi, 0, RSPI_SPSCR);
 	rspi->spcmd |=3D SPCMD_SPB_8_TO_16(access_size);
 	rspi_write16(rspi, rspi->spcmd, RSPI_SPCMD0);
=20
@@ -362,7 +364,8 @@ static int qspi_set_config_register(struct rspi_data *r=
spi, int access_size)
 	/* Sets buffer to allow normal operation */
 	rspi_write8(rspi, 0x00, QSPI_SPBFCR);
=20
-	/* Sets SPCMD */
+	/* Resets sequencer */
+	rspi_write8(rspi, 0, RSPI_SPSCR);
 	rspi_write16(rspi, rspi->spcmd, RSPI_SPCMD0);
=20
 	/* Enables SPI function in master mode */
@@ -726,28 +729,6 @@ static int qspi_transfer_one(struct spi_master *master=
, struct spi_device *spi,
 	}
 }
=20
-static int rspi_setup(struct spi_device *spi)
-{
-	struct rspi_data *rspi =3D spi_master_get_devdata(spi->master);
-
-	rspi->max_speed_hz =3D spi->max_speed_hz;
-
-	rspi->spcmd =3D SPCMD_SSLKP;
-	if (spi->mode & SPI_CPOL)
-		rspi->spcmd |=3D SPCMD_CPOL;
-	if (spi->mode & SPI_CPHA)
-		rspi->spcmd |=3D SPCMD_CPHA;
-
-	/* CMOS output mode and MOSI signal from previous transfer */
-	rspi->sppcr =3D 0;
-	if (spi->mode & SPI_LOOP)
-		rspi->sppcr |=3D SPPCR_SPLP;
-
-	set_config_register(rspi, 8);
-
-	return 0;
-}
-
 static u16 qspi_transfer_mode(const struct spi_transfer *xfer)
 {
 	if (xfer->tx_buf)
@@ -817,8 +798,24 @@ static int rspi_prepare_message(struct spi_master *mas=
ter,
 				struct spi_message *msg)
 {
 	struct rspi_data *rspi =3D spi_master_get_devdata(master);
+	struct spi_device *spi =3D msg->spi;
 	int ret;
=20
+	rspi->max_speed_hz =3D spi->max_speed_hz;
+
+	rspi->spcmd =3D SPCMD_SSLKP;
+	if (spi->mode & SPI_CPOL)
+		rspi->spcmd |=3D SPCMD_CPOL;
+	if (spi->mode & SPI_CPHA)
+		rspi->spcmd |=3D SPCMD_CPHA;
+
+	/* CMOS output mode and MOSI signal from previous transfer */
+	rspi->sppcr =3D 0;
+	if (spi->mode & SPI_LOOP)
+		rspi->sppcr |=3D SPPCR_SPLP;
+
+	set_config_register(rspi, 8);
+
 	if (msg->spi->mode &
 	    (SPI_TX_DUAL | SPI_TX_QUAD | SPI_RX_DUAL | SPI_RX_QUAD)) {
 		/* Setup sequencer for messages with multiple transfer modes */
@@ -1119,7 +1116,6 @@ static int rspi_probe(struct platform_device *pdev)
 	init_waitqueue_head(&rspi->wait);
=20
 	master->bus_num =3D pdev->id;
-	master->setup =3D rspi_setup;
 	master->auto_runtime_pm =3D true;
 	master->transfer_one =3D ops->transfer_one;
 	master->prepare_message =3D rspi_prepare_message;
diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/come=
di/drivers/dt282x.c
index c2a66dcf99fe..6a1222c45d35 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -483,7 +483,8 @@ static irqreturn_t dt282x_interrupt(int irq, void *d)
 	}
 #endif
 	cfc_handle_events(dev, s);
-	cfc_handle_events(dev, s_ao);
+	if (s_ao)
+		cfc_handle_events(dev, s_ao);
=20
 	return IRQ_RETVAL(handled);
 }
diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index a3136b189ee5..846d09940161 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -492,6 +492,11 @@ int line6_init_pcm(struct usb_line6 *line6,
 				usb_rcvisocpipe(line6->usbdev, ep_read), 0),
 			usb_maxpacket(line6->usbdev,
 				usb_sndisocpipe(line6->usbdev, ep_write), 1));
+	if (!line6pcm->max_packet_size) {
+		dev_err(line6pcm->line6->ifcdev,
+			"cannot get proper max packet size\n");
+		return -EINVAL;
+	}
=20
 	line6pcm->properties =3D properties;
 	line6->line6pcm =3D line6pcm;
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_c=
ore.c
index 3c614b8c3fdf..493a7af9696f 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1541,6 +1541,16 @@ static void uart_dtr_rts(struct tty_port *port, int =
onoff)
 		uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
 }
=20
+static int uart_install(struct tty_driver *driver, struct tty_struct *tty)
+{
+	struct uart_driver *drv =3D driver->driver_state;
+	struct uart_state *state =3D drv->state + tty->index;
+
+	tty->driver_data =3D state;
+
+	return tty_standard_install(driver, tty);
+}
+
 /*
  * Calls to uart_open are serialised by the tty_lock in
  *   drivers/tty/tty_io.c:tty_open()
@@ -1553,9 +1563,8 @@ static void uart_dtr_rts(struct tty_port *port, int o=
noff)
  */
 static int uart_open(struct tty_struct *tty, struct file *filp)
 {
-	struct uart_driver *drv =3D (struct uart_driver *)tty->driver->driver_sta=
te;
 	int retval, line =3D tty->index;
-	struct uart_state *state =3D drv->state + line;
+	struct uart_state *state =3D tty->driver_data;
 	struct tty_port *port =3D &state->port;
=20
 	pr_debug("uart_open(%d) called\n", line);
@@ -1583,7 +1592,6 @@ static int uart_open(struct tty_struct *tty, struct f=
ile *filp)
 	 * uart_close() will decrement the driver module use count.
 	 * Any failures from here onwards should not touch the count.
 	 */
-	tty->driver_data =3D state;
 	state->uart_port->state =3D state;
 	state->port.low_latency =3D
 		(state->uart_port->flags & UPF_LOW_LATENCY) ? 1 : 0;
@@ -2265,6 +2273,7 @@ static void uart_poll_put_char(struct tty_driver *dri=
ver, int line, char ch)
 #endif
=20
 static const struct tty_operations uart_ops =3D {
+	.install	=3D uart_install,
 	.open		=3D uart_open,
 	.close		=3D uart_close,
 	.write		=3D uart_write,
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index adf4d3124cc6..4e3722d1906f 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -120,6 +120,7 @@ static const int NR_TYPES =3D ARRAY_SIZE(max_vals);
 static struct input_handler kbd_handler;
 static DEFINE_SPINLOCK(kbd_event_lock);
 static DEFINE_SPINLOCK(led_lock);
+static DEFINE_SPINLOCK(func_buf_lock); /* guard 'func_buf'  and friends */
 static unsigned long key_down[BITS_TO_LONGS(KEY_CNT)];	/* keyboard key bit=
map */
 static unsigned char shift_down[NR_SHIFT];		/* shift state counters.. */
 static bool dead_key_next;
@@ -1865,11 +1866,12 @@ int vt_do_kdgkb_ioctl(int cmd, struct kbsentry __us=
er *user_kdgkb, int perm)
 	char *p;
 	u_char *q;
 	u_char __user *up;
-	int sz;
+	int sz, fnw_sz;
 	int delta;
 	char *first_free, *fj, *fnw;
 	int i, j, k;
 	int ret;
+	unsigned long flags;
=20
 	if (!capable(CAP_SYS_TTY_CONFIG))
 		perm =3D 0;
@@ -1912,7 +1914,14 @@ int vt_do_kdgkb_ioctl(int cmd, struct kbsentry __use=
r *user_kdgkb, int perm)
 			goto reterr;
 		}
=20
+		fnw =3D NULL;
+		fnw_sz =3D 0;
+		/* race aginst other writers */
+		again:
+		spin_lock_irqsave(&func_buf_lock, flags);
 		q =3D func_table[i];
+
+		/* fj pointer to next entry after 'q' */
 		first_free =3D funcbufptr + (funcbufsize - funcbufleft);
 		for (j =3D i+1; j < MAX_NR_FUNC && !func_table[j]; j++)
 			;
@@ -1920,10 +1929,12 @@ int vt_do_kdgkb_ioctl(int cmd, struct kbsentry __us=
er *user_kdgkb, int perm)
 			fj =3D func_table[j];
 		else
 			fj =3D first_free;
-
+		/* buffer usage increase by new entry */
 		delta =3D (q ? -strlen(q) : 1) + strlen(kbs->kb_string);
+
 		if (delta <=3D funcbufleft) { 	/* it fits in current buf */
 		    if (j < MAX_NR_FUNC) {
+			/* make enough space for new entry at 'fj' */
 			memmove(fj + delta, fj, first_free - fj);
 			for (k =3D j; k < MAX_NR_FUNC; k++)
 			    if (func_table[k])
@@ -1936,20 +1947,28 @@ int vt_do_kdgkb_ioctl(int cmd, struct kbsentry __us=
er *user_kdgkb, int perm)
 		    sz =3D 256;
 		    while (sz < funcbufsize - funcbufleft + delta)
 		      sz <<=3D 1;
-		    fnw =3D kmalloc(sz, GFP_KERNEL);
-		    if(!fnw) {
-		      ret =3D -ENOMEM;
-		      goto reterr;
+		    if (fnw_sz !=3D sz) {
+		      spin_unlock_irqrestore(&func_buf_lock, flags);
+		      kfree(fnw);
+		      fnw =3D kmalloc(sz, GFP_KERNEL);
+		      fnw_sz =3D sz;
+		      if (!fnw) {
+			ret =3D -ENOMEM;
+			goto reterr;
+		      }
+		      goto again;
 		    }
=20
 		    if (!q)
 		      func_table[i] =3D fj;
+		    /* copy data before insertion point to new location */
 		    if (fj > funcbufptr)
 			memmove(fnw, funcbufptr, fj - funcbufptr);
 		    for (k =3D 0; k < j; k++)
 		      if (func_table[k])
 			func_table[k] =3D fnw + (func_table[k] - funcbufptr);
=20
+		    /* copy data after insertion point to new location */
 		    if (first_free > fj) {
 			memmove(fnw + (fj - funcbufptr) + delta, fj, first_free - fj);
 			for (k =3D j; k < MAX_NR_FUNC; k++)
@@ -1962,7 +1981,9 @@ int vt_do_kdgkb_ioctl(int cmd, struct kbsentry __user=
 *user_kdgkb, int perm)
 		    funcbufleft =3D funcbufleft - delta + sz - funcbufsize;
 		    funcbufsize =3D sz;
 		}
+		/* finally insert item itself */
 		strcpy(func_table[i], kbs->kb_string);
+		spin_unlock_irqrestore(&func_buf_lock, flags);
 		break;
 	}
 	ret =3D 0;
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 2e80f5a221b4..d49c24bff722 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -419,26 +419,61 @@ static void acm_read_bulk_callback(struct urb *urb)
 	struct acm_rb *rb =3D urb->context;
 	struct acm *acm =3D rb->instance;
 	unsigned long flags;
+	int status =3D urb->status;
+	bool stopped =3D false;
+	bool stalled =3D false;
=20
 	dev_vdbg(&acm->data->dev, "%s - urb %d, len %d\n", __func__,
 					rb->index, urb->actual_length);
-	set_bit(rb->index, &acm->read_urbs_free);
=20
 	if (!acm->dev) {
 		dev_dbg(&acm->data->dev, "%s - disconnected\n", __func__);
 		return;
 	}
=20
-	if (urb->status) {
-		dev_dbg(&acm->data->dev, "%s - non-zero urb status: %d\n",
-							__func__, urb->status);
-		if ((urb->status !=3D -ENOENT) || (urb->actual_length =3D=3D 0))
-			return;
+	switch (status) {
+	case 0:
+		usb_mark_last_busy(acm->dev);
+		acm_process_read_urb(acm, urb);
+		break;
+	case -EPIPE:
+		set_bit(EVENT_RX_STALL, &acm->flags);
+		stalled =3D true;
+		break;
+	case -ENOENT:
+	case -ECONNRESET:
+	case -ESHUTDOWN:
+		dev_dbg(&acm->data->dev,
+			"%s - urb shutting down with status: %d\n",
+			__func__, status);
+		stopped =3D true;
+		break;
+	default:
+		dev_dbg(&acm->data->dev,
+			"%s - nonzero urb status received: %d\n",
+			__func__, status);
+		break;
 	}
=20
-	usb_mark_last_busy(acm->dev);
+	/*
+	 * Make sure URB processing is done before marking as free to avoid
+	 * racing with unthrottle() on another CPU. Matches the barriers
+	 * implied by the test_and_clear_bit() in acm_submit_read_urb().
+	 */
+	smp_mb__before_atomic();
+	set_bit(rb->index, &acm->read_urbs_free);
+	/*
+	 * Make sure URB is marked as free before checking the throttled flag
+	 * to avoid racing with unthrottle() on another CPU. Matches the
+	 * smp_mb() in unthrottle().
+	 */
+	smp_mb__after_atomic();
=20
-	acm_process_read_urb(acm, urb);
+	if (stopped || stalled) {
+		if (stalled)
+			schedule_work(&acm->work);
+		return;
+	}
=20
 	/* throttle device if requested by tty */
 	spin_lock_irqsave(&acm->read_lock, flags);
@@ -468,16 +503,30 @@ static void acm_write_bulk(struct urb *urb)
 	spin_lock_irqsave(&acm->write_lock, flags);
 	acm_write_done(acm, wb);
 	spin_unlock_irqrestore(&acm->write_lock, flags);
+	set_bit(EVENT_TTY_WAKEUP, &acm->flags);
 	schedule_work(&acm->work);
 }
=20
 static void acm_softint(struct work_struct *work)
 {
+	int i;
 	struct acm *acm =3D container_of(work, struct acm, work);
=20
 	dev_vdbg(&acm->data->dev, "%s\n", __func__);
=20
-	tty_port_tty_wakeup(&acm->port);
+	if (test_bit(EVENT_RX_STALL, &acm->flags)) {
+		if (!(usb_autopm_get_interface(acm->data))) {
+			for (i =3D 0; i < acm->rx_buflimit; i++)
+				usb_kill_urb(acm->read_urbs[i]);
+			usb_clear_halt(acm->dev, acm->in);
+			acm_submit_read_urbs(acm, GFP_KERNEL);
+			usb_autopm_put_interface(acm->data);
+		}
+		clear_bit(EVENT_RX_STALL, &acm->flags);
+	}
+
+	if (test_and_clear_bit(EVENT_TTY_WAKEUP, &acm->flags))
+		tty_port_tty_wakeup(&acm->port);
 }
=20
 /*
@@ -773,6 +822,9 @@ static void acm_tty_unthrottle(struct tty_struct *tty)
 	acm->throttle_req =3D 0;
 	spin_unlock_irq(&acm->read_lock);
=20
+	/* Matches the smp_mb__after_atomic() in acm_read_bulk_callback(). */
+	smp_mb();
+
 	if (was_throttled)
 		acm_submit_read_urbs(acm, GFP_KERNEL);
 }
@@ -1347,8 +1399,16 @@ static int acm_probe(struct usb_interface *intf,
 	spin_lock_init(&acm->read_lock);
 	mutex_init(&acm->mutex);
 	acm->is_int_ep =3D usb_endpoint_xfer_int(epread);
-	if (acm->is_int_ep)
+	if (acm->is_int_ep) {
 		acm->bInterval =3D epread->bInterval;
+		acm->in =3D usb_rcvintpipe(usb_dev, epread->bEndpointAddress);
+	} else {
+		acm->in =3D usb_rcvbulkpipe(usb_dev, epread->bEndpointAddress);
+	}
+	if (usb_endpoint_xfer_int(epwrite))
+		acm->out =3D usb_sndintpipe(usb_dev, epwrite->bEndpointAddress);
+	else
+		acm->out =3D usb_sndbulkpipe(usb_dev, epwrite->bEndpointAddress);
 	tty_port_init(&acm->port);
 	acm->port.ops =3D &acm_port_ops;
 	init_usb_anchor(&acm->delayed);
@@ -1393,20 +1453,15 @@ static int acm_probe(struct usb_interface *intf,
 		}
 		urb->transfer_flags |=3D URB_NO_TRANSFER_DMA_MAP;
 		urb->transfer_dma =3D rb->dma;
-		if (acm->is_int_ep) {
-			usb_fill_int_urb(urb, acm->dev,
-					 usb_rcvintpipe(usb_dev, epread->bEndpointAddress),
-					 rb->base,
+		if (acm->is_int_ep)
+			usb_fill_int_urb(urb, acm->dev, acm->in, rb->base,
 					 acm->readsize,
 					 acm_read_bulk_callback, rb,
 					 acm->bInterval);
-		} else {
-			usb_fill_bulk_urb(urb, acm->dev,
-					  usb_rcvbulkpipe(usb_dev, epread->bEndpointAddress),
-					  rb->base,
+		else
+			usb_fill_bulk_urb(urb, acm->dev, acm->in, rb->base,
 					  acm->readsize,
 					  acm_read_bulk_callback, rb);
-		}
=20
 		acm->read_urbs[i] =3D urb;
 		__set_bit(i, &acm->read_urbs_free);
@@ -1422,12 +1477,10 @@ static int acm_probe(struct usb_interface *intf,
 		}
=20
 		if (usb_endpoint_xfer_int(epwrite))
-			usb_fill_int_urb(snd->urb, usb_dev,
-				usb_sndintpipe(usb_dev, epwrite->bEndpointAddress),
+			usb_fill_int_urb(snd->urb, usb_dev, acm->out,
 				NULL, acm->writesize, acm_write_bulk, snd, epwrite->bInterval);
 		else
-			usb_fill_bulk_urb(snd->urb, usb_dev,
-				usb_sndbulkpipe(usb_dev, epwrite->bEndpointAddress),
+			usb_fill_bulk_urb(snd->urb, usb_dev, acm->out,
 				NULL, acm->writesize, acm_write_bulk, snd);
 		snd->urb->transfer_flags |=3D URB_NO_TRANSFER_DMA_MAP;
 		if (quirks & SEND_ZERO_PACKET)
@@ -1496,8 +1549,8 @@ static int acm_probe(struct usb_interface *intf,
 	}
=20
 	if (quirks & CLEAR_HALT_CONDITIONS) {
-		usb_clear_halt(usb_dev, usb_rcvbulkpipe(usb_dev, epread->bEndpointAddres=
s));
-		usb_clear_halt(usb_dev, usb_sndbulkpipe(usb_dev, epwrite->bEndpointAddre=
ss));
+		usb_clear_halt(usb_dev, acm->in);
+		usb_clear_halt(usb_dev, acm->out);
 	}
=20
 	return 0;
@@ -1671,6 +1724,15 @@ static int acm_reset_resume(struct usb_interface *in=
tf)
=20
 #endif /* CONFIG_PM */
=20
+static int acm_pre_reset(struct usb_interface *intf)
+{
+	struct acm *acm =3D usb_get_intfdata(intf);
+
+	clear_bit(EVENT_RX_STALL, &acm->flags);
+
+	return 0;
+}
+
 #define NOKIA_PCSUITE_ACM_INFO(x) \
 		USB_DEVICE_AND_INTERFACE_INFO(0x0421, x, \
 		USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM, \
@@ -1946,6 +2008,7 @@ static struct usb_driver acm_driver =3D {
 	.resume =3D	acm_resume,
 	.reset_resume =3D	acm_reset_resume,
 #endif
+	.pre_reset =3D	acm_pre_reset,
 	.id_table =3D	acm_ids,
 #ifdef CONFIG_PM
 	.supports_autosuspend =3D 1,
diff --git a/drivers/usb/class/cdc-acm.h b/drivers/usb/class/cdc-acm.h
index b32afbd69dfd..597c9d50b64c 100644
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -83,6 +83,7 @@ struct acm {
 	struct usb_device *dev;				/* the corresponding usb device */
 	struct usb_interface *control;			/* control interface */
 	struct usb_interface *data;			/* data interface */
+	unsigned in, out;				/* i/o pipes */
 	struct tty_port port;			 	/* our tty port data */
 	struct urb *ctrlurb;				/* urbs */
 	u8 *ctrl_buffer;				/* buffers of urbs */
@@ -101,6 +102,9 @@ struct acm {
 	spinlock_t write_lock;
 	struct mutex mutex;
 	bool disconnected;
+	unsigned long flags;
+#		define EVENT_TTY_WAKEUP	0
+#		define EVENT_RX_STALL	1
 	struct usb_cdc_line_coding line;		/* bits, stop, parity */
 	struct work_struct work;			/* work queue entry for line discipline waking=
 up */
 	unsigned int ctrlin;				/* input control lines (DCD, DSR, RI, break, over=
runs) */
diff --git a/drivers/usb/misc/rio500.c b/drivers/usb/misc/rio500.c
index 13731d512624..57c4632ddd0a 100644
--- a/drivers/usb/misc/rio500.c
+++ b/drivers/usb/misc/rio500.c
@@ -464,15 +464,23 @@ static int probe_rio(struct usb_interface *intf,
 {
 	struct usb_device *dev =3D interface_to_usbdev(intf);
 	struct rio_usb_data *rio =3D &rio_instance;
-	int retval;
+	int retval =3D 0;
=20
-	dev_info(&intf->dev, "USB Rio found at address %d\n", dev->devnum);
+	mutex_lock(&rio500_mutex);
+	if (rio->present) {
+		dev_info(&intf->dev, "Second USB Rio at address %d refused\n", dev->devn=
um);
+		retval =3D -EBUSY;
+		goto bail_out;
+	} else {
+		dev_info(&intf->dev, "USB Rio found at address %d\n", dev->devnum);
+	}
=20
 	retval =3D usb_register_dev(intf, &usb_rio_class);
 	if (retval) {
 		dev_err(&dev->dev,
 			"Not able to get a minor for this device.\n");
-		return -ENOMEM;
+		retval =3D -ENOMEM;
+		goto bail_out;
 	}
=20
 	rio->rio_dev =3D dev;
@@ -481,7 +489,8 @@ static int probe_rio(struct usb_interface *intf,
 		dev_err(&dev->dev,
 			"probe_rio: Not enough memory for the output buffer\n");
 		usb_deregister_dev(intf, &usb_rio_class);
-		return -ENOMEM;
+		retval =3D -ENOMEM;
+		goto bail_out;
 	}
 	dev_dbg(&intf->dev, "obuf address:%p\n", rio->obuf);
=20
@@ -490,7 +499,8 @@ static int probe_rio(struct usb_interface *intf,
 			"probe_rio: Not enough memory for the input buffer\n");
 		usb_deregister_dev(intf, &usb_rio_class);
 		kfree(rio->obuf);
-		return -ENOMEM;
+		retval =3D -ENOMEM;
+		goto bail_out;
 	}
 	dev_dbg(&intf->dev, "ibuf address:%p\n", rio->ibuf);
=20
@@ -498,8 +508,10 @@ static int probe_rio(struct usb_interface *intf,
=20
 	usb_set_intfdata (intf, rio);
 	rio->present =3D 1;
+bail_out:
+	mutex_unlock(&rio500_mutex);
=20
-	return 0;
+	return retval;
 }
=20
 static void disconnect_rio(struct usb_interface *intf)
diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbv=
ga/sisusb.c
index 633caf643122..e5919c34b12e 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3093,6 +3093,13 @@ static int sisusb_probe(struct usb_interface *intf,
=20
 	mutex_init(&(sisusb->lock));
=20
+	sisusb->sisusb_dev =3D dev;
+	sisusb->vrambase   =3D SISUSB_PCI_MEMBASE;
+	sisusb->mmiobase   =3D SISUSB_PCI_MMIOBASE;
+	sisusb->mmiosize   =3D SISUSB_PCI_MMIOSIZE;
+	sisusb->ioportbase =3D SISUSB_PCI_IOPORTBASE;
+	/* Everything else is zero */
+
 	/* Register device */
 	if ((retval =3D usb_register_dev(intf, &usb_sisusb_class))) {
 		dev_err(&sisusb->sisusb_dev->dev, "Failed to get a minor for device %d\n=
",
@@ -3101,13 +3108,7 @@ static int sisusb_probe(struct usb_interface *intf,
 		goto error_1;
 	}
=20
-	sisusb->sisusb_dev =3D dev;
-	sisusb->minor      =3D intf->minor;
-	sisusb->vrambase   =3D SISUSB_PCI_MEMBASE;
-	sisusb->mmiobase   =3D SISUSB_PCI_MMIOBASE;
-	sisusb->mmiosize   =3D SISUSB_PCI_MMIOSIZE;
-	sisusb->ioportbase =3D SISUSB_PCI_IOPORTBASE;
-	/* Everything else is zero */
+	sisusb->minor =3D intf->minor;
=20
 	/* Allocate buffers */
 	sisusb->ibufsize =3D SISUSB_IBUF_SIZE;
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index c44b911937e8..0036d9627787 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -350,39 +350,59 @@ void usb_serial_generic_read_bulk_callback(struct urb=
 *urb)
 	struct usb_serial_port *port =3D urb->context;
 	unsigned char *data =3D urb->transfer_buffer;
 	unsigned long flags;
+	bool stopped =3D false;
+	int status =3D urb->status;
 	int i;
=20
 	for (i =3D 0; i < ARRAY_SIZE(port->read_urbs); ++i) {
 		if (urb =3D=3D port->read_urbs[i])
 			break;
 	}
-	set_bit(i, &port->read_urbs_free);
=20
 	dev_dbg(&port->dev, "%s - urb %d, len %d\n", __func__, i,
 							urb->actual_length);
-	switch (urb->status) {
+	switch (status) {
 	case 0:
+		usb_serial_debug_data(&port->dev, __func__, urb->actual_length,
+							data);
+		port->serial->type->process_read_urb(urb);
 		break;
 	case -ENOENT:
 	case -ECONNRESET:
 	case -ESHUTDOWN:
 		dev_dbg(&port->dev, "%s - urb stopped: %d\n",
-							__func__, urb->status);
-		return;
+							__func__, status);
+		stopped =3D true;
+		break;
 	case -EPIPE:
 		dev_err(&port->dev, "%s - urb stopped: %d\n",
-							__func__, urb->status);
-		return;
+							__func__, status);
+		stopped =3D true;
+		break;
 	default:
 		dev_dbg(&port->dev, "%s - nonzero urb status: %d\n",
-							__func__, urb->status);
-		goto resubmit;
+							__func__, status);
+		break;
 	}
=20
-	usb_serial_debug_data(&port->dev, __func__, urb->actual_length, data);
-	port->serial->type->process_read_urb(urb);
+	/*
+	 * Make sure URB processing is done before marking as free to avoid
+	 * racing with unthrottle() on another CPU. Matches the barriers
+	 * implied by the test_and_clear_bit() in
+	 * usb_serial_generic_submit_read_urb().
+	 */
+	smp_mb__before_atomic();
+	set_bit(i, &port->read_urbs_free);
+	/*
+	 * Make sure URB is marked as free before checking the throttled flag
+	 * to avoid racing with unthrottle() on another CPU. Matches the
+	 * smp_mb() in unthrottle().
+	 */
+	smp_mb__after_atomic();
+
+	if (stopped)
+		return;
=20
-resubmit:
 	/* Throttle the device if requested by tty */
 	spin_lock_irqsave(&port->lock, flags);
 	port->throttled =3D port->throttle_req;
@@ -399,6 +419,7 @@ void usb_serial_generic_write_bulk_callback(struct urb =
*urb)
 {
 	unsigned long flags;
 	struct usb_serial_port *port =3D urb->context;
+	int status =3D urb->status;
 	int i;
=20
 	for (i =3D 0; i < ARRAY_SIZE(port->write_urbs); ++i) {
@@ -410,22 +431,22 @@ void usb_serial_generic_write_bulk_callback(struct ur=
b *urb)
 	set_bit(i, &port->write_urbs_free);
 	spin_unlock_irqrestore(&port->lock, flags);
=20
-	switch (urb->status) {
+	switch (status) {
 	case 0:
 		break;
 	case -ENOENT:
 	case -ECONNRESET:
 	case -ESHUTDOWN:
 		dev_dbg(&port->dev, "%s - urb stopped: %d\n",
-							__func__, urb->status);
+							__func__, status);
 		return;
 	case -EPIPE:
 		dev_err_console(port, "%s - urb stopped: %d\n",
-							__func__, urb->status);
+							__func__, status);
 		return;
 	default:
 		dev_err_console(port, "%s - nonzero urb status: %d\n",
-							__func__, urb->status);
+							__func__, status);
 		goto resubmit;
 	}
=20
@@ -456,6 +477,12 @@ void usb_serial_generic_unthrottle(struct tty_struct *=
tty)
 	port->throttled =3D port->throttle_req =3D 0;
 	spin_unlock_irq(&port->lock);
=20
+	/*
+	 * Matches the smp_mb__after_atomic() in
+	 * usb_serial_generic_read_bulk_callback().
+	 */
+	smp_mb();
+
 	if (was_throttled)
 		usb_serial_generic_submit_read_urbs(port, GFP_KERNEL);
 }
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-seria=
l.c
index a290891ddd84..02bce9ab6f62 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -167,9 +167,9 @@ void usb_serial_put(struct usb_serial *serial)
  * @driver: the driver (USB in our case)
  * @tty: the tty being created
  *
- * Create the termios objects for this tty.  We use the default
+ * Initialise the termios structure for this tty.  We use the default
  * USB serial settings but permit them to be overridden by
- * serial->type->init_termios.
+ * serial->type->init_termios on first open.
  *
  * This is the first place a new tty gets used.  Hence this is where we
  * acquire references to the usb_serial structure and the driver module,
@@ -181,6 +181,7 @@ static int serial_install(struct tty_driver *driver, st=
ruct tty_struct *tty)
 	int idx =3D tty->index;
 	struct usb_serial *serial;
 	struct usb_serial_port *port;
+	bool init_termios;
 	int retval =3D -ENODEV;
=20
 	port =3D usb_serial_port_get_by_minor(idx);
@@ -195,14 +196,16 @@ static int serial_install(struct tty_driver *driver, =
struct tty_struct *tty)
 	if (retval)
 		goto error_get_interface;
=20
+	init_termios =3D (driver->termios[idx] =3D=3D NULL);
+
 	retval =3D tty_port_install(&port->port, driver, tty);
 	if (retval)
 		goto error_init_termios;
=20
 	mutex_unlock(&serial->disc_mutex);
=20
-	/* allow the driver to update the settings */
-	if (serial->type->init_termios)
+	/* allow the driver to update the initial settings */
+	if (init_termios && serial->type->init_termios)
 		serial->type->init_termios(tty);
=20
 	tty->driver_data =3D port;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 48507ef0542a..d128c363738f 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1194,7 +1194,7 @@ static int get_indirect(struct vhost_virtqueue *vq,
 		/* If this is an input descriptor, increment that count. */
 		if (desc.flags & VRING_DESC_F_WRITE) {
 			*in_num +=3D ret;
-			if (unlikely(log)) {
+			if (unlikely(log && ret)) {
 				log[*log_num].addr =3D desc.addr;
 				log[*log_num].len =3D desc.len;
 				++*log_num;
@@ -1317,7 +1317,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 			/* If this is an input descriptor,
 			 * increment that count. */
 			*in_num +=3D ret;
-			if (unlikely(log)) {
+			if (unlikely(log && ret)) {
 				log[*log_num].addr =3D desc.addr;
 				log[*log_num].len =3D desc.len;
 				++*log_num;
diff --git a/drivers/video/backlight/lm3630a_bl.c b/drivers/video/backlight=
/lm3630a_bl.c
index 4505b92c189a..64863dfb9c2b 100644
--- a/drivers/video/backlight/lm3630a_bl.c
+++ b/drivers/video/backlight/lm3630a_bl.c
@@ -201,7 +201,7 @@ static int lm3630a_bank_a_update_status(struct backligh=
t_device *bl)
 				      LM3630A_LEDA_ENABLE, LM3630A_LEDA_ENABLE);
 	if (ret < 0)
 		goto out_i2c_err;
-	return bl->props.brightness;
+	return 0;
=20
 out_i2c_err:
 	dev_err(pchip->dev, "i2c failed to access\n");
@@ -278,7 +278,7 @@ static int lm3630a_bank_b_update_status(struct backligh=
t_device *bl)
 				      LM3630A_LEDB_ENABLE, LM3630A_LEDB_ENABLE);
 	if (ret < 0)
 		goto out_i2c_err;
-	return bl->props.brightness;
+	return 0;
=20
 out_i2c_err:
 	dev_err(pchip->dev, "i2c failed to access REG_CTRL\n");
diff --git a/drivers/virt/fsl_hypervisor.c b/drivers/virt/fsl_hypervisor.c
index 7c95e0a8f68b..3df3946d6e82 100644
--- a/drivers/virt/fsl_hypervisor.c
+++ b/drivers/virt/fsl_hypervisor.c
@@ -338,8 +338,8 @@ static long ioctl_dtprop(struct fsl_hv_ioctl_prop __use=
r *p, int set)
 	struct fsl_hv_ioctl_prop param;
 	char __user *upath, *upropname;
 	void __user *upropval;
-	char *path =3D NULL, *propname =3D NULL;
-	void *propval =3D NULL;
+	char *path, *propname;
+	void *propval;
 	int ret =3D 0;
=20
 	/* Get the parameters from the user. */
@@ -351,32 +351,30 @@ static long ioctl_dtprop(struct fsl_hv_ioctl_prop __u=
ser *p, int set)
 	upropval =3D (void __user *)(uintptr_t)param.propval;
=20
 	path =3D strndup_user(upath, FH_DTPROP_MAX_PATHLEN);
-	if (IS_ERR(path)) {
-		ret =3D PTR_ERR(path);
-		goto out;
-	}
+	if (IS_ERR(path))
+		return PTR_ERR(path);
=20
 	propname =3D strndup_user(upropname, FH_DTPROP_MAX_PATHLEN);
 	if (IS_ERR(propname)) {
 		ret =3D PTR_ERR(propname);
-		goto out;
+		goto err_free_path;
 	}
=20
 	if (param.proplen > FH_DTPROP_MAX_PROPLEN) {
 		ret =3D -EINVAL;
-		goto out;
+		goto err_free_propname;
 	}
=20
 	propval =3D kmalloc(param.proplen, GFP_KERNEL);
 	if (!propval) {
 		ret =3D -ENOMEM;
-		goto out;
+		goto err_free_propname;
 	}
=20
 	if (set) {
 		if (copy_from_user(propval, upropval, param.proplen)) {
 			ret =3D -EFAULT;
-			goto out;
+			goto err_free_propval;
 		}
=20
 		param.ret =3D fh_partition_set_dtprop(param.handle,
@@ -395,7 +393,7 @@ static long ioctl_dtprop(struct fsl_hv_ioctl_prop __use=
r *p, int set)
 			if (copy_to_user(upropval, propval, param.proplen) ||
 			    put_user(param.proplen, &p->proplen)) {
 				ret =3D -EFAULT;
-				goto out;
+				goto err_free_propval;
 			}
 		}
 	}
@@ -403,10 +401,12 @@ static long ioctl_dtprop(struct fsl_hv_ioctl_prop __u=
ser *p, int set)
 	if (put_user(param.ret, &p->ret))
 		ret =3D -EFAULT;
=20
-out:
-	kfree(path);
+err_free_propval:
 	kfree(propval);
+err_free_propname:
 	kfree(propname);
+err_free_path:
+	kfree(path);
=20
 	return ret;
 }
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 526db4502aa6..9ce725ce2bac 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -706,6 +706,12 @@ static void ceph_umount_begin(struct super_block *sb)
 	return;
 }
=20
+static int ceph_remount(struct super_block *sb, int *flags, char *data)
+{
+	sync_filesystem(sb);
+	return 0;
+}
+
 static const struct super_operations ceph_super_ops =3D {
 	.alloc_inode	=3D ceph_alloc_inode,
 	.destroy_inode	=3D ceph_destroy_inode,
@@ -713,6 +719,7 @@ static const struct super_operations ceph_super_ops =3D=
 {
 	.drop_inode	=3D ceph_drop_inode,
 	.sync_fs        =3D ceph_sync_fs,
 	.put_super	=3D ceph_put_super,
+	.remount_fs	=3D ceph_remount,
 	.show_options   =3D ceph_show_options,
 	.statfs		=3D ceph_statfs,
 	.umount_begin   =3D ceph_umount_begin,
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index d95a547cf94e..3e573192ac4e 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1000,26 +1000,28 @@ smb21_set_oplock_level(struct cifsInodeInfo *cinode=
, __u32 oplock,
 		       unsigned int epoch, bool *purge_cache)
 {
 	char message[5] =3D {0};
+	unsigned int new_oplock =3D 0;
=20
 	oplock &=3D 0xFF;
 	if (oplock =3D=3D SMB2_OPLOCK_LEVEL_NOCHANGE)
 		return;
=20
-	cinode->oplock =3D 0;
 	if (oplock & SMB2_LEASE_READ_CACHING_HE) {
-		cinode->oplock |=3D CIFS_CACHE_READ_FLG;
+		new_oplock |=3D CIFS_CACHE_READ_FLG;
 		strcat(message, "R");
 	}
 	if (oplock & SMB2_LEASE_HANDLE_CACHING_HE) {
-		cinode->oplock |=3D CIFS_CACHE_HANDLE_FLG;
+		new_oplock |=3D CIFS_CACHE_HANDLE_FLG;
 		strcat(message, "H");
 	}
 	if (oplock & SMB2_LEASE_WRITE_CACHING_HE) {
-		cinode->oplock |=3D CIFS_CACHE_WRITE_FLG;
+		new_oplock |=3D CIFS_CACHE_WRITE_FLG;
 		strcat(message, "W");
 	}
-	if (!cinode->oplock)
-		strcat(message, "None");
+	if (!new_oplock)
+		strncpy(message, "None", sizeof(message));
+
+	cinode->oplock =3D new_oplock;
 	cifs_dbg(FYI, "%s Lease granted on inode %p\n", message,
 		 &cinode->vfs_inode);
 }
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 201f683bea89..773b653bae51 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -173,6 +173,13 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_it=
er *from)
 	}
=20
 	ret =3D __generic_file_write_iter(iocb, from);
+	/*
+	 * Unaligned direct AIO must be the only IO in flight. Otherwise
+	 * overlapping aligned IO after unaligned might result in data
+	 * corruption.
+	 */
+	if (ret =3D=3D -EIOCBQUEUED && aio_mutex)
+		ext4_unwritten_wait(inode);
 	mutex_unlock(&inode->i_mutex);
=20
 	if (ret > 0) {
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 99bfe22f2a71..8d410994a7c4 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -634,7 +634,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, un=
signed long arg)
 		if (err =3D=3D 0)
 			err =3D err2;
 		mnt_drop_write_file(filp);
-		if (!err && (o_group > EXT4_SB(sb)->s_groups_count) &&
+		if (!err && (o_group < EXT4_SB(sb)->s_groups_count) &&
 		    ext4_has_group_desc_csum(sb) &&
 		    test_opt(sb, INIT_INODE_TABLE))
 			err =3D ext4_register_li_request(sb, o_group);
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 69e471b042a6..43dd3ef4625a 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1597,7 +1597,7 @@ __acquires(fc->lock)
 {
 	struct fuse_conn *fc =3D get_fuse_conn(inode);
 	struct fuse_inode *fi =3D get_fuse_inode(inode);
-	size_t crop =3D i_size_read(inode);
+	loff_t crop =3D i_size_read(inode);
 	struct fuse_req *req;
=20
 	while (fi->writectr >=3D 0 && !list_empty(&fi->queued_writes)) {
@@ -3017,6 +3017,13 @@ static long fuse_file_fallocate(struct file *file, i=
nt mode, loff_t offset,
 		}
 	}
=20
+	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
+	    offset + length > i_size_read(inode)) {
+		err =3D inode_newsize_ok(inode, offset + length);
+		if (err)
+			goto out;
+	}
+
 	if (!(mode & FALLOC_FL_KEEP_SIZE))
 		set_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
=20
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index f4cb9c0d6bbd..4fffbbf8de4a 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -731,6 +731,7 @@ void gfs2_clear_rgrpd(struct gfs2_sbd *sdp)
=20
 		gfs2_free_clones(rgd);
 		kfree(rgd->rd_bits);
+		rgd->rd_bits =3D NULL;
 		return_all_reservations(rgd);
 		kmem_cache_free(gfs2_rgrpd_cachep, rgd);
 	}
@@ -925,9 +926,6 @@ static int read_rindex_entry(struct gfs2_inode *ip)
 	if (error)
 		goto fail;
=20
-	rgd->rd_gl->gl_object =3D rgd;
-	rgd->rd_gl->gl_vm.start =3D rgd->rd_addr * bsize;
-	rgd->rd_gl->gl_vm.end =3D rgd->rd_gl->gl_vm.start + (rgd->rd_length * bsi=
ze) - 1;
 	rgd->rd_rgl =3D (struct gfs2_rgrp_lvb *)rgd->rd_gl->gl_lksb.sb_lvbptr;
 	rgd->rd_flags &=3D ~GFS2_RDF_UPTODATE;
 	if (rgd->rd_data > sdp->sd_max_rg_data)
@@ -935,14 +933,20 @@ static int read_rindex_entry(struct gfs2_inode *ip)
 	spin_lock(&sdp->sd_rindex_spin);
 	error =3D rgd_insert(rgd);
 	spin_unlock(&sdp->sd_rindex_spin);
-	if (!error)
+	if (!error) {
+		rgd->rd_gl->gl_object =3D rgd;
+		rgd->rd_gl->gl_vm.start =3D (rgd->rd_addr * bsize) & PAGE_MASK;
+		rgd->rd_gl->gl_vm.end =3D PAGE_ALIGN((rgd->rd_addr +
+						    rgd->rd_length) * bsize) - 1;
 		return 0;
+	}
=20
 	error =3D 0; /* someone else read in the rgrp; free it and ignore it */
 	gfs2_glock_put(rgd->rd_gl);
=20
 fail:
 	kfree(rgd->rd_bits);
+	rgd->rd_bits =3D NULL;
 	kmem_cache_free(gfs2_rgrpd_cachep, rgd);
 	return error;
 }
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 7cc112108df6..59c56e6c41bb 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1344,6 +1344,10 @@ static int jbd2_write_superblock(journal_t *journal,=
 int write_op)
 	journal_superblock_t *sb =3D journal->j_superblock;
 	int ret;
=20
+	/* Buffer got discarded which means block device got invalidated */
+	if (!buffer_mapped(bh))
+		return -EIO;
+
 	trace_jbd2_write_superblock(journal, write_op);
 	if (!(journal->j_flags & JBD2_BARRIER))
 		write_op &=3D ~(REQ_FUA | REQ_FLUSH);
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 474cb8195245..80c499433269 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -140,6 +140,10 @@ int nfs40_discover_server_trunking(struct nfs_client *=
clp,
 		/* Sustain the lease, even if it's empty.  If the clientid4
 		 * goes stale it's of no use for trunking discovery. */
 		nfs4_schedule_state_renewal(*result);
+
+		/* If the client state need to recover, do it. */
+		if (clp->cl_state)
+			nfs4_schedule_state_manager(clp);
 	}
 out:
 	return status;
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index 29651167190d..305eeee1bdca 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -148,16 +148,24 @@ static struct dentry *ocfs2_get_parent(struct dentry =
*child)
 	u64 blkno;
 	struct dentry *parent;
 	struct inode *dir =3D child->d_inode;
+	int set;
=20
 	trace_ocfs2_get_parent(child, child->d_name.len, child->d_name.name,
 			       (unsigned long long)OCFS2_I(dir)->ip_blkno);
=20
+	status =3D ocfs2_nfs_sync_lock(OCFS2_SB(dir->i_sb), 1);
+	if (status < 0) {
+		mlog(ML_ERROR, "getting nfs sync lock(EX) failed %d\n", status);
+		parent =3D ERR_PTR(status);
+		goto bail;
+	}
+
 	status =3D ocfs2_inode_lock(dir, NULL, 0);
 	if (status < 0) {
 		if (status !=3D -ENOENT)
 			mlog_errno(status);
 		parent =3D ERR_PTR(status);
-		goto bail;
+		goto unlock_nfs_sync;
 	}
=20
 	status =3D ocfs2_lookup_ino_from_name(dir, "..", 2, &blkno);
@@ -166,11 +174,31 @@ static struct dentry *ocfs2_get_parent(struct dentry =
*child)
 		goto bail_unlock;
 	}
=20
+	status =3D ocfs2_test_inode_bit(OCFS2_SB(dir->i_sb), blkno, &set);
+	if (status < 0) {
+		if (status =3D=3D -EINVAL) {
+			status =3D -ESTALE;
+		} else
+			mlog(ML_ERROR, "test inode bit failed %d\n", status);
+		parent =3D ERR_PTR(status);
+		goto bail_unlock;
+	}
+
+	trace_ocfs2_get_dentry_test_bit(status, set);
+	if (!set) {
+		status =3D -ESTALE;
+		parent =3D ERR_PTR(status);
+		goto bail_unlock;
+	}
+
 	parent =3D d_obtain_alias(ocfs2_iget(OCFS2_SB(dir->i_sb), blkno, 0, 0));
=20
 bail_unlock:
 	ocfs2_inode_unlock(dir, 0);
=20
+unlock_nfs_sync:
+	ocfs2_nfs_sync_unlock(OCFS2_SB(dir->i_sb), 1);
+
 bail:
 	trace_ocfs2_get_parent_end(parent);
=20
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2616ddea6756..e5a9b5b9dc67 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1038,6 +1038,10 @@ xfs_fs_put_super(
 {
 	struct xfs_mount	*mp =3D XFS_M(sb);
=20
+	/* if ->fill_super failed, we have no mount to tear down */
+	if (!sb->s_fs_info)
+		return;
+
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
=20
@@ -1045,6 +1049,8 @@ xfs_fs_put_super(
 	xfs_icsb_destroy_counters(mp);
 	xfs_destroy_mount_workqueues(mp);
 	xfs_close_devices(mp);
+
+	sb->s_fs_info =3D NULL;
 	xfs_free_fsname(mp);
 	kfree(mp);
 }
@@ -1514,6 +1520,7 @@ xfs_fs_fill_super(
  out_close_devices:
 	xfs_close_devices(mp);
  out_free_fsname:
+	sb->s_fs_info =3D NULL;
 	xfs_free_fsname(mp);
 	kfree(mp);
  out:
@@ -1540,6 +1547,9 @@ xfs_fs_nr_cached_objects(
 	struct super_block	*sb,
 	int			nid)
 {
+	/* Paranoia: catch incorrect calls during mount setup or teardown */
+	if (WARN_ON_ONCE(!sb->s_fs_info))
+		return 0;
 	return xfs_reclaim_inodes_count(XFS_M(sb));
 }
=20
diff --git a/include/linux/atalk.h b/include/linux/atalk.h
index 73fd8b7e9534..af43ed404ff4 100644
--- a/include/linux/atalk.h
+++ b/include/linux/atalk.h
@@ -150,19 +150,29 @@ extern int sysctl_aarp_retransmit_limit;
 extern int sysctl_aarp_resolve_time;
=20
 #ifdef CONFIG_SYSCTL
-extern void atalk_register_sysctl(void);
+extern int atalk_register_sysctl(void);
 extern void atalk_unregister_sysctl(void);
 #else
-#define atalk_register_sysctl()		do { } while(0)
-#define atalk_unregister_sysctl()	do { } while(0)
+static inline int atalk_register_sysctl(void)
+{
+	return 0;
+}
+static inline void atalk_unregister_sysctl(void)
+{
+}
 #endif
=20
 #ifdef CONFIG_PROC_FS
 extern int atalk_proc_init(void);
 extern void atalk_proc_exit(void);
 #else
-#define atalk_proc_init()	({ 0; })
-#define atalk_proc_exit()	do { } while(0)
+static inline int atalk_proc_init(void)
+{
+	return 0;
+}
+static inline void atalk_proc_exit(void)
+{
+}
 #endif /* CONFIG_PROC_FS */
=20
 #endif /* __LINUX_ATALK_H__ */
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 6bff13f74050..75d17e15da33 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1621,6 +1621,9 @@ enum ieee80211_reasoncode {
 	WLAN_REASON_INVALID_RSN_IE_CAP =3D 22,
 	WLAN_REASON_IEEE8021X_FAILED =3D 23,
 	WLAN_REASON_CIPHER_SUITE_REJECTED =3D 24,
+	/* TDLS (802.11z) */
+	WLAN_REASON_TDLS_TEARDOWN_UNREACHABLE =3D 25,
+	WLAN_REASON_TDLS_TEARDOWN_UNSPECIFIED =3D 26,
 	/* 802.11e */
 	WLAN_REASON_DISASSOC_UNSPECIFIED_QOS =3D 32,
 	WLAN_REASON_DISASSOC_QAP_NO_BANDWIDTH =3D 33,
diff --git a/include/linux/mfd/da9063/registers.h b/include/linux/mfd/da906=
3/registers.h
index 09a85c699da1..1b76436cfaae 100644
--- a/include/linux/mfd/da9063/registers.h
+++ b/include/linux/mfd/da9063/registers.h
@@ -204,9 +204,9 @@
=20
 /* DA9063 Configuration registers */
 /* OTP */
-#define	DA9063_REG_OPT_COUNT		0x101
-#define	DA9063_REG_OPT_ADDR		0x102
-#define	DA9063_REG_OPT_DATA		0x103
+#define	DA9063_REG_OTP_CONT		0x101
+#define	DA9063_REG_OTP_ADDR		0x102
+#define	DA9063_REG_OTP_DATA		0x103
=20
 /* Customer Trim and Configuration */
 #define	DA9063_REG_T_OFFSET		0x104
diff --git a/include/linux/of.h b/include/linux/of.h
index 15e6a340c1bd..ab7408c35b8d 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -171,8 +171,8 @@ extern struct device_node *of_find_all_nodes(struct dev=
ice_node *prev);
 static inline u64 of_read_number(const __be32 *cell, int size)
 {
 	u64 r =3D 0;
-	while (size--)
-		r =3D (r << 32) | be32_to_cpu(*(cell++));
+	for (; size--; cell++)
+		r =3D (r << 32) | be32_to_cpu(*cell);
 	return r;
 }
=20
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 789ac99f5a6c..dd6d4455b792 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -308,6 +308,8 @@ struct pci_dev {
 						   powered on/off by the
 						   corresponding bridge */
 	unsigned int	ignore_hotplug:1;	/* Ignore hotplug events */
+	unsigned int	clear_retrain_link:1;	/* Need to clear Retrain Link
+						   bit manually */
 	unsigned int	d3_delay;	/* D3->D0 transition time in ms */
 	unsigned int	d3cold_delay;	/* D3cold->D0 transition time in ms */
=20
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 84e526a12def..e90628cac8fa 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -299,7 +299,6 @@ static inline void pwm_add_table(struct pwm_lookup *tab=
le, size_t num)
 #ifdef CONFIG_PWM_SYSFS
 void pwmchip_sysfs_export(struct pwm_chip *chip);
 void pwmchip_sysfs_unexport(struct pwm_chip *chip);
-void pwmchip_sysfs_unexport_children(struct pwm_chip *chip);
 #else
 static inline void pwmchip_sysfs_export(struct pwm_chip *chip)
 {
@@ -308,10 +307,6 @@ static inline void pwmchip_sysfs_export(struct pwm_chi=
p *chip)
 static inline void pwmchip_sysfs_unexport(struct pwm_chip *chip)
 {
 }
-
-static inline void pwmchip_sysfs_unexport_children(struct pwm_chip *chip)
-{
-}
 #endif /* CONFIG_PWM_SYSFS */
=20
 #endif /* __LINUX_PWM_H */
diff --git a/include/linux/smpboot.h b/include/linux/smpboot.h
index 13e929679550..b2d986e3fe77 100644
--- a/include/linux/smpboot.h
+++ b/include/linux/smpboot.h
@@ -31,7 +31,7 @@ struct smpboot_thread_data;
  * @thread_comm:	The base name of the thread
  */
 struct smp_hotplug_thread {
-	struct task_struct __percpu	**store;
+	struct task_struct		* __percpu *store;
 	struct list_head		list;
 	int				(*thread_should_run)(unsigned int cpu);
 	void				(*thread_fn)(unsigned int cpu);
diff --git a/include/media/davinci/vpbe.h b/include/media/davinci/vpbe.h
index 57585c7004a4..d9e8c5449692 100644
--- a/include/media/davinci/vpbe.h
+++ b/include/media/davinci/vpbe.h
@@ -96,7 +96,7 @@ struct vpbe_config {
 	struct encoder_config_info *ext_encoders;
 	/* amplifier information goes here */
 	struct amp_config_info *amp;
-	int num_outputs;
+	unsigned int num_outputs;
 	/* Order is venc outputs followed by LCD and then external encoders */
 	struct vpbe_output *outputs;
 };
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_c=
ore.h
index b386bf17e6c2..588746487c1a 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -142,6 +142,9 @@ struct oob_data {
=20
 #define HCI_MAX_SHORT_NAME_LENGTH	10
=20
+/* Min encryption key size to match with SMP */
+#define HCI_MIN_ENC_KEY_SIZE		7
+
 /* Default LE RPA expiry time, 15 minutes */
 #define HCI_DEFAULT_RPA_TIMEOUT		(15 * 60)
=20
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 421b6ecb4b2c..8d876dc8b299 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4815,4 +4815,17 @@ int ieee80211_parse_p2p_noa(const struct ieee80211_p=
2p_noa_attr *attr,
  */
 void ieee80211_update_p2p_noa(struct ieee80211_noa_data *data, u32 tsf);
=20
+/**
+ * ieee80211_tdls_oper - request userspace to perform a TDLS operation
+ * @vif: virtual interface
+ * @peer: the peer's destination address
+ * @oper: the requested TDLS operation
+ * @reason_code: reason code for the operation, valid for TDLS teardown
+ * @gfp: allocation flags
+ *
+ * See cfg80211_tdls_oper_request().
+ */
+void ieee80211_tdls_oper_request(struct ieee80211_vif *vif, const u8 *peer=
,
+				 enum nl80211_tdls_operation oper,
+				 u16 reason_code, gfp_t gfp);
 #endif /* MAC80211_H */
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 98d2f17479d7..0ff1729344e3 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2569,7 +2569,7 @@ static int kdb_per_cpu(int argc, const char **argv)
 		diag =3D kdbgetularg(argv[3], &whichcpu);
 		if (diag)
 			return diag;
-		if (!cpu_online(whichcpu)) {
+		if (whichcpu >=3D nr_cpu_ids || !cpu_online(whichcpu)) {
 			kdb_printf("cpu %ld is not online\n", whichcpu);
 			return KDB_BADCPUNUM;
 		}
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index b1d6d26dbdc3..4ccb54cb67ec 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -588,7 +588,7 @@ static inline void process_adjtimex_modes(struct timex =
*txc,
 		time_constant =3D max(time_constant, 0l);
 	}
=20
-	if (txc->modes & ADJ_TAI && txc->constant > 0)
+	if (txc->modes & ADJ_TAI && txc->constant >=3D 0)
 		*time_tai =3D txc->constant;
=20
 	if (txc->modes & ADJ_OFFSET)
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 1e0729443d93..7bfdc041085d 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1007,9 +1007,6 @@ event_id_read(struct file *filp, char __user *ubuf, s=
ize_t cnt, loff_t *ppos)
 	char buf[32];
 	int len;
=20
-	if (*ppos)
-		return 0;
-
 	if (unlikely(!id))
 		return -ENODEV;
=20
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 9ebf9e20de53..590e45d7c6fb 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -178,6 +178,13 @@ int kobject_uevent_env(struct kobject *kobj, enum kobj=
ect_action action,
 	struct uevent_sock *ue_sk;
 #endif
=20
+	/*
+	 * Mark "remove" event done regardless of result, for some subsystems
+	 * do not want to re-trigger "remove" event via automatic cleanup.
+	 */
+	if (action =3D=3D KOBJ_REMOVE)
+		kobj->state_remove_uevent_sent =3D 1;
+
 	pr_debug("kobject: '%s' (%p): %s\n",
 		 kobject_name(kobj), kobj, __func__);
=20
@@ -275,8 +282,6 @@ int kobject_uevent_env(struct kobject *kobj, enum kobje=
ct_action action,
 	 */
 	if (action =3D=3D KOBJ_ADD)
 		kobj->state_add_uevent_sent =3D 1;
-	else if (action =3D=3D KOBJ_REMOVE)
-		kobj->state_remove_uevent_sent =3D 1;
=20
 	mutex_lock(&uevent_sock_mutex);
 	/* we will send an event, so request a new sequence number */
diff --git a/net/appletalk/atalk_proc.c b/net/appletalk/atalk_proc.c
index af46bc49e1e9..b5f84f428aa6 100644
--- a/net/appletalk/atalk_proc.c
+++ b/net/appletalk/atalk_proc.c
@@ -293,7 +293,7 @@ int __init atalk_proc_init(void)
 	goto out;
 }
=20
-void __exit atalk_proc_exit(void)
+void atalk_proc_exit(void)
 {
 	remove_proc_entry("interface", atalk_proc_dir);
 	remove_proc_entry("route", atalk_proc_dir);
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index bfcf6be1d665..e462ce6617a9 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1913,12 +1913,16 @@ static const char atalk_err_snap[] __initconst =3D
 /* Called by proto.c on kernel start up */
 static int __init atalk_init(void)
 {
-	int rc =3D proto_register(&ddp_proto, 0);
+	int rc;
=20
-	if (rc !=3D 0)
+	rc =3D proto_register(&ddp_proto, 0);
+	if (rc)
 		goto out;
=20
-	(void)sock_register(&atalk_family_ops);
+	rc =3D sock_register(&atalk_family_ops);
+	if (rc)
+		goto out_proto;
+
 	ddp_dl =3D register_snap_client(ddp_snap_id, atalk_rcv);
 	if (!ddp_dl)
 		printk(atalk_err_snap);
@@ -1926,12 +1930,33 @@ static int __init atalk_init(void)
 	dev_add_pack(&ltalk_packet_type);
 	dev_add_pack(&ppptalk_packet_type);
=20
-	register_netdevice_notifier(&ddp_notifier);
+	rc =3D register_netdevice_notifier(&ddp_notifier);
+	if (rc)
+		goto out_sock;
+
 	aarp_proto_init();
-	atalk_proc_init();
-	atalk_register_sysctl();
+	rc =3D atalk_proc_init();
+	if (rc)
+		goto out_aarp;
+
+	rc =3D atalk_register_sysctl();
+	if (rc)
+		goto out_proc;
 out:
 	return rc;
+out_proc:
+	atalk_proc_exit();
+out_aarp:
+	aarp_cleanup_module();
+	unregister_netdevice_notifier(&ddp_notifier);
+out_sock:
+	dev_remove_pack(&ppptalk_packet_type);
+	dev_remove_pack(&ltalk_packet_type);
+	unregister_snap_client(ddp_dl);
+	sock_unregister(PF_APPLETALK);
+out_proto:
+	proto_unregister(&ddp_proto);
+	goto out;
 }
 module_init(atalk_init);
=20
diff --git a/net/appletalk/sysctl_net_atalk.c b/net/appletalk/sysctl_net_at=
alk.c
index ebb864361f7a..4e6042e0fcac 100644
--- a/net/appletalk/sysctl_net_atalk.c
+++ b/net/appletalk/sysctl_net_atalk.c
@@ -44,9 +44,12 @@ static struct ctl_table atalk_table[] =3D {
=20
 static struct ctl_table_header *atalk_table_header;
=20
-void atalk_register_sysctl(void)
+int __init atalk_register_sysctl(void)
 {
 	atalk_table_header =3D register_net_sysctl(&init_net, "net/appletalk", at=
alk_table);
+	if (!atalk_table_header)
+		return -ENOMEM;
+	return 0;
 }
=20
 void atalk_unregister_sysctl(void)
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 1cb6405e4429..1dade2d3760c 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -980,8 +980,16 @@ int hci_conn_security(struct hci_conn *conn, __u8 sec_=
level, __u8 auth_type)
 		return 0;
=20
 encrypt:
-	if (conn->link_mode & HCI_LM_ENCRYPT)
+	if (conn->link_mode & HCI_LM_ENCRYPT) {
+		/* Ensure that the encryption key size has been read,
+		 * otherwise stall the upper layer responses.
+		 */
+		if (!conn->enc_key_size)
+			return 0;
+
+		/* Nothing else needed, all requirements are met */
 		return 1;
+	}
=20
 	hci_conn_encrypt(conn);
 	return 0;
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 14690f24ca99..79b2d349de99 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1260,6 +1260,21 @@ static void l2cap_start_connection(struct l2cap_chan=
 *chan)
 	}
 }
=20
+static bool l2cap_check_enc_key_size(struct hci_conn *hcon)
+{
+	/* The minimum encryption key size needs to be enforced by the
+	 * host stack before establishing any L2CAP connections. The
+	 * specification in theory allows a minimum of 1, but to align
+	 * BR/EDR and LE transports, a minimum of 7 is chosen.
+	 *
+	 * This check might also be called for unencrypted connections
+	 * that have no key size requirements. Ensure that the link is
+	 * actually encrypted before enforcing a key size.
+	 */
+	return (!(hcon->link_mode & HCI_LM_ENCRYPT) ||
+		hcon->enc_key_size >=3D HCI_MIN_ENC_KEY_SIZE);
+}
+
 static void l2cap_do_start(struct l2cap_chan *chan)
 {
 	struct l2cap_conn *conn =3D chan->conn;
@@ -1273,10 +1288,14 @@ static void l2cap_do_start(struct l2cap_chan *chan)
 		if (!(conn->info_state & L2CAP_INFO_FEAT_MASK_REQ_DONE))
 			return;
=20
-		if (l2cap_chan_check_security(chan) &&
-		    __l2cap_no_conn_pending(chan)) {
+		if (!l2cap_chan_check_security(chan) ||
+		    !__l2cap_no_conn_pending(chan))
+			return;
+
+		if (l2cap_check_enc_key_size(conn->hcon))
 			l2cap_start_connection(chan);
-		}
+		else
+			__set_chan_timer(chan, L2CAP_DISC_TIMEOUT);
 	} else {
 		struct l2cap_info_req req;
 		req.type =3D cpu_to_le16(L2CAP_IT_FEAT_MASK);
@@ -1366,7 +1385,10 @@ static void l2cap_conn_start(struct l2cap_conn *conn=
)
 				continue;
 			}
=20
-			l2cap_start_connection(chan);
+			if (l2cap_check_enc_key_size(conn->hcon))
+				l2cap_start_connection(chan);
+			else
+				l2cap_chan_close(chan, ECONNREFUSED);
=20
 		} else if (chan->state =3D=3D BT_CONNECT2) {
 			struct l2cap_conn_rsp rsp;
@@ -7352,7 +7374,7 @@ int l2cap_security_cfm(struct hci_conn *hcon, u8 stat=
us, u8 encrypt)
 		}
=20
 		if (chan->state =3D=3D BT_CONNECT) {
-			if (!status)
+			if (!status && l2cap_check_enc_key_size(hcon))
 				l2cap_start_connection(chan);
 			else
 				__set_chan_timer(chan, L2CAP_DISC_TIMEOUT);
@@ -7360,7 +7382,7 @@ int l2cap_security_cfm(struct hci_conn *hcon, u8 stat=
us, u8 encrypt)
 			struct l2cap_conn_rsp rsp;
 			__u16 res, stat;
=20
-			if (!status) {
+			if (!status && l2cap_check_enc_key_size(hcon)) {
 				if (test_bit(FLAG_DEFER_SETUP, &chan->flags)) {
 					res =3D L2CAP_CR_PEND;
 					stat =3D L2CAP_CS_AUTHOR_PEND;
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtable=
s.c
index 75929f9bd4e6..1596736ff268 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2139,7 +2139,9 @@ static int compat_copy_entries(unsigned char *data, u=
nsigned int size_user,
 	if (ret < 0)
 		return ret;
=20
-	WARN_ON(size_remaining);
+	if (size_remaining)
+		return -EINVAL;
+
 	return state->buf_kern_offset;
 }
=20
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 04700c745ca0..a464eb7b962a 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -167,6 +167,7 @@ static int icmp_filter(const struct sock *sk, const str=
uct sk_buff *skb)
  */
 static int raw_v4_input(struct sk_buff *skb, const struct iphdr *iph, int =
hash)
 {
+	int dif =3D inet_iif(skb);
 	struct sock *sk;
 	struct hlist_head *head;
 	int delivered =3D 0;
@@ -179,8 +180,7 @@ static int raw_v4_input(struct sk_buff *skb, const stru=
ct iphdr *iph, int hash)
=20
 	net =3D dev_net(skb->dev);
 	sk =3D __raw_v4_lookup(net, __sk_head(head), iph->protocol,
-			     iph->saddr, iph->daddr,
-			     skb->dev->ifindex);
+			     iph->saddr, iph->daddr, dif);
=20
 	while (sk) {
 		delivered =3D 1;
@@ -193,7 +193,7 @@ static int raw_v4_input(struct sk_buff *skb, const stru=
ct iphdr *iph, int hash)
 		}
 		sk =3D __raw_v4_lookup(net, sk_next(sk), iph->protocol,
 				     iph->saddr, iph->daddr,
-				     skb->dev->ifindex);
+				     dif);
 	}
 out:
 	read_unlock(&raw_v4_hashinfo.lock);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d7a4c0ff66ff..9b975cfd6a22 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1858,6 +1858,9 @@ int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct n=
et_device *dev,
 			const u8 *extra_ies, size_t extra_ies_len);
 int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 			const u8 *peer, enum nl80211_tdls_operation oper);
+void ieee80211_tdls_handle_disconnect(struct ieee80211_sub_if_data *sdata,
+				      const u8 *peer, u16 reason);
+const char *ieee80211_get_reason_code_string(u16 reason_code);
=20
=20
 #ifdef CONFIG_MAC80211_NOINLINE
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 58fab5951b22..85eb858a2ba2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2298,7 +2298,7 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_s=
ub_if_data *sdata,
 #define case_WLAN(type) \
 	case WLAN_REASON_##type: return #type
=20
-static const char *ieee80211_get_reason_code_string(u16 reason_code)
+const char *ieee80211_get_reason_code_string(u16 reason_code)
 {
 	switch (reason_code) {
 	case_WLAN(UNSPECIFIED);
@@ -2357,21 +2357,24 @@ static void ieee80211_rx_mgmt_deauth(struct ieee802=
11_sub_if_data *sdata,
 {
 	struct ieee80211_if_managed *ifmgd =3D &sdata->u.mgd;
 	const u8 *bssid =3D NULL;
-	u16 reason_code;
+	u16 reason_code =3D le16_to_cpu(mgmt->u.deauth.reason_code);
=20
 	sdata_assert_lock(sdata);
=20
 	if (len < 24 + 2)
 		return;
=20
+	if (!ether_addr_equal(mgmt->bssid, mgmt->sa)) {
+		ieee80211_tdls_handle_disconnect(sdata, mgmt->sa, reason_code);
+		return;
+	}
+
 	if (!ifmgd->associated ||
 	    !ether_addr_equal(mgmt->bssid, ifmgd->associated->bssid))
 		return;
=20
 	bssid =3D ifmgd->associated->bssid;
=20
-	reason_code =3D le16_to_cpu(mgmt->u.deauth.reason_code);
-
 	sdata_info(sdata, "deauthenticated from %pM (Reason: %u=3D%s)\n",
 		   bssid, reason_code, ieee80211_get_reason_code_string(reason_code));
=20
@@ -2398,6 +2401,11 @@ static void ieee80211_rx_mgmt_disassoc(struct ieee80=
211_sub_if_data *sdata,
=20
 	reason_code =3D le16_to_cpu(mgmt->u.disassoc.reason_code);
=20
+	if (!ether_addr_equal(mgmt->bssid, mgmt->sa)) {
+		ieee80211_tdls_handle_disconnect(sdata, mgmt->sa, reason_code);
+		return;
+	}
+
 	sdata_info(sdata, "disassociated from %pM (Reason: %u)\n",
 		   mgmt->sa, reason_code);
=20
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 87d1722b6b1b..6b52b8d379e7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3084,6 +3084,8 @@ static bool prepare_for_handlers(struct ieee80211_rx_=
data *rx,
 	case NL80211_IFTYPE_STATION:
 		if (!bssid && !sdata->u.mgd.use_4addr)
 			return false;
+		if (ieee80211_is_robust_mgmt_frame(skb) && !rx->sta)
+			return false;
 		if (!multicast &&
 		    !ether_addr_equal(sdata->vif.addr, hdr->addr1)) {
 			if (!(sdata->dev->flags & IFF_PROMISC) ||
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 652813b2d3df..01ab5e00d42a 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -8,6 +8,7 @@
  */
=20
 #include <linux/ieee80211.h>
+#include <net/cfg80211.h>
 #include "ieee80211_i.h"
=20
 static void ieee80211_tdls_add_ext_capab(struct sk_buff *skb)
@@ -323,3 +324,42 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct ne=
t_device *dev,
=20
 	return 0;
 }
+
+void ieee80211_tdls_oper_request(struct ieee80211_vif *vif, const u8 *peer=
,
+				 enum nl80211_tdls_operation oper,
+				 u16 reason_code, gfp_t gfp)
+{
+	struct ieee80211_sub_if_data *sdata =3D vif_to_sdata(vif);
+
+	if (vif->type !=3D NL80211_IFTYPE_STATION || !vif->bss_conf.assoc) {
+		sdata_err(sdata, "Discarding TDLS oper %d - not STA or disconnected\n",
+			  oper);
+		return;
+	}
+
+	cfg80211_tdls_oper_request(sdata->dev, peer, oper, reason_code, gfp);
+}
+EXPORT_SYMBOL(ieee80211_tdls_oper_request);
+
+void ieee80211_tdls_handle_disconnect(struct ieee80211_sub_if_data *sdata,
+				      const u8 *peer, u16 reason)
+{
+	struct ieee80211_sta *sta;
+
+	rcu_read_lock();
+	sta =3D ieee80211_find_sta(&sdata->vif, peer);
+	if (!sta || !sta->tdls) {
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+
+	tdls_dbg(sdata, "disconnected from TDLS peer %pM (Reason: %u=3D%s)\n",
+		 peer, reason,
+		 ieee80211_get_reason_code_string(reason));
+
+	ieee80211_tdls_oper_request(&sdata->vif, peer,
+				    NL80211_TDLS_TEARDOWN,
+				    WLAN_REASON_TDLS_TEARDOWN_UNREACHABLE,
+				    GFP_ATOMIC);
+}
diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index 800180ed0a10..caeca8371c9b 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -5348,7 +5348,8 @@ int snd_hda_gen_init(struct hda_codec *codec)
 	if (spec->init_hook)
 		spec->init_hook(codec);
=20
-	snd_hda_apply_verbs(codec);
+	if (!spec->skip_verbs)
+		snd_hda_apply_verbs(codec);
=20
 	codec->cached_write =3D 1;
=20
diff --git a/sound/pci/hda/hda_generic.h b/sound/pci/hda/hda_generic.h
index bb2dea743986..02eb6bfddb99 100644
--- a/sound/pci/hda/hda_generic.h
+++ b/sound/pci/hda/hda_generic.h
@@ -238,6 +238,7 @@ struct hda_gen_spec {
 	unsigned int indep_hp_enabled:1; /* independent HP enabled */
 	unsigned int have_aamix_ctl:1;
 	unsigned int hp_mic_jack_modes:1;
+	unsigned int skip_verbs:1; /* don't apply verbs at snd_hda_gen_init() */
=20
 	/* additional mute flags (only effective with auto_mute_via_amp=3D1) */
 	u64 mute_bits;
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 06b990727f68..eb4a93b110c0 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1632,6 +1632,12 @@ static void hdmi_repoll_eld(struct work_struct *work=
)
 {
 	struct hdmi_spec_per_pin *per_pin =3D
 	container_of(to_delayed_work(work), struct hdmi_spec_per_pin, work);
+	struct hda_codec *codec =3D per_pin->codec;
+	struct hda_jack_tbl *jack;
+
+	jack =3D snd_hda_jack_tbl_get(codec, per_pin->pin_nid);
+	if (jack)
+		jack->jack_dirty =3D 1;
=20
 	if (per_pin->repoll_count++ > 6)
 		per_pin->repoll_count =3D 0;
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3d82dc7267e6..ac59f3299bd0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -831,10 +831,11 @@ static int alc_init(struct hda_codec *codec)
 	if (spec->init_hook)
 		spec->init_hook(codec);
=20
+	spec->gen.skip_verbs =3D 1; /* applied in below */
+	snd_hda_gen_init(codec);
 	alc_fix_pll(codec);
 	alc_auto_init_amp(codec, spec->init_amp);
-
-	snd_hda_gen_init(codec);
+	snd_hda_apply_verbs(codec); /* apply verbs here after own init */
=20
 	snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_INIT);
=20
diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 39124f43faa1..c21f5fdda1a9 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -1271,14 +1271,14 @@ static const struct snd_soc_dapm_widget max98090_da=
pm_widgets[] =3D {
 		&max98090_right_rcv_mixer_controls[0],
 		ARRAY_SIZE(max98090_right_rcv_mixer_controls)),
=20
-	SND_SOC_DAPM_MUX("LINMOD Mux", M98090_REG_LOUTR_MIXER,
-		M98090_LINMOD_SHIFT, 0, &max98090_linmod_mux),
+	SND_SOC_DAPM_MUX("LINMOD Mux", SND_SOC_NOPM, 0, 0,
+		&max98090_linmod_mux),
=20
-	SND_SOC_DAPM_MUX("MIXHPLSEL Mux", M98090_REG_HP_CONTROL,
-		M98090_MIXHPLSEL_SHIFT, 0, &max98090_mixhplsel_mux),
+	SND_SOC_DAPM_MUX("MIXHPLSEL Mux", SND_SOC_NOPM, 0, 0,
+		&max98090_mixhplsel_mux),
=20
-	SND_SOC_DAPM_MUX("MIXHPRSEL Mux", M98090_REG_HP_CONTROL,
-		M98090_MIXHPRSEL_SHIFT, 0, &max98090_mixhprsel_mux),
+	SND_SOC_DAPM_MUX("MIXHPRSEL Mux", SND_SOC_NOPM, 0, 0,
+		&max98090_mixhprsel_mux),
=20
 	SND_SOC_DAPM_PGA("HP Left Out", M98090_REG_OUTPUT_ENABLE,
 		M98090_HPLEN_SHIFT, 0, NULL, 0),
diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
index 8acac5fd084c..f9cc109fbc64 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -245,6 +245,7 @@ static int fsl_esai_set_dai_sysclk(struct snd_soc_dai *=
dai, int clk_id,
 		break;
 	case ESAI_HCKT_EXTAL:
 		ecr |=3D ESAI_ECR_ETI;
+		break;
 	case ESAI_HCKR_EXTAL:
 		ecr |=3D ESAI_ECR_ERI;
 		break;
diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 538df481fe5e..158c84b79103 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -81,6 +81,7 @@ struct mixer_build {
 	unsigned char *buffer;
 	unsigned int buflen;
 	DECLARE_BITMAP(unitbitmap, MAX_ID_ELEMS);
+	DECLARE_BITMAP(termbitmap, MAX_ID_ELEMS);
 	struct usb_audio_term oterm;
 	const struct usbmix_name_map *map;
 	const struct usbmix_selector_map *selector_map;
@@ -685,15 +686,24 @@ static int get_term_name(struct mixer_build *state, s=
truct usb_audio_term *iterm
  * parse the source unit recursively until it reaches to a terminal
  * or a branched unit.
  */
-static int check_input_term(struct mixer_build *state, int id,
+static int __check_input_term(struct mixer_build *state, int id,
 			    struct usb_audio_term *term)
 {
 	int err;
 	void *p1;
+	unsigned char *hdr;
=20
 	memset(term, 0, sizeof(*term));
-	while ((p1 =3D find_audio_control_unit(state, id)) !=3D NULL) {
-		unsigned char *hdr =3D p1;
+	for (;;) {
+		/* a loop in the terminal chain? */
+		if (test_and_set_bit(id, state->termbitmap))
+			return -EINVAL;
+
+		p1 =3D find_audio_control_unit(state, id);
+		if (!p1)
+			break;
+
+		hdr =3D p1;
 		term->id =3D id;
 		switch (hdr[2]) {
 		case UAC_INPUT_TERMINAL:
@@ -711,7 +721,7 @@ static int check_input_term(struct mixer_build *state, =
int id,
 				term->name =3D d->iTerminal;
=20
 				/* call recursively to get the clock selectors */
-				err =3D check_input_term(state, d->bCSourceID, term);
+				err =3D __check_input_term(state, d->bCSourceID, term);
 				if (err < 0)
 					return err;
 			}
@@ -734,7 +744,7 @@ static int check_input_term(struct mixer_build *state, =
int id,
 		case UAC2_CLOCK_SELECTOR: {
 			struct uac_selector_unit_descriptor *d =3D p1;
 			/* call recursively to retrieve the channel info */
-			err =3D check_input_term(state, d->baSourceID[0], term);
+			err =3D __check_input_term(state, d->baSourceID[0], term);
 			if (err < 0)
 				return err;
 			term->type =3D d->bDescriptorSubtype << 16; /* virtual type */
@@ -781,6 +791,15 @@ static int check_input_term(struct mixer_build *state,=
 int id,
 	return -ENODEV;
 }
=20
+
+static int check_input_term(struct mixer_build *state, int id,
+			    struct usb_audio_term *term)
+{
+	memset(term, 0, sizeof(*term));
+	memset(state->termbitmap, 0, sizeof(state->termbitmap));
+	return __check_input_term(state, id, term);
+}
+
 /*
  * Feature Unit
  */
@@ -1594,6 +1613,7 @@ static int parse_audio_mixer_unit(struct mixer_build =
*state, int unitid,
 	int pin, ich, err;
=20
 	if (desc->bLength < 11 || !(input_pins =3D desc->bNrInPins) ||
+	    desc->bLength < sizeof(*desc) + desc->bNrInPins ||
 	    !(num_outs =3D uac_mixer_unit_bNrChannels(desc))) {
 		usb_audio_err(state->chip,
 			      "invalid MIXER UNIT descriptor %d\n",
@@ -2090,6 +2110,8 @@ static int parse_audio_selector_unit(struct mixer_bui=
ld *state, int unitid,
 	kctl =3D snd_ctl_new1(&mixer_selectunit_ctl, cval);
 	if (! kctl) {
 		usb_audio_err(state->chip, "cannot malloc kcontrol\n");
+		for (i =3D 0; i < desc->bNrInPins; i++)
+			kfree(namelist[i]);
 		kfree(namelist);
 		kfree(cval);
 		return -ENOMEM;
@@ -2499,7 +2521,9 @@ int snd_usb_create_mixer(struct snd_usb_audio *chip, =
int ctrlif,
 	    (err =3D snd_usb_mixer_status_create(mixer)) < 0)
 		goto _error;
=20
-	snd_usb_mixer_apply_create_quirk(mixer);
+	err =3D snd_usb_mixer_apply_create_quirk(mixer);
+	if (err < 0)
+		goto _error;
=20
 	err =3D snd_device_new(chip->card, SNDRV_DEV_CODEC, mixer, &dev_ops);
 	if (err < 0)
diff --git a/tools/testing/selftests/ipc/msgque.c b/tools/testing/selftests=
/ipc/msgque.c
index 552f0810bffb..330e896c55b0 100644
--- a/tools/testing/selftests/ipc/msgque.c
+++ b/tools/testing/selftests/ipc/msgque.c
@@ -1,8 +1,9 @@
+#define _GNU_SOURCE
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
 #include <errno.h>
-#include <linux/msg.h>
+#include <sys/msg.h>
 #include <fcntl.h>
=20
 #define MAX_MSG_SIZE		32
@@ -70,7 +71,7 @@ int restore_queue(struct msgque_data *msgque)
 	return 0;
=20
 destroy:
-	if (msgctl(id, IPC_RMID, 0))
+	if (msgctl(id, IPC_RMID, NULL))
 		printf("Failed to destroy queue: %d\n", -errno);
 	return ret;
 }
@@ -117,7 +118,7 @@ int check_and_destroy_queue(struct msgque_data *msgque)
=20
 	ret =3D 0;
 err:
-	if (msgctl(msgque->msq_id, IPC_RMID, 0)) {
+	if (msgctl(msgque->msq_id, IPC_RMID, NULL)) {
 		printf("Failed to destroy queue: %d\n", -errno);
 		return -errno;
 	}
@@ -126,7 +127,7 @@ int check_and_destroy_queue(struct msgque_data *msgque)
=20
 int dump_queue(struct msgque_data *msgque)
 {
-	struct msqid64_ds ds;
+	struct msqid_ds ds;
 	int kern_id;
 	int i, ret;
=20
@@ -243,7 +244,7 @@ int main(int argc, char **argv)
 	return 0;
=20
 err_destroy:
-	if (msgctl(msgque.msq_id, IPC_RMID, 0)) {
+	if (msgctl(msgque.msq_id, IPC_RMID, NULL)) {
 		printf("Failed to destroy queue: %d\n", -errno);
 		return -errno;
 	}
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 00d86427af0f..1d115e71c950 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -39,7 +39,7 @@ static int coalesced_mmio_in_range(struct kvm_coalesced_m=
mio_dev *dev,
 	return 1;
 }
=20
-static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev)
+static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev, u32=
 last)
 {
 	struct kvm_coalesced_mmio_ring *ring;
 	unsigned avail;
@@ -51,7 +51,7 @@ static int coalesced_mmio_has_room(struct kvm_coalesced_m=
mio_dev *dev)
 	 * there is always one unused entry in the buffer
 	 */
 	ring =3D dev->kvm->coalesced_mmio_ring;
-	avail =3D (ring->first - ring->last - 1) % KVM_COALESCED_MMIO_MAX;
+	avail =3D (ring->first - last - 1) % KVM_COALESCED_MMIO_MAX;
 	if (avail =3D=3D 0) {
 		/* full */
 		return 0;
@@ -65,24 +65,27 @@ static int coalesced_mmio_write(struct kvm_io_device *t=
his,
 {
 	struct kvm_coalesced_mmio_dev *dev =3D to_mmio(this);
 	struct kvm_coalesced_mmio_ring *ring =3D dev->kvm->coalesced_mmio_ring;
+	__u32 insert;
=20
 	if (!coalesced_mmio_in_range(dev, addr, len))
 		return -EOPNOTSUPP;
=20
 	spin_lock(&dev->kvm->ring_lock);
=20
-	if (!coalesced_mmio_has_room(dev)) {
+	insert =3D ACCESS_ONCE(ring->last);
+	if (!coalesced_mmio_has_room(dev, insert) ||
+	    insert >=3D KVM_COALESCED_MMIO_MAX) {
 		spin_unlock(&dev->kvm->ring_lock);
 		return -EOPNOTSUPP;
 	}
=20
 	/* copy data in first free entry of the ring */
=20
-	ring->coalesced_mmio[ring->last].phys_addr =3D addr;
-	ring->coalesced_mmio[ring->last].len =3D len;
-	memcpy(ring->coalesced_mmio[ring->last].data, val, len);
+	ring->coalesced_mmio[insert].phys_addr =3D addr;
+	ring->coalesced_mmio[insert].len =3D len;
+	memcpy(ring->coalesced_mmio[insert].data, val, len);
 	smp_wmb();
-	ring->last =3D (ring->last + 1) % KVM_COALESCED_MMIO_MAX;
+	ring->last =3D (insert + 1) % KVM_COALESCED_MMIO_MAX;
 	spin_unlock(&dev->kvm->ring_lock);
 	return 0;
 }
=0D
--=-9HYtwmGPcZLRw9b9z1hd--

--=-xtw+5YNuh/lG96QhUOBf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl2J6MoACgkQ57/I7JWG
EQn9SA/+IpqxRw2NT+jmOuyyfIeTCDQgiMaEVa4S4Qj27cTTbWo0Dj8ptCGn9WsC
16lbsBVnE5VbJ3gY23dqKVRBjmNMlAPu7vPO6XOfBCLkuddtxh5a48LhbWzZOZ0w
1V2nuvn7C0GY/WcvOsh04ST5i5Q+6CYvxw7Hs8kQ9f0RR0ws984ZdKqDkelLO+/o
SmhHHP8UxlHq8GKCr7rcUIAoAg82v+5y/VSjM4hW1CF+KDN3bPQXVor+tuEzpa1U
rbbzIuDP4iK5JMTvwi1uh8yr365blBFdgCwyhmKEuD8Y8YvzIMx7JUu7UMLxGbOI
/yUN144ON7gZJnRWTcDFaHC7RxIGoBjZgwscsNRRJADN4RGjRzi7W8nAcoH+v36o
A9TNGCI8iC4i84qRAm4ihyaXek35xZSgWL9QI1NNbv+6f7ia3qUl3I3KE+o5yEEe
7q4NgYtF77pK2efNFsRPMwFFc03XPO3F9NPKPxX1pPEO/f6tCbB4TeorhVNsXIEL
ci2RdIa0sHQrDKDFP653zZIDelIPXeGz93Dg0LJqW5D+9t2hrLNaL+T1m73rGRdM
K2nsTkaDPuXYuPEC9+Gvf4stCcrOlTotj0y1KqOGnPbNFL+KikAXmnZs/AJNXdQd
Fc2GUm104/92DERm0drVGNrHCagbY4SNIcJYWXocTV6VX7kBWvU=
=iprn
-----END PGP SIGNATURE-----

--=-xtw+5YNuh/lG96QhUOBf--
