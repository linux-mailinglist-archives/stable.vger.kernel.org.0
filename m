Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F8550094A
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 11:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238667AbiDNJJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 05:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240800AbiDNJJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 05:09:52 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D946D972
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 02:07:28 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23E7VnPc023485;
        Thu, 14 Apr 2022 02:07:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=dXXZmZtQ+nG5zP4Th1IEnbZbI/Y/0w4eck71rqplxHE=;
 b=XkCwaI25BSqh4zEv9MxAU0j013fKmWZMOYx7Trtk/9SNHXBi2JaYjTDavTdJdECHW9mC
 N692zu/aqfJftZhWO1UUNcAK68WMvgTL2ONTAjwwkn66LOVmRNcrDvpQbfxpY7qCYFjs
 xhkZaoR11QSeUMJr8teNa1n245pXzhh5XNz5Xk7DlUB3DpJfj6OptUZPHp5gG+K6GOOf
 wgihQolnzjwiD3TUYWZX6E7Q+kVG8VcWyuCq0mU4iBpwonGAvYkIGTiTwxARC5Tau9PV
 C59iUali3oFOGs72ieYZaVUd1Hg+4m+yR7nW0NbnKsihmwJ4me9lpZjkOAvEvFMG0tT9 rQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb9nfurtg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 02:07:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B2GefN2OxU6fhUeqaphy5iw/QW/FNll8j6Iu80aLg8AUSjnhBATUI6n4SIF/B6fV5Fartfz2RdZjouEiWRax/gWE0MNU8n30zC+KyGcDKlYv3uwv38OmsiVbHYSBzF+q5Xy3lyh0ODryF4IrkxNlqZmrh5Tb+Oe88G44ME/HxQhBR3MUWHSbXLz3sLaapPmG8EhCB8EaK2qXwGpb4Kc4/p3kqI67XlhIvJd5TaRKjb3CA5PBGQEpbgwpoF+IlZiODCKncvC3VXEl8T2dfWw/G3b6ZeSu1ZSGAh8CiAJOLMJ6cx1sgjed1RoSz70iKUfJIJbkUeuJinB0+R3/lVgM6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXXZmZtQ+nG5zP4Th1IEnbZbI/Y/0w4eck71rqplxHE=;
 b=DiChFx/+bJEx+HEgzJ/kGH99cjGBGAd3/RB/gHtk3Dd/7MY9FuPpQF6uxn/JJpadRdPk+0CdVvOYRIjyhBAdhQZXR250cJaPvMSZ6MXzVD8hXKn7JH2JPiM6uTnRhPC3UBvfs3YvRicZVRJ3P8EUo9ANiDhFAVfEo1z15vutG6Es1Y9rjNcnxImGx1C+nn+XnlYsAis4kWeXtN5q4MzOL+3SZ6Iar9pvtR519oRDoCE1gBpsfpKKjTzr0ZxUPFtjifKGX+Psd1eFJZ1oLjhpux47RVC9RerXdNaGaSweceJyV0YWmMxKolG7oQ23vCrQxyI+G2hVdjfo1DWM7m7UEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BY5PR11MB4356.namprd11.prod.outlook.com (2603:10b6:a03:1bf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 09:07:21 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 09:07:21 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 4.19 1/6] cgroup: Use open-time credentials for process migraton perm checks
Date:   Thu, 14 Apr 2022 12:06:55 +0300
Message-Id: <20220414090700.2729576-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220414090700.2729576-1-ovidiu.panait@windriver.com>
References: <20220414090700.2729576-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR07CA0263.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::30) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8d76eb8-d084-4554-e976-08da1df62f03
X-MS-TrafficTypeDiagnostic: BY5PR11MB4356:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB435617B7146E773BF0A451D0FEEF9@BY5PR11MB4356.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PFa+iSbPRmlf+qU5chLVveiVR8f6fEpd0w/Q3egl7y8P++e8t2aNDmfzzT9YzpB17psKHcjYo3O5IsHU7I67qGjFsTrzN+AiKfuI8iOtjSbXhNo7V5MMjayDWBsdoLhxsT6sQfM4DtKWpiq0+kd9wIaoGLI0aff0q3H7jVxEUpIJXeP5f5GOK8wIYErKTUYLYXns4i+0ND6hgG691/7S3LM7g3XzMG4fyhbxZon6I+n0a3KQ/hvShOmjLS8zKK+vQYaVhVxIvOS8OzA9d1bWQxelU5CWn0ZJJ9d/XcRREbkwFMctfuTKP2dPZ9Gh/wY7UPFU1oQsN2xfn+QWCZllTI/GNQMrKJKWs69NfhXwwp/jmxe5dKpjl7ZKEYqO9K0yIQOi3km5mDJKKNDVR+TysNYwysPLenp+VmpUSwZnb7R+6vaH78UAuXHcZthi6eo3U7+JzLRmtb3SWA1bWbqfJrfQ023d4QtE/PQAjVO8QRuRaCh2Z35RaOMWrRRASfUmWj9+I6ypJlPEy5yOSifXAwexjUUoNZ1nsMRJfQj6YlAkjGmpfzkVmejnmdbXOvht6ML+0oIIwUAdycMjwGdY2nKstkDxcZeCPuIefi3vxafCj6kabgCYluvRwEOeecZdpf1bjVpmo0aaDFyeALTch0x0nANHuXuCi4+jyEGtQs5VKvAGZU/Lu4/Ip4sEy7uKqxxoXpcVKdkx1ji3q6H8yA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(5660300002)(52116002)(1076003)(186003)(8936002)(6666004)(26005)(36756003)(2616005)(6506007)(6512007)(508600001)(44832011)(316002)(2906002)(6486002)(66556008)(66946007)(66476007)(38350700002)(38100700002)(8676002)(83380400001)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWZnK3BUWk50R2IrZlBUbTVLQzc5YjdJWHhZSTVXU2laWHpRVlNLdzBGMlpQ?=
 =?utf-8?B?RUFSR29MMHBRMVg3NEVLOXdISTA0ODVLZU9iYXE1UVBRUmNyTEZHQzQ2T0hy?=
 =?utf-8?B?aFFVUWZTd1RHNS9IT1UyMUxGVDc2S0dEVDErSmx2TU9vVUFnOGh2L2ZueEF3?=
 =?utf-8?B?WTJ6R0R0akkwbUNIZm9JRC80Yk5NSlJnWE5JUmRHQkRLRmg5U1lIQXpHU3lG?=
 =?utf-8?B?U0h5MW13Sk1SODBxdG4weDNwK3diT1NqYnpRUzZtcmg3MWE1MTN3Y1V2YzhP?=
 =?utf-8?B?NDJkeWVaY2cxQ3U2MGZPdGtUOCtOeWpXcW80aFdJek9wdkowUThWa0FIM0JH?=
 =?utf-8?B?YkVudHQ5TWl3TWYrRmU4OGgvVGlNdGlzQ0ozSDFXWHJicWdXaitsVVRDNnB6?=
 =?utf-8?B?MlFzZzAzeDZmV2ZZV2dCYVIxUldrMXBPLzFMN3h0RmhicXdGTzJtS2RhS3FH?=
 =?utf-8?B?R3hlSm4xZG4yRHROclM4WnRRTjMzNHh2WXJoc1Bic0wySUZNMjZnOFhrRVc5?=
 =?utf-8?B?NkpicitBMlNaRjZuUGkwNDgvdk1VQjJTcnExcTd5RmtHcCt4NTVmbThLZ2g0?=
 =?utf-8?B?SjdnM3NwU3RUaFdlMEdJS2lSaTlTaHBlM1dnRHhLZkxKSzQ4ZVh4VWVGUFpH?=
 =?utf-8?B?SmVmZlJuODNoek5CMWg1dlk5VU10a0s5cDZtY1JFeFljMDRuZlo5dEVhcFBl?=
 =?utf-8?B?c2ZvNVhGUEZoYXhhbUJCc3pzQ3BkWmJWWk42eTZwTTBENWlvbjZ1WWwrbDc4?=
 =?utf-8?B?TXVhbHNqNElZeVNyc1JYNWpLdmRPbGhBUG1sVlA1RkhyZElabnpnRG8yNmI2?=
 =?utf-8?B?OXppTGR2RHcvRDFiYVJSQ0J5QXAySFVTNFQrb1VHQ3dHWnRxT2ZyL1ZpSjdG?=
 =?utf-8?B?Ukpya003Y2FrMTUxcUlEb0J1YmR1LyszTWpiZWRhVlI0dHRtMitlSk5zYXJV?=
 =?utf-8?B?WGRiUEtBSk5BQ1dzcTI5WFp3R21ZOUU4MmcyUDRxTVJHMEhqY2F5SEVDSGVn?=
 =?utf-8?B?YUVaVEVHK3pNM3lvWXlVdzcrRVhRc2JZcXlod1IyRCtYQ0ZUYTN0WUlZVXVn?=
 =?utf-8?B?UXVKL1ZRTWRqaWgzS3V6ZGhocXAxNlVVZDdlbThLaCtoWFVYNVdocmVLbHNq?=
 =?utf-8?B?bDUvQVBtcFdEMUlaQVZLUUpVRGJHdnMwbnh3cUJYZ0trL0hhUzJaT2R4a2Vx?=
 =?utf-8?B?OElKeDZ5TS9tdTdnNnFQVUVNUTJmQUJpaHNPOWNSVHdPYTkzS1RlTEZteHFT?=
 =?utf-8?B?THVrZUxLWlh3aXdFMGlkZFVQTFovQnhpWStCWkZOckJBQzRGK0NBRGpNd2xk?=
 =?utf-8?B?YktMK3ZuMmhXZFJySGF6UGlvdy9yckJQUGowSkVJcmtlYmQ3RWRHOVZCSFRV?=
 =?utf-8?B?M1hTekU1RlNVUW5LczczY2t6VjhWcjVGRU1Tbko5WWN4TmNHaEFUN2NqV3NY?=
 =?utf-8?B?K01mVnFVOUpRTWxzZGFTRmxCU0VQUng2K092QTJpUGZaMHNpWEp2SUlFTHUv?=
 =?utf-8?B?emxHamJscUt6YUh2RWdXMUR4QWJSaWlITUk3dTNEZGFMTHpTV2tZdjhCdVVR?=
 =?utf-8?B?YU8rbHlxaWQwR3BFVjhpd2UzaFRnd0lOMWhWZG9lbE1uVnpYR2xFZzhLaGtL?=
 =?utf-8?B?TzZyU1dJVzN6czJERkRXUkQ2STFQNlVZeXhuTU1qZEpUVVZvcVk0RDZ2U2Q0?=
 =?utf-8?B?VXh1cGozbEtxMHFIR1BYM1N4Z21tbXRYZUhqTkkvUS9ra0o3OTQ3UnNjeHhv?=
 =?utf-8?B?OVd3M2g5MW05dzlZN2p0aVd0QVpUZXNVbndhVDJheDZXWS9zRnhHU0R4VU91?=
 =?utf-8?B?cXdtZUgzc1R5dmUyWFA5QVBIWGFIcUw4cTFOQjFHYXRMKzc1a0xzcFpqS25z?=
 =?utf-8?B?cDlJMnpMT2pYeVRweE1VMk1XTHVhYzUrZEE5QkdYNTJUZW5Hb002Rld0d1dD?=
 =?utf-8?B?RE9yUnZpSDRQeElUOEVWQ0ZxWHBrRkp4VFVpN0hvaXJxM1R1R0c5cEpXY1JG?=
 =?utf-8?B?WncxdjJYNjhmQjBSbWNhNkVPWWZxdTdpeUwzTDAxSElyM0Z2TENGYnJmOHlR?=
 =?utf-8?B?QjFpVmFRb2VNUThXcTRVVkNpUXZHRnlCdmZMV1VETlhwN0RNaWF4TUdHekRK?=
 =?utf-8?B?WEx2RW8xNTk5aW1MM0s2WUFJdHB5Zi9Pbm95NFFrN05ZZEJacEUyZkZWclMr?=
 =?utf-8?B?eFpuZWNmNHRBL3ZlNHNyTEI3Y1JOZytNQWJGZU00SHlmZE1ZYnRuMUQ4Tmh2?=
 =?utf-8?B?UkpETzVtVXlZZ0d4MjZNMDRZQnZUcmE0bnAxaS8xVnAxS1VLVFdCaWlmcjU3?=
 =?utf-8?B?L3JlWGhYNmxLOVJSQXlSeENNT01tRlpYS0J0VDBzdThmTWhnejhkNWMxekxn?=
 =?utf-8?Q?yfndGKIuUAMIEeMQ=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8d76eb8-d084-4554-e976-08da1df62f03
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 09:07:21.5698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cjUphoy9qdSKUp2PGXsFKf6Q7qYiD/AlUuGYu39uBKQE/n9iFBCamWdV/laHeTR9nE3H2fix2CzZSNEYAaVmv+M8JTt/nY/tctJGYohxYdM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4356
X-Proofpoint-ORIG-GUID: Ittd9PjZylm7srIoW4_IouILgvmEzWPd
X-Proofpoint-GUID: Ittd9PjZylm7srIoW4_IouILgvmEzWPd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=768 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 phishscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140051
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
[OP: backport to v4.19: apply original __cgroup_procs_write() changes to
cgroup_threads_write() and cgroup_procs_write()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/cgroup/cgroup-v1.c |  7 ++++---
 kernel/cgroup/cgroup.c    | 17 ++++++++++++++++-
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index ced2b3f3547c..7fb6b3ad75ce 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -535,10 +535,11 @@ static ssize_t __cgroup1_procs_write(struct kernfs_open_file *of,
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
index 63eff85f251f..1bac7c56f648 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4487,6 +4487,7 @@ static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 {
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
+	const struct cred *saved_cred;
 	ssize_t ret;
 
 	dst_cgrp = cgroup_kn_lock_live(of->kn, false);
@@ -4503,8 +4504,15 @@ static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
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
 
@@ -4528,6 +4536,7 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 {
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
+	const struct cred *saved_cred;
 	ssize_t ret;
 
 	buf = strstrip(buf);
@@ -4546,9 +4555,15 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
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

