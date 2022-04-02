Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED47E4F009A
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 12:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354317AbiDBKaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 06:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242970AbiDBKaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 06:30:18 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C5FDD8;
        Sat,  2 Apr 2022 03:28:23 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2321ueEZ012994;
        Sat, 2 Apr 2022 10:28:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Dlt4DVzFlV4rj/Ms/7TJfrHF6jPaXGEsuCAgl1GofH4=;
 b=nyhF7Fo9TmvuDKF2KJd0pjiaiG8/4so444AYkM40F/RkihSE61L0QYmQ5dcpqd9vM4N1
 uqUF2vFjfcDKBUmyVn56U8CaHpfdjMftzVA0RqDF6SumMzwSuWofEW0ha2h25x6ghGwi
 p4w5EPSGokydokVOHCBGJ1ZPrpSmHVF6PegAdVIRx9/AkCd9x8mspW2VDOKPA5ks7Ba3
 xZbB1M+zN6YfyyR83uJNozW/biQRm9PJyBA3HMiCZRajFMJPB3UcDNV/2BpCm1xlVtN/
 8ArMjSBHMO+G4fwNwRzGCS/p3XwUSGTjQl5UXKeK5B8PmfUOnnPBJaaOieLowAVFt38g Rg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d92rcb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:28:21 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 232AMC9T024636;
        Sat, 2 Apr 2022 10:28:20 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx0xcqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:28:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Td6Ll2Cb8bBvXswZz1Q9WYerKeDrForhQS5X7mpv+LJEi8x17/FNqKO7eOfBfR/lpI656xR5nNnG/8nQ5DU4Tm50MFdeJzuzRYPFnjWXBvZFkXySsIC6OwhZlifEiW05QDpQ9Ffm70Vj7Gglo8y6+ZIYnTQ0l/BM9ppyukV6uSIRbEu4HfctHXqYYMPLG7U5Elwff4Ls5INxv075xf0otPdpijhku261TYZBU3M4TEb30uQ8aVlW3ASGZ8ECg9Bl+O1zr3ySo++q0yGdmI0ggchTxwvcerp5Z0Nd83cont/f/bAAmWmCLA50jxBSIG0XqfXJ2FtyPF3i2lN75d7LVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dlt4DVzFlV4rj/Ms/7TJfrHF6jPaXGEsuCAgl1GofH4=;
 b=J/IoCFq14Jiqo8CMjHeVGXMnW/U60obHBBosvY89ws7yeOY9qt02GaMtNXNe7C+BmPbMBL8pdxFqkvhkhY7vy6Ex8ntudaRLVfWsYsxOaBp1nOcTCo52x/54DGCLS7wJcUvwek7xrvXjQrS9HLqKA3LqbC9Krmz/iFBBze7CnDflAjdUx6HqFUHt8kbMtuDKb7xMiVHTVk2NC3fvoPzbnNx0NClVKlGOfVMPcZQ6U4jUWd+8It3uTM2TcFrLxz8OBZBdkTUwWAFjdsyHIQpBVQc0++VuxNsQWV2u9PxoSGcwpKS8wKoaLaK1Cdq9mlpZyPyNX6IkL1DRUnm0ZpXz8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dlt4DVzFlV4rj/Ms/7TJfrHF6jPaXGEsuCAgl1GofH4=;
 b=qRjyRBajd2nc4GWggemZkU/bZEgnWjoZkpuqirLDnH7138atJzJm8ijrdkHhLNGiot7fAGnmrnZc46S+rHMnOiV3bDm+QYg4osqEDfbvK050zbzAyHatuzAvrBXWPkwT1zwjYqOuG/N+Aquehb3ZczmtB49A3gSQjZS+WIZ5OoA=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM6PR10MB3049.namprd10.prod.outlook.com (2603:10b6:5:6f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Sat, 2 Apr
 2022 10:28:17 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%6]) with mapi id 15.20.5123.016; Sat, 2 Apr 2022
 10:28:17 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 16/17 stable-5.15.y] gfs2: Introduce flag for glock holder auto-demotion
Date:   Sat,  2 Apr 2022 18:25:53 +0800
Message-Id: <281bfda151d14381c713f1de8d52a05ec07848d4.1648636044.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1648636044.git.anand.jain@oracle.com>
References: <cover.1648636044.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0039.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::8)
 To PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3abd049-4c92-4f66-829c-08da1493808f
X-MS-TrafficTypeDiagnostic: DM6PR10MB3049:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3049057361AF8A312CD87374E5E39@DM6PR10MB3049.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YQIbgWy5ny9pcMhqLMKfvcrykJx2CGVjlHay9VYQ4mIoB8TNgSRxzjsmT3k6MQ6oP8zQkJxKwhf1WzWisDIM8y2nDT1aORkjXyGVtlrzN9TCeTfFrcU71zd2FY3KAB1l04E7fYOsT9UKdZ5zkVaFSs/EKWkQAVX6UHTOEIlK5zmnFdJUqUdhf30o9sPHlwwPibsGOtT2xjw254inQBKU7noQI7Q83SjfSD2EuzZK2SGPnE24O/Ah8lK1/U32HKqxEAoVX+5Yx57d0vxd6RZ9BYb8AUw7TuUlhf+6xHjtcEvb6upLOr3hmwjP4ZBgGUVbRfB4fT8e3Dw58JSmvSLv6e4tlhJsspz2u7KRuqDNMCXSsHEDNyJfwBeksBOv4jPTd2+GO/B8Ml46h1Kv+6Jmp0WmN+Pd713XJOKDr1JdM6Ea9s9h3enxhvD7yj2pUEU2TF6qy6/7s+ZUFdZV/lIMjuUNSc9QkerjjIQPBGINfuQuddVw/EGrCQZymq+y48LHMZ3XMHrVBOqDN86iEMf6tEgcYDwALdQgawi0C3thHVSrxkV2+s1RvSdAS8g/9wjhLfccRynfOLliLKeP1EYNF1gYL16L8fXH5SCZdpJBtUxcS9Cl0mJLOLc3ECbBWzo3MS4/UFYAoUnwwlGweIDVHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(38100700002)(83380400001)(30864003)(316002)(508600001)(6512007)(36756003)(86362001)(26005)(6486002)(44832011)(66476007)(6506007)(54906003)(2616005)(6666004)(4326008)(186003)(6916009)(66946007)(107886003)(66556008)(5660300002)(8676002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pGJ/2JyGMzGNYCRh3vzvXUwBBuGKpMnxBUiSx7sP8zeKsKf+L5TnYLExiEQc?=
 =?us-ascii?Q?BNGmEKiTi8voQ1s6ikAFbMZq0QE7SiEvXmW4tjV6XD11hPDbRZwWF3h14dPT?=
 =?us-ascii?Q?a8/pj7/8CbJqzn3J0OLHzQyaFey9Ybx6HRaK/97X1t1xPX6aKQ9mLJtMxfUj?=
 =?us-ascii?Q?ynnqpc1OC4qAHIH+jIuahIadTq4pndSGJRHL4svavt2PM7hAvw93zUHXVP1g?=
 =?us-ascii?Q?CLarZ0VVRN94N2KJg0O/k8QyCpDAEkQtWcxzndCL3hA33DTVVjKZ/iwQSbPK?=
 =?us-ascii?Q?W1wAsVz0pMqCkqNMlg6Y4Fz4xC25/UpUWEAiGGMr2hxaVDvqIyNvbALQXADq?=
 =?us-ascii?Q?7fVoPDM3PyygW6Uxi9o8MmqJFeuKXZ0d2OjHTGzEdLabzN1snNzRDERsn4QB?=
 =?us-ascii?Q?YaUfUeOxkd7s2sjirfzCwiENKjZfmR9HkgV0D5jP5SWh55SliFNOrrfx2we6?=
 =?us-ascii?Q?X97FievyZQ8OWomJLjepvr1zbnS9wOMsaG8VwC560OEGWMzZ41gUFKZyIDZt?=
 =?us-ascii?Q?kUN+HBoiYHJyY3W95qnt4MPEBDBo9C8yBmwZn1cVkTXB0k51kJdc/0iDPGGU?=
 =?us-ascii?Q?NaHGbRCQFSyTXuTOUssyf9F0Et03lNgnuBusXSRQWqQ4UbkDH17TyekbAF2s?=
 =?us-ascii?Q?GgHzry4UCb1vO2MhBx+im7yyudDc2pjr2JMZ0t7ZHZaiPIn731VpnrlBchfO?=
 =?us-ascii?Q?XWgJ/dt0vIzYbAaHwyUCB6gmMJ7GUzpWCv9x6KCwiIWUNxFkzy/irPPKAkxk?=
 =?us-ascii?Q?qv5A/UyG//Wht+hp9pEvYAM6BgqliWJaxmrr0A5YRtPMvyI7jHpyjkDucHtS?=
 =?us-ascii?Q?i/EDteUDUoX2O9+0eQDUHYRKKQdO/R6ojo5vhecVQJCcnCkBCsOKI/m++QU+?=
 =?us-ascii?Q?XyujtuCIZDgAueXapwm7IKpp7TNiRktn1tLQHvZIl5S6kY7qTaiGSoaC7Uvg?=
 =?us-ascii?Q?5Ls9ryZl8Z3vwkOwayRg9eD1dRVfku+yWvwMu2K4KV/LjMvPrmTvbUaUyjUE?=
 =?us-ascii?Q?i/qbrIccBtHVVH0ppSGoZ0AzC3iuG42XHalukhJjFKMKJX04g5URln20w5fd?=
 =?us-ascii?Q?pD4JgxE5MeDWQkaI52EkRngnpAqTfdQ8iYxToF+uJGkmZgfFBe9152GCm3+c?=
 =?us-ascii?Q?JIY328PP93a52tYMSXZQUJ8krNQjz8Zygibx/F3slxTo2XThSMWP1Wn/Axhy?=
 =?us-ascii?Q?ConRJIXEhC39zqkSHkuU5gvyo7xRTPGmsM9i+43fd0y4TPjo4rrwxC339UfS?=
 =?us-ascii?Q?gEOeFaVJvGjHNguo1DoLAjfaKSttdZA6ya7D3mzwtT1bv9thgwnpk3UkunNe?=
 =?us-ascii?Q?WCTiRx9Lr5XyaTtQweSWrTfATr1sZ4vSg1T61fP8/X/JTxuK+H+e8zdliRZI?=
 =?us-ascii?Q?0jcGOZOhLge5J5HSvZp4ioQHGnDCYEgw9vhgc01h8sEesWHmgnehm6pJ2tSs?=
 =?us-ascii?Q?/ToR4FVfLt6wBERPi1nDqrqbOZrVaHj4feOEV39SUW3HVfGAd5J/DpFCG5tL?=
 =?us-ascii?Q?aciKb10VoK+7oQYT7PYTnkXxyaUdEyqp/cQZa961A5GPcz4pFizJRI7etm6x?=
 =?us-ascii?Q?wFQR2uQpPIshieH5KWo3XwVTlgUMFyV7e8HgbQC3jANG6yfvz2pnPVbl5ig7?=
 =?us-ascii?Q?L/6WGTYPTARuADRIHwI8qVcVctizu6PHt4g7Ka1LCci6T7UYPPChw/7gyC7g?=
 =?us-ascii?Q?tFsLp1Ys/7ufp5xrOLskE8ycm3PE6at0BLxS5o62y045gL4+vIIfKXSYpaAk?=
 =?us-ascii?Q?SOUAWOd7jZmMnNg4FMR1/Qe85JRPchg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3abd049-4c92-4f66-829c-08da1493808f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2022 10:28:17.6921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bWjWDKR/YICMqEmQ0PgxS75Q67vbsfHl8sj3vA4+6CYfdXzcv80Tq8O6/vYp+3Dt826fRrLsGRLffI3tmvaSXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3049
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-02_03:2022-03-30,2022-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204020064
X-Proofpoint-ORIG-GUID: DJjmNWfRi8HKRjKTkEMxEQ7HUvBeunQA
X-Proofpoint-GUID: DJjmNWfRi8HKRjKTkEMxEQ7HUvBeunQA
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

