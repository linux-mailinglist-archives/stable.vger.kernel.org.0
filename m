Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF48599EB0
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 17:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349506AbiHSPko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349944AbiHSPkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:40:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576C21022A1;
        Fri, 19 Aug 2022 08:40:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41C15B82811;
        Fri, 19 Aug 2022 15:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEC6C433C1;
        Fri, 19 Aug 2022 15:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660923624;
        bh=aN7ikgqYQS/8ATnVfbtoQ7KtdoZZkAyN1Q6O+e/woho=;
        h=From:To:Cc:Subject:Date:From;
        b=DmoKRLjvRz1NXNYiW6JTo/MDbmhqb/04FLEFqZZsCg3xFdTT9sxVsF1qKFFa30drq
         hofInAWqCXsEU7XVh2V/kdRoOSqpr+4bTElBs8B9dGs75Nmh5+4jl3T1BgFjkptKQF
         gJrWbMVM3TAydxWd436xq3sSgCMmoq8M49nGOHFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.18 0/6] 5.18.19-rc1 review
Date:   Fri, 19 Aug 2022 17:40:12 +0200
Message-Id: <20220819153710.430046927@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.19-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.18.19-rc1
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

-------------------
NOTE, this is the LAST 5.18.y stable release.  This tree will be
end-of-life after this one.  Please move to 5.19.y at this point in time
or let us know why that is not possible.
-------------------

This is the start of the stable review cycle for the 5.18.19 release.
There are 6 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.19-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.18.19-rc1

Coiby Xu <coxu@redhat.com>
    arm64: kexec_file: use more system keyrings to verify kernel image signature

Coiby Xu <coxu@redhat.com>
    kexec, KEYS: make the code in bzImage64_verify_sig generic

Qu Wenruo <wqu@suse.com>
    btrfs: raid56: don't trust any cached sector in __raid56_parity_recover()

Qu Wenruo <wqu@suse.com>
    btrfs: only write the sectors in the vertical stripe which has data stripes

Jamal Hadi Salim <jhs@mojatatu.com>
    net_sched: cls_route: disallow handle of 0

Jens Wiklander <jens.wiklander@linaro.org>
    tee: add overflow check in register_shm_helper()


-------------

Diffstat:

 Makefile                          |  4 +--
 arch/arm64/kernel/kexec_image.c   | 11 +-----
 arch/x86/kernel/kexec-bzimage64.c | 20 +----------
 drivers/tee/tee_shm.c             |  3 ++
 fs/btrfs/raid56.c                 | 74 ++++++++++++++++++++++++++++++---------
 include/linux/kexec.h             |  7 ++++
 kernel/kexec_file.c               | 17 +++++++++
 net/sched/cls_route.c             | 10 ++++++
 8 files changed, 98 insertions(+), 48 deletions(-)


