Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBB71CD8F7
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 13:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbgEKLxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 07:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729476AbgEKLxm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 07:53:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8575206F5;
        Mon, 11 May 2020 11:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589198021;
        bh=4XjnbiL37FKTcpfmTEhqXKH7HRBw1kzSdxnwPaTgXfM=;
        h=Subject:To:Cc:From:Date:From;
        b=1tJ0WQRRzR43i31letUnypvwd7/4HPa+VwArGc35p7eeT0YsFN9r+T4uNfqZuUPZL
         Z8w++irbUUHfTqYNe52x24IzzZOqZuw4Jd0HphODjbcXXX4GRpSkYC9Nurs+c8sdx4
         hqZ91gMi5wmIqk15S2hEzXVz3VbArHO2sygKIMqM=
Subject: Linux 4.19.122
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Mon, 11 May 2020 13:53:37 +0200
Message-ID: <1589198017118229@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.122 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 arch/hexagon/include/asm/io.h                         |   12 +---
 arch/hexagon/kernel/hexagon_ksyms.c                   |    2 
 arch/hexagon/mm/ioremap.c                             |    2 
 arch/powerpc/kernel/pci_of_scan.c                     |   12 +++-
 arch/s390/kernel/diag.c                               |    2 
 arch/s390/kernel/smp.c                                |    4 -
 arch/s390/kernel/trace.c                              |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c                |    3 -
 drivers/gpu/drm/amd/powerplay/hwmgr/processpptables.c |   26 +++++++++
 drivers/gpu/drm/drm_ioctl.c                           |    7 ++
 drivers/mfd/intel-lpss.c                              |    2 
 drivers/net/ethernet/broadcom/bcmsysport.c            |    3 -
 drivers/net/ethernet/broadcom/genet/bcmgenet.c        |    3 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c   |    9 ++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c |   12 ++--
 drivers/net/wimax/i2400m/usb-fw.c                     |    1 
 drivers/platform/x86/gpd-pocket-fan.c                 |    2 
 drivers/usb/dwc3/core.h                               |    4 +
 drivers/usb/dwc3/gadget.c                             |   52 ++++++++++++++----
 drivers/vhost/vsock.c                                 |    5 +
 fs/cifs/connect.c                                     |    2 
 include/linux/ieee80211.h                             |    9 +++
 include/linux/io.h                                    |    2 
 lib/devres.c                                          |   19 ++++++
 lib/mpi/longlong.h                                    |   34 +++++------
 net/core/netclassid_cgroup.c                          |    4 -
 net/mac80211/mlme.c                                   |    2 
 net/mac80211/rx.c                                     |    8 +-
 net/mac80211/status.c                                 |    5 -
 net/mac80211/tx.c                                     |    2 
 net/sctp/sm_make_chunk.c                              |    6 +-
 scripts/config                                        |    5 +
 sound/pci/hda/hda_intel.c                             |    9 +--
 sound/soc/codecs/hdac_hdmi.c                          |    6 +-
 sound/soc/codecs/sgtl5000.c                           |   34 +++++++++++
 sound/soc/codecs/sgtl5000.h                           |    1 
 sound/soc/sh/rcar/ssi.c                               |   11 +++
 sound/soc/sh/rcar/ssiu.c                              |    2 
 sound/soc/soc-topology.c                              |    4 +
 tools/testing/selftests/ipc/msgque.c                  |    2 
 41 files changed, 249 insertions(+), 85 deletions(-)

Aaron Ma (1):
      drm/amdgpu: Fix oops when pp_funcs is unset in ACPI event

Alexey Kardashevskiy (1):
      powerpc/pci/of: Parse unassigned resources

Amadeusz Sławiński (2):
      ASoC: topology: Check return value of pcm_new_ver
      ASoC: codecs: hdac_hdmi: Fix incorrect use of list_for_each_entry

Christoph Hellwig (1):
      hexagon: clean up ioremap

Daniel Vetter (1):
      drm/atomic: Take the atomic toys away from X

Doug Berger (2):
      net: bcmgenet: suppress warnings on failed Rx SKB allocations
      net: systemport: suppress warnings on failed Rx SKB allocations

Greg Kroah-Hartman (1):
      Linux 4.19.122

Hans de Goede (1):
      platform/x86: GPD pocket fan: Fix error message when temp-limits are out of range

Jere Leppänen (1):
      sctp: Fix SHUTDOWN CTSN Ack in the peer restart case

Jeremie Francois (on alpha) (1):
      scripts/config: allow colons in option strings for sed

Jia He (1):
      vhost: vsock: kick send_pkt worker once device is started

Jiri Slaby (1):
      cgroup, netclassid: remove double cond_resched

Julien Beraud (2):
      net: stmmac: fix enabling socfpga's ptp_ref_clock
      net: stmmac: Fix sub-second increment

Matthias Blankertz (4):
      ASoC: rsnd: Fix parent SSI start/stop in multi-SSI mode
      ASoC: rsnd: Fix HDMI channel mapping for multi-SSI mode
      ASoC: rsnd: Don't treat master SSI in multi SSI setup as parent
      ASoC: rsnd: Fix "status check failed" spam for multi-SSI

Nathan Chancellor (1):
      lib/mpi: Fix building for powerpc with clang

Nick Desaulniers (1):
      hexagon: define ioremap_uc

Philipp Rudo (1):
      s390/ftrace: fix potential crashes when switching tracers

Ronnie Sahlberg (1):
      cifs: protect updating server->dstaddr with a spinlock

Sandeep Raghuraman (1):
      drm/amdgpu: Correctly initialize thermal controller for GPUs with Powerplay table v0 (e.g Hawaii)

Sebastian Reichel (1):
      ASoC: sgtl5000: Fix VAG power-on handling

Takashi Iwai (1):
      ALSA: hda: Match both PCI ID and SSID for driver blacklist

Thinh Nguyen (1):
      usb: dwc3: gadget: Properly set maxpacket limit

Thomas Pedersen (1):
      mac80211: add ieee80211_is_any_nullfunc()

Tuowen Zhao (2):
      lib: devres: add a helper function for ioremap_uc
      mfd: intel-lpss: Use devm_ioremap_uc for MMIO

Tyler Hicks (1):
      selftests/ipc: Fix test failure seen after initial test run

Xiyu Yang (1):
      wimax/i2400m: Fix potential urb refcnt leak

