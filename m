Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7315BF465
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 05:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiIUD0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 23:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiIUDZ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 23:25:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8B122292;
        Tue, 20 Sep 2022 20:25:57 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28L3P0dC019186;
        Wed, 21 Sep 2022 03:25:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=1ag9RncpoVcywSr9KbfiCpt9Byd+/I1IVd3bbnoAnAs=;
 b=xw1NSCmssTZif8nc8zsXzXoMXncDjujXESeOPGqY0J52JIzcj5+PBQqJB88B2F+0LCCX
 ARvHT7qVK+etIJi2gf9TRlRiTmkFxjjGmB3yErhvb53fw3d26B/nqgcrOYwKne9bphoz
 xKZYEpliJIDrIQMZe/hT6GyRb6ng0UT6l2lyG4zFj4+jVylVCAbEQKmyhXSCZLX3nQR6
 gRcidmfxLW2qpD9mlqIPG2y1BlTZcCrJpvHIylPBN/i54Sj8SuCtnOWyetQqlysjo6Jw
 0ZIfkIjSimqGpNICZMC8DyfZgoWDCEDL0/rstbkaNQlQgwd0SmIRrPv3IT77n3pTRUqD XA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6sth4sr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:25:52 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28L2Pv11009952;
        Wed, 21 Sep 2022 03:25:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3c9p68d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:25:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+tMfE6jVs0R6AChIQ5BxORgANmlnZGvCv/gGdIbkkNxZGZcPOo+anZGDfH0MKqm51aJEK3yPhHSNFhTCsxVsmigK4RR4Y+VcgwYEkYjdCnrNSaIGFVxmC/36ynyG6jzTq9hZt1h5WG12SaRwiXTHiYUSF2Lp65t+TNw0FCLSYQh7DlEf2bSszmf3UYcc1//dgrdF8BS0E74NbZpg0iVD30ogGPihtCYh04wosibbtbvq1I+CZ7SI8j5CVSgUaAMj5+mpIQBeD2cdR7GvyfZEjn3gL+dUe5NEtJh/xCSUM/Q3+T71EcGuiO7Lcdn3YegArj6b0KUTZ58+kY3VW6Y6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ag9RncpoVcywSr9KbfiCpt9Byd+/I1IVd3bbnoAnAs=;
 b=MsuWXQ2GF9UNH8q2u4Iu58BC0455i3vVD4yMOnbylqYYj0FDFHJDhK78WLcRzvBg3h48dfqks5ngbqIJ9413m7w9UUhY2arE2mR5v9gkpejVM9oDNvraV4ieUO7EjWkYQqz+CEnp9//xuhrIY7YjX9hJbAyo0gG5GyN6natgR19gYxx4fikp6zIbUpLgiBOtmcrZUDzM0Ud0YVljIvRpQQoKXHS/yrrrnp5GVgM2DTEESxVW5wYJxzj6pF/Ru9Jff3HxftyTiiox9awX4UHZHC/ag3ATHrKE2xU22Uo4UjnQSJUJAw8WEVlfGtXFU0lm+wCXDBA7PN1T8rJJn8TG3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ag9RncpoVcywSr9KbfiCpt9Byd+/I1IVd3bbnoAnAs=;
 b=k80ho6ldGVoFDJ8QFES+MeMzK//94XRnE5/6rKNJqW9tVsHC+RF5geTl7Lw3/pMOBjVPKkkNVQciIPmslsp/6Tb8sQW7BXHBOHR6BFf+PAjSRG97OcYDakIKgd5TC/zI79aMVNtA4UUgs0RGYn/R7YmwS0XgLZx6mczboqadxRg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB5579.namprd10.prod.outlook.com (2603:10b6:510:f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 03:25:50 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 03:25:50 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 16/17] xfs: split the sunit parameter update into two parts
Date:   Wed, 21 Sep 2022 08:53:51 +0530
Message-Id: <20220921032352.307699-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921032352.307699-1-chandan.babu@oracle.com>
References: <20220921032352.307699-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0103.apcprd02.prod.outlook.com
 (2603:1096:4:92::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB5579:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f0e9590-a252-4b28-d3a7-08da9b80fb27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: voVWANucNb/s7t+o17wDGSke0e68PyvSkmC7sqLe7cxoqza298llbRtSQoO00n+Pg9YfbG10dcdNVm5QuKK8Qoi89JUVKs39y2r4ZBNomxAekcppAcIPrDum83BuVypfIn9SubyaZBHLYVg5I2Dx5Xo+5pxINLoeQ6lKD8futSfQzhEKnk7wvfIabcWaswRF7ZgN0o+2y6+hlRyBvn/WX16gfItjPBRhUTYAJ+NVgYf5EPkKBuenJfqBvWBXjQuG59RixsiRefe7aik9U/L1r0QygImiX6nWeBl7lObC7+vMBfoBjOae0qgBI1FtgIK7qC02t8epto6EuskkHwfXi8D2aBgfQUpZKAC5BsyGj88/JmC0pdBPQ4i0zjhoZRNnBnOwSKIKITX/zllCt6mTVmM55vYfcYt4hzR85JD6+zT2jiqxSHaljWjjn/gu3X8+Q6a6ViUjD3I+M1PTWK32gVSHSb7mKudH/8E+mmKo2Auo9+WgJRLsgK6zRRNOFNtGpeGAF/1B80oM5G0HEZ1yeT5h2iyrXntXy4S08eoWDM1Q6xlxNfRzIQN3ahSWyA72La/+H5BgWhQTdIlfmYHSNjCPME4ehmvaKelq9UA7NqrVs1TyAJR0Lc8eNmwyPN0EUGkkKAOqQy4oRJkpc3QoqpiUVO2/Uk7+2CSiF/aky4/u2rXYiLBd2Hgdbql5pABYfWFF6VmY0ReATkVBDnYPsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(2616005)(41300700001)(186003)(1076003)(83380400001)(2906002)(4326008)(478600001)(66556008)(66476007)(8676002)(5660300002)(86362001)(38100700002)(316002)(6506007)(15650500001)(8936002)(66946007)(6916009)(6486002)(6512007)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3LrEQW/nN9QNpyourfxwhWLi05Ss412yY6mGWNNbRgtMcZ2Fl4YKxDgB48Dv?=
 =?us-ascii?Q?4vqtWlPD8TkpulkeiNIGGayFX78ut5IDDUG1wAcqdTTfDl4gR0suYLKbXspE?=
 =?us-ascii?Q?h66KXb4SE7GGGUwuD3ERZldAphnFSn8LZrw5Uii795JgUo14fYR51ch3Ehs/?=
 =?us-ascii?Q?M4QcbvIvYVxWQJ+XEuAMe+Ea4T0FQVizI7P1JG5fr/t0o5LIADf1PulGJUFr?=
 =?us-ascii?Q?ClX8nvmY7cGKDGgKpfTfgm22ftKOpT1mwTnNNORJIEOYkwQL+TsFeQC8zVOz?=
 =?us-ascii?Q?uncv5Fp0di+yqAcDhvcZsipkWEajlrMvf4NbUs5L/tbdpYUGWEVK52pyq4MF?=
 =?us-ascii?Q?/Vk256Ox3t3e+LjgXSGVaA9enwgj1MI9NCTJyCQgBfgbwpORZNTQIg2VKYxc?=
 =?us-ascii?Q?lZedjUR+ParCNs6Hp1ZOAiYjPmwlArFky/ZYvOrOUIZy23DdrGQ1Q6IPmxVT?=
 =?us-ascii?Q?+WblPUHayZhAOJa4V55uxs0j6yZ1P53ZTIilDtPGDPJdxAd4uhRM2r6aDyc1?=
 =?us-ascii?Q?a620B63XPA5y23UeCX+LhUZghkuBatSEl6qsoD4RfCo/0AQyloHlge3Zh563?=
 =?us-ascii?Q?JAt2DC5Kc06hGbV/qRQ4ilRFVObTOsj5fAWhEA9SUpOpgbIGZXJ1zMg8J1ie?=
 =?us-ascii?Q?D+DBa/FEYYSCqW9+uNnEJuXbQbXf0QjJFBl9BDkLoDHRITi29fYSiUqOdBK8?=
 =?us-ascii?Q?j9rKKlgU+4IOiAFTgUtRwvo6ovLbTJwVBhPWrg5XNUVGyVPgRB5zCLdit9Ar?=
 =?us-ascii?Q?NC1vbvxMiD6VU2uzhCx/sEQJz4GD7pb5rPHW3Bd+hPPCBW26KKyv0QJAHaXZ?=
 =?us-ascii?Q?4bSbXjjdMQPjRDewvWaiUYMDgvyr/IUkrSL3XKwzC0nA+AONghfnm/2YZDju?=
 =?us-ascii?Q?md6cNl8+n/P4ftPMVLpGb4dUNioVaaf9jdS2NJX8mCowN6SyguTynbX/Kwef?=
 =?us-ascii?Q?/XE6D2hEI3H3DX6ltiBNSV867XDx8AjLGV7iHhyr5pfSCog5pgtxt1g2XWte?=
 =?us-ascii?Q?Kaw/3sCu4LTQRDKO+teRYResztBSrW4HroNexBE85GPvLIiJ8xULgi/NIgkK?=
 =?us-ascii?Q?swBFcEPuwclVA5SgE7sjppRWfIzeIyeyfarNhBfwEcR7mb4bMfT3/Ebzqcp7?=
 =?us-ascii?Q?di0gnK9hcDSU4XrGxQ+88kudU1rdeQ7VdhKgSltOOMmF6GZyHF0kCMBDAGwn?=
 =?us-ascii?Q?VXOqOYAfHhnwcgJol+C2wdnnl4T8/8WDgxzUHp1wmj8fBhA5hfzNrLrgkq3+?=
 =?us-ascii?Q?u81oHKjl2kxQRQJY74ze90H2agB9ret0QMM5zDUmxXH4DO+Kxc3INrpmDX2l?=
 =?us-ascii?Q?lzt16m0lzuzOfIYrG6E1HtgvLsgFxD+uhp/B5h7Gk79lSjwXmIewsgS0mLPt?=
 =?us-ascii?Q?G4xjyjfAyigwBlxXjT906dgqD3NeQxJuk97Rt3lUGP9B+gmaxtXiqWfS8RdC?=
 =?us-ascii?Q?agNePeepm1UncK7sa5otO9qkmq7hcWZ3mbOGdehXbwqx+DTn3Swzc2HnkH54?=
 =?us-ascii?Q?pDI3nThY0X3QuGImidd/6fwoR36HbLzd2VbmNUGGp2tu4TJ8D60sQ4d5mW1w?=
 =?us-ascii?Q?BN3XeYeiK2rfhiJqwkyjU4OGyV73Ys+hSJ2Lx298E9tV9c62q4gEYyMNRW2I?=
 =?us-ascii?Q?Wg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f0e9590-a252-4b28-d3a7-08da9b80fb27
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 03:25:50.0812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9FSgBum0+vucPWJgrqx04ql8VxZHNp47TsM1QBbzTj/XrFj3C+X7/dUVuITdySVs76T7LgU78rPGq4CDYnny0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209210020
X-Proofpoint-GUID: eMr5nhDmY7x-YCflQBUD8keprbBtYgbG
X-Proofpoint-ORIG-GUID: eMr5nhDmY7x-YCflQBUD8keprbBtYgbG
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

commit 4f5b1b3a8fa07dc8ecedfaf539b3deed8931a73e upstream.

If the administrator provided a sunit= mount option, we need to validate
the raw parameter, convert the mount option units (512b blocks) into the
internal unit (fs blocks), and then validate that the (now cooked)
parameter doesn't screw anything up on disk.  The incore inode geometry
computation can depend on the new sunit option, but a subsequent patch
will make validating the cooked value depends on the computed inode
geometry, so break the sunit update into two steps.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_mount.c | 123 ++++++++++++++++++++++++++-------------------
 1 file changed, 72 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5a0ce0c2c4bb..5c2539e13a0b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -365,66 +365,76 @@ xfs_readsb(
 }
 
 /*
- * Update alignment values based on mount options and sb values
+ * If we were provided with new sunit/swidth values as mount options, make sure
+ * that they pass basic alignment and superblock feature checks, and convert
+ * them into the same units (FSB) that everything else expects.  This step
+ * /must/ be done before computing the inode geometry.
  */
 STATIC int
-xfs_update_alignment(xfs_mount_t *mp)
+xfs_validate_new_dalign(
+	struct xfs_mount	*mp)
 {
-	xfs_sb_t	*sbp = &(mp->m_sb);
+	if (mp->m_dalign == 0)
+		return 0;
 
-	if (mp->m_dalign) {
+	/*
+	 * If stripe unit and stripe width are not multiples
+	 * of the fs blocksize turn off alignment.
+	 */
+	if ((BBTOB(mp->m_dalign) & mp->m_blockmask) ||
+	    (BBTOB(mp->m_swidth) & mp->m_blockmask)) {
+		xfs_warn(mp,
+	"alignment check failed: sunit/swidth vs. blocksize(%d)",
+			mp->m_sb.sb_blocksize);
+		return -EINVAL;
+	} else {
 		/*
-		 * If stripe unit and stripe width are not multiples
-		 * of the fs blocksize turn off alignment.
+		 * Convert the stripe unit and width to FSBs.
 		 */
-		if ((BBTOB(mp->m_dalign) & mp->m_blockmask) ||
-		    (BBTOB(mp->m_swidth) & mp->m_blockmask)) {
+		mp->m_dalign = XFS_BB_TO_FSBT(mp, mp->m_dalign);
+		if (mp->m_dalign && (mp->m_sb.sb_agblocks % mp->m_dalign)) {
 			xfs_warn(mp,
-		"alignment check failed: sunit/swidth vs. blocksize(%d)",
-				sbp->sb_blocksize);
+		"alignment check failed: sunit/swidth vs. agsize(%d)",
+				 mp->m_sb.sb_agblocks);
 			return -EINVAL;
-		} else {
-			/*
-			 * Convert the stripe unit and width to FSBs.
-			 */
-			mp->m_dalign = XFS_BB_TO_FSBT(mp, mp->m_dalign);
-			if (mp->m_dalign && (sbp->sb_agblocks % mp->m_dalign)) {
-				xfs_warn(mp,
-			"alignment check failed: sunit/swidth vs. agsize(%d)",
-					 sbp->sb_agblocks);
-				return -EINVAL;
-			} else if (mp->m_dalign) {
-				mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
-			} else {
-				xfs_warn(mp,
-			"alignment check failed: sunit(%d) less than bsize(%d)",
-					 mp->m_dalign, sbp->sb_blocksize);
-				return -EINVAL;
-			}
-		}
-
-		/*
-		 * Update superblock with new values
-		 * and log changes
-		 */
-		if (xfs_sb_version_hasdalign(sbp)) {
-			if (sbp->sb_unit != mp->m_dalign) {
-				sbp->sb_unit = mp->m_dalign;
-				mp->m_update_sb = true;
-			}
-			if (sbp->sb_width != mp->m_swidth) {
-				sbp->sb_width = mp->m_swidth;
-				mp->m_update_sb = true;
-			}
+		} else if (mp->m_dalign) {
+			mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
 		} else {
 			xfs_warn(mp,
-	"cannot change alignment: superblock does not support data alignment");
+		"alignment check failed: sunit(%d) less than bsize(%d)",
+				 mp->m_dalign, mp->m_sb.sb_blocksize);
 			return -EINVAL;
 		}
+	}
+
+	if (!xfs_sb_version_hasdalign(&mp->m_sb)) {
+		xfs_warn(mp,
+"cannot change alignment: superblock does not support data alignment");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* Update alignment values based on mount options and sb values. */
+STATIC int
+xfs_update_alignment(
+	struct xfs_mount	*mp)
+{
+	struct xfs_sb		*sbp = &mp->m_sb;
+
+	if (mp->m_dalign) {
+		if (sbp->sb_unit == mp->m_dalign &&
+		    sbp->sb_width == mp->m_swidth)
+			return 0;
+
+		sbp->sb_unit = mp->m_dalign;
+		sbp->sb_width = mp->m_swidth;
+		mp->m_update_sb = true;
 	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
 		    xfs_sb_version_hasdalign(&mp->m_sb)) {
-			mp->m_dalign = sbp->sb_unit;
-			mp->m_swidth = sbp->sb_width;
+		mp->m_dalign = sbp->sb_unit;
+		mp->m_swidth = sbp->sb_width;
 	}
 
 	return 0;
@@ -692,12 +702,12 @@ xfs_mountfs(
 	}
 
 	/*
-	 * Check if sb_agblocks is aligned at stripe boundary
-	 * If sb_agblocks is NOT aligned turn off m_dalign since
-	 * allocator alignment is within an ag, therefore ag has
-	 * to be aligned at stripe boundary.
+	 * If we were given new sunit/swidth options, do some basic validation
+	 * checks and convert the incore dalign and swidth values to the
+	 * same units (FSB) that everything else uses.  This /must/ happen
+	 * before computing the inode geometry.
 	 */
-	error = xfs_update_alignment(mp);
+	error = xfs_validate_new_dalign(mp);
 	if (error)
 		goto out;
 
@@ -708,6 +718,17 @@ xfs_mountfs(
 	xfs_rmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
+	/*
+	 * Check if sb_agblocks is aligned at stripe boundary.  If sb_agblocks
+	 * is NOT aligned turn off m_dalign since allocator alignment is within
+	 * an ag, therefore ag has to be aligned at stripe boundary.  Note that
+	 * we must compute the free space and rmap btree geometry before doing
+	 * this.
+	 */
+	error = xfs_update_alignment(mp);
+	if (error)
+		goto out;
+
 	/* enable fail_at_unmount as default */
 	mp->m_fail_unmount = true;
 
-- 
2.35.1

