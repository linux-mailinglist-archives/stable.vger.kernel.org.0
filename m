Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDAF3AA985
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 19:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389315AbfIERAb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 5 Sep 2019 13:00:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:5869 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389197AbfIERAb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Sep 2019 13:00:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 10:00:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,470,1559545200"; 
   d="scan'208";a="182883502"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga008.fm.intel.com with ESMTP; 05 Sep 2019 10:00:30 -0700
Received: from fmsmsx116.amr.corp.intel.com (10.18.116.20) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 5 Sep 2019 10:00:30 -0700
Received: from fmsmsx125.amr.corp.intel.com ([169.254.2.49]) by
 fmsmsx116.amr.corp.intel.com ([169.254.2.181]) with mapi id 14.03.0439.000;
 Thu, 5 Sep 2019 10:00:30 -0700
From:   "Brown, Len" <len.brown@intel.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Prarit Bhargava <prarit@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: RE: [PATCH AUTOSEL 5.2 82/94] tools/power turbostat: fix file
 descriptor leaks
Thread-Topic: [PATCH AUTOSEL 5.2 82/94] tools/power turbostat: fix file
 descriptor leaks
Thread-Index: AQHVYznN/Ro8M0co9U+Uq7T0wLP1CKcdTlTA
Date:   Thu, 5 Sep 2019 17:00:30 +0000
Message-ID: <1A7043D5F58CCB44A599DFD55ED4C9486D97C3FA@FMSMSX125.amr.corp.intel.com>
References: <20190904155739.2816-1-sashal@kernel.org>
 <20190904155739.2816-82-sashal@kernel.org>
In-Reply-To: <20190904155739.2816-82-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNmU5M2FlNmUtODZkZC00ZWQ1LWIxODgtNmM2YWVmNzcwZDU4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiWG5wb1wvM0tnU0FRdmt5cG5aRW11MjJmK2J0WnB2ZW1pSlNBZURvbGY1VlE1aHpSK3FqNVRDeko1K2RcLzh4T1wvQiJ9
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

FWIW,

The latest turbostat and x86_energy_perf_policy utilities in the upstream kernel tree should always be backward compatible with all old kernels.  If that is EVER not the case, I want to know about it.

Yes, I know that some distros ship old versions of these utilities built out of their matching kernel tree snapshots.
Yes, applying upstream fixes to .stable for such distros is a good thing.

However, the better solution for these particular utilities, is that they simply always use upstream utilities -- even with old kernels.

When somebody reports a problem and I need them to run these tools, 100% of the time, I start by sending them the latest upstream version to replace the old version shipped by the distro.

Cheers,
-Len



-----Original Message-----
From: Sasha Levin [mailto:sashal@kernel.org] 
Sent: Wednesday, September 04, 2019 11:57 AM
To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
Cc: Gustavo A. R. Silva <gustavo@embeddedor.com>; Prarit Bhargava <prarit@redhat.com>; Brown, Len <len.brown@intel.com>; Sasha Levin <sashal@kernel.org>; linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 82/94] tools/power turbostat: fix file descriptor leaks

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

[ Upstream commit 605736c6929d541c78a85dffae4d33a23b6b2149 ]

Fix file descriptor leaks by closing fp before return.

Addresses-Coverity-ID: 1444591 ("Resource leak")
Addresses-Coverity-ID: 1444592 ("Resource leak")
Fixes: 5ea7647b333f ("tools/power turbostat: Warn on bad ACPI LPIT data")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Reviewed-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 71a931813de00..066bd43ed6c9f 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -2912,6 +2912,7 @@ int snapshot_cpu_lpi_us(void)
 	if (retval != 1) {
 		fprintf(stderr, "Disabling Low Power Idle CPU output\n");
 		BIC_NOT_PRESENT(BIC_CPU_LPI);
+		fclose(fp);
 		return -1;
 	}
 
-- 
2.20.1

