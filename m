Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CF520F776
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 16:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgF3Opf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 10:45:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgF3Opf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jun 2020 10:45:35 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44EF720663;
        Tue, 30 Jun 2020 14:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593528334;
        bh=zbsP9rS1uzBWcN+k9VTI1wOd8OrPWywy+CRsgj/n2Ko=;
        h=From:To:Cc:Subject:Date:From;
        b=rVN2mDhMqQF5Ur4AaOFL6aqpRMwL5T0FZgfvHe4pzqhqKoUteRca6riVYmY8ccxrc
         5HsyE7PKh4U3l66hKwIxRUa4dSUXz4jgQzO/vIIbA0l4p2GKp2k3GCUUYQQ3vVIJBw
         EA56A++nDYabWQ3dGjYUYb4wH0aZS4R+9vEjl4Io=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     stable@vger.kernel.org
Cc:     Changbin Du <changbin.du@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        mhiramat@kernel.org
Subject: [PATCH for 4.9 0/4] tools/perf: Backport fixes for 4.9 for newer toolchain
Date:   Tue, 30 Jun 2020 23:45:30 +0900
Message-Id: <159352833055.45385.11124685086393181445.stgit@devnote2>
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

While porting failed perf-probe fix to 4.9.y (*), I found the perf
command had build errors on Ubuntu 20.04. Fortunately all issues has
been fixed on the upstream. Thus I ported those patches too on 4.9.y.

(*) https://lore.kernel.org/stable/159257562524637@kroah.com/

I think perf tools in other stable branch also has similar issues.

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


 tools/perf/builtin-script.c    |   24 ++++++++++++------------
 tools/perf/tests/attr.c        |    4 ++--
 tools/perf/tests/pmu.c         |    2 +-
 tools/perf/util/annotate.c     |   17 ++++++++++++-----
 tools/perf/util/cgroup.c       |    2 +-
 tools/perf/util/parse-events.c |    4 ++--
 tools/perf/util/pmu.c          |    2 +-
 tools/perf/util/probe-event.c  |   21 +++++++++++++++------
 tools/perf/util/srcline.c      |   16 +++++++++++++++-
 9 files changed, 61 insertions(+), 31 deletions(-)

--
Masami Hiramatsu (Linaro) <mhiramat@kernel.org>
