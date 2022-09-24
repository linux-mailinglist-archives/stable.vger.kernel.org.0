Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968C95E8CDE
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiIXM64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiIXM6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:58:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DBC10F70A;
        Sat, 24 Sep 2022 05:58:52 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28O3wK10003110;
        Sat, 24 Sep 2022 12:58:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=CS/JPWPekvz9NXFP05O5/jYdkuqbnHN4DIlrt2cBhzI=;
 b=t/WDrOcGcBtMrXq14JAdBZ22RIWO879x/BAtIeVSHk4ysGgaERtdvQNrmxmK8GCaIPAc
 OzJGNbfZXgY/bJh7cMvKRySsqfF8d0TMsPdz12kg6hOq7JNhsziVxIRaw1rwcMXPA75E
 LI1YgE+b+CwRHJ2rzfLlC7d0RiBz+ZMDjSCXb/wrK6m6H8tE++3iGZVxw4UPQHJtwbvh
 tM4KuwnE2C3CM7Q9vUc2vMlkFIl2nUC+PWKzZu4RKe6LK+y4bwtZ3nuwwBdabVbMu4py
 3i1HD0YJ1T46XZZfmm1GgKmHCXL1nOYd8ai9p6qGRj4+oQMItERSk75MTVunZ/Usnu6p Cg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jstesrfvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:58:48 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28O4d9dn002797;
        Sat, 24 Sep 2022 12:58:39 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jsrb1s6j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:58:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dv2W78B41siufvrx/0nL2RJs/JaFd12uqBYZeZkI+PgHOj/USgURjxZq+4PmSyM+cR1mewg1oAF3vVT41WlApNX0wdNWM99iR26LbxR0S23FSmf/9LpC1FllbuoYfsv10XKTY8eAKT4vGWUXT7mvJFXcnGYOPfBrCWW4Bn3l8Z6yw1jsoDpOBt4elhGXLJMzVKYklohRoFsMvYdeAoaYpYSR0yd8LesBKE8Mw4Ww8575EBIS+295MRkDXRfQewAin0TPSBlbsO1PFLtwRo1QZ+rCX6VmYCiq9NSnItxOBWy+SO37RUGOlBSghp6I/mnEQNiHnqEOSaUcXXIxiaLRFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CS/JPWPekvz9NXFP05O5/jYdkuqbnHN4DIlrt2cBhzI=;
 b=B7xvARFhmrJMSMSYlEMFQXRXM/hpX5WXl3O1Sh8pZz9RK3pdkvtaofy4Hg+rv9jcFH8BpqW0xOGGZutaQrWTYXYRuMc/swoXTJBpahLuspyyXDE0Zkm2zMd5y4kUJRYBx20ekGGVmb0tnGzVgdaNLR67Kpiw/zwZt8+ynnyfs8PWbNEvoPJdn+BhusvPNmgpzBE0/b9nbjW9hLSEi1zahN87SLgpatbU6IL3zDHv6AA2N2qAY58Lhdz/2TSjgkHqGJYoLNNH9BUwzIwhmZMHWqenffaIuafJdIjXy3si6a4Z07pXrGa0g9X2VV28Z+vWKrjS+kFLqsTss4Ezlzlb4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CS/JPWPekvz9NXFP05O5/jYdkuqbnHN4DIlrt2cBhzI=;
 b=o/wgkUjaxn9uXzMHLGPEfzlQFlrH++OidO4IoYaFZDDPVn4jlYPD5kUYfY1RN6SCBCzzu1Pw7SVvDcA818G5aPuzuLCV869aShWXgdr9FlhACMbhJ6juimHQBiQD/qrHYZoNv/Rii5ZfSAyQZcDoLrV1hPMBJV2RvUrtShVcv0E=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BLAPR10MB5108.namprd10.prod.outlook.com (2603:10b6:208:330::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.22; Sat, 24 Sep
 2022 12:58:36 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.022; Sat, 24 Sep 2022
 12:58:36 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2 13/19] xfs: stabilize insert range start boundary to avoid COW writeback race
Date:   Sat, 24 Sep 2022 18:26:50 +0530
Message-Id: <20220924125656.101069-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220924125656.101069-1-chandan.babu@oracle.com>
References: <20220924125656.101069-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0028.apcprd02.prod.outlook.com
 (2603:1096:404:a6::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BLAPR10MB5108:EE_
X-MS-Office365-Filtering-Correlation-Id: 95d00661-7e6e-47ff-7241-08da9e2c7e39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rSj4VRmskgGASGPt9mNP7UkvPsh5ZjLddybfiH9FkLj4Sq545hn+wgkdW49FxmdzKAQpntvAklhZzdmwnJjujOU+tB/HKQikokUU0ayAtst9ZZS/IMR3sIzvxVNSDTGBUVQQDdc/lKzI6hTphtR6rWUV+YKlpPSJ3ElL9gy/+qC7FQaePdjUzQo6mwJ+Y73NYZVvpD6gdkhB2ep6047GqswVkeIOJlsk9TF+po2ANfHi9d1BGgr9F7mIl2NmYE9D8ok6dBztoiu/0F2cjdeIAdQj6hqzuTCWyOpyxv9i1hAnnHKeKqp2g+n0AzDmibN+G36AvUwg3M1cxiCNpq2uqzGZPI+YWoujFGCowZQ0mT8BK/jx9sMlNVG1qNloTh3FToCvetGZrvsqFtOLfNlcw5e8W/egjlmOuXcnjxw3c+TrI1+pmgWGDweyOPR7w6XPrLECXv3JkZVHzIa8GWP7cit9xUmWSmjLg0A9e6rtOq75Yw+XeFqSiMxxrj0ee/FDfv3f2KbsFW1DZYnGJE4p62vKeoMYg/CCAaDhk0Ux2l2Y4V/w2f8AJc1U/U3Ngtg+ShjZaWPrrcLyFnbH98l9Bgc7mvUdkGHF+SW0hy54mhbZcGnLGVEhQqjXHtIV5oQtpzQtQ2oGscZHcc6ODT4Xjsw15gacMPqW2aZUcNLqxvi/GByIGnWZp1cp6UbftReFJ9j0bpH0GR4AYiaw7y2+xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(396003)(366004)(39860400002)(451199015)(8936002)(6666004)(38100700002)(83380400001)(6916009)(478600001)(316002)(6486002)(4326008)(66946007)(86362001)(66556008)(66476007)(8676002)(26005)(6512007)(36756003)(6506007)(1076003)(41300700001)(186003)(2906002)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nc/FUMbeGkPksCA691PN8zr3lR4Wt0ZrfzwY01u7vT0A+0RcBG/s0+Kw/9vL?=
 =?us-ascii?Q?3FGPcAn2Mhdy/lrZRLHdHJoB4VmQ5VQjpv7nGJNh6NZBQdURBa6fm3GgKRVa?=
 =?us-ascii?Q?2+9jEhUkoutTPfOhZ7t+VzvimLEGuDS+Vx57bzb8hsVqfC0rfBgsZ3pFh6Xc?=
 =?us-ascii?Q?oXQBfprt7tNXA5oALnTEPpTHaky2Rw2JGPj2j8pmu7s22jRebLdEBNs+DB8n?=
 =?us-ascii?Q?5mLBQcmHsGKLerF8V2KNgZd66Z4DGVcciOw7i1EPR2RJIEtLPShIFZYURCBV?=
 =?us-ascii?Q?BFvUQNvg7174oToyLF3yZhRfg4nEU//Q4dzdl6CXcfkwtwLjo3qkHLJtopuD?=
 =?us-ascii?Q?A4ezJDj1QtG3NyJ7kRU6rTpbp4S3p5H4Q0wWyv5D09CtaBx6Uqv13IRDZVyn?=
 =?us-ascii?Q?zQ3VqCC9Zcnoq5o6EOiKlay8jmzcTgpeTuj4mHQuEvgMevbvlEOVVul1uQ7l?=
 =?us-ascii?Q?SQJdz0QXcrz2gNWs/3DgAnT3atJukhlPKxXTvqRe12DTrs6667xJKZZlcN2O?=
 =?us-ascii?Q?2Ma8wlBim4ZA6Q9FKBErN07IDf7kOaNDYpIV9pef2eufPfEArqFvbCT3I1Vs?=
 =?us-ascii?Q?4ZPeTf5V4adkAvMhEc2n0y8Zzn7rjYLuwSQBjUyXYq7jBExwPfgf4N1n6D13?=
 =?us-ascii?Q?n35xH5UG6X0J420nlihKomjadOmt9hR/XO8KgJbm0hF1NcvVNDRfyk1ov+wh?=
 =?us-ascii?Q?hD+WGe36vJaBE8A8Ku0sxqSNPhbUMq6zstCOHhmYQ/oLR+wUKnaYHCUfhT7n?=
 =?us-ascii?Q?0+3nZKsJTL8jqHvmXfApnXVjBe006ypaUEPRN3McajB3AtVvfxyT1vU6BUUc?=
 =?us-ascii?Q?cw8GrfS07JHgygbePydYeczHCOUGPJ3NpW7hBp9t0oZcv2lNvZ0DIU/yuotO?=
 =?us-ascii?Q?3nCLHWBrrQOPpvNGXpNgm4xxPQPWiBE9+0LKjoTIeaDGLr5kELy1nbS9YEHF?=
 =?us-ascii?Q?tU4o0meIjARH5PhhMt/W/5XjKTkNT0DYUVL7sUxZNsAA1OE7grkgjZTsqk5j?=
 =?us-ascii?Q?kF7wEI8X8+rYGEbiuALQ6VcoKo/24SxjOx4WWZ/vdsYA1UX5puzhdrnLfj+G?=
 =?us-ascii?Q?EPWa/n1Qrzdoaz8u5bYBS1xGVonGBX+W6HWR/0239qsjv3CIsDQXFy7vK7xH?=
 =?us-ascii?Q?DzGuB0KmWNhDFP7mDevEFp0z5vHzWpalxnwkgRWZ254UfQRDiEMUTL+RN9K9?=
 =?us-ascii?Q?U5Ya4GsAJjedOidCyTofnPuJII//uQqL/ZkLKxfIEDGk9ZnIJK+w+eixgjhK?=
 =?us-ascii?Q?lJSrEPkcdddfcOxGG92o34S5mNSOrMLwrnkw/OY2ZeVuehHX1AoUznwexr1i?=
 =?us-ascii?Q?yjHbjOW20raAv5+beEBS91QL8KuatRqW/5/1Xo+UWOpQR0e9eAscRvDbOtGc?=
 =?us-ascii?Q?UQA0KpNryTFoaND4qxP4c+fsIf7aWssMyxGFoaGsGdYoV27vhM/3SmU/Hx9w?=
 =?us-ascii?Q?NRKI57rYOIx+d73WNasGiQLauiTbmDsB4zg6jRSQtqz0AUKGDpfbwrMDH9gX?=
 =?us-ascii?Q?SEuJRFo46ckLiyF7+Fkn82Z0OhORy0ddSI64SANof9YJQ3yxHrlfib/HPKpP?=
 =?us-ascii?Q?Sz2lF52YKixhJi7WoO7sDm28H/f3waErLurWIsTLFavWdWL3aLdPQNR/2HvW?=
 =?us-ascii?Q?Ew=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95d00661-7e6e-47ff-7241-08da9e2c7e39
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 12:58:36.1977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JcJYPi4o5yUPpA7sNbK4jNatw7diWI/l8Ir2D7lc2ifzq53nAKhJtx4/F+jNqnwO5i4ldHCbtj6AE/UiZlrW3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5108
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-24_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209240098
X-Proofpoint-GUID: a3SxnpjW4u0gxHF1FP_iYuJeQPZmXfFh
X-Proofpoint-ORIG-GUID: a3SxnpjW4u0gxHF1FP_iYuJeQPZmXfFh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit d0c2204135a0cdbc607c94c481cf1ccb2f659aa7 upstream.

generic/522 (fsx) occasionally fails with a file corruption due to
an insert range operation. The primary characteristic of the
corruption is a misplaced insert range operation that differs from
the requested target offset. The reason for this behavior is a race
between the extent shift sequence of an insert range and a COW
writeback completion that causes a front merge with the first extent
in the shift.

The shift preparation function flushes and unmaps from the target
offset of the operation to the end of the file to ensure no
modifications can be made and page cache is invalidated before file
data is shifted. An insert range operation then splits the extent at
the target offset, if necessary, and begins to shift the start
offset of each extent starting from the end of the file to the start
offset. The shift sequence operates at extent level and so depends
on the preparation sequence to guarantee no changes can be made to
the target range during the shift. If the block immediately prior to
the target offset was dirty and shared, however, it can undergo
writeback and move from the COW fork to the data fork at any point
during the shift. If the block is contiguous with the block at the
start offset of the insert range, it can front merge and alter the
start offset of the extent. Once the shift sequence reaches the
target offset, it shifts based on the latest start offset and
silently changes the target offset of the operation and corrupts the
file.

To address this problem, update the shift preparation code to
stabilize the start boundary along with the full range of the
insert. Also update the existing corruption check to fail if any
extent is shifted with a start offset behind the target offset of
the insert range. This prevents insert from racing with COW
writeback completion and fails loudly in the event of an unexpected
extent shift.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |  2 +-
 fs/xfs/xfs_bmap_util.c   | 12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e7fa611887ad..8d035842fe51 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5876,7 +5876,7 @@ xfs_bmap_insert_extents(
 	XFS_WANT_CORRUPTED_GOTO(mp, !isnullstartblock(got.br_startblock),
 				del_cursor);
 
-	if (stop_fsb >= got.br_startoff + got.br_blockcount) {
+	if (stop_fsb > got.br_startoff) {
 		ASSERT(0);
 		error = -EFSCORRUPTED;
 		goto del_cursor;
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index d6d78e127625..113bed28bc31 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1167,6 +1167,7 @@ xfs_prepare_shift(
 	struct xfs_inode	*ip,
 	loff_t			offset)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	int			error;
 
 	/*
@@ -1179,6 +1180,17 @@ xfs_prepare_shift(
 			return error;
 	}
 
+	/*
+	 * Shift operations must stabilize the start block offset boundary along
+	 * with the full range of the operation. If we don't, a COW writeback
+	 * completion could race with an insert, front merge with the start
+	 * extent (after split) during the shift and corrupt the file. Start
+	 * with the block just prior to the start to stabilize the boundary.
+	 */
+	offset = round_down(offset, 1 << mp->m_sb.sb_blocklog);
+	if (offset)
+		offset -= (1 << mp->m_sb.sb_blocklog);
+
 	/*
 	 * Writeback and invalidate cache for the remainder of the file as we're
 	 * about to shift down every extent from offset to EOF.
-- 
2.35.1

