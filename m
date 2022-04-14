Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622285008A8
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 10:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241099AbiDNIsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 04:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiDNIrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 04:47:55 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4C265D24
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 01:45:30 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23E82A1O007385;
        Thu, 14 Apr 2022 01:45:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=VWmnFS34249LqyqSuAKLRKNMnVxinE0hR8NVwQc/z+E=;
 b=nMIYW1ovH979QOsZAB+RSm+oiKHKe3Zk7P4+cJpPmMpaDuiOlt0/3Mzk2FL3ZIQgLb4t
 6RDDukQkRRuRtIYcdYrHAuZZjk6kfSbje7qwAuXYrjJ+G0Gez2zlU40xm7Gsye2s4oar
 O2Aeqnp8RRvIJqNy8FnKVzihQ8WgpLUHUIO0gnQ0vTdRsNKUP5/7FEREAxeWD8WeCoCq
 Pa6L/lZa3/T5hjU2DpVzBkpQ5gy6vHtT/0Y61GEO/rlw2ooc5DvmlXsx7E2d3VOT7z1f
 PvshnzAkgwF+el7jEvrsxJP+3LiafUlVz4QyYNfiBuSzWrr+jvJYanE0gfm6Krt0yMCh wA== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fc0jeb4j0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 01:45:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kDF2/YYLKOw791qr+/uP9u/sZiYwM4NTh+JrWFOq452oj9VGw+X89eCeDJ+X8nf1i0jwXZfqVssSfYU51fQrdHu88VkFd+p8p0kk+VXG5nsdMoLPbIq6bjsZ1Ac2UZmYTvUGTZianZE9/332vdpXRTaZWCRB3b9wLhPJO81PJlBMWQHEHUfytawWYeSJk4tU+ueMm5GkYVaqGQpJ0/f9pLV+n11q9Zh/4pqerytHVXwMoKyGSQu5LhVNZcVlZT2w1L6PwBne3gT+LnIp7PAoSN+g6pp+mN8mRFC/pQmctkjrh4vbq9Ed1Jm9oBtbH9eOJcdnI08K9FVe/LcI+CpzyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VWmnFS34249LqyqSuAKLRKNMnVxinE0hR8NVwQc/z+E=;
 b=kHuowl4XcEtwQEOm2EniCUpjo0BT6vzUYhTjKEwEBNH25xlCVGzNjEC8FMxNUa9B71qujBfiTrxX9kYWtqbOM6fSTymYbxZ5V9YV6bvjnn25sO8RzweGA/ZNy6wDSCi6Qk9Uq4ekVSvgY++jMA2wxNiPa07BKVGOYgvH7dILlU7UTm+0Dbrg9lll0sJBkeo5vAMqX3GKdYJHiBnfEdoTt2q2AAtxtOFddibvcpD1lVgetdnjLCCdgTIsWCasv17LpHALA5qNCsRFhKVumfzXr0wH8gV1tWqf5bayEJMq3e/UuZtsZoiNlnju8oWSyCKdpz9JABuOAnvJq6lUzAQYEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY4PR11MB1800.namprd11.prod.outlook.com (2603:10b6:903:120::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 08:45:18 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 08:45:18 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 5.4 4/6] selftests: cgroup: Make cg_create() use 0755 for permission instead of 0644
Date:   Thu, 14 Apr 2022 11:44:48 +0300
Message-Id: <20220414084450.2728917-5-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220414084450.2728917-1-ovidiu.panait@windriver.com>
References: <20220414084450.2728917-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VE1PR08CA0034.eurprd08.prod.outlook.com
 (2603:10a6:803:104::47) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b50cec37-62e8-40b9-d629-08da1df31a1f
X-MS-TrafficTypeDiagnostic: CY4PR11MB1800:EE_
X-Microsoft-Antispam-PRVS: <CY4PR11MB180035BCC49C3D0361676805FEEF9@CY4PR11MB1800.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H+czda91rmcFIiB5aZYVNgCA84JlPwFXYZWxEURuViTc5cyNt07hNH0ZE33Uyfe+fpn0fad9dt1C2tN+au5ljdgCUDvG3+E9u+kSiLvN7Qk2FpO70V8JbxPAb8Bi+jdOBB17aj2CPwlE5pWdnK00jWSLJaMBMCvO+ztdC81FUd3A1ghLldp43Ne26bsYoUt8rzpk85s2kOt+e4k6PeE/u1rTS1GAPi8HpKrHXX475wHifh1nW0MDSkpVHPKeIZc7NnRY9HK1TZ1FyVKmmRo4AQBllRhp+S6KAOe4nVnPKNik/KiMgF1FTxs4SzaEw7XvUDu1/GcRPjV2+aT8XFIsYei8Iol/Vsm4+W3A60QnYrgMh0nK3t4XsyzHTN6WKIjchBhVmOkPj2gYHktvH/vaOeOGH53X/8VhoDcVpi0nGsWh7XLixuvgpl0cuN0WsrVlBcyJyA8v5qygQ9W4tE0gwuBndTS0uVb59AVkOjo3th/aS3kPjadMZVXV+o6eUXH2kJA4ygF46g4g2/YjHFxipz3HGNp6rphSR9c9ffPSVbEV37ZNT2S5K1ZxYepK6Kg8egGepuR59pyytgRqUQD108Vve+3fE+6uMNDOqKp1kTo3mAYF6s9h9Tr8vc9U2vOnVZM7L/gAOKdh3gb+YcNNaDdGYqiIMGd7A4cO3JcgEeweNI4pyrqHWWhj3BO/Ba+K1ssGfqv6aZMvwcCHhyRA5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(6506007)(83380400001)(316002)(4326008)(66476007)(66556008)(66946007)(8676002)(6916009)(86362001)(2616005)(1076003)(36756003)(8936002)(26005)(186003)(52116002)(6512007)(2906002)(44832011)(6486002)(6666004)(508600001)(4744005)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjNOZEY5UElTaW5acjJ2V2h0Z3lsN2x0bUJCeXRSWEN3U29uemt1ajV6eFIr?=
 =?utf-8?B?cE94NnlMR09DOVJlNlVTc2FoY3Y3Ym0rTUMxZVYvRXFBT3pkaVovQlpGMFdY?=
 =?utf-8?B?MVpqWC96d21BVkplRmVpYklyWWljbXNibkY3c1pHaUVlUUlvYUJoQ1VmdjZn?=
 =?utf-8?B?ellrOHl2cnA1dUppblpZWDlycnYxUDZwMWhYTThPUXAzVFp4NlJaS2VrR3BZ?=
 =?utf-8?B?RktPYmhvVlo2Z21Vam9Qd24yNmZXcG92TTBGS3hXdHFZTVdpcXNOdmlMaG1K?=
 =?utf-8?B?QnFqVTdJTk5sMjVJekpwUkM3TVg4elBxa1d0VURPSkREZjAxNmxjaFpSSXhn?=
 =?utf-8?B?alFkcXczcThkNFhnMlJvTzdydCt5MHRrb0ZpTlhkY2h4L1Z3cXZvNmExbmxL?=
 =?utf-8?B?S1N2QmpBRFR2cU5pRzl1aG1NWnlRTzRVcWZTZjhTdHRmdEFkNmc3Vnp4UHJO?=
 =?utf-8?B?ME1icnJVZlowR2N1NHM0UDAySC9HeGwxQlJIdHNNQ011QWJtaVBQUUVFQXo4?=
 =?utf-8?B?MHdSTDA0WUh1WkVxd3NPUkVBZ3I2UlpLcFUyL3NSNEtuOUM2OW5TclNaSnZt?=
 =?utf-8?B?SHloa3lmVmIxQzV2ZGI5UkJzclArOXp4QkhEM1E5N0hBaFA0M25ma0dxVWJq?=
 =?utf-8?B?VTlod2JMS1NYMUlqV0RSVTNLYUFRVW53bjd0OC9IdGI2eDRsNzVsQXNmS0F2?=
 =?utf-8?B?MlFzWE1oRTlPakRSbjh0aW5NQlhiL1VLVnU5UlZrNVFoQVY2RWhteDVFSlQ0?=
 =?utf-8?B?Vmc0bldORkV4eDRaVUxnaTNibjlMckFPSG9TVGQ1Ujg2UTJjaThwT2dRbXZS?=
 =?utf-8?B?RXJXdTZscmF0WTRaZ3NyUmRTNEpxMFBUQk9MNUovMnpoZThMSDYxM25PUjB2?=
 =?utf-8?B?SXV2YXlJeU1sY055eExzZUhob0s2T1JIQ1NpUU5ieWwvR2kreFZNWjRST2FB?=
 =?utf-8?B?WWZZMkNyMytUWnNsZ05DbUU0UWRqYytveVRCYXl1UHN2MEplcm1QMFN3Q2Za?=
 =?utf-8?B?L3VSNEZlWUpncHVQdWJvSGJOQ0VZT0pwU1B3MUdwWVVZUHIrT2xlV0ZjaDNI?=
 =?utf-8?B?UkhVWmw4TUJ1LzhCZ09saC81M2wrckpLUnUvOHZZV2xxQVYzdGpyaVhzYWN0?=
 =?utf-8?B?Q0VKWmdkdU1rcklqTUtjNng1K3pHb2VuVnhyL0NmemJiNlBudDRrSEhoL0dz?=
 =?utf-8?B?ODhGVTNlQTcwRjdBdWRqMVNodmNkQWpxeXlPOE5hR2RmQTRDWDFERjFpaWhZ?=
 =?utf-8?B?TE10SnNoVWhHQ050dGU0d0pkNVdOdDVXd04wcTBSVFZVMnViQUNTUGxIR2la?=
 =?utf-8?B?dkF5ZFhtZnJpcjZ6MVhvNldqSlpoUFM1K0l3Z1VJZmV0N0JGRmNlNjZZNElR?=
 =?utf-8?B?eTB6a2Z0ZmdpTGpiRkhRMHZ5MkRjQVFsMDhzczNLd0J3UXRKUFhQM1NjMW1X?=
 =?utf-8?B?NFZHQ2tvRGh0cGRHZGJGWEJ3OE1aZHdPRXVNL0M5bVd6L1N5SE0zTFRlTWY1?=
 =?utf-8?B?dnh3U25oekljTHM3VjRITStrSDJodi81Q2JSWmttbERoMmw3SlNpTGFYS3c4?=
 =?utf-8?B?eDNFUFZ5azVpTE9Ra3I0dTdZS3FtVDM1aTNsdVZPa2xRVjR6ZGdRUElCNlND?=
 =?utf-8?B?ZE8xdE44eVJEd2xQa1NtcThmeWpYakhyMk40KzM5Wldoc2hqSHpud254R3dK?=
 =?utf-8?B?ZGlXOXJKZVdGZnVXbFpxYXNadzB4TjJFOXc0cTF5WEVQL3RmQ1Z3cVBDVDB4?=
 =?utf-8?B?Z0NiYWxSMnB6SGkrSDQzbk40ZXU5T1huMFpwKzR3SkJIazhweEtBSjNLaVB3?=
 =?utf-8?B?blZkWHYvNFVLQThNRzVnREdSTHhJZzFXK1k5MU90UUsyWGRkOW5hMmYzUnF6?=
 =?utf-8?B?SEtENnZwcklKb29vMktZL3FOdExIaFhqbElZVng2Vm9KS3Rmd0hqZFlXbHJH?=
 =?utf-8?B?NTVnSHJmR1pzWE9xWWlVd3hCNXVndXdSdEdIWTlKWWtmZkhXRVV1YkVSRHVB?=
 =?utf-8?B?VWVXdml4SVZoMitzTnFOdnRqTzlaT3FNT3JEd1gvN1VHNVlEQUVpcitoWkhr?=
 =?utf-8?B?QjFvTjRaRURlYmpNaGFOZ05HQXI0RHZZMnZqOEVXZDhIa3BZVW1TT1Z0NlFw?=
 =?utf-8?B?WlRUS0Q1eC8vZVVXanNibURoMFkvc1RUSWFSZDgzM01hSTJjcFlISUFzaDZ5?=
 =?utf-8?B?cXpReWtvbVdDb1R6K0pQRGIvMnhBM0VkL2srWVFQNDFhdHB6V0Q4K25EQ2lE?=
 =?utf-8?B?NHRZYTRWTnJWM0Y3cHNmUVFoZ056aUkwUHlPSXc1SVBpQmFSR2JsbWtlamw0?=
 =?utf-8?B?UldKaWQ1MUFBQURpemJrdE13OThUa3F6bUJ3b1ZPTUxYcHQwd003TlhPRG1C?=
 =?utf-8?Q?6cxTMchq7Dv13Hwo=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b50cec37-62e8-40b9-d629-08da1df31a1f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 08:45:18.1241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tIJqFX/pE58BOOeBofJbA2crHtCKjBVJWpaKkFZGwnh+hK/2END/18rcMNEkJYRuBZtP2l5tl6lvzOncQ1+Gac8od3m1PMNh8cFwZmSdgYk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1800
X-Proofpoint-ORIG-GUID: Q01cPb5WSrU4o81wOp2RvRO1kUkioWfc
X-Proofpoint-GUID: Q01cPb5WSrU4o81wOp2RvRO1kUkioWfc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=943
 priorityscore=1501 lowpriorityscore=0 adultscore=0 impostorscore=0
 phishscore=0 malwarescore=0 clxscore=1015 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140048
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit b09c2baa56347ae65795350dfcc633dedb1c2970 upstream.

0644 is an odd perm to create a cgroup which is a directory. Use the regular
0755 instead. This is necessary for euid switching test case.

Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/cgroup/cgroup_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index 5e939ff1e3f9..819f3480a6f7 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -202,7 +202,7 @@ int cg_find_unified_root(char *root, size_t len)
 
 int cg_create(const char *cgroup)
 {
-	return mkdir(cgroup, 0644);
+	return mkdir(cgroup, 0755);
 }
 
 int cg_wait_for_proc_count(const char *cgroup, int count)
-- 
2.25.1

