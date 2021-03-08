Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C302C330DBF
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhCHMcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:32:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:40940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231734AbhCHMbt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:31:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A2F264EBC;
        Mon,  8 Mar 2021 12:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206708;
        bh=O9FQY07aGWbMSCNkZhMqrNSyjIHNGPemolofsgQjK+0=;
        h=From:To:Cc:Subject:Date:From;
        b=16n/LB9xDlyVRJjgx9fGWBXS+vhzC2zrZqGcEjmrKbJU5rBzmU7s9x9aFNMo3Z6q1
         DXEKPZL4jebx33gd59lCL2PjfLyv8ylvrtvB0esb1B9rmFTsb6thv1cC6Eaoa2QUYP
         Ugj6BF6y3ICO7SVLmWDDGfP1jaLPsmzaZdfzi6Fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/22] 5.4.104-rc1 review
Date:   Mon,  8 Mar 2021 13:30:17 +0100
Message-Id: <20210308122714.391917404@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.104-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.104-rc1
X-KernelTest-Deadline: 2021-03-10T12:27+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.104 release.
There are 22 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 10 Mar 2021 12:27:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.104-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.104-rc1

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix resuming from suspend on RTL8105e if machine runs on battery

Dan Carpenter <dan.carpenter@oracle.com>
    rsxx: Return -EFAULT if copy_to_user() fails

Chen Jun <chenjun102@huawei.com>
    ftrace: Have recordmcount use w8 to read relp->r_info in arm64_is_fake_mcount

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: hda: intel-nhlt: verify config type

YueHaibing <yuehaibing@huawei.com>
    IB/mlx5: Add missing error code

Julian Braha <julianbraha@gmail.com>
    RDMA/rxe: Fix missing kconfig dependency on CRYPTO

Colin Ian King <colin.king@canonical.com>
    ALSA: ctxfi: cthw20k2: fix mask on conf to allow 4 bits

Antonio Borneo <borneo.antonio@gmail.com>
    usbip: tools: fix build error for multiple definition

Ard Biesheuvel <ardb@kernel.org>
    crypto - shash: reduce minimum alignment of shash_desc structure

Timothy E Baldwin <T.E.Baldwin99@members.leeds.ac.uk>
    arm64: ptrace: Fix seccomp of traced syscall -1 (NO_SYSCALL)

Kevin Wang <kevin1.wang@amd.com>
    drm/amdgpu: fix parameter error of RREG32_PCIE() in amdgpu_regs_pcie

Milan Broz <gmazyland@gmail.com>
    dm verity: fix FEC for RS roots unaligned to block size

Mikulas Patocka <mpatocka@redhat.com>
    dm bufio: subtract the number of initial sectors in dm_bufio_get_device_size

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Update device status before letting suppliers suspend

Filipe Manana <fdmanana@suse.com>
    btrfs: fix warning when creating a directory with smack enabled

Nikolay Borisov <nborisov@suse.com>
    btrfs: unlock extents in btrfs_zero_range in case of quota reservation errors

Nikolay Borisov <nborisov@suse.com>
    btrfs: free correct amount of space in btrfs_delayed_inode_reserve_metadata

Dan Carpenter <dancarpenter@oracle.com>
    btrfs: validate qgroup inherit for SNAP_CREATE_V2 ioctl

Ira Weiny <ira.weiny@intel.com>
    btrfs: fix raid6 qstripe kmap

David Sterba <dsterba@suse.com>
    btrfs: raid56: simplify tracking of Q stripe presence

Jarkko Sakkinen <jarkko@kernel.org>
    tpm, tpm_tis: Decorate tpm_get_timeouts() with request_locality()

Lukasz Majczak <lma@semihalf.com>
    tpm, tpm_tis: Decorate tpm_tis_gen_interrupt() with request_locality()


-------------

Diffstat:

 Makefile                                    |  4 +-
 arch/arm64/kernel/ptrace.c                  |  2 +-
 drivers/base/power/runtime.c                | 62 +++++++++++++++++------------
 drivers/block/rsxx/core.c                   |  8 ++--
 drivers/char/tpm/tpm_tis_core.c             | 30 +++++++++++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |  4 +-
 drivers/infiniband/hw/mlx5/devx.c           |  4 +-
 drivers/infiniband/sw/rxe/Kconfig           |  1 +
 drivers/md/dm-bufio.c                       |  4 ++
 drivers/md/dm-verity-fec.c                  | 23 ++++++-----
 drivers/net/ethernet/realtek/r8169_main.c   |  2 +
 fs/btrfs/delayed-inode.c                    |  2 +-
 fs/btrfs/file.c                             |  5 ++-
 fs/btrfs/ioctl.c                            | 19 ++++++++-
 fs/btrfs/raid56.c                           | 58 ++++++++++++---------------
 fs/btrfs/xattr.c                            | 31 +++++++++++++--
 include/crypto/hash.h                       |  8 ++--
 include/linux/crypto.h                      |  9 +++--
 include/sound/intel-nhlt.h                  |  5 +++
 scripts/recordmcount.c                      |  2 +-
 sound/hda/intel-nhlt.c                      | 54 ++++++++++++++++++++-----
 sound/pci/ctxfi/cthw20k2.c                  |  2 +-
 tools/usb/usbip/libsrc/usbip_host_common.c  |  2 +-
 23 files changed, 232 insertions(+), 109 deletions(-)


