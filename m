Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43C1867EFD6
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 21:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbjA0UmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 15:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbjA0UmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 15:42:00 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F037E684;
        Fri, 27 Jan 2023 12:41:29 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RESXKO004156;
        Fri, 27 Jan 2023 20:40:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=/ScKNlq04bACu9a67pQ0P3CjFeCGILL1fNZe+wVV9dI=;
 b=QLMnyiVT6Xbh7Y73yDH0yLIo8eylBjyf63q7cBFlwQvCE3C3ZvpX4L/mWBl0FIwOE2uI
 +54UFH8l7nWkR0uF9BN92koOcFco5OEuwKeAnEkHuazwHsPwFR596jA6ljBLXkOgLY3u
 LitzCbJ/ruje3Ns7ncUNQLvDvqLYVl2BWl/a3EdNdCSGg0RYN3iT8owY5jijzB1Lsckt
 1xT8xO89K7t1G95VBaRsiO39WlWt0T7TlrZtXpTzpLYarbpNpy392qyr4JyUyWayDN1g
 MaixsPFlqXwNnkXLH+0DQXEORadLkAxFS0+IAVooNpLgU1/rtT+OpIGdNA9xJStpj/Ge fA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncfd190vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:40:33 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30RKBs1I004986;
        Fri, 27 Jan 2023 20:40:32 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86ggjeqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:40:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+Wqjv+0riwi731m02q4k/vlDUqMsaoER68vJuOCzt3N+2FP3erYY1ZY7XUVVQxDJiSCQzkhw54gbxy90KHuYwElnFon/WN7W5NJs40BguazuqbKkGQsk8a2ZFouhUCeiPEh33v/bCvwuXqxXCMQr64j2NKwLKEOzcUD//iQ+OgEiqQbp4JoIuLrSy94fegHjKkjwjmEPVhucqqHyhkjEQuXWlhucF3pVQxS+od1RMLpdD/XbrQ5uKTzI+ne8ZAQhorCJbMHj8bDPZfDu5R9QhlfYIrNSWnoXu668AnIKt4akrLk6J+Il3xkpYQC1bTjms8RuQkElXVDSO4tZfhz7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ScKNlq04bACu9a67pQ0P3CjFeCGILL1fNZe+wVV9dI=;
 b=EpFMomI0dtqYvx31EenFEIx9sBnPEwgS8amGeSigh3AfYJAmj6ZzPh4S8F4XFZF2EqFJXoiU8MczPsYCyYbPs7PUrgV+Vp39tdwg7LCgURgl0oCefutcJtsJ1PvZcgQ//Fx4VzQFiiAxcr65ghQLMeoNz+dgnlMqqrzm9XG9/8ztH6a/L+rnInj90aT4oC/J/zI1uWStuNxJSJsPrl79amA+sBG/ePeuaSD9NesYy9ZyZgaexxOyX6mEkmJTYZ2fulpH7lmHrQKcOTFo4y8sukhgAr68EpiDuem5zuqlrMmNIhTD3ACI3oF89bC1so8/cECIKqeQVC4mcacS9VX4NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ScKNlq04bACu9a67pQ0P3CjFeCGILL1fNZe+wVV9dI=;
 b=bX4mqJ8JZBbClZv5QKVcNodc95Oaz9ItksOMg+1Q6OGwoE1T7ZlBYM1+XtM+91ZntWIlqR5VwzotvfAUWzn3wAd3eg1INHN1fhy2IJmyyNiPwtwldbjUYlZcqGntwp7fCV7RtusnGymXVqGIasauDOmTyIOQ2s4yTAEhUk7Chlw=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CH3PR10MB7459.namprd10.prod.outlook.com (2603:10b6:610:160::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.10; Fri, 27 Jan
 2023 20:40:30 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 20:40:30 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 5.15 fix build id for arm64 4/5] s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36
Date:   Fri, 27 Jan 2023 13:40:10 -0700
Message-Id: <178abde2262b22100aac5de018e92a6dc9d5bce6.1674851705.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674851705.git.tom.saeger@oracle.com>
References: <cover.1674851705.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0163.namprd03.prod.outlook.com
 (2603:10b6:a03:338::18) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CH3PR10MB7459:EE_
X-MS-Office365-Filtering-Correlation-Id: 80453183-c155-4cff-16f6-08db00a6ba82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZTl9NzkGUYWAWfW3IOJZNogZNQhfx9xVqPKlAvQt22v5Tc+M1ffeZM3S8Ptje1YMxVBy9wOG7HaSLcfklikyMobzJxJfykIOXKs2740dcQ6RMYuSy3QeK8o+UExWO+oCsVRB6b76s4ZRQYtZCsCdAbfz1fdz1gUA+2PR+xN8YqlNtndV4CFTrB2fo2Fr2yNWPaUfB1cigBHulPQTp6T/rlLHbjUpxEvBkUIZcbM1uY1PnFDPZ66PhIlQmj/dlGzdJNGicPd3wlkoMTJKN3vjJSnDIKwcyIiA175ziO54X6iQudfPDGcwvEJaJYoGZAG/OKoSkWLl/A8510oimHDyj3ePygjbnwxdY6iXZd3iuPNLmZnv5//oVWrL38dUvWHbbkoWCw5gH6hpySwaJasNJWBS5c+6WZiOuVZ4Ro4yT6Rcep9xQlW2vmbmhu1bJo2o+fQFD1yP04lGYbyzxbuchGUQLK3CUFse5Q+Zp+5FrpX6VMtnAEPsoe5uLyBDjNcsOtcdoPoZOQcPyJGhjJdwPFZZx+TkqHrywpeUuF9dJfEAg0jMGQ1jKQV7Tz9REIfPa18uJQYCippJ4VnUasb1atV5VNz25wwpySE+KbuzkxY6mvE3AjtoXDxcLK3CN8JHJI04BRC8EArb7sjle3LsQA/gEak11brv2OvT+xdM2bvae3f4QAyBg4rTwdyLAEeqOH1R6a2EAavuVc/AFTjGPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199018)(36756003)(44832011)(2906002)(54906003)(6666004)(6486002)(478600001)(966005)(8936002)(6512007)(6506007)(316002)(2616005)(186003)(38100700002)(7416002)(5660300002)(86362001)(4326008)(66946007)(66476007)(8676002)(66556008)(6916009)(41300700001)(66899018);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ihD7Sk27bRjEphqziys2YR7cKjgLze5HKcYYe7eumlNK4XTj/fZH2nuUObDG?=
 =?us-ascii?Q?YcWsp+xSHrb0JDQnJu+/F71eAC90IAccaxj9ACyKCmzHloosqzV/BwQ+007J?=
 =?us-ascii?Q?6GrjjV0ewuVSxKhNalCMW8pAUIhN4a+sCJIL9EwRkuKn5M7ImjWaOkwr9uhs?=
 =?us-ascii?Q?EixVerNXKZc4eoMY2wiUwnVqtXJ1u73FGBZSHS0jxh+/xqyc0sRqbYLoHPfO?=
 =?us-ascii?Q?Lmb516gI2E7qYbnfKhMK6Q3TUCox11f2gDP/J/3V61Q1pPePRQr5ewMzZZlU?=
 =?us-ascii?Q?1mvvfqMVFXn8Lmskl9NMENHoSqYj+iiqkaAbtUUyamM/IBwbaXSJVfW0LTtm?=
 =?us-ascii?Q?wzRxgshq+MwZHOyC1geRGyrnrc6uaseVL48p9XYfwT1a8ixAaohGh4Uuhvzr?=
 =?us-ascii?Q?jCub/MFl+yzgrY4/SVpvHIXaZxi6DtPHBYL5iKhSyc16Oqmz05WcvGK0a9ig?=
 =?us-ascii?Q?bvsTK5ruuZpzx5hXaebmb1NHm2gXrYq2kN/Pp4WPNmnBl1r0SC15WPlE5SSt?=
 =?us-ascii?Q?zAYHj+uDUGJ3PJgaWRxKJodGcwyhoWr8X2m4GdLWvG0St8b//9DEYNs/xznf?=
 =?us-ascii?Q?UiqYZhqlLis5WgIQ7AzwDSeoDZDsfwyjVMsVJfSUbSZmkQwk/UPUvHLPjOmn?=
 =?us-ascii?Q?Umq40WYj4+B/Cunuo5j+Jpo5QOYRNPrLxRPA+cglphD5gj5fq+Qpwr7KgqGW?=
 =?us-ascii?Q?gBSN5sMu2nDqz5rJ4J5QB1h7uGo7oW3pTedhDcJFVpRqPoeH/eHRgGoyYF/t?=
 =?us-ascii?Q?5T7sdeCLE9sMvpX/rzX7Y1kRCFhzik02Po5QFNcrRg33g4epN3jhWPswYsbf?=
 =?us-ascii?Q?cEeTWEw8OQvN7YCJKIgb5Kr3h7ht+qpxlhz9WMHKLBC7zeERdU/My5L7r773?=
 =?us-ascii?Q?odGIquZDzKk9rYZMQ7Z9Gr67ZS9HOF5LRJ1ifDInU3Z7prk2lTTrsctyzt8S?=
 =?us-ascii?Q?4ZmSN8fUgno+AIqpmgfqbVQ9HgaWgr8ceIFQRtUh/rWn+WLQVWtid8ZLluEz?=
 =?us-ascii?Q?CGMOvjZNAgOFO35u1vteo/PPWxU7v/KmMH3sgso8LGSHYmEk0hD5g8OXonIK?=
 =?us-ascii?Q?qMLMmOdTHe2sUr1C3b4C/hhLnsPaZ3T9N0ig7f6YxsoeAyW6teEYnxp+VI9B?=
 =?us-ascii?Q?j6mBKCFxyKddFWWqEk/J8FMptGk0v4AnwsX5fTGZlKSlEPnAq8yIGqXIw+Nm?=
 =?us-ascii?Q?NKafnc9h9Nug1PQouyU88vMgLaVhdAe0+gNBi/zXanq/pBSdHYtxmlx5aEpk?=
 =?us-ascii?Q?qFaFAhOvgT71tQw9Z1QzilMkOgP7+l1SahErUFMxFgmIAG8X3wYER5Up3Z8G?=
 =?us-ascii?Q?ePOA+IQIQu31YCClg3iDgVDcnKDQJeDxxhwKiYulsyxl6P8X4xmcJ30biUZ5?=
 =?us-ascii?Q?gWTYRXuZ7JTYdXBlZCLwC2hy5W5KuWd+G3iC5LCW6xsw4mYLRfG2lsCbql9E?=
 =?us-ascii?Q?5xRGtNekg226S92LKnYs37hk1bo2SwQCbHpoQpx/11adLIYn04mSP0gFjxCR?=
 =?us-ascii?Q?cpZKdYABKJ5ZnrNgRJ9oY3ewEah4q16O2V2GaJWrajlDHvZkEhMp9fVpQaY8?=
 =?us-ascii?Q?SpGHf/PyqdN7vYaa5lZRkL/r+Id8O2bVFMGF5NaQFIX0dPmjKFizoy4EDVp7?=
 =?us-ascii?Q?13yPMgrrqTXqUHGgvWreOLE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?xVU8w83qXbU5M9dokscxK2JH5bSeiATdDj7BU6ybz4iKdtHYHVjwR8LwcENY?=
 =?us-ascii?Q?EMoA1v1vcZTA4MRne+PeLogmMl14A3Wf72jh5pJ4sJzF+2IadUArGdOvoxtA?=
 =?us-ascii?Q?Le1HzPPhqwTFnkChzbhapTkSpimX9zMwOC0GJzoskkxcjXKvh4lYWouhPh6n?=
 =?us-ascii?Q?t8u7CGQzxlwaD3gJVKBIPly5cDdBqMOuEpPnwf1dP3Q5XR9AzMAAcupSrY4Z?=
 =?us-ascii?Q?gFmiSGpt6K1dzuSrnZjOc2v5TuoZbFJ6u6GmkJOup9U+zqJ1FC8dKdipSDRN?=
 =?us-ascii?Q?Xcb2q+EelQD+nbyic523kiHT9KyHneE0CFEp4YMY4XNgAByUw+ThfRpsZ10S?=
 =?us-ascii?Q?2E533xyAgn6Shqgf9RONeCyPZcHtUFkgyLgY5hH5UvDykgE/FdQZmWfpVm5F?=
 =?us-ascii?Q?YaRdUUwIsl+eItTxSJtvewFHkoQXDOezyE37vJOpNnxEjHmvBRTb73XdUuAb?=
 =?us-ascii?Q?E3yloNr+h3AZgboyym5ZGZe3vs8BVOxNneejsQiCkhnj80GLqBnzUbj3JEr0?=
 =?us-ascii?Q?Id6n0y2Wpx7txrjKpbq7dJ2QJbfhDfXJKBhdLtvZfPkJG3WrhPSHpOpIm+mx?=
 =?us-ascii?Q?p0jBrD6NdVhkOowKZ0dnh5gvlP8GyAnLCyNS6oHU34+uBV/FmY0VBZTgdl+U?=
 =?us-ascii?Q?I/3YBjZsonNdbl6hqcwRFIhANxARnTgQgRPz6ypt4j03bJK+pECudZnYdezU?=
 =?us-ascii?Q?UoGbpbmeWzlPwQQmRoRdxzA7EBmZwcDMOM4hOSAa7pelqt85nMqMIpjt6RkL?=
 =?us-ascii?Q?DMv6X2haQzXglv/Fg76R4ilFX+F0PBEpGGnXoeOHjtQx60XAP7lTX3oWMVpZ?=
 =?us-ascii?Q?M5aQWQq+etqKN2sG30wvTU+bY8ZVgGKWKrKZ4V3peG332AKM/bjCnCzOXY1g?=
 =?us-ascii?Q?pEZtsPz3O36ajoC/oadPmPNMAzkd3aZQbF5OJN4KD1JjA/cd9nF8ebVPyzKv?=
 =?us-ascii?Q?CwAhkRb/dNX5u/dvx2QsygTLDAA0m9HcvL1hEYfGgRBt1GO5tfxF3/+c4yxt?=
 =?us-ascii?Q?ndQOBe3O5Xkk3iSVxOOiFhXUdPDHJ0OGUhau7mb5+FaT8VCwF3J9Z1D3Gy1x?=
 =?us-ascii?Q?36mG4sopzEgKZh9hWnVR0xDMznWvOQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80453183-c155-4cff-16f6-08db00a6ba82
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 20:40:29.8747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: awxF1l1rojWfDbefa5xHk3/4Tkkkdtmh5K0bNriJSBbuP0tAGun64o7msi02QZiCCPpljcyqeRkUELf3YKIPXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7459
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301270190
X-Proofpoint-ORIG-GUID: NaILmeKXaWiDE97CURorLlDwZUJxmHQM
X-Proofpoint-GUID: NaILmeKXaWiDE97CURorLlDwZUJxmHQM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit a494398bde273143c2352dd373cad8211f7d94b2 upstream.

Nathan Chancellor reports that the s390 vmlinux fails to link with
GNU ld < 2.36 since commit 99cb0d917ffa ("arch: fix broken BuildID
for arm64 and riscv").

It happens for defconfig, or more specifically for CONFIG_EXPOLINE=y.

  $ s390x-linux-gnu-ld --version | head -n1
  GNU ld (GNU Binutils for Debian) 2.35.2
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- allnoconfig
  $ ./scripts/config -e CONFIG_EXPOLINE
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- olddefconfig
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu-
  `.exit.text' referenced in section `.s390_return_reg' of drivers/base/dd.o: defined in discarded section `.exit.text' of drivers/base/dd.o
  make[1]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
  make: *** [Makefile:1252: vmlinux] Error 2

arch/s390/kernel/vmlinux.lds.S wants to keep EXIT_TEXT:

        .exit.text : {
                EXIT_TEXT
        }

But, at the same time, EXIT_TEXT is thrown away by DISCARD because
s390 does not define RUNTIME_DISCARD_EXIT.

I still do not understand why the latter wins after 99cb0d917ffa,
but defining RUNTIME_DISCARD_EXIT seems correct because the comment
line in arch/s390/kernel/vmlinux.lds.S says:

        /*
         * .exit.text is discarded at runtime, not link time,
         * to deal with references from __bug_table
         */

Nathan also found that binutils commit 21401fc7bf67 ("Duplicate output
sections in scripts") cured this issue, so we cannot reproduce it with
binutils 2.36+, but it is better to not rely on it.

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Link: https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20230105031306.1455409-1-masahiroy@kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/s390/kernel/vmlinux.lds.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index b508ccad4856..7582d5fa4cc1 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -17,6 +17,8 @@
 /* Handle ro_after_init data on our own. */
 #define RO_AFTER_INIT_DATA
 
+#define RUNTIME_DISCARD_EXIT
+
 #define EMITS_PT_NOTE
 
 #include <asm-generic/vmlinux.lds.h>
-- 
2.39.1

