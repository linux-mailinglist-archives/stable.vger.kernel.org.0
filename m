Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8504C681DBB
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 23:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjA3WKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 17:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjA3WKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 17:10:10 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE30530B02;
        Mon, 30 Jan 2023 14:09:38 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30UM3iDX023836;
        Mon, 30 Jan 2023 22:08:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=6jdlMh4cj4GoGxLUXvh2tXm6ZLUNsMqrNqM7K0LXvoU=;
 b=VYSU0ZxbdkftRrVdzETcrVN60V4kyE4pMZY6u01khwa9u4UouduYUbBA/c4e4pthmZfP
 xo1SefJtiSdHFR5N6qLX+QCWPJu0jv4fEYObhRw62gnFVGEKZu4uljW43v3zSGxhfzbo
 kMz2jxOX8UeYn+/+clACQ9DrMvPVV5LgOJRZiyiI3E2cX1UqNMZz9NZCohwl3wr+V/SU
 0Dlz/Ydx09+8O/jjGCW2yIWN7rMqbB2epc8JTvggJETCTzYWUwRqms8nC3BjvjE9qb/k
 oVzJDIbxgGu6cLODKAIPeqV9/GmSxoalO24OEVTXIWDQjvSGEjeTHh1/L+O7QoqHEutb Lw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvmhm47a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Jan 2023 22:08:54 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30UM2f34010420;
        Mon, 30 Jan 2023 22:08:53 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct5508bf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Jan 2023 22:08:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEfNk0N/fC5IvbqzpH4yqDMZHQr6BZtPuIa8eLJX2CQUrc6o4zjJ5Uf3eBgxDpu2FOBTgYlkqAepyI1sK23tsdM1uyVSp2CjCGCNKz1OI9ZNXBfsjQYmUo98SwnePjlRZOxQ7TZIu7c/8BhCMfn4wxJBjQyTrKs1A2kNwU7TRyVWzhxpp+X8ZN2lQV9B9b+WVP+I19Hhe/9TiFqtOBV6LduKLNp8TVuyyIWGi4KhK5/ukSQWKE0xJ/VlrzFCOr+uQPFhWk9YeyYkoJnIvNdXw18pSAjhNH2tcEDONK/ZaQIr1/XIpRfxWenq2zm7pY+iiuOTVM6a6qqwKcwa0K2oYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6jdlMh4cj4GoGxLUXvh2tXm6ZLUNsMqrNqM7K0LXvoU=;
 b=Futn/1TT04a0aQ7Lrlr3nNJLRqhaJMaonnLsP+LvjgQNZI+sXli1j5lBsNOhc8hiRbaVed8qxCtq5eKvs81/TgpkZzy1puVDW8t492QaC9QAqcuRnvm1mHb4zbOH6SsBWuVooEHEautxUB4xsCQ8ajKwxMEbOMOZQV1G/QlKy8640HZ8k0ciosZSHvJ0a2qRKyuxszyVfuUG6mxyUz9xuSPXGIcEzOs2cvrqxWghcHYEpCkSObqnpAIYHFOTkT+NZfyVuWpDoqxs8w3sGBqIHIm/ZVJjrX5ztTQIcNnlmsQsyDG/y3EQAfM/Q+dAOQuI7t5U6ADNPs7FQ13B098Ijg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jdlMh4cj4GoGxLUXvh2tXm6ZLUNsMqrNqM7K0LXvoU=;
 b=rkidPfGZDLPBldEqjoqWSfoGMvY3bjrbxcGJzDPzbueuNMAlMgD1E/hdkUrfFb49anYvLfK97QZJlXOLFKRJ3/BfYG2NLsu0gCLChz+je1az9JS/uZ3WD2SGDTrTbKMrKpXbWdJUQEwv8d9SkfY11U9crD4V4MJp08NV4uILUjg=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by PH0PR10MB5562.namprd10.prod.outlook.com (2603:10b6:510:f1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Mon, 30 Jan
 2023 22:08:50 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14%9]) with mapi id 15.20.6064.021; Mon, 30 Jan 2023
 22:08:50 +0000
Date:   Mon, 30 Jan 2023 14:08:47 -0800
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
Message-ID: <Y9g/70m15SwxkLfc@monkey>
References: <20230126222721.222195-1-mike.kravetz@oracle.com>
 <20230126222721.222195-2-mike.kravetz@oracle.com>
 <4ad5163f-5368-0bd8-de9b-1400a7a653ed@redhat.com>
 <20230127150411.7c3b7b99fa4884a6af0b9351@linux-foundation.org>
 <Y9R2ZXMxeF6Lpw4g@monkey>
 <Y9e56ofZ+E4buuam@dhcp22.suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9e56ofZ+E4buuam@dhcp22.suse.cz>
X-ClientProxiedBy: MW4PR04CA0196.namprd04.prod.outlook.com
 (2603:10b6:303:86::21) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|PH0PR10MB5562:EE_
X-MS-Office365-Filtering-Correlation-Id: dbc7d306-e732-4813-e0cb-08db030e9145
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pWQFDEMgSsXFDdxzsR0Qgr8OqcCmSpBisKAKLu/mEmBMDn1InyY7OUi3FgfUvZ0y826QSwZqr7VylYXPGCXCKDCVEUVTwcLQdIW8i4MYeok7lpkQDJfadHQ6aItDBtWWpbbXmU0rgkiVhsK00DyrobtowGUEKMRCRiVM14vI6DcU+tr9xY+VfDj2T1naFfPH1Ib+FescBMos+HKYNZmkpZCowB6LVYazmBDKQjiBWrIXfNi3Yf9Gw5ALfNtqmFVl4t63mhfsma+q9dGtuX2s1928Y7yzGPH01QVhsUetAAxj8EkFlh4fQ3eLknuq2KEiU+ChwS1Y2VeKjAxMxvLXk+ZjMvlW8LflXX3Ij6ADcpRj5EiLSrEAwGBBpWFOoBkz8yglKbauyehqcYuJhKjTGLKtfqMek8gXgmTdpVHOWxcs+fOQWGu3t/jGwm2Uvf01VQbGiGY8RMs6FEESZXOTzLvuMB9camBdVYwldmK5WghBNxix5qHCKJgtkpKMpA5uo6Rw0yWBqBUR1Y8z0wZ/Du0UW+FaJ81NcnTS+HtpLePnmN9J9+V+jvXw4oYBA8GtIkRw3qk7tKDvITXZiNRTNVEhQx8fkaEkJVSSWSvQrdPcUfuz4NRiBcRi660NiRO0g3vpUMR9OY2nJtxKvcBtCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(39860400002)(396003)(376002)(346002)(136003)(451199018)(478600001)(6486002)(26005)(83380400001)(86362001)(38100700002)(33716001)(186003)(9686003)(6512007)(53546011)(6666004)(6506007)(4326008)(6916009)(8676002)(66476007)(66556008)(66946007)(7416002)(54906003)(5660300002)(316002)(8936002)(41300700001)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3bL5mplmdYYRTofyVYFApLQXYDBxQMaQNryzmEHUPD4F3LP4Phd+u2U9+zQ9?=
 =?us-ascii?Q?L7dlWNiDFt3ltH9lNw0aKUSpExb40t2kyDwpCCNiVuNO9gmXJr2+3GR2D5IS?=
 =?us-ascii?Q?kggnk874QNc5Ift/nJd90ueNMBQP6pl5rMjn7rPrhLvb2i7x9bGD2luMff/t?=
 =?us-ascii?Q?W4Yp+EFPY5ZGBkRiR29riQJSEIdlYGtj6ZhITatNP3EuFQAY03jXoUMwv2Nx?=
 =?us-ascii?Q?cnssVlbKOXDGZgxKx7uwrLEpLMc94/n0ViQ7Ho4zKQ304naSLLGzDN35UuNZ?=
 =?us-ascii?Q?8t/Q0ditlSvf2rnFw9AHdugZH2YpLE4J1o8AkRisaekm+wXmQ7VouDEwwbt+?=
 =?us-ascii?Q?0UtbcFTz8ZW02jbVDAkbxk+Y+uQvQBEj6BNR7Nl4x1fAj0GtWMlxIftGVZMW?=
 =?us-ascii?Q?t1T6ktTmV6wSIUb8F5mpEwcociXdLSmgBBDkAx1P9eBFkllEuA2pTSFz4tbQ?=
 =?us-ascii?Q?MwCCokcs66okjP4zVRQ8mPhss7tlOQA6lwVLNm9zKu6Ibjml1ABQ7RvnV+Ih?=
 =?us-ascii?Q?GjveVe5SrJcyt45k/Pr+2IiwA2trRiK+ifUVgUT77dYWozp3HNHXMngIfpJd?=
 =?us-ascii?Q?knjJx2LJd6hScQM2KfRVKavm+bTENBjY2CiBz7Sl5TIrmIC3z6lZuQbsFSMd?=
 =?us-ascii?Q?kFR981Lgh5dB/oVQ4bKLW6g+KEB765CPmsUyXfUWixP8EGdyo6vOGOPbjPWH?=
 =?us-ascii?Q?63dFxUO14PT6N+oj7lqmEJGl80dbLTSMF9npCaBkWplv1uWrQVwM38WIbiMg?=
 =?us-ascii?Q?OJB+dM3bDUs3tOdBj+p8wRHu5+5/sDYz6cBLD0PBS34iQwuEKR3NV6C5ZUAK?=
 =?us-ascii?Q?iwldJHAcBCDPCTrgqWDYqLLJD4xg6zW8HCLIugb/1xRcqVKgbfqyF+hVK56a?=
 =?us-ascii?Q?mXRKNCXURhXxEJgWfzSB3HKtYkSiPY2BHD/sgOukFmSBcYIQNjANiSXxIzcb?=
 =?us-ascii?Q?HivzqLtcyh5xTvMbvlX+l8qBa2VufHuKMMxnoEv7G7hWvOHIyVWo4BalBWbG?=
 =?us-ascii?Q?YCb9gW2Ohw2uWiKCmdCVClPTtRb9KfrqJd4gUTtY7sQ+KmOr93RhsBiLqS0P?=
 =?us-ascii?Q?kJERLYhTeApWBvNTHPWOukrj5J5uk6pwpM6jRSGwXdYn9XUsfYO8LR1BEezb?=
 =?us-ascii?Q?CbH7DlmsHVZA9+uqGuzXvS/VjkSLcXQ2diV6GivWl5wsG3NgsC2BDClQxiTw?=
 =?us-ascii?Q?26RsMBA7LFh8og1K8qq25u3XkTTbxWDrNr5so5AglHPlD5OErKv0fcB6hPdR?=
 =?us-ascii?Q?CkYFgZO+OmKkvwXpwe3M6I/sIqmWxFe/159Blk7VE/eJBieSJcL5u5cs8Aep?=
 =?us-ascii?Q?oRrWTRM1UZT42uNmLGmHGTKBYyJtE6jHLc2vMdz55mPVVwv2qTsugwv/ME9u?=
 =?us-ascii?Q?TrA5rc3OmbyqUKGpmg4UNNBbcDcFJ4H7LYdEno+nXy31RTjB3PYNEzlZpkrP?=
 =?us-ascii?Q?Y8HXgROm4h8Sb89vMVf30hybJkdLiDFpyBf2cc+jOWbC6Rei4u2OQ7IlWYRo?=
 =?us-ascii?Q?2TlsQaFPjGRkYwb7Kc5sG41kX9aZfw+CZX+gVnqAICPh06jrLS9PR1XEI2xM?=
 =?us-ascii?Q?dzZqFDTtBbFfIQH+FlkZliB0/ED1qP774FxrSCANLdQ/F1fZ/owN5C4LIvvT?=
 =?us-ascii?Q?uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?YnL12xVxr3a9K5K4UbIRLcYqT3K61dSwBKwWbyJBjON7L3WIPdw3GF5+Zpi4?=
 =?us-ascii?Q?WXpZIkF6auVRTMEXo/1uC8JcBd0YkfqOt78VXx6sYd9y7un9alJ0ly3t+m1Z?=
 =?us-ascii?Q?mxFZT5uGgI/y1REZ/PJC2O472ntT8IjIglZ+0RGSRli73ATl0sS6w3wa1Lbn?=
 =?us-ascii?Q?f4cIof2y9qUeZXQ49ItyoABqWXQcbUxR9p1fH2JST6pHFqV9pjd1+P0GJFhw?=
 =?us-ascii?Q?AnF87TokgNWHeIxYPRfM/J75DxM5B1fhztmqT9Lx9kL+sM0EnsNJX0p5wQbU?=
 =?us-ascii?Q?Ryya3hFzTw22BuBxYnlK5euS+Kg487bBzpMWgXytgVLb0VCKr+h/56ihkaCS?=
 =?us-ascii?Q?XxOvfa1XsOzmRNg/Dk6pz8KNEQir3TbwRdlvsP0t/LCPRLHaBrLkPiyaYfKZ?=
 =?us-ascii?Q?w3Rx6zx1guw++Nz5c52qKCpmd5WBlJhMCxFaU9tRLR9QfATtiTF8Pk3YGK2C?=
 =?us-ascii?Q?Fw9AmgkXw3qx9M1P18mSynSo+jxE1q39PD65hN2PCE02p6/X4FROXkRKjohb?=
 =?us-ascii?Q?+2Ss6wyux9ieJkbFMnL7w/X2eiLbW3C1flVrjFyHEgy3dkZpJwsPyr3amYjL?=
 =?us-ascii?Q?o5Jl6hb5YcVD1dGwdW3WaSS0VCFpcYAs53O1tE2O57WbRDEHhCpKFzAPach8?=
 =?us-ascii?Q?gDYrvPl1UpbjOKyxn9vtElW3InAzm9wwgG7s/rYZU4DwdnBqziy10OFlSpaa?=
 =?us-ascii?Q?yOOGyWG+wRWr7xVjtDnly+RaV982DSC2zxRiSy0XVF/xCDDNBZPTXDzezm/l?=
 =?us-ascii?Q?9hV3MZn0wgcr6+MKzYuDtVo4q4yZZA42Qs1T3nXpHaRfk6vtRcQnOHwr8W5G?=
 =?us-ascii?Q?+Q0KlOaswFns4j9qsFmBOgxGJ/jHHBtIT8CxKgg19ixbk2wECnEizjBpzj8M?=
 =?us-ascii?Q?KKiedVOAOF7eB8LiLmntmXDCuxhMgD4Ox6s8k1qDI4u7hjaBMdP8wZHDHPLb?=
 =?us-ascii?Q?2QmFR6COTfyYtpoEE5shFKhGw/aftFXFpBOth7j9sjoIFRecg5l6oVxRtxCC?=
 =?us-ascii?Q?fD5KybhfTwvMkgAqDVsOmMQybtt02WM6gEx4EdqK/SE88OcfmuG90I+T5TGb?=
 =?us-ascii?Q?urah5CmH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc7d306-e732-4813-e0cb-08db030e9145
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 22:08:50.7882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 51yTO3UXI9PRO8ykbaEmOMuf1ssTOpl5XyEhss1wtLaLHVd/OCUhUymMLeqEuJ9GsmYo48J07pKMYjr2ZPGffw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5562
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-30_17,2023-01-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301300203
X-Proofpoint-ORIG-GUID: za57tjRFcaK9Hu2iDRfkcvwrqBPcCMHM
X-Proofpoint-GUID: za57tjRFcaK9Hu2iDRfkcvwrqBPcCMHM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/30/23 13:36, Michal Hocko wrote:
> On Fri 27-01-23 17:12:05, Mike Kravetz wrote:
> > On 01/27/23 15:04, Andrew Morton wrote:
> > > On Fri, 27 Jan 2023 17:23:39 +0100 David Hildenbrand <david@redhat.com> wrote:
> > > > On 26.01.23 23:27, Mike Kravetz wrote:
> 
> Yes, this looks simple enough. My only concern would be that this
> special casing might be required on other places which is hard to
> evaluate. I thought PSS reported by smaps would be broken as well but it
> seems pss is not really accounted for hugetlb mappings at all.
> 
> Have you tried to look into {in,de}creasing the map count of the page when
> the the pte is {un}shared for it?

A quick thought is that it would not be too difficult.  It would need
to include the following:
- At PMD share time in huge_pmd_share(),
  Go through all entries in the PMD, and increment map and ref count for
  all referenced pages.  huge_pmd_share is just adding another sharing
  process.
- At PMD unshare time in huge_pmd_unshare(),
  Go through all entries in the PMD, and decrement map and ref count for
  all referenced pages.  huge_pmd_unshare is just removing one sharing
  process.
- At page fault time, check if we are adding a new entry to a shared PMD.
  If yes, add 'num_of_sharing__processes - 1' to the ref and map count.

In each of the above operations, we are holding the PTL lock (which is
really the split/PMD lock) so synchronization should not be an issue.

Although I mention processes sharing the PMD above, it is really mappings/vmas
sharing the PMD.  You could have two mappings of the same object in the same
process sharing PMDs.

I'll code this up and see how it looks.

However, unless you have an objection I would prefer the simple patches
move forward, especially for stable backports.
-- 
Mike Kravetz
