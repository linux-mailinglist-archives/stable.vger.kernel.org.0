Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8C46A2943
	for <lists+stable@lfdr.de>; Sat, 25 Feb 2023 12:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjBYLJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 06:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjBYLJO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 06:09:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4AA193C8;
        Sat, 25 Feb 2023 03:08:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E287F60AF8;
        Sat, 25 Feb 2023 11:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A2DC4339B;
        Sat, 25 Feb 2023 11:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677323334;
        bh=7JmKsDWXFcoeqpKGcgNazimnZSWlvyXkJ3Xh7pSbJao=;
        h=From:To:Cc:Subject:Date:From;
        b=G1ZeytexzC8LFPYMdxfe0oHT8ulH41gb3YgDCVA5UbBuCo9F2IzHCMQeIrOZ9zbSG
         BgIuQJglmAKPGVtyhn3ZL0gIg11MThp3SiTs0kMubtpvgPdR0+/Ec3HyNcXCgROJ2d
         en0lI8Qy/6vcc3pGMagPooICt5wene9BlU9qVV8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.233
Date:   Sat, 25 Feb 2023 12:08:42 +0100
Message-Id: <16773233222145@kroah.com>
X-Mailer: git-send-email 2.39.2
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

I'm announcing the release of the 5.4.233 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi    |   44 ++++++++
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi    |   44 ++++++++
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi           |   20 +++-
 arch/x86/kvm/vmx/nested.c                             |   11 ++
 arch/x86/kvm/vmx/vmx.c                                |    6 -
 arch/x86/kvm/x86.c                                    |    4 
 drivers/gpu/drm/etnaviv/etnaviv_gem.c                 |   12 +-
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c                 |   19 +--
 drivers/gpu/drm/i915/gvt/gtt.c                        |   17 ++-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c     |   33 ++++--
 drivers/net/wireless/marvell/mwifiex/sdio.c           |    1 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c |    8 -
 fs/ext4/sysfs.c                                       |    7 +
 include/linux/dma-mapping.h                           |   80 ++++++++++++++++
 include/linux/nospec.h                                |    4 
 include/linux/random.h                                |    6 -
 include/linux/scatterlist.h                           |   50 +++++++++-
 kernel/bpf/core.c                                     |    3 
 kernel/time/alarmtimer.c                              |   33 +++++-
 lib/usercopy.c                                        |    7 +
 net/mac80211/ieee80211_i.h                            |   24 ++++
 net/mac80211/mesh.h                                   |   22 ----
 net/mac80211/mesh_pathtbl.c                           |   89 ++++++------------
 net/sched/sch_taprio.c                                |    8 -
 25 files changed, 410 insertions(+), 144 deletions(-)

Bitterblue Smith (1):
      wifi: rtl8xxxu: gen2: Turn on the rate control

Dave Hansen (1):
      uaccess: Add speculation barrier to copy_from_user()

Greg Kroah-Hartman (1):
      Linux 5.4.233

Jason A. Donenfeld (1):
      random: always mix cycle counter in add_latent_entropy()

Jim Mattson (1):
      KVM: VMX: Execute IBPB on emulated VM-exit when guest has IBRS

Kees Cook (1):
      ext4: Fix function prototype mismatch for ext4_feat_ktype

Linus Torvalds (1):
      bpf: add missing header file include

Lucas Stach (1):
      drm/etnaviv: don't truncate physical page address

Lukas Wunner (1):
      wifi: mwifiex: Add missing compatible string for SD8787

Marc Kleine-Budde (1):
      can: kvaser_usb: hydra: help gcc-13 to figure out cmd_len

Marek Szyprowski (3):
      dma-mapping: add generic helpers for mapping sgtable objects
      scatterlist: add generic wrappers for iterating over sgtable objects
      drm: etnaviv: fix common struct sg_table related issues

Pavel Skripkin (1):
      mac80211: mesh: embedd mesh_paths and mpp_paths into ieee80211_if_mesh

Sean Anderson (2):
      powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G
      powerpc: dts: t208x: Disable 10G on MAC1 and MAC2

Sean Christopherson (1):
      KVM: x86: Fail emulation during EMULTYPE_SKIP on any exception

Thomas Gleixner (1):
      alarmtimer: Prevent starvation by small intervals and SIG_IGN

Vladimir Oltean (1):
      Revert "net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs"

Zheng Wang (1):
      drm/i915/gvt: fix double free bug in split_2MB_gtt_entry

