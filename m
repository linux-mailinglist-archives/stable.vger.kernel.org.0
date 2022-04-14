Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4735D5008AB
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 10:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240147AbiDNIr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 04:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241086AbiDNIrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 04:47:55 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4034D65839
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 01:45:29 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23E8MH9n025116;
        Thu, 14 Apr 2022 01:45:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=ts7Z8njnkOFVxjvFPeCfq/833UlNERCqNgu/1Qsxwbo=;
 b=cJaJeIPgWqIO3qUU/mQv+5l52WZXXos+zIWEhoVpr/VD0mBZKIB92c07h0OBXp73LKQS
 84zULGsmye+wRze5MRRZ/E2NOjRdHFqA284fKTu/OHa/hjnGqCCX9X2lrnfjjN19IhBP
 gxA74kTgTYCyKe61Ur2tFygt3mjsvaYHIquxYDtM5yXTAROMcCaxlBu4Tc8qSVFmY5hX
 NbQmVnVisw4V3b+7gqnnsml1Xkp9iO2PCbGCkkxKnRxvwyR3UI8rH70Qzn0i1S/1n9bK
 BfVFoRhpSlA8lxibBblYR3uw5R4IInsmOSwJstXqicD4tVrDhQIfC2RChhf7jDtBXEz0 9w== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2169.outbound.protection.outlook.com [104.47.73.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fc0jeb4hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 01:45:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VDWKcxmr/9AfUZXuqzo8Shr8lMBSfIersSMO3LXx+4PFKkRn4OtpgltXIq/gMS9nUzlGNrNXe5hh7JbYfHCTH+32D0R0gTVk3lhfGW7L4O3PAftTRI2Up/GDqgHdHnYAaoIT8dQYMMzMe6Ew9CZO/tc5yiWVXRDUf1yZAD/fkJzBANbpDMLWM3W5o5t6lTAZmE2N2xQZFoB58xtj4zSKWUfLeDte+KoFTimmVcCrvHIl51p7ADlnlIGZDLtPtOfh1613/+49bBUE2rCV1OY5f35VEa+P/gtphnVRsDDBfA/f84z5bIgXvCtIfcDxBH74WxwNPgi5J5/ZqOtX0w9wPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ts7Z8njnkOFVxjvFPeCfq/833UlNERCqNgu/1Qsxwbo=;
 b=V0t6rHyWWYYOpXklR66QMCG9jfBH0eUSl6xcFSp8TEcRlLZKIJBpwEsJk45gksFLXxTpW9kkoNt34QlFEcqH0Vqs5msWJvirpPvNhm4ugUOgKnzVmUF4bvGLgzksvDPlaLALs+WKxKnezeJzpcOLZRB/zqYBQ6X09neA2GyKGmBOmZnm44qUUaT5sY6kW2C4O8yTLIOoH58AQBRzoieeZ2A/HuUg9VoKvvYyEyXtLfo6WOpOPOHR8Xj2NDCF94vWWPvh9/EuNcx3XCTD0m/LzZKrxC8aW7I4owZf3ePlqndPqeu6f9pfeHBCBHyxXO/VWzex2lwPS2eiI7H3CvBmfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3435.namprd11.prod.outlook.com (2603:10b6:5:68::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 08:45:13 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 08:45:13 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 5.4 1/6] cgroup: Use open-time credentials for process migraton perm checks
Date:   Thu, 14 Apr 2022 11:44:45 +0300
Message-Id: <20220414084450.2728917-2-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 686b5d7e-5271-4187-0b6f-08da1df3179c
X-MS-TrafficTypeDiagnostic: DM6PR11MB3435:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB343533886BEB7D27BC90FDEEFEEF9@DM6PR11MB3435.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O13a/vDJv2eS7P/LkeUypowghQteGVFTEnEnWegib9PeCw8jQJNepZUjjvBGHCAY49m3aNzWM3k5smQA/FNRunMxUDyCXs8BNQQp1QCB+BHu/kAXEbsWAvVIE0n4Xl2v8iFnaM72RcIUr2uL722T15C7D3AsRhTy40DRpMOMTfSwsOFi8mJun3NOCB3iWtI/+v0PldL1Xa1NtEZ2jkscvED2tB0UjxFBukrCmKxD0RigQlORUNYwvLverfWXSkcc+W7pMYZWy2FGApMQxZ1twMq0XVcWOZpEqFpXDQYO25hQ+i5ldgBN7KII/+t2WRxt7OXdXoTA/wXspPNC3W9FlzDO3q87wU0ZNWt8pKDmYPxjZZSqIU/wJi/WhtZyXO3Ei3QzsZ+Lt0arO99qZJiD7gATgI9eQrrUuHMDEe0F4qk+IOhjVa8gP2O+74UkxxkObprnCCazC3kwVrDpyR+zBEyTcyLSTneXV5JrALoESpEaui93h7FeTtoVv9oKshbaBX8KJwj8y4Yvi0doHVXCLDCsYskgLYWoBFnb6pYfFQqBjB3Vxg1bG2EB2aO2IwlKuSkBugfu40Hs5Ko13ooTwiGBaevaGzndLW45h+jY9d29PwiX2/yQ9++BgthrgiPAveJK2RzWPSaZqq0ddkDo7Pl/vKfQntiWJI5CrFS/uVsLFucl2tevYJ4qOwAL5aKfPigqeM3OAnewaEaXgGYcAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(26005)(6666004)(316002)(86362001)(1076003)(52116002)(6506007)(2616005)(38100700002)(38350700002)(66556008)(66476007)(5660300002)(66946007)(8676002)(4326008)(6486002)(44832011)(8936002)(36756003)(6512007)(83380400001)(508600001)(6916009)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmVuaVVBcW9PVVFWaVRndy9OMTdWb1NnMXVCMU82UFVIc0lxbHRQK1NMbjdZ?=
 =?utf-8?B?ZVZtbnEyN2xrWmVCVGxWTk9mQ0RvNi8xMGJsbUF3dVJqTGd5ZFRTR2JLZGdl?=
 =?utf-8?B?a09BUVhvSU9kLzJ5M1BUNFZyMHBpaXlvckFueE5oL2Z2YnUrc1NRQkpvdFVn?=
 =?utf-8?B?d2xjQmlpTHpwVDhIT1FjUFlsRkpRT0VoUEptcFlJNXBCOCsxbVM3SjdSWGZI?=
 =?utf-8?B?bG5ucUlMNXhoODZwZDNieExsYmw0UU9ZaytOQTdENC9MZzZsc092cFNXeXc2?=
 =?utf-8?B?KzRlcENqSUJjWkovOXltZ2N4YWlVaEpnRGp2enRXaWh3amJDZE1QVDZxUHpC?=
 =?utf-8?B?S2JFeVR1TnMweFlkRU5RQlE5NXZ4bXBHLytCZ1FmbmhtRksxb3FBLzB6dDNt?=
 =?utf-8?B?WWNiN0RmakpEZWlvWDhvc0xNRkwvamR1V1h2OGgyYmhKclRPWnM4NXF1aG9l?=
 =?utf-8?B?anMxSUkzQXAyb1FiSmpqakFtbjFVTVRLSG03ejdRL2RDbmE2c2xlTiszWlBL?=
 =?utf-8?B?SkNQSnBWTnFZN1IwS1dvV3pueFMxZHI1b0IvZmJMeGdsanlkRU45ZWRBT2dx?=
 =?utf-8?B?Tmx4SFVjZDVyRUtQckxkVVMzakhoc2NmaFp0Mzc0dHhmWS92Y0lxUUZpQnZm?=
 =?utf-8?B?TTZGQjJvK1YxaUNyS3Z0WVpDeDdwNGpzeHcyWVlYb1lwZFRTbGw1eGZHRlZB?=
 =?utf-8?B?UHR6eHhLYUxXSWhXV1c4TXBSemI0c1RsQXNjWHZFVmhsT0FzVzB6b04xNzZt?=
 =?utf-8?B?b0ptck5wMVF0ZDVSb2FmY25CZzFiSzFQd2tNYnpnWndHV3NzejRucUpRK3Bv?=
 =?utf-8?B?VGVZUVdpeEdlb29OZ3YrRWd0WERvQzZpcTl3K0NHSDkvUDIyWmxLdnlHdlB0?=
 =?utf-8?B?QktVTnFQWXFydWFyM2xvejlnSjNrTm1mKzhPbVNYNVNYS24yQUo5TWV5MCtS?=
 =?utf-8?B?eC9SRDBIK0R2cFBuZWxiZGExV0FiaFFSMGpTSXZta1VFSUorbjhCVzc0bmor?=
 =?utf-8?B?d0NVTDBzZHd6aklrL0U0Wm1zbVk0dEs2d1FVeEw5bmdRd1BaNXVrd0ZzajFp?=
 =?utf-8?B?UGpKTzdNaHV1TENJaHJacitnZHN5RWFaUzZhUDhveDF0ZFRvNjJrWFBobzBR?=
 =?utf-8?B?dXNzOXM0Qm52TjlNVTVkUEV1TkJHd2d2Q3UzcG9Rc29wbmZUOFlhd2UxeEFQ?=
 =?utf-8?B?WWMyZDFhaFF2ZG5xWUE2cmoyVjJSMk00dkVYMEFQMzJrbEk2enJFYWpIYU55?=
 =?utf-8?B?bGw5Vk1hNEpWTHdzaFRXdlhjNDBDNG5jVHlTQ3cvc0craDBBdkpvUlIrOGZM?=
 =?utf-8?B?VFVUUDNuYVZvbE1nN2dxTExFMDJiRFJjSENydlFUVHZONHgzNmp4Sm56dDh0?=
 =?utf-8?B?UTc1VFI4NFp2Y1Ewb0hSckhnL0VSejE1SHBsRkx5RkNhTDhvKzhJK0U4Z3RW?=
 =?utf-8?B?ZGhzYlRPSGdRNktGWDVSclNRaXZGaEZGL05vQjF6VFRqeFlEV01GbkNFeTFV?=
 =?utf-8?B?eDJPOXZrR3I5NUMycUk2YWplQThLYk1jWXBCSnN6bkF4YTd3K0NERjBCOS8x?=
 =?utf-8?B?dlNRR1dmUUZBcmNENlZiSGg0ZElhQ2pSZHd0UldDSVA4NFRPVENiVVJzSWhz?=
 =?utf-8?B?a2MzZkR0eFdDNFVQSUh5OXRnam5QM0lvNE5WbmRWd3loTlVQRXVrdUlCcFJ5?=
 =?utf-8?B?VzUyVEd0cUJieEZFR21rNFZSQzJrbzRkMjlLMkZlSm5nQVlHUnZHVUI3SUt0?=
 =?utf-8?B?WnBWTnlYMXdoZXNVK3RSWTVqQWl3ZjVqKzUxcVVUUEF1WVhWeU40MTVZZStT?=
 =?utf-8?B?T281alcxSXh5Qk5BWW4vdERFeWV3SVZ1QWVqRkdSYThEaldibzQvUkY1M1FH?=
 =?utf-8?B?ZUt3L1dFUG9ZSXcrWkhiTWNoK0QwLzFlVG02TU1vSU9GMlVEVWxEMGd0Vmdk?=
 =?utf-8?B?MzlodXVadVgxNzlwZWZwMmNic3ZqS1NkUFpFRXQ0SVBhbVl3T20xQkVIZGUz?=
 =?utf-8?B?MmhHWDdjRERYbC83MkpjYXFHc0o0SDNDZnNHMVhqOUNQVEg4eDZBYTFNajJL?=
 =?utf-8?B?RjVKZUdrUFVSRHVZK2JyMVhRc2JzZHNQdVpvL1JJWHY2TlJLWmw2WWFjZEhU?=
 =?utf-8?B?YjRkd1gyTHVFUjdSV0svaFhLaGRmMWRhZVZmb3hueE9ON2owNUxLeDd4aVI4?=
 =?utf-8?B?d01sczRxdDlTRFdPZHIyeGN6NmJqZ2RyTXpyRnZ4STAzQ05ydXZ2SmZNVzBK?=
 =?utf-8?B?TDNGWWFia2dxd1BRL1Jqd1c4ODdGWFMycnQ0QzhBKy80ZFpjak9SbmZoOFpO?=
 =?utf-8?B?ZFNJYU5PUDlnOWlwKzVreUU3dXRndW5oenZHTkc4c3d6NFl2TUo4SVlWK1Zr?=
 =?utf-8?Q?k8RG2NCeh/tYEqX0=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 686b5d7e-5271-4187-0b6f-08da1df3179c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 08:45:13.8256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SBDTjRMmyzzlkbRdnB9gxz3ZH2s+PqkpYJGqBaFzi4bvvxd4urZQ452S8mYNkYvaWPz8vqo4qiFoGAY/VSxfBTvouAsjjpGAxOhei88+Iko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3435
X-Proofpoint-ORIG-GUID: p2hlZLkWHUGhsPOB6QheadRA_k6q7c1J
X-Proofpoint-GUID: p2hlZLkWHUGhsPOB6QheadRA_k6q7c1J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=768
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
[OP: backport to 5.4: apply original __cgroup_procs_write() changes to
cgroup_threads_write() and cgroup_procs_write()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/cgroup/cgroup-v1.c |  7 ++++---
 kernel/cgroup/cgroup.c    | 17 ++++++++++++++++-
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 5e465c4b1e64..413b8bfc0ff5 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -507,10 +507,11 @@ static ssize_t __cgroup1_procs_write(struct kernfs_open_file *of,
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
index ce1745ac7b8c..8c5f7b346abb 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4798,6 +4798,7 @@ static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 {
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
+	const struct cred *saved_cred;
 	ssize_t ret;
 
 	dst_cgrp = cgroup_kn_lock_live(of->kn, false);
@@ -4814,8 +4815,15 @@ static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 	src_cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
 	spin_unlock_irq(&css_set_lock);
 
+	/*
+	 * Process and thread migrations follow same delegation rule. Check
+	 * permissions using the credentials from file open to protect against
+	 * inherited fd attacks.
+	 */
+	saved_cred = override_creds(of->file->f_cred);
 	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp,
 					    of->file->f_path.dentry->d_sb);
+	revert_creds(saved_cred);
 	if (ret)
 		goto out_finish;
 
@@ -4839,6 +4847,7 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 {
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
+	const struct cred *saved_cred;
 	ssize_t ret;
 
 	buf = strstrip(buf);
@@ -4857,9 +4866,15 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 	src_cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
 	spin_unlock_irq(&css_set_lock);
 
-	/* thread migrations follow the cgroup.procs delegation rule */
+	/*
+	 * Process and thread migrations follow same delegation rule. Check
+	 * permissions using the credentials from file open to protect against
+	 * inherited fd attacks.
+	 */
+	saved_cred = override_creds(of->file->f_cred);
 	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp,
 					    of->file->f_path.dentry->d_sb);
+	revert_creds(saved_cred);
 	if (ret)
 		goto out_finish;
 
-- 
2.25.1

