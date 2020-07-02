Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8E521238B
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 14:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbgGBMli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 08:41:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728893AbgGBMlh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 08:41:37 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4AF020885;
        Thu,  2 Jul 2020 12:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593693697;
        bh=lDOGQAowU/l/wTAh+KcXplccev7uS9fXUjTT1Xhovrw=;
        h=From:To:Cc:Subject:Date:From;
        b=VhZU5sgc8kugcXWjTJ3I2D13FfR1ovD2YijZMAgUt5dmfqJrEp1Yifm3BQos/WMGn
         8PfWth/zGA5x8SfC+NGGc7scTPLaO+oexM37U5V1cJGiUyVXEtMu9vSJACSS70axSO
         R/but8xOg4w91LT0B23OrmJipi3Ff8j7WTAQsSFw=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     stable@vger.kernel.org
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Changbin Du <changbin.du@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        mhiramat@kernel.org
Subject: [PATCH for 4.4.y 0/5] tools/perf: Backport fixes for 4.4 for newer toolchain
Date:   Thu,  2 Jul 2020 21:41:32 +0900
Message-Id: <159369369207.82195.5763005209795799082.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Here is a series of patches for 4.4.y to build perf-tools on
newer toolchain. This also includes a perf-probe fix.

Thank you,

---

Arnaldo Carvalho de Melo (1):
      perf annotate: Use asprintf when formatting objdump command line

Changbin Du (1):
      perf: Make perf able to build with latest libbfd

Jiri Olsa (1):
      perf tools: Fix snprint warnings for gcc 8

Masami Hiramatsu (1):
      perf probe: Fix to check blacklist address correctly

Sergey Senozhatsky (1):
      tools/lib/subcmd/pager.c: do not alias select() params


 tools/perf/builtin-script.c    |   24 ++++++++++++------------
 tools/perf/tests/attr.c        |    4 ++--
 tools/perf/tests/pmu.c         |    2 +-
 tools/perf/util/annotate.c     |   14 +++++++++++---
 tools/perf/util/cgroup.c       |    2 +-
 tools/perf/util/pager.c        |    5 ++++-
 tools/perf/util/parse-events.c |    4 ++--
 tools/perf/util/pmu.c          |    2 +-
 tools/perf/util/probe-event.c  |   21 +++++++++++++++------
 tools/perf/util/srcline.c      |   16 +++++++++++++++-
 10 files changed, 64 insertions(+), 30 deletions(-)

--
Masami Hiramatsu (Linaro) <mhiramat@kernel.org>
