Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11E121707D
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgGGPSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:18:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728029AbgGGPSQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:18:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D61A720663;
        Tue,  7 Jul 2020 15:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135095;
        bh=ilYYFJzYlR8L79QzvjEoYBrKxdaoFfPYh7DDSAojEbA=;
        h=From:To:Cc:Subject:Date:From;
        b=0xr/fYkebjvU8sy2L62Dff08aHFz/fPZydMXk1Gt/Quo42+H3HliyfP3L0VV2vKF6
         k28y2G+IdmGPGxdN5M7GhLIDtqRJGLBETA8usrliVbVC0zipG7sZrLU7sVlo1VU2MG
         IgKycJYsRrDsCwTTXO6AswI8MWToRYgopH31GbsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/36] 4.19.132-rc1 review
Date:   Tue,  7 Jul 2020 17:16:52 +0200
Message-Id: <20200707145749.130272978@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.132-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.132-rc1
X-KernelTest-Deadline: 2020-07-09T14:57+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.132 release.
There are 36 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.132-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.132-rc1

Peter Jones <pjones@redhat.com>
    efi: Make it possible to disable efivar_ssdt entirely

Hou Tao <houtao1@huawei.com>
    dm zoned: assign max_io_len correctly

Marc Zyngier <maz@kernel.org>
    irqchip/gic: Atomically update affinity

Hauke Mehrtens <hauke@hauke-m.de>
    MIPS: Add missing EHB in mtc0 -> mfc0 sequence for DSPen

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix the target file was deleted when rename failed.

Paul Aurich <paul@darkrain42.org>
    SMB3: Honor lease disabling for multiuser mounts

Paul Aurich <paul@darkrain42.org>
    SMB3: Honor persistent/resilient handle flags for multiuser mounts

Paul Aurich <paul@darkrain42.org>
    SMB3: Honor 'seal' flag for multiuser mounts

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ALSA: usb-audio: Improve frames size computation"

J. Bruce Fields <bfields@redhat.com>
    nfsd: apply umask on fs without ACL support

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: mlxcpld: check correct size of maximum RECV_LEN packet

Chris Packham <chris.packham@alliedtelesis.co.nz>
    i2c: algo-pca: Add 0x78 as SCL stuck low status for PCA9665

Christoph Hellwig <hch@lst.de>
    nvme: fix a crash in nvme_mpath_add_disk

Paul Aurich <paul@darkrain42.org>
    SMB3: Honor 'posix' flag for multiuser mounts

Hou Tao <houtao1@huawei.com>
    virtio-blk: free vblk-vqs in error path of virtblk_probe()

Chen-Yu Tsai <wens@csie.org>
    drm: sun4i: hdmi: Remove extra HPD polling

Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
    hwmon: (acpi_power_meter) Fix potential memory leak in acpi_power_meter_add()

Chu Lin <linchuyuan@google.com>
    hwmon: (max6697) Make sure the OVERT mask is set correctly

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: fix SGE queue dump destination buffer context

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: use correct type for all-mask IP address comparison

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: parse TC-U32 key values and masks natively

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: use unaligned conversion for fetching timestamp

Chen Tao <chentao107@huawei.com>
    drm/msm/dpu: fix error return code in dpu_encoder_init

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - fix use-after-free in af_alg_accept() due to bh_lock_sock()

Douglas Anderson <dianders@chromium.org>
    kgdb: Avoid suspicious RCU usage warning

Anton Eidelman <anton@lightbitslabs.com>
    nvme-multipath: fix deadlock between ana_work and scan_work

Sagi Grimberg <sagi@grimberg.me>
    nvme: fix possible deadlock when I/O is blocked

Keith Busch <kbusch@kernel.org>
    nvme-multipath: set bdi capabilities once

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/debug: avoid kernel warning on too large number of pages

Zqiang <qiang.zhang@windriver.com>
    usb: usbtest: fix missing kfree(dev->buf) in usbtest_disconnect

Qian Cai <cai@lca.pw>
    mm/slub: fix stack overruns with SLUB_STATS

Dongli Zhang <dongli.zhang@oracle.com>
    mm/slub.c: fix corrupted freechain in deactivate_slab()

Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
    usbnet: smsc95xx: Fix use-after-free after removal

Borislav Petkov <bp@suse.de>
    EDAC/amd64: Read back the scrub rate PCI register on F15h

Hugh Dickins <hughd@google.com>
    mm: fix swap cache node allocation mask

Filipe Manana <fdmanana@suse.com>
    btrfs: fix a block group ref counter leak after failure to remove block group


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/mips/kernel/traps.c                           |   1 +
 arch/s390/kernel/debug.c                           |   3 +-
 crypto/af_alg.c                                    |  26 ++---
 crypto/algif_aead.c                                |   9 +-
 crypto/algif_hash.c                                |   9 +-
 crypto/algif_skcipher.c                            |   9 +-
 drivers/block/virtio_blk.c                         |   1 +
 drivers/edac/amd64_edac.c                          |   2 +
 drivers/firmware/efi/Kconfig                       |  11 ++
 drivers/firmware/efi/efi.c                         |   2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |   2 +-
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c             |   5 +-
 drivers/hwmon/acpi_power_meter.c                   |   4 +-
 drivers/hwmon/max6697.c                            |   7 +-
 drivers/i2c/algos/i2c-algo-pca.c                   |   3 +-
 drivers/i2c/busses/i2c-mlxcpld.c                   |   4 +-
 drivers/irqchip/irq-gic.c                          |  14 +--
 drivers/md/dm-zoned-target.c                       |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c     |   6 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |  10 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c  |  18 +--
 .../ethernet/chelsio/cxgb4/cxgb4_tc_u32_parse.h    | 122 ++++++++++++++-------
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |   2 +-
 drivers/net/usb/smsc95xx.c                         |   2 +-
 drivers/nvme/host/core.c                           |   1 -
 drivers/nvme/host/multipath.c                      |  33 ++++--
 drivers/usb/misc/usbtest.c                         |   1 +
 fs/btrfs/extent-tree.c                             |  19 ++--
 fs/cifs/connect.c                                  |   9 +-
 fs/cifs/inode.c                                    |  10 +-
 fs/nfsd/vfs.c                                      |   6 +
 include/crypto/if_alg.h                            |   4 +-
 kernel/debug/debug_core.c                          |   4 +
 mm/slub.c                                          |  30 ++++-
 mm/swap_state.c                                    |   3 +-
 sound/usb/card.h                                   |   4 -
 sound/usb/endpoint.c                               |  43 +-------
 sound/usb/endpoint.h                               |   1 -
 sound/usb/pcm.c                                    |   2 -
 40 files changed, 256 insertions(+), 192 deletions(-)


