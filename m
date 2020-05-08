Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E343E1CAC1C
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbgEHMuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729818AbgEHMuG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:50:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10A8524953;
        Fri,  8 May 2020 12:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942205;
        bh=tDgb4ZhqgTRX4pFltIIphvpJ1LIqmMkqkCzl3AR9tCU=;
        h=From:To:Cc:Subject:Date:From;
        b=eHiGacgwJ7dRMKrYqc3egS+1xqGdBtKrQSE19AZt8YZ1TyBqPetDtF3XuXjgt+r7K
         r3U57g3P3u+lOjFTE4ozEOAebBIxdmEcJcNLL2ur2Mhnot/uTL3lVk04ce4nWnIaHc
         reXfRbxS8yImDdOCY9rOJvHQh4/6bnlXYv2ZKgZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/18] 4.9.223-rc1 review
Date:   Fri,  8 May 2020 14:35:03 +0200
Message-Id: <20200508123030.497793118@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.223-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.223-rc1
X-KernelTest-Deadline: 2020-05-10T12:30+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.223 release.
There are 18 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 10 May 2020 12:29:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.223-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.223-rc1

Thomas Pedersen <thomas@adapt-ip.com>
    mac80211: add ieee80211_is_any_nullfunc()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Match both PCI ID and SSID for driver blacklist

Jere Leppänen <jere.leppanen@nokia.com>
    sctp: Fix SHUTDOWN CTSN Ack in the peer restart case

Marcin Nowakowski <marcin.nowakowski@imgtec.com>
    MIPS: perf: Remove incorrect odd/even counter handling for I6400

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Fix backchannel allocation of extra rpcrdma_reps

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

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: protect updating server->dstaddr with a spinlock

Julien Beraud <julien.beraud@orolia.com>
    net: stmmac: Fix sub-second increment

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    wimax/i2400m: Fix potential urb refcnt leak

Sebastian Reichel <sebastian.reichel@collabora.com>
    ASoC: sgtl5000: Fix VAG power-on handling

Tyler Hicks <tyhicks@linux.microsoft.com>
    selftests/ipc: Fix test failure seen after initial test run

YueHaibing <yuehaibing@huawei.com>
    iio:ad7797: Use correct attribute_group

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/pci/of: Parse unassigned resources

Jia He <justin.he@arm.com>
    vhost: vsock: kick send_pkt worker once device is started


-------------

Diffstat:

 Makefile                                           |  4 +--
 arch/mips/kernel/perf_event_mipsxx.c               |  6 +++-
 arch/powerpc/kernel/pci_of_scan.c                  | 12 ++++++--
 drivers/iio/adc/ad7793.c                           |  2 +-
 drivers/net/dsa/b53/b53_common.c                   | 30 ++++++++++++++++---
 drivers/net/dsa/b53/b53_regs.h                     |  3 ++
 drivers/net/ethernet/broadcom/bcmsysport.c         |  3 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  | 12 +++++---
 drivers/net/wimax/i2400m/usb-fw.c                  |  1 +
 drivers/vhost/vsock.c                              |  5 ++++
 fs/cifs/connect.c                                  |  2 ++
 include/linux/ieee80211.h                          |  9 ++++++
 lib/mpi/longlong.h                                 | 34 +++++++++++-----------
 net/mac80211/mlme.c                                |  2 +-
 net/mac80211/rx.c                                  |  8 ++---
 net/mac80211/status.c                              |  5 ++--
 net/mac80211/tx.c                                  |  2 +-
 net/sctp/sm_make_chunk.c                           |  6 +++-
 net/sunrpc/xprtrdma/backchannel.c                  | 12 ++------
 net/sunrpc/xprtrdma/verbs.c                        | 34 +++++++++++++---------
 net/sunrpc/xprtrdma/xprt_rdma.h                    |  2 +-
 scripts/config                                     |  5 +++-
 sound/pci/hda/hda_intel.c                          |  9 +++---
 sound/soc/codecs/sgtl5000.c                        | 34 ++++++++++++++++++++++
 sound/soc/codecs/sgtl5000.h                        |  1 +
 tools/testing/selftests/ipc/msgque.c               |  2 +-
 27 files changed, 173 insertions(+), 75 deletions(-)


