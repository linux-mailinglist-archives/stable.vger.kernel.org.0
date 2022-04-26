Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68EB75106D0
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 20:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351246AbiDZS2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 14:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351261AbiDZS2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 14:28:50 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357F917E02;
        Tue, 26 Apr 2022 11:25:39 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QFoIpg018591;
        Tue, 26 Apr 2022 18:25:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=As+g0AX46wz26K5RQ2155T5vra/9VECbGS/3F+i4sEg=;
 b=e29A0Fwonx/nL7aDmSzq/L+l0uDmDRxLUFq4aYXsdmIs4YuayHkEtXaIUKf4TdICwB4j
 F2yDrB/6njYcSex3roE+l/bDoBLwauW0oSDMx/0m+tXYBjY2dhzxHtGGsm0SJyTl8AgJ
 nCRUjSeGNOTXD4ZHy03IUaZ7wXc3g4fbF/uVrikR4T5qRUZpTRH6LNezNMYD+HNO0XGm
 yNsnxd/Wn0+ohF12/vBfbS/9dR0JcFGF31zxMn7WTeRwvV7t4WCky7UUgzTM81mXftfc
 hLilVeFqdJxg/1ljmhbFtY4yDSCmT6dZy/9F7dBTyysVMOhriC8dK2G4EPr+hoXp+8uH 8g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb5jy0wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 18:25:07 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23QIAWmk008147;
        Tue, 26 Apr 2022 18:25:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5yjt0q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 18:25:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrCAoxpoVr/waKHnZKEBaDWnEVoX3OKxy4GtKtFbVjXoX1wM1g2s1yUgcoTn/0A8xJAARSMdevWa+2Qlgk3PBicnOjNmeNILn3IB/Rr1yLK2DH6dLnK39A/B1G401WrVJUbmEo4EMVY0nIQh1k3yeay0e3RVfL6+a4+DK7CskEfAQfFzm93LpyjmljDTQBuHvgAs/ICrew0qL6GkLFCgSd7zEI2fyy1MznNYJo5whj7cnaxD79lRDUpIlOCbghXnCDSD/1WiSw9G8tHSuoMt/PMmQuHues2KNEvhmqn5w5SGzzbwH3zJfiwH8BfGwjFmr9kOXy4h+qUjiGUs/0NsuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=As+g0AX46wz26K5RQ2155T5vra/9VECbGS/3F+i4sEg=;
 b=LWDUbRuCsN+JHc6BuF44nEJ7+IXbkyL1EYVmsSNBqfolztMVx9eiR3Eau5zCSgBUFqp6qadeFF+h5gbXlzGkAsz6Ku9RVgjg80xHEp1+jJUDtIktNC1lzTiQhvmIl9rr/WForVMWf0IdyD1yLIMP20WvT5+Zwbm1yj5SYsMUBKN8OJjEaOmSmjudMi3Ntu/XWKVsYtNre1sJwu5sEV9lsgqiVLM5naZiQ7lWRUY5UdIpbLLNpciuE/oNvXyOzczFbWAVJD2+te/WzlgOFq8DnyBxqy0eWlQBJUQPFu2Dgh3VUHEOxlgafzK1q+K8/vTnWfbVkfyQHO/Dm8Iu7vWeBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=As+g0AX46wz26K5RQ2155T5vra/9VECbGS/3F+i4sEg=;
 b=Bx5hYZ76W2FyLZ0D+Hm3J/WM7wOgRIvy1OyxRUVxww5BVd7cX7/gL6L67MHimvYWTvSKkCV4+lWThe7R+dgrknhL0TRYhNq4qPbG/r1XV6eTnjiJ6Kk5fgIKwfALBXrrsn1jBzaLUIkMSIEzHVKez3Gu+W0IeWFeF/FS4B65V64=
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by CY4PR10MB1655.namprd10.prod.outlook.com (2603:10b6:910:7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Tue, 26 Apr
 2022 18:25:04 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::4427:92a2:50a5:50b6]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::4427:92a2:50a5:50b6%7]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 18:25:04 +0000
Message-ID: <e1eb47ea-7327-7565-3a8f-3d9cf4ee904c@oracle.com>
Date:   Tue, 26 Apr 2022 12:24:24 -0500
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
From:   John Donnelly <John.p.donnelly@oracle.com>
In-Reply-To: <Ymgxd6WGhUBuntkS@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB6PR0202CA0044.eurprd02.prod.outlook.com
 (2603:10a6:4:a5::30) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2f41559-3058-4f2d-81b3-08da27b21568
X-MS-TrafficTypeDiagnostic: CY4PR10MB1655:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1655146C100C14D201A0AD29C7FB9@CY4PR10MB1655.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5zZERZ73WuSzRXuhKrGQSkU5Qkc104jGn0QyTf7qv3Lg0ZZ/zlVs7SN9UMxGm6N5tt3frzxS4fV3UeE/6lXVgZpOVrRh02SLKoKQjzx3RV3cXw9Lmw6XT8XqsiCRtXUOR/fqPMKlKGGA3gGXLTvH1NKB5fqjUTZ4p9cFUau+yb67uVFrxoTxlHq5lz1fdhvKlebKn8+eOJ1vrokf7ZRutI5ePTvD7K+eqmePO/mmgDxk8SNr/IgHW8uRBCI9vIuPWn1CKJCGb9dUBaqIPGl1ThiGZYDQGk5M7i1whe7FwTkw5nYoYgm+Oq6eG8oXAisrUvPF3xeJATEbVmqDllpYkZJpXIF2CJ6op99bqDw6z4qHjy3fMC+CJz44zsJ+v8aKQRizKjrCrL/4Dc4HTPd97O6xupYoXl2vSyryonE54eLcwNqNjs1S5cyk1FRsHHfJPKs64xPQfCd2kWZy0BYRvGl2CnUm6q4T5TGT1JjnTfEaTkAWaaQCOhvzIUp3BRXhApJfp527jlwClT9hRB9pQwj3cV7CtXO8JTZYA8VhmeNSKhXrAl74bJWziaMFAABpKFNUVN0bR69cEUi/+L5/v2tMQsMf7C1AvWBx4FhV4gyo4wMiv5klzPOgxlHHnD2cRquXDsUk6yKM61y+KVqBn9C+32Ql1Lylnr6+Gl2i1HF4XkT3Sr4WmU6kwN+6ZXY+ttjaLVPT3yzMQC1dTycAcoAlpG6Y7VGmYzlXQW3rqtKgnM58e6mAtXvGloDqeKPu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(38100700002)(26005)(6512007)(6666004)(5660300002)(66556008)(66946007)(66476007)(53546011)(2906002)(8936002)(7416002)(83380400001)(4744005)(8676002)(4326008)(31686004)(36756003)(6486002)(508600001)(31696002)(86362001)(2616005)(316002)(186003)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2xVNm95dUU2dnE5dm5ybC9OOGRvbXoxb2FyYlloUUNmNms3M3JLZThvb0Yy?=
 =?utf-8?B?VFpTYkJKZEJDdlRRQWg5dnNvU2FmWmUvVTcyWWVNTXFnd0wvRlRBMWh2MWpP?=
 =?utf-8?B?bFB1M0I3RmFaRGZzL1hJbXN3ZjU3UEErZ3R6ajhSMmc0aTZGTGlrRmhZR3Z1?=
 =?utf-8?B?U3hYbFp5K0p1YklNdktkMkNSTlZNN3dJK1g5dHhsN1l6aGFnK3lVMUhxdEhp?=
 =?utf-8?B?eHRobTJrWG1hS1JhbWR1cVM2bFpVditvQVJEY1k4OFJhRmp2SlpRUWtWUzIw?=
 =?utf-8?B?czlOdXpBQVVpU3lES0JJWXFDdGRjYmJKY2hYZW9sMG02KzA5VmV1aGhsdUxq?=
 =?utf-8?B?M1I1eFNydnZtNTdFWWwrcVRaaEhFOXZUL2grQS8rRXpYSTFTVXdrMVZJUWI0?=
 =?utf-8?B?alQxaEZldTBNTU0vdWZ6T1hnWmpZUkd5U3ZtaGFYb3cwQ1N0aWVRZ1JBK2Ir?=
 =?utf-8?B?L1FVVVp2dCtjUE5rYmRlWkxCYTVkVCtJcEYvUGhPNExmeStVbFNEMVFoN0Vi?=
 =?utf-8?B?OGtsakh5dUppSHlmb3JEd1Z5YU1tUmoxREhJMzBMc3JSQ3RlQVlUTDVMMTRK?=
 =?utf-8?B?WXB1UDVveCttTGpaQktGbEhNQ0NnQlBsRXRub1pTVG9CQ0k2eDNtWGlGdWk2?=
 =?utf-8?B?cjlZUUhTUkhmTVJBL0dvL2VJMkNaOEdLL2tadWk2dEZEL2xmSnlKTjY2VGlm?=
 =?utf-8?B?WldTT1JEbjhGVXFlcmVpcGpscnJnT1ZQRHAxd080MzlTSmhEN3hGbWhFd0Ni?=
 =?utf-8?B?bitleHV0ZmRyQ2JhMzBRdVRmNU1XY0Z3WHVLdEM4azV5N0Nsc2YzTVV4WVlB?=
 =?utf-8?B?clFIY2pxdVc3Rld3YTBoeVlZU0tGZW5LU2RtaWpnajBPODRiTGRuMXlYc3NX?=
 =?utf-8?B?RTIxK2dNNWRrVTY3c1BOaDVvcnBoNGhOcTJOVlVFN2hsMVZWVVpaMnorcVZG?=
 =?utf-8?B?aVRQK1R3azNLcEtpNUlMWTdFc0pNZEZ3WXNQOVdQUE5RNm1tNnpMR0ZzdDBC?=
 =?utf-8?B?Nnh0QlpnTUpZMldXcUJOMUc0ZHdCb2tKRGRWRXBrMTNsS2xhREVKdVArdWNS?=
 =?utf-8?B?dmZsZkRPZnhIVGdnR2liOEhQVTduVWVYMU9wSGVwUzZJeUkvTHR3TGNiZUZu?=
 =?utf-8?B?Tkw1ZjZrWEZTV3dIeHIxaUphTVNxMGtFUW5YNDU1NFNTNHhwSVhQeUdvOWZh?=
 =?utf-8?B?aVN1WnV2YkVrdG44ekN5VSs2ZkRGUGllT1dpMjVEdS9ReDAyaVljVHVQMnk5?=
 =?utf-8?B?aFQ1a1NkaFQ4dlNGbXRsRGhPMkVlNDdHMW1ONmRhWVJqeFNLVGhzVjhDc1Bl?=
 =?utf-8?B?ZWdkbmNuSkdYRXNxMEtuZUpTN1hmSm84ZUFPSWdnK3FqYjRyZVlpb1NMdWdS?=
 =?utf-8?B?cDNSS3BpVU40Mk1tMzlwTzlKVXNRS0RIMmRNNHlpbFJUV2JaTUlrSmJab2Nn?=
 =?utf-8?B?Uk05VDAzUmJLbXZFQkV5ZEZzL0ZSamhnTWJTYUplKzZ3N3hDZ2FCTkhXSU95?=
 =?utf-8?B?UWF3cUgvbXkzTFJSU2ErMlMrUnluMDQrQzZ0M2tzajc5aWpzSDBMd24rNjIz?=
 =?utf-8?B?ZFBGZ1IrdVJDd2dHSS9rRjNxQ2FkTUEzWEd4S21Nd0Y3WGNqTGNVMGFZOTZ3?=
 =?utf-8?B?ekNxck9sd0hhVkQwL1VWODFzMjhNMFJRbTBPL2l0LzhYbWg3aFIvdXhyMlpn?=
 =?utf-8?B?R2x2amtrem1FUUsrbnhpc09xWDFZazEwajlyQ2IwN2VWZEswOWVEMytWaGdO?=
 =?utf-8?B?eklHSUkxWnNKcitNVUlVa2FzaDZIN3cwS0ZLa2E3VTJHSHNzRUtBM01IYXE2?=
 =?utf-8?B?dTE0WU9hOFk2VHNtbDI3SXoyUDVhN04wS1dPcnp0eU9Xam9LRERvWmdZRkdS?=
 =?utf-8?B?RkYyNEtZcFNja0g1eHpRTHZ2azAxY0FObkN2SFhScmQwL2pWelBYWGZ2THhv?=
 =?utf-8?B?UXZxUlBVYmp2bXovVXRqaU5NQVhsOEIybjRjRGhlRkJLV21yYWxaSGVTQjRU?=
 =?utf-8?B?NnhacTI5aVp2Qk9VaVVCMHMzamcrVUtVTTIvUEF1QXdUeDAwbS9pU0JSTlBv?=
 =?utf-8?B?bit1VDEvc3UvYjhhaThIbkdHdmRocXBJVlpyNHFQem9DdUo3MUM2K2FlNnRO?=
 =?utf-8?B?cmozZTB2V1JDRGcrK2J6RURmZU9iNTJJMUc1UmE4ck1uZHBwUjF2VW5GUHNK?=
 =?utf-8?B?SjV6RUQrZytIUG0rMWtibTRvbkFpMkxMMVRHL2FHd1ZlZkxndllTblVBMkM0?=
 =?utf-8?B?MHpuYVh2NVZWRUVHdmRUTFZJZ1ZjMzEzQTNDam5ObXRmS09qNHJGQ0VPbmZS?=
 =?utf-8?B?UHZoYWJ2YVZDZHBCOEJDcjNwclZXVnhVNGJyamUrZnAzSCtoL3MvZHRqaUZ4?=
 =?utf-8?Q?n3BRSAPgFMk7p8uQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2f41559-3058-4f2d-81b3-08da27b21568
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 18:25:04.5678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IqqVkSh2AZD8npyvJwTuLuasJiDLt2p/KNH8hFkcD82Mh1n/R2qJkn5CyJ15AzSLdhMcYU58raaxfbrgYX7cAJOBvEnSdRvbb9BSw6u0gmQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1655
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-26_05:2022-04-26,2022-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204260116
X-Proofpoint-GUID: tOlujTw5kG7nAeicLnHt-ae4yrlstRGo
X-Proofpoint-ORIG-GUID: tOlujTw5kG7nAeicLnHt-ae4yrlstRGo
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/22 12:52 PM, Greg Kroah-Hartman wrote:
> On Tue, Apr 26, 2022 at 12:37:21PM -0500, john.p.donnelly@oracle.com wrote:
>> 76723ed1fb89 2021-12-01 | locking/rwsem: Make handoff bit handling more
>> consistent
>>
>> In Linux 5.15.y.
> 
> That commit is in 5.15.6, released December 1, 2021.  And this just now
> shows up?  How is this related to 5.15.36-rc1?

Hi,

This  was briefly discussed in :

Re: [PATCH v5] locking/rwsem: Make handoff bit handling more consistent

Additional testing shows the rwsem hang still exists.  It takes a 24hr 
fio soak test to show up.

It likely still exists in Linux 5.18.y too. We will be testing that in 
the future as time permits.

> 
> Please start a new thread with the authors/reviewers of that commit and
> we will be glad to discuss it.
> 
> thanks,
> 
> greg k-h

Will do.

Thx
