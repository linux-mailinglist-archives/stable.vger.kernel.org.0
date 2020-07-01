Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31BE5210CD2
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 15:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731287AbgGANzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 09:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730792AbgGANzt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 09:55:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96996206BE;
        Wed,  1 Jul 2020 13:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593611747;
        bh=6tLr7QW05av3y6e8PbbNUath4BuR+ue8fyXsqiVd2Qc=;
        h=From:To:Cc:Subject:Date:From;
        b=qd0BgV4pVSw9VSm/22sfa1xHnam/pFGmHjZMa1Jz0Qc+pC985a8G7sZiAZFof9TMy
         TiC/xj7vB1zhDw534rXgAzBaFqXFXwZC1xVMDtyaHf/gYpHVwi68iSK/ajs4hLwm2K
         M9ljjg4/hONB0syq9tlvIAYjG8HkSlz2NwnVPUiw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Linux 4.14.187
Date:   Wed,  1 Jul 2020 09:55:44 -0400
Message-Id: <20200701135545.2688845-1-sashal@kernel.org>
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

I'm announcing the release of the 4.14.187 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary


Thanks,
Sasha


 Makefile                                       |  2 +-
 arch/arm/boot/dts/bcm-nsp.dtsi                 |  6 ++---
 arch/arm/mach-imx/pm-imx5.c                    |  6 +++--
 arch/arm64/kernel/perf_regs.c                  | 25 ++++++++++++++++---
 arch/s390/kernel/ptrace.c                      | 31 ++++++++++++++++++++++-
 arch/sparc/kernel/ptrace_32.c                  |  9 +++++--
 arch/x86/include/asm/kvm_host.h                |  2 +-
 arch/x86/kvm/mmu.c                             |  4 +--
 arch/x86/kvm/mmu.h                             |  2 +-
 arch/x86/kvm/paging_tmpl.h                     |  7 +++---
 arch/x86/kvm/vmx.c                             |  5 ++--
 arch/x86/kvm/x86.c                             |  4 +--
 block/bio-integrity.c                          |  1 -
 drivers/acpi/sysfs.c                           |  4 +--
 drivers/ata/libata-scsi.c                      |  9 ++++---
 drivers/block/loop.c                           |  6 ++---
 drivers/firmware/efi/esrt.c                    |  2 +-
 drivers/gpu/drm/radeon/ni_dpm.c                |  2 +-
 drivers/infiniband/core/cma.c                  | 18 ++++++++++++++
 drivers/infiniband/core/mad.c                  |  1 +
 drivers/net/ethernet/atheros/alx/main.c        |  9 ++++---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |  8 +++---
 drivers/net/ethernet/broadcom/tg3.c            |  4 +--
 drivers/net/ethernet/ibm/ibmveth.c             |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.c      |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_vf.c       | 23 +++++++++++++----
 drivers/net/ethernet/rocker/rocker_main.c      |  4 +--
 drivers/net/usb/ax88179_178a.c                 | 11 +++++----
 drivers/scsi/scsi_devinfo.c                    |  5 ++--
 drivers/staging/rtl8723bs/core/rtw_wlan_util.c |  4 ++-
 drivers/tty/hvc/hvc_console.c                  | 16 ++----------
 drivers/usb/class/cdc-acm.c                    |  2 ++
 drivers/usb/core/quirks.c                      |  3 ++-
 drivers/usb/dwc2/gadget.c                      |  6 -----
 drivers/usb/dwc2/platform.c                    | 11 +++++++++
 drivers/usb/gadget/udc/mv_udc_core.c           |  3 ++-
 drivers/usb/host/ehci-exynos.c                 |  5 ++--
 drivers/usb/host/ehci-pci.c                    |  7 ++++++
 drivers/usb/host/ohci-sm501.c                  |  1 +
 drivers/usb/host/xhci-mtk.c                    |  5 ++--
 drivers/usb/host/xhci.c                        |  4 +++
 drivers/usb/host/xhci.h                        |  2 +-
 fs/btrfs/inode.c                               |  3 ---
 fs/cifs/smb2ops.c                              | 12 +++++++++
 fs/nfs/direct.c                                | 13 +++++++---
 fs/nfs/file.c                                  |  1 +
 fs/nfs/flexfilelayout/flexfilelayout.c         | 11 ++++++---
 fs/ocfs2/ocfs2_fs.h                            |  4 +--
 fs/ocfs2/suballoc.c                            |  9 ++++---
 fs/xfs/libxfs/xfs_alloc.c                      | 16 ++++++++++++
 include/linux/netdevice.h                      |  2 +-
 include/linux/qed/qed_chain.h                  | 26 ++++++++++++--------
 include/linux/virtio_net.h                     | 17 +++++++------
 include/net/sctp/constants.h                   |  8 +++---
 include/net/sock.h                             |  1 -
 kernel/sched/core.c                            |  3 ++-
 kernel/trace/blktrace.c                        | 13 ++++++++++
 kernel/trace/trace_events_trigger.c            | 21 ++++++++++++++--
 mm/slab_common.c                               |  2 +-
 net/bridge/br_private.h                        |  2 +-
 net/core/dev.c                                 |  7 ++++++
 net/core/sock.c                                |  2 ++
 net/ipv4/fib_semantics.c                       |  2 +-
 net/ipv4/ip_tunnel.c                           | 14 ++++++-----
 net/ipv4/tcp_cubic.c                           |  2 ++
 net/ipv4/tcp_input.c                           | 12 +++++++--
 net/ipv6/ip6_gre.c                             |  9 ++++---
 net/ipv6/mcast.c                               |  1 +
 net/netfilter/ipset/ip_set_core.c              |  2 ++
 net/rxrpc/call_accept.c                        |  7 ++++++
 net/rxrpc/input.c                              |  7 +++---
 net/sched/sch_generic.c                        |  1 +
 net/sctp/associola.c                           |  5 +++-
 net/sctp/bind_addr.c                           |  1 +
 net/sctp/protocol.c                            |  3 ++-
 net/sunrpc/rpc_pipe.c                          |  1 +
 net/sunrpc/xdr.c                               |  4 +++
 scripts/Kbuild.include                         | 11 +++++----
 security/apparmor/lsm.c                        |  4 +--
 sound/pci/hda/patch_hdmi.c                     |  5 ++++
 sound/soc/rockchip/rockchip_pdm.c              |  4 ++-
 sound/usb/mixer.c                              | 34 +++++++++++++++++---------
 sound/usb/mixer.h                              | 15 ++++++++++--
 sound/usb/mixer_quirks.c                       |  5 ++--
 sound/usb/mixer_scarlett.c                     |  6 ++---
 sound/usb/quirks.c                             |  1 +
 86 files changed, 431 insertions(+), 181 deletions(-)

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

Chuck Lever (1):
      SUNRPC: Properly set the @subbuf parameter of xdr_buf_subsegment()

Chuhong Yuan (1):
      USB: ohci-sm501: Add missed iounmap() in remove

Dan Carpenter (2):
      usb: gadget: udc: Potential Oops in error handling code
      Staging: rtl8723bs: prevent buffer overflow in update_sta_support_rate()

David Christensen (1):
      tg3: driver sleeps indefinitely when EEH errors exceed eeh_max_freezes

David Howells (2):
      rxrpc: Fix notification call on completion of discarded calls
      rxrpc: Fix handling of rwind from an ACK packet

Denis Efremov (1):
      drm/radeon: fix fb_div check in ni_init_smc_spll_table()

Doug Berger (1):
      net: bcmgenet: use hardware padding of runt frames

Eric Dumazet (2):
      net: be more gentle about silly gso requests coming from user
      tcp: grow window for OOO packets only for SACK flows

Fan Guo (1):
      RDMA/mad: Fix possible memory leak in ib_mad_post_receive_mads()

Filipe Manana (1):
      btrfs: fix failure of RWF_NOWAIT write into prealloc extent beyond eof

Greg Kroah-Hartman (1):
      Revert "tty: hvc: Fix data abort due to race in hvc_open"

Jann Horn (1):
      apparmor: don't try to replace stale label in ptraceme check

Jeremy Kerr (1):
      net: usb: ax88179_178a: fix packet alignment padding

Jiping Ma (1):
      arm64: perf: Report the PC value in REGS_ABI_32 mode

Joakim Tjernlund (1):
      cdc-acm: Add DISABLE_ECHO quirk for Microchip/SMSC chip

Julian Scheel (1):
      ALSA: usb-audio: uac1: Invalidate ctl on interrupt

Junxiao Bi (3):
      ocfs2: load global_inode_alloc
      ocfs2: fix value of OCFS2_INVALID_SLOT
      ocfs2: fix panic on nfs server over ocfs2

Juri Lelli (1):
      sched/core: Fix PI boosting between RT and DEADLINE tasks

Kai-Heng Feng (1):
      xhci: Poll for U0 after disabling USB2 LPM

Longfang Liu (1):
      USB: ehci: reopen solution for Synopsys HC bug

Luis Chamberlain (1):
      blktrace: break out of blktrace setup on concurrent calls

Macpaul Lin (1):
      usb: host: xhci-mtk: avoid runtime suspend when removing hcd

Marcelo Ricardo Leitner (1):
      sctp: Don't advertise IPv4 addresses if ipv6only is set on the socket

Mark Zhang (1):
      RDMA/cma: Protect bind_list and listen_list while finding matching cm id

Martin Wilck (1):
      scsi: scsi_devinfo: handle non-terminated strings

Masahiro Yamada (1):
      kbuild: improve cc-option to clean up all temporary files

Masami Hiramatsu (1):
      tracing: Fix event trigger to accept redundant spaces

Mathias Nyman (1):
      xhci: Fix incorrect EP_STATE_MASK

Matthew Hagan (1):
      ARM: dts: NSP: Correct FA2 mailbox node

Minas Harutyunyan (1):
      usb: dwc2: Postponed gadget registration to the udc class driver

Nathan Chancellor (1):
      ACPI: sysfs: Fix pm_profile_attr type

Neal Cardwell (1):
      tcp_cubic: fix spurious HYSTART_DELAY exit upon drop in min RTT

Olga Kornievskaia (1):
      NFSv4 fix CLOSE not waiting for direct IO compeletion

Qiushi Wu (2):
      efi/esrt: Fix reference count leak in esre_create_sysfs_entry.
      ASoC: rockchip: Fix a reference count leak.

Russell King (1):
      netfilter: ipset: fix unaligned atomic access

Sasha Levin (1):
      Linux 4.14.187

Sean Christopherson (1):
      KVM: nVMX: Plumb L2 GPA through to PML emulation

Sven Schnelle (1):
      s390/ptrace: fix setting syscall number

Taehee Yoo (3):
      ip_tunnel: fix use-after-free in ip_tunnel_lookup()
      ip6_gre: fix use-after-free in ip6gre_tunnel_lookup()
      net: core: reduce recursion limit value

Takashi Iwai (2):
      ALSA: usb-audio: Clean up mixer element list traverse
      ALSA: usb-audio: Fix OOB access of mixer element list

Tang Bin (1):
      usb: host: ehci-exynos: Fix error check in exynos_ehci_probe()

Tariq Toukan (1):
      net: Do not clear the sock TX queue in sk_set_socket()

Thomas Falcon (1):
      ibmveth: Fix max MTU limit

Thomas Martitz (1):
      net: bridge: enfore alignment for ethernet address

Tomasz Meresiński (1):
      usb: add USB_QUIRK_DELAY_INIT for Logitech C922

Trond Myklebust (1):
      pNFS/flexfiles: Fix list corruption if the mirror count changes

Valentin Longchamp (1):
      net: sched: export __netdev_watchdog_up()

Vasily Averin (1):
      sunrpc: fixed rollback in rpc_gssd_dummy_populate()

Waiman Long (1):
      mm/slab: use memzero_explicit() in kzfree()

Wang Hai (1):
      mld: fix memory leak in ipv6_mc_destroy_dev()

Xiaoyao Li (1):
      KVM: X86: Fix MSR range of APIC registers in X2APIC mode

Yang Yingliang (1):
      net: fix memleak in register_netdevice()

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

iQIzBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAl78ldoACgkQ3qZv95d3
LNyCJA/9FOwwQuZURjWhcAlA7ZiUCm6MdJYzj0CZC9ttKyIO0j2sEO5iLTyYgvod
T1uvZaF2e8xsg9Gp+reZuLQGmBch1LLLw6y5/6Cj/jhBB2m5NdDefl9ykMT6FCJL
X+iHRZwj81ctufZN8TFUF0Hysvtdil7g7mWxZ6TXXcsdowuosl7LEweRWmt379Un
wy9HI08pN7uBEMdtWbAmELIqFOmt2GhPqCMTNM+PSOYe7XX5dtd9A9X/sn2WDWt9
U//DFZJBKQDJALJt/N/klUJ6Wud3XgpMdmTuRkW3OR9qZhcsAyLZhDnw004/rdhH
QOVjpOAkZo2Z4hFUND+3CrIVsnDzwpfwFiegHcokNqxZu4ctCO4HK1p+Ozp2+5yI
4Iy/wTlwWCtMo7/cY9pRUB2JvbIVw7AAHqvtaHuo4SBjcmF5yKdEpes/EuYwq40T
U+53z/E7LYHioFx15twq9auGSpD3nibH3RpBtkFMkZJmGdNnxIZ10VGABb6y8Nv9
jmm8ymdTXgEanguOzRtnTJkv2hIgIRa8s4s4hxkLq4b4SyLJ0GTSsJ/ta3rPrUb8
iECNL2+OZEnEz1YudXT0SMBSYVAun4D5nEav6gHvSjqoBm9qTm1LJdRbbMXPhA66
6q2CL4DvuQiD+Gmcv/o/uDr/WGrtaoSptKjLewOjajiv5IxiPIQ=
=bxda
-----END PGP SIGNATURE-----
