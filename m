Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2FF64F0085
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 12:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235885AbiDBK2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 06:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354294AbiDBK2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 06:28:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BDF53B66;
        Sat,  2 Apr 2022 03:26:51 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2322rwHW018854;
        Sat, 2 Apr 2022 10:26:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=5ybCZa2BiePKDCzqPdDuMZWFkfah4+o/OXzJe34yNsI=;
 b=tvWH+DNk5UcDyZv3DpsOt8Z/G2WDt7KUR8oqxVkgvz2BtNFEdqW2cRdweahGqAE0PdMQ
 8cu04ISP1fS3vR8Q0qOEJf3Toyu5aH+g9+/1kV9bTg2ABHKmEF3hyIz3xPweetfn8PcP
 4Rav1us1kHn9SR6yAQ8vJOEV4alLi45TIMZ/gqdhHddaJoc/YEiCDt2MJP6l2chJ+tTK
 lzhqksiLHXxNwIBptOcq6fwenYwewGoCbj/eqoe6cONA9nnDJxMLxu6Vd36V3zWIred2
 /IeQ9IfVBugXonPxonoVezLycahTP8vUDrBvkJY2pGWC3ls54g0kdTG2b5MmN+YcRlsG 7A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6e3sgayj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:26:49 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 232AMCKh001646;
        Sat, 2 Apr 2022 10:26:48 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx0y513-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:26:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgMjVtLqCG2EkX/mW2Al9yRyEpRNQGVsPOtlOG+Wmcq2GQER2pabLqtTbU/Txdfcg61hscOBqfJXXDvYRMHLnyG1jnzs2G+N9HX+kGXD+hgyDNS9WUyw9a3g+/yut22xSDa1ulUGpBmFpYtXC0M4II0PiBy40pQHQYwPOlCTatmQMJH213UXTUrl5qpB6MJVY+O1fhd6Bp3DP7DLgwLMhq8llxL1nnoG8wkC+2VtTEk1aakdy2kQoBa4IDyN1MdZUBMM9anvJnLIPHgIRRzkkymW2jyR3+frQL/Nd5id9+aow9l6FhJDtdx/waYffL9/X9cbU6g55gag3lGQ8buIZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ybCZa2BiePKDCzqPdDuMZWFkfah4+o/OXzJe34yNsI=;
 b=hJ1MF2qw9xOXiAMBcK9ceMtIDCOKUz0pLMMAf7QFeCDWybgCzdng1aK2xTptn++fcPuHyg9sqmo65dBd8IFlhIrEYPakRCmTkD4FH+DdyXAemIUUZCoYjWweNNCqQB3ukUVZLS2sl+jeVLoXbcU85MOoSYKy9eXZtvCiHbsOQc7j8yuSrogI3YNbsEer1maNevf4hEo6L+/Qom85HfpZ/46y+d/lTSFVCJn2h4M7CAn9dsykozPbXY4Gmwbtf5CfZIRhtBbyymfbopgK1k3RPJtqolVpx1FkNAtznl+zKr850WhDvPr8aOf32B3kW3Qc3cSNMop9KFC2JTU3/lyqMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ybCZa2BiePKDCzqPdDuMZWFkfah4+o/OXzJe34yNsI=;
 b=rKq/wiHbnARummSmzvS9VUcOtvvm49yErP1KaUpV6/V0ZtzMwAWl7qofe/DTIK1dK7YGl88wYYw85Li4+f5tZBeyZQwAatm50rK3A3Nf7yyExhTsW8FYSRSKyG+jgC4EOz+3QqFKfs/C0W0wP7rXeErSc9Olj5Q0FrYJOf8Rj14=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM6PR10MB3049.namprd10.prod.outlook.com (2603:10b6:5:6f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Sat, 2 Apr
 2022 10:26:46 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%6]) with mapi id 15.20.5123.016; Sat, 2 Apr 2022
 10:26:46 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 05/17 stable-5.15.y] gfs2: Add wrapper for iomap_file_buffered_write
Date:   Sat,  2 Apr 2022 18:25:42 +0800
Message-Id: <b1f7119c7ac9c09788eb812169e5e94ebfcf3c65.1648636044.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1648636044.git.anand.jain@oracle.com>
References: <cover.1648636044.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0007.APCP153.PROD.OUTLOOK.COM (2603:1096::17) To
 PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae80c536-7b7e-43da-f6b8-08da149349df
X-MS-TrafficTypeDiagnostic: DM6PR10MB3049:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3049C22AE5D61121473E7C24E5E39@DM6PR10MB3049.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O6e1mNO/YcnXQiL6TAA9Hiv/VlcEXEe1U6zSEFmYii5VHHurOmgt1DLuTMWPBPuehoSSZp2EHDhm7lpyYC9XBd2Gd2QeoJ/odD0LZLcKN3kNqwRo66yifFL0gqPQBb74fiDNcvEFApF2RjioQGz6BjjANXjw5PVmFIbrQdY0XbOd8LmGXfT5PmP0FTXlkYiufz4OVyrPjgMJ2jMbRg2Z/stkPtf80P65YCU6ZuLql7XeJZb0RLLNGFRHCXVXCg0+fk7M1pzx940x9WeHT02xQdNCr3dZY+rHC+vBnI0yXTVyScFU35u9NRSQlkYK5ecLnpMRb4zM4CSRuEodrGIVLHpr4TwQiUQ6Gg6GOFY8A0cz3Fzlz5sLWqmwjGMpczrycTl0CFX1PIvu0/fWztJ/3WJhtaRBofU9Wtq4rXNJywjgv0kW2UbFkuFj5cv04KDendj/BMsCSeuXaHQ4O9EaNwSO9ju3Xhqeuc+varcNxKlrQcX6hssC7PEe5Q4Vc5dcksZSGjuVjTOog4WISdwCqR6ja3a3pGR28PawA8Kz5qN/zF8qCPHn7FruUm8PXGC+cEp0ZWhuz7xswFIYNwYhtOW4tPqbFh67FIUJGjJqCGaonHXPUaqadkzSebQEq7FL8H1AB19TO7ZTEAQuMx8dow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(26005)(6486002)(66476007)(54906003)(6506007)(36756003)(6512007)(86362001)(5660300002)(66946007)(107886003)(66556008)(8676002)(2906002)(6916009)(2616005)(186003)(6666004)(4326008)(38100700002)(8936002)(316002)(508600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PsRKZ7KFsRkVdg87zAN9G37uKYrB0BJlryXax48lduATC1d7T6XAMxlwmIzF?=
 =?us-ascii?Q?jjNQt2Fb/ewlSI0+wEftqmg8gHl0d5fNyWnAHB7Dl0FvpYetdtcVWZH4dOZ7?=
 =?us-ascii?Q?oO5VYuaAxY5jSx811vU+9COzwT0G1DVtfj4Dp9zgCIAlu3LO66Hecx0tGLPv?=
 =?us-ascii?Q?j8JnQw0uowAmaGdQhvA6l0XJy51eZbI/vMcUyTuNkbFHAl+zCrAvowQrfwpf?=
 =?us-ascii?Q?yhqkBmsOhTNBnfm7k1eWYfIWmxACX6VojgV/1afz2Uz3mj81yLdJYMi6mzIh?=
 =?us-ascii?Q?r+h5HoQ7POUQte7oU6GobSv2YXubjqjOZJrpppt8kEnPYRy25gPdTkP6e6m+?=
 =?us-ascii?Q?koA0FPZIJSAUXF2i3nYSiC7PQTcIeQBlqurGveo7UbtuJ60v4vvoVX7EBOgM?=
 =?us-ascii?Q?zTYpowKhp5D7odngk1IrfWDCu0Sj3xbSEeeBjRxMTcAZNY8ygmjF4FLQ4Fwp?=
 =?us-ascii?Q?blf9vajfOQWRFT/u7uiItHz2kWmaejatfPAxk13K6XF5IflIIkQrQYPcO5Vp?=
 =?us-ascii?Q?lZ4wXPZBQhoYngxYetxY5IWA5B79TU4F3udYh9nzIEsS75G8RdsfRRJ5WMv2?=
 =?us-ascii?Q?w8TW7hChtdkSxlnDrHzOQI/nDyUQYpmnuIcbL8UHZCFmkDcvHp1Jac4dSgRE?=
 =?us-ascii?Q?YCatO6kCC3ca/QlxLQdOqEgO8+/3o8UoSDC5PChVSW8kaV/L155LOhCvpspG?=
 =?us-ascii?Q?JA6uHxjeCWeso0sIHqLmxo0atu+UWoZr9o9n5azBy6y9Tx2HB89AOe2azB4O?=
 =?us-ascii?Q?91QJef9PHh9TCBBU2O8ErHNQ8i5orCuulJSmrJf/48klPbKOAVo3HgrUJ3yo?=
 =?us-ascii?Q?i7z6px1H+Ld/HeSWam0e9UIXfrqMeF32gVJ5Wae9anHIzN2zyxA9VwQcwhkv?=
 =?us-ascii?Q?NGCoKSmA8TUbz2i243Qi017u0bJzrOfDA4WsJeOXDflF1EPuvp9xP0+Vsuk+?=
 =?us-ascii?Q?1NnN9mUigDMKUGiRvHqKjUPiwBa+DAtowxQ/GI/y7RTfMEAtIvq1jtz7DHSc?=
 =?us-ascii?Q?3nND1NNKuNEi29GD3UIuYoz51rM2ozIAP3CIw17uqH7a1ZCJNZa0vV2R8dXg?=
 =?us-ascii?Q?p/2Lv2cgRdt9MR8Z+rjSsGkw0LuRpeJ+ztk0+e3s5Q8RPkjKZZmgTgY0MDMT?=
 =?us-ascii?Q?aCN/NhrvuKHc5zGiz98LC71zymfv1riL5QokSpOSKngatUfrHNm0jQnakq3V?=
 =?us-ascii?Q?0TzRxmioVI2Hiw9cH1Rf2CXDo0rIOAfPqnAkskkWAcnK0UcvIhI7prMQBOAb?=
 =?us-ascii?Q?Qyn4sjzpnDvA5BPlpFHr1Dv1VC1dsmFWiWNpLLtZ8wnBaEudPx1lnfD7AiYG?=
 =?us-ascii?Q?VN4y3siPwenR175jCV/HPqohNZBrkKWCwntUIj9X3UHwiKVBAYvaj61+lQCr?=
 =?us-ascii?Q?7EtVdYSYgUGowolz9eW1vmTy7NjMIEnz6ZvLjtv/30D7Gm6omsjL6iSBNwwk?=
 =?us-ascii?Q?sXhiz/njRkSuFyb3gUvAqj7V7zjBP/uvHQXuBt9b/txmCJCtJzLxMJ+ncWxz?=
 =?us-ascii?Q?tK/Edh8zY0QwISwBN78uDKb4+IRZjJEhBEgVxHYhCtDj1X0kHj2MGHIOytla?=
 =?us-ascii?Q?3WN5UlTC3k0guZr0OXXUek9o3NYjCnruS6Tu2Ob1hqHi/54Lr4e2GhvAQ/bq?=
 =?us-ascii?Q?zDmqtF/VZpod6AKVN8Wd7bSA+ZW0WK0lE1QsFgeQ9pM44S2Ys3Z2VljR+KiM?=
 =?us-ascii?Q?DPTeIzj3v5d0Xx2DDqiSwoH8Fo8/SI1fnhqZd4CaMVGKfxwRFPXuyS9whmuP?=
 =?us-ascii?Q?TL8B7Gwy8A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae80c536-7b7e-43da-f6b8-08da149349df
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2022 10:26:46.1310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XDcLM6uEI/iv+MZeGhL9GYdgxB0K0mPrftyiTKKrLhr5vgwDpnjPF+EMVIlQ2uXMt7861ksuM0/Z5efG3QXjfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3049
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-02_03:2022-03-30,2022-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204020064
X-Proofpoint-ORIG-GUID: 4mIc4vGNuL9nRzFfKqCmy7192vfrXw88
X-Proofpoint-GUID: 4mIc4vGNuL9nRzFfKqCmy7192vfrXw88
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

commit 2eb7509a05443048fb4df60b782de3f03c6c298b upstream

Add a wrapper around iomap_file_buffered_write.  We'll add code for when
the operation needs to be retried here later.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/gfs2/file.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index f6d3b3e13d72..51c83d85a5a5 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -877,6 +877,20 @@ static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	return written ? written : ret;
 }
 
+static ssize_t gfs2_file_buffered_write(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(file);
+	ssize_t ret;
+
+	current->backing_dev_info = inode_to_bdi(inode);
+	ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
+	current->backing_dev_info = NULL;
+	if (ret > 0)
+		iocb->ki_pos += ret;
+	return ret;
+}
+
 /**
  * gfs2_file_write_iter - Perform a write to a file
  * @iocb: The io context
@@ -928,9 +942,7 @@ static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			goto out_unlock;
 
 		iocb->ki_flags |= IOCB_DSYNC;
-		current->backing_dev_info = inode_to_bdi(inode);
-		buffered = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
-		current->backing_dev_info = NULL;
+		buffered = gfs2_file_buffered_write(iocb, from);
 		if (unlikely(buffered <= 0)) {
 			if (!ret)
 				ret = buffered;
@@ -944,7 +956,6 @@ static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		 * the direct I/O range as we don't know if the buffered pages
 		 * made it to disk.
 		 */
-		iocb->ki_pos += buffered;
 		ret2 = generic_write_sync(iocb, buffered);
 		invalidate_mapping_pages(mapping,
 				(iocb->ki_pos - buffered) >> PAGE_SHIFT,
@@ -952,13 +963,9 @@ static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		if (!ret || ret2 > 0)
 			ret += ret2;
 	} else {
-		current->backing_dev_info = inode_to_bdi(inode);
-		ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
-		current->backing_dev_info = NULL;
-		if (likely(ret > 0)) {
-			iocb->ki_pos += ret;
+		ret = gfs2_file_buffered_write(iocb, from);
+		if (likely(ret > 0))
 			ret = generic_write_sync(iocb, ret);
-		}
 	}
 
 out_unlock:
-- 
2.33.1

