Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32BB3EC8C7
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 13:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237931AbhHOLlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 07:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238028AbhHOLlA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Aug 2021 07:41:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20DD261042;
        Sun, 15 Aug 2021 11:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629027630;
        bh=aA74iw1NV1m8x1a7OKWbSAfV1Qyv2iMHGUEX3sUosYQ=;
        h=From:To:Cc:Subject:Date:From;
        b=lFsU5qR4nk5uI4HVrV+4i/3LTEy4nn0g94iI6StvwHD4l8qhjHRl7ymALCGpOzgN0
         VM/PckzgRfdWRaCRRaWbn0BEqJql36mGOSXOcdgL1xhRxgelIz3AVN3xDEZ5aNdVpY
         PuqksudtkITXg4asenJQGO8QKs5kwucYj6dP7pK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.204
Date:   Sun, 15 Aug 2021 13:40:27 +0200
Message-Id: <16290276278105@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.204 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/virtual/kvm/mmu.txt             |    4 -
 Makefile                                      |    2 
 arch/x86/kvm/paging_tmpl.h                    |   14 +++--
 arch/x86/kvm/svm.c                            |    2 
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |    5 -
 drivers/net/ppp/ppp_generic.c                 |   19 +++++--
 drivers/usb/host/ehci-pci.c                   |    3 +
 fs/namespace.c                                |   42 ++++++++++------
 kernel/bpf/verifier.c                         |   68 ++++++++++++++++++++++----
 kernel/trace/trace_events_hist.c              |   14 +++++
 tools/testing/selftests/bpf/test_verifier.c   |    2 
 11 files changed, 137 insertions(+), 38 deletions(-)

Daniel Borkmann (4):
      bpf: Inherit expanded/patched seen count from old aux data
      bpf: Do not mark insn as seen under speculative path verification
      bpf: Fix leakage under speculation on mispredicted branches
      bpf, selftests: Adjust few selftest outcomes wrt unreachable code

Greg Kroah-Hartman (1):
      Linux 4.19.204

Lai Jiangshan (1):
      KVM: X86: MMU: Use the correct inherited permissions to get shadow page

Longfang Liu (1):
      USB:ehci:fix Kunpeng920 ehci hardware problem

Masami Hiramatsu (1):
      tracing: Reject string operand in the histogram expression

Miklos Szeredi (1):
      ovl: prevent private clone if bind mount is not allowed

Pali Rohár (1):
      ppp: Fix generating ppp unit id when ifname is not specified

Sean Christopherson (1):
      KVM: SVM: Fix off-by-one indexing when nullifying last used SEV VMCB

YueHaibing (1):
      net: xilinx_emaclite: Do not print real IOMEM pointer

