Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D7067F394
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 02:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjA1BNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 20:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbjA1BM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 20:12:59 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404B81ADDE;
        Fri, 27 Jan 2023 17:12:58 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RNDiQg008668;
        Sat, 28 Jan 2023 01:12:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=kVTz73jLs/m+KGcHzDSVjXJ+NunGsbKBjvJpISbZDWM=;
 b=y49ncK0pdefBKpFZM/cMFeg+EtQRooSJbx6md2I33Ik3nn+PzDZzv6g32jfXwWR0elFX
 QbY17vIuc40VdZffVIYRJ8/2pcYnlhOEIHgRmSOBYk79c9xD7M2TjDP+LL4nv5fwhy9y
 t381JZzYknrP4X0+16tUdeMX6rc3t0PqwXHsMDlXPKRlmW0PZS4noCvZe26BE7ACRakD
 oVGFQ9tXCcrPbyYzbW8Wpy9lK4oTWyt8GJjYckXTFIJzPRPnNFYZXs9eYJLCVau/LzR3
 Y2CULPTr9NkIloWtR/YW3e6S8vbWA/2nmWgOsPnWtcttcrk0vZrKDETcrRV+6Vdy+5VE qw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87nte282-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Jan 2023 01:12:11 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30RMcI58023972;
        Sat, 28 Jan 2023 01:12:11 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gaa7g9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Jan 2023 01:12:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F10NmWq8iTtTjVVyWFZbgEW8ovdJ0pckCY0lFAoeEjcmdgauHFRYkjuckQFqKMMGDytkIknLD9tWi9/utBOVet/x+ZvgZV226zxpkAfFsoDvo4pqr8/XirqmKvMZpUl5Ku8m6UfKTmMhpqinudGDHk9lr7D2WCfs744+MFoqoffZj9fCIqEFcctS2z3iynLu2O72xGZTZmhslgbodSnD9uPvpBb1UqXKb8vBEr5Kn89L8T5Z4OUlQJpz9iAyRJdYZcbNDfzw3Ji19bsXEJBz639bBPJHHDnIQLHtw4o0Wsq5sK0jlOFy5riHY2O7QnLOadOcUhUyCpAooBb+UB+MXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kVTz73jLs/m+KGcHzDSVjXJ+NunGsbKBjvJpISbZDWM=;
 b=Fq4vlkyzSgP380puGSkEO1PNQVS+SDDnNtgBUbAAuAfuu6RGK5Y7NhGQg/+lzzf2xbKtfaaawY32OVTMYqrxvpFBGSsOi4dv4qwLDJa5S/mPnEG28MPLRZ0sSFGEl/6Z5jldBHBrp1ux4s05YOBe/GgKKmZKbUus6Bx4erEBcb4laBMjla8849XiB1jeL7vaYZUJGoaPR90Eh2Na0rdV5NTcyxZK2xSkGut1ibCjccMvW4ySjLnbhQp4j3F5dO4K+O5CQEJ1p9h/AWzs1g6HUZtngxr8i5HI/mnOHxC3XgvMVPRFFhEcGXsXqsSk6TVKlfoMbBOKtyjR8uMMLR02Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kVTz73jLs/m+KGcHzDSVjXJ+NunGsbKBjvJpISbZDWM=;
 b=H1bFJ0wLK1axWzs3i0fvzPIBtsMILWgZlL6fxEmMFK/vrhGjThXerzEYBDB2TtIT5WImyn9LhVpHfGfFRQ9K/730E6T3ZhfwwYpbLhAwssbW4GJqRMNsO/7bv6swcKL0519mWqRXAIE873bl5l2NqTi/izXOVhmDjHs0LIKtfIs=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by MW4PR10MB6369.namprd10.prod.outlook.com (2603:10b6:303:1ec::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.9; Sat, 28 Jan
 2023 01:12:08 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14%9]) with mapi id 15.20.6064.013; Sat, 28 Jan 2023
 01:12:08 +0000
Date:   Fri, 27 Jan 2023 17:12:05 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Peter Xu <peterx@redhat.com>, Michal Hocko <mhocko@suse.com>,
        Yang Shi <shy828301@gmail.com>,
        Vishal Moola <vishal.moola@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: hugetlb: proc: check for hugetlb shared PMD in
 /proc/PID/smaps
Message-ID: <Y9R2ZXMxeF6Lpw4g@monkey>
References: <20230126222721.222195-1-mike.kravetz@oracle.com>
 <20230126222721.222195-2-mike.kravetz@oracle.com>
 <4ad5163f-5368-0bd8-de9b-1400a7a653ed@redhat.com>
 <20230127150411.7c3b7b99fa4884a6af0b9351@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127150411.7c3b7b99fa4884a6af0b9351@linux-foundation.org>
X-ClientProxiedBy: MW4PR04CA0276.namprd04.prod.outlook.com
 (2603:10b6:303:89::11) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|MW4PR10MB6369:EE_
X-MS-Office365-Filtering-Correlation-Id: 908e785c-cd63-42d2-928d-08db00ccad3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0R9GBg/MtzlqpRg7xf7fpoQId0HzXD4TBKtPuhcL/M71Esv4+swbO57bcM55U4DKniHzOFFIjlxbMsQKiBBNsnTMNeR0uSgAnu2KV+PZzBVV4vlmNYB/wSBTmOroK/6koNgCvNChHKSmf3mTJUC/aE9kj/gN2X2I6iJOu7b/s9AF5k54Ez4fxPRxVSQ9fNPLOTCpB7dh/aUxderzMeCIphq3hinXji2FPuRcga/qQdRl93TyI9OaVylWSzIbi9hxjM0IhmDCxF9Bj9dl5LW+iULU2KBzI8j6Yx4zsQmh23IDoLAp2IogUOmStIeBazvbec0rHzC6P8bJp8f/eSiFe7Iuw06MBip7vKfGs+52/w9Eb5MxWXEAZTZworzkbw+W3w+Ii6vjVBjpe4GD2FPRkGaCrdnDe0qzFhj80rwdB1PnNReYP33Ec9c8qW6BgoNQV62BEy7Rjbe8X9PvsUWrpKOEBpiutn8IOtjom4o2eSPzlirO1nfMgUJIkIMClO0Px2baaxR4hMlaNZpuG2TDGZgUMKxXrkRFIO41MQGR8yiaU7Tr5AU2TONCPhGhTWHTNoAsUYXIWPyhGXWmNSUGelzGS0qh+eRIrtMDSg9SDZGNlp8OhznvhXP1S90d378p6QwoqMmOBcoINUh7MPfOrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(39860400002)(396003)(346002)(366004)(376002)(451199018)(186003)(4326008)(316002)(5660300002)(7416002)(2906002)(44832011)(38100700002)(6486002)(26005)(6916009)(66556008)(6666004)(54906003)(66946007)(8676002)(478600001)(8936002)(86362001)(9686003)(6512007)(41300700001)(6506007)(66476007)(33716001)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZWBEe3XlmgoOmiZqiBXgHHje+OWslQdxnyTNEIFextevXAeqmL7E4zHC9x5n?=
 =?us-ascii?Q?AlICnql9l9OnHL3/DxiPmDQKhgAP79sQ8Ds59bdCyos/k9xMRiwLm5Xxp7Xg?=
 =?us-ascii?Q?gecJqdokpGXHrQv3pxE4w2ISzlkPeixFGWSTp+3vwDMt5LiLjUTIN6wQEqmP?=
 =?us-ascii?Q?0oI8oOuKFS4tfsPu47pREzA1xCvy8Ur6S7YGrzBq5j62VTM+f3G576/8HKyZ?=
 =?us-ascii?Q?u4xBmMBRjyMt2LnlkYcwdfMTH7QGM+d3c5/Rcmq9pjbcDYR5kyS++1ib6MnA?=
 =?us-ascii?Q?q3JQpab8mrh09pVealZnfilxJjGjIKBReKc4qH7/OGY14HTwwcWrY3ktRaDU?=
 =?us-ascii?Q?a+c5hWwWOJd7uEm3nQ56KgQr7/q//8UCkL3apJmOFUDkO8A0SOlXJzF8FlCe?=
 =?us-ascii?Q?ZQ1T7mVkbe4YSFrVgw4ND7F14SZ7YBADknxitTG60/0aLZIvhyWODmvd+UOZ?=
 =?us-ascii?Q?jW7Wh9GVuGT+FgnIM/G5vbW8l6tAJ1laNPftNAyBpUZZh+QdszIhIKxXkG+v?=
 =?us-ascii?Q?9YrRHGbr4Fcu/1k7oGBCX7Gt4SDZFER4Gx7SGy19jmTeOD7shbuyrah8Uw8S?=
 =?us-ascii?Q?xATUPklzodEqMPx/bNoQO0pxkBapiSMNa5aEtnZ5N6EE2s7keX53i4KlxC9E?=
 =?us-ascii?Q?kBUY5wfwfqsyNL2lc+IWTwxuI09GzxRljw4th+cHeLI7JhawNedoplb0KCY/?=
 =?us-ascii?Q?sP46vxncln3xBjChQ2EcvlvHF7t7QPLt/nUPDX7J6p9q1bRiXh85kWWDAxSA?=
 =?us-ascii?Q?JRB9l1wiHIXlqgZBDVrePDY8+7LnEp3PMini7JzBM6HD9q/D8O7SW8PfsUaR?=
 =?us-ascii?Q?tdEsctpnu221SG5G60VY5X1QkHFQQdMwD2eRrhVo+7O5qMzA0sSTwW7cXjYw?=
 =?us-ascii?Q?UI/uYzty+ZzyRAIKfQ3VIa16o81rJFmbNP5uww1knuqAav+1KwkYRw3Ww0q5?=
 =?us-ascii?Q?Q/o4IuA7Bqk7Ci9gaz1+Lfgn0srnsxq7XV3tmap5E7Rr+MojCv1qJ8XkJx2T?=
 =?us-ascii?Q?lqItp+NtFsHg8xHIoqYL39QBBXD8aPMbKbMknTE4VUkzhPT03WB8oMI0f05t?=
 =?us-ascii?Q?9auZ/TsRD/AuuigluDZK8vjirjm01K/3/3rtGj2WVLCsXi4SZpidQdvqFB51?=
 =?us-ascii?Q?zp+gV7nfSUOx2zSAwiAm4YxM4bY8doy6dbq7LIVZbLREZh5BDh/zMB16GcNY?=
 =?us-ascii?Q?7bNDc3KUlmXxT0KiPCA1QkPEHYJ6CokC7RpxRAt6AeVSmIze4hPAPWqk2jH3?=
 =?us-ascii?Q?Gu8rj/O/e2u917pAZj09hw5uXMiw9Hz9jzRZpCZRJ9MSuAuyLQw2fX1fxLUu?=
 =?us-ascii?Q?NKuebLlvNLQu2p/Taejr54r9Vd9/WRodPuP4Vf+EnUknZH8z+LjIgRonrT5V?=
 =?us-ascii?Q?AsqInfvVgX7KR/Opjjv9vmIFIqLc7uG7jU5WcbjR77o24KAJg2pt7vYsPIUf?=
 =?us-ascii?Q?UDaDGJqVjeVyFFQvMFqRiPncHP1Qe4rwqcEoSZWWCYhjJfQ+J0MNez80rtBC?=
 =?us-ascii?Q?qjxza/6E9lYfugQhJCZBPntklgixZ2N0yiHBbqBshztapyagXwJ10YZL0pGk?=
 =?us-ascii?Q?zpRJnbgYxj9CgkQ0vM//Z2HDAsWso9crcEbIlmT9PODUa9fxLDmcjczXr16k?=
 =?us-ascii?Q?GQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?pzOgkijmsAISG5YVExwNm2InwfpYuCs7DFKLUXNJ8gCoRQJa69Y4D9KXZ2Q0?=
 =?us-ascii?Q?d7dm74lAj0R313d+xMuEbFrO2aZdIf7Y/ldWIeLEJMD0UCbRUr5qRCuaQV3d?=
 =?us-ascii?Q?0aOg/qe/QToNE3M+dddbXRlqEiJ9X7/tzSATW8V2CBDvpXup1idWEJ/V6yCa?=
 =?us-ascii?Q?UyWdsXlq8aeLm4yjrsyH4SK/Av1SungZ3vQBUDLxmxH79jjzuwbMkh+6a2oW?=
 =?us-ascii?Q?Sww7XcpsGQ4Y0kW9SCRi1pSjjLfdg5wfK1rCczuc5MezsvnwxwslVcWH4M3z?=
 =?us-ascii?Q?teaxG767t4Y9NE98NL7RrXSixfuLkt5uSHYVS7retdhE+MZvnyOaczQEaovU?=
 =?us-ascii?Q?Ht+43kvgFKzX1lF3WuKBst+Bs7wlKJ7iNw6n8qyA6E5sgZeY3kUNag2jnFHy?=
 =?us-ascii?Q?+dGHlmaJ4jfn/fn455lq3x7bUQGjrzxUvpgYJxhFrMXPaxyJhSW0MVd5ZJgP?=
 =?us-ascii?Q?M5npZnjNO0iL0390Mj2jrvzCZqd2TTMKz64T9EUjh0vq4ZR49c3+iWdm7llW?=
 =?us-ascii?Q?gxT5d5qJALIXeXAeyX354tY/YEt/5BUNpgIrs3nL8/dLkinHzmatZUAUyxAA?=
 =?us-ascii?Q?14+zrUKuKCNTV5JGhFMa5W0fXEKIDCgkuXZGMoOpSiRSg35rWd1DgMia4tug?=
 =?us-ascii?Q?NrgKmYKljYJ+fy8RBPKok0nT3uMaonInHZhOI8nXrGcq5G5Mvb+Lt6p+eyWz?=
 =?us-ascii?Q?WDJHcP6CxjUetVdHS9zsJQi3lBKHgw79+eH0ZQckvRIqKvtAYvP+1w56N53v?=
 =?us-ascii?Q?aJgh5el17I2z5kTRIwQ3uZF1vTotehXpM435cmmDV4lxIHeS39lHqBaCjNL0?=
 =?us-ascii?Q?fjMpmkwhA+/IFcs7l/x2DOO9bozE60w3JG5Ssq296IUCWln9pBs5XlrhIcCd?=
 =?us-ascii?Q?ffkNpJpBmdjyoiVSi3VEgJNO5ENnRYVpsYnEFXp9LNa3NnN7v8FYn2PZsRlf?=
 =?us-ascii?Q?ZGFYNdGQsa5LZ+jOML8X/R3pTirD8c9mMAc2J0+9tCK7nZvti8w83g3+nT77?=
 =?us-ascii?Q?t28o1rUnisPbRWv3RKW8RqZndTQjnjUeKmce8Efu3Okfl9c=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 908e785c-cd63-42d2-928d-08db00ccad3d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 01:12:08.5691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x44ha3pCHuVucstQYWUA6g+jqvObkUA89Z9APDAfV8F6KAK486vDmbKKsyO2g5G8tDSn/AQhLRe0mBIX4nVGBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6369
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_15,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=749 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301280009
X-Proofpoint-ORIG-GUID: EXYzSjbG5_ZbvNsMOCJvpXU-9USfChN8
X-Proofpoint-GUID: EXYzSjbG5_ZbvNsMOCJvpXU-9USfChN8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/27/23 15:04, Andrew Morton wrote:
> On Fri, 27 Jan 2023 17:23:39 +0100 David Hildenbrand <david@redhat.com> wrote:
> 
> > On 26.01.23 23:27, Mike Kravetz wrote:
> > > A hugetlb page will have a mapcount of 1 if mapped by multiple processes
> > > via a shared PMD.  This is because only the first process increases the
> > > map count, and subsequent processes just add the shared PMD page to
> > > their page table.
> > > 
> > > page_mapcount is being used to decide if a hugetlb page is shared or
> > > private in /proc/PID/smaps.  Pages referenced via a shared PMD were
> > > incorrectly being counted as private.
> > > 
> > > To fix, check for a shared PMD if mapcount is 1.  If a shared PMD is
> > > found count the hugetlb page as shared.  A new helper to check for a
> > > shared PMD is added.
> > > 
> > ...
> >
> > > --- a/fs/proc/task_mmu.c
> > > +++ b/fs/proc/task_mmu.c
> > > @@ -749,8 +749,14 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
> > >   
> > >   		if (mapcount >= 2)
> > >   			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
> > > -		else
> > > -			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
> > > +		else {
> > 
> > Better:
> > 
> > if (mapcount >= 2 || hugetlb_pmd_shared(pte))
> > 	mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
> > else
> > 	mss->private_hugetlb += huge_page_size(hstate_vma(vma));
> 
> Yup.  And that local doesn't add any value?
> 
> --- a/fs/proc/task_mmu.c~mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix
> +++ a/fs/proc/task_mmu.c
> @@ -745,18 +745,10 @@ static int smaps_hugetlb_range(pte_t *pt
>  			page = pfn_swap_entry_to_page(swpent);
>  	}
>  	if (page) {
> -		int mapcount = page_mapcount(page);
> -
> -		if (mapcount >= 2)
> +		if (page_mapcount(page) >= 2 || hugetlb_pmd_shared(pte))
>  			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
> -		else {
> -			if (hugetlb_pmd_shared(pte))
> -				mss->shared_hugetlb +=
> -						huge_page_size(hstate_vma(vma));
> -			else
> -				mss->private_hugetlb +=
> -						huge_page_size(hstate_vma(vma));
> -		}
> +		else
> +			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
>  	}
>  	return 0;
>  }

Thank you both!  That looks much better.

-- 
Mike Kravetz
