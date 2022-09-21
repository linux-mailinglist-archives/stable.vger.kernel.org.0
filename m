Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4E25BF44C
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 05:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiIUDYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 23:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiIUDYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 23:24:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40073764F;
        Tue, 20 Sep 2022 20:24:47 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KLO9ol006568;
        Wed, 21 Sep 2022 03:24:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=76fnbzJDMDqKN4x9d36FmcDRlOb+bCbP3eD41UcY+VI=;
 b=chEhgCzxGOlRha8TopOfjYhiDiMqPk+DSB7NL4Okkp05tpDzAiZWXIIj4qIb8+f3fLdb
 1kGbYV53uYIXfGyz9Gm5jucXvoGOYFv7tPogqVHdy+0re2SEzYN8pyVj9eL1wC1mUztJ
 tjtw9CMFg7KDbmvz6ZuNrB/tsx5ipx3jzmyzm4xTLsO9MSxWe9YpdJjH7k9u8zvzH7Pa
 P/AEgebbLmgNnTpGusDosHTgkVUO9JG3uYMNWJR+6f/edh6EXt9L5C8t3/3Hd9XbRo2j
 NfIHaM+uWPZZS9tJU14Le/1nXy98XiNKn5eiRmA81wmdilSsysll2xFHd92bfUa3Lu9Y eg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69ks0vw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:24:43 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28L2EjLC007903;
        Wed, 21 Sep 2022 03:24:42 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39m00gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:24:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ddVeveDszCSI9wAM8dyDD8Tl1Y+I4EndL2nK3iTF+hCJkR4AZLTQC1csmzg/xZh/CMS2e0Cyx7M3yUmgA9OlPEFC5FSgBY3RDttM/m/BcwVNwYDqdF54sqAw2uVcJowNDKt4NCl2xq8AA63TGEVBetLN5CRtuUKVbPsCG+f2nTcCR9Im9oyA1Pmuiawj1X47A1RcA/rPxCXmc3SZL5ecwx18I6dyMf9vFoXSLtkKuiFIC2HFTLfYB2CMMhOn8bL0EVCI4ZWTMZRvB8Wrd+jEcKUXEQhzy2gpMTx9Q1U+NA4x/J682kMAeDZeUexYpTx/hOdGC4lDXJnrzDA0HEgh/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=76fnbzJDMDqKN4x9d36FmcDRlOb+bCbP3eD41UcY+VI=;
 b=EZBPimh+/0URGJN+x/hipSMmsO25bXg3aPR2TUhJNM7fmYpuJdnDVmXN/JesTSRB6h4bjVMqQBVv3h4yFXaOUokic+v+x9isntAgl5i909wehWasZ1rhllaT94ZNFEGDkW9KyHBkeZhfvIh9iKs6JytFS8j6x8CblAvtW8BC9jTsFpSdyrvnoocfoy5j4/bxofDBctN5zay1MMueU96WOJCKffIhtuBBIO5X/bZ9sGrvB+9OAxCTDpoSIas0DbeYf52V9muWKEiw8644C4lRQKNMPJWWK6ww8gjcupR3Ub4gS9IVKoiq+An/2JFWGeKMiffvGizVOAeTKyGH9EOVQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=76fnbzJDMDqKN4x9d36FmcDRlOb+bCbP3eD41UcY+VI=;
 b=dyasDBDQDHXSPXi+eSCjeSc4oCO850vWOOWnUq4Eky2Tf5oGijzqRjjErRCxj9OwjgUWq8v54d+kSmfdnyKmM7qegBSy0o2v3RRm/OnNLfC+DgMO9EJ28k0/0b6MJN3BFqbO/a2wrtlNISOXkPvjmGShNri7NgmR9zhmFzyuAq0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB5579.namprd10.prod.outlook.com (2603:10b6:510:f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 03:24:41 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 03:24:41 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 06/17] xfs: range check ri_cnt when recovering log items
Date:   Wed, 21 Sep 2022 08:53:41 +0530
Message-Id: <20220921032352.307699-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921032352.307699-1-chandan.babu@oracle.com>
References: <20220921032352.307699-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0011.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::23)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB5579:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bf47301-d22e-4d82-cb02-08da9b80d1e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OCD5nEFWHuMQQka1PBjsHcFuSHkPN4MbFT5npJJ8bXVl2Qc+Zar8v6QcZm4YKhQHt9Z3FCJ9ospJ5usQSceIMHuF05RPV6T/EqbQ+1NIQKxYOCTV7PxdCAGsS0BK3Tsbvq8FlN/47uW02k5ENbSAf89rwyD+twV/1hRQ7119jX75+HUGgJMtsIxzpHPryMLxo71pPtUUbFK2w0FM9qcJ+XpC7P5UuN+UPklFIoZCTzCScIGJzFWjh0ld+RAiuW2zFBYgpBYx1xvuoTmFJb7K9tmRzNH6kpc0hrc8RBTsh0idVUM+l037DV0yEUHZvmVdiq8Uqt64tw3Eg7E/7nq5raZwWZNFfpmZfWVmwN9jNw4hrGgelOY6aPqFNAq5Ptll1jxYz3p9cGDVha+5C1etq6EUDIS2GVitOPYjtY7Jv1UkXcfg9Jj5qV12EAKgo+cEdRXqY6Hn2qfvPs111qyWpoeIMKB8Wns0FUdphNIkOlPFsC6o2f5UleM6ecNhCwffwvfEtu/nmu2xUeUX7f0acVzB4mXkeB2DF40o3r4Wl1MAUK3fCGilKG/ob460zy03uG4GsBvsxTZhNqdqueXIQQ0H4aokD/NkoDSboypqtFB6MUMD/SI9FKu3RzA9yX61T4qay9MvtTu6+jizzX2ms5gDQYZAvKXaZyMK3t0T9iKCjeFiCvC9M3vXJpyaPvjtXb+QeGyMJVH4guPTahM8/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(2616005)(41300700001)(186003)(1076003)(83380400001)(2906002)(4326008)(478600001)(66556008)(66476007)(8676002)(5660300002)(86362001)(38100700002)(316002)(6506007)(8936002)(66946007)(6916009)(6486002)(6512007)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6I3ultEve4/5Ctscpx+7Squ1vah2hNsX1o0aAN8JkhvSa/HNNtej+et0230d?=
 =?us-ascii?Q?w6NIu0ZZZY0upx+OYlhStzapJhzXbiDBJuhgbg3/ZPmIAsj/1sF0tWuXTmpv?=
 =?us-ascii?Q?yifB90OITWzokAJ7+rd5TPA2iN00gXET1kK0noaQpol4NdzStWqoQsVxz0Mc?=
 =?us-ascii?Q?hdPWomfKG1nc5jhafN6nWsBr3htldditCAZmgBBkUjYPIdKlhoFH1gmRxiaX?=
 =?us-ascii?Q?dWuPvNVeD5ZGb13F0lobU03kVr3YFG0yawEfqMyXJlZE/uvt2lgJelSCe1MH?=
 =?us-ascii?Q?7gUyoZb8rq6gIr98MUZ81Xwh/zfKOrogiMV4iFqyqzUorLlm0zBj1U+2LtDb?=
 =?us-ascii?Q?AMAunR9hjGSTplg+hnnf1CGB/lUjfcY8MBwOmOSwuTWlBbCvWulMc42Y+qJM?=
 =?us-ascii?Q?92Yhe60bxabTLK2gIk9XndauH2FPShFxnJgcdsfDIkJXxxdJBV4JtPmeHMCF?=
 =?us-ascii?Q?gmfVpfcgXHGv9S2sYHgCzr95F5/mR67fvAl9SAs4htZGuhxS1JXbltUfoADy?=
 =?us-ascii?Q?Qq/qD9Ntv4slGz7DKONYZuXjoMsmPdbq97kvEKAfPQemWJ0suC3mwINHT5/z?=
 =?us-ascii?Q?jlGPVpbQpJrmYC7MCU3Pnar0Sd7bI57R03f86H9SUQ2FsRBJo/wMSjNCs63z?=
 =?us-ascii?Q?/oDV++rxtZfRBlnZqBaE5KFl7+kOE2f9YG3XtfRh3P/jL+dA270I3Cga7Auo?=
 =?us-ascii?Q?Zb3paEkNOQubUnwLBz7WAI3qLJmqI6U6Rmloruk7Mda3Y6VX2mEPDQYsP7hH?=
 =?us-ascii?Q?x+yfmrOevXa00X2ArqBu3ZAbgmdv2GjGrsj7PKA0iegy9ZWK5pDZ2hsMthzw?=
 =?us-ascii?Q?GPcEUkyEz6uzowtITtRpaz1B4d/ukFufPH6hw07+RMSQCV+aCO3WSWL2UmyM?=
 =?us-ascii?Q?vzfFQu0zagG9Ki6XbfBJAhMHH+FiJ/XAbbaKNRNgaNt7zB3nUekVqF9V4n+2?=
 =?us-ascii?Q?3Wohst4cEvC1FW1lA5MRbVA+SiVj9A6K+C+PgL6BXGIALJyhC1VkDSX78gfg?=
 =?us-ascii?Q?/kJfm16RkG1zQQ8dVAM7OviZOfZC0zWxqy8Dlewnc3nWYgZcUQp+NAWpJ2dZ?=
 =?us-ascii?Q?VWwXfeiK/SJ5PU6UWNFUF7XP39+lOY53IUK4kO3tOl9VYCRJpi43tzMvYnIe?=
 =?us-ascii?Q?q5vn0iulQvJTi2dzausJSXpRl5o7YuKBmFlDUrf6egYZoZ7v5ePdxVHilXq9?=
 =?us-ascii?Q?doj1rS+zOGm3LwMrfWNRnM3+ngK7GomxSa4EmHwSZWo4dVDtyH0A61nzNc7A?=
 =?us-ascii?Q?kLXK9uyhVV9pjfWq1gAeNkt4hbRzDaQvaA4v7BHZOjjp3Zz7B6ovZ9tEwP7v?=
 =?us-ascii?Q?vYsgMSB7TnU+GfeKRnpCRvCvfjklj72wMmpKlJoLRUz7o3z+v608o80BI/qE?=
 =?us-ascii?Q?wO0GW9I/rK/VHTEXgmjwxT2ygMWWb9Fb5rjO8dg8FfZCEOsy4QGh74EQStsl?=
 =?us-ascii?Q?HzStownGkbUhTtadrjzjcf2asCfRNgXY5oEpFZQyyQX+YtN3H8Rj1dy5GYcj?=
 =?us-ascii?Q?WIX+FNGn/yUsoUInfrYuTVIl2a9Cdmky1vVvma18+nmMRPaiK+sxekCzzGkv?=
 =?us-ascii?Q?eQugu9yJ5V/YNwqcPi+PcfiMASDDsHoYpDzmulQ8JUWXbxfcLROM5u235Jol?=
 =?us-ascii?Q?7w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf47301-d22e-4d82-cb02-08da9b80d1e6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 03:24:40.9153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: otjv5t2inLAbYbsccBmhznW1xxS7k96ewhhwJDr0RHc9B9/yjxlbyO0k8PWVwEWqghvkWj5HPQmrJw0h5CVXAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209210020
X-Proofpoint-ORIG-GUID: y9ISTN5Wa4ZMST8K6e28VuoA7tMLVr2R
X-Proofpoint-GUID: y9ISTN5Wa4ZMST8K6e28VuoA7tMLVr2R
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

