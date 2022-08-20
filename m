Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72FC59B272
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 09:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiHUHBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 03:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiHUHAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 03:00:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19D426130;
        Sun, 21 Aug 2022 00:00:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61416B80BA7;
        Sun, 21 Aug 2022 07:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755D5C433C1;
        Sun, 21 Aug 2022 07:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661065243;
        bh=+tNLkwdaAJsFxR/g29LyPbKlXMNd23s45Xz6hLyafi4=;
        h=From:To:Cc:Subject:Date:From;
        b=JjvfgbVEKrkiyiicD02yuSHdUnYyPF4Roxsls9oxpS+o+VmcZDQ+bFM/foaHqpVBz
         CLHgdNGIOCfMshCN521l+ZyGs7aFIA9g7sOgSWmXz7z1hSE5VfjLqKJF/OshGQAkUs
         FPDTdSxmt6wg1RyhaFTXNxGaTgwRU2KCJWoIK4Ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 00/10] 5.15.62-rc2 review
Date:   Sat, 20 Aug 2022 20:23:24 +0200
Message-Id: <20220820182309.607584465@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.62-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.62-rc2
X-KernelTest-Deadline: 2022-08-22T18:23+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.62 release.
There are 10 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 22 Aug 2022 18:23:01 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.62-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.62-rc2

Qu Wenruo <wqu@suse.com>
    btrfs: raid56: don't trust any cached sector in __raid56_parity_recover()

Qu Wenruo <wqu@suse.com>
    btrfs: only write the sectors in the vertical stripe which has data stripes

Peter Zijlstra <peterz@infradead.org>
    x86/ftrace: Use alternative RET encoding

Peter Zijlstra <peterz@infradead.org>
    x86/ibt,ftrace: Make function-graph play nice

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    Revert "x86/ftrace: Use alternative RET encoding"

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix heap-based overflow in set_ntacl_dacl()

Hyunchul Lee <hyc.lee@gmail.com>
    ksmbd: prevent out of bound read for SMB2_WRITE

Jamal Hadi Salim <jhs@mojatatu.com>
    net_sched: cls_route: disallow handle of 0

Jens Wiklander <jens.wiklander@linaro.org>
    tee: add overflow check in register_shm_helper()

Jens Axboe <axboe@kernel.dk>
    io_uring: use original request task for inflight tracking


-------------

Diffstat:

 Makefile                    |   4 +-
 arch/x86/kernel/ftrace.c    |   7 +--
 arch/x86/kernel/ftrace_64.S |  19 +++++--
 drivers/tee/tee_shm.c       |   3 +
 fs/btrfs/raid56.c           |  74 +++++++++++++++++++------
 fs/io_uring.c               |   2 +-
 fs/ksmbd/smb2misc.c         |   7 ++-
 fs/ksmbd/smb2pdu.c          |  45 +++++++++------
 fs/ksmbd/smbacl.c           | 130 ++++++++++++++++++++++++++++++--------------
 fs/ksmbd/smbacl.h           |   2 +-
 fs/ksmbd/vfs.c              |   5 ++
 net/sched/cls_route.c       |  10 ++++
 12 files changed, 216 insertions(+), 92 deletions(-)


