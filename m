Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A592501E65
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347150AbiDNWdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347164AbiDNWdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:33:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9AFC558B;
        Thu, 14 Apr 2022 15:30:41 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EJ4f0n018415;
        Thu, 14 Apr 2022 22:30:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=rM2OYNDnjOSXgpIxpKd8yTK/tasdQ+W01Fq39WF5u3k=;
 b=behEU2BLdDYegnjQA1SJyOFSUoyX/y80OLaEr+WPh10ZYYs16caCWuq0FE2YPGvhqXBO
 cMmaybros75qUZu6h32eTfBCCc8ii+tcIXDNAqzxXRKhrgOE3Dw+3QpYdeQ0sr8KVnbl
 MTRK9tLU7nmhtVoAIQpq+tmZMLGft7HBgQRjOtIVZ9UZJtHXgSeptDIIDOeSdtdk2QId
 ufbQqiDwPzevofbZsMReLtA6TvvjBv22KJekG56vTuCYvS7XjpPwWn2KbyZiUCtjk6ih
 krYfQOe5s+jm5QrX887/V7ug6pBy6byW8kt0IQgKjaYR6aQSacvmS2Yo477gxyhqcSii lA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0r1p63u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:30:39 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23EMHPqu020912;
        Thu, 14 Apr 2022 22:30:37 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2046.outbound.protection.outlook.com [104.47.56.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k57g2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:30:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEOrzr46rfYgfmpTVdDAtn/LdKMe2D4vgiNlsEhSx8xw7nD3KtbYOgap/ad2QDezw0aA7gtmM4rZpnhLMDo9psIMqDB8lzOOBC1b6y0v4VSYZ5arEvhvrrUpBYpu8pI8EFrHh1Q5cVolW3W/J+kAkbpLuvFH7GN917qr9SvkNaa/LHZ9nC/tAZFQyXOzRkFmkrg5hXgZRFWpZJIsJ7vOcJzpMQ0N/gtGyq4n20nHFH2RfmpIW/O/EDm4MRsmk+wjwEbUk10Yjii4FyyesFwjuFhG9lJhxccbqclogCxSD3RPxIjaeaNUo04kzVnAT+iUp655lD+B3+9D5ZJ3U9J2HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rM2OYNDnjOSXgpIxpKd8yTK/tasdQ+W01Fq39WF5u3k=;
 b=SN+zmnMdAxW0yNYAsKT2Tv7OYZEiPqG0Vek9p2KkNroSyvyoUscxp/9BzDCkctnRnkxWx5GaG9rFOoJELSacoaL5FW2UVWcweyFL1iCEsK58WqGGLwjxMoCEend11MSe8egQMquo4htNacScWrtwva3OVAKnuYcmIdVAy7ay9j/9Un1Vqkf8BrucJA25H5eSJzDwqZwI6vqzu2NpnB5Emm3ku1pPOdip/edOqBrjDjbtfkk1qDk+oYxjlDX25ZThyDyJeWgNrvcyR2SxXRZu7AbIFkIoNv7dxvn6ljNqm5RsI9DovoNVFJ+jsPGKmOLBnx/ZYyqHAa7hm0sRQfWyqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rM2OYNDnjOSXgpIxpKd8yTK/tasdQ+W01Fq39WF5u3k=;
 b=lrUVsQpHeY35+cXtCFbs1cd3fgiV4tmWCACMgPwUn3qQEMjiC+2fQIh7jyA7AduzYsF4ZHJ6B84aEHA8iQUIiDBZSQTzI9CbmoiycuBuA8JdhXT/W4gInVPyH4Nh12NyupFMBbTjo3l1UhCF2+ImraOIoqCMG+IFz/7kaZDpZqA=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by CO6PR10MB5572.namprd10.prod.outlook.com (2603:10b6:303:147::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 22:30:36 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:30:36 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v3 13/18 stable-5.15.y] gup: Introduce FOLL_NOFAULT flag to disable page faults
Date:   Fri, 15 Apr 2022 06:28:51 +0800
Message-Id: <2ee1e383ae1cca975426b54ab251257f6d4e12c0.1649951733.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649951733.git.anand.jain@oracle.com>
References: <cover.1649951733.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0018.apcprd06.prod.outlook.com
 (2603:1096:4:186::8) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee23dbdd-5a1e-48ca-729c-08da1e666521
X-MS-TrafficTypeDiagnostic: CO6PR10MB5572:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB55727EDC2AD35AF20DF92C7DE5EF9@CO6PR10MB5572.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SIZ06lEf9beV2fRBqOgnanZHn8unUL6UFGY/LQ8ICFvwGEwgx5YB51UFjLQxq4mSN85FiPwnQ8kttvWb5F8GH38SdoZcKdPWcqaWITZoLatS+P54kKplDwF6NZSoYm1P0Rz2sQBj/9KJ10V+X5CrOW+f8PBDqoAZdfmTnErB98H5FNfeNteIqWeDE9B8+oHSlJ2AX3QI/QR6q4TH+/tlF3BDrcOghYDNH8I4abFlKLxFY+0SQSOrgJ3nGZW8RTiSkc0RCnWh7OUekKcLIofKHgRjqroB1EKoYcfROVSK6Twji/K5hTm7wLo+Ho/7rTANgDsxqakAjtlh8qQ/7/1uGOqtfwr8WVhZzX1UUE4ExQZt29xF4e5kPuId2LoHy8AaCjqIO1nLE3BwXvUf6qc9WAsQJxuOSAwnI2I8TgoVLlqxlrrzVDTnFDECLu1P29SdCY05U7vDs+wPOG40+LtNoQiSz4m2BMIjAOc1PRszzci6jjh1k7tEXXnAmvpFUkZTaMptRbf5NQYJrQ4JD64zNjZlGU297QZrkf2agwUXc+d7fJUJR72zm3gjlGQCR7QNusFecPRuHmbHbcyZwKM57xWQ2DX48VY+C//7HInQbfXTXBacTxIO7AXmRGzC5ZCD8Z/BkaH0q39AghFLMQZFiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(38100700002)(86362001)(6512007)(6506007)(2906002)(4326008)(36756003)(66556008)(66476007)(66946007)(508600001)(8676002)(6486002)(44832011)(83380400001)(107886003)(8936002)(6916009)(5660300002)(316002)(2616005)(54906003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mzFpJ9j9KHzindn5ZYICNv6LKvC+2Of5feDoi1WQZIzzX3gw4E1INX8D+WCG?=
 =?us-ascii?Q?coUmZad/JWJuf/MKEb4KxwHzPVyTAIejh3vPdbfeiY8BXKCBGOjDKbFvZPMu?=
 =?us-ascii?Q?R+yx+dt2BHdE6V33Ldj6kmJheL4z65A7FdFsmdb0iY/rPwEIvTtTikbj1XrL?=
 =?us-ascii?Q?wZcVr06tYBBl4UaBU1T24Km4dF29gaHUrmiR8Dqpcx2NYtf8un3m/JHBaHHX?=
 =?us-ascii?Q?liJIai8VdKyjHf8Cvw9g7guTCdo+P3H9CW8yvUUGjIKTcy2gWanylaE6FTOZ?=
 =?us-ascii?Q?ggWllMQCyWlJ+dbfV6TQJoOaR/F+xl7FCYDy1ZbgPNGxH5NkJA7yoRwSFPZx?=
 =?us-ascii?Q?L6AYbBV0REBYb22ZxmUUOODSEqDhtD/S3xPCcXPtgBJt4Ff3Fwa5njF4Z7sS?=
 =?us-ascii?Q?RFBNGVD+tKoGOo4jha4nWJSmPl5zYw9QgHn7i5gHuklyL/Mu9NTyuehxQQHY?=
 =?us-ascii?Q?lv6UfA1Rijd8Z6s+p8xTqiEp9WLoMvyUlqYS2+Wx6z1OkwnlzaUNdUAyxTji?=
 =?us-ascii?Q?TSC1/NAbhPazleBpPrgx6WBgSMhNGnwC6meSM8Ub/ALIIcd81UIuogfrBeXg?=
 =?us-ascii?Q?Y3VRsSue35YJqDM9RjxMghctwcPxTmyRqwKwSv/WGCtKUF+s8U3c+ueXEb+9?=
 =?us-ascii?Q?pD0IQrJeBuNQcwqD6IGq0P8MazTupc8bj3ElbVkKYvU5QqaXuEgpUgsUeZm8?=
 =?us-ascii?Q?drXiBMC5tCSOVWC8k7Ef2R0oukH+9oHAJx8GBMLGEsLirYvmPOT4H/TPG7gt?=
 =?us-ascii?Q?WvFrgtUoCFekwGeyVnRYU5TMTKx12XdXbXnOG8WZXrc2OseL9tuZvDvepyzW?=
 =?us-ascii?Q?tM0OiTDyeyqwo5C6TN5E0k01ZFqwv4rsmZNFNeREmt2Mxir2YJqcglf2CQaP?=
 =?us-ascii?Q?+ABshslJevuLKIk8xIHRjH12AWuJQCAWUHM7fuL+sQX7irNAy6hp5ED864BJ?=
 =?us-ascii?Q?WRW/Fsu1wD7UvhmwPIMyeu4dMMYvhITTMj1OJr6GZ+4h8ZNOW1LKE8wduk/C?=
 =?us-ascii?Q?IQo689WJ0CYZ1sW86R0kQ2X79GpWgc4RZjOrcqml1ww7X7b7v+Dngluf/wrS?=
 =?us-ascii?Q?haFCoqU/3jmDIbSgi1zdFqhRZyy7mSII8rWiMNDYdyIar4Jjz/+Tm8ba6bTp?=
 =?us-ascii?Q?CyHkg9l9xrMEyfY0WM/ajfTpu1A/q+46yCO6q6mNXhio9ECV86mo0n6b9e+Z?=
 =?us-ascii?Q?nmuBev9f9IPEnu9QHdA5iG7rW5V/fmByOCzzXdy+rE11kOcTDlrWyYd/Yl6e?=
 =?us-ascii?Q?fCLoE2LvFTDDh2r7VR8XUXuY7dZyGr2VkCIYKVf4p17uv7y+f9L/AsPFlgjR?=
 =?us-ascii?Q?zuj+HZS3e/h9ffdHtAiXVbQe6HuGN+mBpsRbQGzT3664UlKusPeELlOWU8Fi?=
 =?us-ascii?Q?Bk4NxaeM7jb/G39oTJUybQxCsAunu4BC1JhjoW/XEq2+0/lcLFybtRJ97x/B?=
 =?us-ascii?Q?o+TIB/gh0XZCHJMkgnZcWzCgtt05Ta9cfDCDvKXpfwRYZ8Wuq1Fp+SAnqdpN?=
 =?us-ascii?Q?ccRxZmgf97WbSApidLz5rzGHyAeQrD/OFEt0BfmY58Nc9j394xad4eVx4mRr?=
 =?us-ascii?Q?+qr+DVp9fciP5OT8HXGDdg0alfrxQWM8A1dRdlb99UcVteD31fBj//icRl7m?=
 =?us-ascii?Q?UI+E0TXdo/ZMjXQQpqiLghtywUKvhHKkeggfoXjfXZ9JJr08lXzNNvo+z0sL?=
 =?us-ascii?Q?fi2tPG8DBaC4XTJvaTo4F5JrSZbpMTtnZ+8T5Vdx6+nHKJXuYbngjWCDlQUp?=
 =?us-ascii?Q?eXov39jg7wSks6Umr9oL5E3mOIjL3+LvgOrGsFaxYaBa3/VLz+Ww?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee23dbdd-5a1e-48ca-729c-08da1e666521
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 22:30:35.9628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RaWtCsSYVAuEI+fu5MoQ+BBWJJYywu0aXIU710mqwzJUJfZbjuxS1v9xXTGePGD498JD76b5ddrj21R7dYELLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5572
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_07:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140116
X-Proofpoint-GUID: JCfclztuLK2th8LhaJczUXT3XIi7C5It
X-Proofpoint-ORIG-GUID: JCfclztuLK2th8LhaJczUXT3XIi7C5It
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

commit 55b8fe703bc51200d4698596c90813453b35ae63 upstream

Introduce a new FOLL_NOFAULT flag that causes get_user_pages to return
-EFAULT when it would otherwise trigger a page fault.  This is roughly
similar to FOLL_FAST_ONLY but available on all architectures, and less
fragile.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 include/linux/mm.h | 3 ++-
 mm/gup.c           | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 90c2d7f3c7a8..04345ff97f8c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2858,7 +2858,8 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 #define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
 #define FOLL_NOWAIT	0x20	/* if a disk transfer is needed, start the IO
 				 * and return without waiting upon it */
-#define FOLL_POPULATE	0x40	/* fault in page */
+#define FOLL_POPULATE	0x40	/* fault in pages (with FOLL_MLOCK) */
+#define FOLL_NOFAULT	0x80	/* do not fault in pages */
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
 #define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
 #define FOLL_MIGRATION	0x400	/* wait for page to replace migration entry */
diff --git a/mm/gup.c b/mm/gup.c
index bd53a5bb715d..a4c6affe6df3 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -943,6 +943,8 @@ static int faultin_page(struct vm_area_struct *vma,
 	/* mlock all present pages, but do not fault in new pages */
 	if ((*flags & (FOLL_POPULATE | FOLL_MLOCK)) == FOLL_MLOCK)
 		return -ENOENT;
+	if (*flags & FOLL_NOFAULT)
+		return -EFAULT;
 	if (*flags & FOLL_WRITE)
 		fault_flags |= FAULT_FLAG_WRITE;
 	if (*flags & FOLL_REMOTE)
@@ -2868,7 +2870,7 @@ static int internal_get_user_pages_fast(unsigned long start,
 
 	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM |
 				       FOLL_FORCE | FOLL_PIN | FOLL_GET |
-				       FOLL_FAST_ONLY)))
+				       FOLL_FAST_ONLY | FOLL_NOFAULT)))
 		return -EINVAL;
 
 	if (gup_flags & FOLL_PIN)
-- 
2.33.1

