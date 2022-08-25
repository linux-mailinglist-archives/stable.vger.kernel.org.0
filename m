Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB5E5A0CFA
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 11:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240703AbiHYJrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 05:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240704AbiHYJrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 05:47:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A21AB428;
        Thu, 25 Aug 2022 02:47:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55C1961C22;
        Thu, 25 Aug 2022 09:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A843C433C1;
        Thu, 25 Aug 2022 09:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661420830;
        bh=wOqF7hf+m/vp7soDKl7ZcLpSEYkNbL8P8BPDOm7dljQ=;
        h=From:To:Cc:Subject:Date:From;
        b=1MBba0WkRi2MMjvC46VdeHcM/eSlM6pdWMcZbW4w8Ns03hpmSoBCl2+5b/I6hdAV3
         vot2w66zTHdB6CP6JG9mJKEpoHK20j+a4C8g+s5pstTN6XrL7y4jqjOsObNHYRt5m2
         OXE4yxXCLzyUcV30auWg88uvmckbk963A6p6eM3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.326
Date:   Thu, 25 Aug 2022 11:47:06 +0200
Message-Id: <166142082714971@kroah.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_ABUSE_SURBL,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.326 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 
 arch/arm/lib/xor-neon.c                         |    3 
 arch/ia64/include/asm/processor.h               |    2 
 arch/mips/cavium-octeon/octeon-platform.c       |    3 
 arch/mips/kernel/proc.c                         |    2 
 arch/mips/mm/tlbex.c                            |    4 
 arch/nios2/include/asm/entry.h                  |    3 
 arch/nios2/include/asm/ptrace.h                 |    2 
 arch/nios2/kernel/entry.S                       |   22 ++--
 arch/nios2/kernel/signal.c                      |    3 
 arch/nios2/kernel/syscall_table.c               |    1 
 arch/nios2/kernel/time.c                        |    5 
 arch/parisc/kernel/drivers.c                    |    9 -
 arch/powerpc/kernel/prom.c                      |    7 +
 arch/powerpc/platforms/powernv/rng.c            |    2 
 arch/powerpc/sysdev/fsl_pci.c                   |    8 +
 arch/powerpc/sysdev/fsl_pci.h                   |    1 
 arch/x86/kvm/emulate.c                          |   19 +--
 arch/x86/kvm/svm.c                              |    2 
 arch/x86/platform/olpc/olpc-xo1-sci.c           |    2 
 drivers/acpi/video_detect.c                     |   55 ++++++----
 drivers/ata/libata-eh.c                         |    1 
 drivers/atm/idt77252.c                          |    1 
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c |    2 
 drivers/irqchip/irq-tegra.c                     |   10 -
 drivers/macintosh/adb.c                         |    2 
 drivers/md/dm-raid.c                            |    2 
 drivers/md/raid10.c                             |    5 
 drivers/md/raid5.c                              |    2 
 drivers/misc/cxl/irq.c                          |    1 
 drivers/net/can/usb/ems_usb.c                   |    2 
 drivers/net/ethernet/freescale/fec_ptp.c        |    6 -
 drivers/net/sungem_phy.c                        |    1 
 drivers/net/usb/ax88179_178a.c                  |   14 +-
 drivers/net/usb/usbnet.c                        |    8 -
 drivers/net/wireless/mediatek/mt7601u/usb.c     |    1 
 drivers/pinctrl/nomadik/pinctrl-nomadik.c       |    4 
 drivers/pinctrl/qcom/pinctrl-msm8916.c          |    4 
 drivers/s390/scsi/zfcp_fc.c                     |   29 +++--
 drivers/s390/scsi/zfcp_fc.h                     |    6 -
 drivers/s390/scsi/zfcp_fsf.c                    |    4 
 drivers/scsi/sg.c                               |   57 ++++++-----
 drivers/scsi/ufs/ufshcd-pltfrm.c                |   15 ++
 drivers/staging/android/ion/ion-ioctl.c         |    8 -
 drivers/tty/serial/ucc_uart.c                   |    2 
 drivers/usb/core/hcd.c                          |   26 ++---
 drivers/usb/gadget/legacy/inode.c               |    1 
 drivers/usb/host/ohci-ppc-of.c                  |    1 
 drivers/vfio/vfio.c                             |    1 
 drivers/video/fbdev/i740fb.c                    |    9 +
 drivers/xen/xenbus/xenbus_dev_frontend.c        |    4 
 fs/attr.c                                       |    2 
 fs/btrfs/disk-io.c                              |   14 ++
 fs/btrfs/tree-log.c                             |    4 
 fs/ext4/inline.c                                |    3 
 fs/ext4/inode.c                                 |    7 +
 fs/ext4/namei.c                                 |   23 +++-
 fs/ext4/resize.c                                |   11 ++
 fs/ext4/xattr.c                                 |    6 -
 fs/ext4/xattr.h                                 |   13 ++
 fs/fuse/inode.c                                 |    6 +
 fs/nfs/nfs4proc.c                               |    3 
 fs/ntfs/attrib.c                                |    8 +
 fs/proc/base.c                                  |   23 +---
 fs/proc/fd.c                                    |    6 -
 fs/proc/internal.h                              |    2 
 fs/proc/namespaces.c                            |    3 
 include/linux/bpf.h                             |   11 ++
 include/linux/buffer_head.h                     |   25 ++++
 include/linux/pci_ids.h                         |    2 
 include/linux/usb/hcd.h                         |    1 
 include/net/bluetooth/l2cap.h                   |    1 
 include/sound/core.h                            |    8 +
 include/trace/events/spmi.h                     |   12 +-
 include/uapi/linux/swab.h                       |    4 
 init/main.c                                     |   14 --
 kernel/bpf/core.c                               |   16 ++-
 kernel/bpf/syscall.c                            |   36 +++++--
 net/9p/client.c                                 |    4 
 net/bluetooth/l2cap_core.c                      |   68 +++++++++----
 net/ipv4/tcp_output.c                           |    7 -
 net/ipv6/ping.c                                 |    6 +
 net/netfilter/nf_tables_api.c                   |    3 
 net/netfilter/nfnetlink_queue.c                 |    7 +
 net/rds/ib_recv.c                               |    1 
 net/sched/cls_route.c                           |    8 +
 net/sunrpc/backchannel_rqst.c                   |   14 ++
 net/vmw_vsock/af_vsock.c                        |    9 +
 security/selinux/hooks.c                        |  123 +++++++++++++++---------
 security/selinux/include/objsec.h               |    5 
 security/selinux/selinuxfs.c                    |    4 
 sound/core/info.c                               |    6 -
 sound/core/misc.c                               |   94 ++++++++++++++++++
 sound/core/timer.c                              |   11 +-
 sound/pci/hda/patch_cirrus.c                    |    1 
 sound/pci/hda/patch_conexant.c                  |   11 +-
 sound/usb/bcd2000/bcd2000.c                     |    3 
 97 files changed, 742 insertions(+), 293 deletions(-)

Al Viro (6):
      nios2: page fault et.al. are *not* restartable syscalls...
      nios2: don't leave NULLs in sys_call_table[]
      nios2: traced syscall does need to check the syscall number
      nios2: fix syscall restart checks
      nios2: restarts apply only to the first sigframe we build...
      nios2: add force_successful_syscall_return()

Alexander Lobakin (2):
      ia64, processor: fix -Wincompatible-pointer-types in ia64_get_irr()
      x86/olpc: fix 'logical not is only applied to the left hand side'

Allen Ballway (1):
      ALSA: hda/cirrus - support for iMac 12,1 model

Amadeusz Sławiński (1):
      ALSA: info: Fix llseek return value when using callback

Andreas Gruenbacher (4):
      selinux: Minor cleanups
      proc: Pass file mode to proc_pid_make_inode
      selinux: Clean up initialization of isec->sclass
      selinux: Convert isec->lock into a spinlock

Baokun Li (3):
      ext4: add EXT4_INODE_HAS_XATTR_SPACE macro in xattr.h
      ext4: fix use-after-free in ext4_xattr_set_entry
      ext4: correct max_inline_xattr_value_size computing

ChenXiaoSong (1):
      ntfs: fix use-after-free in ntfs_ucsncmp()

Christian Borntraeger (1):
      include/uapi/linux/swab.h: fix userspace breakage, use __BITS_PER_LONG for swap

Christophe JAILLET (1):
      cxl: Fix a memory leak in an error handling path

Csókás Bence (1):
      fec: Fix timer capture timing in `fec_ptp_enable_pps()`

Damien Le Moal (1):
      ata: libata-eh: Add missing command name

Dan Carpenter (1):
      xen/xenbus: fix return type in xenbus_file_read()

Daniel Borkmann (1):
      bpf: fix overflow in prog accounting

Daniel Micay (1):
      init/main.c: extract early boot entropy from the passed cmdline

David Collins (1):
      spmi: trace: fix stack-out-of-bound access in SPMI tracing functions

David Howells (1):
      vfs: Check the truncate maximum size in inode_newsize_ok()

Duoming Zhou (1):
      atm: idt77252: fix use-after-free bugs caused by tst_timer

Eric Dumazet (1):
      tcp: fix over estimation in sk_forced_mem_schedule()

Eric Whitney (1):
      ext4: fix extent status tree race in writeback error recovery path

Filipe Manana (1):
      btrfs: fix lost error handling when looking up extended ref on log replay

Florian Westphal (2):
      netfilter: nf_queue: do not allow packet truncation below transport header offset
      netfilter: nf_tables: fix null deref due to zeroed list head

Greg Kroah-Hartman (2):
      ARM: crypto: comment out gcc warning that breaks clang builds
      Linux 4.9.326

Guenter Roeck (1):
      nios2: time: Read timer in get_cycles only if initialized

Hans-Christian Noren Egtvedt (1):
      random: only call boot_init_stack_canary() once

Helge Deller (1):
      parisc: Fix device names in /proc/iomem

Huacai Chen (1):
      MIPS: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK

Jamal Hadi Salim (1):
      net_sched: cls_route: disallow handle of 0

Jose Alonso (1):
      Revert "net: usb: ax88179_178a needs FLAG_SEND_ZLP"

Jozef Martiniak (1):
      gadgetfs: ep_io - wait until IRQ finishes

Kiselev, Oleg (1):
      ext4: avoid resizing to a partial cluster size

Kuniyuki Iwashima (1):
      net: ping6: Fix memleak in ipv6_renew_options().

Laura Abbott (1):
      init: move stack canary initialization after setup_arch

Liang He (5):
      scsi: ufs: host: Hold reference returned by of_parse_phandle()
      net: sungem_phy: Add of_node_put() for reference returned by of_get_parent()
      usb: host: ohci-ppc-of: Fix refcount leak bug
      tty: serial: Fix refcount leak bug in ucc_uart.c
      mips: cavium-octeon: Fix missing of_node_put() in octeon2_usb_clocks_start

Luiz Augusto von Dentz (2):
      Bluetooth: L2CAP: Fix use-after-free caused by l2cap_chan_put
      Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm regression

Lukas Czerner (1):
      ext4: make sure ext4_append() always allocates new block

Lukas Wunner (1):
      usbnet: Fix linkwatch use-after-free on disconnect

Maciej S. Szmigiero (1):
      KVM: SVM: Don't BUG if userspace injects an interrupt with GIF=0

Marc Kleine-Budde (1):
      can: ems_usb: fix clang's -Wunaligned-access warning

Meng Tang (1):
      ALSA: hda/conexant: Add quirk for LENOVO 20149 Notebook model

Miaoqian Lin (1):
      pinctrl: nomadik: Fix refcount leak in nmk_pinctrl_dt_subnode_to_map

Michael Ellerman (1):
      powerpc/powernv: Avoid crashing if rng is NULL

Miklos Szeredi (1):
      fuse: limit nsec

Mikulas Patocka (4):
      add barriers to buffer_uptodate and set_buffer_uptodate
      md-raid10: fix KASAN warning
      dm raid: fix address sanitizer warning in raid_status
      rds: add missing barrier to release_refill

Nathan Chancellor (2):
      ion: Make user_ion_handle_put_nolock() a void function
      MIPS: tlbex: Explicitly compare _PAGE_NO_EXEC against 0

Nikita Travkin (1):
      pinctrl: qcom: msm8916: Allow CAMSS GP clocks to be muxed

Ning Qiang (1):
      macintosh/adb: fix oob read in do_adb_query() function

Pablo Neira Ayuso (1):
      netfilter: nf_tables: really skip inactive sets when allocating name

Pali Rohár (2):
      PCI: Add defines for normal and subtractive PCI bridges
      powerpc/fsl-pci: Fix Class Code of PCIe Root Port

Paul Moore (1):
      selinux: fix inode_doinit_with_dentry() LABEL_INVALID error handling

Peilin Ye (1):
      vsock: Fix memory leak in vsock_connect()

Qu Wenruo (1):
      btrfs: reject log replay if there is unsupported RO compat flag

Sai Prakash Ranjan (1):
      irqchip/tegra: Fix overflow implicit truncation warnings

Schspa Shi (1):
      vfio: Clear the caps->buf to NULL after free

Sean Christopherson (1):
      KVM: x86: Mark TSS busy during LTR emulation _after_ all fault checks

Steffen Maier (1):
      scsi: zfcp: Fix missing auto port scan and thus missing target ports

Takashi Iwai (2):
      ALSA: core: Add async signal helpers
      ALSA: timer: Use deferred fasync helper

Thadeu Lima de Souza Cascardo (1):
      net_sched: cls_route: remove from list when handle is 0

Theodore Ts'o (1):
      ext4: update s_overhead_clusters in the superblock during an on-line resize

Tianyue Ren (1):
      selinux: fix error initialization in inode_doinit_with_dentry()

Timur Tabi (1):
      drm/nouveau: fix another off-by-one in nvbios_addr

Tony Battersby (1):
      scsi: sg: Allow waiting for commands to complete on removed device

Trond Myklebust (1):
      SUNRPC: Reinitialise the backchannel request buffers before reuse

Tyler Hicks (1):
      net/9p: Initialize the iounit field during fid creation

Viresh Kumar (2):
      init/main: Fix double "the" in comment
      init/main: properly align the multi-line comment

Wei Mingzhi (1):
      mt7601u: add USB device ID for some versions of XiaoDu WiFi Dongle.

Weitao Wang (1):
      USB: HCD: Fix URB giveback issue in tasklet function

Wentao_Liang (1):
      drivers:md:fix a potential use-after-free bug

Werner Sembach (2):
      ACPI: video: Force backlight native for some TongFang devices
      ACPI: video: Shortening quirk list by identifying Clevo by board_name only

Ye Bin (1):
      ext4: avoid remove directory when directory is corrupted

Zhang Xianwei (1):
      NFSv4.1: RECLAIM_COMPLETE must handle EACCES

Zheyu Ma (2):
      ALSA: bcd2000: Fix a UAF bug on the error path of probing
      video: fbdev: i740fb: Check the argument of i740_calc_vclk()

Zhouyi Zhou (1):
      powerpc/64: Init jump labels before parse_early_param()

