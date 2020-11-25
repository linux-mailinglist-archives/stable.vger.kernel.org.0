Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890022C48E1
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 21:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgKYUMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 15:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgKYUMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 15:12:52 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C443CC0613D4
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 12:12:51 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id k14so1173138wrn.1
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 12:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bd7TNLRL/BDcofDOp2zwuHONXhhKrPSzdPi97VTB628=;
        b=VyjQXeUDKjyEnnM1Mh+13AHZWixDUhlzBY6lHWkbHPMXguGL6kf4OYZTDRckt6QtUK
         qWv/ncpAFKCe7eP66N5TGlW5vju7zJkbigivGkdiwNaqeV/gopSST2JhPp9Y8JfOxvH/
         Lq1ZZRMmbTeVYZsKNPB8QFej5yV7pwko2IY+fvvntSHp3CGnAwcy29ytJoz6NvwEXp7K
         2N95BksHPnv4GrRGqwZRWAhuSo3aib/5lx8IIflUjcEjiiXV50aJ19AcXX3m1BkN+9rZ
         isCKFgUdS4jslXYziW5nvaGyFtXOV08AJsHi8tnRCr6o3VYh/GbJP25Ywzq8UavRgkLJ
         cDZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Bd7TNLRL/BDcofDOp2zwuHONXhhKrPSzdPi97VTB628=;
        b=DEZG1blfn8agEnCga6esJBfbNgkEXQINRc7orqQ5xByh3G0AFjrZTmMq6YGfgPBvwt
         E5Vdx/KPYrs6dZ1i7qTg3drvKm5X4gAmkT6fdRCHmNYNUXYdyHpe1oskGLlBkEkSZo6f
         xqte4vzh9B1jygI9Vt/+AlJiWYbeplQTCzlBC249X+6esFIU17ljzDUqFsrGOHKtkqoc
         8yAnK1MEDGp66FwbC43ot5fed6dOaZPp3ILM1HCg1Ak5JbAZRhWCsbEHjlhdUHc+uLxM
         CVpAVy9nwEtTG4Mw/cNWor0Yu4ZSRAze6+eFVY5eigU4reReKpRefJ3/2mVYWrEMdM7P
         YRGQ==
X-Gm-Message-State: AOAM532PcebtE7vgUH+/07hrDenFi7lBhJXKY7SFHN99kG4WVnRGeWr+
        cXMCF+Kwpyyzvz63OLb//0E=
X-Google-Smtp-Source: ABdhPJyeyZX1+zsB2AFTcN02MO1LwA3gafI1HtsOwl8uBa1dKJ9kCM0IVHqjmncx7OSnIHIfZcclRw==
X-Received: by 2002:a5d:530d:: with SMTP id e13mr6134329wrv.92.1606335170564;
        Wed, 25 Nov 2020 12:12:50 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id w1sm5436278wmi.24.2020.11.25.12.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 12:12:49 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable@vger.kernel.org
Cc:     Andrey Zhizhikin <andrey.z@gmail.com>,
        Leo Yan <leo.yan@linaro.org>, Thomas Backlund <tmb@mageia.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        Tor Jeremiassen <tor@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 2/2] perf cs-etm: Move definition of 'traceid_list' global variable from header file
Date:   Wed, 25 Nov 2020 21:12:15 +0100
Message-Id: <20201125201215.26455-2-carnil@debian.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201125201215.26455-1-carnil@debian.org>
References: <20201122134339.GA6071@leoy-ThinkPad-X240s>
 <20201125201215.26455-1-carnil@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

commit 168200b6d6ea0cb5765943ec5da5b8149701f36a upstream.

The variable 'traceid_list' is defined in the header file cs-etm.h,
if multiple C files include cs-etm.h the compiler might complaint for
multiple definition of 'traceid_list'.

To fix multiple definition error, move the definition of 'traceid_list'
into cs-etm.c.

Fixes: cd8bfd8c973e ("perf tools: Add processing of coresight metadata")
Reported-by: Thomas Backlund <tmb@mageia.org>
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Tested-by: Mike Leach <mike.leach@linaro.org>
Tested-by: Thomas Backlund <tmb@mageia.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: Tor Jeremiassen <tor@ti.com>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lore.kernel.org/lkml/20200505133642.4756-1-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
---
 tools/perf/util/cs-etm.c | 3 +++
 tools/perf/util/cs-etm.h | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 5cde3956e19a..3275b8dc9344 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -87,6 +87,9 @@ struct cs_etm_queue {
 	struct cs_etm_packet *packet;
 };
 
+/* RB tree for quick conversion between traceID and metadata pointers */
+static struct intlist *traceid_list;
+
 static int cs_etm__update_queues(struct cs_etm_auxtrace *etm);
 static int cs_etm__process_timeless_queues(struct cs_etm_auxtrace *etm,
 					   pid_t tid, u64 time_);
diff --git a/tools/perf/util/cs-etm.h b/tools/perf/util/cs-etm.h
index fb5fc6538b7f..97c3152f5bfd 100644
--- a/tools/perf/util/cs-etm.h
+++ b/tools/perf/util/cs-etm.h
@@ -53,9 +53,6 @@ enum {
 	CS_ETMV4_PRIV_MAX,
 };
 
-/* RB tree for quick conversion between traceID and metadata pointers */
-struct intlist *traceid_list;
-
 #define KiB(x) ((x) * 1024)
 #define MiB(x) ((x) * 1024 * 1024)
 
-- 
2.29.2

