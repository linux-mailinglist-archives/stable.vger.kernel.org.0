Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC095E8CE8
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbiIXM71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiIXM7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:59:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0045F10F70A;
        Sat, 24 Sep 2022 05:59:23 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28O3RwfJ004259;
        Sat, 24 Sep 2022 12:59:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=L0FIOY9HE66I/2+Ho5XAluljDOec3i86BTE2IGgp3NE=;
 b=QxC4WwIu8dAgC2AampqNVvRXStSj4v8RRgFphmJnSnTOtTUoUyx+KV6RlfEOO+OxWCzA
 q0Vfd92B45fzzQSbwAUsL1BbtkGvS/6t0aSRhX+40BGswsg8qaL5odgqWgqiYRyDRBov
 XBClX6ZkOqTb8OMtZWLwJ35tVqqLyfRmboq9ZL1/ePMzr8WNyROZXSr6e9O4V9Emw97B
 l4mG9qZe8/47oI4dmdpydQtX+e/UeHlkZolYgI6xLrxkuLuBwchDSKcFUcl76N3WWEnK
 PTn0dfiso/uk9D9fUMlvooZceKEmL5BtHHOEz+k+XQ/gOogSZgA3UJSSpmlizdDm7ZrA Ow== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst0kgg3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:59:19 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28OCerhn036705;
        Sat, 24 Sep 2022 12:59:19 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jsrb1s19w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:59:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G3l87/yLVa5UUsj6Wr7jHTUBAL+lE9DoAseNl9A5Uhk+0j4hF+84Oxb7Piz7PD681SBlaqygghMqm+P7PdBtIGHrf55Zw+B36FZbKcWmvqfgaOvAwsianCgeD1nk9/Jwhd4drQ2mswjzT9baEwxT5lCi+kjDJD+xuSa2Wq+XBH7koFFEm34ECsnSpI7D5Hq+FIGe462b4bWOww9bLC5kCN528tY06C0OPu54Vt47QOFoIK0YklMdNARP3ygTHGyeHP41QzvaWgHCr+gbYOywtKVOSOhCcS2Wemhqmh1tkeBeM+qZgBlBsViPypw7TBWvLOhuzOSnv6rI+I/LBqtxPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L0FIOY9HE66I/2+Ho5XAluljDOec3i86BTE2IGgp3NE=;
 b=ODtBr25NDHxcnQDWeMlKl/U3KE0bMeJqkfuiOcn8+zJc3AvpQ/OEQhvih8apGegC0uTAVEPYliYGSFSh/0Z5gSbFJ3wWxviOLlyJ0jKBjoRIi6YqMJ48a3QVyybtJY8pM5WAEK/zN+MlyIgT3HgYga7W5UaD1icJLouH4QYyRBrezcL0JLZUuP0FfT72f8L14/YFZiZr6P9YAZAxrppf3N6MgC0v2zc8/uttuUmRWtT1RXPpHfEf7eIE2mraAzKdY7pB0PGbk0If85j0qxR1vKWcEAmBEUPOi/sOhGSWxu87T8espQdO7aKKS0EEsL6udRr9WPuSRN7KtbUR2E9oXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L0FIOY9HE66I/2+Ho5XAluljDOec3i86BTE2IGgp3NE=;
 b=Bp3c100tDLTnUH31HqSlwttkuufg6wMdgdhv3x39yLFxAGMIIT3ot53PTxmT8p32Ivftr9TC9049RdgONjeQu8nwLmJ1Xy7ofiaCUQ2whODotqNcyd+K92RzKjWTkBKgIKjO36zRQyiUKm9pd+ihXjOQ5ewcGklmkzl2juFr5+E=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BLAPR10MB5108.namprd10.prod.outlook.com (2603:10b6:208:330::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.22; Sat, 24 Sep
 2022 12:59:17 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.022; Sat, 24 Sep 2022
 12:59:17 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2 19/19] xfs: fix use-after-free when aborting corrupt attr inactivation
Date:   Sat, 24 Sep 2022 18:26:56 +0530
Message-Id: <20220924125656.101069-20-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220924125656.101069-1-chandan.babu@oracle.com>
References: <20220924125656.101069-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0004.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:26c::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BLAPR10MB5108:EE_
X-MS-Office365-Filtering-Correlation-Id: bb06065a-4d53-4fb2-6547-08da9e2c9696
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wln7XlU+RisEL1wFOJzb23idL3cYBi7QnhzoRGu2WVRk211VrSb4PY63Q/2NG14RoNsvObmO5i6V+AVZAkK8WGAueNm+kbHXPZknAzoesfj2NnDvvN+yq4y8gyfQtPClCkCFafvzZEd1AXv25DtdGRGpA2tBLbVjUdZFY1fy9GSOanjuFZH38ZAqzeOMoACPoQ9kTKldRYJYL0o8PyjX9HF57m/Jyj6cOj4yK2SDLlC37oBOzi8Z7QBo0K10wfOE8/nliiF7yvJ/CjvXaxGJ3EFkAsuyR8YCc3gD0WWK3k/gzc2JzBoDWrgjIfwB3FTBHqr8gsJLL2qt1uHJ6nmxSUz0i6YK58/1vuAGc9W8kugGtLqA4yJkT/VOYCdFTyCpMGPSR20EtV6ZGLRf3gWimvOz04wOTRBXMDFuyJ/a3DA21Q8jwPD0dAJPvG+lcdZTZOX4cG9L9BwHLk1OVomxGS/KP1evi0TO6ChTuu+TNPQHGtlVar/vGYFbxOWjmCkE7Ts3UXjNGLwgOY6vqJ7Ot5asol4nm4JQ1RXj0vwEc58WLv9fgTXrkHIe0CIokZKhIw0xlWXO4482oLTmw3K3RykwH7SulG94N3F8Dl1Ok43sdo3V7CGatiDqzsklSuZ860TJBF0IpGgYy/U1UJdJz5QzUNDXWnMHFrVAMANgCYVI+WKZ/H01coxP2IQV7mV6uM8vUBk60AHV+a+TAqGSjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(396003)(366004)(39860400002)(451199015)(8936002)(6666004)(38100700002)(83380400001)(6916009)(478600001)(316002)(6486002)(4326008)(66946007)(86362001)(66556008)(66476007)(8676002)(26005)(6512007)(36756003)(6506007)(1076003)(41300700001)(186003)(2906002)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ThYfUD7LbzaGlvsXRvCpc31vVrqVKa7opjf1bYJwZsL+fw+vUrQI9RSwwVF+?=
 =?us-ascii?Q?xKUvG20RXVcpeHkHj+TaEUP81CGbbCyOk4FRMhEfX5XpBaJLvsrylOt8aJ9l?=
 =?us-ascii?Q?Bu3bU+Y4oeKU/7dySQl5XOtAL/6hi/FWKnDmqygoZFsX913nVB6StDW+r+ns?=
 =?us-ascii?Q?i7+OtWPzRqLAcPkNVyjxUWueExILc0MFX0mKmgn1outsdFKUXg/ewIM3b/2N?=
 =?us-ascii?Q?lbJVlQplxfnIaS3gfY2wh1v1C/IIuR/V+fQ4QLrIt2bEDPXvU4fIBZKVpJT1?=
 =?us-ascii?Q?RPYXfkFCoqn2w4UC8ffgoFbXMwqGMeK3m4vBEfL6/A/wGFm6Rhq08eq4WfC3?=
 =?us-ascii?Q?adGvyQHNPkksvPkh0+v+U1nAxAUgsU2oX/q/k/69jCjtHr1RND5Vl9THrB3T?=
 =?us-ascii?Q?89JBfMFXYBsQbN8+igLgVgnHaYNKzPDEkzulprAIegsgwm+jPPBspSnymx7E?=
 =?us-ascii?Q?QUPz4RDeh9kQiPXXj6akgE6YFJz8I/k5k+NyeiiGyOYAmZPFr+L9Do9uIDNs?=
 =?us-ascii?Q?MCtdWcFHv6onwzl5ApHnxcoftcHj69wbgHnCx50AS2fB7hC40YSQPlazOiwb?=
 =?us-ascii?Q?/2gLLuhtD9r+sL9RPuv0U0k/1HxqxGudrW/XT0c8HkZqFMumLimbMogacxeX?=
 =?us-ascii?Q?IB4D3vb84mpgA37YUZV5BEOSCXSosgHbnSp9LlFrnrlWH6QP2Madz9m55NWC?=
 =?us-ascii?Q?JXD/q4j44mmeLXvMOoCD+z40fABbKGFz4HIdfByb2uNH/JhmcfJDL49E7D6Q?=
 =?us-ascii?Q?XonwpeYZuDXhfx7dkGLJTlQZJJAwQLHG2Txpu2voUH4JYZOJ+lxrsx4SLdjN?=
 =?us-ascii?Q?IvWvDgmMOEdlyLOb+Zn12A+RKcsr8+E9ug1wjE5ACDjabSTF1tGPN6/YLrJb?=
 =?us-ascii?Q?AzJ93DD9RCvaXFdyJNpqfmMJSf4blD9PibNJXQ5yxqm8WztwE3KRXIG5jhkX?=
 =?us-ascii?Q?EnqcFI2IIOnn0CQnLawRYNY2UsiFVeEmzStJ9jx3A0+9NiHzN5UhsN1Wrthj?=
 =?us-ascii?Q?hQJE+j62t0SLMOmjhmbYcoI+IysG5UNeSoTxu63UJUOv5e2PyjrChuNxd3qh?=
 =?us-ascii?Q?uoQ77wY9+5Aa9G+25bhSctBNAqxULE/i0qHOZtIFR8W3M7Pj23mKruLtUpY/?=
 =?us-ascii?Q?F7KWDSQlsBjBwswEgTf2vVzlQRQP1xwbzYRrOE6YW3gxhxKD2pNy8t2t8kES?=
 =?us-ascii?Q?CZ2uVARodjDtr5GviDZDvUkWrGB1kj4c/syGOBl/+xtr8e0EwDx/3vW8Y+cM?=
 =?us-ascii?Q?jSofaPm4O80pTPNwU/rwCM30a78UO9nnXBnx3LOdiKY2LxKsdBSY09baKrSe?=
 =?us-ascii?Q?TKS51i74Sdnw2ebXmiJShYKFNKIUWUoLsfBvjcrlbfnaYzHPy98/1bjvBkfq?=
 =?us-ascii?Q?chB57dsMjnDTI8+Z8KHkp0fNihl+0lnyrPqS+qh3HFYAZ14aAOYBQMrbDp8C?=
 =?us-ascii?Q?tUn67E/mlfIr8ls7Ae2bg+0wwwajL1YcvjBzhrDrdyBQIGO11N06KD3Cin/k?=
 =?us-ascii?Q?TZ9xPl/RSNJnhMI6XH0bQ7qu6KnnhFhqQ3uoFGHgcKE6him1aRv/5YCmAop8?=
 =?us-ascii?Q?K6BLGbMPGKeuTv8321Jpsyjnx+Uaj9CII55n2TIkRA24RDWzs4vKhE01oIkP?=
 =?us-ascii?Q?Gw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb06065a-4d53-4fb2-6547-08da9e2c9696
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 12:59:16.9472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n+OZueGvFsoGzNKMrD2hNJBMvHtG1aqWc6Dks/Kpo6JeahwlXlaRQn540aFWSPWJPFtwKxuInARh0K+8+aZ0ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5108
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-24_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209240098
X-Proofpoint-GUID: qU2b0owyPDSukhtxRv90SrvPnr-AjA2w
X-Proofpoint-ORIG-GUID: qU2b0owyPDSukhtxRv90SrvPnr-AjA2w
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 496b9bcd62b0b3a160be61e3265a086f97adcbd3 upstream.

Log the corrupt buffer before we release the buffer.

Fixes: a5155b870d687 ("xfs: always log corruption errors")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_attr_inactive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 43ae392992e7..766b1386402a 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -209,8 +209,8 @@ xfs_attr3_node_inactive(
 	 * Since this code is recursive (gasp!) we must protect ourselves.
 	 */
 	if (level > XFS_DA_NODE_MAXDEPTH) {
-		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
 		xfs_buf_corruption_error(bp);
+		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
 		return -EFSCORRUPTED;
 	}
 
-- 
2.35.1

