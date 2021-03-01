Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEF9329237
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243470AbhCAUll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:41:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232326AbhCAUd7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:33:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 431DC64DBD;
        Mon,  1 Mar 2021 18:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614624831;
        bh=JOeQMOdStZQ8zOc/AwJ9c5j1aHREEL+GdfyslgS9M9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gcUMjJsMlW7D1Pwdg7XRsU8h3lOLSXppvosdN/6mX9W3ufCwsrz1ItWyFuZqu1dd5
         6CUzW0rv+YT16rdkot1Xkz8w7imluzqv++a3yo0P6NavB7Xn41mMnQnVnNZvjZ4Smp
         4R1oGIz4QR9EErAy8Ip16qQa2OJa9zGTo81dsnI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        James Clark <james.clark@arm.com>,
        Jiri Olsa <jolsa@redhat.com>, Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        <nakamura.shun@fujitsu.com>, linux-arm-kernel@lists.infradead.org,
        linuxarm@openeuler.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 415/775] perf vendor events arm64: Fix Ampere eMag event typo
Date:   Mon,  1 Mar 2021 17:09:43 +0100
Message-Id: <20210301161222.090634687@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit 2bf797be81fa808f05f1a7a65916619132256a27 ]

The "briefdescription" for event 0x35 has a typo - fix it.

Fixes: d35c595bf005 ("perf vendor events arm64: Revise core JSON events for eMAG")
Signed-off-by: John Garry <john.garry@huawei.com>
Acked-by: Will Deacon <will@kernel.org>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Nakamura, Shunsuke/中村 俊介 <nakamura.shun@fujitsu.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linuxarm@openeuler.org
Link: https://lore.kernel.org/r/1611835236-34696-2-git-send-email-john.garry@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/arch/arm64/ampere/emag/cache.json | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/pmu-events/arch/arm64/ampere/emag/cache.json b/tools/perf/pmu-events/arch/arm64/ampere/emag/cache.json
index 40010a8724b3a..ce6e7e7960579 100644
--- a/tools/perf/pmu-events/arch/arm64/ampere/emag/cache.json
+++ b/tools/perf/pmu-events/arch/arm64/ampere/emag/cache.json
@@ -114,7 +114,7 @@
         "PublicDescription": "Level 2 access to instruciton TLB that caused a page table walk. This event counts on any instruciton access which causes L2I_TLB_REFILL to count",
         "EventCode": "0x35",
         "EventName": "L2I_TLB_ACCESS",
-        "BriefDescription": "L2D TLB access"
+        "BriefDescription": "L2I TLB access"
     },
     {
         "PublicDescription": "Branch target buffer misprediction",
-- 
2.27.0



