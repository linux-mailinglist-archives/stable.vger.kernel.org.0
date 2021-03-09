Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DEA332320
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 11:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbhCIKe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 05:34:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:42360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229837AbhCIKeb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Mar 2021 05:34:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D4EB65266;
        Tue,  9 Mar 2021 10:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615286071;
        bh=oeAVH7jb3YMnY1k9zqq79mJPGWoE7Nm677t7rgligfs=;
        h=From:To:Cc:Subject:Date:From;
        b=2L+sHrI1H2vEhdufaOddzBQKHewWk5YDJqfEjbsOneMnG+04LiV9HhVewh15p82ah
         aBZac4G6kkR4kkRH1mD/IaLrtZHzVJAtV3xrRbm+sjmnfssKGSjGl4NlIhM73MyEVI
         Ya0iEy010jTA81ykice4rafimoaDWhinxoI1Vdrw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.104
Date:   Tue,  9 Mar 2021 11:34:25 +0100
Message-Id: <161528606622750@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I'm announcing the release of the 5.4.104 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 arch/arm64/kernel/ptrace.c                  |    2 
 drivers/base/power/runtime.c                |   62 ++++++++++++++++------------
 drivers/block/rsxx/core.c                   |    8 ++-
 drivers/char/tpm/tpm_tis_core.c             |   30 +++++++++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    4 -
 drivers/infiniband/hw/mlx5/devx.c           |    4 +
 drivers/infiniband/sw/rxe/Kconfig           |    1 
 drivers/md/dm-bufio.c                       |    4 +
 drivers/md/dm-verity-fec.c                  |   23 +++++-----
 drivers/net/ethernet/realtek/r8169_main.c   |    2 
 fs/btrfs/delayed-inode.c                    |    2 
 fs/btrfs/file.c                             |    5 +-
 fs/btrfs/ioctl.c                            |   19 ++++++++
 fs/btrfs/raid56.c                           |   58 +++++++++++---------------
 fs/btrfs/xattr.c                            |   31 ++++++++++++--
 include/crypto/hash.h                       |    8 +--
 include/linux/crypto.h                      |    9 ++--
 include/sound/intel-nhlt.h                  |    5 ++
 scripts/recordmcount.c                      |    2 
 sound/hda/intel-nhlt.c                      |   54 ++++++++++++++++++++----
 sound/pci/ctxfi/cthw20k2.c                  |    2 
 tools/usb/usbip/libsrc/usbip_host_common.c  |    2 
 23 files changed, 231 insertions(+), 108 deletions(-)

Antonio Borneo (1):
      usbip: tools: fix build error for multiple definition

Ard Biesheuvel (1):
      crypto - shash: reduce minimum alignment of shash_desc structure

Chen Jun (1):
      ftrace: Have recordmcount use w8 to read relp->r_info in arm64_is_fake_mcount

Colin Ian King (1):
      ALSA: ctxfi: cthw20k2: fix mask on conf to allow 4 bits

Dan Carpenter (2):
      btrfs: validate qgroup inherit for SNAP_CREATE_V2 ioctl
      rsxx: Return -EFAULT if copy_to_user() fails

David Sterba (1):
      btrfs: raid56: simplify tracking of Q stripe presence

Filipe Manana (1):
      btrfs: fix warning when creating a directory with smack enabled

Greg Kroah-Hartman (1):
      Linux 5.4.104

Heiner Kallweit (1):
      r8169: fix resuming from suspend on RTL8105e if machine runs on battery

Ira Weiny (1):
      btrfs: fix raid6 qstripe kmap

Jarkko Sakkinen (1):
      tpm, tpm_tis: Decorate tpm_get_timeouts() with request_locality()

Julian Braha (1):
      RDMA/rxe: Fix missing kconfig dependency on CRYPTO

Kevin Wang (1):
      drm/amdgpu: fix parameter error of RREG32_PCIE() in amdgpu_regs_pcie

Lukasz Majczak (1):
      tpm, tpm_tis: Decorate tpm_tis_gen_interrupt() with request_locality()

Mikulas Patocka (1):
      dm bufio: subtract the number of initial sectors in dm_bufio_get_device_size

Milan Broz (1):
      dm verity: fix FEC for RS roots unaligned to block size

Nikolay Borisov (2):
      btrfs: free correct amount of space in btrfs_delayed_inode_reserve_metadata
      btrfs: unlock extents in btrfs_zero_range in case of quota reservation errors

Pierre-Louis Bossart (1):
      ALSA: hda: intel-nhlt: verify config type

Rafael J. Wysocki (1):
      PM: runtime: Update device status before letting suppliers suspend

Timothy E Baldwin (1):
      arm64: ptrace: Fix seccomp of traced syscall -1 (NO_SYSCALL)

YueHaibing (1):
      IB/mlx5: Add missing error code

