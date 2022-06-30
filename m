Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1B9561D98
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235297AbiF3ON1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236838AbiF3OLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C037D1CB;
        Thu, 30 Jun 2022 06:56:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 784AB61F60;
        Thu, 30 Jun 2022 13:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56037C34115;
        Thu, 30 Jun 2022 13:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597363;
        bh=4X01PIFBlWh05yi752/l9We6l3jDCblSCjcHtAHcj/s=;
        h=From:To:Cc:Subject:Date:From;
        b=cqL8VNsFLMMSqQpckKN8OVflZZ/VlpXT4OPDCy1Z8k/e76MD49YcMgNHZnEfafEeV
         lnEvSLyGYLWcx88RAAAHX9tNQY/ksTQIyroEGYSfaMyk4wjiFJN/IheZzHVfffDgr5
         JUVzirpVmaorHX6YvHwMcMGR8o3nX6wDQ6xg/ZEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.18 0/6] 5.18.9-rc1 review
Date:   Thu, 30 Jun 2022 15:47:26 +0200
Message-Id: <20220630133230.239507521@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.9-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.18.9-rc1
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

This is the start of the stable review cycle for the 5.18.9 release.
There are 6 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.9-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.18.9-rc1

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix not locked access to fixed buf table

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/ftrace: Remove ftrace init tramp once kernel init is complete

Kees Cook <keescook@chromium.org>
    hinic: Replace memcpy() with direct assignment

Coly Li <colyli@suse.de>
    bcache: memset on stack variables in bch_btree_check() and bch_sectors_dirty_init()

Linus Walleij <linus.walleij@linaro.org>
    clocksource/drivers/ixp4xx: Drop boardfile probe path

Masahiro Yamada <masahiroy@kernel.org>
    tick/nohz: unexport __init-annotated tick_nohz_full_setup()


-------------

Diffstat:

 Makefile                                          |  4 +--
 arch/powerpc/include/asm/ftrace.h                 |  4 ++-
 arch/powerpc/kernel/trace/ftrace.c                | 15 ++++++++--
 arch/powerpc/mm/mem.c                             |  2 ++
 drivers/clocksource/Kconfig                       |  2 +-
 drivers/clocksource/timer-ixp4xx.c                | 25 -----------------
 drivers/md/bcache/btree.c                         |  1 +
 drivers/md/bcache/writeback.c                     |  1 +
 drivers/net/ethernet/huawei/hinic/hinic_devlink.c |  4 +--
 fs/io_uring.c                                     | 34 ++++++++++++-----------
 include/linux/platform_data/timer-ixp4xx.h        | 11 --------
 kernel/time/tick-sched.c                          |  1 -
 12 files changed, 41 insertions(+), 63 deletions(-)


