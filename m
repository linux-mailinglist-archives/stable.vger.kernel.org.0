Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C91E51199E9
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfLJVJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:09:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:57284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728064AbfLJVJJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBB81246AA;
        Tue, 10 Dec 2019 21:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012149;
        bh=2mu7+3HFmFKeJlS5lR+uw4E75ZYbVPQWmMppHv/oUdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KS7VR9ki1z4O5RFrDFNgHHMg21UD0z28KjE0HBsYzsNCZqn0DFHudgkcCvxNJubCe
         iQa1ymPi2guKJcuMgWFVUc7jwT+dDw4jRL/NfbGa7HBDGh+QOUUzHRbgXb5hyfui57
         p65U76gAOTMkY/215hlK9P00xMFLk0xTooYJtT/U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>, linuxarm@huawei.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 112/350] perf vendor events arm64: Fix Hisi hip08 DDRC PMU eventname
Date:   Tue, 10 Dec 2019 16:03:37 -0500
Message-Id: <20191210210735.9077-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit 84b0975f4853ba32d2d9b3c19ffa2b947f023fb3 ]

The "EventName" for the DDRC precharge command event is incorrect, so
fix it.

Fixes: 57cc732479ba ("perf jevents: Add support for Hisi hip08 DDRC PMU aliasing")
Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: linuxarm@huawei.com
Link: http://lore.kernel.org/lkml/1567612484-195727-2-git-send-email-john.garry@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../perf/pmu-events/arch/arm64/hisilicon/hip08/uncore-ddrc.json | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/pmu-events/arch/arm64/hisilicon/hip08/uncore-ddrc.json b/tools/perf/pmu-events/arch/arm64/hisilicon/hip08/uncore-ddrc.json
index 0d1556fcdffe7..99f4fc4255647 100644
--- a/tools/perf/pmu-events/arch/arm64/hisilicon/hip08/uncore-ddrc.json
+++ b/tools/perf/pmu-events/arch/arm64/hisilicon/hip08/uncore-ddrc.json
@@ -15,7 +15,7 @@
    },
    {
 	    "EventCode": "0x04",
-	    "EventName": "uncore_hisi_ddrc.flux_wr",
+	    "EventName": "uncore_hisi_ddrc.pre_cmd",
 	    "BriefDescription": "DDRC precharge commands",
 	    "PublicDescription": "DDRC precharge commands",
 	    "Unit": "hisi_sccl,ddrc",
-- 
2.20.1

