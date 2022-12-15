Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABF464E037
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 19:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiLOSKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 13:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLOSKn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 13:10:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD926147;
        Thu, 15 Dec 2022 10:10:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06B8461E59;
        Thu, 15 Dec 2022 18:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8153C433EF;
        Thu, 15 Dec 2022 18:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671127839;
        bh=F4U0ZFdAXj+74LYC3BcBLmMk6whq3qdqz6xNXMglYQg=;
        h=From:To:Cc:Subject:Date:From;
        b=jp6X1cIgtebuLvE011BNyCyt8TF2yuy4/qkxLSoYHnyWCYoG+UhV3GbHucDU0BZAz
         PIQ+A3C8fc3UQ06CBw8hTigEOaBwZt0Mo/0p5XImT/tYOF7gT8QNm1pap4OvZErzlV
         jNGNLO2Wcu/1nciDTfGuNwwkusefED9YWK5EJ+2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.4 0/9] 5.4.228-rc1 review
Date:   Thu, 15 Dec 2022 19:10:27 +0100
Message-Id: <20221215172905.468656378@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.228-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.228-rc1
X-KernelTest-Deadline: 2022-12-17T17:29+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.228 release.
There are 9 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.228-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.228-rc1

Yasushi SHOJI <yasushi.shoji@gmail.com>
    can: mcba_usb: Fix termination command argument

Heiko Schocher <hs@denx.de>
    can: sja1000: fix size of OCR_MODE_MASK define

Ricardo Ribalda <ribalda@chromium.org>
    pinctrl: meditatek: Startup with the IRQs disabled

Mark Brown <broonie@kernel.org>
    ASoC: ops: Check bounds for second channel in snd_soc_put_volsw_sx()

Jialiang Wang <wangjialiang0806@163.com>
    nfp: fix use-after-free in area_cache_get()

Ming Lei <ming.lei@redhat.com>
    block: unhash blkdev part inode when the part is deleted

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm/hugetlb: fix races when looking up a CONT-PTE/PMD size hugetlb page

Paul E. McKenney <paulmck@kernel.org>
    x86/smpboot: Move rcu_cpu_starting() earlier

Lorenzo Colitti <lorenzo@google.com>
    net: bpf: Allow TC programs to call BPF_FUNC_skb_change_head


-------------

Diffstat:

 Makefile                                           |  4 +--
 arch/x86/kernel/cpu/mtrr/mtrr.c                    |  2 --
 arch/x86/kernel/smpboot.c                          |  1 +
 block/partition-generic.c                          |  7 +++++
 drivers/net/can/usb/mcba_usb.c                     | 10 +++++---
 .../ethernet/netronome/nfp/nfpcore/nfp_cppcore.c   |  3 ++-
 drivers/pinctrl/mediatek/mtk-eint.c                |  9 ++++---
 include/linux/can/platform/sja1000.h               |  2 +-
 include/linux/hugetlb.h                            |  6 ++---
 mm/gup.c                                           | 13 +++++++++-
 mm/hugetlb.c                                       | 30 +++++++++++-----------
 net/core/filter.c                                  |  2 ++
 sound/soc/soc-ops.c                                |  6 +++++
 13 files changed, 64 insertions(+), 31 deletions(-)


