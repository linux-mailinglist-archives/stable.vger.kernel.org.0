Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077BF31ABA2
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 14:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhBMNTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 08:19:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:35386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229905AbhBMNS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Feb 2021 08:18:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7037264E4F;
        Sat, 13 Feb 2021 13:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613222232;
        bh=f8hO2mVlO6p/6UoSHLqFUd9pFHmBmyJw9M0jV8OH7dg=;
        h=From:To:Cc:Subject:Date:From;
        b=OUC3cebsX3aHL6gZW/NpMFAyVPjzA2qF/6n0JC8PQh3ixAyC5y877K8daqiSaoLJ8
         x9oZDxEdSE3pZoSGf+7zy8gV4r7Wr4wbMJ452l89JWJxs1M19QFU6zuMcnlPA+luHD
         Co33ckSUCkNDDVsqguW36APY0c2+gYK6OA3Vk6IU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.16
Date:   Sat, 13 Feb 2021 14:16:59 +0100
Message-Id: <1613222220445@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.16 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 arch/powerpc/kernel/vdso.c                                  |    2 
 arch/powerpc/kernel/vdso64/sigtramp.S                       |   11 
 arch/powerpc/kernel/vdso64/vdso64.lds.S                     |    1 
 block/blk-cgroup.c                                          |   18 
 drivers/gpio/gpiolib-cdev.c                                 |    2 
 drivers/gpu/drm/i915/display/intel_ddi.c                    |   13 
 drivers/gpu/drm/nouveau/include/nvif/push.h                 |  216 +++----
 drivers/i2c/busses/i2c-mt65xx.c                             |   19 
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c |    7 
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c              |   25 
 drivers/net/wireless/intel/iwlwifi/iwl-config.h             |    3 
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c        |    3 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c           |    3 
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c                |    7 
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                |    6 
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c    |   11 
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c               |   10 
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c                |    5 
 drivers/net/wireless/intel/iwlwifi/queue/tx.c               |    6 
 drivers/regulator/core.c                                    |   44 +
 fs/io-wq.c                                                  |   10 
 fs/io-wq.h                                                  |    1 
 fs/io_uring.c                                               |  360 ++++--------
 fs/nfs/pnfs.c                                               |   30 -
 fs/nilfs2/file.c                                            |    1 
 fs/squashfs/block.c                                         |    8 
 fs/squashfs/export.c                                        |   41 +
 fs/squashfs/id.c                                            |   40 +
 fs/squashfs/squashfs_fs_sb.h                                |    1 
 fs/squashfs/super.c                                         |    6 
 fs/squashfs/xattr.h                                         |   10 
 fs/squashfs/xattr_id.c                                      |   66 +-
 include/linux/sunrpc/xdr.h                                  |    3 
 kernel/bpf/verifier.c                                       |   38 -
 mm/memcontrol.c                                             |    5 
 net/key/af_key.c                                            |    6 
 net/mac80211/spectmgmt.c                                    |   10 
 net/sunrpc/auth_gss/auth_gss.c                              |   30 -
 net/sunrpc/auth_gss/auth_gss_internal.h                     |   45 +
 net/sunrpc/auth_gss/gss_krb5_mech.c                         |   31 -
 sound/hda/intel-dsp-config.c                                |    4 
 sound/soc/codecs/ak4458.c                                   |   22 
 sound/soc/codecs/wm_adsp.c                                  |    3 
 sound/soc/intel/boards/sof_sdw.c                            |   10 
 sound/soc/intel/skylake/skl-topology.c                      |    2 
 46 files changed, 682 insertions(+), 515 deletions(-)

Baolin Wang (1):
      blk-cgroup: Use cond_resched() when destroy blkgs

Bard Liao (1):
      ALSA: hda: intel-dsp-config: add PCI id for TGL-H

Ben Skeggs (1):
      drm/nouveau/nvif: fix method count when pushing an array

Cong Wang (1):
      af_key: relax availability checks for skb size calculation

Daniel Borkmann (3):
      bpf: Fix verifier jmp32 pruning decision logic
      bpf: Fix 32 bit src register truncation on div/mod
      bpf: Fix verifier jsgt branch analysis on max bound

Dave Wysochanski (2):
      SUNRPC: Move simple_get_bytes and simple_get_netobj into private header
      SUNRPC: Handle 0 length opaque XDR object data properly

David Collins (1):
      regulator: core: avoid regulator_resolve_supply() race condition

Eliot Blennerhassett (1):
      ASoC: ak4458: correct reset polarity

Emmanuel Grumbach (1):
      iwlwifi: pcie: add a NULL check in iwl_pcie_txq_unmap

Greg Kroah-Hartman (1):
      Linux 5.10.16

Gregory Greenman (1):
      iwlwifi: mvm: invalidate IDs of internal stations at mvm start

Hao Xu (1):
      io_uring: fix flush cqring overflow list while TASK_INTERRUPTIBLE

James Schulman (1):
      ASoC: wm_adsp: Fix control name parsing for multi-fw

Jens Axboe (2):
      io_uring: account io_uring internal files as REQ_F_INFLIGHT
      io_uring: if we see flush on exit, cancel related tasks

Joachim Henke (1):
      nilfs2: make splice write available again

Johannes Berg (4):
      iwlwifi: mvm: take mutex for calling iwl_mvm_get_sync_time()
      iwlwifi: pcie: fix context info memory leak
      iwlwifi: mvm: guard against device removal in reprobe
      iwlwifi: queue: bail out on invalid freeing

Johannes Weiner (1):
      Revert "mm: memcontrol: avoid workload stalls when lowering memory.high"

Kent Gibson (1):
      gpiolib: cdev: clear debounce period if line set to output

Libin Yang (1):
      ASoC: Intel: sof_sdw: set proper flags for Dell TGL-H SKU 0A5E

Luca Coelho (1):
      iwlwifi: pcie: add rules to match Qu with Hr2

Mark Brown (1):
      regulator: Fix lockdep warning resolving supplies

Pan Bian (1):
      chtls: Fix potential resource leak

Pavel Begunkov (13):
      io_uring: simplify io_task_match()
      io_uring: add a {task,files} pair matching helper
      io_uring: don't iterate io_uring_cancel_files()
      io_uring: pass files into kill timeouts/poll
      io_uring: always batch cancel in *cancel_files()
      io_uring: fix files cancellation
      io_uring: fix __io_uring_files_cancel() with TASK_UNINTERRUPTIBLE
      io_uring: replace inflight_wait with tctx->wait
      io_uring: fix cancellation taking mutex while TASK_UNINTERRUPTIBLE
      io_uring: fix list corruption for splice file_get
      io_uring: fix sqo ownership false positive warning
      io_uring: reinforce cancel on flush during exit
      io_uring: drop mm/files between task_work_submit

Phillip Lougher (4):
      squashfs: avoid out of bounds writes in decompressors
      squashfs: add more sanity checks in id lookup
      squashfs: add more sanity checks in inode lookup
      squashfs: add more sanity checks in xattr id lookup

Qii Wang (1):
      i2c: mediatek: Move suspend and resume handling to NOIRQ phase

Raoni Fassina Firmino (1):
      powerpc/64/signal: Fix regression in __kernel_sigtramp_rt64() semantics

Ricardo Ribalda (1):
      ASoC: Intel: Skylake: Zero snd_ctl_elem_value

Sara Sharon (1):
      iwlwifi: mvm: skip power command when unbinding vif during CSA

Shay Bar (1):
      mac80211: 160MHz with extended NSS BW in CSA

Trond Myklebust (2):
      pNFS/NFSv4: Try to return invalid layout in pnfs_layout_process()
      pNFS/NFSv4: Improve rejection of out-of-order layouts

Ville Syrjälä (2):
      drm/i915: Fix ICL MG PHY vswing handling
      drm/i915: Skip vswing programming for TBT

