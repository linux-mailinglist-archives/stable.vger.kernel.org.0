Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E2B60DB43
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbiJZGbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiJZGbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:31:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515158E9AE;
        Tue, 25 Oct 2022 23:31:12 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nMHn016341;
        Wed, 26 Oct 2022 06:31:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=RcI50StIy12ptR4TMHlLnsR5ebHI2rMtvAANXH5BVw4=;
 b=aqiHvR0SnBorCMyMPSJkbuRiKdj6lTc015a15cIU3J+PZOx4NrRgK11vUgIaSoqfWmW4
 r5yClZG++53LZEd4stSY37UtBt1MZlcusLr6pYDi5zOZlW5r4HbCSVrTbLY3A2nQHjnj
 UcA00p54MXSK7sCN46ex2S00POLs2JtBFtgZ5qMtsOQzb4gWyvIdUeiUvvs0JLc2GiAl
 GdUemhSn7uP/4cNpoz/8Ca7tikclNUgLZz0qzMfEZ2IXiR0/2jqrF91vY3Y12Y/EnFbv
 25NQ2OF3hI4ibOfstmnZl0YryFNP6xkUDlkSPDEMjW4vRb/2Xh3rpnhMi9VgAvNqMCdX 3w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc6xe4u3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:31:06 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q35aT2011247;
        Wed, 26 Oct 2022 06:31:06 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y5d9su-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:31:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EWAUuGVJdW9JIcOfmvCMOMNM+TgpJoNuKGyjaNv8/BnK9hMJLeiI7zg8bbLkLWu8H9xbQ1XsSl6chU+XYxmVL4uhEGvbjebL0ojaui7tJ9Qa4O+qRID9VEMBw+fxZeytgHRrd0JujNGLDxkxlRsj0vl8LbKTNk3j/AbLpbzB3IhKIYPMbs2pkjTFucMvENLtNbLuPAoK1qNS2CqBBb/ra1OUDKQZz87JXCVzS1108gYtmPfGsoIBmilmbu7qK3PR8cIN/v5BbBDtc2hs855BJJVXo7vbkSvGWWHsArR8g+kKpaEXYdZHZj6YaCsezkisB3fu6aML0fBeAhhQ003d4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RcI50StIy12ptR4TMHlLnsR5ebHI2rMtvAANXH5BVw4=;
 b=kTAtFvsut+iEMC1rrE1Up1kC7hEwzU7DNfY+BMvaF28cuYTYU3HUsAv7UzhpTRW3I8ror5JhixeXYoaEbipt6/2fQW/2nBKTLWkSwiHVDfOLfn3boemn8V0S62naNWeP8SASnzKkqeKQ0FdaQviQs6qT32l0xNlaXz5J+6jJ0JHhfyrcgRA20Lk85tRfXe4m1bMH8Ex341aapezwW82A8lei4U5D/IwyeG7aMksGDV9IHU3UAq1wcdFW3B3gzuVvLlOVAoZCDsG1bPIDk+JWpjMXyFmchEZlkfTdr5bvQIpwCdyV7dS7W/Hh/+8JVYCRVoL5OJuRKkfwazsgYOH9LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RcI50StIy12ptR4TMHlLnsR5ebHI2rMtvAANXH5BVw4=;
 b=KZjVn91WKIyn0djRYQFyLxyWlHSht5HWoZePx1g2dl0AGodW5vnjPya3hj/zK5OF72OmBizfhIhgVL8VWQ9lKbFIh8WyYqQCo1+ALPThCTpwp6X1jeGhsel8D0U/Wi2HblsDYdcQeUsnm7u9T2aqZJJkJqXrOn9XTfffSe7rED0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4646.namprd10.prod.outlook.com (2603:10b6:510:38::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Wed, 26 Oct
 2022 06:31:03 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:31:03 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 21/26] xfs: don't write a corrupt unmount record to force summary counter recalc
Date:   Wed, 26 Oct 2022 11:58:38 +0530
Message-Id: <20221026062843.927600-22-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::12) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4646:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ee9222c-30a9-47d6-b76b-08dab71ba7f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JQZo81oSkdgMAocxVy3plRz6FHJNyIi5xLC6Nr7djoz04mJw/7ZyacBzYvIq4edvnixcUOvmf4wpBn+Ks1C4tSsAnp0auAaia8O64in0QtSoc8NMs/3l/k2yC78s8Zx7LP+j8qQJCHCdAz3l1BvZ9T9t1yhX/UM71aQLc1E5q5K078O07eTHUlIQMCuaNerga4Nl17D1OnQ5jq28BveuSOwA9h+Fdt1PJ11J4iHwckLbP6zuIBwlaUI3I/PTe9ZBOWhQANN0m01fkl5urO0Wn+46xnuVZ54TrzoBAf+mEPSA8lHsVH5zQNRf1OCVmaXcMPnMSbtlG8pc6cTOPZ8k/3yMBtZdsLxVIJ+CoPp5noDYXN6rIoZQ0j+9rPdC2xxA9rlGJl7L3Ng/FbP9NRyrvIQlH28coIyw89eX2F+J2ictBLS6yL/2QaBwwRdHHHBjArLqOqb5TrFjbJhBDvXvfz0htFPzjvKcvwBSxyxTSQCLR5yZRSQdB6w6lI+GgiioTd+vA64kWlKvgOdzRRR6Fd8guz5laeyOU9zjouGu/kJz+Tg2uO4PODb2I2gbtwpYYC6huQVApFvCkH3G6Mt+fKMRo+QXxUGT+YHJ1Bj3pPG9rU0szdiZccdAmRIocgHHRbeN+nHUAWT7zXL9LNmEzsG8GTosCRn7RS3rPXjJqUrGK7KojfobGNE3PYqLYWZdaJxXO22wC88oRYmNnTgfbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199015)(478600001)(38100700002)(83380400001)(6486002)(66556008)(6916009)(1076003)(6666004)(8676002)(36756003)(4326008)(66476007)(186003)(6506007)(8936002)(26005)(66946007)(41300700001)(316002)(2906002)(86362001)(6512007)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3yFS0ykXgT6Q/sy7VNzTDLKn//+hkk/zeFI68FgF6Ttma3H7yP+MNMmZfRoU?=
 =?us-ascii?Q?LFMNn2H1ke2mRRvAT1k3BD35RJ6Gexa+56xy6cJdvDlflDf1FkCFtr72lAqZ?=
 =?us-ascii?Q?lClWkJdIl2c0ZR08Cn8KVzbyWAZQ0klK1AoxzrCFCkJ0wTQpRPJK/vmr7Vfb?=
 =?us-ascii?Q?Qq5AHnr2sRoRK0XGz0hLIRze0xXE0dd5Xn9eIK5YR5lVFm/TWVsVKJUclPqL?=
 =?us-ascii?Q?4oCGhnsW4ifR98GpJT+URZfk2I1hJQY3xQUsX6oemeBHMazrJf1+/RgExQB0?=
 =?us-ascii?Q?vAwRdt8AKBckgpdUla/m18Nm4gO6nCxJ1+wIz2d1Ssbb4xgG6ov053dNFlif?=
 =?us-ascii?Q?aK49tdO7StU5OLbpTyhjcjgZyQVIhNE7rzisXWq9i6iZ0PROVpmy987+RDCk?=
 =?us-ascii?Q?LsjYBpvONOsPVACe1grBc68Z0z2gImBiywqy0uPl54XSICiHbSrcFTOF9+mf?=
 =?us-ascii?Q?K6AtMCD928PcM8hcF5lD5nNy0bKbMox9XaeMokMDzmifV9Ys0kSZJNtXspd1?=
 =?us-ascii?Q?hIVw1dz5zGISAC3Fk9pNXTRI265mSi/I9VCQUBCRSPTLx9mQHGdG/+gBnnlU?=
 =?us-ascii?Q?XFRWd5W5xa3mb3EvmOQlaJfGzi9m7tDzEK3Bb+eQOpHgbwNfASc/P01QEj0n?=
 =?us-ascii?Q?vDV4MZuzuv0XJZ0DaWHXEgOvc9D/QCCiYZwrLeYx5HNa2xSl8SX61aPY7E9Z?=
 =?us-ascii?Q?VT2cjgjjGXqS1o/F54CVOFLIN8Bq/0SEt5RHmL3UXLXd4ho+iyMeVZrhOaEA?=
 =?us-ascii?Q?TGyGnn/mJKbhWzqrOhqC/84Sdgo4/6DinCUOtTvY8PC4frdwnbRsi7CJwvKo?=
 =?us-ascii?Q?42Y4wTkPcMJnp/J/xBLx28r7xVArB7SklsiTa6DHZYa8ElLZvIn7d4NPKEub?=
 =?us-ascii?Q?FSK+djHpvD75fqRTQ+nza00P6VYAlPB/vyRXJ1Wg+TnyysKgJ3b1n7YsLTTI?=
 =?us-ascii?Q?+MNj5YtP3vbehN8av/3ithRybmtqE2ns4qGGBQJzw4VzVAav6bkTCdFUIxTp?=
 =?us-ascii?Q?M5/d8SsG9YS/9HII1Gv2tiFpZwFzOzlitb0vn/9jQoAghmF2xJR0abiqVFa4?=
 =?us-ascii?Q?1UsakVeyJuAkQGH3U1cR/eySjE2b1Mc1q3fS6OtmRHUhTeCe3CuVwrMQpMrG?=
 =?us-ascii?Q?V/ooTBV+FoEIAUWcQVMnJxKKV+MH1POVjwjFTOvXXk49WhLEQhz1+keov+tS?=
 =?us-ascii?Q?aPIep0qTq+RURcbV6J3cSTiTCe946QYmqZdSTXyxxmtYqNVpPBE57EM/8827?=
 =?us-ascii?Q?r//sFYbgHvzHm+75w3hIOzOK9sGh2dPojp8XOHTjKZi3QiJetgBhnD5voSGK?=
 =?us-ascii?Q?UcwkYozEaxMY/E3WzosSEmLlx5gkvHecTQhxegWzgfRIkLlDSBMlMFWFv8Vq?=
 =?us-ascii?Q?lPGJ5ySDDOtsI5YvFkl31pk5N63Rlb3R+Tp64Wi5smTOSXbM6HV1M2rEXbYH?=
 =?us-ascii?Q?CFIdcXI7kNB4mq+AdtZqDAmCRpVWkvJKrDVEDHcOe4/P4UAA9i8DoDUP/IEs?=
 =?us-ascii?Q?4bb9rHIl1VFoKRM0TECEq5IsLc40NqbRxCe9+7uZPDW5RXDy492p7I3lunyS?=
 =?us-ascii?Q?Bk9aL5+vQIkIhwvh6gaW+Db7w1k8Vx/0Pk67w1bDO21/PhwG0QNsUL+9Hx6g?=
 =?us-ascii?Q?2w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ee9222c-30a9-47d6-b76b-08dab71ba7f7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:31:03.7312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gi+GRCEnO9t68LX7yYJydeEv1MrewaVpfM9IJJTLELDHGbq7dbjRSuTPIYOuWxmnS+xnGJRd3a8yK56nPvbWKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4646
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-GUID: B7DBvdqfmxRruNVxTQ6rMPGCrLUEfCac
X-Proofpoint-ORIG-GUID: B7DBvdqfmxRruNVxTQ6rMPGCrLUEfCac
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

commit 5cc3c006eb45524860c4d1dd4dd7ad4a506bf3f5 upstream.

[ Modify fs/xfs/xfs_log.c to include the changes at locations suitable for
  5.4-lts kernel ]

In commit f467cad95f5e3, I added the ability to force a recalculation of
the filesystem summary counters if they seemed incorrect.  This was done
(not entirely correctly) by tweaking the log code to write an unmount
record without the UMOUNT_TRANS flag set.  At next mount, the log
recovery code will fail to find the unmount record and go into recovery,
which triggers the recalculation.

What actually gets written to the log is what ought to be an unmount
record, but without any flags set to indicate what kind of record it
actually is.  This worked to trigger the recalculation, but we shouldn't
write bogus log records when we could simply write nothing.

Fixes: f467cad95f5e3 ("xfs: force summary counter recalc at next mount")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7b0d9ad8cb1a..63c0f1e9d101 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -837,19 +837,6 @@ xfs_log_write_unmount_record(
 	if (error)
 		goto out_err;
 
-	/*
-	 * If we think the summary counters are bad, clear the unmount header
-	 * flag in the unmount record so that the summary counters will be
-	 * recalculated during log recovery at next mount.  Refer to
-	 * xlog_check_unmount_rec for more details.
-	 */
-	if (XFS_TEST_ERROR(xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS), mp,
-			XFS_ERRTAG_FORCE_SUMMARY_RECALC)) {
-		xfs_alert(mp, "%s: will fix summary counters at next mount",
-				__func__);
-		flags &= ~XLOG_UNMOUNT_TRANS;
-	}
-
 	/* remove inited flag, and account for space used */
 	tic->t_flags = 0;
 	tic->t_curr_res -= sizeof(magic);
@@ -932,6 +919,19 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 	} while (iclog != first_iclog);
 #endif
 	if (! (XLOG_FORCED_SHUTDOWN(log))) {
+		/*
+		 * If we think the summary counters are bad, avoid writing the
+		 * unmount record to force log recovery at next mount, after
+		 * which the summary counters will be recalculated.  Refer to
+		 * xlog_check_unmount_rec for more details.
+		 */
+		if (XFS_TEST_ERROR(xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS),
+				mp, XFS_ERRTAG_FORCE_SUMMARY_RECALC)) {
+			xfs_alert(mp,
+				"%s: will fix summary counters at next mount",
+				__func__);
+			return 0;
+		}
 		xfs_log_write_unmount_record(mp);
 	} else {
 		/*
-- 
2.35.1

