Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8DC235ACFD
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 13:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbhDJLgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 07:36:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234580AbhDJLgb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Apr 2021 07:36:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D58C6610F7;
        Sat, 10 Apr 2021 11:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618054577;
        bh=QgAw1K5Zk7Zwn1JwRsh64ThRFX1xUH+w0h8sYjqTMs0=;
        h=From:To:Cc:Subject:Date:From;
        b=I6kJXah9oo6XArEErvpwuxA8/b6PWj5HxFwAeksf2DeB7c+33NBJlz4FAtdj37orz
         kXus0Wx95AphFYoN8ddPmGhnPWSa5fZra/dg1oL71OWqQ2gE1Q6sscdrG03FKxz2CH
         r+tE5uBCtDiFpT/IMyuFmz2duRJN4MegTVlrkydM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.186
Date:   Sat, 10 Apr 2021 13:36:11 +0200
Message-Id: <16180545719084@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.186 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 +-
 arch/arm/boot/dts/am33xx.dtsi             |    3 +++
 arch/ia64/kernel/err_inject.c             |   22 +++++++++++-----------
 arch/ia64/kernel/mca.c                    |    2 +-
 arch/x86/Makefile                         |    2 +-
 arch/x86/net/bpf_jit_comp.c               |   11 ++++++++++-
 arch/x86/net/bpf_jit_comp32.c             |   11 ++++++++++-
 drivers/bus/ti-sysc.c                     |    4 +++-
 drivers/gpu/drm/msm/msm_fence.c           |    2 +-
 drivers/isdn/hardware/mISDN/mISDNipac.c   |    2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c |    2 +-
 drivers/platform/x86/intel-hid.c          |    7 +++++++
 drivers/platform/x86/thinkpad_acpi.c      |    8 +++++++-
 drivers/target/target_core_pscsi.c        |    8 ++++++++
 fs/cifs/file.c                            |    1 +
 fs/cifs/smb2misc.c                        |    4 ++--
 init/Kconfig                              |    3 +--
 net/mac80211/main.c                       |   13 ++++++++++++-
 18 files changed, 81 insertions(+), 26 deletions(-)

Alban Bedel (1):
      platform/x86: intel-hid: Support Lenovo ThinkPad X1 Tablet Gen 2

Arnd Bergmann (1):
      x86/build: Turn off -fcf-protection for realmode targets

Esteve Varela Colominas (1):
      platform/x86: thinkpad_acpi: Allow the FnLock LED to change state

Greg Kroah-Hartman (1):
      Linux 4.19.186

Heiko Carstens (1):
      init/Kconfig: make COMPILE_TEST depend on !S390

Karthikeyan Kathirvel (1):
      mac80211: choose first enabled channel for monitor

Mans Rullgard (1):
      ARM: dts: am33xx: add aliases for mmc interfaces

Martin Wilck (1):
      scsi: target: pscsi: Clean up after failure in pscsi_map_sg()

Masahiro Yamada (1):
      init/Kconfig: make COMPILE_TEST depend on HAS_IOMEM

Pavel Andrianov (1):
      net: pxa168_eth: Fix a potential data race in pxa168_eth_remove

Piotr Krysiuk (2):
      bpf, x86: Validate computation of branch displacements for x86-64
      bpf, x86: Validate computation of branch displacements for x86-32

Rob Clark (1):
      drm/msm: Ratelimit invalid-fence message

Ronnie Sahlberg (1):
      cifs: revalidate mapping when we open files for SMB1 POSIX

Sergei Trofimovich (2):
      ia64: mca: allocate early mca with GFP_ATOMIC
      ia64: fix format strings for err_inject

Tong Zhang (1):
      mISDN: fix crash in fritzpci

Tony Lindgren (1):
      bus: ti-sysc: Fix warning on unbind if reset is not deasserted

Vincent Whitchurch (1):
      cifs: Silently ignore unknown oplock break handle

