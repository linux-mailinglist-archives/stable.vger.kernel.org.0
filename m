Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F41514714
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357582AbiD2Ko5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357570AbiD2Koz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:44:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4D5B82DD;
        Fri, 29 Apr 2022 03:41:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3AC162351;
        Fri, 29 Apr 2022 10:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D807C385A4;
        Fri, 29 Apr 2022 10:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651228896;
        bh=gSIo23UnH9bNLn4a6l75u8Olgj6fvPblKdNnVRDlAiI=;
        h=From:To:Cc:Subject:Date:From;
        b=DBqrLoWWlZMHIFq7kMycTfbDayMsNHFBGu2Exu+ievEM7ggfjRwdUKG2RieqFCSOl
         P4EjmtZUAmbzbVvgwpKVsA4VeAvv68UN0JhJmWprzi/MK49WOkbibVLArxKVtiszLD
         gU4TlyOxwoKDXJIeYuLzuzl1DKgNAK4JewcK4J2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.19 00/12] 4.19.241-rc1 review
Date:   Fri, 29 Apr 2022 12:41:17 +0200
Message-Id: <20220429104048.459089941@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.241-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.241-rc1
X-KernelTest-Deadline: 2022-05-01T10:40+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.241 release.
There are 12 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 01 May 2022 10:40:41 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.241-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.241-rc1

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    lightnvm: disable the subsystem

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "net: ethernet: stmmac: fix altr_tse_pcs function when using a fixed-link"

Masami Hiramatsu <mhiramat@kernel.org>
    ia64: kprobes: Fix to pass correct trampoline address to the handler

Masami Hiramatsu <mhiramat@kernel.org>
    Revert "ia64: kprobes: Use generic kretprobe trampoline handler"

Masami Hiramatsu <mhiramat@kernel.org>
    Revert "ia64: kprobes: Fix to pass correct trampoline address to the handler"

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Unmerge EX_LR and EX_DAR

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64/interrupt: Temporarily save PPR on stack to fix register corruption due to SLB miss

Eric Dumazet <edumazet@google.com>
    net/sched: cls_u32: fix netns refcount changes in u32_change()

Lin Ma <linma@zju.edu.cn>
    hamradio: remove needs_free_netdev to avoid UAF

Lin Ma <linma@zju.edu.cn>
    hamradio: defer 6pack kfree after unregister_netdev

Willy Tarreau <w@1wt.eu>
    floppy: disable FDRAWCMD by default

Dafna Hirschfeld <dafna3@gmail.com>
    media: vicodec: upon release, call m2m release before freeing ctrl handler


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/ia64/kernel/kprobes.c                         | 78 +++++++++++++++++++++-
 arch/powerpc/include/asm/exception-64s.h           | 37 +++++-----
 drivers/block/Kconfig                              | 16 +++++
 drivers/block/floppy.c                             | 43 +++++++++---
 drivers/lightnvm/Kconfig                           |  2 +-
 drivers/media/platform/vicodec/vicodec-core.c      |  6 +-
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c |  8 +++
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h |  4 --
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    | 13 ++--
 drivers/net/hamradio/6pack.c                       |  5 +-
 net/sched/cls_u32.c                                | 18 +++--
 12 files changed, 181 insertions(+), 53 deletions(-)


