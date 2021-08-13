Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BB63EB3A4
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 11:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239981AbhHMJ4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 05:56:24 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:11346 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239995AbhHMJ4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 05:56:23 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D9pTks007747;
        Fri, 13 Aug 2021 09:55:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=yJygOy7GffoQaQFjEZeMDh40uSheu3ewQYjb2/c7ZQY=;
 b=KT0EC2iQZ8NmdyEsW10rx30Sl+T9BNj2mpkHpOx4dsGzo2NIDDGpxoM5KuJsXR3er5rW
 XuthFJrryfFxo23dSLtoN8BJmL0xGabL3SA8rzpiTySPUTlJTB4QlnuEYpYQVzT/8vDj
 mqHGKR6ui9uV9NxzUhndTkslLPy9oG6RKq3jSJnsatK7SPztnwLknfmc/anHnOW+O5hs
 NSaao18K91HvUCaxcJDQ6zDnix9H2QoJuuF2aXlBRWziljajsLXtqa6/NATCDWvaw8WI
 2kNE6KFVrXm0QDxY4fv9Llt13ocoW1VBOh08v1z071JgbIzHqqrMR4rIIAMR3cSOBrKp dw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=yJygOy7GffoQaQFjEZeMDh40uSheu3ewQYjb2/c7ZQY=;
 b=IKtzuo7UyqEgzZZk6jbLonEDuN+dgbcr4ONwvFlEwYRP9jhOCBQ4bXl8L3dVKlm+q08H
 u9qWFvtIGiRe2jGRCGRvL9hmfwyDKm+/QoUdV4hw2PwYLwEhV+m2bw/se+OeIC8hnhtc
 T4B09p3p3kTF3Fp8+MCJbTKoODb1r3K0nrnz/ouEo6Xb9Jpaj2ClKS66vFw+AxNwWDzI
 g2Dj5v1vdIxv2wIpjCkoQWf5bvvVsMHT4fn0PU6sUfl+073o6KqLpUaR+jWv6PVMbBhr
 5yl2J+Mi0ueAADBqIFsYi6jQA/Oz0e+pzCSdefQgzZ0FhnmHFyzcOo4wUigMOjNDUtnc Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aceudvyqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 09:55:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17D9oYVJ035806;
        Fri, 13 Aug 2021 09:55:52 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by aserp3020.oracle.com with ESMTP id 3accrdrqq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 09:55:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJ2M8Fxwr4JVtZ8fAfHUZY8YBgKl60CWN/YR1FM5wcmSrVrMa5XFdA+0+EYAvwkZsDFApPCY0+inKnbPd5/XtIkbrjsLmT528ti8jVyOdQdb7ZjSFh4k+XL6rUVacqXvZam/djkC2DGumoQpcCrsELoY9Z4C39QcaOFJ5/R5WreSfBQr6kzfHll+sGJ155/vEYdlFQG9lsb9Pgoq2aOV2I0tYH6Bf/OQAD1nzG0TKL4sSS5ufO3TGy6YtCEgAvaf8MldVTiuBbzMI1pmo7dGi5kBO8c55t93P+f7fjkC2jxrDlY2lQs7Ea88+2kuU1/0MWHv60G/AshMrkfCPVZRGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJygOy7GffoQaQFjEZeMDh40uSheu3ewQYjb2/c7ZQY=;
 b=nzt6bkPmo0qBcbP4cRlobxKcGSCIGm02HsDNxSdHEjsaxU+/ww/hzAZXV0zku2bSlUpuisEHxLatk5micwCe9J91MpDMDXQWsPPfWxbE1GUbRwXBaDssNLQ0w/tcXEQmRJNAqDPKLnXR9+q4KGthQlI258fKufXYEFiM1Z6pFTWtxfbU/gfqNlImDY6opJp61jMk7CIh3bmhhfQViT4syVez40vT2edcBIlviT0eBoO8ncSKw6pwg/GefplTcX2iuHX2xuqgPzOyN+xFv/rRpla57S7Q9CT2fWVkmMadZUtGW1Fa/w5l+UOpUK5YoyNGkSQse0NBO9xsh05bPP0Rvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJygOy7GffoQaQFjEZeMDh40uSheu3ewQYjb2/c7ZQY=;
 b=lj+JLZDRiBHo9aNWlblUHmiO2wdVVBAmxZP+F7dMHR+J/8cENvXunYHHmnWX7r/YzHHVKOQWVgXCJiqNf3m0eLJ+Ol+frnxdqzk9lIjN7B3gWQ9GR1A/PC00XLospB4lOTZ5d8iajuJu2xOL5K7spXXRWcnQUg/iJteDWdUpjzc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by BLAPR10MB4852.namprd10.prod.outlook.com (2603:10b6:208:30f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Fri, 13 Aug
 2021 09:55:50 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a%5]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 09:55:50 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 1/7] btrfs: make qgroup_free_reserved_data take btrfs_inode
Date:   Fri, 13 Aug 2021 17:55:24 +0800
Message-Id: <8a1f31bf0f35535bb38d906432d78a7de7fdff2c.1628845854.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628845854.git.anand.jain@oracle.com>
References: <cover.1628845854.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0124.apcprd03.prod.outlook.com
 (2603:1096:4:91::28) To MN2PR10MB4128.namprd10.prod.outlook.com
 (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (39.109.186.25) by SG2PR03CA0124.apcprd03.prod.outlook.com (2603:1096:4:91::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Fri, 13 Aug 2021 09:55:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5b155ce-b1c2-4725-882c-08d95e4087c4
X-MS-TrafficTypeDiagnostic: BLAPR10MB4852:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB48524DD5EF6BCE4118B8EF87E5FA9@BLAPR10MB4852.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:418;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zO4pKcqPCChEkQhDAoLL4mpLgz5moTGbSHvODPZgkflOmcV6HyOYAYjv49XEX1Q+8eQKfphsgsU2qIWrzgj/NPlgtwROX5bI5HPTzkLVzMma9Fu1KLZb53cYT+2rAOFNPDVCwk3B77uxClnsHXempivfl25i1MxDyEXVQAlcYNN/ljngQzo6emmdcklabydbjmwR1C3b9bJe3j/+MxhQ1sNxyfXtjigWaQHmAplKDVmF9BkyIF9oBI9rk/LG26cSQn9+mf8qq4H6+MRuM2SZ5TeT4GqGL30VxaTXxu5IRWC/fNrV8oCDEVW6JLh31a2EVm15eSSN3qhwa7cH6z4fxfYY/fMMieeyLNEVlTeRDvFNKODZlsLmEYeR9F3yKL+kvwSBVrmJJnCtCs8G4tVr6XujDsIfAXBFcS5wmxN/IL8PQ994xE6OjfgGRtqmMUW5qYOFojcb36EAbCsgByNoWG0PCVfd3r65BuAKEHBY2SSQKpifUz5o/FlSCPwX6yim0V6TshrU5omVF4uJm8AWoUfzZwi5IMxyl+/8gxB8oL82jDq/BZmk4hZDHLgiXfarzcof8T7cCjSd2r/gh9Qp9Hao0KnvYQ3o1YCQWH+rx9OfxAB1CaZH4JfRuZICOirCwv0lbI9IuvniFxjzgsJpqnq1YpBb3Bx9P4PIGi3zcXbGmLtKXyzC/ihsLejjIXDJm68Bqo1IS6mz+eZ0oinREA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(376002)(346002)(107886003)(8936002)(8676002)(2906002)(478600001)(316002)(83380400001)(54906003)(44832011)(4326008)(956004)(2616005)(86362001)(186003)(66946007)(26005)(66476007)(6666004)(6486002)(6512007)(52116002)(66556008)(36756003)(5660300002)(38350700002)(38100700002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sBkn7r1KfOilaekiYNB/TtQprfl/phrNRcXBCEToK2UYEq/wqvO1IitDlcRJ?=
 =?us-ascii?Q?RjX5Kau7MxVO60dlpFc06iCNAQdJqvMpN8vsqBaCay1vbJrUPdhW/hiPS60p?=
 =?us-ascii?Q?Wg8q5BMR3gmUVlXZTFjf1xx6OQVv2RLO657PSX0cuOJ7UjAcRdzSojZs+EGc?=
 =?us-ascii?Q?dnS0A9yZDFfcFj9WF0HzkQ1XRQehLEaKV9TDAcUfpkJSuwaynGmMqfUYkCKa?=
 =?us-ascii?Q?rT4FrMCMIn2be8uTbK6Bwdtlt6iy4rWXULCAqfXEe1H1UTGBapGDZ2qnhi3h?=
 =?us-ascii?Q?3Mb85S2U1jLUfqXyVYXck/vzEi55fklNERev5jWmKtamX4zdsJxT4g0IrEsG?=
 =?us-ascii?Q?LXMRuK6p2KlE+lRLsFmHzdIz2cFmaj9gAAf1tRIwhWEL7kJddFI8FbJh7W6o?=
 =?us-ascii?Q?JTG1u20BgbAaBUw7DV7oda3SYBh653XeFJ86C0IMPuKyzK9fCW6QWQbCaESO?=
 =?us-ascii?Q?vMQc3mpPKUg37Pi5/cdx+N5HXaqpiug+cJ84lMP/2sP3WXMbFOmmgVaJ5AZQ?=
 =?us-ascii?Q?yW2g2bV065Y6w0AbG6n9DFO568fAKXeu5TlBRBhiF36xWhXE9M0r0bJl+yvO?=
 =?us-ascii?Q?E07Wdq02GjOmttlrX3dAH2yEk813QVbkbLq4cATsZzrW/+WkCkKAMbCW/ahR?=
 =?us-ascii?Q?Pislt4HJHb/s4U3hZDk33xCcAJ43V2YxRep5X/eaCiLMwjLgh0opa9zQjEYb?=
 =?us-ascii?Q?CJMWyesUf8C0S2uvXCP57Y11t66UUlLzm3ME7/DrjrKd0G8oWmecQX55yrJc?=
 =?us-ascii?Q?nakR+93E4hHCbNPZEfjuHZ9w+spE/eyGenZQ9Jc3xViZKpSeBcjf9k+oseOY?=
 =?us-ascii?Q?esU8aN+eFs1uh5wVTbIxEs2psM1NTSEQDsrw4GG3vyC3krP+RZ6AgndQ41uQ?=
 =?us-ascii?Q?plUwLowFhfVmU2ODrzWRav4CRIBATQim8BvMavERK7PvHz+aMNUcqBG/BeMg?=
 =?us-ascii?Q?6YTUGO01xYPRwyaT//GKlVi8mwGmH5Yrob+FmJUdex0CjbFWY7fkYKi+5+N1?=
 =?us-ascii?Q?C4O/82YG8ANNRSJxcC/gbiJAi0ZkeMY0uLjPaEAFlT725wdNG+C2cLEmie4L?=
 =?us-ascii?Q?6NwBzs3qocuiuczjt0wYhtK/s3RtGW4IuXyRuvNMfI3IWfvkG3fBjF/GebSE?=
 =?us-ascii?Q?mIjMbD5fMMCTWmL3JjIi/PCWEuR7SOYMjhzczbR0yMVlvJQ7ed+FFZ4frSzd?=
 =?us-ascii?Q?MIUxbhv29lpQ2ISvEEbNst9mVEyAfHaWKjsojfAKzN6LVaP3f5frLmVS5Qz4?=
 =?us-ascii?Q?ysycxSDlY/6sEjOEsyRng24+7lZONwqy7owTlV7hEmxkg3lJgvvrdNfMRSG3?=
 =?us-ascii?Q?gCkn9KzOEA50PpzOWVnAJdI6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5b155ce-b1c2-4725-882c-08d95e4087c4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 09:55:50.1613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Db3Whh5lHCFGhLkhndtG0udbpKZrt7WUcrov1JUx4y4ctLRtCMvgT+OG2OaUQVAj3C2RHajugwVE/5YGueFTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4852
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130059
X-Proofpoint-ORIG-GUID: PblvL4UyEoePfi0rc9q1-czKmSIhvHz_
X-Proofpoint-GUID: PblvL4UyEoePfi0rc9q1-czKmSIhvHz_
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

commit df2cfd131fd33dbef1ce33be8b332b1f3d645f35 upstream

It only uses btrfs_inode so can just as easily take it as an argument.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/qgroup.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index cd8e81c02f63..1f214f80d664 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3481,10 +3481,10 @@ int btrfs_qgroup_reserve_data(struct inode *inode,
 }
 
 /* Free ranges specified by @reserved, normally in error path */
-static int qgroup_free_reserved_data(struct inode *inode,
+static int qgroup_free_reserved_data(struct btrfs_inode *inode,
 			struct extent_changeset *reserved, u64 start, u64 len)
 {
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_root *root = inode->root;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
 	struct extent_changeset changeset;
@@ -3520,8 +3520,8 @@ static int qgroup_free_reserved_data(struct inode *inode,
 		 * EXTENT_QGROUP_RESERVED, we won't double free.
 		 * So not need to rush.
 		 */
-		ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree,
-				free_start, free_start + free_len - 1,
+		ret = clear_record_extent_bits(&inode->io_tree, free_start,
+				free_start + free_len - 1,
 				EXTENT_QGROUP_RESERVED, &changeset);
 		if (ret < 0)
 			goto out;
@@ -3550,7 +3550,8 @@ static int __btrfs_qgroup_release_data(struct inode *inode,
 	/* In release case, we shouldn't have @reserved */
 	WARN_ON(!free && reserved);
 	if (free && reserved)
-		return qgroup_free_reserved_data(inode, reserved, start, len);
+		return qgroup_free_reserved_data(BTRFS_I(inode), reserved,
+						 start, len);
 	extent_changeset_init(&changeset);
 	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start, 
 			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);
-- 
2.31.1

