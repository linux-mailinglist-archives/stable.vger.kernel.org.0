Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B896DEA6E
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjDLE2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjDLE21 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:28:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A303468D;
        Tue, 11 Apr 2023 21:28:25 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLFxAW005450;
        Wed, 12 Apr 2023 04:28:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=V51eWPQ+rJK4vrYZadIwSoYfXGz/J6qwbV1+yWr30u8=;
 b=EcbMHtS9eBhUSW9soMn62swIL4RelOlh1FZ2vEOsl51GzHOWG/+o3k6WfevgHl9V4PJS
 zoDMtwWW/UIRE1+iwDNGRO3AZ8vVywE52s312nWnYoQ1cvVpCImTu/JOVnWYRt8tCmI4
 xq9uQ1Fkw2mN16nvr9mhDmixbztndUEmXr/F0gabU3BH8HGgktgCRqougmX/QzYtV1CE
 aeA0UCTjyuLCiniIrJF8nOoXPtGDlvcytYk0gvoNeZbvwOTiuW08HsNWDQ/JDX6l72NH
 ujF1qA/5hB1ubIza03nB/o6UwsD9CTVMHmWvDGxcCUpoAdzYKx9Nnn+FpjPGqa2t5YYS zg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0e7f0kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:28:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C2WhHc008083;
        Wed, 12 Apr 2023 04:28:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwc5914c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:28:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ph+nCLpnA14qbthB9OKJvH0BCrKi8ulndPm8d9ZzTH74/KffsHoTrJ2icI/1TfFiTIkdj/KyR6S+b1kndhZtA9MM+ymA4xsHtHNv2yMK0iMTLlnWdm66m5trOSR5SACOeqSiLDigHKkb708SNpo+x22s1G0OpcZtDMM6PNTJaqekp30Lgr3rDqmEmvdCzgAfztHk6pJxV602asB0J1QoHdQ4bkayS5Ae71eNZmn6uA1URR+hLSBSOxURFspNajhrPP/Cn0fG1DFYfTnaBVC41ksfWNVRQWdWzjltZnnkQ9q0klApg5x1rTuPBJAl4m155FU7I/YPd4PTAGV6zXpuqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V51eWPQ+rJK4vrYZadIwSoYfXGz/J6qwbV1+yWr30u8=;
 b=Xudzc+Lk8JyUjYzuBiEgoIVCjf5pH5rtkaA2XqMs1m9+/eZmtpoGTk1/5pSQVrLk5jfP/IPUcgUFUvUAoTqBbjJzyE20X1oWheTLyPt57YcIaIrjL1kgt71XAuXedwNVh7jOvSxQKXCrykYuBOfCVPol+sPz1P8UseNx1pdnpxPje4L/ZYNjBz0E3ubEkSXT5wIbKcXlEiwp/xdxncJnAv3zoceQ1hb+9NKCOMY6umomEfMjvG6wUZgaFFbTceieRz6S5ddJcrV2tO5c4sSzSI5RtIUkNqdQMWwk1QOP/JrecnlPmq3HJf5yz31N6U4kgTmU2J+dWJxDybqneB8Rrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V51eWPQ+rJK4vrYZadIwSoYfXGz/J6qwbV1+yWr30u8=;
 b=TCZ5Iyhd67GtHaUON3y0Gq+yv3O4WkSOuyt2HEQA/iz2lD4nVY5ioZLtf5+5laA5AAV7E0LSVZRL1kezoQZ23ieAiaXFNIp3/xyv1g8OEUZmw926xKoqeLeebFrQARqbcLPZWa6Od7o+qeihkrn1IwEpX6jWf/C/hcwvz1ER8o0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB7363.namprd10.prod.outlook.com (2603:10b6:8:fd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 04:28:19 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 04:28:19 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 08/17] xfs: simplify di_flags2 inheritance in xfs_ialloc
Date:   Wed, 12 Apr 2023 09:56:15 +0530
Message-Id: <20230412042624.600511-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230412042624.600511-1-chandan.babu@oracle.com>
References: <20230412042624.600511-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0027.jpnprd01.prod.outlook.com
 (2603:1096:404:28::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB7363:EE_
X-MS-Office365-Filtering-Correlation-Id: 6802bc47-45f9-471c-2f74-08db3b0e57cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p3xeulI0xzZZgsRTUvsAAR7OIDqcQf2nYtngvVU2ZcorIiJ/vqZ8azEG+FbsJkTTldi4A7ZaWgfEqp6MGn+U+oYgNXPmdxp148ztynNSVKint8m1MOCj/1kH3XmWFhHxyjMKMKBYLasA4LpEgc8dtQ13XP/nqZY3U9GvOX6OQd4jSnwsmmTFB5Fr78xVv6UQt/jf/KXrGaMbVetOsjQ4l5kR7rSNFXiAJ3RTXxOfq4ES1xPpYJjk6ijfZmjCv4/ulBzHqL/kpb3BYMUNwgMAOMkCdY6wsK9e7BaNjelouq6+duEcwymggGw46T+vkAgZF91AJmXml+tObQfmwx7qipzL7sPFx7JvHXY6RSn4CkNfeYgGMks2aVNr0zy8r4vlWUFsIPln8bqYFZ4soB3QECT67JpbcQJQRUCfQvqX8TiTr5ny3k4zERZ9TOcsLrIp3bCTFiCShnZKudq/LJffDts7caxncT85Y6TF9z55uWyRA4Mc2KIwHDq9A28657veR2vNvZmkYw2d3x3LhB28ITTt2x415uj/FOnjqhdNyAdR2baqyGgdoSDM0fE9Vy40sCvqshwcSBFM5KJEp6rUWlPRVLOuyrQtQCVOrgzaeHA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(396003)(376002)(346002)(451199021)(6486002)(4326008)(41300700001)(6916009)(8676002)(66946007)(66476007)(66556008)(478600001)(316002)(86362001)(36756003)(2616005)(6512007)(26005)(1076003)(6506007)(6666004)(83380400001)(8936002)(2906002)(5660300002)(38100700002)(186003)(218113003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VE3TL9MrQd73E0y6qRqUQQPh3HlMmhUwIbNUeLfbOr558xaacTyVbiwgiZlW?=
 =?us-ascii?Q?RQtyUqDV7cVbDAdyxomD1jlA0XbTqISd8n3W8lbH8N9wvaVkytd1nAO1d7C4?=
 =?us-ascii?Q?mMEKALwNOIqK4QrWizZngc/UjZ+hhGsLKP+JljBTJaO3dY+j7CVrmFdM8pHG?=
 =?us-ascii?Q?mffsT9WIlBBNOgOqGiXWZQVg2Ney4rv2cvok0o41zKgoOAdascM0btT0IBAU?=
 =?us-ascii?Q?X0GXJmCbTerfQ0e2sJJJBatb5iVmtHAa3AhEamAskuFlphjjTAAmvPhcF68g?=
 =?us-ascii?Q?HwDzEGCDnTbWKrWsxMC9R+cat+jtgThthAdPFhXiupIobOmRxZrxDJf8BcTd?=
 =?us-ascii?Q?k+BdR0K3daa0d946djivo+aZSlQvgdo5mNnyQOJCh16+d43aKJ2bs4/2NqKv?=
 =?us-ascii?Q?QPGmgJzc9WgOhJziar1noxUILYHKL48XC0LMp60zgG4+rbHqRUaxVtgPgqBK?=
 =?us-ascii?Q?Mo2dr6a6ZkwHJJce3AeLgULZER9YSUxr0Hsp3vo0a+OmlNoD3jhF28IFblxm?=
 =?us-ascii?Q?Zw49sFlcTkIiHhxLJ5qPXrwCZ56VTRXxfVMiOuVxDDF9G/Nn9GBeEMWyehNQ?=
 =?us-ascii?Q?dAVbOpmhxed5ShlRMUIiunXRJu9rNYFxsxSm2AOiF6PqqqXzPmMiPJHTh4fi?=
 =?us-ascii?Q?3xaaEwong1YEIaR9+gw52DmGbaSVU65QS48+7K3ygHVqlNx+qXmt6mZ3Grei?=
 =?us-ascii?Q?WKNWfQ1kHxcuowvAPaOHRUgDa+9ejN6H8UPZZVwjJhOrJvwi+JOcFiL7W4cY?=
 =?us-ascii?Q?ykE3OLhLSKzQeiXdYmwOp9ed7IGoSi3vXDY6DKp1tuE6SCjQGLZsDE2LwIc/?=
 =?us-ascii?Q?d4FX6Kr3W68XxpAtBy4oWGXTlVMUVlW9zUZfC/9oD8A1F6D0bz611wVWr5QQ?=
 =?us-ascii?Q?hGUqmbIDsHWywH/YMgFj/2kZW2Z0E02CzZSJgIJubOr4rnS9V27egqTIBEKl?=
 =?us-ascii?Q?y0VzuEbsTwoBYXEUl2ZWYBOj1vS4D56tm/2Zs0eQZMppUZtodv4F1nqioxLp?=
 =?us-ascii?Q?mimt0WPfzBGpZdDlkjptpYBpWHs15fh4T8iHr5/8iCkf5kO7ioC/l7kKs1XH?=
 =?us-ascii?Q?WF4B+/g3RwuMbR0sM6e8qgYD3tE+BfsGZuTiVUKMN6JrOj8V6JesiORQAqPB?=
 =?us-ascii?Q?aYe99kJ8jzBR+/VQ+vpt+To+729aXzVIp45d8f6Jcinmx4zM+oAo4KMf7NP6?=
 =?us-ascii?Q?k1MAHebIGAl0wAtsuf7vh8gEKSnbcAZepXjl/CPp+GzijkoBZtik/A18p4Sw?=
 =?us-ascii?Q?NEg+5gL4vh74QIn+Hj/NswfYYFo6UYarYf/6/FFD07qSiyV/Eosu9xJS1D9Y?=
 =?us-ascii?Q?FlNlDzT+yfM1W1Y3DcdRLG3nTE8e0bdFJp5s+q5KX6Thiy0cycRDrpbQpcpt?=
 =?us-ascii?Q?jUZXFlns9F9mrRrwm6ugAHOmcGvBTdYZqSBrl8oMpvi7D9jaepP7JC4EOmgW?=
 =?us-ascii?Q?AbsaghJrRmvy8KKpGktb56g+ABTP7fj4V2ZNFpi5zErWL1r7Uzb8kz8JvIME?=
 =?us-ascii?Q?PE+pArS+wt7JAXrBfwxtG9Xms6Gmw70PmJYFkOuNjZiU2FvYeo4YEedQV49k?=
 =?us-ascii?Q?M8/XBbm1PqYM+5MSVFc/l4Ejh3zHpD4iIBQ34qO9?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: sJXutggthx4shftHTRBTlqFx4+CjbZf+GanS7oagV5I9unteraItB6lxooSdTBmE/HoYHUj5WTk/qxQ8/TRbAv1nRXW8UUz+25AItEDB032GaolPUVHm9TXAaNWhN3Zps+3LUiA2nCQTz8K7ebRCQdSVhgMXQnzrkUV0l9mG3OSaN3tLN7JVpyLlnFFLH1ivOScup3djtemBygFZVXdQgJDmBcIlLC3QIvc3P4Ikh/hsUs6S555h8CxEDUstU9RIHFr07jymOSvVISMNgajVeKnJENVI0tlGTPUtMMJGy//0Kpmk2LH5MlGgP4QtZX6/tN6KCwa1uFslu6IX+bOQ6dHvEiRiKAOQq05M+Ke8DXj6zhAHMNnCPyjdqEhCskfE8JTTfW7SEwGgUtUd5TR3nxZQJdkcOH1eEue0f8zYT6jidc18zqmHZJNSdk2bFVWm5hm+LJw1U+oHjDzRsH30TGI4w8xlg2wIy5mlkfkzrXHNEEY2aJDMPtZdjIR9jil4McDaFkRJakvgDC+vUoRK/Y1CXrlcTwXpkYxCFP7iiwIA7zafQvS2OVzjHmwH+ln1zxIubRxj9ea/jTXbLqAOkL06s6si0iRMouTgt4umbMCqPgVVgNJf4MWAuKgiXl2gpfDmY76RdMaRa7lA8FhBAo6G9L8jJv7ab04FuVQlco85L2DKLD31wFHwSMbVOfO3Q1AlKOg+GfZwPoi3lVEoc3inwcyZ3sJfLfxmJN8vxPpV/uhEnuVHsu+HuRzAKlbNu8HS6r0WtfK2W6uG8nNP9bsAoiJA1vuUCfTaZIPK4Xj3I34tfVqmgq+jzYwqOVqfCZWYrv5nLSh5uVCZPGQvaeMV6sts21YJa81gFWoyad0bZ8NSHPjGRyG4+3I83phQ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6802bc47-45f9-471c-2f74-08db3b0e57cc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:28:19.3846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AfDonMnuShMcbUXJGRcVvOpj8Kz+McnbP05AdYkebddUPz6b+jrkmonh7gBrx93z2paaA/idtHRERUT6rBqjiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7363
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=729 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304120038
X-Proofpoint-ORIG-GUID: -jHaJ143SDPzOXItaJ9wS607E0vp6Ua5
X-Proofpoint-GUID: -jHaJ143SDPzOXItaJ9wS607E0vp6Ua5
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

commit b3d1d37544d8c98be610df0ed66c884ff18748d5 upstream.

di_flags2 is initialized to zero for v4 and earlier file systems.  This
means di_flags2 can only be non-zero for a v5 file systems, in which
case both the parent and child inodes can store the field.  Remove the
extra di_version check, and also remove the rather pointless local
di_flags2 variable while at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9d6ad669adc5..cb44bdf1c22e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -902,20 +902,13 @@ xfs_ialloc(
 
 			ip->i_d.di_flags |= di_flags;
 		}
-		if (pip &&
-		    (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY) &&
-		    pip->i_d.di_version == 3 &&
-		    ip->i_d.di_version == 3) {
-			uint64_t	di_flags2 = 0;
-
+		if (pip && (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY)) {
 			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
-				di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+				ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
 				ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
 			}
 			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
-				di_flags2 |= XFS_DIFLAG2_DAX;
-
-			ip->i_d.di_flags2 |= di_flags2;
+				ip->i_d.di_flags2 |= XFS_DIFLAG2_DAX;
 		}
 		/* FALLTHROUGH */
 	case S_IFLNK:
-- 
2.39.1

