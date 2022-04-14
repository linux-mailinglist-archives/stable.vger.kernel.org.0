Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A6C5009BB
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 11:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241739AbiDNJ3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 05:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241730AbiDNJ3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 05:29:03 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680476D4D4
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 02:26:38 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23E8pF5H001147;
        Thu, 14 Apr 2022 09:26:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=Ck4DxZcMDFVexRYxaGwLIloleTAigYzT/Hhe8EotjNk=;
 b=gA2y6P6OY2IocwQumjidQzniJMiJXCejbALSXAyglkM080maX7hJPbvwAObpbgHT5ewv
 cHJItlSTBAhcvQw67Y6+oywb+PG/OSN/5ic2HRYOwWuWHh3s/jA/Kh5rE+cRXCxuyBd5
 RcyiZcJ2XR/Mit/xuZQv0/43Y4KXqUx1tmBIMQ4NMML8fGM2bTN/g7HJMvTvPuUNVEOK
 L4S+w45X2j2tab0lJ5BOMkFWL7TJKlgHL4dGok11XYofaIM6uTfYC5n7y0XymAQm34fV
 xmGI17PklJ3NxYoVK9eK1XNUyp31PmLV7k9zwSzUysc/mGTWIA7FHDhpTZFGi7QjHffa Ag== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb6fwbueh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 09:26:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLYVzc8/fWf3ADULyQ/OnG8nZbJLalUu6c3DTyt89usdXeDXv40wuqivck6nar3jikHgTEeCqUH599/u7jByoPRf6O2MsVr/sUPqTRWfb9Lg2A6yVFQ8qAAN2W9IJEoA0MWQrXwIEQnnEjQfAKV/UDCp1r54cXSfhbFzXhibkk4vbwasH39L/hJTeWH+mwWqXah3L/BvvtfxK0lK1fWdrVv21GiWsWHaHKaRxEdWfOHeNGQiNEO7G+q4hdg2n6kKs4PEzFqn5D9B4aAHrERzVjSD2WnIuWSgtPCWozBCIydg4Pvjou2vsjcxhRe6SftP9w7lQM2yKCPoHjF/5OPr8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ck4DxZcMDFVexRYxaGwLIloleTAigYzT/Hhe8EotjNk=;
 b=KX8Mdfp/O/0g0SwNmK7aS9XpHPldwSPahthxqVH3UUxARTnwwhOERpwN1yRgkK2jDANGyxkz/Wal7+ruPyWZcCLLaVfg+J+l85GOfMaubkMSAVx8eIlXAvyEvip3v+9F+2liqYOuNHhBepfVXs1jerRRfz7FT3vuXMoYHUKECqQIQ8AP0R7rVbSYFn7ih+KcM5UM3+LzT0H+ySQiLKGG/pRGwjjYRMddJ4LdLqEZ7Z25p3QjCNambTC6CV6GTl+1RlzzfPePZT+TncwmHwQgiuNAs5S2kNbM/nMMzSyNleupD3xbsgIx/m+gG23v0yWTuC+wbJJ7StFK6s9mCn+kTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CH0PR11MB5756.namprd11.prod.outlook.com (2603:10b6:610:104::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 09:26:24 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 09:26:24 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 4.14 1/3] cgroup: Use open-time credentials for process migraton perm checks
Date:   Thu, 14 Apr 2022 12:24:19 +0300
Message-Id: <20220414092421.2730403-2-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 160776ac-f930-424d-01fb-08da1df8d838
X-MS-TrafficTypeDiagnostic: CH0PR11MB5756:EE_
X-Microsoft-Antispam-PRVS: <CH0PR11MB5756BF989AA840087E41FC85FEEF9@CH0PR11MB5756.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CiTGYuZeG4hx2IGquDrn6iEfHTv7oTK0LshQWTUXBJ7xgoDOb/dt1HusKJxno7edPMpgiKWgljPgzEami44Q7d5q6zdDQDnLiiAQmQrCGA6SyOsarIkqq1o9ewujJIIj+d5AP5EyNYtE/aO8KZPro4nMF3kfm1fxFVj3tjHlB6MkKExv0gdO/Ly5atEhT4eFi2jC0x/aBhVQsiG1eXVaJukpLIHKcajn3Xxla9eQkYvg62y+5W8FiwUzIsGW94qtPExRh5UliUtdxTFg9AZ5lyG1sR3Kf0E6SlrFcDnaOm6YHNQh6cFnmqN0GFTKNo8OLTzPfx8jsPmniVRYOM7muQQu9KVzcnpX04gDyRW9qTFJUeULkbhPwMGGpYoBmIkVmkpU7U99f/Nt9KwsevSc5lbimMAPTDohbaGbM79YMsQWX5c3kjJEkI6yF+0g7kFD1vE5l6B+tZWKyg4Gkkx/bodSMnjGUyMpDjku9Do+BF3asTWJ/dwa8XGNlYwmdOtsmCU20Qr61y0K0TbcQf5jZIOQlPDpxeNl/a8M3cjNGTP+x5JiOMwNTYEpjvGexE3FdEQm5kGKv46lg0SjPh84RM11KtFVE1tpbi3utvRHWP2MZJyT5l7HkFi6oE/hf2kwiywrHdq63zY5IyJorzhXLZMEtH4g3OAkFTcVPhlp2rUb6XrisTpWjolFkeC3cNQUhXPIu3uL+9BapXrSg2zEgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(8936002)(6666004)(38350700002)(38100700002)(52116002)(316002)(6916009)(508600001)(86362001)(66946007)(66476007)(8676002)(4326008)(66556008)(6506007)(6512007)(6486002)(186003)(1076003)(36756003)(26005)(83380400001)(2906002)(44832011)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vk9XVHVBVmM0MnZPL1lLdXBnVFRmbEFBSnI1UU8wMjQ5TTVaMzVsS3lvMGNE?=
 =?utf-8?B?ZVh3V1V5MkMzWFVZeHlWS2FUdmZRR25oOHJpTFltbnVCeEVDeTFyME1VaVp6?=
 =?utf-8?B?N3RNbzAyWnRCeUQ5WUwwRXZ6dGh5OVlYWlZkVHphYkE1L3lRamVTckwzcnBx?=
 =?utf-8?B?OXVGNERDbWJsajViRHc3WEtIY3N1T1JnOGtFSjZFT1E2Z2g1Syt0MG1IYkxl?=
 =?utf-8?B?dnpqdExvMDdaSERMeGNSdUNxMEtHZm9IcTNaRW8vd2gxVGVaeFVyL3NycUpR?=
 =?utf-8?B?SHFUS3oxdE9tVVl0Z2hwWmVFT2ZVb1JGQk1pMUxINnV2MTZWb1hSTy9qQXhG?=
 =?utf-8?B?c3ZIUENLMGxRSHU2RGhlM25BNTNvZlNrekRDb2NrT0dUdi9WdUd4ODNPalVp?=
 =?utf-8?B?Y0Q1K25uN041Uk9YanBBMDZTSlhxU3d2a0xjRXZ1TEpqUFdKb1UyQ0M5RGQ3?=
 =?utf-8?B?a2V1WnJ6RkM3YTdyMUVBZTloam16azFsUmZzRkhOWmRWaFpvMWJxN3c1THRW?=
 =?utf-8?B?VWlEc1NYaGdZVGRyVlFTV3pOMlpPUjJCVFc0RE4vS2ZTRWxhdEVnSGZmdjZC?=
 =?utf-8?B?dCszMmFoZTdtL0VBMjUweVJ2VUJvM2JQSTBTOGwwMTRBdmlWOW40RVFJckZa?=
 =?utf-8?B?YmZvZk8vcnh1eVJRWkdZalNlL2poaTY3WWcxclZEc01oSld1c3JXQmkwM2xF?=
 =?utf-8?B?M2duRVVidWl5MFpZWEFobzdQZHg4d1c0akhuVDF0amhzbjRKb3ZBMStqcGdn?=
 =?utf-8?B?SjliUXRZcmlxMXlmNjdWNG1JcHhIZS8wbkszc1hteUFMZUxUMVBhY3pIYmI0?=
 =?utf-8?B?NjhoNXVDKzRMdXYvUk9lRkkwQWFvVXFONVAvOVR5eTR2QWFPT3JhNVlUckd5?=
 =?utf-8?B?ZDk0bG82YUV2c3dVdldKdXo0ZmV2NGE0dGFPSi9QUmQwRVUzeWRtcjkwS2xM?=
 =?utf-8?B?MlBEZm5ES3l0dVNYaWVFZm9QdHdvSlduQ095Q2VJaFZHczlRbG5vT3BSOE9o?=
 =?utf-8?B?VFNKNTJFM05INGlkajVTcXNaWmRHSEs5UEFOdStsQThoWVNQVml2YXpNdVYr?=
 =?utf-8?B?OTJ5eUxoTGtaSm04MDRSdmhYWTVWWGhuT2xIQkR5QmppU29lWkd4eDFDTFFL?=
 =?utf-8?B?MTBKRXdpendVOUEzQUhhdDBGbzJLUGFvQXFkM2gvVi9zL3FCeVNqVi9wWXB2?=
 =?utf-8?B?N3dOQVpTcU05MDNCN29kQmQyc2JzdjRCYmw3TTVRWnlxb1ByTEtvc013Ulgx?=
 =?utf-8?B?RFdEZytVY09TL3BiT3ZSU3Y0QkZyWllqQUk3SFB1YXdGRHRpZHRGVEJFdDBN?=
 =?utf-8?B?TzlHQWIvbXlZRzJIcmJ0OUJ3NVMzUlllUVc5TUFLSGtqdngvQXFoZ0svdXA5?=
 =?utf-8?B?emxtL1lzU25kK3c5aDBCbUYrWHBaQWU3MHpiMFNRSkl3MUNhSFJHY29jVHd1?=
 =?utf-8?B?UEhlZm1BcmNWMTJQdHJsQ2ZFcFVBUWdQb2IvdFlqcEluUjFKejYrS0VwKytW?=
 =?utf-8?B?Q1RiQm42MG55VkNyT2VPSTBmTlFOY05JVjRDVm5yN05ZeFhMUHU1R0ZtRHRl?=
 =?utf-8?B?SkdYeWZGT0JhalJJYW5kdTNtY1JZMldiUFliRS9qbmtGNlRqd2pNaDR4RWwv?=
 =?utf-8?B?U3NnclVZdTlnTzVDNXhhNGRMTDBnM0NEL3dpenFXMGVTVjNFK2xaV3p5WDJk?=
 =?utf-8?B?TDdtcCtEMStXS1lZR1ZPbWlRYmxlSjl6MWpjRnJJR3pFNjA2aW4zTi9iQnh2?=
 =?utf-8?B?RG13RnRpZVNacGZHZDlRbWxBdTh1ZDdCY3hUMU4yMEJTTnUrQmpoNkZHcUZm?=
 =?utf-8?B?MWZ3aWtpcGY0RmRvOUpnQnVDMjVVcnpZQjZLV0ljOWdRaUJqZjhEK2lhS2hG?=
 =?utf-8?B?Wlp2R2dlUkdZbmtDblNPNEdBUjNQMWxUY253cmxnZmZlTFVzNmxGKzE1QjFS?=
 =?utf-8?B?Y2xhZXlkSWZEQXNQSVRXOWoyM1dHbzJKMDg0NGhuVWNTSDBWN2x3Z251Z05R?=
 =?utf-8?B?ZUZWeitzVlBuU2FBNkhDeHdHRjBsYzdkZFhJc1QzNnllZmIwUUNrbGR3NmpI?=
 =?utf-8?B?Q2ZjRURDd2taR1Y0S3hnYkVoTVh1eTY4YjB0Sm53dFVPM2hrVEZVYlhrTk5K?=
 =?utf-8?B?S2h2RFgyWFYxUHZjdU9uWEFheld1cFMxb1IzK0dzd3lrNW5mSHJuY2N0UzRG?=
 =?utf-8?B?VWo1YTh6K01WZWR0SGc1OGxORUI3YnBVRnFkZVlpbWJtRW5sRGFuRXlZTnpL?=
 =?utf-8?B?S0dteFVraWp6YkZBdVowQW9pTkY5dVY4UUdVNG96aVM1dTY2cUNzK1FKL0tD?=
 =?utf-8?B?bGJDN0FrRmtmQnI2SElFUko5VjRXOHN6eXAvZStSZGVTZzdWMVFONHVnbmhn?=
 =?utf-8?Q?7+Kgu8l6sT14B0/I=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 160776ac-f930-424d-01fb-08da1df8d838
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 09:26:24.4408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zbllUth6EhYgsD1EFiPC3lJgdB8trFbU9R/nJ/R7yYeUwr5Z4U3/diXLUKI/BfaQIxKoHWq12TIIfVy60B5nZwjqVgv4dcxdoqUCBcd+eg0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5756
X-Proofpoint-ORIG-GUID: DA5-g6LkaQ05n5zf_GuKBOn6pI0D0gL8
X-Proofpoint-GUID: DA5-g6LkaQ05n5zf_GuKBOn6pI0D0gL8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=768
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
[OP: backport to v4.14: apply original __cgroup_procs_write() changes to
cgroup_threads_write() and cgroup_procs_write()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/cgroup/cgroup-v1.c |  7 ++++---
 kernel/cgroup/cgroup.c    | 17 ++++++++++++++++-
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 105f5b2f5978..4a2b148b900d 100644
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
index d5044ca33bd0..380500251b96 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4381,6 +4381,7 @@ static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 {
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
+	const struct cred *saved_cred;
 	ssize_t ret;
 
 	dst_cgrp = cgroup_kn_lock_live(of->kn, false);
@@ -4397,8 +4398,15 @@ static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
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
 
@@ -4422,6 +4430,7 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 {
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
+	const struct cred *saved_cred;
 	ssize_t ret;
 
 	buf = strstrip(buf);
@@ -4440,9 +4449,15 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
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

