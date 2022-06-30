Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB28561D21
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236436AbiF3OI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236727AbiF3OH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:07:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548BA72EF5;
        Thu, 30 Jun 2022 06:54:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6CA862152;
        Thu, 30 Jun 2022 13:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A19C34115;
        Thu, 30 Jun 2022 13:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597265;
        bh=MsT6bAXMxy3BBJuQ+eQJx81JIY1mMrFyvXy7QNY985o=;
        h=From:To:Cc:Subject:Date:From;
        b=TxeyRi/y/40/9WRBKN+3xEKhfUENFam9OwKaR0S3cgEu3cO7nmpwPRYpaw1OVpl/R
         8Q+ZO/OHfLYLitYomgWN7MolS3absAszyW8enoxPCVvbCb0wjuR2UjCkXd9s8sYv5B
         7udi8FhAMX+HdX5ptG4tUbb8j0xCAUTu+Al79KeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/12] 5.10.128-rc1 review
Date:   Thu, 30 Jun 2022 15:47:05 +0200
Message-Id: <20220630133230.676254336@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.128-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.128-rc1
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

This is the start of the stable review cycle for the 5.10.128 release.
There are 12 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.128-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.128-rc1

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: allow unregistered IP multicast flooding

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/ftrace: Remove ftrace init tramp once kernel init is complete

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
    clocksource/drivers/ixp4xx: remove __init from ixp4xx_timer_setup()

Masahiro Yamada <masahiroy@kernel.org>
    tick/nohz: unexport __init-annotated tick_nohz_full_setup()

Christoph Hellwig <hch@lst.de>
    drm: remove drm_fb_helper_modinit

Amir Goldstein <amir73il@gmail.com>
    MAINTAINERS: add Amir as xfs maintainer for 5.10.y


-------------

Diffstat:

 MAINTAINERS                                |  3 ++-
 Makefile                                   |  4 ++--
 arch/powerpc/include/asm/ftrace.h          |  4 +++-
 arch/powerpc/kernel/trace/ftrace.c         | 15 ++++++++++++---
 arch/powerpc/mm/mem.c                      |  2 ++
 drivers/clocksource/mmio.c                 |  2 +-
 drivers/clocksource/timer-ixp4xx.c         | 10 ++++------
 drivers/gpu/drm/drm_crtc_helper_internal.h | 10 ----------
 drivers/gpu/drm/drm_fb_helper.c            | 21 ---------------------
 drivers/gpu/drm/drm_kms_helper_common.c    | 25 ++++++++++++-------------
 drivers/md/bcache/btree.c                  |  1 +
 drivers/md/bcache/writeback.c              |  1 +
 drivers/net/ethernet/mscc/ocelot.c         |  8 ++++++--
 fs/xfs/libxfs/xfs_attr.c                   | 13 +++++--------
 fs/xfs/xfs_aops.c                          | 15 ++++++++++++---
 fs/xfs/xfs_buf_item_recover.c              |  2 +-
 fs/xfs/xfs_extfree_item.c                  |  6 +++---
 fs/xfs/xfs_super.c                         | 14 +++++++++++---
 include/linux/platform_data/timer-ixp4xx.h |  5 ++---
 kernel/time/tick-sched.c                   |  1 -
 20 files changed, 80 insertions(+), 82 deletions(-)


