Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88CA55009BC
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 11:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241736AbiDNJ3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 05:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241731AbiDNJ3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 05:29:04 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918DC52B18
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 02:26:40 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23E8pF5J001147;
        Thu, 14 Apr 2022 09:26:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=BzPa7VLZk/5rsgF2xiiQzcYF/+4xdA2bANaXTUsDTOE=;
 b=spWXd4uyeTQo/VF3RZ3cu192r5CoATrZ9ud+uByhG40ek9lTTpRntKxIIY1hPX/ph9kS
 mdzlcDhT395okdUmpFVXfEbwoCcQqn6D1s4EQqHuRGPOlNcnn2rhmgVNngEQyzO0hYpg
 mNUX0ZwFXX76CQ0YdPiAksWcXxRvwsjym00O57HP4LmaFHTCiHtsYrhKuziziPP5w586
 TG4wPz73KuVgszVVcVHGEMMj7UlQBtLNqXfZF4KkM9aFCrVoYrL0BxsTvdkkeM+WaDkQ
 9nhKuvl/py9trzVKARIfCjBz5Ba05hqBsdLKk4CgheALFCX3AbQUFg1UN3kuz4CrZeIV Jw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb6fwbueh-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 09:26:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LIp8hXFKeYZTNrOqU7t+TK8SMbVQCJcnNlofyJg4XpPCJX6vV9rpvex0lOkbl483b9vdf6N1HwGBhOGvE0c1TBmZ8busN4fLrtI9qGKQ57GI7pgXurCsp9VeuCzTS8KReVNPRDK3QTAOct64qLu+Y9rgGTrU5hMSjqlyX012pIvzz0i7f2Vx7GkFdSnWKlXnrkQsP1FLvZ9y68VmRp3ko8C29iS8rbRKuArCfeHNTKEv2FEooMjZtnuU+2dLFT4qUPAGIdKDk/jRnvzDwjx7llSPDIW91dbX9Ls2i3RTuPTZXerN32OPg4WCnYqXkHVASg4C3fPRY2h5Tr2SFwsaLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BzPa7VLZk/5rsgF2xiiQzcYF/+4xdA2bANaXTUsDTOE=;
 b=JwtzQmGoWfhOhhaKom0vRFV+6+JWQRfbiyQ3+10P4oid9jo/CycZQr5btNCphWw22ddqIIDQDfCWi143UQ2zCN+oK8/c8yAWG/JOmBVUo0//63wL5y6J+zoG63BcF5nBBBhIPSUaUt+by/S1039zGjf0u9ixfSGwl06v3U5lp9iHNc2eqs3GEZD8YcACnVqoqVNsLAWupE6aedtE6rfmfll6mFcxFhPhUwihHndk8fkWLqCI/m2JwOUcwmawE7/zgH6B9hRtPDFXS/LBnu5DG25p9sHtEceJStSIxTaZbeX4BYxBFxr5JzNvEb/EgP+SAmwkn8OOrCI77ofubHFvQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CH0PR11MB5756.namprd11.prod.outlook.com (2603:10b6:610:104::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 09:26:26 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 09:26:26 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 4.14 3/3] cgroup: Use open-time cgroup namespace for process migration perm checks
Date:   Thu, 14 Apr 2022 12:24:21 +0300
Message-Id: <20220414092421.2730403-4-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: a4b2f038-ff18-4a18-9983-08da1df8d99b
X-MS-TrafficTypeDiagnostic: CH0PR11MB5756:EE_
X-Microsoft-Antispam-PRVS: <CH0PR11MB575654AE74BFD18B67025CE8FEEF9@CH0PR11MB5756.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mDiQTPN/0g4mGXuaDBhSzesLYBgTGT4JFVdZMabM5135L63508LE/GxRveYDIxtAC9YD0zO/ISYoh911BhNgks14cAbNpW89puPtdj4atMZKauYuqatB91oJqw9mLXc8IVjU/UPnpK9eyaPNEFuSEwkTHQBxKnmBo4b5li3Z+IydahEJV0Np5pOLCZhKjSTGmXPMk5P8XxbfNaX0jFD5VEFCD9V1pT0A8yW7gDCmKMneGHg3d/UoMM9W5Fd/luDCrYz/krZGtWOSrUOGvBw3BEx1uM3xeSsodMbAEP6F4w7R4626rVPfiIMenZ9CiwbQHldsERqZLoCDfDv6VfSNe2xpOJJbeewJ4PWNxYKbbiopjvPAZ+Wf/dbPu3+5qoTkTpCnuQYREwn/WTnTxCPfQCUhfHNM6RCdKgtD5rYP/ljmpklP446URh8GmaKYKWdnM+mUpkG9vmLl/I6FjstQoD/5DY30dqLexonw4gVqh751WOftxAgmD4SJW7KO2SGpO0mS3SghEaPPHKAy8VJ8S9hZFp51PJZWBiDHOQv4rssTttxFFOmKdzK+Omgdk9BOMrek/WJGtm51yx6x3WKCHK4O8STP+X36n63OdpKACKozTu4uP0wvG8Wna7vm/45D6jPEHqTPCtBy4EMPFjBZNBF1ZDO0D3IF+OSjj9KTcXMEbfqRC1iJPKXf/fscsDDKcubB/vowHTLL4mCoBVvy7xiCpMlEpZ5i7V3IpyBSpMx+3Gg6R+qrx0X/f4hn/u3F55omysoA8QwVBsOBmfw+lIac/nAkOVppsY0IKbsk6Kw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(8936002)(6666004)(38350700002)(38100700002)(52116002)(316002)(6916009)(508600001)(86362001)(66946007)(966005)(66476007)(8676002)(4326008)(66556008)(6506007)(6512007)(6486002)(186003)(1076003)(36756003)(26005)(83380400001)(2906002)(44832011)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YllmZ3owUjUxZDZ0WGcyQitocklvWkxHcDJPUmliRnRHc0ZqTEl1TEd1QjBq?=
 =?utf-8?B?NWtzUnIvTEUyam1iWHpFZW9EWnJjR1czNnRPMmwyMUhiN25tN3QvbnVpYkQr?=
 =?utf-8?B?Y3Z6Wm1tTktlQjlQSDZoK2xGMmd0eWRsbkhyWGJoN282YmNFU29hOUZTMFlJ?=
 =?utf-8?B?N01mdHZLaVNuMmhZRnBXd2loclRSaDl0QXNhZXU1dFRPMmN1U2RTMHgwZXV4?=
 =?utf-8?B?Vzh3VndhL1M0ZUFhdVhKT3NqTnhXdk53d1pCaWxLTi9jRFlBeW9YNktIWkw1?=
 =?utf-8?B?MlAyWGw1VWE5Snh1OWJLbDluTmllL3F2U1RGczJQT0x5UklnVTU2NlFFZEZy?=
 =?utf-8?B?Tmc2OHdFMUFwZ001U3hzTk14ajFaNVlKMWxDRHpFT1F6dlpXUGphYllOVHRM?=
 =?utf-8?B?MmJrMUJEd0ovcndwYmJHbGZZRXp0aFFLczZEQXlUc2RQeFA1T3VwVlNSQnVE?=
 =?utf-8?B?emxWdk1WZTlsZnFOQTJXVWt4M25hanhqNXluNnNzeFJqS2Q2SWdEZWFpa3NG?=
 =?utf-8?B?Tm9RdUNCRmFjb1RqdVRNbmRxZW5RNExLWjliTzJKVkNHcERBQVRGc3JjckdB?=
 =?utf-8?B?UVJHazZxanZBS3RCMnVObTVPeTBPRXpZbDJTa3FvTi9ZQktwNE91SUxvQ1JR?=
 =?utf-8?B?NTg3T284b1lmcW5PVE9qOHhQYTdLNDhqMVdkeEpBaW1PQ0FzeG1MRnlCMUF5?=
 =?utf-8?B?SGFERmVYSGtja2ZUVjB2UUZjL1VzR2JWWUJBQ2FxcGlMcVhkWFY3aWZJcGRW?=
 =?utf-8?B?SjBxZWhNMGNtZUd6eGdteW9nOW5rNmtHTU1ZNzRYK01NM0FFcDQ5OU5yR1Nn?=
 =?utf-8?B?VmQzWTdMMmc2akJSRmZGYUdiV2lUa3RnLzYxcCtjNlJYUVYzU2paQVJpVGZh?=
 =?utf-8?B?V1BWWlpoaVVpMUtqMWJBemNsRE9wSW9CSlF4cng4U3VVazV0YjM4Q2pDZHhj?=
 =?utf-8?B?dXNpbmVyRFRJdXBuVkpPRFM0eU5WWE10S2laSlpaY25UdklDTDJpYmRVcTRV?=
 =?utf-8?B?cmJVZjBIZlk3NEpVZVNMR3ZQMTRNMHlqTGVtRGZLaUhLN0pHRUNtTGlsNkhC?=
 =?utf-8?B?UkZDUXJhZ3dZaElJK212VisyYXdEUzBISnRtRFBUNWkyNkV0bGJZQ3ZTTzRJ?=
 =?utf-8?B?R2dGYzh6dkgrZG1RdU9hdXdvR25KUmRPZGNjWGVoNWZpeE9sR3ZoUXRZZ0JX?=
 =?utf-8?B?OFdQQlpWQXRLTGFJdTdSeFUrc2xUZGRSNDVmTkZBV3ZZbGVMUFZvUDMyUGF1?=
 =?utf-8?B?TUxMRHBtMCt1ajExZUl3eUNrd2xJc0xLamlqU2FBTTZZd1k2TjBmQ0tTV21P?=
 =?utf-8?B?UlI2bGVrQnBBNmlDd2NKdmN5NVU0QlhEbW9iREwva2VMOGN3SFZ1UU1lWkVo?=
 =?utf-8?B?MW9VdFBiVmZCR0NzdVc4cnpyN0Z5cWhwNlR2bElmeXgzZGhtTjkydDlQbXc2?=
 =?utf-8?B?bzdiVTBpVVFPQk95V2htUktLQVkyT0FvcWYxOEtuazh3TVRaanpjb2YvQWx2?=
 =?utf-8?B?ZWY2dzNoYnNWY2ZIV2F1RHlqd0owUm5SK1doL3ZJVzl6cHY0Qk5WVk5mdDVq?=
 =?utf-8?B?QTNQWlVIWmZobjJ2L3Y1a0orM1g2SzdJeEdqYWVSRW1kR1hsdGpCWlp2RE92?=
 =?utf-8?B?THV2ejkzZGMzUWRtMVZVWjhHTXV3dHFrR1NqcGl2WmNxYUJCL1NPdjU5dVg4?=
 =?utf-8?B?UWNXUjk5SVdqK1JBdzdBMVFzOTVXaVVyMERrMFhyc016Z1FQVVh6SHFwVVF3?=
 =?utf-8?B?SGFIZFYvMHZWeVMvOGlrNnNFN2ZRV0J2NFZiaG00d1Rab2RxL0wzYUtLRDdX?=
 =?utf-8?B?b3VQYWpZSjYxRFl5QzRkZVVzZUZSZ2pqc1Q3WGJiNTVZVlR4TWdUSjNVSzhw?=
 =?utf-8?B?eVBidWJQQVR4OE1EeUdHYkJaNFNLWUFUb1U0THVzMUNuMFdLend4Rm5jdnA0?=
 =?utf-8?B?YVRHdWRPZ25DdkNDVi9CdGs4NU4zZHlldGxtMTdOdys2UXZSTjJmZFQ2d2Nr?=
 =?utf-8?B?Q1VYT1J3ZC92N2I1K09Dc1lCVW16blNlN00wTVNMeDcyelBVZkVYaWZOMzFz?=
 =?utf-8?B?YWpLNy9CV0I1N2FkRjkzY09QN2VoOGJQM0U1R24zMnhDcDFsc05Jbk42ODlB?=
 =?utf-8?B?TFNKekFwWVFUd3l6YncvN3dPKzBlY2huYm5IbkFDQnRLeHQ3UWEyTDVlNnVZ?=
 =?utf-8?B?RWllakduYUlQbnJxRWhubk11eHpENmNwZDlydHladW9VaFFJcXYzQzhhazBG?=
 =?utf-8?B?VTh0M0pEUXlycEdsMGFvT2NlZ1VYUWp1R2xrb0poK2FnOHJZMzZzTEU5M3lW?=
 =?utf-8?B?ZVZtcUN2b1RlYkNxUi82VkM2NS9QdEJ6VnB5eEg4bVpnQVI4dk9USzliSVhT?=
 =?utf-8?Q?QnyE+OEv1nbb9e+w=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4b2f038-ff18-4a18-9983-08da1df8d99b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 09:26:26.7544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R2csMDookKWfa1HDeAEN2yXyN37NqL8C5jW+25zFnKcnNQ3QUohqB2+C3CmtSyEa/YX6QSYckNBwhqEpxwUSpbDzzeueSTwK+tamqcF3fn4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5756
X-Proofpoint-ORIG-GUID: yhkuN7ASoOAmWVss7n9CcxRJrQWBILOX
X-Proofpoint-GUID: yhkuN7ASoOAmWVss7n9CcxRJrQWBILOX
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

commit e57457641613fef0d147ede8bd6a3047df588b95 upstream.

cgroup process migration permission checks are performed at write time as
whether a given operation is allowed or not is dependent on the content of
the write - the PID. This currently uses current's cgroup namespace which is
a potential security weakness as it may allow scenarios where a less
privileged process tricks a more privileged one into writing into a fd that
it created.

This patch makes cgroup remember the cgroup namespace at the time of open
and uses it for migration permission checks instad of current's. Note that
this only applies to cgroup2 as cgroup1 doesn't have namespace support.

This also fixes a use-after-free bug on cgroupns reported in

 https://lore.kernel.org/r/00000000000048c15c05d0083397@google.com

Note that backporting this fix also requires the preceding patch.

Reported-by: "Eric W. Biederman" <ebiederm@xmission.com>
Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Reported-by: syzbot+50f5cf33a284ce738b62@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/00000000000048c15c05d0083397@google.com
Fixes: 5136f6365ce3 ("cgroup: implement "nsdelegate" mount option")
Signed-off-by: Tejun Heo <tj@kernel.org>
[mkoutny: v5.10: duplicate ns check in procs/threads write handler, adjust context]
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[OP: backport to v4.14: drop changes to cgroup_attach_permissions() and
cgroup_css_set_fork(), adjust cgroup_procs_write_permission() calls]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/cgroup/cgroup-internal.h |  2 ++
 kernel/cgroup/cgroup.c          | 24 +++++++++++++++++-------
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index aee1af8bf849..421c01590cb5 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -11,6 +11,8 @@
 struct cgroup_pidlist;
 
 struct cgroup_file_ctx {
+	struct cgroup_namespace	*ns;
+
 	struct {
 		void			*trigger;
 	} psi;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 9381100d6770..63d1349a17a3 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3370,14 +3370,19 @@ static int cgroup_file_open(struct kernfs_open_file *of)
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
+
+	ctx->ns = current->nsproxy->cgroup_ns;
+	get_cgroup_ns(ctx->ns);
 	of->priv = ctx;
 
 	if (!cft->open)
 		return 0;
 
 	ret = cft->open(of);
-	if (ret)
+	if (ret) {
+		put_cgroup_ns(ctx->ns);
 		kfree(ctx);
+	}
 	return ret;
 }
 
@@ -3388,13 +3393,14 @@ static void cgroup_file_release(struct kernfs_open_file *of)
 
 	if (cft->release)
 		cft->release(of);
+	put_cgroup_ns(ctx->ns);
 	kfree(ctx);
 }
 
 static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 				 size_t nbytes, loff_t off)
 {
-	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *cgrp = of->kn->parent->priv;
 	struct cftype *cft = of->kn->priv;
 	struct cgroup_subsys_state *css;
@@ -3408,7 +3414,7 @@ static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 	 */
 	if ((cgrp->root->flags & CGRP_ROOT_NS_DELEGATE) &&
 	    !(cft->flags & CFTYPE_NS_DELEGATABLE) &&
-	    ns != &init_cgroup_ns && ns->root_cset->dfl_cgrp == cgrp)
+	    ctx->ns != &init_cgroup_ns && ctx->ns->root_cset->dfl_cgrp == cgrp)
 		return -EPERM;
 
 	if (cft->write)
@@ -4351,9 +4357,9 @@ static int cgroup_procs_show(struct seq_file *s, void *v)
 
 static int cgroup_procs_write_permission(struct cgroup *src_cgrp,
 					 struct cgroup *dst_cgrp,
-					 struct super_block *sb)
+					 struct super_block *sb,
+					 struct cgroup_namespace *ns)
 {
-	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
 	struct cgroup *com_cgrp = src_cgrp;
 	struct inode *inode;
 	int ret;
@@ -4389,6 +4395,7 @@ static int cgroup_procs_write_permission(struct cgroup *src_cgrp,
 static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 				  char *buf, size_t nbytes, loff_t off)
 {
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
 	const struct cred *saved_cred;
@@ -4415,7 +4422,8 @@ static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 	 */
 	saved_cred = override_creds(of->file->f_cred);
 	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp,
-					    of->file->f_path.dentry->d_sb);
+					    of->file->f_path.dentry->d_sb,
+					    ctx->ns);
 	revert_creds(saved_cred);
 	if (ret)
 		goto out_finish;
@@ -4438,6 +4446,7 @@ static void *cgroup_threads_start(struct seq_file *s, loff_t *pos)
 static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 				    char *buf, size_t nbytes, loff_t off)
 {
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
 	const struct cred *saved_cred;
@@ -4466,7 +4475,8 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 	 */
 	saved_cred = override_creds(of->file->f_cred);
 	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp,
-					    of->file->f_path.dentry->d_sb);
+					    of->file->f_path.dentry->d_sb,
+					    ctx->ns);
 	revert_creds(saved_cred);
 	if (ret)
 		goto out_finish;
-- 
2.25.1

