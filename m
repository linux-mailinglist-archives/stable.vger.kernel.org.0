Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2332B4DC6EC
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbiCQM44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234387AbiCQM4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:56:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085BEE9948;
        Thu, 17 Mar 2022 05:54:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D5FF60F1B;
        Thu, 17 Mar 2022 12:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5FCC340E9;
        Thu, 17 Mar 2022 12:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521660;
        bh=Oiwz1Z86UsbOiF/D/+uZsqFlOG7gt+YtJPBjmB8q8KM=;
        h=From:To:Cc:Subject:Date:From;
        b=NBYwLnP8k7chZmwJ7Xz9+Z5MIr9RC1IvS7xIaqHnaouepDvgGMBAt5pC5pt1qpn04
         VgG0/naTzcE4J4aBuJVLHyXqb/bttC8uBx1uVLzyS/WgRkfquj+/tI4p+1MLTxZ+6M
         6MahGgb5mbd41EWHWvuBY+QraFf1ErpK4y40+aMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.16 00/28] 5.16.16-rc1 review
Date:   Thu, 17 Mar 2022 13:45:51 +0100
Message-Id: <20220317124526.768423926@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.16-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.16.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.16.16-rc1
X-KernelTest-Deadline: 2022-03-19T12:45+00:00
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

This is the start of the stable review cycle for the 5.16.16 release.
There are 28 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.16-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.16.16-rc1

Ivan Vecera <ivecera@redhat.com>
    ice: Fix race condition during interface enslave

Chengming Zhou <zhouchengming@bytedance.com>
    kselftest/vm: fix tests build with old libc

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    bnx2: Fix an error message

Niels Dossche <dossche.niels@gmail.com>
    sfc: extend the locking on mcdi->seqno

Eric Dumazet <edumazet@google.com>
    tcp: make tcp_read_sock() more robust

Sreeramya Soratkal <quic_ssramya@quicinc.com>
    nl80211: Update bss channel on channel switch for P2P_CLIENT

Manasi Navare <manasi.d.navare@intel.com>
    drm/vrr: Set VRR capable prop only if it is attached to connector

Golan Ben Ami <golan.ben.ami@intel.com>
    iwlwifi: don't advertise TWT support

Hans de Goede <hdegoede@redhat.com>
    Input: goodix - workaround Cherry Trail devices with a bogus ACPI Interrupt() resource

Hans de Goede <hdegoede@redhat.com>
    Input: goodix - use the new soc_intel_is_byt() helper

Florian Westphal <fw@strlen.de>
    netfilter: egress: silence egress hook lockdep splats

Jia-Ju Bai <baijiaju1990@gmail.com>
    atm: firestream: check the return value of ioremap() in fs_init()

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    can: rcar_canfd: rcar_canfd_channel_probe(): register the CAN device when fully ready

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix leaking sent_cmd skb

Julian Braha <julianbraha@gmail.com>
    ARM: 9178/1: fix unmet dependency on BITREVERSE for HAVE_ARCH_BITREVERSE

Alexander Lobakin <alobakin@pm.me>
    MIPS: smp: fill in sibling and core maps earlier

Johannes Berg <johannes.berg@intel.com>
    mac80211: refuse aggregations sessions before authorized

Corentin Labbe <clabbe@baylibre.com>
    ARM: dts: rockchip: fix a typo on rk3288 crypto-controller

Sascha Hauer <s.hauer@pengutronix.de>
    ARM: dts: rockchip: reorder rk322x hmdi clocks

Dinh Nguyen <dinguyen@kernel.org>
    arm64: dts: agilex: use the compatible "intel,socfpga-agilex-hsotg"

Sascha Hauer <s.hauer@pengutronix.de>
    arm64: dts: rockchip: reorder rk3399 hdmi clocks

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    arm64: dts: rockchip: align pl330 node name with dtschema

Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
    arm64: dts: rockchip: fix rk3399-puma eMMC HS400 signal integrity

Yan Yan <evitayan@google.com>
    xfrm: Fix xfrm migrate issues when address family changes

Yan Yan <evitayan@google.com>
    xfrm: Check if_id in xfrm_migrate

Quentin Schulz <quentin.schulz@theobroma-systems.com>
    arm64: dts: rockchip: fix rk3399-puma-haikou USB OTG mode

Frank Wunderlich <frank-w@public-files.de>
    arm64: dts: rockchip: fix dma-controller node names on rk356x

Kai Lueke <kailueke@linux.microsoft.com>
    Revert "xfrm: state and policy should fail if XFRMA_IF_ID 0"


-------------

Diffstat:

 Makefile                                           |  4 +--
 arch/arm/boot/dts/rk322x.dtsi                      |  4 +--
 arch/arm/boot/dts/rk3288.dtsi                      |  2 +-
 arch/arm64/boot/dts/intel/socfpga_agilex.dtsi      |  4 +--
 arch/arm64/boot/dts/rockchip/px30.dtsi             |  2 +-
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |  2 +-
 .../arm64/boot/dts/rockchip/rk3399-puma-haikou.dts |  1 +
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      | 20 +++++++++++++
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |  6 ++--
 arch/arm64/boot/dts/rockchip/rk356x.dtsi           |  4 +--
 arch/mips/kernel/smp.c                             |  6 ++--
 drivers/atm/firestream.c                           |  2 ++
 drivers/gpu/drm/drm_connector.c                    |  3 ++
 drivers/input/touchscreen/goodix.c                 | 34 +++++++++++-----------
 drivers/net/can/rcar/rcar_canfd.c                  |  6 ++--
 drivers/net/ethernet/broadcom/bnx2.c               |  2 +-
 drivers/net/ethernet/intel/ice/ice.h               | 11 ++++++-
 drivers/net/ethernet/intel/ice/ice_main.c          | 12 +++++++-
 drivers/net/ethernet/sfc/mcdi.c                    |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  1 -
 include/linux/netfilter_netdev.h                   |  4 +++
 include/net/xfrm.h                                 |  5 ++--
 lib/Kconfig                                        |  1 -
 net/bluetooth/hci_core.c                           |  1 +
 net/ipv4/tcp.c                                     | 10 ++++---
 net/key/af_key.c                                   |  2 +-
 net/mac80211/agg-tx.c                              | 10 ++++++-
 net/wireless/nl80211.c                             |  3 +-
 net/xfrm/xfrm_policy.c                             | 14 +++++----
 net/xfrm/xfrm_state.c                              | 15 +++++++---
 net/xfrm/xfrm_user.c                               | 27 +++++------------
 tools/testing/selftests/vm/userfaultfd.c           |  1 +
 33 files changed, 141 insertions(+), 83 deletions(-)


