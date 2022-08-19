Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F59A599E8E
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 17:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349975AbiHSPm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349972AbiHSPmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:42:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B01103625;
        Fri, 19 Aug 2022 08:41:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECAEA6163B;
        Fri, 19 Aug 2022 15:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24E4C433C1;
        Fri, 19 Aug 2022 15:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660923689;
        bh=hiMg46p6NCJj1EV5/LXQXtG9v0apz6S0I5TWCJsZky4=;
        h=From:To:Cc:Subject:Date:From;
        b=BAZoJV2CHgW4ATH4c+yHqqa5Zpszb8O3yQA86JtY1EEgWRXmYlr4Bbs65tDSbrE8E
         aR1kUAxpZXYsojmQUZSj68HnlxGXOg/3nnDZWjrMDF02zKaIWmDECqJtTLLVFoqeua
         nsFJZCF+5cLaLf/CwRbe/mMWHLG3Ww0SP1LK6s6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 00/14] 5.15.62-rc1 review
Date:   Fri, 19 Aug 2022 17:40:16 +0200
Message-Id: <20220819153711.658766010@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.62-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.62-rc1
X-KernelTest-Deadline: 2022-08-21T15:37+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.62 release.
There are 14 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.62-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.62-rc1

Coiby Xu <coxu@redhat.com>
    arm64: kexec_file: use more system keyrings to verify kernel image signature

Coiby Xu <coxu@redhat.com>
    kexec, KEYS: make the code in bzImage64_verify_sig generic

Coiby Xu <coxu@redhat.com>
    kexec: clean up arch_kexec_kernel_verify_sig

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    kexec_file: drop weak attribute from functions

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

 Makefile                          |   4 +-
 arch/arm64/include/asm/kexec.h    |   4 +-
 arch/arm64/kernel/kexec_image.c   |  11 +---
 arch/powerpc/include/asm/kexec.h  |   9 +++
 arch/s390/include/asm/kexec.h     |   3 +
 arch/x86/include/asm/kexec.h      |   6 ++
 arch/x86/kernel/ftrace.c          |   7 +-
 arch/x86/kernel/ftrace_64.S       |  19 ++++--
 arch/x86/kernel/kexec-bzimage64.c |  20 +-----
 drivers/tee/tee_shm.c             |   3 +
 fs/btrfs/raid56.c                 |  74 +++++++++++++++++-----
 fs/io_uring.c                     |   2 +-
 fs/ksmbd/smb2misc.c               |   7 +-
 fs/ksmbd/smb2pdu.c                |  45 +++++++------
 fs/ksmbd/smbacl.c                 | 130 ++++++++++++++++++++++++++------------
 fs/ksmbd/smbacl.h                 |   2 +-
 fs/ksmbd/vfs.c                    |   5 ++
 include/linux/kexec.h             |  50 ++++++++++++---
 kernel/kexec_file.c               |  83 +++++++++---------------
 net/sched/cls_route.c             |  10 +++
 20 files changed, 312 insertions(+), 182 deletions(-)


