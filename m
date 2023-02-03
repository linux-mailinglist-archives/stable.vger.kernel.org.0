Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15D86895CD
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbjBCKXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233428AbjBCKX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:23:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ACA61E1F3;
        Fri,  3 Feb 2023 02:23:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0060D61E93;
        Fri,  3 Feb 2023 10:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77498C433D2;
        Fri,  3 Feb 2023 10:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419788;
        bh=vZz2fXuEaeQwNy1wZBxCZF+GAUxemlvH6I6lLPmPJ6I=;
        h=From:To:Cc:Subject:Date:From;
        b=XjMfxlEN7olZOODqYKZYGkZGPX5ZqAww4gmv2kMLUzXkbNLCHx/sp8qqH9XO8DAT3
         k+8bfAOgwKwdPDUaRZtntju2yOPvo6Cl8IaOqnugfCukleKyhaR6kn3Xh2ogA4oBsQ
         0HTDmDl6ymnddt/bK/oNi4yCAVM+FtA4kOcu5I80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.10 0/9] 5.10.167-rc1 review
Date:   Fri,  3 Feb 2023 11:13:29 +0100
Message-Id: <20230203101006.422534094@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.167-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.167-rc1
X-KernelTest-Deadline: 2023-02-05T10:10+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.167 release.
There are 9 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.167-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.167-rc1

Yan Zhai <yan@cloudflare.com>
    net: fix NULL pointer in skb_segment_list

Soenke Huster <soenke.huster@eknoes.de>
    Bluetooth: fix null ptr deref on hci_sync_conn_complete_evt

Dave Hansen <dave.hansen@intel.com>
    ACPI: processor idle: Practically limit "Dummy wait" workaround to old Intel systems

Hui Wang <hui.wang@canonical.com>
    dmaengine: imx-sdma: Fix a possible memory leak in sdma_transfer_init

Yu Kuai <yukuai3@huawei.com>
    blk-cgroup: fix missing pd_online_fn() while activating policy

Hao Sun <sunhao.th@gmail.com>
    bpf: Skip task with pid=1 in send_signal_common()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: imx8mq-thor96: fix no-mmc property for SDHCI

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: vf610: Fix pca9548 i2c-mux node names

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: imx: Fix pca9547 i2c-mux node name


-------------

Diffstat:

 Makefile                                        |  4 ++--
 arch/arm/boot/dts/imx53-ppd.dts                 |  2 +-
 arch/arm/boot/dts/vf610-zii-dev-rev-b.dts       |  2 +-
 arch/arm/boot/dts/vf610-zii-dev-rev-c.dts       |  2 +-
 arch/arm64/boot/dts/freescale/imx8mq-thor96.dts |  4 ++--
 block/blk-cgroup.c                              |  4 ++++
 drivers/acpi/processor_idle.c                   | 23 ++++++++++++++++++++---
 drivers/dma/imx-sdma.c                          |  4 +++-
 kernel/trace/bpf_trace.c                        |  3 +++
 net/bluetooth/hci_event.c                       | 13 +++++++++++++
 net/core/skbuff.c                               |  5 ++---
 11 files changed, 52 insertions(+), 14 deletions(-)


