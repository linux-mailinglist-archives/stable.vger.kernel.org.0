Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C05BD68B668
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 08:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjBFH2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 02:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjBFH1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 02:27:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89CC1B57C;
        Sun,  5 Feb 2023 23:27:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 815F460D34;
        Mon,  6 Feb 2023 07:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97122C433D2;
        Mon,  6 Feb 2023 07:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675668439;
        bh=AC9CNcpCNhR5J0ULMqUgbpgZQGEZ+u9Biy5gUU00bf0=;
        h=From:To:Cc:Subject:Date:From;
        b=kHx0Gss+SyGkcYWnKom5Oqqo6oTW5NkQ6DSxZaP7Cvcg/sxBMf3mgvQX0SsZAxziy
         6mK1hdhVVYnz28QTJ1vYx/sAHWRU1nr63Po1iP2HRNyOOD4TWcGp2iHc63MRrXcx9p
         e4C2hesd9BirR4i/FQiLdlf/xML+4oHTnLFLzgdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.1.10
Date:   Mon,  6 Feb 2023 08:27:00 +0100
Message-Id: <167566842014820@kroah.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.1.10 kernel.

All users of the 6.1 kernel series must upgrade.

The updated 6.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                   |    2 
 arch/arm/boot/dts/imx53-ppd.dts                            |    2 
 arch/arm/boot/dts/vf610-zii-dev-rev-b.dts                  |    2 
 arch/arm/boot/dts/vf610-zii-dev-rev-c.dts                  |    2 
 arch/arm/mach-omap1/gpio15xx.c                             |    1 
 arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts          |    2 
 arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts          |    2 
 arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts          |    2 
 arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts          |    2 
 arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts          |    2 
 arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts        |    2 
 arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi         |    2 
 arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi         |    2 
 arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi        |    2 
 arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts       |    2 
 arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts          |    4 -
 arch/arm64/boot/dts/freescale/imx8mq-thor96.dts            |    4 -
 arch/arm64/boot/dts/freescale/imx8qxp-mek.dts              |    2 
 arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts |   19 ++++++-
 arch/loongarch/kernel/process.c                            |   12 +---
 arch/loongarch/kernel/unwind_guess.c                       |    6 ++
 arch/loongarch/kernel/unwind_prologue.c                    |   16 +++++-
 arch/s390/kernel/setup.c                                   |    5 +-
 block/blk-cgroup.c                                         |    4 +
 block/blk-mq.c                                             |    6 ++
 drivers/acpi/video_detect.c                                |    8 +++
 drivers/dma/imx-sdma.c                                     |    4 +
 drivers/firmware/arm_scmi/driver.c                         |    2 
 drivers/gpio/gpiolib-acpi.c                                |   20 ++++++--
 drivers/hid/hid-ids.h                                      |    1 
 drivers/hid/hid-playstation.c                              |   32 +++++++++++++
 drivers/hid/hid-uclogic-core.c                             |    2 
 drivers/hid/hid-uclogic-params.c                           |    2 
 drivers/nvme/host/apple.c                                  |    6 +-
 fs/cifs/dfs_cache.c                                        |    6 +-
 fs/erofs/super.c                                           |   13 ++---
 fs/erofs/zmap.c                                            |   10 ++--
 kernel/trace/bpf_trace.c                                   |    3 +
 net/core/skbuff.c                                          |    5 --
 net/mac80211/rx.c                                          |    3 +
 net/mctp/af_mctp.c                                         |    6 ++
 rust/kernel/print.rs                                       |   29 +++++++----
 tools/testing/selftests/lib.mk                             |    2 
 43 files changed, 189 insertions(+), 72 deletions(-)

Arnd Bergmann (1):
      ARM: omap1: fix building gpio15xx

Cristian Marussi (1):
      firmware: arm_scmi: Clear stale xfer->hdr.status

Dominik Kobinski (1):
      arm64: dts: msm8994-angler: fix the memory map

Geert Uytterhoeven (3):
      ARM: dts: imx: Fix pca9547 i2c-mux node name
      ARM: dts: vf610: Fix pca9548 i2c-mux node names
      arm64: dts: freescale: Fix pca954x i2c-mux node names

Greg Kroah-Hartman (1):
      Linux 6.1.10

Hans de Goede (1):
      ACPI: video: Add backlight=native DMI quirk for Acer Aspire 4810T

Hao Sun (1):
      bpf: Skip task with pid=1 in send_signal_common()

Heiko Carstens (1):
      s390: workaround invalid gcc-11 out of bounds read warning

Hui Wang (1):
      dmaengine: imx-sdma: Fix a possible memory leak in sdma_transfer_init

Janne Grunau (1):
      nvme-apple: only reset the controller when RTKit is running

Jeremy Kerr (1):
      net: mctp: purge receive queues on sk destruction

Jingbo Xu (1):
      erofs: clean up parsing of fscache related options

Jinyang He (1):
      LoongArch: Get frame info in unwind_start() when regs is not available

José Expósito (1):
      HID: uclogic: Add support for XP-PEN Deco 01 V2

Krzysztof Kozlowski (1):
      arm64: dts: imx8mq-thor96: fix no-mmc property for SDHCI

Mario Limonciello (3):
      gpiolib: acpi: Allow ignoring wake capability on pins that aren't in _AEI
      gpiolib: acpi: Add a ignore wakeup quirk for Clevo NL5xRU
      gpiolib-acpi: Don't set GPIOs for wakeup in S3 mode

Mark Brown (1):
      kselftest: Fix error message for unconfigured LLVM builds

Miguel Ojeda (1):
      rust: print: avoid evaluating arguments in `pr_*` macros in `unsafe` blocks

Paulo Alcantara (1):
      cifs: fix return of uninitialized rc in dfs_cache_update_tgthint()

Pavel Begunkov (1):
      block: fix hctx checks for batch allocation

Roderick Colenbrander (1):
      HID: playstation: sanity check DualSense calibration data.

Siddh Raman Pant (1):
      erofs/zmap.c: Fix incorrect offset calculation

Sriram R (1):
      mac80211: Fix MLO address translation for multiple bss case

Yan Zhai (1):
      net: fix NULL pointer in skb_segment_list

Yu Kuai (1):
      blk-cgroup: fix missing pd_online_fn() while activating policy

