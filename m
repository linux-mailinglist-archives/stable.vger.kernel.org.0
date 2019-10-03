Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAB28CA970
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392656AbfJCQm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392653AbfJCQm2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:42:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5D832133F;
        Thu,  3 Oct 2019 16:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120947;
        bh=sQXkXt8R38QkmXVe1OI/saT7LbNFH+7CrxACz0uYLK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vybM9cV+TCJjGgqAZ3/QtxEf5rWMl+M+yF44UjW0KmAuJkyPXNNmRZ75YkRJyrToe
         VGbL4Pn7lU8QvzHybIBJ/26v+gUYwiYPdiPm9arL1V1Epemu4XYED35IsMSli7HsKT
         C4+jv9NsUV5sXaGNRiGAbOnB+Vm31b1mv6r3jVMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luke Mujica <lukemujica@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 096/344] perf tools: Fix paths in include statements
Date:   Thu,  3 Oct 2019 17:51:01 +0200
Message-Id: <20191003154549.653665913@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



