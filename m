Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798EF37657C
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 14:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237071AbhEGMuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 08:50:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237068AbhEGMuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 May 2021 08:50:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D06B6143F;
        Fri,  7 May 2021 12:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620391757;
        bh=SoY6AMPFWW9wH8Y+E/2kVSrNsQNERQ76Um/dBHPGoOs=;
        h=From:To:Cc:Subject:Date:From;
        b=ZZThocKIbcW6qYlaYh/VwT7smWCQ0xAB8i/rr0jZEJ1lqkAqH59lYAfsUNyVJ6a7l
         wbSAEFYaEcXlJVLPaeWEInQ756n51SRiiBToIgGwW1wOAsXlm/bzLiO+I2E4wxxDoZ
         pNeNdmgTPqGJCpdjSsqJGYKYRc+Vie6CkdoFLji4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.12.2
Date:   Fri,  7 May 2021 14:49:09 +0200
Message-Id: <162039174226118@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.12.2 kernel.

All users of the 5.12 kernel series must upgrade.

The updated 5.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.12.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 -
 arch/mips/include/asm/vdso/gettimeofday.h |   26 +++++++++++++++++++----
 drivers/gpu/drm/i915/i915_drv.c           |   10 +++++++++
 drivers/net/usb/ax88179_178a.c            |    6 +++--
 drivers/platform/x86/thinkpad_acpi.c      |   31 ++++++++++++++++++++--------
 drivers/usb/core/quirks.c                 |    4 +++
 fs/overlayfs/namei.c                      |    1 
 fs/overlayfs/super.c                      |   12 ++++++----
 include/linux/bpf_verifier.h              |    5 ++--
 kernel/bpf/verifier.c                     |   33 ++++++++++++++++--------------
 kernel/events/core.c                      |   12 +++++-----
 net/netfilter/nf_conntrack_standalone.c   |   10 +--------
 net/qrtr/mhi.c                            |    8 ++++---
 sound/usb/endpoint.c                      |    8 +++----
 sound/usb/quirks-table.h                  |   10 +++++++++
 15 files changed, 118 insertions(+), 60 deletions(-)

Bjorn Andersson (1):
      net: qrtr: Avoid potential use after free in MHI send

Chris Chiu (1):
      USB: Add reset-resume quirk for WD19's Realtek Hub

Daniel Borkmann (2):
      bpf: Fix masking negation logic upon negative dst register
      bpf: Fix leakage of uninitialized bpf stack under speculation

Greg Kroah-Hartman (1):
      Linux 5.12.2

Imre Deak (1):
      drm/i915: Disable runtime power management during shutdown

Jonathon Reinhart (1):
      netfilter: conntrack: Make global sysctls readonly in non-init netns

Kai-Heng Feng (1):
      USB: Add LPM quirk for Lenovo ThinkPad USB-C Dock Gen2 Ethernet

Mark Pearson (1):
      platform/x86: thinkpad_acpi: Correct thermal sensor allocation

Mickaël Salaün (1):
      ovl: fix leaked dentry

Miklos Szeredi (1):
      ovl: allow upperdir inside lowerdir

Ondrej Mosnacek (1):
      perf/core: Fix unconditional security_locked_down() call

Phillip Potter (1):
      net: usb: ax88179_178a: initialize local variables before use

Romain Naour (1):
      mips: Do not include hi and lo in clobber list for R6

Takashi Iwai (2):
      ALSA: usb-audio: Add MIDI quirk for Vox ToneLab EX
      ALSA: usb-audio: Fix implicit sync clearance at stopping stream

