Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAAE318E21
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhBKPV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:21:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230014AbhBKPRm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:17:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4350064F09;
        Thu, 11 Feb 2021 15:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055933;
        bh=oay6nCYT2aYEVTlzf7BDWQe0pcdXoheFAcG0rLPjmLM=;
        h=From:To:Cc:Subject:Date:From;
        b=bqzgzHjwmmAXVo4Pw1FeYUemx01TnUH76TFfUsYVyKiL/rAEmDy22jP26DN1hxi3I
         EV0SpbcdO/rc6xLlS1NBNE/R5gOJDVuVFD5stAbN20RlYFMAWzc2KaTkT9eDwMuf36
         iQUuXLZeYHUiyOWHsnS0NCYg6zHxiAgvy5vv5HAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/24] 5.4.98-rc1 review
Date:   Thu, 11 Feb 2021 16:02:23 +0100
Message-Id: <20210211150148.516371325@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.98-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.98-rc1
X-KernelTest-Deadline: 2021-02-13T15:01+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.98 release.
There are 24 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 13 Feb 2021 15:01:39 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.98-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.98-rc1

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: add more sanity checks in xattr id lookup

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: add more sanity checks in inode lookup

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: add more sanity checks in id lookup

Peter Gonda <pgonda@google.com>
    Fix unsynchronized access to sev members through svm_register_enc_region

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix 32 bit src register truncation on div/mod

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
    iwlwifi: mvm: guard against device removal in reprobe

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

Eliot Blennerhassett <eliot@blennerhassett.gen.nz>
    ASoC: ak4458: correct reset polarity

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS/NFSv4: Try to return invalid layout in pnfs_layout_process()

Pan Bian <bianpan2016@163.com>
    chtls: Fix potential resource leak

Ricardo Ribalda <ribalda@chromium.org>
    ASoC: Intel: Skylake: Zero snd_ctl_elem_value

Shay Bar <shay.bar@celeno.com>
    mac80211: 160MHz with extended NSS BW in CSA

David Collins <collinsd@codeaurora.org>
    regulator: core: avoid regulator_resolve_supply() race condition

Cong Wang <cong.wang@bytedance.com>
    af_key: relax availability checks for skb size calculation

Masami Hiramatsu <mhiramat@kernel.org>
    tracing/kprobe: Fix to support kretprobe events on unloaded modules


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/x86/kvm/svm.c                                 | 18 +++---
 block/blk-cgroup.c                                 | 18 ++++--
 drivers/crypto/chelsio/chtls/chtls_cm.c            |  7 +--
 drivers/i2c/busses/i2c-mt65xx.c                    | 19 ++++++-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |  3 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  3 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  7 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  6 ++
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   | 11 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  5 ++
 drivers/regulator/core.c                           | 44 +++++++++++----
 fs/nfs/pnfs.c                                      |  8 ++-
 fs/squashfs/export.c                               | 41 +++++++++++---
 fs/squashfs/id.c                                   | 40 ++++++++++---
 fs/squashfs/squashfs_fs_sb.h                       |  1 +
 fs/squashfs/super.c                                |  6 +-
 fs/squashfs/xattr.h                                | 10 +++-
 fs/squashfs/xattr_id.c                             | 66 +++++++++++++++++++---
 include/linux/kprobes.h                            |  2 +-
 include/linux/sunrpc/xdr.h                         |  3 +-
 kernel/bpf/verifier.c                              | 28 +++++----
 kernel/kprobes.c                                   | 34 ++++++++---
 kernel/trace/trace_kprobe.c                        | 10 ++--
 net/key/af_key.c                                   |  6 +-
 net/mac80211/spectmgmt.c                           | 10 +++-
 net/sunrpc/auth_gss/auth_gss.c                     | 30 +---------
 net/sunrpc/auth_gss/auth_gss_internal.h            | 45 +++++++++++++++
 net/sunrpc/auth_gss/gss_krb5_mech.c                | 31 +---------
 sound/soc/codecs/ak4458.c                          | 22 +++-----
 sound/soc/intel/skylake/skl-topology.c             |  2 +-
 31 files changed, 364 insertions(+), 176 deletions(-)


