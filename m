Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478866DC867
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 17:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjDJPX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 11:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjDJPX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 11:23:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACE55FE2;
        Mon, 10 Apr 2023 08:23:52 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33ACtcLw002874;
        Mon, 10 Apr 2023 15:23:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=1xcHzjTMWXUeimgvMQnN/jQSevjGbl5wl5ep5zX58W4=;
 b=i4GhURrwGKZeGMJLT373Dh5jwkdNHehLyL2VF3wxmUAJwF20v3wsFSYMJhG7ZayqMI5i
 27K4Yob1Cf1OnPt1rSbZN8bZxwcbEB8dMeAwXi5j/bwh1/jkBnvCWD3O1uaFe1SHAlLq
 MoS+dilN9Hr9lzp31d8qy42YrRio23J8eskXZbOoMkGRCvgf+9ufQk9lKUcDu2LMboBK
 7tGlDF+MbBbVuVih42bC4f9KJvQQ4Blc7ih7626ojXgn2cHr55Ttc7DZyuJaW/yD4kaO
 gfwfNu551R8cspaPv/jKPO6MwchSM4QpiPjJqewA3AYDWuDY4fKMDiCOp50IR32yannZ wA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0eq33hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Apr 2023 15:23:46 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33AEUqRv032745;
        Mon, 10 Apr 2023 15:23:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw8ybjjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Apr 2023 15:23:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zr9EvRt6C8uNRRpsyfpSqOgnXHfOvbt2UxXyYB3HjzRlOYzqKFcRWuHeFmbbIeGWOsPyo26M6ELB4+4860+BwFErnVl95ct29MI/nJo2UWrf3f3JL8quvVQhmkNyjJMH6dPf66tqPiZK3WmVYpvEp2T7nH0Ue4j0cFoOsHo/y36uUUPYykD5q6WM19m+/hmOU/Fy1oDKsPkd6MjseDhZfCgRDpvG+dj1mlhgG6BSrnZRBDkVK7OSPUQkBbByNIpzVrMmmCwdWFrSfMBkX8g4/5LH6oTMcjxZsi4JPX4g3FU99rIy8G0bP9+S0ZX+X6X9rQqnDbWwjxRx06V3cGltqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1xcHzjTMWXUeimgvMQnN/jQSevjGbl5wl5ep5zX58W4=;
 b=ehR6fJhbQ6nWbkTo5v7wmt2hnpKVOMYFDouHN3UDTCvNxUWSBYRhsucZXBGbx4XW/aBDqZChgzkF57OmrTes5HackAo1rznYR3J4rtNpUH+aH4QnR4iPsTPurFvZz3EtBgxrREornSp38wVgDw4Y1uAnLZrxxQ9/apim+cjRqIoGMEJ2mC4kUhlP5HByNltg/XQAwsM7XsGQnWHh0g/CpO+IXxI3kB2ygTsI2rxgGe8trRMfqBe8GlsK18xxX/XFjsw9hxuU7mbqEvhGYPnjCJlHBmwY/9Q9wYp4emfP3iBnPLRdZmklWh9D27pozk5tLnNB+lwK62u11E8CFvLVoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xcHzjTMWXUeimgvMQnN/jQSevjGbl5wl5ep5zX58W4=;
 b=XcOTzkmEu54cC/+kldJYZttjH4uBEAtA99QhVsCdcbnpP+Y9G9eudltS4XeWhi+OnvSj4bMk6AYbGpdBDNC6dEa4VS7oHyxVdDd2pS2AHfIFsCnYtldwtibbjLUxzyuL7pmZD9zgN7Vtn15wnYYUOqH3p2e934zKmDUIgBMNWH8=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SA2PR10MB4571.namprd10.prod.outlook.com (2603:10b6:806:11d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Mon, 10 Apr
 2023 15:23:43 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6277.035; Mon, 10 Apr 2023
 15:23:42 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        syzbot+a7c1ec5b1d71ceaa5186@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: [PATCH] mm/mempolicy: Fix use-after-free of VMA iterator
Date:   Mon, 10 Apr 2023 11:22:05 -0400
Message-Id: <20230410152205.2294819-1-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0036.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::35) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|SA2PR10MB4571:EE_
X-MS-Office365-Filtering-Correlation-Id: 1644e888-9512-449a-7d1c-08db39d791ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K700GTOZFIFDQCpi4pEHT4xBB1YV91Fd8/veHFZwC40TvfnCdfQYoD8lBcBiAp6Pdy96d0HQtmzC4n01Bbl/ndX3ACHa29FWaSkLwvAS2AdTxDgBwhCYmcGuSLjNB9v4Yc7xWWVdm6QbtYOn8eMp/NBwgX22wvT3eC3GYCKxA15CUM0gpfCk6Ko9Bxfv4ICNvMD4PBxMKqFI73IAgb5UGX9TIcDs2Gz4emT3P/lbuUFrAk7sibkRZcolBqGxlu1P8DNOqoySGTAcuLlCN6Sr0HQy4zsoTApXkgKlci/CxSd6EjlawaawY7e6Q04+QY+7DmZbm5DuL0Qlje6AKZhQVbRB9xJmd0SzrOuE3+w3OsgCCixxph8Cw+YwaPjPGrsloDnQ53gjPXnrC1uUKyDdSswG4BUKcU7y1e9sDHoZFP++VmmBsWXOPvt8dtQwan9srtHuCSYJ4ILWAjGDxJQKRHePdeVVe9P0ZcFUxRFpHBPMQBgDs7gO2hPfAc74I1B2a1+n3LJoHL6tcNRHCPnno3CVqdT0nWm4ReOfuKVUzMs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199021)(86362001)(36756003)(66946007)(316002)(41300700001)(66476007)(66556008)(478600001)(4326008)(6666004)(6486002)(6916009)(966005)(2906002)(8676002)(5660300002)(8936002)(83380400001)(38100700002)(186003)(6512007)(1076003)(6506007)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9PnESerhRc2D4MSWOaakCFJuKpUemmQ893+vm+pWFCswO45JQsWbMvdAtKXn?=
 =?us-ascii?Q?pJmOtTMVQvEhGD0rdmMW6YOIWdwSI6or+aoVc3ndZABH2IwqLY0jj6kL+EjJ?=
 =?us-ascii?Q?3cOnmWFWnFvprlEDB9rf1T9o5r9A3JfccnYCJ89FLtChJIgehOtc9XrtD4e9?=
 =?us-ascii?Q?VWnASrbQOTAN1cGHPev/lrV0V0rytuSx7GCP1AFp1IgyyJDSSgf90Y5p5s/L?=
 =?us-ascii?Q?fcSLPVhHai25dqecOkXLyytij4/NG4HhKmSxfqwOQpVDdw49fpIVBxFTPFdB?=
 =?us-ascii?Q?TKgYnRIF+yvAQexAVxgr98iT6882ILits1sustAzajvXjEUrlCQsGdfx9Wt/?=
 =?us-ascii?Q?0jifr4CY5Pcb/wIZ4iKxTU6oUHoLPkJ10M3OSDDvimBsV2WFvwX/N+ns2myv?=
 =?us-ascii?Q?AuT2R0Sy9flGRZUBDdAl089GYExwwfvn4n/iKfPyoYltBgAexKzJ23RfN1Bj?=
 =?us-ascii?Q?szmhawtAaU48EyDt53YTDvjPdzMmTo8YXZ/7gWZeN43KpdWTvW6zJkOtJVfv?=
 =?us-ascii?Q?Yog/OHBNAPeY3HDXojNGLUBAyOyHm64CtGOFL6FpYBSxakl1Hnt+sr1imNQR?=
 =?us-ascii?Q?U/CZLobnY1lpE1WK599Dt8wQkvFwm0GOWhv9Z2z3qP7EcpYzzT2++nNRifdx?=
 =?us-ascii?Q?qIhGQW9xEto6etPpivp1VNdvYhZiJJ7/a930LZIVANeK7CuvN1/CiMev11hK?=
 =?us-ascii?Q?hGfRVzt2wouFc0HOb9e+jCBD7ATmDT31saaUXJ9pc2g7ncAUeEXP3fxSHCQR?=
 =?us-ascii?Q?JS3SKo7HVKo6xOUsux/bx7VWKs8v3DGS3cWZ7DJw6J5mrNwsf+t0YMwHvTuo?=
 =?us-ascii?Q?oz1v8VQst0mG4Opa59ldCMwo0qOn5OXn2+PgkuLga3UI9y+b8sC/JRhHD3IY?=
 =?us-ascii?Q?CF+q7S7HnmCdRuR0GVmspkRUugG1M/b4rA42jZks6EipyDJCexNwn8UAp8LI?=
 =?us-ascii?Q?2XQ/9quWkfYe3uGCRRUJn3nJzBlqxrDOgBcnoWDCsv1NWCI0/tqmFB0JgZf/?=
 =?us-ascii?Q?nyfte7qBnNl+mtoG61DtTatylEx40ZZlAOa38OgGLyH+N2q+1gi52D38bm89?=
 =?us-ascii?Q?2hc8j0N7atvaY2eJIxozFPtoAHA1Mk3yHzYnUAKbDYtu1OZw7Rb3KFMEkjLA?=
 =?us-ascii?Q?/lP2V9rLgSWsn/+7JXIg4TerqDHlSwYqtS+CbNXiGvUfUgaDflYsy6NVUbja?=
 =?us-ascii?Q?7dzKY27lq/BlopdC1E/WLUl6ObSqMDcitt3qEGS39nZum76yEg/SptZaWk2v?=
 =?us-ascii?Q?J+c9UWXUQauVA34wVTCujwN5L9ME5dVls4Pm09LSvwWG3Ho2GZuedo1KPKzJ?=
 =?us-ascii?Q?0EUWEZKtgPw5YkgmRo6c/+GmV+0vm8sf+4a5Cg7ZY92mlrrcQrKUaW0AdPDt?=
 =?us-ascii?Q?Y1EbSi2BQg3d4+EZSjPt8zgkrk68iCUe6ChxJmWY16vIXqe5Q72WQ+27lam6?=
 =?us-ascii?Q?WhS0A37mUKQtmfKrUCx65shlfdbexH4PgRKg9Q7WRGgQvJjgA6fi+j8O3Qm9?=
 =?us-ascii?Q?868OAhLxi68GXa9renZgHX+gw9DjyaE+4CORMMeuqXpgGpvVngJyn3xp8Ju+?=
 =?us-ascii?Q?Af6N7ZVOxfPrZNnGGAaJ+1ezHMzHDQ7FBvcvQluoUfsojMw4/7AKjvakJ9Kh?=
 =?us-ascii?Q?BQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: vckqn3YoSS3L2I3feZcM3CofhwEN/l9WNcq5hGx0yk9V0o38btdUmtBCd39qYMi3YUPnjHrdm31PKN3kLZ190ijP71bfmVp7lanwTzRZ2XxOconD6Jv9D96jvVtns5/Clw7Ku4kKqlw40z8mRRWcmCwJ1pr44oQMQK8sUzVKl557QMUHOI5wPududEUbwqTpeLNz1wngVOawNbP74LE67JvxTdZ6R+EkuXExChs/dLXgQAhEsvn7+f+J6DUOgrQc0kDBnEwwaBxxXp9qBDVeaFHzQjvrXSqWY7LBa6dPdPL8T+D3V1ErAdHTwFeaKPBkCDsEGMundxDetsIMd6fv170nvCHA7bhxosuhRW2Lnyv0akE5jojkXWlME7A7k4/xYAY7hf8iMGsMsj6bZcTmwULUVWRJU50yvD05p0kVtsQcL4Idt+k3uQi3sUYdwT/l8lIewWp9xpI0g7h7vRxm/QSGT0pltNmrLFiX8J7o0UvQ6X7S3mRVal8TxQj7OCXxnTs3QzulqzeS3XAZAufJpa1HehyOQJS9Jhdzkj6PkeBg252QCJKc8rumLiwiB2M2pxXWhOWzg56RjHWv2GcY1ybhsFKZS1NO2bQ12Sq3+D4rm2989Ay+NKOGXp3pAzp5h5yJ9oIgzyKlFTIM8oe24/5dXkQFpFuTU7zrIALATT/GJiqarriUdCX3V2CzZ9jLLhykfA+8JB0o4R/kgjl/VTQ7ggvCDvx9yEgkNjllCyz2AkwlCvfe7p8GLuU/oRcOkzMGpIYtufVqfqv/LPEZm+fIxRHkGM0hCXXBY8tmpZjHHDOjHmuQIdMIRvPVbDv035EHf8WxklnCK5HR0kgAKk+5+BAsggEpAoO03a4fby9QNw5jFefZdJ3vszQ4MF62XAEtYMHbom8kWxwaA6jYjEay40PIpBYRtzntL6N6Ifg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1644e888-9512-449a-7d1c-08db39d791ab
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 15:23:42.8997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l96+sdTOOsFvfW58sL8Uyt5e9imlotakvaNJeKBHb1anHorquscygo9VnOsGOm/L7D99eeCGdezlEF/ERMEKnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4571
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_11,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=899 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304100131
X-Proofpoint-GUID: cu4RXvOM3q4q6SmLDvUXFD9tFOG1SWM0
X-Proofpoint-ORIG-GUID: cu4RXvOM3q4q6SmLDvUXFD9tFOG1SWM0
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

set_mempolicy_home_node() iterates over a list of VMAs and calls
mbind_range() on each VMA, which also iterates over the singular list of
the VMA passed in and potentially splits the VMA.  Since the VMA
iterator is not passed through, set_mempolicy_home_node() may now point
to a stale node in the VMA tree.  This can result in a UAF as reported
by syzbot.

Avoid the stale maple tree node by passing the VMA iterator through to
the underlying call to split_vma().

mbind_range() is also overly complicated, since there are two calling
functions and one already handles iterating over the VMAs.  Simplify
mbind_range() to only handle merging and splitting of the VMAs.

Align the new loop in do_mbind() and existing loop in
set_mempolicy_home_node() to use the reduced mbind_range() function.
This allows for a single location of the range calculation and avoids
constantly looking up the previous VMA (since this is a loop over the
VMAs).

Link: https://lore.kernel.org/linux-mm/000000000000c93feb05f87e24ad@google.com/
Reported-and-tested-by: syzbot+a7c1ec5b1d71ceaa5186@syzkaller.appspotmail.com
Fixes: 66850be55e8e ("mm/mempolicy: use vma iterator & maple state instead of vma linked list")
Cc: <stable@vger.kernel.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/mempolicy.c | 104 +++++++++++++++++++++++--------------------------
 1 file changed, 49 insertions(+), 55 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index a256a241fd1d..2068b594dc88 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -790,61 +790,50 @@ static int vma_replace_policy(struct vm_area_struct *vma,
 	return err;
 }
 
-/* Step 2: apply policy to a range and do splits. */
-static int mbind_range(struct mm_struct *mm, unsigned long start,
-		       unsigned long end, struct mempolicy *new_pol)
+/* Split or merge the VMA (if required) and apply the new policy */
+static int mbind_range(struct vma_iterator *vmi, struct vm_area_struct *vma,
+		struct vm_area_struct **prev, unsigned long start,
+		unsigned long end, struct mempolicy *new_pol)
 {
-	VMA_ITERATOR(vmi, mm, start);
-	struct vm_area_struct *prev;
-	struct vm_area_struct *vma;
-	int err = 0;
+	struct vm_area_struct *merged;
+	unsigned long vmstart, vmend;
 	pgoff_t pgoff;
+	int err;
 
-	prev = vma_prev(&vmi);
-	vma = vma_find(&vmi, end);
-	if (WARN_ON(!vma))
+	vmend = min(end, vma->vm_end);
+	if (start > vma->vm_start) {
+		*prev = vma;
+		vmstart = start;
+	} else {
+		vmstart = vma->vm_start;
+	}
+
+	if (mpol_equal(vma_policy(vma), new_pol))
 		return 0;
 
-	if (start > vma->vm_start)
-		prev = vma;
-
-	do {
-		unsigned long vmstart = max(start, vma->vm_start);
-		unsigned long vmend = min(end, vma->vm_end);
-
-		if (mpol_equal(vma_policy(vma), new_pol))
-			goto next;
-
-		pgoff = vma->vm_pgoff +
-			((vmstart - vma->vm_start) >> PAGE_SHIFT);
-		prev = vma_merge(&vmi, mm, prev, vmstart, vmend, vma->vm_flags,
-				 vma->anon_vma, vma->vm_file, pgoff,
-				 new_pol, vma->vm_userfaultfd_ctx,
-				 anon_vma_name(vma));
-		if (prev) {
-			vma = prev;
-			goto replace;
-		}
-		if (vma->vm_start != vmstart) {
-			err = split_vma(&vmi, vma, vmstart, 1);
-			if (err)
-				goto out;
-		}
-		if (vma->vm_end != vmend) {
-			err = split_vma(&vmi, vma, vmend, 0);
-			if (err)
-				goto out;
-		}
-replace:
-		err = vma_replace_policy(vma, new_pol);
+	pgoff = vma->vm_pgoff + ((vmstart - vma->vm_start) >> PAGE_SHIFT);
+	merged = vma_merge(vmi, vma->vm_mm, *prev, vmstart, vmend, vma->vm_flags,
+			 vma->anon_vma, vma->vm_file, pgoff, new_pol,
+			 vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+	if (merged) {
+		*prev = merged;
+		return vma_replace_policy(merged, new_pol);
+	}
+
+	if (vma->vm_start != vmstart) {
+		err = split_vma(vmi, vma, vmstart, 1);
 		if (err)
-			goto out;
-next:
-		prev = vma;
-	} for_each_vma_range(vmi, vma, end);
+			return err;
+	}
 
-out:
-	return err;
+	if (vma->vm_end != vmend) {
+		err = split_vma(vmi, vma, vmend, 0);
+		if (err)
+			return err;
+	}
+
+	*prev = vma;
+	return vma_replace_policy(vma, new_pol);
 }
 
 /* Set the process memory policy */
@@ -1259,6 +1248,8 @@ static long do_mbind(unsigned long start, unsigned long len,
 		     nodemask_t *nmask, unsigned long flags)
 {
 	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma, *prev;
+	struct vma_iterator vmi;
 	struct mempolicy *new;
 	unsigned long end;
 	int err;
@@ -1328,7 +1319,13 @@ static long do_mbind(unsigned long start, unsigned long len,
 		goto up_out;
 	}
 
-	err = mbind_range(mm, start, end, new);
+	vma_iter_init(&vmi, mm, start);
+	prev = vma_prev(&vmi);
+	for_each_vma_range(vmi, vma, end) {
+		err = mbind_range(&vmi, vma, &prev, start, end, new);
+		if (err)
+			break;
+	}
 
 	if (!err) {
 		int nr_failed = 0;
@@ -1489,10 +1486,8 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 		unsigned long, home_node, unsigned long, flags)
 {
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma, *prev;
 	struct mempolicy *new, *old;
-	unsigned long vmstart;
-	unsigned long vmend;
 	unsigned long end;
 	int err = -ENOENT;
 	VMA_ITERATOR(vmi, mm, start);
@@ -1521,6 +1516,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 	if (end == start)
 		return 0;
 	mmap_write_lock(mm);
+	prev = vma_prev(&vmi);
 	for_each_vma_range(vmi, vma, end) {
 		/*
 		 * If any vma in the range got policy other than MPOL_BIND
@@ -1541,9 +1537,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 		}
 
 		new->home_node = home_node;
-		vmstart = max(start, vma->vm_start);
-		vmend   = min(end, vma->vm_end);
-		err = mbind_range(mm, vmstart, vmend, new);
+		err = mbind_range(&vmi, vma, &prev, start, end, new);
 		mpol_put(new);
 		if (err)
 			break;
-- 
2.39.2

