Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F991140005
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390744AbgAPXr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:47:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:47736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389926AbgAPXUx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:20:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 865262077C;
        Thu, 16 Jan 2020 23:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216853;
        bh=amStAd1KELjmA1Scb6cF9nLqAP1m98ADee0TQF538lQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOqiPVd3UyAL/6QQMDfR3lH5iiTqk3TVvD5mOMXWKhkhYa+eXR/6LhGl/icNdYSu3
         cmYUC+qPBP/GgHyI9uvqD+TOriOJtULvtlbXuYERrf3Gga08t2EHj/L4Zrx5D6vaz3
         fEfxu2xmCF6LUS7+l3KlI4MS1p7Bz5x+pQVG01ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ed Maste <emaste@freebsd.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greentime Hu <green.hu@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.4 046/203] perf vendor events s390: Remove name from L1D_RO_EXCL_WRITES description
Date:   Fri, 17 Jan 2020 00:16:03 +0100
Message-Id: <20200116231748.018307555@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ed Maste <emaste@freebsd.org>

commit 58b3bafff8257c6946df5d6aeb215b8ac839ed2a upstream.

In 7fcfa9a2d9 an unintended prefix "Counter:18 Name:" was removed from
the description for L1D_RO_EXCL_WRITES, but the extra name remained in
the description.  Remove it too.

Fixes: 7fcfa9a2d9a7 ("perf list: Fix s390 counter long description for L1D_RO_EXCL_WRITES")
Signed-off-by: Ed Maste <emaste@freebsd.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Link: http://lore.kernel.org/lkml/20191212145346.5026-1-emaste@freefall.freebsd.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/pmu-events/arch/s390/cf_z14/extended.json |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/pmu-events/arch/s390/cf_z14/extended.json
+++ b/tools/perf/pmu-events/arch/s390/cf_z14/extended.json
@@ -4,7 +4,7 @@
 		"EventCode": "128",
 		"EventName": "L1D_RO_EXCL_WRITES",
 		"BriefDescription": "L1D Read-only Exclusive Writes",
-		"PublicDescription": "L1D_RO_EXCL_WRITES A directory write to the Level-1 Data cache where the line was originally in a Read-Only state in the cache but has been updated to be in the Exclusive state that allows stores to the cache line"
+		"PublicDescription": "A directory write to the Level-1 Data cache where the line was originally in a Read-Only state in the cache but has been updated to be in the Exclusive state that allows stores to the cache line"
 	},
 	{
 		"Unit": "CPU-M-CF",


