Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B035009B9
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 11:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241727AbiDNJ3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 05:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241726AbiDNJ3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 05:29:03 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2493950E2A
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 02:26:39 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23E8pF5I001147;
        Thu, 14 Apr 2022 09:26:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=XAZHyC9K2o/7LQrznoYuKmVJVKVq9KNj/WfHjgJZXek=;
 b=JAV56AMSdmMDgKpmSbC1Cy/1UKST1ymID6JVhXnCULb3odtJIha+xGfqbrCKtAcBqahX
 3L+nqmqnqCYohLThpM3YawzAzvfgwXFZ5yVRgjbE22+DUIy7Ayu4cFP0ppX6VJZi5Qt+
 weR8uto7GAbtTC04NGQxVdoxRVPbi5TNfeP4Pdwxc7c0onZxc0zVkj8epMyvoX0y3XR9
 Q6eGELI7l3n0KhVUq9YbJ042+HBiuJKtIq3Q4OWTDBVClBmhTOxnost4GwCfxbxZRgiU
 fThoqgtte9EqESP5Vu2kGspAcipTBsRy9J5aBAZAtR/+CqLC67BYpal3BsRtkpdIrFcr LA== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb6fwbueh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 09:26:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gpv3d616M5h/wxBIDu3WTz2ynBXDGKu1iVgvfZ0Ulm7hxQD3z1DMI7bhqAIsz56TrZ/8egtHQYhHkQzRNDrR21uTC9nwimOsGXmFzgPMrHik/XFgo8N1a4DxrduVN+IHq834kZW/RGyZSL9ixPQ5xT8wLA+Knvjn73EPN+CQD6BM//lqGVy2JVoDEglyWqxDeEX/rfaqEUJp5uv8XBiZlJTSjFjHm94+BAhmaD+hudqT3EhTnI/FdqK42lyUxiXX1ghPG/LmYSWjCMa1JRUN3+rRLvh5l3dhF8hsqpRppf3oDA/hZtwpwZIodFj60blOr6bx5nmDcghQydISZuNHzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XAZHyC9K2o/7LQrznoYuKmVJVKVq9KNj/WfHjgJZXek=;
 b=VOTip7Q9P7e08fWUiZWIFW4z6B85NC86QjS0slCe3GBSNC35eUrMr8KEWuF86ND2XwjIL4OUb/XLSLO0NqLYQKtU1dQFlgdvno9FbtHQGb8uG+WBPpPZwJ+hj5afniZbcMVJmqlI5loPlupBp01fGYqrnlf3rtLZbSCn/MM6FIffaxiKCMW3SontUQmgtAOQ6lv/FL0LdIxCXQtW7h9XL6fl3K2R/uCksCt3GUojLuxQ8SO0QgZV8EMyoAyCJ8x5likBU+mviHdH0Haq2ezE70KIb5BJSrCWD9APeSfLUU7idM13CgS3oVE0uGRYjIWacWxlYgcDMt1tykqSHLyUvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CH0PR11MB5756.namprd11.prod.outlook.com (2603:10b6:610:104::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 09:26:25 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 09:26:25 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 4.14 2/3] cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv
Date:   Thu, 14 Apr 2022 12:24:20 +0300
Message-Id: <20220414092421.2730403-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220414092421.2730403-1-ovidiu.panait@windriver.com>
References: <20220414092421.2730403-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VE1PR03CA0009.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::21) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df186478-17a9-4c49-e419-08da1df8d8f6
X-MS-TrafficTypeDiagnostic: CH0PR11MB5756:EE_
X-Microsoft-Antispam-PRVS: <CH0PR11MB57561AE9B48A7D7D7AD52E20FEEF9@CH0PR11MB5756.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W+S+Hyx4SSFB3ZTUmHcG8qzzmCIflta/p9RQw5XPgqLst5Pzolxdf47tdsqBpO5n/hEYvdtMmnasr5bbt3q3ILQAMueiKcgZY4olKsgEfIUsrpWq8+F20++HdHr6Sdicb6x3r6RPP9qkNMQ9ZK4d85eqKwFgnQ1AEkvM4r9IXZo0VKckaKxJxxeXNuJTrehF9GAN8ZZGkkcNospS72RDiaFRO+/8gCaqhWXvJC75UVgqyYAagjDXvJxLonqh+S5Io57Ufv8+8y5Iwz7g7Jtf6QIRs6n9aGHduHSXeyF5+VjM5UqWOwM5MuLMgaFikiJtq2/v4MenV0xsSpcX4Awc5u1m6gBvyouuVf8VhGiiE39M4uWQSsNVdSH5gluIv09Av7axGcO6RF2YejzOmkOqfidX2Clr/c+SQ3JgvlOAfU/oPR6LuHveAf+mqQL4/Gw/POuRKn2nsoNPfK9g0ed5z0YLYpma5JRR6iQJNi5jlLCVph373AlrPQXnePuPQzd8YCT94Vuzvwor906HEeMBU2qXTU+fIShfuwlhHuyZLpGV1mRxSPTVNPLTipXP5pDlJZ818zOIaD4JVJ/xBwoUKZYwWuhrwgdweL2XdEFNtZhMk2yg5P0kO4wI1CNv0M4tpfjH1N+hLArI/7fvXwXc5n6QngO7j1ptpNr/xNDGDRhXiYkDMJboB5idcaZHCycHC8Lj+rgHfb3LxMXjbL0SAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(8936002)(6666004)(38350700002)(38100700002)(52116002)(316002)(6916009)(508600001)(86362001)(66946007)(66476007)(8676002)(4326008)(66556008)(6506007)(6512007)(6486002)(186003)(1076003)(36756003)(26005)(83380400001)(2906002)(44832011)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3NjWFlCR05iTTl1Z0plbW1nWW1jblFzQllkWElpMFQ2RExpcDQ1NHRyRjVv?=
 =?utf-8?B?YUM2K3ZLdVdLaW8xbDRnd1FHQWZORjBmaWxWck1VeFQwYUovc1hmZkZXMldG?=
 =?utf-8?B?N2ZvRVNzWnp4Y2hYWktWUW5GTGhabGF4RCtNbXU1V29rMWlSanlUWVEyTXN0?=
 =?utf-8?B?MHJHODlKdEtVWUR6aFhPZmR5bWl2OHoyaU10bEFsQTIwaUh6M0U5Q2oyZmZH?=
 =?utf-8?B?WllrSVdDcEh0SkdrRmZaL3FMbnhudE82bk1hYlpYK0VSdXplVTRScmlBbzNt?=
 =?utf-8?B?NHh6NWRxMXVzSnhaVzRhUTFIYVIzcFd5dTd3WFlzRHgyUDRzRmxHNjNLUGoy?=
 =?utf-8?B?V1h3NERENWxuckdLQ2t3TFEwQUkvbWZWcXBDRUgxVkxKMUhPTms1cDl0YzJT?=
 =?utf-8?B?eFBjUGJNSEg5c2tKTWVwV0o1biszQ2NnM3liVjhjRXczU1o2K2JDcmlXc3Iw?=
 =?utf-8?B?UnU1QlVWTlVQRzlrQVcrMTN1dEpqUUM3T05oRlBSd3ZUUU5NZlhMYjkwdVky?=
 =?utf-8?B?YXZLUVBybDViVDVGRzd4Q0MzYXdCNi9Lcld5Tjl3SmgrVFFhZm1FTlcxNkhL?=
 =?utf-8?B?QjBFSmRJUDNwMFZGa2lMTEl1N1ljdW02TURxdmZRQmJ1N3Bqb1l5YU5YZSs1?=
 =?utf-8?B?Q01RbkFXNlpCOFBaWTJyRFozamdkNWUrRlBGZ3RBaStvNCsxQmtoNzIvTjVs?=
 =?utf-8?B?ck9EUElVVi9IYWNka2Y1NTRDdzR5amM4ZlhuVGx1Wi91eTN4ZVRSb0ZBcWRn?=
 =?utf-8?B?Wm5OMmFRMXdOc2RXbnQxRmphWmtxdGsxaW0wSm02c3l2bS9RMXAzWlI2emlt?=
 =?utf-8?B?R2J1b1BLWlRkeXQ2ZG51aEVYUGZaMUgxb0pnWktscDJGL1RpSllVdm16UlU1?=
 =?utf-8?B?eUJhOXZuZVRUaXJwYllHcE1OTHFNZzFGZVRaem4zTFhORURGbVVheVNKQXU4?=
 =?utf-8?B?ZDVjbUZBTmxML1VDV3hhTFdYR2FGdGtoKzB0Y2xXZThRSW9LdHRVRG9qVFdO?=
 =?utf-8?B?YnpldkJUU25Tb0E3bk01TjJlL29icFV6cnRZMW5Xb2FtZzN5b2dBQ0NFZnZk?=
 =?utf-8?B?WC9XcDdMWXBUZEs5UzdpV3J5eFRNZjFSVy91bEFINHZKcmFMSG9aOEE5b0dh?=
 =?utf-8?B?WTR4QTN4WlordEtTK1NzNDdwbDcrMHVHbU9CREo1SUE1VVdOb0Y4TW9WM2Uw?=
 =?utf-8?B?OGN3QUZwSVBTWGd5b3NCMk1WYXZwMFVpcUNrMTFQSDUzMUlUQUQ4S3pkeVRv?=
 =?utf-8?B?TjZlVERhMzJTSTRiL0dSVkxTQVpqMDVkQlcvd243U1FMZXpSdFA5elo5NmJo?=
 =?utf-8?B?TjlHVU9vTkhUbGF0QXByWHhKd3ZzTU9uNXVrdWRKWkcxNnRpSTNwWVV2QVVh?=
 =?utf-8?B?cmlZM25lK2ZLR0VYSEFERWFlbWpzS3c5Q21ZZGpqY0ZleFBwWUh4NEx2S2Ew?=
 =?utf-8?B?UWpiZHZaQ3BJYjRVTEFjcnFmRjdJdUhyMkIxUWNEN0MzcXZvT2NFN2NPNkpw?=
 =?utf-8?B?dktPdDBEOHU2SnE1NFlPWkVZbUE1Wmp3U3VUanBHamlmeGlTMWlVQzFWeGpt?=
 =?utf-8?B?cDVsNXpNTjB4TjRzQk9FRDhEcmJEMWRsbGg0VEJuOVpxbEN3RERVejdRWGlv?=
 =?utf-8?B?cXZmbHFLYXFvVnpBRUtxeHRVT2s0SmJ0SHVNQU5QYTlTdko0UXN6M2xwNkpz?=
 =?utf-8?B?QUxacWN4WG96TGNvY0piWHhscFpyT24vaVhvQmtHNDBPcGRDR0FxVm9kaTB3?=
 =?utf-8?B?bmw5Umo3VzFNYm5TTWlRSW02Tm9zTVhtaVZ0MHh4dDdNRndSMDloMmkrNVc2?=
 =?utf-8?B?c2VGa2h6RXhqM3cycWJubHUrSHp1cy8wMHc5OVFkWUZGSy9JN2UzSUZ0NkJi?=
 =?utf-8?B?c1A0YUR5cGJHNTlVTVRueldzV0tLNEIvN3RpSit4MnBQeTdYV05ibmh1NjJR?=
 =?utf-8?B?ZlBsTjJ1Y3hrNU00aGRjRkxzcEkycGE3bWQ2ekl3eGZLaEF0c2ZvMzdXSTg0?=
 =?utf-8?B?Q3c3OUxqOFhQSzZEc0o3MzN0VTMyQlBJZUpFYXFkOFZKYU9rTUcxbXlrWDhU?=
 =?utf-8?B?SFpEVzJtajVEZGUvQjRRTVFKYWtRZGpNZDFibEFBMmRDUW1QdHVTU0JycXlv?=
 =?utf-8?B?RkFjeFdHYWd0dUQ5Smd6NjAzM3dMTEdtYUpuNTNDZW1Oc3VtV3RwUDcrZmpr?=
 =?utf-8?B?aHVIcDJRaVlYOWJtcmRURTNyL1Y1eGhNTG80OTU5Y0IzY0tHSmd2aCt6c1BE?=
 =?utf-8?B?SXdYTUlhVnRUR1Y3OUZIYUF4dnNQTjFxb1BXTUNrVkRQLzVaV2JQOWJNMEtI?=
 =?utf-8?B?K3BrTGZFQjUvZ1ltaS8zMWtkVllKRGVkeEVSNDlMcDlxa2oxTmtMY3dyZDYv?=
 =?utf-8?Q?OC5vPSfgpl61eg8s=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df186478-17a9-4c49-e419-08da1df8d8f6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 09:26:25.6595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8AGV0+RDiCFmpV9juIgjeIOk1bnObJ5vCTaKO7FrwSa2aAfKdVKbVoNYIGMoAMP/aEmt5oS2c/irNZc6jBaI6JdnVij2xXK63PzN8OrIRu0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5756
X-Proofpoint-ORIG-GUID: LraVI4T3usJFN4Fdkh54bPpljkQoe7TL
X-Proofpoint-GUID: LraVI4T3usJFN4Fdkh54bPpljkQoe7TL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 spamscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxscore=0 phishscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140052
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

commit 0d2b5955b36250a9428c832664f2079cbf723bec upstream.

of->priv is currently used by each interface file implementation to store
private information. This patch collects the current two private data usages
into struct cgroup_file_ctx which is allocated and freed by the common path.
This allows generic private data which applies to multiple files, which will
be used to in the following patch.

Note that cgroup_procs iterator is now embedded as procs.iter in the new
cgroup_file_ctx so that it doesn't need to be allocated and freed
separately.

v2: union dropped from cgroup_file_ctx and the procs iterator is embedded in
    cgroup_file_ctx as suggested by Linus.

v3: Michal pointed out that cgroup1's procs pidlist uses of->priv too.
    Converted. Didn't change to embedded allocation as cgroup1 pidlists get
    stored for caching.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
[mkoutny: v5.10: modify cgroup.pressure handlers, adjust context]
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[OP: backport to v4.14: drop changes to cgroup_pressure_*() functions]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/cgroup/cgroup-internal.h | 17 +++++++++++++
 kernel/cgroup/cgroup-v1.c       | 26 ++++++++++----------
 kernel/cgroup/cgroup.c          | 42 ++++++++++++++++++++-------------
 3 files changed, 57 insertions(+), 28 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index bf54ade001be..aee1af8bf849 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -8,6 +8,23 @@
 #include <linux/list.h>
 #include <linux/refcount.h>
 
+struct cgroup_pidlist;
+
+struct cgroup_file_ctx {
+	struct {
+		void			*trigger;
+	} psi;
+
+	struct {
+		bool			started;
+		struct css_task_iter	iter;
+	} procs;
+
+	struct {
+		struct cgroup_pidlist	*pidlist;
+	} procs1;
+};
+
 /*
  * A cgroup can be associated with multiple css_sets as different tasks may
  * belong to different cgroups on different hierarchies.  In the other
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 4a2b148b900d..a14182e90f57 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -426,6 +426,7 @@ static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
 	 * next pid to display, if any
 	 */
 	struct kernfs_open_file *of = s->private;
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *cgrp = seq_css(s)->cgroup;
 	struct cgroup_pidlist *l;
 	enum cgroup_filetype type = seq_cft(s)->private;
@@ -435,25 +436,24 @@ static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
 	mutex_lock(&cgrp->pidlist_mutex);
 
 	/*
-	 * !NULL @of->priv indicates that this isn't the first start()
-	 * after open.  If the matching pidlist is around, we can use that.
-	 * Look for it.  Note that @of->priv can't be used directly.  It
-	 * could already have been destroyed.
+	 * !NULL @ctx->procs1.pidlist indicates that this isn't the first
+	 * start() after open. If the matching pidlist is around, we can use
+	 * that. Look for it. Note that @ctx->procs1.pidlist can't be used
+	 * directly. It could already have been destroyed.
 	 */
-	if (of->priv)
-		of->priv = cgroup_pidlist_find(cgrp, type);
+	if (ctx->procs1.pidlist)
+		ctx->procs1.pidlist = cgroup_pidlist_find(cgrp, type);
 
 	/*
 	 * Either this is the first start() after open or the matching
 	 * pidlist has been destroyed inbetween.  Create a new one.
 	 */
-	if (!of->priv) {
-		ret = pidlist_array_load(cgrp, type,
-					 (struct cgroup_pidlist **)&of->priv);
+	if (!ctx->procs1.pidlist) {
+		ret = pidlist_array_load(cgrp, type, &ctx->procs1.pidlist);
 		if (ret)
 			return ERR_PTR(ret);
 	}
-	l = of->priv;
+	l = ctx->procs1.pidlist;
 
 	if (pid) {
 		int end = l->length;
@@ -481,7 +481,8 @@ static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
 static void cgroup_pidlist_stop(struct seq_file *s, void *v)
 {
 	struct kernfs_open_file *of = s->private;
-	struct cgroup_pidlist *l = of->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
+	struct cgroup_pidlist *l = ctx->procs1.pidlist;
 
 	if (l)
 		mod_delayed_work(cgroup_pidlist_destroy_wq, &l->destroy_dwork,
@@ -492,7 +493,8 @@ static void cgroup_pidlist_stop(struct seq_file *s, void *v)
 static void *cgroup_pidlist_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	struct kernfs_open_file *of = s->private;
-	struct cgroup_pidlist *l = of->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
+	struct cgroup_pidlist *l = ctx->procs1.pidlist;
 	pid_t *p = v;
 	pid_t *end = l->list + l->length;
 	/*
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 380500251b96..9381100d6770 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3364,18 +3364,31 @@ static int cgroup_stat_show(struct seq_file *seq, void *v)
 static int cgroup_file_open(struct kernfs_open_file *of)
 {
 	struct cftype *cft = of->kn->priv;
+	struct cgroup_file_ctx *ctx;
+	int ret;
 
-	if (cft->open)
-		return cft->open(of);
-	return 0;
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+	of->priv = ctx;
+
+	if (!cft->open)
+		return 0;
+
+	ret = cft->open(of);
+	if (ret)
+		kfree(ctx);
+	return ret;
 }
 
 static void cgroup_file_release(struct kernfs_open_file *of)
 {
 	struct cftype *cft = of->kn->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
 
 	if (cft->release)
 		cft->release(of);
+	kfree(ctx);
 }
 
 static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
@@ -4270,21 +4283,21 @@ void css_task_iter_end(struct css_task_iter *it)
 
 static void cgroup_procs_release(struct kernfs_open_file *of)
 {
-	if (of->priv) {
-		css_task_iter_end(of->priv);
-		kfree(of->priv);
-	}
+	struct cgroup_file_ctx *ctx = of->priv;
+
+	if (ctx->procs.started)
+		css_task_iter_end(&ctx->procs.iter);
 }
 
 static void *cgroup_procs_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	struct kernfs_open_file *of = s->private;
-	struct css_task_iter *it = of->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
 
 	if (pos)
 		(*pos)++;
 
-	return css_task_iter_next(it);
+	return css_task_iter_next(&ctx->procs.iter);
 }
 
 static void *__cgroup_procs_start(struct seq_file *s, loff_t *pos,
@@ -4292,21 +4305,18 @@ static void *__cgroup_procs_start(struct seq_file *s, loff_t *pos,
 {
 	struct kernfs_open_file *of = s->private;
 	struct cgroup *cgrp = seq_css(s)->cgroup;
-	struct css_task_iter *it = of->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
+	struct css_task_iter *it = &ctx->procs.iter;
 
 	/*
 	 * When a seq_file is seeked, it's always traversed sequentially
 	 * from position 0, so we can simply keep iterating on !0 *pos.
 	 */
-	if (!it) {
+	if (!ctx->procs.started) {
 		if (WARN_ON_ONCE((*pos)))
 			return ERR_PTR(-EINVAL);
-
-		it = kzalloc(sizeof(*it), GFP_KERNEL);
-		if (!it)
-			return ERR_PTR(-ENOMEM);
-		of->priv = it;
 		css_task_iter_start(&cgrp->self, iter_flags, it);
+		ctx->procs.started = true;
 	} else if (!(*pos)) {
 		css_task_iter_end(it);
 		css_task_iter_start(&cgrp->self, iter_flags, it);
-- 
2.25.1

