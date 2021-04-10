Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCCA35AD08
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 13:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbhDJLv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 07:51:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231279AbhDJLv2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Apr 2021 07:51:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9455B6113A;
        Sat, 10 Apr 2021 11:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618055474;
        bh=OyGTiZLJ5gdOI3vpJosmYDxFjoYhLpee0Fe4dlECmpo=;
        h=From:To:Cc:Subject:Date:From;
        b=X67W8yYeiKZjSeaUoALtKUBjIGnCjGOKeXH2P6ib9ToX+DnI8xtrviZLdBx8+ax9A
         sUPW05JXtivKM9uOI7UKK++sXoFp2offKaiFj2oBbsgbnO8v5d53ehwsf3H8AUE7fG
         JMeFv+BglWO9J44qR+EN/wovcdh1S8unEWCPaP8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.111
Date:   Sat, 10 Apr 2021 13:51:10 +0200
Message-Id: <1618055471133153@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.111 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 +-
 arch/arm/boot/dts/am33xx.dtsi                     |    3 +++
 arch/ia64/kernel/err_inject.c                     |   22 +++++++++++-----------
 arch/ia64/kernel/mca.c                            |    2 +-
 arch/x86/Makefile                                 |    2 +-
 arch/x86/net/bpf_jit_comp.c                       |   15 ++++++++++++---
 arch/x86/net/bpf_jit_comp32.c                     |   11 ++++++++++-
 drivers/bus/ti-sysc.c                             |    4 +++-
 drivers/gpu/drm/msm/adreno/a5xx_power.c           |    2 +-
 drivers/gpu/drm/msm/msm_fence.c                   |    2 +-
 drivers/isdn/hardware/mISDN/mISDNipac.c           |    2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c         |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    5 +++--
 drivers/nvme/host/multipath.c                     |    2 +-
 drivers/platform/x86/intel-hid.c                  |    7 +++++++
 drivers/platform/x86/thinkpad_acpi.c              |    8 +++++++-
 drivers/target/target_core_pscsi.c                |    8 ++++++++
 fs/cifs/file.c                                    |    1 +
 fs/cifs/smb2misc.c                                |    4 ++--
 init/Kconfig                                      |    3 +--
 net/mac80211/main.c                               |   13 ++++++++++++-
 net/netfilter/nf_conntrack_proto_gre.c            |    3 ---
 22 files changed, 88 insertions(+), 35 deletions(-)

Alban Bedel (1):
      platform/x86: intel-hid: Support Lenovo ThinkPad X1 Tablet Gen 2

Arnd Bergmann (1):
      x86/build: Turn off -fcf-protection for realmode targets

Esteve Varela Colominas (1):
      platform/x86: thinkpad_acpi: Allow the FnLock LED to change state

Greg Kroah-Hartman (1):
      Linux 5.4.111

Heiko Carstens (1):
      init/Kconfig: make COMPILE_TEST depend on !S390

Karthikeyan Kathirvel (1):
      mac80211: choose first enabled channel for monitor

Konrad Dybcio (1):
      drm/msm/adreno: a5xx_power: Don't apply A540 lm_setup to other GPUs

Ludovic Senecaux (1):
      netfilter: conntrack: Fix gre tunneling over ipv6

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

Sagi Grimberg (1):
      nvme-mpath: replace direct_make_request with generic_make_request

Sergei Trofimovich (2):
      ia64: mca: allocate early mca with GFP_ATOMIC
      ia64: fix format strings for err_inject

Tariq Toukan (1):
      net/mlx5e: Enforce minimum value check for ICOSQ size

Tong Zhang (1):
      mISDN: fix crash in fritzpci

Tony Lindgren (1):
      bus: ti-sysc: Fix warning on unbind if reset is not deasserted

Vincent Whitchurch (1):
      cifs: Silently ignore unknown oplock break handle

Yonghong Song (1):
      bpf, x86: Use kvmalloc_array instead kmalloc_array in bpf_jit_comp

