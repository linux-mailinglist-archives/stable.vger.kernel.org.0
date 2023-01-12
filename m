Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED896673C0
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 14:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjALN50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 08:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjALN5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 08:57:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DE149149;
        Thu, 12 Jan 2023 05:57:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E6ACB81E69;
        Thu, 12 Jan 2023 13:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80EB7C433EF;
        Thu, 12 Jan 2023 13:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673531841;
        bh=RpE3C9hcWr3R39LG47mt9CWEyjptD/q/m5p2Q6P2QAE=;
        h=From:To:Cc:Subject:Date:From;
        b=eT/4zX8EYf7X4OyWxRE7uhETbuJ46o540NZzn1UG/1EbREKpETk14IP3KYFkkwwia
         MpoaeHMjTYnYal86CGZcjdr4YkxP0Ii4ubiyYYV7WabRcVLBV4ztAOpGlHfUEBw3wY
         5dw5Jrw39Ke4CaNKoJC/PbMCXgF7MUpXoTIq1JUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 00/10] 5.15.88-rc1 review
Date:   Thu, 12 Jan 2023 14:56:37 +0100
Message-Id: <20230112135326.689857506@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.88-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.88-rc1
X-KernelTest-Deadline: 2023-01-14T13:53+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.88 release.
There are 10 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.88-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.88-rc1

Paolo Abeni <pabeni@redhat.com>
    net/ulp: prevent ULP without clone op from entering the LISTEN status

Frederick Lawler <fred@cloudflare.com>
    net: sched: disallow noqueue for qdisc classes

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    serial: fixup backport of "serial: Deassert Transmit Enable on probe in driver-specific way"

Kyle Huey <me@kylehuey.com>
    selftests/vm/pkeys: Add a regression test for setting PKRU through ptrace

Kyle Huey <me@kylehuey.com>
    x86/fpu: Emulate XRSTOR's behavior if the xfeatures PKRU bit is not set

Kyle Huey <me@kylehuey.com>
    x86/fpu: Allow PKRU to be (once again) written by ptrace.

Kyle Huey <me@kylehuey.com>
    x86/fpu: Add a pkru argument to copy_uabi_to_xstate()

Kyle Huey <me@kylehuey.com>
    x86/fpu: Add a pkru argument to copy_uabi_from_kernel_to_xstate().

Kyle Huey <me@kylehuey.com>
    x86/fpu: Take task_struct* in copy_sigframe_from_user_to_xstate()

Helge Deller <deller@gmx.de>
    parisc: Align parisc MADV_XXX constants with all other architectures


-------------

Diffstat:

 Makefile                                     |   4 +-
 arch/parisc/include/uapi/asm/mman.h          |  27 +++---
 arch/parisc/kernel/sys_parisc.c              |  27 ++++++
 arch/parisc/kernel/syscalls/syscall.tbl      |   2 +-
 arch/x86/include/asm/fpu/xstate.h            |   4 +-
 arch/x86/kernel/fpu/regset.c                 |   2 +-
 arch/x86/kernel/fpu/signal.c                 |   2 +-
 arch/x86/kernel/fpu/xstate.c                 |  41 ++++++++-
 drivers/tty/serial/fsl_lpuart.c              |   2 +-
 drivers/tty/serial/serial_core.c             |   3 +-
 net/ipv4/inet_connection_sock.c              |  16 +++-
 net/ipv4/tcp_ulp.c                           |   4 +
 net/sched/sch_api.c                          |   5 +
 tools/arch/parisc/include/uapi/asm/mman.h    |  12 +--
 tools/perf/bench/bench.h                     |  12 ---
 tools/testing/selftests/vm/pkey-x86.h        |  12 +++
 tools/testing/selftests/vm/protection_keys.c | 131 ++++++++++++++++++++++++++-
 17 files changed, 257 insertions(+), 49 deletions(-)


