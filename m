Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F8666AA94
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjANJlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbjANJk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:40:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70EF769E;
        Sat, 14 Jan 2023 01:40:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73CEF60244;
        Sat, 14 Jan 2023 09:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79211C433D2;
        Sat, 14 Jan 2023 09:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673689244;
        bh=HBbExZy3k6FmIQVpJIT5WXHqmePeLufqRlPHAM6QN6M=;
        h=From:To:Cc:Subject:Date:From;
        b=xJglCCTLmk961WQxfPqBjDHfqz0M5MWI0XcjRjwyrs7nevojCmcmpWjb2bMktalyf
         kPJZ2xN74McTM1A03j83X0pksplmfX7Vgq0MvcRUtpLW32mAI5eQlSxCy/0Ev70/1x
         xVYiwltQbMYBy/4f4ZMQW/XzxpZKnOTJMO+NbS68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.1.6
Date:   Sat, 14 Jan 2023 10:40:30 +0100
Message-Id: <1673689231200135@kroah.com>
X-Mailer: git-send-email 2.39.0
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

I'm announcing the release of the 6.1.6 kernel.

All users of the 6.1 kernel series must upgrade.

The updated 6.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                     |    2 
 arch/parisc/include/uapi/asm/mman.h          |   29 ++---
 arch/parisc/kernel/sys_parisc.c              |   28 +++++
 arch/parisc/kernel/syscalls/syscall.tbl      |    2 
 arch/x86/kernel/fpu/core.c                   |   19 +--
 arch/x86/kernel/fpu/regset.c                 |    2 
 arch/x86/kernel/fpu/signal.c                 |    2 
 arch/x86/kernel/fpu/xstate.c                 |   52 +++++++++-
 arch/x86/kernel/fpu/xstate.h                 |    4 
 fs/nfsd/nfs4proc.c                           |    7 -
 fs/nfsd/nfs4xdr.c                            |    2 
 init/Kconfig                                 |    6 +
 net/sched/sch_api.c                          |    5 +
 net/sunrpc/auth_gss/svcauth_gss.c            |    4 
 net/sunrpc/svc.c                             |    6 -
 net/sunrpc/svc_xprt.c                        |    2 
 net/sunrpc/svcsock.c                         |    8 -
 net/sunrpc/xprtrdma/svc_rdma_transport.c     |    2 
 sound/core/control.c                         |   24 +++-
 sound/pci/hda/cs35l41_hda.c                  |   20 +++-
 sound/pci/hda/patch_hdmi.c                   |    1 
 sound/pci/hda/patch_realtek.c                |    2 
 tools/arch/parisc/include/uapi/asm/mman.h    |   12 +-
 tools/perf/bench/bench.h                     |   12 --
 tools/testing/selftests/vm/pkey-x86.h        |   12 ++
 tools/testing/selftests/vm/protection_keys.c |  131 ++++++++++++++++++++++++++-
 26 files changed, 308 insertions(+), 88 deletions(-)

Adrian Chan (1):
      ALSA: hda/hdmi: Add a HP device 0x8715 to force connect list

Chris Chiu (1):
      ALSA: hda - Enable headset mic on another Dell laptop with ALC3254

Chuck Lever (1):
      Revert "SUNRPC: Use RMW bitops in single-threaded hot paths"

Clement Lecigne (1):
      ALSA: pcm: Move rwsem lock inside snd_ctl_elem_read to prevent UAF

Frederick Lawler (1):
      net: sched: disallow noqueue for qdisc classes

Greg Kroah-Hartman (1):
      Linux 6.1.6

Helge Deller (1):
      parisc: Align parisc MADV_XXX constants with all other architectures

Jeremy Szu (1):
      ALSA: hda/realtek: fix mute/micmute LEDs don't work for a HP platform

Kyle Huey (6):
      x86/fpu: Take task_struct* in copy_sigframe_from_user_to_xstate()
      x86/fpu: Add a pkru argument to copy_uabi_from_kernel_to_xstate().
      x86/fpu: Add a pkru argument to copy_uabi_to_xstate()
      x86/fpu: Allow PKRU to be (once again) written by ptrace.
      x86/fpu: Emulate XRSTOR's behavior if the xfeatures PKRU bit is not set
      selftests/vm/pkeys: Add a regression test for setting PKRU through ptrace

Linus Torvalds (1):
      gcc: disable -Warray-bounds for gcc-11 too

Takashi Iwai (2):
      ALSA: hda: cs35l41: Don't return -EINVAL from system suspend/resume
      ALSA: hda: cs35l41: Check runtime suspend capability at runtime_idle

