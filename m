Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44D326A291B
	for <lists+stable@lfdr.de>; Sat, 25 Feb 2023 11:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjBYKqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 05:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBYKqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 05:46:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339FE14216;
        Sat, 25 Feb 2023 02:46:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9A82B80907;
        Sat, 25 Feb 2023 10:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15446C4339B;
        Sat, 25 Feb 2023 10:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677321988;
        bh=8TMBpxEJBw6b3+wMb+g1stVmLeFSJgXVmLGqshPHht0=;
        h=From:To:Cc:Subject:Date:From;
        b=EpvxFzuFs/j/Apsf5uBlDYaKWwBvtksda/BezxEd57pNiIZSp+ZySRK7MvHsDhNR/
         TtJECBOEY5aoVAvJtwz+NOjVVYgtqdvcnt3uZU0mF2UK55zM+w1MbLU923xRlsOhxI
         x7B3nmOW47WfifTqRsX4CkvVsCiF7kLmaqAOo8To=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.2.1
Date:   Sat, 25 Feb 2023 11:46:24 +0100
Message-Id: <16773219832135@kroah.com>
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

I'm announcing the release of the 6.2.1 kernel.

All users of the 6.2 kernel series must upgrade.

The updated 6.2.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.2.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 MAINTAINERS                                    |    2 
 Makefile                                       |    2 
 arch/x86/include/asm/text-patching.h           |   31 ++++++++++++
 arch/x86/kernel/alternative.c                  |   62 ++++++++++++++++++-------
 arch/x86/kernel/kprobes/core.c                 |   38 +++------------
 arch/x86/kernel/static_call.c                  |   50 ++++++++++++++++++--
 drivers/hid/hid-mcp2221.c                      |    3 +
 drivers/net/wireless/marvell/mwifiex/sdio.c    |    1 
 drivers/platform/x86/amd/pmf/Kconfig           |    1 
 drivers/platform/x86/nvidia-wmi-ec-backlight.c |    6 ++
 fs/ext4/sysfs.c                                |    7 ++
 include/linux/nospec.h                         |    4 +
 kernel/bpf/core.c                              |    3 -
 lib/usercopy.c                                 |    7 ++
 security/Kconfig.hardening                     |    3 +
 15 files changed, 166 insertions(+), 54 deletions(-)

Benjamin Tissoires (1):
      HID: mcp-2221: prevent UAF in delayed work

Dave Hansen (1):
      uaccess: Add speculation barrier to copy_from_user()

Eric Biggers (1):
      randstruct: disable Clang 15 support

Greg Kroah-Hartman (1):
      Linux 6.2.1

Hans de Goede (1):
      platform/x86: nvidia-wmi-ec-backlight: Add force module parameter

Kees Cook (1):
      ext4: Fix function prototype mismatch for ext4_feat_ktype

Linus Torvalds (1):
      bpf: add missing header file include

Lukas Wunner (1):
      wifi: mwifiex: Add missing compatible string for SD8787

Paul Moore (1):
      audit: update the mailing list in MAINTAINERS

Peter Zijlstra (3):
      x86/alternatives: Introduce int3_emulate_jcc()
      x86/alternatives: Teach text_poke_bp() to patch Jcc.d32 instructions
      x86/static_call: Add support for Jcc tail-calls

Shyam Sundar S K (1):
      platform/x86/amd/pmf: Add depends on CONFIG_POWER_SUPPLY

