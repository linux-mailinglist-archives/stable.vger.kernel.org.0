Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1299B612183
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 10:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiJ2InI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Oct 2022 04:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiJ2Imd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Oct 2022 04:42:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFB618DAAB;
        Sat, 29 Oct 2022 01:42:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9EC0CCE3074;
        Sat, 29 Oct 2022 08:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7572EC433C1;
        Sat, 29 Oct 2022 08:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667032946;
        bh=RqzbEjN+FXY5xRnkIO4L+Yu94qzjeKDiE82xP9FWkZI=;
        h=From:To:Cc:Subject:Date:From;
        b=vFbdFYEZsOc71JsS+NvLvHCX7ejcYHuD8e7jt+MSDAlMI1GhtEYFPVNJJRf0/bIAO
         BIsK8l6lsv0BGguakriuN/QFsvEUO29biCFVjdAqnGdKXZh82DIs2lfneS986/Yx5w
         W//2d50Mt7OJgaAd7RXrOXVaVMKyFxxgW0lUn2bs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.221
Date:   Sat, 29 Oct 2022 10:43:10 +0200
Message-Id: <16670329903578@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.221 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/arm64/silicon-errata.rst    |    4 
 Makefile                                  |    6 -
 arch/arm64/Kconfig                        |   16 +++
 arch/arm64/include/asm/cpucaps.h          |    3 
 arch/arm64/kernel/cpu_errata.c            |   16 +++
 arch/arm64/kernel/cpufeature.c            |   13 ++
 arch/arm64/kernel/topology.c              |   40 --------
 arch/riscv/Kconfig                        |    2 
 arch/riscv/kernel/smpboot.c               |    4 
 arch/x86/kernel/cpu/microcode/amd.c       |   16 ++-
 drivers/acpi/acpi_extlog.c                |   33 ++++--
 drivers/acpi/video_detect.c               |   64 +++++++++++++
 drivers/ata/ahci.h                        |    2 
 drivers/ata/ahci_imx.c                    |    2 
 drivers/base/arch_topology.c              |   19 ++++
 drivers/hid/hid-magicmouse.c              |    2 
 drivers/hwmon/coretemp.c                  |   56 ++++++++---
 drivers/iommu/intel-iommu.c               |    5 +
 drivers/media/platform/qcom/venus/vdec.c  |    2 
 drivers/net/ethernet/hisilicon/hns/hnae.c |    4 
 drivers/net/hyperv/hyperv_net.h           |    3 
 drivers/net/hyperv/netvsc.c               |    4 
 drivers/net/hyperv/netvsc_drv.c           |   20 ++++
 drivers/net/phy/dp83867.c                 |    8 +
 drivers/net/usb/cdc_ether.c               |    7 +
 drivers/net/usb/r8152.c                   |    1 
 fs/btrfs/backref.c                        |   46 ++++++---
 fs/ocfs2/namei.c                          |   23 ++--
 fs/proc/task_mmu.c                        |    2 
 fs/xfs/libxfs/xfs_alloc.c                 |    2 
 fs/xfs/libxfs/xfs_attr_leaf.c             |    6 -
 fs/xfs/libxfs/xfs_bmap.c                  |   32 ------
 fs/xfs/libxfs/xfs_bmap.h                  |    3 
 fs/xfs/libxfs/xfs_btree.c                 |    2 
 fs/xfs/libxfs/xfs_da_btree.c              |   10 +-
 fs/xfs/libxfs/xfs_dir2_block.c            |   33 ++++++
 fs/xfs/libxfs/xfs_dir2_data.c             |   32 ++++++
 fs/xfs/libxfs/xfs_dir2_leaf.c             |    2 
 fs/xfs/libxfs/xfs_dir2_node.c             |    8 -
 fs/xfs/libxfs/xfs_dquot_buf.c             |    8 -
 fs/xfs/libxfs/xfs_format.h                |   10 +-
 fs/xfs/libxfs/xfs_trans_resv.c            |    6 -
 fs/xfs/xfs_attr_inactive.c                |    6 -
 fs/xfs/xfs_attr_list.c                    |    2 
 fs/xfs/xfs_bmap_util.c                    |   57 ++++++------
 fs/xfs/xfs_buf.c                          |   22 ++++
 fs/xfs/xfs_buf.h                          |    2 
 fs/xfs/xfs_dquot.c                        |   26 ++---
 fs/xfs/xfs_dquot.h                        |   98 ++++++++++----------
 fs/xfs/xfs_dquot_item.c                   |   47 +++++++--
 fs/xfs/xfs_dquot_item.h                   |   35 ++++---
 fs/xfs/xfs_error.c                        |    7 +
 fs/xfs/xfs_error.h                        |    2 
 fs/xfs/xfs_export.c                       |   14 --
 fs/xfs/xfs_file.c                         |   16 +--
 fs/xfs/xfs_inode.c                        |   23 ++++
 fs/xfs/xfs_inode.h                        |    1 
 fs/xfs/xfs_inode_item.c                   |   28 ++---
 fs/xfs/xfs_log.c                          |   26 ++---
 fs/xfs/xfs_log_cil.c                      |   39 +++++++-
 fs/xfs/xfs_log_priv.h                     |   53 +++++++++--
 fs/xfs/xfs_log_recover.c                  |    5 -
 fs/xfs/xfs_mount.h                        |    5 +
 fs/xfs/xfs_qm.c                           |   64 ++++++++-----
 fs/xfs/xfs_qm_bhv.c                       |    6 -
 fs/xfs/xfs_qm_syscalls.c                  |  142 ++++++++++++++----------------
 fs/xfs/xfs_stats.c                        |   10 +-
 fs/xfs/xfs_super.c                        |   28 ++++-
 fs/xfs/xfs_trace.h                        |    1 
 fs/xfs/xfs_trans_ail.c                    |   88 +++++++++++-------
 fs/xfs/xfs_trans_dquot.c                  |   54 +++++------
 fs/xfs/xfs_trans_priv.h                   |    6 -
 net/atm/mpoa_proc.c                       |    3 
 net/sched/sch_cake.c                      |    4 
 net/tipc/discover.c                       |    2 
 net/tipc/topsrv.c                         |    2 
 virt/kvm/arm/vgic/vgic-its.c              |    5 -
 77 files changed, 972 insertions(+), 534 deletions(-)

Alexander Potapenko (1):
      tipc: fix an information leak in tipc_topsrv_kern_subscr

Alexander Stein (1):
      ata: ahci-imx: Fix MODULE_ALIAS

Borislav Petkov (1):
      x86/microcode/AMD: Apply the patch early on every logical thread

Brian Foster (6):
      xfs: open code insert range extent split helper
      xfs: rework insert range into an atomic operation
      xfs: rework collapse range into an atomic operation
      xfs: factor out quotaoff intent AIL removal and memory free
      xfs: fix unmount hang and memory leak on shutdown during quotaoff
      xfs: trylock underlying buffer on dquot flush

Bryan O'Donoghue (1):
      media: venus: dec: Handle the case where find_format fails

Christoph Hellwig (2):
      xfs: factor out a new xfs_log_force_inode helper
      xfs: reflink should force the log out if mounted with wsync

Conor Dooley (2):
      arm64: topology: move store_cpu_topology() to shared code
      riscv: topology: fix default topology reporting

Darrick J. Wong (8):
      xfs: add a function to deal with corrupt buffers post-verifiers
      xfs: xfs_buf_corruption_error should take __this_address
      xfs: fix buffer corruption reporting when xfs_dir3_free_header_check fails
      xfs: check owner of dir3 data blocks
      xfs: check owner of dir3 blocks
      xfs: preserve default grace interval during quotacheck
      xfs: don't write a corrupt unmount record to force summary counter recalc
      xfs: move inode flush to the sync workqueue

Dave Chinner (5):
      xfs: Lower CIL flush limit for large logs
      xfs: Throttle commits on delayed background CIL push
      xfs: factor common AIL item deletion code
      xfs: tail updates only need to occur when LSN changes
      xfs: fix use-after-free on CIL context on shutdown

Eric Ren (1):
      KVM: arm64: vgic: Fix exit condition in scan_its_table()

Filipe Manana (2):
      btrfs: fix processing of delayed data refs during backref walking
      btrfs: fix processing of delayed tree block refs during backref walking

Gaurav Kohli (1):
      hv_netvsc: Fix race between VF offering and VF association message from host

Greg Kroah-Hartman (1):
      Linux 5.4.221

Harini Katakam (1):
      net: phy: dp83867: Extend RX strap quirk for SGMII mode

James Morse (1):
      arm64: errata: Remove AES hwcap for COMPAT tasks

Jean-Francois Le Fillatre (1):
      r8152: add PID for the Lenovo OneLink+ Dock

Jerry Snitselaar (1):
      iommu/vt-d: Clean up si_domain in the init_dmars() error path

Joseph Qi (2):
      ocfs2: clear dinode links count in case of error
      ocfs2: fix BUG when iput after ocfs2_mknod fails

José Expósito (1):
      HID: magicmouse: Do not set BTN_MOUSE on double report

Kai-Heng Feng (1):
      ata: ahci: Match EM_MAX_SLOTS with SATA_PMP_MAX_PORTS

Mark Tomlinson (1):
      tipc: Fix recognition of trial period

Nick Desaulniers (1):
      Makefile.debug: re-enable debug info for .S files

Pavel Reichl (4):
      xfs: remove the xfs_disk_dquot_t and xfs_dquot_t
      xfs: remove the xfs_dq_logitem_t typedef
      xfs: remove the xfs_qoff_logitem_t typedef
      xfs: Replace function declaration by actual definition

Seth Jenkins (1):
      mm: /proc/pid/smaps_rollup: fix no vma's null-deref

Takashi Iwai (1):
      xfs: Use scnprintf() for avoiding potential buffer overflow

Tony Luck (1):
      ACPI: extlog: Handle multiple records

Werner Sembach (1):
      ACPI: video: Force backlight native for more TongFang devices

Xiaobo Liu (1):
      net/atm: fix proc_mpc_write incorrect return value

Yang Yingliang (1):
      net: hns: fix possible memory leak in hnae_ae_register()

Zhang Rui (1):
      hwmon/coretemp: Handle large core ID value

Zhengchao Shao (1):
      net: sched: cake: fix null pointer access issue when cake_init() fails

