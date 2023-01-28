Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA81367F48E
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 05:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjA1ELO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 23:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjA1ELK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 23:11:10 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E62F7C310;
        Fri, 27 Jan 2023 20:11:08 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30S3Nxaj007751;
        Sat, 28 Jan 2023 04:10:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=mHh23EwbHtTCjdAD6V+MUBygjOeY1qmSVswxlKOVqmk=;
 b=dBx4wdsDROELNoLpnPcesDiUurpVClv7MS7zzs1Z8cfY/MPllspcu9vtFueaxA9EGyj7
 BuwHg7KBKkaCrtpASkEoLED7HXA8LvP3+KASPB33mj/JDNBC8/ThRJh0e+zD1lBg+sJw
 lgY3l8RVq5MBj+wijN+aTxvuW8OPPJ/oIYdTJkQ6b+3h94c3ypuZc23zy4Oq31p4nKkH
 VrGhouQJLTfcdDhWOoUz290TI8t8OK6kuG0cFwrJe2pmk1pGBO9sat1d5N7Itr/79Be1
 rUtvDyPUq+xa7HZ5U37g+ja2iNP4tKvLsEXrDVLLQvldbbKE97J0bmNjZ0qpWQcSu+Gq OQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncuka8156-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Jan 2023 04:10:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30S1XcXv007430;
        Sat, 28 Jan 2023 04:10:33 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nct58u38b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Jan 2023 04:10:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KDfrCFdsJWw4+jfemY/UIXXEDdIbu1BnIXbog2UwR0LlVh0nHpMXMAWbJG/mnKWwU9cZQuN/SYGkSi3int/fmueLIrZXKJN4M3Y3zyc707zoPHGZZiXo9wp1JeMuwbwQjliHIZbKkFihUFjqVIhrINbR5rCdr7H/rRiyEBQGUWxF5ocRZ4UOIx8fRGbA/ynEOqQLPolJ6oBPtchpo/qLaiVpHNWBIVq/WW7XtIzfoZYIcd4IWUaaXj9jAGKfnCMsp+3Cgo8SK3Ym/9McO0ZN8bfmtQb2+0qC0Z3i4k6BLjNago2ZxIv9Q95S9TSMu1BgOPYlv0IyDImZ47H/2XPOvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mHh23EwbHtTCjdAD6V+MUBygjOeY1qmSVswxlKOVqmk=;
 b=Mxp7Llxr3DYh+a6Kg/6V+J6out470fB4+WVYcGX+yaNi3PmmSDkPVkaqSfl+Dn5llBVMng8u+skmVQMVBtmqo3zJv1YGxByjFhGHTXZt4T+ZABLD9c/GQ0mFyRAd2ZkC+1wNNdc+Y3xr3i9F5ARxNewqLfqxvybMuOhU51MJx12Ba5E46gjY5BTbu/xnsJoAxlW0Wk4S6DmOa480mctcfQ9Yqbjg8PhaMGflWlpAPXsMkRcGMW6zQV5xh158wXH7hkAVUqk0NUeFTlcxEouc3aGM0Anm1oxdOfUGGe9O/JSwNhS7xVZDixDhJHJQcrkTZweivXu3cc2uV6tSl7AYJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHh23EwbHtTCjdAD6V+MUBygjOeY1qmSVswxlKOVqmk=;
 b=0GcQN1f/8RPg2Uu1XjQZQQqpyaTM0U15LxH15x2O91Hbrz8WKNMesbUtdRyHecsnqqu3UjSQhXuzV0HIWsEOUucceewMpEckZy7OmBZoRB0CFD0ImwBeqWsLAqjhPzV0qVeLovpbBn2zmguxSwiySuVvzesCuFbz9pmIoIiudc0=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CY8PR10MB7124.namprd10.prod.outlook.com (2603:10b6:930:75::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Sat, 28 Jan
 2023 04:10:32 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.022; Sat, 28 Jan 2023
 04:10:31 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 6.1 fix build id for arm64 1/5] arch: fix broken BuildID for arm64 and riscv
Date:   Fri, 27 Jan 2023 21:10:18 -0700
Message-Id: <e9fea9abe5fc908a95d2289a2cc8e61cadc8dee1.1674876902.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674876902.git.tom.saeger@oracle.com>
References: <cover.1674876902.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0035.prod.exchangelabs.com (2603:10b6:a02:80::48)
 To BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CY8PR10MB7124:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c272355-ccee-4d54-f547-08db00e598f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iD3I8OstcqouhkTmjOJQAzYlfvwsfzpnYr+vfgtoE2h1ACAd5aPWISSPRh78SIwN7oti2AqFgCl9OdjRKfndGF/P6kaIATffMxjvA3+T8P04/e8J2v0TkBr6BOCw+C/D4EgtdC44OD0ZDbwDKrc1r2/bQdl1biZ1zXYAStkW/Uoth5+2N8zHgeRfqQnjuVZdif172i3R0Wd+WmgLiwjd/3ZfH7DlqfD7h0JyrJZ+jKugkrPWfI8TCv6Z2lkXeQVfZB+CHXBtM2DXdcVYKKQG76o/TObTC60rNcvnI791terh2bd9mbI/z4ZFYRFVXIuBAAoQlF5H3azAI9fHII7f9xamYYuuTuv7I5tjJ7LE9fbIlKmHGsMGTdHkOPfHz8P4ZD9V1PL37TxfqI7XMikSGIvRqg9sVSC35/Y09dYNTvm2FxhFCcsjJk1eEuWCPm52xoNGYBuciLLYBSiBnGEArkTcKAcx3E+/ZF3QuZDE3KFma56xn76vcH2Y9IsHoRA7oGXHcN6oLqE4GrcvCjrn/2AWH1EFZkSjvqS8nolsBZY0bn+ckz2HQiyqi5r6wpSF/YXsTpw2zGv3llSYmHJcVi6E/tpPAVQj5oSGR00cPI4xsq4LkHN0fOu7wzxMrOh1S4nP2aCDhm1MYjynfmeGrirlF5Btis95Gu7Oge1yfL4sb94HtYurlbJyrSzUvQtI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199018)(6666004)(186003)(8936002)(6512007)(6506007)(7416002)(54906003)(5660300002)(2906002)(36756003)(44832011)(86362001)(966005)(6486002)(478600001)(316002)(6916009)(8676002)(66556008)(66946007)(4326008)(66476007)(83380400001)(41300700001)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iBfQ42DKz5loCq7dg9jo6u4e708LCsEmC1KXV6k+vnOva+MaC+RCRRtzTECE?=
 =?us-ascii?Q?xlJdRz4DgrWF03lodoz+tP4uTvTNpqKBDMirbvFl4mcV0O2HwUWdzGh9K1YK?=
 =?us-ascii?Q?IGfw/jU4fBwWo3neRIUFTwv2ZaE3rl7BojqK7WaC/ADLy9kO55DrpJ66C1pz?=
 =?us-ascii?Q?Ea/lOReaP9u/W21aZzHYLy6TC9KFM/76chrbpQ2oPaBegqoJuajxaIjWY3Lp?=
 =?us-ascii?Q?m7hwRAczplndBkflpEguBJ7/AIi00t14N2hrFrGWsak5IVzVlSzQDVCmOJi8?=
 =?us-ascii?Q?Z5n29cWyiGqJTEJXQxldrbS5jrGZ42qF5yTym/Y33VJHARrO11gtO0CYVaAW?=
 =?us-ascii?Q?DB0thWWupfQV65IwgRagqn3FThTR5FUFFPVgmNw0Y/2Vcy+JUZ5MHPva43Pl?=
 =?us-ascii?Q?VXeKBTm/gzvAszBlRBt5mauoDb+kVRKohZJ68duw73VAAhhqIFBhrKSHCi+N?=
 =?us-ascii?Q?H4PAz57flFZ0tTkWdNcpkDuiIONbNmCPiB3XAMb06VYhBlRsu2jdKqhi2KsY?=
 =?us-ascii?Q?MAmBgBOeDaGTm60X9qDjJmcNLtvqCT3ZOlPxVQoW40KaXCw5mRWGuJtYJRH2?=
 =?us-ascii?Q?QrF+2fDmPkVdLj4VU3aoAWYOi6/JIQfE5g1RE+xZLlx5GLtYMMS8XdymBN1H?=
 =?us-ascii?Q?QW4YDMf7a1Afao7xkgzV+uhHSX91ru4+CXLO3ovbFvFKG8nK4xpgEl81JZDs?=
 =?us-ascii?Q?J+9KPQ9bnJbB2MWt1vJOfeJEag//TdnRSp3eWziv0Ob7dhL0+o5HkbYSRBRk?=
 =?us-ascii?Q?faQQBAbUAB7wqrvhZw+FZg/RioBwSveootedtLte3JQOVeTR74QSRYmqSUGP?=
 =?us-ascii?Q?lB9jQBtSzaiWLAPS4PmOuvfg8HltGungNWl1/mnJuGNQmc6KFCw+lEkK8XYe?=
 =?us-ascii?Q?sh6/ymDTYCZEYGwta+YPHE1MWk8t8FuyRe8YQwy95PMAZs9w8nbU8kzCvSZX?=
 =?us-ascii?Q?AbYcp0PiT6XR34JexpU+8y3uYEKM+665T2gkPS+AUNwf0jWr6lojKjZBtSEc?=
 =?us-ascii?Q?VDiM10btwHVt+i5jFcO9Dut4n8f7YYpV33RC6/np25YZIJDIRaKsrwPgjNxP?=
 =?us-ascii?Q?CXogQpZY1x0I5j3qqIr5q3P4SlUEeDMcIe/Orr8Ezmi+Vzv6FyUgc0BZmoFT?=
 =?us-ascii?Q?Bfpe/U+Jz03O+JVGKZ1t6D5VlijLDoV93zVcPYoh8QEJxzv/MWLha5mPPAKt?=
 =?us-ascii?Q?nHoEMo60tba3SEjUdaBUmPhOJ+McERSv2h+MemMSKTJs0WyfspXb/VMa2tKE?=
 =?us-ascii?Q?p4vCRHMhruIJuFQv0b9GTIHBIw0W5wVnb/4TOONcFN6eOH6LL518II1InCxE?=
 =?us-ascii?Q?kKG/nk3usLxYw9v3LloPIkGAgP/kKipuBWcKIndTz5uJ9Gxib4TzFBgTccOs?=
 =?us-ascii?Q?4p09R8PcFWisXAvwZtK/Q59MYynspvjvbLf0jU5lG2cITBXtfyqXl/woBGWo?=
 =?us-ascii?Q?N0njesJfHIyx12TbEjPiIWeDT28WTcDin0Yep+fmxuMunEEwOfrDQ7NndUYk?=
 =?us-ascii?Q?fH+6TzOoyQ2mOV/jOJIS5wuE8PTbcn36PqK4zvPS9VbDy/jSjD0ziAOKjNVQ?=
 =?us-ascii?Q?8mzQo0zSAAakU5dW/bK65c8LMbh8Ym7uVjmkhIrkOuq488SidX+kdLTLieRR?=
 =?us-ascii?Q?3b0ibQtvT8u3C9jdCZL84Lo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?mTVKk0RBrPFtwcPTHAa3rDGyuS5V8TYK/YG/h+keUnjjAl4CuhMtmk/NNTqg?=
 =?us-ascii?Q?qr3rbtho2DOV6ZUYwAhMcnQVszEZnc1liIeSIX8auJtA9nNhnM+xgXqm4xYO?=
 =?us-ascii?Q?rrj9cOJ3DiBBh94EE1V4TaR7Gv+4pnnQLDd0tqPdH1wAtsboMKJme6rhIKtK?=
 =?us-ascii?Q?FZlFXOA59x9e5dTqY1Phg3UqASLAdrpw76Z9cP2FFLKqNIVzfcognie0D+T7?=
 =?us-ascii?Q?EPT/jqSMjqXFXbzF0zIiD+tLDN2O2Ht141+MbYWRMVMrdI33X2PhHGs5N4Ad?=
 =?us-ascii?Q?HHuj7eNbodqrb7ACYHpR9xCNfKsKXOg3aSS7WSOMshwgBK3oieB6NPH6+Gaw?=
 =?us-ascii?Q?7ViC41Q9vwUssjCgILDKu3HT+K5D2PLaNgxRjyzQYEPco9MQa9CQnCV4eA0C?=
 =?us-ascii?Q?fXeHFTlFlqx/e8viT6J5b2XQBm+wX2aOq97MUoc5qq6T6tqFSqtUHM9UhNQN?=
 =?us-ascii?Q?7MCO6C6TfP77pxvtg3j5Or0uBcnZQuVYMxLPEFarigiRIjmz/QxPnEvvZo8w?=
 =?us-ascii?Q?BrM9pg++rHNV4ouW0ADEhFcruJYEEWupd/mawYRVfttlrJn00mZTemZPeNlz?=
 =?us-ascii?Q?mkTulFfSuKapba9DmiO6GECEKPL8PmTnOor0FjnCyTvaYwzmKizJw0D8nkK3?=
 =?us-ascii?Q?x+dKmUytq0QNGqr9gK8JfQ1PrTCD7LgQPRnQEI2bghAeNsfAgMH07FlJWJ7Y?=
 =?us-ascii?Q?H4fEkjrSohTzRaZHkoq4w7biiXaRZHeuhHOamvKpyAVgFn6RbJ32XksVBJvH?=
 =?us-ascii?Q?2mQ+XRYfujJ4k0jmzDntszBoTlCT3tk0E11RkOS/gTjdoDNaG7S0O4Ts6TpX?=
 =?us-ascii?Q?S8pR86mEqwwYuHZl68TNWtDx4CirLJlYOkrIiv7NxVeX+oYU/gb+m+fuo+77?=
 =?us-ascii?Q?RjhcvjZbE2a7LjYh2lnC1jxMSOCycz+NjYqdyRjvtPONJSYEzsuDygl7kvCZ?=
 =?us-ascii?Q?MkProa2hle30TpdBcC45wGtxuqh9ean9k9rkTYrxwm+HLVis7ImVTd0rsrfG?=
 =?us-ascii?Q?rd7T0+sAuLHpxd2orz1LkGHh37c3pYwytMVA/9W2JngMfzNtd2kQGYUnKLst?=
 =?us-ascii?Q?8a8At1fHoPQ6KOkTe61IZoTXQDAOJQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c272355-ccee-4d54-f547-08db00e598f4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 04:10:31.8789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rZgJu9wOa56yfzCG1hDm/QuhINvB/AsBjPHYh4FmVEj2VRAav5CHqaQXr7xxHdvIN1Ehf3tVs+u5vSUGVYkhtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7124
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-28_01,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301280039
X-Proofpoint-GUID: zIcIlSf0rT_JIOvorLnp4tIitX0Y1w1S
X-Proofpoint-ORIG-GUID: zIcIlSf0rT_JIOvorLnp4tIitX0Y1w1S
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

commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.

Dennis Gilmore reports that the BuildID is missing in the arm64 vmlinux
since commit 994b7ac1697b ("arm64: remove special treatment for the
link order of head.o").

The issue is that the type of .notes section, which contains the BuildID,
changed from NOTES to PROGBITS.

Ard Biesheuvel figured out that whichever object gets linked first gets
to decide the type of a section. The PROGBITS type is the result of the
compiler emitting .note.GNU-stack as PROGBITS rather than NOTE.

While Ard provided a fix for arm64, I want to fix this globally because
the same issue is happening on riscv since commit 2348e6bf4421 ("riscv:
remove special treatment for the link order of head.o"). This problem
will happen in general for other architectures if they start to drop
unneeded entries from scripts/head-object-list.txt.

Discard .note.GNU-stack in include/asm-generic/vmlinux.lds.h.

Link: https://lore.kernel.org/lkml/CAABkxwuQoz1CTbyb57n0ZX65eSYiTonFCU8-LCQc=74D=xE=rA@mail.gmail.com/
Fixes: 994b7ac1697b ("arm64: remove special treatment for the link order of head.o")
Fixes: 2348e6bf4421 ("riscv: remove special treatment for the link order of head.o")
Reported-by: Dennis Gilmore <dennis@ausil.us>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 include/asm-generic/vmlinux.lds.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 3dc5824141cd..7ad6f51b3d91 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -929,7 +929,12 @@
 #define PRINTK_INDEX
 #endif
 
+/*
+ * Discard .note.GNU-stack, which is emitted as PROGBITS by the compiler.
+ * Otherwise, the type of .notes section would become PROGBITS instead of NOTES.
+ */
 #define NOTES								\
+	/DISCARD/ : { *(.note.GNU-stack) }				\
 	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
 		__start_notes = .;					\
 		KEEP(*(.note.*))					\
-- 
2.39.1

