Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB876DEA77
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjDLE3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDLE3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:29:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CA75272;
        Tue, 11 Apr 2023 21:29:03 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLFOv5023160;
        Wed, 12 Apr 2023 04:29:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=A7alFF2p0WCmWAguIdk8p3HehsedTit5NcooSGQ/hL0=;
 b=q3Znk1L6LOrZgNEKA3BAqZlws3DTrH2v+KZQ1Z4hsN2RTyb86jtRjz/KC/16KPYoWOZU
 swXVgRb9IGMF5zLA9de2UkK/Edq5ZDK+Ts4zvcBdWNxylq47lYJiSomB0xeHIJHneNMU
 b5MogIYdeJgT23M+DWknh6jQ5z/YEXzPMdkviTuAN3pj/q2FcjhcPcl8msmXPg7IcjIx
 O1oGBzGd7GvzsklTmIw1pcRE8J0SgY8hVnaRXs3Fo1j+NekJCdxmGxu/jtW27rcw2O46
 f6Do5tesvLpKAGE7rNId8QgvWxGFh3NO98buNUHjJkl/hVSOW95UgVy+ZUyJTuTgk34g sw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0eq72ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:28:59 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C31DbK012879;
        Wed, 12 Apr 2023 04:28:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwdq0pmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:28:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OD23jwlYzSt90X5f3RmMftkbKnrzscGH72S+/S2DPW6iMhdDNHBIyNswOlgCLz9aTWOdV39VWd4RpdVgU2bep8lJWlNo0ZbP+Pk7y+/cx0mvbY1lqDC3OSYF4FDZR/4HelEn8mRYczhc4Yy3HW5s2Chkkn3FN02wnokYLZwY8WMiwvd1SBbcMtSlzJOVwPTqPsdyn8uwSPqeZ3nwk2sM5+5nHNKZtUDB00w8hsQuH32Ux4MP7mCRyJpSdbaV8A80qOvHRBX/bWrtbdaUOgC7eHv/NhFfnsg8YtVdnc7mmV0qFkOHy3HsRCXwXeOr+/vrDAqMqO5U9qw8Xu+hW+KWEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A7alFF2p0WCmWAguIdk8p3HehsedTit5NcooSGQ/hL0=;
 b=RuCZ6fcu/IWs3tBUZL8YkHSQEy9W/n4baopULCPMD8RmAKXjto4Ybp8se3BNGdlJ2uwf4syrgNktAu9Wh9Mk0voBgN9GSxZGDixpgJtk0CljVUHPhn1JSiDJAxHxebvuGI+rY+ayR8S0/qN+vx+WJzg6l0tGsfEdruYZrZUAujslKb/yeqQjlr1tIaO1E23sJ0C+NQCTl4qmoDJ6y95eT1OGD7EToi6xa56po2eZnbXh9OEqnEte2xynPLt/TyR6UrLk5s+9oMu6ODspvQ/eRqCVYFYwpJVyMRx1YSS7kBZ2qOztuVq82M1PLctKel6NcfO/+lPUiICQlU8qfJeUHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7alFF2p0WCmWAguIdk8p3HehsedTit5NcooSGQ/hL0=;
 b=vvEfLxd6t4tyxhtDewK4uCv4ubM9EpSyQ9pWLNMiN217s8RsTU5D/7cjJ9JgHnzGPulx3ZwHg3dvWeAaiM3gbeJpBV5kkZZB7RFY1GX/3qdaRMeCMSnZnQVBf5/IwaCQQ0j3kiUEiyNcLlb3lrc6Q//nkp+HfNxqpdLZe24GKsM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB7363.namprd10.prod.outlook.com (2603:10b6:8:fd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 04:28:57 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 04:28:57 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 13/17] xfs: report corruption only as a regular error
Date:   Wed, 12 Apr 2023 09:56:20 +0530
Message-Id: <20230412042624.600511-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230412042624.600511-1-chandan.babu@oracle.com>
References: <20230412042624.600511-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0233.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c7::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB7363:EE_
X-MS-Office365-Filtering-Correlation-Id: 91c4849b-c214-4bc6-18a5-08db3b0e6ea1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SvSOVTpzBZy5vmL9x6tIAuZ49ppoPyXGtii+WJCYByCCMLxLuLxPRMxH7YcBXQmVcmTvi8fX1UvDW0+sFfo08BrrWvlVhpUqe0hPiyFDqRKGAZXoRO5yfxAKR3Ptu8qORn/cVSulBys1XgrKLXKEGzXmIz2Mn/oQ+wj6hruIbThZ7AeQ6zzk712BJwsQNutAZKIJIEmfwhfmrwQcNiroZ51dmWGlqxLtO9hEDbPeCHL76T43Jahw94SjsgiShEPZFwBTygr1TGkAXjMcB9jqczAuafrn28jnsCxEhY5MBUfgTqdcu+7a1Nb+CLttXJUFnOACbJSm65w2dnFA233FhqyWB3j0gZlGv471OSUAuhRKWn1GTMgBq38MmjilAGXtEKICNlICY4gw3riCvTfPFiGV+PalKuUyaOqOFWDokhi7OaKxcQnwGQwWPHupvd88o6qFZ0AxLELrbv1yg/FxCKBK7NjnkQE4lyw847nvjtAs0fHYCA2rO3Asj9P6TD5XFD/woE6C+i8LSqghx+gWnzJwylMInNO+3bRHkP2RTHkboiCAGkW5VjVFV55U19ze
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(396003)(376002)(346002)(451199021)(6486002)(4326008)(41300700001)(6916009)(8676002)(66946007)(66476007)(66556008)(478600001)(316002)(86362001)(36756003)(2616005)(6512007)(26005)(1076003)(6506007)(6666004)(83380400001)(8936002)(2906002)(5660300002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yTo2uexiMlYZf38Icemtvv2QbEiiB6wOyMKWwiKzrnarV9mZcLFxQAtaSlAs?=
 =?us-ascii?Q?jAmHrVzfnv1V2Prcr2x4hFYbY06HJZ6NMdflAaDmmPyYMiJWmIzB5OLXI9YY?=
 =?us-ascii?Q?RQ02KVTe6d9NJ5In9g3+v/uJwd5cVvuAYkYd93eqDWEldrYebskqbOlbceNC?=
 =?us-ascii?Q?Pdk/IYRvaCl+1jDwCSjgpfkiiQsD9BPFYD4etDKsWGWi2oZVMy+Uvt7ibdpW?=
 =?us-ascii?Q?BIhFkxor1yLkenkINYwCm/oMi3zUiXEij47RU5E/h/dwHf7MI2WD+y/Lupjy?=
 =?us-ascii?Q?G9dkb8R/s2jBDyx5lC7EfMJT1tBtcj8mtiU4B1B2/eRAGZHtKUJYWh1vuU1m?=
 =?us-ascii?Q?VDLplu0isQ4c2ho/7f1nISA4E9oqqcpIETDhjrro8C19TVyVdL/lqo/uNdD6?=
 =?us-ascii?Q?hWWBaQgN1WVO7Q1OH6VRookrs2VHd/baq9EKpMqBQlO/OxHZxgOOmv0a9yg7?=
 =?us-ascii?Q?dvAs8E6/IkMNolRR8rGvxxFTFTxVwteB6TjTARpD3UBzIWJ+aemdStU+21JY?=
 =?us-ascii?Q?Zcn1iPoq/47o5m73HkKN2/BgcPyIPaV/8v927gDBloDQzG0y7yOzbFJgqywz?=
 =?us-ascii?Q?fXdkwIPRVQ8r/WpWMhrOtyLCvidouftg3J9SI8XyQwM1BuKRydyqRVg01uTB?=
 =?us-ascii?Q?Sef2nDY7RdT/vn6vsnExED7QTVEF3zGLozHDVKMM7nyI1YCgICUxCzurA0zv?=
 =?us-ascii?Q?Ym0m3WKFDUXftOIqoiNG8iYN2f0dZJcNxgbPscKZ2X97O73d3/FPIIvXk8D3?=
 =?us-ascii?Q?2RR9ZVFqXCyTaiVYWLRFLIxLMOeVsLMBioGumQ8s7OW17/9dmYOIxz/Vc5Up?=
 =?us-ascii?Q?vmeqZn70jKgG2MVzPQScoJPkHLNTdl4qLbdGsHaR5tL2KWF/7cdOH8iNn8so?=
 =?us-ascii?Q?l7lPBfsJoxM+Tcq0n0Ez7G4VqYdXcCwuYaVmZjx6uVSmuJQFZyB6VEVT4uMS?=
 =?us-ascii?Q?Y0UfZWlytA0Iu78VVqJrsMJe/z98SiBc96aAnaxnbwIHukEzXBnOQaTYD88C?=
 =?us-ascii?Q?yPW+QPvDKxU0Mb00Qd5AwYdGGezDV/B5V/nhwKe786GjJ5vO//sVy5mnj810?=
 =?us-ascii?Q?3gTcsndR7VN9MNZbqWGVIb3dFGEmXOzN7eDokDJmPRPJYpsZ/FFjUhWzTt/o?=
 =?us-ascii?Q?TzkswK/6KmBR4SFRU8LW4GMp5wN/zO3OQiebZHWXG4EDSDwJOcUgaSSu2Gfh?=
 =?us-ascii?Q?ID6MGeMtTGVrVlexuHpd99HtUbMn+/t8j0Xtk6559RdKPdwYbNBa5Y3PObtd?=
 =?us-ascii?Q?P+jTCi+pNj85dcwUOJsRuQvoqz8+yQrtsgYx2Auk90zioZzf4+zMI0WDDWkO?=
 =?us-ascii?Q?hOHK2bBp2l/Jw65FQWVANsD3L5XGE/gVPxHkE3GjjikNYag2sfPy05GgcrSz?=
 =?us-ascii?Q?vWSDZDFq7DssxKbzQQvbOCpbrvgvI1SGp4LQJLktRaJuMMr9gOqNVgr6j98A?=
 =?us-ascii?Q?19lzTwgV4H5O2r7f4gdvSwF/2BA9dc6PkJObjAsyaf0mUzh1//U9CJiVxnLZ?=
 =?us-ascii?Q?s+0SWFH81PG8H1qhwQWieYuC9TE6CY8/GH2XNSWNjJPjwko3laEXKO1jZ6cA?=
 =?us-ascii?Q?JzYtfy0O02++nYVZdSVf5Lf43K5rnKNJ6AyG+T8MT28OfwoVATci525Dpxjo?=
 =?us-ascii?Q?BA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xGumWEecW1v9JojOdaCjRwkNQGjITcAjQnjd/s5ui85G+K0uG6j18IMc+tqHm4kCbdYe1rJPNPfJthDD4BMzTCuq6CoM5Ic/6jeLZKk8jpcnQ2x9Pm5SWBjn2N2IvQ+ACJBczrWurunQZc6VUFsYQYAuU+HL4USD/kMEgCKkBakZJC66fXYEkp8h4UGjhf41V9+KU3h0DDYzdVcG1+HUGVkJLx7E6P22KUXKIpdq5Pfv54TDxJw/y32br6s9TdEpsLAgvDZxYewW3sbkuobNbj3EWhfOCb8/+V591Z1tFKmaAZSHrAPm/4CgkKs/94c/Kw+Z6l7tBHP9mz/gWxVZB/pMdUxQtr98sPRqa+gUW+137kGMk6lUuO2DBKr/STPtCZC9xgcjmrru1xIq78v3qAR29DkvOwm22PMgPV+w4hzvdorcQ1kQ+lnR0RBkgfe0WsC1decCkwRkKPiimT6NUCjJDrc2XlRJ2gODC1qrjo/nftlmjCBWjZnb329rHUl4Sx7EQsdmXVFdHMUA2+pxkv5ElOxrsseHw4kMYVAZ5npdLOtUwC/gW9WLczf/jrJRm0PnqDg3NXuwcFaI8YrQebswnlNrzl5OY/9YasL7w7Y/zrdjyYAQ+LBRUiNBrIVWxNjUBYT1k9e6qPYQcHSDJlizifV7xenr38Gwvh6xV8Qg4Cy3A2YFrkHO9eKS2u5yrKM+BwIqUvGPtjVy/H+sXPdjiyV6ldYsur+1b5ddgb07FfqKD0JfWNF5vTRtVjTi9+jxyMI46Y82I2ikvY/D29UjkPU1EAU3g5C5SNX6SWRxUdsppKzSlJfar11fgI/ajL4srgkES7os8x5mb0Ee9wUXhdSmZ7sx6DorXFHIz+DRusc7R9zkzc7sqggEzLv3
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c4849b-c214-4bc6-18a5-08db3b0e6ea1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:28:57.5643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PhatGcXx2UH+dVBqVt2EUzqCeq/nlf7O7nrwGGoNPmMl9MVx/L6ydjCM4qRhzLha9P0eHOHf660wpHyzLQ72dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7363
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120038
X-Proofpoint-GUID: UkyF-PSg_o-eaGeAFvst2On6h4XQNpXz
X-Proofpoint-ORIG-GUID: UkyF-PSg_o-eaGeAFvst2On6h4XQNpXz
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

commit 6519f708cc355c4834edbe1885c8542c0e7ef907 uptream.

[ Slightly modify fs/xfs/xfs_linux.h to resolve merge conflicts ]

Redefine XFS_IS_CORRUPT so that it reports corruptions only via
xfs_corruption_report.  Since these are on-disk contents (and not checks
of internal state), we don't ever want to panic the kernel.  This also
amends the corruption report to recommend unmounting and running
xfs_repair.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_error.c | 2 +-
 fs/xfs/xfs_linux.h | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index e9acd58248f9..182b70464b71 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -335,7 +335,7 @@ xfs_corruption_error(
 	int			linenum,
 	xfs_failaddr_t		failaddr)
 {
-	if (level <= xfs_error_level)
+	if (buf && level <= xfs_error_level)
 		xfs_hex_dump(buf, bufsize);
 	xfs_error_report(tag, level, mp, filename, linenum, failaddr);
 	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index f4f52ac5628c..4f6f09157f0d 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -217,6 +217,12 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 #endif /* XFS_WARN */
 #endif /* DEBUG */
 
+#define XFS_IS_CORRUPT(mp, expr)	\
+	(unlikely(expr) ? xfs_corruption_error(#expr, XFS_ERRLEVEL_LOW, (mp), \
+					       NULL, 0, __FILE__, __LINE__, \
+					       __this_address), \
+			  true : false)
+
 #define STATIC static noinline
 
 #ifdef CONFIG_XFS_RT
-- 
2.39.1

