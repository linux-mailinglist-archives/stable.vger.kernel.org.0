Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82BE689624
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbjBCK0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbjBCKYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:24:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E7F9D588;
        Fri,  3 Feb 2023 02:24:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC2C661ECA;
        Fri,  3 Feb 2023 10:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FADC433D2;
        Fri,  3 Feb 2023 10:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419852;
        bh=vtCxNCIxjYFkTjPajOZKVI3jVIF/uZSv6nommn41nak=;
        h=From:To:Cc:Subject:Date:From;
        b=H2rfDLbeKPsyBskzNIEfYtOnq3jpUI36SorS0TBZTfU8v9cJ0zeucsbm6Ez0IJZXf
         vAxSNycidWzjCHGXcDSF33jkjjtbWzQzq16SOhumKjVqlFBQ7DLfY4sJUPtWnUiYTK
         NNpTNyl+9/VSi7JEfkdUq1VGHdFBVnRbnZc16/Oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 00/20] 5.15.92-rc1 review
Date:   Fri,  3 Feb 2023 11:13:27 +0100
Message-Id: <20230203101007.985835823@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.92-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.92-rc1
X-KernelTest-Deadline: 2023-02-05T10:10+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.92 release.
There are 20 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.92-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.92-rc1

Jeremy Kerr <jk@codeconstruct.com.au>
    net: mctp: purge receive queues on sk destruction

Yan Zhai <yan@cloudflare.com>
    net: fix NULL pointer in skb_segment_list

Reinette Chatre <reinette.chatre@intel.com>
    selftests: Provide local define of __cpuid_count()

Shuah Khan <skhan@linuxfoundation.org>
    selftests/vm: remove ARRAY_SIZE define from individual tests

Shuah Khan <skhan@linuxfoundation.org>
    tools: fix ARRAY_SIZE defines in tools and selftests hdrs

Soenke Huster <soenke.huster@eknoes.de>
    Bluetooth: fix null ptr deref on hci_sync_conn_complete_evt

Dave Hansen <dave.hansen@intel.com>
    ACPI: processor idle: Practically limit "Dummy wait" workaround to old Intel systems

Rong Chen <rong.a.chen@intel.com>
    extcon: usbc-tusb320: fix kernel-doc warning

Baokun Li <libaokun1@huawei.com>
    ext4: fix bad checksum after online resize

Paulo Alcantara <pc@cjr.nz>
    cifs: fix return of uninitialized rc in dfs_cache_update_tgthint()

Hui Wang <hui.wang@canonical.com>
    dmaengine: imx-sdma: Fix a possible memory leak in sdma_transfer_init

Roderick Colenbrander <roderick@gaikai.com>
    HID: playstation: sanity check DualSense calibration data.

Yu Kuai <yukuai3@huawei.com>
    blk-cgroup: fix missing pd_online_fn() while activating policy

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
 block/blk-cgroup.c                                 |  4 +++
 drivers/acpi/processor_idle.c                      | 23 ++++++++++++++--
 drivers/dma/imx-sdma.c                             |  4 ++-
 drivers/extcon/extcon-usbc-tusb320.c               |  2 +-
 drivers/firmware/arm_scmi/driver.c                 |  2 ++
 drivers/hid/hid-playstation.c                      | 32 ++++++++++++++++++++++
 fs/cifs/dfs_cache.c                                |  6 ++--
 fs/erofs/zmap.c                                    | 10 +++++--
 fs/ext4/resize.c                                   |  4 +--
 kernel/trace/bpf_trace.c                           |  3 ++
 net/bluetooth/hci_event.c                          | 13 +++++++++
 net/core/skbuff.c                                  |  5 ++--
 net/mctp/af_mctp.c                                 |  6 ++++
 tools/include/linux/kernel.h                       |  2 ++
 tools/testing/selftests/kselftest.h                | 19 +++++++++++++
 tools/testing/selftests/kselftest_harness.h        |  2 ++
 tools/testing/selftests/vm/mremap_test.c           |  1 -
 tools/testing/selftests/vm/pkey-helpers.h          |  3 +-
 tools/testing/selftests/vm/va_128TBswitch.c        |  2 +-
 36 files changed, 144 insertions(+), 39 deletions(-)


