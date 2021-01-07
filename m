Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA952ED280
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbhAGOdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:33:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:47682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729532AbhAGOdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:33:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A47EF22AAA;
        Thu,  7 Jan 2021 14:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029978;
        bh=rj/4aXAuyZnYPE4FwldshuIiuPW06XkHQInQzQjdt34=;
        h=From:To:Cc:Subject:Date:From;
        b=XFkYh4//T/4waqsEZhSXmO6p3ZiaV2JNK16+e7lsMPnzthvS52nqoy8G6/H8dNF+B
         j5Vk8rZQYEL/RmqfTBBxt2EWzMjzTVT3o2/FX+erO8oGNETWykqgwZnR9h9H342qxN
         I9aZOJWQf94BbP3bOVloH43lYJVRATahMOTWqzlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.10 00/20] 5.10.6-rc1 review
Date:   Thu,  7 Jan 2021 15:33:55 +0100
Message-Id: <20210107143052.392839477@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.10.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.6-rc1
X-KernelTest-Deadline: 2021-01-09T14:30+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.6 release.
There are 20 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.6-rc1

Zhang Xiaohui <ruc_zhangxiaohui@163.com>
    mwifiex: Fix possible buffer overflows in mwifiex_cmd_802_11_ad_hoc_start

Eric W. Biederman <ebiederm@xmission.com>
    exec: Transform exec_update_mutex into a rw_semaphore

Eric W. Biederman <ebiederm@xmission.com>
    rwsem: Implement down_read_interruptible

Eric W. Biederman <ebiederm@xmission.com>
    rwsem: Implement down_read_killable_nested

peterz@infradead.org <peterz@infradead.org>
    perf: Break deadlock involving exec_update_mutex

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix bad inode

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/siw,rxe: Make emulated devices virtual in the device tree

Christoph Hellwig <hch@lst.de>
    RDMA/core: remove use of dma_virt_ops

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Re-enable WriteBooster after device reset

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: Allow an error return value from ->device_reset()

Imre Deak <imre.deak@intel.com>
    drm/i915/tgl: Fix Combo PHY DPLL fractional divider for 38.4MHz ref clock

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/hdmi: Fix incorrect mutex unlock in silent_stream_disable()

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Modify Dell platform name

Edward Vear <edwardvear@gmail.com>
    Bluetooth: Fix attempting to set RPA timeout when unsupported

Josh Poimboeuf <jpoimboe@redhat.com>
    kdev_t: always inline major/minor helper functions

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    dt-bindings: rtc: add reset-source property

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    rtc: pcf2127: only use watchdog when explicitly available

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    rtc: pcf2127: move watchdog initialisation to a separate function

Felix Fietkau <nbd@nbd.name>
    Revert "mtd: spinand: Fix OOB read"

Alex Deucher <alexdeucher@gmail.com>
    Revert "drm/amd/display: Fix memory leaks in S3 resume"


-------------

Diffstat:

 Documentation/devicetree/bindings/rtc/rtc.yaml    |  5 ++
 Makefile                                          |  4 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  3 +-
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c     | 41 ++++++++-----
 drivers/infiniband/core/device.c                  | 43 ++++++-------
 drivers/infiniband/core/rw.c                      |  5 +-
 drivers/infiniband/sw/rdmavt/Kconfig              |  1 -
 drivers/infiniband/sw/rdmavt/mr.c                 |  6 +-
 drivers/infiniband/sw/rdmavt/vt.c                 |  8 ---
 drivers/infiniband/sw/rxe/Kconfig                 |  1 -
 drivers/infiniband/sw/rxe/rxe_net.c               | 12 ----
 drivers/infiniband/sw/rxe/rxe_verbs.c             |  8 ---
 drivers/infiniband/sw/rxe/rxe_verbs.h             |  1 -
 drivers/infiniband/sw/siw/Kconfig                 |  1 -
 drivers/infiniband/sw/siw/siw.h                   |  1 -
 drivers/infiniband/sw/siw/siw_main.c              | 26 +-------
 drivers/mtd/nand/spi/core.c                       |  4 --
 drivers/net/wireless/marvell/mwifiex/join.c       |  2 +
 drivers/nvme/target/rdma.c                        |  3 +-
 drivers/rtc/rtc-pcf2127.c                         | 57 ++++++++++--------
 drivers/scsi/ufs/ufs-mediatek.c                   |  4 +-
 drivers/scsi/ufs/ufs-qcom.c                       |  6 +-
 drivers/scsi/ufs/ufshcd.h                         | 16 +++--
 fs/exec.c                                         | 12 ++--
 fs/fuse/acl.c                                     |  6 ++
 fs/fuse/dir.c                                     | 37 ++++++++++--
 fs/fuse/file.c                                    | 19 +++---
 fs/fuse/fuse_i.h                                  | 12 ++++
 fs/fuse/inode.c                                   |  4 +-
 fs/fuse/readdir.c                                 |  4 +-
 fs/fuse/xattr.c                                   |  9 +++
 fs/proc/base.c                                    | 10 ++--
 include/linux/kdev_t.h                            | 22 +++----
 include/linux/rwsem.h                             |  3 +
 include/linux/sched/signal.h                      | 11 ++--
 include/rdma/ib_verbs.h                           | 73 ++++++++++++++++-------
 init/init_task.c                                  |  2 +-
 kernel/events/core.c                              | 52 ++++++++--------
 kernel/fork.c                                     |  6 +-
 kernel/kcmp.c                                     | 30 +++++-----
 kernel/locking/rwsem.c                            | 40 +++++++++++++
 kernel/pid.c                                      |  4 +-
 net/bluetooth/hci_core.c                          |  2 +-
 sound/pci/hda/patch_hdmi.c                        |  2 +-
 sound/pci/hda/patch_realtek.c                     |  2 +-
 45 files changed, 363 insertions(+), 257 deletions(-)


