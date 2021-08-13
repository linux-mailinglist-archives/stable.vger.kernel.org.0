Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089CE3EB510
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 14:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240297AbhHMMNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 08:13:20 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:55730 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240259AbhHMMNS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 08:13:18 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17DC7bTM015718;
        Fri, 13 Aug 2021 12:12:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=4npzuYd9vVl/RsNpNn83J0xXpFJRszeHjHcq32NexDY=;
 b=RtSA20rknKRSwvG4/i3YH71SfP2J9V9R1ZQfE4K8ToIDP8V9UbDeAz/TkEyIAe4ew+aR
 Mko34J/IdpjjByneyJGDzpsaZiv1yat/jTWHa3pmVrDUU8yuYhNX7GE/6NFbFY91Q49b
 RiNPZExODuMT31fENm4a6nJ7BhD10MJx9Xj62RPIqtjGGUy7p1/UTK6d8TuGC5IAEgbg
 Y9NdspjYJlXtUh/YMeiVmnLD1rKBMV2wCDp5W/JRB6bW+ho0uzjiePswp6FR+F8emkkN
 XJ4Uli0PB/rj4ryMtWBlODMI8QvElmwVLAZLKV/b0vnZ6jeipUBsOBSfr9zVXz1YSIvC Bg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=4npzuYd9vVl/RsNpNn83J0xXpFJRszeHjHcq32NexDY=;
 b=ckJOM/+hNMWAt9qvvCTFWuKJx+Fp1Jn97UWNd01yLicHBLsqkoMdwCEA3rJj0Vf7Ldg4
 mqzMQwBg3FcdQCh4AuRxjzlR6F/BIG96Q8X0+2gvpvhVMUMxelsztqtHiHiq/kl2xGrV
 ffRGCSn1z1kKl57S68XZC0jy14W4U44bV0NLiaDjy+0v9YZsTqc6jKdZe3NuxbRU3ecI
 hPwrvqwTiLQMWri+7qSLg9tBxlvdZAVBrsxsiuuQOC//CJUXRFNH+X4B6A8qJWKc7Bhu
 e59aP4IJ0Lp6VOTTT/4amhrqoNnH0wryuZAv/g/wctBQ4660soht5hr3uvF5akXqRYKW vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ad13vasvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 12:12:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17DCAZxd038678;
        Fri, 13 Aug 2021 12:12:47 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 3accrdx880-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 12:12:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SuFRl0apA5s4NVWabFvrBJrwkby2uZlQxddLT2uBDrJCRkLPMCHiTiYhNeP30kLt3oFp02W4s6OIRx5l2gn6V35hZOdklef9fU7KCFbaPs00yw24XtA3m9uV9M+zLdNox86U6tuubuuPOV2cbckSumx//auVZb5KluwxZg3VmFkoVz+I3nDizXTWQ731eDgs4K6yaxCd6or5Y6hpBr1DGfYxSsLbTX5TQdWqnjNwhjQmuBJ7Zg3NX+MHJE+do7FhAtLFBmmPo2QR2DmDoH63UKV/a+V05da4xwvda5wNfOiOTzUgssFSq9nx6W1sjKEvwKotiUURtp9VRNQaxbjM4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4npzuYd9vVl/RsNpNn83J0xXpFJRszeHjHcq32NexDY=;
 b=TQCsgteEP4KoTZTetSJkB3UZXeZGXctBHpNHksAlZeFYO9k9O1VvyNeUNpGKlydNOWM188r7XmKVfDE7R1GI2mH9pM89/DLuKZjSyBNaZPHsCBeCuknw9h/3HQ2mMXMkU5UWDd9kyU2UsEMxECaDOS79MtzADxDyRvb6PFPDWc8PVvcoEmskFNpf1JZBfAnMlPLWFh9ThQjPKnPd8n8F43VqOAFw2gFso+4yWr39gVDUTQmX8B6WDnxC8GiHYthst/p/c7tOG1Wo14il2YkPGTfCQQrMa1hrOh+89bspwxrUbS1HF3IQ+rW+YwfS7WTPU0ht2YyNBrxHe0+/hbGD/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4npzuYd9vVl/RsNpNn83J0xXpFJRszeHjHcq32NexDY=;
 b=ed276V+htzsb36DiX5rEi+5EoKNwbwOAaTdZ8FjwR/ViOq0CoOiorjYpomaH6UiLfs7r86weq3cR9N1PFn7RisaKtr1BtyIXoFsyH9zfAHLlvLhD2xyVpllZ1j9lg3wr5JpYmGJ+BLQLik+DlbidyLZKlvuXjMQG1jVeiY2R2uQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by MN2PR10MB3789.namprd10.prod.outlook.com (2603:10b6:208:181::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Fri, 13 Aug
 2021 12:12:45 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a%5]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 12:12:45 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, fdmanana@suse.com,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 2/3] btrfs: export and rename qgroup_reserve_meta
Date:   Fri, 13 Aug 2021 20:12:24 +0800
Message-Id: <4cdae9f94a8feae8f848574c214016ae6a923078.1628854236.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628854236.git.anand.jain@oracle.com>
References: <cover.1628854236.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0155.apcprd04.prod.outlook.com (2603:1096:4::17)
 To MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (39.109.186.25) by SG2PR04CA0155.apcprd04.prod.outlook.com (2603:1096:4::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17 via Frontend Transport; Fri, 13 Aug 2021 12:12:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d676bd4d-a1ef-4445-6aa5-08d95e53a8ad
X-MS-TrafficTypeDiagnostic: MN2PR10MB3789:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB378996A19064D60E8F21AE27E5FA9@MN2PR10MB3789.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:167;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Px84CRCR6TiXZJLbowXsQR56Fi2ETz+mfvXL8wYfeI+jRwT6GnFxivIU6DVOIIwo6qw1XqLrfyCtq9KTtXw9yFK8vjGeB034zaif/sR78a0qHLihaLjSF6wHMkfbi3cOILC2kDHKwfdWKeNFOSmh2WFiaJmtQEKh5Gwgzfv+Ub1UZTXGz8datYy8gS3lUXhKfHR9CXA8J1zw/zKgsMJ8Nud1KXx3BlyIxkreaM9USjgx0MTQ6iNRYLV3i9QGsrbG4SwkK8FaBR/sIgR5BUY9UlED4qjGxwnv144EBhxlLkRfuFa/qYlYZYygCcQYteuvHe2tKwUqa7IV6fiS5RkaMIiQuFujAseL1qGeG1deahlCrk8TWSnDGi3T+gagJnEUG2RzjuUqyWZQTIuVzlnjSUyW1mqvcBNDPjqhU26SYjqT6rEhYaYeAl5aVx8vFda8FLrgBGyF6gs90RkYLnRLvsY7u+1suffOK4v6gDpQQxiEAWAJxMoM8MPjqiQn2T3xGt2+2w6OGdrYklivupbFqnH9lviOseDv72K+LvcSVZb5lVFjot9KLXIRHX1YGaQ2Vfbh6vBXLyn7tM0p7wv4jTfSCWg5ZmxeAcfUNXCRihRxrWaXkaR3Ws/LbXF6KvZOxKJ8B+hDHz8DXS8X+oYefJKXZGaBj14B+P+iLmdb9bk1UzZ7yh38sBODk9WnDpxJm91khDLTcsSzXmVdt58XWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(366004)(376002)(39860400002)(26005)(54906003)(44832011)(5660300002)(52116002)(107886003)(316002)(6506007)(83380400001)(36756003)(956004)(6666004)(8936002)(4326008)(2616005)(6512007)(38350700002)(38100700002)(86362001)(8676002)(66476007)(66556008)(66946007)(2906002)(6486002)(186003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?agOdv8b7ZgeXhLqy4VbjgfV2ULr5xfoYYPPdBs8gfLgt1yHMcJ955Ts9P2uZ?=
 =?us-ascii?Q?c+hf2oPbID+CFfsaN1D2ZleusuiZQqX8Sd+8hXWYcDlDyBKmMdj4meslxOVP?=
 =?us-ascii?Q?ENRXSBhVsOpjC86Hbw16agrnVhEQutis8lX+Z3wU//3nAhnkD0nWEyFvU5Fu?=
 =?us-ascii?Q?sC2Q7ACHXGRQQCnMXdpyNFt0qkRqaH2uL54zEPhTIhL85NLQ0lD6t55m2Ram?=
 =?us-ascii?Q?/wEEsAjcGxNMSds7dMR8+7NVHrhEG/Dq9C+mHuRTAUDYAFoX64wUSfbq75ue?=
 =?us-ascii?Q?lAv/k5vq9CKQnQ9E1WXslduIKbkJ33C+ER1qeYrvYcLuhcvEj4+JDxslC4dC?=
 =?us-ascii?Q?GLnFf7IaIF1W2/pyOEdiHYD7k4HYNsXdSAQDXY6ScxbueaRxbm+zZEQR1hgp?=
 =?us-ascii?Q?4ElDDrDOnxGOvM8xPEd6sIyGEiA5/XSTgX19Vh0Omd5gZz5EXBVnKdi3nh6J?=
 =?us-ascii?Q?Cmidf8Lagv/M+s3RS7rJuJHL2xZFINh3nHid/ylF5L13DY34QSWX7FcLiOqO?=
 =?us-ascii?Q?bpfBgnoQXsHlhJUkMMs1WyEYqH/3bxa0tQ832x3dJFuF8lJuxpApjnX9QQKM?=
 =?us-ascii?Q?LZSf292XPRVB/lJFG9aXe47dnFyspbnDdtxQnUUuuX3icnocb2s8LeE9kloH?=
 =?us-ascii?Q?U5mOkS2x+T2wsTrpwxtXRTnKsB/d94nEhBphsO72f1CSb4HxK3ZCEM3tX8t+?=
 =?us-ascii?Q?JAPTmh/Hm82HWjTO6+4/Ui2mB7/sMSiC8IynvqocD/5lP1LbKeUvqb46sCfK?=
 =?us-ascii?Q?+cXBfpcnFjnJtKUbXJoSboHFX2TYrqsD8TvZnwMWr8ZSvX9NGrRufGFPEbX0?=
 =?us-ascii?Q?HfR+OIq8QLk/Ld8u81oLKisih4XlVFVlyA9ptjx3/eEWxDJE9Te1RfTAWQaR?=
 =?us-ascii?Q?wRQpP9NY4ZO+VHfJ8olGLawTPWvzOIvPZUgpjdeEwV39c27Pjn8JDHvRk6gW?=
 =?us-ascii?Q?c6/eO8wF5X8SbjCUkDS93Vc9Kozm7tXhqfwfXtbIjhbZbJRcYPHOGjQsY0jx?=
 =?us-ascii?Q?qcuuC/8P2qZoWYLMelTHNd6vo5m4P7dxI9AQu0kM2RfG42V0jn0q3Nn1FL49?=
 =?us-ascii?Q?tGIqWdUi85lq88eDU68V9arCCogYDoT8J6TsZtfW3hU5FxQrnHqSLvpV0cZM?=
 =?us-ascii?Q?sU9KpT5ZbF38uUwwnuMYT6JZGtOOH2VJxqkXLyJA/LkDiFUfKwte5RaH6mhy?=
 =?us-ascii?Q?TiuewGS9b7vKxy/iooXZn+OI3OKhMxmdy7g+NYPsL5jZxUQyrwLdzqEntuye?=
 =?us-ascii?Q?7kyGxTrxo2Ego/BGNnDIQ5rsMgWelkWrmX+0wLBUO+ClwXWHSTCEWf3A6X3W?=
 =?us-ascii?Q?sWRfX5a+I683+9X4vNy9e+Vo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d676bd4d-a1ef-4445-6aa5-08d95e53a8ad
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 12:12:45.7886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pllsS1bsZO2Axk3gd8aZZI6RWE6JcHtipu/RUKKSNiZaa65kWBbb7PWdkMyLfztMtKmKPt2nlJkhCfRh0EGJNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3789
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130074
X-Proofpoint-ORIG-GUID: XLXJNsW3uLXyUlrZXrMjULYdKt3ODrcl
X-Proofpoint-GUID: XLXJNsW3uLXyUlrZXrMjULYdKt3ODrcl
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

commit 80e9baed722c853056e0c5374f51524593cb1031 upstream

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>

 Conflicts:
	fs/btrfs/qgroup.h
---
 fs/btrfs/qgroup.c | 8 ++++----
 fs/btrfs/qgroup.h | 3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 78146501c665..a7344c7d3160 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3800,8 +3800,8 @@ static int sub_root_meta_rsv(struct btrfs_root *root, int num_bytes,
 	return num_bytes;
 }
 
-static int qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
-				enum btrfs_qgroup_rsv_type type, bool enforce)
+int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
+			      enum btrfs_qgroup_rsv_type type, bool enforce)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
@@ -3832,14 +3832,14 @@ int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 {
 	int ret;
 
-	ret = qgroup_reserve_meta(root, num_bytes, type, enforce);
+	ret = btrfs_qgroup_reserve_meta(root, num_bytes, type, enforce);
 	if (ret <= 0 && ret != -EDQUOT)
 		return ret;
 
 	ret = try_flush_qgroup(root);
 	if (ret < 0)
 		return ret;
-	return qgroup_reserve_meta(root, num_bytes, type, enforce);
+	return btrfs_qgroup_reserve_meta(root, num_bytes, type, enforce);
 }
 
 void btrfs_qgroup_free_meta_all_pertrans(struct btrfs_root *root)
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index d1f93585f217..0a2659685ad6 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -349,7 +349,8 @@ int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
 int btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len);
 int btrfs_qgroup_free_data(struct inode *inode,
 			struct extent_changeset *reserved, u64 start, u64 len);
-
+int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
+			      enum btrfs_qgroup_rsv_type type, bool enforce);
 int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 				enum btrfs_qgroup_rsv_type type, bool enforce);
 /* Reserve metadata space for pertrans and prealloc type */
-- 
2.31.1

