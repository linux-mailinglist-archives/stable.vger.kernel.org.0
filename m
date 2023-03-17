Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE4A6BE275
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 09:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjCQIEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 04:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbjCQIEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 04:04:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5296B9CFD5;
        Fri, 17 Mar 2023 01:04:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BE6E6220C;
        Fri, 17 Mar 2023 08:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB07C433D2;
        Fri, 17 Mar 2023 08:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679040239;
        bh=dVmNReL976Q/T1SRRni2Dc+GHUdTllKUrm6ukZxmJ9k=;
        h=From:To:Cc:Subject:Date:From;
        b=B71wa6AG7rW/FlB8+4IuFJ1oJBVQjaqklJmcol4phvY6ndlPBUhcxv59qLkue+KaG
         U4be6X0YfILTmcPwPUi3TkUJoum0aQxBYC1mS5xHayOblrEWcRqFcZj6zuN5Joyw9n
         WBkFayuFa3/lVW5OyNJeRdBKU1hJLu1YH8gFXJm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.310
Date:   Fri, 17 Mar 2023 09:03:56 +0100
Message-Id: <1679040236109254@kroah.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.310 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 +-
 arch/alpha/kernel/module.c               |    4 +---
 arch/mips/include/asm/mach-rc32434/pci.h |    2 +-
 arch/x86/kernel/cpu/amd.c                |   11 ++++++++++-
 drivers/gpu/drm/i915/intel_ringbuffer.c  |    4 ++--
 drivers/macintosh/windfarm_lm75_sensor.c |    4 ++--
 drivers/macintosh/windfarm_smu_sensors.c |    4 ++--
 drivers/media/i2c/ov5640.c               |    2 +-
 drivers/nfc/fdp/i2c.c                    |    4 ++++
 fs/ext4/fsmap.c                          |    2 ++
 fs/ext4/inline.c                         |    1 -
 fs/ext4/inode.c                          |    7 ++++++-
 fs/ext4/ioctl.c                          |    1 +
 fs/ext4/namei.c                          |   13 +++++++------
 fs/ext4/xattr.c                          |    3 +++
 fs/file.c                                |    1 +
 include/linux/pci_ids.h                  |    2 ++
 net/caif/caif_usb.c                      |    3 +++
 net/ipv6/ila/ila_xlat.c                  |    1 +
 net/nfc/netlink.c                        |    2 +-
 net/tipc/socket.c                        |    2 +-
 21 files changed, 52 insertions(+), 23 deletions(-)

Alvaro Karsz (1):
      PCI: Add SolidRun vendor ID

Andrew Cooper (1):
      x86/CPU/AMD: Disable XSAVES on AMD family 0x17

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
      Linux 4.14.310

John Harrison (1):
      drm/i915: Don't use BAR mappings for ring buffers with LLC

Kang Chen (1):
      nfc: fdp: add null check of devm_kmalloc_array in fdp_nci_i2c_read_device_properties

Nathan Chancellor (1):
      macintosh: windfarm: Use unsigned type for 1-bit bitfields

Paul Elder (1):
      media: ov5640: Fix analogue gain control

Rhythm Mahajan (1):
      x86/cpu: Fix LFENCE serialization check in init_amd()

Shigeru Yoshida (1):
      net: caif: Fix use-after-free in cfusbl_device_notify()

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

