Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6174DE803
	for <lists+stable@lfdr.de>; Sat, 19 Mar 2022 14:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240557AbiCSNFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Mar 2022 09:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235249AbiCSNFx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Mar 2022 09:05:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A4C25DAB5;
        Sat, 19 Mar 2022 06:04:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04DB4B80B96;
        Sat, 19 Mar 2022 13:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD2BC340EC;
        Sat, 19 Mar 2022 13:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647695068;
        bh=ajXshAsUOCtw4Xw27NMvc0imYmtLllvr+HTHAMcAioE=;
        h=From:To:Cc:Subject:Date:From;
        b=2dZPj3KWvf6rhtOnv2iAw/yCYIToWL3CX51Jd77RfkABtE5vINE9/y10wigiMPHO5
         11onPYaZQSHxg/iqdXiTMUKWbfrpBX/ZRL/2HAc8mwW0Or2+u4IvLKRalWAg5k/ytA
         n19iC1NCeyLOi4xugDx5eoHCK3j5RavJigBsOHME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.186
Date:   Sat, 19 Mar 2022 14:04:24 +0100
Message-Id: <1647695064125232@kroah.com>
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

I'm announcing the release of the 5.4.186 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arm/boot/dts/rk322x.dtsi                      |    4 
 arch/arm/boot/dts/rk3288.dtsi                      |    2 
 arch/arm/include/asm/kvm_host.h                    |    7 
 arch/arm/include/uapi/asm/kvm.h                    |    6 
 arch/arm64/Kconfig                                 |    9 
 arch/arm64/boot/dts/intel/socfpga_agilex.dtsi      |    4 
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      |    6 
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |    6 
 arch/arm64/include/asm/assembler.h                 |   33 +
 arch/arm64/include/asm/cpu.h                       |    1 
 arch/arm64/include/asm/cpucaps.h                   |    3 
 arch/arm64/include/asm/cpufeature.h                |   40 ++
 arch/arm64/include/asm/cputype.h                   |   16 
 arch/arm64/include/asm/fixmap.h                    |    6 
 arch/arm64/include/asm/kvm_host.h                  |    5 
 arch/arm64/include/asm/kvm_mmu.h                   |    6 
 arch/arm64/include/asm/mmu.h                       |    8 
 arch/arm64/include/asm/sections.h                  |    5 
 arch/arm64/include/asm/sysreg.h                    |   17 
 arch/arm64/include/asm/vectors.h                   |   73 +++
 arch/arm64/include/uapi/asm/kvm.h                  |    5 
 arch/arm64/kernel/cpu_errata.c                     |  385 ++++++++++++++++++++-
 arch/arm64/kernel/cpufeature.c                     |   21 +
 arch/arm64/kernel/cpuinfo.c                        |    1 
 arch/arm64/kernel/entry.S                          |  213 ++++++++---
 arch/arm64/kernel/vmlinux.lds.S                    |    2 
 arch/arm64/kvm/hyp/hyp-entry.S                     |   64 +++
 arch/arm64/kvm/hyp/switch.c                        |    8 
 arch/arm64/kvm/sys_regs.c                          |    2 
 arch/arm64/mm/mmu.c                                |   12 
 arch/mips/kernel/smp.c                             |    6 
 drivers/atm/firestream.c                           |    2 
 drivers/gpu/drm/drm_connector.c                    |    3 
 drivers/net/can/rcar/rcar_canfd.c                  |    6 
 drivers/net/ethernet/sfc/mcdi.c                    |    2 
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |    3 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |    1 
 include/linux/arm-smccc.h                          |    5 
 include/net/xfrm.h                                 |    5 
 lib/Kconfig                                        |    1 
 net/ipv4/tcp.c                                     |   10 
 net/key/af_key.c                                   |    2 
 net/mac80211/agg-tx.c                              |   10 
 net/sctp/sm_statefuns.c                            |   71 ++-
 net/wireless/nl80211.c                             |    3 
 net/xfrm/xfrm_policy.c                             |   14 
 net/xfrm/xfrm_state.c                              |   15 
 net/xfrm/xfrm_user.c                               |   27 -
 tools/testing/selftests/vm/userfaultfd.c           |    1 
 virt/kvm/arm/psci.c                                |   34 +
 51 files changed, 1035 insertions(+), 158 deletions(-)

Alexander Lobakin (1):
      MIPS: smp: fill in sibling and core maps earlier

Anshuman Khandual (1):
      arm64: Add Cortex-X2 CPU part definition

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
      Linux 5.4.186

Jakob Unterwurzacher (1):
      arm64: dts: rockchip: fix rk3399-puma eMMC HS400 signal integrity

James Morse (19):
      arm64: entry.S: Add ventry overflow sanity checks
      arm64: entry: Make the trampoline cleanup optional
      arm64: entry: Free up another register on kpti's tramp_exit path
      arm64: entry: Move the trampoline data page before the text page
      arm64: entry: Allow tramp_alias to access symbols after the 4K boundary
      arm64: entry: Don't assume tramp_vectors is the start of the vectors
      arm64: entry: Move trampoline macros out of ifdef'd section
      arm64: entry: Make the kpti trampoline's kpti sequence optional
      arm64: entry: Allow the trampoline text to occupy multiple pages
      arm64: entry: Add non-kpti __bp_harden_el1_vectors for mitigations
      arm64: entry: Add vectors that have the bhb mitigation sequences
      arm64: entry: Add macro for reading symbol addresses from the trampoline
      arm64: Add percpu vectors for EL1
      arm64: proton-pack: Report Spectre-BHB vulnerabilities as part of Spectre-v2
      KVM: arm64: Add templates for BHB mitigation sequences
      arm64: Mitigate spectre style branch history side channels
      KVM: arm64: Allow SMCCC_ARCH_WORKAROUND_3 to be discovered and migrated
      arm64: Use the clearbhb instruction in mitigations
      fixup for "arm64 entry: Add macro for reading symbol address from the trampoline"

Jia-Ju Bai (1):
      atm: firestream: check the return value of ioremap() in fs_init()

Joey Gouly (1):
      arm64: add ID_AA64ISAR2_EL1 sys register

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

Rob Herring (1):
      arm64: Add part number for Arm Cortex-A77

Sascha Hauer (2):
      arm64: dts: rockchip: reorder rk3399 hdmi clocks
      ARM: dts: rockchip: reorder rk322x hmdi clocks

Sreeramya Soratkal (1):
      nl80211: Update bss channel on channel switch for P2P_CLIENT

Suzuki K Poulose (1):
      arm64: Add Neoverse-N2, Cortex-A710 CPU part definition

Xin Long (1):
      sctp: fix the processing for INIT chunk

Yan Yan (2):
      xfrm: Check if_id in xfrm_migrate
      xfrm: Fix xfrm migrate issues when address family changes

