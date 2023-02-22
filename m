Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB09569FAB5
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 19:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbjBVSDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 13:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbjBVSDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 13:03:36 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F82A227B1
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 10:03:29 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31MGTjl3003371;
        Wed, 22 Feb 2023 18:03:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=/BNNH4vH3aX42rDN78KzDmhODOqHcvhAEfqg9W1Snek=;
 b=RfuEt+ukZII4OGAQCnevN3aZTy0zjrpXhsSy/HT1vB+5+Fe+K7+6laZfufF/lIIjpyfY
 tA/DmL+QDc1iIoGpm5LQtc+S2SM9iFWXlmcXEZIlFXizb9yOs/pnb9YCMCzFIXSxI+7i
 tQi1tZk+xv5UpdKzZhmVwanyt6JVwi+60HG9Lv6TTB6TXvxljF33s5f2p2BTRyy1CZaJ
 l1ly7yXpjvqfRckkvNnxbP3t8ERFeVyR9XOzghLLJwdSp5ICxn5Xah+FiUdJLAzHVtNB
 ADTy3KE8fTNwbF01YUOO8xhyDQIIBhYODoEmkEDwfBnAmi65qSZWa6/IjJ3uCZ8SmeLp Qg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntn90rmsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 18:03:25 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31MH1pXg023455;
        Wed, 22 Feb 2023 18:03:24 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn46yp0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 18:03:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FocAtL2HZLiatY1RD3ZYP40qTVLM16ACeQ01HKsV/pWTWQBUrXzRs57ZQJw0ABD2GLf2bbd0LEi/EaHxi/2ozod/Nm/QPnyT4T7pA0paP6NhQutsNx1CArNJ2loKxwRDWRMkRnVjNxoif913CN85BZuEw2ZleL8sNqe7FpNd3lcGSWitvrZplezKbUDTRvWis+Xqi5XJFz4y0lK+Vapl0XFPWcKDacfRbOdnGkTVHCqs4MWqcK6GoF3G/RJrD+kjxemkXnNqB8zDJ98vNOSTuaOLwbS1pNMVMeAWyq999Ibs71kkv9l2Xc3MFmcx+T7BnY3x60MVgj6h0uBU7cKXfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/BNNH4vH3aX42rDN78KzDmhODOqHcvhAEfqg9W1Snek=;
 b=QZKPA8bqupkyqVLGFrqK+wAMo6M1UTnedkc3eayTeQrMm1BHWoG1iAKiYsKOkbeG6WsvlcbEXn+nhBeRBZdmdQaYP8g/2V+W8H9j0N+EilpiXfzGyWciku8x1vphlZVpLyqW0J90Dsoqy2kOHVce/myugI9sWBQzXZK8qLs1NuymtPlzpL1t2Xx/6vpKL2pUkOsJ1RDtg+PQ+TByosB9qbYfEwdcVFlNescELvxNziDAawu7rHRFsxTx67U1JVivPQ7zbO7cxZk/dPq4z2ZoOQybEFaWN4OibJHzVpsQI1xE+8VFfVaKgGwwcO6VXXCK6JbPP6qdizgGIN0dhI1RYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/BNNH4vH3aX42rDN78KzDmhODOqHcvhAEfqg9W1Snek=;
 b=c75x/ntmtSfi59hwwCUlu4xEToySsFYvm54PprzB2p1XBLhQXbJcquME4rekIwFD7oClSxhdwQyFu1pW+6KFJsy6jfaD3GVWzzZ61wAVaAoE4vzeSneD22J361XEc/1WT2TAB21jRmFZTUL7x5eMe5DL39iNOWvkSwQeRnlecrU=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by IA1PR10MB6123.namprd10.prod.outlook.com (2603:10b6:208:3a9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.16; Wed, 22 Feb
 2023 18:03:01 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6134.017; Wed, 22 Feb 2023
 18:03:01 +0000
Date:   Wed, 22 Feb 2023 12:02:57 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 v2 0/5] Fix Build ID on arm64 if CONFIG_MODVERSIONS=y
Message-ID: <20230222180257.l22ulyjsifpog6nf@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
 <20230221230225.cll4lfsxhv2s4sms@oracle.com>
 <Y/WvsGwUfsenunAw@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/WvsGwUfsenunAw@kroah.com>
X-ClientProxiedBy: BYAPR01CA0028.prod.exchangelabs.com (2603:10b6:a02:80::41)
 To BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|IA1PR10MB6123:EE_
X-MS-Office365-Filtering-Correlation-Id: 508ce41a-43c6-4bde-0fb9-08db14ff0928
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tdWtD3A92x4ltm/QJzcFyoccxxD0GgclPsTaj9eI3N/Sh5bS425P/hgSBlWx5VvMynSvIy3vZW0Gt+tdprRB0EFe4NkAJ7nK4y7DQjc4XijBlNCOZsuRP9nF20TigSs4OAM1EQWN8DoOVKtncUz07s6GCSyB5QdwISO/fJ5xKotTOXExXjqiE3/sDtWEzrUqnWbUgKIehiR3WH2zljat9ll2sopUTbQTaXsnv81IchoLGrrmRHtONDZEHG5RTcEpe/RBcTFgDO+guZsEhRUWMBkdoVA2HMHGS5ar88JKAnBopMntW8m9k+bJ8t29takMThZtRbJyC8ufH23rdcKbfdqyP91UNOFA37Zh9TqTJjy5gfH1c9w7Duu1zJMJfJ+Rmp/b+wMqeImKku5L957fNdDS4lWI2dEEpAci89v4FPTdBo7JIGUPwso8REDrPPT+EeJkdrKniw6mkGUCvwZRG0QDybf1UzYoYtN3kH4BHBRh53MD6lsqArm2tcJqQ464NH1kVf8B6L9fLhsH2SmzcSnzPbamF2XGKzqTifbUoXZaYm6uww14WXPvtG+jtkeOm3+kVCq4C9yA3iAzqQKtYI0lsYcQh1dQ8V5B83YnxMwmwwFDuNzJIn7KvII5zoZ4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(39860400002)(366004)(376002)(136003)(451199018)(86362001)(36756003)(66556008)(6512007)(26005)(4326008)(6916009)(8676002)(8936002)(1076003)(66476007)(6506007)(186003)(41300700001)(66946007)(2616005)(6486002)(316002)(6666004)(478600001)(38100700002)(2906002)(5660300002)(44832011)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dEw2S2Q3YTFRQWVhcDRXZHloYjdlaFIyYnd2S3BpdEZRckxjcUdSbHozTEJP?=
 =?utf-8?B?R0k0RjY3elNBUzEwTjk1bmVtQXhEWlFDYWc4aFdpODBVZ05vT0VrdkxXQ3FB?=
 =?utf-8?B?bFlLby81N0lYb0R3NXFzVFNOQUtpSmFua0J5MXNsNHMvUkdqbHh0bk84ckI3?=
 =?utf-8?B?VHdwZ2FncmlCOGxlUzdXK29GWHdjcCs5dkR5UmdXWnRkOVBlYlpkLzFxMVRZ?=
 =?utf-8?B?OUdEOGVSdmwwL3BaZnAyRVRTTUxNTDQyTW5rd29tVGNhY1BvUXdOTlFLZ0FB?=
 =?utf-8?B?cVlDcW1kd0xnVFdFU00rTk5pbFpIOEdsVFBhbCsxTDMxMW5Yd1NXSjNiQWtz?=
 =?utf-8?B?WFJYeFgxU1FPZWJWV2s1WVNKZDRQN2YvRllKT25sS2NBby9OS2dVb2NBamVJ?=
 =?utf-8?B?STV6ZU81THErdWVtdnlSQ3hjWXJJV29TQzgvTEFEZmU1MjdCTFNLR3VKellT?=
 =?utf-8?B?RjI2NDE0czJPaHU2VXJTb01xSHM1Y0YwRE13ZnVyV2IyUFJCdEgrZUo0UWNG?=
 =?utf-8?B?T3NtN25hQlRVbjRaSGRwYXViT0VubXQvZlhOS05lcnpncU10Yno1RWdSdWln?=
 =?utf-8?B?aHljK0RRclc4QVlwUmZOWWN0OGtVR2h0QmhzQ2xBc1hiWnV1RkFUZGpMMzEx?=
 =?utf-8?B?UWJRMFEwNHhlaXRxdDBNTk1TeTdQZU1vSkgwRS93NVcrcCtBdmlLMC9NMDM3?=
 =?utf-8?B?M2I2QW41ZXM3cDBmd1pXc0RrV3VRNlNGOHVnMExkMXJKR3pGblo3UUZzcDJE?=
 =?utf-8?B?Qjg0dHdaMWovMVA1R3E2Z3J4WXJucHRYdTR0aFBnZ3ZVZWVCVlFjQWM1TjdY?=
 =?utf-8?B?WW5jMkd2ak9iYU03UnZXZnhpSGxWTDZ0RkxHOXpvd1BvLzdzS1hxbmhqbjZP?=
 =?utf-8?B?WUR3d2dSMEE0WmtmYWpDblZvYXBtZUlPc2o4WE9LNnpHVUx3cXkrRjBEcDNm?=
 =?utf-8?B?cnFHOGhaTWtEVDdpRUJtbk9EOXZMaXlaS2lIRVlYa083YjZweDgwcWIvck45?=
 =?utf-8?B?T05Dd1VXWEFpa2txRytrbm04MTBkTkUvS2RoRWlwRndub1JaZUlwSEdoVExO?=
 =?utf-8?B?WWFwYjdLa1BnTE5lejFaajZ1em1IQ0ttcC9xT1cxbGRCYTNuMEJGRTRDbVYw?=
 =?utf-8?B?SGFyTjI1RDZKNXE4aHpESHpOY2NTT2FDYmZKbCtCQzUxZWw1eS9HaU1IeFl1?=
 =?utf-8?B?RDkybFhRT2FCRm15STdtM2ZYQ0dYa3ZBRlhCQmxKallDOXZRUTJiRXY3a0xk?=
 =?utf-8?B?MU9XK3VvOWhNS2VFWTQ1czVXNTM5Mm5DNVR4b2xZRk8xMHd4RWIxZUZoR3Rn?=
 =?utf-8?B?Q1M0UHFTRXFCTVlKWVFDeVVsVkNiaXE1TThxT1plQ3VRTnVuL3lXdXBjZDYx?=
 =?utf-8?B?akFmUmdWSmNwNy9EMVBwRkZJeVc5U3B3b0VONDZaWTRucXk1STBWcXBDY0hl?=
 =?utf-8?B?bEpzeFZGNTl2bnpleWZGcVZjVlhKM3E1WmE0RHpSSWVMQXVHUU02Umt2dFJD?=
 =?utf-8?B?b21FTEE2NndnVTJYbDljWmp5NmlhRktweFNHdi9Nd1VUUFpleWhDcVRDQ2xX?=
 =?utf-8?B?TGlRSjB2cVhLSjFieldCOXpKOUMxdUpiSWQ1MzB2cWxFUHlJTjd4eWZOQnBk?=
 =?utf-8?B?UnQ2SVhYYTF4aTdpdnJrRG5KcjhNa3l0K2w0ZzdqRExGaUVwWmttejdyTGJV?=
 =?utf-8?B?YzR2U1ErY1RORkF3ZWRYSzRYam11dTJnbWpBVnBINnc4dmEyS1lIeWh2S3g5?=
 =?utf-8?B?WVhORVhaaHowM1dZT0J1Zkxtd3l4bVhDUDVjWlJwMWVWTXpQR3NCMWNpYTVy?=
 =?utf-8?B?R215alFIVFNnL1o5cDBxdWIyTGwrTG9HQnBSdDNrODFjVVFhU2h6K0sxRlpo?=
 =?utf-8?B?TCtIcjRhNFZsWDFqUWJ6WkVXYmlCb2dOdkRSdS84L21ZMEpjMFRMRlRkaVdj?=
 =?utf-8?B?N0VnK2tKK0FNYTZwYlFOcnY0a0ZSOVBnaHZUSCtVS0R6RXc4dm9aaU9PT2Rz?=
 =?utf-8?B?b2VSNHN6SVljR1JVMVN3Tko3K2VlTlF2d3lqcWYvTzlRUXRjeU5yYXFpdVRU?=
 =?utf-8?B?eGppMzA2Vm9leEwxRE9sWTJSejVTUGYxekthV3F0L3lIcFhMbjAweStubjI0?=
 =?utf-8?Q?gl0DhQz262oC1You9toA+d3Hs?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0asLX7cRhdiLLlgj/RE0hcXTbl5bszOwdF3NKTToyaCMYbHma/CqQdE/8F1G2OveT2iw6NnKATWwkx/5qHRGFIUMSQoAGDOFegfb6PEdNfl7/1ANPdSgR8SGlOuHYDTl/DbZlFNwekEAWxvZBRJo1B527+6RybFLpAdEHL1pnyp/658DIoHb8irP++gWooe0OJG/K0C+EI6qgx3dhoQOvqoB1l4W0S893qR8t4j4x5tfaa/K3IoilfKyexRvNS3zfw2l1rQNOjAqu/HTNDoVGVqz3EoYFq7jPzZo0ZnyKUD3+sq0/kiADUcKf8jZX+Y3H1HHF3iM1R65UU3SwEsUYGGDpy7ZcvsMuLkcIubZ+pyY4PXaK2fpu/4o3XND8dBxCFspQ8VVvsFx5gDGpYxjSeuCVP/6k2c8gZxQ86OGTfC8xlnCVSsO1zGK4fJIXZIC26MSQCrOJSzucc7HWN34UjQ2eu8F7A0lBED3glQPN0mtN/r7eGWXUhSOQ728ySshSkKG0BbhZFD4xh6GraRKS5dmtlvI8uypA1qerzk4HyFn7WvjASlU09ySIAghltdtAezLpPMnT8FicpQ6PGF6P4qZ4pSYvHrLcV3DSa2pBjurcBzdeKTKMMROuTGlNHFVACerWgXglGKJBu/yBnSlC7zruXFafto6oxDcASacDSJI7qPP5dldqjD17KJa+Yqy5uIon3JrVSQQb/n1kqCU3XSoyKUnI1jrX9vw4lAFbw+N6AVMaJ8yzpgovAdJM5FO+zyHjbnf2vsdEPY9BOJzv/7BJRPo2Qqvhti262GmnSUn2mggAge06Ifn2uUDHD5oE3hNShuWnoiUzn9lkiy46Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 508ce41a-43c6-4bde-0fb9-08db14ff0928
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 18:03:00.9174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0u7PcEHZFtHWCWi6Fa5FgFYV7xjy2aXPhDd+FyaiosBgHiP2TNLfSPWmZYTdvMwBcSijFFTxTDc7YAVqLazaUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6123
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_06,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=622 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302220157
X-Proofpoint-ORIG-GUID: 3Lb9-Yv8H-nqbZRfLc7lK-p1_A6bG1wK
X-Proofpoint-GUID: 3Lb9-Yv8H-nqbZRfLc7lK-p1_A6bG1wK
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 22, 2023 at 07:01:20AM +0100, Greg Kroah-Hartman wrote:
> On Tue, Feb 21, 2023 at 05:02:25PM -0600, Tom Saeger wrote:
> > On Fri, Feb 10, 2023 at 01:18:39PM -0700, Tom Saeger wrote:
> > 
> > I double-checked submission procedures and I believe everything is correct, 
> > is there anything I still need to do?
> 
> Not top-post and have patience?  :)
> 
> They are in my queue, I wanted to wait until we had a "quieter" release
> to put them in to make it easier to handle when this problamatic series
> is let loose on all of the builders.
> 
> thanks,
> 
> greg k-h

Understood - thanks

--Tom
