Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1A23624E2
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 18:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238753AbhDPQAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 12:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238620AbhDPQAc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 12:00:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 286516137D;
        Fri, 16 Apr 2021 16:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618588807;
        bh=8MwsR3r0G8gU+SLOs1HEzMeA1n52GmyZuwKM4i1FRA0=;
        h=From:To:Cc:Subject:Date:From;
        b=GJ/UJuguv69nvHnU21QXtOlVGmNK5QJmyzP+moEle3fnHnjjVc2Zr8asTl4gm0rP5
         zK18XwMPg5SVmtziiu21N9j9RWddBdsdKGeAPuEYfRuErVNcMhoCQRGTZEnSGYJqq9
         en0XrLnaAawUwWT+gFREcS1T5/R4cAFNS6lCWp/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.113
Date:   Fri, 16 Apr 2021 18:00:03 +0200
Message-Id: <1618588804136248@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.113 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                              |    2 +-
 arch/arm64/include/asm/kvm_arm.h      |    1 +
 arch/arm64/kernel/cpufeature.c        |    1 -
 arch/arm64/kvm/debug.c                |    2 ++
 arch/riscv/kernel/entry.S             |    1 +
 block/bio.c                           |    2 +-
 drivers/base/dd.c                     |    8 +++++---
 drivers/gpu/drm/imx/imx-ldb.c         |   10 ++++++++++
 drivers/gpu/drm/tegra/dc.c            |   10 +++++-----
 drivers/interconnect/core.c           |    2 ++
 drivers/xen/events/events_base.c      |    4 ++--
 fs/block_dev.c                        |    4 ++++
 fs/gfs2/super.c                       |   10 ++++++----
 net/ipv4/netfilter/arp_tables.c       |    2 ++
 net/ipv4/netfilter/ip_tables.c        |    2 ++
 net/ipv6/netfilter/ip6_tables.c       |    2 ++
 net/netfilter/x_tables.c              |   10 ++--------
 tools/perf/util/expr.y                |    3 ++-
 tools/perf/util/map.c                 |    7 +++----
 tools/perf/util/parse-events.y        |    2 +-
 tools/perf/util/session.c             |    2 +-
 tools/perf/util/zstd.c                |    2 +-
 tools/testing/radix-tree/idr-test.c   |   10 ++++++++--
 tools/testing/radix-tree/multiorder.c |    2 ++
 tools/testing/radix-tree/xarray.c     |    2 ++
 25 files changed, 68 insertions(+), 35 deletions(-)

Arnaldo Carvalho de Melo (1):
      perf map: Tighten snprintf() string precision to pass gcc check on some 32-bit arches

Arnd Bergmann (1):
      drm/imx: imx-ldb: fix out of bounds array access warning

Bob Peterson (1):
      gfs2: report "already frozen/thawed" errors

Chris Wilson (1):
      perf tools: Use %zd for size_t printf formats on 32-bit

Dmitry Osipenko (1):
      drm/tegra: dc: Don't set PLL clock to 0Hz

Florian Westphal (1):
      netfilter: x_tables: fix compat match/target pad out-of-bound write

Greg Kroah-Hartman (1):
      Linux 5.4.113

Jia-Ju Bai (1):
      interconnect: core: fix error return code of icc_link_destroy()

Jiri Olsa (1):
      perf tools: Use %define api.pure full instead of %pure-parser

Juergen Gross (1):
      xen/events: fix setting irq affinity

Matthew Wilcox (Oracle) (3):
      radix tree test suite: Register the main thread with the RCU library
      idr test suite: Take RCU read lock in idr_find_test_1
      idr test suite: Create anchor before launching throbber

Pavel Begunkov (1):
      block: don't ignore REQ_NOWAIT for direct IO

Saravana Kannan (1):
      driver core: Fix locking bug in deferred_probe_timeout_work_func()

Suzuki K Poulose (2):
      KVM: arm64: Hide system instruction access to Trace registers
      KVM: arm64: Disable guest access to trace filter controls

Yufen Yu (1):
      block: only update parent bi_status when bio fail

Zihao Yu (1):
      riscv,entry: fix misaligned base for excp_vect_table

