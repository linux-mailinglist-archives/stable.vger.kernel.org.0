Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8C82E9A08
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbhADQCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:02:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:39138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728873AbhADQCi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:02:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D8EC22509;
        Mon,  4 Jan 2021 16:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776142;
        bh=TKdNEaV8+nA+h4XSNUbtT1gdhF2dCHMoT1Eo1KK/Dp0=;
        h=From:To:Cc:Subject:Date:From;
        b=uLPuF+knkWFcbLFoJ7xmznE6SHSvREuqNiU42ROA6aNKt2dLvcTkC8WLLV2b+BcAI
         BMcQ832A20e5Dg1DaoqCAWS5+IGfU782tV2iuVRsPftoofHKU8dxz9RMt35eeZMxsd
         zDE/k/Kv8IThve6ZxtH11MiCWUhmdI8PcODNKIeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.10 00/63] 5.10.5-rc1 review
Date:   Mon,  4 Jan 2021 16:56:53 +0100
Message-Id: <20210104155708.800470590@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.10.5-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.5-rc1
X-KernelTest-Deadline: 2021-01-06T15:57+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.5 release.
There are 63 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 06 Jan 2021 15:56:52 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.5-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.5-rc1

Dan Williams <dan.j.williams@intel.com>
    device-dax: Fix range release

Chunguang Xu <brookxu@tencent.com>
    ext4: avoid s_mb_prefetch to be zero in individual scenarios

Hyeongseok Kim <hyeongseok@gmail.com>
    dm verity: skip verity work if I/O error when system is shutting down

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Clear the full allocated memory at hw_params

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: remove racy overflow list fast checks

Heiko Carstens <hca@linux.ibm.com>
    s390: always clear kernel stack backchain before calling functions

Thomas Gleixner <tglx@linutronix.de>
    tick/sched: Remove bogus boot "safety" check

Jake Wang <haonan.wang2@amd.com>
    drm/amd/display: updated wm table for Renoir

Jeff Layton <jlayton@kernel.org>
    ceph: fix inode refcount leak when ceph_fill_inode on non-I_NEW inode fails

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.2: Don't error when exiting early on a READ_PLUS buffer overflow

Gabriel Krisman Bertazi <krisman@collabora.com>
    um: ubd: Submit all data segments atomically

Christopher Obbard <chris.obbard@collabora.com>
    um: random: Register random as hwrng-core device

Zhang Qilong <zhangqilong3@huawei.com>
    watchdog: rti-wdt: fix reference leak in rti_wdt_probe

Eric Biggers <ebiggers@google.com>
    fs/namespace.c: WARN if mnt_count has become negative

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64: irq replay remove decrementer overflow check

Jessica Yu <jeyu@kernel.org>
    module: delay kobject uevent until after module init call

Daeho Jeong <daehojeong@google.com>
    f2fs: fix race of pending_pages in decompression

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: avoid race condition for shrinker count

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix a pNFS layout related use-after-free race when freeing the inode

Qinglang Miao <miaoqinglang@huawei.com>
    i3c master: fix missing destroy_workqueue() on error in i3c_master_register

Qinglang Miao <miaoqinglang@huawei.com>
    powerpc: sysdev: add missing iounmap() on error in mpic_msgr_probe()

Zheng Liang <zhengliang6@huawei.com>
    rtc: pl031: fix resource leak in pl031_probe

Jan Kara <jack@suse.cz>
    quota: Don't overflow quota file offsets

Miroslav Benes <mbenes@suse.cz>
    module: set MODULE_STATE_GOING state when a module fails to load

Dinghao Liu <dinghao.liu@zju.edu.cn>
    rtc: sun6i: Fix memleak in sun6i_rtc_clk_init

Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
    io_uring: check kthread stopped flag when sq thread is unparked

Boqun Feng <boqun.feng@gmail.com>
    fcntl: Fix potential deadlock in send_sig{io, urg}()

Theodore Ts'o <tytso@mit.edu>
    ext4: check for invalid block size early when mounting a file system

Randy Dunlap <rdunlap@infradead.org>
    bfs: don't use WARNING: string when it's just info.

Takashi Iwai <tiwai@suse.de>
    ALSA: rawmidi: Access runtime->avail always in spinlock

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Use bool for snd_seq_queue internal flags

Chao Yu <chao@kernel.org>
    f2fs: fix shift-out-of-bounds in sanity_check_raw_super()

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: gp8psk: initialize stats at power control logic

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    misc: vmw_vmci: fix kernel info-leak by initializing dbells in vmci_ctx_get_chkpt_doorbells()

Rustam Kovhaev <rkovhaev@gmail.com>
    reiserfs: add check for an invalid ih_entry_count

Daniel Vetter <daniel.vetter@ffwll.ch>
    fbcon: Disable accelerated scrolling

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    Bluetooth: hci_h5: close serdev device and free hu in h5_close

Randy Dunlap <rdunlap@infradead.org>
    scsi: cxgb4i: Fix TLS dependency

Randy Dunlap <rdunlap@infradead.org>
    zlib: move EXPORT_SYMBOL() and MODULE_LICENSE() out of dfltcc_syms.c

Qinglang Miao <miaoqinglang@huawei.com>
    cgroup: Fix memory leak when parsing multiple source parameters

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools headers UAPI: Sync linux/const.h with the kernel headers

Petr Vorel <petr.vorel@gmail.com>
    uapi: move constants from <linux/kernel.h> to <linux/const.h>

Pavel Begunkov <asml.silence@gmail.com>
    kernel/io_uring: cancel io_uring before task works

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix io_sqe_files_unregister() hangs

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: add a helper for setting a ref node

Jens Axboe <axboe@kernel.dk>
    io_uring: use bottom half safe lock for fixed file data

Jens Axboe <axboe@kernel.dk>
    io_uring: don't assume mm is constant across submits

Ilya Leoshkevich <iii@linux.ibm.com>
    lib/zlib: fix inflating zlib streams on s390

Baoquan He <bhe@redhat.com>
    mm: memmap defer init doesn't work as expected

Mike Kravetz <mike.kravetz@oracle.com>
    mm/hugetlb: fix deadlock in hugetlb_cow error path

Bart Van Assche <bvanassche@acm.org>
    scsi: block: Fix a race in the runtime power management code

Viresh Kumar <viresh.kumar@linaro.org>
    opp: Call the missing clk_put() on error

Quanyang Wang <quanyang.wang@windriver.com>
    opp: fix memory leak in _allocate_opp_table

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    spi: dw-bt1: Fix undefined devm_mux_control_get symbol

Jamie Iles <jamie@nuviainc.com>
    jffs2: Fix NULL pointer dereference in rp_size fs option parsing

lizhe <lizhe67@huawei.com>
    jffs2: Allow setting rp_size to zero during remounting

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: close a small race gap for files cancel

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Add get_dig_frontend implementation for DCEx

Kevin Vigor <kvigor@gmail.com>
    md/raid10: initialize r10_bio->read_slot before use.

Michal Kubecek <mkubecek@suse.cz>
    ethtool: fix string set id check

Ivan Vecera <ivecera@redhat.com>
    ethtool: fix error paths in ethnl_set_channels()

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix security context on server socket

Davide Caratti <dcaratti@redhat.com>
    net/sched: sch_taprio: reset child qdiscs before freeing them


-------------

Diffstat:

 Documentation/gpu/todo.rst                         |  18 ++
 Makefile                                           |   4 +-
 arch/ia64/mm/init.c                                |   4 +-
 arch/powerpc/kernel/irq.c                          |  53 +-----
 arch/powerpc/kernel/time.c                         |   9 +-
 arch/powerpc/platforms/powernv/opal.c              |   2 +-
 arch/powerpc/sysdev/mpic_msgr.c                    |   2 +-
 arch/s390/kernel/entry.S                           |  12 +-
 arch/um/drivers/random.c                           | 101 +++--------
 arch/um/drivers/ubd_kern.c                         | 191 +++++++++++++--------
 block/blk-pm.c                                     |  15 +-
 drivers/bluetooth/hci_h5.c                         |   8 +-
 drivers/char/hw_random/Kconfig                     |  16 +-
 drivers/dax/bus.c                                  |  44 +++--
 .../drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c  |  12 +-
 .../gpu/drm/amd/display/dc/dce/dce_link_encoder.c  |  44 ++++-
 .../gpu/drm/amd/display/dc/dce/dce_link_encoder.h  |   2 +
 drivers/i3c/master.c                               |   5 +-
 drivers/md/dm-verity-target.c                      |  12 +-
 drivers/md/raid10.c                                |   3 +-
 drivers/media/usb/dvb-usb/gp8psk.c                 |   2 +-
 drivers/misc/vmw_vmci/vmci_context.c               |   2 +-
 drivers/opp/core.c                                 |   9 +-
 drivers/rtc/rtc-pl031.c                            |   6 +-
 drivers/rtc/rtc-sun6i.c                            |   8 +-
 drivers/scsi/cxgbi/cxgb4i/Kconfig                  |   1 +
 drivers/spi/Kconfig                                |   3 +-
 drivers/video/fbdev/core/fbcon.c                   |  45 +----
 drivers/watchdog/rti_wdt.c                         |   4 +-
 fs/bfs/inode.c                                     |   2 +-
 fs/ceph/inode.c                                    |   2 +
 fs/ext4/mballoc.c                                  |   9 +-
 fs/ext4/super.c                                    |  40 ++---
 fs/f2fs/checkpoint.c                               |   2 +-
 fs/f2fs/compress.c                                 |   2 -
 fs/f2fs/data.c                                     |  58 +++++--
 fs/f2fs/debug.c                                    |  11 +-
 fs/f2fs/f2fs.h                                     |  11 +-
 fs/f2fs/node.c                                     |  29 ++--
 fs/f2fs/node.h                                     |   4 +-
 fs/f2fs/shrinker.c                                 |   4 +-
 fs/f2fs/super.c                                    |   9 +-
 fs/fcntl.c                                         |  10 +-
 fs/file.c                                          |   2 -
 fs/io_uring.c                                      |  91 ++++++----
 fs/jffs2/jffs2_fs_sb.h                             |   1 +
 fs/jffs2/super.c                                   |  17 +-
 fs/namespace.c                                     |   9 +-
 fs/nfs/nfs42xdr.c                                  |  36 ++--
 fs/nfs/nfs4super.c                                 |   2 +-
 fs/nfs/pnfs.c                                      |  33 +++-
 fs/nfs/pnfs.h                                      |   5 +
 fs/pnode.h                                         |   2 +-
 fs/quota/quota_tree.c                              |   8 +-
 fs/reiserfs/stree.c                                |   6 +
 include/linux/mm.h                                 |   5 +-
 include/uapi/linux/const.h                         |   5 +
 include/uapi/linux/ethtool.h                       |   2 +-
 include/uapi/linux/kernel.h                        |   9 +-
 include/uapi/linux/lightnvm.h                      |   2 +-
 include/uapi/linux/mroute6.h                       |   2 +-
 include/uapi/linux/netfilter/x_tables.h            |   2 +-
 include/uapi/linux/netlink.h                       |   2 +-
 include/uapi/linux/sysctl.h                        |   2 +-
 kernel/cgroup/cgroup-v1.c                          |   2 +
 kernel/exit.c                                      |   2 +
 kernel/module.c                                    |   6 +-
 kernel/time/tick-sched.c                           |   7 -
 lib/zlib_dfltcc/Makefile                           |   2 +-
 lib/zlib_dfltcc/dfltcc.c                           |   6 +-
 lib/zlib_dfltcc/dfltcc_deflate.c                   |   3 +
 lib/zlib_dfltcc/dfltcc_inflate.c                   |   4 +-
 lib/zlib_dfltcc/dfltcc_syms.c                      |  17 --
 mm/hugetlb.c                                       |  22 ++-
 mm/memory_hotplug.c                                |   2 +-
 mm/page_alloc.c                                    |   8 +-
 net/ethtool/channels.c                             |   6 +-
 net/ethtool/strset.c                               |   2 +-
 net/mptcp/protocol.c                               |   2 +
 net/sched/sch_taprio.c                             |  17 +-
 sound/core/pcm_native.c                            |   9 +-
 sound/core/rawmidi.c                               |  49 ++++--
 sound/core/seq/seq_queue.h                         |   8 +-
 tools/include/uapi/linux/const.h                   |   5 +
 84 files changed, 713 insertions(+), 539 deletions(-)


