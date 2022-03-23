Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB204E4E33
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 09:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242716AbiCWI3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 04:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242719AbiCWI27 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 04:28:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793F175C11;
        Wed, 23 Mar 2022 01:27:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D5ACB81E42;
        Wed, 23 Mar 2022 08:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CFBC340EE;
        Wed, 23 Mar 2022 08:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648024045;
        bh=raH6VpAxWGhMQevcE1EmPjYIBMozb/If+RHXqe5TDVA=;
        h=From:To:Cc:Subject:Date:From;
        b=yPHzy66mclngP7UE9TSbo9F2HWcNKeH9ZzQM89eHQCCj/UdINeH4BUEppdpHTwa7Y
         +exKghcFKMjIFcAvuHfsy9cAOwBSnPvsGjQKG3AqBrK1qI6RLccWtx1qvwf1opQ2GU
         wwYxBEy/Nsib5i3Mk4+kJ6tH1PA+zug1wB/4Vlxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.187
Date:   Wed, 23 Mar 2022 09:27:16 +0100
Message-Id: <164802403725159@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.187 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    2 
 arch/arm64/include/asm/vectors.h                     |    4 -
 drivers/atm/eni.c                                    |    2 
 drivers/crypto/qcom-rng.c                            |   17 +++--
 drivers/firmware/efi/apple-properties.c              |    2 
 drivers/firmware/efi/efi.c                           |    2 
 drivers/gpu/drm/panel/panel-simple.c                 |    2 
 drivers/input/tablet/aiptek.c                        |   10 +--
 drivers/net/hyperv/netvsc_drv.c                      |    3 +
 drivers/net/phy/marvell.c                            |    8 +-
 drivers/usb/class/usbtmc.c                           |   13 +++-
 drivers/usb/gadget/function/rndis.c                  |    1 
 drivers/usb/gadget/udc/core.c                        |    3 -
 fs/ocfs2/super.c                                     |   22 +++----
 include/linux/if_arp.h                               |    1 
 net/dsa/dsa2.c                                       |    1 
 net/packet/af_packet.c                               |   11 +++
 tools/perf/util/symbol.c                             |    2 
 tools/testing/selftests/bpf/prog_tests/timer_crash.c |   32 -----------
 tools/testing/selftests/bpf/progs/timer_crash.c      |   54 -------------------
 20 files changed, 64 insertions(+), 128 deletions(-)

Alan Stern (2):
      usb: gadget: Fix use-after-free bug by not setting udc->dev.driver
      usb: usbtmc: Fix bug in pipe direction for control transfers

Arnd Bergmann (1):
      arm64: fix clang warning about TRAMP_VALIAS

Brian Masney (1):
      crypto: qcom-rng - ensure buffer for generate is completely filled

Dan Carpenter (1):
      usb: gadget: rndis: prevent integer overflow in rndis_set_response()

Eric Dumazet (1):
      net/packet: fix slab-out-of-bounds access in packet_recvmsg()

Greg Kroah-Hartman (2):
      Revert "selftests/bpf: Add test for bpf_timer overwriting crash"
      Linux 5.4.187

Jiasheng Jiang (2):
      atm: eni: Add check for dma_map_single
      hv_netvsc: Add check for kvmalloc_array

Joseph Qi (1):
      ocfs2: fix crash when initialize filecheck kobj fails

Kurt Cancemi (1):
      net: phy: marvell: Fix invalid comparison in the resume and suspend functions

Marek Vasut (1):
      drm/panel: simple: Fix Innolux G070Y2-L01 BPP settings

Miaoqian Lin (1):
      net: dsa: Add missing of_node_put() in dsa_port_parse_of

Michael Petlan (1):
      perf symbols: Fix symbol size calculation condition

Nicolas Dichtel (1):
      net: handle ARPHRD_PIMREG in dev_is_mac_header_xmit()

Pavel Skripkin (1):
      Input: aiptek - properly check endpoint type

Randy Dunlap (1):
      efi: fix return value of __setup handlers

