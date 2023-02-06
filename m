Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278B268B65E
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 08:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjBFH1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 02:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjBFH1L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 02:27:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28671B322;
        Sun,  5 Feb 2023 23:27:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DD3660C88;
        Mon,  6 Feb 2023 07:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5075CC433EF;
        Mon,  6 Feb 2023 07:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675668426;
        bh=arFHs64xQoZUYVSPOo93peI+BXA6GYe7jhfgPTtcPnY=;
        h=From:To:Cc:Subject:Date:From;
        b=gumx7bew80NZdqMl2oGU2Wz1rEwtf46CEvYC9q7rLPDqKAVkVGQ/ZxCbvMNwEfM/q
         XRel5AeHVq86soCCEOj1rXeuaEhUDJkvysvomXZOJVs6ZJ7s0kQMIpwy2NE+6qBJmS
         7pHiUg3YLnqKZBcsMs1IYDFmLRNGBFzmFKtDRh4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.92
Date:   Mon,  6 Feb 2023 08:26:55 +0100
Message-Id: <1675668416536@kroah.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.92 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    2 -
 arch/arm/boot/dts/imx53-ppd.dts                      |    2 -
 arch/arm/boot/dts/vf610-zii-dev-rev-b.dts            |    2 -
 arch/arm/boot/dts/vf610-zii-dev-rev-c.dts            |    2 -
 arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts    |    2 -
 arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts    |    2 -
 arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts    |    2 -
 arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts    |    2 -
 arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts    |    2 -
 arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts  |    2 -
 arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi   |    2 -
 arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi   |    2 -
 arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi  |    2 -
 arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts |    2 -
 arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts    |    4 +-
 arch/arm64/boot/dts/freescale/imx8mq-thor96.dts      |    4 +-
 arch/arm64/boot/dts/freescale/imx8qxp-mek.dts        |    2 -
 block/blk-cgroup.c                                   |    4 ++
 drivers/acpi/processor_idle.c                        |   23 +++++++++++--
 drivers/dma/imx-sdma.c                               |    4 +-
 drivers/extcon/extcon-usbc-tusb320.c                 |    2 -
 drivers/firmware/arm_scmi/driver.c                   |    2 +
 drivers/hid/hid-playstation.c                        |   32 +++++++++++++++++++
 fs/cifs/dfs_cache.c                                  |    6 +--
 fs/erofs/zmap.c                                      |   10 ++++-
 fs/ext4/resize.c                                     |    4 +-
 kernel/trace/bpf_trace.c                             |    3 +
 net/bluetooth/hci_event.c                            |   13 +++++++
 net/core/skbuff.c                                    |    5 +-
 net/mctp/af_mctp.c                                   |    6 +++
 tools/include/linux/kernel.h                         |    2 +
 tools/testing/selftests/kselftest.h                  |   19 +++++++++++
 tools/testing/selftests/kselftest_harness.h          |    2 +
 tools/testing/selftests/vm/mremap_test.c             |    1 
 tools/testing/selftests/vm/pkey-helpers.h            |    3 +
 tools/testing/selftests/vm/va_128TBswitch.c          |    2 -
 36 files changed, 143 insertions(+), 38 deletions(-)

Baokun Li (1):
      ext4: fix bad checksum after online resize

Cristian Marussi (1):
      firmware: arm_scmi: Clear stale xfer->hdr.status

Dave Hansen (1):
      ACPI: processor idle: Practically limit "Dummy wait" workaround to old Intel systems

Geert Uytterhoeven (3):
      ARM: dts: imx: Fix pca9547 i2c-mux node name
      ARM: dts: vf610: Fix pca9548 i2c-mux node names
      arm64: dts: freescale: Fix pca954x i2c-mux node names

Greg Kroah-Hartman (1):
      Linux 5.15.92

Hao Sun (1):
      bpf: Skip task with pid=1 in send_signal_common()

Hui Wang (1):
      dmaengine: imx-sdma: Fix a possible memory leak in sdma_transfer_init

Jeremy Kerr (1):
      net: mctp: purge receive queues on sk destruction

Krzysztof Kozlowski (1):
      arm64: dts: imx8mq-thor96: fix no-mmc property for SDHCI

Paulo Alcantara (1):
      cifs: fix return of uninitialized rc in dfs_cache_update_tgthint()

Reinette Chatre (1):
      selftests: Provide local define of __cpuid_count()

Roderick Colenbrander (1):
      HID: playstation: sanity check DualSense calibration data.

Rong Chen (1):
      extcon: usbc-tusb320: fix kernel-doc warning

Shuah Khan (2):
      tools: fix ARRAY_SIZE defines in tools and selftests hdrs
      selftests/vm: remove ARRAY_SIZE define from individual tests

Siddh Raman Pant (1):
      erofs/zmap.c: Fix incorrect offset calculation

Soenke Huster (1):
      Bluetooth: fix null ptr deref on hci_sync_conn_complete_evt

Yan Zhai (1):
      net: fix NULL pointer in skb_segment_list

Yu Kuai (1):
      blk-cgroup: fix missing pd_online_fn() while activating policy

