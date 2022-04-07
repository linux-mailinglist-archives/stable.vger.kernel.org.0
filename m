Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BEA4F775A
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 09:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbiDGHYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 03:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiDGHYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 03:24:10 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A9E2D8
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 00:22:12 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23770FKM015774;
        Thu, 7 Apr 2022 00:22:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=Ok8H1IhUcJu1N1fSF4+mewf47REAdMd7GhsXFo8Z3Uo=;
 b=UQPk7t/9Fzsx8mE8faVg+caNVnANov/G/C24a/pIsowF0BmZWiUTCK4Ya/8jcCCqlQGs
 WmQ+ywXivtiAVFtZQnHe8tCuKD7+wmnutR8NjihYiy78Nrj8RGeru5vrTmu5GK+dAprJ
 30y+I28k1Vp/+//2GQx6AzHR+3RUlMmU67ml08aBmIMfJfmiUuUszZtRG7IkYDw+P5/7
 x+5LH+L4LHDo1Vj3hczo3A+KPuD7r3dPOsdio4tRNXccvCH+AvaYUAGBTOHUGCIP7WxI
 vAieUxir/4el6fukqEaflR0p0eVE7z4dIFI7r1DgfCMHuaqjFbo/2RjtxVQmQ+UNw2GE LA== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3f6hs3uxsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 00:22:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fKcMWFrbgnzJu0DZVQOVVXmHJk3dv0tt3cLJjQDQeGUPbeDxBN1jQIYjG/shH0XOD5KHDvCFTcfUYeIRXW/MWq3ti7op7bGv71aWnlzC3FrkkQ+9cFvBP6LrnCyeoVARLtTzf5Nr7XZSkFHZQuTvyM1uWfTev2LPFhwp7STgsGAfL7uuxwUl1IC5DS09kkjj9MWH9bW9LammOF8R1X1Sg/G/URF+Bqy3/eBK4VvGv4TJ4gioFm8rKo5hGxf5Z2HNJmt/NK4tbqseDvascKHSrPfWfMh4wbzgA2FMC/HFf3K01jZgwlKW6pylgUDfyPXXUoH50kCNfBziIpiX5TXyKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ok8H1IhUcJu1N1fSF4+mewf47REAdMd7GhsXFo8Z3Uo=;
 b=hsCPdKb57fVg5ioV7hmDbATrN5BYUh8cqEL8xGeWdrWqwAv4s3mHZg3gDFGAyVx0xCw6gVHmZcdJSqlhp9dHyl/Hj+rlBbleM85lE3BfAVJ4MQAGqRRrLVXoUw/QCyRDEFtO+QlcEMkCFPOjzOYFpwZ0F2VdcaiUxg0NfdXufKcweHkNyjTgbtusGWXRMdmKg0BhwmmIV9DYom5Q58+H96nKtL254EkC4WM8FUjn3cNNM/+P+Eq7CLNhJi8VyybzJPaM7s8YL/eM099kUqusP4NVyzhEJjo19hItXLaq9Uvyrey4WbqfOph67oSuFOyDewO7zMed1WTgAzV05E087g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3371.namprd11.prod.outlook.com (2603:10b6:5:e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Thu, 7 Apr 2022 07:21:59 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::fd7f:8915:60b2:cacf]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::fd7f:8915:60b2:cacf%6]) with mapi id 15.20.5123.031; Thu, 7 Apr 2022
 07:21:59 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 5.10 1/5] cgroup: Use open-time credentials for process migraton perm checks
Date:   Thu,  7 Apr 2022 10:21:31 +0300
Message-Id: <20220407072135.32441-2-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 08307a59-c939-4722-f354-08da18674ddb
X-MS-TrafficTypeDiagnostic: DM6PR11MB3371:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB3371DBD7872C8202C3E0DF78FEE69@DM6PR11MB3371.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iJ5IXMd+4ujCrwIdmx4L7b0HH/Isc5D9kryUx67mlOEKPHEkDK1EgQXspS+8OsCgSieKPkdw0X8VkQH3ZGotmWy6cA1BQFrtARugkESU1bCSJWzdtZPAlaCpcsyBi76iDGlzsAuOP4C0Ozr838CUIzAT5uJYp06n4f7Cahp/3lPTULA7NcDfCU2xf8Rg/eo8YDh3t6G4JicftdgUU3B96fTJnii6UrAlmnk+es0UJcKTFlL1GcCYRU3WSKrOGlOqFd++n/cHaQcqgtbuz3YEwix+/lch4/q2D25m4FjvWqrZF/x25yqV9WKp3AxBd4dXkbJrorjlKpdCPXS8Q+5KWVr8zkFGtMRMp8DOvIgyY4gxFP8fXVKovwf9oWovKhBnmQZDSeS9csiOuLOe2Isc9XKh0jN1kpGDcRYiqy99w044zCrLQ7rgts5kTZm0/6DSIZgzoGZbybzawHr2iKbOd1lNAKjevvmbYksbj9D/2VsdyMzLjdhdtIgO8f8pn0ttktPlRDkbbBZGVi4OpcO+bzuPbhoY7VpwpBoZlLGyqkmkrH/K8h4sUgdqbCuQkJKkD0BGtYRw3NVWptAUYa3A5NfyS3xxTlZp4LOOC+aZ4e2uGTaCXhr7L/w2JPRun38FLFIKOz8hGvVb4xsVzR7fu7JdLtAt5J+jCEROY6RlW/KFimJYLFDHSOAPFYNUr09aFjMhSwlICiZ4shoge4uaIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(1076003)(66476007)(6512007)(66946007)(8676002)(44832011)(4326008)(38350700002)(38100700002)(5660300002)(6916009)(186003)(26005)(2616005)(316002)(2906002)(36756003)(508600001)(6486002)(6506007)(52116002)(8936002)(83380400001)(6666004)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UzdSaDRGZy9WT2VaR1YzVHYvOWUyVzRlM1NNMndBamRaQVdPbVNnMktqZnI4?=
 =?utf-8?B?c1YwVlgzejViMXV3K3hGTXl5U2FBSHRKa3pGL0NqWVVzVnJsTjJuVWVRNjZK?=
 =?utf-8?B?QmxNamNLSGZYdE8wN2ZGS0xvZkQ0dlAzYU1OMHJvWnlvQjZleHJFVWJOV2dw?=
 =?utf-8?B?TnpMUUNibGMzNjB0WU5yalJFRHZyOGNuMnp6L2p4ZnF5bHhsaTdUUjRhV1M0?=
 =?utf-8?B?UmdzNTUxWk5XVnBVZTZiYkdxRzBOZjFoZk44T2dBemE2cnRxZVEwdHQxTmQ5?=
 =?utf-8?B?ODFyeUR1blRjRktSOTBBVTRlZ1ltNXpKYk12UTBjaW4wcDVtcnpXaEpmMFli?=
 =?utf-8?B?Z1dXWkhWVGZlUFdUcnZRYmFkMmVSdWI4NU5VSGZVTG5TY3l6bDI2c2VnZmNN?=
 =?utf-8?B?VENCYXovV2tMTjl0eGE3a1NQYTI3aGc4NGU5QkdYSWJzdXRiOTdMQStSdzFr?=
 =?utf-8?B?d3h2TWxVMTkxRzAvWWJybEhvdUdPaytzMkJUTFBhSTVUT3d1OFYrREZ4a2hK?=
 =?utf-8?B?elVObUpaWFpURDFtVHA3bEwwTGkyNllOMmg4TnkxWWgra0RvWnc4Z0dGS3RK?=
 =?utf-8?B?OXR2U1VaenVMQmRoNExkeVZ0V05tOEJTWHY5UEN3Q2RrRUhOdlJqUmQrbzFo?=
 =?utf-8?B?N0s3ZjJTMDgxY0dsYUlyQ3pGbGdkMzZlZ3ovU0ZLRS90QXk3dnBXMUlEK2E4?=
 =?utf-8?B?cDZkRkViWkc3SFNwbUFaRlh5UGNNSEhQSFhMQXgvMVU0cW5CWDVqbjR0bGl0?=
 =?utf-8?B?Y1VGRnE4bE5UM2xaODBESkFCb0VleUYrZkc0M2JNcnMwRTFOR2VUWXI1aUg1?=
 =?utf-8?B?VVJkNUJXdmlwL1NtcVdMUFYwVlppN1RlL0twM3pBSldpSi9lK1RoUElpM0px?=
 =?utf-8?B?cmJKN3lETUVkUXVZQWZPOWMrZUltM3ltWnVpTlZPdnczRGtZS2FCYkFlK3pz?=
 =?utf-8?B?UFZ1WUVqMEVuVzZpeTRhYzloaHJON1Z3UlMyb1lCYkZCem5rcUZlVnVUUitR?=
 =?utf-8?B?UEZRZk1kNHVwd0hMVENEdDA3L29JZ1hBNVFSTlBCVVJrYXpXeHJxek8yUHNX?=
 =?utf-8?B?aitZMC9tbzZYTHFXZmh1b1NNRXVwWGRxa2RFRFY1R28rdzdpQjEvV2V0dXZL?=
 =?utf-8?B?ZmpoYU9vcTRRb2lyZXYxbGF3d0NWTDRseTZrWGpvemUzbzVpRnRKV1p2NGk4?=
 =?utf-8?B?M3lkdEQxQVMyOEJNQVJRODZYQklkNnp3UkV3RFAwMkNQR1BBbzROVHEzcjNH?=
 =?utf-8?B?YnNBeFFVemxVaThyLzFmampaZldyR0FLZnFvelVZc0lETTJrM0RqMEQ0QWsw?=
 =?utf-8?B?YmFPdTYwNVdTUEI4bXBpTlFTVmNwcFRJUjdMWmxqOFpxc2RJSU1wanBJd3lE?=
 =?utf-8?B?YTNTVU1LQW9XK1RoZUE0VlgxWTRPQTRmUVFzS1R6dFdqby81eFNYNDQ5Nytz?=
 =?utf-8?B?N3ZjZjdnajRodmU3c2NMY3lSMGRhdUNqVThrdWxKa2NQZk9Sc2E1N2FUeFB5?=
 =?utf-8?B?TVIwRnIvTzdzM3EzZDVhdzg1S1N5WE1VVHRYcnFGSHNIWWN0N0lpdTJuQ24w?=
 =?utf-8?B?QmdGRnFPV1lLZVEybGRVcjVDME1ZODh4V0ZralRFbXI3bDVOYjdjKzEyMXp4?=
 =?utf-8?B?blVYT01QQ1VZQklxVUhUa1o0QVdUek05VHpnbzJaNnZKdFNucTZ2eXRiZjBo?=
 =?utf-8?B?NjZxdzZyM2dkSTRKVEphNlViNlZzSWRENnJFUGRVZkdsb3hHd0tFWGJZa3hT?=
 =?utf-8?B?VXI0NW9aM3VoQloyZVJ0TTlINitzUytXV281ejJUZjk1S0cyZGx3NTZsQkxJ?=
 =?utf-8?B?NGs3NllXV0RaczhQWGVNeVZoaW52RTRpak16ZmxoZE5CTEp5TmtpYTFnMVBj?=
 =?utf-8?B?RDFHbERpK3Ruano2SS9LMEpsZXNtMUZmbmlDQlpiNFV5dFo3UHQxc0JpbHBV?=
 =?utf-8?B?WWNxS0dRaDNtai9STnRTL015NTJSa1BTYys0VXFPKzJDQVVqSXhsRlFzUnFI?=
 =?utf-8?B?T0FMUzhSRXB3cFM3QnU0VTlSMm1mUVhuZWpFcUw5d29CeU9vMUsxSVB2Wjl6?=
 =?utf-8?B?Tng2VFNBanRTQVRuVlREZTQ4aXZZU0JibVppM2pONjd0eEhDNTg1TFFobURk?=
 =?utf-8?B?R0dFQjZPYy9lRkdTdVVHdlczcU9uM1hsYjhlc3ZoUWpVN3JVenMrZ052eGVW?=
 =?utf-8?B?U1JrM3hNOU0zWmx2YURlMTVWdmYwZTB1c3NQUWJmYkRWYXJINW1FYUxlU0R4?=
 =?utf-8?B?L3BheXBHVVp6RVROanJpMG9GTURFTDFsTU5Yck9Ca3U5VkpiT0t5UU8wdExL?=
 =?utf-8?B?SXJKWnc4bXdGV3g5ZGpvNGdRQUZjb1oyUGpmaERnS0VOYTRtVkMydjZQS3JB?=
 =?utf-8?Q?TH++MOL2ebfYHrQo=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08307a59-c939-4722-f354-08da18674ddb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:21:59.5179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9bo86Vgvo3SsUKu1KUvE/6rBgFCtrV2ZnTAZVhA9tVjXnNYLS2pwDMoTSikMLZ9etVBPF7MLW2aA5DFbCpJRAYY8yyYh4O4y2Nr3pNBdm5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3371
X-Proofpoint-GUID: wxXouWS-L7JBC06JglN87NJzWHcJECAR
X-Proofpoint-ORIG-GUID: wxXouWS-L7JBC06JglN87NJzWHcJECAR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=876
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

commit 1756d7994ad85c2479af6ae5a9750b92324685af upstream.

cgroup process migration permission checks are performed at write time as
whether a given operation is allowed or not is dependent on the content of
the write - the PID. This currently uses current's credentials which is a
potential security weakness as it may allow scenarios where a less
privileged process tricks a more privileged one into writing into a fd that
it created.

This patch makes both cgroup2 and cgroup1 process migration interfaces to
use the credentials saved at the time of open (file->f_cred) instead of
current's.

Reported-by: "Eric W. Biederman" <ebiederm@xmission.com>
Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
Fixes: 187fe84067bd ("cgroup: require write perm on common ancestor when moving processes on the default hierarchy")
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[OP: apply original __cgroup_procs_write() changes to cgroup_threads_write()
and cgroup_procs_write(), as the refactoring commit da70862efe006 ("cgroup:
cgroup.{procs,threads} factor out common parts") is not present in 5.10-stable]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/cgroup/cgroup-v1.c |  7 ++++---
 kernel/cgroup/cgroup.c    | 17 ++++++++++++++++-
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 8f0ea12d7cee..1a0a9f820c69 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -505,10 +505,11 @@ static ssize_t __cgroup1_procs_write(struct kernfs_open_file *of,
 		goto out_unlock;
 
 	/*
-	 * Even if we're attaching all tasks in the thread group, we only
-	 * need to check permissions on one of them.
+	 * Even if we're attaching all tasks in the thread group, we only need
+	 * to check permissions on one of them. Check permissions using the
+	 * credentials from file open to protect against inherited fd attacks.
 	 */
-	cred = current_cred();
+	cred = of->file->f_cred;
 	tcred = get_task_cred(task);
 	if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
 	    !uid_eq(cred->euid, tcred->uid) &&
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 3f8447a5393e..0853289d321a 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4788,6 +4788,7 @@ static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
+	const struct cred *saved_cred;
 	ssize_t ret;
 	bool locked;
 
@@ -4805,9 +4806,16 @@ static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 	src_cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
 	spin_unlock_irq(&css_set_lock);
 
+	/*
+	 * Process and thread migrations follow same delegation rule. Check
+	 * permissions using the credentials from file open to protect against
+	 * inherited fd attacks.
+	 */
+	saved_cred = override_creds(of->file->f_cred);
 	ret = cgroup_attach_permissions(src_cgrp, dst_cgrp,
 					of->file->f_path.dentry->d_sb, true,
 					ctx->ns);
+	revert_creds(saved_cred);
 	if (ret)
 		goto out_finish;
 
@@ -4832,6 +4840,7 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
+	const struct cred *saved_cred;
 	ssize_t ret;
 	bool locked;
 
@@ -4851,10 +4860,16 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 	src_cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
 	spin_unlock_irq(&css_set_lock);
 
-	/* thread migrations follow the cgroup.procs delegation rule */
+	/*
+	 * Process and thread migrations follow same delegation rule. Check
+	 * permissions using the credentials from file open to protect against
+	 * inherited fd attacks.
+	 */
+	saved_cred = override_creds(of->file->f_cred);
 	ret = cgroup_attach_permissions(src_cgrp, dst_cgrp,
 					of->file->f_path.dentry->d_sb, false,
 					ctx->ns);
+	revert_creds(saved_cred);
 	if (ret)
 		goto out_finish;
 
-- 
2.25.1

