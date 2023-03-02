Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5086A7943
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjCBCE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjCBCEZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:04:25 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00F3367F8
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:04:24 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321MvR8Q013690;
        Thu, 2 Mar 2023 02:04:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=RdWkHqdkAuWyigm8Pq3tJL3YKVMV7wrzxo3oLgZnOdY=;
 b=KS64I2CLqawLol6oD4YbMRan5h7HZowaHy8HfEHY5W0SUpHWjVDQoH8ng5WMM247g7OL
 aWUs2qokcLz2ZCbAvml9iJhh1+wzY1ZJtbdRq2IoRQDYzVZFFRP7D51SXGk0gnvxLkgi
 E6Z0AfzH+aTcfJ+VUNA1lhZijP4tk6VStkDk9Nh5ES0BPg/v34ukniJpW7Zt0c5LpRRt
 V9xcJ5fx9yjuRXaQmII1i9P9Gk80foeHZAoOiPoyGhJROqfSdJEhLnoHpob7aSu7X2rS
 2y0/YFU84BRUE5BZAlvr5FItY87t36CrS9P0DijqG/5NYw5YZecfktNKnpGfZij1YDgl Ow== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyba7jd86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:04:19 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3221Svol015969;
        Thu, 2 Mar 2023 02:04:18 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2046.outbound.protection.outlook.com [104.47.51.46])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8s9pdnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:04:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+q+simLX6ZS2KR6ahyp0O/d2pn7WKL9XswDtUnoYcgDuGyQF4hUg7KKFUpgr/uQq2mMEJLnQdoYR6xYk8QBj7NyH8ofI+sJHb6OjjxeJDDxJezePbx3wWOp2OnyO2lP2G8IJE2QK9ITdG7AEdS3JCnwqh6W0WIGhJLKgTY87hb//ScXmdQE3MdSHqmFWxfp9WnsWgujfS10Km1B2HZXvxm1lAwb3QLYacOhqsXMf0ZgX1xNLMsvrKPSl/EQXroUPVQZxt9A4x19A1rxlHQH2EdlKlvq71NjW5VYAzc1n+go3cn0fc5VwA1E/m2gVBa4U5MF6+QyNOoMUHkXBGD4wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RdWkHqdkAuWyigm8Pq3tJL3YKVMV7wrzxo3oLgZnOdY=;
 b=L8Y1oYR5MeyebepsD/iA8QwEJjto3aLhG2N0MSl9uGSyy4oRj+xk04kP0WU5jOzalpH6fbEMnUxWX2XI5BCLx5DuH1cVPXO9IkOV1LNaICZn9GGyeU18AWhlvyF2kKxetx6QupmH0KuX7tSPr+RCjx4YDMPSdr+54AMScSkLE9t4MKwieOkwP6NCz46gqRfETJODrYWRxigO5ivRtD1RmipvqumNT4LMSKYw49jDjgjgLHUnIjUHE2q41HDfYRktNYWcPKbYzklpjYca6uv6b25ns1uwxHWzCCB/b5XEXlIv5iB28FJ+68pm1pjoENx5EaLNbkMetO5f2l6leGoepQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdWkHqdkAuWyigm8Pq3tJL3YKVMV7wrzxo3oLgZnOdY=;
 b=APlohBy5HPedLtHFWe9P2YBK+P5CTaiA/mr6HkzdTs8eu5z5ef3V/izOE5ev/w0A7cgNltdvDzj/TZqptj1uyteO8epmmZ4csAra+kofHSJedvpEd8kT9nOXTO8cwVkWmba248cL7DFECGRKgq+6KuqM3lPp47HA/Qqh7OswatE=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DS0PR10MB6872.namprd10.prod.outlook.com (2603:10b6:8:131::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Thu, 2 Mar
 2023 02:04:16 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 02:04:16 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 v3 3/5] powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds
Date:   Wed,  1 Mar 2023 19:03:50 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-15-v3-3-3431a425f0c7@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-15-v3-0-3431a425f0c7@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-15-v3-0-3431a425f0c7@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR07CA0072.namprd07.prod.outlook.com
 (2603:10b6:5:74::49) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DS0PR10MB6872:EE_
X-MS-Office365-Filtering-Correlation-Id: a6c4b9d2-fc52-477d-1639-08db1ac26d2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CzFt3yadQfvhwkP0ROqrvmHnTRR09gbXpNMYaU+oQCdAmyCizN3DrB/OND7nB6/o8cnBwU1n+ut19bvXB4xzUV5jMy8F5dLR2MSq7i0MdAPXLe6hyfzhnNnBGx06G7PA8ZD/y+YLPTmdDqj5iK8TRRbY9HJ2yPkwifzHZz0VUPeK2W7cxncRaBc4zlK1BnMMwarkEIJmilo3WZngj7FQ6nbhrJ/kh+PK4jDd9zcJ2LchDjQmpAHuc7SPfHUuvuR5OAkGVAT2p6atHPhl1QeBGuCS1xZMRoX4MAPGgSfM7uo2hjnG7CKn0qsZxbYiztzfx/Fbml/m8+ENNLJwB9WYlG8oMUXdj+FAhyyyEkyRhz3uazxzANyx+rjIbBhKUSqnfSdZp8fXzuUGBnpjlIXg8BU0Q9630VZj1POVXKrn2e/Ge6pqikwZuC+l6hE84jt9zVoP52mULL5EMD5IURpasB5omIqbjwVnYdHpmLwvHuiIc6P5HQT0DIRehE5/quXFhGgC5imSsDkQSL9yKSOsFf9EZRZBLE+kZE4Lrig1dFqk7IFgPYqJowKkGHOo6AhC1xiRza7C9j/mr+QzUlsokQTu+kah4Tu0QXEccZ1QYUInIICv6nPd4lbBC9rvw/8RG3bm/Cr4/G3Gkb3ntoMdDHwM2Pqyk8N+glwSuO3/FfTSO1N/thkyrUID9jB5Dfge
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199018)(5660300002)(44832011)(83380400001)(41300700001)(4326008)(6916009)(8676002)(8936002)(66476007)(66556008)(66946007)(966005)(316002)(54906003)(38100700002)(36756003)(2906002)(6486002)(6512007)(478600001)(6506007)(86362001)(26005)(186003)(6666004)(2616005)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekViblRIaUY4NDdBbzFab1c0ZzBHa0EwNzBqTDg4UkxoUk43dGI1cUFieXZO?=
 =?utf-8?B?cGtsb0xRV09aaDR5QUpLSmVPZzJHLzdVekNvRDhmWVVDdStaZHB6bEUyenBU?=
 =?utf-8?B?akZoY0hDNjNYYURLTmpwVG5qT2Q4N1lkZEN2dzVlQlZxdERVM2xaa283S2F5?=
 =?utf-8?B?WXczek9pU0tuVHZOT2M5ODRRcUpod3BZdjkxeWozUjNxVnVXVHM5OHJQT3BE?=
 =?utf-8?B?bjgxNVdnZWNqeHBKeE5NMkk4Umo0dkpnZ284NVV1c3VmRTdXTk5lV2o2TXFa?=
 =?utf-8?B?aVp0ZFEyZHh0YkZ3RlRNSU5RT0M3dTBiRUlCdWFsSFYveWw0RDUvRHNYb2xr?=
 =?utf-8?B?SWlzT3J4RVkrSk11TFROV3JvOVMrd1Yvb3VDS0MyTDJtOW5rRm42czdCTGk3?=
 =?utf-8?B?NVdGUThBNThjRzU3NjFMYXZGSmh0TDdXNHM4QVJGRmMva2Nqd3NUZVBDamdM?=
 =?utf-8?B?akZScHJacGYzbVVRM08xQUE3TDBGd21vSitKN1lzL2RrcVhybTJjeDR3TXF1?=
 =?utf-8?B?OVRwZHg3bWx6YkFpN1JpUFFpU2UxcXVOaWdMbGF0TTZxRlh4dWx4YUVRQkpp?=
 =?utf-8?B?U3daU3MvdTRna3QybFlhcXJ6eGR0OVdxaUdMalNlZ1ZVYmRzT3lQMUVjbUwz?=
 =?utf-8?B?NUZSVFd1dWliOGxtalN5dTdBQ0lud1A3OU5iQmFWNXNOVFFiODNyVjJZRmZj?=
 =?utf-8?B?b0dZWVRhb01laWNIekxObk5pcXNnckUxQ3Z5OVFXYm56dnNBMjlYc1pHTTRF?=
 =?utf-8?B?YjFEYlYrdWxPNDlYdVM1dTJORDlOcEFhQ3VUTTJ6NUxxbVJpbFgxVEhpSUpv?=
 =?utf-8?B?UzFJN0FqeDlMcnUxQ3EvbTRVaHlMdjNkNmlUMjVabXcxaWg3dk12N0FwZG5u?=
 =?utf-8?B?VnFqbWxvbWdBZmJVdUt1QjY4VlZzMnV2QmhPWG5tVDZJYkRaKzFoVFNBWGE0?=
 =?utf-8?B?UW5Yd1ZYZCtOVVh6RjRFaUkvK1M4bVRRS2JXY3g2a1k3c1E5d1crV2s5WmtY?=
 =?utf-8?B?MU9jMmcxeDFsbzRGL2RSQ1ZrUXpaM252TmFWQWdXcGhxMlA0M0IzWlhPWTZF?=
 =?utf-8?B?NVMwclVjcHZKc2xqMVVYNlgwc1JYd29mSUNGM1BpODFxSUlscUJKR2E4cHVW?=
 =?utf-8?B?MHVlM3FocWEwamFqSVF1TWZJN2VJRUkweUpsb0MvK1l0RDN0SzU2Q1l1WjBL?=
 =?utf-8?B?SUxVSEQyWUNmV216cHVmT2srcVFEd2NQZVhUbWg2S1B4QThiRzN6THpCYlhP?=
 =?utf-8?B?NVRFYnlLS2x0TzNqbXY2ZWZWL2E1bm5KbjZDOXhNeDNPWnE2d1RKZkFwSCtm?=
 =?utf-8?B?aE5NOHRHZEtXQlY4NjRJVHc1cGlZYURhdUJacnJNTFhTRVlpbVlLUzFldkJU?=
 =?utf-8?B?TmpIWXM2NU5jSW5nTXRHSFFzNVlSVWtPM09NLy9UaFlobU83c2MwUFlpeVpi?=
 =?utf-8?B?QTdWZjhqYmxnM3lZSHg1QUNwUkZhc3kxRjRpS3doaU91Wi9pNVN6MGhHU3Yr?=
 =?utf-8?B?OGdGeDJ3TDBVcFhqczM5aGUzNkdYNElIV2I4QUVJbG1oZnRQbjhFU3EwSUwz?=
 =?utf-8?B?M1VtUUFndkpKV0UyY2ovWHMvd0hDZFZKRXRSR1Avb3MrUENJbVA1bmFycURF?=
 =?utf-8?B?aithMnJIMitreWVvSlVWM2xwLzc1RTJ5M2M4Ym5pdUNZM0s4UlhCS2lTcWgw?=
 =?utf-8?B?Wnp2YjZGbWFLSS9JMGhDcEFibkVMcmprYTl1WDd3WTBqNk1OMUkza2ZnWlJz?=
 =?utf-8?B?elZxa0N0YlZWSVR2b255Z2tFQUVRalN4Z1QyeEV4ZW0wNWowSjdaNktWZXVC?=
 =?utf-8?B?V1MyTnlGaHlaR2xmbVR3YWNTWU1yck5qNWg5aVZESS85dythbnZ4ajRsREkx?=
 =?utf-8?B?TnBJak5ENHZUU0FZTFlLUkNiWEJnSXNBVXU1bmtKckRmWk4yUU9YTGNudURS?=
 =?utf-8?B?NUtUNjZpaVVMdkI3WGIvUDgvYVRUWThUamtScUVqOUE3d1NudkRTc1ZvWWxa?=
 =?utf-8?B?Zzg1N1dPMGdRb1hjcG9Sci9vQk5EZTQreVY4MzMwaVZKRWhsV1JrNFpiZHB6?=
 =?utf-8?B?WGlXVVZFK2QrNlpLVWFoVjZnT2FSOUdXUUdaU1htMEtJYXJyVTZDay9PL01R?=
 =?utf-8?B?UWdVamxGUmlQYldwVVVlY1dtemlRSE1mNHFPWndIS1dvZ0didUIrc1lja1FU?=
 =?utf-8?B?amc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: D7ic32FC6YqzKzIDs2v1pUdbK8Lrmm4ffEFqe8dzYpTVCDbBP3aLgTyFfzUbbSU+ZCiAI1jVkzOZFdRJf4JaUb264dICLklK/s8K3j76kCC70SsS2lgwhjkH32188Z6ziIbQl26/UphyJ31H8e7Sn+8IH8RJnPCN5GvTMoJcH+kya86l1Cs+verPuNAy01Q2nXeBtK/pxrfSj61IhtmfDv5vDKHCzxdRCnntHXyzMmduTYN1uEsVKCoEs2hBghZxG/7vGmtUdjGPOjDciDvEtiKXEB5EDCDLyF630NkAa1HMW4th2kCZjtjYPDc7N3m9ahW6AxLwX5Eexf4yQ0K0i+QzPJZMAqxxqw14a/tRsHhNMo3MfqEKBR5Jd0/rKvvd4/8DbSJD7bMUGfcx6w03/oeU9XbLBVozieH3YJpZzIC7KuCroQ2qjXDwa8IuT8+9EwQaf45JhNuVZTlQk9KTWm/a8vcWf6fLcTYwh7kcB1VTOo4+5OE78EJ8DN/q6rDgfkU7SBwmHMN3lIG/tuFVF6/u7T+i8IH5k+zEuQdPJOwOFdJV3UxS05Go+8QR3E7iQzqynA80HCw5fmm/clm1Zw2VJDNOPWbvZxPRdTATsAa7W2KfQIAYyWTCwth8qMN8x/uivOdZ45pgljU3biZjsLENHGO2o/7KW3M3vfxZe2PvdtBeQCffujviwucWBPnuT1mwUBnSWAt45Xbcq6MviMGY14Ajpiycg/KQ18xKh6PwW8SMXt92o1Qs7TAb/ReEqFoGF+FBYUXRBzMp3iaaP00NDGCnW2aNtCEc1Y9lis3WuwvQIck5DUVKXSGwW7Liy70FQ3H0KXBPZJE1wH2aqvZzsnocHRMbOD7D0zqXZsv9ulKtcUyKsBWJxqrScZTX
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6c4b9d2-fc52-477d-1639-08db1ac26d2d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 02:04:16.2893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ai43u3qbxtMtLhZbSguks6Jn576MMeuBJ/LFjM8dG1qKTh6TkkOm80HDeTq45MEkGH7PNbsb/6xkkCBBqHO8Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_17,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303020015
X-Proofpoint-ORIG-GUID: AyJZTFtc6j-IauYhIq0KTJdEqqzApkOC
X-Proofpoint-GUID: AyJZTFtc6j-IauYhIq0KTJdEqqzApkOC
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 07b050f9290ee012a407a0f64151db902a1520f5 upstream.

Relocatable kernels must not discard relocations, they need to be
processed at runtime. As such they are included for CONFIG_RELOCATABLE
builds in the powerpc linker script (line 340).

However they are also unconditionally discarded later in the
script (line 414). Previously that worked because the earlier inclusion
superseded the discard.

However commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and
riscv") introduced an earlier use of DISCARD as part of the RO_DATA
macro (line 137). With binutils < 2.36 that causes the DISCARD
directives later in the script to be applied earlier, causing .rela* to
actually be discarded at link time, leading to build warnings and a
kernel that doesn't boot:

  ld: warning: discarding dynamic section .rela.init.rodata

Fix it by conditionally discarding .rela* only when CONFIG_RELOCATABLE
is disabled.

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Link: https://lore.kernel.org/r/20230105132349.384666-2-mpe@ellerman.id.au
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/powerpc/kernel/vmlinux.lds.S | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index fda97c3dca4c..d4531902d8c6 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -408,9 +408,12 @@ SECTIONS
 	DISCARDS
 	/DISCARD/ : {
 		*(*.EMB.apuinfo)
-		*(.glink .iplt .plt .rela* .comment)
+		*(.glink .iplt .plt .comment)
 		*(.gnu.version*)
 		*(.gnu.attributes)
 		*(.eh_frame)
+#ifndef CONFIG_RELOCATABLE
+		*(.rela*)
+#endif
 	}
 }

-- 
2.39.2

