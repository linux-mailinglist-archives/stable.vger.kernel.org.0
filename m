Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA3E2170AF
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbgGGPTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729413AbgGGPTu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:19:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC8B9206E2;
        Tue,  7 Jul 2020 15:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135189;
        bh=5CPAhSAwQXF+M0Sy6Lk2qPm9hQakreBODcy+jje2OBE=;
        h=From:To:Cc:Subject:Date:From;
        b=W5zwY2jEnEu8dUiSxGDwj6CLteQxIUJPe620Vedcck3/wfUjHqs78iwpAsPJTL1Ki
         Hyfc00Qvp0XDkvj0mK1vGZxGWR2e9mpowQhbM1iTJ3C6CRZ2nqXJiG49DzWrMwI9QT
         NUoxgiurnL8lM5JL9K7xaY6fN8450OSJEa13TSn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/65] 5.4.51-rc1 review
Date:   Tue,  7 Jul 2020 17:16:39 +0200
Message-Id: <20200707145752.417212219@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.51-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.51-rc1
X-KernelTest-Deadline: 2020-07-09T14:57+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.51 release.
There are 65 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.51-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.51-rc1

Peter Jones <pjones@redhat.com>
    efi: Make it possible to disable efivar_ssdt entirely

Hou Tao <houtao1@huawei.com>
    dm zoned: assign max_io_len correctly

Babu Moger <babu.moger@amd.com>
    x86/resctrl: Fix memory bandwidth counter width for AMD

Vlastimil Babka <vbabka@suse.cz>
    mm, compaction: make capture control handling safe wrt interrupts

Vlastimil Babka <vbabka@suse.cz>
    mm, compaction: fully assume capture is not NULL in compact_zone_order()

Marc Zyngier <maz@kernel.org>
    irqchip/gic: Atomically update affinity

Sumit Semwal <sumit.semwal@linaro.org>
    dma-buf: Move dma_buf_release() from fops to dentry_ops

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/atomfirmware: fix vram_info fetching for renoir

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: use %u rather than %d for sclk/mclk

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Only revalidate bandwidth on medium and fast updates

Hauke Mehrtens <hauke@hauke-m.de>
    MIPS: Add missing EHB in mtc0 -> mfc0 sequence for DSPen

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    MIPS: lantiq: xway: sysctrl: fix the GPHY clock alias names

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix the target file was deleted when rename failed.

Paul Aurich <paul@darkrain42.org>
    SMB3: Honor 'handletimeout' flag for multiuser mounts

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

Krzysztof Kozlowski <krzk@kernel.org>
    spi: spi-fsl-dspi: Fix external abort on interrupt in resume or exit paths

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: mlxcpld: check correct size of maximum RECV_LEN packet

Chris Packham <chris.packham@alliedtelesis.co.nz>
    i2c: algo-pca: Add 0x78 as SCL stuck low status for PCA9665

Kees Cook <keescook@chromium.org>
    samples/vfs: avoid warning in statx override

Christoph Hellwig <hch@lst.de>
    nvme: fix a crash in nvme_mpath_add_disk

Sagi Grimberg <sagi@grimberg.me>
    nvme: fix identify error status silent ignore

Paul Aurich <paul@darkrain42.org>
    SMB3: Honor 'posix' flag for multiuser mounts

Hou Tao <houtao1@huawei.com>
    virtio-blk: free vblk-vqs in error path of virtblk_probe()

Chen-Yu Tsai <wens@csie.org>
    drm: sun4i: hdmi: Remove extra HPD polling

J. Bruce Fields <bfields@redhat.com>
    nfsd: fix nfsdfs inode reference count leak

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix nfsdfs reference count loop

J. Bruce Fields <bfields@redhat.com>
    nfsd: clients don't need to break their own delegations

J. Bruce Fields <bfields@redhat.com>
    kthread: save thread function

Dien Pham <dien.pham.ry@renesas.com>
    thermal/drivers/rcar_gen3: Fix undefined temperature if negative

Michael Kao <michael.kao@mediatek.com>
    thermal/drivers/mediatek: Fix bank number settings on mt8183

Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
    hwmon: (acpi_power_meter) Fix potential memory leak in acpi_power_meter_add()

Chu Lin <linchuyuan@google.com>
    hwmon: (max6697) Make sure the OVERT mask is set correctly

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: fix SGE queue dump destination buffer context

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: use correct type for all-mask IP address comparison

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: fix endian conversions for L4 ports in filters

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: parse TC-U32 key values and masks natively

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: use unaligned conversion for fetching timestamp

Mark Zhang <markz@mellanox.com>
    RDMA/counter: Query a counter before release

David Howells <dhowells@redhat.com>
    rxrpc: Fix afs large storage transmission performance drop

Chen Tao <chentao107@huawei.com>
    drm/msm/dpu: fix error return code in dpu_encoder_init

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - fix use-after-free in af_alg_accept() due to bh_lock_sock()

James Bottomley <James.Bottomley@HansenPartnership.com>
    tpm: Fix TIS locality timeout problems

Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
    selftests: tpm: Use /bin/sh instead of /bin/bash

Douglas Anderson <dianders@chromium.org>
    kgdb: Avoid suspicious RCU usage warning

Sagi Grimberg <sagi@grimberg.me>
    nvme-multipath: fix bogus request queue reference put

Anton Eidelman <anton@lightbitslabs.com>
    nvme-multipath: fix deadlock due to head->lock

Anton Eidelman <anton@lightbitslabs.com>
    nvme-multipath: fix deadlock between ana_work and scan_work

Sagi Grimberg <sagi@grimberg.me>
    nvme: fix possible deadlock when I/O is blocked

Keith Busch <kbusch@kernel.org>
    nvme-multipath: set bdi capabilities once

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/debug: avoid kernel warning on too large number of pages

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tools lib traceevent: Handle __attribute__((user)) in field names

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tools lib traceevent: Add append() function helper for appending strings

Zqiang <qiang.zhang@windriver.com>
    usb: usbtest: fix missing kfree(dev->buf) in usbtest_disconnect

David Howells <dhowells@redhat.com>
    rxrpc: Fix race between incoming ACK parser and retransmitter

Qian Cai <cai@lca.pw>
    mm/slub: fix stack overruns with SLUB_STATS

Dongli Zhang <dongli.zhang@oracle.com>
    mm/slub.c: fix corrupted freechain in deactivate_slab()

Valentin Schneider <valentin.schneider@arm.com>
    sched/debug: Make sd->flags sysctl read-only

Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
    usbnet: smsc95xx: Fix use-after-free after removal

Borislav Petkov <bp@suse.de>
    EDAC/amd64: Read back the scrub rate PCI register on F15h

Hugh Dickins <hughd@google.com>
    mm: fix swap cache node allocation mask

Jens Axboe <axboe@kernel.dk>
    io_uring: make sure async workqueue is canceled on exit


-------------

Diffstat:

 Documentation/filesystems/locking.rst              |   2 +
 Makefile                                           |   4 +-
 arch/mips/kernel/traps.c                           |   1 +
 arch/mips/lantiq/xway/sysctrl.c                    |   8 +-
 arch/s390/kernel/debug.c                           |   3 +-
 arch/x86/kernel/cpu/resctrl/core.c                 |   2 +
 arch/x86/kernel/cpu/resctrl/internal.h             |   3 +
 arch/x86/kernel/cpu/resctrl/monitor.c              |   3 +-
 crypto/af_alg.c                                    |  26 ++--
 crypto/algif_aead.c                                |   9 +-
 crypto/algif_hash.c                                |   9 +-
 crypto/algif_skcipher.c                            |   9 +-
 drivers/block/virtio_blk.c                         |   1 +
 drivers/char/tpm/tpm-dev-common.c                  |  19 ++-
 drivers/dma-buf/dma-buf.c                          |  54 ++++-----
 drivers/edac/amd64_edac.c                          |   2 +
 drivers/firmware/efi/Kconfig                       |  11 ++
 drivers/firmware/efi/efi.c                         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c   |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c             |   4 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  10 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |   2 +-
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c             |   5 +-
 drivers/hwmon/acpi_power_meter.c                   |   4 +-
 drivers/hwmon/max6697.c                            |   7 +-
 drivers/i2c/algos/i2c-algo-pca.c                   |   3 +-
 drivers/i2c/busses/i2c-mlxcpld.c                   |   4 +-
 drivers/infiniband/core/counters.c                 |   4 +-
 drivers/irqchip/irq-gic.c                          |  14 +--
 drivers/md/dm-zoned-target.c                       |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c     |   6 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |  25 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   2 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   |  30 ++---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c  |  18 +--
 .../ethernet/chelsio/cxgb4/cxgb4_tc_u32_parse.h    | 122 ++++++++++++-------
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |   2 +-
 drivers/net/usb/smsc95xx.c                         |   2 +-
 drivers/nvme/host/core.c                           |  13 +-
 drivers/nvme/host/multipath.c                      |  45 +++++--
 drivers/nvme/host/nvme.h                           |   2 +
 drivers/spi/spi-fsl-dspi.c                         |  17 ++-
 drivers/thermal/mtk_thermal.c                      |   5 +-
 drivers/thermal/rcar_gen3_thermal.c                |   2 +-
 drivers/usb/misc/usbtest.c                         |   1 +
 fs/cifs/connect.c                                  |  10 +-
 fs/cifs/inode.c                                    |  10 +-
 fs/io_uring.c                                      |  63 ++++++++++
 fs/locks.c                                         |   3 +
 fs/nfsd/nfs4proc.c                                 |   2 +
 fs/nfsd/nfs4state.c                                |  22 +++-
 fs/nfsd/nfsctl.c                                   |  23 ++--
 fs/nfsd/nfsd.h                                     |   5 +
 fs/nfsd/nfssvc.c                                   |   6 +
 fs/nfsd/vfs.c                                      |   6 +
 include/crypto/if_alg.h                            |   4 +-
 include/linux/fs.h                                 |   1 +
 include/linux/kthread.h                            |   1 +
 include/linux/sunrpc/svc.h                         |   1 +
 kernel/debug/debug_core.c                          |   4 +
 kernel/kthread.c                                   |  17 +++
 kernel/sched/debug.c                               |   2 +-
 mm/compaction.c                                    |  19 ++-
 mm/slub.c                                          |  30 ++++-
 mm/swap_state.c                                    |   4 +-
 net/rxrpc/call_event.c                             |  29 ++---
 samples/vfs/test-statx.c                           |   2 +
 sound/usb/card.h                                   |   4 -
 sound/usb/endpoint.c                               |  43 +------
 sound/usb/endpoint.h                               |   1 -
 sound/usb/pcm.c                                    |   2 -
 tools/lib/traceevent/event-parse.c                 | 133 ++++++++++++---------
 tools/testing/selftests/tpm2/test_smoke.sh         |   2 +-
 tools/testing/selftests/tpm2/test_space.sh         |   2 +-
 74 files changed, 609 insertions(+), 362 deletions(-)


