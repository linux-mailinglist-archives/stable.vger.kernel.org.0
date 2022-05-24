Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A22D53329F
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 22:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241732AbiEXUuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 16:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241112AbiEXUuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 16:50:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99D8737A0;
        Tue, 24 May 2022 13:50:38 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OJT7E4018614;
        Tue, 24 May 2022 20:50:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ISxhDVlPxp/UugQFvW0vUmVQQcd+qDNUR3rDl2UEFz4=;
 b=pFBNUpuTP/WHda2X8XztA7bpSjQCAutBI5yNowZXs9S/AP2Gq64lJSCJlqDTqZR9giGd
 W941Y+HCoC06dSyWLbxqamEaKksJSKDmD/8+BTKUa7ok/CQwFzzMOk13dddBB/BJon3h
 WvgfPMq2Ss7Cri30MiwqIcToQB8hhNR3a0iIBRCw+k3sngUbSffzHb5TycpLDVlPQtsG
 wwA6PeVSArHZ6N7YBXweC0JPcvDDwmuWxVf/OjihqJ0pCWYEYhfulcD8bDNHg5JIxBry
 KGAGXNo72NAGlDvEdrEXL7w+JkMD0TR/zqt2rhuLN9PKGBbvHQORo5baS0JNCccXzi43 6g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tc0f7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 20:50:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24OKoJQS016791;
        Tue, 24 May 2022 20:50:36 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93x549d5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 20:50:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X5rvJJ4L/mKyTCyIJITGcoV6NyhFvhfk3eWCe9yQ4rrgPHrjva8PC/z7yQrgIE3aIDkQqZk03jDH5L49NmfaY570rxSO4FAcM8RJ0lqMvHWlZFA7eMDii3seqkswbtyCB/RpnbFVQMsUOfa/3oWb4vdfAkXv0FCBVD3WY00FtF+zwQz4xIiyJURIZSqtwKEAd9FGECzXb1lmtblmFieMx7A5CMbG6wrK3F1dI7ZowyQgo9yL/NatRsqCYsZO7rtn/TDS4F770NVw+pLU4nA6S7pVxGMCgarOd4kvIGatKzzZRsGwCfP5iPolYIOS9wCl4VUDEhen+DidA4z5CxD0Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ISxhDVlPxp/UugQFvW0vUmVQQcd+qDNUR3rDl2UEFz4=;
 b=YcdsxyoQ0XrYbWqaUcn77Wiy2er+mb76/5FJax2aDsdGfppcSQU+xlGc8NbArnyNxS23gca3ACnWS3/z1SIa0xtKo/+vvJPBYili4+FqQaPSk5aBz5vdCSrBu1nmQXk3QlB4Elh5gyXzqhs+ktfj98dEGLRByWH54GDmnJwvTIncjfMUTxj2OCglygHdsmYeW0DNPpuA2l+XDQWmZ+TEYZ4zKMXIw5XmChKN2COtyZyS5zcmb5PBdz4L/TyNiy7PP8x1P67BZpkznHOBGidQUFm/i9F9oUuNi+Rls3oAVWGu1Uq1wndaCKv+6vjzooHXXrR99eW4XNtgYXnyzazplg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISxhDVlPxp/UugQFvW0vUmVQQcd+qDNUR3rDl2UEFz4=;
 b=GCp/e3/g5CUhECLJ2ojnPhFurb1IGOnVdNi1XYIZ2qOPHg98Xxt9KDLyoWhn+otlPeOtTpcfJO7oY8Bs9mTR418a9tNiHbg4XoeERd+iwB064WiyeTgp5lrb/lqBrufGTZH/7qSueFSc02GgEmpPD/Qd7MuG98Bw5qDxvHb8x70=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by CO6PR10MB5618.namprd10.prod.outlook.com (2603:10b6:303:149::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Tue, 24 May
 2022 20:50:34 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::2125:9bb7:bfeb:81f9]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::2125:9bb7:bfeb:81f9%9]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 20:50:34 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>, stable@vger.kernel.org
Subject: [PATCH] hugetlb: fix huge_pmd_unshare address update
Date:   Tue, 24 May 2022 13:50:03 -0700
Message-Id: <20220524205003.126184-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.35.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P223CA0005.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::10) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5be55647-7911-4a82-d387-08da3dc70c06
X-MS-TrafficTypeDiagnostic: CO6PR10MB5618:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB561882D7427C01F98D2F246FE2D79@CO6PR10MB5618.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qJExZkxCp/t2Ms2dXtGdOdoatbMRD8IaQ+ZbOZFJp/MFFW1RpabH2mqVtrv7fEG7dijlToX1cjH5g+uGxPpbpZJOxYCLDPKQAbaq//WobgBu2ccWsbIGubYyMP1QeqjK1UPdt/ml0gwVWu0efvZokaD1VKSs/5eTQ1EYXM4TOl3Sv9yHeYRPkQ86UjZVC3EWLlpwILXKuvo7WnisSvuhi3iyVf4jH78/jtiNolxzjXrwQbsg064WVO7YBq8YymzAliBsmBYNsH4uXae2RI3EnEOUJAovETr/l5TQ1WQaJP3yCHAbBAYa83iAKZhMhBMzjd53ZR3eljvln01RA4nP3XDhR1C/5aLZRjjwvpVxlqizvOVXX+4npj8u082I966BdwpmMlyrMbvoWs0kX1OpAzO+KNJ4w2xZ/576/LKLzIR2vATSPhuOLHCKDOsih0sfWm9WLd6AtpRiiD1zN3STCDFHOaycnDCqGIyWWdzMcDsFINv4dEQw8lfhxV17CRVVkc0GflhnX/l0+Q4VImdcFUZxLwHu8l6YZ97cxSutbOzpLPlmmqyK6XVXgff563gfxEZ72JnLkZaBP9Wrgaz/hdhvqLhHuLd81Xr1LpjgP/YdVJBl90BH+ODMg6Iyuj/MGMnzuKtg9aVIrXYqINDymGRosdv6LDJzsFfcgD4skV04Lgk9Uhep8WkTPWZ4lbzMjc7dQ3gtf3GWsgNPK5WPtwCwEKsGC0/O17tfp9X+9qQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(6486002)(6666004)(44832011)(316002)(5660300002)(54906003)(8936002)(508600001)(2906002)(83380400001)(6506007)(66556008)(66476007)(38350700002)(6512007)(26005)(36756003)(66946007)(4326008)(2616005)(15650500001)(52116002)(1076003)(8676002)(186003)(38100700002)(14583001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?24NM6F7GljyWyM1yVJC4Y9bAynT9YuyQ08tW1ei16ZWckePZsJeo4JVoW+rQ?=
 =?us-ascii?Q?HQ3IFyx1tq5ZNkIgzo/6WMnwmCMuRWYK1pevXl1u2b38aPdKqmxDebx/GLi3?=
 =?us-ascii?Q?nnJNyFIq3m7vo1iCel+r+1EDhDJF7YZHMI2k166olwq3emaKJGrvaGLSV9yV?=
 =?us-ascii?Q?SYS9/XdpQJb+ZHxZPXjm2weMYzrdChHioAUGepIu6LLQqZxzpsp0xyu4deLj?=
 =?us-ascii?Q?BCtUB07VHfqeBg/xBV6li+wN3Z/rl1eAMSx6rZIIroNE3dwiUrHtN+FsyRcb?=
 =?us-ascii?Q?vMTdntgSYQ30erFoNMfoH8fNrqTmlxKSrYf1CTGRhXDSCkWR8T0nxLV0OP+F?=
 =?us-ascii?Q?QMRVeuudB3j02JoJtNmdoSME6UGwpxQbK3ugcld9/wuYDn//OfG36g3uTIpm?=
 =?us-ascii?Q?5VvQfmrll47F5aVzv1j44rpSPQ0tw5t1Ujd154/7LlSjrjFEnhzN42bjOn2C?=
 =?us-ascii?Q?lcFSWYn6b9bWnGYmbecIr0fAyNnsmI5KnK2lPvh7Zoo5cwwi94Zu1KSYaMgN?=
 =?us-ascii?Q?eBsoa5YAy95UeP4TWD/0enMNmKgDGQ/6GPgB9LzhDEyxNvq1No5BvMlM7PzR?=
 =?us-ascii?Q?AxOSNyg+dg6p5NKRu1v+UI9h+TByjujxfh1TVb0IzqsDeHGnLLSRj7bEf6Lz?=
 =?us-ascii?Q?bTO6F2RekkZajwyOWhwijSDPARrQpJA6gh/cpjGca74ww/mT6mF8e8D3kuPb?=
 =?us-ascii?Q?t5dyBvnEuyalyMkIMimQf+zd5vBj14kNWL6ah9pq8MNWMB/uIiVuX3qtRIGK?=
 =?us-ascii?Q?Lev9KiuZIbBWN6LkhSpwN1M1vf+yjBvCS3jfZaZRTvyEmQZ5K6bewo24PRrf?=
 =?us-ascii?Q?h4L8Znn9pJ2lpf0dMTC1P7iWfLA4xijeaaQ+8OkHwNiRlvASy7jeAfjXcdYN?=
 =?us-ascii?Q?KmZT2RLdqNNDUJJ/cFeNJI2Zr/dKQo7LYSD7C0ruyl1FYQd0xIojvJ8rnNx+?=
 =?us-ascii?Q?6ZsHfMdO4sep/YMVe7oR+vTpQ76Ty8Y45H8RC44FzYMMx3szYJ0W02iowmMI?=
 =?us-ascii?Q?vp7r4EWCWUMZWx9z4czIbadvClEeG5r+edd070ClQIciVhV5FVnOndPMU6Ol?=
 =?us-ascii?Q?OQF54IXdkTCnAj4CEOEV8ep9TJzRVN/tJQPerAGh7XuM3jePhkYXGhDjsNZu?=
 =?us-ascii?Q?UU4eE37hjVGTa+ECMNgUhgNgtzDaDMphsoit9K6+jxskA9iAm3sA35in835b?=
 =?us-ascii?Q?9UeHqwyaIiTNKr6/1xZxKp7HDsw5MEiDsrU/CgTYQ3AzJeEVL9uvY/IW2Xuo?=
 =?us-ascii?Q?kwjh4N2tM1tWCSDM7NJtijiQ6HFSVF/azyeW0gwk1toahAwD4PdiK0GhEt+k?=
 =?us-ascii?Q?Pnkn69sNt1hRdPIj8esOv3zAFH5pwy2E9slOnj8vPePLt84q0zdPThj2p3Nd?=
 =?us-ascii?Q?FGYY/Ay+4G+C9bGvWTb77Uxx4ttIBF+DFVGFHisNhI8791p5Z7SyUWkOdI6F?=
 =?us-ascii?Q?LErYPDFEmW8bPeTXmFRoJ721j3wNYGpzjzJ3dFUJ2FEQ5WhY4f8JlSfOxuI8?=
 =?us-ascii?Q?UbWa75SHt5ViR5glhM1J/sq6Y3WchMXNzZsyqtETocI2ngVGGRjNUcJyRbXq?=
 =?us-ascii?Q?8npgraagTXpfGP9OFZt9GNa919Bvbflr9vnsq8/I2+aofsmMwgBcukLLoBC9?=
 =?us-ascii?Q?uKdF69uMMzvHfucdGOiwefE12oE9C7hfF7J7BUz/vJxvBGxn8QSas8Gg4mFq?=
 =?us-ascii?Q?+uzpQy7X9xkHv1AkUNh599tlN5myoTDDpfgEwDKL4nOkmIy4D5gG2RwS6YpS?=
 =?us-ascii?Q?MfJLbFweRN8xHqul1PMGxcGf+OXqc40=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5be55647-7911-4a82-d387-08da3dc70c06
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 20:50:33.9827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w3qtrAidsrr2V8OoHPtJti6yoPjDVchHRilpkyyZuzALsZ0V0UGBPask6K021/oGVXoSKDEt0nkdTDNcNUuxVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5618
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-24_08:2022-05-23,2022-05-24 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=820 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205240102
X-Proofpoint-ORIG-GUID: 5l9193N3t5EELc0hV_JtXyCrDR8iqoBQ
X-Proofpoint-GUID: 5l9193N3t5EELc0hV_JtXyCrDR8iqoBQ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The routine huge_pmd_unshare is passed a pointer to an address
associated with an area which may be unshared.  If unshare is successful
this address is updated to 'optimize' callers iterating over huge page
addresses.  For the optimization to work correctly, address should be
updated to the last huge page in the unmapped/unshared area.  However,
in the common case where the passed address is PUD_SIZE aligned, the
address is incorrectly updated to the address of the preceding huge
page.  That wastes CPU cycles as the unmapped/unshared range is scanned
twice.

Cc: <stable@vger.kernel.org>
Fixes: 39dde65c9940 ("shared page table for hugetlb page")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 mm/hugetlb.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 01f0e2e5ab48..7c468ac1d069 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6755,7 +6755,14 @@ int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
 	pud_clear(pud);
 	put_page(virt_to_page(ptep));
 	mm_dec_nr_pmds(mm);
-	*addr = ALIGN(*addr, HPAGE_SIZE * PTRS_PER_PTE) - HPAGE_SIZE;
+	/*
+	 * This update of passed address optimizes loops sequentially
+	 * processing addresses in increments of huge page size (PMD_SIZE
+	 * in this case).  By clearing the pud, a PUD_SIZE area is unmapped.
+	 * Update address to the 'last page' in the cleared area so that
+	 * calling loop can move to first page past this area.
+	 */
+	*addr |= PUD_SIZE - PMD_SIZE;
 	return 1;
 }
 
-- 
2.35.3

