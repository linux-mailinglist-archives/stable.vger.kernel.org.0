Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0E0401BDF
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243106AbhIFNAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 09:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243153AbhIFM7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:59:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C6AC60F45;
        Mon,  6 Sep 2021 12:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933109;
        bh=78kBtY81YvTkHWw20V54tSvc11jXQAJ9BWpp+xT10W8=;
        h=From:To:Cc:Subject:Date:From;
        b=HyF4W1oAt82uLRMaDgVj3S8hEfIuFU1UD9HWe/ILy4jDhviXIr2hrzTA2pHb5SQ/A
         QruHb0Pi7lOykjino+2nDjnHcThS27EtlzXqvv1B2JrRHvhD3tTB/AlkdV8zemMl01
         TTF5g9e/QpHS+IQ5st3naXvjhBVnSgEMrww0ATr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.13 00/24] 5.13.15-rc1 review
Date:   Mon,  6 Sep 2021 14:55:29 +0200
Message-Id: <20210906125449.112564040@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.15-rc1
X-KernelTest-Deadline: 2021-09-08T12:54+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.13.15 release.
There are 24 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.15-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.13.15-rc1

Pavel Skripkin <paskripkin@gmail.com>
    media: stkwebcam: fix memory leak in stk_camera_probe

Zubin Mithra <zsm@chromium.org>
    ALSA: pcm: fix divide error in snd_pcm_lib_ioctl

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Workaround for conflicting SSID on ASUS ROG Strix G17

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix regression on Sony WALKMAN NW-A45 DAC

Johnathon Clark <john.clark@cantab.net>
    ALSA: hda/realtek: Quirk for HP Spectre x360 14 amp setup

Johan Hovold <johan@kernel.org>
    USB: serial: cp210x: fix flow-control error handling

Johan Hovold <johan@kernel.org>
    USB: serial: cp210x: fix control-characters error handling

Robert Marko <robert.marko@sartura.hr>
    USB: serial: pl2303: fix GL type detection

Randy Dunlap <rdunlap@infradead.org>
    xtensa: fix kconfig unmet dependency warning for HAVE_FUTEX_CMPXCHG

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

Bin Meng <bin.meng@windriver.com>
    riscv: dts: microchip: Add ethernet0 to the aliases node

Bin Meng <bin.meng@windriver.com>
    riscv: dts: microchip: Use 'local-mac-address' for emac1

Nathan Rossi <nathan.rossi@digi.com>
    net: dsa: mv88e6xxx: Update mv88e6393x serdes errata

Shai Malin <smalin@marvell.com>
    qed: Fix the VF msix vectors flow

Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
    reset: reset-zynqmp: Fixed the argument data type

Krzysztof Hałasa <khalasa@piap.pl>
    gpu: ipu-v3: Fix i.MX IPU-v3 offset calculations for (semi)planar U/V formats

Jan Kara <jack@suse.cz>
    ext4: fix e2fsprogs checksum failure for mounted filesystem

Theodore Ts'o <tytso@mit.edu>
    ext4: fix race writing to an inline_data file while its xattrs are changing


-------------

Diffstat:

 Makefile                                           |  4 +--
 .../dts/microchip/microchip-mpfs-icicle-kit.dts    |  4 +++
 arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi  |  2 +-
 arch/x86/events/amd/ibs.c                          |  8 ++++++
 arch/x86/events/amd/power.c                        |  1 +
 arch/x86/events/intel/pt.c                         |  2 +-
 arch/xtensa/Kconfig                                |  2 +-
 drivers/block/Kconfig                              |  4 +--
 drivers/block/cryptoloop.c                         |  2 ++
 drivers/gpu/ipu-v3/ipu-cpmem.c                     | 30 +++++++++++-----------
 drivers/media/usb/stkwebcam/stk-webcam.c           |  6 +++--
 drivers/net/dsa/mv88e6xxx/serdes.c                 | 11 ++++----
 drivers/net/ethernet/cadence/macb_ptp.c            | 11 +++++++-
 drivers/net/ethernet/qlogic/qed/qed_main.c         |  7 ++++-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  2 +-
 drivers/reset/reset-zynqmp.c                       |  3 ++-
 drivers/usb/serial/cp210x.c                        | 21 +++++++++------
 drivers/usb/serial/pl2303.c                        |  1 +
 fs/ceph/mdsmap.c                                   |  8 +++---
 fs/ext4/inline.c                                   |  6 +++++
 fs/ext4/super.c                                    |  8 ++++++
 sound/core/pcm_lib.c                               |  2 +-
 sound/pci/hda/patch_realtek.c                      | 11 ++++++++
 sound/usb/endpoint.c                               |  5 ++++
 24 files changed, 116 insertions(+), 45 deletions(-)


