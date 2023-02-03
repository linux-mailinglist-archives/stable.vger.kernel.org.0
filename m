Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C2F689631
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbjBCK0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbjBCK0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:26:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06CF9F9E8;
        Fri,  3 Feb 2023 02:25:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22D6961E68;
        Fri,  3 Feb 2023 10:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8B8C433D2;
        Fri,  3 Feb 2023 10:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419648;
        bh=hGGirB/MkQLm/1/vblk4wapwUHWf/861OK5xdBjeNgk=;
        h=From:To:Cc:Subject:Date:From;
        b=VjfA21suc/ZvCtHQ0RP7X9j4u4LAPvE4ivBHEAAtICxx9ufbSSJpaTBenCdeiNcOJ
         sglXyQj8rNGFUigNoy9qoFJMxku8UC2srIFMC6TYCHOLdugYcLL24yLTO2g10MLBr9
         /8XPBc03nJ77GXeArveLpV9F2rnzeF1Y9JQgOeek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.1 00/28] 6.1.10-rc1 review
Date:   Fri,  3 Feb 2023 11:12:48 +0100
Message-Id: <20230203101009.946745030@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.10-rc1
X-KernelTest-Deadline: 2023-02-05T10:10+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.1.10 release.
There are 28 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.10-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.10-rc1

Jeremy Kerr <jk@codeconstruct.com.au>
    net: mctp: purge receive queues on sk destruction

Miguel Ojeda <ojeda@kernel.org>
    rust: print: avoid evaluating arguments in `pr_*` macros in `unsafe` blocks

Yan Zhai <yan@cloudflare.com>
    net: fix NULL pointer in skb_segment_list

Mario Limonciello <mario.limonciello@amd.com>
    gpiolib-acpi: Don't set GPIOs for wakeup in S3 mode

Mario Limonciello <mario.limonciello@amd.com>
    gpiolib: acpi: Add a ignore wakeup quirk for Clevo NL5xRU

Janne Grunau <j@jannau.net>
    nvme-apple: only reset the controller when RTKit is running

Paulo Alcantara <pc@cjr.nz>
    cifs: fix return of uninitialized rc in dfs_cache_update_tgthint()

Mario Limonciello <mario.limonciello@amd.com>
    gpiolib: acpi: Allow ignoring wake capability on pins that aren't in _AEI

Hui Wang <hui.wang@canonical.com>
    dmaengine: imx-sdma: Fix a possible memory leak in sdma_transfer_init

Roderick Colenbrander <roderick@gaikai.com>
    HID: playstation: sanity check DualSense calibration data.

José Expósito <jose.exposito89@gmail.com>
    HID: uclogic: Add support for XP-PEN Deco 01 V2

Heiko Carstens <hca@linux.ibm.com>
    s390: workaround invalid gcc-11 out of bounds read warning

Pavel Begunkov <asml.silence@gmail.com>
    block: fix hctx checks for batch allocation

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Add backlight=native DMI quirk for Acer Aspire 4810T

Jinyang He <hejinyang@loongson.cn>
    LoongArch: Get frame info in unwind_start() when regs is not available

Yu Kuai <yukuai3@huawei.com>
    blk-cgroup: fix missing pd_online_fn() while activating policy

Jingbo Xu <jefflexu@linux.alibaba.com>
    erofs: clean up parsing of fscache related options

Mark Brown <broonie@kernel.org>
    kselftest: Fix error message for unconfigured LLVM builds

Arnd Bergmann <arnd@arndb.de>
    ARM: omap1: fix building gpio15xx

Dominik Kobinski <dominikkobinski314@gmail.com>
    arm64: dts: msm8994-angler: fix the memory map

Sriram R <quic_srirrama@quicinc.com>
    mac80211: Fix MLO address translation for multiple bss case

Siddh Raman Pant <code@siddh.me>
    erofs/zmap.c: Fix incorrect offset calculation

Hao Sun <sunhao.th@gmail.com>
    bpf: Skip task with pid=1 in send_signal_common()

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Clear stale xfer->hdr.status

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: imx8mq-thor96: fix no-mmc property for SDHCI

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: freescale: Fix pca954x i2c-mux node names

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: vf610: Fix pca9548 i2c-mux node names

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: imx: Fix pca9547 i2c-mux node name


-------------

Diffstat:

 Makefile                                           |  4 +--
 arch/arm/boot/dts/imx53-ppd.dts                    |  2 +-
 arch/arm/boot/dts/vf610-zii-dev-rev-b.dts          |  2 +-
 arch/arm/boot/dts/vf610-zii-dev-rev-c.dts          |  2 +-
 arch/arm/mach-omap1/gpio15xx.c                     |  1 +
 arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts  |  2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts  |  2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts  |  2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts  |  2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts  |  2 +-
 .../arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts |  2 +-
 arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi |  2 +-
 arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi |  2 +-
 .../arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi |  2 +-
 .../boot/dts/freescale/imx8mm-nitrogen-r2.dts      |  2 +-
 arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts  |  4 +--
 arch/arm64/boot/dts/freescale/imx8mq-thor96.dts    |  4 +--
 arch/arm64/boot/dts/freescale/imx8qxp-mek.dts      |  2 +-
 .../dts/qcom/msm8994-huawei-angler-rev-101.dts     | 19 +++++++++++--
 arch/loongarch/kernel/process.c                    | 12 ++------
 arch/loongarch/kernel/unwind_guess.c               |  6 ++++
 arch/loongarch/kernel/unwind_prologue.c            | 16 +++++++++--
 arch/s390/kernel/setup.c                           |  5 ++--
 block/blk-cgroup.c                                 |  4 +++
 block/blk-mq.c                                     |  6 +++-
 drivers/acpi/video_detect.c                        |  8 ++++++
 drivers/dma/imx-sdma.c                             |  4 ++-
 drivers/firmware/arm_scmi/driver.c                 |  2 ++
 drivers/gpio/gpiolib-acpi.c                        | 20 ++++++++++++--
 drivers/hid/hid-ids.h                              |  1 +
 drivers/hid/hid-playstation.c                      | 32 ++++++++++++++++++++++
 drivers/hid/hid-uclogic-core.c                     |  2 ++
 drivers/hid/hid-uclogic-params.c                   |  2 ++
 drivers/nvme/host/apple.c                          |  6 ++--
 fs/cifs/dfs_cache.c                                |  6 ++--
 fs/erofs/super.c                                   | 13 ++++-----
 fs/erofs/zmap.c                                    | 10 +++++--
 kernel/trace/bpf_trace.c                           |  3 ++
 net/core/skbuff.c                                  |  5 ++--
 net/mac80211/rx.c                                  |  3 ++
 net/mctp/af_mctp.c                                 |  6 ++++
 rust/kernel/print.rs                               | 29 ++++++++++++--------
 tools/testing/selftests/lib.mk                     |  2 +-
 43 files changed, 190 insertions(+), 73 deletions(-)


