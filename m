Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003256DEADD
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 07:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjDLFIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 01:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDLFIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 01:08:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA551996;
        Tue, 11 Apr 2023 22:08:38 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLLAIj005408;
        Wed, 12 Apr 2023 05:08:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=fbFr1MyfoNJSjdL3IGaTyK6sfGFaNcRINRGwv+DEHcg=;
 b=cqm3itXnR4sXYiZJCFLgUrLSf5I4a7qNxafh49oV15DueoJ4GKbIHeK3WWsHFuby7yH2
 z6fNe2cdzRcIFoJRyvSEtHz335KSCJBGk7AjONh5u/8WFSEP6fOCBaMw6PalwwHBN+Wp
 utIFFh3mz63TcxWYPPZFiFBAb1pC+bCfNVKheBpfYqr+NRBIaB87B7l1g/6hgYmG0lOW
 QUyVMmKHFbMVyNa1ueBYtXm+um+/Wy+wK6ehgvBDREIEx56uCozZwojACIId7n3L9/E0
 uvtN1aA9XJ490jckiDemMXbOY53GyXo/zVeff5gCk1fhmH1XWr16EDCIVv6TQ3VVLQFC eA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0e7f267-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 05:08:34 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C2ZeaG025027;
        Wed, 12 Apr 2023 05:08:33 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwe8aa4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 05:08:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOlTgf2Sm+Byx6E9bWLjiVJqsIVNHLlguN+mX8PTMIL9QLvQ8m0f1B/yfZ6y4QWxACN3svTfzO9iN5EOwoCFyHlFMB0Xs+lu6E/HerEjOQ4wk5i929s2E55I+ADYNDVxaF8suSToqpZkQcOgFsNItEJYdu55zCCzU00J50La5n/6dn+czncRLtY/8GRLe8xpamnR4eevGoSYPkJU2SKCGOiQZf/ucWgWI2H/IoW2smrCGPM8GL/hswoitiSv28ZWIX7YOpKDa1we3Ee6b+K3TVgJdMzmg6Lt0dtAulb1pP7WfiPD5YdZEklIDtCeIzKOZaKfhj4W+L3/Wf2K8sl+tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fbFr1MyfoNJSjdL3IGaTyK6sfGFaNcRINRGwv+DEHcg=;
 b=Zf8SIGQ7+TATmtuJsEBpQ81Ghssvz1PoF0kzQegqz6pB/Hw7jMS2iGq1VioDY04HfKPrrU0OD5yjYgtTE3rMAiPihtZrErZjWmhplYMAmd70XRaBbf4bLX/anPdt6e5o0cf79Kx5dYWGMugLmfHBGdWhWI/8XhhhtzaFOR2SrpOO5kbGKbc0WJYZVZHnbtJvwbDWH6GljPY5Qtf3ZYrfM6MgoTNohittr0mtJEZfoRkbQr/hLQJYj9kEhtW8LwF4ZBfx4USpSVnx4ANNozsKOAwesqlRiHnaV1FXnqMNNrdTq4kHKOIE8kOSjbP7cLFcTLHMjrneIZG3KyoHB+Jw0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbFr1MyfoNJSjdL3IGaTyK6sfGFaNcRINRGwv+DEHcg=;
 b=BgUN5PQQfS0pwvMGswiphvyhkMkVuCR2GGILPMX94Su31xfh6EIoE5oOJIm5GEsyyLlEVfi0eoVUXNT1vxAT4VJlKzCIxIh2W9PN+xPEvAxRSgjVDepBuvkmxhLRZ8xqpffIB/SVzT6reRRzt5V5aauCOE3zsBioPpceSZa+yXw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by IA0PR10MB7579.namprd10.prod.outlook.com (2603:10b6:208:493::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 05:08:30 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 05:08:30 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2] xfs: simplify a check in xfs_ioctl_setattr_check_cowextsize
Date:   Wed, 12 Apr 2023 10:38:23 +0530
Message-Id: <20230412050823.721047-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230412042624.600511-10-chandan.babu@oracle.com>
References: <20230412042624.600511-10-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0052.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b5::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|IA0PR10MB7579:EE_
X-MS-Office365-Filtering-Correlation-Id: e8de757e-f69a-414e-3644-08db3b13f520
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iro3oN0Wr1E71kai4Gt5G+x3DDoSxIRBLEWS+e+iLCY/PQ89Ysk7elKXM1lwlg3/QSr5/e0JWmB9KMUdRWGfOsTPYWOEZUpuZohhJYfh3kpGDgqN5EC1v4syqQSUzQO4xg4O8LUUzBXlFaF6KR1rqOexmnvN94Q3CFb2CKYaI3NN4zkmcgsK64EwK8O4uxP4ZOgXk/qrF7L1YxqElaILVrL/PdlhwmIveyOjWGj5dsmJXgo/rm5E6dbcHj3HM3A/Uf/bEjxCjVx5aXS8ClR/FvL24NYMLH7ZdTF9UIuKdWKuwbv/2/eHHB4Qv5xFQqd2F7H3e9/6l+W23XY//+hCOoWsgTSF+X6+5ddyR3r5Kk4UzWGq0fGnbMj/l2SC5qX3+6YrhfPJMXboEVlimu6RuOCU598meNNMtCBdrp37D/05HZ5vC2bRreVvfZ0Ysecejuppwx/c/Hrtf1QMkpwf6aqRgTVwDMqRxQKSpdH2Sw2cdFpH8iY7ZlhOGQUvFOAfZNX0YuqKyhNB7Ara59UqH7kd3TCWXlPjNrmTxMLcR6xTLv27zT+t75wkYXSGChZ6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199021)(36756003)(86362001)(6486002)(41300700001)(316002)(66476007)(8676002)(4326008)(66946007)(6916009)(478600001)(66556008)(5660300002)(2906002)(8936002)(186003)(38100700002)(6666004)(6506007)(1076003)(6512007)(26005)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rGHLglUJoQxT2Xuja354ZGNyjdZz7MLdeFZRaBxKYFuOWM8BrpfRY6KjbVMh?=
 =?us-ascii?Q?zgXgprbl6XpaVqLRfsKoYncsKdkjjzsMGbsxFdPl3em2T/YLAy2KX7bYmNYD?=
 =?us-ascii?Q?2NwwtrLqb5QpcD0GY4KjHr7ph1atV5WSfRxxK412ei1LiPWZxqXsEkLycgBk?=
 =?us-ascii?Q?xWoPlbY4td8Ib6QIBmvqf9eP6LLwG65DfC41HWHvQMFZl19+ZUcflHAw7CHa?=
 =?us-ascii?Q?zxzLSowzn+PIOfPdTqAGS9HuHtET/vVZtIhZ83ASDZjbaowTCJKt0JO1qY0y?=
 =?us-ascii?Q?qfAGY5apkyMtENMlFTzTnvA2beLeY8LlzSj2t02RPWaRmlOygnGqK2sYme+/?=
 =?us-ascii?Q?vX/NMm01rBoGvMyv08m6/97QJaoQe0cp6vv+Ci11k6lEgaD0pz3ibrZ2ykDE?=
 =?us-ascii?Q?l7yhOn6g+UTE6SHXfQCLcpFKBPsDUkA42JbDt8bzFxf1mwJZq269zaWHZ5GY?=
 =?us-ascii?Q?NhO1wIFZqeRkN7TS4OGQrqWCMHBWg297012W7ehJrBcAoxDoD4mx29VZp/ja?=
 =?us-ascii?Q?arBEG5ZnTrSOB0AKFC6A1UgMROQ386L/rtNjDHz5FqrTZoUbxGSovSlHGGDo?=
 =?us-ascii?Q?SXuf4Iigl9QBe7IjdNmWL/3xgkQNGe+2HlPt0px5G1u6p1keZy0tTP+SVdHi?=
 =?us-ascii?Q?F+q55rrxkXtLiOtCByH+RKrnhbSNDGkdqdYNC7lLtOX9o8q4/qJZRGBp+eeH?=
 =?us-ascii?Q?WHBmgiBCWsfkFADpu62TkrrLw928JLhYPaW/vgDxKFJAuKiqRQAt49+jzRO/?=
 =?us-ascii?Q?qJ/EmU+EAzvoh1zj+oVQXGevL6Gk/wmXt3u9rvXdbQuL0l72Jrcgef9qNhMX?=
 =?us-ascii?Q?oqjG3zszdNOBBa8oGyivgvlQFkKurbs9mqvqf7mFlufFhxHEoIT/BI9UJG3o?=
 =?us-ascii?Q?doZ6AYGS56H5CwuVqmdXPfKmIBsVjSWSmmOo0fFNF3jGeGs28kih1vD+nrvh?=
 =?us-ascii?Q?/tpMjoOkzp7GY7OqFyezDl2XkrhPtM2KyYShQPtvEsXf8uGEhLeqFDvBvN1g?=
 =?us-ascii?Q?EGLflVUUqTggislfdx2Sit6Qrxkx0TEQ+gqT7kpG4HGmTYpzOS3/cXJmvfQj?=
 =?us-ascii?Q?S/wTy7stfh8NEzjkAQOMjYKsV81YdODLYo8S+66pFiF6q5yxwupISPaK1WDe?=
 =?us-ascii?Q?0vnycMS6TxMevosoSFRTunDUQThd3o+nJkFXUXRXoQokKL8kT0SD5YN1rOnZ?=
 =?us-ascii?Q?LMt/SuMtpPUEvNOmohNWeEMqgRCO3AF44I1qDlzlyXpx+5uEQf2ojzEFpipi?=
 =?us-ascii?Q?/ir+sWTsqW9cvWHmivoLrkyqJ2CJt0OEHBEiueS6Z23BRN+e3ATAe7WGlcRF?=
 =?us-ascii?Q?NDf+yzEtjySFaQiv7Pl7Z5mFMst0gNrY3OM8PfqE7yFHfvZQMwrW8/augJDH?=
 =?us-ascii?Q?Dc/VgNfrqfwmlevwdWV4+R5Nf+FbWWOrY/RaMmI2wdouxWzzC3PGJgGQt2mm?=
 =?us-ascii?Q?LO3SQcpLIqFGdUEHfbNpI4tejKKio4ZTSwXaRjDBG07i9yF7ETmoaQdsRBQP?=
 =?us-ascii?Q?HULNAJbeQdXEsXYlK84FLIVATO9r/REGv4SqjoCnMnn8VJ3EcGn/Sqw6zlT0?=
 =?us-ascii?Q?NiZXL1VnY+VuteA9PI2Y0nh+7UuS88Z/b+9howdcFiDNa78Fw4syKv+eXbJ6?=
 =?us-ascii?Q?7A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 4ezqQY9KJ9p8Kzrvm4oOXJhBzKz+XC8xlLM26fxfBAdMg1qPTKmnzK85AGkg4x4vS83iYd0Pz6zDv/smJUHe1OMU6Obn9puC/+ffAluPaGTf9skZOiYy/l68DL/0X5fHWG0t/VKpIM2qtFJzfoP7oHaw3v+nQILLKPARVuCXZzAYs+3Y7UjAlOCMTVNgE7FNE3pH7Thq/XFiRoEn7e0sEqutWu3CcnhwG2Ptinml4IQVbrVCZ8Mu9ft9ob+G2G4wgik01Q8YrOjW87r49wEvQ2h011q8s+UXKhEdcZcTSB8NzIX8BJolzXz+UrEfvqDTik42a6b3JMjPbEN0UMFuDaW1mPzBSq2cwdUVw+TFmGBx3BryImF5ZO1c+nKALqmWof9vzExJmelyCOWUcgsu2rnA0PsMOLk39MYaWsU+3X2lW9fynSCmJ6KQOePnOC0lSATC7lz6gfAIDzxv/gtCxjBn/Mbdb9CHuez5T0HhJDR2bCdcqvlqSFK+JqGgzUML1d4g8GUWHoecK1r7rYRP4jj5b7YT8D7LCr79dNm6O1ULXjkckIeOOoQm66OOrox+H3dsYST9pNI2hhSjC/ZsvAxmWHD5kSvfcsKkYq75yz+fmvO9jkhJ9jCaLjDtVGx03DDe48+zA0K7S5njdLfPErpyth/QBGkNUG6uev3CF0FqBJTUKopxagmMmMt7Zf0lKNExCqnuVOvJ+cuwU5kwQj81zhMGuNjd5t05mWrZSKexNud3hPxR2Zn6o5oTfD6GqeZaQt3Caiv4aFDp68+f8xPv19vCRvItFZy5pYjpkazij+bDDnqiRiOS/ZlKVBU+7WpngF7rIOq0oD0WNVJBjPSOHao7Kagi2V5KlGDNI2oVKpDzhMRgm6jdjEhmLbMi
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8de757e-f69a-414e-3644-08db3b13f520
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 05:08:30.8130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2HC/2uYCz781igmWosxfT4vS6uXHqA24GCpkXP8UJkconwIINTz8YU0i88P2D/nEGk24Pk/KFIt3TMkNYmknsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120045
X-Proofpoint-ORIG-GUID: RwQH5vc6bzDtEn20cr4uVoSIsp_mtM6Z
X-Proofpoint-GUID: RwQH5vc6bzDtEn20cr4uVoSIsp_mtM6Z
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

commit 5e28aafe708ba3e388f92a7148093319d3521c2f upstream.

Only v5 file systems can have the reflink feature, and those will
always use the large dinode format.  Remove the extra check for the
inode version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
Changelog:
V1 -> V2:
  Fix spelling mistake.

 fs/xfs/xfs_ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6d3abb84451c..597190134aba 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1510,8 +1510,7 @@ xfs_ioctl_setattr_check_cowextsize(
 	if (!(fa->fsx_xflags & FS_XFLAG_COWEXTSIZE))
 		return 0;
 
-	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb) ||
-	    ip->i_d.di_version != 3)
+	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
 		return -EINVAL;
 
 	if (fa->fsx_cowextsize == 0)
-- 
2.39.1

