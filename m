Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E90D6BAB4E
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389752AbfIVThG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:37:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389692AbfIVSp4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:45:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0C17206C2;
        Sun, 22 Sep 2019 18:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177955;
        bh=sQXkXt8R38QkmXVe1OI/saT7LbNFH+7CrxACz0uYLK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXps/TLCkwZ8Dhj+QJUJCJTu/woYhd3hPfzhFl8NMDTm75gIILarzqB4cYTYlHohD
         zvvcIItfodRPOed4WquZTWcuL2YvuwqS23+JOzAquGeKHT1csflOrGob3hPHHMkxrJ
         4p+YD8XPf6btd8fxJ2Bk6emk+kFXQLm1Uncavkdo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luke Mujica <lukemujica@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 060/203] perf tools: Fix paths in include statements
Date:   Sun, 22 Sep 2019 14:41:26 -0400
Message-Id: <20190922184350.30563-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke Mujica <lukemujica@google.com>

[ Upstream commit 2b75863b0845764529e01014a5c90664d8044cbe ]

These paths point to the wrong location but still work because they get
picked up by a -I flag that happens to direct to the correct file. Fix
paths to lead to the actual file location without help from include
flags.

Signed-off-by: Luke Mujica <lukemujica@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/20190719202253.220261-1-lukemujica@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/util/kvm-stat.c | 4 ++--
 tools/perf/arch/x86/util/tsc.c      | 6 +++---
 tools/perf/ui/helpline.c            | 4 ++--
 tools/perf/ui/util.c                | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/arch/x86/util/kvm-stat.c b/tools/perf/arch/x86/util/kvm-stat.c
index 865a9762f22ef..3f84403c0983a 100644
--- a/tools/perf/arch/x86/util/kvm-stat.c
+++ b/tools/perf/arch/x86/util/kvm-stat.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <errno.h>
-#include "../../util/kvm-stat.h"
-#include "../../util/evsel.h"
+#include "../../../util/kvm-stat.h"
+#include "../../../util/evsel.h"
 #include <asm/svm.h>
 #include <asm/vmx.h>
 #include <asm/kvm.h>
diff --git a/tools/perf/arch/x86/util/tsc.c b/tools/perf/arch/x86/util/tsc.c
index 950539f9a4f77..b1eb963b4a6e1 100644
--- a/tools/perf/arch/x86/util/tsc.c
+++ b/tools/perf/arch/x86/util/tsc.c
@@ -5,10 +5,10 @@
 #include <linux/stddef.h>
 #include <linux/perf_event.h>
 
-#include "../../perf.h"
+#include "../../../perf.h"
 #include <linux/types.h>
-#include "../../util/debug.h"
-#include "../../util/tsc.h"
+#include "../../../util/debug.h"
+#include "../../../util/tsc.h"
 
 int perf_read_tsc_conversion(const struct perf_event_mmap_page *pc,
 			     struct perf_tsc_conversion *tc)
diff --git a/tools/perf/ui/helpline.c b/tools/perf/ui/helpline.c
index b3c421429ed44..54bcd08df87e3 100644
--- a/tools/perf/ui/helpline.c
+++ b/tools/perf/ui/helpline.c
@@ -3,10 +3,10 @@
 #include <stdlib.h>
 #include <string.h>
 
-#include "../debug.h"
+#include "../util/debug.h"
 #include "helpline.h"
 #include "ui.h"
-#include "../util.h"
+#include "../util/util.h"
 
 char ui_helpline__current[512];
 
diff --git a/tools/perf/ui/util.c b/tools/perf/ui/util.c
index 63bf06e80ab9d..9ed76e88a3e4c 100644
--- a/tools/perf/ui/util.c
+++ b/tools/perf/ui/util.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "util.h"
-#include "../debug.h"
+#include "../util/debug.h"
 
 
 /*
-- 
2.20.1

