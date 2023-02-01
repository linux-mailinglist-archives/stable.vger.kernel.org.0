Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440B7687054
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 22:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbjBAVG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 16:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbjBAVGZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 16:06:25 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48006E43E;
        Wed,  1 Feb 2023 13:06:19 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 311KwsA7000899;
        Wed, 1 Feb 2023 21:05:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=Y43JmkMFCeKbGXp4dDcAOp96/crBxPLL2tZ2vPZYnqI=;
 b=CV4rrWk/ki5D7fKXudWazEwQUXvDOmUQA91wYTUmp2QLfzxfF4DKz1BTR5ls7SNpeF++
 2GLK/vxRihT+dhpujmJ3YcwRGqrnSiAf94j1s5xPKblgnbob5cEsbJX1uQGFOxPaH+Uf
 x6BM6LuTyiv/XpwP2bjOL5tf4dih6jvkoxKqbpj8ZJy41MjGo3/IpZ/K8rdbUXYHOjgb
 KxawngbkfsOsZq8fuVSzKfdBCrcDs2Zxnzd+uQ6Zsxuhi89aDsTOdR9HfjDJXF58onSo
 ukdei4mPgCfM2wAkmHlb+KgNi4ZRIB3DceEKO/YZpIEpmn2ZptotQ7bHwS7IkqDQ+h8d YA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nfq28sbua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Feb 2023 21:05:42 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 311KprjN025298;
        Wed, 1 Feb 2023 21:05:41 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct583dtq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Feb 2023 21:05:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0hkrT3VjDJdsJvK+LzZWA1sG6v4EjeNe5oJNazKZo1kTCZQQKMcLEo/FPFLPCiB78mwMx9Tip5yTK2WOEOhb+PAsSiFPHoVbqdsPvy7tBPDD8uQ2WmBPx8DkSO7xrvKfbVTEnFcCjqlmOvEbpf8+HV+5jOYsaXL3eaPIHtIxXxWPlrkeW0xMQplGSHFiJ+h668eSEK3b4W1lc6kv30bWKg0FdMfuNrqBhIk/XD9LuAtJLVVcsX1e9s0LHIYehD53qXwrUJ33JpbBKwyJHAnUmpOi+XXqrfSH1rEg65gY9ihHRuYSyfpqU5Fb9cb0g+2d8DkBZzBLuFSW3ljlzEseQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y43JmkMFCeKbGXp4dDcAOp96/crBxPLL2tZ2vPZYnqI=;
 b=AtBOtoTNctcbRsQjnTZqdrb3QWZMOsQ/lN+oKRnYSxIxlzP0bFLuDATBQmPjjlc3AgIUrQ38W7VPsdgX/4lIjroEptk9XOuNETK/eY796XCdYziVp11EeC4IZRWTgqbeUiXaZhd2ir/CEMIz3KukZRIPwEs7jrR9x4INNtQJ3NIjBd62Kjl/lJta/3yI6w7vpULOQ0GehNZPIFURUsLGR+m7lIm09J9eU4vTz9KItVYq02OhOI5ko27m59HO8kh63s5XrJbfoQWSpB9nvnmjwj2898qWjIdBBf8Qs7HBgdhHD8CPPKVqsjShz57FY6WdWLv3/9uoIlYRXzak8g6Q6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y43JmkMFCeKbGXp4dDcAOp96/crBxPLL2tZ2vPZYnqI=;
 b=zpgWX9twK5QkU6e+lzaTLsMZtzCQflx/Z06HiTtUURDLm+dk8jBFK9cmf3go4Ek4brK6B9nVdSP2h6M2H9R33cgKdjtTGDOAhraBeoksMINQAp7axx1LHOFtY9PqJ+emxQ+pNb3zFT673xZmBhmGz+WaRucildIqMboh8QnYZwU=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by MN0PR10MB5957.namprd10.prod.outlook.com (2603:10b6:208:3cf::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Wed, 1 Feb
 2023 21:05:38 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14%9]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 21:05:38 +0000
Date:   Wed, 1 Feb 2023 13:05:35 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Peter Xu <peterx@redhat.com>, Yang Shi <shy828301@gmail.com>,
        Vishal Moola <vishal.moola@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: hugetlb: proc: check for hugetlb shared PMD in
 /proc/PID/smaps
Message-ID: <Y9rUHw2kuSwg2ntI@monkey>
References: <20230126222721.222195-1-mike.kravetz@oracle.com>
 <20230126222721.222195-2-mike.kravetz@oracle.com>
 <4ad5163f-5368-0bd8-de9b-1400a7a653ed@redhat.com>
 <20230127150411.7c3b7b99fa4884a6af0b9351@linux-foundation.org>
 <Y9R2ZXMxeF6Lpw4g@monkey>
 <Y9e56ofZ+E4buuam@dhcp22.suse.cz>
 <Y9g/70m15SwxkLfc@monkey>
 <Y9oY9850e/8LQ78i@dhcp22.suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9oY9850e/8LQ78i@dhcp22.suse.cz>
X-ClientProxiedBy: MW4PR04CA0384.namprd04.prod.outlook.com
 (2603:10b6:303:81::29) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|MN0PR10MB5957:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d299e70-6e5b-472d-d8e4-08db049811b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BmvYxEFusmGA9s+ieIj7QxaxTh2GQz5aYz//UQJ09vbsnlmz2XfquFuhdrWRXxdLYvPk3q5zDMMhSx6WLAhfDEHIRRssUmPhNNULF4HtJ3CLnwMqaUX1N2NyelWvidYZ7Ljn8cCbx0yEWL9qu+1CuWbdc79b7ZzbF8/QFawoIkaQHGu8byX4O5DDilbR8FbuByonW6PfznfTmmeUYkjqmaFVV9uQBnC/boZumUgFaarsPNz/XfZL60pkG8ydh2fdqVzgr3bqlHchpVHkVfYbvHslJjaz6e3YIxYBqeoOf+qSPNqWCIWyDX68V4NYeHddQQ7WtCqcL+1I0Dh00gcd5foP4eGuIL50Y2KoNrstw+PL9xN5QPlre8D2MDYRvPz7nJzIpm+bfDySG2XvfOASNq412vgzvSzaHcZnS6cRfYcvsRL3HuWJJCa5obMLQ8GgPvSohc3uYb1T81gdwYbLjCPPiOLZq9PHHXkD5nph3DFmI+r8v6yvcC4G+hNfaMrtv6gOOoYOUuZoUHIvI6umg+WIGHqlm6euGadcv1+qI1jdA3UF+NYPTIb0OaCTS66gqc2lb5Ujs3OHBk74SwJXXowO9jMNGTLEhzkOmEn2C/6jCA1XwJuzsVaPMEwjAYIvGQ4/A2dJQCObPrMckL8MY8rws4alqD7Ie4Su+rWTF1ZYqSXwmmVsdskh4hHG+eIL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(366004)(396003)(39860400002)(376002)(346002)(451199018)(33716001)(2906002)(8936002)(6916009)(8676002)(38100700002)(4326008)(44832011)(478600001)(186003)(966005)(5660300002)(6486002)(6666004)(6512007)(53546011)(26005)(9686003)(6506007)(86362001)(7416002)(41300700001)(83380400001)(66946007)(66476007)(66556008)(316002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FapAiLCJQv3slmhhNBmnqlkPjcPLp1zIf+BAmqIY63bR+OEVF+s8XFOOcRWQ?=
 =?us-ascii?Q?gk2vn6gzJ/3n0iQ5nlFE0+X4INybQcLmz+bYwe2ogv1zzJPKDsAsoz1QATWO?=
 =?us-ascii?Q?6j0r4ZdHnc5RxY09brsWnQ76CJwcR2ZbzmYD9txQPwfYFrd2EADBHER/UX26?=
 =?us-ascii?Q?TNGwuWwmbV6a1F3JZK/62O6n2JskzTkBBVXq3+ooJfVA4JNX3ASY7XMd6FRH?=
 =?us-ascii?Q?PyKGxukBqPbFysrL+bT07/LPNqq2szusJ3nd1/J2WNgbvCI2MAVkoPY8H3J+?=
 =?us-ascii?Q?L6UqVvfjNcyYpmDwe/tRAlIJyqH5FRoNUPLx8Fpl0I06V4oCbjV+Y4nU6OkS?=
 =?us-ascii?Q?cOFOE0/updcZ3qzrVDRgr9Jo4wun8uoAMkTrg/UXBtGh/8DA1hZZ+ZBUgfEX?=
 =?us-ascii?Q?+tahHadup7wNWPomxIJFOYlPdt2OsQBPlm0XvAm7gJhW9dTdI96yCM4OL9bw?=
 =?us-ascii?Q?TR62D5lGKvyTv1L0DF/JHx9Zw2DJ9gUYbFOpEAWRVi+oxbk0rvnidXlTprsr?=
 =?us-ascii?Q?CekHYw2YRfzBr9iBWtpvQtzHc9AVnO+szg87+BjJLqFwQ5Njj/cLgsxFr7wn?=
 =?us-ascii?Q?BjIxZO1zxJUg7BTjzUUFRw0Pg7uFP0OPaQ2EWSLP4iYJrwZLi36ev6+6RciN?=
 =?us-ascii?Q?us713VodLuItSY0xG7nJwNzpWE/htEaoRsLnnkucxOEik5BtfJL60OI6fEAP?=
 =?us-ascii?Q?u0FQDf2AJd70LomPHY/HxLVuHr3VdBZTiflOWMKWPUIwCDlOEqbBMAZK+6GA?=
 =?us-ascii?Q?mXLFwdSyoEoBHIqBKJjCvpdiMzNYFHjNAcL6Ghxz+3iS1mXiak6FnWcEv/8f?=
 =?us-ascii?Q?GmW6rGNDIdaMATIzSYWB7MxczwBKwyHkvLv/CUeQvyC1FTbVe8rhpQnJtGJW?=
 =?us-ascii?Q?yG8D9D1h4CJlPEzucKegKKwu1p+OOGmYtM3v7nkurqekSZtbwphxnNsO+zZ1?=
 =?us-ascii?Q?b6FVW35E4I9yg1UgFJv7J6XsH9eAlf0cnyqBzSjDf10AU8nzF6qRES/gcpFE?=
 =?us-ascii?Q?i3mJtATb/UwmXNV6omDBoajWSYKTLJ77rSxqdfkSA1smMR3A39i5vavZBO2I?=
 =?us-ascii?Q?Au0nq2dGklIE194ZZYOZARdz9YVY9lX/Zl5iuxmQX1IOyOnrKvNHwOmA41YO?=
 =?us-ascii?Q?3hLd7Wu4jfdCFXEw8+bQ1TtE/yuIblZRHpTZeTFaMvAwlc3vONcKt/bugNuu?=
 =?us-ascii?Q?2xtv86qraWuARpwzuI9S8B2xbghA5SOxH431mHWy2PxvRuhIbF15jxJm49CQ?=
 =?us-ascii?Q?sWjQ3l6h7wlZAGhnaIvJtfyac0JIGxFMNxu97KmmlMiXGlt6AR5BunIjDQoH?=
 =?us-ascii?Q?vbEFXs4KnTunoyRHkGPhi1QNBF66n8Z2fkTh2YfiD93cwQCeD3N3P9SxOcBI?=
 =?us-ascii?Q?C+XCKfT3URPeCVCuRTpqbh0gtr/CrsS/Gr13sShYw4piTB5SoXJj5BeBqvei?=
 =?us-ascii?Q?p5VGZsHy8ZKIhBi01rdEpSsmTbS57P2Gw4Hh/UdzKpetWgVltlfjtlTnT2fm?=
 =?us-ascii?Q?Qj/4xSDhefVTHr74vx/fnXOaeuyHyML9+2MkCQOOK7er2pADnGS0+2h6IwdT?=
 =?us-ascii?Q?d0lihLoxbkcu6rE/SkwPsEu/etMHAbpBmjYqc+XYUgrXwFY4rl/W2oicLQQy?=
 =?us-ascii?Q?Sg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?H/OgLypNiuIdjAAydNuUgdOVyRhyS3pUWz8PZhZEUB338xQVmM4FtN1Et0yC?=
 =?us-ascii?Q?fJzlHMsrletiYCqUvyKyP+PJErDaIbCjMFTrVCyHNotTMxXv7feJPVM8NJ9t?=
 =?us-ascii?Q?tnRsB1xkd1ISTSqwCssdJMhNmSk6GPEANaECnIM+S9sY0Wi5T1bbsgyX/s4c?=
 =?us-ascii?Q?JfM3dsFHzndwZ3f08aJuz9lvY1faXLjN+MpVI4EFL4clNobYAIkuuAzu0NEX?=
 =?us-ascii?Q?FUAG1wdfCzGp/c0fhUir/9u3oVogZii/D855dBLK1mHzb5KHBhiaV9/Y4CXd?=
 =?us-ascii?Q?XXVTGiDxmkxhwClrMi91VEZLV3i79kiF5LTPtmxzpXiuS8E67jXjlta0WIwd?=
 =?us-ascii?Q?O5UEVobojjnhU8mSOZmprzZa6uiixhBmoje9m658SJbow01ix010PiFQqWw3?=
 =?us-ascii?Q?iLZr9X0JZiQ9GjJ8O7DW0+lhBpe51tT4wsvuprGynEEWgDD5aDSQFsuez4Nj?=
 =?us-ascii?Q?IAdpkiJcxyEK08DKHtNd2KwJlNkfvf3WftOpX724laEfN6gBpWB1APBZ3DBo?=
 =?us-ascii?Q?erpInbvFjQjR48gOQy0KaV9TWHXckOQ5jC5EMCvbwPTobjte6ALiCU6tvGnv?=
 =?us-ascii?Q?CKEzktO6LFc4oG7zEBcghqPZLllzZAKu1rJz6NW0lPTNfcvVUT+CkDHRxJhl?=
 =?us-ascii?Q?3Ljw2G8BSxSvGGRRs+VEa+RtaDrdOkca84gn1iTXWzlSuFQ/gw5DtDnT5SDT?=
 =?us-ascii?Q?dfkiwjY2XzqB7Uu3pAB2DtvLqTzXbe5WDKLVq9Jevtg6p2m261hAZciqOXCf?=
 =?us-ascii?Q?I4KnCHRwlX8/9dMrQlIv8Rtn6Mu544ZWLAS/TCwqA0fbl4AIkowBE9ih3/cy?=
 =?us-ascii?Q?yBdXy/aS0lU8oLKaftOhB8gEKcxFafTrArWp2X/lw5JOX4vT/f3p03tsbssw?=
 =?us-ascii?Q?8NDPfgt/GQts4mQntOX4nsz4K7QHWLHXPY34HVfo/AbpxykQ0wS0PYSBgAaG?=
 =?us-ascii?Q?Rq7lxdPHp4BPLppmftgr1ADIxR3Bn9exnghCrzCW6pDYoisQk/z6Oahne/Qp?=
 =?us-ascii?Q?S5E2ZUp0fJLmNeCkY3Ra5JmgLXXrzbolxZtTH31PSeXJ0e8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d299e70-6e5b-472d-d8e4-08db049811b6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 21:05:38.5229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yh6KxMiTHuSaGMh68wLfCPfYYwPhplCVk0TFkqwLJfMoMUd85PEfzrPGINXM4IwVn+AbFHUrTg/t6t9tT958CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5957
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_04,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302010178
X-Proofpoint-GUID: 74MBFRSIoLiGDksvp_qlhHiG_Nv3Hqr6
X-Proofpoint-ORIG-GUID: 74MBFRSIoLiGDksvp_qlhHiG_Nv3Hqr6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/01/23 08:47, Michal Hocko wrote:
> On Mon 30-01-23 14:08:47, Mike Kravetz wrote:
> > On 01/30/23 13:36, Michal Hocko wrote:
> > > On Fri 27-01-23 17:12:05, Mike Kravetz wrote:
> > > > On 01/27/23 15:04, Andrew Morton wrote:
> > > > > On Fri, 27 Jan 2023 17:23:39 +0100 David Hildenbrand <david@redhat.com> wrote:
> > > > > > On 26.01.23 23:27, Mike Kravetz wrote:
> > > 
> > > Yes, this looks simple enough. My only concern would be that this
> > > special casing might be required on other places which is hard to
> > > evaluate. I thought PSS reported by smaps would be broken as well but it
> > > seems pss is not really accounted for hugetlb mappings at all.
> > > 
> > > Have you tried to look into {in,de}creasing the map count of the page when
> > > the the pte is {un}shared for it?
> > 
> > A quick thought is that it would not be too difficult.  It would need
> > to include the following:
> > - At PMD share time in huge_pmd_share(),
> >   Go through all entries in the PMD, and increment map and ref count for
> >   all referenced pages.  huge_pmd_share is just adding another sharing
> >   process.
> > - At PMD unshare time in huge_pmd_unshare(),
> >   Go through all entries in the PMD, and decrement map and ref count for
> >   all referenced pages.  huge_pmd_unshare is just removing one sharing
> >   process.
> > - At page fault time, check if we are adding a new entry to a shared PMD.
> >   If yes, add 'num_of_sharing__processes - 1' to the ref and map count.
> > 
> > In each of the above operations, we are holding the PTL lock (which is
> > really the split/PMD lock) so synchronization should not be an issue.
> > 
> > Although I mention processes sharing the PMD above, it is really mappings/vmas
> > sharing the PMD.  You could have two mappings of the same object in the same
> > process sharing PMDs.
> > 
> > I'll code this up and see how it looks.
> 
> Thanks!
>  
> > However, unless you have an objection I would prefer the simple patches
> > move forward, especially for stable backports.
> 
> Yes, the current patch is much simpler and more suitable for stable
> backports. If the explicit map count modifications are not all that
> terrible then this would sound like a more appropriate long term plan
> though.

The approach mentioned above seems to be simple enough.  Patch is below.

I 'tested' with the same method and tests used to measure fault scalabilty
when developing vma based locking [1].  I figured this would be a good stress
of the share, unshare and fault paths.  With the patch, we are doing more
with the page table lock held, so I expected to see a little difference
in scalability, but not as much as actually measured:

				next-20230131
test		instances	unmodified	patched
--------------------------------------------------------------------------
Combined faults 24		61888.4		58314.8
Combined forks  24		  157.3		  130.1

These tests could seem a bit like a micro-benchmark targeting these code
paths.  However, I put them together based on the description of a
customer workload that prompted the vma based locking work.  And, performance
of these tests seems to reflect performance of their workloads.

This extra overhead is the cost needed to make shared PMD map counts be
accurate and in line with what is normal and expected.  I think it is
worth the cost.  Other opinions?  Of course, the patch below may have
issues so please take a look.

[1] https://lore.kernel.org/linux-mm/20220914221810.95771-1-mike.kravetz@oracle.com/


From bff5a717521f96b0e5075ac4b5a1ef84a3589b7e Mon Sep 17 00:00:00 2001
From: Mike Kravetz <mike.kravetz@oracle.com>
Date: Mon, 30 Jan 2023 20:14:14 -0800
Subject: [PATCH] hugetlb: Adjust hugetlbp page ref/map counts for PMD sharing

When hugetlb PMDS are shared, the sharing code simply adds the shared
PMD to another processes page table.  It will not update the ref/map
counts of pages referenced by the shared PMD.  As a result, the ref/map
count will only reflect when the page was added to the shared PMD.  Even
though the shared PMD may be in MANY process page tables, ref/map counts
on the pages will only appear to be that of a single process.

Update ref/map counts to take PMD sharing into account.  This is done in
three distinct places:
1) At PMD share time in huge_pmd_share(),
   Go through all entries in the PMD, and increment map and ref count for
   all referenced pages.  huge_pmd_share is just adding another use and
   mapping of each page.
2) At PMD unshare time in huge_pmd_unshare(),
   Go through all entries in the PMD, and decrement map and ref count for
   all referenced pages.  huge_pmd_unshare is just removing one use and
   mapping of each page.
3) When faulting in a new hugetlb page,
   Check if we are adding a new entry to a shared PMD.  If yes, add
   'num_of_sharing__processes - 1' to the ref and map count.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 mm/hugetlb.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3a01a9dbf445..c7b1c6307a82 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -96,6 +96,7 @@ static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
 static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma);
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end);
+static void adjust_page_counts_for_shared_pmd(pte_t *ptep, struct folio *folio);
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
@@ -5905,10 +5906,12 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 	if (!pte_same(huge_ptep_get(ptep), old_pte))
 		goto backout;
 
-	if (anon_rmap)
+	if (anon_rmap) {
 		hugepage_add_new_anon_rmap(folio, vma, haddr);
-	else
+	} else {
 		page_dup_file_rmap(&folio->page, true);
+		adjust_page_counts_for_shared_pmd(ptep, folio);
+	}
 	new_pte = make_huge_pte(vma, &folio->page, ((vma->vm_flags & VM_WRITE)
 				&& (vma->vm_flags & VM_SHARED)));
 	/*
@@ -7036,6 +7039,43 @@ void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 		*end = ALIGN(*end, PUD_SIZE);
 }
 
+static void adjust_page_counts_for_shared_pmd(pte_t *ptep, struct folio *folio)
+{
+	int shared_count = page_count(virt_to_page(ptep));
+
+	if (shared_count < 2)
+		return;
+
+	folio_ref_add(folio, shared_count - 1);
+	atomic_add(shared_count - 1, &folio->_entire_mapcount);
+}
+
+static void adjust_shared_pmd_page_counts(pmd_t *pmd_start, int delta)
+{
+	struct folio *folio;
+	struct page *page;
+	pte_t *ptep, pte;
+	int i;
+
+	for (i= 0; i < PTRS_PER_PMD; i++) {
+		ptep = (pte_t *)(pmd_start + i);
+
+		pte = huge_ptep_get(ptep);
+		if (huge_pte_none(pte) || !pte_present(pte))
+			continue;
+
+		page = pte_page(pte);
+		folio = (struct folio *)page;
+		if (delta > 0) {
+			folio_get(folio);
+			atomic_inc(&folio->_entire_mapcount);
+		} else {
+			folio_put(folio);
+			atomic_dec(&folio->_entire_mapcount);
+		}
+	}
+}
+
 /*
  * Search for a shareable pmd page for hugetlb. In any case calls pmd_alloc()
  * and returns the corresponding pte. While this is not necessary for the
@@ -7078,9 +7118,11 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	ptl = huge_pte_lock(hstate_vma(vma), mm, spte);
 	if (pud_none(*pud)) {
-		pud_populate(mm, pud,
-				(pmd_t *)((unsigned long)spte & PAGE_MASK));
+		pmd_t *pmdp = (pmd_t *)((unsigned long)spte & PAGE_MASK);
+
+		pud_populate(mm, pud, pmdp);
 		mm_inc_nr_pmds(mm);
+		adjust_shared_pmd_page_counts(pmdp, 1);
 	} else {
 		put_page(virt_to_page(spte));
 	}
@@ -7118,12 +7160,18 @@ int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	pud_clear(pud);
 	put_page(virt_to_page(ptep));
+	adjust_shared_pmd_page_counts(
+				(pmd_t *)((unsigned long)ptep & PAGE_MASK), -1);
 	mm_dec_nr_pmds(mm);
 	return 1;
 }
 
 #else /* !CONFIG_ARCH_WANT_HUGE_PMD_SHARE */
 
+static void adjust_page_counts_for_shared_pmd(pte_t *ptep, struct folio *folio)
+{
+}
+
 pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, pud_t *pud)
 {
-- 
2.39.1

