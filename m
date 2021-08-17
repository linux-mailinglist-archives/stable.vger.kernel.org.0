Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB953EF4B6
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 23:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbhHQVMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 17:12:42 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:60342 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234843AbhHQVMi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 17:12:38 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17HL2mQ1020659;
        Tue, 17 Aug 2021 21:11:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ERoa5rS/n+Hla8p9cz5ajnPWMKvOvimPPA/+YLyZZyE=;
 b=OCKx7o7oSBTkF0J9/HJGjAWe01pbjOxrG3InxIyfRZfXew6DBTg9G+bKztjbCPPg4v+W
 TMpW6bMx3H+6mBfgPLPU9fkl3ps1IG091SCv26L5a4Ai+Q3jxdyamUpra50Ft8nXDv+o
 PjMU0rFlL4Hg+e9ueR+yD8g0FXUgkF3MXUc60Osm14kV66xnXI8+inMDeRu252ZoBfqW
 kKxMiW5XaIN+xPvsdZGkqT4Og5TBd55qi3bG2Cd9q/lKKWJFIfhCnVJ/ERXHGu9mQyiS
 RveugEQkGXHwxc0MjbjmzmWBdLTTldiidRB+GIeNayBe9YtT4k5pMbYaNSrIhwBbYmzN 8A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ERoa5rS/n+Hla8p9cz5ajnPWMKvOvimPPA/+YLyZZyE=;
 b=JYs7pHQZ3NCN70h4GFBUQoHaU8AdjkTJGfgO51K9nWANuYRd6HSNRRegJApc8WYtbg3B
 sHcMRBNFSpNp63ITgoRD/qQeQmm8LKb3qLYJHWSEAEmVLjVPoI9rOUHGzJihOuNqwrMU
 RRdGryvLltTicjdRGd96QjWbvRWYgPZb32GsgrMxw+1yJoCI09M/imlkuKp037jUkuXt
 acG8z2QjHoCkTtxnuEsc7WbpXBD6JKuDKZXaPiC3Y1dW60CJiZAUeIONyvfaYLJLxvr1
 2n7B+mns6CXCJyHPR2HTpgC2N/NhtNo+LcwpFH0HsaUQz4lZqVwjLcscAivPJgKU82qa WA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3agdnf19jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 21:11:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17HLAt0l171107;
        Tue, 17 Aug 2021 21:11:58 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2046.outbound.protection.outlook.com [104.47.74.46])
        by aserp3030.oracle.com with ESMTP id 3ae3vg971c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 21:11:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HfSDYk4OB4GWioqWG8fEynjmWo28LJ1UUmADZPnu/jLgESQ3/CBr8OFssvpUgYYZBmUmG/GZu8O2EnVq/uRd6efwMfSyOnfgm3vnpajxSZ9syNDy22ymrL5folCuMGTzCmw8dzUJmoErdZSmN8+nDtc5O48/ld3TmewinRzHtPJHJf1NG0uQ1qocKkwfnA5c9c+r4zsFosQyKq8hxOEBrIabMNz8eOlpS/NWGTkSZpolISKhmJEu+AzdYGCpygdq/FxeMQ0EZH6VBBDdTQWuUN8D8/sCb9Y30wx7VvF2wxQrE9E17FDfdiRETWszV9W702B/KLq/SXQB2uiOWzrWQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERoa5rS/n+Hla8p9cz5ajnPWMKvOvimPPA/+YLyZZyE=;
 b=U6FMg9tdpK5Ws1fwFae7ILGpGG2ukGmuCJ+Iy2gojRKsCN3m0l05jrXO0tfwi+V0BGwFguQgzO4AJai3R4nFbw3kpj0yFTYoyaaau9NPhB5zollpGQ1unNuugtfgkVulyxZHMNhiAZ72Aq7ScJcsTQ5hDBFmiwTQJUWlZheOzD/tJSzoxz9dvhtFnMmwEloh1vWK9KoEdmcK0EyChZZQbOUuWxVhEIRh5abmQc3g4YlHpbJlRfC1pEIxZ+dQwh6YQqC90AkKC0M3dFerrNdqhI7pOptkj48CBTJCdapcqCBCaKRk+9fbil0ZzULgBAqxDEXywQWW/vNL7kvwmhhGyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERoa5rS/n+Hla8p9cz5ajnPWMKvOvimPPA/+YLyZZyE=;
 b=Xt/YQXIo/yA6JumBkbMXIjLvT3iLLI4yubjJiGjKjAW9v8LTDsC9Ds/4jmp7hlvTAVsOF7GSnr7EcYiEV/w+zUvPg5EQO/1W9Oe8JuX7bGifVRmY+4BBqzjC+CILe3OVMT5zq2+924SumzWRNsxRrHt9CNB16wxDbTYtk+h3na8=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN0PR10MB5320.namprd10.prod.outlook.com (2603:10b6:408:12a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 17 Aug
 2021 21:11:56 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4551:a5b4:f2ec:daf]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4551:a5b4:f2ec:daf%7]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 21:11:56 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     george.kennedy@oracle.com, tytso@mit.edu, adilger.kernel@dilger.ca,
        stable@vger.kernel.org, dhaval.giani@oracle.com,
        dan.carpenter@oracle.com, linux-ext4@vger.kernel.org,
        riteshh@linux.ibm.com
Subject: [PATCH 5.4.y 0/1] ext4: fix EXT4_MAX_LOGICAL_BLOCK macro
Date:   Tue, 17 Aug 2021 16:12:11 -0500
Message-Id: <1629234731-20065-2-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.9.4
In-Reply-To: <1629234731-20065-1-git-send-email-george.kennedy@oracle.com>
References: <1629234731-20065-1-git-send-email-george.kennedy@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0021.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::34) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-152-13-169.usdhcp.oraclecorp.com.com (209.17.40.42) by BY5PR20CA0021.namprd20.prod.outlook.com (2603:10b6:a03:1f4::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Tue, 17 Aug 2021 21:11:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3bd9f86-69e2-42ba-2984-08d961c3a4e0
X-MS-TrafficTypeDiagnostic: BN0PR10MB5320:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB53204C7C6BF97689CEB13733E6FE9@BN0PR10MB5320.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:206;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6vjZqgGGJZJRgSqy8HuAOQASjA68miBDT2AVPI2gMbLoCrlLanASDbAzjNCcWAPONJ+S30KO1uIZnKKGfwNkazIzFAXhw9hxp9jrlgquvzO/r1BuMB2HZUv15fDxplj1F2oHaky6TThiFnDtf+U1Dom9P7cAekNHIN1NkNzvKB96hI7koqEfHmySi/42GARIGjXUiaJ3x8slMJUVn3SsjtVluxaQ9vGlQqab+zWfZlosOl2oZoPfQiZ061IwLUeHz7o5/EttTMlXVMDGvPdrMBmeP+Q+lrOxGMDzu/H98ytB9tQvu47v+/0tGHLex4A4Eb0jHgQ6ub7ipHBYWn50cX8q462uDdqt+IaUmnP4x/g8fcl30/hkieFxaOmgd2815Nx/gVgD+IZ3Y2SJHuwvBYr+JxoVm9lRQaCm891BNb1AKrLn69ofEWkylKIMhLYTnTpLfg85sinPTJeT9CSw+UtuvfaNEvdDglllCrs8nJVH1QUK3pyvXPgDzF6TBxhpAaisyzhkhXIFEgUwcqn2mc8SvSQxSfF8KvD/hjqOhPAFtMeQ2dXSFdPmaCedRDVa8GQsys5N2Osdcb9u82e0H4SEi8crAFTGl/8BvZERK+YuRA61zq/cNow0B/eoGjsoUoYQBw9sWNmt0rr6jDMun761ReR16294t7ovJo4JUVn678YQYXsdRUoMvWU9CobXMbXvj9aJcTAwf4qWPpStibU2cCwlFmP9IAiazUpuu+1iDDx6j0XhVC5trYQzaRRzFKfTYc0GgNFirAMFA6nxGBk9nPI42GPnfuml8k3sMuM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(376002)(346002)(396003)(66476007)(36756003)(38100700002)(38350700002)(2616005)(316002)(66946007)(8676002)(956004)(26005)(6512007)(83380400001)(478600001)(6486002)(966005)(6506007)(66556008)(5660300002)(4326008)(2906002)(6666004)(86362001)(44832011)(186003)(6916009)(8936002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OTCLVB/cnl1jUYO8J57DSEOQ1xPInBHvU+T9HjXiwTcg5IosXJWdbtsWzMtV?=
 =?us-ascii?Q?J6xJzts0JFO0EN8lw+REhD7UaIGrmLLemmdgLL1Mj1asHRasyLIlwBcTSVwr?=
 =?us-ascii?Q?XN2llGFUmDVWjSC8MQZyLRG4CcOLc7JLmVpDqzsx+VpBiOk/+FLT/0+Cfa5K?=
 =?us-ascii?Q?OjPPezLuE4GetFAIOZHbzx1vV9DE3FNmfbxuub4j33Qor0wtGhgvPoenYmpz?=
 =?us-ascii?Q?MRuXJAEN0+gLDxOKt04HOvNjCVqD4zv/+B2zOYcx+zYSpc4+l7H0HjgHKHUm?=
 =?us-ascii?Q?8vKEnpb8S744wOexZ6NctE1z/JA0aIiTPAUxPuBQKWKW34loTufvAQ+OjGmo?=
 =?us-ascii?Q?dMcajyAE9+CZHbtTbLM30l0ZWPwLGGqXrFqdvZEmuRbl7lx+P+uqMIHSvKr7?=
 =?us-ascii?Q?OUc+F/ZtePnQtTYTUDr6t6IU2O5osV3mxI4SV4iTJT91bhL5S02ETux3eGW9?=
 =?us-ascii?Q?JxkxblXFbKH4PiufLUkw4WWqa3D3NDMkCLGGzGSiuMgkovA72XNzw1ub2cu1?=
 =?us-ascii?Q?paYFbRRoTZvjnnJqnc8I0XFZbCHuboXAoJh6ZwJgxEY5UEF5ED0/d8+oU1bb?=
 =?us-ascii?Q?6fTODAupb7EOgVDEuRIW0QWiDC2tqdeRpBTX3ffDY70u3z8yrSH79MXWJTPs?=
 =?us-ascii?Q?z+tmJOaJS6J/OFh1I1mk4tzpzle7yMdoN1i7zdC/AGs9+5RagY3eS/n7MJuW?=
 =?us-ascii?Q?pmHktrBxReiXKqM7/m3ub9QIyqZc1ilp91F1a36ZWVikIUHm4xxSBqxRnWAR?=
 =?us-ascii?Q?1n19bRnWwpjARShigVu1Ii2I0Sc6wYxkZz6WabXiUITwHV9pUlfp9auK9Z6F?=
 =?us-ascii?Q?ccTw5B9umtT0cEluh+/9kD+X/9KkOTCpr9gclA6WAi2eI5bWzyFfSr1UgH9i?=
 =?us-ascii?Q?qeWsqs6WF+PsuY1wy02dHemfYfCJG5Bf+hkoRH5mjYOORg/au5rAB23T04Et?=
 =?us-ascii?Q?Yc/YPOwVXz72o8cLphOg10ua1+e/IzFnkyUmm1iflSu6CAXwbQCPuA0myEvh?=
 =?us-ascii?Q?j/3s0CE0zgf4K2J3RMQCTshk3vw1V/LqiokidqFWzfPkxfAWp/WhSNp1f0AC?=
 =?us-ascii?Q?pcKPEmLIYv9O89a9pkGyA4AnrMJ6iPo+EUT/qa1m8wgVf+5wn3xDX/ICGNjs?=
 =?us-ascii?Q?kdnAQ746pae2o8QeH2+kBmoDh5kPCg8elfvvt7zYiImATZwWU7JwcpOY4dg3?=
 =?us-ascii?Q?O7ZkrgmMeLqXSJOY00wbvJgKq/vlKI7ksaZ7PYhDZuSPjaF6i5g79bs1RJxA?=
 =?us-ascii?Q?PUirc0c5EuigC5do8fdVlv9YuSyUu7HyllATVZGXR3mxrqEgM3VjMFnmX3kT?=
 =?us-ascii?Q?XJr9Jg6hGkqsYMKQvWFJ22CF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3bd9f86-69e2-42ba-2984-08d961c3a4e0
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 21:11:56.3750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w96lGFV6Tw3yJnrz1y0cz3EAWRyCUaRl5MDFDAZIK+V0fKjePn63ZinS/Tp/ppkmNtiQlORDaKvBDeJQYC+WSwLicZLrhjw61BEXZ1gt0g0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5320
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10079 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170133
X-Proofpoint-GUID: _E1QtmeesnVfShh7xFQ82oChIoKwumTO
X-Proofpoint-ORIG-GUID: _E1QtmeesnVfShh7xFQ82oChIoKwumTO
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

ext4 supports max number of logical blocks in a file to be 0xffffffff.
(This is since ext4_extent's ee_block is __le32).
This means that EXT4_MAX_LOGICAL_BLOCK should be 0xfffffffe (starting
from 0 logical offset). This patch fixes this.

The issue was seen when ext4 moved to iomap_fiemap API and when
overlayfs was mounted on top of ext4. Since overlayfs was missing
filemap_check_ranges(), so it could pass a arbitrary huge length which
lead to overflow of map.m_len logic.

This patch fixes that.

Fixes: d3b6f23f7167 ("ext4: move ext4_fiemap to use iomap framework")
Reported-by: syzbot+77fa5bdb65cc39711820@syzkaller.appspotmail.com
Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20200505154324.3226743-2-hch@lst.de
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
(cherry picked from commit 175efa81feb8405676e0136d97b10380179c92e0)
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
---
 fs/ext4/ext4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bf3eaa9..ae2cb15 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -718,7 +718,7 @@ enum {
 #define EXT4_MAX_BLOCK_FILE_PHYS	0xFFFFFFFF
 
 /* Max logical block we can support */
-#define EXT4_MAX_LOGICAL_BLOCK		0xFFFFFFFF
+#define EXT4_MAX_LOGICAL_BLOCK		0xFFFFFFFE
 
 /*
  * Structure of an inode on the disk
-- 
1.8.3.1

