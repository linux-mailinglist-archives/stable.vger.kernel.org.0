Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA754455D3F
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 15:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbhKROGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 09:06:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:38898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232086AbhKROGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 09:06:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBF5161AE2;
        Thu, 18 Nov 2021 14:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637244214;
        bh=5nYCugOfuqdSAX6c3I6kdxQPw1axUC4Jm2eU3GpSOyo=;
        h=From:To:Cc:Subject:Date:From;
        b=M1E2Y4M5PkJvbCfwMa4DA3AK0Thb1qslkI695wp8FwoM/0fKRnE68oeHwNh6U9kDy
         3bDbT//IMeaVLKALRwFUDsyPUvnUNFyPBDZSBS3quIqCFmeb7FtPIuf++hvUnOYZwf
         qeKDnUQ03IevnUNoCZfy6Tg38ou0jM6ADB+Io4Z4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.14.20
Date:   Thu, 18 Nov 2021 15:03:26 +0100
Message-Id: <1637244207253142@kroah.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.14.20 kernel.

All users of the 5.14 kernel series must upgrade.

The updated 5.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                |    2 
 arch/alpha/include/asm/processor.h      |    2 
 arch/alpha/kernel/process.c             |    5 +-
 arch/arc/include/asm/processor.h        |    2 
 arch/arc/kernel/stacktrace.c            |    4 -
 arch/arm/include/asm/processor.h        |    2 
 arch/arm/kernel/process.c               |    4 +
 arch/arm64/include/asm/processor.h      |    2 
 arch/arm64/kernel/process.c             |    4 +
 arch/csky/include/asm/processor.h       |    2 
 arch/csky/kernel/stacktrace.c           |    5 +-
 arch/h8300/include/asm/processor.h      |    2 
 arch/h8300/kernel/process.c             |    5 +-
 arch/hexagon/include/asm/processor.h    |    2 
 arch/hexagon/kernel/process.c           |    4 +
 arch/ia64/include/asm/processor.h       |    2 
 arch/ia64/kernel/process.c              |    5 +-
 arch/m68k/include/asm/processor.h       |    2 
 arch/m68k/kernel/process.c              |    4 +
 arch/microblaze/include/asm/processor.h |    2 
 arch/microblaze/kernel/process.c        |    2 
 arch/mips/include/asm/processor.h       |    2 
 arch/mips/kernel/process.c              |    8 ++-
 arch/nds32/include/asm/processor.h      |    2 
 arch/nds32/kernel/process.c             |    7 ++-
 arch/nios2/include/asm/processor.h      |    2 
 arch/nios2/kernel/process.c             |    5 +-
 arch/openrisc/include/asm/processor.h   |    2 
 arch/openrisc/kernel/process.c          |    2 
 arch/parisc/include/asm/processor.h     |    2 
 arch/parisc/kernel/process.c            |    5 +-
 arch/powerpc/include/asm/processor.h    |    2 
 arch/powerpc/kernel/process.c           |    9 ++--
 arch/riscv/include/asm/processor.h      |    2 
 arch/riscv/kernel/stacktrace.c          |   12 +++--
 arch/s390/include/asm/processor.h       |    2 
 arch/s390/kernel/process.c              |    4 -
 arch/sh/include/asm/processor_32.h      |    2 
 arch/sh/kernel/process_32.c             |    5 +-
 arch/sparc/include/asm/processor_32.h   |    2 
 arch/sparc/include/asm/processor_64.h   |    2 
 arch/sparc/kernel/process_32.c          |    5 +-
 arch/sparc/kernel/process_64.c          |    5 +-
 arch/um/include/asm/processor-generic.h |    2 
 arch/um/kernel/process.c                |    5 +-
 arch/x86/include/asm/processor.h        |    2 
 arch/x86/kernel/process.c               |   65 +++++++++++++++++++++++++-------
 arch/xtensa/include/asm/processor.h     |    2 
 arch/xtensa/kernel/process.c            |    5 +-
 include/linux/sched.h                   |    1 
 kernel/sched/core.c                     |   19 ---------
 51 files changed, 160 insertions(+), 94 deletions(-)

Greg Kroah-Hartman (4):
      Revert "x86: Fix __get_wchan() for !STACKTRACE"
      Revert "sched: Add wrapper for get_wchan() to keep task blocked"
      Revert "x86: Fix get_wchan() to support the ORC unwinder"
      Linux 5.14.20

