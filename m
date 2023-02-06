Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86B068B65D
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 08:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjBFH1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 02:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjBFH1L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 02:27:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E941C7E3;
        Sun,  5 Feb 2023 23:27:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15F5860C88;
        Mon,  6 Feb 2023 07:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDA6C433EF;
        Mon,  6 Feb 2023 07:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675668423;
        bh=uLkbwd9zcgVXFfPTtLeX6YU/oPS7ZUOaZz4gCzYgu/0=;
        h=From:To:Cc:Subject:Date:From;
        b=KFyUzJkmhmOsChNIH77y30D5taHqmhR4xYcfbTPx8d/7s+dhSsgiZpWlShLaHmGBE
         vtKmN8fiu3QOiAB4EL5AwVI03u6iWf30GYrZ3j4oOR4/yFmOhphz3Bh3zgRayz4TNm
         rVu40sZUdMOVpSrqnKSv5+iBlR7JoUDo11GxKtrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.167
Date:   Mon,  6 Feb 2023 08:26:50 +0100
Message-Id: <167566841047145@kroah.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.167 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 +-
 arch/arm/boot/dts/imx53-ppd.dts                 |    2 +-
 arch/arm/boot/dts/vf610-zii-dev-rev-b.dts       |    2 +-
 arch/arm/boot/dts/vf610-zii-dev-rev-c.dts       |    2 +-
 arch/arm64/boot/dts/freescale/imx8mq-thor96.dts |    4 ++--
 block/blk-cgroup.c                              |    4 ++++
 drivers/acpi/processor_idle.c                   |   23 ++++++++++++++++++++---
 drivers/dma/imx-sdma.c                          |    4 +++-
 kernel/trace/bpf_trace.c                        |    3 +++
 net/bluetooth/hci_event.c                       |   13 +++++++++++++
 net/core/skbuff.c                               |    5 ++---
 11 files changed, 51 insertions(+), 13 deletions(-)

Dave Hansen (1):
      ACPI: processor idle: Practically limit "Dummy wait" workaround to old Intel systems

Geert Uytterhoeven (2):
      ARM: dts: imx: Fix pca9547 i2c-mux node name
      ARM: dts: vf610: Fix pca9548 i2c-mux node names

Greg Kroah-Hartman (1):
      Linux 5.10.167

Hao Sun (1):
      bpf: Skip task with pid=1 in send_signal_common()

Hui Wang (1):
      dmaengine: imx-sdma: Fix a possible memory leak in sdma_transfer_init

Krzysztof Kozlowski (1):
      arm64: dts: imx8mq-thor96: fix no-mmc property for SDHCI

Soenke Huster (1):
      Bluetooth: fix null ptr deref on hci_sync_conn_complete_evt

Yan Zhai (1):
      net: fix NULL pointer in skb_segment_list

Yu Kuai (1):
      blk-cgroup: fix missing pd_online_fn() while activating policy

