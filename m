Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832B2698C8D
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 07:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjBPGGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 01:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjBPGGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 01:06:00 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08F836FCD;
        Wed, 15 Feb 2023 22:05:58 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2J9r5011524;
        Thu, 16 Feb 2023 05:20:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=q8UTo2pWGfISnko9YZOKVR4wyvGvV4LD4dTRPRY3UA8=;
 b=fV52SGgiuAxpbHwlnHYhTUkwo74f8tanGvQFB+idMHKqAYnvBySPOhkW7hxsZxS04eSW
 FkD84hXNdr82PYMD+0BR+8DrMARQBT2sxiC3+h0BfxOfGfenRpAIeTMlP1igAMDIF/fz
 3LAcHR7N7vtZ8/on3fMrfxG5YtiUGNn4CoxP6DSkO1to4/39beMsF6bjSKxzt/r566h1
 jvt4WuIl9K6LPZ1tHcVf56ZkB/LbAafrjcVEijkh7Vjsdn1O+WxJSUdR9pz4QEzrgi4L
 2xQjzMmPxQqOZjVBdVpTtGJn623XAtG9g9Q1uS8ZCjCbJkutzHLCc8BtKTf/X1voyawM +w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1xba7yr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:20:50 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G2nqDS032441;
        Thu, 16 Feb 2023 05:20:50 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f84hs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:20:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGFYAYymYIIHmQmUwqZBZf2Unro+knd96wKAcvriFkhczX00N+BGrDLsJSbHa6S5veY3NqOMe4cqw3RFtAvp6FaP12CL3TXKQLkyHsBcW0Vt2NS9NxxDAaLGtQXXvqznbll0vlx0dGn4QvVPpSq0iCu4SJVQ7v+IHgGrY8aoTnLnCqwF1skeyVgkpRFAESJqWoFaEcYRSprA5XAxFKOyUgczGpmipad8RuH7tuftYxlzEjdY634SmMVIhfbT48rPE+Tfazi1B0OrW2a1JLbFSEutv62bvK5+36zjaEKvMbm/kLVNE/40wK22wbbB5mrJRYar/0AmldLs6ibc6/JmzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q8UTo2pWGfISnko9YZOKVR4wyvGvV4LD4dTRPRY3UA8=;
 b=Ev2gbbNBgwCQ7XK7VOSqJ8+zDfZnIaS6wn98LE6SUWEeft0zQPlycqSlgKRLEm03c1QeRvb1ADIRKsY7l9ygaNpoFUJSMasrTrW12/98fu3n9HwLat6uEAXyftODGtpB75w+9DBWvyzlMarJLDkzw1IgjPYGqM2jJ0wpoKvArTlzw6zvDrq6ASBL5M+npuSvtcF6U/4jgKScKyNR1yWK5sPUqftvLn6GFWI/b91NfMLbf1Hddt+VYpWfR36CYXmiLGmMXR5m7Sp1nbuo636j/I1hbsm2zWEcq6NAi9r3rAWHQTy6+XDDQeKYdOMC8wY2eXAZdu47RkqELB8trO9NTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q8UTo2pWGfISnko9YZOKVR4wyvGvV4LD4dTRPRY3UA8=;
 b=rdO+9dAm2GaczT4B89yzGspTzAH/bTag1nOTpY15+ELwVowNDq7l/+M39DHE/3UzjHWFNiS/ah1P6xe+7vszWijJGj1TjIoUhay059kKxi4Pmv4k/jHWb1LP/h7vTPzJyI2ohp+GbgHuSlzWKjaJNbRumHOO59VfowXXzAgi6wQ=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DM4PR10MB6789.namprd10.prod.outlook.com (2603:10b6:8:10b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 05:20:47 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:20:47 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 03/25] xfs: remove the xfs_inode_log_item_t typedef
Date:   Thu, 16 Feb 2023 10:49:57 +0530
Message-Id: <20230216052019.368896-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0158.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:383::9) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: 7087d0be-1e9c-44e3-b0d8-08db0fdd8fa4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TWf3GOc3MvJn8zsb1ZmYzN/+T5sb34OOpd48Fz61g+mMA8kQ1N4jpqYmzNQ4u2CrT47RPaQ7Ka6zMwT5FfgfQMCZDcI7lRSXkJ8XyHtQFgSvBZIBRYN/Yl7oJaOAUwtHg2x977YWEAX9SBotK+mz0Eu/bqBMW0JLuqz6RgmICklUqLi5SGPUdffSkETSfsX2tswF+0eBkyPsM9eSav0YIBJagGONlnVexJqCtc0saBAqCGI3gQ/QoKXGZ5ZUjBV6bKs/Ud6TTAdym0/Eecf2bQ33Kx+pHDes4x6MWNmXAl3IntkTkoYpIODhpNUe8i++Ov7cLy8Y1/1fXg4YW1iTpP2GLn7ZlvAAlnlTH8wWunWWlhtJZmp983KO7h5Zo5trCXBuZfQRLiJcKnbFNycB6oEjXUKPqwSXQspxc4xzoR3QgR/aPJdFePEd0FczNcmjKs+iy6uF1BIak7sJbAj1vkFhT75TrWEX1/itPwCWGoGnP4If5TKYzT7PkBNSSxAlK9hdTWEn2fqM3tO5Leoxc0KmoBqG+NZ5/Msmy+TDYu7ckZ+KqpZCUbqcK/ZSOI4hbpCcwdMc1bdCExsuuicqihEtsZFfFK3jYMzteSrQhWyORJKNOoU+gnfwFq7+lJ2rP1e211ZWy4C6BOCEt7FSGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199018)(2616005)(5660300002)(38100700002)(316002)(6512007)(6486002)(2906002)(1076003)(6506007)(36756003)(26005)(478600001)(4326008)(66556008)(66476007)(8936002)(66946007)(86362001)(41300700001)(8676002)(83380400001)(6666004)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RG8kPUlLecDvsR/29dfmgcBEolA01zFKC3uHOIfb1RAUi5nxKEVsR9cX4poJ?=
 =?us-ascii?Q?NkT+n/rF7odFvRonGwpu2t3BjgEOZuNryWAEbq0znwb8xWvNP2fS97SlfOxz?=
 =?us-ascii?Q?Vm2arVUK8LmpzZ9UJOsWn/LEcxD/3XZ5Jk20H9FAmJY/4wni5MC/gThB5TrS?=
 =?us-ascii?Q?WQo63NR1wvOmZpNK8iWgKmKtbxoJ4stnfxGAbn7T0mCl7VmSt7maVMG3lcN2?=
 =?us-ascii?Q?jaDUWDG4IHEpcR43hu88uJngZa20aS9OhHYBTYc08JgfYaptbYIjN5EDXgM0?=
 =?us-ascii?Q?gTcskpOQyp2jXEniSwpi5lLxk0GaN1qGQM6TL2n0Hte6cxPe6yhnzIzXg3FP?=
 =?us-ascii?Q?FCUBFXZ/3pVonvnZxRCi8Vl4zSuosgqrsKb+pMDud/Qu6jskwXoiOdLPJzEm?=
 =?us-ascii?Q?WmBX0W1Vbkt35PbgUDFe1PRQP6+sfc/Y0GD5jcOWzeC9DPRaTRxuDItKJinZ?=
 =?us-ascii?Q?EEO8oABku/QRHtJfR1ygH/RjiZ4alRYYf2BgYtonwI6r5nT4ohhxBIaw1WTn?=
 =?us-ascii?Q?08t/TlGN3lZ/XZKW3cRz52cR7CqHQyGF8A0uRdqD21L2CyW7gSYzIgddhnJk?=
 =?us-ascii?Q?2wHKEHHdRxWK1qhLEm7xwJQPpAtQng0mY/6JI4c2bDICvlq3IdAHE7LGpn0L?=
 =?us-ascii?Q?zAA+vfEEIf8Escm3euen7OVt0QFLUQccZBJy7xFcjjqBlTKmN/OtqcXjogu8?=
 =?us-ascii?Q?lqGMh65zSb2BqiG6wY2dQjbnhnbiM7lakVUudncdMcfYFOX+9GIciunbyIwD?=
 =?us-ascii?Q?UibSWEgVzFBBC6xNjrG+xik/rrl0hEM1kw/DL0uyBrv4+HL2rghKBGzk7MXL?=
 =?us-ascii?Q?vCDgOoWHoJs9mKlIeyWIpAT5CReD04Kb+JKPEGXbGisYQ43/HHu3Q6aVnJVP?=
 =?us-ascii?Q?VHS/HwZI4itJ6MH8k8V4Wg+wi+BdBbCuLnwe2q+C/Xoydn7slJ76H/2lE0cZ?=
 =?us-ascii?Q?cHu5sUvma2q5zw0Z4bZG2QBiKEW/Cw9PV/Cn2BTZpUv1bLc/QfqVRZC+WR/P?=
 =?us-ascii?Q?n1cyuJJxSWBITZa7Ue4diThBMwxn5sD0FaZ91ByrMpZl70ErgmHLbS28WGgU?=
 =?us-ascii?Q?+DNxED2tFoVUZ4Wlo+33uXTnKTEqIhRRibJgT9vyFPkfKkCGrnuF6upLcuLR?=
 =?us-ascii?Q?nzeYtPfLsTaGdfBRfHL78g9EQGEtNVe9mrmeEFqAiBgv3vHsUlp5RIlA31uG?=
 =?us-ascii?Q?avfFPq6hqp8x/IMeV85nUlYNa0htdYIsOT49819TSjML+lUNTnlbtL/na/ch?=
 =?us-ascii?Q?gxRp+nuj1e+Eswz1KZMCds5NoT+zrdFdzOEShgwDXjoxS5RseLUTdlZVmFjN?=
 =?us-ascii?Q?DLmX4f0lOwoXYBXV4djBT/izBM1qlJHikEXKR7uuqjA5qd1wLyHTUQbbjyl9?=
 =?us-ascii?Q?te81o2K1X/kpaZi8ubjIOPvZYF24OOZvFMAdeRorMLcAUr+0xi/kcT0fgI7B?=
 =?us-ascii?Q?DgIbIhRRiAogGIzLS0vBvG7U9hnPvWLKJAdEFRiq96QVP62V6F846AfOCLq+?=
 =?us-ascii?Q?GXzMt+p1QsI17wT/diN/WhIOd1R2xzHTgUq9jrZCuVyUM3CfSbk982YfVJGI?=
 =?us-ascii?Q?Ved05oUvqcBemdjTBOiIY0d9hK3r5vNwUVJIr1mkIgMNUxWMw0PJpNywEFB+?=
 =?us-ascii?Q?Ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: dGPw57nUaW5dd8epuZFVHyhMQZJ+pwTEA0jqB9AoSoOddIUDMA+482MgPi0x7BtEWJ/FldadG9fIJFI+6xAAiShZQZdV81w2qqNEAOvsKjjEq9p/3hjhoX7RKWsFCtqs82+0SuT7n/vvgEYUOptMaJJcX/zMNfUVtfwvFB2dRWCWGErkNV/uaPVLVgTan7t3xs4EYXQ8UrSPg1kLil6TsssauxXOuF0fZ9OlxR5cD0qpYNbA/6OuQo2vLn59Ys77+4TehI7UtJocJcYAUT+s/0qQdJ4+mZE5tLIk5DCtgU0tbfzvZxTyvsDvQHOMSMVt5B0C/GYYtZYPsTgNicSXVeWwY26uyWwo+PZMTZrb8v3AOoolNQAdwgz4+7zGynPwEyf56MtbMN9kz9eRvHP4HhlsLe9a0gtmovOY+Sh7Blh3Us33F9Ba+InpalPvFX0Xt9kdO+bTA/zg6B98c8Z5SqeTtHbf8uS3HXIPfyJtXP3tOhda+6vNBDE8DRTrMYcYkyf9FI9PX0FsrmmQ3L6UA7GDpYOnCxswe+E/T8F/cd2AE5zlteXjCGc3lifGdeeD+SlvYp/thyipul5LpFVn4vajzZAhxPSInC+QotAaynj+ZZcLE20FJqkXUM9+yfnLnZTFmbzounBgAfcYUOkNSKVEPtBmKHpfsXZfykci/J2FkD6qr3aAQRpRM9snv2SNULYLHWCdELEectvGYX+oCYRcgrIwm8KAgUIaGXV+oEDujAEMg4j8qFB1Nwb6eTRDaUru4Vy4KCU5lAPT/4u6fmkesnKRjut3ImpRu3OGGhSsauxCZD+CMTkpJWSxWeQx7FkB91HwOvsCrUxRnsogU/eFNSq6JdEjEUy1Viph8YRncnJInXLp6oiIfJsWmWAL
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7087d0be-1e9c-44e3-b0d8-08db0fdd8fa4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:20:47.6119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4xqMf2+z07vzBNzXnW7ZuFJvtF7IVzm9Gj3Teska9qk1fl6NJkrtr2Z9dVvVrWtjZDp/IQieCFfI0mq3s24MXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=966 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160043
X-Proofpoint-ORIG-GUID: HTyp7-i1tsxYr5beXu1z9k_pFQBEreOu
X-Proofpoint-GUID: HTyp7-i1tsxYr5beXu1z9k_pFQBEreOu
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

commit fd9cbe51215198ccffa64169c98eae35b0916088 upstream.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_fork.c  | 2 +-
 fs/xfs/libxfs/xfs_trans_inode.c | 2 +-
 fs/xfs/xfs_inode.c              | 4 ++--
 fs/xfs/xfs_inode_item.c         | 2 +-
 fs/xfs/xfs_inode_item.h         | 4 ++--
 fs/xfs/xfs_super.c              | 4 ++--
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 15d6f947620f..93357072b19d 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -592,7 +592,7 @@ void
 xfs_iflush_fork(
 	xfs_inode_t		*ip,
 	xfs_dinode_t		*dip,
-	xfs_inode_log_item_t	*iip,
+	struct xfs_inode_log_item *iip,
 	int			whichfork)
 {
 	char			*cp;
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 0ba7368b9a5f..1d0e78e0099d 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -27,7 +27,7 @@ xfs_trans_ijoin(
 	struct xfs_inode	*ip,
 	uint			lock_flags)
 {
-	xfs_inode_log_item_t	*iip;
+	struct xfs_inode_log_item *iip;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	if (ip->i_itemp == NULL)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e5a90a0b8f8a..02f77a359972 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2555,7 +2555,7 @@ xfs_ifree_cluster(
 	xfs_daddr_t		blkno;
 	xfs_buf_t		*bp;
 	xfs_inode_t		*ip;
-	xfs_inode_log_item_t	*iip;
+	struct xfs_inode_log_item *iip;
 	struct xfs_log_item	*lip;
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
@@ -2617,7 +2617,7 @@ xfs_ifree_cluster(
 		 */
 		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
 			if (lip->li_type == XFS_LI_INODE) {
-				iip = (xfs_inode_log_item_t *)lip;
+				iip = (struct xfs_inode_log_item *)lip;
 				ASSERT(iip->ili_logged == 1);
 				lip->li_cb = xfs_istale_done;
 				xfs_trans_ail_copy_lsn(mp->m_ail,
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 76a60526af94..83b8f5655636 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -781,7 +781,7 @@ xfs_iflush_abort(
 	xfs_inode_t		*ip,
 	bool			stale)
 {
-	xfs_inode_log_item_t	*iip = ip->i_itemp;
+	struct xfs_inode_log_item *iip = ip->i_itemp;
 
 	if (iip) {
 		if (test_bit(XFS_LI_IN_AIL, &iip->ili_item.li_flags)) {
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 07a60e74c39c..ad667fd4ae62 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -13,7 +13,7 @@ struct xfs_bmbt_rec;
 struct xfs_inode;
 struct xfs_mount;
 
-typedef struct xfs_inode_log_item {
+struct xfs_inode_log_item {
 	struct xfs_log_item	ili_item;	   /* common portion */
 	struct xfs_inode	*ili_inode;	   /* inode ptr */
 	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
@@ -23,7 +23,7 @@ typedef struct xfs_inode_log_item {
 	unsigned int		ili_last_fields;   /* fields when flushed */
 	unsigned int		ili_fields;	   /* fields to be logged */
 	unsigned int		ili_fsync_fields;  /* logged since last fsync */
-} xfs_inode_log_item_t;
+};
 
 static inline int xfs_inode_clean(xfs_inode_t *ip)
 {
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9b2d7e4e263e..9e73d2b29911 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1934,8 +1934,8 @@ xfs_init_zones(void)
 		goto out_destroy_efi_zone;
 
 	xfs_ili_zone =
-		kmem_zone_init_flags(sizeof(xfs_inode_log_item_t), "xfs_ili",
-					KM_ZONE_SPREAD, NULL);
+		kmem_zone_init_flags(sizeof(struct xfs_inode_log_item),
+					"xfs_ili", KM_ZONE_SPREAD, NULL);
 	if (!xfs_ili_zone)
 		goto out_destroy_inode_zone;
 	xfs_icreate_zone = kmem_zone_init(sizeof(struct xfs_icreate_item),
-- 
2.35.1

