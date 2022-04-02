Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456814F008C
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 12:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354302AbiDBK3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 06:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354294AbiDBK3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 06:29:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE231AA056;
        Sat,  2 Apr 2022 03:27:08 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2321VUoZ016265;
        Sat, 2 Apr 2022 10:27:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=SavcZTed/RFOwJyi4RItXOumP0hW4Wdy7lHhn0nWLu4=;
 b=sp76TvETCri8cOm8RbjP6JQEZ6ccetXYbjrnJCwN5ufAIuDqHqalC2O4jh+QivkY7Lv6
 KbpAW0hr7wY5kTuR0QWg8hutrMZKr2gWyGOB9rnc7VrkxptaYK0UFPh2o/lRu/R959bC
 EZXOVkVgM8KW8EKVSDBxkUHTzANRkWL5gneECckzBX0xZqoLYWG+VD6hshjrHJnY+Chj
 jglddrB8jWly/j0Bf47/0qNw4WB5rmgFJQ5Sb2OEXJkm8+2wk7u3GZRGZweE9SR5boyp
 4SCRssTn9tV4PAA/3AN4cv/XgVaS+1SwpMH/UhguB/kKGpy2zL+xzWZPMnKU0aGh2PGy WQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6cwc8cpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:27:06 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 232ALqIT024522;
        Sat, 2 Apr 2022 10:27:05 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx0xce6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:27:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4LSgO20j92sObvGZQGJOZ89fOII6DMQnfnha7Mxmcrx2LmF+CnxtnxVv0tqKVC/yqz7+54FVa3WlwuWbDYJP1shh9rGAR48gKsRqN+D5FL7p0HQRGf9FDnDjU+NACopOuyZyWy0HjfTd+uGWEWmaxrZSZkDInvKSZJtqdeV4g9jpQ9B/OiiE41DVjvXAjtsoi/aVO9LyHcFaKhv1UftM7vQyUmx636qFdUbIXHntCbr1YVPfjqmyIWlg3tWf84bxjrhAHOLmEFSSJzEUGPsLllKv3hNf9x5s3JqDPqwgmAOCOo/Rtu7pnhDdC4xdyNeaQ8iktyYW3yunSf2NFKrRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SavcZTed/RFOwJyi4RItXOumP0hW4Wdy7lHhn0nWLu4=;
 b=nQUucVDBFU6DhWUJZcl02P7caGX1IkD8DmVHtyZbJ5jdA1WxwJHKNvGxL/gIcni2KVgrJEZjfh/93mFay9BEiGC7JBKyJrGy6iytyJo9MlyTa4I86OLSErV710jtXlKqqmKdj08oEpLiLBP0vly7HDQEJO12dNeDe0zPL7RUlTYc4Aa2e0kcemZNGiAjy3CH3GH+o/MnvX4uwXx1orHC6QtMBrSK8vcHZqX1mUhkhMM6jSEwTQsIYgVw6VtzJkxaamQWtmjlH4NIwyrwlwQA5mbbffpmAeyaiOXOSnp2J98rYSUkxpnDgRyiHNV5OOXGQx+cpyn8zIP4sYrKvkX77A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SavcZTed/RFOwJyi4RItXOumP0hW4Wdy7lHhn0nWLu4=;
 b=Pi2+NN1XEwKalk7pMNSDdqpjK30zNrWvYcXDFWifxT6Qt9IL3E35W9JKLORanrGQX/tC24qeDZSq5QRoM6mBTxzXCD8VeqN1yWGPdVE//j4dpjcZ9FoGzDy7TWfAL1UdQEsw9bJUJj/n/vH10ACq/0soPUwFqdJFweEaLU0JkTA=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM6PR10MB3049.namprd10.prod.outlook.com (2603:10b6:5:6f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Sat, 2 Apr
 2022 10:27:03 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%6]) with mapi id 15.20.5123.016; Sat, 2 Apr 2022
 10:27:03 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 07/17 stable-5.15.y] gfs2: Move the inode glock locking to gfs2_file_buffered_write
Date:   Sat,  2 Apr 2022 18:25:44 +0800
Message-Id: <2cf03f199f93aed16a4d79bdc46c60a1e7e75c6d.1648636044.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1648636044.git.anand.jain@oracle.com>
References: <cover.1648636044.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0100.apcprd02.prod.outlook.com
 (2603:1096:4:92::16) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e95d435a-3fcd-4e97-0fae-08da14935443
X-MS-TrafficTypeDiagnostic: DM6PR10MB3049:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3049BA3D2386C3ABAB5A11EAE5E39@DM6PR10MB3049.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GjvgVwwgkV4/P9+Nff1qOsL5RG3phW5HbxU5s3BO7H2GkUDp2Jg73JajsG/VNLOr0vUXVxJGMYB+3uwYWcqDZ+APBA8Q39tho7hud4f7dh6oQzzM9TCVamk0qvB19qsiCpbJNRFjebm4stpTCxtcrduo/th4N6BENzwyVIDEkPjkY7kHGHiFTx4CvFycArf6CdNQiwaJzYbgSwwrvqv107pfgfJGUVYgcR/hhl/BCe9Upu59qc7C03CVDQKtYZ5Qq9dfIr0JRJdhwOwozW/3cuBuWXDojt9BNi/DtS+xpBvaAUqlfcFcocfSyE2kYZg5UVBDaVIEGiieI2kUTOtQ+faKY9sQcBZbs/d2/RxZCXEEY96rV9JZTVWwWJlSaSh3FYC8KMfWonKd9OF9Me6zvGLo8x/q47zo28DyKT1Upk7akEjsOYLjRaG1XQBaC5FbmS/aEWIuPVTax1V+IJqzDuU7EuOJ2XY3T16TL9jdiqi4q4G7ZiKGca1oFoj1F9F2XQgTINvJ7m4yonwt4aIl1iknWp8yMj7sur2KjI2z0pjQQ7rFD9zZ4U9AhvplppTRW88tFqVkcy1f6oN4eWWtFrltx6gkggIsJINdd+Pppo2QgUaROu0GvEJ1svJ0XaPyO0op93o/C8wTzRrkc4B7QA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(26005)(6486002)(66476007)(54906003)(6506007)(36756003)(6512007)(86362001)(5660300002)(66946007)(107886003)(66556008)(8676002)(2906002)(6916009)(2616005)(186003)(6666004)(4326008)(38100700002)(8936002)(316002)(508600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W4VeWdA8wFibgvn7Xp5RDTqDUw4oTMWHpm2pl7WfY+PfPefOnQBI55CVfORH?=
 =?us-ascii?Q?HECEIUVKmIE4pDoW9GSLia4HezAVC/TXQzZp+xv6in5+9yhaf8K4lAnFzKLe?=
 =?us-ascii?Q?0DXBWJmn3sk7y0DPdzTDf8tOeAfNQy3RA3r26hCSHL3xASuTX06Q/pBOfBm5?=
 =?us-ascii?Q?UaA7x7otiLRtNlFyW86QKw+pjqYbW1dBqWpCkx85ucTvBopuQZR3jiN3DSjy?=
 =?us-ascii?Q?XxiPzJx8SB7eHXAtX4quNa4yBcwKOp3d2Po80BJMwBr3HTAB/db70jSfY7gt?=
 =?us-ascii?Q?zFQaaSZkzj73A3FoieRjdjWKrrskvzINwt5KMPsD3aoU3vKZbMR3kwyQ9TET?=
 =?us-ascii?Q?46LN4EsYWvkW9v6sNvo3MIKE6FDNowC1yIr/DBrsHr4JZs5b1CY+MWWqxVUu?=
 =?us-ascii?Q?aIC9AFNtDQ5y/B+64vgpgQh6idZYa3IvqNTQ9gVVMQ3ERb+OZWbshy5951dg?=
 =?us-ascii?Q?m2/ZhqPwu+K5tNUX6B2VdtXRip37YeCbB3xpHykAXSc3+vmF/jJ9mJuyqqrM?=
 =?us-ascii?Q?Ug9iGlZ9+A6+/L2x+YT4UtxmA/I+CKNXL3CPcSvVsfDH1sm45RDy+QAD7OeR?=
 =?us-ascii?Q?gn35ZiCPSpYfdh4+gb8qDjNCHOkU/FNpDgRAxZutnSaTwfLi5Ro0Oc5BWIeR?=
 =?us-ascii?Q?ucOYDc08wgIQLkFvTxo7msx7+Q8FnaOK6pP/BYkX6/o//VYSaJ99YKIR/YQv?=
 =?us-ascii?Q?BKY79oJTkH6EligLYIFoFDpKGRNrHoCveh+t0sRHycJVq29ftX01drbgYyYM?=
 =?us-ascii?Q?BDbGtCdDDTHe4taSNxedTIUUcHVjpPx/tnZfqtRFGpWGHXOSDSdfP+cIhshE?=
 =?us-ascii?Q?kp4A1/I2bSPHTCQzz38hPq8WoWWRFBZMsM7/hYzfMnhJod9vjVtJUULwb7rx?=
 =?us-ascii?Q?kmuqnVJ+IxehP2Ajm9ARDOK2jNQaSZU/8j9/KMnctXyyDiQZij9e/aXevyvq?=
 =?us-ascii?Q?8IipRE1LDRv/WQlzaEei4lLvA+SxgE7Mt931lG/vC2sCxLkzyUH8hp3tvX1x?=
 =?us-ascii?Q?7EP8Hu0t19Coki/c30bQiNJrVce6Mw3AB4+31TS8yYRrqa7tX3zZYpRs/MrO?=
 =?us-ascii?Q?yWh5Df7GjJqs1BPOUf3OmF/n0PncVvBKSv65DK5V03k04FB4dh4ZIsciR6Q4?=
 =?us-ascii?Q?BUHQVo8PMYotB0Qrd/D0ib/UHuFpIOc9l3fBmbIDHOLqgukvk6Ir+bnU/ECG?=
 =?us-ascii?Q?VO3utjp4Gou/F3I5mSEHTzQGylPyMkFEzMYGgbtPHw6EQ7zWSj9O0lGdPyOt?=
 =?us-ascii?Q?KEawnXXk1jlfU3wCiyzzGhtbKm2P3jDduaqD94bbZ+G2NCzChQyUntdKYzs6?=
 =?us-ascii?Q?p3cwHBs4w1cYC6U+GDQk9+2g2EykxSVqUl9JZ0GtlJTus8mR5fgA2rF/jDxU?=
 =?us-ascii?Q?gbg358yBzX8frmtAi1fdziBnHSSEDg8y2hetD7PHvwVkxlnME4rc9MPQLmw4?=
 =?us-ascii?Q?ueUuHo9LNI1hjzV6IQKHpQzUKnDMFTdLa4lb/kyax4VzeEickow4/kNAaBT4?=
 =?us-ascii?Q?POAWCh+MzbPREtjelZIQkt8GugbVg/fZHA/+r1yH90E6zb4pnvssgu/SrJox?=
 =?us-ascii?Q?r/FWIn/aV4HUIyRwFDeTuiV7mgEKfwCXGW2zPcBI4ywxQOvHAL0ACFvgWSWn?=
 =?us-ascii?Q?6ywvmTBYGzVuZ4IfIe2cx1wQ9JM6UvuhBZCFegUwy2ghCoyGboURN0XbJraf?=
 =?us-ascii?Q?nuipyZeG1FUFdp8WCFLisO3YDBW9b9MIHFfBvsqiefqn5ngWU/Dhtbkkbk++?=
 =?us-ascii?Q?TcSLZQt20Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e95d435a-3fcd-4e97-0fae-08da14935443
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2022 10:27:03.3557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fsOEoig0SMU6/HtK66965FN5Q/f9GaXxMmoC1F55ZXF6nMoT43oh6EhPo3/dBViuV4HXhS0DHpx39HIzhVScDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3049
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-02_03:2022-03-30,2022-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204020064
X-Proofpoint-ORIG-GUID: aGKq2kZfnqUfRgIWEMb0bNLjw0Ika-Fj
X-Proofpoint-GUID: aGKq2kZfnqUfRgIWEMb0bNLjw0Ika-Fj
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit b924bdab7445946e2ed364a0e6e249d36f1f1158 upstream

So far, for buffered writes, we were taking the inode glock in
gfs2_iomap_begin and dropping it in gfs2_iomap_end with the intention of
not holding the inode glock while iomap_write_actor faults in user
pages.  It turns out that iomap_write_actor is called inside iomap_begin
... iomap_end, so the user pages were still faulted in while holding the
inode glock and the locking code in iomap_begin / iomap_end was
completely pointless.

Move the locking into gfs2_file_buffered_write instead.  We'll take care
of the potential deadlocks due to faulting in user pages while holding a
glock in a subsequent patch.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/gfs2/bmap.c | 60 +-------------------------------------------------
 fs/gfs2/file.c | 27 +++++++++++++++++++++++
 2 files changed, 28 insertions(+), 59 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index fba32141a651..d67108489148 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -961,46 +961,6 @@ static int __gfs2_iomap_get(struct inode *inode, loff_t pos, loff_t length,
 	goto out;
 }
 
-static int gfs2_write_lock(struct inode *inode)
-{
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	int error;
-
-	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &ip->i_gh);
-	error = gfs2_glock_nq(&ip->i_gh);
-	if (error)
-		goto out_uninit;
-	if (&ip->i_inode == sdp->sd_rindex) {
-		struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
-
-		error = gfs2_glock_nq_init(m_ip->i_gl, LM_ST_EXCLUSIVE,
-					   GL_NOCACHE, &m_ip->i_gh);
-		if (error)
-			goto out_unlock;
-	}
-	return 0;
-
-out_unlock:
-	gfs2_glock_dq(&ip->i_gh);
-out_uninit:
-	gfs2_holder_uninit(&ip->i_gh);
-	return error;
-}
-
-static void gfs2_write_unlock(struct inode *inode)
-{
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
-
-	if (&ip->i_inode == sdp->sd_rindex) {
-		struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
-
-		gfs2_glock_dq_uninit(&m_ip->i_gh);
-	}
-	gfs2_glock_dq_uninit(&ip->i_gh);
-}
-
 static int gfs2_iomap_page_prepare(struct inode *inode, loff_t pos,
 				   unsigned len)
 {
@@ -1118,11 +1078,6 @@ static int gfs2_iomap_begin_write(struct inode *inode, loff_t pos,
 	return ret;
 }
 
-static inline bool gfs2_iomap_need_write_lock(unsigned flags)
-{
-	return (flags & IOMAP_WRITE) && !(flags & IOMAP_DIRECT);
-}
-
 static int gfs2_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
 			    unsigned flags, struct iomap *iomap,
 			    struct iomap *srcmap)
@@ -1135,12 +1090,6 @@ static int gfs2_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
 		iomap->flags |= IOMAP_F_BUFFER_HEAD;
 
 	trace_gfs2_iomap_start(ip, pos, length, flags);
-	if (gfs2_iomap_need_write_lock(flags)) {
-		ret = gfs2_write_lock(inode);
-		if (ret)
-			goto out;
-	}
-
 	ret = __gfs2_iomap_get(inode, pos, length, flags, iomap, &mp);
 	if (ret)
 		goto out_unlock;
@@ -1168,10 +1117,7 @@ static int gfs2_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
 	ret = gfs2_iomap_begin_write(inode, pos, length, flags, iomap, &mp);
 
 out_unlock:
-	if (ret && gfs2_iomap_need_write_lock(flags))
-		gfs2_write_unlock(inode);
 	release_metapath(&mp);
-out:
 	trace_gfs2_iomap_end(ip, iomap, ret);
 	return ret;
 }
@@ -1219,15 +1165,11 @@ static int gfs2_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	}
 
 	if (unlikely(!written))
-		goto out_unlock;
+		return 0;
 
 	if (iomap->flags & IOMAP_F_SIZE_CHANGED)
 		mark_inode_dirty(inode);
 	set_bit(GLF_DIRTY, &ip->i_gl->gl_flags);
-
-out_unlock:
-	if (gfs2_iomap_need_write_lock(flags))
-		gfs2_write_unlock(inode);
 	return 0;
 }
 
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 51c83d85a5a5..59442e35fcf3 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -881,13 +881,40 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb, struct iov_iter *fro
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	ssize_t ret;
 
+	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &ip->i_gh);
+	ret = gfs2_glock_nq(&ip->i_gh);
+	if (ret)
+		goto out_uninit;
+
+	if (inode == sdp->sd_rindex) {
+		struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
+
+		ret = gfs2_glock_nq_init(m_ip->i_gl, LM_ST_EXCLUSIVE,
+					 GL_NOCACHE, &m_ip->i_gh);
+		if (ret)
+			goto out_unlock;
+	}
+
 	current->backing_dev_info = inode_to_bdi(inode);
 	ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
 	current->backing_dev_info = NULL;
 	if (ret > 0)
 		iocb->ki_pos += ret;
+
+	if (inode == sdp->sd_rindex) {
+		struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
+
+		gfs2_glock_dq_uninit(&m_ip->i_gh);
+	}
+
+out_unlock:
+	gfs2_glock_dq(&ip->i_gh);
+out_uninit:
+	gfs2_holder_uninit(&ip->i_gh);
 	return ret;
 }
 
-- 
2.33.1

