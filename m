Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B741DF721
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 14:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbgEWMPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 08:15:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52470 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725852AbgEWMPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 May 2020 08:15:14 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jcT3T-0007KX-Of; Sat, 23 May 2020 13:15:07 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jcT3T-007j3L-53; Sat, 23 May 2020 13:15:07 +0100
Date:   Sat, 23 May 2020 13:15:07 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc:     lwn@lwn.net
Subject: Linux 3.16.84
Message-ID: <lsq.1590236050.522640101@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--QTprm0S8XgL7H0Dt
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.16.84 kernel.

All users of the 3.16 kernel series should upgrade.

The updated 3.16.y git tree can be found at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.16.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git

The diff from 3.16.83 is attached to this message.

Ben.

------------

 Makefile                                           |   2 +-
 arch/arm/boot/dts/sama5d3.dtsi                     |  26 ++--
 arch/arm/boot/dts/sama5d3_can.dtsi                 |   4 +-
 arch/arm/boot/dts/sama5d3_tcb1.dtsi                |   1 +
 arch/arm/boot/dts/sama5d3_uart.dtsi                |   4 +-
 arch/arm/include/asm/kvm_emulate.h                 |   5 +
 arch/arm/include/asm/kvm_mmio.h                    |   2 +
 arch/arm/kvm/mmio.c                                |   6 +
 arch/arm/mach-tegra/sleep-tegra30.S                |  11 ++
 arch/arm64/include/asm/kvm_emulate.h               |   5 +
 arch/arm64/include/asm/kvm_mmio.h                  |   6 +-
 arch/ia64/include/asm/io.h                         |   1 +
 arch/powerpc/Kconfig                               |   1 +
 arch/powerpc/kvm/book3s_hv.c                       |   4 +-
 arch/powerpc/kvm/book3s_pr.c                       |   4 +-
 arch/sparc/include/uapi/asm/ipcbuf.h               |  22 ++--
 arch/x86/kernel/cpu/tsx.c                          |  13 +-
 arch/x86/kvm/emulate.c                             |  12 +-
 arch/x86/kvm/i8259.c                               |   4 +-
 arch/x86/kvm/lapic.c                               |  14 +-
 arch/x86/kvm/vmx.c                                 |   4 +-
 arch/x86/kvm/x86.c                                 |  57 +++++++--
 arch/x86/platform/efi/efi.c                        |  37 +++---
 crypto/af_alg.c                                    |   6 +-
 crypto/algapi.c                                    |  22 +---
 crypto/api.c                                       |   3 +-
 crypto/internal.h                                  |   1 -
 crypto/pcrypt.c                                    |   4 +-
 drivers/crypto/picoxcell_crypto.c                  |  15 ++-
 drivers/firmware/efi/efi.c                         |   4 +-
 drivers/md/persistent-data/dm-space-map-common.c   |  27 ++++
 drivers/md/persistent-data/dm-space-map-common.h   |   2 +
 drivers/md/persistent-data/dm-space-map-disk.c     |   6 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |   5 +-
 drivers/media/rc/iguanair.c                        |  15 +--
 drivers/media/usb/uvc/uvc_driver.c                 |  12 ++
 drivers/media/v4l2-core/videobuf-dma-sg.c          |   5 +-
 drivers/mmc/host/mmc_spi.c                         |  11 +-
 drivers/net/bonding/bond_alb.c                     |  44 +++++--
 drivers/net/ethernet/freescale/gianfar.c           |  10 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   3 +
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   3 +-
 drivers/net/wireless/iwlegacy/common.c             |   2 +-
 drivers/net/wireless/orinoco/orinoco_usb.c         |   4 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |  12 +-
 drivers/net/wireless/zd1211rw/zd_usb.c             |   2 +-
 drivers/of/Kconfig                                 |   4 +
 drivers/of/address.c                               |   6 +-
 drivers/pci/setup-bus.c                            |  20 ++-
 drivers/power/sbs-battery.c                        |   2 +-
 drivers/rtc/rtc-hym8563.c                          |   2 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   3 +-
 drivers/spi/spi-dw.c                               |  14 +-
 drivers/spi/spi-dw.h                               |   1 +
 drivers/staging/wlan-ng/prism2mgmt.c               |   2 +-
 drivers/usb/dwc3/core.c                            |   3 +
 drivers/usb/gadget/f_ecm.c                         |  16 ++-
 drivers/usb/gadget/f_ncm.c                         |  17 ++-
 drivers/usb/serial/ir-usb.c                        | 136 +++++++++++++++-----
 drivers/video/fbdev/pxa168fb.c                     |   6 +-
 fs/btrfs/ctree.c                                   |   8 +-
 fs/btrfs/ctree.h                                   |   6 +-
 fs/btrfs/delayed-ref.c                             |   8 +-
 fs/btrfs/disk-io.c                                 |   1 -
 fs/btrfs/tests/btrfs-tests.c                       |   1 -
 fs/cifs/cifsglob.h                                 |   1 +
 fs/cifs/smb2pdu.c                                  |  10 +-
 fs/cifs/smb2transport.c                            |   2 +
 fs/cifs/transport.c                                |   4 +
 fs/jbd2/checkpoint.c                               |   2 +-
 fs/jbd2/commit.c                                   |   4 +-
 fs/jbd2/journal.c                                  |  21 ++-
 fs/namespace.c                                     |   2 +-
 fs/nfs/Kconfig                                     |   2 +-
 fs/nfs/dir.c                                       | 104 ++++++---------
 fs/pnode.c                                         |   9 +-
 fs/reiserfs/super.c                                |   4 +-
 fs/ubifs/file.c                                    |   5 +-
 include/linux/padata.h                             |  13 +-
 include/linux/usb/irda.h                           |  13 +-
 kernel/padata.c                                    | 142 ++++++++-------------
 kernel/time/clocksource.c                          |  11 +-
 kernel/trace/trace_stat.c                          |  31 +++--
 mm/mempolicy.c                                     |   6 +-
 net/ipv4/tcp.c                                     |   1 +
 net/sched/cls_rsvp.h                               |   6 +-
 net/sched/ematch.c                                 |   3 +
 net/sunrpc/auth_gss/svcauth_gss.c                  |   4 +
 scripts/kconfig/confdata.c                         |   2 +-
 sound/drivers/dummy.c                              |   2 +-
 sound/sh/aica.c                                    |   4 +-
 virt/kvm/ioapic.c                                  |  15 ++-
 virt/kvm/kvm_main.c                                |  12 +-
 94 files changed, 713 insertions(+), 443 deletions(-)

Al Viro (1):
      propagate_one(): mnt_set_mountpoint() needs mount_lock

Alexandre Belloni (2):
      ARM: dts: at91: sama5d3: fix maximum peripheral clock rates
      ARM: dts: at91: sama5d3: define clock rate range for tcb1

Ard Biesheuvel (1):
      efi/x86: Map the entire EFI vendor string before copying it

Arnd Bergmann (2):
      sparc32: fix struct ipc64_perm type definition
      x86: kvm: avoid unused variable warning

Ben Hutchings (1):
      Linux 3.16.84

Bin Liu (1):
      usb: dwc3: turn off VBUS when leaving host mode

Bryan O'Donoghue (2):
      usb: gadget: f_ncm: Use atomic_t to track in-flight request
      usb: gadget: f_ecm: Use atomic_t to track in-flight request

Chen Yucong (1):
      kvm: x86: use macros to compute bank MSRs

Christoffer Dall (1):
      KVM: arm64: Only sign-extend MMIO up to register width

Christophe JAILLET (1):
      pxa168fb: Fix the function used to release some memory in an error handling path

Chuhong Yuan (1):
      crypto: picoxcell - adjust the position of tasklet_init and fix missed tasklet_kill

Colin Ian King (2):
      staging: wlan-ng: ensure error return is actually returned
      iwlegacy: ensure loop counter addr does not wrap and cause an infinite loop

Dan Carpenter (3):
      brcmfmac: Fix use after free in brcmf_sdio_readframes()
      power: supply: sbs-battery: Fix a signedness bug in sbs_get_battery_capacity()
      mm/mempolicy.c: fix out of bounds write in mpol_parse_str()

Daniel Jordan (3):
      padata: initialize pd->cpu with effective cpumask
      padata: purge get_cpu and reorder_via_wq from padata_do_serial
      padata: always acquire cpu_hotplug_lock before pinst->lock

Daniel Kiper (2):
      arch/ia64: Define early_memunmap()
      efi: Use early_mem*() instead of early_io*()

Eric Dumazet (4):
      net_sched: ematch: reject invalid TCF_EM_SIMPLE
      tcp: clear tp->total_retrans in tcp_disconnect()
      cls_rsvp: fix rsvp_policy
      bonding/alb: properly access headers in bond_alb_xmit()

Fabian Frederick (1):
      nfs: use kmap/kunmap directly

Filipe Manana (1):
      Btrfs: fix race between adding and putting tree mod seq elements and nodes

Geert Uytterhoeven (1):
      nfs: NFS_SWAP should depend on SWAP

Guenter Roeck (1):
      brcmfmac: abort and release host after error

Herbert Xu (7):
      padata: Replace delayed timer with immediate workqueue in padata_reorder
      padata: Remove broken queue flushing
      crypto: pcrypt - Fix user-after-free on module unload
      crypto: pcrypt - Do not clear MAY_SLEEP flag in original request
      crypto: af_alg - Use bh_lock_sock in sk_destruct
      crypto: api - Check spawn->alg under lock in crypto_drop_spawn
      crypto: api - Fix race condition in crypto_spawn_alg

Jan Kara (2):
      reiserfs: Fix memory leak of journal device string
      reiserfs: Fix spurious unlock in reiserfs_fill_super() error handling

Jason A. Donenfeld (2):
      padata: avoid race in reordering
      padata: get_next is never NULL

Joe Thornber (1):
      dm space map common: fix to ensure new block isn't already in use

Johan Hovold (10):
      ath9k: fix storage endpoint lookup
      rsi: fix use-after-free on failed probe and unbind
      brcmfmac: fix interface sanity check
      orinoco_usb: fix interface sanity check
      rsi_91x_usb: fix interface sanity check
      zd1211rw: fix storage endpoint lookup
      media: iguanair: fix endpoint sanity check
      USB: serial: ir-usb: add missing endpoint sanity check
      USB: serial: ir-usb: fix link-speed handling
      USB: serial: ir-usb: fix IrLAP framing

John Hubbard (1):
      media/v4l2-core: set pages dirty upon releasing DMA buffers

Kai Li (1):
      jbd2: clear JBD2_ABORT flag before journal_reset to update log tail info when load journal

Konstantin Khlebnikov (1):
      clocksource: Prevent double add_timer_on() for watchdog_timer

Linus Walleij (1):
      mmc: spi: Toggle SPI polarity, do not hardcode it

Logan Gunthorpe (1):
      PCI: Don't disable bridge BARs when assigning bus resources

Luis Henriques (1):
      tracing: Fix tracing_stat return values in error handling paths

Marios Pomonis (7):
      KVM: x86: Protect x86_decode_insn from Spectre-v1/L1TF attacks
      KVM: x86: Refactor picdev_write() to prevent Spectre-v1/L1TF attacks
      KVM: x86: Protect ioapic_read_indirect() from Spectre-v1/L1TF attacks
      KVM: x86: Protect ioapic_write_indirect() from Spectre-v1/L1TF attacks
      KVM: x86: Protect kvm_lapic_reg_write() from Spectre-v1/L1TF attacks
      KVM: x86: Protect MSR-based index computations from Spectre-v1/L1TF attacks in x86.c
      KVM: x86: Protect DR-based index computations from Spectre-v1/L1TF attacks

Masahiro Yamada (1):
      kconfig: fix broken dependency in randconfig-generated .config

Mathias Krause (3):
      padata: set cpu_index of unused CPUs to -1
      padata: ensure the reorder timer callback runs on the correct CPU
      padata: ensure padata_do_serial() runs on the correct CPU

Miaohe Lin (1):
      KVM: nVMX: vmread should not set rflags to specify success in case of #PF

Michael Ellerman (1):
      of: Add OF_DMA_DEFAULT_COHERENT & select it on powerpc

Navid Emamdoost (1):
      brcmfmac: Fix memory leak in brcmf_usbdev_qinit

Oliver Neukum (1):
      media: iguanair: add sanity checks

Paul Kocialkowski (1):
      rtc: hym8563: Return -EINVAL if the time is known to be invalid

Pawan Gupta (1):
      x86/cpu: Update cached HLE state on write to TSX_CTRL_CPUID_CLEAR

Piotr Krysiuk (1):
      fs/namespace.c: fix mountpoint reference counter race

Quinn Tran (1):
      scsi: qla2xxx: Fix mtcp dump collection failure

Roberto Bergantinos Corpas (1):
      sunrpc: expiry_time should be seconds not timeval

Ronnie Sahlberg (1):
      cifs: fail i/o on soft mounts if sessionsetup errors out

Sean Christopherson (6):
      KVM: x86: Don't let userspace set host-reserved cr4 bits
      KVM: x86/mmu: Apply max PA check for MMIO sptes to 32-bit KVM
      KVM: PPC: Book3S HV: Uninit vCPU if vcore creation fails
      KVM: PPC: Book3S PR: Free shared page if mmu initialization fails
      KVM: x86: Free wbinvd_dirty_mask if vCPU creation fails
      KVM: Check for a bad hva before dropping into the ghc slow path

Stephen Warren (1):
      ARM: tegra: Enable PLLP bypass during Tegra124 LP1

Steven Rostedt (VMware) (1):
      tracing: Fix very unlikely race of registering two stat tracers

Takashi Iwai (2):
      ALSA: sh: Fix compile warning wrt const
      ALSA: dummy: Fix PCM format loop in proc output

Tobias Klauser (1):
      padata: Remove unused but set variables

Trond Myklebust (2):
      NFS: Fix memory leaks and corruption in readdir
      NFS: Directory page cache pages need to be locked when read

Vincent Whitchurch (1):
      CIFS: Fix task struct use-after-free on reconnect

Vladimir Oltean (1):
      gianfar: Fix TX timestamping with a stacked DSA driver

Will Deacon (1):
      media: uvcvideo: Avoid cyclic entity chains due to malformed USB descriptors

Zhihao Cheng (1):
      ubifs: Fix deadlock in concurrent bulk-read and writepage

wuxu.wu (1):
      spi: spi-dw: Add lock protect dw_spi rx/tx to prevent concurrent calls

zhangyi (F) (2):
      jbd2: switch to use jbd2_journal_abort() when failed to submit the commit record
      ext4, jbd2: ensure panic when aborting with zero errno


--azLHFNyN32YCQGCU
Content-Type: text/x-diff; charset=UTF-8; name="linux-3.16.84.patch"
Content-Disposition: attachment; filename="linux-3.16.84.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Makefile b/Makefile
index 99500d145fab..e1c91ead7918 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 16
-SUBLEVEL =3D 83
+SUBLEVEL =3D 84
 EXTRAVERSION =3D
 NAME =3D Museum of Fishiegoodies
=20
diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index e0b15a6e8897..d6fea619a0b5 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -1031,43 +1031,43 @@
 					usart0_clk: usart0_clk {
 						#clock-cells =3D <0>;
 						reg =3D <12>;
-						atmel,clk-output-range =3D <0 66000000>;
+						atmel,clk-output-range =3D <0 83000000>;
 					};
=20
 					usart1_clk: usart1_clk {
 						#clock-cells =3D <0>;
 						reg =3D <13>;
-						atmel,clk-output-range =3D <0 66000000>;
+						atmel,clk-output-range =3D <0 83000000>;
 					};
=20
 					usart2_clk: usart2_clk {
 						#clock-cells =3D <0>;
 						reg =3D <14>;
-						atmel,clk-output-range =3D <0 66000000>;
+						atmel,clk-output-range =3D <0 83000000>;
 					};
=20
 					usart3_clk: usart3_clk {
 						#clock-cells =3D <0>;
 						reg =3D <15>;
-						atmel,clk-output-range =3D <0 66000000>;
+						atmel,clk-output-range =3D <0 83000000>;
 					};
=20
 					twi0_clk: twi0_clk {
 						reg =3D <18>;
 						#clock-cells =3D <0>;
-						atmel,clk-output-range =3D <0 16625000>;
+						atmel,clk-output-range =3D <0 41500000>;
 					};
=20
 					twi1_clk: twi1_clk {
 						#clock-cells =3D <0>;
 						reg =3D <19>;
-						atmel,clk-output-range =3D <0 16625000>;
+						atmel,clk-output-range =3D <0 41500000>;
 					};
=20
 					twi2_clk: twi2_clk {
 						#clock-cells =3D <0>;
 						reg =3D <20>;
-						atmel,clk-output-range =3D <0 16625000>;
+						atmel,clk-output-range =3D <0 41500000>;
 					};
=20
 					mci0_clk: mci0_clk {
@@ -1083,19 +1083,19 @@
 					spi0_clk: spi0_clk {
 						#clock-cells =3D <0>;
 						reg =3D <24>;
-						atmel,clk-output-range =3D <0 133000000>;
+						atmel,clk-output-range =3D <0 166000000>;
 					};
=20
 					spi1_clk: spi1_clk {
 						#clock-cells =3D <0>;
 						reg =3D <25>;
-						atmel,clk-output-range =3D <0 133000000>;
+						atmel,clk-output-range =3D <0 166000000>;
 					};
=20
 					tcb0_clk: tcb0_clk {
 						#clock-cells =3D <0>;
 						reg =3D <26>;
-						atmel,clk-output-range =3D <0 133000000>;
+						atmel,clk-output-range =3D <0 166000000>;
 					};
=20
 					pwm_clk: pwm_clk {
@@ -1106,7 +1106,7 @@
 					adc_clk: adc_clk {
 						#clock-cells =3D <0>;
 						reg =3D <29>;
-						atmel,clk-output-range =3D <0 66000000>;
+						atmel,clk-output-range =3D <0 83000000>;
 					};
=20
 					dma0_clk: dma0_clk {
@@ -1137,13 +1137,13 @@
 					ssc0_clk: ssc0_clk {
 						#clock-cells =3D <0>;
 						reg =3D <38>;
-						atmel,clk-output-range =3D <0 66000000>;
+						atmel,clk-output-range =3D <0 83000000>;
 					};
=20
 					ssc1_clk: ssc1_clk {
 						#clock-cells =3D <0>;
 						reg =3D <39>;
-						atmel,clk-output-range =3D <0 66000000>;
+						atmel,clk-output-range =3D <0 83000000>;
 					};
=20
 					sha_clk: sha_clk {
diff --git a/arch/arm/boot/dts/sama5d3_can.dtsi b/arch/arm/boot/dts/sama5d3=
_can.dtsi
index eaf41451ad0c..d1660f5945c3 100644
--- a/arch/arm/boot/dts/sama5d3_can.dtsi
+++ b/arch/arm/boot/dts/sama5d3_can.dtsi
@@ -37,13 +37,13 @@
 					can0_clk: can0_clk {
 						#clock-cells =3D <0>;
 						reg =3D <40>;
-						atmel,clk-output-range =3D <0 66000000>;
+						atmel,clk-output-range =3D <0 83000000>;
 					};
=20
 					can1_clk: can1_clk {
 						#clock-cells =3D <0>;
 						reg =3D <41>;
-						atmel,clk-output-range =3D <0 66000000>;
+						atmel,clk-output-range =3D <0 83000000>;
 					};
 				};
 			};
diff --git a/arch/arm/boot/dts/sama5d3_tcb1.dtsi b/arch/arm/boot/dts/sama5d=
3_tcb1.dtsi
index 02848453ca0c..80b623c8898d 100644
--- a/arch/arm/boot/dts/sama5d3_tcb1.dtsi
+++ b/arch/arm/boot/dts/sama5d3_tcb1.dtsi
@@ -23,6 +23,7 @@
 					tcb1_clk: tcb1_clk {
 						#clock-cells =3D <0>;
 						reg =3D <27>;
+						atmel,clk-output-range =3D <0 166000000>;
 					};
 				};
 			};
diff --git a/arch/arm/boot/dts/sama5d3_uart.dtsi b/arch/arm/boot/dts/sama5d=
3_uart.dtsi
index 7a8d4c6115f7..8070ed629178 100644
--- a/arch/arm/boot/dts/sama5d3_uart.dtsi
+++ b/arch/arm/boot/dts/sama5d3_uart.dtsi
@@ -42,13 +42,13 @@
 					uart0_clk: uart0_clk {
 						#clock-cells =3D <0>;
 						reg =3D <16>;
-						atmel,clk-output-range =3D <0 66000000>;
+						atmel,clk-output-range =3D <0 83000000>;
 					};
=20
 					uart1_clk: uart1_clk {
 						#clock-cells =3D <0>;
 						reg =3D <17>;
-						atmel,clk-output-range =3D <0 66000000>;
+						atmel,clk-output-range =3D <0 83000000>;
 					};
 				};
 			};
diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_=
emulate.h
index 853e2becad18..8d704db1ce96 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -105,6 +105,11 @@ static inline bool kvm_vcpu_dabt_issext(struct kvm_vcp=
u *vcpu)
 	return kvm_vcpu_get_hsr(vcpu) & HSR_SSE;
 }
=20
+static inline bool kvm_vcpu_dabt_issf(const struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 static inline int kvm_vcpu_dabt_get_rd(struct kvm_vcpu *vcpu)
 {
 	return (kvm_vcpu_get_hsr(vcpu) & HSR_SRT_MASK) >> HSR_SRT_SHIFT;
diff --git a/arch/arm/include/asm/kvm_mmio.h b/arch/arm/include/asm/kvm_mmi=
o.h
index adcc0d7d3175..e28cef4beae8 100644
--- a/arch/arm/include/asm/kvm_mmio.h
+++ b/arch/arm/include/asm/kvm_mmio.h
@@ -26,6 +26,8 @@
 struct kvm_decode {
 	unsigned long rt;
 	bool sign_extend;
+	/* Not used on 32-bit arm */
+	bool sixty_four;
 };
=20
 /*
diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
index c47f108c2b8a..c480bd438fd0 100644
--- a/arch/arm/kvm/mmio.c
+++ b/arch/arm/kvm/mmio.c
@@ -112,6 +112,9 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struc=
t kvm_run *run)
 			data =3D (data ^ mask) - mask;
 		}
=20
+		if (!vcpu->arch.mmio_decode.sixty_four)
+			data =3D data & 0xffffffff;
+
 		trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
 			       &data);
 		data =3D vcpu_data_host_to_guest(vcpu, data, len);
@@ -127,6 +130,7 @@ static int decode_hsr(struct kvm_vcpu *vcpu, phys_addr_=
t fault_ipa,
 	unsigned long rt;
 	int len;
 	bool is_write, sign_extend;
+	bool sixty_four;
=20
 	if (kvm_vcpu_dabt_isextabt(vcpu)) {
 		/* cache operation on I/O addr, tell guest unsupported */
@@ -146,6 +150,7 @@ static int decode_hsr(struct kvm_vcpu *vcpu, phys_addr_=
t fault_ipa,
=20
 	is_write =3D kvm_vcpu_dabt_iswrite(vcpu);
 	sign_extend =3D kvm_vcpu_dabt_issext(vcpu);
+	sixty_four =3D kvm_vcpu_dabt_issf(vcpu);
 	rt =3D kvm_vcpu_dabt_get_rd(vcpu);
=20
 	mmio->is_write =3D is_write;
@@ -153,6 +158,7 @@ static int decode_hsr(struct kvm_vcpu *vcpu, phys_addr_=
t fault_ipa,
 	mmio->len =3D len;
 	vcpu->arch.mmio_decode.sign_extend =3D sign_extend;
 	vcpu->arch.mmio_decode.rt =3D rt;
+	vcpu->arch.mmio_decode.sixty_four =3D sixty_four;
=20
 	/*
 	 * The MMIO instruction is emulated and should not be re-executed
diff --git a/arch/arm/mach-tegra/sleep-tegra30.S b/arch/arm/mach-tegra/slee=
p-tegra30.S
index b16d4a57fa59..ab9a46178367 100644
--- a/arch/arm/mach-tegra/sleep-tegra30.S
+++ b/arch/arm/mach-tegra/sleep-tegra30.S
@@ -378,6 +378,14 @@ ENTRY(tegra30_lp1_reset)
 	pll_locked r1, r0, CLK_RESET_PLLC_BASE
 	pll_locked r1, r0, CLK_RESET_PLLX_BASE
=20
+	tegra_get_soc_id TEGRA_APB_MISC_BASE, r1
+	cmp	r1, #TEGRA30
+	beq	1f
+	ldr	r1, [r0, #CLK_RESET_PLLP_BASE]
+	bic	r1, r1, #(1<<31)	@ disable PllP bypass
+	str	r1, [r0, #CLK_RESET_PLLP_BASE]
+1:
+
 	mov32	r7, TEGRA_TMRUS_BASE
 	ldr	r1, [r7]
 	add	r1, r1, #LOCK_DELAY
@@ -637,7 +645,10 @@ ENDPROC(tegra30_lp1_reset)
 	str	r0, [r4, #PMC_PLLP_WB0_OVERRIDE]
=20
 	/* disable PLLP, PLLA, PLLC and PLLX */
+	tegra_get_soc_id TEGRA_APB_MISC_BASE, r1
+	cmp	r1, #TEGRA30
 	ldr	r0, [r5, #CLK_RESET_PLLP_BASE]
+	orrne	r0, r0, #(1 << 31)	@ enable PllP bypass on fast cluster
 	bic	r0, r0, #(1 << 30)
 	str	r0, [r5, #CLK_RESET_PLLP_BASE]
 	ldr	r0, [r5, #CLK_RESET_PLLA_BASE]
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/=
kvm_emulate.h
index ef490a55cdf1..9e1f3250bd73 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -140,6 +140,11 @@ static inline bool kvm_vcpu_dabt_issext(const struct k=
vm_vcpu *vcpu)
 	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_EL2_SSE);
 }
=20
+static inline bool kvm_vcpu_dabt_issf(const struct kvm_vcpu *vcpu)
+{
+	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_EL2_SF);
+}
+
 static inline int kvm_vcpu_dabt_get_rd(const struct kvm_vcpu *vcpu)
 {
 	return (kvm_vcpu_get_hsr(vcpu) & ESR_EL2_SRT_MASK) >> ESR_EL2_SRT_SHIFT;
diff --git a/arch/arm64/include/asm/kvm_mmio.h b/arch/arm64/include/asm/kvm=
_mmio.h
index fc2f689c0694..09923122c4c9 100644
--- a/arch/arm64/include/asm/kvm_mmio.h
+++ b/arch/arm64/include/asm/kvm_mmio.h
@@ -22,13 +22,11 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_arm.h>
=20
-/*
- * This is annoying. The mmio code requires this, even if we don't
- * need any decoding. To be fixed.
- */
 struct kvm_decode {
 	unsigned long rt;
 	bool sign_extend;
+	/* Witdth of the register accessed by the faulting instruction is 64-bits=
 */
+	bool sixty_four;
 };
=20
 /*
diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
index 0d2bcb37ec35..bee0acd52f7e 100644
--- a/arch/ia64/include/asm/io.h
+++ b/arch/ia64/include/asm/io.h
@@ -426,6 +426,7 @@ extern void iounmap (volatile void __iomem *addr);
 extern void __iomem * early_ioremap (unsigned long phys_addr, unsigned lon=
g size);
 #define early_memremap(phys_addr, size)        early_ioremap(phys_addr, si=
ze)
 extern void early_iounmap (volatile void __iomem *addr, unsigned long size=
);
+#define early_memunmap(addr, size)             early_iounmap(addr, size)
 static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsig=
ned long size)
 {
 	return ioremap(phys_addr, size);
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 5ff5ab0411b3..d05ea43f24e0 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -89,6 +89,7 @@ config PPC
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select BINFMT_ELF
 	select OF
+	select OF_DMA_DEFAULT_COHERENT		if !NOT_COHERENT_CACHE
 	select OF_EARLY_FLATTREE
 	select OF_RESERVED_MEM
 	select HAVE_FTRACE_MCOUNT_RECORD
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index eaac0cb57717..5e5ba4a2b11a 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1316,7 +1316,7 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_hv(st=
ruct kvm *kvm,
 	mutex_unlock(&kvm->lock);
=20
 	if (!vcore)
-		goto free_vcpu;
+		goto uninit_vcpu;
=20
 	spin_lock(&vcore->lock);
 	++vcore->num_threads;
@@ -1329,6 +1329,8 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_hv(st=
ruct kvm *kvm,
=20
 	return vcpu;
=20
+uninit_vcpu:
+	kvm_vcpu_uninit(vcpu);
 free_vcpu:
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 out:
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 1d9c536e6b16..b484895d4c78 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1346,10 +1346,12 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_pr(=
struct kvm *kvm,
=20
 	err =3D kvmppc_mmu_init(vcpu);
 	if (err < 0)
-		goto uninit_vcpu;
+		goto free_shared_page;
=20
 	return vcpu;
=20
+free_shared_page:
+	free_page((unsigned long)vcpu->arch.shared);
 uninit_vcpu:
 	kvm_vcpu_uninit(vcpu);
 free_shadow_vcpu:
diff --git a/arch/sparc/include/uapi/asm/ipcbuf.h b/arch/sparc/include/uapi=
/asm/ipcbuf.h
index 66013b4fe10d..58da9c4addb2 100644
--- a/arch/sparc/include/uapi/asm/ipcbuf.h
+++ b/arch/sparc/include/uapi/asm/ipcbuf.h
@@ -14,19 +14,19 @@
=20
 struct ipc64_perm
 {
-	__kernel_key_t	key;
-	__kernel_uid_t	uid;
-	__kernel_gid_t	gid;
-	__kernel_uid_t	cuid;
-	__kernel_gid_t	cgid;
+	__kernel_key_t		key;
+	__kernel_uid32_t	uid;
+	__kernel_gid32_t	gid;
+	__kernel_uid32_t	cuid;
+	__kernel_gid32_t	cgid;
 #ifndef __arch64__
-	unsigned short	__pad0;
+	unsigned short		__pad0;
 #endif
-	__kernel_mode_t	mode;
-	unsigned short	__pad1;
-	unsigned short	seq;
-	unsigned long long __unused1;
-	unsigned long long __unused2;
+	__kernel_mode_t		mode;
+	unsigned short		__pad1;
+	unsigned short		seq;
+	unsigned long long	__unused1;
+	unsigned long long	__unused2;
 };
=20
 #endif /* __SPARC_IPCBUF_H */
diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
index c2a9dd816c5c..9a7983968ba8 100644
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -115,11 +115,12 @@ void __init tsx_init(void)
 		tsx_disable();
=20
 		/*
-		 * tsx_disable() will change the state of the
-		 * RTM CPUID bit.  Clear it here since it is now
-		 * expected to be not set.
+		 * tsx_disable() will change the state of the RTM and HLE CPUID
+		 * bits. Clear them here since they are now expected to be not
+		 * set.
 		 */
 		setup_clear_cpu_cap(X86_FEATURE_RTM);
+		setup_clear_cpu_cap(X86_FEATURE_HLE);
 	} else if (tsx_ctrl_state =3D=3D TSX_CTRL_ENABLE) {
=20
 		/*
@@ -131,10 +132,10 @@ void __init tsx_init(void)
 		tsx_enable();
=20
 		/*
-		 * tsx_enable() will change the state of the
-		 * RTM CPUID bit.  Force it here since it is now
-		 * expected to be set.
+		 * tsx_enable() will change the state of the RTM and HLE CPUID
+		 * bits. Force them here since they are now expected to be set.
 		 */
 		setup_force_cpu_cap(X86_FEATURE_RTM);
+		setup_force_cpu_cap(X86_FEATURE_HLE);
 	}
 }
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index ede6797ee203..16c267510d28 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -26,6 +26,7 @@
 #include <asm/kvm_emulate.h>
 #include <linux/stringify.h>
 #include <asm/nospec-branch.h>
+#include <linux/nospec.h>
=20
 #include "x86.h"
 #include "tss.h"
@@ -4487,10 +4488,15 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, =
void *insn, int insn_len)
 			}
 			break;
 		case Escape:
-			if (ctxt->modrm > 0xbf)
-				opcode =3D opcode.u.esc->high[ctxt->modrm - 0xc0];
-			else
+			if (ctxt->modrm > 0xbf) {
+				size_t size =3D ARRAY_SIZE(opcode.u.esc->high);
+				u32 index =3D array_index_nospec(
+					ctxt->modrm - 0xc0, size);
+
+				opcode =3D opcode.u.esc->high[index];
+			} else {
 				opcode =3D opcode.u.esc->op[(ctxt->modrm >> 3) & 7];
+			}
 			break;
 		default:
 			return EMULATION_FAILED;
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index cc31f7c06d3d..08b2ad1df9f8 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -486,9 +486,11 @@ static int picdev_write(struct kvm_pic *s,
 	switch (addr) {
 	case 0x20:
 	case 0x21:
+		pic_ioport_write(&s->pics[0], addr, data);
+		break;
 	case 0xa0:
 	case 0xa1:
-		pic_ioport_write(&s->pics[addr >> 7], addr, data);
+		pic_ioport_write(&s->pics[1], addr, data);
 		break;
 	case 0x4d0:
 	case 0x4d1:
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d03a88cb3129..e38d6a7dfbd6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -35,6 +35,7 @@
 #include <asm/apicdef.h>
 #include <linux/atomic.h>
 #include <linux/jump_label.h>
+#include <linux/nospec.h>
 #include "kvm_cache_regs.h"
 #include "irq.h"
 #include "trace.h"
@@ -1196,15 +1197,20 @@ static int apic_reg_write(struct kvm_lapic *apic, u=
32 reg, u32 val)
 	case APIC_LVTTHMR:
 	case APIC_LVTPC:
 	case APIC_LVT1:
-	case APIC_LVTERR:
+	case APIC_LVTERR: {
 		/* TODO: Check vector */
+		size_t size;
+		u32 index;
+
 		if (!kvm_apic_sw_enabled(apic))
 			val |=3D APIC_LVT_MASKED;
-
-		val &=3D apic_lvt_mask[(reg - APIC_LVTT) >> 4];
+		size =3D ARRAY_SIZE(apic_lvt_mask);
+		index =3D array_index_nospec(
+				(reg - APIC_LVTT) >> 4, size);
+		val &=3D apic_lvt_mask[index];
 		apic_set_reg(apic, reg, val);
-
 		break;
+	}
=20
 	case APIC_LVTT:
 		if ((kvm_apic_get_reg(apic, APIC_LVTT) &
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 1faaa78505f4..0566fd97b58e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6455,8 +6455,10 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		/* _system ok, as nested_vmx_check_permission verified cpl=3D0 */
 		if (kvm_write_guest_virt_system(vcpu, gva, &field_value,
 						(is_long_mode(vcpu) ? 8 : 4),
-						&e))
+						&e)) {
 			kvm_inject_page_fault(vcpu, &e);
+			return 1;
+		}
 	}
=20
 	nested_vmx_succeed(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9d4d3e0eaa6b..730b3beeda6a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -48,6 +48,7 @@
 #include <linux/pci.h>
 #include <linux/timekeeper_internal.h>
 #include <linux/pvclock_gtod.h>
+#include <linux/nospec.h>
 #include <trace/events/kvm.h>
=20
 #define CREATE_TRACE_POINTS
@@ -82,6 +83,8 @@ u64 __read_mostly efer_reserved_bits =3D ~((u64)(EFER_SCE=
 | EFER_LME | EFER_LMA));
 static u64 __read_mostly efer_reserved_bits =3D ~((u64)EFER_SCE);
 #endif
=20
+static u64 __read_mostly cr4_reserved_bits =3D CR4_RESERVED_BITS;
+
 #define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
 #define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
=20
@@ -660,13 +663,32 @@ int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64=
 xcr)
 }
 EXPORT_SYMBOL_GPL(kvm_set_xcr);
=20
+static u64 kvm_host_cr4_reserved_bits(struct cpuinfo_x86 *c)
+{
+	u64 reserved_bits =3D CR4_RESERVED_BITS;
+
+	if (!cpu_has(c, X86_FEATURE_XSAVE))
+		reserved_bits |=3D X86_CR4_OSXSAVE;
+
+	if (!cpu_has(c, X86_FEATURE_SMEP))
+		reserved_bits |=3D X86_CR4_SMEP;
+
+	if (!cpu_has(c, X86_FEATURE_SMAP))
+		reserved_bits |=3D X86_CR4_SMAP;
+
+	if (!cpu_has(c, X86_FEATURE_FSGSBASE))
+		reserved_bits |=3D X86_CR4_FSGSBASE;
+
+	return reserved_bits;
+}
+
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	unsigned long old_cr4 =3D kvm_read_cr4(vcpu);
 	unsigned long pdptr_bits =3D X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
 				   X86_CR4_SMEP | X86_CR4_SMAP;
=20
-	if (cr4 & CR4_RESERVED_BITS)
+	if (cr4 & cr4_reserved_bits)
 		return 1;
=20
 	if (!guest_cpuid_has_xsave(vcpu) && (cr4 & X86_CR4_OSXSAVE))
@@ -779,9 +801,11 @@ static void kvm_update_dr7(struct kvm_vcpu *vcpu)
=20
 static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 {
+	size_t size =3D ARRAY_SIZE(vcpu->arch.db);
+
 	switch (dr) {
 	case 0 ... 3:
-		vcpu->arch.db[dr] =3D val;
+		vcpu->arch.db[array_index_nospec(dr, size)] =3D val;
 		if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP))
 			vcpu->arch.eff_db[dr] =3D val;
 		break;
@@ -826,9 +850,11 @@ EXPORT_SYMBOL_GPL(kvm_set_dr);
=20
 static int _kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
 {
+	size_t size =3D ARRAY_SIZE(vcpu->arch.db);
+
 	switch (dr) {
 	case 0 ... 3:
-		*val =3D vcpu->arch.db[dr];
+		*val =3D vcpu->arch.db[array_index_nospec(dr, size)];
 		break;
 	case 4:
 		if (kvm_read_cr4_bits(vcpu, X86_CR4_DE))
@@ -1894,8 +1920,11 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, u32 ms=
r, u64 data)
 		break;
 	default:
 		if (msr >=3D MSR_IA32_MC0_CTL &&
-		    msr < MSR_IA32_MC0_CTL + 4 * bank_num) {
-			u32 offset =3D msr - MSR_IA32_MC0_CTL;
+		    msr < MSR_IA32_MCx_CTL(bank_num)) {
+			u32 offset =3D array_index_nospec(
+				msr - MSR_IA32_MC0_CTL,
+				MSR_IA32_MCx_CTL(bank_num) - MSR_IA32_MC0_CTL);
+
 			/* only 0 or all 1s can be written to IA32_MCi_CTL
 			 * some Linux kernels though clear bit 10 in bank 4 to
 			 * workaround a BIOS/GART TBL issue on AMD K8s, ignore
@@ -2255,7 +2284,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct =
msr_data *msr_info)
=20
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
-	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
+	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
 		return set_msr_mce(vcpu, msr, data);
=20
 	/* Performance counters are not protected by a CPUID bit,
@@ -2421,8 +2450,11 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 ms=
r, u64 *pdata)
 		break;
 	default:
 		if (msr >=3D MSR_IA32_MC0_CTL &&
-		    msr < MSR_IA32_MC0_CTL + 4 * bank_num) {
-			u32 offset =3D msr - MSR_IA32_MC0_CTL;
+		    msr < MSR_IA32_MCx_CTL(bank_num)) {
+			u32 offset =3D array_index_nospec(
+				msr - MSR_IA32_MC0_CTL,
+				MSR_IA32_MCx_CTL(bank_num) - MSR_IA32_MC0_CTL);
+
 			data =3D vcpu->arch.mce_banks[offset];
 			break;
 		}
@@ -2607,7 +2639,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct =
msr_data *msr_info)
 	case MSR_IA32_MCG_CAP:
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
-	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
+	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
 		return get_msr_mce(vcpu, msr_info->index, &msr_info->data);
 	case MSR_K7_CLK_CTL:
 		/*
@@ -5709,14 +5741,12 @@ static void kvm_set_mmio_spte_mask(void)
 	/* Set the present bit. */
 	mask |=3D 1ull;
=20
-#ifdef CONFIG_X86_64
 	/*
 	 * If reserved bit is not supported, clear the present bit to disable
 	 * mmio page fault.
 	 */
 	if (maxphyaddr =3D=3D 52)
 		mask &=3D ~1ull;
-#endif
=20
 	kvm_mmu_set_mmio_spte_mask(mask);
 }
@@ -7068,8 +7098,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_mmu_unload(vcpu);
 	vcpu_put(vcpu);
=20
-	fx_free(vcpu);
-	kvm_x86_ops->vcpu_free(vcpu);
+	kvm_arch_vcpu_free(vcpu);
 }
=20
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu)
@@ -7220,6 +7249,8 @@ int kvm_arch_hardware_setup(void)
 	if (r !=3D 0)
 		return r;
=20
+	cr4_reserved_bits =3D kvm_host_cr4_reserved_bits(&boot_cpu_data);
+
 	kvm_init_msr_list();
 	return 0;
 }
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 09c8ac286cd5..f7e3bcb01c8c 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -435,7 +435,7 @@ void __init efi_unmap_memmap(void)
 {
 	clear_bit(EFI_MEMMAP, &efi.flags);
 	if (memmap.map) {
-		early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
+		early_memunmap(memmap.map, memmap.nr_map * memmap.desc_size);
 		memmap.map =3D NULL;
 	}
 }
@@ -475,12 +475,12 @@ static int __init efi_systab_init(void *phys)
 			if (!data)
 				return -ENOMEM;
 		}
-		systab64 =3D early_ioremap((unsigned long)phys,
+		systab64 =3D early_memremap((unsigned long)phys,
 					 sizeof(*systab64));
 		if (systab64 =3D=3D NULL) {
 			pr_err("Couldn't map the system table!\n");
 			if (data)
-				early_iounmap(data, sizeof(*data));
+				early_memunmap(data, sizeof(*data));
 			return -ENOMEM;
 		}
=20
@@ -512,9 +512,9 @@ static int __init efi_systab_init(void *phys)
 					   systab64->tables;
 		tmp |=3D data ? data->tables : systab64->tables;
=20
-		early_iounmap(systab64, sizeof(*systab64));
+		early_memunmap(systab64, sizeof(*systab64));
 		if (data)
-			early_iounmap(data, sizeof(*data));
+			early_memunmap(data, sizeof(*data));
 #ifdef CONFIG_X86_32
 		if (tmp >> 32) {
 			pr_err("EFI data located above 4GB, disabling EFI.\n");
@@ -524,7 +524,7 @@ static int __init efi_systab_init(void *phys)
 	} else {
 		efi_system_table_32_t *systab32;
=20
-		systab32 =3D early_ioremap((unsigned long)phys,
+		systab32 =3D early_memremap((unsigned long)phys,
 					 sizeof(*systab32));
 		if (systab32 =3D=3D NULL) {
 			pr_err("Couldn't map the system table!\n");
@@ -545,7 +545,7 @@ static int __init efi_systab_init(void *phys)
 		efi_systab.nr_tables =3D systab32->nr_tables;
 		efi_systab.tables =3D systab32->tables;
=20
-		early_iounmap(systab32, sizeof(*systab32));
+		early_memunmap(systab32, sizeof(*systab32));
 	}
=20
 	efi.systab =3D &efi_systab;
@@ -571,7 +571,7 @@ static int __init efi_runtime_init32(void)
 {
 	efi_runtime_services_32_t *runtime;
=20
-	runtime =3D early_ioremap((unsigned long)efi.systab->runtime,
+	runtime =3D early_memremap((unsigned long)efi.systab->runtime,
 			sizeof(efi_runtime_services_32_t));
 	if (!runtime) {
 		pr_err("Could not map the runtime service table!\n");
@@ -586,7 +586,7 @@ static int __init efi_runtime_init32(void)
 	efi_phys.set_virtual_address_map =3D
 			(efi_set_virtual_address_map_t *)
 			(unsigned long)runtime->set_virtual_address_map;
-	early_iounmap(runtime, sizeof(efi_runtime_services_32_t));
+	early_memunmap(runtime, sizeof(efi_runtime_services_32_t));
=20
 	return 0;
 }
@@ -595,7 +595,7 @@ static int __init efi_runtime_init64(void)
 {
 	efi_runtime_services_64_t *runtime;
=20
-	runtime =3D early_ioremap((unsigned long)efi.systab->runtime,
+	runtime =3D early_memremap((unsigned long)efi.systab->runtime,
 			sizeof(efi_runtime_services_64_t));
 	if (!runtime) {
 		pr_err("Could not map the runtime service table!\n");
@@ -610,7 +610,7 @@ static int __init efi_runtime_init64(void)
 	efi_phys.set_virtual_address_map =3D
 			(efi_set_virtual_address_map_t *)
 			(unsigned long)runtime->set_virtual_address_map;
-	early_iounmap(runtime, sizeof(efi_runtime_services_64_t));
+	early_memunmap(runtime, sizeof(efi_runtime_services_64_t));
=20
 	return 0;
 }
@@ -641,7 +641,7 @@ static int __init efi_runtime_init(void)
 static int __init efi_memmap_init(void)
 {
 	/* Map the EFI memory map */
-	memmap.map =3D early_ioremap((unsigned long)memmap.phys_map,
+	memmap.map =3D early_memremap((unsigned long)memmap.phys_map,
 				   memmap.nr_map * memmap.desc_size);
 	if (memmap.map =3D=3D NULL) {
 		pr_err("Could not map the memory map!\n");
@@ -718,7 +718,6 @@ void __init efi_init(void)
 	efi_char16_t *c16;
 	char vendor[100] =3D "unknown";
 	int i =3D 0;
-	void *tmp;
=20
 #ifdef CONFIG_X86_32
 	if (boot_params.efi_info.efi_systab_hi ||
@@ -745,14 +744,16 @@ void __init efi_init(void)
 	/*
 	 * Show what we know for posterity
 	 */
-	c16 =3D tmp =3D early_ioremap(efi.systab->fw_vendor, 2);
+	c16 =3D early_memremap(efi.systab->fw_vendor,
+			     sizeof(vendor) * sizeof(efi_char16_t));
 	if (c16) {
-		for (i =3D 0; i < sizeof(vendor) - 1 && *c16; ++i)
-			vendor[i] =3D *c16++;
+		for (i =3D 0; i < sizeof(vendor) - 1 && c16[i]; ++i)
+			vendor[i] =3D c16[i];
 		vendor[i] =3D '\0';
-	} else
+		early_memunmap(c16, sizeof(vendor) * sizeof(efi_char16_t));
+	} else {
 		pr_err("Could not map the firmware vendor!\n");
-	early_iounmap(tmp, 2);
+	}
=20
 	pr_info("EFI v%u.%.02u by %s\n",
 		efi.systab->hdr.revision >> 16,
diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 7f06df512f24..ae17aeb86130 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -136,11 +136,13 @@ void af_alg_release_parent(struct sock *sk)
 	sk =3D ask->parent;
 	ask =3D alg_sk(sk);
=20
-	lock_sock(sk);
+	local_bh_disable();
+	bh_lock_sock(sk);
 	ask->nokey_refcnt -=3D nokey;
 	if (!last)
 		last =3D !--ask->refcnt;
-	release_sock(sk);
+	bh_unlock_sock(sk);
+	local_bh_enable();
=20
 	if (last)
 		sock_put(sk);
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 300cafd2228d..ede3aec4ff7c 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -618,11 +618,9 @@ EXPORT_SYMBOL_GPL(crypto_init_spawn2);
=20
 void crypto_drop_spawn(struct crypto_spawn *spawn)
 {
-	if (!spawn->alg)
-		return;
-
 	down_write(&crypto_alg_sem);
-	list_del(&spawn->list);
+	if (spawn->alg)
+		list_del(&spawn->list);
 	up_write(&crypto_alg_sem);
 }
 EXPORT_SYMBOL_GPL(crypto_drop_spawn);
@@ -630,22 +628,16 @@ EXPORT_SYMBOL_GPL(crypto_drop_spawn);
 static struct crypto_alg *crypto_spawn_alg(struct crypto_spawn *spawn)
 {
 	struct crypto_alg *alg;
-	struct crypto_alg *alg2;
=20
 	down_read(&crypto_alg_sem);
 	alg =3D spawn->alg;
-	alg2 =3D alg;
-	if (alg2)
-		alg2 =3D crypto_mod_get(alg2);
-	up_read(&crypto_alg_sem);
-
-	if (!alg2) {
-		if (alg)
-			crypto_shoot_alg(alg);
-		return ERR_PTR(-EAGAIN);
+	if (alg && !crypto_mod_get(alg)) {
+		alg->cra_flags |=3D CRYPTO_ALG_DYING;
+		alg =3D NULL;
 	}
+	up_read(&crypto_alg_sem);
=20
-	return alg;
+	return alg ?: ERR_PTR(-EAGAIN);
 }
=20
 struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
diff --git a/crypto/api.c b/crypto/api.c
index 7db2e89a3114..b16cedc5731a 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -345,13 +345,12 @@ static unsigned int crypto_ctxsize(struct crypto_alg =
*alg, u32 type, u32 mask)
 	return len;
 }
=20
-void crypto_shoot_alg(struct crypto_alg *alg)
+static void crypto_shoot_alg(struct crypto_alg *alg)
 {
 	down_write(&crypto_alg_sem);
 	alg->cra_flags |=3D CRYPTO_ALG_DYING;
 	up_write(&crypto_alg_sem);
 }
-EXPORT_SYMBOL_GPL(crypto_shoot_alg);
=20
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask)
diff --git a/crypto/internal.h b/crypto/internal.h
index bd39bfc92eab..3c15f2b25c99 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -88,7 +88,6 @@ void crypto_alg_tested(const char *name, int err);
 void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 			  struct crypto_alg *nalg);
 void crypto_remove_final(struct list_head *list);
-void crypto_shoot_alg(struct crypto_alg *alg);
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask);
 void *crypto_create_tfm(struct crypto_alg *alg,
diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index a96de79498ee..a615ab6e3966 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -137,7 +137,6 @@ static void pcrypt_aead_done(struct crypto_async_reques=
t *areq, int err)
 	struct padata_priv *padata =3D pcrypt_request_padata(preq);
=20
 	padata->info =3D err;
-	req->base.flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
=20
 	padata_do_serial(padata);
 }
@@ -552,11 +551,12 @@ static int __init pcrypt_init(void)
=20
 static void __exit pcrypt_exit(void)
 {
+	crypto_unregister_template(&pcrypt_tmpl);
+
 	pcrypt_fini_padata(&pencrypt);
 	pcrypt_fini_padata(&pdecrypt);
=20
 	kset_unregister(pcrypt_kset);
-	crypto_unregister_template(&pcrypt_tmpl);
 }
=20
 module_init(pcrypt_init);
diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_c=
rypto.c
index 5da5b98b8f29..8bdd1e641914 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1690,6 +1690,11 @@ static bool spacc_is_compatible(struct platform_devi=
ce *pdev,
 	return false;
 }
=20
+static void spacc_tasklet_kill(void *data)
+{
+	tasklet_kill(data);
+}
+
 static int spacc_probe(struct platform_device *pdev)
 {
 	int i, err, ret =3D -EINVAL;
@@ -1730,6 +1735,14 @@ static int spacc_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
=20
+	tasklet_init(&engine->complete, spacc_spacc_complete,
+		     (unsigned long)engine);
+
+	ret =3D devm_add_action(&pdev->dev, spacc_tasklet_kill,
+			      &engine->complete);
+	if (ret)
+		return ret;
+
 	if (devm_request_irq(&pdev->dev, irq->start, spacc_spacc_irq, 0,
 			     engine->name, engine)) {
 		dev_err(engine->dev, "failed to request IRQ\n");
@@ -1792,8 +1805,6 @@ static int spacc_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&engine->completed);
 	INIT_LIST_HEAD(&engine->in_progress);
 	engine->in_flight =3D 0;
-	tasklet_init(&engine->complete, spacc_spacc_complete,
-		     (unsigned long)engine);
=20
 	platform_set_drvdata(pdev, engine);
=20
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index d1296babcc18..ad558dda449a 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -295,7 +295,7 @@ int __init efi_config_init(efi_config_table_type_t *arc=
h_tables)
 			if (table64 >> 32) {
 				pr_cont("\n");
 				pr_err("Table located above 4GB, disabling EFI.\n");
-				early_iounmap(config_tables,
+				early_memunmap(config_tables,
 					       efi.systab->nr_tables * sz);
 				return -EINVAL;
 			}
@@ -311,7 +311,7 @@ int __init efi_config_init(efi_config_table_type_t *arc=
h_tables)
 		tablep +=3D sz;
 	}
 	pr_cont("\n");
-	early_iounmap(config_tables, efi.systab->nr_tables * sz);
+	early_memunmap(config_tables, efi.systab->nr_tables * sz);
=20
 	set_bit(EFI_CONFIG_TABLES, &efi.flags);
=20
diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/=
persistent-data/dm-space-map-common.c
index aacbe70c2c2e..6ade82751181 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -384,6 +384,33 @@ int sm_ll_find_free_block(struct ll_disk *ll, dm_block=
_t begin,
 	return -ENOSPC;
 }
=20
+int sm_ll_find_common_free_block(struct ll_disk *old_ll, struct ll_disk *n=
ew_ll,
+	                         dm_block_t begin, dm_block_t end, dm_block_t *b)
+{
+	int r;
+	uint32_t count;
+
+	do {
+		r =3D sm_ll_find_free_block(new_ll, begin, new_ll->nr_blocks, b);
+		if (r)
+			break;
+
+		/* double check this block wasn't used in the old transaction */
+		if (*b >=3D old_ll->nr_blocks)
+			count =3D 0;
+		else {
+			r =3D sm_ll_lookup(old_ll, *b, &count);
+			if (r)
+				break;
+
+			if (count)
+				begin =3D *b + 1;
+		}
+	} while (count);
+
+	return r;
+}
+
 static int sm_ll_mutate(struct ll_disk *ll, dm_block_t b,
 			int (*mutator)(void *context, uint32_t old, uint32_t *new),
 			void *context, enum allocation_event *ev)
diff --git a/drivers/md/persistent-data/dm-space-map-common.h b/drivers/md/=
persistent-data/dm-space-map-common.h
index b3078d5eda0c..8de63ce39bdd 100644
--- a/drivers/md/persistent-data/dm-space-map-common.h
+++ b/drivers/md/persistent-data/dm-space-map-common.h
@@ -109,6 +109,8 @@ int sm_ll_lookup_bitmap(struct ll_disk *ll, dm_block_t =
b, uint32_t *result);
 int sm_ll_lookup(struct ll_disk *ll, dm_block_t b, uint32_t *result);
 int sm_ll_find_free_block(struct ll_disk *ll, dm_block_t begin,
 			  dm_block_t end, dm_block_t *result);
+int sm_ll_find_common_free_block(struct ll_disk *old_ll, struct ll_disk *n=
ew_ll,
+	                         dm_block_t begin, dm_block_t end, dm_block_t *re=
sult);
 int sm_ll_insert(struct ll_disk *ll, dm_block_t b, uint32_t ref_count, enu=
m allocation_event *ev);
 int sm_ll_inc(struct ll_disk *ll, dm_block_t b, enum allocation_event *ev);
 int sm_ll_dec(struct ll_disk *ll, dm_block_t b, enum allocation_event *ev);
diff --git a/drivers/md/persistent-data/dm-space-map-disk.c b/drivers/md/pe=
rsistent-data/dm-space-map-disk.c
index 8d0a6a23438b..d2487a6efc79 100644
--- a/drivers/md/persistent-data/dm-space-map-disk.c
+++ b/drivers/md/persistent-data/dm-space-map-disk.c
@@ -165,8 +165,10 @@ static int sm_disk_new_block(struct dm_space_map *sm, =
dm_block_t *b)
 	enum allocation_event ev;
 	struct sm_disk *smd =3D container_of(sm, struct sm_disk, sm);
=20
-	/* FIXME: we should loop round a couple of times */
-	r =3D sm_ll_find_free_block(&smd->old_ll, smd->begin, smd->old_ll.nr_bloc=
ks, b);
+	/*
+	 * Any block we allocate has to be free in both the old and current ll.
+	 */
+	r =3D sm_ll_find_common_free_block(&smd->old_ll, &smd->ll, smd->begin, sm=
d->ll.nr_blocks, b);
 	if (r)
 		return r;
=20
diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/m=
d/persistent-data/dm-space-map-metadata.c
index 35a7ac8499c3..0aed7ec50a95 100644
--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -447,7 +447,10 @@ static int sm_metadata_new_block_(struct dm_space_map =
*sm, dm_block_t *b)
 	enum allocation_event ev;
 	struct sm_metadata *smm =3D container_of(sm, struct sm_metadata, sm);
=20
-	r =3D sm_ll_find_free_block(&smm->old_ll, smm->begin, smm->old_ll.nr_bloc=
ks, b);
+	/*
+	 * Any block we allocate has to be free in both the old and current ll.
+	 */
+	r =3D sm_ll_find_common_free_block(&smm->old_ll, &smm->ll, smm->begin, sm=
m->ll.nr_blocks, b);
 	if (r)
 		return r;
=20
diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 627ddfd61980..611d539ad925 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -430,6 +430,10 @@ static int iguanair_probe(struct usb_interface *intf,
 	int ret, pipein, pipeout;
 	struct usb_host_interface *idesc;
=20
+	idesc =3D intf->cur_altsetting;
+	if (idesc->desc.bNumEndpoints < 2)
+		return -ENODEV;
+
 	ir =3D kzalloc(sizeof(*ir), GFP_KERNEL);
 	rc =3D rc_allocate_device();
 	if (!ir || !rc) {
@@ -444,18 +448,13 @@ static int iguanair_probe(struct usb_interface *intf,
 	ir->urb_in =3D usb_alloc_urb(0, GFP_KERNEL);
 	ir->urb_out =3D usb_alloc_urb(0, GFP_KERNEL);
=20
-	if (!ir->buf_in || !ir->packet || !ir->urb_in || !ir->urb_out) {
+	if (!ir->buf_in || !ir->packet || !ir->urb_in || !ir->urb_out ||
+	    !usb_endpoint_is_int_in(&idesc->endpoint[0].desc) ||
+	    !usb_endpoint_is_int_out(&idesc->endpoint[1].desc)) {
 		ret =3D -ENOMEM;
 		goto out;
 	}
=20
-	idesc =3D intf->altsetting;
-
-	if (idesc->desc.bNumEndpoints < 2) {
-		ret =3D -ENODEV;
-		goto out;
-	}
-
 	ir->rc =3D rc;
 	ir->dev =3D &intf->dev;
 	ir->udev =3D udev;
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc=
_driver.c
index 9da63b6ff167..37da5b650523 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1369,6 +1369,11 @@ static int uvc_scan_chain_forward(struct uvc_video_c=
hain *chain,
 			break;
 		if (forward =3D=3D prev)
 			continue;
+		if (forward->chain.next || forward->chain.prev) {
+			uvc_trace(UVC_TRACE_DESCR, "Found reference to "
+				"entity %d already in chain.\n", forward->id);
+			return -EINVAL;
+		}
=20
 		switch (UVC_ENTITY_TYPE(forward)) {
 		case UVC_VC_EXTENSION_UNIT:
@@ -1450,6 +1455,13 @@ static int uvc_scan_chain_backward(struct uvc_video_=
chain *chain,
 				return -1;
 			}
=20
+			if (term->chain.next || term->chain.prev) {
+				uvc_trace(UVC_TRACE_DESCR, "Found reference to "
+					"entity %d already in chain.\n",
+					term->id);
+				return -EINVAL;
+			}
+
 			if (uvc_trace_param & UVC_TRACE_PROBE)
 				printk(" %d", term->id);
=20
diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2=
-core/videobuf-dma-sg.c
index 828e7c10bd70..05410a8d2c8b 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -316,8 +316,11 @@ int videobuf_dma_free(struct videobuf_dmabuf *dma)
 	BUG_ON(dma->sglen);
=20
 	if (dma->pages) {
-		for (i =3D 0; i < dma->nr_pages; i++)
+		for (i =3D 0; i < dma->nr_pages; i++) {
+			if (dma->direction =3D=3D DMA_FROM_DEVICE)
+				set_page_dirty_lock(dma->pages[i]);
 			page_cache_release(dma->pages[i]);
+		}
 		kfree(dma->pages);
 		dma->pages =3D NULL;
 	}
diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index a55c4fb42b00..cf1e58b73560 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1149,17 +1149,22 @@ static void mmc_spi_initsequence(struct mmc_spi_hos=
t *host)
 	 * SPI protocol.  Another is that when chipselect is released while
 	 * the card returns BUSY status, the clock must issue several cycles
 	 * with chipselect high before the card will stop driving its output.
+	 *
+	 * SPI_CS_HIGH means "asserted" here. In some cases like when using
+	 * GPIOs for chip select, SPI_CS_HIGH is set but this will be logically
+	 * inverted by gpiolib, so if we want to ascertain to drive it high
+	 * we should toggle the default with an XOR as we do here.
 	 */
-	host->spi->mode |=3D SPI_CS_HIGH;
+	host->spi->mode ^=3D SPI_CS_HIGH;
 	if (spi_setup(host->spi) !=3D 0) {
 		/* Just warn; most cards work without it. */
 		dev_warn(&host->spi->dev,
 				"can't change chip-select polarity\n");
-		host->spi->mode &=3D ~SPI_CS_HIGH;
+		host->spi->mode ^=3D SPI_CS_HIGH;
 	} else {
 		mmc_spi_readbytes(host, 18);
=20
-		host->spi->mode &=3D ~SPI_CS_HIGH;
+		host->spi->mode ^=3D SPI_CS_HIGH;
 		if (spi_setup(host->spi) !=3D 0) {
 			/* Wot, we can't get the same setup we had before? */
 			dev_err(&host->spi->dev,
diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index cd440dfffad1..16ea3787a02b 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1450,26 +1450,31 @@ int bond_alb_xmit(struct sk_buff *skb, struct net_d=
evice *bond_dev)
 	bool do_tx_balance =3D true;
 	u32 hash_index =3D 0;
 	const u8 *hash_start =3D NULL;
-	struct ipv6hdr *ip6hdr;
=20
 	skb_reset_mac_header(skb);
 	eth_data =3D eth_hdr(skb);
=20
 	switch (ntohs(skb->protocol)) {
 	case ETH_P_IP: {
-		const struct iphdr *iph =3D ip_hdr(skb);
+		const struct iphdr *iph;
=20
 		if (ether_addr_equal_64bits(eth_data->h_dest, mac_bcast) ||
-		    (iph->daddr =3D=3D ip_bcast) ||
-		    (iph->protocol =3D=3D IPPROTO_IGMP)) {
+		    !pskb_network_may_pull(skb, sizeof(*iph))) {
+			do_tx_balance =3D false;
+			break;
+		}
+		iph =3D ip_hdr(skb);
+		if (iph->daddr =3D=3D ip_bcast || iph->protocol =3D=3D IPPROTO_IGMP) {
 			do_tx_balance =3D false;
 			break;
 		}
 		hash_start =3D (char *)&(iph->daddr);
 		hash_size =3D sizeof(iph->daddr);
-	}
 		break;
-	case ETH_P_IPV6:
+	}
+	case ETH_P_IPV6: {
+		const struct ipv6hdr *ip6hdr;
+
 		/* IPv6 doesn't really use broadcast mac address, but leave
 		 * that here just in case.
 		 */
@@ -1486,7 +1491,11 @@ int bond_alb_xmit(struct sk_buff *skb, struct net_de=
vice *bond_dev)
 			break;
 		}
=20
-		/* Additianally, DAD probes should not be tx-balanced as that
+		if (!pskb_network_may_pull(skb, sizeof(*ip6hdr))) {
+			do_tx_balance =3D false;
+			break;
+		}
+		/* Additionally, DAD probes should not be tx-balanced as that
 		 * will lead to false positives for duplicate addresses and
 		 * prevent address configuration from working.
 		 */
@@ -1496,17 +1505,26 @@ int bond_alb_xmit(struct sk_buff *skb, struct net_d=
evice *bond_dev)
 			break;
 		}
=20
-		hash_start =3D (char *)&(ipv6_hdr(skb)->daddr);
-		hash_size =3D sizeof(ipv6_hdr(skb)->daddr);
+		hash_start =3D (char *)&ip6hdr->daddr;
+		hash_size =3D sizeof(ip6hdr->daddr);
 		break;
-	case ETH_P_IPX:
-		if (ipx_hdr(skb)->ipx_checksum !=3D IPX_NO_CHECKSUM) {
+	}
+	case ETH_P_IPX: {
+		const struct ipxhdr *ipxhdr;
+
+		if (pskb_network_may_pull(skb, sizeof(*ipxhdr))) {
+			do_tx_balance =3D false;
+			break;
+		}
+		ipxhdr =3D (struct ipxhdr *)skb_network_header(skb);
+
+		if (ipxhdr->ipx_checksum !=3D IPX_NO_CHECKSUM) {
 			/* something is wrong with this packet */
 			do_tx_balance =3D false;
 			break;
 		}
=20
-		if (ipx_hdr(skb)->ipx_type !=3D IPX_TYPE_NCP) {
+		if (ipxhdr->ipx_type !=3D IPX_TYPE_NCP) {
 			/* The only protocol worth balancing in
 			 * this family since it has an "ARP" like
 			 * mechanism
@@ -1515,9 +1533,11 @@ int bond_alb_xmit(struct sk_buff *skb, struct net_de=
vice *bond_dev)
 			break;
 		}
=20
+		eth_data =3D eth_hdr(skb);
 		hash_start =3D (char *)eth_data->h_dest;
 		hash_size =3D ETH_ALEN;
 		break;
+	}
 	case ETH_P_ARP:
 		do_tx_balance =3D false;
 		if (bond_info->rlb_enabled)
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/etherne=
t/freescale/gianfar.c
index a6cf40e62f3a..1b90a6e63edc 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -2524,13 +2524,17 @@ static void gfar_clean_tx_ring(struct gfar_priv_tx_=
q *tx_queue)
=20
 	while ((skb =3D tx_queue->tx_skbuff[skb_dirtytx])) {
 		unsigned long flags;
+		bool do_tstamp;
+
+		do_tstamp =3D (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+			    priv->hwts_tx_en;
=20
 		frags =3D skb_shinfo(skb)->nr_frags;
=20
 		/* When time stamping, one additional TxBD must be freed.
 		 * Also, we need to dma_unmap_single() the TxPAL.
 		 */
-		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS))
+		if (unlikely(do_tstamp))
 			nr_txbds =3D frags + 2;
 		else
 			nr_txbds =3D frags + 1;
@@ -2544,7 +2548,7 @@ static void gfar_clean_tx_ring(struct gfar_priv_tx_q =
*tx_queue)
 		    (lstatus & BD_LENGTH_MASK))
 			break;
=20
-		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS)) {
+		if (unlikely(do_tstamp)) {
 			next =3D next_txbd(bdp, base, tx_ring_size);
 			buflen =3D next->length + GMAC_FCB_LEN + GMAC_TXPAL_LEN;
 		} else
@@ -2553,7 +2557,7 @@ static void gfar_clean_tx_ring(struct gfar_priv_tx_q =
*tx_queue)
 		dma_unmap_single(priv->dev, bdp->bufPtr,
 				 buflen, DMA_TO_DEVICE);
=20
-		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS)) {
+		if (unlikely(do_tstamp)) {
 			struct skb_shared_hwtstamps shhwtstamps;
 			u64 *ns =3D (u64*) (((u32)skb->data + 0x10) & ~0x7);
=20
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireles=
s/ath/ath9k/hif_usb.c
index 2bb8dd09fec2..abe99aa6b002 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1141,7 +1141,7 @@ static void ath9k_hif_usb_firmware_cb(const struct fi=
rmware *fw, void *context)
 static int send_eject_command(struct usb_interface *interface)
 {
 	struct usb_device *udev =3D interface_to_usbdev(interface);
-	struct usb_host_interface *iface_desc =3D &interface->altsetting[0];
+	struct usb_host_interface *iface_desc =3D interface->cur_altsetting;
 	struct usb_endpoint_descriptor *endpoint;
 	unsigned char *cmd;
 	u8 bulk_out_ep;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/n=
et/wireless/brcm80211/brcmfmac/dhd_sdio.c
index f93bdba6901c..8a1d1e480c9a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1971,7 +1971,10 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio =
*bus, uint maxframes)
 			if (brcmf_sdio_hdparse(bus, bus->rxhdr, &rd_new,
 					       BRCMF_SDIO_FT_NORMAL)) {
 				rd->len =3D 0;
+				brcmf_sdio_rxfail(bus, true, true);
+				sdio_release_host(bus->sdiodev->func[1]);
 				brcmu_pkt_buf_free_skb(pkt);
+				continue;
 			}
 			bus->sdcnt.rx_readahead_cnt++;
 			if (rd->len !=3D roundup(rd_new.len, 16)) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wi=
reless/brcm80211/brcmfmac/usb.c
index f245a39f612c..a31458c6f7a3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -41,7 +41,7 @@
=20
 #define CONFIGDESC(usb)         (&((usb)->actconfig)->desc)
 #define IFPTR(usb, idx)         ((usb)->actconfig->interface[(idx)])
-#define IFALTS(usb, idx)        (IFPTR((usb), (idx))->altsetting[0])
+#define IFALTS(usb, idx)        (*IFPTR((usb), (idx))->cur_altsetting)
 #define IFDESC(usb, idx)        IFALTS((usb), (idx)).desc
 #define IFEPDESC(usb, idx, ep)  (IFALTS((usb), (idx)).endpoint[(ep)]).desc
=20
@@ -365,6 +365,7 @@ brcmf_usbdev_qinit(struct list_head *q, int qsize)
 			usb_free_urb(req->urb);
 		list_del(q->next);
 	}
+	kfree(reqs);
 	return NULL;
=20
 }
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/=
iwlegacy/common.c
index ecc674627e6e..eb22eea328a9 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -717,7 +717,7 @@ il_eeprom_init(struct il_priv *il)
 	u32 gp =3D _il_rd(il, CSR_EEPROM_GP);
 	int sz;
 	int ret;
-	u16 addr;
+	int addr;
=20
 	/* allocate eeprom */
 	sz =3D il->cfg->eeprom_size;
diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wirel=
ess/orinoco/orinoco_usb.c
index c90939ced0e4..f97af26e86d6 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -1602,9 +1602,9 @@ static int ezusb_probe(struct usb_interface *interfac=
e,
 	/* set up the endpoint information */
 	/* check out the endpoints */
=20
-	iface_desc =3D &interface->altsetting[0].desc;
+	iface_desc =3D &interface->cur_altsetting->desc;
 	for (i =3D 0; i < iface_desc->bNumEndpoints; ++i) {
-		ep =3D &interface->altsetting[0].endpoint[i].desc;
+		ep =3D &interface->cur_altsetting->endpoint[i].desc;
=20
 		if (((ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
 		     =3D=3D USB_DIR_IN) &&
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/=
rsi/rsi_91x_usb.c
index 4c46e5631e2f..16f83f6c1b75 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -103,7 +103,7 @@ static int rsi_find_bulk_in_and_out_endpoints(struct us=
b_interface *interface,
 	__le16 buffer_size;
 	int ii, bep_found =3D 0;
=20
-	iface_desc =3D &(interface->altsetting[0]);
+	iface_desc =3D interface->cur_altsetting;
=20
 	for (ii =3D 0; ii < iface_desc->desc.bNumEndpoints; ++ii) {
 		endpoint =3D &(iface_desc->endpoint[ii].desc);
@@ -245,6 +245,14 @@ static void rsi_rx_done_handler(struct urb *urb)
 	rsi_set_event(&dev->rx_thread.event);
 }
=20
+static void rsi_rx_urb_kill(struct rsi_hw *adapter)
+{
+	struct rsi_91x_usbdev *dev =3D (struct rsi_91x_usbdev *)adapter->rsi_dev;
+	struct urb *urb =3D dev->rx_usb_urb[0];
+
+	usb_kill_urb(urb);
+}
+
 /**
  * rsi_rx_urb_submit() - This function submits the given URB to the USB st=
ack.
  * @adapter: Pointer to the adapter structure.
@@ -510,6 +518,8 @@ static void rsi_disconnect(struct usb_interface *pfunct=
ion)
 	if (!adapter)
 		return;
=20
+	rsi_rx_urb_kill(adapter);
+
 	rsi_mac80211_detach(adapter);
 	rsi_deinit_usb_interface(adapter);
 	rsi_91x_deinit(adapter);
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/=
zd1211rw/zd_usb.c
index 8d621ee5f349..d51557809c60 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -1272,7 +1272,7 @@ static void print_id(struct usb_device *udev)
 static int eject_installer(struct usb_interface *intf)
 {
 	struct usb_device *udev =3D interface_to_usbdev(intf);
-	struct usb_host_interface *iface_desc =3D &intf->altsetting[0];
+	struct usb_host_interface *iface_desc =3D intf->cur_altsetting;
 	struct usb_endpoint_descriptor *endpoint;
 	unsigned char *cmd;
 	u8 bulk_out_ep;
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 2dcb0541012d..a3bec421551e 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -78,4 +78,8 @@ config OF_RESERVED_MEM
 	help
 	  Helpers to allow for reservation of memory regions
=20
+config OF_DMA_DEFAULT_COHERENT
+	# arches should select this if DMA is coherent by default for OF devices
+	bool
+
 endmenu # OF
diff --git a/drivers/of/address.c b/drivers/of/address.c
index 01570bf23842..2f108ab4e7f6 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -812,12 +812,16 @@ EXPORT_SYMBOL_GPL(of_dma_get_range);
  * @np:	device node
  *
  * It returns true if "dma-coherent" property was found
- * for this device in DT.
+ * for this device in the DT, or if DMA is coherent by
+ * default for OF devices on the current platform.
  */
 bool of_dma_is_coherent(struct device_node *np)
 {
 	struct device_node *node =3D of_node_get(np);
=20
+	if (IS_ENABLED(CONFIG_OF_DMA_DEFAULT_COHERENT))
+		return true;
+
 	while (node) {
 		if (of_property_read_bool(node, "dma-coherent")) {
 			of_node_put(node);
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 8c7496928fb8..5946b071fdcf 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1650,12 +1650,18 @@ void pci_assign_unassigned_root_bus_resources(struc=
t pci_bus *bus)
 	/* restore size and flags */
 	list_for_each_entry(fail_res, &fail_head, list) {
 		struct resource *res =3D fail_res->res;
+		int idx;
=20
 		res->start =3D fail_res->start;
 		res->end =3D fail_res->end;
 		res->flags =3D fail_res->flags;
-		if (fail_res->dev->subordinate)
-			res->flags =3D 0;
+
+		if (pci_is_bridge(fail_res->dev)) {
+			idx =3D res - &fail_res->dev->resource[0];
+			if (idx >=3D PCI_BRIDGE_RESOURCES &&
+			    idx <=3D PCI_BRIDGE_RESOURCE_END)
+				res->flags =3D 0;
+		}
 	}
 	free_list(&fail_head);
=20
@@ -1716,12 +1722,18 @@ void pci_assign_unassigned_bridge_resources(struct =
pci_dev *bridge)
 	/* restore size and flags */
 	list_for_each_entry(fail_res, &fail_head, list) {
 		struct resource *res =3D fail_res->res;
+		int idx;
=20
 		res->start =3D fail_res->start;
 		res->end =3D fail_res->end;
 		res->flags =3D fail_res->flags;
-		if (fail_res->dev->subordinate)
-			res->flags =3D 0;
+
+		if (pci_is_bridge(fail_res->dev)) {
+			idx =3D res - &fail_res->dev->resource[0];
+			if (idx >=3D PCI_BRIDGE_RESOURCES &&
+			    idx <=3D PCI_BRIDGE_RESOURCE_END)
+				res->flags =3D 0;
+		}
 	}
 	free_list(&fail_head);
=20
diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
index b5f2a76b6cdf..32553c23d467 100644
--- a/drivers/power/sbs-battery.c
+++ b/drivers/power/sbs-battery.c
@@ -400,7 +400,7 @@ static int sbs_get_battery_capacity(struct i2c_client *=
client,
 		mode =3D BATTERY_MODE_AMPS;
=20
 	mode =3D sbs_set_battery_mode(client, mode);
-	if (mode < 0)
+	if ((int)mode < 0)
 		return mode;
=20
 	ret =3D sbs_read_word_data(client, sbs_data[reg_offset].addr);
diff --git a/drivers/rtc/rtc-hym8563.c b/drivers/rtc/rtc-hym8563.c
index 280584b2813b..93ac58d11f3d 100644
--- a/drivers/rtc/rtc-hym8563.c
+++ b/drivers/rtc/rtc-hym8563.c
@@ -105,7 +105,7 @@ static int hym8563_rtc_read_time(struct device *dev, st=
ruct rtc_time *tm)
=20
 	if (!hym8563->valid) {
 		dev_warn(&client->dev, "no valid clock/calendar values available\n");
-		return -EPERM;
+		return -EINVAL;
 	}
=20
 	ret =3D i2c_smbus_read_i2c_block_data(client, HYM8563_SEC, 7, buf);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 50f5e6043268..f9054cce41be 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5388,9 +5388,8 @@ qla2x00_dump_mctp_data(scsi_qla_host_t *vha, dma_addr=
_t req_dma, uint32_t addr,
 	mcp->mb[7] =3D LSW(MSD(req_dma));
 	mcp->mb[8] =3D MSW(addr);
 	/* Setting RAM ID to valid */
-	mcp->mb[10] |=3D BIT_7;
 	/* For MCTP RAM ID is 0x40 */
-	mcp->mb[10] |=3D 0x40;
+	mcp->mb[10] =3D BIT_7 | 0x40;
=20
 	mcp->out_mb |=3D MBX_10|MBX_8|MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|
 	    MBX_0;
diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index 66e9e5196c8c..b3e697d5b596 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -182,9 +182,11 @@ static inline u32 rx_max(struct dw_spi *dws)
=20
 static void dw_writer(struct dw_spi *dws)
 {
-	u32 max =3D tx_max(dws);
+	u32 max;
 	u16 txw =3D 0;
=20
+	spin_lock(&dws->buf_lock);
+	max =3D tx_max(dws);
 	while (max--) {
 		/* Set the tx word if the transfer's original "tx" is not null */
 		if (dws->tx_end - dws->len) {
@@ -196,13 +198,16 @@ static void dw_writer(struct dw_spi *dws)
 		dw_writew(dws, DW_SPI_DR, txw);
 		dws->tx +=3D dws->n_bytes;
 	}
+	spin_unlock(&dws->buf_lock);
 }
=20
 static void dw_reader(struct dw_spi *dws)
 {
-	u32 max =3D rx_max(dws);
+	u32 max;
 	u16 rxw;
=20
+	spin_lock(&dws->buf_lock);
+	max =3D rx_max(dws);
 	while (max--) {
 		rxw =3D dw_readw(dws, DW_SPI_DR);
 		/* Care rx only if the transfer's original "rx" is not null */
@@ -214,6 +219,7 @@ static void dw_reader(struct dw_spi *dws)
 		}
 		dws->rx +=3D dws->n_bytes;
 	}
+	spin_unlock(&dws->buf_lock);
 }
=20
 static void *next_transfer(struct dw_spi *dws)
@@ -368,6 +374,7 @@ static void pump_transfers(unsigned long data)
 	struct spi_transfer *previous =3D NULL;
 	struct spi_device *spi =3D NULL;
 	struct chip_data *chip =3D NULL;
+	unsigned long flags;
 	u8 bits =3D 0;
 	u8 imask =3D 0;
 	u8 cs_change =3D 0;
@@ -406,6 +413,7 @@ static void pump_transfers(unsigned long data)
 	dws->dma_width =3D chip->dma_width;
 	dws->cs_control =3D chip->cs_control;
=20
+	spin_lock_irqsave(&dws->buf_lock, flags);
 	dws->rx_dma =3D transfer->rx_dma;
 	dws->tx_dma =3D transfer->tx_dma;
 	dws->tx =3D (void *)transfer->tx_buf;
@@ -415,6 +423,7 @@ static void pump_transfers(unsigned long data)
 	dws->len =3D dws->cur_transfer->len;
 	if (chip !=3D dws->prev_chip)
 		cs_change =3D 1;
+	spin_unlock_irqrestore(&dws->buf_lock, flags);
=20
 	cr0 =3D chip->cr0;
=20
@@ -651,6 +660,7 @@ int dw_spi_add_host(struct device *dev, struct dw_spi *=
dws)
 	dws->dma_addr =3D (dma_addr_t)(dws->paddr + 0x60);
 	snprintf(dws->name, sizeof(dws->name), "dw_spi%d",
 			dws->bus_num);
+	spin_lock_init(&dws->buf_lock);
=20
 	ret =3D request_irq(dws->irq, dw_spi_irq, IRQF_SHARED, dws->name, dws);
 	if (ret < 0) {
diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
index 6d2acad34f64..be4119a2159b 100644
--- a/drivers/spi/spi-dw.h
+++ b/drivers/spi/spi-dw.h
@@ -116,6 +116,7 @@ struct dw_spi {
 	size_t			len;
 	void			*tx;
 	void			*tx_end;
+	spinlock_t		buf_lock;
 	void			*rx;
 	void			*rx_end;
 	int			dma_mapped;
diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng=
/prism2mgmt.c
index d110b362c3bd..68465e7343ef 100644
--- a/drivers/staging/wlan-ng/prism2mgmt.c
+++ b/drivers/staging/wlan-ng/prism2mgmt.c
@@ -939,7 +939,7 @@ int prism2mgmt_flashdl_state(wlandevice_t *wlandev, voi=
d *msgp)
 		}
 	}
=20
-	return 0;
+	return result;
 }
=20
 /*----------------------------------------------------------------
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 52b30c5b000e..b489be926ebd 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -614,6 +614,9 @@ static void dwc3_core_exit_mode(struct dwc3 *dwc)
 		/* do nothing */
 		break;
 	}
+
+	/* de-assert DRVVBUS for HOST and OTG mode */
+	dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_DEVICE);
 }
=20
 #define DWC3_ALIGN_MASK		(16 - 1)
diff --git a/drivers/usb/gadget/f_ecm.c b/drivers/usb/gadget/f_ecm.c
index 798760fa7e70..637f631a66a4 100644
--- a/drivers/usb/gadget/f_ecm.c
+++ b/drivers/usb/gadget/f_ecm.c
@@ -56,6 +56,7 @@ struct f_ecm {
 	struct usb_ep			*notify;
 	struct usb_request		*notify_req;
 	u8				notify_state;
+	atomic_t			notify_count;
 	bool				is_open;
=20
 	/* FIXME is_open needs some irq-ish locking
@@ -384,7 +385,7 @@ static void ecm_do_notify(struct f_ecm *ecm)
 	int				status;
=20
 	/* notification already in flight? */
-	if (!req)
+	if (atomic_read(&ecm->notify_count))
 		return;
=20
 	event =3D req->buf;
@@ -424,10 +425,10 @@ static void ecm_do_notify(struct f_ecm *ecm)
 	event->bmRequestType =3D 0xA1;
 	event->wIndex =3D cpu_to_le16(ecm->ctrl_id);
=20
-	ecm->notify_req =3D NULL;
+	atomic_inc(&ecm->notify_count);
 	status =3D usb_ep_queue(ecm->notify, req, GFP_ATOMIC);
 	if (status < 0) {
-		ecm->notify_req =3D req;
+		atomic_dec(&ecm->notify_count);
 		DBG(cdev, "notify --> %d\n", status);
 	}
 }
@@ -452,17 +453,19 @@ static void ecm_notify_complete(struct usb_ep *ep, st=
ruct usb_request *req)
 	switch (req->status) {
 	case 0:
 		/* no fault */
+		atomic_dec(&ecm->notify_count);
 		break;
 	case -ECONNRESET:
 	case -ESHUTDOWN:
+		atomic_set(&ecm->notify_count, 0);
 		ecm->notify_state =3D ECM_NOTIFY_NONE;
 		break;
 	default:
 		DBG(cdev, "event %02x --> %d\n",
 			event->bNotificationType, req->status);
+		atomic_dec(&ecm->notify_count);
 		break;
 	}
-	ecm->notify_req =3D req;
 	ecm_do_notify(ecm);
 }
=20
@@ -922,6 +925,11 @@ static void ecm_unbind(struct usb_configuration *c, st=
ruct usb_function *f)
=20
 	usb_free_all_descriptors(f);
=20
+	if (atomic_read(&ecm->notify_count)) {
+		usb_ep_dequeue(ecm->notify, ecm->notify_req);
+		atomic_set(&ecm->notify_count, 0);
+	}
+
 	kfree(ecm->notify_req->buf);
 	usb_ep_free_request(ecm->notify, ecm->notify_req);
 }
diff --git a/drivers/usb/gadget/f_ncm.c b/drivers/usb/gadget/f_ncm.c
index a9499fd30792..3639d110703f 100644
--- a/drivers/usb/gadget/f_ncm.c
+++ b/drivers/usb/gadget/f_ncm.c
@@ -57,6 +57,7 @@ struct f_ncm {
 	struct usb_ep			*notify;
 	struct usb_request		*notify_req;
 	u8				notify_state;
+	atomic_t			notify_count;
 	bool				is_open;
=20
 	const struct ndp_parser_opts	*parser_opts;
@@ -460,7 +461,7 @@ static void ncm_do_notify(struct f_ncm *ncm)
 	int				status;
=20
 	/* notification already in flight? */
-	if (!req)
+	if (atomic_read(&ncm->notify_count))
 		return;
=20
 	event =3D req->buf;
@@ -500,7 +501,8 @@ static void ncm_do_notify(struct f_ncm *ncm)
 	event->bmRequestType =3D 0xA1;
 	event->wIndex =3D cpu_to_le16(ncm->ctrl_id);
=20
-	ncm->notify_req =3D NULL;
+	atomic_inc(&ncm->notify_count);
+
 	/*
 	 * In double buffering if there is a space in FIFO,
 	 * completion callback can be called right after the call,
@@ -510,7 +512,7 @@ static void ncm_do_notify(struct f_ncm *ncm)
 	status =3D usb_ep_queue(ncm->notify, req, GFP_ATOMIC);
 	spin_lock(&ncm->lock);
 	if (status < 0) {
-		ncm->notify_req =3D req;
+		atomic_dec(&ncm->notify_count);
 		DBG(cdev, "notify --> %d\n", status);
 	}
 }
@@ -545,17 +547,19 @@ static void ncm_notify_complete(struct usb_ep *ep, st=
ruct usb_request *req)
 	case 0:
 		VDBG(cdev, "Notification %02x sent\n",
 		     event->bNotificationType);
+		atomic_dec(&ncm->notify_count);
 		break;
 	case -ECONNRESET:
 	case -ESHUTDOWN:
+		atomic_set(&ncm->notify_count, 0);
 		ncm->notify_state =3D NCM_NOTIFY_NONE;
 		break;
 	default:
 		DBG(cdev, "event %02x --> %d\n",
 			event->bNotificationType, req->status);
+		atomic_dec(&ncm->notify_count);
 		break;
 	}
-	ncm->notify_req =3D req;
 	ncm_do_notify(ncm);
 	spin_unlock(&ncm->lock);
 }
@@ -1382,6 +1386,11 @@ static void ncm_unbind(struct usb_configuration *c, =
struct usb_function *f)
=20
 	usb_free_all_descriptors(f);
=20
+	if (atomic_read(&ncm->notify_count)) {
+		usb_ep_dequeue(ncm->notify, ncm->notify_req);
+		atomic_set(&ncm->notify_count, 0);
+	}
+
 	kfree(ncm->notify_req->buf);
 	usb_ep_free_request(ncm->notify, ncm->notify_req);
 }
diff --git a/drivers/usb/serial/ir-usb.c b/drivers/usb/serial/ir-usb.c
index f9734a96d516..a3e3b4703f38 100644
--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -49,9 +49,10 @@ static int buffer_size;
 static int xbof =3D -1;
=20
 static int  ir_startup (struct usb_serial *serial);
-static int  ir_open(struct tty_struct *tty, struct usb_serial_port *port);
-static int ir_prepare_write_buffer(struct usb_serial_port *port,
-						void *dest, size_t size);
+static int ir_write(struct tty_struct *tty, struct usb_serial_port *port,
+		const unsigned char *buf, int count);
+static int ir_write_room(struct tty_struct *tty);
+static void ir_write_bulk_callback(struct urb *urb);
 static void ir_process_read_urb(struct urb *urb);
 static void ir_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios);
@@ -81,8 +82,9 @@ static struct usb_serial_driver ir_device =3D {
 	.num_ports		=3D 1,
 	.set_termios		=3D ir_set_termios,
 	.attach			=3D ir_startup,
-	.open			=3D ir_open,
-	.prepare_write_buffer	=3D ir_prepare_write_buffer,
+	.write			=3D ir_write,
+	.write_room		=3D ir_write_room,
+	.write_bulk_callback	=3D ir_write_bulk_callback,
 	.process_read_urb	=3D ir_process_read_urb,
 };
=20
@@ -199,6 +201,9 @@ static int ir_startup(struct usb_serial *serial)
 	struct usb_irda_cs_descriptor *irda_desc;
 	int rates;
=20
+	if (serial->num_bulk_in < 1 || serial->num_bulk_out < 1)
+		return -ENODEV;
+
 	irda_desc =3D irda_usb_find_class_desc(serial, 0);
 	if (!irda_desc) {
 		dev_err(&serial->dev->dev,
@@ -255,35 +260,102 @@ static int ir_startup(struct usb_serial *serial)
 	return 0;
 }
=20
-static int ir_open(struct tty_struct *tty, struct usb_serial_port *port)
+static int ir_write(struct tty_struct *tty, struct usb_serial_port *port,
+		const unsigned char *buf, int count)
 {
-	int i;
+	struct urb *urb =3D NULL;
+	unsigned long flags;
+	int ret;
=20
-	for (i =3D 0; i < ARRAY_SIZE(port->write_urbs); ++i)
-		port->write_urbs[i]->transfer_flags =3D URB_ZERO_PACKET;
+	if (port->bulk_out_size =3D=3D 0)
+		return -EINVAL;
=20
-	/* Start reading from the device */
-	return usb_serial_generic_open(tty, port);
-}
+	if (count =3D=3D 0)
+		return 0;
=20
-static int ir_prepare_write_buffer(struct usb_serial_port *port,
-						void *dest, size_t size)
-{
-	unsigned char *buf =3D dest;
-	int count;
+	count =3D min(count, port->bulk_out_size - 1);
+
+	spin_lock_irqsave(&port->lock, flags);
+	if (__test_and_clear_bit(0, &port->write_urbs_free)) {
+		urb =3D port->write_urbs[0];
+		port->tx_bytes +=3D count;
+	}
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	if (!urb)
+		return 0;
=20
 	/*
 	 * The first byte of the packet we send to the device contains an
-	 * inbound header which indicates an additional number of BOFs and
+	 * outbound header which indicates an additional number of BOFs and
 	 * a baud rate change.
 	 *
 	 * See section 5.4.2.2 of the USB IrDA spec.
 	 */
-	*buf =3D ir_xbof | ir_baud;
+	*(u8 *)urb->transfer_buffer =3D ir_xbof | ir_baud;
+
+	memcpy(urb->transfer_buffer + 1, buf, count);
+
+	urb->transfer_buffer_length =3D count + 1;
+	urb->transfer_flags =3D URB_ZERO_PACKET;
+
+	ret =3D usb_submit_urb(urb, GFP_ATOMIC);
+	if (ret) {
+		dev_err(&port->dev, "failed to submit write urb: %d\n", ret);
+
+		spin_lock_irqsave(&port->lock, flags);
+		__set_bit(0, &port->write_urbs_free);
+		port->tx_bytes -=3D count;
+		spin_unlock_irqrestore(&port->lock, flags);
+
+		return ret;
+	}
+
+	return count;
+}
+
+static void ir_write_bulk_callback(struct urb *urb)
+{
+	struct usb_serial_port *port =3D urb->context;
+	int status =3D urb->status;
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->lock, flags);
+	__set_bit(0, &port->write_urbs_free);
+	port->tx_bytes -=3D urb->transfer_buffer_length - 1;
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	switch (status) {
+	case 0:
+		break;
+	case -ENOENT:
+	case -ECONNRESET:
+	case -ESHUTDOWN:
+		dev_dbg(&port->dev, "write urb stopped: %d\n", status);
+		return;
+	case -EPIPE:
+		dev_err(&port->dev, "write urb stopped: %d\n", status);
+		return;
+	default:
+		dev_err(&port->dev, "nonzero write-urb status: %d\n", status);
+		break;
+	}
+
+	usb_serial_port_softint(port);
+}
+
+static int ir_write_room(struct tty_struct *tty)
+{
+	struct usb_serial_port *port =3D tty->driver_data;
+	int count =3D 0;
+
+	if (port->bulk_out_size =3D=3D 0)
+		return 0;
+
+	if (test_bit(0, &port->write_urbs_free))
+		count =3D port->bulk_out_size - 1;
=20
-	count =3D kfifo_out_locked(&port->write_fifo, buf + 1, size - 1,
-								&port->lock);
-	return count + 1;
+	return count;
 }
=20
 static void ir_process_read_urb(struct urb *urb)
@@ -336,34 +408,34 @@ static void ir_set_termios(struct tty_struct *tty,
=20
 	switch (baud) {
 	case 2400:
-		ir_baud =3D USB_IRDA_BR_2400;
+		ir_baud =3D USB_IRDA_LS_2400;
 		break;
 	case 9600:
-		ir_baud =3D USB_IRDA_BR_9600;
+		ir_baud =3D USB_IRDA_LS_9600;
 		break;
 	case 19200:
-		ir_baud =3D USB_IRDA_BR_19200;
+		ir_baud =3D USB_IRDA_LS_19200;
 		break;
 	case 38400:
-		ir_baud =3D USB_IRDA_BR_38400;
+		ir_baud =3D USB_IRDA_LS_38400;
 		break;
 	case 57600:
-		ir_baud =3D USB_IRDA_BR_57600;
+		ir_baud =3D USB_IRDA_LS_57600;
 		break;
 	case 115200:
-		ir_baud =3D USB_IRDA_BR_115200;
+		ir_baud =3D USB_IRDA_LS_115200;
 		break;
 	case 576000:
-		ir_baud =3D USB_IRDA_BR_576000;
+		ir_baud =3D USB_IRDA_LS_576000;
 		break;
 	case 1152000:
-		ir_baud =3D USB_IRDA_BR_1152000;
+		ir_baud =3D USB_IRDA_LS_1152000;
 		break;
 	case 4000000:
-		ir_baud =3D USB_IRDA_BR_4000000;
+		ir_baud =3D USB_IRDA_LS_4000000;
 		break;
 	default:
-		ir_baud =3D USB_IRDA_BR_9600;
+		ir_baud =3D USB_IRDA_LS_9600;
 		baud =3D 9600;
 	}
=20
diff --git a/drivers/video/fbdev/pxa168fb.c b/drivers/video/fbdev/pxa168fb.c
index c95b9e46d48f..d24018124d11 100644
--- a/drivers/video/fbdev/pxa168fb.c
+++ b/drivers/video/fbdev/pxa168fb.c
@@ -772,8 +772,8 @@ static int pxa168fb_probe(struct platform_device *pdev)
 failed_free_clk:
 	clk_disable(fbi->clk);
 failed_free_fbmem:
-	dma_free_coherent(fbi->dev, info->fix.smem_len,
-			info->screen_base, fbi->fb_start_dma);
+	dma_free_writecombine(fbi->dev, info->fix.smem_len,
+			      info->screen_base, fbi->fb_start_dma);
 failed_free_info:
 	kfree(info);
 failed_put_clk:
@@ -809,7 +809,7 @@ static int pxa168fb_remove(struct platform_device *pdev)
=20
 	irq =3D platform_get_irq(pdev, 0);
=20
-	dma_free_writecombine(fbi->dev, PAGE_ALIGN(info->fix.smem_len),
+	dma_free_writecombine(fbi->dev, info->fix.smem_len,
 				info->screen_base, info->fix.smem_start);
=20
 	clk_disable(fbi->clk);
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 4d1766e5438a..f33fe516667e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -365,12 +365,10 @@ u64 btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_i=
nfo,
 			   struct seq_list *elem)
 {
 	tree_mod_log_write_lock(fs_info);
-	spin_lock(&fs_info->tree_mod_seq_lock);
 	if (!elem->seq) {
 		elem->seq =3D btrfs_inc_tree_mod_seq(fs_info);
 		list_add_tail(&elem->list, &fs_info->tree_mod_seq_list);
 	}
-	spin_unlock(&fs_info->tree_mod_seq_lock);
 	tree_mod_log_write_unlock(fs_info);
=20
 	return elem->seq;
@@ -390,7 +388,7 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_in=
fo,
 	if (!seq_putting)
 		return;
=20
-	spin_lock(&fs_info->tree_mod_seq_lock);
+	tree_mod_log_write_lock(fs_info);
 	list_del(&elem->list);
 	elem->seq =3D 0;
=20
@@ -401,19 +399,17 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_=
info,
 				 * blocker with lower sequence number exists, we
 				 * cannot remove anything from the log
 				 */
-				spin_unlock(&fs_info->tree_mod_seq_lock);
+				tree_mod_log_write_unlock(fs_info);
 				return;
 			}
 			min_seq =3D cur_elem->seq;
 		}
 	}
-	spin_unlock(&fs_info->tree_mod_seq_lock);
=20
 	/*
 	 * anything that's lower than the lowest existing (read: blocked)
 	 * sequence number can be removed from the tree.
 	 */
-	tree_mod_log_write_lock(fs_info);
 	tm_root =3D &fs_info->tree_mod_log;
 	for (node =3D rb_first(tm_root); node; node =3D next) {
 		next =3D rb_next(node);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6bcfc5a98548..fb871710607b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1502,14 +1502,12 @@ struct btrfs_fs_info {
 	spinlock_t delayed_iput_lock;
 	struct list_head delayed_iputs;
=20
-	/* this protects tree_mod_seq_list */
-	spinlock_t tree_mod_seq_lock;
 	atomic64_t tree_mod_seq;
-	struct list_head tree_mod_seq_list;
=20
-	/* this protects tree_mod_log */
+	/* this protects tree_mod_log and tree_mod_seq_list */
 	rwlock_t tree_mod_log_lock;
 	struct rb_root tree_mod_log;
+	struct list_head tree_mod_seq_list;
=20
 	atomic_t nr_async_submits;
 	atomic_t async_submit_draining;
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 6d16bea94e1c..27e5683167f2 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -344,7 +344,7 @@ void btrfs_merge_delayed_refs(struct btrfs_trans_handle=
 *trans,
 	if (head->is_data)
 		return;
=20
-	spin_lock(&fs_info->tree_mod_seq_lock);
+	read_lock(&fs_info->tree_mod_log_lock);
 	if (!list_empty(&fs_info->tree_mod_seq_list)) {
 		struct seq_list *elem;
=20
@@ -352,7 +352,7 @@ void btrfs_merge_delayed_refs(struct btrfs_trans_handle=
 *trans,
 					struct seq_list, list);
 		seq =3D elem->seq;
 	}
-	spin_unlock(&fs_info->tree_mod_seq_lock);
+	read_unlock(&fs_info->tree_mod_log_lock);
=20
 	node =3D rb_first(&head->ref_root);
 	while (node) {
@@ -377,7 +377,7 @@ int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_in=
fo,
 	struct seq_list *elem;
 	int ret =3D 0;
=20
-	spin_lock(&fs_info->tree_mod_seq_lock);
+	read_lock(&fs_info->tree_mod_log_lock);
 	if (!list_empty(&fs_info->tree_mod_seq_list)) {
 		elem =3D list_first_entry(&fs_info->tree_mod_seq_list,
 					struct seq_list, list);
@@ -390,7 +390,7 @@ int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_in=
fo,
 		}
 	}
=20
-	spin_unlock(&fs_info->tree_mod_seq_lock);
+	read_unlock(&fs_info->tree_mod_log_lock);
 	return ret;
 }
=20
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c3669e689db8..c9c57d98a89b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2167,7 +2167,6 @@ int open_ctree(struct super_block *sb,
 	spin_lock_init(&fs_info->delayed_iput_lock);
 	spin_lock_init(&fs_info->defrag_inodes_lock);
 	spin_lock_init(&fs_info->free_chunk_lock);
-	spin_lock_init(&fs_info->tree_mod_seq_lock);
 	spin_lock_init(&fs_info->super_lock);
 	spin_lock_init(&fs_info->qgroup_op_lock);
 	spin_lock_init(&fs_info->buffer_lock);
diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index 9626252ee6b4..69255148f0c8 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -109,7 +109,6 @@ struct btrfs_fs_info *btrfs_alloc_dummy_fs_info(void)
 	spin_lock_init(&fs_info->qgroup_op_lock);
 	spin_lock_init(&fs_info->super_lock);
 	spin_lock_init(&fs_info->fs_roots_radix_lock);
-	spin_lock_init(&fs_info->tree_mod_seq_lock);
 	mutex_init(&fs_info->qgroup_ioctl_lock);
 	mutex_init(&fs_info->qgroup_rescan_lock);
 	rwlock_init(&fs_info->tree_mod_log_lock);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2882ebeff95b..51481fa96283 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1252,6 +1252,7 @@ struct mid_q_entry {
 	mid_receive_t *receive; /* call receive callback */
 	mid_callback_t *callback; /* call completion callback */
 	void *callback_data;	  /* general purpose pointer for callback */
+	struct task_struct *creator;
 	void *resp_buf;		/* pointer to received SMB header */
 	int mid_state;	/* wish this were enum but can not pass to wait_event */
 	unsigned int mid_flags;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index ac1dd5564896..753de57ad877 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -250,9 +250,14 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *=
tcon)
 	 */
 	mutex_lock(&tcon->ses->session_mutex);
 	rc =3D cifs_negotiate_protocol(0, tcon->ses);
-	if (!rc && tcon->ses->need_reconnect)
+	if (!rc && tcon->ses->need_reconnect) {
 		rc =3D cifs_setup_session(0, tcon->ses, nls_codepage);
-
+		if ((rc =3D=3D -EACCES) && !tcon->retry) {
+			rc =3D -EHOSTDOWN;
+			mutex_unlock(&tcon->ses->session_mutex);
+			goto failed;
+		}
+	}
 	if (rc || !tcon->need_reconnect) {
 		mutex_unlock(&tcon->ses->session_mutex);
 		goto out;
@@ -290,6 +295,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *t=
con)
 	case SMB2_SET_INFO:
 		rc =3D -EAGAIN;
 	}
+failed:
 	unload_nls(nls_codepage);
 	return rc;
 }
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 3fb9be656ce6..5a45ca01d082 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -542,6 +542,8 @@ smb2_mid_entry_alloc(const struct smb2_hdr *smb_buffer,
 		 * The default is for the mid to be synchronous, so the
 		 * default callback just wakes up the current task.
 		 */
+		get_task_struct(current);
+		temp->creator =3D current;
 		temp->callback =3D cifs_wake_up_task;
 		temp->callback_data =3D current;
 	}
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 503e7b2eda8c..4adf54163c33 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -72,6 +72,8 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct T=
CP_Server_Info *server)
 		 * The default is for the mid to be synchronous, so the
 		 * default callback just wakes up the current task.
 		 */
+		get_task_struct(current);
+		temp->creator =3D current;
 		temp->callback =3D cifs_wake_up_task;
 		temp->callback_data =3D current;
 	}
@@ -86,6 +88,8 @@ static void _cifs_mid_q_entry_release(struct kref *refcou=
nt)
 	struct mid_q_entry *mid =3D container_of(refcount, struct mid_q_entry,
 					       refcount);
=20
+	put_task_struct(mid->creator);
+
 	mempool_free(mid, cifs_mid_poolp);
 }
=20
diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index d4c7e470dec8..7c3244cafd43 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -173,7 +173,7 @@ void __jbd2_log_wait_for_space(journal_t *journal)
 				       "journal space in %s\n", __func__,
 				       journal->j_devname);
 				WARN_ON(1);
-				jbd2_journal_abort(journal, 0);
+				jbd2_journal_abort(journal, -EIO);
 			}
 			write_lock(&journal->j_state_lock);
 		} else {
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 362e5f614450..943a575a8704 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -802,7 +802,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		err =3D journal_submit_commit_record(journal, commit_transaction,
 						 &cbh, crc32_sum);
 		if (err)
-			__jbd2_journal_abort_hard(journal);
+			jbd2_journal_abort(journal, err);
 	}
=20
 	blk_finish_plug(&plug);
@@ -894,7 +894,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		err =3D journal_submit_commit_record(journal, commit_transaction,
 						&cbh, crc32_sum);
 		if (err)
-			__jbd2_journal_abort_hard(journal);
+			jbd2_journal_abort(journal, err);
 	}
 	if (cbh)
 		err =3D journal_wait_on_commit_record(journal, cbh);
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 59c56e6c41bb..633e94f1a41f 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1674,6 +1674,11 @@ int jbd2_journal_load(journal_t *journal)
 		       journal->j_devname);
 		return -EIO;
 	}
+	/*
+	 * clear JBD2_ABORT flag initialized in journal_init_common
+	 * here to update log tail information with the newest seq.
+	 */
+	journal->j_flags &=3D ~JBD2_ABORT;
=20
 	/* OK, we've finished with the dynamic journal bits:
 	 * reinitialise the dynamic contents of the superblock in memory
@@ -1681,7 +1686,6 @@ int jbd2_journal_load(journal_t *journal)
 	if (journal_reset(journal))
 		goto recovery_error;
=20
-	journal->j_flags &=3D ~JBD2_ABORT;
 	journal->j_flags |=3D JBD2_LOADED;
 	return 0;
=20
@@ -2102,12 +2106,10 @@ static void __journal_abort_soft (journal_t *journa=
l, int errno)
=20
 	__jbd2_journal_abort_hard(journal);
=20
-	if (errno) {
-		jbd2_journal_update_sb_errno(journal);
-		write_lock(&journal->j_state_lock);
-		journal->j_flags |=3D JBD2_REC_ERR;
-		write_unlock(&journal->j_state_lock);
-	}
+	jbd2_journal_update_sb_errno(journal);
+	write_lock(&journal->j_state_lock);
+	journal->j_flags |=3D JBD2_REC_ERR;
+	write_unlock(&journal->j_state_lock);
 }
=20
 /**
@@ -2149,11 +2151,6 @@ static void __journal_abort_soft (journal_t *journal=
, int errno)
  * failure to disk.  ext3_error, for example, now uses this
  * functionality.
  *
- * Errors which originate from within the journaling layer will NOT
- * supply an errno; a null errno implies that absolutely no further
- * writes are done to the journal (unless there are any already in
- * progress).
- *
  */
=20
 void jbd2_journal_abort(journal_t *journal, int errno)
diff --git a/fs/namespace.c b/fs/namespace.c
index 5acf789efbab..8c41f38617db 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2937,8 +2937,8 @@ SYSCALL_DEFINE2(pivot_root, const char __user *, new_=
root,
 	/* make certain new is below the root */
 	if (!is_path_reachable(new_mnt, new.dentry, &root))
 		goto out4;
-	root_mp->m_count++; /* pin it so it won't go away */
 	lock_mount_hash();
+	root_mp->m_count++; /* pin it so it won't go away */
 	detach_mnt(new_mnt, &parent_path);
 	detach_mnt(root_mnt, &root_parent);
 	if (root_mnt->mnt.mnt_flags & MNT_LOCKED) {
diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
index 3dece03f2fc8..44c5e3a35cea 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -89,7 +89,7 @@ config NFS_V4
 config NFS_SWAP
 	bool "Provide swap over NFS support"
 	default n
-	depends on NFS_FS
+	depends on NFS_FS && SWAP
 	select SUNRPC_SWAP
 	help
 	  This option enables swapon to work on files located on NFS mounts.
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 5cbdbb6aedde..94215aac7155 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -169,25 +169,15 @@ typedef struct {
 	unsigned int	eof:1;
 } nfs_readdir_descriptor_t;
=20
-/*
- * The caller is responsible for calling nfs_readdir_release_array(page)
- */
 static
-struct nfs_cache_array *nfs_readdir_get_array(struct page *page)
+void nfs_readdir_init_array(struct page *page)
 {
-	void *ptr;
-	if (page =3D=3D NULL)
-		return ERR_PTR(-EIO);
-	ptr =3D kmap(page);
-	if (ptr =3D=3D NULL)
-		return ERR_PTR(-ENOMEM);
-	return ptr;
-}
+	struct nfs_cache_array *array;
=20
-static
-void nfs_readdir_release_array(struct page *page)
-{
-	kunmap(page);
+	array =3D kmap_atomic(page);
+	memset(array, 0, sizeof(struct nfs_cache_array));
+	array->eof_index =3D -1;
+	kunmap_atomic(array);
 }
=20
 /*
@@ -202,6 +192,7 @@ void nfs_readdir_clear_array(struct page *page)
 	array =3D kmap_atomic(page);
 	for (i =3D 0; i < array->size; i++)
 		kfree(array->array[i].string.name);
+	array->size =3D 0;
 	kunmap_atomic(array);
 }
=20
@@ -229,13 +220,10 @@ int nfs_readdir_make_qstr(struct qstr *string, const =
char *name, unsigned int le
 static
 int nfs_readdir_add_to_array(struct nfs_entry *entry, struct page *page)
 {
-	struct nfs_cache_array *array =3D nfs_readdir_get_array(page);
+	struct nfs_cache_array *array =3D kmap(page);
 	struct nfs_cache_array_entry *cache_entry;
 	int ret;
=20
-	if (IS_ERR(array))
-		return PTR_ERR(array);
-
 	cache_entry =3D &array->array[array->size];
=20
 	/* Check that this entry lies within the page bounds */
@@ -254,7 +242,7 @@ int nfs_readdir_add_to_array(struct nfs_entry *entry, s=
truct page *page)
 	if (entry->eof !=3D 0)
 		array->eof_index =3D array->size;
 out:
-	nfs_readdir_release_array(page);
+	kunmap(page);
 	return ret;
 }
=20
@@ -343,11 +331,7 @@ int nfs_readdir_search_array(nfs_readdir_descriptor_t =
*desc)
 	struct nfs_cache_array *array;
 	int status;
=20
-	array =3D nfs_readdir_get_array(desc->page);
-	if (IS_ERR(array)) {
-		status =3D PTR_ERR(array);
-		goto out;
-	}
+	array =3D kmap(desc->page);
=20
 	if (*desc->dir_cookie =3D=3D 0)
 		status =3D nfs_readdir_search_for_pos(array, desc);
@@ -359,8 +343,7 @@ int nfs_readdir_search_array(nfs_readdir_descriptor_t *=
desc)
 		desc->current_index +=3D array->size;
 		desc->page_index++;
 	}
-	nfs_readdir_release_array(desc->page);
-out:
+	kunmap(desc->page);
 	return status;
 }
=20
@@ -551,13 +534,10 @@ int nfs_readdir_page_filler(nfs_readdir_descriptor_t =
*desc, struct nfs_entry *en
 	} while (!entry->eof);
=20
 	if (count =3D=3D 0 || (status =3D=3D -EBADCOOKIE && entry->eof !=3D 0)) {
-		array =3D nfs_readdir_get_array(page);
-		if (!IS_ERR(array)) {
-			array->eof_index =3D array->size;
-			status =3D 0;
-			nfs_readdir_release_array(page);
-		} else
-			status =3D PTR_ERR(array);
+		array =3D kmap(page);
+		array->eof_index =3D array->size;
+		status =3D 0;
+		kunmap(page);
 	}
=20
 	put_page(scratch);
@@ -612,6 +592,8 @@ int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *=
desc, struct page *page,
 	int status =3D -ENOMEM;
 	unsigned int array_size =3D ARRAY_SIZE(pages);
=20
+	nfs_readdir_init_array(page);
+
 	entry.prev_cookie =3D 0;
 	entry.cookie =3D desc->last_cookie;
 	entry.eof =3D 0;
@@ -627,13 +609,7 @@ int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t =
*desc, struct page *page,
 		goto out;
 	}
=20
-	array =3D nfs_readdir_get_array(page);
-	if (IS_ERR(array)) {
-		status =3D PTR_ERR(array);
-		goto out_label_free;
-	}
-	memset(array, 0, sizeof(struct nfs_cache_array));
-	array->eof_index =3D -1;
+	array =3D kmap(page);
=20
 	status =3D nfs_readdir_large_page(pages, array_size);
 	if (status < 0)
@@ -655,8 +631,7 @@ int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *=
desc, struct page *page,
=20
 	nfs_readdir_free_large_page(pages_ptr, pages, array_size);
 out_release_array:
-	nfs_readdir_release_array(page);
-out_label_free:
+	kunmap(page);
 	nfs4_label_free(entry.label);
 out:
 	nfs_free_fattr(entry.fattr);
@@ -688,6 +663,7 @@ int nfs_readdir_filler(nfs_readdir_descriptor_t *desc, =
struct page* page)
 	unlock_page(page);
 	return 0;
  error:
+	nfs_readdir_clear_array(page);
 	unlock_page(page);
 	return ret;
 }
@@ -695,8 +671,6 @@ int nfs_readdir_filler(nfs_readdir_descriptor_t *desc, =
struct page* page)
 static
 void cache_page_release(nfs_readdir_descriptor_t *desc)
 {
-	if (!desc->page->mapping)
-		nfs_readdir_clear_array(desc->page);
 	page_cache_release(desc->page);
 	desc->page =3D NULL;
 }
@@ -710,19 +684,28 @@ struct page *get_cache_page(nfs_readdir_descriptor_t =
*desc)
=20
 /*
  * Returns 0 if desc->dir_cookie was found on page desc->page_index
+ * and locks the page to prevent removal from the page cache.
  */
 static
-int find_cache_page(nfs_readdir_descriptor_t *desc)
+int find_and_lock_cache_page(nfs_readdir_descriptor_t *desc)
 {
 	int res;
=20
 	desc->page =3D get_cache_page(desc);
 	if (IS_ERR(desc->page))
 		return PTR_ERR(desc->page);
-
-	res =3D nfs_readdir_search_array(desc);
+	res =3D lock_page_killable(desc->page);
 	if (res !=3D 0)
-		cache_page_release(desc);
+		goto error;
+	res =3D -EAGAIN;
+	if (desc->page->mapping !=3D NULL) {
+		res =3D nfs_readdir_search_array(desc);
+		if (res =3D=3D 0)
+			return 0;
+	}
+	unlock_page(desc->page);
+error:
+	cache_page_release(desc);
 	return res;
 }
=20
@@ -737,7 +720,7 @@ int readdir_search_pagecache(nfs_readdir_descriptor_t *=
desc)
 		desc->last_cookie =3D 0;
 	}
 	do {
-		res =3D find_cache_page(desc);
+		res =3D find_and_lock_cache_page(desc);
 	} while (res =3D=3D -EAGAIN);
 	return res;
 }
@@ -754,12 +737,7 @@ int nfs_do_filldir(nfs_readdir_descriptor_t *desc)
 	struct nfs_cache_array *array =3D NULL;
 	struct nfs_open_dir_context *ctx =3D file->private_data;
=20
-	array =3D nfs_readdir_get_array(desc->page);
-	if (IS_ERR(array)) {
-		res =3D PTR_ERR(array);
-		goto out;
-	}
-
+	array =3D kmap(desc->page);
 	for (i =3D desc->cache_entry_index; i < array->size; i++) {
 		struct nfs_cache_array_entry *ent;
=20
@@ -780,9 +758,7 @@ int nfs_do_filldir(nfs_readdir_descriptor_t *desc)
 	if (array->eof_index >=3D 0)
 		desc->eof =3D 1;
=20
-	nfs_readdir_release_array(desc->page);
-out:
-	cache_page_release(desc);
+	kunmap(desc->page);
 	dfprintk(DIRCACHE, "NFS: nfs_do_filldir() filling ended @ cookie %Lu; ret=
urning =3D %d\n",
 			(unsigned long long)*desc->dir_cookie, res);
 	return res;
@@ -828,13 +804,13 @@ int uncached_readdir(nfs_readdir_descriptor_t *desc)
=20
 	status =3D nfs_do_filldir(desc);
=20
+ out_release:
+	nfs_readdir_clear_array(desc->page);
+	cache_page_release(desc);
  out:
 	dfprintk(DIRCACHE, "NFS: %s: returns %d\n",
 			__func__, status);
 	return status;
- out_release:
-	cache_page_release(desc);
-	goto out;
 }
=20
 /* The file offset position represents the dirent entry number.  A
@@ -900,6 +876,8 @@ static int nfs_readdir(struct file *file, struct dir_co=
ntext *ctx)
 			break;
=20
 		res =3D nfs_do_filldir(desc);
+		unlock_page(desc->page);
+		cache_page_release(desc);
 		if (res < 0)
 			break;
 	} while (!desc->eof);
diff --git a/fs/pnode.c b/fs/pnode.c
index 52e7506782cb..3f6281239a36 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -249,14 +249,13 @@ static int propagate_one(struct mount *m)
 	child =3D copy_tree(last_source, last_source->mnt.mnt_root, type);
 	if (IS_ERR(child))
 		return PTR_ERR(child);
+	read_seqlock_excl(&mount_lock);
 	mnt_set_mountpoint(m, mp, child);
+	if (m->mnt_master !=3D dest_master)
+		SET_MNT_MARK(m->mnt_master);
+	read_sequnlock_excl(&mount_lock);
 	last_dest =3D m;
 	last_source =3D child;
-	if (m->mnt_master !=3D dest_master) {
-		read_seqlock_excl(&mount_lock);
-		SET_MNT_MARK(m->mnt_master);
-		read_sequnlock_excl(&mount_lock);
-	}
 	hlist_add_head(&child->mnt_hash, list);
 	return count_mounts(m->mnt_ns, child);
 }
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 7daf9e503f80..ffb7612e709b 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -589,6 +589,7 @@ static void reiserfs_put_super(struct super_block *s)
 	reiserfs_write_unlock(s);
 	mutex_destroy(&REISERFS_SB(s)->lock);
 	destroy_workqueue(REISERFS_SB(s)->commit_wq);
+	kfree(REISERFS_SB(s)->s_jdev);
 	kfree(s->s_fs_info);
 	s->s_fs_info =3D NULL;
 }
@@ -1900,7 +1901,7 @@ static int reiserfs_fill_super(struct super_block *s,=
 void *data, int silent)
 		if (!sbi->s_jdev) {
 			SWARN(silent, s, "", "Cannot allocate memory for "
 				"journal device name");
-			goto error;
+			goto error_unlocked;
 		}
 	}
 #ifdef CONFIG_QUOTA
@@ -2188,6 +2189,7 @@ static int reiserfs_fill_super(struct super_block *s,=
 void *data, int silent)
 			kfree(qf_names[j]);
 	}
 #endif
+	kfree(sbi->s_jdev);
 	kfree(sbi);
=20
 	s->s_fs_info =3D NULL;
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index fdf6d28c4839..8c0202739ece 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -782,8 +782,9 @@ static int ubifs_do_bulk_read(struct ubifs_info *c, str=
uct bu_info *bu,
=20
 		if (page_offset > end_index)
 			break;
-		page =3D find_or_create_page(mapping, page_offset,
-					   GFP_NOFS | __GFP_COLD);
+		page =3D pagecache_get_page(mapping, page_offset,
+				 FGP_LOCK|FGP_ACCESSED|FGP_CREAT|FGP_NOWAIT,
+				 GFP_NOFS | __GFP_COLD);
 		if (!page)
 			break;
 		if (!PageUptodate(page))
diff --git a/include/linux/padata.h b/include/linux/padata.h
index 438694650471..547a8d1e4a3b 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -24,7 +24,6 @@
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
-#include <linux/timer.h>
 #include <linux/notifier.h>
 #include <linux/kobject.h>
=20
@@ -37,6 +36,7 @@
  * @list: List entry, to attach to the padata lists.
  * @pd: Pointer to the internal control structure.
  * @cb_cpu: Callback cpu for serializatioon.
+ * @cpu: Cpu for parallelization.
  * @seq_nr: Sequence number of the parallelized data object.
  * @info: Used to pass information from the parallel to the serial functio=
n.
  * @parallel: Parallel execution function.
@@ -46,6 +46,7 @@ struct padata_priv {
 	struct list_head	list;
 	struct parallel_data	*pd;
 	int			cb_cpu;
+	int			cpu;
 	int			info;
 	void                    (*parallel)(struct padata_priv *padata);
 	void                    (*serial)(struct padata_priv *padata);
@@ -83,7 +84,6 @@ struct padata_serial_queue {
  * @serial: List to wait for serialization after reordering.
  * @pwork: work struct for parallelization.
  * @swork: work struct for serialization.
- * @pd: Backpointer to the internal control structure.
  * @work: work struct for parallelization.
  * @num_obj: Number of objects that are processed by this cpu.
  * @cpu_index: Index of the cpu.
@@ -91,7 +91,6 @@ struct padata_serial_queue {
 struct padata_parallel_queue {
        struct padata_list    parallel;
        struct padata_list    reorder;
-       struct parallel_data *pd;
        struct work_struct    work;
        atomic_t              num_obj;
        int                   cpu_index;
@@ -118,10 +117,10 @@ struct padata_cpumask {
  * @reorder_objects: Number of objects waiting in the reorder queues.
  * @refcnt: Number of objects holding a reference on this parallel_data.
  * @max_seq_nr:  Maximal used sequence number.
+ * @cpu: Next CPU to be processed.
  * @cpumask: The cpumasks in use for parallel and serial workers.
+ * @reorder_work: work struct for reordering.
  * @lock: Reorder lock.
- * @processed: Number of already processed objects.
- * @timer: Reorder timer.
  */
 struct parallel_data {
 	struct padata_instance		*pinst;
@@ -130,10 +129,10 @@ struct parallel_data {
 	atomic_t			reorder_objects;
 	atomic_t			refcnt;
 	atomic_t			seq_nr;
+	int				cpu;
 	struct padata_cpumask		cpumask;
+	struct work_struct		reorder_work;
 	spinlock_t                      lock ____cacheline_aligned;
-	unsigned int			processed;
-	struct timer_list		timer;
 };
=20
 /**
diff --git a/include/linux/usb/irda.h b/include/linux/usb/irda.h
index e345ceaf72d6..9dc46010a067 100644
--- a/include/linux/usb/irda.h
+++ b/include/linux/usb/irda.h
@@ -118,11 +118,22 @@ struct usb_irda_cs_descriptor {
  * 6 - 115200 bps
  * 7 - 576000 bps
  * 8 - 1.152 Mbps
- * 9 - 5 mbps
+ * 9 - 4 Mbps
  * 10..15 - Reserved
  */
 #define USB_IRDA_STATUS_LINK_SPEED	0x0f
=20
+#define USB_IRDA_LS_NO_CHANGE		0
+#define USB_IRDA_LS_2400		1
+#define USB_IRDA_LS_9600		2
+#define USB_IRDA_LS_19200		3
+#define USB_IRDA_LS_38400		4
+#define USB_IRDA_LS_57600		5
+#define USB_IRDA_LS_115200		6
+#define USB_IRDA_LS_576000		7
+#define USB_IRDA_LS_1152000		8
+#define USB_IRDA_LS_4000000		9
+
 /* The following is a 4-bit value used only for
  * outbound header:
  *
diff --git a/kernel/padata.c b/kernel/padata.c
index 9978b5712fce..3dbd6d470218 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -33,6 +33,8 @@
=20
 #define MAX_OBJ_NUM 1000
=20
+static void padata_free_pd(struct parallel_data *pd);
+
 static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
 {
 	int cpu, target_cpu;
@@ -63,15 +65,11 @@ static int padata_cpu_hash(struct parallel_data *pd)
 static void padata_parallel_worker(struct work_struct *parallel_work)
 {
 	struct padata_parallel_queue *pqueue;
-	struct parallel_data *pd;
-	struct padata_instance *pinst;
 	LIST_HEAD(local_list);
=20
 	local_bh_disable();
 	pqueue =3D container_of(parallel_work,
 			      struct padata_parallel_queue, work);
-	pd =3D pqueue->pd;
-	pinst =3D pd->pinst;
=20
 	spin_lock(&pqueue->parallel.lock);
 	list_replace_init(&pqueue->parallel.list, &local_list);
@@ -134,6 +132,7 @@ int padata_do_parallel(struct padata_instance *pinst,
 	padata->cb_cpu =3D cb_cpu;
=20
 	target_cpu =3D padata_cpu_hash(pd);
+	padata->cpu =3D target_cpu;
 	queue =3D per_cpu_ptr(pd->pqueue, target_cpu);
=20
 	spin_lock(&queue->parallel.lock);
@@ -157,8 +156,6 @@ EXPORT_SYMBOL(padata_do_parallel);
  * A pointer to the control struct of the next object that needs
  * serialization, if present in one of the percpu reorder queues.
  *
- * NULL, if all percpu reorder queues are empty.
- *
  * -EINPROGRESS, if the next object that needs serialization will
  *  be parallel processed by another cpu and is not yet present in
  *  the cpu's reorder queue.
@@ -168,40 +165,29 @@ EXPORT_SYMBOL(padata_do_parallel);
  */
 static struct padata_priv *padata_get_next(struct parallel_data *pd)
 {
-	int cpu, num_cpus;
-	unsigned int next_nr, next_index;
 	struct padata_parallel_queue *next_queue;
 	struct padata_priv *padata;
 	struct padata_list *reorder;
+	int cpu =3D pd->cpu;
=20
-	num_cpus =3D cpumask_weight(pd->cpumask.pcpu);
-
-	/*
-	 * Calculate the percpu reorder queue and the sequence
-	 * number of the next object.
-	 */
-	next_nr =3D pd->processed;
-	next_index =3D next_nr % num_cpus;
-	cpu =3D padata_index_to_cpu(pd, next_index);
 	next_queue =3D per_cpu_ptr(pd->pqueue, cpu);
-
-	padata =3D NULL;
-
 	reorder =3D &next_queue->reorder;
=20
+	spin_lock(&reorder->lock);
 	if (!list_empty(&reorder->list)) {
 		padata =3D list_entry(reorder->list.next,
 				    struct padata_priv, list);
=20
-		spin_lock(&reorder->lock);
 		list_del_init(&padata->list);
 		atomic_dec(&pd->reorder_objects);
-		spin_unlock(&reorder->lock);
=20
-		pd->processed++;
+		pd->cpu =3D cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1,
+					    false);
=20
+		spin_unlock(&reorder->lock);
 		goto out;
 	}
+	spin_unlock(&reorder->lock);
=20
 	if (__this_cpu_read(pd->pqueue->cpu_index) =3D=3D next_queue->cpu_index) {
 		padata =3D ERR_PTR(-ENODATA);
@@ -219,6 +205,7 @@ static void padata_reorder(struct parallel_data *pd)
 	struct padata_priv *padata;
 	struct padata_serial_queue *squeue;
 	struct padata_instance *pinst =3D pd->pinst;
+	struct padata_parallel_queue *next_queue;
=20
 	/*
 	 * We need to ensure that only one cpu can work on dequeueing of
@@ -237,12 +224,11 @@ static void padata_reorder(struct parallel_data *pd)
 		padata =3D padata_get_next(pd);
=20
 		/*
-		 * All reorder queues are empty, or the next object that needs
-		 * serialization is parallel processed by another cpu and is
-		 * still on it's way to the cpu's reorder queue, nothing to
-		 * do for now.
+		 * If the next object that needs serialization is parallel
+		 * processed by another cpu and is still on it's way to the
+		 * cpu's reorder queue, nothing to do for now.
 		 */
-		if (!padata || PTR_ERR(padata) =3D=3D -EINPROGRESS)
+		if (PTR_ERR(padata) =3D=3D -EINPROGRESS)
 			break;
=20
 		/*
@@ -251,7 +237,6 @@ static void padata_reorder(struct parallel_data *pd)
 		 * so exit immediately.
 		 */
 		if (PTR_ERR(padata) =3D=3D -ENODATA) {
-			del_timer(&pd->timer);
 			spin_unlock_bh(&pd->lock);
 			return;
 		}
@@ -270,28 +255,27 @@ static void padata_reorder(struct parallel_data *pd)
=20
 	/*
 	 * The next object that needs serialization might have arrived to
-	 * the reorder queues in the meantime, we will be called again
-	 * from the timer function if no one else cares for it.
+	 * the reorder queues in the meantime.
 	 *
-	 * Ensure reorder_objects is read after pd->lock is dropped so we see
-	 * an increment from another task in padata_do_serial.  Pairs with
+	 * Ensure reorder queue is read after pd->lock is dropped so we see
+	 * new objects from another task in padata_do_serial.  Pairs with
 	 * smp_mb__after_atomic in padata_do_serial.
 	 */
 	smp_mb();
-	if (atomic_read(&pd->reorder_objects)
-			&& !(pinst->flags & PADATA_RESET))
-		mod_timer(&pd->timer, jiffies + HZ);
-	else
-		del_timer(&pd->timer);
=20
-	return;
+	next_queue =3D per_cpu_ptr(pd->pqueue, pd->cpu);
+	if (!list_empty(&next_queue->reorder.list))
+		queue_work(pinst->wq, &pd->reorder_work);
 }
=20
-static void padata_reorder_timer(unsigned long arg)
+static void invoke_padata_reorder(struct work_struct *work)
 {
-	struct parallel_data *pd =3D (struct parallel_data *)arg;
+	struct parallel_data *pd;
=20
+	local_bh_disable();
+	pd =3D container_of(work, struct parallel_data, reorder_work);
 	padata_reorder(pd);
+	local_bh_enable();
 }
=20
 static void padata_serial_worker(struct work_struct *serial_work)
@@ -299,6 +283,7 @@ static void padata_serial_worker(struct work_struct *se=
rial_work)
 	struct padata_serial_queue *squeue;
 	struct parallel_data *pd;
 	LIST_HEAD(local_list);
+	int cnt;
=20
 	local_bh_disable();
 	squeue =3D container_of(serial_work, struct padata_serial_queue, work);
@@ -308,6 +293,8 @@ static void padata_serial_worker(struct work_struct *se=
rial_work)
 	list_replace_init(&squeue->serial.list, &local_list);
 	spin_unlock(&squeue->serial.lock);
=20
+	cnt =3D 0;
+
 	while (!list_empty(&local_list)) {
 		struct padata_priv *padata;
=20
@@ -317,9 +304,12 @@ static void padata_serial_worker(struct work_struct *s=
erial_work)
 		list_del_init(&padata->list);
=20
 		padata->serial(padata);
-		atomic_dec(&pd->refcnt);
+		cnt++;
 	}
 	local_bh_enable();
+
+	if (atomic_sub_and_test(cnt, &pd->refcnt))
+		padata_free_pd(pd);
 }
=20
 /**
@@ -332,29 +322,22 @@ static void padata_serial_worker(struct work_struct *=
serial_work)
  */
 void padata_do_serial(struct padata_priv *padata)
 {
-	int cpu;
-	struct padata_parallel_queue *pqueue;
-	struct parallel_data *pd;
-
-	pd =3D padata->pd;
-
-	cpu =3D get_cpu();
-	pqueue =3D per_cpu_ptr(pd->pqueue, cpu);
+	struct parallel_data *pd =3D padata->pd;
+	struct padata_parallel_queue *pqueue =3D per_cpu_ptr(pd->pqueue,
+							   padata->cpu);
=20
 	spin_lock(&pqueue->reorder.lock);
-	atomic_inc(&pd->reorder_objects);
 	list_add_tail(&padata->list, &pqueue->reorder.list);
+	atomic_inc(&pd->reorder_objects);
 	spin_unlock(&pqueue->reorder.lock);
=20
 	/*
-	 * Ensure the atomic_inc of reorder_objects above is ordered correctly
+	 * Ensure the addition to the reorder list is ordered correctly
 	 * with the trylock of pd->lock in padata_reorder.  Pairs with smp_mb
 	 * in padata_reorder.
 	 */
 	smp_mb__after_atomic();
=20
-	put_cpu();
-
 	padata_reorder(pd);
 }
 EXPORT_SYMBOL(padata_do_serial);
@@ -403,9 +386,14 @@ static void padata_init_pqueues(struct parallel_data *=
pd)
 	struct padata_parallel_queue *pqueue;
=20
 	cpu_index =3D 0;
-	for_each_cpu(cpu, pd->cpumask.pcpu) {
+	for_each_possible_cpu(cpu) {
 		pqueue =3D per_cpu_ptr(pd->pqueue, cpu);
-		pqueue->pd =3D pd;
+
+		if (!cpumask_test_cpu(cpu, pd->cpumask.pcpu)) {
+			pqueue->cpu_index =3D -1;
+			continue;
+		}
+
 		pqueue->cpu_index =3D cpu_index;
 		cpu_index++;
=20
@@ -439,12 +427,13 @@ static struct parallel_data *padata_alloc_pd(struct p=
adata_instance *pinst,
=20
 	padata_init_pqueues(pd);
 	padata_init_squeues(pd);
-	setup_timer(&pd->timer, padata_reorder_timer, (unsigned long)pd);
 	atomic_set(&pd->seq_nr, -1);
 	atomic_set(&pd->reorder_objects, 0);
-	atomic_set(&pd->refcnt, 0);
+	atomic_set(&pd->refcnt, 1);
 	pd->pinst =3D pinst;
 	spin_lock_init(&pd->lock);
+	pd->cpu =3D cpumask_first(pd->cpumask.pcpu);
+	INIT_WORK(&pd->reorder_work, invoke_padata_reorder);
=20
 	return pd;
=20
@@ -467,31 +456,6 @@ static void padata_free_pd(struct parallel_data *pd)
 	kfree(pd);
 }
=20
-/* Flush all objects out of the padata queues. */
-static void padata_flush_queues(struct parallel_data *pd)
-{
-	int cpu;
-	struct padata_parallel_queue *pqueue;
-	struct padata_serial_queue *squeue;
-
-	for_each_cpu(cpu, pd->cpumask.pcpu) {
-		pqueue =3D per_cpu_ptr(pd->pqueue, cpu);
-		flush_work(&pqueue->work);
-	}
-
-	del_timer_sync(&pd->timer);
-
-	if (atomic_read(&pd->reorder_objects))
-		padata_reorder(pd);
-
-	for_each_cpu(cpu, pd->cpumask.cbcpu) {
-		squeue =3D per_cpu_ptr(pd->squeue, cpu);
-		flush_work(&squeue->work);
-	}
-
-	BUG_ON(atomic_read(&pd->refcnt) !=3D 0);
-}
-
 static void __padata_start(struct padata_instance *pinst)
 {
 	pinst->flags |=3D PADATA_INIT;
@@ -505,10 +469,6 @@ static void __padata_stop(struct padata_instance *pins=
t)
 	pinst->flags &=3D ~PADATA_INIT;
=20
 	synchronize_rcu();
-
-	get_online_cpus();
-	padata_flush_queues(pinst->pd);
-	put_online_cpus();
 }
=20
 /* Replace the internal control structure with a new one. */
@@ -529,8 +489,8 @@ static void padata_replace(struct padata_instance *pins=
t,
 	if (!cpumask_equal(pd_old->cpumask.cbcpu, pd_new->cpumask.cbcpu))
 		notification_mask |=3D PADATA_CPU_SERIAL;
=20
-	padata_flush_queues(pd_old);
-	padata_free_pd(pd_old);
+	if (atomic_dec_and_test(&pd_old->refcnt))
+		padata_free_pd(pd_old);
=20
 	if (notification_mask)
 		blocking_notifier_call_chain(&pinst->cpumask_change_notifier,
@@ -660,8 +620,8 @@ int padata_set_cpumask(struct padata_instance *pinst, i=
nt cpumask_type,
 	struct cpumask *serial_mask, *parallel_mask;
 	int err =3D -EINVAL;
=20
-	mutex_lock(&pinst->lock);
 	get_online_cpus();
+	mutex_lock(&pinst->lock);
=20
 	switch (cpumask_type) {
 	case PADATA_CPU_PARALLEL:
@@ -679,8 +639,8 @@ int padata_set_cpumask(struct padata_instance *pinst, i=
nt cpumask_type,
 	err =3D  __padata_set_cpumasks(pinst, parallel_mask, serial_mask);
=20
 out:
-	put_online_cpus();
 	mutex_unlock(&pinst->lock);
+	put_online_cpus();
=20
 	return err;
 }
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 7d890e157452..51c68ce92337 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -343,8 +343,15 @@ static void clocksource_watchdog(unsigned long data)
 	next_cpu =3D cpumask_next(raw_smp_processor_id(), cpu_online_mask);
 	if (next_cpu >=3D nr_cpu_ids)
 		next_cpu =3D cpumask_first(cpu_online_mask);
-	watchdog_timer.expires +=3D WATCHDOG_INTERVAL;
-	add_timer_on(&watchdog_timer, next_cpu);
+
+	/*
+	 * Arm timer if not already pending: could race with concurrent
+	 * pair clocksource_stop_watchdog() clocksource_start_watchdog().
+	 */
+	if (!timer_pending(&watchdog_timer)) {
+		watchdog_timer.expires +=3D WATCHDOG_INTERVAL;
+		add_timer_on(&watchdog_timer, next_cpu);
+	}
 out:
 	spin_unlock(&watchdog_lock);
 }
diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 7af67360b330..9457c39e8d3c 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -277,19 +277,23 @@ static int tracing_stat_init(void)
=20
 	d_tracing =3D tracing_init_dentry();
 	if (!d_tracing)
-		return 0;
+		return -ENODEV;
=20
 	stat_dir =3D debugfs_create_dir("trace_stat", d_tracing);
-	if (!stat_dir)
+	if (!stat_dir) {
 		pr_warning("Could not create debugfs "
 			   "'trace_stat' entry\n");
+		return -ENOMEM;
+	}
 	return 0;
 }
=20
 static int init_stat_file(struct stat_session *session)
 {
-	if (!stat_dir && tracing_stat_init())
-		return -ENODEV;
+	int ret;
+
+	if (!stat_dir && (ret =3D tracing_stat_init()))
+		return ret;
=20
 	session->file =3D debugfs_create_file(session->ts->name, 0644,
 					    stat_dir,
@@ -302,7 +306,7 @@ static int init_stat_file(struct stat_session *session)
 int register_stat_tracer(struct tracer_stat *trace)
 {
 	struct stat_session *session, *node;
-	int ret;
+	int ret =3D -EINVAL;
=20
 	if (!trace)
 		return -EINVAL;
@@ -313,17 +317,15 @@ int register_stat_tracer(struct tracer_stat *trace)
 	/* Already registered? */
 	mutex_lock(&all_stat_sessions_mutex);
 	list_for_each_entry(node, &all_stat_sessions, session_list) {
-		if (node->ts =3D=3D trace) {
-			mutex_unlock(&all_stat_sessions_mutex);
-			return -EINVAL;
-		}
+		if (node->ts =3D=3D trace)
+			goto out;
 	}
-	mutex_unlock(&all_stat_sessions_mutex);
=20
+	ret =3D -ENOMEM;
 	/* Init the session */
 	session =3D kzalloc(sizeof(*session), GFP_KERNEL);
 	if (!session)
-		return -ENOMEM;
+		goto out;
=20
 	session->ts =3D trace;
 	INIT_LIST_HEAD(&session->session_list);
@@ -332,15 +334,16 @@ int register_stat_tracer(struct tracer_stat *trace)
 	ret =3D init_stat_file(session);
 	if (ret) {
 		destroy_session(session);
-		return ret;
+		goto out;
 	}
=20
+	ret =3D 0;
 	/* Register */
-	mutex_lock(&all_stat_sessions_mutex);
 	list_add_tail(&session->session_list, &all_stat_sessions);
+ out:
 	mutex_unlock(&all_stat_sessions_mutex);
=20
-	return 0;
+	return ret;
 }
=20
 void unregister_stat_tracer(struct tracer_stat *trace)
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index ad5f8f16270c..11fee39672ee 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2687,6 +2687,9 @@ int mpol_parse_str(char *str, struct mempolicy **mpol)
 	char *flags =3D strchr(str, '=3D');
 	int err =3D 1;
=20
+	if (flags)
+		*flags++ =3D '\0';	/* terminate mode string */
+
 	if (nodelist) {
 		/* NUL-terminate mode or flags string */
 		*nodelist++ =3D '\0';
@@ -2697,9 +2700,6 @@ int mpol_parse_str(char *str, struct mempolicy **mpol)
 	} else
 		nodes_clear(nodes);
=20
-	if (flags)
-		*flags++ =3D '\0';	/* terminate mode string */
-
 	for (mode =3D 0; mode < MPOL_MAX; mode++) {
 		if (!strcmp(str, policy_modes[mode])) {
 			break;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e16ae4249199..e87ddcbb46f2 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2363,6 +2363,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->window_clamp =3D 0;
 	tcp_set_ca_state(sk, TCP_CA_Open);
 	tcp_clear_retrans(tp);
+	tp->total_retrans =3D 0;
 	inet_csk_delack_init(sk);
 	/* Initialize rcv_mss to TCP_MIN_MSS to avoid division by 0
 	 * issue in __tcp_select_window()
diff --git a/net/sched/cls_rsvp.h b/net/sched/cls_rsvp.h
index 1020e233a5d6..c424b7aa969b 100644
--- a/net/sched/cls_rsvp.h
+++ b/net/sched/cls_rsvp.h
@@ -404,10 +404,8 @@ static u32 gen_tunnel(struct rsvp_head *data)
=20
 static const struct nla_policy rsvp_policy[TCA_RSVP_MAX + 1] =3D {
 	[TCA_RSVP_CLASSID]	=3D { .type =3D NLA_U32 },
-	[TCA_RSVP_DST]		=3D { .type =3D NLA_BINARY,
-				    .len =3D RSVP_DST_LEN * sizeof(u32) },
-	[TCA_RSVP_SRC]		=3D { .type =3D NLA_BINARY,
-				    .len =3D RSVP_DST_LEN * sizeof(u32) },
+	[TCA_RSVP_DST]		=3D { .len =3D RSVP_DST_LEN * sizeof(u32) },
+	[TCA_RSVP_SRC]		=3D { .len =3D RSVP_DST_LEN * sizeof(u32) },
 	[TCA_RSVP_PINFO]	=3D { .len =3D sizeof(struct tc_rsvp_pinfo) },
 };
=20
diff --git a/net/sched/ematch.c b/net/sched/ematch.c
index eaf8e3e727dc..cc80a4204c33 100644
--- a/net/sched/ematch.c
+++ b/net/sched/ematch.c
@@ -241,6 +241,9 @@ static int tcf_em_validate(struct tcf_proto *tp,
 			goto errout;
=20
 		if (em->ops->change) {
+			err =3D -EINVAL;
+			if (em_hdr->flags & TCF_EM_SIMPLE)
+				goto errout;
 			err =3D em->ops->change(tp, data, data_len, em);
 			if (err < 0)
 				goto errout;
diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcaut=
h_gss.c
index 03000a10983d..09c2f8c27ec4 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1171,6 +1171,7 @@ static int gss_proxy_save_rsc(struct cache_detail *cd,
 		dprintk("RPC:       No creds found!\n");
 		goto out;
 	} else {
+		struct timespec boot;
=20
 		/* steal creds */
 		rsci.cred =3D ud->creds;
@@ -1191,6 +1192,9 @@ static int gss_proxy_save_rsc(struct cache_detail *cd,
 						&expiry, GFP_KERNEL);
 		if (status)
 			goto out;
+
+		getboottime(&boot);
+		expiry -=3D boot.tv_sec;
 	}
=20
 	rsci.h.expiry_time =3D expiry;
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 186d5aec7e72..8fce1f5beb88 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -1231,7 +1231,7 @@ bool conf_set_all_new_symbols(enum conf_def_mode mode)
=20
 		sym_calc_value(csym);
 		if (mode =3D=3D def_random)
-			has_changed =3D randomize_choice_values(csym);
+			has_changed |=3D randomize_choice_values(csym);
 		else {
 			set_all_choice_values(csym);
 			has_changed =3D true;
diff --git a/sound/drivers/dummy.c b/sound/drivers/dummy.c
index 35cc884bca6b..eb161cf7ffbd 100644
--- a/sound/drivers/dummy.c
+++ b/sound/drivers/dummy.c
@@ -927,7 +927,7 @@ static void print_formats(struct snd_dummy *dummy,
 {
 	int i;
=20
-	for (i =3D 0; i < SNDRV_PCM_FORMAT_LAST; i++) {
+	for (i =3D 0; i <=3D SNDRV_PCM_FORMAT_LAST; i++) {
 		if (dummy->pcm_hw.formats & (1ULL << i))
 			snd_iprintf(buffer, " %s", snd_pcm_format_name(i));
 	}
diff --git a/sound/sh/aica.c b/sound/sh/aica.c
index 47849eaf266d..e631d6d71e1a 100644
--- a/sound/sh/aica.c
+++ b/sound/sh/aica.c
@@ -120,10 +120,10 @@ static void spu_memset(u32 toi, u32 what, int length)
 }
=20
 /* spu_memload - write to SPU address space */
-static void spu_memload(u32 toi, void *from, int length)
+static void spu_memload(u32 toi, const void *from, int length)
 {
 	unsigned long flags;
-	u32 *froml =3D from;
+	const u32 *froml =3D from;
 	u32 __iomem *to =3D (u32 __iomem *) (SPU_MEMORY_BASE + toi);
 	int i;
 	u32 val;
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index e8ce34c9db32..456131c04c90 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -36,6 +36,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/nospec.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/current.h>
@@ -73,13 +74,14 @@ static unsigned long ioapic_read_indirect(struct kvm_io=
apic *ioapic,
 	default:
 		{
 			u32 redir_index =3D (ioapic->ioregsel - 0x10) >> 1;
-			u64 redir_content;
+			u64 redir_content =3D ~0ULL;
=20
-			if (redir_index < IOAPIC_NUM_PINS)
-				redir_content =3D
-					ioapic->redirtbl[redir_index].bits;
-			else
-				redir_content =3D ~0ULL;
+			if (redir_index < IOAPIC_NUM_PINS) {
+				u32 index =3D array_index_nospec(
+					redir_index, IOAPIC_NUM_PINS);
+
+				redir_content =3D ioapic->redirtbl[index].bits;
+			}
=20
 			result =3D (ioapic->ioregsel & 0x1) ?
 			    (redir_content >> 32) & 0xffffffff :
@@ -310,6 +312,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *io=
apic, u32 val)
 		ioapic_debug("change redir index %x val %x\n", index, val);
 		if (index >=3D IOAPIC_NUM_PINS)
 			return;
+		index =3D array_index_nospec(index, IOAPIC_NUM_PINS);
 		e =3D &ioapic->redirtbl[index];
 		mask_before =3D e->fields.mask;
 		if (ioapic->ioregsel & 1) {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cc0b4c5f5c72..dd3068094a01 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1596,12 +1596,12 @@ int kvm_write_guest_cached(struct kvm *kvm, struct =
gfn_to_hva_cache *ghc,
 	if (slots->generation !=3D ghc->generation)
 		kvm_gfn_to_hva_cache_init(kvm, ghc, ghc->gpa, ghc->len);
=20
-	if (unlikely(!ghc->memslot))
-		return kvm_write_guest(kvm, ghc->gpa, data, len);
-
 	if (kvm_is_error_hva(ghc->hva))
 		return -EFAULT;
=20
+	if (unlikely(!ghc->memslot))
+		return kvm_write_guest(kvm, ghc->gpa, data, len);
+
 	r =3D __copy_to_user((void __user *)ghc->hva, data, len);
 	if (r)
 		return -EFAULT;
@@ -1622,12 +1622,12 @@ int kvm_read_guest_cached(struct kvm *kvm, struct g=
fn_to_hva_cache *ghc,
 	if (slots->generation !=3D ghc->generation)
 		kvm_gfn_to_hva_cache_init(kvm, ghc, ghc->gpa, ghc->len);
=20
-	if (unlikely(!ghc->memslot))
-		return kvm_read_guest(kvm, ghc->gpa, data, len);
-
 	if (kvm_is_error_hva(ghc->hva))
 		return -EFAULT;
=20
+	if (unlikely(!ghc->memslot))
+		return kvm_read_guest(kvm, ghc->gpa, data, len);
+
 	r =3D __copy_from_user(data, (void __user *)ghc->hva, len);
 	if (r)
 		return -EFAULT;

--azLHFNyN32YCQGCU--

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl7JE8sACgkQ57/I7JWG
EQnFwA/+I/cptJV0i4zk1fNZRVDHhG/EOPoHtD1Lu5s4Pzm7PGhXaNfRd1sks7WZ
KwkevJ459NYn5AD2NKb6+Ao4QmPKZ6WERhwPVRpy/9e+OOjnFclzSTOpKdEs+2bB
pcA85VD1zGRVU0Dnz6BjtnEInmCZnXCTM7SX/fDuwHVtu7NqNNLx3wdA/xHKBf2P
BARm6jWiMmDYqOrmxuojKMn01pnDLYtfP0+dSgZkAVqLxtahDoJxilt1I3lDFo7G
0H+lSU1L1MIUR4P+odNUlcM5JNs50OddzTl2tsCdIfy1SdO4ELo9G7nqSt3qgaME
jb1xe7tcDlEpjuzpElKiQQzNlXQc9bJqAKRA8eVLMYSGFWhkEbzPGV+p9G30bV0A
UbIGGLyJo96a5ssanZKc7fMDs5bq7Z8VIPaZ/AzG3Z6sYbVNEDClO+cKzcGm9cWr
YsGtKE2rUW4p2+DY2sJRS9PT+Dh4I3eqozhTcjsZo/r1M7gIHOGGTD4HFksz/1PJ
cn+VEIAIo55s0Ke1shDYVMAtcM1mLGF1v5fxxS3GjfXlb92bHx2ExoF1blSfkPjZ
iOiFDVfoP3DZ+mSFqpD1rCBZhEJr3Ht65taeWRkqivFnxRZR5Ao/44XbGDMtRGOR
S21mrLfHUITD3zAW2igj0t3psLPCdxONB208o94UUfsQzlghGEk=
=FQxx
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--
