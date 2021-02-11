Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C38318DFB
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhBKPTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:19:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230006AbhBKPNU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:13:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CAA164EEA;
        Thu, 11 Feb 2021 15:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055864;
        bh=p95M9SDyAaci6/jF9PKDNnqjCvKwONH60AJ9jGmNUfI=;
        h=From:To:Cc:Subject:Date:From;
        b=vXiS/VOH8+B4mgzP34bv7dov52QD9k8FOgU8Imt22kSo3NXPCqKEOlB7U/tmk0E8D
         cRFc6d7w151u4Kfc4JQfHni0T+glwX0FHIqVtgqyEFPKQe3PCWDkdKVcMyAtgoKDr4
         RY0R571eWxKf9lwOrnDIoCtf65WoaJQ18MFaSm2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 5.10 00/54] 5.10.16-rc1 review
Date:   Thu, 11 Feb 2021 16:01:44 +0100
Message-Id: <20210211150152.885701259@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.10.16-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.16-rc1
X-KernelTest-Deadline: 2021-02-13T15:01+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.16 release.
There are 54 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 13 Feb 2021 15:01:39 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.16-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.16-rc1

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: add more sanity checks in xattr id lookup

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: add more sanity checks in inode lookup

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: add more sanity checks in id lookup

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: avoid out of bounds writes in decompressors

Johannes Weiner <hannes@cmpxchg.org>
    Revert "mm: memcontrol: avoid workload stalls when lowering memory.high"

Joachim Henke <joachim.henke@t-systems.com>
    nilfs2: make splice write available again

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Skip vswing programming for TBT

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix ICL MG PHY vswing handling

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix verifier jsgt branch analysis on max bound

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix 32 bit src register truncation on div/mod

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix verifier jmp32 pruning decision logic

Mark Brown <broonie@kernel.org>
    regulator: Fix lockdep warning resolving supplies

Baolin Wang <baolin.wang@linux.alibaba.com>
    blk-cgroup: Use cond_resched() when destroy blkgs

Qii Wang <qii.wang@mediatek.com>
    i2c: mediatek: Move suspend and resume handling to NOIRQ phase

Dave Wysochanski <dwysocha@redhat.com>
    SUNRPC: Handle 0 length opaque XDR object data properly

Dave Wysochanski <dwysocha@redhat.com>
    SUNRPC: Move simple_get_bytes and simple_get_netobj into private header

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: queue: bail out on invalid freeing

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: guard against device removal in reprobe

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: pcie: add rules to match Qu with Hr2

Gregory Greenman <gregory.greenman@intel.com>
    iwlwifi: mvm: invalidate IDs of internal stations at mvm start

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: fix context info memory leak

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: pcie: add a NULL check in iwl_pcie_txq_unmap

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: take mutex for calling iwl_mvm_get_sync_time()

Sara Sharon <sara.sharon@intel.com>
    iwlwifi: mvm: skip power command when unbinding vif during CSA

Libin Yang <libin.yang@intel.com>
    ASoC: Intel: sof_sdw: set proper flags for Dell TGL-H SKU 0A5E

Eliot Blennerhassett <eliot@blennerhassett.gen.nz>
    ASoC: ak4458: correct reset polarity

Bard Liao <bard.liao@intel.com>
    ALSA: hda: intel-dsp-config: add PCI id for TGL-H

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS/NFSv4: Improve rejection of out-of-order layouts

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS/NFSv4: Try to return invalid layout in pnfs_layout_process()

Pan Bian <bianpan2016@163.com>
    chtls: Fix potential resource leak

Ricardo Ribalda <ribalda@chromium.org>
    ASoC: Intel: Skylake: Zero snd_ctl_elem_value

Shay Bar <shay.bar@celeno.com>
    mac80211: 160MHz with extended NSS BW in CSA

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/nvif: fix method count when pushing an array

James Schulman <james.schulman@cirrus.com>
    ASoC: wm_adsp: Fix control name parsing for multi-fw

David Collins <collinsd@codeaurora.org>
    regulator: core: avoid regulator_resolve_supply() race condition

Cong Wang <cong.wang@bytedance.com>
    af_key: relax availability checks for skb size calculation

Raoni Fassina Firmino <raoni@linux.ibm.com>
    powerpc/64/signal: Fix regression in __kernel_sigtramp_rt64() semantics

Kent Gibson <warthog618@gmail.com>
    gpiolib: cdev: clear debounce period if line set to output

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: drop mm/files between task_work_submit

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: reinforce cancel on flush during exit

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix sqo ownership false positive warning

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix list corruption for splice file_get

Hao Xu <haoxu@linux.alibaba.com>
    io_uring: fix flush cqring overflow list while TASK_INTERRUPTIBLE

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix cancellation taking mutex while TASK_UNINTERRUPTIBLE

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: replace inflight_wait with tctx->wait

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix __io_uring_files_cancel() with TASK_UNINTERRUPTIBLE

Jens Axboe <axboe@kernel.dk>
    io_uring: if we see flush on exit, cancel related tasks

Jens Axboe <axboe@kernel.dk>
    io_uring: account io_uring internal files as REQ_F_INFLIGHT

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix files cancellation

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: always batch cancel in *cancel_files()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: pass files into kill timeouts/poll

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: don't iterate io_uring_cancel_files()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: add a {task,files} pair matching helper

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: simplify io_task_match()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/powerpc/kernel/vdso.c                         |   2 +-
 arch/powerpc/kernel/vdso64/sigtramp.S              |  11 +-
 arch/powerpc/kernel/vdso64/vdso64.lds.S            |   1 +
 block/blk-cgroup.c                                 |  18 +-
 drivers/gpio/gpiolib-cdev.c                        |   2 +
 drivers/gpu/drm/i915/display/intel_ddi.c           |  13 +-
 drivers/gpu/drm/nouveau/include/nvif/push.h        | 216 ++++++-------
 drivers/i2c/busses/i2c-mt65xx.c                    |  19 +-
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |   7 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |  25 ++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   3 +
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   6 +
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |  11 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  10 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   5 +
 drivers/net/wireless/intel/iwlwifi/queue/tx.c      |   6 +-
 drivers/regulator/core.c                           |  44 ++-
 fs/io-wq.c                                         |  10 -
 fs/io-wq.h                                         |   1 -
 fs/io_uring.c                                      | 360 ++++++++-------------
 fs/nfs/pnfs.c                                      |  30 +-
 fs/nilfs2/file.c                                   |   1 +
 fs/squashfs/block.c                                |   8 +-
 fs/squashfs/export.c                               |  41 ++-
 fs/squashfs/id.c                                   |  40 ++-
 fs/squashfs/squashfs_fs_sb.h                       |   1 +
 fs/squashfs/super.c                                |   6 +-
 fs/squashfs/xattr.h                                |  10 +-
 fs/squashfs/xattr_id.c                             |  66 +++-
 include/linux/sunrpc/xdr.h                         |   3 +-
 kernel/bpf/verifier.c                              |  38 +--
 mm/memcontrol.c                                    |   5 +-
 net/key/af_key.c                                   |   6 +-
 net/mac80211/spectmgmt.c                           |  10 +-
 net/sunrpc/auth_gss/auth_gss.c                     |  30 +-
 net/sunrpc/auth_gss/auth_gss_internal.h            |  45 +++
 net/sunrpc/auth_gss/gss_krb5_mech.c                |  31 +-
 sound/hda/intel-dsp-config.c                       |   4 +
 sound/soc/codecs/ak4458.c                          |  22 +-
 sound/soc/codecs/wm_adsp.c                         |   3 +
 sound/soc/intel/boards/sof_sdw.c                   |  10 +
 sound/soc/intel/skylake/skl-topology.c             |   2 +-
 46 files changed, 683 insertions(+), 516 deletions(-)


