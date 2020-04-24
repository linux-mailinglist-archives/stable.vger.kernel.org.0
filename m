Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873231B705F
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 11:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgDXJOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 05:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbgDXJOH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 05:14:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E23A420724;
        Fri, 24 Apr 2020 09:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587719645;
        bh=b042syBUH4LxxCp9b9MbSRmkkkXF5Qk4mfXZoMU3428=;
        h=Date:From:To:Cc:Subject:From;
        b=YBTbNrm8wj2A/XMjkg8WWJa9fXx1WtrJsbfaeP+J/VRWWZWV46V1wPJNjuAR9bjZS
         V4Au1dPWuwJl59qa0h56A5uGON2+IwKL/ndGUBlJKXo9oNwpd6oUGI8CSEyplVRXeA
         /7pLDMSfmaCsMwowV4rS9ahAYuSdVBD8n6rOMkQ0=
Date:   Fri, 24 Apr 2020 11:14:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.220
Message-ID: <20200424091403.GA359552@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.220 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                              |    2=20
 arch/arm64/kernel/armv8_deprecated.c                  |    2=20
 arch/arm64/kernel/cpu_errata.c                        |    2=20
 arch/mips/cavium-octeon/octeon-irq.c                  |    3=20
 arch/powerpc/kernel/signal_64.c                       |    4=20
 arch/powerpc/mm/tlb_nohash_low.S                      |   12 ++
 arch/powerpc/platforms/maple/setup.c                  |   34 +++----
 arch/s390/kernel/diag.c                               |    2=20
 arch/s390/kernel/processor.c                          |    5 -
 arch/s390/kvm/vsie.c                                  |    1=20
 arch/s390/mm/gmap.c                                   |    7 +
 arch/x86/boot/compressed/head_32.S                    |    2=20
 arch/x86/boot/compressed/head_64.S                    |    4=20
 arch/x86/entry/entry_32.S                             |    1=20
 arch/x86/include/asm/microcode_intel.h                |    2=20
 arch/x86/include/asm/processor.h                      |   18 ++++
 arch/x86/include/asm/vgtod.h                          |    2=20
 arch/x86/kernel/acpi/boot.c                           |    2=20
 arch/x86/kvm/cpuid.c                                  |    3=20
 arch/x86/kvm/vmx.c                                    |   79 +++++--------=
-----
 arch/x86/kvm/x86.c                                    |   11 ++
 drivers/ata/libata-pmp.c                              |    1=20
 drivers/ata/libata-scsi.c                             |    9 --
 drivers/bus/sunxi-rsb.c                               |    2=20
 drivers/char/ipmi/ipmi_msghandler.c                   |    4=20
 drivers/clk/at91/clk-usb.c                            |    3=20
 drivers/clk/tegra/clk-tegra-pmc.c                     |   12 +-
 drivers/cpufreq/powernv-cpufreq.c                     |    6 +
 drivers/crypto/mxs-dcp.c                              |   58 ++++++-------
 drivers/gpio/gpiolib.c                                |   31 +------
 drivers/gpu/drm/drm_dp_mst_topology.c                 |   15 ++-
 drivers/gpu/drm/drm_pci.c                             |   25 -----
 drivers/i2c/busses/i2c-st.c                           |    1=20
 drivers/input/serio/i8042-x86ia64io.h                 |   11 ++
 drivers/iommu/amd_iommu_types.h                       |    2=20
 drivers/irqchip/irq-versatile-fpga.c                  |   18 ++--
 drivers/md/dm-flakey.c                                |    5 +
 drivers/md/dm-verity-fec.c                            |    1=20
 drivers/media/platform/ti-vpe/cal.c                   |   16 +--
 drivers/mfd/dln2.c                                    |    9 +-
 drivers/mfd/rts5227.c                                 |    1=20
 drivers/misc/echo/echo.c                              |    2=20
 drivers/mtd/devices/phram.c                           |   15 ++-
 drivers/mtd/lpddr/lpddr_cmds.c                        |    1=20
 drivers/net/ethernet/neterion/vxge/vxge-config.h      |    2=20
 drivers/net/ethernet/neterion/vxge/vxge-main.h        |   14 +--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c |    2=20
 drivers/net/wireless/ath/ath9k/main.c                 |    3=20
 drivers/net/wireless/ath/wil6210/debugfs.c            |    7 -
 drivers/net/wireless/ath/wil6210/interrupt.c          |   22 ++++-
 drivers/net/wireless/ath/wil6210/main.c               |    2=20
 drivers/net/wireless/ath/wil6210/txrx.c               |    4=20
 drivers/net/wireless/ath/wil6210/wmi.c                |    2=20
 drivers/net/wireless/mac80211_hwsim.c                 |   12 +-
 drivers/nvdimm/bus.c                                  |    6 -
 drivers/of/base.c                                     |    3=20
 drivers/of/unittest.c                                 |    7 +
 drivers/power/supply/bq27xxx_battery.c                |    5 -
 drivers/rtc/rtc-omap.c                                |    4=20
 drivers/rtc/rtc-pm8xxx.c                              |   49 ++++++++---
 drivers/s390/scsi/zfcp_erp.c                          |    2=20
 drivers/scsi/sg.c                                     |    4=20
 drivers/scsi/ufs/ufs-qcom.c                           |    2=20
 drivers/scsi/ufs/ufshcd.c                             |   32 +++++--
 drivers/soc/qcom/smem.c                               |    2=20
 drivers/target/iscsi/iscsi_target.c                   |   79 +++++--------=
-----
 drivers/target/iscsi/iscsi_target.h                   |    1=20
 drivers/target/iscsi/iscsi_target_configfs.c          |    5 -
 drivers/target/iscsi/iscsi_target_login.c             |    5 -
 drivers/tty/ehv_bytechan.c                            |   21 ++++
 drivers/usb/gadget/composite.c                        |    9 ++
 drivers/usb/gadget/function/f_fs.c                    |    1=20
 drivers/video/fbdev/core/fbmem.c                      |    2=20
 drivers/video/fbdev/sis/init301.c                     |    4=20
 fs/btrfs/async-thread.c                               |    8 +
 fs/btrfs/async-thread.h                               |    2=20
 fs/btrfs/disk-io.c                                    |   13 ++
 fs/btrfs/relocation.c                                 |   39 +++++---
 fs/exec.c                                             |    2=20
 fs/ext2/xattr.c                                       |    8 -
 fs/ext4/extents.c                                     |    8 -
 fs/ext4/inode.c                                       |    2=20
 fs/ext4/super.c                                       |    9 +-
 fs/gfs2/glock.c                                       |    3=20
 fs/hfsplus/attributes.c                               |    4=20
 fs/jbd2/commit.c                                      |    7 -
 fs/nfs/direct.c                                       |    2=20
 fs/nfs/pagelist.c                                     |   17 +--
 fs/ocfs2/alloc.c                                      |    4=20
 include/linux/compiler.h                              |    2=20
 include/linux/devfreq_cooling.h                       |    2=20
 include/linux/percpu_counter.h                        |    4=20
 include/linux/sched.h                                 |    4=20
 include/net/ip6_route.h                               |    1=20
 include/target/iscsi/iscsi_target_core.h              |    2=20
 kernel/cpu.c                                          |    5 -
 kernel/kmod.c                                         |    4=20
 kernel/locking/lockdep.c                              |    4=20
 kernel/locking/locktorture.c                          |    8 -
 kernel/sched/sched.h                                  |    8 +
 kernel/signal.c                                       |    2=20
 kernel/trace/trace_events_trigger.c                   |   10 --
 mm/page_alloc.c                                       |    8 -
 net/hsr/hsr_netlink.c                                 |    9 +-
 net/ipv4/devinet.c                                    |   13 ++
 net/qrtr/qrtr.c                                       |    7 -
 security/keys/key.c                                   |    2=20
 security/keys/keyctl.c                                |    4=20
 sound/core/oss/pcm_plugin.c                           |   32 +++++--
 sound/pci/hda/hda_beep.c                              |    6 +
 sound/pci/hda/hda_codec.c                             |    1=20
 sound/pci/hda/hda_intel.c                             |   35 ++++---
 sound/pci/ice1712/prodigy_hifi.c                      |    4=20
 sound/soc/intel/atom/sst-atom-controls.c              |    2=20
 sound/soc/intel/atom/sst/sst_pci.c                    |    2=20
 sound/soc/soc-dapm.c                                  |    8 +
 sound/soc/soc-ops.c                                   |    4=20
 sound/soc/soc-pcm.c                                   |    6 -
 sound/soc/soc-topology.c                              |    2=20
 sound/usb/mixer.c                                     |    2=20
 sound/usb/mixer_maps.c                                |   28 ++++++
 tools/gpio/Makefile                                   |    2=20
 tools/objtool/check.c                                 |    5 -
 tools/testing/selftests/x86/ptrace_syscall.c          |    8 +
 124 files changed, 680 insertions(+), 453 deletions(-)

Adrian Huang (1):
      iommu/amd: Fix the configuration of GCR3 table root pointer

Alain Volmat (1):
      i2c: st: fix missing struct parameter description

Alexander Duyck (1):
      mm: Use fixed constant in page_frag_alloc instead of size + 1

Alexander Gordeev (1):
      s390/cpuinfo: fix wrong output when CPU0 is offline

Andy Lutomirski (1):
      selftests/x86/ptrace_syscall_32: Fix no-vDSO segfault

Andy Shevchenko (1):
      mfd: dln2: Fix sanity checking for endpoints

Anssi Hannula (1):
      tools: gpio: Fix out-of-tree build regression

Arnd Bergmann (1):
      arm64: cpu_errata: include required headers

Arvind Sankar (1):
      x86/boot: Use unsigned comparison for addresses

Benoit Parrot (1):
      media: ti-vpe: cal: fix disable_irqs to only the intended target

Bob Peterson (1):
      gfs2: Don't demote a glock until its revokes are written

Boqun Feng (1):
      locking/lockdep: Avoid recursion in lockdep_count_{for,back}ward_deps=
()

Borislav Petkov (1):
      x86/CPU: Add native CPUID variants returning a single datum

Can Guo (1):
      scsi: ufs: Fix ufshcd_hold() caused scheduling while atomic

Changwei Ge (1):
      ocfs2: no need try to truncate file beyond i_size

Chris Lew (1):
      soc: qcom: smem: Use le32_to_cpu for comparison

Chris Wilson (1):
      drm: Remove PageReserved manipulation from drm_pci_alloc

Claudiu Beznea (1):
      clk: at91: usb: continue if clk_hw_round_rate() return zero

Colin Ian King (2):
      ASoC: Intel: mrfld: fix incorrect check on p->sink
      ASoC: Intel: mrfld: return error codes when an error occurs

Dan Carpenter (3):
      libnvdimm: Out of bounds read in __nd_ioctl()
      fbdev: potential information leak in do_fb_ioctl()
      mtd: lpddr: Fix a double free in probe()

David Hildenbrand (3):
      KVM: s390: vsie: Fix region 1 ASCE sanity shadow address checks
      KVM: s390: vsie: Fix delivery of addressing exceptions
      KVM: s390: vsie: Fix possible race when shadowing region 3 tables

Dedy Lansky (2):
      wil6210: fix temperature debugfs
      wil6210: rate limit wil_rx_refill error

Dmitry Osipenko (1):
      power: supply: bq27xxx_battery: Silence deferred-probe error

Eric Biggers (1):
      kmod: make request_module() return an error when autoloading is disab=
led

Eric Sandeen (1):
      ext4: do not commit super on read-only bdev

Eric W. Biederman (1):
      signal: Extend exec_id to 64bits

Evalds Iodzevics (1):
      x86/microcode/intel: replace sync_core() with native_cpuid_reg(eax)

Filipe Manana (1):
      Btrfs: fix crash during unmount due to race with delayed inode workers

Frank Rowand (1):
      of: unittest: kmemleak in of_unittest_platform_populate()

Fredrik Strupe (1):
      arm64: armv8_deprecated: Fix undef_hook mask for thumb setend

Goldwyn Rodrigues (1):
      dm flakey: check for null arg_name in parse_features()

Greg Kroah-Hartman (1):
      Linux 4.9.220

Gustavo A. R. Silva (1):
      MIPS: OCTEON: irq: Fix potential NULL pointer dereference

Hamad Kadmany (1):
      wil6210: increase firmware ready timeout

Hans de Goede (1):
      Input: i8042 - add Acer Aspire 5738z to nomux list

Jan Engelhardt (1):
      acpi/x86: ignore unspecified bit positions in the ACPI global lock fi=
eld

Jan Kara (2):
      ext4: do not zeroout extents beyond i_disksize
      ext2: fix debug reference to ext2_xattr_cache

Jim Mattson (1):
      kvm: x86: Host feature SSBD doesn't imply guest feature SPEC_CTRL_SSBD

Joe Moriarty (1):
      drm: NULL pointer dereference [null-pointer-deref] (CWE 476) problem

John Garry (1):
      libata: Remove extra scsi_host_put() in ata_scsi_add_hosts()

Josef Bacik (4):
      btrfs: remove a BUG_ON() from merge_reloc_roots()
      btrfs: track reloc roots based on their commit root bytenr
      btrfs: drop block from cache on error in relocation
      btrfs: check commit root generation in should_ignore_root

Josh Poimboeuf (1):
      objtool: Fix switch table detection in .text.unlikely

Josh Triplett (2):
      ext4: fix incorrect group count in ext4_fill_super error message
      ext4: fix incorrect inodes per group in error message

Kai-Heng Feng (1):
      libata: Return correct status in sata_pmp_eh_recover_pm() when ATA_DF=
LAG_DETACH is set

Laurentiu Tudor (1):
      powerpc/fsl_booke: Avoid creating duplicate tlb1 entry

Li Bin (1):
      scsi: sg: add sg_remove_request in sg_common_write

Lior David (1):
      wil6210: fix length check in __wmi_send

Lyude Paul (1):
      drm/dp_mst: Fix clearing payload state on topology disable

Martin Blumenstingl (1):
      thermal: devfreq_cooling: inline all stubs for CONFIG_DEVFREQ_THERMAL=
=3Dn

Maurizio Lombardi (2):
      scsi: target: remove boilerplate code
      scsi: target: fix hang when multiple threads try to destroy the same =
iscsi session

Michael Ellerman (1):
      powerpc/64/tm: Don't let userspace set regs->trap via sigreturn

Michael Mueller (1):
      s390/diag: fix display of diagnose call statistics

Michael Wang (1):
      sched: Avoid scale real weight down to zero

Misono Tomohiro (1):
      NFS: direct.c: Fix memory leak of dreq when nfs_get_lock_context fails

Mohit Aggarwal (1):
      rtc: pm8xxx: Fix issue in RTC write path

Nathan Chancellor (4):
      rtc: omap: Use define directive for PIN_CONFIG_ACTIVE_HIGH
      misc: echo: Remove unnecessary parentheses and simplify check for zero
      video: fbdev: sis: Remove unnecessary parentheses and commented code
      powerpc/maple: Fix declaration made after definition

Oliver O'Halloran (1):
      cpufreq: powernv: Fix use-after-free

Ondrej Jirman (1):
      bus: sunxi-rsb: Return correct data when mixing 16-bit and 8-bit reads

Paul E. McKenney (1):
      locktorture: Print ratio of acquisitions, not failures

Qian Cai (2):
      ext4: fix a data race at inode->i_blocks
      percpu_counter: fix a data race at vm_committed_as

Randy Dunlap (1):
      ext2: fix empty body warnings when -Wextra is used

Remi Pommarel (1):
      ath9k: Handle txpower changes even when TPC is disabled

Rob Herring (1):
      of: fix missing kobject init for !SYSFS && OF_DYNAMIC config

Rosioru Dragos (1):
      crypto: mxs-dcp - fix scatterlist linearization for hash

Samuel Neves (1):
      x86/vdso: Fix lsl operand order

Sean Christopherson (2):
      KVM: x86: Allocate new rmap and large page tracking when moving memsl=
ot
      KVM: VMX: Always VMCLEAR in-use VMCSes during crash with kexec support

Shetty, Harshini X (EXT-Sony Mobile) (1):
      dm verity fec: fix memory leak in verity_fec_dtr

Simon Gander (1):
      hfsplus: fix crash and filesystem corruption when deleting files

Sowjanya Komatineni (1):
      clk: tegra: Fix Tegra PMC clock out parents

Sriharsha Allenki (1):
      usb: gadget: f_fs: Fix use after free issue as part of queue failure

Steffen Maier (1):
      scsi: zfcp: fix missing erp_lock in port recovery trigger for point-t=
o-point

Stephen Rothwell (1):
      tty: evh_bytechan: Fix out of bounds accesses

Subhash Jadavani (1):
      scsi: ufs: ufs-qcom: remove broken hci version quirk

Sungbo Eo (2):
      irqchip/versatile-fpga: Handle chained IRQs properly
      irqchip/versatile-fpga: Apply clear-mask earlier

Taehee Yoo (1):
      hsr: check protocol version in hsr_newlink()

Takashi Iwai (8):
      ALSA: usb-audio: Add mixer workaround for TRX40 and co
      ALSA: hda: Add driver blacklist
      ALSA: hda: Fix potential access overflow in beep helper
      ALSA: ice1724: Fix invalid access for enumerated ctl items
      ALSA: pcm: oss: Fix regression by buffer overflow fix
      ALSA: hda: Initialize power_state field properly
      ALSA: usb-audio: Don't override ignore_ctl_error value from the map
      ALSA: hda: Don't release card at firmware loading error

Taras Chornyi (1):
      net: ipv4: devinet: Fix crash when add/del multicast IP with autojoin

Thinh Nguyen (1):
      usb: gadget: composite: Inform controller driver of self-powered

Thomas Gleixner (1):
      x86/entry/32: Add missing ASM_CLAC to general_protection entry

Tim Stallard (1):
      net: ipv6: do not consider routes via gateways for anycast address ch=
eck

Timur Tabi (1):
      Revert "gpio: set up initial state from .get_direction()"

Trond Myklebust (1):
      NFS: Fix memory leaks in nfs_pageio_stop_mirroring()

Tuomas Tynkkynen (1):
      mac80211_hwsim: Use kstrndup() in place of kasprintf()

Vegard Nossum (1):
      compiler.h: fix error in BUILD_BUG_ON() reporting

Venkat Gopalakrishnan (1):
      scsi: ufs: make sure all interrupts are processed

Vitaly Kuznetsov (1):
      KVM: VMX: fix crash cleanup when KVM wasn't used

Wang Wenhu (1):
      net: qrtr: send msgs from local of same id as broadcast

Wen Yang (2):
      ipmi: fix hung processes in __get_guid()
      mtd: phram: fix a double free issue in error path

Xiao Yang (1):
      tracing: Fix the race between registering 'snapshot' event trigger an=
d triggering 'snapshot' operation

Xu Wang (1):
      qlcnic: Fix bad kzalloc null test

Yang Xu (1):
      KEYS: reaching the keys quotas correctly

YueHaibing (1):
      misc: rtsx: set correct pcr_ops for rts522A

Zheng Wei (1):
      net: vxge: fix wrong __VA_ARGS__ usage

Zhenzhong Duan (1):
      x86/speculation: Remove redundant arch_smt_update() invocation

zhangyi (F) (1):
      jbd2: improve comments about freeing data buffers whose page mapping =
is NULL

=EC=9D=B4=EA=B2=BD=ED=83=9D (4):
      ASoC: fix regwmask
      ASoC: dapm: connect virtual mux with default value
      ASoC: dpcm: allow start or stop during pause for backend
      ASoC: topology: use name_prefix for new kcontrol


--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6irdgACgkQONu9yGCS
aT75Xw/8CwksZa8cdsgUyCzHx0HqEELj4hC1aj1y9q5GPyT7A044BliVPbjYHO8t
DoOhqjXjsvI3P4e5K3W7iZkM8EZj9cV1bdIVaY18ugFHSGraYbdJVVASqK6TJOC+
PzKyU9ePFWUpBnacVOzEJrZUExQj3RJaDiADsigWUuLG6wlP4X0Awfhl1BbDj+7x
cwG6cixZhnRqggiyWkTlerfES1POENsVIuGyBLM5Tj0nnhER0ENYXlkJbp9SWrWN
5QGpv18b35JN8TEZ+fsFHeaYw9T+kbouuYSiW/niLD8hZDqze7iya4fqyy4c1+g3
7q677FARciexO4AG9ksUOuAfnCFFDCA5Qyy0dyFfjeiYa09f4UEiln1kh99aMt5+
lKvYDU2bT6Ad8dNQatkK8Paalpv/ey/LP8rMfdJI6gbsdMTDwOaMwInF26aIKNKT
/KRjfD6JO2dJWoGZRxVV49lO4HABIlL91QYQg4xCpkU55iNCsF92yzfwLgTp9+hr
US3aDI273pmmUbN0boDqLFTe0D5REIgt3k/xc8hTuUgqwqVOH8FgOcff/FGM51kK
+iyJazJ4DmaDgaA1jNEEdrKeTk5gG+s+akn9kdE4EHYC+N178eDgrFT1w5CHXs75
oyPJDlrjFBZx2sGPDpRketo7tcxefWoRjfQ1rKaQAmIxQfPUODk=
=AJi5
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
