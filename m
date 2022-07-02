Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46DF45640E0
	for <lists+stable@lfdr.de>; Sat,  2 Jul 2022 16:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbiGBO5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jul 2022 10:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbiGBO5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jul 2022 10:57:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E10DEF8;
        Sat,  2 Jul 2022 07:57:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27708B832C1;
        Sat,  2 Jul 2022 14:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FF8C34114;
        Sat,  2 Jul 2022 14:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656773863;
        bh=UTcJzNiasbdg/J+IxBLRiWYwbnpQNFUGHOa43YRMfd8=;
        h=From:To:Cc:Subject:Date:From;
        b=qcRc8yodrqDA0Rbeb1CJvBYjGjMlGZucb+HuCHqfaRX8Qz0ojxEgDJeiSMrBOE0yL
         qA288dLgVLDDrFYSSy4jnArjKZTpuaDBOaNw6FE1i+Y6KTRnjydadH/QFyL35BE240
         hpOBW9nc1dElm5VFjQAdP5pxMIfTVcrSfNqYRnjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.52
Date:   Sat,  2 Jul 2022 16:57:37 +0200
Message-Id: <16567738587380@kroah.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
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

I'm announcing the release of the 5.15.52 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/idmappings.rst      |   72 --------
 Makefile                                      |    2 
 arch/powerpc/include/asm/ftrace.h             |    4 
 arch/powerpc/kernel/trace/ftrace.c            |   15 +
 arch/powerpc/mm/mem.c                         |    2 
 arch/x86/kernel/kvm.c                         |    2 
 drivers/md/bcache/btree.c                     |    1 
 drivers/md/bcache/writeback.c                 |    1 
 drivers/net/ethernet/mscc/ocelot.c            |    8 
 drivers/net/wireless/realtek/rtw88/rtw8821c.c |   14 +
 fs/attr.c                                     |   26 ++
 fs/cachefiles/bind.c                          |    2 
 fs/ecryptfs/main.c                            |    2 
 fs/io_uring.c                                 |   28 +--
 fs/ksmbd/smbacl.c                             |   19 --
 fs/ksmbd/smbacl.h                             |    5 
 fs/namespace.c                                |   53 ++++-
 fs/nfsd/export.c                              |    2 
 fs/open.c                                     |    8 
 fs/overlayfs/super.c                          |    2 
 fs/posix_acl.c                                |   27 ++-
 fs/proc_namespace.c                           |    2 
 fs/xattr.c                                    |    6 
 fs/xfs/libxfs/xfs_attr.c                      |   17 -
 fs/xfs/xfs_aops.c                             |   15 +
 fs/xfs/xfs_buf_item_recover.c                 |    2 
 fs/xfs/xfs_extfree_item.c                     |    6 
 fs/xfs/xfs_inode.c                            |    8 
 fs/xfs/xfs_linux.h                            |    1 
 fs/xfs/xfs_log_cil.c                          |    6 
 fs/xfs/xfs_super.c                            |   21 +-
 fs/xfs/xfs_symlink.c                          |    4 
 include/linux/fs.h                            |  141 ++++-----------
 include/linux/mnt_idmapping.h                 |  234 ++++++++++++++++++++++++++
 include/linux/posix_acl_xattr.h               |    4 
 kernel/time/tick-sched.c                      |    1 
 security/commoncap.c                          |   15 +
 37 files changed, 490 insertions(+), 288 deletions(-)

Brian Foster (1):
      xfs: punch out data fork delalloc blocks on COW writeback failure

Christian Brauner (12):
      fs: add is_idmapped_mnt() helper
      fs: move mapping helpers
      fs: tweak fsuidgid_has_mapping()
      fs: account for filesystem mappings
      docs: update mapping documentation
      fs: use low-level mapping helpers
      fs: remove unused low-level mapping helpers
      fs: port higher-level mapping helpers
      fs: add i_user_ns() helper
      fs: support mapped mounts of mapped filesystems
      fs: fix acl translation
      fs: account for group membership

Coly Li (1):
      bcache: memset on stack variables in bch_btree_check() and bch_sectors_dirty_init()

Darrick J. Wong (3):
      xfs: remove all COW fork extents when remounting readonly
      xfs: prevent UAF in xfs_log_item_in_current_chkpt
      xfs: only bother with sync_filesystem during readonly remount

Dave Chinner (1):
      xfs: check sb_meta_uuid for dabuf buffer recovery

Greg Kroah-Hartman (2):
      x86, kvm: use proper ASM macros for kvm_vcpu_is_preempted
      Linux 5.15.52

Guo-Feng Fan (1):
      rtw88: 8821c: support RFE type4 wifi NIC

Masahiro Yamada (1):
      tick/nohz: unexport __init-annotated tick_nohz_full_setup()

Naveen N. Rao (1):
      powerpc/ftrace: Remove ftrace init tramp once kernel init is complete

Pavel Begunkov (1):
      io_uring: fix not locked access to fixed buf table

Ping-Ke Shih (1):
      rtw88: rtw8821c: enable rfe 6 devices

Rustam Kovhaev (1):
      xfs: use kmem_cache_free() for kmem_cache objects

Vladimir Oltean (1):
      net: mscc: ocelot: allow unregistered IP multicast flooding to CPU

Yang Xu (1):
      xfs: Fix the free logic of state in xfs_attr_node_hasname

