Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE9D6BE277
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 09:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbjCQIEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 04:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbjCQIEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 04:04:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9D82213C;
        Fri, 17 Mar 2023 01:04:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BA7E6220C;
        Fri, 17 Mar 2023 08:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C30C433EF;
        Fri, 17 Mar 2023 08:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679040247;
        bh=4Xe9/G16lGvhstrbnFRa9oxjcKbvVEZDuOTbKWIqIVg=;
        h=From:To:Cc:Subject:Date:From;
        b=VduA841s32O64PRRZN7astatbDB0FJp/z2gZoktmL65IlLZOtUZYpyMUzZI1F8gc+
         vg/kk4Detc5EayypnuT/X9uV4JjAXD/SN6ZdbsVti1jtz7t4zZcK0Lli2QlbO+p7uw
         iSp0oVZVLUA3JWsV/qNxwPPPh6n8GwwvDfP6+nf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.278
Date:   Fri, 17 Mar 2023 09:04:01 +0100
Message-Id: <1679040241149209@kroah.com>
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

I'm announcing the release of the 4.19.278 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 
 arch/alpha/kernel/module.c               |    4 -
 arch/mips/include/asm/mach-rc32434/pci.h |    2 
 arch/x86/kernel/cpu/amd.c                |    9 +++
 drivers/gpu/drm/i915/intel_ringbuffer.c  |    4 -
 drivers/macintosh/windfarm_lm75_sensor.c |    4 -
 drivers/macintosh/windfarm_smu_sensors.c |    4 -
 drivers/media/i2c/ov5640.c               |    2 
 drivers/nfc/fdp/i2c.c                    |    4 +
 drivers/scsi/hosts.c                     |    2 
 drivers/staging/mt7621-spi/spi-mt7621.c  |    8 ++-
 fs/ext4/fsmap.c                          |    2 
 fs/ext4/inline.c                         |    1 
 fs/ext4/inode.c                          |    7 ++
 fs/ext4/ioctl.c                          |    1 
 fs/ext4/namei.c                          |   13 ++---
 fs/ext4/xattr.c                          |    3 +
 fs/file.c                                |    1 
 fs/udf/directory.c                       |    2 
 fs/udf/file.c                            |    7 +-
 fs/udf/ialloc.c                          |   14 ++---
 fs/udf/inode.c                           |   76 +++++++++++++++++++++----------
 fs/udf/misc.c                            |    6 +-
 fs/udf/namei.c                           |    7 +-
 fs/udf/partition.c                       |    2 
 fs/udf/super.c                           |   12 ++++
 fs/udf/symlink.c                         |    2 
 fs/udf/udf_i.h                           |   12 ++--
 include/linux/pci_ids.h                  |    2 
 net/caif/caif_usb.c                      |    3 +
 net/ipv6/ila/ila_xlat.c                  |    1 
 net/nfc/netlink.c                        |    2 
 net/tipc/socket.c                        |    2 
 scripts/Makefile.build                   |    4 +
 34 files changed, 149 insertions(+), 78 deletions(-)

Alvaro Karsz (1):
      PCI: Add SolidRun vendor ID

Andrew Cooper (1):
      x86/CPU/AMD: Disable XSAVES on AMD family 0x17

Bart Van Assche (1):
      scsi: core: Remove the /proc/scsi/${proc_name} directory earlier

Darrick J. Wong (1):
      ext4: fix another off-by-one fsmap error on 1k block filesystems

Edward Humes (1):
      alpha: fix R_ALPHA_LITERAL reloc for large modules

Eric Dumazet (1):
      ila: do not generate empty messages in ila_xlat_nl_cmd_get_mapping()

Eric Whitney (1):
      ext4: fix RENAME_WHITEOUT handling for inline directories

Fedor Pchelkin (1):
      nfc: change order inside nfc_se_io error path

Greg Kroah-Hartman (1):
      Linux 4.19.278

Jan Kara (4):
      udf: Explain handling of load_nls() failure
      udf: Remove pointless union in udf_inode_info
      udf: Preserve link count of system files
      udf: Detect system inodes linked into directory hierarchy

John Harrison (1):
      drm/i915: Don't use BAR mappings for ring buffers with LLC

Kang Chen (1):
      nfc: fdp: add null check of devm_kmalloc_array in fdp_nci_i2c_read_device_properties

Masahiro Yamada (2):
      kbuild: fix false-positive need-builtin calculation
      kbuild: generate modules.order only in directories visited by obj-y/m

Nathan Chancellor (1):
      macintosh: windfarm: Use unsigned type for 1-bit bitfields

Nobuhiro Iwamatsu (1):
      Revert "spi: mt7621: Fix an error message in mt7621_spi_probe()"

Paul Elder (1):
      media: ov5640: Fix analogue gain control

Shigeru Yoshida (1):
      net: caif: Fix use-after-free in cfusbl_device_notify()

Steven J. Magnani (1):
      udf: reduce leakage of blocks related to named streams

Theodore Ts'o (1):
      fs: prevent out-of-bounds array speculation when closing a file descriptor

Tung Nguyen (1):
      tipc: improve function tipc_wait_for_cond()

Ye Bin (2):
      ext4: move where set the MAY_INLINE_DATA flag is set
      ext4: fix WARNING in ext4_update_inline_data

Zhihao Cheng (1):
      ext4: zero i_disksize when initializing the bootloader inode

xurui (1):
      MIPS: Fix a compilation issue

