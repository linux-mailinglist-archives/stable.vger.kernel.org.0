Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7FA52649B
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380862AbiEMOas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381048AbiEMOaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:30:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D3B8CCD2;
        Fri, 13 May 2022 07:27:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BC1FB82F64;
        Fri, 13 May 2022 14:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBEAC34115;
        Fri, 13 May 2022 14:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452074;
        bh=znZc3GTdHEhFbUeuYlH2QnELIcZgjVAxloRunIRBuXU=;
        h=From:To:Cc:Subject:Date:From;
        b=IGJhXJSNQf9p4yQ55b9/WOT0ORGENDekJIviroogsZHDcC1r/UXWaxCJ06CIzI6sK
         GAgDbSsW7RJLjCAtb9scV59GZHFL2LZSNq8uwFTsGatY7Xf5/QgT1Dxb8HgUwpfIAo
         02L2naFPg5mE4Bs4ILazOoSjppRarPbsFstMdq7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/10] 5.10.116-rc1 review
Date:   Fri, 13 May 2022 16:23:44 +0200
Message-Id: <20220513142228.303546319@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.116-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.116-rc1
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

This is the start of the stable review cycle for the 5.10.116 release.
There are 10 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.116-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.116-rc1

Muchun Song <songmuchun@bytedance.com>
    mm: userfaultfd: fix missing cache flush in mcopy_atomic_pte() and __mcopy_atomic()

Muchun Song <songmuchun@bytedance.com>
    mm: hugetlb: fix missing cache flush in copy_huge_page_from_user()

Muchun Song <songmuchun@bytedance.com>
    mm: fix missing cache flush for all tail pages of compound page

Itay Iellin <ieitayie@gmail.com>
    Bluetooth: Fix the creation of hdev->name

Mike Rapoport <rppt@kernel.org>
    arm: remove CONFIG_ARCH_HAS_HOLES_MEMORYMODEL

Nathan Chancellor <nathan@kernel.org>
    nfp: bpf: silence bitwise vs. logical OR warning

Lee Jones <lee.jones@linaro.org>
    drm/amd/display/dc/gpio/gpio_service: Pass around correct dce_{version, environment} types

Lee Jones <lee.jones@linaro.org>
    block: drbd: drbd_nl: Make conversion to 'enum drbd_ret_code' explicit

Dmitry Osipenko <digetx@gmail.com>
    regulator: consumer: Add missing stubs to regulator/consumer.h

Nathan Chancellor <natechancellor@gmail.com>
    MIPS: Use address-of operator on section symbols


-------------

Diffstat:

 Documentation/vm/memory-model.rst                  |  3 +--
 Makefile                                           |  4 +--
 arch/arm/Kconfig                                   |  8 ++----
 arch/arm/mach-bcm/Kconfig                          |  1 -
 arch/arm/mach-davinci/Kconfig                      |  1 -
 arch/arm/mach-exynos/Kconfig                       |  1 -
 arch/arm/mach-highbank/Kconfig                     |  1 -
 arch/arm/mach-omap2/Kconfig                        |  1 -
 arch/arm/mach-s5pv210/Kconfig                      |  1 -
 arch/arm/mach-tango/Kconfig                        |  1 -
 arch/mips/bmips/setup.c                            |  2 +-
 arch/mips/lantiq/prom.c                            |  2 +-
 arch/mips/pic32/pic32mzda/init.c                   |  2 +-
 arch/mips/ralink/of.c                              |  2 +-
 drivers/block/drbd/drbd_nl.c                       | 13 +++++----
 drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c | 12 ++++-----
 .../amd/display/include/gpio_service_interface.h   |  4 +--
 drivers/net/ethernet/netronome/nfp/nfp_asm.c       |  4 +--
 fs/proc/kcore.c                                    |  2 --
 include/linux/mmzone.h                             | 31 ----------------------
 include/linux/regulator/consumer.h                 | 30 +++++++++++++++++++++
 include/net/bluetooth/hci_core.h                   |  3 +++
 mm/memory.c                                        |  2 ++
 mm/migrate.c                                       |  7 +++--
 mm/mmzone.c                                        | 14 ----------
 mm/userfaultfd.c                                   |  3 +++
 mm/vmstat.c                                        |  4 ---
 net/bluetooth/hci_core.c                           |  6 ++---
 28 files changed, 73 insertions(+), 92 deletions(-)


