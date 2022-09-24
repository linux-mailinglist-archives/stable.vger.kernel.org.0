Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 668815E8CCC
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiIXM56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiIXM5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:57:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500C610BB3E;
        Sat, 24 Sep 2022 05:57:54 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28OCh6Pe003190;
        Sat, 24 Sep 2022 12:57:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=76fnbzJDMDqKN4x9d36FmcDRlOb+bCbP3eD41UcY+VI=;
 b=zp1/imECLL/5y8XA7wrw767V29W7JtEZ0Vy6rPidCCmTXIw/obR9YD2kGwlo0V4QN486
 5HS9+gBWr6cP1W0xpGUOkLMHq85YvnJtT3bW+0cxYsIg7HwLeZgPkAJwCTy/RZ1mwOrz
 O92M4fLpgUdF0qFqRDEi9JZSPyuefXe4MpUhnyVSMY+UbUzMgydmMEzaWzj9+SlXD07I
 9i2EXI6pEy7GPIy91LizGBAEVmH5nwih+pMIVvNor9pT/z9Vpx+c/oCC4LEt4bNoRbpv
 V2hHVxXq8ZygwlJJAY2FsVasf3Iqz0KYkuHWoLfsaJTS51awfaNRLJrB7/uJ1wz9oZx9 sA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jsstpgh1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:57:50 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28OB1mJm033248;
        Sat, 24 Sep 2022 12:57:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jsrb1gws4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:57:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=me7KsH5EMIBBtgShxfTD6A0zcIvRHtuaBbtUmH38Q37jjZYB25QUof/UtcYgjPpFhrFrISni6nf2rrGVc6cWOA8MjTbUVrGF8ODGvB6sEC3V3s2sLTQEsOEwxrC2Qx30+HhAoBeFMHqNxnU5j+OHH6HUOCBvBVwxNWdUU8KwcgirZBiMX1hVVN5DJKUTKKDKAyiqIKw/dld4PzSLQDr8cac24clqJ5yBZevICwTf0lCZyNhpTD2/w1tmNIKRhEZSzQsJbd1SmECEf2at/d/XPEbXHfItt0lC3dTS0pkNVgATwqc4+A/uB4HaCY+yzhw9E71aAykgjjLETsv65vwrfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=76fnbzJDMDqKN4x9d36FmcDRlOb+bCbP3eD41UcY+VI=;
 b=H12Z/LLnBqWTH86dOfsH2rxYPfuFcZhDUnEou/m+06LgYYIAKknJDA/LidmIKx68WCyZZdBbWHBEFWHiqibwD5EH1XvoYdEDoWJk5fDgOGUNDfKdnUyOmwFyxCPf1ENfU2mAdIPVaejSBk/KrNeifFoydpM8DaOvYjk8MgkIFtOXFQXbJE6C9wdjnvg3Q4hqrC7ipsHynBnVzsm1hZCZXbDRaLYQ1ZiZ2pbCBITCy/ivYvKEs9TOjXy+qHlhx+Vd3ByCDWQV36AiiJDpaMCGkcu5t+r314e9Wqs/2MiZC5HJY/+Pd4hEU98w2DdOPCvaGsXDw0bvIXjgdCDBAlrIjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=76fnbzJDMDqKN4x9d36FmcDRlOb+bCbP3eD41UcY+VI=;
 b=hWkbAJQW7Su+U4rquPAXqyqkTwALLJV0bn0bMn/bTMnZ7HYEHrru9wCu3Ov9DOXrjzpXPOw4opEe+O7gdhYX4CKOm9cuYmkqq8bn9b2ifkoQyI4kjE02iw5ycMyAXZkuDEaz9ye+jSU2/ZK3Wc0Qsx5j7J5V/wp/I3YgK/MONHY=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH7PR10MB6249.namprd10.prod.outlook.com (2603:10b6:510:213::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Sat, 24 Sep
 2022 12:57:47 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.022; Sat, 24 Sep 2022
 12:57:47 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2 06/19] xfs: range check ri_cnt when recovering log items
Date:   Sat, 24 Sep 2022 18:26:43 +0530
Message-Id: <20220924125656.101069-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220924125656.101069-1-chandan.babu@oracle.com>
References: <20220924125656.101069-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0024.apcprd02.prod.outlook.com
 (2603:1096:404:56::36) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6249:EE_
X-MS-Office365-Filtering-Correlation-Id: 256fde14-50c3-4f83-090f-08da9e2c6105
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3drRqMtlJbms6Tm8l2hHNImM/XbSXxtl5/CAiYvTcwBd196K7qH/SQueG4eU6UwrTfZPuJ7OdNanMc+YlTBc0xNxNcgQ6GEadKBFLfs+V2aHPklh7ixCjnFHXL8mBqjiALmxqNN/Uvyr9SJDnM4pvAgd0nOspWUHwTfzmxz/p+4WLQYfbAgdN+WuLj6YzNxPD5rmJOoG63w8N7SKkG9ooJWdJsgkoh3lyN+BBxAVOmlKb2Bg46oHviigAYiZKvBNW27rVLP4dZe7szcfkqwnAl/CnRGkTIFHc/7aYeVeUfEfo1/pFYWXgJsmbgVPtkN0Y5arVI2MDrYi9uussaSznVfEZE9SIgrSmRaizowVtNnuxdn6uu3LUitqvuJBfM2v0MMCF0jRIOZXxLxA3O/44NsFLTRG8Z9QDxRloijDHXoEvvmhEr5cP/veL2KMNfZOO2ubNzzp4ooEHebulsq1Gb6scvzrvouV+W00VTim4m9ZBkEj+ett4E9mv3mQsyB0sfavbYiRyqjuK6dbWWou8/6GDIeN2CjWimnrr1G/9bshIlQlbVH39Q7xQlGexoCRBi4xenVajxTph9BIZoo6jPgyAT7Jk1NORyymrYQYuvQ/OsNqADc/LlbBYP+rtDSzxQkyH/jujqTMhxBHJJeAjGSTCFumb6jziJpV0oOy6l44tfmOHAkln3dEXE83BNkXGXy+A1T2HYGl4PiErMSP9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(366004)(39860400002)(346002)(451199015)(66556008)(66946007)(66476007)(83380400001)(36756003)(6506007)(2906002)(86362001)(26005)(38100700002)(8676002)(4326008)(478600001)(6486002)(5660300002)(41300700001)(186003)(8936002)(1076003)(2616005)(6916009)(6666004)(316002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h/Q1E/ikWhLgFOnxKwMmX+3W2qc5sAo4sfJ4ktRxmDbltr4OwnoQpizeiwDV?=
 =?us-ascii?Q?cL+QUhY53B7Z7HifxKZRHi2yeDXyTr6nH94WcZVbNu2yY/vQTT6/vvjQ5Abo?=
 =?us-ascii?Q?ZlQ6XeX1YY3e1Rze2Ly2barsAx8BdQ9nx/5GEaX257Z1O4ssIPP+C5l3y4AJ?=
 =?us-ascii?Q?JGr4pcdOkBsINTpzSYEJ2DPrZv4Ajq0M2GyeHBOpKzsRUwLbcHF/lsjp+/iP?=
 =?us-ascii?Q?WV+46/h/6a0mxE/rsbEyxlPv+n8dScm+bUjGmMOxpDH0ypMxWloWSl3NM9EQ?=
 =?us-ascii?Q?vEFQDYxzADQDYeptLBYJ9GAvXEcX3Ff/l+52wbPe8xLRKnhGVuyHr2yaQxIk?=
 =?us-ascii?Q?6gFrhdqxxgQf4NRZZeUsxtyypaRvds2i+4RDnFNrj29Z3U8cU2tHn/1Pzte/?=
 =?us-ascii?Q?mFew761hP2eBMGGQ59sxskHb6ch9RdEFgjygn0aEqUIDRhIZzoNiKiKkQpiV?=
 =?us-ascii?Q?5NWMRp8PVFveJ3Ihv+z4beWtN8ZOA37F8Lb8i6fP5e+qHchqRNCQsApdPp6V?=
 =?us-ascii?Q?rhtShCZARmAPO9ADYT+Be3lvlrREYHIMJNWKWKgXv3pt181H1MyzWQCbFEMC?=
 =?us-ascii?Q?SL+hA/GAvMhjwcr/BGwzhtkOglhd2KK+2QTRlwT923LefFtsHX+afz/S9enu?=
 =?us-ascii?Q?zeSOR5cqKgoL8tPm7kG7XhG05RRmEmfQUXhn8mVbXY2m7dMQgnRLdp2jEo6g?=
 =?us-ascii?Q?LLl2XREeOZPp4j8Fo3e04LTrnwuLnjhHyWVvZ0thhcHLYT/BoYB5Ew97fgfT?=
 =?us-ascii?Q?CewdRkPNe6O4y1oj7u4419+Ewf/191WygH68yKevdcYyA5Q0oBHCTqfUbHhN?=
 =?us-ascii?Q?ABvn91ci+GVyWgMWYw1Y932UMN6RUurXkOrsspLCD9f1aFauzWnOUIwSG9aW?=
 =?us-ascii?Q?KrTvta7qrp9iB3awUfKLtMH1tyo4RY2kck4hhg3NGJTHUo+XlOuHW62+OtIN?=
 =?us-ascii?Q?H8oiW3C+FL79D6pkZU3fRGvXFWLTjBPTzUhOQvLrx93kbWTVhVDnmmByMV9Y?=
 =?us-ascii?Q?KkEu318Yya4Zhmy0JiQIFJOpKFYweHhSe1bsuCoG0ZMkuWFc5I2nznA+vHqq?=
 =?us-ascii?Q?n226552X2YtW7mBUNXNVMYrABVchXFcovQkIOscF2YCUREwVikLaH2wrtmoF?=
 =?us-ascii?Q?lXI+hTQ1X7JBohytOO5U/t3J+7ii5WyBWNZgVFf0XRPqR6uog6BQ6yPzJSq2?=
 =?us-ascii?Q?f8HhLUqGeGZGhzBfc6rQGnHRlmCbsEtzNCAvWQNxZ7iwAbLYFXs7UJp+sNPQ?=
 =?us-ascii?Q?YADsSPEND/vdD71zhVNSvRvqw5oUPpgoYkpInFkza0ermQq2nrvfAKLSumVr?=
 =?us-ascii?Q?g25FEaTjT2W91VqIq4N7bGXfhEfUV0WRcbWEG06Gz2MKisWs2lOrVOLhaFSs?=
 =?us-ascii?Q?BuwKQhk+XVfkl2JPwmzQYITYbI7VJ02uhree7CFnTdsXMH8Zw1DVhIqBU3aN?=
 =?us-ascii?Q?5m3ZBiAWRnnUAi0Z3LGQPJI2yEaqD0fRKB1OapbsAAHobk+o1PMyJswRiSak?=
 =?us-ascii?Q?R3QukW4Tigzam3N/5Wego0HST2QTUPHO2GravlInD/5E475EQ4Sn1LHZhrgd?=
 =?us-ascii?Q?lgYnJYBq2xahuN3y6HXBIgPQs5yywpkAuCeHYxke?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 256fde14-50c3-4f83-090f-08da9e2c6105
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 12:57:47.0754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cRvRWUqytes4FsOj+LtD1sR/lBOP1/UuZX24A1s6yfJh3uqPLkwOlVxbrQFr9VVo6prnlA7/zXwCe0pF0VOY7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6249
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-24_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209240097
X-Proofpoint-ORIG-GUID: BMb5KtN1140yZR8CLNSTcbvD684mh7lJ
X-Proofpoint-GUID: BMb5KtN1140yZR8CLNSTcbvD684mh7lJ
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

commit d6abecb82573fed5f7e4b595b5c0bd37707d2848 upstream.

Range check the region counter when we're reassembling regions from log
items during log recovery.  In the old days ASSERT would halt the
kernel, but this isn't true any more so we have to make an explicit
error return.

Coverity-id: 1132508
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log_recover.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c1a514ffff55..094ae1a91c44 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4293,7 +4293,16 @@ xlog_recover_add_to_trans(
 			kmem_zalloc(item->ri_total * sizeof(xfs_log_iovec_t),
 				    0);
 	}
-	ASSERT(item->ri_total > item->ri_cnt);
+
+	if (item->ri_total <= item->ri_cnt) {
+		xfs_warn(log->l_mp,
+	"log item region count (%d) overflowed size (%d)",
+				item->ri_cnt, item->ri_total);
+		ASSERT(0);
+		kmem_free(ptr);
+		return -EFSCORRUPTED;
+	}
+
 	/* Description region is ri_buf[0] */
 	item->ri_buf[item->ri_cnt].i_addr = ptr;
 	item->ri_buf[item->ri_cnt].i_len  = len;
-- 
2.35.1

