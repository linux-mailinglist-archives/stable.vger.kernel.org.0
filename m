Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8781A50094D
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 11:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241245AbiDNJJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 05:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241125AbiDNJJy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 05:09:54 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667996E346
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 02:07:30 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23E97PdZ018335;
        Thu, 14 Apr 2022 02:07:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=pa+df0Rkcs4cpUSyLBdIE3DLT3uDu2HGlW+S8KKJqJk=;
 b=MLK5M2OZgeYO4LRq0+rSA021EmqTREoC/tMCT0Y6ENaT5mvzr73R8vLmQObrqoltpPWj
 2XztdcIzG1C05G7qlLz9Pd76vw7kgnNFjs9E3pcWkcN1edehG0Pi+LLZaQzeyO4owIJt
 4fPhypfezUv5xdC/sZ+C225hBzU5Lfk4JaaR/qqOaKuSkZnxDAsk6aAHl27albKdch52
 MG2d/OyUJ1kxj4zo+YGJxlC5x7hOyuGokLGx3zMrYw2FtwheA/WomBvsqxmYVhcnboaJ
 Acplg62RhMre0YLtkMFE5Duj1gc58288RuLEWHpaonEMCe6hu6KMoJcxkJmh1X4sokie 0Q== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb9nfurth-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 02:07:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VcMCMxiqEN8OBVSTfcazfuKQpMKmC4Vny8tG0KybLpvQIinrHCT834cPaoWA6YIh9ml+R6qj4EAsPaLHEZJCmLXzI9pvaUtM+a5/fDbnBdMmzyrpix3B9IVe4LoQv3RP976BLGOqzMJXF+mMEVN85/IcpzjN0PxHoALH5MAeRjAvHlxJF8x3Lcq+5L4LmnjkYvXFytzkd4lrmFUl9cQxR0TZe+LpZiBiAZGNP09YHF8UiTc7ROh2RT15wrsCQlpAHVHhAzItbWuCaqZd7aRAKYtmtf2EVIa2rxqMBcvgmQLAR39nudGCawkidYSXr3VX5qV/BiIxCbWngRLzeu8AwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pa+df0Rkcs4cpUSyLBdIE3DLT3uDu2HGlW+S8KKJqJk=;
 b=IRVDnJ9lrxfaGvmr/tzAOv3sMSZFXuiHuqbQgWv/o19GqeDG9/egaSmZ14LDyHpZzjV8DIEKsYlKI4iJ7eEUww7J4wufPmlueUXVUa8sVP0vaE9G/M4tzA866LAsVJimRcEZoSydE8oA6ahWL8DvU8z0KkPs3wsdZtAZ/1wMKtt/yt4Y4IVrSgCvEmJMb3YnCqXgdsd57mXYEGGkJP9U55B9YkBKQPpfR1RdbIrZgw4UdH3QKXeIkGSKgUTGiTVJdfe88yRI/Yfa43cnkojJJotOIALWevcgSoNUj5J/eNtop9qrUCzZ0qkxpblRX7tOpQs3wYh92vye4NJPnTmXrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BY5PR11MB4356.namprd11.prod.outlook.com (2603:10b6:a03:1bf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 09:07:24 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 09:07:24 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 4.19 3/6] cgroup: Use open-time cgroup namespace for process migration perm checks
Date:   Thu, 14 Apr 2022 12:06:57 +0300
Message-Id: <20220414090700.2729576-4-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3b566142-6d3c-4008-4537-08da1df6306e
X-MS-TrafficTypeDiagnostic: BY5PR11MB4356:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB435698B6143FB72258535FAEFEEF9@BY5PR11MB4356.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9OXjxL7fsgV6gVth4uyWax8K363AEcJ52Y6uu5fTkRMRk0PdMJtlWsuxi3hY49WoGIxwl7o1MVj1cWELMM7dGLK5D6/2Ie2X9hYWlF3Vg+HfjfbtR/Y6lo5JPEKdJbsjLj3jq8QYUag3h344XYAiDfopjPwA6ZVHR/VE+3AwyixXFC8OcJ4ZRj4JHHbD3tNIZJTbSEscNf92xYrAjTtNtuqtlDDxMC8FwqmE5oaxodSU4TGWVCQ/3wdZIUqJYS9Q7UtJg6M5iuwFNi0JKUR33tR2E8KnSYDnoKgSojLQJL+Z3M5W8x+sl+Uro5UiZkBdMXOKHTH90i3tlwxG79eJL2asCLRIXNR2TbbIaiOjDc3Ry4pnBPwFXGhf0yP9K+/uzr5qCpTWAmftEUL0XVHo7sWKRf4rfQ19Br3wKefpXMFmEcC2q7mj8jkuO9kVAImrW5aFvvLegg25FUlHQ1T2o95tyzeX/5rt/KLF4IJ/awIIHQrBZ293nM7DyukRPNxUDMfx6RKbnTZATO46YFwpWiPKBTO0K1+jbb4N/9feONk6kMCJKvJMjEZnwJ0X05G9bpeVfZpls1S+Vfj9zEsCHho1NN7ASkE48kapb/8OHw0JEESHqjLsR/V8OCw/55C+ZLrZQE5KEeaPyT70aAxvv2PaFU9f1uU/nIRDcE+vM8QZwU4nmrhtsKCFMg9UeqOvhZbPnnY+M9LQvIx0phMvB1cHvNS6emuTBxg8j6Jq/ADHpOPwABtx9CxLrIwuHaL7ZQQmT9R40IjL1f2Jrsa6E2AwvBOk6TnB3wq31reggIU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(5660300002)(52116002)(1076003)(186003)(8936002)(6666004)(26005)(36756003)(2616005)(6506007)(6512007)(508600001)(44832011)(316002)(966005)(2906002)(6486002)(66556008)(66946007)(66476007)(38350700002)(38100700002)(8676002)(83380400001)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmFTVUlmaW9QajU1ZUNaVjVtR1JBd1BLNGczQkNLTUVqL2ZpcytUeXhUT3h4?=
 =?utf-8?B?K1ZoOGJIOTBHMlpkYjlhTXlHaE51N0pwdDI5UG9PRUJvdW12QnVCVE9CWVo4?=
 =?utf-8?B?T2dNcFpOMjZuL2JTaUoydmNDNG5PNERBNlpQT0docDNHWWptOG5iMzhMNXlq?=
 =?utf-8?B?amJrd0JHTXBNS0FBSk5Hb2lmVkk0cE9SSlExZFFDTGt6YWlaSnUyc0NKZDBM?=
 =?utf-8?B?OU5ESnhpTERYK05kbWxRZGtYbkVCSDJPdnlqc1N1bUtwWXo5QkdnV3JjSytS?=
 =?utf-8?B?OGEvdThJdTN3TitxMzhFblRhNmk4bUxOKzJWTm54YktacFV2MVpEYU5ZaWhk?=
 =?utf-8?B?TGpXRzg5UjlOQ2ZFLys1d3o0NzNPMUR2YVY5c0RuSmJmRUxmMzNPcGMyTkF3?=
 =?utf-8?B?YWlrdlVWUzBpcUo5UUxDaXNrOTJLM05iRG5paUxYZjgvNTBwOHFZMWpTeTRS?=
 =?utf-8?B?RTVXLzlwZjdJVk9OQkdwQmxWTHpWUjBrUnlhM3daSjRORmxrOUR2dzFSaWlt?=
 =?utf-8?B?NWE3Njh3NXY1cjFENmZjMXFwS1dPN3NsQnZBZUFKMUdMajI4dGhjZVNld2tO?=
 =?utf-8?B?dmo5N0w5Q2xKQW9PTktUMU85NElqcXBBU1QxNGEyN3NiRHBpRGNlYUsvTWpH?=
 =?utf-8?B?Zms5a2JMTCt2T0kwUG44SUNzbmw0UGMwanJVNzZuZDBPN011SnJzejJJQkVx?=
 =?utf-8?B?NEZqWTVHOGhOeTlIWXFDNWFpREdhZ3JESHRYMERpYURYTnArM1lyRlVOZW9z?=
 =?utf-8?B?YmhZbnhYWVV2Z3UyRTJQRnJiZWV5VTY3ZW45TUY1TXpnWXllZmZWaGFtd2tl?=
 =?utf-8?B?eXU0R3VGdHVYbjFoZHZXRVI0RXdiZWgwcEUzQVNqOUc3ZGtJY0NwdGpQK3l2?=
 =?utf-8?B?RHhaUkFKSnlZaGJZOGJVMkxuWnh2MnJ1RllSeTdHbWljUWE3RUsyS0ZFNnhG?=
 =?utf-8?B?SXhqSlg0dWhQbnhsVndnUXYrVWoyNlpxek90dXVrWVRFTVhEOW1Hcjg0L2Zi?=
 =?utf-8?B?YmJMaXl0andnb1JnR3huWk5SL0FkWk9CSjIrSm9FS1p6Mmo3TzlpTzI2dDFw?=
 =?utf-8?B?aE1oS0d3MjVWTGgya0JyR256Z0EvaFpnSHNmaFNEMG0rQ0NIQnR2dlQ0QXNN?=
 =?utf-8?B?WTJIVG54dnhPcHptczlvSTExNVIwNTlQWjBhMkJGcXhML1lNT2xickFoOVFy?=
 =?utf-8?B?SG5seUVYNS82dGdSMHBvZmRNRG5RdXVHMDdPYjUzYTBPQ1lnN0lRei9YYWFn?=
 =?utf-8?B?ZHV2am5oS3MwSzByNnFZRlg4dGtBVmNDSGxQRWhwc0pyV1hldzhLZ0sxQ2Z3?=
 =?utf-8?B?UUpHVVhncGpSZUZYaXRnaUU3Q1BaOUY3ODNvdG1EbGpWNDJubDJCV0NTU1lO?=
 =?utf-8?B?K3hHVWpxYS9GMEoyLzIzM0svZ242ZWxsZU12TUJWSC9PSFVsWWRLU3pYZ2RI?=
 =?utf-8?B?aVkrS2xscUlia1lsLzZzY3BWZGM3NFlxVk5JTVBCeDFkZ2FNNHZQQUo4dWlR?=
 =?utf-8?B?R1RKTHlIUUlvdVQxZmhNNTFRNUhiUDErYldPOFE0S3NhaDdkYzh6OWZsc2FC?=
 =?utf-8?B?YjlKUWljam1FdW1HbWY5ZUpRV3h4a3hJZ0kvbVRqQVZWZE9NL2ZDZnZqSG5p?=
 =?utf-8?B?QXo5TmNXbWl1UHQ0bm9FMkl1dEQ2UTlmODhwY0lpWmpKT1pQS09lNENJbjAz?=
 =?utf-8?B?cGpRUmJYbGo5c1ZLNjZsTEYweHVQYlp3bm1aTGVKWjZnVG1TbkZSNVJzZlFM?=
 =?utf-8?B?d1UwNWI4ZUxvamdCUVFsWFpqakRtQmtxYXJkQjA5WVozdlZZdFQyeFA3dUFB?=
 =?utf-8?B?OHJucEtzSCs3MGJMSGhZKytkYVd2NGtIdTBqL3BYSUpGK3VlZUQvcC90VElv?=
 =?utf-8?B?cHB1dHlGRGR2QnpaRzVOOU93Szk4VWQ3ZTh6dXhsUDhra2h0Y0dmNkplVkRN?=
 =?utf-8?B?bDNZSlBsUnZ6VTdVNnE4VDFMNk5vZUFYVFh3Rlp2ZUZ6OGMzQUNmbHc2a0lW?=
 =?utf-8?B?T21raDNXOFFhWllhWWliZmcxanRmVWJjSWNNaFQ4U2Irdm8xM3B5Zno2MTZQ?=
 =?utf-8?B?MEJCRGJ4eUpXQU5rRW8zQ3RDWHZzZGVmRDhaUGdYQU56a0VFMmFjdWsxby9h?=
 =?utf-8?B?dDkvZTV6dFlZL3RSbnZXOUUyejRJbnI2dlNwV2pHL1lhUGRqU1hKalFYYW9h?=
 =?utf-8?B?ZjcyMlZTZXMvUkJiOENpVmUrSExMTWkwNUFZbXhISHZxRUI3Q1hJcExPMFRp?=
 =?utf-8?B?Q2VCbjNZN2tQK05hZ0k0c3ptdURrVWFYUUw0V2hOU2k4ZmhKK2cxdVBXYTRI?=
 =?utf-8?B?OHVTSjcrR1MvVEViNXhOamtJR1drMm8ybmUrNlhQZnp3RmhyMXpXSmNOVU5p?=
 =?utf-8?Q?WdpPwv0CTnzrFWCo=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b566142-6d3c-4008-4537-08da1df6306e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 09:07:23.9445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cDuGZaL4sw0nKrRZkka2byBvoSWDYWbr1Tm8Rsplc0o7EFaz0XSUeUjKvsu+qTQRWc0zWzHV9dCH4OO1FTMxsE/rP6Bx2nuQ6xThs5+Eq5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4356
X-Proofpoint-ORIG-GUID: OkhqfIC6qXU9lx0Oc-RcWzbTtqQreGLH
X-Proofpoint-GUID: OkhqfIC6qXU9lx0Oc-RcWzbTtqQreGLH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0
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
[OP: backport to v4.19: drop changes to cgroup_attach_permissions() and
cgroup_css_set_fork(), adjust cgroup_procs_write_permission() calls]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/cgroup/cgroup-internal.h |  2 ++
 kernel/cgroup/cgroup.c          | 24 +++++++++++++++++-------
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 7ce7bd4b5fa0..8f7729b0a638 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -37,6 +37,8 @@ extern char trace_cgroup_path[TRACE_CGROUP_PATH_LEN];
 struct cgroup_pidlist;
 
 struct cgroup_file_ctx {
+	struct cgroup_namespace	*ns;
+
 	struct {
 		void			*trigger;
 	} psi;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index b2ace9339595..4e8284d8cacc 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3457,14 +3457,19 @@ static int cgroup_file_open(struct kernfs_open_file *of)
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
 
@@ -3475,13 +3480,14 @@ static void cgroup_file_release(struct kernfs_open_file *of)
 
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
@@ -3495,7 +3501,7 @@ static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 	 */
 	if ((cgrp->root->flags & CGRP_ROOT_NS_DELEGATE) &&
 	    !(cft->flags & CFTYPE_NS_DELEGATABLE) &&
-	    ns != &init_cgroup_ns && ns->root_cset->dfl_cgrp == cgrp)
+	    ctx->ns != &init_cgroup_ns && ctx->ns->root_cset->dfl_cgrp == cgrp)
 		return -EPERM;
 
 	if (cft->write)
@@ -4457,9 +4463,9 @@ static int cgroup_procs_show(struct seq_file *s, void *v)
 
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
@@ -4495,6 +4501,7 @@ static int cgroup_procs_write_permission(struct cgroup *src_cgrp,
 static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 				  char *buf, size_t nbytes, loff_t off)
 {
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
 	const struct cred *saved_cred;
@@ -4521,7 +4528,8 @@ static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 	 */
 	saved_cred = override_creds(of->file->f_cred);
 	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp,
-					    of->file->f_path.dentry->d_sb);
+					    of->file->f_path.dentry->d_sb,
+					    ctx->ns);
 	revert_creds(saved_cred);
 	if (ret)
 		goto out_finish;
@@ -4544,6 +4552,7 @@ static void *cgroup_threads_start(struct seq_file *s, loff_t *pos)
 static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 				    char *buf, size_t nbytes, loff_t off)
 {
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
 	const struct cred *saved_cred;
@@ -4572,7 +4581,8 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
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

