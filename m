Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1046B62658B
	for <lists+stable@lfdr.de>; Sat, 12 Nov 2022 00:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbiKKX3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 18:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234527AbiKKX3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 18:29:13 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9C483394;
        Fri, 11 Nov 2022 15:29:12 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABN4TIr024620;
        Fri, 11 Nov 2022 23:26:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=H81csLrJ59W5pI2KFQFYj/lp0XhS1ySTEqlAmdoct7s=;
 b=Oz1/88M4jxuWAKp5euIzwjWz5sIqrqawpiBLgEJ+SZjOiWK10gCsKDs1+FyalY9mIPGl
 TQ4skQN+dS2aj0CiBbY5Os62oX0/jq/aHxH6C9E7IRIoOKpJCKV8RSyXh0C77Md6GB+p
 7g5Wg+AyU6h+J1Yg2BxraPvfHTk8T0L0AIMxNWMHda3qWEE0habZylSM9cROUWNGoWqV
 9Pn9SD78lzMCBpcQ/AJoCJR4mL+3KxJCeSV9UtQHQMjnS08Q3gAJjGIGqKiKZvXvkSB6
 rSb2Y/AM2a7BqcFDijQ9kCQyKmgSTLWxAJkLy/n+fQEl58J1Eve5Eqx+hz0WbJrm2/bK Iw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ksyr5g0pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 23:26:54 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABKHkiM022406;
        Fri, 11 Nov 2022 23:26:54 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcytucmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 23:26:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fwkz9SEaX6VpB2yLfj/P/x7fHeMw6JjxChrXJLWTF3j9Ks5IancyBkeA2yKzGookcFXKQFiDBKglahrvSkm9j3kUtUQiFLKF8UZ+RlPWPcMZiTXt6jrkqtWMETpncMAEY/nOP6vZ9nqGunSU7vy4sP8BX64b9jBtg3VDOAhwiVhy+Ei7Uk9TRhsppu39cnJCJLe0K2zzq4++2QeJLPmV084iEPaK4R8CyLRdP5tltOp90CTbGq/+tyE3g00ye2uH5/dE3Mykz70EjavRBKk5r8ttNFyuXyCLhD/jj4ZzQOP7V6LWET5NzifMlDkT8lbzF+MiVHN/K9M8dgv0uV6y5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H81csLrJ59W5pI2KFQFYj/lp0XhS1ySTEqlAmdoct7s=;
 b=lCU/oySynoqNY6t+PS5FNOHem0dtGfEFLrs2p9rvddp9C3b6uya/3vC4rET93dQ2O8/EcYOTguJPcc5atNmhJBLtbkSfuZh7RDeFQYF4sGH8yY9SrgRigeutUD0djy4c9soojxVWMzkHBpdRBGeip3w/NcBDVePZyqmgCK0ulFTOtR4YW1MufC15QVKUa1uFm3bzGxsPEnFvKIytYZv7ny9Yuu69c+iNDDVCqaXPf6Buu5fn0dwOco/zqdE95gNfaAJ+g0IHbtm1yZnAQjZMGEeXWIGWqVjMdfIzcARdbx+P1mLSuN1P+jeLsgys42ZezNhntgi2wNbA3cBrhv38+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H81csLrJ59W5pI2KFQFYj/lp0XhS1ySTEqlAmdoct7s=;
 b=KxLKEkjpu+/T6rzZJlq8VPBuS/11JUdsdqsKyxTQ/nKHQSzfkpt1+dal6iWFTNeyWG38L4B98eII5DOGAFO+SVuXUt7gJ8WfFrejU/mCcz991pnzDKAtg15t4gQmCBn8veBpsfTapJBNoYY9689pb1RzHRKRnvA6flzZxXtxO1M=
Received: from DM6PR10MB4201.namprd10.prod.outlook.com (2603:10b6:5:216::10)
 by DM6PR10MB4139.namprd10.prod.outlook.com (2603:10b6:5:21d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.12; Fri, 11 Nov
 2022 23:26:52 +0000
Received: from DM6PR10MB4201.namprd10.prod.outlook.com
 ([fe80::4786:1191:c631:99da]) by DM6PR10MB4201.namprd10.prod.outlook.com
 ([fe80::4786:1191:c631:99da%4]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 23:26:52 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v9 3/3] hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED processing
Date:   Fri, 11 Nov 2022 15:26:28 -0800
Message-Id: <20221111232628.290160-4-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221111232628.290160-1-mike.kravetz@oracle.com>
References: <20221111232628.290160-1-mike.kravetz@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0294.namprd03.prod.outlook.com
 (2603:10b6:303:b5::29) To DM6PR10MB4201.namprd10.prod.outlook.com
 (2603:10b6:5:216::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4201:EE_|DM6PR10MB4139:EE_
X-MS-Office365-Filtering-Correlation-Id: 8312ddca-352e-4762-6e85-08dac43c3689
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wo8mYLhwBWUvx/Cs+6IlsxZfr7eQEQJQgNTcia81ciJ2ULhfMXlOgTKqOZwRZvkzQKgYdShpGKWKeMEO2BFhJIdLW0NfDS/yd34+Qq/PyO1aifdaZCtRECHKoRWOVROU1yaVlAXvaBWgyY03UgeYKsA8ZjSgQeMRZgmNRWUpy4FYKkc+rUtx0rQ9nuykTFp5+HOSX0iNpNi/dDE5L04Eg4/uFOm458vj9Rv4HKWevALgoCpXJ3h6SppfEFjiNamsdtluBmpK65u3xiOiESanSb1hGmUuaxzI02D7JNNC1kzTvT1nRVjW1uuHqxg4caA/ZnTox9lV0l/uxh45nRxLbQsVgbQXzsCVLzDcudYkdCKGm46pwkCo/JQpbGfc/HGe9cQaEwA2E6s2jDn1WDJCICt1/wxmIa1OL//k0PFtO79DMDnkf8HkSd3gSgoeRPm9r+sLDyIdk2JxvqQIzQhV4N6e78sEKzXI3D+Eg2fcQjUKb3uBeqiyJXbVa2kdfiOaajYWY7dcqN9qwygQYipQ1P4z7fiPpcL6ylOTyPrjcd1PmWoryswp8Gn9JmkMETrsTJwvT46C0MP2kSv1YgoBDPyvPMFtWb3uxNYnGbApwKFyj8ja8e4wkQomoR2Y2gpSLkTDOcKWB+iaTFKZCO8uY46hxDuj4Ev09+yhzon+Hyi8IH0U2wHgaKGQeszswFYRPpnUPl0kK9XUwkaygDm82hbYZLB04aI4FWtewFRaRvU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4201.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(39860400002)(396003)(366004)(451199015)(66946007)(8676002)(66476007)(66556008)(316002)(44832011)(4326008)(38100700002)(83380400001)(2906002)(41300700001)(86362001)(26005)(6512007)(5660300002)(186003)(7416002)(1076003)(2616005)(8936002)(36756003)(6506007)(966005)(6486002)(478600001)(54906003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MSfT/CQffUS/FEi1NDckCaODCy67H6tqjLFFF5LRs/XFoZapisJFffKSiwmb?=
 =?us-ascii?Q?9q6QD8WAz7DMftDI+XuQczA/nGLBHySjnltAWHiY04dWL4BmfmPPMduLjPh4?=
 =?us-ascii?Q?DdHGNw/bzRhOtJreg73a3483HhsEXUWvtWRSWEtBE6Ld9blXMWXyzUxe7PuX?=
 =?us-ascii?Q?kVec65VWDlISvw+cMc9QAYIwMGxaSjjib8d3+B4xb7iRGZcMg/TMw4QcvLSG?=
 =?us-ascii?Q?tPJRapf/eTrEHlRn+L1uBuSos7tzjJLpUT/6+CF/jdhxDYuuaoTMHLBRSwBs?=
 =?us-ascii?Q?G1CoAsWwEXZbH1FtiX39FXwull/g/ME7LN8W53CcRn2uINSYTBqvgqYU7xST?=
 =?us-ascii?Q?niSpxILKKJhPtnHtat5YW360D0mN2cT/bZ7PQp1NNy+A/55bMLmNMMV/7t0C?=
 =?us-ascii?Q?SXy+bhaZ8Dr5z9pc2Aj4Nk+aw9ZsW+OD+kAhNVTktZH+i88po2Gt4YNhz29X?=
 =?us-ascii?Q?uOGD2huUxdXl0ioNix9tSLrog6wojDZkmK/vL7RNfL3QIzNuQCWwmEyr2IgK?=
 =?us-ascii?Q?KekyHksyyqI6bj6FghRaRh7vJKTlHI2mcQ0SOio/l3vC93XGz0ZtP64+b3K0?=
 =?us-ascii?Q?HL7tFN/70kD456oCBjSuo8RqKIdPdT8nlNy2hML6N9A4pe/cy/wlVA4G270g?=
 =?us-ascii?Q?u55Dugrdug6vVn+t8OGGln9M3QVuFbUpv3hhhrNh/yN0flSKM33BCNXbQsUD?=
 =?us-ascii?Q?kTL6TxU2BR0RlR8r2uTV98NNXieJy/i9s2LDWVu4ZpNkCaUdE2GR62XCmdTL?=
 =?us-ascii?Q?yzSkoh9ACa02+lf5PHc7uIE1G8vnLbvaBdmsM5U+3Nx0zLTfKxBPDD863VUB?=
 =?us-ascii?Q?dieDj6jnamCJVxa+gsQuzu7pqFmt4Be8LOsLylSswlmh0/fVdpvDY3GBqT42?=
 =?us-ascii?Q?rNDuUmIoSne5B4BkKSJ282g9hLOik+RIEWyk9TmegtkMFo0MclQ99QzV9Uf8?=
 =?us-ascii?Q?Rbr4QkQ9fgThAxKM/AMqUde9RTeCvEgPNCM7GaLqKBIQYGmku81FARhVzNAl?=
 =?us-ascii?Q?9PnJ1ICsOMgTDbl1IJZsGZU2UPWuIqpqmV2an3kH3xeVJsPe/RDLIGa0Bgvg?=
 =?us-ascii?Q?hGOSTFqQaYclNo5+LFcjQOjLCikpX/JOSEV5fRPiEiFUH5awrxdfAECmDZx1?=
 =?us-ascii?Q?4GC1jCuJftgvqwdoHPCxl/Ke2DrN8vEJxm641SOwzWe5Z2w2Gy6pfnTe3xS1?=
 =?us-ascii?Q?d+kTgDGbVYc1WJCo64b0p9Yo+1Cb9XBzF3qI7kJEZ8108/0BXDaqTZ27nhE9?=
 =?us-ascii?Q?VmmOwj2Wf6c34dxPRNcPmVWk4Y3s4mhE96d6s5N2tL5P+D0fk0cNvKeCVs9F?=
 =?us-ascii?Q?dJUAv0hSGo2IOqemM5b9z+6Fk1OB9lF9r0Gdnlsb4ZznIdLXHZRYy7vHaE2M?=
 =?us-ascii?Q?TDo6zC98G0kCG6DByTlEb6ayoNfgQHhUOIAPOIfWd1TarwjyGxJ0JG8BGTwU?=
 =?us-ascii?Q?BjB5X/zv9RDaSWCu6r+j3voSULogDGctBQVka/d3WJkpQD7ot3u1M8uPzJ2i?=
 =?us-ascii?Q?rMBkANGVDMuTTRIoLjQuYT9FnA9VpEQn4vWOJcKw1tNNjE7T/Ap2JNT17gJp?=
 =?us-ascii?Q?U6UmafjturN2HgOPKYeFo2ScI+6ZBaNtTr5oeEiENUBoW60qmIWOXTv6SrEX?=
 =?us-ascii?Q?0g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?JPCAavrchR1BMrTIxwRoDBF5JH2LLSXaaIAqnfyHqiSCoVhe1gN1UCoxaG3G?=
 =?us-ascii?Q?6dlpUxKY1bG/RVEKJJo0NkEG2o3X4jVl+NQLUGZr4yqv7tqmFHJW3g0ksJye?=
 =?us-ascii?Q?8cz9ikjf78I9uoV6A1M4VNLhDsZfo09A72YdkYYn2/9AFY3RIQbv2qlhEcKY?=
 =?us-ascii?Q?HI5H5vDkD+2hQRUDZonKIlXo35cOiHF+q23bSEUTAomjRf7d8XqLneGkW6Fc?=
 =?us-ascii?Q?pYwWw38TvwZYo7Hi1q++M0rC5Cgprpad5Jmu+74At8IxthTKHa0nxnUcLnpd?=
 =?us-ascii?Q?DCxZDLxDhHw7hW+nK45Q+dbt6y2JZNv3M1J/Yw1Ay95B/vawTqvHziHzIRjz?=
 =?us-ascii?Q?hk3SflHoUgIt5JpN5OBAP078BzTI+Xb3aN9AJl7aKmDK9Sd0p13dc/nqH2Pd?=
 =?us-ascii?Q?QQYfCSIzm0DIPWiiXv84DUg1/GvvucAoSez1UufhF7K0IChU73ohf0k1t/Si?=
 =?us-ascii?Q?zdVeyas0oUnQvK8V1XoCBjON/mGdWfCfk7m2WeNoGv3fg+aQMCaM08OUCOOJ?=
 =?us-ascii?Q?2o1CYD6eT0Nz3ogUf+0gT2Nr5Wa0bCjxDYXHDxhuuY3EanqELJ/+rXP7qBDq?=
 =?us-ascii?Q?fBGBdmawaNFsvMyf23iWynaz5G7AyXTtcRmAfU2njgTuJWBC4rq1QKJZs6Xu?=
 =?us-ascii?Q?dJl+TqniEkqdZT7HRhop/RqWP9hL7BeuF2IjU6SQn16dHwcPeE98BKDxiZzK?=
 =?us-ascii?Q?93MYb30FT9y/YMGVRIPXsuBrqOokF0PYWQjXjMcsl5Q11gbmKCTRf44JoC8H?=
 =?us-ascii?Q?EGY/usGYbPTWxpZzKkH1rN+CokScG560+Rimc5KpIYEAjFVpqabwY0p3mPkZ?=
 =?us-ascii?Q?UNZws3KICohO/HbO2w6gpIEM1oaynw/8bv9X0ZhQZTXPBs9/uX0CLA4ldLuP?=
 =?us-ascii?Q?Z6w2FCxKidJyQ0zssMnuo7Ga5JWrLhWMoYLjb1h6D82x7WVKhh3l4TcgPomB?=
 =?us-ascii?Q?/dmFILmkJ6npe9RIYHCVeKAxGTedKE3API7Qm/x95q0sqbuaCq683jTUSBpS?=
 =?us-ascii?Q?0UWortoZUZSy599Cezdm6NmnPwtCIeWBlOgQ2PpT+bN7g99Fn2h2s89UwH8D?=
 =?us-ascii?Q?vKcAmH6K0FTsmL7lD/77zadCzdi1OBYCzjk2No6H/Kyv6TrfaUgYU57AOTQP?=
 =?us-ascii?Q?MdmLpu/E65uwb9YkDuVIdYaZKX6+So9nClZK/WAt9MiKBGGBFdsY7cw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8312ddca-352e-4762-6e85-08dac43c3689
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4201.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 23:26:51.9342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: riII9JniIrw0eDCrA64BLssku8Y+9jt8GofcuESrvQKjeSvQXBo06GH33Xpp6sS0kLyDfgocUKbIuP87R3pxAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_11,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110159
X-Proofpoint-ORIG-GUID: hcGCgWUR5jy2wwiHVzT_X5IEyK5UL6EB
X-Proofpoint-GUID: hcGCgWUR5jy2wwiHVzT_X5IEyK5UL6EB
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

madvise(MADV_DONTNEED) ends up calling zap_page_range() to clear page
tables associated with the address range.  For hugetlb vmas,
zap_page_range will call __unmap_hugepage_range_final.  However,
__unmap_hugepage_range_final assumes the passed vma is about to be removed
and deletes the vma_lock to prevent pmd sharing as the vma is on the way
out.  In the case of madvise(MADV_DONTNEED) the vma remains, but the
missing vma_lock prevents pmd sharing and could potentially lead to issues
with truncation/fault races.

This issue was originally reported here [1] as a BUG triggered in
page_try_dup_anon_rmap.  Prior to the introduction of the hugetlb
vma_lock, __unmap_hugepage_range_final cleared the VM_MAYSHARE flag to
prevent pmd sharing.  Subsequent faults on this vma were confused as
VM_MAYSHARE indicates a sharable vma, but was not set so page_mapping was
not set in new pages added to the page table.  This resulted in pages that
appeared anonymous in a VM_SHARED vma and triggered the BUG.

Address issue by adding a new zap flag ZAP_FLAG_UNMAP to indicate an unmap
call from unmap_vmas().  This is used to indicate the 'final' unmapping of
a hugetlb vma.  When called via MADV_DONTNEED, this flag is not set and the
vm_lock is not deleted.

[1] https://lore.kernel.org/lkml/CAO4mrfdLMXsao9RF4fUE8-Wfde8xmjsKrTNMNC9wjUb6JudD0g@mail.gmail.com/
Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Wei Chen <harperchen1110@gmail.com>
Cc: <stable@vger.kernel.org>
---
 include/linux/mm.h |  2 ++
 mm/hugetlb.c       | 27 ++++++++++++++++-----------
 mm/memory.c        |  2 +-
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9e7cad65dfde..d0e8d5007343 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1897,6 +1897,8 @@ struct zap_details {
  * default, the flag is not set.
  */
 #define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
+/* Set in unmap_vmas() to indicate a final unmap call.  Only used by hugetlb */
+#define  ZAP_FLAG_UNMAP              ((__force zap_flags_t) BIT(1))
 
 #ifdef CONFIG_MMU
 extern bool can_do_mlock(void);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 205c67c6787a..0cdefa63f474 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5202,17 +5202,22 @@ void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 	/* mmu notification performed in caller */
 	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
 
-	/*
-	 * Unlock and free the vma lock before releasing i_mmap_rwsem.  When
-	 * the vma_lock is freed, this makes the vma ineligible for pmd
-	 * sharing.  And, i_mmap_rwsem is required to set up pmd sharing.
-	 * This is important as page tables for this unmapped range will
-	 * be asynchrously deleted.  If the page tables are shared, there
-	 * will be issues when accessed by someone else.
-	 */
-	__hugetlb_vma_unlock_write_free(vma);
-
-	i_mmap_unlock_write(vma->vm_file->f_mapping);
+	if (zap_flags & ZAP_FLAG_UNMAP) {	/* final unmap */
+		/*
+		 * Unlock and free the vma lock before releasing i_mmap_rwsem.
+		 * When the vma_lock is freed, this makes the vma ineligible
+		 * for pmd sharing.  And, i_mmap_rwsem is required to set up
+		 * pmd sharing.  This is important as page tables for this
+		 * unmapped range will be asynchrously deleted.  If the page
+		 * tables are shared, there will be issues when accessed by
+		 * someone else.
+		 */
+		__hugetlb_vma_unlock_write_free(vma);
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
+	} else {
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
+		hugetlb_vma_unlock_write(vma);
+	}
 }
 
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
diff --git a/mm/memory.c b/mm/memory.c
index ebdbd395cfad..2d453736f87c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1673,7 +1673,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
 {
 	struct mmu_notifier_range range;
 	struct zap_details details = {
-		.zap_flags = ZAP_FLAG_DROP_MARKER,
+		.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
 		/* Careful - we need to zap private pages too! */
 		.even_cows = true,
 	};
-- 
2.37.3

