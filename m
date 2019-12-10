Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BACC11195B4
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbfLJVWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:22:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48728 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727237AbfLJVWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 16:22:44 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iemxs-0008EQ-L2; Tue, 10 Dec 2019 21:22:40 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iemxr-0008Td-PH; Tue, 10 Dec 2019 21:22:39 +0000
Date:   Tue, 10 Dec 2019 21:22:39 +0000
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc:     lwn@lwn.net
Subject: Linux 3.16.79
Message-ID: <lsq.1576012912.801612107@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.12.2 (2019-09-21)
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.16.79 kernel.

All users of the 3.16 kernel series should upgrade.

The updated 3.16.y git tree can be found at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.16.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git

The diff from 3.16.78 is attached to this message.

Ben.

------------

 Makefile                                     |   2 +-
 arch/arm/mach-zynq/platsmp.c                 |   2 +-
 arch/powerpc/kernel/rtas.c                   |  11 +-
 arch/powerpc/platforms/pseries/setup.c       |   3 +
 arch/s390/hypfs/inode.c                      |   9 +-
 arch/s390/kernel/topology.c                  |   3 +-
 arch/x86/kernel/smp.c                        |  46 +++---
 arch/x86/kvm/cpuid.c                         |   5 +-
 arch/x86/kvm/mmu.c                           |   5 -
 arch/x86/kvm/mmu.h                           |   5 +
 arch/x86/kvm/x86.c                           |  16 +-
 crypto/crypto_user.c                         |  43 ++++--
 drivers/char/hw_random/core.c                |   2 +-
 drivers/char/mem.c                           |  21 +++
 drivers/firmware/efi/cper.c                  |  15 ++
 drivers/hid/hid-axff.c                       |  11 +-
 drivers/hid/hid-dr.c                         |  12 +-
 drivers/hid/hid-emsff.c                      |  12 +-
 drivers/hid/hid-gaff.c                       |  12 +-
 drivers/hid/hid-holtekff.c                   |  12 +-
 drivers/hid/hid-lg2ff.c                      |  12 +-
 drivers/hid/hid-lg3ff.c                      |  11 +-
 drivers/hid/hid-lg4ff.c                      |  11 +-
 drivers/hid/hid-lgff.c                       |  11 +-
 drivers/hid/hid-prodikeys.c                  |  12 +-
 drivers/hid/hid-sony.c                       |  12 +-
 drivers/hid/hid-tmff.c                       |  12 +-
 drivers/hid/hid-zpff.c                       |  12 +-
 drivers/hid/hidraw.c                         |   2 +-
 drivers/hid/usbhid/hiddev.c                  |  12 ++
 drivers/i2c/busses/i2c-riic.c                |   1 +
 drivers/input/ff-memless.c                   |   9 ++
 drivers/leds/leds-lp5562.c                   |   6 +-
 drivers/media/usb/b2c2/flexcop-usb.c         |   3 +
 drivers/media/usb/dvb-usb/dib0700_devices.c  |   8 +
 drivers/media/usb/gspca/sn9c20x.c            |   7 +
 drivers/media/usb/tm6000/tm6000-dvb.c        |   3 +
 drivers/media/usb/ttusb-dec/ttusb_dec.c      |   2 +-
 drivers/mtd/chips/cfi_cmdset_0002.c          |  19 ++-
 drivers/net/can/spi/mcp251x.c                |  19 ++-
 drivers/net/can/usb/gs_usb.c                 |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb_core.c |   2 +-
 drivers/net/phy/national.c                   |   9 +-
 drivers/net/wimax/i2400m/op-rfkill.c         |   1 +
 drivers/net/wireless/libertas_tf/cmd.c       |   2 +-
 drivers/net/wireless/mwifiex/pcie.c          |   9 +-
 drivers/parisc/dino.c                        |  24 +++
 drivers/s390/cio/ccwgroup.c                  |   2 +-
 drivers/s390/cio/css.c                       |   2 +
 drivers/scsi/bfa/bfad_attr.c                 |   4 +-
 drivers/staging/android/binder.c             |  17 ++-
 drivers/thermal/thermal_core.c               |   2 +-
 drivers/usb/core/config.c                    |  12 +-
 drivers/usb/misc/adutux.c                    |   9 +-
 drivers/usb/misc/iowarrior.c                 |   8 +-
 drivers/video/fbdev/ssd1307fb.c              |  67 +++++++--
 drivers/video/of_display_timing.c            |   7 +-
 fs/btrfs/ctree.c                             |   5 +-
 fs/cifs/smb2ops.c                            |   5 +
 fs/cifs/xattr.c                              |   2 +-
 fs/configfs/symlink.c                        |  33 +++-
 fs/ext4/extents.c                            |   4 +-
 fs/ext4/inline.c                             |   2 +-
 fs/fuse/file.c                               |   1 +
 include/linux/atalk.h                        |   2 +-
 include/linux/ieee80211.h                    |  53 +++++++
 include/sound/soc-dapm.h                     |   2 +
 net/appletalk/aarp.c                         |  15 +-
 net/appletalk/ddp.c                          |  21 ++-
 net/sched/sch_netem.c                        |   2 +-
 net/wireless/nl80211.c                       |  35 +++++
 net/wireless/util.c                          |   1 +
 security/smack/smack_access.c                |   4 +-
 security/smack/smack_lsm.c                   |   5 +-
 sound/aoa/codecs/onyx.c                      |   4 +-
 sound/pci/hda/patch_analog.c                 |   1 +
 sound/soc/codecs/sgtl5000.c                  | 216 +++++++++++++++++++++++----
 77 files changed, 831 insertions(+), 191 deletions(-)

Al Viro (1):
      configfs: fix a deadlock in configfs_symlink()

Alan Stern (4):
      HID: hidraw: Fix invalid read in hidraw_ioctl
      USB: usbcore: Fix slab-out-of-bounds bug during device reset
      HID: prodikeys: Fix general protection fault during probe
      HID: Fix assumption that devices have inputs

Arnd Bergmann (1):
      media: dib0700: fix link error for dibx000_i2c_set_speed

Ben Hutchings (1):
      Linux 3.16.79

Chris Brandt (1):
      i2c: riic: Clear NACK in tend isr

Colin Ian King (2):
      ext4: set error return correctly when ext4_htree_store_dirent fails
      USB: adutux: remove redundant variable minor

David Howells (1):
      hypfs: Fix error number left in struct pointer member

Denis Kenzior (1):
      cfg80211: Purge frame registrations on iftype change

Douglas Anderson (1):
      video: of: display_timing: Add of_node_put() in of_get_display_timing()

Eric Biggers (1):
      smack: use GFP_NOFS while holding inode_smack::smk_lock

Eric Dumazet (1):
      sch_netem: fix a divide by zero in tabledist()

Filipe Manana (1):
      Btrfs: fix use-after-free when using the tree modification log

Grzegorz Halat (1):
      x86/reboot: Always use NMI fallback when shutdown via reboot vector IPI fails

Hans de Goede (1):
      media: sn9c20x: Add MSI MS-1039 laptop to flip_dmi_table

Helge Deller (1):
      parisc: Disable HP HSC-PCI Cards to prevent kernel crash

Herbert Xu (1):
      crypto: user - Fix crypto_alg_match race

Hillf Danton (2):
      HID: hiddev: do cleanup in failure of opening a device
      HID: hiddev: avoid opening a disconnected device

Ido Schimmel (1):
      thermal: Fix use-after-free when unregistering thermal zone device

Jann Horn (1):
      Smack: Don't ignore other bprm->unsafe flags if LSM_UNSAFE_PTRACE is set

Jean-Michel Hautbois (1):
      ASoC: sgtl5000: fix VAG power up timing

Johan Hovold (3):
      USB: adutux: fix use-after-free on disconnect
      USB: iowarrior: fix use-after-free on disconnect
      can: peak_usb: fix slab info leak

Johannes Berg (3):
      ALSA: aoa: onyx: always initialize register read value
      cfg80211: add and use strongly typed element iteration macros
      nl80211: validate beacon head

Junaid Shahid (1):
      kvm: mmu: Don't read PDPTEs when paging is not enabled

Laurent Vivier (1):
      hwrng: core - don't wait on add_early_randomness()

Luis Araneda (1):
      ARM: zynq: Use memcpy_toio instead of memcpy on smp bring-up

Marc Kleine-Budde (1):
      can: mcp251x: mcp251x_hw_reset(): allow more time after a reset

Marko Kohtala (1):
      video: ssd1307fb: Start page range at page_offset

Martijn Coenen (1):
      ANDROID: binder: remove waitqueue when thread exits.

Murphy Zhou (1):
      CIFS: fix max ea value size

Nathan Lynch (2):
      powerpc/rtas: use device model APIs and serialization during LPM
      powerpc/pseries: correctly track irq state in default idle

Navid Emamdoost (7):
      wimax: i2400: fix memory leak
      wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle
      can: gs_usb: gs_can_open(): prevent memory leak
      mwifiex: pcie: Fix memory leak in mwifiex_pcie_alloc_cmdrsp_buf
      mwifiex: pcie: Fix memory leak in mwifiex_pcie_init_evt_ring
      crypto: user - fix memory leak in crypto_report
      scsi: bfa: release allocated memory in case of error

Nick Stoughton (1):
      leds: leds-lp5562 allow firmware files up to the maximum length

Nikolay Borisov (1):
      btrfs: Relinquish CPUs in btrfs_compare_trees

Oleksandr Suvorov (2):
      ASoC: Define a set of DAPM pre/post-up events
      ASoC: sgtl5000: Improve VAG power and mute control

Oliver Neukum (3):
      media: b2c2-flexcop-usb: add sanity checking
      Input: ff-memless - kill timer in destroy()
      usb: iowarrior: fix deadlock on disconnect

Paolo Bonzini (1):
      KVM: x86: fix out-of-bounds write in KVM_GET_EMULATED_CPUID (CVE-2019-19332)

Pavel Shilovsky (1):
      CIFS: Fix oplock handling for SMB 2.1+ protocols

Peter Mamonov (1):
      net/phy: fix DP83865 10 Mbps HDX loopback disable function

Prabhakar Lad (1):
      fbdev: ssd1307fb: return proper error code if write command fails

Rakesh Pandit (1):
      ext4: fix warning inside ext4_convert_unwritten_extents_endio

Sean Christopherson (1):
      KVM: x86: Manually calculate reserved bits when loading PDPTRS

Sean Young (1):
      media: tm6000: double free if usb disconnect while streaming

Shih-Yuan Lee (FourDollars) (1):
      ALSA: hda - Add laptop imic fixup for ASUS M9V laptop

Tetsuo Handa (1):
      /dev/mem: Bail out upon SIGKILL.

Tiejun Chen (1):
      KVM: mmio: cleanup kvm_set_mmio_spte_mask

Tokunori Ikegami (1):
      mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()

Tomas Bortoli (1):
      media: ttusb-dec: Fix info-leak in ttusb_dec_send_command()

Vasily Averin (1):
      fuse: fix missing unlock_page in fuse_writepage()

Vasily Gorbik (3):
      s390/topology: avoid firing events before kobjs are created
      s390/cio: avoid calling strlen on null pointer
      s390/cio: exclude subchannels with no parent from pseudo check

Wei Wang (1):
      thermal: Fix deadlock in thermal thermal_zone_device_check

Xiaofei Tan (1):
      efi: cper: print AER info of PCIe fatal error

YueHaibing (3):
      libertas_tf: Use correct channel range in lbtf_geo_init
      appletalk: Fix potential NULL pointer dereference in unregister_snap_client
      appletalk: Set error code if register_snap_client failed


--pf9I7BMVVzbSWLtt
Content-Type: text/x-diff; charset=UTF-8; name="linux-3.16.79.patch"
Content-Disposition: attachment; filename="linux-3.16.79.patch"
Content-Transfer-Encoding: 8bit

diff --git a/Makefile b/Makefile
index 1c577cc5ad59..a53770703aa1 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 3
 PATCHLEVEL = 16
-SUBLEVEL = 78
+SUBLEVEL = 79
 EXTRAVERSION =
 NAME = Museum of Fishiegoodies
 
diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
index abc82ef085c1..5ebcbee0ff7d 100644
--- a/arch/arm/mach-zynq/platsmp.c
+++ b/arch/arm/mach-zynq/platsmp.c
@@ -65,7 +65,7 @@ int zynq_cpun_start(u32 address, int cpu)
 			* 0x4: Jump by mov instruction
 			* 0x8: Jumping address
 			*/
-			memcpy((__force void *)zero, &zynq_secondary_trampoline,
+			memcpy_toio(zero, &zynq_secondary_trampoline,
 							trampoline_size);
 			writel(address, zero + trampoline_size);
 
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 79c459a2b684..acf420108a2c 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -855,15 +855,17 @@ static int rtas_cpu_state_change_mask(enum rtas_cpu_state state,
 		return 0;
 
 	for_each_cpu(cpu, cpus) {
+		struct device *dev = get_cpu_device(cpu);
+
 		switch (state) {
 		case DOWN:
-			cpuret = cpu_down(cpu);
+			cpuret = device_offline(dev);
 			break;
 		case UP:
-			cpuret = cpu_up(cpu);
+			cpuret = device_online(dev);
 			break;
 		}
-		if (cpuret) {
+		if (cpuret < 0) {
 			pr_debug("%s: cpu_%s for cpu#%d returned %d.\n",
 					__func__,
 					((state == UP) ? "up" : "down"),
@@ -955,6 +957,8 @@ int rtas_ibm_suspend_me(struct rtas_args *args)
 	data.token = rtas_token("ibm,suspend-me");
 	data.complete = &done;
 
+	lock_device_hotplug();
+
 	/* All present CPUs must be online */
 	cpumask_andnot(offline_mask, cpu_present_mask, cpu_online_mask);
 	cpuret = rtas_online_cpus_mask(offline_mask);
@@ -986,6 +990,7 @@ int rtas_ibm_suspend_me(struct rtas_args *args)
 				__func__);
 
 out:
+	unlock_device_hotplug();
 	free_cpumask_var(offline_mask);
 	return atomic_read(&data.error);
 }
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index f2f40e64658f..5e369bb9e4fd 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -360,6 +360,9 @@ static void pseries_lpar_idle(void)
 	 * low power mode by cedeing processor to hypervisor
 	 */
 
+	if (!prep_irq_for_idle())
+		return;
+
 	/* Indicate to hypervisor that we are idle. */
 	get_lppaca()->idle = 1;
 
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index c6570e1d6763..9c319dfe46f6 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -275,7 +275,7 @@ static int hypfs_show_options(struct seq_file *s, struct dentry *root)
 static int hypfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct inode *root_inode;
-	struct dentry *root_dentry;
+	struct dentry *root_dentry, *update_file;
 	int rc = 0;
 	struct hypfs_sb_info *sbi;
 
@@ -306,9 +306,10 @@ static int hypfs_fill_super(struct super_block *sb, void *data, int silent)
 		rc = hypfs_diag_create_files(root_dentry);
 	if (rc)
 		return rc;
-	sbi->update_file = hypfs_create_update_file(root_dentry);
-	if (IS_ERR(sbi->update_file))
-		return PTR_ERR(sbi->update_file);
+	update_file = hypfs_create_update_file(root_dentry);
+	if (IS_ERR(update_file))
+		return PTR_ERR(update_file);
+	sbi->update_file = update_file;
 	hypfs_update_update(sb);
 	pr_info("Hypervisor filesystem mounted\n");
 	return 0;
diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index b93bed76ea94..404a1119fd65 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -266,7 +266,8 @@ int arch_update_cpu_topology(void)
 	update_cpu_masks();
 	for_each_online_cpu(cpu) {
 		dev = get_cpu_device(cpu);
-		kobject_uevent(&dev->kobj, KOBJ_CHANGE);
+		if (dev)
+			kobject_uevent(&dev->kobj, KOBJ_CHANGE);
 	}
 	return 1;
 }
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 00e67d05cbd0..3353f6603449 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -178,6 +178,12 @@ asmlinkage __visible void smp_reboot_interrupt(void)
 	irq_exit();
 }
 
+static int register_stop_handler(void)
+{
+	return register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
+				    NMI_FLAG_FIRST, "smp_stop");
+}
+
 static void native_stop_other_cpus(int wait)
 {
 	unsigned long flags;
@@ -211,39 +217,41 @@ static void native_stop_other_cpus(int wait)
 		apic->send_IPI_allbutself(REBOOT_VECTOR);
 
 		/*
-		 * Don't wait longer than a second if the caller
-		 * didn't ask us to wait.
+		 * Don't wait longer than a second for IPI completion. The
+		 * wait request is not checked here because that would
+		 * prevent an NMI shutdown attempt in case that not all
+		 * CPUs reach shutdown state.
 		 */
 		timeout = USEC_PER_SEC;
-		while (num_online_cpus() > 1 && (wait || timeout--))
+		while (num_online_cpus() > 1 && timeout--)
 			udelay(1);
 	}
-	
-	/* if the REBOOT_VECTOR didn't work, try with the NMI */
-	if ((num_online_cpus() > 1) && (!smp_no_nmi_ipi))  {
-		if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
-					 NMI_FLAG_FIRST, "smp_stop"))
-			/* Note: we ignore failures here */
-			/* Hope the REBOOT_IRQ is good enough */
-			goto finish;
-
-		/* sync above data before sending IRQ */
-		wmb();
 
-		pr_emerg("Shutting down cpus with NMI\n");
+	/* if the REBOOT_VECTOR didn't work, try with the NMI */
+	if (num_online_cpus() > 1) {
+		/*
+		 * If NMI IPI is enabled, try to register the stop handler
+		 * and send the IPI. In any case try to wait for the other
+		 * CPUs to stop.
+		 */
+		if (!smp_no_nmi_ipi && !register_stop_handler()) {
+			/* Sync above data before sending IRQ */
+			wmb();
 
-		apic->send_IPI_allbutself(NMI_VECTOR);
+			pr_emerg("Shutting down cpus with NMI\n");
 
+			apic->send_IPI_allbutself(NMI_VECTOR);
+		}
 		/*
-		 * Don't wait longer than a 10 ms if the caller
-		 * didn't ask us to wait.
+		 * Don't wait longer than 10 ms if the caller didn't
+		 * reqeust it. If wait is true, the machine hangs here if
+		 * one or more CPUs do not reach shutdown state.
 		 */
 		timeout = USEC_PER_MSEC * 10;
 		while (num_online_cpus() > 1 && (wait || timeout--))
 			udelay(1);
 	}
 
-finish:
 	local_irq_save(flags);
 	disable_local_APIC();
 	local_irq_restore(flags);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 90ad3c2db24a..66062325d4b7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -327,7 +327,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 
 	r = -E2BIG;
 
-	if (*nent >= maxnent)
+	if (WARN_ON(*nent >= maxnent))
 		goto out;
 
 	do_cpuid_1_ent(entry, function, index);
@@ -599,6 +599,9 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 func,
 			u32 idx, int *nent, int maxnent, unsigned int type)
 {
+	if (*nent >= maxnent)
+		return -E2BIG;
+
 	if (type == KVM_GET_EMULATED_CPUID)
 		return __do_cpuid_ent_emulated(entry, func, idx, nent, maxnent);
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 886fb53b4604..c780e96ba156 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -295,11 +295,6 @@ static bool check_mmio_spte(struct kvm *kvm, u64 spte)
 	return likely(kvm_gen == spte_gen);
 }
 
-static inline u64 rsvd_bits(int s, int e)
-{
-	return ((1ULL << (e - s + 1)) - 1) << s;
-}
-
 void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 		u64 dirty_mask, u64 nx_mask, u64 x_mask)
 {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index f3dc8f614512..f71858da69bf 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -56,6 +56,11 @@
 #define PFERR_RSVD_MASK (1U << PFERR_RSVD_BIT)
 #define PFERR_FETCH_MASK (1U << PFERR_FETCH_BIT)
 
+static inline u64 rsvd_bits(int s, int e)
+{
+	return ((1ULL << (e - s + 1)) - 1) << s;
+}
+
 int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 48cfac1a78de..d6711e5b9e78 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -465,8 +465,14 @@ int kvm_read_nested_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 				       data, offset, len, access);
 }
 
+static inline u64 pdptr_rsvd_bits(struct kvm_vcpu *vcpu)
+{
+	return rsvd_bits(cpuid_maxphyaddr(vcpu), 63) | rsvd_bits(5, 8) |
+	       rsvd_bits(1, 2);
+}
+
 /*
- * Load the pae pdptrs.  Return true is they are all valid.
+ * Load the pae pdptrs.  Return 1 if they are all valid, 0 otherwise.
  */
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
 {
@@ -485,7 +491,7 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
 	}
 	for (i = 0; i < ARRAY_SIZE(pdpte); ++i) {
 		if (is_present_gpte(pdpte[i]) &&
-		    (pdpte[i] & vcpu->arch.mmu.rsvd_bits_mask[0][2])) {
+		    (pdpte[i] & pdptr_rsvd_bits(vcpu))) {
 			ret = 0;
 			goto out;
 		}
@@ -511,7 +517,7 @@ static bool pdptrs_changed(struct kvm_vcpu *vcpu)
 	gfn_t gfn;
 	int r;
 
-	if (is_long_mode(vcpu) || !is_pae(vcpu))
+	if (is_long_mode(vcpu) || !is_pae(vcpu) || !is_paging(vcpu))
 		return false;
 
 	if (!test_bit(VCPU_EXREG_PDPTR,
@@ -5689,7 +5695,7 @@ static void kvm_set_mmio_spte_mask(void)
 	 * entry to generate page fault with PFER.RSV = 1.
 	 */
 	 /* Mask the reserved physical address bits. */
-	mask = ((1ull << (51 - maxphyaddr + 1)) - 1) << maxphyaddr;
+	mask = rsvd_bits(maxphyaddr, 51);
 
 	/* Bit 62 is always reserved for 32bit host. */
 	mask |= 0x3ull << 62;
@@ -6783,7 +6789,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 		kvm_update_cpuid(vcpu);
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	if (!is_long_mode(vcpu) && is_pae(vcpu)) {
+	if (!is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu)) {
 		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
 		mmu_reset_needed = 1;
 	}
diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 4e9be2e02090..05b7e619d896 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -65,10 +65,14 @@ static struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact)
 		else if (!exact)
 			match = !strcmp(q->cra_name, p->cru_name);
 
-		if (match) {
-			alg = q;
-			break;
-		}
+		if (!match)
+			continue;
+
+		if (unlikely(!crypto_mod_get(q)))
+			continue;
+
+		alg = q;
+		break;
 	}
 
 	up_read(&crypto_alg_sem);
@@ -211,9 +215,10 @@ static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 	if (!alg)
 		return -ENOENT;
 
+	err = -ENOMEM;
 	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
 	if (!skb)
-		return -ENOMEM;
+		goto drop_alg;
 
 	info.in_skb = in_skb;
 	info.out_skb = skb;
@@ -221,8 +226,14 @@ static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 	info.nlmsg_flags = 0;
 
 	err = crypto_report_alg(alg, &info);
-	if (err)
+
+drop_alg:
+	crypto_mod_put(alg);
+
+	if (err) {
+		kfree_skb(skb);
 		return err;
+	}
 
 	return nlmsg_unicast(crypto_nlsk, skb, NETLINK_CB(in_skb).portid);
 }
@@ -293,6 +304,7 @@ static int crypto_update_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	up_write(&crypto_alg_sem);
 
+	crypto_mod_put(alg);
 	crypto_remove_final(&list);
 
 	return 0;
@@ -303,6 +315,7 @@ static int crypto_del_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 {
 	struct crypto_alg *alg;
 	struct crypto_user_alg *p = nlmsg_data(nlh);
+	int err;
 
 	if (!netlink_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
@@ -319,13 +332,19 @@ static int crypto_del_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	 * if we try to unregister. Unregistering such an algorithm without
 	 * removing the module is not possible, so we restrict to crypto
 	 * instances that are build from templates. */
+	err = -EINVAL;
 	if (!(alg->cra_flags & CRYPTO_ALG_INSTANCE))
-		return -EINVAL;
+		goto drop_alg;
+
+	err = -EBUSY;
+	if (atomic_read(&alg->cra_refcnt) > 2)
+		goto drop_alg;
 
-	if (atomic_read(&alg->cra_refcnt) != 1)
-		return -EBUSY;
+	err = crypto_unregister_instance(alg);
 
-	return crypto_unregister_instance(alg);
+drop_alg:
+	crypto_mod_put(alg);
+	return err;
 }
 
 static struct crypto_alg *crypto_user_skcipher_alg(const char *name, u32 type,
@@ -404,8 +423,10 @@ static int crypto_add_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EINVAL;
 
 	alg = crypto_alg_match(p, exact);
-	if (alg)
+	if (alg) {
+		crypto_mod_put(alg);
 		return -EEXIST;
+	}
 
 	if (strlen(p->cru_driver_name))
 		name = p->cru_driver_name;
diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index d456303f4625..23cae27a21d2 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -68,7 +68,7 @@ static void add_early_randomness(struct hwrng *rng)
 	int bytes_read;
 	size_t size = min_t(size_t, 16, rng_buffer_size());
 
-	bytes_read = rng_get_data(rng, rng_buffer, size, 1);
+	bytes_read = rng_get_data(rng, rng_buffer, size, 0);
 	if (bytes_read > 0)
 		add_device_randomness(rng_buffer, bytes_read);
 }
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 446b57efb19f..44d51466ebcc 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -96,6 +96,13 @@ void __weak unxlate_dev_mem_ptr(unsigned long phys, void *addr)
 {
 }
 
+static inline bool should_stop_iteration(void)
+{
+	if (need_resched())
+		cond_resched();
+	return fatal_signal_pending(current);
+}
+
 /*
  * This funcion reads the *physical* memory. The f_pos points directly to the
  * memory location.
@@ -162,6 +169,8 @@ static ssize_t read_mem(struct file *file, char __user *buf,
 		p += sz;
 		count -= sz;
 		read += sz;
+		if (should_stop_iteration())
+			break;
 	}
 
 	*ppos += read;
@@ -233,6 +242,8 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
 		p += sz;
 		count -= sz;
 		written += sz;
+		if (should_stop_iteration())
+			break;
 	}
 
 	*ppos += written;
@@ -436,6 +447,10 @@ static ssize_t read_kmem(struct file *file, char __user *buf,
 			read += sz;
 			low_count -= sz;
 			count -= sz;
+			if (should_stop_iteration()) {
+				count = 0;
+				break;
+			}
 		}
 	}
 
@@ -460,6 +475,8 @@ static ssize_t read_kmem(struct file *file, char __user *buf,
 			buf += sz;
 			read += sz;
 			p += sz;
+			if (should_stop_iteration())
+				break;
 		}
 		free_page((unsigned long)kbuf);
 	}
@@ -510,6 +527,8 @@ static ssize_t do_write_kmem(unsigned long p, const char __user *buf,
 		p += sz;
 		count -= sz;
 		written += sz;
+		if (should_stop_iteration())
+			break;
 	}
 
 	*ppos += written;
@@ -561,6 +580,8 @@ static ssize_t write_kmem(struct file *file, const char __user *buf,
 			buf += sz;
 			virtr += sz;
 			p += sz;
+			if (should_stop_iteration())
+				break;
 		}
 		free_page((unsigned long)kbuf);
 	}
diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 1491dd4f08f9..ef6cd9c2ab72 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -295,6 +295,21 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
 		printk(
 	"%s""bridge: secondary_status: 0x%04x, control: 0x%04x\n",
 	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
+
+	/* Fatal errors call __ghes_panic() before AER handler prints this */
+	if ((pcie->validation_bits & CPER_PCIE_VALID_AER_INFO) &&
+	    (gdata->error_severity & CPER_SEV_FATAL)) {
+		struct aer_capability_regs *aer;
+
+		aer = (struct aer_capability_regs *)pcie->aer_info;
+		printk("%saer_uncor_status: 0x%08x, aer_uncor_mask: 0x%08x\n",
+		       pfx, aer->uncor_status, aer->uncor_mask);
+		printk("%saer_uncor_severity: 0x%08x\n",
+		       pfx, aer->uncor_severity);
+		printk("%sTLP Header: %08x %08x %08x %08x\n", pfx,
+		       aer->header_log.dw0, aer->header_log.dw1,
+		       aer->header_log.dw2, aer->header_log.dw3);
+	}
 }
 
 static void cper_estatus_print_section(
diff --git a/drivers/hid/hid-axff.c b/drivers/hid/hid-axff.c
index a594e478a1e2..843aed4dec80 100644
--- a/drivers/hid/hid-axff.c
+++ b/drivers/hid/hid-axff.c
@@ -75,13 +75,20 @@ static int axff_init(struct hid_device *hid)
 {
 	struct axff_device *axff;
 	struct hid_report *report;
-	struct hid_input *hidinput = list_first_entry(&hid->inputs, struct hid_input, list);
+	struct hid_input *hidinput;
 	struct list_head *report_list =&hid->report_enum[HID_OUTPUT_REPORT].report_list;
-	struct input_dev *dev = hidinput->input;
+	struct input_dev *dev;
 	int field_count = 0;
 	int i, j;
 	int error;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_first_entry(&hid->inputs, struct hid_input, list);
+	dev = hidinput->input;
+
 	if (list_empty(report_list)) {
 		hid_err(hid, "no output reports found\n");
 		return -ENODEV;
diff --git a/drivers/hid/hid-dr.c b/drivers/hid/hid-dr.c
index ce0644424f58..e4e3c7b76fe9 100644
--- a/drivers/hid/hid-dr.c
+++ b/drivers/hid/hid-dr.c
@@ -87,13 +87,19 @@ static int drff_init(struct hid_device *hid)
 {
 	struct drff_device *drff;
 	struct hid_report *report;
-	struct hid_input *hidinput = list_first_entry(&hid->inputs,
-						struct hid_input, list);
+	struct hid_input *hidinput;
 	struct list_head *report_list =
 			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
-	struct input_dev *dev = hidinput->input;
+	struct input_dev *dev;
 	int error;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_first_entry(&hid->inputs, struct hid_input, list);
+	dev = hidinput->input;
+
 	if (list_empty(report_list)) {
 		hid_err(hid, "no output reports found\n");
 		return -ENODEV;
diff --git a/drivers/hid/hid-emsff.c b/drivers/hid/hid-emsff.c
index d82d75bb11f7..80f9a02dfa69 100644
--- a/drivers/hid/hid-emsff.c
+++ b/drivers/hid/hid-emsff.c
@@ -59,13 +59,19 @@ static int emsff_init(struct hid_device *hid)
 {
 	struct emsff_device *emsff;
 	struct hid_report *report;
-	struct hid_input *hidinput = list_first_entry(&hid->inputs,
-						struct hid_input, list);
+	struct hid_input *hidinput;
 	struct list_head *report_list =
 			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
-	struct input_dev *dev = hidinput->input;
+	struct input_dev *dev;
 	int error;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_first_entry(&hid->inputs, struct hid_input, list);
+	dev = hidinput->input;
+
 	if (list_empty(report_list)) {
 		hid_err(hid, "no output reports found\n");
 		return -ENODEV;
diff --git a/drivers/hid/hid-gaff.c b/drivers/hid/hid-gaff.c
index 2d8cead3adca..5a02c50443cb 100644
--- a/drivers/hid/hid-gaff.c
+++ b/drivers/hid/hid-gaff.c
@@ -77,14 +77,20 @@ static int gaff_init(struct hid_device *hid)
 {
 	struct gaff_device *gaff;
 	struct hid_report *report;
-	struct hid_input *hidinput = list_entry(hid->inputs.next,
-						struct hid_input, list);
+	struct hid_input *hidinput;
 	struct list_head *report_list =
 			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct list_head *report_ptr = report_list;
-	struct input_dev *dev = hidinput->input;
+	struct input_dev *dev;
 	int error;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_entry(hid->inputs.next, struct hid_input, list);
+	dev = hidinput->input;
+
 	if (list_empty(report_list)) {
 		hid_err(hid, "no output reports found\n");
 		return -ENODEV;
diff --git a/drivers/hid/hid-holtekff.c b/drivers/hid/hid-holtekff.c
index 9325545fc3ae..3e84551cca9c 100644
--- a/drivers/hid/hid-holtekff.c
+++ b/drivers/hid/hid-holtekff.c
@@ -140,13 +140,19 @@ static int holtekff_init(struct hid_device *hid)
 {
 	struct holtekff_device *holtekff;
 	struct hid_report *report;
-	struct hid_input *hidinput = list_entry(hid->inputs.next,
-						struct hid_input, list);
+	struct hid_input *hidinput;
 	struct list_head *report_list =
 			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
-	struct input_dev *dev = hidinput->input;
+	struct input_dev *dev;
 	int error;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_entry(hid->inputs.next, struct hid_input, list);
+	dev = hidinput->input;
+
 	if (list_empty(report_list)) {
 		hid_err(hid, "no output report found\n");
 		return -ENODEV;
diff --git a/drivers/hid/hid-lg2ff.c b/drivers/hid/hid-lg2ff.c
index 0e3fb1a7e421..6909d9c2fc67 100644
--- a/drivers/hid/hid-lg2ff.c
+++ b/drivers/hid/hid-lg2ff.c
@@ -62,11 +62,17 @@ int lg2ff_init(struct hid_device *hid)
 {
 	struct lg2ff_device *lg2ff;
 	struct hid_report *report;
-	struct hid_input *hidinput = list_entry(hid->inputs.next,
-						struct hid_input, list);
-	struct input_dev *dev = hidinput->input;
+	struct hid_input *hidinput;
+	struct input_dev *dev;
 	int error;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_entry(hid->inputs.next, struct hid_input, list);
+	dev = hidinput->input;
+
 	/* Check that the report looks ok */
 	report = hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 7);
 	if (!report)
diff --git a/drivers/hid/hid-lg3ff.c b/drivers/hid/hid-lg3ff.c
index 8c2da183d3bc..acf739fc4060 100644
--- a/drivers/hid/hid-lg3ff.c
+++ b/drivers/hid/hid-lg3ff.c
@@ -129,12 +129,19 @@ static const signed short ff3_joystick_ac[] = {
 
 int lg3ff_init(struct hid_device *hid)
 {
-	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
-	struct input_dev *dev = hidinput->input;
+	struct hid_input *hidinput;
+	struct input_dev *dev;
 	const signed short *ff_bits = ff3_joystick_ac;
 	int error;
 	int i;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_entry(hid->inputs.next, struct hid_input, list);
+	dev = hidinput->input;
+
 	/* Check that the report looks ok */
 	if (!hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 35))
 		return -ENODEV;
diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index cc2bd2022198..a05ce3b8210e 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -558,14 +558,21 @@ static enum led_brightness lg4ff_led_get_brightness(struct led_classdev *led_cde
 
 int lg4ff_init(struct hid_device *hid)
 {
-	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
-	struct input_dev *dev = hidinput->input;
+	struct hid_input *hidinput;
+	struct input_dev *dev;
 	struct lg4ff_device_entry *entry;
 	struct lg_drv_data *drv_data;
 	struct usb_device_descriptor *udesc;
 	int error, i, j;
 	__u16 bcdDevice, rev_maj, rev_min;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_entry(hid->inputs.next, struct hid_input, list);
+	dev = hidinput->input;
+
 	/* Check that the report looks ok */
 	if (!hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 7))
 		return -1;
diff --git a/drivers/hid/hid-lgff.c b/drivers/hid/hid-lgff.c
index e1394af0ae7b..1871cdcd1e0a 100644
--- a/drivers/hid/hid-lgff.c
+++ b/drivers/hid/hid-lgff.c
@@ -127,12 +127,19 @@ static void hid_lgff_set_autocenter(struct input_dev *dev, u16 magnitude)
 
 int lgff_init(struct hid_device* hid)
 {
-	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
-	struct input_dev *dev = hidinput->input;
+	struct hid_input *hidinput;
+	struct input_dev *dev;
 	const signed short *ff_bits = ff_joystick;
 	int error;
 	int i;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_entry(hid->inputs.next, struct hid_input, list);
+	dev = hidinput->input;
+
 	/* Check that the report looks ok */
 	if (!hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 7))
 		return -ENODEV;
diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
index 91fab975063c..7905d9f015ed 100644
--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -557,10 +557,14 @@ static void pcmidi_setup_extra_keys(
 
 static int pcmidi_set_operational(struct pcmidi_snd *pm)
 {
+	int rc;
+
 	if (pm->ifnum != 1)
 		return 0; /* only set up ONCE for interace 1 */
 
-	pcmidi_get_output_report(pm);
+	rc = pcmidi_get_output_report(pm);
+	if (rc < 0)
+		return rc;
 	pcmidi_submit_output_report(pm, 0xc1);
 	return 0;
 }
@@ -689,7 +693,11 @@ static int pcmidi_snd_initialise(struct pcmidi_snd *pm)
 	spin_lock_init(&pm->rawmidi_in_lock);
 
 	init_sustain_timers(pm);
-	pcmidi_set_operational(pm);
+	err = pcmidi_set_operational(pm);
+	if (err < 0) {
+		pk_error("failed to find output report\n");
+		goto fail_register;
+	}
 
 	/* register it */
 	err = snd_card_register(card);
diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 2259eaa8b988..3bd8bd394c7e 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -1509,9 +1509,15 @@ static int sony_play_effect(struct input_dev *dev, void *data,
 
 static int sony_init_ff(struct sony_sc *sc)
 {
-	struct hid_input *hidinput = list_entry(sc->hdev->inputs.next,
-						struct hid_input, list);
-	struct input_dev *input_dev = hidinput->input;
+	struct hid_input *hidinput;
+	struct input_dev *input_dev;
+
+	if (list_empty(&sc->hdev->inputs)) {
+		hid_err(sc->hdev, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_entry(sc->hdev->inputs.next, struct hid_input, list);
+	input_dev = hidinput->input;
 
 	input_set_capability(input_dev, EV_FF, FF_RUMBLE);
 	return input_ff_create_memless(input_dev, NULL, sony_play_effect);
diff --git a/drivers/hid/hid-tmff.c b/drivers/hid/hid-tmff.c
index b83376077d72..9e908d94cc4c 100644
--- a/drivers/hid/hid-tmff.c
+++ b/drivers/hid/hid-tmff.c
@@ -126,12 +126,18 @@ static int tmff_init(struct hid_device *hid, const signed short *ff_bits)
 	struct tmff_device *tmff;
 	struct hid_report *report;
 	struct list_head *report_list;
-	struct hid_input *hidinput = list_entry(hid->inputs.next,
-							struct hid_input, list);
-	struct input_dev *input_dev = hidinput->input;
+	struct hid_input *hidinput;
+	struct input_dev *input_dev;
 	int error;
 	int i;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_entry(hid->inputs.next, struct hid_input, list);
+	input_dev = hidinput->input;
+
 	tmff = kzalloc(sizeof(struct tmff_device), GFP_KERNEL);
 	if (!tmff)
 		return -ENOMEM;
diff --git a/drivers/hid/hid-zpff.c b/drivers/hid/hid-zpff.c
index a29756c6ca02..4e7e01be99b1 100644
--- a/drivers/hid/hid-zpff.c
+++ b/drivers/hid/hid-zpff.c
@@ -66,11 +66,17 @@ static int zpff_init(struct hid_device *hid)
 {
 	struct zpff_device *zpff;
 	struct hid_report *report;
-	struct hid_input *hidinput = list_entry(hid->inputs.next,
-						struct hid_input, list);
-	struct input_dev *dev = hidinput->input;
+	struct hid_input *hidinput;
+	struct input_dev *dev;
 	int i, error;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_entry(hid->inputs.next, struct hid_input, list);
+	dev = hidinput->input;
+
 	for (i = 0; i < 4; i++) {
 		report = hid_validate_values(hid, HID_OUTPUT_REPORT, 0, i, 1);
 		if (!report)
diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index c0c4df198725..627a24d3ea7c 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -383,7 +383,7 @@ static long hidraw_ioctl(struct file *file, unsigned int cmd,
 
 	mutex_lock(&minors_lock);
 	dev = hidraw_table[minor];
-	if (!dev) {
+	if (!dev || !dev->exist) {
 		ret = -ENODEV;
 		goto out;
 	}
diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 308d8432fea3..8903ea09ac58 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -308,6 +308,14 @@ static int hiddev_open(struct inode *inode, struct file *file)
 	spin_unlock_irq(&list->hiddev->list_lock);
 
 	mutex_lock(&hiddev->existancelock);
+	/*
+	 * recheck exist with existance lock held to
+	 * avoid opening a disconnected device
+	 */
+	if (!list->hiddev->exist) {
+		res = -ENODEV;
+		goto bail_unlock;
+	}
 	if (!list->hiddev->open++)
 		if (list->hiddev->exist) {
 			struct hid_device *hid = hiddev->hid;
@@ -322,6 +330,10 @@ static int hiddev_open(struct inode *inode, struct file *file)
 	return 0;
 bail_unlock:
 	mutex_unlock(&hiddev->existancelock);
+
+	spin_lock_irq(&list->hiddev->list_lock);
+	list_del(&list->node);
+	spin_unlock_irq(&list->hiddev->list_lock);
 bail:
 	file->private_data = NULL;
 	vfree(list);
diff --git a/drivers/i2c/busses/i2c-riic.c b/drivers/i2c/busses/i2c-riic.c
index 7a7b71e97ba4..30238823c16b 100644
--- a/drivers/i2c/busses/i2c-riic.c
+++ b/drivers/i2c/busses/i2c-riic.c
@@ -212,6 +212,7 @@ static irqreturn_t riic_tend_isr(int irq, void *data)
 	if (readb(riic->base + RIIC_ICSR2) & ICSR2_NACKF) {
 		/* We got a NACKIE */
 		readb(riic->base + RIIC_ICDRR);	/* dummy read */
+		riic_clear_set_bit(riic, ICSR2_NACKF, 0, RIIC_ICSR2);
 		riic->err = -ENXIO;
 	} else if (riic->bytes_left) {
 		return IRQ_NONE;
diff --git a/drivers/input/ff-memless.c b/drivers/input/ff-memless.c
index 74c0d8c6002a..eaeadc73cf5c 100644
--- a/drivers/input/ff-memless.c
+++ b/drivers/input/ff-memless.c
@@ -489,6 +489,15 @@ static void ml_ff_destroy(struct ff_device *ff)
 {
 	struct ml_device *ml = ff->private;
 
+	/*
+	 * Even though we stop all playing effects when tearing down
+	 * an input device (via input_device_flush() that calls into
+	 * input_ff_flush() that stops and erases all effects), we
+	 * do not actually stop the timer, and therefore we should
+	 * do it here.
+	 */
+	del_timer_sync(&ml->timer);
+
 	kfree(ml->private);
 }
 
diff --git a/drivers/leds/leds-lp5562.c b/drivers/leds/leds-lp5562.c
index ca85724ab138..adc875823e21 100644
--- a/drivers/leds/leds-lp5562.c
+++ b/drivers/leds/leds-lp5562.c
@@ -263,7 +263,11 @@ static void lp5562_firmware_loaded(struct lp55xx_chip *chip)
 {
 	const struct firmware *fw = chip->fw;
 
-	if (fw->size > LP5562_PROGRAM_LENGTH) {
+	/*
+	 * the firmware is encoded in ascii hex character, with 2 chars
+	 * per byte
+	 */
+	if (fw->size > (LP5562_PROGRAM_LENGTH * 2)) {
 		dev_err(&chip->cl->dev, "firmware data size overflow: %zu\n",
 			fw->size);
 		return;
diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
index 0bd969063392..83d3a5cf272f 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -508,6 +508,9 @@ static int flexcop_usb_probe(struct usb_interface *intf,
 	struct flexcop_device *fc = NULL;
 	int ret;
 
+	if (intf->cur_altsetting->desc.bNumEndpoints < 1)
+		return -ENODEV;
+
 	if ((fc = flexcop_device_kmalloc(sizeof(struct flexcop_usb))) == NULL) {
 		err("out of memory\n");
 		return -ENOMEM;
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 4d99682a207f..8edaceef598e 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -2283,9 +2283,13 @@ static int dib9090_tuner_attach(struct dvb_usb_adapter *adap)
 		8, 0x0486,
 	};
 
+	if (!IS_ENABLED(CONFIG_DVB_DIB9000))
+		return -ENODEV;
 	if (dvb_attach(dib0090_fw_register, adap->fe_adap[0].fe, i2c, &dib9090_dib0090_config) == NULL)
 		return -ENODEV;
 	i2c = dib9000_get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_GPIO_1_2, 0);
+	if (!i2c)
+		return -ENODEV;
 	if (dib01x0_pmu_update(i2c, data_dib190, 10) != 0)
 		return -ENODEV;
 	dib0700_set_i2c_speed(adap->dev, 1500);
@@ -2361,10 +2365,14 @@ static int nim9090md_tuner_attach(struct dvb_usb_adapter *adap)
 		0, 0x00ef,
 		8, 0x0406,
 	};
+	if (!IS_ENABLED(CONFIG_DVB_DIB9000))
+		return -ENODEV;
 	i2c = dib9000_get_tuner_interface(adap->fe_adap[0].fe);
 	if (dvb_attach(dib0090_fw_register, adap->fe_adap[0].fe, i2c, &nim9090md_dib0090_config[0]) == NULL)
 		return -ENODEV;
 	i2c = dib9000_get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_GPIO_1_2, 0);
+	if (!i2c)
+		return -ENODEV;
 	if (dib01x0_pmu_update(i2c, data_dib190, 10) < 0)
 		return -ENODEV;
 
diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
index 41a9a892f79c..dd1c74051638 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -138,6 +138,13 @@ static const struct dmi_system_id flip_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "0341")
 		}
 	},
+	{
+		.ident = "MSI MS-1039",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MICRO-STAR INT'L CO.,LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MS-1039"),
+		}
+	},
 	{
 		.ident = "MSI MS-1632",
 		.matches = {
diff --git a/drivers/media/usb/tm6000/tm6000-dvb.c b/drivers/media/usb/tm6000/tm6000-dvb.c
index 095f5db1a790..175e668f5b5d 100644
--- a/drivers/media/usb/tm6000/tm6000-dvb.c
+++ b/drivers/media/usb/tm6000/tm6000-dvb.c
@@ -111,6 +111,7 @@ static void tm6000_urb_received(struct urb *urb)
 			printk(KERN_ERR "tm6000:  error %s\n", __func__);
 			kfree(urb->transfer_buffer);
 			usb_free_urb(urb);
+			dev->dvb->bulk_urb = NULL;
 		}
 	}
 }
@@ -143,6 +144,7 @@ static int tm6000_start_stream(struct tm6000_core *dev)
 	dvb->bulk_urb->transfer_buffer = kzalloc(size, GFP_KERNEL);
 	if (dvb->bulk_urb->transfer_buffer == NULL) {
 		usb_free_urb(dvb->bulk_urb);
+		dvb->bulk_urb = NULL;
 		printk(KERN_ERR "tm6000: couldn't allocate transfer buffer!\n");
 		return -ENOMEM;
 	}
@@ -170,6 +172,7 @@ static int tm6000_start_stream(struct tm6000_core *dev)
 
 		kfree(dvb->bulk_urb->transfer_buffer);
 		usb_free_urb(dvb->bulk_urb);
+		dvb->bulk_urb = NULL;
 		return ret;
 	}
 
diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 29724af9b9ab..ab0098ce4bbb 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -272,7 +272,7 @@ static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
 
 	dprintk("%s\n", __func__);
 
-	b = kmalloc(COMMAND_PACKET_SIZE + 4, GFP_KERNEL);
+	b = kzalloc(COMMAND_PACKET_SIZE + 4, GFP_KERNEL);
 	if (!b)
 		return -ENOMEM;
 
diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index 40047a2f4696..91514f9ad77a 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -1295,29 +1295,36 @@ static int __xipram do_write_oneword(struct map_info *map, struct flchip *chip,
 			continue;
 		}
 
-		if (time_after(jiffies, timeo) && !chip_ready(map, adr)){
+		/*
+		 * We check "time_after" and "!chip_good" before checking
+		 * "chip_good" to avoid the failure due to scheduling.
+		 */
+		if (time_after(jiffies, timeo) &&
+		    !chip_good(map, adr, datum)) {
 			xip_enable(map, chip, adr);
 			printk(KERN_WARNING "MTD %s(): software timeout\n", __func__);
 			xip_disable(map, chip, adr);
+			ret = -EIO;
 			break;
 		}
 
-		if (chip_ready(map, adr))
+		if (chip_good(map, adr, datum))
 			break;
 
 		/* Latency issues. Drop the lock, wait a while and retry */
 		UDELAY(map, chip, adr, 1);
 	}
+
 	/* Did we succeed? */
-	if (!chip_good(map, adr, datum)) {
+	if (ret) {
 		/* reset on all failures. */
 		map_write( map, CMD(0xF0), chip->start );
 		/* FIXME - should have reset delay before continuing */
 
-		if (++retry_cnt <= MAX_RETRIES)
+		if (++retry_cnt <= MAX_RETRIES) {
+			ret = 0;
 			goto retry;
-
-		ret = -EIO;
+		}
 	}
 	xip_enable(map, chip, adr);
  op_done:
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index cc7ee1b6602b..0cd7e3bd4ccc 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -626,7 +626,7 @@ static int mcp251x_setup(struct net_device *net, struct mcp251x_priv *priv,
 static int mcp251x_hw_reset(struct spi_device *spi)
 {
 	struct mcp251x_priv *priv = spi_get_drvdata(spi);
-	u8 reg;
+	unsigned long timeout;
 	int ret;
 
 	/* Wait for oscillator startup timer after power up */
@@ -640,10 +640,19 @@ static int mcp251x_hw_reset(struct spi_device *spi)
 	/* Wait for oscillator startup timer after reset */
 	mdelay(MCP251X_OST_DELAY_MS);
 	
-	reg = mcp251x_read_reg(spi, CANSTAT);
-	if ((reg & CANCTRL_REQOP_MASK) != CANCTRL_REQOP_CONF)
-		return -ENODEV;
-
+	/* Wait for reset to finish */
+	timeout = jiffies + HZ;
+	while ((mcp251x_read_reg(spi, CANSTAT) & CANCTRL_REQOP_MASK) !=
+	       CANCTRL_REQOP_CONF) {
+		usleep_range(MCP251X_OST_DELAY_MS * 1000,
+			     MCP251X_OST_DELAY_MS * 1000 * 2);
+
+		if (time_after(jiffies, timeout)) {
+			dev_err(&spi->dev,
+				"MCP251x didn't enter in conf mode after reset\n");
+			return -EBUSY;
+		}
+	}
 	return 0;
 }
 
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 9ba8753c7d47..3da1be6b508b 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -617,6 +617,7 @@ static int gs_can_open(struct net_device *netdev)
 					   rc);
 
 				usb_unanchor_urb(urb);
+				usb_free_urb(urb);
 				break;
 			}
 
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index 524be31ec83e..10b854abaf0f 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -732,7 +732,7 @@ static int peak_usb_create_dev(struct peak_usb_adapter *peak_usb_adapter,
 	dev = netdev_priv(netdev);
 
 	/* allocate a buffer large enough to send commands */
-	dev->cmd_buf = kmalloc(PCAN_USB_MAX_CMD_LEN, GFP_KERNEL);
+	dev->cmd_buf = kzalloc(PCAN_USB_MAX_CMD_LEN, GFP_KERNEL);
 	if (!dev->cmd_buf) {
 		err = -ENOMEM;
 		goto lbl_free_candev;
diff --git a/drivers/net/phy/national.c b/drivers/net/phy/national.c
index 9a5f234d95b0..a63a32a35fc6 100644
--- a/drivers/net/phy/national.c
+++ b/drivers/net/phy/national.c
@@ -110,14 +110,17 @@ static void ns_giga_speed_fallback(struct phy_device *phydev, int mode)
 
 static void ns_10_base_t_hdx_loopack(struct phy_device *phydev, int disable)
 {
+	u16 lb_dis = BIT(1);
+
 	if (disable)
-		ns_exp_write(phydev, 0x1c0, ns_exp_read(phydev, 0x1c0) | 1);
+		ns_exp_write(phydev, 0x1c0,
+			     ns_exp_read(phydev, 0x1c0) | lb_dis);
 	else
 		ns_exp_write(phydev, 0x1c0,
-			     ns_exp_read(phydev, 0x1c0) & 0xfffe);
+			     ns_exp_read(phydev, 0x1c0) & ~lb_dis);
 
 	pr_debug("10BASE-T HDX loopback %s\n",
-		 (ns_exp_read(phydev, 0x1c0) & 0x0001) ? "off" : "on");
+		 (ns_exp_read(phydev, 0x1c0) & lb_dis) ? "off" : "on");
 }
 
 static int ns_config_init(struct phy_device *phydev)
diff --git a/drivers/net/wimax/i2400m/op-rfkill.c b/drivers/net/wimax/i2400m/op-rfkill.c
index b0dba35a8ad2..dc6fe93ce71f 100644
--- a/drivers/net/wimax/i2400m/op-rfkill.c
+++ b/drivers/net/wimax/i2400m/op-rfkill.c
@@ -147,6 +147,7 @@ int i2400m_op_rfkill_sw_toggle(struct wimax_dev *wimax_dev,
 error_alloc:
 	d_fnend(4, dev, "(wimax_dev %p state %d) = %d\n",
 		wimax_dev, state, result);
+	kfree(cmd);
 	return result;
 }
 
diff --git a/drivers/net/wireless/libertas_tf/cmd.c b/drivers/net/wireless/libertas_tf/cmd.c
index 909ac3685010..2b193f1257a5 100644
--- a/drivers/net/wireless/libertas_tf/cmd.c
+++ b/drivers/net/wireless/libertas_tf/cmd.c
@@ -69,7 +69,7 @@ static void lbtf_geo_init(struct lbtf_private *priv)
 			break;
 		}
 
-	for (ch = priv->range.start; ch < priv->range.end; ch++)
+	for (ch = range->start; ch < range->end; ch++)
 		priv->channels[CHAN_TO_IDX(ch)].flags = 0;
 }
 
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index c4e1dc70cea5..351dda2fa1ce 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -539,8 +539,11 @@ static int mwifiex_pcie_init_evt_ring(struct mwifiex_adapter *adapter)
 		skb_put(skb, MAX_EVENT_SIZE);
 
 		if (mwifiex_map_pci_memory(adapter, skb, MAX_EVENT_SIZE,
-					   PCI_DMA_FROMDEVICE))
+					   PCI_DMA_FROMDEVICE)) {
+			kfree_skb(skb);
+			kfree(card->evtbd_ring_vbase);
 			return -1;
+		}
 
 		buf_pa = MWIFIEX_SKB_DMA_ADDR(skb);
 
@@ -876,8 +879,10 @@ static int mwifiex_pcie_alloc_cmdrsp_buf(struct mwifiex_adapter *adapter)
 	}
 	skb_put(skb, MWIFIEX_UPLD_SIZE);
 	if (mwifiex_map_pci_memory(adapter, skb, MWIFIEX_UPLD_SIZE,
-				   PCI_DMA_FROMDEVICE))
+				   PCI_DMA_FROMDEVICE)) {
+		kfree_skb(skb);
 		return -1;
+	}
 
 	card->cmdrsp_buf = skb;
 
diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index 1a5d765b6af6..369965192df4 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -160,6 +160,15 @@ struct dino_device
 	(struct dino_device *)__pdata; })
 
 
+/* Check if PCI device is behind a Card-mode Dino. */
+static int pci_dev_is_behind_card_dino(struct pci_dev *dev)
+{
+	struct dino_device *dino_dev;
+
+	dino_dev = DINO_DEV(parisc_walk_tree(dev->bus->bridge));
+	return is_card_dino(&dino_dev->hba.dev->id);
+}
+
 /*
  * Dino Configuration Space Accessor Functions
  */
@@ -442,6 +451,21 @@ static void quirk_cirrus_cardbus(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_6832, quirk_cirrus_cardbus );
 
+#ifdef CONFIG_TULIP
+static void pci_fixup_tulip(struct pci_dev *dev)
+{
+	if (!pci_dev_is_behind_card_dino(dev))
+		return;
+	if (!(pci_resource_flags(dev, 1) & IORESOURCE_MEM))
+		return;
+	pr_warn("%s: HP HSC-PCI Cards with card-mode Dino not yet supported.\n",
+		pci_name(dev));
+	/* Disable this card by zeroing the PCI resources */
+	memset(&dev->resource[0], 0, sizeof(dev->resource[0]));
+	memset(&dev->resource[1], 0, sizeof(dev->resource[1]));
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_DEC, PCI_ANY_ID, pci_fixup_tulip);
+#endif /* CONFIG_TULIP */
 
 static void __init
 dino_bios_init(void)
diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index e443b0d0b236..0d59c128f734 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -369,7 +369,7 @@ int ccwgroup_create_dev(struct device *parent, struct ccwgroup_driver *gdrv,
 		goto error;
 	}
 	/* Check for trailing stuff. */
-	if (i == num_devices && strlen(buf) > 0) {
+	if (i == num_devices && buf && strlen(buf) > 0) {
 		rc = -EINVAL;
 		goto error;
 	}
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 0268e5fd59b5..5fc5e4f2d296 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -1125,6 +1125,8 @@ device_initcall(cio_settle_init);
 
 int sch_is_pseudo_sch(struct subchannel *sch)
 {
+	if (!sch->dev.parent)
+		return 0;
 	return sch == to_css(sch->dev.parent)->pseudo_subchannel;
 }
 
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 40be670a1cbc..408bba4001be 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -282,8 +282,10 @@ bfad_im_get_stats(struct Scsi_Host *shost)
 	rc = bfa_port_get_stats(BFA_FCPORT(&bfad->bfa),
 				fcstats, bfad_hcb_comp, &fcomp);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
-	if (rc != BFA_STATUS_OK)
+	if (rc != BFA_STATUS_OK) {
+		kfree(fcstats);
 		return NULL;
+	}
 
 	wait_for_completion(&fcomp.comp);
 
diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 06fbf0b0a3cb..6a06230a40e1 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -329,7 +329,8 @@ enum {
 	BINDER_LOOPER_STATE_EXITED      = 0x04,
 	BINDER_LOOPER_STATE_INVALID     = 0x08,
 	BINDER_LOOPER_STATE_WAITING     = 0x10,
-	BINDER_LOOPER_STATE_NEED_RETURN = 0x20
+	BINDER_LOOPER_STATE_NEED_RETURN = 0x20,
+	BINDER_LOOPER_STATE_POLL	= 0x40,
 };
 
 struct binder_thread {
@@ -2554,6 +2555,18 @@ static int binder_free_thread(struct binder_proc *proc,
 		} else
 			BUG();
 	}
+
+	/*
+	 * If this thread used poll, make sure we remove the waitqueue
+	 * from any epoll data structures holding it with POLLFREE.
+	 * waitqueue_active() is safe to use here because we're holding
+	 * the global lock.
+	 */
+	if ((thread->looper & BINDER_LOOPER_STATE_POLL) &&
+	    waitqueue_active(&thread->wait)) {
+		wake_up_poll(&thread->wait, POLLHUP | POLLFREE);
+	}
+
 	if (send_reply)
 		binder_send_failed_reply(send_reply, BR_DEAD_REPLY);
 	binder_release_work(&thread->todo);
@@ -2577,6 +2590,8 @@ static unsigned int binder_poll(struct file *filp,
 		return POLLERR;
 	}
 
+	thread->looper |= BINDER_LOOPER_STATE_POLL;
+
 	wait_for_proc_work = thread->transaction_stack == NULL &&
 		list_empty(&thread->todo) && thread->return_error == BR_OK;
 
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 284733e1fb6f..21b1b2c86b9f 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1625,7 +1625,7 @@ void thermal_zone_device_unregister(struct thermal_zone_device *tz)
 
 	mutex_unlock(&thermal_list_lock);
 
-	thermal_zone_device_set_polling(tz, 0);
+	cancel_delayed_work_sync(&tz->poll_queue);
 
 	if (tz->type[0])
 		device_remove_file(&tz->device, &dev_attr_type);
diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 52dfe4936a0f..872669da443e 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -886,7 +886,7 @@ int usb_get_bos_descriptor(struct usb_device *dev)
 	struct device *ddev = &dev->dev;
 	struct usb_bos_descriptor *bos;
 	struct usb_dev_cap_header *cap;
-	unsigned char *buffer;
+	unsigned char *buffer, *buffer0;
 	int length, total_len, num, i;
 	__u8 cap_type;
 	int ret;
@@ -931,10 +931,12 @@ int usb_get_bos_descriptor(struct usb_device *dev)
 			ret = -ENOMSG;
 		goto err;
 	}
+
+	buffer0 = buffer;
 	total_len -= length;
+	buffer += length;
 
 	for (i = 0; i < num; i++) {
-		buffer += length;
 		cap = (struct usb_dev_cap_header *)buffer;
 
 		if (total_len < sizeof(*cap) || total_len < cap->bLength) {
@@ -948,8 +950,6 @@ int usb_get_bos_descriptor(struct usb_device *dev)
 			break;
 		}
 
-		total_len -= length;
-
 		if (cap->bDescriptorType != USB_DT_DEVICE_CAPABILITY) {
 			dev_warn(ddev, "descriptor type invalid, skip\n");
 			continue;
@@ -974,7 +974,11 @@ int usb_get_bos_descriptor(struct usb_device *dev)
 		default:
 			break;
 		}
+
+		total_len -= length;
+		buffer += length;
 	}
+	dev->bos->desc->wTotalLength = cpu_to_le16(buffer - buffer0);
 
 	return 0;
 
diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index 5cfaf69bc62f..065db5f4b62b 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -796,19 +796,18 @@ static int adu_probe(struct usb_interface *interface,
 static void adu_disconnect(struct usb_interface *interface)
 {
 	struct adu_device *dev;
-	int minor;
 
 	dev = usb_get_intfdata(interface);
 
-	mutex_lock(&dev->mtx);	/* not interruptible */
-	dev->udev = NULL;	/* poison */
-	minor = dev->minor;
 	usb_deregister_dev(interface, &adu_class);
-	mutex_unlock(&dev->mtx);
 
 	mutex_lock(&adutux_mutex);
 	usb_set_intfdata(interface, NULL);
 
+	mutex_lock(&dev->mtx);	/* not interruptible */
+	dev->udev = NULL;	/* poison */
+	mutex_unlock(&dev->mtx);
+
 	/* if the device is not opened, then we clean up right now */
 	if (!dev->open_count)
 		adu_delete(dev);
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 5e43fd881a9c..4af9279f2cf0 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -900,8 +900,9 @@ static void iowarrior_disconnect(struct usb_interface *interface)
 	usb_set_intfdata(interface, NULL);
 
 	minor = dev->minor;
+	mutex_unlock(&iowarrior_open_disc_lock);
+	/* give back our minor - this will call close() locks need to be dropped at this point*/
 
-	/* give back our minor */
 	usb_deregister_dev(interface, &iowarrior_class);
 
 	mutex_lock(&dev->mutex);
@@ -909,9 +910,6 @@ static void iowarrior_disconnect(struct usb_interface *interface)
 	/* prevent device read, write and ioctl */
 	dev->present = 0;
 
-	mutex_unlock(&dev->mutex);
-	mutex_unlock(&iowarrior_open_disc_lock);
-
 	if (dev->opened) {
 		/* There is a process that holds a filedescriptor to the device ,
 		   so we only shutdown read-/write-ops going on.
@@ -920,8 +918,10 @@ static void iowarrior_disconnect(struct usb_interface *interface)
 		usb_kill_urb(dev->int_in_urb);
 		wake_up_interruptible(&dev->read_wait);
 		wake_up_interruptible(&dev->write_wait);
+		mutex_unlock(&dev->mutex);
 	} else {
 		/* no process is using the device, cleanup now */
+		mutex_unlock(&dev->mutex);
 		iowarrior_delete(dev);
 	}
 
diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
index f4daa59f0a80..729dd7cc9275 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -320,7 +320,10 @@ static int ssd1307fb_ssd1306_init(struct ssd1307fb_par *par)
 
 	/* Set initial contrast */
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_CONTRAST);
-	ret = ret & ssd1307fb_write_cmd(par->client, 0x7f);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client, 0x7f);
 	if (ret < 0)
 		return ret;
 
@@ -336,63 +339,99 @@ static int ssd1307fb_ssd1306_init(struct ssd1307fb_par *par)
 
 	/* Set multiplex ratio value */
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_SET_MULTIPLEX_RATIO);
-	ret = ret & ssd1307fb_write_cmd(par->client, par->height - 1);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client, par->height - 1);
 	if (ret < 0)
 		return ret;
 
 	/* set display offset value */
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_SET_DISPLAY_OFFSET);
+	if (ret < 0)
+		return ret;
+
 	ret = ssd1307fb_write_cmd(par->client, 0x20);
 	if (ret < 0)
 		return ret;
 
 	/* Set clock frequency */
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_SET_CLOCK_FREQ);
-	ret = ret & ssd1307fb_write_cmd(par->client, 0xf0);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client, 0xf0);
 	if (ret < 0)
 		return ret;
 
 	/* Set precharge period in number of ticks from the internal clock */
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_SET_PRECHARGE_PERIOD);
-	ret = ret & ssd1307fb_write_cmd(par->client, 0x22);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client, 0x22);
 	if (ret < 0)
 		return ret;
 
 	/* Set COM pins configuration */
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_SET_COM_PINS_CONFIG);
-	ret = ret & ssd1307fb_write_cmd(par->client, 0x22);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client, 0x22);
 	if (ret < 0)
 		return ret;
 
 	/* Set VCOMH */
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_SET_VCOMH);
-	ret = ret & ssd1307fb_write_cmd(par->client, 0x49);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client, 0x49);
 	if (ret < 0)
 		return ret;
 
 	/* Turn on the DC-DC Charge Pump */
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_CHARGE_PUMP);
-	ret = ret & ssd1307fb_write_cmd(par->client, 0x14);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client, 0x14);
 	if (ret < 0)
 		return ret;
 
 	/* Switch to horizontal addressing mode */
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_SET_ADDRESS_MODE);
-	ret = ret & ssd1307fb_write_cmd(par->client,
-					SSD1307FB_SET_ADDRESS_MODE_HORIZONTAL);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client,
+				  SSD1307FB_SET_ADDRESS_MODE_HORIZONTAL);
 	if (ret < 0)
 		return ret;
 
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_SET_COL_RANGE);
-	ret = ret & ssd1307fb_write_cmd(par->client, 0x0);
-	ret = ret & ssd1307fb_write_cmd(par->client, par->width - 1);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client, 0x0);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client, par->width - 1);
 	if (ret < 0)
 		return ret;
 
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_SET_PAGE_RANGE);
-	ret = ret & ssd1307fb_write_cmd(par->client, 0x0);
-	ret = ret & ssd1307fb_write_cmd(par->client,
-					par->page_offset + (par->height / 8) - 1);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client, par->page_offset);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client,
+				  par->page_offset + (par->height / 8) - 1);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/video/of_display_timing.c b/drivers/video/of_display_timing.c
index 987edf110038..5e2aeda42463 100644
--- a/drivers/video/of_display_timing.c
+++ b/drivers/video/of_display_timing.c
@@ -114,6 +114,7 @@ int of_get_display_timing(struct device_node *np, const char *name,
 		struct display_timing *dt)
 {
 	struct device_node *timing_np;
+	int ret;
 
 	if (!np)
 		return -EINVAL;
@@ -125,7 +126,11 @@ int of_get_display_timing(struct device_node *np, const char *name,
 		return -ENOENT;
 	}
 
-	return of_parse_display_timing(timing_np, dt);
+	ret = of_parse_display_timing(timing_np, dt);
+
+	of_node_put(timing_np);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(of_get_display_timing);
 
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index ccfeca9105be..8c65bac0c8a2 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1411,6 +1411,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 	struct tree_mod_elem *tm;
 	struct extent_buffer *eb = NULL;
 	struct extent_buffer *eb_root;
+	u64 eb_root_owner = 0;
 	struct extent_buffer *old;
 	struct tree_mod_root *old_root = NULL;
 	u64 old_generation = 0;
@@ -1445,6 +1446,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 			free_extent_buffer(old);
 		}
 	} else if (old_root) {
+		eb_root_owner = btrfs_header_owner(eb_root);
 		btrfs_tree_read_unlock(eb_root);
 		free_extent_buffer(eb_root);
 		eb = alloc_dummy_extent_buffer(logical, root->nodesize);
@@ -1462,7 +1464,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 	if (old_root) {
 		btrfs_set_header_bytenr(eb, eb->start);
 		btrfs_set_header_backref_rev(eb, BTRFS_MIXED_BACKREF_REV);
-		btrfs_set_header_owner(eb, btrfs_header_owner(eb_root));
+		btrfs_set_header_owner(eb, eb_root_owner);
 		btrfs_set_header_level(eb, old_root->level);
 		btrfs_set_header_generation(eb, old_generation);
 	}
@@ -5444,6 +5446,7 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 	advance_left = advance_right = 0;
 
 	while (1) {
+		cond_resched();
 		if (advance_left && !left_end_reached) {
 			ret = tree_advance(left_root, left_path, &left_level,
 					left_root_level,
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 3e573192ac4e..e2e4e0acbf51 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1006,6 +1006,11 @@ smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
 	if (oplock == SMB2_OPLOCK_LEVEL_NOCHANGE)
 		return;
 
+	/* Check if the server granted an oplock rather than a lease */
+	if (oplock & SMB2_OPLOCK_LEVEL_EXCLUSIVE)
+		return smb2_set_oplock_level(cinode, oplock, epoch,
+					     purge_cache);
+
 	if (oplock & SMB2_LEASE_READ_CACHING_HE) {
 		new_oplock |= CIFS_CACHE_READ_FLG;
 		strcat(message, "R");
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 5ac836a86b18..16dc931ea787 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -29,7 +29,7 @@
 #include "cifsproto.h"
 #include "cifs_debug.h"
 
-#define MAX_EA_VALUE_SIZE 65535
+#define MAX_EA_VALUE_SIZE CIFSMaxBufSize
 #define CIFS_XATTR_DOS_ATTRIB "user.DosAttrib"
 #define CIFS_XATTR_CIFS_ACL "system.cifs_acl"
 
diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index 52fc4e25a7cb..28a551c6d994 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -157,11 +157,42 @@ int configfs_symlink(struct inode *dir, struct dentry *dentry, const char *symna
 	    !type->ct_item_ops->allow_link)
 		goto out_put;
 
+	/*
+	 * This is really sick.  What they wanted was a hybrid of
+	 * link(2) and symlink(2) - they wanted the target resolved
+	 * at syscall time (as link(2) would've done), be a directory
+	 * (which link(2) would've refused to do) *AND* be a deep
+	 * fucking magic, making the target busy from rmdir POV.
+	 * symlink(2) is nothing of that sort, and the locking it
+	 * gets matches the normal symlink(2) semantics.  Without
+	 * attempts to resolve the target (which might very well
+	 * not even exist yet) done prior to locking the parent
+	 * directory.  This perversion, OTOH, needs to resolve
+	 * the target, which would lead to obvious deadlocks if
+	 * attempted with any directories locked.
+	 *
+	 * Unfortunately, that garbage is userland ABI and we should've
+	 * said "no" back in 2005.  Too late now, so we get to
+	 * play very ugly games with locking.
+	 *
+	 * Try *ANYTHING* of that sort in new code, and you will
+	 * really regret it.  Just ask yourself - what could a BOFH
+	 * do to me and do I want to find it out first-hand?
+	 *
+	 *  AV, a thoroughly annoyed bastard.
+	 */
+	mutex_unlock(&dir->i_mutex);
 	ret = get_target(symname, &path, &target_item, dentry->d_sb);
+	mutex_lock(&dir->i_mutex);
 	if (ret)
 		goto out_put;
 
-	ret = type->ct_item_ops->allow_link(parent_item, target_item);
+	if (dentry->d_inode || d_unhashed(dentry))
+		ret = -EEXIST;
+	else
+		ret = inode_permission(dir, MAY_WRITE | MAY_EXEC);
+	if (!ret)
+		ret = type->ct_item_ops->allow_link(parent_item, target_item);
 	if (!ret) {
 		mutex_lock(&configfs_symlink_mutex);
 		ret = create_link(parent_item, target_item, dentry);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3bb1153827d8..25620fc51bf3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3775,8 +3775,8 @@ static int ext4_convert_unwritten_extents_endio(handle_t *handle,
 	 * illegal.
 	 */
 	if (ee_block != map->m_lblk || ee_len > map->m_len) {
-#ifdef EXT4_DEBUG
-		ext4_warning("Inode (%ld) finished: extent logical block %llu,"
+#ifdef CONFIG_EXT4_DEBUG
+		ext4_warning(inode->i_sb, "Inode (%ld) finished: extent logical block %llu,"
 			     " len %u; IO logical block %llu, len %u\n",
 			     inode->i_ino, (unsigned long long)ee_block, ee_len,
 			     (unsigned long long)map->m_lblk, map->m_len);
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index c2bb71c98d43..7141a1000464 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1404,7 +1404,7 @@ int htree_inlinedir_to_tree(struct file *dir_file,
 		err = ext4_htree_store_dirent(dir_file,
 				   hinfo->hash, hinfo->minor_hash, de);
 		if (err) {
-			count = err;
+			ret = err;
 			goto out;
 		}
 		count++;
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 43dd3ef4625a..a683fcd16b05 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1767,6 +1767,7 @@ static int fuse_writepage(struct page *page, struct writeback_control *wbc)
 		WARN_ON(wbc->sync_mode == WB_SYNC_ALL);
 
 		redirty_page_for_writepage(wbc, page);
+		unlock_page(page);
 		return 0;
 	}
 
diff --git a/include/linux/atalk.h b/include/linux/atalk.h
index af43ed404ff4..4be0e14b38fc 100644
--- a/include/linux/atalk.h
+++ b/include/linux/atalk.h
@@ -107,7 +107,7 @@ static __inline__ struct elapaarp *aarp_hdr(struct sk_buff *skb)
 #define AARP_RESOLVE_TIME	(10 * HZ)
 
 extern struct datalink_proto *ddp_dl, *aarp_dl;
-extern void aarp_proto_init(void);
+extern int aarp_proto_init(void);
 
 /* Inter module exports */
 
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 75d17e15da33..579cd7317182 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2358,4 +2358,57 @@ static inline bool ieee80211_check_tim(const struct ieee80211_tim_ie *tim,
 #define TU_TO_JIFFIES(x)	(usecs_to_jiffies((x) * 1024))
 #define TU_TO_EXP_TIME(x)	(jiffies + TU_TO_JIFFIES(x))
 
+struct element {
+	u8 id;
+	u8 datalen;
+	u8 data[];
+};
+
+/* element iteration helpers */
+#define for_each_element(element, _data, _datalen)			\
+	for (element = (void *)(_data);					\
+	     (u8 *)(_data) + (_datalen) - (u8 *)element >=		\
+		sizeof(*element) &&					\
+	     (u8 *)(_data) + (_datalen) - (u8 *)element >=		\
+		sizeof(*element) + element->datalen;			\
+	     element = (void *)(element->data + element->datalen))
+
+#define for_each_element_id(element, _id, data, datalen)		\
+	for_each_element(element, data, datalen)			\
+		if (element->id == (_id))
+
+#define for_each_element_extid(element, extid, data, datalen)		\
+	for_each_element(element, data, datalen)			\
+		if (element->id == WLAN_EID_EXTENSION &&		\
+		    element->datalen > 0 &&				\
+		    element->data[0] == (extid))
+
+#define for_each_subelement(sub, element)				\
+	for_each_element(sub, (element)->data, (element)->datalen)
+
+#define for_each_subelement_id(sub, id, element)			\
+	for_each_element_id(sub, id, (element)->data, (element)->datalen)
+
+#define for_each_subelement_extid(sub, extid, element)			\
+	for_each_element_extid(sub, extid, (element)->data, (element)->datalen)
+
+/**
+ * for_each_element_completed - determine if element parsing consumed all data
+ * @element: element pointer after for_each_element() or friends
+ * @data: same data pointer as passed to for_each_element() or friends
+ * @datalen: same data length as passed to for_each_element() or friends
+ *
+ * This function returns %true if all the data was parsed or considered
+ * while walking the elements. Only use this if your for_each_element()
+ * loop cannot be broken out of, otherwise it always returns %false.
+ *
+ * If some data was malformed, this returns %false since the last parsed
+ * element will not fill the whole remaining data.
+ */
+static inline bool for_each_element_completed(const struct element *element,
+					      const void *data, size_t datalen)
+{
+	return (u8 *)element == (u8 *)data + datalen;
+}
+
 #endif /* LINUX_IEEE80211_H */
diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index f7c0a020518b..7d7f088a4a72 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -329,6 +329,8 @@ struct device;
 #define SND_SOC_DAPM_WILL_PMD   0x80    /* called at start of sequence */
 #define SND_SOC_DAPM_PRE_POST_PMD \
 				(SND_SOC_DAPM_PRE_PMD | SND_SOC_DAPM_POST_PMD)
+#define SND_SOC_DAPM_PRE_POST_PMU \
+				(SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMU)
 
 /* convenience event type detection */
 #define SND_SOC_DAPM_EVENT_ON(e)	\
diff --git a/net/appletalk/aarp.c b/net/appletalk/aarp.c
index d1c55d8dd0a2..6d6fcc451d73 100644
--- a/net/appletalk/aarp.c
+++ b/net/appletalk/aarp.c
@@ -879,15 +879,24 @@ static struct notifier_block aarp_notifier = {
 
 static unsigned char aarp_snap_id[] = { 0x00, 0x00, 0x00, 0x80, 0xF3 };
 
-void __init aarp_proto_init(void)
+int __init aarp_proto_init(void)
 {
+	int rc;
+
 	aarp_dl = register_snap_client(aarp_snap_id, aarp_rcv);
-	if (!aarp_dl)
+	if (!aarp_dl) {
 		printk(KERN_CRIT "Unable to register AARP with SNAP.\n");
+		return -ENOMEM;
+	}
 	setup_timer(&aarp_timer, aarp_expire_timeout, 0);
 	aarp_timer.expires  = jiffies + sysctl_aarp_expiry_time;
 	add_timer(&aarp_timer);
-	register_netdevice_notifier(&aarp_notifier);
+	rc = register_netdevice_notifier(&aarp_notifier);
+	if (rc) {
+		del_timer_sync(&aarp_timer);
+		unregister_snap_client(aarp_dl);
+	}
+	return rc;
 }
 
 /* Remove the AARP entries associated with a device. */
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index d1ac3818a37b..c91946ef2180 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1912,9 +1912,6 @@ static unsigned char ddp_snap_id[] = { 0x08, 0x00, 0x07, 0x80, 0x9B };
 EXPORT_SYMBOL(atrtr_get_dev);
 EXPORT_SYMBOL(atalk_find_dev_addr);
 
-static const char atalk_err_snap[] __initconst =
-	KERN_CRIT "Unable to register DDP with SNAP.\n";
-
 /* Called by proto.c on kernel start up */
 static int __init atalk_init(void)
 {
@@ -1929,17 +1926,23 @@ static int __init atalk_init(void)
 		goto out_proto;
 
 	ddp_dl = register_snap_client(ddp_snap_id, atalk_rcv);
-	if (!ddp_dl)
-		printk(atalk_err_snap);
+	if (!ddp_dl) {
+		pr_crit("Unable to register DDP with SNAP.\n");
+		rc = -ENOMEM;
+		goto out_sock;
+	}
 
 	dev_add_pack(&ltalk_packet_type);
 	dev_add_pack(&ppptalk_packet_type);
 
 	rc = register_netdevice_notifier(&ddp_notifier);
 	if (rc)
-		goto out_sock;
+		goto out_snap;
+
+	rc = aarp_proto_init();
+	if (rc)
+		goto out_dev;
 
-	aarp_proto_init();
 	rc = atalk_proc_init();
 	if (rc)
 		goto out_aarp;
@@ -1953,11 +1956,13 @@ static int __init atalk_init(void)
 	atalk_proc_exit();
 out_aarp:
 	aarp_cleanup_module();
+out_dev:
 	unregister_netdevice_notifier(&ddp_notifier);
-out_sock:
+out_snap:
 	dev_remove_pack(&ppptalk_packet_type);
 	dev_remove_pack(&ltalk_packet_type);
 	unregister_snap_client(ddp_dl);
+out_sock:
 	sock_unregister(PF_APPLETALK);
 out_proto:
 	proto_unregister(&ddp_proto);
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index ab8263d97c5b..95df63bca928 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -737,7 +737,7 @@ static int get_dist_table(struct Qdisc *sch, const struct nlattr *attr)
 	int i;
 	size_t s;
 
-	if (n > NETEM_DIST_MAX)
+	if (!n || n > NETEM_DIST_MAX)
 		return -EINVAL;
 
 	s = sizeof(struct disttable) + n * sizeof(s16);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 105fdd8589d7..d82d35aec0ee 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -208,6 +208,36 @@ cfg80211_get_dev_from_info(struct net *netns, struct genl_info *info)
 	return __cfg80211_rdev_from_attrs(netns, info->attrs);
 }
 
+static int validate_beacon_head(const struct nlattr *attr)
+{
+	const u8 *data = nla_data(attr);
+	unsigned int len = nla_len(attr);
+	const struct element *elem;
+	const struct ieee80211_mgmt *mgmt = (void *)data;
+	unsigned int fixedlen = offsetof(struct ieee80211_mgmt,
+					 u.beacon.variable);
+
+	if (len < fixedlen)
+		goto err;
+
+	if (ieee80211_hdrlen(mgmt->frame_control) !=
+	    offsetof(struct ieee80211_mgmt, u.beacon))
+		goto err;
+
+	data += fixedlen;
+	len -= fixedlen;
+
+	for_each_element(elem, data, len) {
+		/* nothing */
+	}
+
+	if (for_each_element_completed(elem, data, len))
+		return 0;
+
+err:
+	return -EINVAL;
+}
+
 /* policy for the attributes */
 static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
@@ -3125,6 +3155,11 @@ static int nl80211_parse_beacon(struct nlattr *attrs[],
 	memset(bcn, 0, sizeof(*bcn));
 
 	if (attrs[NL80211_ATTR_BEACON_HEAD]) {
+		int ret = validate_beacon_head(attrs[NL80211_ATTR_BEACON_HEAD]);
+
+		if (ret)
+			return ret;
+
 		bcn->head = nla_data(attrs[NL80211_ATTR_BEACON_HEAD]);
 		bcn->head_len = nla_len(attrs[NL80211_ATTR_BEACON_HEAD]);
 		if (!bcn->head_len)
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 8b435bfc225f..2d8e3d82ad74 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -926,6 +926,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		}
 
 		cfg80211_process_rdev_events(rdev);
+		cfg80211_mlme_purge_registrations(dev->ieee80211_ptr);
 	}
 
 	err = rdev_change_virtual_intf(rdev, dev, ntype, flags, params);
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index c062e9467b62..f5ef20e8fddf 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -430,7 +430,7 @@ char *smk_parse_smack(const char *string, int len)
 	if (i == 0 || i >= SMK_LONGLABEL)
 		return NULL;
 
-	smack = kzalloc(i + 1, GFP_KERNEL);
+	smack = kzalloc(i + 1, GFP_NOFS);
 	if (smack != NULL) {
 		strncpy(smack, string, i + 1);
 		smack[i] = '\0';
@@ -502,7 +502,7 @@ struct smack_known *smk_import_entry(const char *string, int len)
 	if (skp != NULL)
 		goto freeout;
 
-	skp = kzalloc(sizeof(*skp), GFP_KERNEL);
+	skp = kzalloc(sizeof(*skp), GFP_NOFS);
 	if (skp == NULL)
 		goto freeout;
 
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index a6a3482e4d7e..b4043b7c144a 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -70,7 +70,7 @@ static struct smack_known *smk_fetch(const char *name, struct inode *ip,
 	if (ip->i_op->getxattr == NULL)
 		return NULL;
 
-	buffer = kzalloc(SMK_LONGLABEL, GFP_KERNEL);
+	buffer = kzalloc(SMK_LONGLABEL, GFP_NOFS);
 	if (buffer == NULL)
 		return NULL;
 
@@ -553,7 +553,8 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
 
 		if (rc != 0)
 			return rc;
-	} else if (bprm->unsafe)
+	}
+	if (bprm->unsafe & ~(LSM_UNSAFE_PTRACE | LSM_UNSAFE_PTRACE_CAP))
 		return -EPERM;
 
 	bsp->smk_task = isp->smk_task;
diff --git a/sound/aoa/codecs/onyx.c b/sound/aoa/codecs/onyx.c
index 401107b85d30..01678e989ebb 100644
--- a/sound/aoa/codecs/onyx.c
+++ b/sound/aoa/codecs/onyx.c
@@ -74,8 +74,10 @@ static int onyx_read_register(struct onyx *onyx, u8 reg, u8 *value)
 		return 0;
 	}
 	v = i2c_smbus_read_byte_data(onyx->i2c, reg);
-	if (v < 0)
+	if (v < 0) {
+		*value = 0;
 		return -1;
+	}
 	*value = (u8)v;
 	onyx->cache[ONYX_REG_CONTROL-FIRSTREGISTER] = *value;
 	return 0;
diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index 4714ff92f15e..66a40b1f2356 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -332,6 +332,7 @@ static const struct hda_fixup ad1986a_fixups[] = {
 
 static const struct snd_pci_quirk ad1986a_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x30af, "HP B2800", AD1986A_FIXUP_LAPTOP_IMIC),
+	SND_PCI_QUIRK(0x1043, 0x1153, "ASUS M9V", AD1986A_FIXUP_LAPTOP_IMIC),
 	SND_PCI_QUIRK(0x1043, 0x1443, "ASUS Z99He", AD1986A_FIXUP_EAPD),
 	SND_PCI_QUIRK(0x1043, 0x1447, "ASUS A8JN", AD1986A_FIXUP_EAPD),
 	SND_PCI_QUIRK_MASK(0x1043, 0xff00, 0x8100, "ASUS P5", AD1986A_FIXUP_3STACK),
diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 31281d24e009..41aad8bdf578 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -34,6 +34,13 @@
 #define SGTL5000_DAP_REG_OFFSET	0x0100
 #define SGTL5000_MAX_REG_OFFSET	0x013A
 
+/* Delay for the VAG ramp up */
+#define SGTL5000_VAG_POWERUP_DELAY 500 /* ms */
+/* Delay for the VAG ramp down */
+#define SGTL5000_VAG_POWERDOWN_DELAY 500 /* ms */
+
+#define SGTL5000_OUTPUTS_MUTE (SGTL5000_HP_MUTE | SGTL5000_LINE_OUT_MUTE)
+
 /* default value of sgtl5000 registers */
 static const struct reg_default sgtl5000_reg_defaults[] = {
 	{ SGTL5000_CHIP_DIG_POWER,		0x0000 },
@@ -121,6 +128,13 @@ struct ldo_regulator {
 	bool enabled;
 };
 
+enum {
+	HP_POWER_EVENT,
+	DAC_POWER_EVENT,
+	ADC_POWER_EVENT,
+	LAST_POWER_EVENT = ADC_POWER_EVENT
+};
+
 /* sgtl5000 private structure in codec */
 struct sgtl5000_priv {
 	int sysclk;	/* sysclk rate */
@@ -131,8 +145,107 @@ struct sgtl5000_priv {
 	struct regmap *regmap;
 	struct clk *mclk;
 	int revision;
+	u16 mute_state[LAST_POWER_EVENT + 1];
 };
 
+static inline int hp_sel_input(struct snd_soc_codec *codec)
+{
+	return (snd_soc_read(codec, SGTL5000_CHIP_ANA_CTRL) &
+		SGTL5000_HP_SEL_MASK) >> SGTL5000_HP_SEL_SHIFT;
+}
+
+static inline u16 mute_output(struct snd_soc_codec *codec,
+			      u16 mute_mask)
+{
+	u16 mute_reg = snd_soc_read(codec, SGTL5000_CHIP_ANA_CTRL);
+
+	snd_soc_update_bits(codec, SGTL5000_CHIP_ANA_CTRL,
+			    mute_mask, mute_mask);
+	return mute_reg;
+}
+
+static inline void restore_output(struct snd_soc_codec *codec,
+				  u16 mute_mask, u16 mute_reg)
+{
+	snd_soc_update_bits(codec, SGTL5000_CHIP_ANA_CTRL,
+		mute_mask, mute_reg);
+}
+
+static void vag_power_on(struct snd_soc_codec *codec, u32 source)
+{
+	if (snd_soc_read(codec, SGTL5000_CHIP_ANA_POWER) &
+	    SGTL5000_VAG_POWERUP)
+		return;
+
+	snd_soc_update_bits(codec, SGTL5000_CHIP_ANA_POWER,
+			    SGTL5000_VAG_POWERUP, SGTL5000_VAG_POWERUP);
+
+	/* When VAG powering on to get local loop from Line-In, the sleep
+	 * is required to avoid loud pop.
+	 */
+	if (hp_sel_input(codec) == SGTL5000_HP_SEL_LINE_IN &&
+	    source == HP_POWER_EVENT)
+		msleep(SGTL5000_VAG_POWERUP_DELAY);
+}
+
+static int vag_power_consumers(struct snd_soc_codec *codec,
+			       u16 ana_pwr_reg, u32 source)
+{
+	int consumers = 0;
+
+	/* count dac/adc consumers unconditional */
+	if (ana_pwr_reg & SGTL5000_DAC_POWERUP)
+		consumers++;
+	if (ana_pwr_reg & SGTL5000_ADC_POWERUP)
+		consumers++;
+
+	/*
+	 * If the event comes from HP and Line-In is selected,
+	 * current action is 'DAC to be powered down'.
+	 * As HP_POWERUP is not set when HP muxed to line-in,
+	 * we need to keep VAG power ON.
+	 */
+	if (source == HP_POWER_EVENT) {
+		if (hp_sel_input(codec) == SGTL5000_HP_SEL_LINE_IN)
+			consumers++;
+	} else {
+		if (ana_pwr_reg & SGTL5000_HP_POWERUP)
+			consumers++;
+	}
+
+	return consumers;
+}
+
+static void vag_power_off(struct snd_soc_codec *codec, u32 source)
+{
+	u16 ana_pwr = snd_soc_read(codec, SGTL5000_CHIP_ANA_POWER);
+
+	if (!(ana_pwr & SGTL5000_VAG_POWERUP))
+		return;
+
+	/*
+	 * This function calls when any of VAG power consumers is disappearing.
+	 * Thus, if there is more than one consumer at the moment, as minimum
+	 * one consumer will definitely stay after the end of the current
+	 * event.
+	 * Don't clear VAG_POWERUP if 2 or more consumers of VAG present:
+	 * - LINE_IN (for HP events) / HP (for DAC/ADC events)
+	 * - DAC
+	 * - ADC
+	 * (the current consumer is disappearing right now)
+	 */
+	if (vag_power_consumers(codec, ana_pwr, source) >= 2)
+		return;
+
+	snd_soc_update_bits(codec, SGTL5000_CHIP_ANA_POWER,
+		SGTL5000_VAG_POWERUP, 0);
+	/* In power down case, we need wait 400-1000 ms
+	 * when VAG fully ramped down.
+	 * As longer we wait, as smaller pop we've got.
+	 */
+	msleep(SGTL5000_VAG_POWERDOWN_DELAY);
+}
+
 /*
  * mic_bias power on/off share the same register bits with
  * output impedance of mic bias, when power on mic bias, we
@@ -161,34 +274,45 @@ static int mic_bias_event(struct snd_soc_dapm_widget *w,
 	return 0;
 }
 
-/*
- * As manual described, ADC/DAC only works when VAG powerup,
- * So enabled VAG before ADC/DAC up.
- * In power down case, we need wait 400ms when vag fully ramped down.
- */
-static int power_vag_event(struct snd_soc_dapm_widget *w,
-	struct snd_kcontrol *kcontrol, int event)
+static int vag_and_mute_control(struct snd_soc_codec *codec,
+				 int event, int event_source)
 {
-	const u32 mask = SGTL5000_DAC_POWERUP | SGTL5000_ADC_POWERUP;
+	static const u16 mute_mask[] = {
+		/*
+		 * Mask for HP_POWER_EVENT.
+		 * Muxing Headphones have to be wrapped with mute/unmute
+		 * headphones only.
+		 */
+		SGTL5000_HP_MUTE,
+		/*
+		 * Masks for DAC_POWER_EVENT/ADC_POWER_EVENT.
+		 * Muxing DAC or ADC block have to wrapped with mute/unmute
+		 * both headphones and line-out.
+		 */
+		SGTL5000_OUTPUTS_MUTE,
+		SGTL5000_OUTPUTS_MUTE
+	};
+
+	struct sgtl5000_priv *sgtl5000 = snd_soc_codec_get_drvdata(codec);
 
 	switch (event) {
+	case SND_SOC_DAPM_PRE_PMU:
+		sgtl5000->mute_state[event_source] =
+			mute_output(codec, mute_mask[event_source]);
+		break;
 	case SND_SOC_DAPM_POST_PMU:
-		snd_soc_update_bits(w->codec, SGTL5000_CHIP_ANA_POWER,
-			SGTL5000_VAG_POWERUP, SGTL5000_VAG_POWERUP);
+		vag_power_on(codec, event_source);
+		restore_output(codec, mute_mask[event_source],
+			       sgtl5000->mute_state[event_source]);
 		break;
-
 	case SND_SOC_DAPM_PRE_PMD:
-		/*
-		 * Don't clear VAG_POWERUP, when both DAC and ADC are
-		 * operational to prevent inadvertently starving the
-		 * other one of them.
-		 */
-		if ((snd_soc_read(w->codec, SGTL5000_CHIP_ANA_POWER) &
-				mask) != mask) {
-			snd_soc_update_bits(w->codec, SGTL5000_CHIP_ANA_POWER,
-				SGTL5000_VAG_POWERUP, 0);
-			msleep(400);
-		}
+		sgtl5000->mute_state[event_source] =
+			mute_output(codec, mute_mask[event_source]);
+		vag_power_off(codec, event_source);
+		break;
+	case SND_SOC_DAPM_POST_PMD:
+		restore_output(codec, mute_mask[event_source],
+			       sgtl5000->mute_state[event_source]);
 		break;
 	default:
 		break;
@@ -197,6 +321,38 @@ static int power_vag_event(struct snd_soc_dapm_widget *w,
 	return 0;
 }
 
+/*
+ * Mute Headphone when power it up/down.
+ * Control VAG power on HP power path.
+ */
+static int headphone_pga_event(struct snd_soc_dapm_widget *w,
+	struct snd_kcontrol *kcontrol, int event)
+{
+	struct snd_soc_codec *codec = snd_soc_dapm_to_codec(w->dapm);
+
+	return vag_and_mute_control(codec, event, HP_POWER_EVENT);
+}
+
+/* As manual describes, ADC/DAC powering up/down requires
+ * to mute outputs to avoid pops.
+ * Control VAG power on ADC/DAC power path.
+ */
+static int adc_updown_depop(struct snd_soc_dapm_widget *w,
+	struct snd_kcontrol *kcontrol, int event)
+{
+	struct snd_soc_codec *codec = snd_soc_dapm_to_codec(w->dapm);
+
+	return vag_and_mute_control(codec, event, ADC_POWER_EVENT);
+}
+
+static int dac_updown_depop(struct snd_soc_dapm_widget *w,
+	struct snd_kcontrol *kcontrol, int event)
+{
+	struct snd_soc_codec *codec = snd_soc_dapm_to_codec(w->dapm);
+
+	return vag_and_mute_control(codec, event, DAC_POWER_EVENT);
+}
+
 /* input sources for ADC */
 static const char *adc_mux_text[] = {
 	"MIC_IN", "LINE_IN"
@@ -232,7 +388,10 @@ static const struct snd_soc_dapm_widget sgtl5000_dapm_widgets[] = {
 			    mic_bias_event,
 			    SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD),
 
-	SND_SOC_DAPM_PGA("HP", SGTL5000_CHIP_ANA_POWER, 4, 0, NULL, 0),
+	SND_SOC_DAPM_PGA_E("HP", SGTL5000_CHIP_ANA_POWER, 4, 0, NULL, 0,
+			   headphone_pga_event,
+			   SND_SOC_DAPM_PRE_POST_PMU |
+			   SND_SOC_DAPM_PRE_POST_PMD),
 	SND_SOC_DAPM_PGA("LO", SGTL5000_CHIP_ANA_POWER, 0, 0, NULL, 0),
 
 	SND_SOC_DAPM_MUX("Capture Mux", SND_SOC_NOPM, 0, 0, &adc_mux),
@@ -248,11 +407,12 @@ static const struct snd_soc_dapm_widget sgtl5000_dapm_widgets[] = {
 				0, SGTL5000_CHIP_DIG_POWER,
 				1, 0),
 
-	SND_SOC_DAPM_ADC("ADC", "Capture", SGTL5000_CHIP_ANA_POWER, 1, 0),
-	SND_SOC_DAPM_DAC("DAC", "Playback", SGTL5000_CHIP_ANA_POWER, 3, 0),
-
-	SND_SOC_DAPM_PRE("VAG_POWER_PRE", power_vag_event),
-	SND_SOC_DAPM_POST("VAG_POWER_POST", power_vag_event),
+	SND_SOC_DAPM_ADC_E("ADC", "Capture", SGTL5000_CHIP_ANA_POWER, 1, 0,
+			   adc_updown_depop, SND_SOC_DAPM_PRE_POST_PMU |
+			   SND_SOC_DAPM_PRE_POST_PMD),
+	SND_SOC_DAPM_DAC_E("DAC", "Playback", SGTL5000_CHIP_ANA_POWER, 3, 0,
+			   dac_updown_depop, SND_SOC_DAPM_PRE_POST_PMU |
+			   SND_SOC_DAPM_PRE_POST_PMD),
 };
 
 /* routes for sgtl5000 */

--pf9I7BMVVzbSWLtt--
