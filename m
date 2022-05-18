Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBF352B405
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 09:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbiERHtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 03:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbiERHtt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 03:49:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20515122B48;
        Wed, 18 May 2022 00:49:48 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24I7GE81019081;
        Wed, 18 May 2022 07:49:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=EPT20kwHOyJNBJW0yLfUBF5bfM4++HNs9/Ysd4NKhDA=;
 b=Ji9pwEgJO4+C7no6DScGI+VQqB6Ptz3IlBVjDJViU3Egk+jcXjkEcqJpHKFboGp11ceV
 9ViJnPOG0GEUKTL7vPqA6xiagPU5/1G7DIcoTEDHu3+Vg93ID1NeF8MmnBQr31xJBcl9
 GsxZI93EcetsJQhcGYIS8QuSOepWAHY/fyiH9dp1J5oubNIe1uzoCqie9aLmAJTXjG9T
 +PTgP93JW42AakeOHKwKuCGd/SCfSkhHtWyS7ZPfZKwCKkqGj1kpGnTfgARh6sL98OEs
 1Mfmt0So/ifxvfmqcEw3Tu6gLo629pZyJv2UZLGGLK5XN6gaInbi8eukG20OjJqrr48/ 7w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g23720jx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 07:49:41 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I7fhXV026584;
        Wed, 18 May 2022 07:49:40 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37cq3r67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 07:49:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZ0hP6ela8VHxq4z0h27JT5wzcEQqSr9OB7zgP+bqwR5QQhX/79AF2de60eKH2Mjheu2srINd96YVqvBj+AAvIS5VkGPg1RFI09fdSZiPSi0U9IvMB3qHvBv7zgIuUz8OtUjHFlYhJemk4+AjK1Y7Y7SJqMi9kmYqmi7pSUYfEfKbq3kPpI6fwKJ6rrNuTa2VvCG+T7WU58A3QFtlfnvQ6xhQtXjujM+1pl7QrT2FnCNAfyr9aEVqVJux39zA/NEngtegafmNxbqdtQwZ6jm5w/msKLJbz+oyycO+EfwlAKDe8WcftNvZSUDtm7wAHuVNVqtm58FHol91mBzghyDvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EPT20kwHOyJNBJW0yLfUBF5bfM4++HNs9/Ysd4NKhDA=;
 b=NLktqoKcL+3X3+rk2pUpPA4MhB9yzVcjsQHBFtqlU1W1HQLtpe0pFG2Ucrby9lrEMmBsU5QnKrofDfQ1xdTeI5RxZPQSF/jiLxzXA2msHtakDpoxwZBvHF9X53krRZtfmyEMD3N9ksSgkfwtcwGRmOzxdJmOtajjZOsUsm2vRsuSkhn/Jc1+sA2Iho1qI1iZicWZI6bLlyYZXd0aM54dh9+CbHTfkGpMuzh/Kftnz29FLBENazmE8ApHC4R/6FYJ4CQ+ExLA54mYSkcjJRV+4vq7EzKyeH8AtkJf2U34moY6RgOErfYJbuHEfbzMz+5XGWL8WcgLipgVY1FsHRj8VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPT20kwHOyJNBJW0yLfUBF5bfM4++HNs9/Ysd4NKhDA=;
 b=O3ur2vWj7oUciftYqbkAZ9LuQkcaGNdskr56qNlpx9iPiY7vboSHl3V3z48dEn2FKzhe5bU6FT7G+g6vjF7a4BnPV4v79jybxAX/wrnMa/qq6ToRHXyyHiHMf3dHpeKIV+hUfSLznOgLu61LkwWAblqYWOeB+pnKX/xDAOq8Ldo=
Received: from SJ0PR10MB4638.namprd10.prod.outlook.com (2603:10b6:a03:2d8::18)
 by DM6PR10MB3913.namprd10.prod.outlook.com (2603:10b6:5:1f7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 07:49:39 +0000
Received: from SJ0PR10MB4638.namprd10.prod.outlook.com
 ([fe80::2162:a766:29eb:1d5c]) by SJ0PR10MB4638.namprd10.prod.outlook.com
 ([fe80::2162:a766:29eb:1d5c%7]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 07:49:38 +0000
Message-ID: <855d90d7-70a2-da82-d62c-e8c030411852@oracle.com>
Date:   Wed, 18 May 2022 11:49:27 +0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] staging: r8188eu: prevent ->Ssid overflow in
 rtw_wx_set_scan()
Content-Language: en-US
To:     Larry.Finger@lwfinger.net
Cc:     phil@philpotter.co.uk, gregkh@linuxfoundation.org,
        dan.carpenter@oracle.com, straube.linux@gmail.com,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, stable <stable@vger.kernel.org>
References: <YEHymwsnHewzoam7@mwanda>
 <20220518070052.108287-1-denis.e.efremov@oracle.com>
From:   Denis Efremov <denis.e.efremov@oracle.com>
In-Reply-To: <20220518070052.108287-1-denis.e.efremov@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DXXP273CA0020.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:2::32) To SJ0PR10MB4638.namprd10.prod.outlook.com
 (2603:10b6:a03:2d8::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5507b79-8814-42eb-4b0d-08da38a2f5b4
X-MS-TrafficTypeDiagnostic: DM6PR10MB3913:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3913E5B78958D3A173AF941DD3D19@DM6PR10MB3913.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Roy5mKlp95XhcoDsA1e3V3g+p/9r2ERX52G8Agm8mxcv6AXbRBOFbApvLQuZ+z3ltfOnT7MMq0yig0nGInom700LHtQuzcQAk1+fOZxbxt/LvMrk4Kie6Y5H2AYwuy/+jOVuGNxoOrJNcxbzCiy9Whm18F7ozshc3NYnbrq097+iGvRYnlulYJvecn3nqPC7mT9Erx020F37JAhQw05EPAWKbL+U3cblxuwBThSMec6Hqx0JF+PXrDt58SmuZEmK6TvywH5V+bpMrBN9BB+MnWoAU/LkWNoEQaj3ki7839PQozWKfUnW0zM0ZkeNBXr5eJbuyUaF08sr92bxDLjlcmfJBFScbjhyzYI9GJ1TybsTxV+Go0kvRW6suWqjB7SabWNTvwhx71g8uEC7l6PYJoQRTbfwdF2qOX7cBqdDd+Xsqw4ZwU9z+cIGckAupZMEd12gQFM7/M+ieStUzyZhAtrz7sqRm3iEm6xRRpQ5uHiI3I2KZZ9HXz3PabU8+LhRBsDhCbWtOM25BMzQ6XJFbQOdeNZMiD1gq+WoiwewfSHdsw1Zld9CiIyCIHlMedTnMf83P63/E16I/Fb4pXNc4bDw29L/YSWMbRbdFngs5utAU3TAQnnYFNRBCWNbfJrRolwMWpetuu0hhujTrx4lrcDVXEPnBx+SNgdNRNQgqiSHAuH466OoL2XOdXvMImaDbo6z5HX253qMwaBxwh/5J8DOQtxsUG8s2HCuMS45A40vwtIWkrJC1eYYqla8s9W5wrfmJPaMb2+bUuN0hE+jqJheqmS5M2QF4ga1dqLIGDkd6bBM3vvjYm7OcoDFpLXX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4638.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(83380400001)(6916009)(53546011)(2906002)(6506007)(2616005)(36756003)(26005)(6512007)(508600001)(31686004)(66946007)(66556008)(31696002)(86362001)(5660300002)(6666004)(66476007)(186003)(966005)(4326008)(38100700002)(8936002)(6486002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q21qdWNkSkNaNVR4SFRxcXV6eHZFVGN4SEFQRUwvYjVqMTJ4dUVldjluTEcw?=
 =?utf-8?B?U3RNT0Z0VmNCWExueFc2RXJyd3lUQVllUExXSlBuUkdWbStSbzNQTzd3YkRi?=
 =?utf-8?B?ZzJWeG91cnlyRlgybTNPMitvNlJvcXczenB4aGtsMEl1b3hLR3ZLNEdPMlBS?=
 =?utf-8?B?UUpRTzlmTXZ5VTg4c0dvZ3NJRzJjWXViclI1bTR1UWNQS3J1WHdMdDBGUnlU?=
 =?utf-8?B?RTVWMk1TdWQ5NGxianBHcEVZZUx5bzVDeWdTY1h6YWpQaFBLNFVkMFBDTnpT?=
 =?utf-8?B?ODZUWVp0emVXVy9BelNQL3kxeTgycTdmWmF2WDMySEk1YThBOVlQdU1WVE9S?=
 =?utf-8?B?NXdoL2t1ajV6Nnc5R2dNNkd4Qzl0OVBaMG9QWWZBcTdzaEY2aHljc1MyNlBs?=
 =?utf-8?B?L1ZhV0dlbnVDcVFpMTcvT2pJZStjN0NTU3ZEdEFPazljcXlMWkxxWXlUTXV1?=
 =?utf-8?B?K1lkc2tDaXdxMTRGZVlDSHNFNThMYUV2ZGZjRE0xS2VRTFh5OEt1V2taNHFu?=
 =?utf-8?B?aWhFZStvQlh5bjV0c0wxUldsZDZYVTNkcm41bWhJaDZPeHduTHZaRU1Rd3NB?=
 =?utf-8?B?dWtBS0VHblJTVWhhZFEwR0JwNTFSQnlrRFdsSEYwTnlBc1Jib09uZThWaFNI?=
 =?utf-8?B?cDhabWVsTlY3OTMvc2tBV0xKUFNzOTBXSWVOM25NSE1SLytraEp4d1Q3RFU0?=
 =?utf-8?B?QmI3enVXeGtuMFl3Zzk2dVNzV285WnUyZ3pYbUt3S3JvbkkxVXV6SUx1SDhV?=
 =?utf-8?B?QnQwa0o5NmlQenpKYUJyQ3dkc0d3K2JaK0RQaGhiL1Z6Z3RQOGZ0dkNyUk15?=
 =?utf-8?B?bDFkaEVJdS8vdXRFV0NvbHlEVzFqenUyWkJIbkpSNlVBcjdVbjVJcDBlajhy?=
 =?utf-8?B?UEdrRVQwd1I1VDVNOWovQ01uNCtzbjlwZFpSTFJ5Nks2VFFTaWphNDdsczM4?=
 =?utf-8?B?SGZIemxLZks3dHNOZGpkY28rMlFxNW9QaXovSm5kZURQeEhrUkcreDJwTVBo?=
 =?utf-8?B?ZlE3ZVFQeEpJL0haQlJKRmFvMXlPbFZNSlZBa3Z2d3ozc05IT1V3ODNhWnpX?=
 =?utf-8?B?aVF6RVp4dkl1V1ZBL3RnRXRSeWxBS1lsY2pWSXlsTUZ3K29UUHVNU2N5RFdS?=
 =?utf-8?B?aTZTdjdLRllWRmNoUSt6ZDdGaHJrN3hOT2pKUmtGWmNreHhyQkEyOFNaeG5F?=
 =?utf-8?B?MlVPNEx4aTdUcUY3ZDk1aGllZ3NmOFBYc3doSXRMV1Q3WFltSDYyRlpBU2t2?=
 =?utf-8?B?MUJWUEdIa3BOMm45T3o1NlpRRk9jcUxsL3hwbWVkdzMwZlZUSEYySDhEM3Bu?=
 =?utf-8?B?aW1Bc05PUDZONFUySmpLNjRnY2J1QzEyenJRaktocXRUVUs4WXNRd3NEdjhP?=
 =?utf-8?B?Q21FT2Q5UXRrT3BUMzhQNEs5enhsMVVIMHRZM21hbW05c3lEejVJd1d2bHhw?=
 =?utf-8?B?N1J3MFlkR2ZnMEJjVzdhb3pFU0pNVVJVNmdhbDdKeU01UlZ1dncwMU85bW9v?=
 =?utf-8?B?VGV6RXQxYWhSSXhJMC9iUklTZm5JNVowQWIxbGU4UW9UUFRmSmdIOHB1aVZ3?=
 =?utf-8?B?NklwK0oybThmYXAvQnE1eDRuN1hIUDQvTkRFNFlXYVdQUHFGbWgrdlhPSTdT?=
 =?utf-8?B?THBsbit3MkZRQnViUUowTFdWNEZMc21mY2NqT01kMnVhOGozZytQY2RqRGdx?=
 =?utf-8?B?NWdCUzkreXdXOXU5RTVaMDI1K1dlaDFoQXpYemUzMzhnVmtzZzAxTUU5SXpU?=
 =?utf-8?B?bFJRWk9Kam5LbDQ1ZDFDaW9OMVJwZ3hmTy9QU3pPZ2JNVHdKYlRJYXE0a3RQ?=
 =?utf-8?B?ZDQvZEhHTWVNbHh1cVViMTVZcGtsUy9NOGJ2M3lFWjRtSXVMeDYyRW9IMWxy?=
 =?utf-8?B?YWVYZ2pnOWF1NVY3SU1nYUtUT0hRYUp3NnBzUVV5V2p6dU12RUF6NEF0NE9H?=
 =?utf-8?B?VmpMdkNrcVdVVW1NRWw5ZXNGL3ZUQktybm1vb0hwaWhTeVpyREh1QlFSVnl4?=
 =?utf-8?B?N2Z0WVE4b0lrS0poeTFHL3BsRkpndWxuNmxacVR4N3hwWTNWbmxGZkp0RFlR?=
 =?utf-8?B?S3QvVUVmdlB4MGxUQnJDcDU3TzUra1NRZ1drRUFsSm5QeHlkcndLZi9jZU5H?=
 =?utf-8?B?RFVDVmR3ZDFNNklRdmx6WFZWMmlYaktwMDFYMDhWcmllU3ZkN3N1Ym5YTDJH?=
 =?utf-8?B?Mk1VTXdlMlRQalRyNWZaWTJLTUN0MTdMNkJoZkdxZE4xQWJHUjBHTlJYbzhJ?=
 =?utf-8?B?SEhOQk9rd3AvODdyMnBGL0JSdHYra2xTaStBZ2JwRkxaMWVNdFNYV25PWXFH?=
 =?utf-8?B?WXpxaG1sQ2pXQ3JNYUV5OG9WVHJsVElNTStyR090dkRpT2ZaajdiREFZUXBP?=
 =?utf-8?Q?osVyMWxiUbzlRQIM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5507b79-8814-42eb-4b0d-08da38a2f5b4
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4638.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 07:49:38.8357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gXpj/9IO1snFI53SrYbsq8nIxVkQJwKWQ4bEAo02H2EmuTa9l2ZO9fXAFAU3evscXVXkPQ2uogQfgikrL9nqsRAqukaW55YuvZieiLzGjHQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3913
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_02:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205180038
X-Proofpoint-GUID: UT7QzZDG6q0t-bxvw4_c--cc-KyqgkUs
X-Proofpoint-ORIG-GUID: UT7QzZDG6q0t-bxvw4_c--cc-KyqgkUs
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/18/22 11:00, Denis Efremov wrote:
> This code has a check to prevent read overflow but it needs another
> check to prevent writing beyond the end of the ->Ssid[] array.
> 
> Fixes: 2b42bd58b321 ("staging: r8188eu: introduce new os_dep dir for RTL8188eu driver")
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Denis Efremov <denis.e.efremov@oracle.com>
> ---
> 
> This patch is a copy of Dan's 74b6b20df8cf (CVE-2021-28660).
> Drivers r8188eu and rtl8188eu share the same code.

I also found same code pattern in rtl8723bs driver in
stable kernels 5.10, 5.4, 4.19, 4.14.
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c?h=linux-5.10.y#n1354
I can send the same fix to stable trees if appropriate.

> 
>  drivers/staging/r8188eu/os_dep/ioctl_linux.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/r8188eu/os_dep/ioctl_linux.c b/drivers/staging/r8188eu/os_dep/ioctl_linux.c
> index eb9375b0c660..a2692ce02bc2 100644
> --- a/drivers/staging/r8188eu/os_dep/ioctl_linux.c
> +++ b/drivers/staging/r8188eu/os_dep/ioctl_linux.c
> @@ -1131,9 +1131,11 @@ static int rtw_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
>  						break;
>  					}
>  					sec_len = *(pos++); len -= 1;
> -					if (sec_len > 0 && sec_len <= len) {
> +					if (sec_len > 0 &&
> +					    sec_len <= len &&
> +					    sec_len <= 32) {
>  						ssid[ssid_index].SsidLength = sec_len;
> -						memcpy(ssid[ssid_index].Ssid, pos, ssid[ssid_index].SsidLength);
> +						memcpy(ssid[ssid_index].Ssid, pos, sec_len);
>  						ssid_index++;
>  					}
>  					pos += sec_len;
