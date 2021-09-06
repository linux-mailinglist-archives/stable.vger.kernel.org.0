Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A9F401B9D
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242659AbhIFM6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:58:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242511AbhIFM6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:58:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C38D60F92;
        Mon,  6 Sep 2021 12:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933016;
        bh=vfCIdf557wb/oZgaUmYl1uK0hHeBGiEZCLfE1FBDQkA=;
        h=From:To:Cc:Subject:Date:From;
        b=zuVK3I0Q8+IWRsoAyS8CxZpBQ2FUqDWPcKX6vt6RSdqvMmo8Adi0HNt6ztrz3eFS9
         J331HnKVtkjtq6gOfMAojS6UFOZw3Iw26zbsCFqn3M8XWzZqCXgAZmJeYhceJazeT1
         sgdNn1VWr/AmgiqbR6SwQ6kSxg4CM3J0LQMucc1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/29] 5.10.63-rc1 review
Date:   Mon,  6 Sep 2021 14:55:15 +0200
Message-Id: <20210906125449.756437409@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.63-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.63-rc1
X-KernelTest-Deadline: 2021-09-08T12:54+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.63 release.
There are 29 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.63-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.63-rc1

Pavel Skripkin <paskripkin@gmail.com>
    media: stkwebcam: fix memory leak in stk_camera_probe

Amir Goldstein <amir73il@gmail.com>
    fuse: fix illegal access to inode with reused nodeid

Al Viro <viro@zeniv.linux.org.uk>
    new helper: inode_wrong_type()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: Switch to signed types for *_native_cs SPI controller fields

Vignesh Raghavendra <vigneshr@ti.com>
    serial: 8250: 8250_omap: Fix possible array out of bounds access

Zubin Mithra <zsm@chromium.org>
    ALSA: pcm: fix divide error in snd_pcm_lib_ioctl

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Workaround for conflicting SSID on ASUS ROG Strix G17

Johnathon Clark <john.clark@cantab.net>
    ALSA: hda/realtek: Quirk for HP Spectre x360 14 amp setup

Christoph Hellwig <hch@lst.de>
    cryptoloop: add a deprecation warning

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/power: Assign pmu.module

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/ibs: Work around erratum #1197

Tuo Li <islituo@gmail.com>
    ceph: fix possible null-pointer dereference in ceph_mdsmap_decode()

Xiaoyao Li <xiaoyao.li@intel.com>
    perf/x86/intel/pt: Fix mask of num_address_ranges

Shai Malin <smalin@marvell.com>
    qede: Fix memset corruption

Harini Katakam <harini.katakam@xilinx.com>
    net: macb: Add a NULL check on desc_ptp

Shai Malin <smalin@marvell.com>
    qed: Fix the VF msix vectors flow

Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
    reset: reset-zynqmp: Fixed the argument data type

Krzysztof Hałasa <khalasa@piap.pl>
    gpu: ipu-v3: Fix i.MX IPU-v3 offset calculations for (semi)planar U/V formats

Maciej Falkowski <maciej.falkowski9@gmail.com>
    ARM: OMAP1: ams-delta: remove unused function ams_delta_camera_power

Randy Dunlap <rdunlap@infradead.org>
    xtensa: fix kconfig unmet dependency warning for HAVE_FUTEX_CMPXCHG

Matthieu Baerts <matthieu.baerts@tessares.net>
    static_call: Fix unused variable warn w/o MODULE

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "Add a reference to ucounts for each cred"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "cred: add missing return error code when set_cred_ucounts() failed"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ucounts: Increase ucounts reference counter before the security hook"

Eric Biggers <ebiggers@google.com>
    ubifs: report correct st_size for encrypted symlinks

Eric Biggers <ebiggers@google.com>
    f2fs: report correct st_size for encrypted symlinks

Eric Biggers <ebiggers@google.com>
    ext4: report correct st_size for encrypted symlinks

Eric Biggers <ebiggers@google.com>
    fscrypt: add fscrypt_symlink_getattr() for computing st_size

Theodore Ts'o <tytso@mit.edu>
    ext4: fix race writing to an inline_data file while its xattrs are changing


-------------

Diffstat:

 Makefile                                     |  4 +--
 arch/arm/mach-omap1/board-ams-delta.c        | 14 ---------
 arch/x86/events/amd/ibs.c                    |  8 +++++
 arch/x86/events/amd/power.c                  |  1 +
 arch/x86/events/intel/pt.c                   |  2 +-
 arch/xtensa/Kconfig                          |  2 +-
 drivers/block/Kconfig                        |  4 +--
 drivers/block/cryptoloop.c                   |  2 ++
 drivers/gpu/ipu-v3/ipu-cpmem.c               | 30 +++++++++----------
 drivers/media/usb/stkwebcam/stk-webcam.c     |  6 ++--
 drivers/net/ethernet/cadence/macb_ptp.c      | 11 ++++++-
 drivers/net/ethernet/qlogic/qed/qed_main.c   |  7 ++++-
 drivers/net/ethernet/qlogic/qede/qede_main.c |  2 +-
 drivers/reset/reset-zynqmp.c                 |  3 +-
 drivers/tty/serial/8250/8250_omap.c          |  1 +
 fs/9p/vfs_inode.c                            |  4 +--
 fs/9p/vfs_inode_dotl.c                       |  4 +--
 fs/ceph/mdsmap.c                             |  8 +++--
 fs/cifs/inode.c                              |  5 ++--
 fs/crypto/hooks.c                            | 44 ++++++++++++++++++++++++++++
 fs/exec.c                                    |  4 ---
 fs/ext4/inline.c                             |  6 ++++
 fs/ext4/symlink.c                            | 11 ++++++-
 fs/f2fs/namei.c                              | 11 ++++++-
 fs/fuse/dir.c                                |  6 ++--
 fs/fuse/fuse_i.h                             |  7 +++++
 fs/fuse/inode.c                              |  4 +--
 fs/fuse/readdir.c                            |  7 +++--
 fs/nfs/inode.c                               |  6 ++--
 fs/nfsd/nfsproc.c                            |  2 +-
 fs/overlayfs/namei.c                         |  4 +--
 fs/ubifs/file.c                              | 12 +++++++-
 include/linux/cred.h                         |  2 --
 include/linux/fs.h                           |  5 ++++
 include/linux/fscrypt.h                      |  7 +++++
 include/linux/spi/spi.h                      |  4 +--
 include/linux/user_namespace.h               |  4 ---
 kernel/cred.c                                | 41 --------------------------
 kernel/fork.c                                |  6 ----
 kernel/static_call.c                         |  4 +--
 kernel/sys.c                                 | 12 --------
 kernel/ucount.c                              | 40 ++-----------------------
 kernel/user_namespace.c                      |  3 --
 sound/core/pcm_lib.c                         |  2 +-
 sound/pci/hda/patch_realtek.c                | 11 +++++++
 45 files changed, 202 insertions(+), 181 deletions(-)


