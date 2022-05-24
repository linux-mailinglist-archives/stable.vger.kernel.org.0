Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127FC533284
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 22:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241562AbiEXUkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 16:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiEXUkq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 16:40:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC676C57C
        for <stable@vger.kernel.org>; Tue, 24 May 2022 13:40:45 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OJSttP004493;
        Tue, 24 May 2022 20:40:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=OTnAzvW8BIjBvy26G1EfDOxahVXPx1XrDuJx0V3ItmU=;
 b=KJiMKmyUyZTxnO0w4Zscm4cTIns3isnW4M12p0EVsEAUrPuKKc8aqXwEN7Dcsl1gBru6
 XL7kXTx4MBJWtOppcQZ9gsbPTrhYMBAwq1er4HwAozpbBZCK/2kv4XB3ob6wjDFj8UwF
 xelXf0NMViu+1GiNXscNf9cc7BpKxPq+BNvOeVp9rRevQXDdW5w6LNOi5lQx1wGPPU4R
 iAkmTTg+MDUNJXaVULuMQ+JP/VRNMx8+NE0xGJXWLV2m/LQqF4MZV6Xp4InntgIV0a/y
 qZH2gRudQIzJTW4gEf/OmcY7OohlZS9g15/XlQV1zuVKtvSYd1JUl7wfa6JQWyDe3SEb TA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93t9reck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 20:40:41 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24OKUI9h026028;
        Tue, 24 May 2022 20:40:40 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g93wumdn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 20:40:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VwbjAVL1CJl/G4hFfxH9M/UXoT4edBMxRAkufPksH44RteHCwSES55JdOmkmMMCaowMe8PSBGGXRTllm0b+A/Jg/AmsRQOpBkxIGuHK4N10t1N/O7XOFnux9UOHo1aJAfdEDprVRTnsXw1XGa7MRoraSEvRvTwCEKrlcNL35jPEh6I8Chuyr4RCgLKKoQWbo0iKWalZ91WvSlDeN0Qo4H0+/7/vK9ZPJcbQmtPinktcmi1eFy1RmKGOHai6bzztj+FI7qVzSx706OCTE3OiJTRS8Es0PVsErkv0ouNzzH1to0J7UYS5MEdNrmwfTEJDCBZVtGVzPD9oWrrkU9glZtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OTnAzvW8BIjBvy26G1EfDOxahVXPx1XrDuJx0V3ItmU=;
 b=eHRv6o0/4TEhk+k3MntQCI1iWA3NqTGP4VSOFtQCAHS2gw4zU1tEBaI9zN764qN1aWkxpwlok6Fw5yPbpfSqx+MVcIDqYSvkBfI4kAIRnuZ4qYvlRi08paVD5PJbKGycZRfHYEgeMhZlMXo8jOW/6igOGdApZZn82bTSnaCmjiVH48hYToTYeaCfStW4zqInyZwUwW2fC21+zYVR1XaIIFPHnGSzIvt0zrt9rr6XELXj2kGlErnbPF1FRNtKixDIyJwrDQl+rT/rYsdAgdaAbUSr/O1YD9wImICqTsCXnjTrsb5bRUUGynsJaDI0Izg9znbksD8O56x+Yvw8je2OLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OTnAzvW8BIjBvy26G1EfDOxahVXPx1XrDuJx0V3ItmU=;
 b=vW9Cl5D+13yiV+0EguF1i6FSZAo7UYG56HlxOWRjlEQEtbmGYZctxW4KwZt9Z/CFKMkuhejG/nZHNrhjXTr1sbD860J/N9ALQQPfFv9mfxw4qjBGOEBdiMVFpVQmu53NUd1gbxB5342RqhpNCUGhT1gkkDKhrY7XVMuB0C9MIf8=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by DM6PR10MB3402.namprd10.prod.outlook.com (2603:10b6:5:1a8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Tue, 24 May
 2022 20:40:37 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47:2730:1cb1:bd51]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47:2730:1cb1:bd51%5]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 20:40:37 +0000
Message-ID: <67e1a766-f828-e867-096b-4dba623ca67b@oracle.com>
Date:   Tue, 24 May 2022 22:40:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: FAILED: patch "[PATCH] KVM: x86/mmu: fix NULL pointer dereference
 on guest INVPCID" failed to apply to 5.4-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, pbonzini@redhat.com, kangel@zju.edu.cn
Cc:     stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>
References: <165314154010137@kroah.com>
From:   Vegard Nossum <vegard.nossum@oracle.com>
In-Reply-To: <165314154010137@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PAZP264CA0069.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::19) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd712672-d792-49fb-e115-08da3dc5a885
X-MS-TrafficTypeDiagnostic: DM6PR10MB3402:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3402F57D91DFDAF0508CCD5597D79@DM6PR10MB3402.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c5TmGRLjkeGKg+KpXHeA8hGanAV8v1EEmEEoMgBgXFHGHxb198hqZBxvTAhDnnY7MlcQgSljRQNA/jb6rs3HyOe4Ivj1Lt06pSapZ2GaudiPwmwgumkHpfu21YI9Sn2XLYJC77kqXFuY+qulBLwobShT0yRX8L/YQqmsKV63SqUazDYYvDNq+2VCPgoDFoOVQAvHVh2nu5oybzkDY39nzle4EqB/Zhy5BBHxTOacbNTak8okXxv6HEm4F5xb/mDmXz5955ISmNvFVz1aTWTanAHgOJ3YXST7oE/f8Nr1pgtO0tPSnRPsT8qPJGmE9l+gYAIogQE6zPB1sLHCjs0Gl76JuQH9KWjW5IJIBfDBdUlo8FDg5BjIrXuP0JawYAkBFoqjBwHaLPFP5pqae8l3UohG0HvfjvN2V5zj0RWXrR4ktMQevDFHbdKegtM1MoZ7mTiP0zmI8Ti/iBWtQPYGMfvm6yZGFHEa+SKd+9mikicYpU/lOCp9sGFQZL5g5B/zzYklLb6cJoHZfRmBFpsymzzLwXJtxt6ALCc8theawOer1S7vviiR7sechxk9C2e/MebSv1DrDJrxjJKczqIuorZLfyAnLmvaT8iREdogl3OcBYv+4P2gOq8qzED4acjnNauuHGy/9ucyvtSFcHgSyHA5jer436MRwl8JUZ4yQXqZDuVsuHmyCVbuDJL1sKs+9he8XOICElct2p/pU7nCbbwVdMEt/adsTNlNE7uMf0rdus4WaHZl9SNum5jb+IKZhZ91GH1hOVO/ToDrblCqDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(53546011)(316002)(31686004)(2906002)(86362001)(44832011)(6506007)(6512007)(38100700002)(26005)(38350700002)(6486002)(52116002)(66556008)(66946007)(5660300002)(6666004)(66476007)(4326008)(186003)(8676002)(2616005)(83380400001)(31696002)(508600001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFJ5SGo4T3dIbEE1eDIvQ0JFRkwvRFFySnhVQnZ2Z01UYkQwV2FyKzU2YlJn?=
 =?utf-8?B?bThEQUc2T1BrMS9hZm5vYm12VVVUaFd3ZVVvMGZlVzBLNmF2S3pob1Uram1r?=
 =?utf-8?B?U1VKMmVCQytmRTh2ZlE4RzdWZTdvb2FEckxIb1p5YUF3OWNaTVdrQ3ZyUW5W?=
 =?utf-8?B?dGJsdWZtaS9PQ2F6MGwwY3gxc3dsbXJrdWYwMnNDelR1eXVvZFRlRzJPeVFD?=
 =?utf-8?B?bXpWK2NqdElYRnF0VU9wM3cvSWxsY0g2emlaeVhXV0w0RjJzYmlFSUw1QXNz?=
 =?utf-8?B?TFMrL0JCRkYxUHRFcXNFK081ME9XZ2ZyWHFxU1c4QjBnMFFZY3l1RG81TWs0?=
 =?utf-8?B?ZnNlQzVwSFg5TUNWS0ZtZVVtbHhRdmFLMHRzZHkyMk1zNjBsMzAyV0RUTkZQ?=
 =?utf-8?B?ejdmNmx0bUhIQnNzMWI5dWlBS3VYMEpsNW56a2hmWlJ2bk1pZEd2RXNhVU51?=
 =?utf-8?B?VjlOZnJrUlppdERNSVMvc0hYcVovcVEzUXh3T2g3cXh4NlBLMi96aUhUeVdK?=
 =?utf-8?B?SU04c0ZZUUp0VEg3NU5kMUtVU05zakkrY2NBTjBjTDg3Ry9wcmZRNDhFM0tn?=
 =?utf-8?B?NW5JL1R1anBjMHMxTEYwTmRyTEhuS1p0dC9va1hvS2VacTJqZGVwc0dqa04y?=
 =?utf-8?B?SEFJWVE5bE9kaHJsdWZFTSsyOWhXb05IVHkxK0tvbk9ROEpLbFNoTzlXOVBt?=
 =?utf-8?B?VExlRnJnM2RZdVovWTBISWhONUg5ajhucXY4U3pOeXd5Ym0rZ1FFWVNJaGFG?=
 =?utf-8?B?K2JURFljMFN1emV5aTVIbU5TMXlVZ1VkUG1wbjZLNTZDaFJMdjNGRTdtSG5K?=
 =?utf-8?B?SitlQlVXOTJ6QlZmMW45OXN1QXE2ZVQxTkd5UFJmdThzUHBITnZ3WHhJdmFC?=
 =?utf-8?B?NG9OdWxYb1hlTlZJNTNtNGoxZkl1YlZSVlFsV2tzK3FNVGZuWnUxM0toQ2N5?=
 =?utf-8?B?elhvbWlhVlo2NWovWTFtKy9sU0JzZTVVUGVyd3FUeTZTUnE4VG50b2YrdEtN?=
 =?utf-8?B?bDJSMmY4Q2p1QW14VnJOTUNlMEVJc3hEcTlYazhta2dUUnc3YXVVeWdsTGxx?=
 =?utf-8?B?MncySUdqbEpXY3NGRC9nZGZqb25Vbmp1ekpRcTYzR1p6TnlCRm55M1pEcmFk?=
 =?utf-8?B?Znk5VEg4Y0g3SWdaQ3VjUS9GNFpzaEhNYmw1RGVkQXEzaTlCNFp4RzlxemUy?=
 =?utf-8?B?YWpUbGFzbUpFRnFVd2RHV0k0STFuOWJOd1pQTDNLaU5YdnFicjc0eCt3b1F2?=
 =?utf-8?B?QjJMTzliTTZLTlpFRzhlRUQ2Q2llcm9vWlVWYWhNQWRLT3lDdml6c0hwazNO?=
 =?utf-8?B?SXhDV3FIRnVPa3h4aU55MDA1cmJTVWlXKy9zYUNJY1dUVkN5NTNVRmlFYXVC?=
 =?utf-8?B?VzFXUEZENHpUMjRtYjRzUVJoMGVrOFhJZmVPdm1VQStFRGlhaG9tQmhpNHFi?=
 =?utf-8?B?S0lrZiszMVFRaU9EVnVXV1ZWYkhLTU1qUVV6SU1vZjJ6U1lOd3ZGUm4wbGt3?=
 =?utf-8?B?Mk50VzNSSDdSOThIcUFxaGFJOUdGeWZGNXdab2ZDWDNYRDlXb2tmdkI1UXd5?=
 =?utf-8?B?RVZQaUJPNDRSWFV1c0dndFJTMmd4ajVxZzFNaDhuWjQ0ZklKK2JmdGJRa1VH?=
 =?utf-8?B?a3BCSGlrL1pIRldoenZEYXQwYmFPK09SSks0Z2pNRTJ3b3Q0aEM2cVNSckhn?=
 =?utf-8?B?UVg3djAzY1ZrMktlRmdCWWhpNW9rL1dTRW9LWk1UUnJCTUE4L25CS0ZHYkpv?=
 =?utf-8?B?ZWU2Q2FDZ3BWT1dPNzRzL3dMR25KYkQwZG1BZFNRVGY4eDZsTWVhUHMzYjVh?=
 =?utf-8?B?clFVV3JSdURqd0VFaGFDaWpMUDRtYi9FbnVVenB0d24rWEpJOWlXVTl4MlY0?=
 =?utf-8?B?Zi9pSFhTVStsYjk0WGVZTVA4MDZuR2VkZkVYbEt1S3oxdjd4M0lRZkNkQXQ5?=
 =?utf-8?B?Yy9NTk13VlhEUzFHbkdOTm0rcTZvRkZDK3luRFpsSXBnS2V5cFZEd0ZYR1hX?=
 =?utf-8?B?NENqdXlBTnJBcDRmbXV3NXdqZ0lld3hxTnBkdnRsUnZmTUtpc1d5a21yUEdq?=
 =?utf-8?B?NnBJWkUwUjNWMk04bGlLS3hoZjNBTEIwOGx5amMxR0RtbGE2TXd0bGNMRUFS?=
 =?utf-8?B?amRIaE93RCtCb2JRWmd4QzZ6Sm5GV3orZHhUWDVBbmhGZUp5WTArb3JvR0sx?=
 =?utf-8?B?VUVPNDRLc1NQcWxOQUVBNnZpL2RaZzJaVGt3aENzWkdVLy9SV0xnVzZJcHNv?=
 =?utf-8?B?QS9OL1cvYmZaTnJZNHNHSDdqeEdkZ29Xekp6Nm5DN1FlSmJnK2FKZXNqT3FP?=
 =?utf-8?B?ZmZBcUZkYUNhK3VJajQ2WWpkM0hUTXdEWVdkOWo1c0dtOWt0YWQ1V2VheWtm?=
 =?utf-8?Q?xTmhlSjJ7TV8komo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd712672-d792-49fb-e115-08da3dc5a885
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 20:40:37.5918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tHQW9kugfOLBRpPH6d1NeFz6bcWi6CntGwI0cYMuiI/gYV8aLWkzaWjqkG+l7jQovmkP+4W3lPnZZGaFah15iIJ3Hxo6Xep5wGEY5JW67BM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3402
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-24_08:2022-05-23,2022-05-24 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205240101
X-Proofpoint-ORIG-GUID: kRtv350eyTXxGhOQI_7tBcUMOmQU3iF-
X-Proofpoint-GUID: kRtv350eyTXxGhOQI_7tBcUMOmQU3iF-
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/21/22 15:59, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
>>From 9f46c187e2e680ecd9de7983e4d081c3391acc76 Mon Sep 17 00:00:00 2001
> From: Paolo Bonzini <pbonzini@redhat.com>
> Date: Fri, 20 May 2022 13:48:11 -0400
> Subject: [PATCH] KVM: x86/mmu: fix NULL pointer dereference on guest INVPCID
> 

I don't think 5.4 or earlier need this patch as (AFAICT) the bug was
introduced by:

commit 5efac0741ce238e0844d3f7af00198f81e84926a
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon Mar 23 20:42:57 2020 -0400

    KVM: x86: introduce kvm_mmu_invalidate_gva

which was merged in v5.8 and has not been backported to v5.4.y or any
earlier stable branch.

The reproducer does not crash on latest v5.4.y, which agrees with the above.


Vegard
