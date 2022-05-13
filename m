Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E729A5263E3
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380512AbiEMOZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359425AbiEMOYs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:24:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE10C51E5D;
        Fri, 13 May 2022 07:24:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA14C61F99;
        Fri, 13 May 2022 14:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A451C34100;
        Fri, 13 May 2022 14:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652451885;
        bh=ats/HlYQpYgQ6ICGJ9t9YHpljthNM6r50J6d/zvOAn8=;
        h=From:To:Cc:Subject:Date:From;
        b=F91V7vJfsslOiz2t2/AjSgvZEm8GFdW8bw/2tJZHzRK6AcGw0Q7uvmJJ1UY0ccrRd
         7OrWxswAzlRpiOzrXykcZzyn7L3TOnYkPHTiKoANUmPClBKf6aqepgvBt6Yz6Du5QY
         IeuDxYWhBuOlQS9SCTbXQO2rTOR8bMheTdJUUImI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.9 0/7] 4.9.314-rc1 review
Date:   Fri, 13 May 2022 16:23:15 +0200
Message-Id: <20220513142225.909697091@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.314-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.314-rc1
X-KernelTest-Deadline: 2022-05-15T14:22+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.314 release.
There are 7 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.314-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.314-rc1

Muchun Song <songmuchun@bytedance.com>
    mm: userfaultfd: fix missing cache flush in mcopy_atomic_pte() and __mcopy_atomic()

Ricky WU <ricky_wu@realtek.com>
    mmc: rtsx: add 74 Clocks in power on flow

Itay Iellin <ieitayie@gmail.com>
    Bluetooth: Fix the creation of hdev->name

Andreas Larsson <andreas@gaisler.com>
    can: grcan: only use the NAPI poll budget for RX

Andreas Larsson <andreas@gaisler.com>
    can: grcan: grcan_probe(): fix broken system id check for errata workaround needs

Lee Jones <lee.jones@linaro.org>
    block: drbd: drbd_nl: Make conversion to 'enum drbd_ret_code' explicit

Nathan Chancellor <natechancellor@gmail.com>
    MIPS: Use address-of operator on section symbols


-------------

Diffstat:

 Makefile                          |  4 ++--
 arch/mips/bmips/setup.c           |  2 +-
 arch/mips/lantiq/prom.c           |  2 +-
 arch/mips/pic32/pic32mzda/init.c  |  2 +-
 drivers/block/drbd/drbd_nl.c      | 13 ++++++++-----
 drivers/mmc/host/rtsx_pci_sdmmc.c | 30 ++++++++++++++++++++----------
 drivers/net/can/grcan.c           | 38 ++++++++++++++++++--------------------
 include/net/bluetooth/hci_core.h  |  3 +++
 mm/userfaultfd.c                  |  3 +++
 net/bluetooth/hci_core.c          |  6 +++---
 10 files changed, 60 insertions(+), 43 deletions(-)


