Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDBD1CAC32
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgEHMu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729861AbgEHMu6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:50:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29A8624953;
        Fri,  8 May 2020 12:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942257;
        bh=M0MB1D8c9E4aDRoDDf4vYS0ucKOU3XJnBVKI6wSa2lA=;
        h=From:To:Cc:Subject:Date:From;
        b=KV0OpifUSjHx0zOEnt2SNRo8Nwlp6O9OZNJL5xhHbzBHxAn813iPqqCrg6qmPshs6
         4RXugLhgvHges4OWSBqLyJ1ud1MNehXEPQCuffL5mC6/uIJ7TFkSxy4FPcrAYpK0eY
         oYiCucW3+T/ItyHi03D4bkU5y9jIqomQSawKJwTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/22] 4.14.180-rc1 review
Date:   Fri,  8 May 2020 14:35:12 +0200
Message-Id: <20200508123033.915895060@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.180-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.180-rc1
X-KernelTest-Deadline: 2020-05-10T12:30+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.180 release.
There are 22 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 10 May 2020 12:29:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.180-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.180-rc1

Jiri Slaby <jslaby@suse.cz>
    cgroup, netclassid: remove double cond_resched

Thomas Pedersen <thomas@adapt-ip.com>
    mac80211: add ieee80211_is_any_nullfunc()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Match both PCI ID and SSID for driver blacklist

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Reverse the order of trace_types_lock and event_mutex

Jere Leppänen <jere.leppanen@nokia.com>
    sctp: Fix SHUTDOWN CTSN Ack in the peer restart case

Doug Berger <opendmb@gmail.com>
    net: systemport: suppress warnings on failed Rx SKB allocations

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: suppress warnings on failed Rx SKB allocations

Nathan Chancellor <natechancellor@gmail.com>
    lib/mpi: Fix building for powerpc with clang

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Rework ARL bin logic

Jeremie Francois (on alpha) <jeremie.francois@gmail.com>
    scripts/config: allow colons in option strings for sed

Philipp Rudo <prudo@linux.ibm.com>
    s390/ftrace: fix potential crashes when switching tracers

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: protect updating server->dstaddr with a spinlock

Julien Beraud <julien.beraud@orolia.com>
    net: stmmac: Fix sub-second increment

Julien Beraud <julien.beraud@orolia.com>
    net: stmmac: fix enabling socfpga's ptp_ref_clock

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    wimax/i2400m: Fix potential urb refcnt leak

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: codecs: hdac_hdmi: Fix incorrect use of list_for_each_entry

Matthias Blankertz <matthias.blankertz@cetitec.com>
    ASoC: rsnd: Fix HDMI channel mapping for multi-SSI mode

Sebastian Reichel <sebastian.reichel@collabora.com>
    ASoC: sgtl5000: Fix VAG power-on handling

Tyler Hicks <tyhicks@linux.microsoft.com>
    selftests/ipc: Fix test failure seen after initial test run

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Check return value of pcm_new_ver

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/pci/of: Parse unassigned resources

Jia He <justin.he@arm.com>
    vhost: vsock: kick send_pkt worker once device is started


-------------

Diffstat:

 Makefile                                           |  4 +--
 arch/powerpc/kernel/pci_of_scan.c                  | 12 ++++++--
 arch/s390/kernel/diag.c                            |  2 +-
 arch/s390/kernel/smp.c                             |  4 +--
 arch/s390/kernel/trace.c                           |  2 +-
 drivers/net/dsa/b53/b53_common.c                   | 30 ++++++++++++++++---
 drivers/net/dsa/b53/b53_regs.h                     |  3 ++
 drivers/net/ethernet/broadcom/bcmsysport.c         |  3 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  3 +-
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |  9 ++++--
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  | 12 +++++---
 drivers/net/wimax/i2400m/usb-fw.c                  |  1 +
 drivers/vhost/vsock.c                              |  5 ++++
 fs/cifs/connect.c                                  |  2 ++
 include/linux/ieee80211.h                          |  9 ++++++
 kernel/trace/trace.c                               |  5 ++++
 kernel/trace/trace_events.c                        | 31 ++++++++++----------
 lib/mpi/longlong.h                                 | 34 +++++++++++-----------
 net/core/netclassid_cgroup.c                       |  4 +--
 net/mac80211/mlme.c                                |  2 +-
 net/mac80211/rx.c                                  |  8 ++---
 net/mac80211/status.c                              |  5 ++--
 net/mac80211/tx.c                                  |  2 +-
 net/sctp/sm_make_chunk.c                           |  6 +++-
 scripts/config                                     |  5 +++-
 sound/pci/hda/hda_intel.c                          |  9 +++---
 sound/soc/codecs/hdac_hdmi.c                       |  6 ++--
 sound/soc/codecs/sgtl5000.c                        | 34 ++++++++++++++++++++++
 sound/soc/codecs/sgtl5000.h                        |  1 +
 sound/soc/sh/rcar/ssiu.c                           |  2 +-
 sound/soc/soc-topology.c                           |  4 ++-
 tools/testing/selftests/ipc/msgque.c               |  2 +-
 32 files changed, 182 insertions(+), 79 deletions(-)


