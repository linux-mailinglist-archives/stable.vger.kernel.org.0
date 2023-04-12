Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A5E6DEA60
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjDLE1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDLE1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:27:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DFA2D7F;
        Tue, 11 Apr 2023 21:27:04 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BL5cNQ030970;
        Wed, 12 Apr 2023 04:26:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=AgXA85vrokK8APl9KPjwu5YMWyEDfxrNR3IWcdOcoys=;
 b=mOpUGKCBPs59FFbhmgptrRUXgbv/+caC1gN+JNJsIsywV3kxKmra751ryBNUWgZCBXeJ
 Ny4SPW3dE9UTiDB7ImkBYyTzwLVHXw5y6OZ14AWfUt+nUgdoAq5G+ouYTy+1cYzENNJX
 ERgZ9AzrgT9rQiS6On7gJMAg74uAgLkzwG9pEzzCSl0KTMB/h6ZfaIDdy/5zpvC0NPrh
 VvWkE3uo8vxxvVhblfG62BWzytygbPwNgXv/Uj6WEHXi4OL4lidjSbmri1U4d8D0tjLJ
 lJnEkygMq70MSO+tmGTkA3yqiVDlIqGOO9B5UY/sI6pKF8dkOEyb+FrAtNXhfwaPyyBt oQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0ttq3pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:26:53 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C2ClIx024983;
        Wed, 12 Apr 2023 04:26:51 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwe88kyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:26:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kEyS+ZRNthBAAVGXJMeWANGXL/oAJDVqMLgyD6cd54zBqOAU27v7yrEdjlSFrWnTQRtswSqFNdJR1bbN6xPjClD1oH9CWjb5UR/MqrdNemBQoiMJgh7+VVCQjW37LmPX4mmkoVx/pRmpROxli/vQvg8baPGBiriCST5xMcPSPKM6k9ZlyeeTTsCeYDzY0CCLYFYxR7ZDMs6kIhK676CwyAG4udaYLki4HbAep3rDr3H8baIOK9VeXE4QmYv0W5Q/gOQYUKaoqajujPanPB3NfBHUs/Hy3k+0jeSCDMRhcTEdD1yZ6SoU+RLw1Zlr6r6Qkmalsw77cYGRvSB7cQf8qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AgXA85vrokK8APl9KPjwu5YMWyEDfxrNR3IWcdOcoys=;
 b=FF5KLQevnoixdVCnLmeEHVqSCV3ucGzNMjlO+eXXfWE3hruKI7GKeA/WSLh/yshnLYwJcJusIZH0HniRzxggsymcwq5uwUPbA7mCg6dPJETe1eu7vBxBiy0j0Pi3VLpQ7IiQPKo5fN3lX+OVCQnNFOVwNqFZy8z6ThbvTPpRSoNwT6e4W9FpxFHos4XSVZdJbZcGquAQYy+jzg6XJpXDvPqNkRbsr9VKHDntG7ulAQ8YvMTt0J014KGNbfQjiMJwVwtPZ5dwctRzya7uYEfEqOtoiFhYkYtARjsK6yHffHHWUYOGjSIg/qHJ+yHU8Yn4ly7yGAIUAShEU6v+I2Oh9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AgXA85vrokK8APl9KPjwu5YMWyEDfxrNR3IWcdOcoys=;
 b=pa33odjiLGl0IFNPKJhwNqQmnTrrzQ1mLDqMJr/Jofni3duQtbiSoPZVXXGFCZTsALPxbKs5MAvXWqaBpLv/7tdaCWw8Y+Vl00JeuajLWmCqujN71dQsfkaYK2ArtXF5+cqXrWRjszyD46eKCrRLGc3Dw+KlDF5SjoWQaYDxqjg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SJ0PR10MB4559.namprd10.prod.outlook.com (2603:10b6:a03:2d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 04:26:49 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 04:26:49 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 02/17] xfs: merge the projid fields in struct xfs_icdinode
Date:   Wed, 12 Apr 2023 09:56:09 +0530
Message-Id: <20230412042624.600511-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230412042624.600511-1-chandan.babu@oracle.com>
References: <20230412042624.600511-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0068.apcprd02.prod.outlook.com
 (2603:1096:4:54::32) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ0PR10MB4559:EE_
X-MS-Office365-Filtering-Correlation-Id: 82f04452-fc8a-430f-8566-08db3b0e220c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UILA9bJP1+/SnHDSzFqB5Q9e//N4phcIiOWMoRdd3lMrHQnBmPPoWD9wEJ3OPvU6R7fOyyf2e5eXxXSHEtqcy8BoUlb156xCu9ASKeswOJb0E96mRj028o+OW6C3k2Z4d0vZiQJlIwxPQsmUftoy8kbFbZDpdt42MMqU+PXfXF5SFcED1ZSw8yc3+S7ScXcAZzYOxcT6+qIKuzpMbXZ1LkYIrKHHsyfp6TDDCKGNiNJPdtbnUh8RN3ZvRWdVJ6bq/JVU3e/50ENVa12cmbhk1ZqX3O3tdyDrLPiesSX5nPCGi7SLCOJ5GEmbuUVMDHHD75kiYnVDeM481zcD9vGN+tVEa9qCCi1a6OOWfAw54a/wf3NTpOzihJjS2FFATv6zI7TrtEnOdn8t5vLaox+jIZhTxdzmiE0XckRHHztvB9+K32CgXSeCtCgAD0WRMd8mgczwY90pFWlg7b4CfFkmQ0hwPxhJ3FaDn9xLHSUxmzGS9o5lGVK6Fu3ScOQ+5J940ROr88/unZa5LyrrV589K+YN64JWuCEvlJ1g79JuHr08Otwrjl8Yz8DQY/GtR3Zo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199021)(38100700002)(66476007)(66946007)(8676002)(6916009)(86362001)(66556008)(478600001)(4326008)(186003)(2616005)(26005)(316002)(41300700001)(36756003)(2906002)(6512007)(1076003)(6506007)(83380400001)(6666004)(8936002)(5660300002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AXRkFpASBERKJMyr8XHuN33pX1YekW7AgJbwdcZqtsMyA14D+2+Ys1gOGNqR?=
 =?us-ascii?Q?ux8f8uQ/21f84RPxn4XkyHYz+fqianGFORMVY3AFsjazf1nQTQ1FyxHGaRRL?=
 =?us-ascii?Q?Gqfsez0Y+fP7cj0WeBtDzBLIQiJ3Sxk118cpQnVYRWBH0U6g8XIdMsqd2QkM?=
 =?us-ascii?Q?BRTYvCG+ROzQNDg39Y+RgterWELQrQyjTsYhjAolClP4jNo91mtykQ1Mh914?=
 =?us-ascii?Q?86h4M+R7IcVfQ8FBKhL4SgjYFyBeKWE0Rc3Cv8ZSlI0q6ywmLbG+wouVDy87?=
 =?us-ascii?Q?MZOHC0eCvvOiqttV/6WaF6szJ4fzhH7PHHvVao12Yse6CN3dsJslAMnE5U1y?=
 =?us-ascii?Q?AQeJYlm7i8JYKkY5lLmy40ptNyVkqR4lryrVID99UsQ9BY3ZMxRw9xddKV3K?=
 =?us-ascii?Q?jYVl4grmKU4SZWofed95jqo4l8j0IpBMhO/KIFhL0hLKbmpBih65gcVBVoPh?=
 =?us-ascii?Q?HqsaeRCCQg/qjFjaayq7FYt9dhGUdXTkxffApZEioBEW+gO58EmnojuTaCHZ?=
 =?us-ascii?Q?5Q+qXZEkLTM9RtACm+wltxd+5fYHRGgZiYRuS8gf9h9kCxoY8cveGYqNCGPn?=
 =?us-ascii?Q?X+esW6JEZVpJKsLys7ZDo1sGUjnH9wwuJCscN/wjW43SgPPOQLtoZDlGkc4M?=
 =?us-ascii?Q?IfHTxW4AA3qZzqBLlpj8BxlmFpD1PcemrzqpmiRkm9DmpYNYxDWi8bEERFkV?=
 =?us-ascii?Q?BFprcH8jfzajOb4Owiw1p0QNXOCTDsfjdVnNeKfsFCXrKxcM/FP1wMCZvEMs?=
 =?us-ascii?Q?Hf2CbDe5BvxFPBhgZ+1QXLR+mGWFSbfB7f80KT1v1Awt9llr4tCR1xjUJIV5?=
 =?us-ascii?Q?/MYjfGAxzxGQHXhcWPVdBywWA9Ja6cQUnYHI2LYztAkKTQzlsbbqTfZo56yZ?=
 =?us-ascii?Q?SBidBNrzE3uPPIBVAqfqY/vFV9DcGZEKgAAOVHPAx1xw+8uhNJjj03XMh27M?=
 =?us-ascii?Q?0gjWhj1UPcMScSJWd6lv8suTR/toy70eI/EAqWwGZNqBGpRpN/Q79P+92aiZ?=
 =?us-ascii?Q?4MY0V01kzH/YqM45cf56c1Hlz0Lo1JypdCpwUbF7B5pP+0FlB+G+X9nWv3a6?=
 =?us-ascii?Q?mv1AwzCc2IYbGG0ZRIr8Qqar1psKXhdqyS0O8oE+0AiBuzdMFkuLIN+7ZBVb?=
 =?us-ascii?Q?AoWBfrNlHYmV1fNBHXRLVYZgLipuzDlCGIiejNgiTA8zp09uDSpYbnV1qHMR?=
 =?us-ascii?Q?KuCZIP7UZelXYRqRT0/ZVCtwWqw7LfdW46c0YAu6kOTDejHXnN3n3a+1WO/o?=
 =?us-ascii?Q?7qGS4g3tV4I8+mmYAty3EpUPM1ft6ripDsnNqwXMjAp9xVqZfXr0FLmjxhPV?=
 =?us-ascii?Q?pip3lFxgeYI29cQ85XHRr+XKRRLMmehbyyTwzS1cSmOaoupFAnbqlUUjc/sI?=
 =?us-ascii?Q?Oqo7+rg5VKH6EpOos+ILf5HRtw0ucHFdEWRoeG1hIsc/nwRtlmzyNBsmgBBy?=
 =?us-ascii?Q?zqSFYu3MuU/KNsycJQWzyXEGK01DzYoFAVysyiwUstGv3ViRe0MTG/fBzW4T?=
 =?us-ascii?Q?6Pvz23+bSSPqGzuxZ+OBydNMyDFwXQDfO+zkjfmqaEIJk3brCGbkEm+WXRqf?=
 =?us-ascii?Q?7fU6R7ULJ7tk0pzg8mSxYzOyrZuF0sJTGBvx3rkP2eJ6slkGNZdKaSKFH3l9?=
 =?us-ascii?Q?Zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Ue7g13gmQniBYBZxScs1IUtVB2TmNXYUunWxoWqylU8+Y/oWI99LQymI6s4DVSBSKeWAE4b4c00WDl/VXCmLBFsnrcvAK5a1dtyQ9caUjHKkppAlUkEvMnuXtiHvuCgoo+HpvLa19moD7WKg0JCO2/in+irC6si00SxmZ3WCaOl11X97zxw6LDV6j8b4b1UMlQzW4KValIkNcgA9ZyVjHhkAAwJBbUhaNvh95kYpoL57ZLBMukjO5ncV6t4Wx5YKl8qRqpGrLIp0rkPxBSnn3MJjHuCY+KtMIdT+TFWlgDYAAOquYa0UkuMbHdTuVrIEt0j0JnG+/qOkfOYUKvDvAOtvbSlX4giHEBNLo5DS44r/jgW62+MeMUJlmJu10YF2OnCivtDxov7rTJv9m5fQ6Py8Q6jublcrAdk9NyxAmryJ0Zd0FIVtzrSRm8rlDeyD5HuhvNAL1mUK0CCthstR7JML2OYkyRpDF3peGeJpQufE7G8a15U9iUYOMKx2OlhYpnGTdnAM8ARbr6Ad1yzp+JNmiFFTJH8myWdvjYv/LB+1fSla6tXWbjI7mCVAmsoArW8n6M0l1XfLBrJwr4riklHbgFcGhYeGnarndeD3iGxNGJYDaSxy3XousyHE8t/HnPCjDL/jwmze6W6r6/SmtFpj4IbRxZysbquaNsp6vE+LCAijmsmJm2Sv1CXbxoDX5+372di0URfss+CUyc7aX3ia0YtIvvUqIvoiBkLHXiM5fkNbjAEIJc9hMsonzRQixQM7IT6B/YXf82scnKmp0jqwXSC/FrVuNPAN2QAjtTa9IuioVQwrcNz2zmU/VtD/oOGBM8tny2QPqPLcG0R7NN68Uwgc770tQlY5CEtNcchGTehl4txAi9r+uZyLv84F
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f04452-fc8a-430f-8566-08db3b0e220c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:26:49.2746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z9zdL7sIF2wCENzu+hywoY9frw0QSPK5cs1+VpVDJgczi/fiVuLbnBPTnYezfokmnFlOHxyKgRNl7RWY7IoV4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120038
X-Proofpoint-ORIG-GUID: Pfi2oKVeHfDGVENhb9-YPnUha41J5I3V
X-Proofpoint-GUID: Pfi2oKVeHfDGVENhb9-YPnUha41J5I3V
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit de7a866fd41b227b0aa6e9cbeb0dae221c12f542 upstream.

There is no point in splitting the fields like this in an purely
in-memory structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 11 +++++------
 fs/xfs/libxfs/xfs_inode_buf.h |  3 +--
 fs/xfs/xfs_dquot.c            |  2 +-
 fs/xfs/xfs_icache.c           |  4 ++--
 fs/xfs/xfs_inode.c            |  6 +++---
 fs/xfs/xfs_inode.h            | 21 +--------------------
 fs/xfs/xfs_inode_item.c       |  4 ++--
 fs/xfs/xfs_ioctl.c            |  8 ++++----
 fs/xfs/xfs_iops.c             |  2 +-
 fs/xfs/xfs_itable.c           |  2 +-
 fs/xfs/xfs_qm.c               |  8 ++++----
 fs/xfs/xfs_qm_bhv.c           |  2 +-
 12 files changed, 26 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 28ab3c5255e1..e1faf48eb002 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -213,13 +213,12 @@ xfs_inode_from_disk(
 	to->di_version = from->di_version;
 	if (to->di_version == 1) {
 		set_nlink(inode, be16_to_cpu(from->di_onlink));
-		to->di_projid_lo = 0;
-		to->di_projid_hi = 0;
+		to->di_projid = 0;
 		to->di_version = 2;
 	} else {
 		set_nlink(inode, be32_to_cpu(from->di_nlink));
-		to->di_projid_lo = be16_to_cpu(from->di_projid_lo);
-		to->di_projid_hi = be16_to_cpu(from->di_projid_hi);
+		to->di_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
+					be16_to_cpu(from->di_projid_lo);
 	}
 
 	to->di_format = from->di_format;
@@ -279,8 +278,8 @@ xfs_inode_to_disk(
 	to->di_format = from->di_format;
 	to->di_uid = cpu_to_be32(from->di_uid);
 	to->di_gid = cpu_to_be32(from->di_gid);
-	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
-	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
+	to->di_projid_lo = cpu_to_be16(from->di_projid & 0xffff);
+	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
 	to->di_atime.t_sec = cpu_to_be32(inode->i_atime.tv_sec);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index ab0f84165317..af3ff02b4a8d 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -21,8 +21,7 @@ struct xfs_icdinode {
 	uint16_t	di_flushiter;	/* incremented on flush */
 	uint32_t	di_uid;		/* owner's user id */
 	uint32_t	di_gid;		/* owner's group id */
-	uint16_t	di_projid_lo;	/* lower part of owner's project id */
-	uint16_t	di_projid_hi;	/* higher part of owner's project id */
+	uint32_t	di_projid;	/* owner's project id */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 6231b155e7f3..f59c3265dae7 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -863,7 +863,7 @@ xfs_qm_id_for_quotatype(
 	case XFS_DQ_GROUP:
 		return ip->i_d.di_gid;
 	case XFS_DQ_PROJ:
-		return xfs_get_projid(ip);
+		return ip->i_d.di_projid;
 	}
 	ASSERT(0);
 	return 0;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index a1135b86e79f..8e6dc04c14d4 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1430,7 +1430,7 @@ xfs_inode_match_id(
 		return 0;
 
 	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
-	    xfs_get_projid(ip) != eofb->eof_prid)
+	    ip->i_d.di_projid != eofb->eof_prid)
 		return 0;
 
 	return 1;
@@ -1454,7 +1454,7 @@ xfs_inode_match_id_union(
 		return 1;
 
 	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
-	    xfs_get_projid(ip) == eofb->eof_prid)
+	    ip->i_d.di_projid == eofb->eof_prid)
 		return 1;
 
 	return 0;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 02f77a359972..891f03a3fd91 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -809,7 +809,7 @@ xfs_ialloc(
 	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
 	ip->i_d.di_gid = xfs_kgid_to_gid(current_fsgid());
 	inode->i_rdev = rdev;
-	xfs_set_projid(ip, prid);
+	ip->i_d.di_projid = prid;
 
 	if (pip && XFS_INHERIT_GID(pip)) {
 		ip->i_d.di_gid = pip->i_d.di_gid;
@@ -1418,7 +1418,7 @@ xfs_link(
 	 * the tree quota mechanism could be circumvented.
 	 */
 	if (unlikely((tdp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     (xfs_get_projid(tdp) != xfs_get_projid(sip)))) {
+		     tdp->i_d.di_projid != sip->i_d.di_projid)) {
 		error = -EXDEV;
 		goto error_return;
 	}
@@ -3299,7 +3299,7 @@ xfs_rename(
 	 * tree quota mechanism would be circumvented.
 	 */
 	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     (xfs_get_projid(target_dp) != xfs_get_projid(src_ip)))) {
+		     target_dp->i_d.di_projid != src_ip->i_d.di_projid)) {
 		error = -EXDEV;
 		goto out_trans_cancel;
 	}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index e493d491b7cc..62b963d3b23d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -177,30 +177,11 @@ xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned short flags)
 	return ret;
 }
 
-/*
- * Project quota id helpers (previously projid was 16bit only
- * and using two 16bit values to hold new 32bit projid was chosen
- * to retain compatibility with "old" filesystems).
- */
-static inline prid_t
-xfs_get_projid(struct xfs_inode *ip)
-{
-	return (prid_t)ip->i_d.di_projid_hi << 16 | ip->i_d.di_projid_lo;
-}
-
-static inline void
-xfs_set_projid(struct xfs_inode *ip,
-		prid_t projid)
-{
-	ip->i_d.di_projid_hi = (uint16_t) (projid >> 16);
-	ip->i_d.di_projid_lo = (uint16_t) (projid & 0xffff);
-}
-
 static inline prid_t
 xfs_get_initial_prid(struct xfs_inode *dp)
 {
 	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
-		return xfs_get_projid(dp);
+		return dp->i_d.di_projid;
 
 	return XFS_PROJID_DEFAULT;
 }
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 83b8f5655636..a3df39033c00 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -310,8 +310,8 @@ xfs_inode_to_log_dinode(
 	to->di_format = from->di_format;
 	to->di_uid = from->di_uid;
 	to->di_gid = from->di_gid;
-	to->di_projid_lo = from->di_projid_lo;
-	to->di_projid_hi = from->di_projid_hi;
+	to->di_projid_lo = from->di_projid & 0xffff;
+	to->di_projid_hi = from->di_projid >> 16;
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
 	memset(to->di_pad3, 0, sizeof(to->di_pad3));
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 7b7a009425e2..fd40a0644b75 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1144,7 +1144,7 @@ xfs_fill_fsxattr(
 	fa->fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
 	fa->fsx_cowextsize = ip->i_d.di_cowextsize <<
 			ip->i_mount->m_sb.sb_blocklog;
-	fa->fsx_projid = xfs_get_projid(ip);
+	fa->fsx_projid = ip->i_d.di_projid;
 
 	if (attr) {
 		if (ip->i_afp) {
@@ -1597,7 +1597,7 @@ xfs_ioctl_setattr(
 	}
 
 	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
-	    xfs_get_projid(ip) != fa->fsx_projid) {
+	    ip->i_d.di_projid != fa->fsx_projid) {
 		code = xfs_qm_vop_chown_reserve(tp, ip, udqp, NULL, pdqp,
 				capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
 		if (code)	/* out of quota */
@@ -1634,13 +1634,13 @@ xfs_ioctl_setattr(
 		VFS_I(ip)->i_mode &= ~(S_ISUID|S_ISGID);
 
 	/* Change the ownerships and register project quota modifications */
-	if (xfs_get_projid(ip) != fa->fsx_projid) {
+	if (ip->i_d.di_projid != fa->fsx_projid) {
 		if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
 			olddquot = xfs_qm_vop_chown(tp, ip,
 						&ip->i_pdquot, pdqp);
 		}
 		ASSERT(ip->i_d.di_version > 1);
-		xfs_set_projid(ip, fa->fsx_projid);
+		ip->i_d.di_projid = fa->fsx_projid;
 	}
 
 	/*
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 80dd05f8f1af..05adfea93ad9 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -668,7 +668,7 @@ xfs_setattr_nonsize(
 		ASSERT(gdqp == NULL);
 		error = xfs_qm_vop_dqalloc(ip, xfs_kuid_to_uid(uid),
 					   xfs_kgid_to_gid(gid),
-					   xfs_get_projid(ip),
+					   ip->i_d.di_projid,
 					   qflags, &udqp, &gdqp, NULL);
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 884950adbd16..f1f4c4dde0a8 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -84,7 +84,7 @@ xfs_bulkstat_one_int(
 	/* xfs_iget returns the following without needing
 	 * further change.
 	 */
-	buf->bs_projectid = xfs_get_projid(ip);
+	buf->bs_projectid = ip->i_d.di_projid;
 	buf->bs_ino = ino;
 	buf->bs_uid = dic->di_uid;
 	buf->bs_gid = dic->di_gid;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 6b23ebd3f54f..8867589bfc3c 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -347,7 +347,7 @@ xfs_qm_dqattach_locked(
 	}
 
 	if (XFS_IS_PQUOTA_ON(mp) && !ip->i_pdquot) {
-		error = xfs_qm_dqattach_one(ip, xfs_get_projid(ip), XFS_DQ_PROJ,
+		error = xfs_qm_dqattach_one(ip, ip->i_d.di_projid, XFS_DQ_PROJ,
 				doalloc, &ip->i_pdquot);
 		if (error)
 			goto done;
@@ -1715,7 +1715,7 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
-		if (xfs_get_projid(ip) != prid) {
+		if (ip->i_d.di_projid != prid) {
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, (xfs_dqid_t)prid, XFS_DQ_PROJ,
 					true, &pq);
@@ -1849,7 +1849,7 @@ xfs_qm_vop_chown_reserve(
 	}
 
 	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
-	    xfs_get_projid(ip) != be32_to_cpu(pdqp->q_core.d_id)) {
+	    ip->i_d.di_projid != be32_to_cpu(pdqp->q_core.d_id)) {
 		prjflags = XFS_QMOPT_ENOSPC;
 		pdq_delblks = pdqp;
 		if (delblks) {
@@ -1950,7 +1950,7 @@ xfs_qm_vop_create_dqattach(
 	}
 	if (pdqp && XFS_IS_PQUOTA_ON(mp)) {
 		ASSERT(ip->i_pdquot == NULL);
-		ASSERT(xfs_get_projid(ip) == be32_to_cpu(pdqp->q_core.d_id));
+		ASSERT(ip->i_d.di_projid == be32_to_cpu(pdqp->q_core.d_id));
 
 		ip->i_pdquot = xfs_qm_dqhold(pdqp);
 		xfs_trans_mod_dquot(tp, pdqp, XFS_TRANS_DQ_ICOUNT, 1);
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index b784a3751fe2..fc2fa418919f 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -60,7 +60,7 @@ xfs_qm_statvfs(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_dquot	*dqp;
 
-	if (!xfs_qm_dqget(mp, xfs_get_projid(ip), XFS_DQ_PROJ, false, &dqp)) {
+	if (!xfs_qm_dqget(mp, ip->i_d.di_projid, XFS_DQ_PROJ, false, &dqp)) {
 		xfs_fill_statvfs_from_dquot(statp, dqp);
 		xfs_qm_dqput(dqp);
 	}
-- 
2.39.1

