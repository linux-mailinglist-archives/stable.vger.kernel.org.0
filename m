Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C343220D882
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733251AbgF2Tjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732999AbgF2Tad (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44BBF252C4;
        Mon, 29 Jun 2020 15:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445089;
        bh=NbzUEhDsiJpIOw0lMP+ImybHEIXHGCL2U9HM9AcxjqU=;
        h=From:To:Cc:Subject:Date:From;
        b=p8+dq8mHnByroLLepvydWu/chZnPnIOjKai3YB8Hq2CFafa9ZnEd1ps8ualioQOEL
         Sq7FLXy09ULSHULk81DNQDcoI/h+9B93EZVyelErYYbqkXa1n4jTiZFeC2/FfVs7rY
         wmu7mJRvXooupkMti7D58ogcrnM4SpWiU7thAw6Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org
Subject: [PATCH 4.14 00/78] 4.14.186-rc1 review
Date:   Mon, 29 Jun 2020 11:36:48 -0400
Message-Id: <20200629153806.2494953-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is the start of the stable review cycle for the 4.14.186 release.
There are 78 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 01 Jul 2020 03:38:04 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-4.14.y&id2=v4.14.185

or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

--
Thanks,
Sasha

-------------------------

Pseudo-Shortlog of commits:

Aaron Plattner (1):
  ALSA: hda: Add NVIDIA codec IDs 9a & 9d through a0 to patch table

Aditya Pakki (1):
  rocker: fix incorrect error handling in dma_rings_init

Al Cooper (1):
  xhci: Fix enumeration issue when setting max packet size for FS
    devices.

Al Viro (1):
  fix a braino in "sparc32: fix register window handling in
    genregs32_[gs]et()"

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
  Staging: rtl8723bs: prevent buffer overflow in
    update_sta_support_rate()

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
  RDMA/cma: Protect bind_list and listen_list while finding matching cm
    id

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
  Linux 4.14.186-rc1

Sean Christopherson (1):
  KVM: nVMX: Plumb L2 GPA through to PML emulation

Sven Schnelle (1):
  s390/ptrace: fix setting syscall number

Taehee Yoo (3):
  ip_tunnel: fix use-after-free in ip_tunnel_lookup()
  ip6_gre: fix use-after-free in ip6gre_tunnel_lookup()
  net: core: reduce recursion limit value

Takashi Iwai (3):
  ALSA: usb-audio: Clean up mixer element list traverse
  ALSA: usb-audio: Fix OOB access of mixer element list
  ALSA: usb-audio: Fix invalid NULL check in snd_emuusb_set_samplerate()

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
  ata/libata: Fix usage of page address by page_address in
    ata_scsi_mode_select_xlat function

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
  block/bio-integrity: don't free 'buf' if bio_integrity_add_page()
    failed
  ARM: imx5: add missing put_device() call in imx_suspend_alloc_ocram()

 Makefile                                      |  4 +--
 arch/arm/boot/dts/bcm-nsp.dtsi                |  6 ++--
 arch/arm/mach-imx/pm-imx5.c                   |  6 ++--
 arch/arm64/kernel/perf_regs.c                 | 25 ++++++++++++--
 arch/s390/kernel/ptrace.c                     | 31 ++++++++++++++++-
 arch/sparc/kernel/ptrace_32.c                 |  9 +++--
 arch/x86/include/asm/kvm_host.h               |  2 +-
 arch/x86/kvm/mmu.c                            |  4 +--
 arch/x86/kvm/mmu.h                            |  2 +-
 arch/x86/kvm/paging_tmpl.h                    |  7 ++--
 arch/x86/kvm/vmx.c                            |  5 ++-
 arch/x86/kvm/x86.c                            |  4 +--
 block/bio-integrity.c                         |  1 -
 drivers/acpi/sysfs.c                          |  4 +--
 drivers/ata/libata-scsi.c                     |  9 +++--
 drivers/block/loop.c                          |  6 ++--
 drivers/firmware/efi/esrt.c                   |  2 +-
 drivers/gpu/drm/radeon/ni_dpm.c               |  2 +-
 drivers/infiniband/core/cma.c                 | 18 ++++++++++
 drivers/infiniband/core/mad.c                 |  1 +
 drivers/net/ethernet/atheros/alx/main.c       |  9 ++---
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  8 ++---
 drivers/net/ethernet/broadcom/tg3.c           |  4 +--
 drivers/net/ethernet/ibm/ibmveth.c            |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.c     |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_vf.c      | 23 ++++++++++---
 drivers/net/ethernet/rocker/rocker_main.c     |  4 +--
 drivers/net/usb/ax88179_178a.c                | 11 +++---
 drivers/scsi/scsi_devinfo.c                   |  5 +--
 .../staging/rtl8723bs/core/rtw_wlan_util.c    |  4 ++-
 drivers/usb/class/cdc-acm.c                   |  2 ++
 drivers/usb/core/quirks.c                     |  3 +-
 drivers/usb/dwc2/gadget.c                     |  6 ----
 drivers/usb/dwc2/platform.c                   | 11 ++++++
 drivers/usb/gadget/udc/mv_udc_core.c          |  3 +-
 drivers/usb/host/ehci-exynos.c                |  5 ++-
 drivers/usb/host/ehci-pci.c                   |  7 ++++
 drivers/usb/host/ohci-sm501.c                 |  1 +
 drivers/usb/host/xhci-mtk.c                   |  5 +--
 drivers/usb/host/xhci.c                       |  4 +++
 drivers/usb/host/xhci.h                       |  2 +-
 fs/btrfs/inode.c                              |  3 --
 fs/cifs/smb2ops.c                             | 12 +++++++
 fs/nfs/direct.c                               | 13 ++++---
 fs/nfs/file.c                                 |  1 +
 fs/nfs/flexfilelayout/flexfilelayout.c        | 11 +++---
 fs/ocfs2/ocfs2_fs.h                           |  4 +--
 fs/ocfs2/suballoc.c                           |  9 +++--
 fs/xfs/libxfs/xfs_alloc.c                     | 16 +++++++++
 include/linux/netdevice.h                     |  2 +-
 include/linux/qed/qed_chain.h                 | 26 ++++++++------
 include/linux/virtio_net.h                    | 17 +++++-----
 include/net/sctp/constants.h                  |  8 +++--
 include/net/sock.h                            |  1 -
 kernel/sched/core.c                           |  3 +-
 kernel/trace/blktrace.c                       | 13 +++++++
 kernel/trace/trace_events_trigger.c           | 21 ++++++++++--
 mm/slab_common.c                              |  2 +-
 net/bridge/br_private.h                       |  2 +-
 net/core/dev.c                                |  7 ++++
 net/core/sock.c                               |  2 ++
 net/ipv4/fib_semantics.c                      |  2 +-
 net/ipv4/ip_tunnel.c                          | 14 ++++----
 net/ipv4/tcp_cubic.c                          |  2 ++
 net/ipv4/tcp_input.c                          | 12 +++++--
 net/ipv6/ip6_gre.c                            |  9 +++--
 net/ipv6/mcast.c                              |  1 +
 net/netfilter/ipset/ip_set_core.c             |  2 ++
 net/rxrpc/call_accept.c                       |  7 ++++
 net/rxrpc/input.c                             |  7 ++--
 net/sched/sch_generic.c                       |  1 +
 net/sctp/associola.c                          |  5 ++-
 net/sctp/bind_addr.c                          |  1 +
 net/sctp/protocol.c                           |  3 +-
 net/sunrpc/rpc_pipe.c                         |  1 +
 net/sunrpc/xdr.c                              |  4 +++
 scripts/Kbuild.include                        | 11 +++---
 security/apparmor/lsm.c                       |  4 +--
 sound/pci/hda/patch_hdmi.c                    |  5 +++
 sound/soc/rockchip/rockchip_pdm.c             |  4 ++-
 sound/usb/mixer.c                             | 34 ++++++++++++-------
 sound/usb/mixer.h                             | 15 ++++++--
 sound/usb/mixer_quirks.c                      | 11 +++---
 sound/usb/mixer_scarlett.c                    |  6 ++--
 sound/usb/quirks.c                            |  1 +
 85 files changed, 433 insertions(+), 171 deletions(-)

-- 
2.25.1

