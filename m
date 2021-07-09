Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546DF3C20FA
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 10:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhGIIqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 04:46:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59478 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231585AbhGIIqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 04:46:30 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1698X3ui034061;
        Fri, 9 Jul 2021 04:43:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=YGU1/GMvFydHj3oddOrY0kMV2Ha7vK1EMdXlqyXSdvY=;
 b=AKCLp/hCQtoTj6eIGpIazqFDRhlEjljHN9HqN3SSoKBX7CP/OcHF63jgoAdFQYDIvDP9
 bhVGmfpX2T2jPGbqsU1I68Ar/MSeh4VycLWdEWkfQYMpPptvfTokqzvx0wEy8MnaFK/n
 NpP/UN+VphrGvKwj55XrPDPXTQje3USSyQOKiMIBvbOafl9kb6ZwoNbBogVSQyAs4nQU
 4smcQyX2CjgU15bTxG4qc/29MNVvCTZCQxEDSG886YfTHxaQMgC19VcToTwDA3iNwwKU
 WSn9fHBL2Q0Oe60Dg2zj/NCVo++nhEz/Dydr2y6DuZRBUkV8/6GtE9bGSo9P+5OZvLf+ 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39p0hr8k7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Jul 2021 04:43:38 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1698XGBR034456;
        Fri, 9 Jul 2021 04:43:38 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39p0hr8k6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Jul 2021 04:43:37 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1698eejn025403;
        Fri, 9 Jul 2021 08:43:36 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 39jf5hhcuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Jul 2021 08:43:36 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1698hWEG34472422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Jul 2021 08:43:33 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C82D9A405C;
        Fri,  9 Jul 2021 08:43:32 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B572AA4054;
        Fri,  9 Jul 2021 08:43:27 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.199.39.183])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  9 Jul 2021 08:43:27 +0000 (GMT)
From:   Kajol Jain <kjain@linux.ibm.com>
To:     will@kernel.org, hao.wu@intel.com, mark.rutland@arm.com
Cc:     trix@redhat.com, yilun.xu@intel.com, mdf@kernel.org,
        linux-fpga@vger.kernel.org, maddy@linux.ibm.com,
        atrajeev@linux.vnet.ibm.com, kjain@linux.ibm.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        rnsastry@linux.ibm.com, linux-perf-users@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] fpga: dfl: fme: Fix cpu hotplug issue in performance reporting
Date:   Fri,  9 Jul 2021 14:13:19 +0530
Message-Id: <20210709084319.33776-1-kjain@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5asgOQpK-L42J3lVBxCXJt5uqxvGUtbb
X-Proofpoint-ORIG-GUID: 5m_umRQ0G3-bQzjaZVAZ1BURCgNMWqVG
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-09_04:2021-07-09,2021-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 mlxscore=0 phishscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107090042
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The performance reporting driver added cpu hotplug
feature but it didn't add pmu migration call in cpu
offline function.
This can create an issue incase the current designated
cpu being used to collect fme pmu data got offline,
as based on current code we are not migrating fme pmu to
new target cpu. Because of that perf will still try to
fetch data from that offline cpu and hence we will not
get counter data.

Patch fixed this issue by adding pmu_migrate_context call
in fme_perf_offline_cpu function.

Fixes: 724142f8c42a ("fpga: dfl: fme: add performance reporting support")
Tested-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Cc: stable@vger.kernel.org
---
 drivers/fpga/dfl-fme-perf.c | 4 ++++
 1 file changed, 4 insertions(+)

---
Changelog:
v1 -> v2:
- Add stable@vger.kernel.org in cc list

RFC -> PATCH v1
- Remove RFC tag
- Did nits changes on subject and commit message as suggested by Xu Yilun
- Added Tested-by tag
- Link to rfc patch: https://lkml.org/lkml/2021/6/28/112
---
diff --git a/drivers/fpga/dfl-fme-perf.c b/drivers/fpga/dfl-fme-perf.c
index 4299145ef347..b9a54583e505 100644
--- a/drivers/fpga/dfl-fme-perf.c
+++ b/drivers/fpga/dfl-fme-perf.c
@@ -953,6 +953,10 @@ static int fme_perf_offline_cpu(unsigned int cpu, struct hlist_node *node)
 		return 0;
 
 	priv->cpu = target;
+
+	/* Migrate fme_perf pmu events to the new target cpu */
+	perf_pmu_migrate_context(&priv->pmu, cpu, target);
+
 	return 0;
 }
 
-- 
2.31.1

