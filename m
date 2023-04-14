Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCDB36E2C69
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 00:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjDNWR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 18:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjDNWR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 18:17:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EE940F1;
        Fri, 14 Apr 2023 15:17:55 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33EGuqjU028703;
        Fri, 14 Apr 2023 22:17:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2023-03-30;
 bh=fSu6M0ulZ9vjoHVAOZifvSvhqwPW4VMg0pgzZy/PM40=;
 b=RQirgGJ+ByYP9qw9Aicus5PhlOOXNWSuA5KXNe8xwja0sq3RsSmD+rO78+jYfXVgwVch
 j9tcfRlbDmXqrJV+2/QtzPtm1k7hTDudT8X9BLSf81M9YCgrVS9C7XSNaRPQfnAC0gMj
 sx4lGL9LRHX6qM2yZ2ImS8nOHE4K+6jNTfN7SlFz5cP632p/OW5mvcqr2Jb2e1ZmNh+9
 7YC8on/W/a/EXVVvn3q3VENmbU+e4LePCFItLoh+nkjsxiW5iCnw0nB7g9XOGY1qW4OP
 zitrra30CkxK6+yARbUs739r0nSH9Nf5Tb+YT5kTZ5UTVipR1n4vCR0uZupfQmvWqMz9 nA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0etxvmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Apr 2023 22:17:46 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33EKTc2m040335;
        Fri, 14 Apr 2023 22:17:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw8cdsjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Apr 2023 22:17:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQFHsFD6Ify8OpKPlFCDOZtWvVBLd4zJhWgWqRpbCH9+/w3KE9R1DaoyIO8syvgjkLlkHN1/1HotL6sHC+BN4eG1bzQ1l45WIGF2xrNXn7oyRmN7/Gvo1it2RxDDJP2oT60TfYVFwwHyrSprioJMxoju34nBPamxJnfohQRk8V7/rgqay1dzlnK8UQdnZIwQJO5ep8KQkcYPEArHi5qaXPjfKg2uQejUi6zq1AcuIHcc/yX12BTnSAu5Anr0dVjxUX56ZsOfCQjnWLMi/jzfuIXzk9Gzr/i/X0Vk5gLPGXTR8K6nEtm+HY/p2oi7DCnHfuA3v5+agaKoTphVElFPKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fSu6M0ulZ9vjoHVAOZifvSvhqwPW4VMg0pgzZy/PM40=;
 b=l/PfHBC0UtOZ6oUP3mFrCyqChEUlv+wSsy5Y4dVG0UBKonTf5JysjYSS0p1os4rnSx5bm9EccCQjU6kkN2lnsINYwfnOLSlVU2FvdkgQome1rUAtb++AHlzZ5CT4fCAbnN0T9BNGCVkifASVc7K6iZeNrj+wSi+znL9ZQWHPlClBg4U1ZcHDJ8ENMxVgRXvusQ8Z9MmPrcvePSfTCXhjpQRKidBGWDz4C/hXgZFsBBoPvJo/oNH+J2zZyyy6XVXLL8sS5PMD4QuCVRg2DxSM7rwv2kSN0f44maohEm3uKphPjLGZkOGIyTSG03BqsT/CwjPWnZSOeTg6+tjkfKGxfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSu6M0ulZ9vjoHVAOZifvSvhqwPW4VMg0pgzZy/PM40=;
 b=tGe2DBZ+skZFJx/t1PmDvITe2rsJ8zf+Yh629szvZh6Bkdbe2rQpj2s7OLTIi/72eTqpakjwOAh2ZIJWSDgO/smm9RNNpwkCqWg/VgGQGr+qQDAhJvSDeo5LeHdFofhg4inX7+2aG+4pihQ5bn14x/7r6ukRZQ8VwHmS7p9A9JQ=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by CO6PR10MB5633.namprd10.prod.outlook.com (2603:10b6:303:148::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 22:17:42 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::ffb:de39:b76b:52eb]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::ffb:de39:b76b:52eb%3]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 22:17:42 +0000
Date:   Fri, 14 Apr 2023 15:17:39 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/6] mm/hugetlb: Fix uffd-wp during fork()
Message-ID: <20230414221739.GA54118@monkey>
References: <20230413231120.544685-1-peterx@redhat.com>
 <20230413231120.544685-2-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413231120.544685-2-peterx@redhat.com>
X-ClientProxiedBy: MW4P220CA0015.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::20) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|CO6PR10MB5633:EE_
X-MS-Office365-Filtering-Correlation-Id: aec8bbcc-1f03-4d97-3271-08db3d3610dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AtKf/QjxPOqGNUe8vYpJHy8FfjvUB556Ah17IWIdtIBF2mKAnmNMGsRT6MIJO+y83MwXDm2WHaMzd7GTvKvkZecOMUhZRlFzDqveU9mSCEzqdRk8C+ncaVFXTiWi2iEMokGc2uGH2btNdEYgIaumzkkkHQQwquu6rzZ8io3xyyBz8ivW0pjf1zQs8gU6QBeAKvRNs8jYZoOESR98bSHZyz7xq/0AwfYAt0/SYVpRZX+GFuHprV3+/wM15MayqzmnLGoJq98DvrVv1WRFa8MxhVhRtkOMgZIVjqLqaVcgJeR4p3hnTlbi6IMGXq+gRLl7ViRdzYf4ubOEaIvFgNMqY19r6/bmv8IPlLq15LNEnMLv3v9TiZf76FemtU43IuRy71D052jH7HGgCI25HRmZOBv2r8hknBWxQ6AgKoZwohCOK0P9pkYBhuo+JzWJ0UP4TNcCet5n2y91dDypiAvb8iCbETIdoEJV4UpISGDKLP9l2WdDPYqyka+FjnYiuclnVHRe2y0LCwaKWKTLd9QpBc8fnCjfAVg4taeCt8LoEk4cu+kx58Q9Vc+rTYDF/1k1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(2906002)(8676002)(8936002)(38100700002)(44832011)(5660300002)(33716001)(33656002)(86362001)(6486002)(6666004)(26005)(9686003)(6506007)(1076003)(6512007)(54906003)(478600001)(53546011)(83380400001)(186003)(316002)(66946007)(41300700001)(66556008)(66476007)(4326008)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sYOfmrtEs1TuR1ed+lIOsRR7d7L2Ba8f5OVDX4+RhMXqPi/o2X7+BDqX2DZb?=
 =?us-ascii?Q?nmqgtDCakfZDxzJGeeTAgNwilpGNv6DYq0tofMXGa9gH55C5RNJRKDeTu719?=
 =?us-ascii?Q?f5+iu4JwaIB7oG5cXu1w4iQNEnGNbSf5hnneF4HpZmbq2pNRO73W17SgmWQa?=
 =?us-ascii?Q?b2LE56cs+22udeQKc8QJJrCpaKGm+maZzY18Pu5l9jbv8wpvFCm/gcfvmKaB?=
 =?us-ascii?Q?RWT/ybIdVQibfpIT8eF5zCH1x+oxDrtW1nbGrb4fYwfVymajBYvvrGRegVIn?=
 =?us-ascii?Q?63tbjb9CJvzssEMkTMqDzWcC763sovheUc2QRuG4abbYrU3DrO9lnxQ7QK9O?=
 =?us-ascii?Q?5/hmuT39LNqeKCyhWadCdtdDEEbPlkt8rorGliQuG47l83H2EZmHr5oe5Ygh?=
 =?us-ascii?Q?NU2t6hpqBYAxu3jz/ZvUl4s6njQiud8Z6fR1dglI7j5pczhHnLmzVEvCW386?=
 =?us-ascii?Q?Ss6pgRF4lagH3Xip35IfZSk9twoWMpB9v5CaiLz153JETL939PAAXn3gZLdT?=
 =?us-ascii?Q?vygHl+OmG5iC64CmDbMi3Zx9UDAcbgCMv5uJD4K+3TE3dOPxZiS4zqZfIuaI?=
 =?us-ascii?Q?p8SPwcRVHwP+PE1VCvqcpMGqgNpEUZ8IDPmi5natHYmSG9arXueUhKD/S2nU?=
 =?us-ascii?Q?UTRKsbK0wACiq9137TwBbYthWj1QJkdY7XqwB1ObEEew2OF2EzhkGmHFoamf?=
 =?us-ascii?Q?pBYh4N4HZzLox1u9yoOEh3r/JAXKNN+1JEmIPhusQyM6iirDElsrNRJm/QLD?=
 =?us-ascii?Q?5qGE/Z9iGv9G7JXFraDdVBP+UWMNkpFpXLYf1RKmmIpwpOs4IJB3YlWUMGZE?=
 =?us-ascii?Q?lCUurpRHuWyd7Imv+WzzU8jESS6TigBwkAFhEY0ik11BFdSynNEU1H1aV16r?=
 =?us-ascii?Q?J8LLLXBva9Aol3XOu1clbi+pO6fJ2Hx/GuxkHU1NTm6mp9cpDufBUWQAvJQH?=
 =?us-ascii?Q?SXLq+OPtg46Sf+ZyWdTGhmHV6QVJhQpBaT/cUtpbMvX89CMtAHcHQZNNx7w1?=
 =?us-ascii?Q?OeMu8lRfo87gSFLW2Y7Wx31smHqE06wVV7DvpVSHVKhgUsXmXMZrriG2Yoyk?=
 =?us-ascii?Q?+okZtoqdpx0jn45TPyxmrtzVUqEtu9WxL9eCoWnBlvfpVXe0UtbGaXneqf/u?=
 =?us-ascii?Q?YX3uez/+qIgRTgWSglN9ubTJRCYps/0nhAu1jHrWnsxer1o136oLP/wkcMeS?=
 =?us-ascii?Q?lVGeC8MaCAUOwKjuD5UVJ9aWZFgu85oRMhZKby+GP4dAcE6F0nxkCVRiNDLW?=
 =?us-ascii?Q?ja9L4NCJCVBl9bFpKIvG+0ffqV7wAoV9pqCGqKSUJ4/GxAwBPb7aLMYohBZN?=
 =?us-ascii?Q?cmCr5SKg7+1osFUIPIWQU4gE2Y33fsnVI0QvwQVjuwjXf8uLEBllltfrSTY0?=
 =?us-ascii?Q?Z7/2qJr/6aqr//qyGvVKnioo/L1KyhXz3p0dr6jsKJpZQZffZtkAXm1DAVHM?=
 =?us-ascii?Q?5xFZkAra5brhIPls3QZWPyj1TafIGqKRWs9eURwEZe/8U888ryKa83cUCubW?=
 =?us-ascii?Q?MXBwv6in6q33BpgzAwoPZleHYOW4P3jli6t3FPt4bkhw1TLQ0CluJ25Kh1Xg?=
 =?us-ascii?Q?oGeL/xrtyZ4aeZWnG1DM9RxIMFTDA6LSpWB+V8bD?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?q4aFjsjFs1avmHyVQnFcBS6fFQf/1Az2FLe5L/URhB2/dKeg85QrW8DnaW1w?=
 =?us-ascii?Q?hy1AA6rb6uAZhd0Uk2cr4OT/l3SaKNnCRnmMQY9cBJGVTMNaaSKd++wQE7cf?=
 =?us-ascii?Q?pGfKpc0Eq2yUZPK8RX9FS7iI+fbatDS4hGSP6pIpZ8yY5DTnkXCsmY/9Ii8Y?=
 =?us-ascii?Q?G9hgoDBzIY9fROcHjk1SPrhYzGC4rCpew7B3Q5T8TWvWtOauaqvaaavuk5IR?=
 =?us-ascii?Q?qPT1aRf2AIONqERaJpzgwZPbUa4m8hCl09XPWZzJMbdm+OazgYreM5ibO4CY?=
 =?us-ascii?Q?U69GHalJqdpAxav4IF6HVwKqcg6Af/7uUgjvVAFDXRPi/IEydz86AtDYGVOn?=
 =?us-ascii?Q?7onTHKSoGjZlgB2u/0S4YEGKgdh96iwEwl3ZV8QS/iBUXLW8g91G7rW/2+B8?=
 =?us-ascii?Q?IEL8I0dAxO86L2hPXWhwmyXUrDdMUlWx21eWCau8BDEMSf4rch01/phw3bPu?=
 =?us-ascii?Q?1zQCEaQMes89/lZjLQeMwqw5a7KJTlubFFaq18nKKU7Db1fYzYmZXxwLkbd2?=
 =?us-ascii?Q?oaGW5HXAC0WW/b0DjEbgZmd79RNDd2xMa1V0VhfUo1zID8Rok0GlWNnOxtdC?=
 =?us-ascii?Q?pdo5AFqDJ1NkSAmXqcvlVq5+27swG5k/mCft8SoC7C54lrOgpyU8CllgCWGt?=
 =?us-ascii?Q?nwWM1Jq7AGPy9qkYghnN72rLuBppWNu54YRWk7Dy0czvlx3/Rq17P+v8+7a5?=
 =?us-ascii?Q?B66/0iIrAru8qCdmoFk44L21V8tw7uQ/jKou7QLn5QL8W9elrnvhMgWrElBU?=
 =?us-ascii?Q?XKZuvkTGGRmkpSqCNnIO5/BE7jF1lqiZArQuMkVct2xYnXix47/p5mDSwwFF?=
 =?us-ascii?Q?RvQLp5G4o92avsvMUn2y280RH7UbjtDdo1yJ/pYZq1DaKQCy9K+sSTBmf3dD?=
 =?us-ascii?Q?iedPYSgj0qf/iPl7eBPi+gR9ssQBYrOol3OO9zSDcMd7pljnDrLYZdx7MehB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aec8bbcc-1f03-4d97-3271-08db3d3610dd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 22:17:42.6290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eeGa5xCQ8DTxaIlBNKdAWkTUqji/WudjEIU7CPiVHGUIdhSTbmBOG4FUHjalBx0yCcFCaX6KMxc0LS1UNM4vvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5633
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-14_14,2023-04-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=530
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304140195
X-Proofpoint-GUID: HZM8BhWN1UfjqOf6wuTWDjpCVAJDe6Q7
X-Proofpoint-ORIG-GUID: HZM8BhWN1UfjqOf6wuTWDjpCVAJDe6Q7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/13/23 19:11, Peter Xu wrote:
> There're a bunch of things that were wrong:
> 
>   - Reading uffd-wp bit from a swap entry should use pte_swp_uffd_wp()
>     rather than huge_pte_uffd_wp().

That was/is quite confusing to me at least.

> 
>   - When copying over a pte, we should drop uffd-wp bit when
>     !EVENT_FORK (aka, when !userfaultfd_wp(dst_vma)).
> 
>   - When doing early CoW for private hugetlb (e.g. when the parent page was
>     pinned), uffd-wp bit should be properly carried over if necessary.
> 
> No bug reported probably because most people do not even care about these
> corner cases, but they are still bugs and can be exposed by the recent unit
> tests introduced, so fix all of them in one shot.
> 
> Cc: linux-stable <stable@vger.kernel.org>
> Fixes: bc70fbf269fd ("mm/hugetlb: handle uffd-wp during fork()")
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  mm/hugetlb.c | 26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)

No issues except losing information in pte entry as pointed out by Mika.

-- 
Mike Kravetz
