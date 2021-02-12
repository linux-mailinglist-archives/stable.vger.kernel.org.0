Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCCE319AED
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 08:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhBLHzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 02:55:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhBLHzt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Feb 2021 02:55:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 600CD64E57;
        Fri, 12 Feb 2021 07:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613116507;
        bh=/Yh86elu8rfhzYjLKlG5boslxjSKh2cvPC/wgQfni+k=;
        h=From:To:Cc:Subject:Date:From;
        b=CankR8Zc2WIg/2O6oxHxVwc7VoZdoNkJpZvNJx1bJcenr6ljO7bUpG9A+R17icLKl
         7m+OJgO1KFsKEjwx3vu4ZfeY6GAK6Fv9cstpXvw6/l76ia0HORMxZ02sDWAGDctzrt
         +fyjhxdm91kpoA0QHXs0ej6YE5eBSASiqNErQo4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/27] 4.19.176-rc2 review
Date:   Fri, 12 Feb 2021 08:55:04 +0100
Message-Id: <20210212074240.963766197@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.176-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.176-rc2
X-KernelTest-Deadline: 2021-02-14T07:42+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.176 release.
There are 27 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 14 Feb 2021 07:42:29 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.176-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.176-rc2

Mark Brown <broonie@kernel.org>
    regulator: Fix lockdep warning resolving supplies

Douglas Anderson <dianders@chromium.org>
    regulator: core: Clean enabling always-on regulators + their supplies

Olliver Schinagl <oliver@schinagl.nl>
    regulator: core: enable power when setting up constraints

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: add more sanity checks in xattr id lookup

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: add more sanity checks in inode lookup

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: add more sanity checks in id lookup

Ming Lei <ming.lei@redhat.com>
    blk-mq: don't hold q->sysfs_lock in blk_mq_map_swqueue

Ming Lei <ming.lei@redhat.com>
    block: don't hold q->sysfs_lock in elevator_init_mq

Peter Gonda <pgonda@google.com>
    Fix unsynchronized access to sev members through svm_register_enc_region

Theodore Ts'o <tytso@mit.edu>
    memcg: fix a crash in wb_workfn when a device disappears

Qian Cai <cai@lca.pw>
    include/trace/events/writeback.h: fix -Wstringop-truncation warnings

Tobin C. Harding <tobin@kernel.org>
    lib/string: Add strscpy_pad() function

Dave Wysochanski <dwysocha@redhat.com>
    SUNRPC: Handle 0 length opaque XDR object data properly

Dave Wysochanski <dwysocha@redhat.com>
    SUNRPC: Move simple_get_bytes and simple_get_netobj into private header

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: guard against device removal in reprobe

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: fix context info memory leak

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: pcie: add a NULL check in iwl_pcie_txq_unmap

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: take mutex for calling iwl_mvm_get_sync_time()

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS/NFSv4: Try to return invalid layout in pnfs_layout_process()

Pan Bian <bianpan2016@163.com>
    chtls: Fix potential resource leak

David Collins <collinsd@codeaurora.org>
    regulator: core: avoid regulator_resolve_supply() race condition

Cong Wang <cong.wang@bytedance.com>
    af_key: relax availability checks for skb size calculation

Sibi Sankar <sibis@codeaurora.org>
    remoteproc: qcom_q6v5_mss: Validate MBA firmware size before load

Sibi Sankar <sibis@codeaurora.org>
    remoteproc: qcom_q6v5_mss: Validate modem blob firmware size before load

Steven Rostedt (VMware) <rostedt@goodmis.org>
    fgraph: Initialize tracing_graph_pause at task creation

zhengbin <zhengbin13@huawei.com>
    block: fix NULL pointer dereference in register_disk

Masami Hiramatsu <mhiramat@kernel.org>
    tracing/kprobe: Fix to support kretprobe events on unloaded modules


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/x86/kvm/svm.c                                 | 18 +++--
 block/blk-mq.c                                     |  7 --
 block/elevator.c                                   | 14 ++--
 block/genhd.c                                      | 10 +--
 drivers/crypto/chelsio/chtls/chtls_cm.c            |  7 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |  3 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  3 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   | 11 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  5 ++
 drivers/regulator/core.c                           | 84 +++++++++++++++-------
 drivers/remoteproc/qcom_q6v5_pil.c                 | 11 ++-
 fs/fs-writeback.c                                  |  2 +-
 fs/nfs/pnfs.c                                      |  8 ++-
 fs/squashfs/export.c                               | 41 ++++++++---
 fs/squashfs/id.c                                   | 40 ++++++++---
 fs/squashfs/squashfs_fs_sb.h                       |  1 +
 fs/squashfs/super.c                                |  6 +-
 fs/squashfs/xattr.h                                | 10 ++-
 fs/squashfs/xattr_id.c                             | 66 ++++++++++++++---
 include/linux/backing-dev.h                        | 10 +++
 include/linux/kprobes.h                            |  2 +-
 include/linux/string.h                             |  4 ++
 include/linux/sunrpc/xdr.h                         |  3 +-
 include/trace/events/writeback.h                   | 35 +++++----
 init/init_task.c                                   |  3 +-
 kernel/kprobes.c                                   | 34 ++++++---
 kernel/trace/ftrace.c                              |  2 -
 kernel/trace/trace_kprobe.c                        |  4 +-
 lib/string.c                                       | 47 ++++++++++--
 mm/backing-dev.c                                   |  1 +
 net/key/af_key.c                                   |  6 +-
 net/sunrpc/auth_gss/auth_gss.c                     | 30 +-------
 net/sunrpc/auth_gss/auth_gss_internal.h            | 45 ++++++++++++
 net/sunrpc/auth_gss/gss_krb5_mech.c                | 31 +-------
 35 files changed, 411 insertions(+), 197 deletions(-)


