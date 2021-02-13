Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4CD31AB9B
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 14:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhBMNSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 08:18:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229832AbhBMNRm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Feb 2021 08:17:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB9DB64E4C;
        Sat, 13 Feb 2021 13:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613222221;
        bh=HohCFhkgE8Mf1zpp0Fv//131K5YQhQrV9l0KXpTqnkM=;
        h=From:To:Cc:Subject:Date:From;
        b=D4OTUgpWXI8M+ljCT+76OLjhVqC7sKjQfcccdTk0SkLCzinj+0DzWc3Io2nAEGgz3
         FtJrCWPHDIDqv6+CXBTT/0J1oLx5N3fxJ34drnGTHNqHm8SChy12JH7GMhFvEVjqAj
         7HtLrRY2Bo85c5JD4kE6RX37bdVAZCBgeITTSSYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.98
Date:   Sat, 13 Feb 2021 14:16:54 +0100
Message-Id: <1613222215146129@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.98 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                 |    2 
 arch/x86/kvm/svm.c                                       |   18 ++--
 block/blk-cgroup.c                                       |   18 ++--
 drivers/crypto/chelsio/chtls/chtls_cm.c                  |    7 -
 drivers/i2c/busses/i2c-mt65xx.c                          |   19 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c     |    3 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c        |    3 
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c             |    7 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c             |    6 +
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c |   11 ++
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c             |    5 +
 drivers/regulator/core.c                                 |   44 +++++++---
 fs/nfs/pnfs.c                                            |    8 +
 fs/squashfs/export.c                                     |   41 +++++++--
 fs/squashfs/id.c                                         |   40 +++++++--
 fs/squashfs/squashfs_fs_sb.h                             |    1 
 fs/squashfs/super.c                                      |    6 -
 fs/squashfs/xattr.h                                      |   10 ++
 fs/squashfs/xattr_id.c                                   |   66 ++++++++++++---
 include/linux/kprobes.h                                  |    2 
 include/linux/sunrpc/xdr.h                               |    3 
 kernel/bpf/verifier.c                                    |   28 ++----
 kernel/kprobes.c                                         |   34 +++++--
 kernel/trace/trace_kprobe.c                              |   10 +-
 net/key/af_key.c                                         |    6 -
 net/mac80211/spectmgmt.c                                 |   10 +-
 net/sunrpc/auth_gss/auth_gss.c                           |   30 ------
 net/sunrpc/auth_gss/auth_gss_internal.h                  |   45 ++++++++++
 net/sunrpc/auth_gss/gss_krb5_mech.c                      |   31 -------
 sound/soc/codecs/ak4458.c                                |   22 +----
 sound/soc/intel/skylake/skl-topology.c                   |    2 
 31 files changed, 363 insertions(+), 175 deletions(-)

Baolin Wang (1):
      blk-cgroup: Use cond_resched() when destroy blkgs

Cong Wang (1):
      af_key: relax availability checks for skb size calculation

Daniel Borkmann (1):
      bpf: Fix 32 bit src register truncation on div/mod

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
      Linux 5.4.98

Gregory Greenman (1):
      iwlwifi: mvm: invalidate IDs of internal stations at mvm start

Johannes Berg (3):
      iwlwifi: mvm: take mutex for calling iwl_mvm_get_sync_time()
      iwlwifi: pcie: fix context info memory leak
      iwlwifi: mvm: guard against device removal in reprobe

Mark Brown (1):
      regulator: Fix lockdep warning resolving supplies

Masami Hiramatsu (1):
      tracing/kprobe: Fix to support kretprobe events on unloaded modules

Pan Bian (1):
      chtls: Fix potential resource leak

Peter Gonda (1):
      Fix unsynchronized access to sev members through svm_register_enc_region

Phillip Lougher (3):
      squashfs: add more sanity checks in id lookup
      squashfs: add more sanity checks in inode lookup
      squashfs: add more sanity checks in xattr id lookup

Qii Wang (1):
      i2c: mediatek: Move suspend and resume handling to NOIRQ phase

Ricardo Ribalda (1):
      ASoC: Intel: Skylake: Zero snd_ctl_elem_value

Sara Sharon (1):
      iwlwifi: mvm: skip power command when unbinding vif during CSA

Shay Bar (1):
      mac80211: 160MHz with extended NSS BW in CSA

Trond Myklebust (1):
      pNFS/NFSv4: Try to return invalid layout in pnfs_layout_process()

