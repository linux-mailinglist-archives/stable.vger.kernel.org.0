Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454A84E281D
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348095AbiCUNxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 09:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbiCUNxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:53:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD27813CED6;
        Mon, 21 Mar 2022 06:51:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C1A6B81676;
        Mon, 21 Mar 2022 13:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F66C340E8;
        Mon, 21 Mar 2022 13:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647870712;
        bh=pPgQaOZzDcuntvZ1Zvvum1sIs0kBLStpXYMjOtcnB/U=;
        h=From:To:Cc:Subject:Date:From;
        b=aGXlZztHKdUBvPJ8JZXZz/MkmqDaMDLzD5t0EL/pZl2YQJDLT35z9Uyqn3+3iwhrI
         tbhmI5wCbDBRF8ipJUsE8ux9hsZTfFD/mAkm+f6C7ptUbigXw4j3QpMeKdb1NExUBC
         EqOIV/JUPWUs6IKxXekACDzC4OndVejdcyW/rUAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.9 00/16] 4.9.308-rc1 review
Date:   Mon, 21 Mar 2022 14:51:30 +0100
Message-Id: <20220321133216.648316863@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.308-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.308-rc1
X-KernelTest-Deadline: 2022-03-23T13:32+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.308 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.308-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.308-rc1

Pavel Skripkin <paskripkin@gmail.com>
    Input: aiptek - properly check endpoint type

Alan Stern <stern@rowland.harvard.edu>
    usb: gadget: Fix use-after-free bug by not setting udc->dev.driver

Dan Carpenter <dan.carpenter@oracle.com>
    usb: gadget: rndis: prevent integer overflow in rndis_set_response()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    atm: eni: Add check for dma_map_single

Eric Dumazet <edumazet@google.com>
    net/packet: fix slab-out-of-bounds access in packet_recvmsg()

Lucas Wei <lucaswei@google.com>
    fs: sysfs_emit: Remove PAGE_SIZE alignment check

Chengming Zhou <zhouchengming@bytedance.com>
    kselftest/vm: fix tests build with old libc

Niels Dossche <dossche.niels@gmail.com>
    sfc: extend the locking on mcdi->seqno

Eric Dumazet <edumazet@google.com>
    tcp: make tcp_read_sock() more robust

Sreeramya Soratkal <quic_ssramya@quicinc.com>
    nl80211: Update bss channel on channel switch for P2P_CLIENT

Jia-Ju Bai <baijiaju1990@gmail.com>
    atm: firestream: check the return value of ioremap() in fs_init()

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    can: rcar_canfd: rcar_canfd_channel_probe(): register the CAN device when fully ready

Julian Braha <julianbraha@gmail.com>
    ARM: 9178/1: fix unmet dependency on BITREVERSE for HAVE_ARCH_BITREVERSE

Alexander Lobakin <alobakin@pm.me>
    MIPS: smp: fill in sibling and core maps earlier

Corentin Labbe <clabbe@baylibre.com>
    ARM: dts: rockchip: fix a typo on rk3288 crypto-controller

Yan Yan <evitayan@google.com>
    xfrm: Fix xfrm migrate issues when address family changes


-------------

Diffstat:

 Makefile                                 |  4 ++--
 arch/arm/boot/dts/rk3288.dtsi            |  2 +-
 arch/mips/kernel/smp.c                   |  6 +++---
 drivers/atm/eni.c                        |  2 ++
 drivers/atm/firestream.c                 |  2 ++
 drivers/input/tablet/aiptek.c            | 10 ++++------
 drivers/net/can/rcar/rcar_canfd.c        |  6 +++---
 drivers/net/ethernet/sfc/mcdi.c          |  2 +-
 drivers/usb/gadget/function/rndis.c      |  1 +
 drivers/usb/gadget/udc/core.c            |  3 ---
 fs/sysfs/file.c                          |  3 +--
 lib/Kconfig                              |  1 -
 net/ipv4/tcp.c                           | 10 ++++++----
 net/packet/af_packet.c                   | 11 ++++++++++-
 net/wireless/nl80211.c                   |  3 ++-
 net/xfrm/xfrm_state.c                    |  8 +++++---
 tools/testing/selftests/vm/userfaultfd.c |  1 +
 17 files changed, 44 insertions(+), 31 deletions(-)


