Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC620527949
	for <lists+stable@lfdr.de>; Sun, 15 May 2022 20:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238502AbiEOSrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 May 2022 14:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238506AbiEOSre (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 May 2022 14:47:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CA413D21;
        Sun, 15 May 2022 11:47:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 307776111F;
        Sun, 15 May 2022 18:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458EEC34115;
        Sun, 15 May 2022 18:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652640449;
        bh=emS5L4p08r9hwaC00TiaPaoFDN6aHpuloYKhkM+inww=;
        h=From:To:Cc:Subject:Date:From;
        b=cRU74wjosyceu8U9vpVSxyk23EHAXPt2buii7taZVv9xUoQLX1cCsSpKR5ZZ8q+qM
         TMczowMnzaH4S/0XUFQ3x5SOosVh29Bdg4dFJnqkaSQiNCL2Uxra1EbGA9cQ1Af/8L
         r4V8dWMtwPl2UGILlkXeZIgj+/eBRY0A1tyY4tKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.116
Date:   Sun, 15 May 2022 20:47:13 +0200
Message-Id: <1652640434217146@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.116 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/vm/memory-model.rst                            |    3 -
 Makefile                                                     |    2 
 arch/arm/Kconfig                                             |    8 --
 arch/arm/mach-bcm/Kconfig                                    |    1 
 arch/arm/mach-davinci/Kconfig                                |    1 
 arch/arm/mach-exynos/Kconfig                                 |    1 
 arch/arm/mach-highbank/Kconfig                               |    1 
 arch/arm/mach-omap2/Kconfig                                  |    1 
 arch/arm/mach-s5pv210/Kconfig                                |    1 
 arch/arm/mach-tango/Kconfig                                  |    1 
 arch/mips/bmips/setup.c                                      |    2 
 arch/mips/lantiq/prom.c                                      |    2 
 arch/mips/pic32/pic32mzda/init.c                             |    2 
 arch/mips/ralink/of.c                                        |    2 
 drivers/block/drbd/drbd_nl.c                                 |   13 ++--
 drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c           |   12 ++--
 drivers/gpu/drm/amd/display/include/gpio_service_interface.h |    4 -
 drivers/net/ethernet/netronome/nfp/nfp_asm.c                 |    4 -
 fs/proc/kcore.c                                              |    2 
 include/linux/mmzone.h                                       |   31 -----------
 include/linux/regulator/consumer.h                           |   30 ++++++++++
 include/net/bluetooth/hci_core.h                             |    3 +
 mm/memory.c                                                  |    2 
 mm/migrate.c                                                 |    7 +-
 mm/mmzone.c                                                  |   14 ----
 mm/userfaultfd.c                                             |    3 +
 mm/vmstat.c                                                  |    4 -
 net/bluetooth/hci_core.c                                     |    6 +-
 28 files changed, 72 insertions(+), 91 deletions(-)

Dmitry Osipenko (1):
      regulator: consumer: Add missing stubs to regulator/consumer.h

Greg Kroah-Hartman (1):
      Linux 5.10.116

Itay Iellin (1):
      Bluetooth: Fix the creation of hdev->name

Lee Jones (2):
      block: drbd: drbd_nl: Make conversion to 'enum drbd_ret_code' explicit
      drm/amd/display/dc/gpio/gpio_service: Pass around correct dce_{version, environment} types

Mike Rapoport (1):
      arm: remove CONFIG_ARCH_HAS_HOLES_MEMORYMODEL

Muchun Song (3):
      mm: fix missing cache flush for all tail pages of compound page
      mm: hugetlb: fix missing cache flush in copy_huge_page_from_user()
      mm: userfaultfd: fix missing cache flush in mcopy_atomic_pte() and __mcopy_atomic()

Nathan Chancellor (2):
      MIPS: Use address-of operator on section symbols
      nfp: bpf: silence bitwise vs. logical OR warning

