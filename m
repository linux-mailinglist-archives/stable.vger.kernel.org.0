Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37A4501E58
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347056AbiDNWcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347054AbiDNWcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:32:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DA083B17;
        Thu, 14 Apr 2022 15:29:54 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EKkvFt006846;
        Thu, 14 Apr 2022 22:29:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=PTEA+N1XhqybQyFM2JLWgGwf4Cn2MWL8Z3+i5Yv4H5Y=;
 b=kIMON+/UugBMBphgx5PlvtZHm9X2SdnG7viiYx/vGwWjLL1mfUeMUppsyPpXHtZvv4ib
 LbL7uCvnPjlwWzWPQhU7Bu7s4uIBOv1ovSg+/MI+7NAIOkAjnRmCD3C47Vkwq7/qCwh4
 U/6Bag3WncfSttZ253XjeSYXiL0EqMqfF3pqS+JN4FaDR/rD60mCDRR8O0Bxmr3Fphax
 E15V0PNtXpQF1o18vfJKHiRJintII6/ZMBAW5r1lYKnwI1GFq1c9u1hPZoUFVZqouVgF
 E13H2igAuACrseOCo4bWm076jFBtFdDN3auY6cQNTf0SNfNwAUs6DoYQkYtK3tskw60a 9w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb1rse6w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:29:51 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23EMGhsX008736;
        Thu, 14 Apr 2022 22:29:50 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fcg9m6k17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:29:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jiz0OO8IAVtwKEw5qamLf5bVD4bMtRazN4tX604JKFv8Etloc6yl41Ch0hLf39R52Dgkl1TkP6om2RVJq9gtYl5+N8ZnecnU9rx1imtoP9GtJ4MuJOShpLdpiUWqMhD0lUNqC4AIJhsy3xqFtjW2XPqwBB3GE1edPLDOQk8rkaUVaCMPwwXIssXcKquYA066GqBx1aBChLl/H3MnpTujZwlpsU5JIQ3GUXCueB5TcW5yJvVyRrqviihhbLZtkGGBReiGl8bZmbr6PjcCRy1iHGYXmUmm405rKiYJTcuOyGIukGgb987FFEGhl3PORWgcKzV6kMUO8jsWR9N2ZxZcHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PTEA+N1XhqybQyFM2JLWgGwf4Cn2MWL8Z3+i5Yv4H5Y=;
 b=dW/FBQ1PgVt2f8CT3oEDUyW//pNfk7l38d5ZIUmVuhVDWGwRy0sQcH7DCXTshIsfJbeCpceIMh6B2rP4cQIPbxKNt6KFmt2rC7isQhLrcOJEmdj1alBfT/me+JhyVHDudhQZrAr1nFeXyU7O0egM6nsWOk/ryHoUqtjVUcDJgOpbcE406CZLuytmGXx5HDVYCzpAMijoubyS7WO0Rr6USeh6GSutoezJLbKt8Wru0dRy8qtXoA3VQ9yasgxw629IQkWu4QEJxJGpUz8exIlr/kqiPSvDwGdozO+TI6ZbqhdXoj/oR2z0qW0+2RFffcDawt21J29O6EI5XVJ4l3FHGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTEA+N1XhqybQyFM2JLWgGwf4Cn2MWL8Z3+i5Yv4H5Y=;
 b=jRPUM44LVGmltHwcYvHklRZR8EjuJBDlW0Fz63Bf8bD0tpfBnMsPkD9wgWpxYc7TbSvYlfSEeL435Cco+FgILYHGrJtfaqn1JetLxD4kBh/k56IFW66LyqhEquDRqBqpFeP9tE9ts45MElkuehpLAj//QP2kA2yCWk1r+sLKAto=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by MWHPR1001MB2094.namprd10.prod.outlook.com (2603:10b6:301:2b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 22:29:48 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:29:48 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v3 07/18 stable-5.15.y] gfs2: Move the inode glock locking to gfs2_file_buffered_write
Date:   Fri, 15 Apr 2022 06:28:45 +0800
Message-Id: <cc3db66fcbea7329e3cc7246cd329b719f76f323.1649951733.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649951733.git.anand.jain@oracle.com>
References: <cover.1649951733.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0016.apcprd06.prod.outlook.com
 (2603:1096:404:42::28) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32fb5859-eb7e-4da8-524f-08da1e6648c8
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2094:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2094457CE183E44977DA4BCAE5EF9@MWHPR1001MB2094.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1/P9wjviQni1HheWXWm3SkDiFRmLV0S2TLAWoKD22HzyEl/CSLJE8dv6c4VivZwQxUle8RVtda3gblC83dFchUT6DoRw34ICcWrwAmm2oFYZeMxP6Zkyq0EVwd9Jt9nStmiyehgLmjk1378ays8Eevw+Yv8WaWqsXzmLZ7VYadi/Ak1/hBrpNzi/5ub8x8NiPQS9JhHWwmdOdkKvpWQ9MM58QJWQASawSHT4uGb2RgUkzPRZwbN+kUJU5AlSX5fHXMgibpCEv9HHQQk/Ho/mENxsjQB1kKmqGiW8TV/o61fBaK7p0D5ibfliba+aK2tOpmf9fYvPn+92aT1bOJrHdgceccryIdzkWQZ4rLBZV5PGEgOxeeKsMiuuA5AxVyMM1QweuEIPfxJqAydqP0ts0FxR7Nb6BsheVO4gWkeYwB/I10We6ghsT+EpVGrSvJCfEFc2C4KApFkwS/KjL77Vdmf13HyzE4fdFOI9VDb2bPYHQLD9hFDbLcWgXFcR3UjTNKWL4TECP7vFzCJec+W2sbo/EMDTaDI/glquyAEzgunNKMjms5QJchJg5gRYRiedW19bUnEgGKXUFOY5oi7dhYUjNhNwbKRx3JokM1ebN1LgzmRMM2iD8W7qF016hHclyr6PKRBuX2rNoZTsJ3OK0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6486002)(2906002)(86362001)(44832011)(508600001)(6666004)(6506007)(6512007)(5660300002)(8936002)(54906003)(316002)(186003)(6916009)(66476007)(83380400001)(66946007)(66556008)(4326008)(38100700002)(2616005)(107886003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jtfcRVsSyHilX3BWGRFjxvFD7EaNE2mdz8rl67Ol04LQLh+1rv0lCi+0+BF7?=
 =?us-ascii?Q?9UAnUFZo9hOoEky7UCM1D63jkPPOuZFNhe2T+oEuw3FETOlWOtqOfDwEjw9y?=
 =?us-ascii?Q?G/rcaGqTWRNyWmUOB5Y83FXDkRTgeVGi1w6VDf/gZfQFAktCw76lE0oRageV?=
 =?us-ascii?Q?3Q9mhLSIKBJJSuw9DtpJqjmfkPxoSN0bE7iMdGO7s6zB9Z7wFIDKnCIJM9Q/?=
 =?us-ascii?Q?MGBoaMxPUTgdtdyiy/Y5ie7WFyTf8FvDzk3Uy9SQW/0RSIRJ/Q1rEMgimj6n?=
 =?us-ascii?Q?BCGzJDQW/CUDQhxvfa+9qISsWCtaZqEvywmcQMl0CtPW8bhAa58Py4ArI5k6?=
 =?us-ascii?Q?a9jkalagoSSnohOQ4QYRhrlj7Ar/X6ix1xi6ppNovUol1Kl4SSJhaURn40k8?=
 =?us-ascii?Q?SNesrbVCdzE/t01++A5wPGjmqR+xr5kxcHJIp4Y86qDiQwKUCAOp17sO/IQH?=
 =?us-ascii?Q?Bt+X6sZUTBx1r77SBZ5M0qnMdaTUlkaA1SJKivRcPraJtsqY5T1abOaGMKG2?=
 =?us-ascii?Q?Gheb7aFEmz/n0q5TUhWjSGbZOEi91C9D7hhGj5gIpPPrbkjjhAVXUbFeT4cM?=
 =?us-ascii?Q?L9r/aeJY4mc99JuPGENfDcDHwANK3NYTs6M9lBliMkxxseuuk/YNFqlmQdKd?=
 =?us-ascii?Q?AG4y8eH2Kja5wmD2z2Po8Ifw9oVis6c923gNhmqO1b9D/6Mc2cbbuzb5VPi+?=
 =?us-ascii?Q?NOgO/Q8Vi1qWHpvZzeU9GpjwkQEr8OIOzxt7PUzTqDbyMQGe6YvtKRRo+SO5?=
 =?us-ascii?Q?UyvxyXlplVe4yfqZTnfqUW2ZNfU60b0PSmgegAVCj/voeZ8DhT6Jh8Ny/lo2?=
 =?us-ascii?Q?HnbMej/zTGE0OjuFq2VidsoSpA8kqHsAdn3sMTwH1VcniFjtRXyMdeJhxykU?=
 =?us-ascii?Q?6lmDU9QZoKkecPxIB6t/uqqWJeORyl6kmjSGZMURFYfP1v6tL7NhmG8lQTH/?=
 =?us-ascii?Q?+VzmDWKh0NFpri4FIDngnuRw/VzYpCEXsajRhjZn+b+xTG+fMNc9kTT3V1FF?=
 =?us-ascii?Q?bSHCIy6WpcUdxDTf6drVXmwASYzpjbdOhBzEznDctXokp+PHB1ez6EoGsl3K?=
 =?us-ascii?Q?Pfmfwl8S3Dq4JunJdknyxOM9i0LThYASfNZqMW1bFwKifq4//H2Mnw2BGSVu?=
 =?us-ascii?Q?ZPMMjq5G8HDBqgKMo35I8SFI5xCxwu1AJHLX1qCRhsLWJGZ3q8iWruXBSVRT?=
 =?us-ascii?Q?fy3keyeCFVkCBpLDnyfDAiD4VDrp99GOkvAVpPPlKFYAO1vK8KJJMQAGkxWZ?=
 =?us-ascii?Q?XK3JV5zEM2P66BibvJD/7iv0rKiXXFv6agPgHeXHB98FjzRAKBpwYqYdCvUE?=
 =?us-ascii?Q?XHQdvB3VBXYVLjGM6K2oUhY970LAaJ1cGPnO5aoSCKptzI6uBa2PHL7W4Aly?=
 =?us-ascii?Q?u4UArSyR2PbtXvjAQsr4H47F4UhFei7AkmTXH0Be2HmjKsxLWoGzaUafw5Gt?=
 =?us-ascii?Q?3bW01guBTp7blAi4vIQz2JQMq+g8lstk6AzgEE+PUeCK63eD5LMDHsOeZ25T?=
 =?us-ascii?Q?hTqC7DFpgnTlla30X+loytSpa0Li3G8+hiK6XEnVfi0puH0CnnqE+TOOdu8N?=
 =?us-ascii?Q?aqhi9Pntwf7ypheku4vfu4EAHmN3Y9JuDNk9AjqVe9UVrdzfS46+oSwO4Ubz?=
 =?us-ascii?Q?nPbwLpmrWC/4OCqCYCMspjdm8p4qQB03mGWyYOuN8z6BE23MRNhr8RMIsaNT?=
 =?us-ascii?Q?RGglcbzlg1bDJodAwSAjco4oFk8pIOIV7e01tWFip55d9Fqxv5UiplCt2lyK?=
 =?us-ascii?Q?VWhQcHsWtOicXazgKL4jAVC8seZ1q6FdG9HaxMIbDIQsuomTZwP8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32fb5859-eb7e-4da8-524f-08da1e6648c8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 22:29:48.4181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7avWeaVMdCV+TOt8n+3IlOLg4MFTsv6CdJ+AZUkk8CVSdPAPhcWV3ijTBmyZfm2WONLTUYkLsKx7/83pBSgnaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2094
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_07:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140116
X-Proofpoint-ORIG-GUID: GPc-RXWypI1_XgELGNO7hkC4S45wAHt0
X-Proofpoint-GUID: GPc-RXWypI1_XgELGNO7hkC4S45wAHt0
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
index bb9014ced702..fbdb7a30470a 100644
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
index df5504214dd4..f652688716aa 100644
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

