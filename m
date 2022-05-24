Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2380532D87
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 17:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239001AbiEXP2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 11:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238900AbiEXP2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 11:28:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3558BD14
        for <stable@vger.kernel.org>; Tue, 24 May 2022 08:28:09 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OCxLi9001538;
        Tue, 24 May 2022 15:28:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6I2iQKyTfq65ZGqOWvjHAOj6ggrjEHLb/MXlApRkHFI=;
 b=PRGQY+lwqR8AVGjtwx8d/eaL7ExxX/z3Aw3Z/OdzTEDmctSJQE4ffBKrVhyZ5D/fTgHn
 P7i+dds2fQ/SKlVc40KI1kPYR/E/R5BczD/SrFop0ZjqPq38r4AkZkJLrTsFU2OCqbaN
 WCDTMD3/gKHZor/GSjUII4L/psjnHGh+fXHvqoW1TckK+BKK6nJDA5BqMpwZWN5Y755+
 No4T73v2DIQRUbtCLMbl9NDSC5p0soK1Ik2iXcxKeOyYsYCgGoFkaenfKhk0p9VsNrW0
 CO4/tyfUonInIR/lCpgiSjPJBBWfqkDCbxwYr3dXgslCaNwARIAMG3I9NPaVI6UW9Yam Hg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6pgbppyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 15:28:05 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24OFFsL2015063;
        Tue, 24 May 2022 15:28:05 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2040.outbound.protection.outlook.com [104.47.73.40])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g6ph8wxc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 15:28:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GThppw+kDSJEejpz0vizQP9RMEtDhn9Ffc2kqNt64QrYcnyuxSlAUnMlACeSXbEjDskt53G3fO/yjeJ7m4B/DBEl/LKZ6eajHZtrYUKR1UHti1Pul1BxTvvIrFKCTMijsh49ACR7st3Ipa7J5oYG+HeIaQAojmS6R3xNTmed+grV5E7cFGPcYcIFFiouKJxXRI9o7JFv64YDf+j9lghZP6X+8bkZiNojt4rU47CauuuLXoj/GRVH1LClR8tcrAuvR05sAXJnf9L+0nSZZaBsQFI3IgIvkPdGELRWISjXlLHQqwyRKWMIjvHsXwFDW58qX6bbFVkHWh54tTm8z1ZZMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6I2iQKyTfq65ZGqOWvjHAOj6ggrjEHLb/MXlApRkHFI=;
 b=ZAi+CR+hiipbyGfTu9Qyla8ZghsJvYFzn0/hIAr3oDRauuekzBCioWiB/y+ym5rNO53r4s1tgwZg03IyNxuW/auDcnSlmTD8ODlfHOpxpZRwKWFERZ2TdwaJlac/HnulHBq50cj9hv3kFPQut7nzd3btUwzPpVE/cp5WMdek+0wvfmgJ3GsD0rwCDRSgAlWbNZKocCzUu6jIZzuQV0RcElBobf1yyVYLT0zjdV2KsMuNltPNBarqDgvc3kk5FfsgKXQKjDVM+TWX8AvDfWVrdVqsTYmx1TkP3xwE2zu0gWDQM6BEnIJG21dcgx6F6G/tQ0kCNz4ii8DFeWLAVQVQmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6I2iQKyTfq65ZGqOWvjHAOj6ggrjEHLb/MXlApRkHFI=;
 b=bRMUJZjNfXr9JGGlWkPkUA7phIOY24qUxoTA4MEG2GV+K1lIZSE8ekw5/Tr9ivd3wFoJTSdy6SLsdyZttaF2bpa0fKtn1QCwOJ9++htHz8dmD7QfTQzNL9u6SkvjS0mkVdCtaRniNXw5TXHIohHadhFSA0YFKrciqMMSRCNjFqE=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by MN2PR10MB3135.namprd10.prod.outlook.com (2603:10b6:208:121::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Tue, 24 May
 2022 15:28:03 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47:2730:1cb1:bd51]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47:2730:1cb1:bd51%5]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 15:28:03 +0000
Message-ID: <e4127ebb-c589-ac2c-e77a-6c56a9c8fbc4@oracle.com>
Date:   Tue, 24 May 2022 17:27:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] KVM: x86/mmu: fix NULL pointer dereference on guest
 INVPCID
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Yongkang Jia <kangel@zju.edu.cn>
References: <165314153515625@kroah.com>
 <20220524151118.4828-1-vegard.nossum@oracle.com> <Yoz4Qg+a5C/lw743@kroah.com>
From:   Vegard Nossum <vegard.nossum@oracle.com>
In-Reply-To: <Yoz4Qg+a5C/lw743@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR0P264CA0083.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::23) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60c7dec7-4580-4f76-ad4b-08da3d99fe0f
X-MS-TrafficTypeDiagnostic: MN2PR10MB3135:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB31358205DF9EA9AAD79A85BD97D79@MN2PR10MB3135.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PdK4P9trpDeK2U6nJZvAwuoYQxSqbuU1tf5AhjS1n1VvkjxtzskIIPR5Z70imXY3VhmwhRfkdwJVhpBdMlR6MlyiePkN+8f8+37MF7DSGwoIfaoOA26akozvHVLecsUwqJcpBYLVhJ1Udyqs6Ae/sxEz002elwpz3sya+eR3eBMG2NtMh7gNdAQsivdRiJ4Vczd0BnYxWMmk6B/pljff3lPkW5OKOsn98sSVcVO9EjHeYDCH0q0N4j7B/DBURU0YB28Erq/o0apx0X77lTfbWXFjMOLFhTbvY1sfQlZ3GCaQHJYVkak8O8SEdeYJIYkH9AzSzCmxZWS0ORYdyPRME9QpVwP7tZU4qy1Scvkq1qQo2WX85fdQwraHP0HeXip9jAc8bOcoRA85RQWP4LST99S4I0CO+M1DElmcAIg1pFtrq9G7s/8u1poCMd4xU0TDb7t5JdwUTqPb7qmfc/WGNJvGMdY0f3h3iKvGKmKqJfsUh/HVgglnCQ1hzebv39k43o3eT1KL7hF0RzmOKpjZyeG5xnm+W3mjBBmR8tov/tiCfpP7HYfnboDs5oBYo29040yPLJMETLq/iFCPOCHiT5hqNZFT8/vlps7PXrrr5h27upatKWI1WkAQDLw1ZjHzlsEb2pKP5G3pjVbUHgE8qqAvuoeFys9Lxm8jdBUh0kZ+vtxapOs878QehxBFofTYA+6cneSIa2wLTeGP9oQbNnyXJee0mGKGYwL0gHEfc+m9K4BVyBX6jeJ/oc93Fpj2WqhRdsLpZv0agxcXU6pBfbzWFCMYqtYWGliuvqsHLQsn77oIPLRNSXUh+xPm4T5KgSSeid4n7m8GsRFsZR4RKwhK2PPPLAPb68ES493M2X0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(31686004)(186003)(2906002)(5660300002)(8936002)(6512007)(52116002)(83380400001)(44832011)(26005)(53546011)(36756003)(6666004)(86362001)(66476007)(66946007)(8676002)(38350700002)(54906003)(38100700002)(508600001)(6486002)(6916009)(2616005)(66556008)(316002)(31696002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0d3RktGMEMwbFRJdUlzSE1Kd3ZYQ05YamNCYW9mNXVlUWZxNUdaR0I3emFK?=
 =?utf-8?B?OHRvQTVaa3VSYjVLWGtqVGdnUWh6a3VqZW1keUxXaVBaTWJlQjlhditReDJU?=
 =?utf-8?B?R0t1elFGbmNSa01uY29EMVVwWDNpNXl5eitUNEFXVmp1NmZpM2JvTHpWc2Va?=
 =?utf-8?B?Q2pPOGtCSUIrOWZQN1Jzbm4wN2xzc0thNmVGaVBkMmhYU29ONnN6dFZEVkJl?=
 =?utf-8?B?NTJ6Y3pNUlhNWEtRcEhQSUlwKy9QVHRnYUlZQkNmSWxrbHdKK25uTWFuMERP?=
 =?utf-8?B?NHA5Unp5a2hPRENMazU0VjMvQitXU21xMXZ4UGFab09WWVV5QVlERnQ1U3RZ?=
 =?utf-8?B?eGFGUElKaHpud1RVVXFKWk9Dc0IzekRyOE1IaXdQSzg5c2xkMUxJME1IdW9p?=
 =?utf-8?B?N29NdklDdkp1M0tvMWtDMU9XUDFpbzY1eVVoSWx3USs2N2prS29UK0haenBD?=
 =?utf-8?B?bVdMRDdPNmNZZk03NGpvS1p0U1JRWUk1MHJoV0RJVis5bVBlSFpuckp1YUs3?=
 =?utf-8?B?NitaanVFTFVZN2VOT1dHWnVuUmNRMlJETjZDc0d5MGVPWUpJZDNsbW0ybzlE?=
 =?utf-8?B?M0htbjBnMXdUd3BjcElHNUw4VmpaNDdQQVBlejJYYnljVmFLeTE2Z3NiaWd3?=
 =?utf-8?B?QUlSeG5MSHlQY3k1TFpLbXBrUG9DUVIvUDVNRnZ3MlcveGo2NitsYS81bnpx?=
 =?utf-8?B?VDZ4M1lRSDU4Z2JPNitCN3pzQkdFS2cwMXdMLzRvUGFEMnVSMFl6RGE2ZS9V?=
 =?utf-8?B?ek5aZWFJWU9McUxSRTRBTi9OZUhEQWthQ2E4a1RPSUNoQTV4TUtlTTRQbzNU?=
 =?utf-8?B?WDdRWlV5S29ScHdDNG9uNVdURlJ6WVZQQTFYczNrSEtmWmdYaGdwT0E2ckZz?=
 =?utf-8?B?dTBzK2o4ZExNUzhONGZQam5FbVhrY1FOWUxGaVYrLzgwd0NxQXRnckFZVkpo?=
 =?utf-8?B?aFpMYVhqNjlucncrZjFaRTVkTm14cUFZNHJpekM0ckNwRzdKZnRJZzFWZ09L?=
 =?utf-8?B?UngrN3J6WEZUaGdmRWJsdXkzZ1FlYXg3K3A3VFB4UE1NeWM5S3JrRjZadWRP?=
 =?utf-8?B?cVVNVXdNNlBCL1hpdjN0OUlmcFRzcDZVd0F6NEs2QzZaLytSTzNidkIrTHZ2?=
 =?utf-8?B?aWFHRVlCTGorOEFMT25TNml2YWxNSkU4QmJ1RDc1OXBhNlljYlg1MFRCU3JE?=
 =?utf-8?B?WHl5YUw1U2QyNUViUm1QVEF1aFYvZm4rbHZXZjFhbDBkRnhkQkF2aG8zNHQy?=
 =?utf-8?B?NXdlQStHSjQxdUNHSWhrcVdWazk1elNFeERlSVhvOVk4Vkd5cmgwa2RwSkc2?=
 =?utf-8?B?SkRZaVNCR3poN0habXc5bmlwd3RJWHlWanQ0K3pSR3doOXZwbTJYN1RRWlQw?=
 =?utf-8?B?WmpmMEpKR0FtcWdlbVRMNlNqUDBSdXJEQlQvcVl5cW5uODd2Lys2dytqQkhU?=
 =?utf-8?B?ZVdIUGFDRUtxcGJqMnlQYWhGN08zby9NVklndmt1NzV2RWJQaUtzQWRPUnBJ?=
 =?utf-8?B?WExKcFpBdzZHQ3dnN3ZkYUVqNVA5VUdRL015c3RuRkhHQmdOMjZxTVJFbVN3?=
 =?utf-8?B?NnpPdjhPS2FyME92a2xCaDdKR0xJZlBGOE1yZXRwSlRJcks0N3MrYXNRS0Q1?=
 =?utf-8?B?NGZ3TkpBWkVtYnJyRG1QV2c4UXM0MitWTUp5aWRYcVpUNDdnMEhxLzIzNk9q?=
 =?utf-8?B?c25idjN6dkZ3dG4rcGprZVlmUzZ0VlNsWk14TWhHTUc3QUVjMFNpQXRMUGQy?=
 =?utf-8?B?Z2NHdFRtTC9yM1pXL284SUNENVRYMmloOHNkQ09BNTBRbnhuYjYvVS9mc0NZ?=
 =?utf-8?B?WFNHcG12UFdlSmhlaUw5UTIzbG1BMUJWM28zeGMzek1GVUc2MEpvZWRDVnBE?=
 =?utf-8?B?YUVMREJONHRxS3VVVTVjYjdaS01kVDNNSnFGUEQvNVcrbFhERkpOeWRoVGxW?=
 =?utf-8?B?TW8vSTRQRjlncW03NXUrU24rNHUyZkNIQWRpQkdQMVdHVVhld2hFNmlCR3By?=
 =?utf-8?B?VE51eDVIWVUzWUk3MVkvL3MrMDFLbktURS9oQlhaL3BpL2JkLzRldUgxWEpV?=
 =?utf-8?B?MUdSNEFTUW1wWDByandXTklYUzBTVjNXZlFBa2ZNMHdUUVYzekZzSE0zRnFM?=
 =?utf-8?B?N1hmdmpiRjh3c1hiZVk1REpORGdqVDZPYXRXaGN1cEg5UHJRVXlBQVVtQnFz?=
 =?utf-8?B?NldkUXJCN3VzUEp2TzdpNmNBNHJUbHZPUEJCT1F4YUNpdmdBdlE3bG95eFNN?=
 =?utf-8?B?WDRqMHllOWNkOW0xOWMzQ01jZGlTTGY2RHVta3hBam03YXM1RDZ6dG1tMDR2?=
 =?utf-8?B?UGVVUndBeHpPWHdTclQ4MUlSYWFBRTR6NnY0Uzc5T3lUOVRDaEF4T2VVcnRK?=
 =?utf-8?Q?MaPPkejLLJNZQgjw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60c7dec7-4580-4f76-ad4b-08da3d99fe0f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 15:28:03.2295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TyOxsT4/6boIj32+ypMH6Xg/wRHy8E255rmiIFYnhFdjUCKOgUV5CXDo8r5aQdTbyLFjTjYXspeI7QRcpRDhs4YlnD+TxqQMQtBeorpCOtg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3135
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-24_05:2022-05-23,2022-05-24 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205240079
X-Proofpoint-ORIG-GUID: U0VMB9FMlv3p-hEiBsecj-lxIZfhYyvV
X-Proofpoint-GUID: U0VMB9FMlv3p-hEiBsecj-lxIZfhYyvV
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 5/24/22 17:22, Greg KH wrote:
> On Tue, May 24, 2022 at 05:11:18PM +0200, Vegard Nossum wrote:
>> From: Paolo Bonzini <pbonzini@redhat.com>
>>
>> commit 9f46c187e2e680ecd9de7983e4d081c3391acc76 upstream.
>>
>> With shadow paging enabled, the INVPCID instruction results in a call
>> to kvm_mmu_invpcid_gva.  If INVPCID is executed with CR0.PG=0, the
>> invlpg callback is not set and the result is a NULL pointer dereference.
>> Fix it trivially by checking for mmu->invlpg before every call.
>>
>> There are other possibilities:
>>
>> - check for CR0.PG, because KVM (like all Intel processors after P5)
>>   flushes guest TLB on CR0.PG changes so that INVPCID/INVLPG are a
>>   nop with paging disabled
>>
>> - check for EFER.LMA, because KVM syncs and flushes when switching
>>   MMU contexts outside of 64-bit mode
>>
>> All of these are tricky, go for the simple solution.  This is CVE-2022-1789.
>>
>> Reported-by: Yongkang Jia <kangel@zju.edu.cn>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> [fix conflict due to missing b9e5603c2a3accbadfec570ac501a54431a6bdba]
>> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
>> ---
>>  arch/x86/kvm/mmu/mmu.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> What kernel tree(s) are you wanting this to be applied to?

I replied to the v5.17 email
(https://lore.kernel.org/stable/165314153515625@kroah.com/T/#u) and I've
only tested this on top of 5.17.9.

Is that generally enough to trigger attempts to automatically
cherry-pick it onto the older branches or should I test and submit for
the older ones as well?

How would you prefer to indicate the kernel tree(s) in the future?


Vegard
