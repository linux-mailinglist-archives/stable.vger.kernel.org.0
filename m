Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E215640DD
	for <lists+stable@lfdr.de>; Sat,  2 Jul 2022 16:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbiGBO5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jul 2022 10:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiGBO5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jul 2022 10:57:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E1EDEA9;
        Sat,  2 Jul 2022 07:57:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6CEDFCE0DB3;
        Sat,  2 Jul 2022 14:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402CCC34114;
        Sat,  2 Jul 2022 14:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656773856;
        bh=XcpJVz3j2nseAeAJtAR9oaLVb8nkuk0LBgwXQpgxF+Y=;
        h=From:To:Cc:Subject:Date:From;
        b=Jy2GzG1roLb5VSJru4wKNwQEpONZAzLb3IPwDm0nAuo4BChsBBEwgZaIL/INY/0nY
         7TDx85mHrhT7/icar9gFR3rWzuCZqqlvmDnsiwfBRt0bB6DIpvUr0cQjK4hHcWAMZw
         EPrbZ56hYa+JnZybTv8Eko4XFBu6kayGSUxdoozM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.128
Date:   Sat,  2 Jul 2022 16:57:33 +0200
Message-Id: <165677385313453@kroah.com>
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

I'm announcing the release of the 5.10.128 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 MAINTAINERS                                |    3 ++-
 Makefile                                   |    2 +-
 arch/powerpc/include/asm/ftrace.h          |    4 +++-
 arch/powerpc/kernel/trace/ftrace.c         |   15 ++++++++++++---
 arch/powerpc/mm/mem.c                      |    2 ++
 drivers/gpu/drm/drm_crtc_helper_internal.h |   10 ----------
 drivers/gpu/drm/drm_fb_helper.c            |   21 ---------------------
 drivers/gpu/drm/drm_kms_helper_common.c    |   25 ++++++++++++-------------
 drivers/md/bcache/btree.c                  |    1 +
 drivers/md/bcache/writeback.c              |    1 +
 drivers/net/ethernet/mscc/ocelot.c         |    8 ++++++--
 fs/xfs/libxfs/xfs_attr.c                   |   13 +++++--------
 fs/xfs/xfs_aops.c                          |   15 ++++++++++++---
 fs/xfs/xfs_buf_item_recover.c              |    2 +-
 fs/xfs/xfs_extfree_item.c                  |    6 +++---
 fs/xfs/xfs_super.c                         |   14 +++++++++++---
 kernel/time/tick-sched.c                   |    1 -
 17 files changed, 72 insertions(+), 71 deletions(-)

Amir Goldstein (1):
      MAINTAINERS: add Amir as xfs maintainer for 5.10.y

Brian Foster (1):
      xfs: punch out data fork delalloc blocks on COW writeback failure

Christoph Hellwig (1):
      drm: remove drm_fb_helper_modinit

Coly Li (1):
      bcache: memset on stack variables in bch_btree_check() and bch_sectors_dirty_init()

Darrick J. Wong (1):
      xfs: remove all COW fork extents when remounting readonly

Dave Chinner (1):
      xfs: check sb_meta_uuid for dabuf buffer recovery

Greg Kroah-Hartman (1):
      Linux 5.10.128

Masahiro Yamada (1):
      tick/nohz: unexport __init-annotated tick_nohz_full_setup()

Naveen N. Rao (1):
      powerpc/ftrace: Remove ftrace init tramp once kernel init is complete

Rustam Kovhaev (1):
      xfs: use kmem_cache_free() for kmem_cache objects

Vladimir Oltean (1):
      net: mscc: ocelot: allow unregistered IP multicast flooding

Yang Xu (1):
      xfs: Fix the free logic of state in xfs_attr_node_hasname

