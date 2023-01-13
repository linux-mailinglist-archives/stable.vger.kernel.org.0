Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D494A669B7D
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 16:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjAMPJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 10:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjAMPJc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 10:09:32 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E209B298;
        Fri, 13 Jan 2023 07:00:21 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30DDUxwM025706;
        Fri, 13 Jan 2023 14:59:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=cqjK3J4uvhIT/NAntM1OlH3TwCp1H/jgGCZ8OvUk/2c=;
 b=HrREvSHd7g7iuK5vHIii4Yt7c/Z24IlD4Bb95+1j8shBK0Avk5RGN+7vYLgWUSDim6mO
 Cw0deg4OiMpPcQrIgnRJqxvZuF8TsdCE+DZl6Xrt64NzVWECjpExhPO9ifXS1Ao0Fjmi
 YqyFBOHQikwdWhNmzsJhV7CtnaMO6SBowCF0/P30eRTCz7g/GHdcFZJwEytBx3AMfrqs
 0w5c9Ial9xhLSFg5XeebrB1ZkA5Unk5zvzA0GRM7bS8JFzY10/aCv1m6qfLU9FoVRHZK
 0A++sAB8LwIWP263iqCDpmMLJGTyObtqbJ+fXcuFFqJCkOUGzApz649Kse2tAGV3VkZT 2A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3my0btvwtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Jan 2023 14:59:49 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30DDkH2j011602;
        Fri, 13 Jan 2023 14:59:49 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4gs5vt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Jan 2023 14:59:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLcwhmvutYNvNd4/rxRjl3aNtilO3NkL5L8dW14tZl59orPGxW7Yc7bb1x0vo9AV6MoybII1lPWoKIpfHuDFxnwq2eiUSaNhP6x7/SAbUhZc5o9MMGkQCcQy0N74Tyg4TXn/YVAoTXsTttbjMDSyrk1MSERK3pNtUa+X9yZnf7qkkt6T0TMqIwCKrITNc0EpI63+sJ462+E0tl4foJKpSvtZVdoWuJdE5LjHdVT2ISNsXevb8TWPoSSBLzQDSN+ZNaglIQi9qMBhb/oSBNqI1SmDN/cgws1aLhbiuHtwJ9cpA5Fp71TzxPAJ5L6k3kLxrpYRUGxL5Sdhw1jsZqGi1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cqjK3J4uvhIT/NAntM1OlH3TwCp1H/jgGCZ8OvUk/2c=;
 b=mofztvJXrCryFvXUFM0Z/JebbC/2CJ7pmUwHHUjZT71dIOeXQTGgu39AfI10V46lBtXN5afZ8y5myFQbVrLswOTsday5Ili2MtSICJgIpfVC9EnBxbj/zAC1yHw/6DkoBj/iHqsR3Dp/kjkyOOMZPOAJ+QZTz+A76GneB9Ow1CaGZ7nD42dBNjJ6uElnQDhOyHCHCzPov0TPVy1LjjIFUXg6BGNiDYrfdzOJDAfj3Sq7QVYfCt23ofMoNlF11PQfk9lnOwo3eWsvxO62erzLaHHTPPpvAOZCgM8rrgoTvafLCf6JfSYqMus4fiwYRv4oPwX+yBKAuc1ULxKkSmo+jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cqjK3J4uvhIT/NAntM1OlH3TwCp1H/jgGCZ8OvUk/2c=;
 b=DFQYi6MSbboNzI+649cDlZM48pmgGBbi7AWwn4n1/l5g/R2scSCNFMa0SqAaHZjv5pqMeNjCH3K/wDBW0eINnEPjYq/XWaH0Hlc+/vCVuLnatfkX/VGZKPBeXfSYh5nz3nCnnFsDsLVwf3QkMHikzlHCtdy76NqDk6SZSNEsVCE=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CH3PR10MB7496.namprd10.prod.outlook.com (2603:10b6:610:164::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Fri, 13 Jan
 2023 14:59:46 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0%6]) with mapi id 15.20.6002.011; Fri, 13 Jan 2023
 14:59:46 +0000
Date:   Fri, 13 Jan 2023 08:59:39 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>, stable@vger.kernel.org
Subject: Re: Linux 6.2-rc2
Message-ID: <20230113145939.hy24zfsyp6azoxqv@oracle.com>
References: <CAHk-=wim8DMRzjyYTJ3UbdqZ26keQyZSU02NZb-JY1=9OpcO1w@mail.gmail.com>
 <20230102225656.GA3532398@roeck-us.net>
 <CAHk-=wjZPPscjDhsHQw_ttHOaQS69rADLm0KuRhbNavBiO62OQ@mail.gmail.com>
 <20230103014535.GA313835@roeck-us.net>
 <CAHk-=whmeBkyu3iS_s-yk0=t3GEoW3sQb-wJFHKykOjG=iQVFw@mail.gmail.com>
 <CAMj1kXHqQoqoys83nEp=Q6oT68+-GpCuMjfnYK9pMy-X_+jjKw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHqQoqoys83nEp=Q6oT68+-GpCuMjfnYK9pMy-X_+jjKw@mail.gmail.com>
X-ClientProxiedBy: SA0PR11CA0129.namprd11.prod.outlook.com
 (2603:10b6:806:131::14) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CH3PR10MB7496:EE_
X-MS-Office365-Filtering-Correlation-Id: a49821df-c752-46c0-860a-08daf576ce4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k2kYums2uOtlGhB9FRfJB2wnV/gDlc8QCr2tOUe8QXKPRJIea+SjVLguZpfpFAbwuvXRbu01wvRiMhq3VpHBzzC9BGkzH2fy4Tr2Dd2dgzvtLwkqCk4TdGJlgmFxOVhVVWkX6w9N8X+tWez5hkNyvTnf7EBMNOrmU+gcq6wyw0h5P7CbakPX7frNF6fcHJJ7cJu5xQ1zbmGBJjbHarnxP06bxtHBWLUbsILO1eBOz0oq4aUoczkIyqdujR80TRjQIKHhs7ib4lhK2yZLMY0RUebKrZ8qai7sumzQy+A3jYBD1eSRF9ldKXvmV1q8mIwFy3D5VEkVY7rxklJNpXs7DCuGd1K6i1zEuhFYYcpls2dQKkRxmKmK6vt374kbjehuUzfkcJ33zAiM40RSdzPAwkeuLm5fJ/E7CAl9KrlZYC2pjYzdJmw3fxSLHd5ko852NUiJY8PaKKNrR1NLs28s+0J6wlDBCedC/GB1M7wtgH6kVYWbI97lwRW9jDKXBnvCOOCnZLhnUc0NElDrm8aHkiJB8rU+HYIOOWo3NLy3FChf1bymL8Jp466AxlLX/tOQmZ5ouHjC/VAzVLMaGvbemRwGMwQ9qwjnkFosJlPQq36TbqxQCwAym7S7kPzIJLH5++5JUhXTtRO/p9c30GgLoog57c87SYNb5vSTH+pF6h5qDFU3FjvelCCPhaiBkaFRdOoTldEXKprut6vcQAya1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(396003)(376002)(39860400002)(451199015)(36756003)(86362001)(8676002)(66946007)(83380400001)(4326008)(66556008)(110136005)(54906003)(41300700001)(66476007)(38100700002)(6506007)(26005)(6486002)(186003)(966005)(6666004)(5660300002)(8936002)(316002)(53546011)(478600001)(2906002)(44832011)(1076003)(6512007)(2616005)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cCK0fylkG9skgxreCVLU4dbrzPQmkmXbdX6rEZWVUcsIidLwrmy6g2batHKK?=
 =?us-ascii?Q?ASNxamRX26VNoBY3gbkmqMvviAlPmz69uWdkPYAjYvIwDjdCrP1fOjVBvokC?=
 =?us-ascii?Q?MWLdpLGs3rpvSKLpeQDOfi5uXFmEYanXDC6t5qnfKAOTt2ymRpD+NENXbccJ?=
 =?us-ascii?Q?Hfyw1C7PCiHmJzEKDKueJ0N5aa19zmnIiPlaFq/Bi9IvVYlOzTAE0g5hRHsy?=
 =?us-ascii?Q?moC4Ir+xqYP1B8zKtFavNGvFxq9n07H4YmTy1QVNgmy7jC3G62EOUmIhQepK?=
 =?us-ascii?Q?xWk8gjScnCvRTW0shCHh+BUDBvkKGTD9fStOcboox4USwOcjNuoj7mgBh5KL?=
 =?us-ascii?Q?/y2JW1JtWAxClB/cYL2OLeQxngBxeHtB+4Q9Lc/8v/pzlBl9+nyM4vFESVKj?=
 =?us-ascii?Q?+LHrhTluqkWaUjhFr+8MxTGASEEKLdGY8m5ArotIEzPjLcAxKzPT+LNlxj+8?=
 =?us-ascii?Q?/j4jM01kC6qERuqA1tDRNfluJas/ulFyBmLftG8AVKejWBd3ClGvVMMXLvMl?=
 =?us-ascii?Q?C9B2swpbecMj7HYKZULJsPSfpffzo03LC82PyVE7Z1iTegdrELBkzmjXLAHd?=
 =?us-ascii?Q?X/EJkgdv81aFWqM+SdxKUp3b2GbjDZaJ+75JeW0gywfiH/iHCdokpAr/9NAf?=
 =?us-ascii?Q?KysOvr17sJf8Z3/R1y/9Xr3Bb5lsXUHriPWqvymvZTGwJS/LddtDbBmkDJWk?=
 =?us-ascii?Q?54Z2oIL7zbud64NVno9CcMyGX/E3W9IxdXUZFVmvpwqS/veVhyPIlc5nhg5M?=
 =?us-ascii?Q?blNUtNvyheEZgcXY+8lZJIn1+6hK7W8fxoRc0U5W+4lv3Ab9fNKeglXUE4Xb?=
 =?us-ascii?Q?hHMxFxEnoC0CX4TuL+yektlPym/EHna6W1fQLq3DZhg2KTsNuvpcd/vGRQuP?=
 =?us-ascii?Q?36WVj05qlFb9AawZF9qfqVInevvZnHls4LX8kUAIkH0qokEmCUBsI9jYlXXz?=
 =?us-ascii?Q?N6maozybhG1o9BPHIDacVoqJ2QUASUaowvjGYNJUI/qmUbIzWRgEQnOxL+Z6?=
 =?us-ascii?Q?K0BvFrWZTbpuDsQKQNsOhlY7/kMbb3kCHE33W2dDkzIfGX8A2BaMTmeWTZtk?=
 =?us-ascii?Q?Yz7Gu1UNEQEn0RhuUcC/hbFhUJdy3D/R4ewMJRzo/gMeXDuJDRbokrteI607?=
 =?us-ascii?Q?Tkj0lwYR9yqotwmzNETAugM+ejOZt3PwDZ/MdncvUkwdU5f4Sh0+gYnM2kzd?=
 =?us-ascii?Q?WZzFl6N/IqzJsswHO/fByVZ+okJESWJpKKJAjwhxg4UPXzqPA5Sq6+lfSvtU?=
 =?us-ascii?Q?FeLq3DESqeTDXquXMccTChrFr2FiW7iLn1dWssTAwuQRlk2tzB/+jE+kEWZJ?=
 =?us-ascii?Q?+Lm2jOY08sd4btGypH8otkODOcBnAFI05NYeQ0w3P+zrrdiUq6zK+8zZcKCN?=
 =?us-ascii?Q?Vju97raOzvq5wlXH+vhKut3mrRgZBSWyGbYPEYjc7p8TQ4oFSID8ln9LGcf4?=
 =?us-ascii?Q?jiiH8lYN7tHNsS61A8yuctc4ujtXESlvH3cXgbat5ehVQbXVECbj4QQDhVLq?=
 =?us-ascii?Q?lt3+ikuzgdm2xp4aPgASuZZmisWNXPytnlv/R0+R38oVpcGUl5/JV+vTlHyS?=
 =?us-ascii?Q?45Jqnq1LG/Rpaqr2JYJGHjVMOnQ3cGtf7TckZyjE?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?3FkvTKuTTIiIRPv2NNenSN5vn4tVxyVOYx2zfuwXUxWOJJX8YZ/79cgoNCi1?=
 =?us-ascii?Q?Edj3oizvN/QCEJMN3GZrds/DZTHfrSdT/vGHDo45KT5lRjl75wV9AYKz4aQw?=
 =?us-ascii?Q?hqC2xckRn/CDv1mRhrbVckdBo6vuI0o2zj/xUuE/vYDkNP3phlC5JYbBH/f7?=
 =?us-ascii?Q?Mec3M8oyUTUdUrnfJs5HjdEN10TsBM9Sft46gNeBKlFyzdvsVsu8QyNeVcmL?=
 =?us-ascii?Q?fT468gotbdfY5NCGoMR9yYEHoXTIQjiJtGwS5tV3ZYJZ/Fbsrg9lg+AZoF9S?=
 =?us-ascii?Q?xDnqzmJdu49UhvAqWuFbboQQCtS5D2IW7slqLDL/YMwr1AVdTWkCHTWj9+p2?=
 =?us-ascii?Q?8c76GZxdxxhUxdc6RvgEwEN0V1bj4jnsTi/g5Oih97hbtktrrYWXeBa9nnpK?=
 =?us-ascii?Q?uqup5HwZzQNTniKWUc1WXT6x5Q0zcAds2QwH93ZLa1YMixFyGomSjWolKliV?=
 =?us-ascii?Q?17Nvegoor+/UqZj/3OsLktta+nA7I5r6lQGQqeF1aOqcf1G1lIq6FYswNY7i?=
 =?us-ascii?Q?K0XWgvg+6GmQ0iV7zeGhJKAjYiqsWRHk6XJlOiogUKPOLnB3lFenwcTh32sX?=
 =?us-ascii?Q?S/ode4DfPGJI8qZle4CF/cOlJDRIrgsILMmy+aGYRzKpZcFXXVdhwI+CB9gc?=
 =?us-ascii?Q?C+P6qj3HMFtnklOitASjeFyO3Rx68GQkmsq5vWLwufsK+E8S3o6nIYav2hfP?=
 =?us-ascii?Q?sUp50VVB2JnXUWS5E57DtqsPeYlzzdVp21H3D0ioBDaVMgxKUmvQUdhQ1C8C?=
 =?us-ascii?Q?D3AU3rxs4NjU0bJ2RnifiTFDFgm6iFA1Ncx6LCZnMn9ugLk3KWDhuGhI5dtL?=
 =?us-ascii?Q?MsXb27Fbsp8c4gMJXfWbuz+Vd1//oxvECDJMOjx2Oha3c2e5MDLOxsMGSzzg?=
 =?us-ascii?Q?C0k7o0sTgTRbTPwxu4uhMDKeQTE4O+p0hMrGXt96cq/Uc6Br8QdZ5CuI626O?=
 =?us-ascii?Q?/H7tnqN+XvWFlX+v7dcpy1Eqo8itu8iTeEuWz6BS6h/yRiV6YjW1ditwSiN6?=
 =?us-ascii?Q?N4rYobW422mQG+x6k4rnFvIScfigOtRFcI0JRvdBOZcB3fOWendk8map7wKY?=
 =?us-ascii?Q?Mh16ClUrjHwa21XR6aBY+J3WH7fujBb7/5z/s9EraoYOinmHgL3Q0Bv3P9tS?=
 =?us-ascii?Q?rMH3NTrYOR5F?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a49821df-c752-46c0-860a-08daf576ce4a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 14:59:45.9937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tmzw2HvgO7sdYHi+QwujpXzqczSuYQHkUtqxhpRVE2qt8Uy/gb0uQmidrmoRLvRZadb5afbYBvsIw5BPkPrA+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7496
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-13_07,2023-01-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301130099
X-Proofpoint-GUID: m64GyZgkLaUefux1MNQXRxrBW3BOrIdh
X-Proofpoint-ORIG-GUID: m64GyZgkLaUefux1MNQXRxrBW3BOrIdh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 03, 2023 at 11:58:48AM +0100, Ard Biesheuvel wrote:
> On Tue, 3 Jan 2023 at 03:13, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Mon, Jan 2, 2023 at 5:45 PM Guenter Roeck <linux@roeck-us.net> wrote:
> > >
> > > ... and reverting commit 99cb0d917ff indeed fixes the problem.
> >
> > Hmm. My gut feel is that this just exposes some bug in binutils.
> >
> > That said, maybe that commit should not have added its own /DISCARDS/
> > thing, and instead just added that "*(.note.GNU-stack)" to the general
> > /DISCARDS/ thing that is defined by the
> >
> >   #define DISCARDS  ..
> >
> > a little bit later, so that we only end up with one single DISCARD
> > list. Something like this (broken patch on purpose):
> >
> >   --- a/include/asm-generic/vmlinux.lds.h
> >   +++ b/include/asm-generic/vmlinux.lds.h
> >   @@ -897,5 +897,4 @@
> >     */
> >    #define NOTES                                        \
> >   -     /DISCARD/ : { *(.note.GNU-stack) }              \
> >         .notes : AT(ADDR(.notes) - LOAD_OFFSET) {       \
> >                 BOUNDED_SECTION_BY(.note.*, _notes)     \
> >   @@ -1016,4 +1015,5 @@
> >    #define DISCARDS                                     \
> >         /DISCARD/ : {                                   \
> >   +     *(.note.GNU-stack)                              \
> >         EXIT_DISCARDS                                   \
> >         EXIT_CALL                                       \
> >
> > But maybe that DISCARDS macrop ends up being used too late?
> >
> 
> Masahiro's v1 did something like this, and it caused an issue on
> RISC-V, which is why we ended up with this approach instead.
> 
> > It really shouldn't matter, but here we are, with a build problem with
> > some random old binutils on an odd platform..
> >
> 
> AIUI, the way ld.bfd used to combine output sections may also affect
> the /DISCARD/ pseudo-section, and so introducing it much earlier
> results in these discards to be interpreted in a different order.
> 
> The purpose of this change is to prevent .note.GNU-stack from deciding
> the section type of the .notes output section, and so keeping it in
> its own section should be sufficient. E.g.,
> 
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -896,7 +896,7 @@
>   * Otherwise, the type of .notes section would become PROGBITS
> instead of NOTES.
>   */
>  #define NOTES                                                          \
> -       /DISCARD/ : { *(.note.GNU-stack) }                              \
> +       .note.GNU-stack : { *(.note.GNU-stack) }                        \
>         .notes : AT(ADDR(.notes) - LOAD_OFFSET) {                       \
>                 BOUNDED_SECTION_BY(.note.*, _notes)                     \
>         } NOTES_HEADERS                                                 \
> 
> The .note.GNU-stack has zero size, so the result should be the same.


+Greg +Nick

This also fixes Build ID on arm64 for stable 5.15, 5.10, and 5.4
which has been broken since backport of:
0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")

Discussed here:

https://lore.kernel.org/stable/3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com/
https://lore.kernel.org/stable/cover.1670358255.git.tom.saeger@oracle.com/

Perhaps add:

Cc: <stable@vger.kernel.org> # 5.15, 5.10, 5.4

for stable 5.15, 5.10, 5.4
Tested-by: Tom Saeger <tom.saeger@oracle.com>
