Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A956BE280
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 09:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjCQIE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 04:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbjCQIEX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 04:04:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F107CB0485;
        Fri, 17 Mar 2023 01:04:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 468026220E;
        Fri, 17 Mar 2023 08:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52874C4339C;
        Fri, 17 Mar 2023 08:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679040254;
        bh=rzB7RrviIhQcEBMScVKljh5UOTUaIFYb4aY6ZZGwOXU=;
        h=From:To:Cc:Subject:Date:From;
        b=Yp5GgYo+bAhvwIgEBAtBDZdXQrsV4BidFoudCEXhgc9UGsEpJm9OkpwCdcatlwkCL
         PHntr0hr1ZkjVZMELl4tKgMa0aJRhBtIh0wTG/bDYIne1FSohKAVz3s3xUsMjJ/lSh
         o9lVAadWr/5CwfuW+2oAQUFO9+2cltNB3PbZGg5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.237
Date:   Fri, 17 Mar 2023 09:04:08 +0100
Message-Id: <1679040248114102@kroah.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.237 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt |   51 +++++-
 Makefile                                        |    2 
 arch/alpha/kernel/module.c                      |    4 
 arch/mips/include/asm/mach-rc32434/pci.h        |    2 
 arch/powerpc/kernel/vmlinux.lds.S               |    6 
 arch/riscv/kernel/stacktrace.c                  |    2 
 arch/s390/kernel/vmlinux.lds.S                  |    2 
 arch/sh/kernel/vmlinux.lds.S                    |    1 
 arch/um/kernel/vmlinux.lds.S                    |    2 
 arch/x86/kernel/cpu/amd.c                       |    9 +
 arch/x86/kernel/vmlinux.lds.S                   |    2 
 drivers/char/ipmi/ipmi_ssif.c                   |  146 ++++++------------
 drivers/char/ipmi/ipmi_watchdog.c               |    8 -
 drivers/gpu/drm/drm_atomic.c                    |    1 
 drivers/gpu/drm/i915/gt/intel_ringbuffer.c      |    4 
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c           |    4 
 drivers/iommu/amd_iommu_init.c                  |  105 ++++++++++---
 drivers/iommu/intel-pasid.c                     |    7 
 drivers/macintosh/windfarm_lm75_sensor.c        |    4 
 drivers/macintosh/windfarm_smu_sensors.c        |    4 
 drivers/media/i2c/ov5640.c                      |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c       |   23 +-
 drivers/net/phy/microchip.c                     |   32 ++++
 drivers/net/usb/lan78xx.c                       |  189 +++++++++---------------
 drivers/nfc/fdp/i2c.c                           |    4 
 drivers/s390/block/dasd_diag.c                  |    7 
 drivers/s390/block/dasd_fba.c                   |    7 
 drivers/s390/block/dasd_int.h                   |    1 
 drivers/scsi/hosts.c                            |    2 
 drivers/scsi/megaraid/megaraid_sas.h            |    2 
 drivers/scsi/megaraid/megaraid_sas_fp.c         |    2 
 fs/cifs/cifsacl.c                               |   14 -
 fs/cifs/cifsfs.c                                |    2 
 fs/cifs/cifsglob.h                              |    6 
 fs/cifs/cifsproto.h                             |    8 +
 fs/cifs/connect.c                               |    2 
 fs/cifs/dir.c                                   |    5 
 fs/cifs/file.c                                  |   10 -
 fs/cifs/inode.c                                 |    8 -
 fs/cifs/ioctl.c                                 |    2 
 fs/cifs/link.c                                  |   18 --
 fs/cifs/smb1ops.c                               |   19 +-
 fs/cifs/smb2inode.c                             |    9 -
 fs/cifs/smb2ops.c                               |   92 ++++-------
 fs/cifs/smb2proto.h                             |    2 
 fs/ext4/fsmap.c                                 |    2 
 fs/ext4/inline.c                                |    1 
 fs/ext4/inode.c                                 |    7 
 fs/ext4/ioctl.c                                 |    1 
 fs/ext4/namei.c                                 |   36 +++-
 fs/ext4/xattr.c                                 |    3 
 fs/file.c                                       |    1 
 include/asm-generic/vmlinux.lds.h               |   16 +-
 include/linux/irqdomain.h                       |    2 
 include/linux/pci_ids.h                         |    2 
 include/net/netfilter/nf_tproxy.h               |    7 
 kernel/bpf/btf.c                                |    1 
 kernel/irq/irqdomain.c                          |   62 +++++--
 net/caif/caif_usb.c                             |    3 
 net/ipv4/netfilter/nf_tproxy_ipv4.c             |    2 
 net/ipv6/ila/ila_xlat.c                         |    1 
 net/ipv6/netfilter/nf_tproxy_ipv6.c             |    2 
 net/nfc/netlink.c                               |    2 
 net/smc/af_smc.c                                |   13 +
 tools/testing/selftests/netfilter/nft_nat.sh    |    2 
 65 files changed, 557 insertions(+), 443 deletions(-)

Alexandre Ghiti (1):
      riscv: Use READ_ONCE_NOCHECK in imprecise unwinding stack mode

Alvaro Karsz (1):
      PCI: Add SolidRun vendor ID

Amir Goldstein (1):
      SMB3: Backup intent flag missing from some more ops

Andrew Cooper (1):
      x86/CPU/AMD: Disable XSAVES on AMD family 0x17

Bart Van Assche (1):
      scsi: core: Remove the /proc/scsi/${proc_name} directory earlier

Bixuan Cui (1):
      irqdomain: Change the type of 'size' in __irq_domain_add() to be consistent

Chandrakanth Patil (1):
      scsi: megaraid_sas: Update max supported LD IDs to 240

Corey Minyard (5):
      ipmi:ssif: resend_msg() cannot fail
      ipmi:ssif: Remove rtc_us_timer
      ipmi:ssif: Increase the message retry time
      ipmi:ssif: Add a timer between request retries
      ipmi:watchdog: Set panic count to proper value on a panic

D. Wythe (1):
      net/smc: fix fallback failed while sendmsg with fastopen

Darrick J. Wong (1):
      ext4: fix another off-by-one fsmap error on 1k block filesystems

Dmitry Baryshkov (1):
      drm/msm/a5xx: fix setting of the CP_PREEMPT_ENABLE_LOCAL register

Edward Humes (1):
      alpha: fix R_ALPHA_LITERAL reloc for large modules

Eric Dumazet (1):
      ila: do not generate empty messages in ila_xlat_nl_cmd_get_mapping()

Eric Whitney (1):
      ext4: fix RENAME_WHITEOUT handling for inline directories

Fedor Pchelkin (1):
      nfc: change order inside nfc_se_io error path

Florian Westphal (1):
      netfilter: tproxy: fix deadlock due to missing BH disable

Gavrilov Ilia (1):
      iommu/amd: Add a length limitation for the ivrs_acpihid command-line parameter

Greg Kroah-Hartman (1):
      Linux 5.4.237

H.J. Lu (1):
      x86, vmlinux.lds: Add RUNTIME_DISCARD_EXIT to generic DISCARDS

Hangbin Liu (1):
      selftests: nft_nat: ensuring the listening side is up before starting the client

Harry Wentland (1):
      drm/connector: print max_requested_bpc in state debugfs

Jacob Pan (1):
      iommu/vt-d: Fix PASID directory pointer coherency

Jan Kara (2):
      ext4: Fix possible corruption when moving a directory
      ext4: Fix deadlock during directory rename

John Harrison (1):
      drm/i915: Don't use BAR mappings for ring buffers with LLC

Kang Chen (1):
      nfc: fdp: add null check of devm_kmalloc_array in fdp_nci_i2c_read_device_properties

Kim Phillips (1):
      iommu/amd: Fix ill-formed ivrs_ioapic, ivrs_hpet and ivrs_acpihid options

Lee Jones (1):
      net: usb: lan78xx: Remove lots of set but unused 'ret' variables

Liguang Zhang (1):
      ipmi:ssif: make ssif_i2c_send() void

Lorenz Bauer (1):
      btf: fix resolving BTF_KIND_VAR after ARRAY, STRUCT, UNION, PTR

Marc Zyngier (1):
      irqdomain: Fix domain registration race

Masahiro Yamada (3):
      arch: fix broken BuildID for arm64 and riscv
      s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36
      UML: define RUNTIME_DISCARD_EXIT

Michael Chan (1):
      bnxt_en: Avoid order-5 memory allocation for TPA data

Michael Ellerman (2):
      powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
      powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds

Nathan Chancellor (1):
      macintosh: windfarm: Use unsigned type for 1-bit bitfields

Paul Elder (1):
      media: ov5640: Fix analogue gain control

Shigeru Yoshida (1):
      net: caif: Fix use-after-free in cfusbl_device_notify()

Stefan Haberland (1):
      s390/dasd: add missing discipline function

Suravee Suthikulpanit (1):
      iommu/amd: Add PCI segment support for ivrs_[ioapic/hpet/acpihid] commands

Theodore Ts'o (1):
      fs: prevent out-of-bounds array speculation when closing a file descriptor

Tom Saeger (1):
      sh: define RUNTIME_DISCARD_EXIT

Volker Lendecke (1):
      cifs: Fix uninitialized memory read in smb3_qfs_tcon()

Ye Bin (2):
      ext4: move where set the MAY_INLINE_DATA flag is set
      ext4: fix WARNING in ext4_update_inline_data

Yejune Deng (1):
      ipmi/watchdog: replace atomic_add() and atomic_sub()

Yuiko Oshino (1):
      net: lan78xx: fix accessing the LAN7800's internal phy specific registers from the MAC driver

Zhihao Cheng (1):
      ext4: zero i_disksize when initializing the bootloader inode

xurui (1):
      MIPS: Fix a compilation issue

