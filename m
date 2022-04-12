Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060E74FCED0
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345584AbiDLFTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbiDLFTn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:19:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8302834659;
        Mon, 11 Apr 2022 22:17:26 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C3I1j6008564;
        Tue, 12 Apr 2022 05:17:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Dlt4DVzFlV4rj/Ms/7TJfrHF6jPaXGEsuCAgl1GofH4=;
 b=0GbcugxaHmVzXgvuEGOpV+lA3djOM6YEw2Q1kcKcGNdWCBnNZ1dXzlUqW1GetZMEOYOT
 x1WMB/eY6EZRg1OTxVyArsuUmDU+QNZdSaQQggDjAk0XME2QLiwREkV1l3MOORAs6h2r
 RS7c/XP/HqFpZopc9Uat/hqHTEGsNBIgPNbjQ/rKh8M1rYH/M68jaXQQKGy9GI5cvw3d
 S66do76WjS72t8U00RuI9HRjyATt+CG3Vz3pwCbVpBXQAcf3ELwDdWQ8nTWNEP1t/1Nq
 32j9olo/9ScNAUQeU1XoGMq3wxh32lmVT2KNhYR2vj2CJin3LUyHw/+rhS42XRF98a2L zQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2dmc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:17:24 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C5HMLb016490;
        Tue, 12 Apr 2022 05:17:23 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k2cmyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:17:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1QqPa0F5uyUcZStPWee4RDI0/zurFCAkYKJspiBw5hY/9Wt866qCxZDw4rI/JXDEOg+Mfc0hDHzPpUxuRS0KhJfUzfBBUtlzG/5Ggdw7c9zOm183mVFL94lmqLPEcmKVUu1IA02fd5CZvbPHkAwqi5rEYVV5t83l8rRyLTXNfuji45KEI6aZuW1EtzRhbaf7ZBV6HL6RqgX19AkgfiiANS9+NCisyX8DJFDpIUOK1YyXaxYeDTshXYInUB00d85s0pZuAct0mNpO2t+IrNrJbxaUwjuoKM96TQ/F+HoJ7HA46r63DmSkNPkG0GLIIHtjzknsY3bAPyutfBty2zxkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dlt4DVzFlV4rj/Ms/7TJfrHF6jPaXGEsuCAgl1GofH4=;
 b=k18Jq64XQtzNf7XwvnVi6S9E9A4bjTkwUAfUVaMbJiBp/Jajo1I2pavsS/D+7mZkl+c8n5ryw65erG0AzEU1qGP9nzWKS+FdlW2iHmtmdY6LmREENvi0XugMTTveGpB374IxdoCJh36cHGL1Cx3yPsUlqUyhObNDmNH86ipYt5kDoP0zbV02I179HokWl9lW/e6IJSxtrb0RNMJfItsLMZ/ryryEN2gDAjVYX82cHFihtJbZbTu977skjtEic524waQ+x/8Zz1FwTacneXmOpdQdM2FB+QCEg0vjWcboOyOQ2xb73mzFHg0ca3+IQJuHBHGZBpXvR7ALkRKOg0FoQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dlt4DVzFlV4rj/Ms/7TJfrHF6jPaXGEsuCAgl1GofH4=;
 b=i/5A0UpZVkPSWkCjx3iB44uHhK04l5QUhJhpkhNQQQw/n04YftEvKm1YTsxcuHRhLq0+MBHXL83BI+61SHUWIt51lcsKdnRFh2M2Kbrdhf+3Ei2G/SL6TfPGdeRdkqKESxvCSd9pcLjyiU9FHQAxipdaQ0GJEO6zrAOLHWN4BIQ=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BYAPR10MB3256.namprd10.prod.outlook.com (2603:10b6:a03:152::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 05:17:20 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 05:17:20 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2 15/18 stable-5.15.y] gfs2: Introduce flag for glock holder auto-demotion
Date:   Tue, 12 Apr 2022 13:15:12 +0800
Message-Id: <8f783c16379c9255434fdebe3cd8aea7e3b8002e.1649733186.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649733186.git.anand.jain@oracle.com>
References: <cover.1649733186.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0046.apcprd02.prod.outlook.com
 (2603:1096:404:a6::34) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b3fa398-2423-4aac-720f-08da1c43b844
X-MS-TrafficTypeDiagnostic: BYAPR10MB3256:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB32561C6539E57448E595A1CEE5ED9@BYAPR10MB3256.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /22aUknSYa6lQxsfWCgZNCmeCqCO9XHU51zihbVTpQUWweIfDWdzwNI6YOOO4aEXOewfPVzIYIRQ6EnpcR2R7CXMtRzdH60Hw7JOxDxZW91qiza4VTNwljhqOMbL+XOSQFJkyAQqMZBKwB71SH+1grnn/Wmz37f0fdQcl+S9/nN8Gio030fH5NNont2X19hXUmczrxwMINwk9PXv0YLWw1JEXvzdPuNoq7Tfmf2UJEGlujKOtkN3HqTlUm4gJrtkYvsrrNGaInu/HjESA7HKNXaog6ezQcPMycLQ6Ax8tjgJZU4RVmlCjTGC9icgYUYKkh1qoIM29r9kin7STYag9zv4J/CCCK3v4VG0QuUM7LFt76vEt2fUYWtoFJ/D0hCUY0VaNYRnMh+hoIF9eeWlIPIKN+Tpfl4EhWQfvpdQr/1HZzDdbD3Ma1+ShZ+OW7nBAO/52weXVhpYzhwdDVlVtVSEZI9oygV/OZbV87yb8+Zub9riAI+O3QOnsFQTJmaj3N5PPitpM0QP5eig4VacQQWS1nV8d23v7YXMsxdkht2VhJc75ZuKydgebRZmbLljMn1ea04vwrN1uWu5dFLBFb90+zLozwXRc4+vNZweSrfgJwupP09krx3zf7i8S/i/jUq+SbTgpCXrY9UzhmRTgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(8936002)(5660300002)(30864003)(2906002)(83380400001)(6512007)(2616005)(66476007)(44832011)(107886003)(186003)(6506007)(6666004)(508600001)(66556008)(66946007)(6486002)(86362001)(54906003)(36756003)(8676002)(4326008)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fVB1VM02emZMo4ScF1QfnZLBJkbYvcYQQFaCkgKaFee6sTfRilSVb40UYmss?=
 =?us-ascii?Q?OtWPMyvlU6QB75EqdRws/Dm2XtikacW6WR3+PfbA/EDYtTOsgys2SD/vgB7A?=
 =?us-ascii?Q?VOMGO8gsXDbJTDmbVhm8tc8U2HuMdIey6ObmaJZitOhR1jVbaLACU2phIp1T?=
 =?us-ascii?Q?puhV2cEYiKV7gQ3WeY1qpByrLL/5A2C87fG/0FmLgFldLbATbmJut8IymsLu?=
 =?us-ascii?Q?ReT5fX8ONOtNdnHoYTPbkx7hHy+McHdeyeoMhDmvX0cwppa0k0/bN38FkCsH?=
 =?us-ascii?Q?y8Uc0SguBcInlUoK953eXuj/S/UPXsPyOS5VyYs0imvQaL/btJEmvAcP49Jb?=
 =?us-ascii?Q?YBx2UnzsXHt5NKgl1WSGDs58c/O9k0XHa+3ASuUHJKGjPw5cVyc2P60Xeeag?=
 =?us-ascii?Q?HIhTlGigR1+sp5MPUSUtvJZ5AkHbI7W99iR0r4izdnvjkY9sWCtxpIDou8jB?=
 =?us-ascii?Q?jqE3OYl9ptbarCcD213TqsXFLJmZMaHGJGYrsaWr3yrfPXJCCJiH/F6uH+M+?=
 =?us-ascii?Q?mzgcjHUTlNbjKiJPVXvfZLbg6P21umS88v0lO6WxN9i9/pOt83Q7LuoxqLA5?=
 =?us-ascii?Q?eD7dGroCBNjG75RcB6FSwZH2bEbeiTBqDHT7cCQA8Arsp2/ouFLb2QfP4KGi?=
 =?us-ascii?Q?4qOqtWcC6x1PAGPlu6QaR1jnBhP4WaGhJqLf24jo7/P3KcbG4SPJDKBf4ZKj?=
 =?us-ascii?Q?4Xc5zU3+VXw1QwXEe0wfNn4R3EJYdWIiN8ZG7UT3XL2KQA+Lbqcv+HscT+ck?=
 =?us-ascii?Q?MUG+e1P/OUFfeU5vLJ/QbN+FnReXsY6o0Zg1JJqhRxd/de8ByE+zvobW9xxd?=
 =?us-ascii?Q?MrbwI6GeNqnMWbtHkSOlEHOqnAaqjKAIfBVPyYxQw3HggqIh1AUQkBZ7p7d8?=
 =?us-ascii?Q?qsfLusEneCTQL32BHD+LkIe6NHH4z+CTVcu4n7Q8GWOX4zoBZkil8PWU+k/p?=
 =?us-ascii?Q?DRRM1/rFvaNNZefNrcNv/ZU1IWwoNNqP+zU4m2ZEng89ZDJ8h2MijLJVWvrD?=
 =?us-ascii?Q?LejBGYIQw9v7Rvf3ehapoK9AZfv94QptHRHYo0vAv+TsRhFky+T8nSKx/p60?=
 =?us-ascii?Q?UUCN5+HjP1UXBoqc0JQktU+zXI0pHsWoG7D8zq1qBJie8JdPTdW0w1uEeuVN?=
 =?us-ascii?Q?I3W6ih0yGvfZGqN8pmWPEsfzvPcC2oQcqcKKwYnv1tTa9dcErKrWCJyu1x6M?=
 =?us-ascii?Q?srYzAfQ1TLwb+u1KGlb/R93NGyIVSzZvoACBfwsl1CCELte5Vezx7Hv+bIce?=
 =?us-ascii?Q?m4rILlV3/EzRoN24NYFZSGnXenq5JiXnFueDvN775kBEgGSSYm1m0SIOjf+v?=
 =?us-ascii?Q?y/fHfD/Zpv2pYaxsRR8Ibbu1vnVdZ0tXCmV8l5UXSYAVbDIQWtc3itlGxmUT?=
 =?us-ascii?Q?poBLLB0fV0OsXkRZ6FlkqaL/Kool/nnJDbVUvjAL6njpQzgP+9QZgSlJ+l6+?=
 =?us-ascii?Q?oA7jBEziyMQ+/oxyQ0MzakOVeMcx0+oFVEb0qLfUrRGDZfWx4ox12GCGLuBg?=
 =?us-ascii?Q?ln7udcEdzsPkWKpUOhevvraUsz8U1Zq62z4WrMw5dfgZ1K3uYxuC7iW0Mv3+?=
 =?us-ascii?Q?AJQ32hs97r8tgMq/Kd6Pck3zD2wqumvsoM/2iJmBQnilhMax9uhX/58jfz6/?=
 =?us-ascii?Q?/bAdtkl8jiuQtGmgOljF7eEJtBa+XjXQDwNpayFl+b+1hcbGhdrAS9yrguat?=
 =?us-ascii?Q?yzzMX7Vz5J3oeXRny+jUBwHwI3fCAMhRYtmaZo+r/N64LxBqK/uxfcZYpjkW?=
 =?us-ascii?Q?c8EZ2shqCmKjdORJTQF6b5YkJf0/ltNlodTIZqQRhiHTfebBPVpe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b3fa398-2423-4aac-720f-08da1c43b844
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 05:17:20.7942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lNGvLhAquVVcrwaKl7/6x2aTTmlP7NusOPOTs8e8Gs+Kaptveg0263XCL08QP1pXwRonkuLHWhgL5tgb0iPQWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3256
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_01:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120024
X-Proofpoint-ORIG-GUID: zHqejQSiuO6RNjyJpN_ck2bzHxoo4QVT
X-Proofpoint-GUID: zHqejQSiuO6RNjyJpN_ck2bzHxoo4QVT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

commit dc732906c2450939c319fec6e258aa89ecb5a632 upstream

This patch introduces a new HIF_MAY_DEMOTE flag and infrastructure that
will allow glocks to be demoted automatically on locking conflicts.
When a locking request comes in that isn't compatible with the locking
state of an active holder and that holder has the HIF_MAY_DEMOTE flag
set, the holder will be demoted before the incoming locking request is
granted.

Note that this mechanism demotes active holders (with the HIF_HOLDER
flag set), while before we were only demoting glocks without any active
holders.  This allows processes to keep hold of locks that may form a
cyclic locking dependency; the core glock logic will then break those
dependencies in case a conflicting locking request occurs.  We'll use
this to avoid giving up the inode glock proactively before faulting in
pages.

Processes that allow a glock holder to be taken away indicate this by
calling gfs2_holder_allow_demote(), which sets the HIF_MAY_DEMOTE flag.
Later, they call gfs2_holder_disallow_demote() to clear the flag again,
and then they check if their holder is still queued: if it is, they are
still holding the glock; if it isn't, they can re-acquire the glock (or
abort).

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/gfs2/glock.c  | 215 +++++++++++++++++++++++++++++++++++++++--------
 fs/gfs2/glock.h  |  20 +++++
 fs/gfs2/incore.h |   1 +
 3 files changed, 200 insertions(+), 36 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 8f30ad956270..e85ef6b14777 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -58,6 +58,7 @@ struct gfs2_glock_iter {
 typedef void (*glock_examiner) (struct gfs2_glock * gl);
 
 static void do_xmote(struct gfs2_glock *gl, struct gfs2_holder *gh, unsigned int target);
+static void __gfs2_glock_dq(struct gfs2_holder *gh);
 
 static struct dentry *gfs2_root;
 static struct workqueue_struct *glock_workqueue;
@@ -197,6 +198,12 @@ static int demote_ok(const struct gfs2_glock *gl)
 
 	if (gl->gl_state == LM_ST_UNLOCKED)
 		return 0;
+	/*
+	 * Note that demote_ok is used for the lru process of disposing of
+	 * glocks. For this purpose, we don't care if the glock's holders
+	 * have the HIF_MAY_DEMOTE flag set or not. If someone is using
+	 * them, don't demote.
+	 */
 	if (!list_empty(&gl->gl_holders))
 		return 0;
 	if (glops->go_demote_ok)
@@ -379,7 +386,7 @@ static void do_error(struct gfs2_glock *gl, const int ret)
 	struct gfs2_holder *gh, *tmp;
 
 	list_for_each_entry_safe(gh, tmp, &gl->gl_holders, gh_list) {
-		if (test_bit(HIF_HOLDER, &gh->gh_iflags))
+		if (!test_bit(HIF_WAIT, &gh->gh_iflags))
 			continue;
 		if (ret & LM_OUT_ERROR)
 			gh->gh_error = -EIO;
@@ -393,6 +400,40 @@ static void do_error(struct gfs2_glock *gl, const int ret)
 	}
 }
 
+/**
+ * demote_incompat_holders - demote incompatible demoteable holders
+ * @gl: the glock we want to promote
+ * @new_gh: the new holder to be promoted
+ */
+static void demote_incompat_holders(struct gfs2_glock *gl,
+				    struct gfs2_holder *new_gh)
+{
+	struct gfs2_holder *gh;
+
+	/*
+	 * Demote incompatible holders before we make ourselves eligible.
+	 * (This holder may or may not allow auto-demoting, but we don't want
+	 * to demote the new holder before it's even granted.)
+	 */
+	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
+		/*
+		 * Since holders are at the front of the list, we stop when we
+		 * find the first non-holder.
+		 */
+		if (!test_bit(HIF_HOLDER, &gh->gh_iflags))
+			return;
+		if (test_bit(HIF_MAY_DEMOTE, &gh->gh_iflags) &&
+		    !may_grant(gl, new_gh, gh)) {
+			/*
+			 * We should not recurse into do_promote because
+			 * __gfs2_glock_dq only calls handle_callback,
+			 * gfs2_glock_add_to_lru and __gfs2_glock_queue_work.
+			 */
+			__gfs2_glock_dq(gh);
+		}
+	}
+}
+
 /**
  * find_first_holder - find the first "holder" gh
  * @gl: the glock
@@ -411,6 +452,26 @@ static inline struct gfs2_holder *find_first_holder(const struct gfs2_glock *gl)
 	return NULL;
 }
 
+/**
+ * find_first_strong_holder - find the first non-demoteable holder
+ * @gl: the glock
+ *
+ * Find the first holder that doesn't have the HIF_MAY_DEMOTE flag set.
+ */
+static inline struct gfs2_holder *
+find_first_strong_holder(struct gfs2_glock *gl)
+{
+	struct gfs2_holder *gh;
+
+	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
+		if (!test_bit(HIF_HOLDER, &gh->gh_iflags))
+			return NULL;
+		if (!test_bit(HIF_MAY_DEMOTE, &gh->gh_iflags))
+			return gh;
+	}
+	return NULL;
+}
+
 /**
  * do_promote - promote as many requests as possible on the current queue
  * @gl: The glock
@@ -425,14 +486,20 @@ __acquires(&gl->gl_lockref.lock)
 {
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 	struct gfs2_holder *gh, *tmp, *first_gh;
+	bool incompat_holders_demoted = false;
 	int ret;
 
 restart:
-	first_gh = find_first_holder(gl);
+	first_gh = find_first_strong_holder(gl);
 	list_for_each_entry_safe(gh, tmp, &gl->gl_holders, gh_list) {
-		if (test_bit(HIF_HOLDER, &gh->gh_iflags))
+		if (!test_bit(HIF_WAIT, &gh->gh_iflags))
 			continue;
 		if (may_grant(gl, first_gh, gh)) {
+			if (!incompat_holders_demoted) {
+				demote_incompat_holders(gl, first_gh);
+				incompat_holders_demoted = true;
+				first_gh = gh;
+			}
 			if (gh->gh_list.prev == &gl->gl_holders &&
 			    glops->go_lock) {
 				spin_unlock(&gl->gl_lockref.lock);
@@ -458,6 +525,11 @@ __acquires(&gl->gl_lockref.lock)
 			gfs2_holder_wake(gh);
 			continue;
 		}
+		/*
+		 * If we get here, it means we may not grant this holder for
+		 * some reason. If this holder is the head of the list, it
+		 * means we have a blocked holder at the head, so return 1.
+		 */
 		if (gh->gh_list.prev == &gl->gl_holders)
 			return 1;
 		do_error(gl, 0);
@@ -1372,7 +1444,7 @@ __acquires(&gl->gl_lockref.lock)
 		if (test_bit(GLF_LOCK, &gl->gl_flags)) {
 			struct gfs2_holder *first_gh;
 
-			first_gh = find_first_holder(gl);
+			first_gh = find_first_strong_holder(gl);
 			try_futile = !may_grant(gl, first_gh, gh);
 		}
 		if (test_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags))
@@ -1381,7 +1453,8 @@ __acquires(&gl->gl_lockref.lock)
 
 	list_for_each_entry(gh2, &gl->gl_holders, gh_list) {
 		if (unlikely(gh2->gh_owner_pid == gh->gh_owner_pid &&
-		    (gh->gh_gl->gl_ops->go_type != LM_TYPE_FLOCK)))
+		    (gh->gh_gl->gl_ops->go_type != LM_TYPE_FLOCK) &&
+		    !test_bit(HIF_MAY_DEMOTE, &gh2->gh_iflags)))
 			goto trap_recursive;
 		if (try_futile &&
 		    !(gh2->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB))) {
@@ -1477,51 +1550,83 @@ int gfs2_glock_poll(struct gfs2_holder *gh)
 	return test_bit(HIF_WAIT, &gh->gh_iflags) ? 0 : 1;
 }
 
-/**
- * gfs2_glock_dq - dequeue a struct gfs2_holder from a glock (release a glock)
- * @gh: the glock holder
- *
- */
+static inline bool needs_demote(struct gfs2_glock *gl)
+{
+	return (test_bit(GLF_DEMOTE, &gl->gl_flags) ||
+		test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags));
+}
 
-void gfs2_glock_dq(struct gfs2_holder *gh)
+static void __gfs2_glock_dq(struct gfs2_holder *gh)
 {
 	struct gfs2_glock *gl = gh->gh_gl;
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
 	unsigned delay = 0;
 	int fast_path = 0;
 
-	spin_lock(&gl->gl_lockref.lock);
 	/*
-	 * If we're in the process of file system withdraw, we cannot just
-	 * dequeue any glocks until our journal is recovered, lest we
-	 * introduce file system corruption. We need two exceptions to this
-	 * rule: We need to allow unlocking of nondisk glocks and the glock
-	 * for our own journal that needs recovery.
+	 * This while loop is similar to function demote_incompat_holders:
+	 * If the glock is due to be demoted (which may be from another node
+	 * or even if this holder is GL_NOCACHE), the weak holders are
+	 * demoted as well, allowing the glock to be demoted.
 	 */
-	if (test_bit(SDF_WITHDRAW_RECOVERY, &sdp->sd_flags) &&
-	    glock_blocked_by_withdraw(gl) &&
-	    gh->gh_gl != sdp->sd_jinode_gl) {
-		sdp->sd_glock_dqs_held++;
-		spin_unlock(&gl->gl_lockref.lock);
-		might_sleep();
-		wait_on_bit(&sdp->sd_flags, SDF_WITHDRAW_RECOVERY,
-			    TASK_UNINTERRUPTIBLE);
-		spin_lock(&gl->gl_lockref.lock);
-	}
-	if (gh->gh_flags & GL_NOCACHE)
-		handle_callback(gl, LM_ST_UNLOCKED, 0, false);
+	while (gh) {
+		/*
+		 * If we're in the process of file system withdraw, we cannot
+		 * just dequeue any glocks until our journal is recovered, lest
+		 * we introduce file system corruption. We need two exceptions
+		 * to this rule: We need to allow unlocking of nondisk glocks
+		 * and the glock for our own journal that needs recovery.
+		 */
+		if (test_bit(SDF_WITHDRAW_RECOVERY, &sdp->sd_flags) &&
+		    glock_blocked_by_withdraw(gl) &&
+		    gh->gh_gl != sdp->sd_jinode_gl) {
+			sdp->sd_glock_dqs_held++;
+			spin_unlock(&gl->gl_lockref.lock);
+			might_sleep();
+			wait_on_bit(&sdp->sd_flags, SDF_WITHDRAW_RECOVERY,
+				    TASK_UNINTERRUPTIBLE);
+			spin_lock(&gl->gl_lockref.lock);
+		}
+
+		/*
+		 * This holder should not be cached, so mark it for demote.
+		 * Note: this should be done before the check for needs_demote
+		 * below.
+		 */
+		if (gh->gh_flags & GL_NOCACHE)
+			handle_callback(gl, LM_ST_UNLOCKED, 0, false);
+
+		list_del_init(&gh->gh_list);
+		clear_bit(HIF_HOLDER, &gh->gh_iflags);
+		trace_gfs2_glock_queue(gh, 0);
+
+		/*
+		 * If there hasn't been a demote request we are done.
+		 * (Let the remaining holders, if any, keep holding it.)
+		 */
+		if (!needs_demote(gl)) {
+			if (list_empty(&gl->gl_holders))
+				fast_path = 1;
+			break;
+		}
+		/*
+		 * If we have another strong holder (we cannot auto-demote)
+		 * we are done. It keeps holding it until it is done.
+		 */
+		if (find_first_strong_holder(gl))
+			break;
 
-	list_del_init(&gh->gh_list);
-	clear_bit(HIF_HOLDER, &gh->gh_iflags);
-	if (list_empty(&gl->gl_holders) &&
-	    !test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags) &&
-	    !test_bit(GLF_DEMOTE, &gl->gl_flags))
-		fast_path = 1;
+		/*
+		 * If we have a weak holder at the head of the list, it
+		 * (and all others like it) must be auto-demoted. If there
+		 * are no more weak holders, we exit the while loop.
+		 */
+		gh = find_first_holder(gl);
+	}
 
 	if (!test_bit(GLF_LFLUSH, &gl->gl_flags) && demote_ok(gl))
 		gfs2_glock_add_to_lru(gl);
 
-	trace_gfs2_glock_queue(gh, 0);
 	if (unlikely(!fast_path)) {
 		gl->gl_lockref.count++;
 		if (test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags) &&
@@ -1530,6 +1635,19 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 			delay = gl->gl_hold_time;
 		__gfs2_glock_queue_work(gl, delay);
 	}
+}
+
+/**
+ * gfs2_glock_dq - dequeue a struct gfs2_holder from a glock (release a glock)
+ * @gh: the glock holder
+ *
+ */
+void gfs2_glock_dq(struct gfs2_holder *gh)
+{
+	struct gfs2_glock *gl = gh->gh_gl;
+
+	spin_lock(&gl->gl_lockref.lock);
+	__gfs2_glock_dq(gh);
 	spin_unlock(&gl->gl_lockref.lock);
 }
 
@@ -1692,6 +1810,7 @@ void gfs2_glock_dq_m(unsigned int num_gh, struct gfs2_holder *ghs)
 
 void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state)
 {
+	struct gfs2_holder mock_gh = { .gh_gl = gl, .gh_state = state, };
 	unsigned long delay = 0;
 	unsigned long holdtime;
 	unsigned long now = jiffies;
@@ -1706,6 +1825,28 @@ void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state)
 		if (test_bit(GLF_REPLY_PENDING, &gl->gl_flags))
 			delay = gl->gl_hold_time;
 	}
+	/*
+	 * Note 1: We cannot call demote_incompat_holders from handle_callback
+	 * or gfs2_set_demote due to recursion problems like: gfs2_glock_dq ->
+	 * handle_callback -> demote_incompat_holders -> gfs2_glock_dq
+	 * Plus, we only want to demote the holders if the request comes from
+	 * a remote cluster node because local holder conflicts are resolved
+	 * elsewhere.
+	 *
+	 * Note 2: if a remote node wants this glock in EX mode, lock_dlm will
+	 * request that we set our state to UNLOCKED. Here we mock up a holder
+	 * to make it look like someone wants the lock EX locally. Any SH
+	 * and DF requests should be able to share the lock without demoting.
+	 *
+	 * Note 3: We only want to demote the demoteable holders when there
+	 * are no more strong holders. The demoteable holders might as well
+	 * keep the glock until the last strong holder is done with it.
+	 */
+	if (!find_first_strong_holder(gl)) {
+		if (state == LM_ST_UNLOCKED)
+			mock_gh.gh_state = LM_ST_EXCLUSIVE;
+		demote_incompat_holders(gl, &mock_gh);
+	}
 	handle_callback(gl, state, delay, true);
 	__gfs2_glock_queue_work(gl, delay);
 	spin_unlock(&gl->gl_lockref.lock);
@@ -2097,6 +2238,8 @@ static const char *hflags2str(char *buf, u16 flags, unsigned long iflags)
 		*p++ = 'H';
 	if (test_bit(HIF_WAIT, &iflags))
 		*p++ = 'W';
+	if (test_bit(HIF_MAY_DEMOTE, &iflags))
+		*p++ = 'D';
 	*p = 0;
 	return buf;
 }
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 31a8f2f649b5..9012487da4c6 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -150,6 +150,8 @@ static inline struct gfs2_holder *gfs2_glock_is_locked_by_me(struct gfs2_glock *
 	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
 		if (!test_bit(HIF_HOLDER, &gh->gh_iflags))
 			break;
+		if (test_bit(HIF_MAY_DEMOTE, &gh->gh_iflags))
+			continue;
 		if (gh->gh_owner_pid == pid)
 			goto out;
 	}
@@ -325,6 +327,24 @@ static inline void glock_clear_object(struct gfs2_glock *gl, void *object)
 	spin_unlock(&gl->gl_lockref.lock);
 }
 
+static inline void gfs2_holder_allow_demote(struct gfs2_holder *gh)
+{
+	struct gfs2_glock *gl = gh->gh_gl;
+
+	spin_lock(&gl->gl_lockref.lock);
+	set_bit(HIF_MAY_DEMOTE, &gh->gh_iflags);
+	spin_unlock(&gl->gl_lockref.lock);
+}
+
+static inline void gfs2_holder_disallow_demote(struct gfs2_holder *gh)
+{
+	struct gfs2_glock *gl = gh->gh_gl;
+
+	spin_lock(&gl->gl_lockref.lock);
+	clear_bit(HIF_MAY_DEMOTE, &gh->gh_iflags);
+	spin_unlock(&gl->gl_lockref.lock);
+}
+
 extern void gfs2_inode_remember_delete(struct gfs2_glock *gl, u64 generation);
 extern bool gfs2_inode_already_deleted(struct gfs2_glock *gl, u64 generation);
 
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 3b82fd2e917b..ca42d310fd4d 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -252,6 +252,7 @@ struct gfs2_lkstats {
 
 enum {
 	/* States */
+	HIF_MAY_DEMOTE		= 1,
 	HIF_HOLDER		= 6,  /* Set for gh that "holds" the glock */
 	HIF_WAIT		= 10,
 };
-- 
2.33.1

