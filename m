Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693545107B8
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 20:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbiDZS7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 14:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiDZS7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 14:59:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61FD17FBFA;
        Tue, 26 Apr 2022 11:56:04 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QIYYWP011396;
        Tue, 26 Apr 2022 18:55:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=WKhLwC/rRi3Q3GewUFP0tbo+U5z0+d/iXUNIjMUKxC8=;
 b=wr/JzCcyLtFIxbfXB6dRL7zYv2e1wXakq7D7RJEaD90mKAjRubmE8iPDz4xoFUoY56N+
 5G8DwMbnSpX75uW2zrPKG9X5InEJMR7E9D44a/UPwgL0yMhP/8D6oUjERSAKpyhogXv1
 8F1AZUCwmAhmO5/G+N3YI72E149As6atF6g7kR9d8uyM4nlgD95ZFsP6v4mBh5R3BPRq
 CmtKQ7PAEjAXDE02UAjMuiePcCU842GULWmbFdmnFZZFTO7kKiRBggHAppXrv6L19kxF
 e1JE+/BJ6DsLRCWk/rMr9wj6QTynT92cL8oI2qKOGrUsCfDMtBzq8TO6dDeG5ZZhXWL+ 6Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmaw4f431-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 18:55:38 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23QIt5No025726;
        Tue, 26 Apr 2022 18:55:38 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w3pdyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 18:55:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Un/htW7frmtBE8zPgUrfaismsuEhHQeoooyRyuXAZlh3Tl9Z4qBg+kNWXa70zpKeK6Tintsi7L0fj4jkTUPiEp7INMrTVBJo1/uR3sD86Vx9TgyeOQho9lE0/qVhVlksTIS17cZ6w22jiSaUlhkoPgI0eGLrqK6E8HIHMuulqSKUNaY+ilv08pPzNjzr6SaPbNfcdP98j8xEktZ6XdVEEmfR7AFkUsS+aLN5u6+QYEYxNQ8yHnCF4T/nfCfJ/+hn8D0HOceSe+ajc7qZgf5f/bVsN9B+Dn3c6qPMY5KF92h4YerE1yHEt1exG+8xe7Tfnk4w5nhUWRtpz6PfR1VY3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WKhLwC/rRi3Q3GewUFP0tbo+U5z0+d/iXUNIjMUKxC8=;
 b=d1FI+ZFxwCcPcg9JGC/q2hrPCSEw3pDdzsQaRt4q2UiC5LUxT3nEOj3B2om+OuKIe+lTCuNpRFy0bmjnEgNQ87btC+S3Fl7MQ2FoHmIcflFSK7sYylRdCJhEY8hbuv3104WXUzVIOFX267p2S9eyjI+gvXIQa5JdK7Y7xM0965jv/VIOJ6OKBuORRmKtEKeRNXYVSp6pxQaa4HBhGhGTv9+9C4fXW3WMew3W1ZRLyHoeXlpNCHujfyQK4+/20BmGkuU19OmwSMS/ekF5zQdFk6bzBZsNDkT6fX7EnhmI3F45rsIYJwjCTn7SEGztDiO69URKwk79v4QrGPPX4a4GCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKhLwC/rRi3Q3GewUFP0tbo+U5z0+d/iXUNIjMUKxC8=;
 b=i/NGOSFyWVdzk8SVLgnLynjzqMyiZnZplCKM0585Dc/fBcGX10AXcsFpt9h7W+u9Ughav54WoOlqdyBHCSr2P4466RfElAwVrM4irPyaaM1uPUy4Zjt2QnjLTTj9hCEZ7nWe+W8zvKB4Ooe4bf1L257B6L8myNtwBShyXzqJjck=
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by CY4PR10MB1909.namprd10.prod.outlook.com (2603:10b6:903:11f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Tue, 26 Apr
 2022 18:55:36 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::4427:92a2:50a5:50b6]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::4427:92a2:50a5:50b6%7]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 18:55:36 +0000
Message-ID: <006692da-5923-824d-d7bc-423e5cd980ef@oracle.com>
Date:   Tue, 26 Apr 2022 13:55:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 5.15 000/124] 5.15.36-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Waiman Long <longman@redhat.com>
References: <20220426081747.286685339@linuxfoundation.org>
 <09eb98b8-6200-20c2-faa2-ced7f0e4fc95@oracle.com>
 <Ymgxd6WGhUBuntkS@kroah.com>
 <e1eb47ea-7327-7565-3a8f-3d9cf4ee904c@oracle.com>
 <Ymg8MSKq93nSS1rq@kroah.com>
From:   John Donnelly <john.p.donnelly@oracle.com>
In-Reply-To: <Ymg8MSKq93nSS1rq@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB6PR07CA0069.eurprd07.prod.outlook.com
 (2603:10a6:6:2a::31) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0cc50ee9-6442-4fdb-dcef-08da27b658fa
X-MS-TrafficTypeDiagnostic: CY4PR10MB1909:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB19096863DC6B937AA310274BC7FB9@CY4PR10MB1909.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cy1v1DY0qDyqNKavZCNk9Ve6vgCvuM5ATZ4XTpD8Z2yMv0FYHYOO1TLBgdV7Y+DyszJnjo9llbWqwE/V01/7nC3QZdDZC1VckObrmHLq0CFxbZx1Pg8fHmwwUl/xs50xrgXugr38A4cGCGlCSJB/an+/SKRv2ZaiRciHEHXm1qzSBan1H0ACBChxWe6lUQKqnVF+8Hq2ciNbsDE1mRX6GFPkAZ6c2RuNPBf7EB24wYB+Ao1+IVpOeZenZMJ7NzroFMG3yZwG0YcrJyLFuy6iaRJw4X0qvL+JmjbTVmtWbtCkdeYiGGhM+L0jdn31me5QogzDPMV70Hr2uyRfzMr63SEyrU27WBvEmoExC4o5uo8mF/PJnRkzuSY6+ASHYealPeHyHmRGTBPPt7sYQnCAvB7XAZxN5TRX+sU0G4qyRL7kQlZ0WvRytuasr/NmzJRVY6Vw+Am40Yq3f9z8v0BH8ayutbmuDitZVH2zdMzXedW40AmJTE+SP2SBMFHJMQYRdp8AcSn8riHyCxPQXc1b1o8rCxyqd9Llue5KV465UgjsbMFO4t+MNSRwdmjWDyG+4AfRiWMRJVbgft5rKN21r+gPkGJwsZcy0E+9k/fBK7uQdr4QjVhxPNC8ciqvgwNmJHu+91KYZGl5wZkoRVHb+Sp3TAUHaF0stPNG9/iusJy90bTXaDWU3MuR/dk5Ni4P/QNj3wmpt++Elqrh5Dw9gIvewzwq9fqORmsb/dhDj/3NdRpOwWfudYC8WSYjMr87jAWBTzQ3xK28d9tn3Tn+bG+Y2pA5wwtPCwugMVoZ3McqIeGpI/v3KGyzUsLbKyGo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(4326008)(7416002)(6916009)(83380400001)(316002)(66946007)(8676002)(966005)(31696002)(86362001)(6486002)(2906002)(508600001)(38100700002)(5660300002)(66556008)(66476007)(2616005)(186003)(26005)(53546011)(6506007)(36756003)(6512007)(6666004)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEM4UUdOOUlMRkFSQ1FNaVZMdUNBYjhxc2wyNFlKcDRrQTNLejBuWTMyTmhC?=
 =?utf-8?B?L1YrM2RoaTVHWXFqZXZVNnFNWmhBYjUrNmtkVTBFRUFTWjRKMFhXbW03dm9a?=
 =?utf-8?B?eWR2cy9PNmtlOE9QdUFORXpBSlkzZ3g4THNBSnJKZkVuTVdoZ2FyUnkzV2VQ?=
 =?utf-8?B?Y1RzMlgwTTUxNk9BTWFnMElIaGVhNDVXY2YzdVBHalBOOUoxeVBUWkptT2dj?=
 =?utf-8?B?L2dFUDBJYWR4Rndqbm9sM3NudkZiNC9oRmVQSWQwSCtUaEtpL2ZYOEVjVWE4?=
 =?utf-8?B?ZkRJUHFBVCtnYVhpYVVldUhwVDdud0lGVzROdWRYUCsxMjVQTVBvZVRrcnN4?=
 =?utf-8?B?TzVGak1yNFVOdjhhYWU0SkUvQ29xZVpKbERaZFo2NTRYZFM4UFZ6MldSYlUw?=
 =?utf-8?B?ZDJ6eHprRHZtU2NOamRKMXFMQ0FMVDFsWkFzelFkN2szQStjeC9DSVh1MFJu?=
 =?utf-8?B?Y3RFcFNkR2tTOHpRVW94Z0QrTEZjRThpZGN6djFCUnJkekFteHhGRlJud1p5?=
 =?utf-8?B?a2M4WTRxZmFoSGVwRGg1cDRpTXJiNkZORG1lTFhFVXJKd1VNYnZSdUxiTEZi?=
 =?utf-8?B?RDR1OTR0cjZTMENpcEk3aGVOdFo0RkJmclp6c2lQU0hFVFAvdGhyM3JYY2hK?=
 =?utf-8?B?REh2ZE9RYWNjRHNKN2tNUE1RUmdpL004N1FrSVpKckF6WEdHQ2d6N1o0MmlH?=
 =?utf-8?B?bjVBNVM4Rm5NNjZpQkNLdDM3TFM2TFZhZUsydmx6R0NmZXdXOGhiMnZPeC9x?=
 =?utf-8?B?SEMwbEtUc1VvelhQR1lQeEVRSmg4ZEszWVBxQmEwR2tZNXhpU2xZWUFUQ2pC?=
 =?utf-8?B?dWFBYnRLRUQxT2lVQ2FDRGpMZWxPWVZhS25RZlRRdWdxOGk4THJ0U1ZZaFlP?=
 =?utf-8?B?MVpsYmNQKzBlOXczRjJxb25iWktMTDVLaXdMVWpiVG9XeWE1VXc1SUZ0TmxM?=
 =?utf-8?B?Um5HSXJvWUlZWk5tVkI4ZWNrSUdmbnoyL1JuTllsL2QvNTVKVGhTT3dOcnRx?=
 =?utf-8?B?Q2ZJUjEyekNHL2FnSVYwTVhlQWR6VzVEN2xGN2w5RkVlU1FlbzhnUEFIT3VQ?=
 =?utf-8?B?YVdGTXdMQkpQUHdjTkszRks1NllWU21hWlBTaTIrY0Q5VUxCSWkxWkZYWnRs?=
 =?utf-8?B?ZklpK1NCMytmb1NjVHJWQzNXQi9NRUdyZGc1SlZOUlA4YTd1cEJEdGppUlIz?=
 =?utf-8?B?d3R0Zk1vblI0dzRyVnhoWXpvQ1c3dUtqSzZpZGsxR1RZa015V0REaUxad0dQ?=
 =?utf-8?B?dmkwWmgzK1lveHViYk1leW43MWJTaEdubEc0VERKc2tGbkk2SzFGTkQ1K21m?=
 =?utf-8?B?dEZOTzdESzhxOGdVM2VXbEo0a0RSdFF1bU0zTk43SWpVYm5mMEtkUzVGU2JP?=
 =?utf-8?B?cFNMSGtHdTFMZ0M0TGg0Z2MrWVdCbllvZ1BHQSszbHFGNUZVSGluaEFxUGVa?=
 =?utf-8?B?bGFNNlY0YWRsOHVURkRJYjZaWGVMTWgzc1E3OGMwWFhoR3NlbFlmZFAvWkFM?=
 =?utf-8?B?NU9sNUhuYUZNNkRJbFlTVTJ5UlZlMnZidjVhaVRlU0hWaENYZWJ4MjNpNWN4?=
 =?utf-8?B?NUtWN0hicFZBZUFQSzl5NlhWU0E2cS9XRmIwU3lKb3ZTTDV1cXhxSHFNYmds?=
 =?utf-8?B?ODFHQ0N2c0FEelNFWEpkSWtVL09KOVJkbjNYS3NiU3ByTlR2YVlUT3JINTJM?=
 =?utf-8?B?QXVZaVEweXZNNHR5VEY2V2hYWDBxb1pwQVl3dzBmUTNtUUpvd3pRdTdoeUVY?=
 =?utf-8?B?ZTR2ZGplbnkrYzN6dmt2Z2JVSUdyNUtveDVxZ0F1YmtjSENuZXMrRndhdXFm?=
 =?utf-8?B?NEdYQkVwc2JxZVB0SXlpbFJWOFhVVm55bnRHT2NUSUVvOFZYTWc4Q2dLNHpN?=
 =?utf-8?B?aEdiQlhWc3huOUcza3ZoT0dWRGFZcFdjMUNiRHpTUFkwTTcwdDd1Y0dXd2d6?=
 =?utf-8?B?REJaWHZLRTUwZmh4Rjh3eXVKMENOd1VMaEJFTFNMQWRuRFBMYVpTa3ZwL1hG?=
 =?utf-8?B?T3Jsbm1VbGEzRnR1cit0a29VUlhxa0RNZTcwbHMxa2tzbklPN2x4RFQ1am4v?=
 =?utf-8?B?S3c2ZDdRNCtQMGNmeFVERU1KVWxvN3NzNjRrWFNpSjRFN1NOVnhPT1ZkZGtr?=
 =?utf-8?B?TzFUeWF0a0RkL1JKZEJraUl6ZW50SUNlRnI4WEhiRE9JUEI1OGNtaXJhaFI5?=
 =?utf-8?B?RzNCQmt5M2RRdEZ1Qkd3QlNpZ2dTSnpOUnB6U0hoNzZrdndLcDd0U3NTZk5w?=
 =?utf-8?B?MlFYMkE3MG5CQ0M5TWltRkFHbkNHRVdmbDlJL1NiV0k2ZFhTTVNKaU44b2ZC?=
 =?utf-8?B?N3NFSzBPKzFzTTVjZGJnaHJURHBEUGVVZUxQY2dDMndNU0YvYnNoTDZveCt3?=
 =?utf-8?Q?Hlg/ifXz95XtpVw8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cc50ee9-6442-4fdb-dcef-08da27b658fa
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 18:55:35.9212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: INHnfeVwVX8MvjpC7Md6zGj88B9sp/lVUOl1EKuQgy74T9olpifY5eCT8loc+UtxHdqXPQT8y9Xyti6DSqNRuA+TSTf7uJ0qSrgt9tDdePg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1909
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-26_05:2022-04-26,2022-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204260120
X-Proofpoint-GUID: ryTm0f9QuZQ_dBMcZ5qvNxhCbiEH7qBR
X-Proofpoint-ORIG-GUID: ryTm0f9QuZQ_dBMcZ5qvNxhCbiEH7qBR
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/22 13:38, Greg Kroah-Hartman wrote:
> On Tue, Apr 26, 2022 at 12:24:24PM -0500, John Donnelly wrote:
>> On 4/26/22 12:52 PM, Greg Kroah-Hartman wrote:
>>> On Tue, Apr 26, 2022 at 12:37:21PM -0500, john.p.donnelly@oracle.com wrote:
>>>> 76723ed1fb89 2021-12-01 | locking/rwsem: Make handoff bit handling more
>>>> consistent
>>>>
>>>> In Linux 5.15.y.
>>>
>>> That commit is in 5.15.6, released December 1, 2021.  And this just now
>>> shows up?  How is this related to 5.15.36-rc1?
>>
>> Hi,
>>
>> This  was briefly discussed in :
>>
>> Re: [PATCH v5] locking/rwsem: Make handoff bit handling more consistent
> 
> Have a lore.kernel.org link?  Why not continue it there?


https://lore.kernel.org/all/eae41639-cbca-4ea6-417f-f9b34a7138ea@oracle.com/

I tried and the thread is quiet.

> 
>> Additional testing shows the rwsem hang still exists.  It takes a 24hr fio
>> soak test to show up.
>>
>> It likely still exists in Linux 5.18.y too. We will be testing that in the
>> future as time permits.
> 
> Can you test 5.17.y also as there is no 5.18.y yet :)



We did.    It failed there too . ;-) We happened to have 5.18.rc2 in the 
work queue
> 
> thanks,
> 
> greg k-h

