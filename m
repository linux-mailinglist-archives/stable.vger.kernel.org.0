Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622D54F7754
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 09:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbiDGHYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 03:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiDGHYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 03:24:08 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0F3B8
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 00:22:09 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2377B9GK012754;
        Thu, 7 Apr 2022 00:22:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=gVXJmf5kx8PnTpEsPd90x9WdGurZR2I1apZLfpsflOE=;
 b=TgWl8ushUeHA7n4mRk1SUy4b3plb/d4My6r8UYquHDb2YwGcramZDJKhMRR8fuaIzpYz
 ncBRQivScJyj44m1LAitPKGkTLbGJJNDG/E+78maTjiQwiutbROfo66hSflBJI23SVWz
 XhVR/4w2RMsUTyuv8q2ZMobMUIjbE5n4iIs59whRoK5i+W8n2oGRs9U6G6ThfqLolnMT
 hrs5eBvnhciNlml2VA3ZxZF+QOCbwUOXIEITkdi2+e1YqdXueVM1v8V8gbKg8mPEq4cv
 jxhYU5e2gmqO4/wpwRYjrcheKYzbXRY2UkqDk+wl0lnMnfWFE4RFzk62hbWf71kOetB+ tQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3f6hs3uxsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 00:22:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9oumsgNz3d0g9pKwZ9j6uWGBasauY3VD24DteacTzDnKx8ss3Jv81R7hLA0bDrC6tuqZHb0vWsUF7k3DuTEePbZEiQReE5qFQOgT40Ae3RXwmg6gSs0qauDkkefdmjICPu+ZxtSoCZHy/zRwweF28VGOtOFbTC8qIMmH90V8Cz4TNkIQRrZmDOTa2J0wfH+EllLaHeECuMDDPjRbI2IDl0lNRg+wy4sLrIWf4qGEFd6sG7044kLKovLEXIR/yEKM7nXrAWmnSsVqiXnG/mjEJ6kTgDIfxe0TUP3ySsyBy0t9f+ZN3TytAulImQ38p54eugwclxhcPfdMkx7JnZdkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gVXJmf5kx8PnTpEsPd90x9WdGurZR2I1apZLfpsflOE=;
 b=nukLE3t4kZQoP7PZ+NkfpB6N4HDs+FeWzF79NhzSWADqsEfJ0mQSrTDGE0kRoOrCgTqk2GpWKitj6osivKfucFrRbgCEaxPUAQWooRU4inqOmLmGgjRZFRe4o6c2itlboJizi9eTI4+HBLs4fgmpmGqUHTxolJ6SBHFhhD/oewlm2aS/dEvIWAj2ET5MGb4G4ZcRyZ6Q5kUf4wwUMt0CPgUsQqrjaq+uTfH7hBtRQ9i0YmSFwB1UAcI1btRa2GRVYCPjs1cCQff3e68PDyYrebLhFtwOgcpEKzgUqodrCfYDZ/jcM7p0KMScWD5HKxTaPu7yTPj7+7L8TGXV7OATEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3371.namprd11.prod.outlook.com (2603:10b6:5:e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Thu, 7 Apr 2022 07:22:03 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::fd7f:8915:60b2:cacf]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::fd7f:8915:60b2:cacf%6]) with mapi id 15.20.5123.031; Thu, 7 Apr 2022
 07:22:03 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 5.10 3/5] selftests: cgroup: Make cg_create() use 0755 for permission instead of 0644
Date:   Thu,  7 Apr 2022 10:21:33 +0300
Message-Id: <20220407072135.32441-4-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407072135.32441-1-ovidiu.panait@windriver.com>
References: <20220407072135.32441-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR04CA0094.eurprd04.prod.outlook.com
 (2603:10a6:803:64::29) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8aa6e5ac-912e-45fc-12c6-08da18675022
X-MS-TrafficTypeDiagnostic: DM6PR11MB3371:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB337181806E848444D990ADE2FEE69@DM6PR11MB3371.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BfV7f7N7T6hEAcmRWwKUFpPWtv5I/ujh7jJf0Lu1hG4VoDtExIed+ydkTrOJZfkWyezLM3wUgzINkljExLWEoAzkmdRMusyD9N4vKpxwks8XRlWfq7TAtKnpBKSNX4dja49cmExmvvRGBoAhCvBcFcJHpeqvvweUI8P7yfeKPVqLVExpnNqrUc4HZpoLzGpsed42SdmrbIt4wlXtIoh0//WmZQ3Izto9eOtpV29FQhiq5amGgJuVia6YeNroACfuLO0Qs4AGaKmLSrKf+IKxzvF2euOE6VEg5EnkE2BuOyUZ/8PUZY/WpAsIq8h+5e7aZVt+jsE1gw/1Aj5AVlY6OrRS0opBogn/h4f35NRlKXdGpKsLw4MdrqrD+ZHjVsJ/q+dyoCc7WAIDO84nDgimoxcGeTtuavniNejQfjEFIcY8c5YU7j/FbSHS8OPOxMtMDDmhK6JZWcLo/W2PofUNKb+ukFVkkvwUwj5+OM2QoMz/lhgnLbn/YyP+PcHX/0xEDyrKXuBGyfO3K6hVzkHX2rp0Tevi+VXX42oHGKgZxZ1NkCEO7w2b5gpP4C3S23diwVLiegraHMehINyUsejhy2wbwtXotWxhRqYcHKVoFFvuqY6qdFPBP5KY1lTg32BZlOF0aqLay5te5dAMisW6MbblTbW22HDpS0kXBrVrVPYJ/pjFE7I1WECdp0g0B2cqfpnLs6v5c6cztA/ZYPApyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(1076003)(66476007)(6512007)(66946007)(8676002)(44832011)(4326008)(38350700002)(38100700002)(5660300002)(6916009)(186003)(26005)(2616005)(316002)(2906002)(36756003)(4744005)(508600001)(6486002)(6506007)(52116002)(8936002)(83380400001)(6666004)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDFqQUlNbnBVT1pMWHVVektkZURYTEVxWUlmWEw0Z2NmRkxROVN3bWEvRERa?=
 =?utf-8?B?MWM3RmtpR0VydEhQbEhUMk5vTmdJVkYvM0JOT094ZE9yNmZ6NzlMekhSbFF4?=
 =?utf-8?B?MjIvQTEvL3RDSUozUzhuZGVINW9WdXhpYldmTlh1R3JFa0YyVlkxSDIzMjZB?=
 =?utf-8?B?UUpGUnhRNjY4MGxuS29sOGZKYjQ2ZWNqeXFyVFRQclZYWXZ0M2R3aU8xTmU4?=
 =?utf-8?B?VTFUTWsrUzh4RFpWZWNNOWJKMzQ2TzY4M1pITGJ0cnZmWGFIczYrMXExdkhX?=
 =?utf-8?B?QXpQdmRNSWRraUVwNzBtdmZEOWFxT3ZTV0pOdGFkVEF1M3BmZnA4YmROZjBI?=
 =?utf-8?B?YVcrLzNWYXl3TERzdXg2aFhJcGJtRFFud2oyc1BNSTRRSWpUUXRXYm9CVFZD?=
 =?utf-8?B?amU4WTUwTEl0WFpsRDB0WEVRZ2JJWU94eHJSbko1aURqUnZrVDdsdW10Wkxm?=
 =?utf-8?B?Vm9IWEpjQ2pNd0RwK0dhZDVCc0JDNlFNNTdjS3ZtdmF2d2VicHNzZEU0cUZM?=
 =?utf-8?B?NmU4TXJTaHdWUFhJcnRCTGpocC9jTGtpb0JmYkEwdHFjRXRqREc2UkgrMzBx?=
 =?utf-8?B?bGE1QUIyOFVYVEcxeHVXY0M3dFdUcmxOZ0loejRWUjR4UThmY1VDQy9iUWJC?=
 =?utf-8?B?Q0lDb0dSZFFMNjhTUGhXUlhFR3Z5TnVVNUdkY3dLNE1RR2g1QVcxMDlHZEdw?=
 =?utf-8?B?d3pMU3QyWjhDQkFBOVByaEczV0hjMExxQnFNN0luYk5ZUkdVKzdtSjRrVWxT?=
 =?utf-8?B?T3BaVEtKd3FDUlNrSnc2VVkvMGkyd1FNdWJ2MGxVR01GZ2NLbmpLNG1jVGly?=
 =?utf-8?B?YjY2SmIrdjhPNjJxcWVGYnFpMHpUV1BCRVFhNlBJSDAzYURuc0xrWFBPeE5Y?=
 =?utf-8?B?eTAxSGZBYldHWnVCdUJ6cm1oZndleFBPZ1VqSWQ4aVFjNVA2enk2SC96QXVa?=
 =?utf-8?B?NnVSUU4xT0dYeHpDamcvRVg4WWR5cURxTVFkb3dkRkRWY0dxa3pKVzIyaEhZ?=
 =?utf-8?B?K09FcS9hZmJpOHpvRkxvWUpxY2FBbTI0V3B2MHBxVXN3TjlTS3RHeTRwR3Ax?=
 =?utf-8?B?YWFTRVh6M2JHSnY0NzhqNnVVK1phVmlLamtsU2hoVm0rUldnWHZ2Q0xROXUz?=
 =?utf-8?B?NXRYb0c0THg2NUNSWEhaaDhPODFkaTZvVGlpVXoxSmdPL0syUmFha2lZcFpt?=
 =?utf-8?B?UmJlY2RLYTFZVzI3bFNuZkVtTlZlMDJSdzNxMFJybUFoalhzdFRlYlBVc0V4?=
 =?utf-8?B?WHB6UDVOc0g1c2kxaGFtY2hOUC9CK3FITno1dFZaYVhYaG9pcWM2MkRpMUVm?=
 =?utf-8?B?Mm9Hb041bERPUGkwNTgwemhEdEpnUjNkdndGc3hlRWxJRWIvWkFqZFg2dDA4?=
 =?utf-8?B?MG5WT2tENUFwU0RhcGpyLzZocXdQYkVsaWVSTGhoczFKSXZxaHQrUHNuZnlz?=
 =?utf-8?B?YjBuaXRDYTZpVkt1b3JWV2poVmlVRXRJckw0ajZud0YyQ0JOMTlkV0w5amVr?=
 =?utf-8?B?Qy9CT2NhK0ZHNW5JUEJVL2tsMzZ3MEhpTmI3NkNKd1QwQTBuRzBiS1poZEtD?=
 =?utf-8?B?Ti8zTU5yMWcraVZhMHBjWXYzT1ludE5pVmE2eDA5TmIzVHE2WUZaamVhaDNj?=
 =?utf-8?B?dVRScit5V3NTZndGQ2NIejVQTXdLbjA5aXZVckRNcUVqWTI5bElQTm1yUmVI?=
 =?utf-8?B?Q3IzZGwwZTFuaTBEczFlTmI1TVF4UTl0WDVRV05CVFRTaStHWmFBMXJOM1FJ?=
 =?utf-8?B?YU5xWlgvdTJDSHdTaFRhNlcrOS9idnFBWDR0Y1ZQWGkzYk16UDVJSXJtMUMw?=
 =?utf-8?B?QTJHZ2Y4MDVQYjQzV2dMUmpUS2lPam9ETXlrY29RbnpUTG83WlJyZ0RBWklV?=
 =?utf-8?B?UE5adE80WDN3a0JKUXlmWHJlakVpV2RYU2tjRzF4dXI1WHI1WVpMdjVUVXNH?=
 =?utf-8?B?NmJOVHQ2akZQSG9GbVlicXJsVVhRZCtKTjBTek1LQm12cG80VHhGcXZBQi83?=
 =?utf-8?B?dEg2VjRpT3JKZDBPY3hSK1lRdXFnUFdtL0o5UTRlZEtVcXNwd0hEeWtMMHdE?=
 =?utf-8?B?SHVrZHQxV3FBSTJ5VHJ4em1nRWNTODVvZ3IzMHlETnBITEQ3bWI4TythNTFU?=
 =?utf-8?B?VGpnVU1yRS9uSTdQMC9GY2Y5dmZ1T3Y2eEtoTFViNjFzSnYwOWZOeCtsa0Rn?=
 =?utf-8?B?TFVwOFdWSE0yYmJlS3NPdVpqNFRab2VGYzljQWxiYmkrOERJSkEraGh5eGtD?=
 =?utf-8?B?eG9SaFVOWWt1dGJxWGhFd0RxcXVsSEpiRE1pVThta1hnbUo1d0M2b294NFU1?=
 =?utf-8?B?SkxlTzBOUkd3L0dPSDBxa3JoT2tZdGluQXcwMC9UNi9SdUJJU2RaZE5kbkdY?=
 =?utf-8?Q?b7UbIFzjQuIbbxUE=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aa6e5ac-912e-45fc-12c6-08da18675022
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:22:03.5672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zJK/Ps7sYWaBMfKmWCcf5UTIR5Gqr2sYap4FzvrfugFAf4xkfsHDlDY6drNfs2B267TY5nswCiEj+IP55v+B1zL5zpqrEBEsnC9bsCO1tmc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3371
X-Proofpoint-GUID: OwAW3u03ydW8LjGK2d5EB6GMmM1D-luV
X-Proofpoint-ORIG-GUID: OwAW3u03ydW8LjGK2d5EB6GMmM1D-luV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=947
 malwarescore=0 spamscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204070036
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index 027014662fb2..5b16c7b0ae4f 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -219,7 +219,7 @@ int cg_find_unified_root(char *root, size_t len)
 
 int cg_create(const char *cgroup)
 {
-	return mkdir(cgroup, 0644);
+	return mkdir(cgroup, 0755);
 }
 
 int cg_wait_for_proc_count(const char *cgroup, int count)
-- 
2.25.1

