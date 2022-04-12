Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A3F4FCEC2
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239848AbiDLFTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiDLFTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:19:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38E5344EF;
        Mon, 11 Apr 2022 22:16:48 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BMg76K001710;
        Tue, 12 Apr 2022 05:16:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=HuGfyFsPlSPlWrwhw45+9Dc4WjbxgSWTpY2S28+blls=;
 b=dekTfSbvGO0S38A0OuWWp9+8RvU4gBxetFaiOVcOQ/EIgbKiPUPkPne+KWhM2F0wy6je
 WjCJvttd0kIbmoFJnbiSofNmTU93zYfsM0SrjvaLrINJ2TsIT1RFY05tpcEJdb3lpHbm
 WjkNzhv5IiaIWKLUIbj37V8Pr2IKtwkLLjNcpJPXERObpMj47c5858fXd/0Mim688ttP
 fC5S6FxRptBwDSjHOoUpFZo9f50s/TNx1yzHBGy+Z6jQo/7LWFL3N80MBPmJhaqq/PoL
 T+8lPEbKtIpP9SLCMhckTn8Ev+UWc3ijlkeMqXSYRpgiqxEk7DNRajNqBP7vvU4sEN84 9A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2dmbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:16:41 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C5GOnN039706;
        Tue, 12 Apr 2022 05:16:40 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fck129f0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:16:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mDfIw7j32x3/tmCgTcsmHN0afJzXkcLH//Zy+c41uKbntyYFqxBVwQq6T9PW8kwLr7jaSdSLvqoayETbvRc/1R36CmzEivLrFlSkTXTD4YuGZFOt1vnwSMoOPMFqLOk7e86Mw+Iy4+3Xx0WBfXxL0yhzZoHNvOYj+32IOJshNP/SUJyseyttZG16wvcHPHB0dl1mJeidUo5yTX/pQiiJ1TKq+LMCQnG6ukeiDohBIfc7Dau88lN8QQV2HNoyqd0P2NFdtVvz3vtlCgwF+ONDCrg0moxHvAcH5OlHBoxlmrN+KFFL8FF/K6ypeSPh3SBsn5lmGCaOAQ6hvPGVIN4IWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HuGfyFsPlSPlWrwhw45+9Dc4WjbxgSWTpY2S28+blls=;
 b=dB29fu0IwlTBQHsHirJEVgRrbCp0VoUw+dxhS7puILwUL/2VhT1Fs/66vnTjA0PBBAfZ+8YdfvXL5dPQq0p6oLaRmc8vRRtLtGTqxPFkXkgVgj0ui7BWneHEl9uwqxc002Uuf5Qxlnumc6nEz6idlVuyQLyD6xhLhn/Rig1ntz/9zDw0R+x2Jv1byGypQrPDwnFBbEt8pfg8lFxPn1jtPF4/SmXcMdCJmfYfEHCcb0Z3Vm+SvKm4BY97X5BBUhR4QYMVfkOeeSkCFatTTxgr19r1D1yTz/oBEK3hAUeCvoqtwda32tUCPee0mlHQR6HmTvroi+CEK1hwIB6gr5zyHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HuGfyFsPlSPlWrwhw45+9Dc4WjbxgSWTpY2S28+blls=;
 b=MW57IlOTOINkEWmYXATdIoFcslSrp2W4+ysis+0+ryJkwmJlPrSxTflP5oplPg+KQBJSccU6niXfjjWdoYSA3gbfYl3wHw5lYCDMfQzMpR1nZlX1eWXA6AXHj7VBud9aAgfo2LEzJGaRjVeqIbMrmKlv3v3xufQbKywWd/K2Flo=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BN8PR10MB3329.namprd10.prod.outlook.com (2603:10b6:408:cd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 05:16:38 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 05:16:38 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2 09/18 stable-5.15.y] iomap: Fix iomap_dio_rw return value for user copies
Date:   Tue, 12 Apr 2022 13:15:06 +0800
Message-Id: <6407750d70683b7c09596f45e4c11acddb21d53e.1649733186.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649733186.git.anand.jain@oracle.com>
References: <cover.1649733186.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0006.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::18)
 To PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59307ad9-83fc-4e68-07b2-08da1c439edd
X-MS-TrafficTypeDiagnostic: BN8PR10MB3329:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB33292FFDD8D49A1982E5D75CE5ED9@BN8PR10MB3329.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: akaFqhGN9xZcdu86H2kO+aCeC3t6upAM9XkxOuTfRtvENP2UNXjdSjsM1Hvob8pt/ReRbUmez2Un8qId+sf8OqHWb3M3qUhiw73qCXwraizDZ9CHNhkOhn/3DQ6BhD3iw8CKjTrO9EJiAwJA7wbu1EY6wsdYaMfwkYePoubAvKVfrf8lzKntwqUpoClWxbTnOkyY3IO7izuxlY5828CY4yq/JVkS/jLl8BwslWfVRaMTCv4P6Q8X/LxG/HSrJDDjmJdpj/1eYlC4+tj5HuIJE4AvIoOMd1bvax7ABKxvLRzLHBRP+iWE1qIA1WqHd3TCSuxQGFo8Z5jC2kkbXKKfrFRabQO7M/6OlsAkMlXLwEDa42TOphnevvu+7Dcj8fwz9Kw4G4g9VMIg1RzaVf7lqVqLAqoS9Ep/or/23INPHJHtHDCR7Gom91pY/rGRm7Ut2Ooo43x8N5AIBLG/LO1F2PmxWrRo2pBsYI1mN/U3mR4w/J1cjwDmBzzkGqiI9EVl2IRFePmkK36fzTk6Sih9sy9O0hpioUUmXQRtfoL10McHmfFQ+7kJhnStR+YB8/5cg2RDXLceBKT4wqBCsVGIgkQATCidnTbsR30sLb2kuavaWfK3dg3arjideGWmQBA5IWrQdYxlucNSggbHdVmDbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6506007)(86362001)(38100700002)(54906003)(6916009)(316002)(6486002)(508600001)(6512007)(2906002)(6666004)(5660300002)(107886003)(2616005)(8676002)(66476007)(186003)(66946007)(66556008)(44832011)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q0yvE+l3xnISLbU/hAfTJciTo6ciY2/7w2tjgn0wjOx2j69UFw+6wiqgedrc?=
 =?us-ascii?Q?ls3HrwefDFJr4tTo1mQriLLzMw8Z3nRcUMXLYt/g8poJ/d3jKQsxXUJXgQSm?=
 =?us-ascii?Q?82uAzgBsdfwjxR8RK8cY4pvLZb4u2trW2L8CD7xp8td7NP3/iZinVyKdf9xc?=
 =?us-ascii?Q?pr6kzzOYP2/hO5ZqDx8JDLjFQSgRQn9qxrcqKKCfn1KamTHRNkc4Hso6ST8/?=
 =?us-ascii?Q?MXjzNHn8JI1YiYOE59NZSgG8fV6lQPaUVT7sZ41LAwmXdktmGlTeu7wBEFHC?=
 =?us-ascii?Q?8ZEamNvb4hqKG7Iw1+Oa2O04wu2JlWEsZaZ2Nm0vWBrvsSaMbiLDenQevKXM?=
 =?us-ascii?Q?XZ5SIDXbdAT11DjXRSvflV3570JLP64aQV0lvnoDux4HdKQaCsbt9Yc2pE0k?=
 =?us-ascii?Q?272IUZ/IdAyay4F/0K4onltcIxvU+YRlw7GHFb2dqwrX47WBGNZ+jbJpkh7/?=
 =?us-ascii?Q?9s9MOBaGSF1eazCoHqPF6JaERM2eFOCeBM3pVHl/4LFLAzenfma+jjmCtO15?=
 =?us-ascii?Q?b3+ZwVa3ACTwvq2CIj6bSgEWX99ms2yBHLLnD8G6jL9hTaVkS75W6NkaVfje?=
 =?us-ascii?Q?hONBtUpoSWBVfuLnngAPrwK22VEC9XAlX6J4jISu5WEatInK5kWm3cxzn40G?=
 =?us-ascii?Q?PzVZ9jUtuubHFqS77g0QWEEi0pB/io/ZUw8j5N/zYdOxeH83yd9d4WAlEkcJ?=
 =?us-ascii?Q?5gl6G+uoQJrgRe7/TcO+O8HRjXV1Nyfj48KOg0iRmGhS4107lHNeL9+P/Tdv?=
 =?us-ascii?Q?c2R4h50Zww5IrIH9hNbvLBGwMzlpdWm42Cc1uN23xuVMZlYuD58cT1Yt4Gjo?=
 =?us-ascii?Q?EZ67PtFglw2SUwCRzuHNptdOQBEUOxhQ8cSyrI9wkk6AC6+PEa9rxCff7jb4?=
 =?us-ascii?Q?JK7Na/mIlDcPnK30UcPDRgJPvSzMbx9rZruQhIOrIxetOBCBgmRUAV6DqbQJ?=
 =?us-ascii?Q?LxxpK28OKvr6lt/w1BXoaxSfaHFDbsGCNMc++yDWFaZce5PaxEW+wKm56Rar?=
 =?us-ascii?Q?tXwkZKdf2UZfy3IP8D8Jt81xyWTZqlAz+aT8ujwXc1JetJPMRydtqyWS3T5l?=
 =?us-ascii?Q?zRFPxgJhi+eh4JapfAkzg8tSakpoT6yQ0c84wjuYLBsjmxbyNtTpe+DGQhSg?=
 =?us-ascii?Q?i3v7pQjZZ6tkC4RVrmwfRIn/rM2suZ3v+QlQMd9KM8uv5vmgyninuoodzK+a?=
 =?us-ascii?Q?Y+W6q9QiRIwvt/y4siXb6bA/+oVeXHEctIq7qvCkWGndY0CM2sf1LmQW3Fzn?=
 =?us-ascii?Q?CmKvv0IBFRVLDH8+QabC+g2BKgzw9L1onRerHyW/Znqic2EDFRSNU4pz2L61?=
 =?us-ascii?Q?0CY2H6S8M6+8zBPO3tYu0HmPZL6bZ5m6aTy6Qxk/R/nGc+dtyBezVfoHOydj?=
 =?us-ascii?Q?HpNz7uBwEiTwoOZrTcgsZeIP3uwzxSo+nZvOsXy/yHWLMQcnl6WrU6JhSqgi?=
 =?us-ascii?Q?QCNVpu4qFjOiNkqjnti1DBNwEBqh1s07qX7nRf+JpYNVm/g5emg5VLn+ceXS?=
 =?us-ascii?Q?tjTMyqhVeSTw/KqSvrTDRHLgnbgbrgfNEcNhxUCkoHBv4vSZ/c0GLk0g3Gyq?=
 =?us-ascii?Q?2Er8kocljitX8PstNm7t4dCSqfHlqY5gjXM7xsXPaxdtSZ9qSGRR6SBbXpjT?=
 =?us-ascii?Q?f7GwF+GW8zyG3keZQFCmfGewua8hdjKT6GK/6zyrBRg+AiZcvGKx476PwfK1?=
 =?us-ascii?Q?sZWgS2xBTox8Q+ONSchiGMjARoUuDCAQCiCyVB+GXMj28vSthG37f7n6c5BP?=
 =?us-ascii?Q?upndERdU7+KXICpqsiX0oKjmAUlrJasqs1yzoGQce4lNM/3qh1Ie?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59307ad9-83fc-4e68-07b2-08da1c439edd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 05:16:38.1112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xba9fD41LZT+VHWKgZygJBOH5gQuqq9zAtkz9KTLSH0mn3c2jHsBIn6ZkTfLxCxDJfhIp0qbij9a9OJBRBKS/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3329
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_01:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120024
X-Proofpoint-ORIG-GUID: RjrQ2Ur3swc31sU5jluGI3VhtP9Psktq
X-Proofpoint-GUID: RjrQ2Ur3swc31sU5jluGI3VhtP9Psktq
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

commit 42c498c18a94eed79896c50871889af52fa0822e upstream

When a user copy fails in one of the helpers of iomap_dio_rw, fail with
-EFAULT instead of returning 0.  This matches what iomap_dio_bio_actor
returns when it gets an -EFAULT from bio_iov_iter_get_pages.  With these
changes, iomap_dio_actor now consistently fails with -EFAULT when a user
page cannot be faulted in.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/iomap/direct-io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 4ecd255e0511..a2a368e824c0 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -371,6 +371,8 @@ static loff_t iomap_dio_hole_iter(const struct iomap_iter *iter,
 	loff_t length = iov_iter_zero(iomap_length(iter), dio->submit.iter);
 
 	dio->size += length;
+	if (!length)
+		return -EFAULT;
 	return length;
 }
 
@@ -402,6 +404,8 @@ static loff_t iomap_dio_inline_iter(const struct iomap_iter *iomi,
 		copied = copy_to_iter(inline_data, length, iter);
 	}
 	dio->size += copied;
+	if (!copied)
+		return -EFAULT;
 	return copied;
 }
 
-- 
2.33.1

