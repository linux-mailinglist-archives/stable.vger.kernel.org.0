Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FD01CD8D8
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 13:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgEKLtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 07:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727873AbgEKLtQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 07:49:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6607220735;
        Mon, 11 May 2020 11:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589197755;
        bh=G+wgiTDTWIi7ajc/ou5pxD/+OW5419RPkT5HXf5jP1E=;
        h=Subject:To:Cc:From:Date:From;
        b=uIgnkHK7QEfRpRUp9N6JU3d9kzkiDu4R2cYoblec3iz6Xi2UFs44rq8CtXdnX84qy
         FAksoPJlvOcT500ydCuhrFFvT3QJH5EtL921aKBMHKZlmPcMp2rdtIkxVYM4mldJQD
         Ud6YfbKpjbu7vYsZ0LFA0peAX3E313w++xHcuNbE=
Subject: Linux 4.14.180
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Mon, 11 May 2020 13:49:09 +0200
Message-ID: <1589197749146101@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.180 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 -
 arch/powerpc/kernel/pci_of_scan.c                     |   12 +++++-
 arch/s390/kernel/diag.c                               |    2 -
 arch/s390/kernel/smp.c                                |    4 +-
 arch/s390/kernel/trace.c                              |    2 -
 drivers/net/dsa/b53/b53_common.c                      |   30 +++++++++++++--
 drivers/net/dsa/b53/b53_regs.h                        |    3 +
 drivers/net/ethernet/broadcom/bcmsysport.c            |    3 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c        |    3 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c   |    9 +++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c |   12 ++++--
 drivers/net/wimax/i2400m/usb-fw.c                     |    1 
 drivers/vhost/vsock.c                                 |    5 ++
 fs/cifs/connect.c                                     |    2 +
 include/linux/ieee80211.h                             |    9 ++++
 kernel/trace/trace.c                                  |    5 ++
 kernel/trace/trace_events.c                           |   31 +++++++---------
 lib/mpi/longlong.h                                    |   34 +++++++++---------
 net/core/netclassid_cgroup.c                          |    4 --
 net/mac80211/mlme.c                                   |    2 -
 net/mac80211/rx.c                                     |    8 +---
 net/mac80211/status.c                                 |    5 +-
 net/mac80211/tx.c                                     |    2 -
 net/sctp/sm_make_chunk.c                              |    6 ++-
 scripts/config                                        |    5 ++
 sound/pci/hda/hda_intel.c                             |    9 ++--
 sound/soc/codecs/hdac_hdmi.c                          |    6 +--
 sound/soc/codecs/sgtl5000.c                           |   34 ++++++++++++++++++
 sound/soc/codecs/sgtl5000.h                           |    1 
 sound/soc/sh/rcar/ssiu.c                              |    2 -
 sound/soc/soc-topology.c                              |    4 +-
 tools/testing/selftests/ipc/msgque.c                  |    2 -
 32 files changed, 181 insertions(+), 78 deletions(-)

Alexey Kardashevskiy (1):
      powerpc/pci/of: Parse unassigned resources

Amadeusz Sławiński (2):
      ASoC: topology: Check return value of pcm_new_ver
      ASoC: codecs: hdac_hdmi: Fix incorrect use of list_for_each_entry

Doug Berger (2):
      net: bcmgenet: suppress warnings on failed Rx SKB allocations
      net: systemport: suppress warnings on failed Rx SKB allocations

Florian Fainelli (1):
      net: dsa: b53: Rework ARL bin logic

Greg Kroah-Hartman (1):
      Linux 4.14.180

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

Matthias Blankertz (1):
      ASoC: rsnd: Fix HDMI channel mapping for multi-SSI mode

Nathan Chancellor (1):
      lib/mpi: Fix building for powerpc with clang

Philipp Rudo (1):
      s390/ftrace: fix potential crashes when switching tracers

Ronnie Sahlberg (1):
      cifs: protect updating server->dstaddr with a spinlock

Sebastian Reichel (1):
      ASoC: sgtl5000: Fix VAG power-on handling

Steven Rostedt (VMware) (1):
      tracing: Reverse the order of trace_types_lock and event_mutex

Takashi Iwai (1):
      ALSA: hda: Match both PCI ID and SSID for driver blacklist

Thomas Pedersen (1):
      mac80211: add ieee80211_is_any_nullfunc()

Tyler Hicks (1):
      selftests/ipc: Fix test failure seen after initial test run

Xiyu Yang (1):
      wimax/i2400m: Fix potential urb refcnt leak

