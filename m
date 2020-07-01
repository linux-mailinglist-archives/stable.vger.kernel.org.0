Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF1D210CCD
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 15:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731172AbgGANz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 09:55:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730245AbgGANz2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 09:55:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA3DE20663;
        Wed,  1 Jul 2020 13:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593611727;
        bh=5iEDX4ws0HrN0sKwSKEQUS5FBjb5h2uhCGAtLqf/5ME=;
        h=From:To:Cc:Subject:Date:From;
        b=1JObLsUroYhRt/sNXY/b+//zHO8FBMJJRkK4skXo1tTjGQYlwfSPo8k8eMNcPKyOZ
         yd8poVTAJmzyficIbqp96ybiXNP0roNu98K27o4A9jzzoDLUUmSVr5+WZJyWLBURR4
         y9jRTqjnDkb5zZmGhpOt3jW0DoDNYtgK4dwqkTAY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Linux 4.19.131
Date:   Wed,  1 Jul 2020 09:55:24 -0400
Message-Id: <20200701135525.2688757-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I'm announcing the release of the 4.19.131 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary


Thanks,
Sasha


 Makefile                                           |  2 +-
 arch/arm/boot/dts/bcm-nsp.dtsi                     |  6 +--
 arch/arm/boot/dts/omap4-duovero-parlor.dts         |  2 +-
 arch/arm/mach-imx/pm-imx5.c                        |  6 ++-
 arch/arm64/kernel/fpsimd.c                         |  6 +--
 arch/arm64/kernel/perf_regs.c                      | 25 +++++++--
 arch/riscv/include/asm/cmpxchg.h                   |  8 +--
 arch/riscv/kernel/sys_riscv.c                      |  6 +++
 arch/s390/include/asm/vdso.h                       |  1 +
 arch/s390/kernel/asm-offsets.c                     |  2 +-
 arch/s390/kernel/ptrace.c                          | 31 ++++++++++-
 arch/s390/kernel/time.c                            |  1 +
 arch/s390/kernel/vdso64/clock_getres.S             | 10 ++--
 arch/sparc/kernel/ptrace_32.c                      |  9 +++-
 arch/x86/include/asm/kvm_host.h                    |  2 +-
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c           |  1 +
 arch/x86/kvm/mmu.c                                 |  4 +-
 arch/x86/kvm/mmu.h                                 |  2 +-
 arch/x86/kvm/paging_tmpl.h                         |  7 +--
 arch/x86/kvm/vmx.c                                 |  5 +-
 arch/x86/kvm/x86.c                                 |  4 +-
 arch/x86/lib/usercopy_64.c                         |  1 +
 block/bio-integrity.c                              |  1 -
 drivers/acpi/sysfs.c                               |  4 +-
 drivers/ata/libata-scsi.c                          |  9 ++--
 drivers/ata/sata_rcar.c                            | 11 ++--
 drivers/base/regmap/regmap.c                       |  1 +
 drivers/block/loop.c                               |  6 +--
 drivers/char/hw_random/ks-sa-rng.c                 |  1 +
 drivers/edac/amd64_edac.c                          | 13 +++++
 drivers/edac/amd64_edac.h                          |  3 ++
 drivers/firmware/efi/esrt.c                        |  2 +-
 .../drm/amd/display/modules/color/color_gamma.c    |  2 +-
 drivers/gpu/drm/radeon/ni_dpm.c                    |  2 +-
 drivers/gpu/drm/rcar-du/Kconfig                    |  1 +
 drivers/i2c/busses/i2c-fsi.c                       |  2 +-
 drivers/i2c/busses/i2c-tegra.c                     | 53 ++++++++++++++-----
 drivers/i2c/i2c-core-smbus.c                       |  7 +++
 drivers/infiniband/core/cma.c                      | 18 +++++++
 drivers/infiniband/core/mad.c                      |  3 +-
 drivers/infiniband/hw/qedr/qedr_iw_cm.c            | 13 ++++-
 drivers/md/dm-writecache.c                         |  4 ++
 drivers/mtd/nand/raw/marvell_nand.c                |  2 +-
 drivers/net/ethernet/atheros/alx/main.c            |  9 ++--
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  8 ++-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |  4 --
 drivers/net/ethernet/broadcom/tg3.c                |  4 +-
 drivers/net/ethernet/chelsio/cxgb4/l2t.c           | 52 +++++++++----------
 drivers/net/ethernet/ibm/ibmveth.c                 |  2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 | 21 ++++++--
 drivers/net/ethernet/qlogic/qed/qed_cxt.c          |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_vf.c           | 23 +++++++--
 drivers/net/ethernet/rocker/rocker_main.c          |  4 +-
 drivers/net/phy/phy_device.c                       |  6 ++-
 drivers/net/usb/ax88179_178a.c                     | 11 ++--
 drivers/regulator/pfuze100-regulator.c             | 60 ++++++++++++++--------
 drivers/s390/scsi/zfcp_erp.c                       | 13 ++++-
 drivers/staging/erofs/unzip_vle.h                  | 20 ++++----
 drivers/staging/rtl8723bs/core/rtw_wlan_util.c     |  4 +-
 drivers/tty/hvc/hvc_console.c                      | 16 +-----
 drivers/usb/class/cdc-acm.c                        |  2 +
 drivers/usb/core/quirks.c                          |  3 +-
 drivers/usb/dwc2/gadget.c                          |  6 ---
 drivers/usb/dwc2/platform.c                        | 11 ++++
 drivers/usb/gadget/udc/mv_udc_core.c               |  3 +-
 drivers/usb/host/ehci-exynos.c                     |  5 +-
 drivers/usb/host/ehci-pci.c                        |  7 +++
 drivers/usb/host/ohci-sm501.c                      |  1 +
 drivers/usb/host/xhci-mtk.c                        |  5 +-
 drivers/usb/host/xhci.c                            |  9 +++-
 drivers/usb/host/xhci.h                            |  2 +-
 drivers/usb/typec/tcpci_rt1711h.c                  | 31 ++++-------
 fs/btrfs/inode.c                                   | 22 ++++++--
 fs/cifs/smb2ops.c                                  | 12 +++++
 fs/nfs/direct.c                                    | 13 +++--
 fs/nfs/file.c                                      |  1 +
 fs/nfs/flexfilelayout/flexfilelayout.c             | 11 ++--
 fs/notify/fanotify/fanotify.c                      |  5 +-
 fs/ocfs2/dlmglue.c                                 | 17 +++++-
 fs/ocfs2/ocfs2.h                                   |  1 +
 fs/ocfs2/ocfs2_fs.h                                |  4 +-
 fs/ocfs2/suballoc.c                                |  9 ++--
 fs/xfs/libxfs/xfs_alloc.c                          | 16 ++++++
 include/linux/netdevice.h                          | 40 ++++++++++++---
 include/linux/qed/qed_chain.h                      | 26 ++++++----
 include/linux/virtio_net.h                         | 17 +++---
 include/net/sctp/constants.h                       |  8 +--
 include/net/sock.h                                 |  1 -
 include/net/xfrm.h                                 |  1 +
 kernel/sched/core.c                                |  3 +-
 kernel/sched/deadline.c                            |  1 +
 kernel/trace/blktrace.c                            | 13 +++++
 kernel/trace/ring_buffer.c                         |  2 +-
 kernel/trace/trace_events_trigger.c                | 21 +++++++-
 mm/slab_common.c                                   |  2 +-
 net/bridge/br_private.h                            |  2 +-
 net/core/dev.c                                     | 19 ++++---
 net/core/filter.c                                  |  6 +--
 net/core/sock.c                                    |  4 +-
 net/ipv4/fib_semantics.c                           |  2 +-
 net/ipv4/ip_tunnel.c                               | 14 ++---
 net/ipv4/tcp_cubic.c                               |  2 +
 net/ipv4/tcp_input.c                               | 26 ++++++++--
 net/ipv6/ip6_gre.c                                 |  9 ++--
 net/ipv6/mcast.c                                   |  1 +
 net/netfilter/ipset/ip_set_core.c                  |  2 +
 net/rxrpc/call_accept.c                            |  7 +++
 net/rxrpc/input.c                                  |  7 ++-
 net/sched/sch_cake.c                               | 58 +++++++++++++++------
 net/sched/sch_generic.c                            |  1 +
 net/sctp/associola.c                               |  5 +-
 net/sctp/bind_addr.c                               |  1 +
 net/sctp/protocol.c                                |  3 +-
 net/sunrpc/rpc_pipe.c                              |  1 +
 net/sunrpc/xdr.c                                   |  4 ++
 net/xfrm/xfrm_device.c                             |  4 +-
 scripts/Kbuild.include                             | 11 ++--
 security/apparmor/lsm.c                            |  4 +-
 sound/pci/hda/patch_hdmi.c                         |  5 ++
 sound/pci/hda/patch_realtek.c                      | 32 +++++++++++-
 sound/soc/fsl/fsl_ssi.c                            | 13 +++--
 sound/soc/qcom/qdsp6/q6asm.c                       |  7 +--
 sound/soc/rockchip/rockchip_pdm.c                  |  4 +-
 sound/usb/mixer.c                                  | 15 ++++--
 sound/usb/mixer.h                                  |  9 +++-
 sound/usb/mixer_quirks.c                           |  3 +-
 sound/usb/quirks.c                                 |  9 ++++
 127 files changed, 831 insertions(+), 348 deletions(-)

Aaron Plattner (1):
      ALSA: hda: Add NVIDIA codec IDs 9a & 9d through a0 to patch table

Aditya Pakki (1):
      rocker: fix incorrect error handling in dma_rings_init

Al Cooper (1):
      xhci: Fix enumeration issue when setting max packet size for FS devices.

Al Viro (1):
      fix a braino in "sparc32: fix register window handling in genregs32_[gs]et()"

Alexander Lobakin (3):
      net: qed: fix left elements count calculation
      net: qed: fix NVMe login fails over VFs
      net: qed: fix excessive QM ILT lines consumption

Amir Goldstein (1):
      fanotify: fix ignore mask logic for events on child and on dir

Charles Keepax (1):
      regmap: Fix memory leak from regmap_register_patch

Chuck Lever (1):
      SUNRPC: Properly set the @subbuf parameter of xdr_buf_subsegment()

Chuhong Yuan (1):
      USB: ohci-sm501: Add missed iounmap() in remove

Dan Carpenter (3):
      x86/resctrl: Fix a NULL vs IS_ERR() static checker warning in rdt_cdp_peer_get()
      usb: gadget: udc: Potential Oops in error handling code
      Staging: rtl8723bs: prevent buffer overflow in update_sta_support_rate()

Daniel Gomez (1):
      drm: rcar-du: Fix build error

David Christensen (1):
      tg3: driver sleeps indefinitely when EEH errors exceed eeh_max_freezes

David Howells (2):
      rxrpc: Fix notification call on completion of discarded calls
      rxrpc: Fix handling of rwind from an ACK packet

Denis Efremov (2):
      drm/amd/display: Use kfree() to free rgb_user in calculate_user_regamma_ramp()
      drm/radeon: fix fb_div check in ni_init_smc_spll_table()

Denis Kirjanov (1):
      tcp: don't ignore ECN CWR on pure ACK

Dinghao Liu (1):
      hwrng: ks-sa - Fix runtime PM imbalance on error

Doug Berger (2):
      net: bcmgenet: remove HFB_CTRL access
      net: bcmgenet: use hardware padding of runt frames

Eddie James (1):
      i2c: fsi: Fix the port number field in status register

Eric Dumazet (3):
      net: be more gentle about silly gso requests coming from user
      net: increment xmit_recursion level in dev_direct_xmit()
      tcp: grow window for OOO packets only for SACK flows

Fan Guo (1):
      RDMA/mad: Fix possible memory leak in ib_mad_post_receive_mads()

Filipe Manana (2):
      btrfs: fix data block group relocation failure due to concurrent scrub
      btrfs: fix failure of RWF_NOWAIT write into prealloc extent beyond eof

Florian Fainelli (1):
      net: phy: Check harder for errors in get_phy_id()

Florian Westphal (2):
      net: place xmit recursion in softnet data
      net: use correct this_cpu primitive in dev_recursion_level

Gao Xiang (1):
      erofs: fix partially uninitialized misuse in z_erofs_onlinepage_fixup

Greg Kroah-Hartman (1):
      Revert "tty: hvc: Fix data abort due to race in hvc_open"

Huaisheng Ye (1):
      dm writecache: correct uncommitted_block when discarding uncommitted entry

Huy Nguyen (1):
      xfrm: Fix double ESP trailer insertion in IPsec crypto offload.

Ilya Ponetayev (1):
      sch_cake: don't try to reallocate or unshare skb unconditionally

Jann Horn (1):
      apparmor: don't try to replace stale label in ptraceme check

Jeremy Kerr (1):
      net: usb: ax88179_178a: fix packet alignment padding

Jiping Ma (1):
      arm64: perf: Report the PC value in REGS_ABI_32 mode

Joakim Tjernlund (1):
      cdc-acm: Add DISABLE_ECHO quirk for Microchip/SMSC chip

Junxiao Bi (4):
      ocfs2: avoid inode removal while nfsd is accessing it
      ocfs2: load global_inode_alloc
      ocfs2: fix value of OCFS2_INVALID_SLOT
      ocfs2: fix panic on nfs server over ocfs2

Juri Lelli (2):
      sched/deadline: Initialize ->dl_boosted
      sched/core: Fix PI boosting between RT and DEADLINE tasks

Kai-Heng Feng (4):
      ALSA: hda/realtek: Enable mute LED on an HP system
      ALSA: hda/realtek - Enable micmute LED on and HP system
      xhci: Poll for U0 after disabling USB2 LPM
      xhci: Return if xHCI doesn't support LPM

Li Jun (1):
      usb: typec: tcpci_rt1711h: avoid screaming irq causing boot hangs

Longfang Liu (1):
      USB: ehci: reopen solution for Synopsys HC bug

Luis Chamberlain (1):
      blktrace: break out of blktrace setup on concurrent calls

Macpaul Lin (2):
      usb: host: xhci-mtk: avoid runtime suspend when removing hcd
      ALSA: usb-audio: add quirk for Samsung USBC Headset (AKG)

Mans Rullgard (1):
      i2c: core: check returned size of emulated smbus block read

Marcelo Ricardo Leitner (1):
      sctp: Don't advertise IPv4 addresses if ipv6only is set on the socket

Mark Zhang (1):
      RDMA/cma: Protect bind_list and listen_list while finding matching cm id

Masahiro Yamada (1):
      kbuild: improve cc-option to clean up all temporary files

Masami Hiramatsu (1):
      tracing: Fix event trigger to accept redundant spaces

Mathias Nyman (1):
      xhci: Fix incorrect EP_STATE_MASK

Matt Fleming (1):
      x86/asm/64: Align start of __clear_user() loop to 16-bytes

Matthew Hagan (1):
      ARM: dts: NSP: Correct FA2 mailbox node

Michal Kalderon (1):
      RDMA/qedr: Fix KASAN: use-after-free in ucma_event_handler+0x532

Mikulas Patocka (1):
      dm writecache: add cond_resched to loop in persistent_memory_claim()

Minas Harutyunyan (1):
      usb: dwc2: Postponed gadget registration to the udc class driver

Miquel Raynal (1):
      mtd: rawnand: marvell: Fix the condition on a return code

Nathan Chancellor (1):
      ACPI: sysfs: Fix pm_profile_attr type

Nathan Huckleberry (1):
      riscv/atomic: Fix sign extension for RV64I

Navid Emamdoost (1):
      sata_rcar: handle pm_runtime_get_sync failure cases

Neal Cardwell (1):
      tcp_cubic: fix spurious HYSTART_DELAY exit upon drop in min RTT

Olga Kornievskaia (1):
      NFSv4 fix CLOSE not waiting for direct IO compeletion

Qiushi Wu (2):
      efi/esrt: Fix reference count leak in esre_create_sysfs_entry.
      ASoC: rockchip: Fix a reference count leak.

Rahul Lakkireddy (1):
      cxgb4: move handling L2T ARP failures to caller

Robin Gong (1):
      regualtor: pfuze100: correct sw1a/sw2 on pfuze3000

Russell King (1):
      netfilter: ipset: fix unaligned atomic access

Sasha Levin (2):
      ALSA: hda/realtek - Enable the headset of ASUS B9450FA with ALC294
      Linux 4.19.131

Sean Christopherson (1):
      KVM: nVMX: Plumb L2 GPA through to PML emulation

Shay Drory (1):
      IB/mad: Fix use after free when destroying MAD agent

Shengjiu Wang (1):
      ASoC: fsl_ssi: Fix bclk calculation for mono channel

Sowjanya Komatineni (1):
      i2c: tegra: Fix Maximum transfer size

Srinivas Kandagatla (1):
      ASoC: q6asm: handle EOS correctly

Steffen Maier (1):
      scsi: zfcp: Fix panic on ERP timeout for previously dismissed ERP action

Steven Rostedt (VMware) (1):
      ring-buffer: Zero out time extend if it is nested and not absolute

Sven Schnelle (1):
      s390/ptrace: fix setting syscall number

Taehee Yoo (3):
      ip6_gre: fix use-after-free in ip6gre_tunnel_lookup()
      ip_tunnel: fix use-after-free in ip_tunnel_lookup()
      net: core: reduce recursion limit value

Takashi Iwai (2):
      ALSA: usb-audio: Fix OOB access of mixer element list
      ALSA: hda/realtek - Add quirk for MSI GE63 laptop

Tang Bin (1):
      usb: host: ehci-exynos: Fix error check in exynos_ehci_probe()

Tariq Toukan (1):
      net: Do not clear the sock TX queue in sk_set_socket()

Thierry Reding (2):
      i2c: tegra: Cleanup kerneldoc comments
      i2c: tegra: Add missing kerneldoc for some fields

Thomas Falcon (2):
      ibmveth: Fix max MTU limit
      ibmvnic: Harden device login requests

Thomas Martitz (1):
      net: bridge: enfore alignment for ethernet address

Toke Høiland-Jørgensen (2):
      sch_cake: fix a few style nits
      sch_cake: don't call diffserv parsing code when it is not needed

Tomasz Meresiński (1):
      usb: add USB_QUIRK_DELAY_INIT for Logitech C922

Tony Lindgren (1):
      ARM: dts: Fix duovero smsc interrupt for suspend

Trond Myklebust (1):
      pNFS/flexfiles: Fix list corruption if the mirror count changes

Valentin Longchamp (1):
      net: sched: export __netdev_watchdog_up()

Vasily Averin (1):
      sunrpc: fixed rollback in rpc_gssd_dummy_populate()

Vincenzo Frascino (1):
      s390/vdso: fix vDSO clock_getres()

Waiman Long (1):
      mm/slab: use memzero_explicit() in kzfree()

Wang Hai (1):
      mld: fix memory leak in ipv6_mc_destroy_dev()

Will Deacon (1):
      arm64: sve: Fix build failure when ARM64_SVE=y and SYSCTL=n

Xiaoyao Li (1):
      KVM: X86: Fix MSR range of APIC registers in X2APIC mode

Yang Yingliang (1):
      net: fix memleak in register_netdevice()

Yash Shah (1):
      RISC-V: Don't allow write+exec only page mapping request in mmap

Yazen Ghannam (1):
      EDAC/amd64: Add Family 17h Model 30h PCI IDs

Ye Bin (1):
      ata/libata: Fix usage of page address by page_address in ata_scsi_mode_select_xlat function

Yick W. Tse (1):
      ALSA: usb-audio: add quirk for Denon DCD-1500RE

Zekun Shen (1):
      net: alx: fix race condition in alx_remove

Zhang Xiaoxu (2):
      cifs/smb3: Fix data inconsistent when punch hole
      cifs/smb3: Fix data inconsistent when zero file range

Zheng Bin (2):
      loop: replace kill_bdev with invalidate_bdev
      xfs: add agf freeblocks verify in xfs_agf_verify

guodeqing (1):
      net: Fix the arp error in some cases

yu kuai (2):
      block/bio-integrity: don't free 'buf' if bio_integrity_add_page() failed
      ARM: imx5: add missing put_device() call in imx_suspend_alloc_ocram()

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAl78lcYACgkQ3qZv95d3
LNxyRxAAg50FgowTHS+t2OkROfGz714a8R/THJdbjEr3jdFQeCp2vVs08sY6sn6V
8z50r2P+IvJg52NHVggI0LckS2K10KnyBJfIUAoQPc3L3vkSd6k9kTryLpmDn3qt
rPZw4kOS1kHIIYUWvtsNxorQsskJtcO+BteRodFWlKANKzjkiIXRf3cY3LSKv4Kr
/EEj1dDW3w0yoUf1D8PUTT1OytkFYbzSGD4Yj0nIpd//335jkJnJhTH2/l8sqo8U
QC+/MEnU2xZMYAFbTfQTTTned1D7QnipPjaUitf+s9f3V5LwfDJ+BZC4KUCNBTs0
ALeh1U6LPC+kTNrFzqdfp6pSyPp9tMfBktTzgoutOlupesCVw2FlIrj3y9/yImfE
BDcaY4+zc9YAnw3UWeUTSSuSry7YXbSQkXN7AFTcyPW4iN2VK2OO9Pg16cXgEHDq
Q+D2wSYG6UeHYAySbsMNBXUVFh27Fi5Vp/4iLbAg533vzvlEBbcAszZqtKe+sPGE
SkqGIUJYA/PkW8uk2BTfgQzu/l8QW4c+URBGDYqtMq9jX5o0GuOclVXhhbe2GFNg
TZe3/oxz2TtpZljN6Jv5hmuSREKyhTFeWiK/LllIgfhmHm+oESPrY0Zy+rINSpn2
IEljJWePB38bNZqGg1Wn6j2CFw+If6pcrpmB/jq3QjosMqeYclE=
=s+2e
-----END PGP SIGNATURE-----
