Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59F54DE80F
	for <lists+stable@lfdr.de>; Sat, 19 Mar 2022 14:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243021AbiCSNGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Mar 2022 09:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243031AbiCSNG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Mar 2022 09:06:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EF725F659;
        Sat, 19 Mar 2022 06:04:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2118860C69;
        Sat, 19 Mar 2022 13:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAB4C340EC;
        Sat, 19 Mar 2022 13:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647695095;
        bh=XLwieuXtimno3a6w/8/ef/UNCG9/Dkz3Zq1nJZ1Qkk0=;
        h=From:To:Cc:Subject:Date:From;
        b=IPCgIhZPMvMqPPBIYBdZ9DxzYP46Iq2ZxeteZMiJmMKlTpxJA44Y41IpZ0X57+JwH
         OtYhD3HjbqN/bY+8PkfI6uWKI2uC/zT0IDgZsmycz3wTx81/lYXQHg8aRb3VpY/qpF
         iw1t8AIbpN4GZ7iWL/IGLYDzhvyd45a7KMM0kfQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.16.16
Date:   Sat, 19 Mar 2022 14:04:39 +0100
Message-Id: <16476950798220@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.16.16 kernel.

All users of the 5.16 kernel series must upgrade.

The updated 5.16.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.16.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 -
 arch/arm/boot/dts/rk322x.dtsi                       |    4 +-
 arch/arm/boot/dts/rk3288.dtsi                       |    2 -
 arch/arm64/boot/dts/intel/socfpga_agilex.dtsi       |    4 +-
 arch/arm64/boot/dts/rockchip/px30.dtsi              |    2 -
 arch/arm64/boot/dts/rockchip/rk3328.dtsi            |    2 -
 arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts |    1 
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi       |   20 +++++++++++
 arch/arm64/boot/dts/rockchip/rk3399.dtsi            |    6 +--
 arch/arm64/boot/dts/rockchip/rk356x.dtsi            |    4 +-
 arch/mips/kernel/smp.c                              |    6 +--
 drivers/atm/firestream.c                            |    2 +
 drivers/gpu/drm/drm_connector.c                     |    3 +
 drivers/input/touchscreen/goodix.c                  |   34 ++++++++++----------
 drivers/net/can/rcar/rcar_canfd.c                   |    6 +--
 drivers/net/ethernet/broadcom/bnx2.c                |    2 -
 drivers/net/ethernet/intel/ice/ice.h                |   11 +++++-
 drivers/net/ethernet/intel/ice/ice_main.c           |   12 ++++++-
 drivers/net/ethernet/sfc/mcdi.c                     |    2 -
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c  |    3 -
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c   |    1 
 include/linux/netfilter_netdev.h                    |    4 ++
 include/net/xfrm.h                                  |    5 +-
 lib/Kconfig                                         |    1 
 net/bluetooth/hci_core.c                            |    1 
 net/ipv4/tcp.c                                      |   10 +++--
 net/key/af_key.c                                    |    2 -
 net/mac80211/agg-tx.c                               |   10 +++++
 net/wireless/nl80211.c                              |    3 +
 net/xfrm/xfrm_policy.c                              |   14 ++++----
 net/xfrm/xfrm_state.c                               |   15 ++++++--
 net/xfrm/xfrm_user.c                                |   27 ++++-----------
 tools/testing/selftests/vm/userfaultfd.c            |    1 
 33 files changed, 140 insertions(+), 82 deletions(-)

Alexander Lobakin (1):
      MIPS: smp: fill in sibling and core maps earlier

Chengming Zhou (1):
      kselftest/vm: fix tests build with old libc

Christophe JAILLET (1):
      bnx2: Fix an error message

Corentin Labbe (1):
      ARM: dts: rockchip: fix a typo on rk3288 crypto-controller

Dinh Nguyen (1):
      arm64: dts: agilex: use the compatible "intel,socfpga-agilex-hsotg"

Eric Dumazet (1):
      tcp: make tcp_read_sock() more robust

Florian Westphal (1):
      netfilter: egress: silence egress hook lockdep splats

Frank Wunderlich (1):
      arm64: dts: rockchip: fix dma-controller node names on rk356x

Golan Ben Ami (1):
      iwlwifi: don't advertise TWT support

Greg Kroah-Hartman (1):
      Linux 5.16.16

Hans de Goede (2):
      Input: goodix - use the new soc_intel_is_byt() helper
      Input: goodix - workaround Cherry Trail devices with a bogus ACPI Interrupt() resource

Ivan Vecera (1):
      ice: Fix race condition during interface enslave

Jakob Unterwurzacher (1):
      arm64: dts: rockchip: fix rk3399-puma eMMC HS400 signal integrity

Jia-Ju Bai (1):
      atm: firestream: check the return value of ioremap() in fs_init()

Johannes Berg (1):
      mac80211: refuse aggregations sessions before authorized

Julian Braha (1):
      ARM: 9178/1: fix unmet dependency on BITREVERSE for HAVE_ARCH_BITREVERSE

Kai Lueke (1):
      Revert "xfrm: state and policy should fail if XFRMA_IF_ID 0"

Krzysztof Kozlowski (1):
      arm64: dts: rockchip: align pl330 node name with dtschema

Lad Prabhakar (1):
      can: rcar_canfd: rcar_canfd_channel_probe(): register the CAN device when fully ready

Luiz Augusto von Dentz (1):
      Bluetooth: hci_core: Fix leaking sent_cmd skb

Manasi Navare (1):
      drm/vrr: Set VRR capable prop only if it is attached to connector

Niels Dossche (1):
      sfc: extend the locking on mcdi->seqno

Quentin Schulz (1):
      arm64: dts: rockchip: fix rk3399-puma-haikou USB OTG mode

Sascha Hauer (2):
      arm64: dts: rockchip: reorder rk3399 hdmi clocks
      ARM: dts: rockchip: reorder rk322x hmdi clocks

Sreeramya Soratkal (1):
      nl80211: Update bss channel on channel switch for P2P_CLIENT

Yan Yan (2):
      xfrm: Check if_id in xfrm_migrate
      xfrm: Fix xfrm migrate issues when address family changes

