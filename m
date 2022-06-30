Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79FBE561D2D
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236689AbiF3OIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237067AbiF3OII (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:08:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7399976EBE;
        Thu, 30 Jun 2022 06:55:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1619A61EE3;
        Thu, 30 Jun 2022 13:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17A8C34115;
        Thu, 30 Jun 2022 13:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597303;
        bh=DQGZOel7/DISMOe97VYoalt5eLut3Ro4R4IcQ7UIU+w=;
        h=From:To:Cc:Subject:Date:From;
        b=KYJntia7YK6ArqVWh43UFWqmnSUsCdhUWpG//az08VhRJZqKFxsDE/dn2CwfjEQIA
         NUwiq35vKeD05uR8vwNnqiTHWNSxhLsZQsPYI5a9WMkKaifNf9EHWj8y0mSAyh15k9
         mbhPtM1Jur/9plAaobCiBzvh28VJSvxQJZVQGEjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 00/28] 5.15.52-rc1 review
Date:   Thu, 30 Jun 2022 15:46:56 +0200
Message-Id: <20220630133232.926711493@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.52-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.52-rc1
X-KernelTest-Deadline: 2022-07-02T13:32+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.52 release.
There are 28 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.52-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.52-rc1

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix not locked access to fixed buf table

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: allow unregistered IP multicast flooding to CPU

Ping-Ke Shih <pkshih@realtek.com>
    rtw88: rtw8821c: enable rfe 6 devices

Guo-Feng Fan <vincent_fann@realtek.com>
    rtw88: 8821c: support RFE type4 wifi NIC

Christian Brauner <brauner@kernel.org>
    fs: account for group membership

Christian Brauner <brauner@kernel.org>
    fs: fix acl translation

Christian Brauner <christian.brauner@ubuntu.com>
    fs: support mapped mounts of mapped filesystems

Christian Brauner <christian.brauner@ubuntu.com>
    fs: add i_user_ns() helper

Christian Brauner <christian.brauner@ubuntu.com>
    fs: port higher-level mapping helpers

Christian Brauner <christian.brauner@ubuntu.com>
    fs: remove unused low-level mapping helpers

Christian Brauner <christian.brauner@ubuntu.com>
    fs: use low-level mapping helpers

Christian Brauner <christian.brauner@ubuntu.com>
    docs: update mapping documentation

Christian Brauner <christian.brauner@ubuntu.com>
    fs: account for filesystem mappings

Christian Brauner <christian.brauner@ubuntu.com>
    fs: tweak fsuidgid_has_mapping()

Christian Brauner <christian.brauner@ubuntu.com>
    fs: move mapping helpers

Christian Brauner <christian.brauner@ubuntu.com>
    fs: add is_idmapped_mnt() helper

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/ftrace: Remove ftrace init tramp once kernel init is complete

Darrick J. Wong <djwong@kernel.org>
    xfs: only bother with sync_filesystem during readonly remount

Darrick J. Wong <djwong@kernel.org>
    xfs: prevent UAF in xfs_log_item_in_current_chkpt

Dave Chinner <dchinner@redhat.com>
    xfs: check sb_meta_uuid for dabuf buffer recovery

Darrick J. Wong <djwong@kernel.org>
    xfs: remove all COW fork extents when remounting readonly

Yang Xu <xuyang2018.jy@fujitsu.com>
    xfs: Fix the free logic of state in xfs_attr_node_hasname

Brian Foster <bfoster@redhat.com>
    xfs: punch out data fork delalloc blocks on COW writeback failure

Rustam Kovhaev <rkovhaev@gmail.com>
    xfs: use kmem_cache_free() for kmem_cache objects

Coly Li <colyli@suse.de>
    bcache: memset on stack variables in bch_btree_check() and bch_sectors_dirty_init()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    x86, kvm: use proper ASM macros for kvm_vcpu_is_preempted

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    clocksource/drivers/ixp4xx: remove __init from ixp4xx_timer_setup()

Masahiro Yamada <masahiroy@kernel.org>
    tick/nohz: unexport __init-annotated tick_nohz_full_setup()


-------------

Diffstat:

 Documentation/filesystems/idmappings.rst      |  72 --------
 Makefile                                      |   4 +-
 arch/powerpc/include/asm/ftrace.h             |   4 +-
 arch/powerpc/kernel/trace/ftrace.c            |  15 +-
 arch/powerpc/mm/mem.c                         |   2 +
 arch/x86/kernel/kvm.c                         |   2 +-
 drivers/clocksource/mmio.c                    |   2 +-
 drivers/clocksource/timer-ixp4xx.c            |  10 +-
 drivers/md/bcache/btree.c                     |   1 +
 drivers/md/bcache/writeback.c                 |   1 +
 drivers/net/ethernet/mscc/ocelot.c            |   8 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.c |  14 +-
 fs/attr.c                                     |  26 ++-
 fs/cachefiles/bind.c                          |   2 +-
 fs/ecryptfs/main.c                            |   2 +-
 fs/io_uring.c                                 |  28 +--
 fs/ksmbd/smbacl.c                             |  19 +--
 fs/ksmbd/smbacl.h                             |   5 +-
 fs/namespace.c                                |  53 ++++--
 fs/nfsd/export.c                              |   2 +-
 fs/open.c                                     |   8 +-
 fs/overlayfs/super.c                          |   2 +-
 fs/posix_acl.c                                |  27 ++-
 fs/proc_namespace.c                           |   2 +-
 fs/xattr.c                                    |   6 +-
 fs/xfs/libxfs/xfs_attr.c                      |  17 +-
 fs/xfs/xfs_aops.c                             |  15 +-
 fs/xfs/xfs_buf_item_recover.c                 |   2 +-
 fs/xfs/xfs_extfree_item.c                     |   6 +-
 fs/xfs/xfs_inode.c                            |   8 +-
 fs/xfs/xfs_linux.h                            |   1 +
 fs/xfs/xfs_log_cil.c                          |   6 +-
 fs/xfs/xfs_super.c                            |  21 ++-
 fs/xfs/xfs_symlink.c                          |   4 +-
 include/linux/fs.h                            | 141 +++++-----------
 include/linux/mnt_idmapping.h                 | 234 ++++++++++++++++++++++++++
 include/linux/platform_data/timer-ixp4xx.h    |   5 +-
 include/linux/posix_acl_xattr.h               |   4 +
 kernel/time/tick-sched.c                      |   1 -
 security/commoncap.c                          |  15 +-
 40 files changed, 498 insertions(+), 299 deletions(-)


