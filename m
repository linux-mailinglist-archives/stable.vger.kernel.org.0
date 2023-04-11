Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21D96DDF43
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbjDKPNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjDKPNU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:13:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D6F5FE7;
        Tue, 11 Apr 2023 08:12:18 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BEx5w1005446;
        Tue, 11 Apr 2023 15:11:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=x17052nrhP8f+waEmBBkJqRQ2lxoNOo2YHzvNVbg+Ec=;
 b=L+HhAN0SJ28TRoqCq8tyVZXL5Wqn0Fzv2Dd5UaJTzbaIoUOlvBd1bmfSzi0xQx7n7e2J
 zHInGBLmN8whc/oeyw92t1M5UAdi2dO0BmOPtwWByxZKzD8BrDDVH4ySIdzqy17CdpLy
 cO0N46U8zBOBfph3iKCo8BFRbgz73reAwNDEeAT5MpSxtoQeijcPrCRYPYTz4/nWsRhL
 gdaAnTr5vH5dT5b26mxIrSCs2tJs66gf3ALwE2dEpGeUSzsS3Z52801tXfMqdh3eMdAv
 9/0gFNYWx+F2VKZkK0eohkxUoGP15c+pa1doQ5hkYU1jEw4Ed1p+u0Z/frnQykMwG3MH cg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0e7dnp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33BER0x7008042;
        Tue, 11 Apr 2023 15:11:52 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwc497w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcHK/ecRnuP5TNmJuaR/yChq7qd7wNi8aRj3AYarcb3nlxmd0ZKcZlUGyQ9ElGJj7M1+K0OoBqfEDcPkyeeTRRdxoOZcJ+IPDiv9ixXSbgNMmK/JnPHHmMClxG+IdBLzQMDqSXpmJyPZQtYNOBj81Kj7jiECtHuWseu9bGJm5NrnypAgOErmYKnORY7Z57LmJOdWJblZKACrqI0zrHyEvo4i5vjy6V7eCPAVhnF3NqWZeXRV6PMY0F2qFmz6Ku4qNa05Vp0mHq+lHWCJ2btRDT7R7V6PkcjTuz+S4qkUj4SnyRD2OVDhf7XcgWynvJMAqzN3FntGiBD9dI3iuY1H2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x17052nrhP8f+waEmBBkJqRQ2lxoNOo2YHzvNVbg+Ec=;
 b=cbIZG0R/f7b10Aw0O4w7qJrl83YSFOuA1UmRZtGReczCnMJV0O3x9DkOG2ui0PXDSJVlYetvAHb27uv8GptTJ9WJpXH95dGo9LiecBmAyUbmBIbV+VGixgRwKUHOo5Usjs1sH9lDH5NLwp/PYnaBdcX33FfGbFS0UJWUcESGDC1xPehYHRgNnFb0mrSwevtzeDgawvoNlHV6XDOjfA+W9VJG58LzDzJ+qMGTV/xiHuRwErB+6u9oBTTnChERIvNqUyNzxONs3vQGgs5ZgvuTI6BeJCefmuyhuO1uC3haMKhzV9Ewj+WPN6jKF9CWYi4wgDPWunrEPui9vqkW2O3wuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x17052nrhP8f+waEmBBkJqRQ2lxoNOo2YHzvNVbg+Ec=;
 b=MJQijBUuh36pSN9FlOsZyR4SyQOLgIBMGQ7nvZ/VzGwzsfE0TUZLk41nCmaqLqSPsN+N2xwX+OHCSTivVoTBD0KXb7Dn7PcO40U5eyYg1LmGjIpvYMKXBmiRTJ8K4WhdO0m4BbelNvwjCJ4W6VQghS9hnaZLiltecBxh97bwqr4=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SJ0PR10MB4718.namprd10.prod.outlook.com (2603:10b6:a03:2dd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 11 Apr
 2023 15:11:50 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6277.035; Tue, 11 Apr 2023
 15:11:50 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 6.1 12/14] maple_tree: add smp_rmb() to dead node detection
Date:   Tue, 11 Apr 2023 11:10:53 -0400
Message-Id: <20230411151055.2910579-13-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
References: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0063.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::28) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|SJ0PR10MB4718:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ab880bd-4863-4462-7c45-08db3a9f1334
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fpOEcDjiGBmxPf8RmvzIaJCivIulZsIfRWJ3GtQ2GEweV9VlO7jhACl++1n+Br8EiRWl8RlUC0GThpHu7fimjNjQM1rKmV3IaNy5fJ+bf+QkxxPJxSK/vAYD0rOI4HX/Q/Y1s/6Q8yuOD/qUf9DzWJyOtuZt9zraFZcNbygVulku8ujveg+f/V1LqyisgoTW7HuZsWVlm96ecETvdngda7edFHhdB5nlBHzL20zSZTTptcxNwxi9D1GvZo+2eC50qzZUz6ewe9Vc8N9zgrHj6Xlzw3pUGTnzgK70vBgKWT8ruJmrexPQEKsEda8A7znclHuZg61w8n/PCK99c9L0uxplpiUt33FXWkUiOW+mu4abLwgjxFORZKPoNOcKsez+vg3EzuJapRCP1wlhBqzt3ee0ngjVsj4SEMH1O1+vuEhD9g40uDiUtu3dtiqp95p0KVVwwuIWLQ84jfuLx3oBPI98b5IwuCpk8YrxNOCp0Pt1h4c1lFv7lbK/tDQZcqVGsQf4f2ef2UjxaPFdhY0zYMD5wMK688lnWzpIXcME/Uw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199021)(38100700002)(6512007)(6506007)(186003)(26005)(1076003)(107886003)(2616005)(8676002)(83380400001)(2906002)(6486002)(5660300002)(8936002)(966005)(36756003)(478600001)(4326008)(86362001)(316002)(66476007)(41300700001)(66556008)(54906003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SIV9ZNotM0BmG9uYSNPysKoPhaRbEqed6IpO+vaytVXKVi235ct8NTvBQL0f?=
 =?us-ascii?Q?B1pHTw17YZ0YL/3ZBRT1n8fGUk4aErO84yMXc1ZmTw4p0a3Zun0EPbmMpa8Q?=
 =?us-ascii?Q?FITJsZ3BoCYY8ThrM500TnsZt7qVfxqvlwkrPjI5UxQe6C85sdRJFSabxKs0?=
 =?us-ascii?Q?csNPt6E8MxW5wNt3PsHuN4AGwqSwTneSE4ujaPrnkfoxDAHHW1UJ41mQ6NLz?=
 =?us-ascii?Q?OpqpJwfe6YBX0inOo+Q6aKwR4sOE/SFl8XrTy9dVgCIvTGgfO+aPfSz68VLH?=
 =?us-ascii?Q?OmnPs8hWRVXUMjZbJHXeS9VYCodh/3qq5sTFow06xeQD1RYZNK4epAFFzZnd?=
 =?us-ascii?Q?GZ2pYAiPIgaRZPoO449dsC/NYrDApEMf71Gm7uwlHpRJKNwLErgdc2tcVV0P?=
 =?us-ascii?Q?mcVsO5uFXbNEcASLsT5Z8iokhoXLC3/nZi4kPUVkV8RXC7sIToectYXT5wsZ?=
 =?us-ascii?Q?U0a9xQwkwTRJyzbozr5mYWrg7fVD8BoMwYsQBFISHfjKsBa4+ewla8i2Dpid?=
 =?us-ascii?Q?ytz9dyQ274VpPH8GsQpozf8IXtN384TNcmeIRgyFi8utrHIVW//+l+fkdLUp?=
 =?us-ascii?Q?3gfmL7ra6VzJykN+c56LEMdRKXpYyCi986dxQ4+q1Qw5Wd0fPVdrQ7Mg3uMK?=
 =?us-ascii?Q?wCXvjCuLw7UrCFvSEPgc/BvLEGxvwtBWd6gzdv1wcBOQHr2Q3fX0MVzl5JUc?=
 =?us-ascii?Q?I5KOEBj6dzF2aC6mWfSkeA/4p3ecUqWMfFuaVYQGAdpdGlQiWMu+uSDMb4lp?=
 =?us-ascii?Q?2std4kaUcavylNjZ4hBbqogJXWVWwgfHLP4YtXQQc8cUuxxeloAYz/DtdA7Q?=
 =?us-ascii?Q?x8bmPCwjy0mmYASOjKImUEYvO7/12igPgL2Z05LDDUxXYhO+kMtuUohebEp6?=
 =?us-ascii?Q?ouXcQit5WakAE8OLx+LzPPrT12STffZzk/RC2W/R4vcAbzAKiFUkAUBAyAU/?=
 =?us-ascii?Q?llPZGt2l9F4spbUpmkjLLdzv5ZxYo+FlfxioM3ySqpe6oHl2GO4aFGxhhAaX?=
 =?us-ascii?Q?E/LgKdjFo/2c3niSiXpIWa12sJs2UXGtyxGwy1Y/ejUihV07xt5A4aFd3DOy?=
 =?us-ascii?Q?sbs5lWwVcnFRrliQ1QSqyGdG6wtGAYAoJifg++h3lu7aDE2EhmJHrA+Zi80h?=
 =?us-ascii?Q?qxumuVN/VipFSYFXuBndsqI2YsZu6qNr7jSRbMle/ye9uXvObbm0rCNxI2fp?=
 =?us-ascii?Q?1GhsbHD5nx4Okq7tVTprz02hw2BQCl1flDxHejwEkLYjaAmUqY9fA4smgTF2?=
 =?us-ascii?Q?hPL235xZMRJKbItxzI0/w989PG/D25Ufk+8mq1xTpoEBJJCTuFzk7dz2xpb2?=
 =?us-ascii?Q?cTGgXPueINlMMIAVWOMCttJxphonYhn3vyY0umx+Q63Z/WGsIUfglvhh1NLc?=
 =?us-ascii?Q?D1aMmo+C1ULG+QnFfsvZTL7F8297amzkg0FyMXrfRZR5Ym8nra6nnXItuk2z?=
 =?us-ascii?Q?ukYUdNCLy5Aa6MKf0Mj+87/33lCznRt2/bd81FEV4I5Lo6whtLpjXmMawfov?=
 =?us-ascii?Q?yrYBg14E1E+VYxcI0v4QGWR9ZirPF+/ith38CRVLBIr1BBbGKvHuOE9ITT7Z?=
 =?us-ascii?Q?wgxFUR74S5+O42jOpi56iuTe7ZbZgEbY9HRYisNnYl7/qiOWMKbv+VV1/vGn?=
 =?us-ascii?Q?og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: fa1IrEhT1zTXhUG64Q0LAxRykuEGN+l/uHpaEc1NsSBiFlhzleiZQlQvEqvhkrJq8asOUngdrfBe2Su5ttwsYbNcwC8k7o64YuMxHGMBedEkt1y/pKTk9eUB1d37XXOPgX2ApfI7jEhpWP+KwPGiEgMHZYnJw/Ruzf8tGwcXbv1X+PQlcQ3W2ahh8BUGQ8nGuEYanzlMF1FXHGPCFE+YapWIzJlWXwtQ+PHLlQXXEoBKH9/iihsC5IqMvhkOxq+fUk+FpFDyXisiVaThkYdRJpeD052QHYv/PlkIILVme2TpAbB7s8y0WLUTuToSE0FteP0WX99ebEAIkxwFDPl/Rm4EiQPICLiaAaeUe8uWmf4yzri+NBGXCDyu26mYaIlMo7oEQ0gc26rkqBQ4JlxR0y10vb8bitvV5sJ1VeZfYI3CLfgi0im8s7kY0pymRH9yC9SdR3wbrHmA7J3az31y4+hPFFXEBOYYlSutLstJHSDexZgHosbSs/Bl1TF1xIcFsevhH+xC/KQx+1UiaIcMAwU9ItvIfhT9yVeOqDf9nN5F+N0bEtz1Px3EI8MOpgXWc7g59YU7sP84vuaSuHm5xU3GvagfCDJG8auxmvoxRCDAynudyEA+9PZQ/AfWE2OfClWJR8Jr72xMdRE1WIUYsWaUkJVnkpHYV8+bFr2dtLq2svcsT8XzV4eC0LeNz3iE5H1oVBecvzEH0DsjSthxNXw2bx6sh809IkWWI94nocNX+J1qONpmtkzaMZuRPT2dYKhddgtCZiMD9cwOAm8eK2ogCxE0NiL+NBGfPco5kSYOGmGedm9muXjm/CEXJ4iR0HpK8eENyD/GCdzUazbUnTctuPAQ7odmAdu9cSg2ucfH0cDWUiqhHfPLAu+a40JhUzjGoS502eDqtKk9P1osDA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ab880bd-4863-4462-7c45-08db3a9f1334
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:11:50.0437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XEzoLyHKLvTDaGZup3pqXVHdcs2o26PkV5wAxXU9w+40aT8jHQbNAyOautjnFhNMTaSnse/irfjTVz4j29QWLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4718
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_10,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304110138
X-Proofpoint-ORIG-GUID: EkAIHQrR67zW9_bDA1YeeHNJDv0HJ7UR
X-Proofpoint-GUID: EkAIHQrR67zW9_bDA1YeeHNJDv0HJ7UR
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit 0a2b18d948838e16912b3b627b504ab062b7d02a upstream.

Add an smp_rmb() before reading the parent pointer to ensure that anything
read from the node prior to the parent pointer hasn't been reordered ahead
of this check.

The is necessary for RCU mode.

Link: https://lkml.kernel.org/r/20230227173632.3292573-7-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Cc: stable@vger.kernel.org
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 281be0997e55..2f9af64edad9 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -529,9 +529,11 @@ static inline struct maple_node *mte_parent(const struct maple_enode *enode)
  */
 static inline bool ma_dead_node(const struct maple_node *node)
 {
-	struct maple_node *parent = (void *)((unsigned long)
-					     node->parent & ~MAPLE_NODE_MASK);
+	struct maple_node *parent;
 
+	/* Do not reorder reads from the node prior to the parent check */
+	smp_rmb();
+	parent = (void *)((unsigned long) node->parent & ~MAPLE_NODE_MASK);
 	return (parent == node);
 }
 
@@ -546,6 +548,8 @@ static inline bool mte_dead_node(const struct maple_enode *enode)
 	struct maple_node *parent, *node;
 
 	node = mte_to_node(enode);
+	/* Do not reorder reads from the node prior to the parent check */
+	smp_rmb();
 	parent = mte_parent(enode);
 	return (parent == node);
 }
-- 
2.39.2

