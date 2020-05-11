Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59141CD87B
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 13:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgEKLcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 07:32:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbgEKLcg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 07:32:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAC4920708;
        Mon, 11 May 2020 11:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589196755;
        bh=75OoYtLf3T/QGuJVP+Wj2fyoO7CesZ+EQYNxXU4NA9M=;
        h=Subject:To:Cc:From:Date:From;
        b=U5IV3dHVc0ZwzIv1z+vs6wlj1gyB18R8cV40JFj51oMFNQrVAoiih5F8Jj2g849O2
         mat4eO+CmCZfibf95+06S1lh0KMBy/Zz7gmzm7mqOdUvdLwxIrUP01/my3+lOz9bs9
         EO1/LBTN81xvLCsTy5CeQww2o7II5cMnVbnCi3pA=
Subject: Linux 4.9.223
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Mon, 11 May 2020 13:32:29 +0200
Message-ID: <1589196749102201@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.223 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 -
 arch/mips/kernel/perf_event_mipsxx.c                  |    6 ++-
 arch/powerpc/kernel/pci_of_scan.c                     |   12 +++++-
 drivers/iio/adc/ad7793.c                              |    2 -
 drivers/net/dsa/b53/b53_common.c                      |   30 +++++++++++++--
 drivers/net/dsa/b53/b53_regs.h                        |    3 +
 drivers/net/ethernet/broadcom/bcmsysport.c            |    3 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c        |    3 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c |   12 ++++--
 drivers/net/wimax/i2400m/usb-fw.c                     |    1 
 drivers/vhost/vsock.c                                 |    5 ++
 fs/cifs/connect.c                                     |    2 +
 include/linux/ieee80211.h                             |    9 ++++
 lib/mpi/longlong.h                                    |   34 +++++++++---------
 net/mac80211/mlme.c                                   |    2 -
 net/mac80211/rx.c                                     |    8 +---
 net/mac80211/status.c                                 |    5 +-
 net/mac80211/tx.c                                     |    2 -
 net/sctp/sm_make_chunk.c                              |    6 ++-
 net/sunrpc/xprtrdma/backchannel.c                     |   12 +-----
 net/sunrpc/xprtrdma/verbs.c                           |   34 ++++++++++--------
 net/sunrpc/xprtrdma/xprt_rdma.h                       |    2 -
 scripts/config                                        |    5 ++
 sound/pci/hda/hda_intel.c                             |    9 ++--
 sound/soc/codecs/sgtl5000.c                           |   34 ++++++++++++++++++
 sound/soc/codecs/sgtl5000.h                           |    1 
 tools/testing/selftests/ipc/msgque.c                  |    2 -
 27 files changed, 172 insertions(+), 74 deletions(-)

Alexey Kardashevskiy (1):
      powerpc/pci/of: Parse unassigned resources

Chuck Lever (1):
      xprtrdma: Fix backchannel allocation of extra rpcrdma_reps

Doug Berger (2):
      net: bcmgenet: suppress warnings on failed Rx SKB allocations
      net: systemport: suppress warnings on failed Rx SKB allocations

Florian Fainelli (1):
      net: dsa: b53: Rework ARL bin logic

Greg Kroah-Hartman (1):
      Linux 4.9.223

Jere Leppänen (1):
      sctp: Fix SHUTDOWN CTSN Ack in the peer restart case

Jeremie Francois (on alpha) (1):
      scripts/config: allow colons in option strings for sed

Jia He (1):
      vhost: vsock: kick send_pkt worker once device is started

Julien Beraud (1):
      net: stmmac: Fix sub-second increment

Marcin Nowakowski (1):
      MIPS: perf: Remove incorrect odd/even counter handling for I6400

Nathan Chancellor (1):
      lib/mpi: Fix building for powerpc with clang

Ronnie Sahlberg (1):
      cifs: protect updating server->dstaddr with a spinlock

Sebastian Reichel (1):
      ASoC: sgtl5000: Fix VAG power-on handling

Takashi Iwai (1):
      ALSA: hda: Match both PCI ID and SSID for driver blacklist

Thomas Pedersen (1):
      mac80211: add ieee80211_is_any_nullfunc()

Tyler Hicks (1):
      selftests/ipc: Fix test failure seen after initial test run

Xiyu Yang (1):
      wimax/i2400m: Fix potential urb refcnt leak

YueHaibing (1):
      iio:ad7797: Use correct attribute_group

