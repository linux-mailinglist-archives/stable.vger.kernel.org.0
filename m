Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E824DE805
	for <lists+stable@lfdr.de>; Sat, 19 Mar 2022 14:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242990AbiCSNGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Mar 2022 09:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242980AbiCSNGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Mar 2022 09:06:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3470925E307;
        Sat, 19 Mar 2022 06:04:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8F0660B2B;
        Sat, 19 Mar 2022 13:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FAEC340EC;
        Sat, 19 Mar 2022 13:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647695077;
        bh=Ha6ruJ9m6sGqV/dKpkgZMcTRo/DH+j7asqWKtyRIT38=;
        h=From:To:Cc:Subject:Date:From;
        b=LHD1+xWXhRjPFUsaK/n8M5IfD3js0gbGuLc5Pdq2yxYlH1W+VYfPMccNddiQSMkD8
         XE6aK8JApr8Wc5p8Z4A8p0h3qIYOSOCIL9oPeBDcBr/VYfxMLuqzhWoxgJ+3v5T0Cd
         FRwfSOf3ANyATHJph9ChL9FbCq3M/02QLvWReIco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.107
Date:   Sat, 19 Mar 2022 14:04:29 +0100
Message-Id: <1647695069241210@kroah.com>
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

I'm announcing the release of the 5.10.107 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arm/boot/dts/rk322x.dtsi                      |    4 -
 arch/arm/boot/dts/rk3288.dtsi                      |    2 
 arch/arm64/boot/dts/intel/socfpga_agilex.dtsi      |    4 -
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      |    6 +
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |    6 -
 arch/arm64/kvm/hyp/smccc_wa.S                      |    4 -
 arch/mips/kernel/smp.c                             |    6 -
 drivers/atm/firestream.c                           |    2 
 drivers/gpu/drm/drm_connector.c                    |    3 
 drivers/net/can/rcar/rcar_canfd.c                  |    6 -
 drivers/net/ethernet/sfc/mcdi.c                    |    2 
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |    3 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |    1 
 fs/io_uring.c                                      |   18 ++++-
 include/net/xfrm.h                                 |    5 -
 lib/Kconfig                                        |    1 
 net/ipv4/tcp.c                                     |   10 +-
 net/key/af_key.c                                   |    2 
 net/mac80211/agg-tx.c                              |   10 ++
 net/sctp/sm_statefuns.c                            |   71 +++++++++++++--------
 net/wireless/nl80211.c                             |    3 
 net/xfrm/xfrm_policy.c                             |   14 ++--
 net/xfrm/xfrm_state.c                              |   15 +++-
 net/xfrm/xfrm_user.c                               |   27 ++-----
 tools/testing/selftests/vm/userfaultfd.c           |    1 
 26 files changed, 139 insertions(+), 89 deletions(-)

Alexander Lobakin (1):
      MIPS: smp: fill in sibling and core maps earlier

Chengming Zhou (1):
      kselftest/vm: fix tests build with old libc

Corentin Labbe (1):
      ARM: dts: rockchip: fix a typo on rk3288 crypto-controller

Dinh Nguyen (1):
      arm64: dts: agilex: use the compatible "intel,socfpga-agilex-hsotg"

Eric Dumazet (1):
      tcp: make tcp_read_sock() more robust

Golan Ben Ami (1):
      iwlwifi: don't advertise TWT support

Greg Kroah-Hartman (1):
      Linux 5.10.107

Jakob Unterwurzacher (1):
      arm64: dts: rockchip: fix rk3399-puma eMMC HS400 signal integrity

James Morse (1):
      arm64: kvm: Fix copy-and-paste error in bhb templates for v5.10 stable

Jia-Ju Bai (1):
      atm: firestream: check the return value of ioremap() in fs_init()

Johannes Berg (1):
      mac80211: refuse aggregations sessions before authorized

Julian Braha (1):
      ARM: 9178/1: fix unmet dependency on BITREVERSE for HAVE_ARCH_BITREVERSE

Kai Lueke (1):
      Revert "xfrm: state and policy should fail if XFRMA_IF_ID 0"

Lad Prabhakar (1):
      can: rcar_canfd: rcar_canfd_channel_probe(): register the CAN device when fully ready

Manasi Navare (1):
      drm/vrr: Set VRR capable prop only if it is attached to connector

Niels Dossche (1):
      sfc: extend the locking on mcdi->seqno

Pavel Begunkov (1):
      io_uring: return back safer resurrect

Sascha Hauer (2):
      arm64: dts: rockchip: reorder rk3399 hdmi clocks
      ARM: dts: rockchip: reorder rk322x hmdi clocks

Sreeramya Soratkal (1):
      nl80211: Update bss channel on channel switch for P2P_CLIENT

Xin Long (1):
      sctp: fix the processing for INIT chunk

Yan Yan (2):
      xfrm: Check if_id in xfrm_migrate
      xfrm: Fix xfrm migrate issues when address family changes

