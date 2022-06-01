Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5E453B084
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 02:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbiFAXD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 19:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbiFAXD0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 19:03:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6F862A1A;
        Wed,  1 Jun 2022 16:03:24 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251KLwL9025661;
        Wed, 1 Jun 2022 23:03:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=n5j4gEi5kfoTTA3JMFqHnY+n9K+EboHc+pFBE6k23uA=;
 b=g5gxI4V+z1oHUYNMj6HWYXZVON+YYk3xehNatWtZBtEzF05eTHafR53ZPxbn432PhIp8
 aZpPgYCZ8VmlhBCamndiLcRO41Gnzn+YlT0PAyEjbIlPWMGpvJ9Z8aDSHKE2AzMqAWAy
 jm9zolN3ztbWKxh4bxs65Txa9Cp+rQEW2dJoeGuxFJ27SyeB1OYtEnlrOfMvQj0bdFeu
 N/pHPq+atssiiE9PMzbagMx7XMyoiiqnA7c2k0AhHphSNlVLLy0NuUa8Z1Xw0ucvBkt0
 IHUdgEZfHKTCTxyuJBkt4+cfPFrb8p33viT0TNP+llWgSaoePctc80HYEnLCSTW3lDus xA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc7krrxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jun 2022 23:03:19 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 251Ma9tl002010;
        Wed, 1 Jun 2022 23:03:18 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8p4arav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jun 2022 23:03:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKO4ocPMkM+RbBD7A9SZkineK2HfdFXAPhXho/mphLVeYhGBkJjSp5oZCT3lV/qbhc3cNoeQfAFiXxzx8VoBTtjBhLE8m0hslfXNdA4lb7Lp/xO5U+WylWOMuCbG9wymtvxLX7pGaaynXPbf3ccbcL/4bJcUkvyp4DiqpTUKuVIZoYLRcNWOyEMSD40NeAIikvxkINhX+q2uVQcOzKVHlaWBM/9TLlxQbNGy4X5/sZy5ycfaYFSf27fQwBWkxGSTGZPorzfiLWpB351xLQtAX5SjWma247UOjdH6RL1D2BYO06nqS9ZW2XQNXF24to/3a2NoVwsX3WB/m2oelPp1RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n5j4gEi5kfoTTA3JMFqHnY+n9K+EboHc+pFBE6k23uA=;
 b=nD+80w1Mh4JiBM8mlXfVZKuSK/o4E/EBOW8Sp8xbY2Iz8mhPDOMLd9SRmN+TXz6FD7uDcohrxxxUNsjpOb5E1lxzR9Rpcr2BeC4TPrlkZ8d7JpbIbynC8EeHr2UfD7yb8FmcK9loJRLdUASMGRaNtsGiWgtwYVbbeKRFKfeAstnV+HFq9Z9RWiXUpesZ+WrDdLgHnE4gjrQtYx2f8P87Olc/feqoxE4vmoOH03qGirmTqYfPbk6ccc+6LBn6T2Dg4nIbvH3zdXI88h/rpRpeMpTRh17Ijuha0pJTMD/GPpF+y/iT5h56GrVRXAdCJbWsPVVgWVvXRgo0oEfzrFwNCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5j4gEi5kfoTTA3JMFqHnY+n9K+EboHc+pFBE6k23uA=;
 b=KrCDeMTpuYsysafSoT93fvISSXIA0vYlTm9C5v77KihtwSzSCK6LQV5TaNOHLHLJZg7VY1vYdQWTtK4WgBCamxDoXorgi2AJAocuEZGZraZFJYD82IAciXBWC2vP7YI2E0PXnAeFwe9b+AYPiwrwlvPrhCyAB+7FzvoESeTMHkE=
Received: from CH2PR10MB4166.namprd10.prod.outlook.com (2603:10b6:610:78::20)
 by BYAPR10MB2600.namprd10.prod.outlook.com (2603:10b6:a02:aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Wed, 1 Jun
 2022 23:03:15 +0000
Received: from CH2PR10MB4166.namprd10.prod.outlook.com
 ([fe80::4421:897e:e867:679c]) by CH2PR10MB4166.namprd10.prod.outlook.com
 ([fe80::4421:897e:e867:679c%9]) with mapi id 15.20.5314.013; Wed, 1 Jun 2022
 23:03:15 +0000
From:   Stephen Brennan <stephen.s.brennan@oracle.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        David Howells <dhowells@redhat.com>
Cc:     torvalds@linux-foundation.org, stable@vger.kernel.org,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] assoc_array: Fix BUG_ON during garbage collect
In-Reply-To: <YpfrLUknlmcvwNzY@sol.localdomain>
References: <165295023086.3361286.8662079860706628540.stgit@warthog.procyon.org.uk>
 <YpfrLUknlmcvwNzY@sol.localdomain>
Date:   Wed, 01 Jun 2022 16:03:12 -0700
Message-ID: <87y1ygyojz.fsf@stepbren-lnx.us.oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SN2PR01CA0006.prod.exchangelabs.com (2603:10b6:804:2::16)
 To CH2PR10MB4166.namprd10.prod.outlook.com (2603:10b6:610:78::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb5fe377-efb4-4b35-bcc5-08da4422e8ee
X-MS-TrafficTypeDiagnostic: BYAPR10MB2600:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2600788B068A23F561CFCA4DDBDF9@BYAPR10MB2600.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hrl8mIMdtI5GEqAgk2RTaLMh10rRSQwXlEFoGksiPNnu7KWwS8bdiImyumgl5wIgKHO7qWuMCGLFj8tIOiDjfNM0Oc8DUQ99k42Q+kkv3FA2532fmi2G2zFdY+IoR00Fj04WpXUWUx1HWjGqQAu/8hoVm27/xU3nJLX/L5n9AXvvqB8eqp3rGb8tVRoNdrOB4rRarCRuECIhVV4+Xv36+EWCidNobzPINQyv7nMcc1/p1dyNKgfbgRNo8MEGq3nZRJpXXVkc4FNuPFzjFpzjZV+WR5Vhh8knm9dRmJ88WfCfDazLi8+15Sfc3C065FtkhLiq0pst/WczMlRXJy0PAIxZF6ffKbhK+EEhk9tnv5Rm0ZMiKx1cbSzUmZwEpEhc7KP1lrmTw5HKpkA5uLRzcHPp7c+ToQCqh+yHrT+SnKgb3mDnRuRumPoom8sgfte34R4HuSP9ttEF17uItI2q3L6owhEOLwUGfoHdcRQvOohwGgjmXJG+9NxU4Fb+/rAKXDxZ2xNdgYKBGdjLuYc0wLZthYUDbrAtrMgVtWltL+TWHbuotJluL756e8tJN5y4RBtv0mEEmQPAOMnbFz2Z/wxNEHCpLVPw++ItCB3p+m9patnevqOTuWkq7vGqv2lMxVgbCND+c7L/YNhRIBf9xdvsXn9s1SsCVa/xwqvNOuuHXGrOPLayiEHECZx8A3VWpMT7IJtoV9EfjgDmtmcbpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4166.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(6506007)(54906003)(52116002)(26005)(6512007)(86362001)(186003)(38100700002)(508600001)(5660300002)(6486002)(8936002)(8676002)(4326008)(2906002)(66476007)(110136005)(66556008)(83380400001)(6666004)(66946007)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YsbEV83xGj8Vei3llKacBI2Oq3YF+fnVPc2JhiVcF8y6M5qMJMZTlk7Bq2pr?=
 =?us-ascii?Q?RGt5XhTpbunwKAGOCxyc8GhnJn784bDQd/zOSytvqDR9sCSR+MStJOJ/2xiH?=
 =?us-ascii?Q?HWHICYgzLlfFeeyTljgo9YpmS9HRTaFFwpE2JJR/WbSDrgDV91tyyNaYL2Iq?=
 =?us-ascii?Q?UW3R4PJVdKb9SREji0OYpVhGC5mApcBK1rYczIBEw/aWevq9YlJQq+01wWEg?=
 =?us-ascii?Q?0JVTh3ww8DB/ZqJR9ZGUkKuFqNICMlg0dkzv3jSXS36W3CDMGaZiUHVlfZ9V?=
 =?us-ascii?Q?hxRam9xRs43KR4L0FT7Akdo+uUoGr0m6UMKBOgxo8QmJp6o3J5z8Er42U27B?=
 =?us-ascii?Q?FcA1t4swDDfNYCqBWT4C7SoW+zNMl4RVwz53zTcc3Gf0GS1qchcf+u8YjbJ9?=
 =?us-ascii?Q?J1Y9Qxg2bN23g5U4hz+vi0uUOvIUz6zu+gH02GjVYmk6WoynAfNcwglZr/ii?=
 =?us-ascii?Q?aU7JNrfJ7nNacQgaO1/PNiss0UG9NlwTRoxhbNdLI1fXVG0TZImnVpfeTZ21?=
 =?us-ascii?Q?Y2Lqbp5CPMNymX7gCjO5LBg/uMT3TA+vFqRXUD/MELw16xH9KHS4DfiRKE1z?=
 =?us-ascii?Q?CkD4cB9psQTm22lDZiDvr4xsSUaq/HoeUzqGxo9Wfhq2UuvNJJ+NK7mYVuUs?=
 =?us-ascii?Q?+/T0C4S1XOn/6XGQdwQWbaYMgIbhBWfwkCM8TLiIUhazijGMwvaAHDeG8Ai9?=
 =?us-ascii?Q?EoR4iGzgq/qopzjLbBDFbwhDmrHZCRh2NdrVDP+FiR2luLgkQpAs8gejFL5Z?=
 =?us-ascii?Q?77IT+WFajo4ix8YsYqX74pR1ROqoqYkkSdEsfNOGMwotTE4u7145AVsCIH8o?=
 =?us-ascii?Q?hlxIy6t4sFzxIj/3hoe5XdZHRdZHrCQqsfrpcaghrT1/6zQzM251oS8Kwak5?=
 =?us-ascii?Q?HcJt1zUxXBAAHJtAlq8QBjmkd+y5tnnzU9HUEt3AEOO1hvJLFdxjdKdGRs0Z?=
 =?us-ascii?Q?AxxZXxDCp69rJQThN8LYW/CQwym0b5TqG3/X3kn8RO8nHsfbuJak/IuIpozI?=
 =?us-ascii?Q?aJnt+oAD3vsUQy9Z67N++dFXtdEKcXCEGlzpUlw0rYm95vpu/mXWuAMLcQOe?=
 =?us-ascii?Q?gkBZyl4zhdbGM/SuiMFN/bdce08lUmga4vT8xcYHJykdaoX2+dMgEHoms2Si?=
 =?us-ascii?Q?FaFBeC9ShlhpFJEyV36RQwckMipbpdIRe8XJrbmvZqSimuPAQDgplBblZYx4?=
 =?us-ascii?Q?nWF1d7NwfVjCokqangtDtKCNYfzq8KA7ayRfAPlDbT+Mz7YpSsfqrzjCL6w6?=
 =?us-ascii?Q?DhIl356a9coSeTdjKspSKWNcZfJAuIEuBAl3tRV4R0dmw52v9wEf2l3pdQnT?=
 =?us-ascii?Q?2aRUJvQ0gBItNTfH6GtzGfeC5YCIf9/AcYc+Xn2MGYYhptltV07nMJUzsCTN?=
 =?us-ascii?Q?guYWn6uXLqYWfSxxdhj/njMG8AD/0yAcYl+H+eM4hYq+0GyEXj4n+H8Uemql?=
 =?us-ascii?Q?S60/7uXVfCZkIb139U8Fm0DZ420s2tTuN7ytYAp7IDwkxesocopr43qw4AqM?=
 =?us-ascii?Q?iwUpyyAHfBMi5pCnwQUAmvb/oWMb8uS+J1MQ0nyhmsQaAZre1bVEJ+G6W652?=
 =?us-ascii?Q?Ffu6OGQuxTAkkLT9voi0fYQ3rHE4Hw3UPBG6fZ4xC0+hN4GyhYm9cMLnrdzR?=
 =?us-ascii?Q?tmS3opmnVVQMLtgwvZUvL7xV9cmWU/ETFnqNQx7Pw+9LNP72fkqvFJi/Me2g?=
 =?us-ascii?Q?ML1XsisEWxjs2c+upvvbr55sl5hRAsndewiF+yrM0k/uIyUkwz+utXOR9/D5?=
 =?us-ascii?Q?dbFCSYgG7D3EAVEEAMVc5+lcAK805Ug=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5fe377-efb4-4b35-bcc5-08da4422e8ee
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4166.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 23:03:15.6226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /P46uT0Kvq/tpIyUAGXjdR/JHFdfL3wx+VHjSSG+GP5JhAYx+NusYBbEN0stqUu381YU7sFhETMNaUFPm5qbVA3y/+izGtfauntZ6jpN6cA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2600
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-01_09:2022-06-01,2022-06-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206010090
X-Proofpoint-GUID: hGfOJK9zUoZLC2XcBU0gCZ2Th3lJ3dCr
X-Proofpoint-ORIG-GUID: hGfOJK9zUoZLC2XcBU0gCZ2Th3lJ3dCr
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> writes:

> On Thu, May 19, 2022 at 09:50:30AM +0100, David Howells wrote:
>> diff --git a/lib/assoc_array.c b/lib/assoc_array.c
>> index 079c72e26493..ca0b4f360c1a 100644
>> --- a/lib/assoc_array.c
>> +++ b/lib/assoc_array.c
>
> Where are the tests for this file?

As of today there are none:

$ grep -lr assoc_array
lib/assoc_array.c
lib/Makefile
lib/Kconfig
arch/powerpc/mm/numa.c
arch/powerpc/platforms/pseries/hotplug-memory.c
Documentation/core-api/index.rst
Documentation/core-api/assoc_array.rst
Documentation/translations/zh_CN/core-api/index.rst
Documentation/translations/zh_CN/core-api/assoc_array.rst
include/linux/assoc_array.h
include/linux/key.h
include/linux/assoc_array_priv.h
include/keys/keyring-type.h
security/keys/internal.h
security/keys/key.c
security/keys/keyring.c
security/keys/request_key.c

The assoc_array code is easy to get up and running in userspace (see the
reproducer for this bug). So testing it would be feasible with some sort
of userspace runner (KUnit?). Seems it hasn't been done yet.

Stephen

>
> - Eric
