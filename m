Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99956DF099
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 11:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbjDLJjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 05:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbjDLJiy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 05:38:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D8B6A78;
        Wed, 12 Apr 2023 02:38:46 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33C6UhI6006440;
        Wed, 12 Apr 2023 09:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=ZrYTwMAiaBksRshZPYLzwApR1txk51DgDNKxfxOAhZg=;
 b=Cg/rtc/rEtCssKHcEzPzByljGee4fblAQxNqhF1madmimZ+7uc4FvjqMXCzJTanpfQeo
 SviqxsE9aJJaHMqJIvlsJU/sq9DVgaaWXS5KX8USTBdkNa5gnM6hWFuQVJ2mPKGEjMfg
 Kkzcolio0x1c5HWakRn55L9C27Amc1XBWRvbLZB1UIgmsrZ7eKUtgVRRM55borqQDdig
 cDcmFXPZZCPNiBqeDQBdbuFv24WGD+5eUV2BjgvyuEKJmSpy8ln5NORCo8B6uu9b77ac
 MQ4ZgFzoDAbHj/qTkNkUBmhc/7r8Stztq89ssHuEc5McpvKTtJm9Y1PLs/qmUF8eB4r0 tQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0e7fje9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 09:38:43 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C8QKgc025084;
        Wed, 12 Apr 2023 09:38:43 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwdqdvnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 09:38:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/LAijAs9VeMvAjLt4+TxIHFY2GoIF5FwHDbcrdI1SVlzrSZIXJ6xaZw3D/yp53cTpJGrSXeFPHJZkIVeoca6d682wEzgAB/VBxGsR5LFSC/bquFAXzNy5j7j18G2jN8KMJl/L7ToBdSFpZhfdC/VNhOb31PzmPUjvPQ/1peV40P/iKRosZPUwuPIogdheAVFXjdzViPIJVK7BLgMGf67cxeo+FARCxbg6U0+7FTFlPYmWUXsVsWsLY7jEu3VlYW8+9s7zYTDmKtumivJM4OoRupqweKI3vCrd/2zohVHT/MoaL4AGgzheaaBk4Q0BYH93qbz6/gUkZDZf2ETUMuVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZrYTwMAiaBksRshZPYLzwApR1txk51DgDNKxfxOAhZg=;
 b=hGNJ8zAKJrBlXEbEX4CqPZFlkivzT0ynVRHc5Lw5AI58Ll8GjeBZ8hWjs0TpVJOXX+1sgZHPnKBQ6rvG1+PHW+C/xsI8DWY13eWR6QaQ9wXooEvmpqqUVitGafx/Ky4zXWlmIKPQTVG8iIFr9aNoZF5STZOxgdKhQuhP+eb3BleUdLhDd2WJSUikn1T6IFOPbnxbXUg/kWlqAw4sLMUQdmuSmLdnZeqD1XWWxJuetQSFVWKpNn4Llzt2LLTLoTh8ntb69+/O+yNXgRQtxHgNIHx7MZWJMAXn6/IKLRGLzETSjl58AbjbJrQJqDqUM1TuhPG9jUZriMKAPAczvrqabA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZrYTwMAiaBksRshZPYLzwApR1txk51DgDNKxfxOAhZg=;
 b=CnA0u9P1W88dYvhwQglE3bqbXpfItv5EVLZfb1dV3vqPe60NbdwJ/vM8kHmqbg3dbFL/bEtiVbsWylze8XSON4k5irrImOSBxrBw+Lu8BCv+VuEsi7pQI8sGHWu77POTmKE6cgVYZSyfcRUZ5cV1PCOkznDAGKtajcZU2a1wJ3o=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY5PR10MB5937.namprd10.prod.outlook.com (2603:10b6:930:2e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 09:38:25 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267%6]) with mapi id 15.20.6277.035; Wed, 12 Apr 2023
 09:38:25 +0000
Message-ID: <d7abc010-4d02-c04d-64d5-5fa857b0e690@oracle.com>
Date:   Wed, 12 Apr 2023 10:38:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
To:     Sagar.Biradar@microchip.com, Don.Brace@microchip.com,
        Gilbert.Wu@microchip.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        brking@linux.vnet.ibm.com, stable@vger.kernel.org,
        Tom.White@microchip.com
References: <20230328214124.26419-1-sagar.biradar@microchip.com>
 <3bce4faf-e843-914c-4822-784188e3436e@oracle.com>
 <BYAPR11MB3606BFE903D1BBE56C89D31BFA959@BYAPR11MB3606.namprd11.prod.outlook.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <BYAPR11MB3606BFE903D1BBE56C89D31BFA959@BYAPR11MB3606.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0014.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY5PR10MB5937:EE_
X-MS-Office365-Filtering-Correlation-Id: b13ff688-bf42-4adf-1e41-08db3b39a9fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i+MHu8EnrrUabvGs8iKH7l1mXDxmHmDoKuoIs43coo8waOYGlrVCJcdobliGDyckPchUzBlIpXd+dpWbHbSV3RFj2ks3uIlHTRlWt9bZG0kCNJpMz/3Z+wyK95NO8KjITrC+jOPek6AgQ9HdDaUXocVxJdhgBcOZECy8+KQxbPTyXkU4VCadCJp1+u8/8GlyVEdXWd74DDrIqi4+Qi2bO0+ZNdCWHi9XBV/Gd8l1JWCk7OqKSxYy0xI2sI+WxJT0kAD8GX1F1eOBa5j/su3k2wOkTRTIovgDbW35MkPsAQMlpLsjYvTZIyN6yGzXpDfD+C4OmM2t60/Clf0jPnw8l3Rl7CGSuXN8APkyCpDpADHWYc/QYYixN0yYENjlA2VFY6CRUrpdkXOD0iHjc+SlUIY2jsj/ppl38Bi+/YBfeB0+Y6C3AbJv1I8jYXGzPqssSyGHABdFhH1WjB2mur9+1wzLuS4mkhuSHCFYpt7VX3vhcYuGFgZnHAI84kNnf+Q8x8xqoGmCcl2ecMaIYE3sx8rmGi5wAF/loNE39y/Jw0vmFNqU3OZg76ZI48FqauXMo4wv4d51HqDlzcHbV7PdLUpJzb5x1fTVxQO0V986FbVt36J3eOLj7/pkKnEB2gDH1GUhQwmrztsAMWJqA2iEXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(366004)(136003)(39860400002)(451199021)(478600001)(36916002)(6512007)(26005)(5660300002)(6506007)(186003)(66556008)(6486002)(53546011)(966005)(316002)(2906002)(66946007)(41300700001)(6666004)(8936002)(8676002)(66476007)(38100700002)(31696002)(83380400001)(36756003)(2616005)(86362001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjYwcmYyUGJ1SjhHY0dWc1JJK1B2Ukw1RzJqVDRNMmhoTUIxaXRteDNGd1Zx?=
 =?utf-8?B?eGRDTDl0T0ErVTc5d0lqNjQ4eWJqWThhR2dxNi8yL1FTR2x1bGFpMUhUR0Rj?=
 =?utf-8?B?Y3B5eFJWUTErV0xJcTJocnZYQWZzZWZETlVNOTN1VWRkK1Z4bVM2TGptN25W?=
 =?utf-8?B?cmdHd3RpMThDeklJQ3lMbzRsSWZQVUpwZU5uRmRkWDRsZ3ZEVVJyS2xWS2dh?=
 =?utf-8?B?bndZaDZ1NDcySktlTE1wTG0zTk0yUUh4THhocFdoelliUEdWS2R0ZUtwbGpP?=
 =?utf-8?B?cHAwMnA1eUkvVHNEU0tQcFVCaXBlZUV6RnRYbGgrVzluMk5sWkdyYTlyMG9G?=
 =?utf-8?B?YmZGQ1JnUktPMFpYbUVzRThINlAyL3BmdXBaTVprYndESWdnNHZITldTditT?=
 =?utf-8?B?eVZ2aWQxRzVSaFlwUXlqWjlLTGZyUTgrU2FTU1IwUWRJN3JxekIvK2FKaitN?=
 =?utf-8?B?T0ErL3MxRHBTWHlpMVZtUWRGaVgvT1dNSk5tL3pjTFEwOWhKWjlwUVFTb3JI?=
 =?utf-8?B?YU9GM1VISzc2WXlvMkJveGIyM3J0cVZVd2dGQTJyMHhaNFlaRWN0a1ZlVnBt?=
 =?utf-8?B?VGZIM0lZejhrRm9PcUxOUWxaMkhGTS9XRysraERKTWxwTTdFeTlqYnAyVlUv?=
 =?utf-8?B?Y1NZcGV2RzhvZmt5ekhNK2xZNFNsVCt5YTdSQmdxWk1GRTV0VlpiY3VWcUZ5?=
 =?utf-8?B?cnhaYkhoY1Zvamk1TXVDcm1uVnNnTFZlNGY5dXdLaEdvRzVxTktBRU8vT0Rj?=
 =?utf-8?B?Y3dVUlhQOEg5WTdaNUt5Z3pUSzF3cU9FY1Y4SUo2aXhGRVFTN0VWeFNZcjVN?=
 =?utf-8?B?TklBMFQ5dVZwSTFrN3NjTXUydTlPV2JER21rOXVuSkpDdFR4OHdyY1F3am15?=
 =?utf-8?B?R3R4bTBQazcvQ3Ryc05ERjU3aDUxVU5Va2xiZ01WRmZqcU15enF0dUlmdW54?=
 =?utf-8?B?NUd1YWRLMHVjYUFuY3dDaFB1N2h2aXhBOW9EeDJpUjN3UjZFVkFYMVBVRGxK?=
 =?utf-8?B?WnRNOVErSXJTVXovSW8zc2pwWG9PVmFmWEFCZFJYZDJHUWsxeTNOUmhjV2I1?=
 =?utf-8?B?VjlRNUM0ZG9hY0oxYTBVWk5hWFBZbm5ZY09IbGdzQW9IMExBVTlrVDgzb3R1?=
 =?utf-8?B?NGZzWVQ4cEh1cTF5VmR1MjR3RFNPY1hqbExVOEJseWowOTJhY3lOR05YaEFi?=
 =?utf-8?B?b3JDZVV5d0FRRSs5MHB5ditGR0JFL09pSWZhNnpsMUc3RXZFWWQ3WjVEMjJG?=
 =?utf-8?B?WGpVZGZ6WWp1YnpFWCtTWGovL01kT2wxUFNhRFNhZG1IcFd0aC9pR3NXSStK?=
 =?utf-8?B?cXNEb0F4YndzWFZja0l0dk5kaXBVSlVLemE1aU51QkN4THEweU0wM3dteGI0?=
 =?utf-8?B?ZHQweWZMNjN3d0Fpdk5CaGg4Qjc3TDA1WHdpVTdhQmtqcTFGUDBXMWtyaVEx?=
 =?utf-8?B?VG1YMklvcE1MbUxoLzkvblNlenlmcUlGRGRibjl2aFlzQjVZK2xWTVFnemY0?=
 =?utf-8?B?WnVtT2s2TjVIWHRWcmNsK0pacHV5MmkyOUhxRHNudzZoMURQTnlOOGNGOUVU?=
 =?utf-8?B?dVc0NmVMZGlLdFNUWnlNZ2hKYjVQWlprdU1teW0xQXNzZCs1N2JZc09BSHR3?=
 =?utf-8?B?SHV6QjNUdEs3WEEwKzY4alJwdGYyYll1YjB4NzlNbmdDQXFVZDFIY1Fabzdm?=
 =?utf-8?B?Rm1GSG5aSzZicVRqcEgrd201a0l6K08xdzlsU2tBeWlQMWd5Q2tmRTZGb20x?=
 =?utf-8?B?RUtpZ1BTcWk3akgxR3h1K0QyK3Fad21YSDBBMGMzL0grS3JTaDQycnVwYlU5?=
 =?utf-8?B?czZzem9OYW1zOTdqK3ZvWU9UdmtuWnRJVWhQcWpyaENaZTA2MjJLdkVIbC9t?=
 =?utf-8?B?SG4wNEN3YWJZTk0raDl4cy9naHZuZ1hOYlJ2amtUNTl4b3g4S0JOaytYblZV?=
 =?utf-8?B?ZjdzNTNSRzZwNi9pTVdsWnF6dnI2aWlVaE92TjBHaXpkaW9HaE13a3V5ajE4?=
 =?utf-8?B?bVA2VEVFamJySkorSXVsK1RQZ2d3Q1V2cEpreFpJMEkxMXpwR2l2Qml4REpG?=
 =?utf-8?B?bzNsUEwzNXhTdTZia1JzenZsVVhIdU96cjBlbk5kVnoyeUNrTUt3U3lvVktZ?=
 =?utf-8?Q?1kpm18V5al0r/e/vGojL65dZS?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: EYnMcN7RyvB03My6QSEZUEmi82gNIeoRCJxEimCnoWTIvGJkf/C1xr9bzUD/KQwNaT12fryVFsnfIO70IJWjqBHZUHkbiuTnb7L9TBe7QPezmDcLMkkUeaplLS+oKIf6vn/6W9dL+MgETFa1IGl066/NPpnTnXpets8+XVtKcEJXEa7zxLy+DZoEdYh9Sgxerf63ORUkLtL0eCBiC7KTkRfYZTzHQRkOOlqn2anKkkfsYz52KWpJFMaNT/5fZ/y228VChm7eAaUD9YG1aBFFv29MwFPhdFtA4afZMY+DRdddUil9/maWZD8+83qs+qRKcH9PQ3bQyPGMkOxjkPDvfX24tb6n0RRgCWT/P0FeFbj4oyF49vHkMO95DZHk+D1OjPqI4Y6SrACM1V6Uv5OuSTUu3WyDOwZOHcdW2HqVRcUoUe8b1zAv15Awt9vwB6aejqQxUCyHHCZaP6hWVzQSZlJOClfZFbpfK7gigWgWM/E3sL57932aoyP/N9fq5Y8JYRBLhaWvAQ5W7iBYQgRz66+eGOiMQTVmGY3CGQYQnfpcQAWHezY6LwWDoI1k/ZcYA3L5zhYz/DpwuVggEc/Oz5mXlQpSuAHp2Z1F1/MPqxyzg0aTYi/0k/Zv9x2TdjQSnIb0vjplj26gq1U8/BPFTSZE7tVTRAtrblIrJuru7B4q/gWAGdDq2DeXtzY3a2Heu/SozPFbFzBhexUOca4bfmb0aqLGSZ38K0SKMc+6ozt/JoxA+4JmrOFcx2rXqk84HEbGLeAea00P3IXlFMtDqWDxn4dzU6cT4AtdmMJT1SAI4t8giM2eR4igGXpmyarVZl+Pp/cdZTW2R9kYS89fUi00o+1WY2AcBjBuZWvX5laxDTF/fwAiaj9I4oyn0bvD
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b13ff688-bf42-4adf-1e41-08db3b39a9fb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 09:38:25.6435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pgPtZLeESQx16C+4wRaCSCMcsNfy4KJ/oFJdiPwVoqGlcSOIDyrt58LsI6GhVJ9XGjUx0jwyKObNar7JKHaMYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5937
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-12_02,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120087
X-Proofpoint-ORIG-GUID: gugbLfpTzfpCYhxn7f2mZN6mzMQWOrxZ
X-Proofpoint-GUID: gugbLfpTzfpCYhxn7f2mZN6mzMQWOrxZ
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/04/2023 22:17, Sagar.Biradar@microchip.com wrote:
> On 28/03/2023 22:41, Sagar Biradar wrote:
>> Fix the IO hang that arises because of MSIx vector not having a mapped
>> online CPU upon receiving completion.
> What about if the CPU targeted goes offline while the IO is in-flight?
> 
>> This patch sets up a reply queue mapping to CPUs based on the IRQ
>> affinity retrieved using pci_irq_get_affinity() API.
>>
> blk-mq already does what you want here, including handling for the case I mention above. It maintains a CPU -> HW queue mapping, and using a reply map in the LLD is the old way of doing this.
> 
> Could you instead follow the example in commit 664f0dce2058 ("scsi:
> mpt3sas: Add support for shared host tagset for CPU hotplug"), and expose the HW queues to the upper layer? You can alternatively check the example of any SCSI driver which sets shost->host_tagset for this.
> 
> Thanks,
> John
> [Sagar Biradar]
> 
> ***What about if the CPU targeted goes offline while the IO is in-flight?
> We ran multiple random cases with the IO's running in parallel and disabling load-bearing CPU's. We saw that the load was transferred to the other online CPUs successfully every time.
> The same was tested at vendor and their customer site - they did not see any issues too.

You need to ensure that all CPUs associated with the HW queue are 
offline and stay offline until any IO may timeout, which would be 30 
seconds according to SCSI sd default timeout. I am not sure if you were 
doing that exactly.

> 
> 
> ***blk-mq already does what you want here, including handling for the case I mention above. It maintains a CPU -> HW queue mapping, and using a reply map in the LLD is the old way of doing this.
> We also tried implementing the blk-mq mechanism in the driver and we saw command timeouts.
> The firmware has limitation of fixed number of queues per vector and the blk-mq changes would saturate that limit.
> That answers the possible command timeout.
> 
> Also this is EOL product and there will be no firmware code changes. Given this, we have decided to stick to the reply_map mechanism.
> (https://urldefense.com/v3/__https://storage.microsemi.com/en-us/support/series8/index.php__;!!ACWV5N9M2RV99hQ!PLrbfoEBvEGxw2CvahCL0AP5c4f5cQ8gT0ahXVgB0mSbyqxWJ8pdtYY0JwRL8xZ59k0NHJhXCBbMtVWlq5pYMeOEHmw7ww$  )
> 
> Thank you for your review comments and we hope you will reconsider the original patch.

I've been checking the driver a bit more and this drivers uses some 
"reserved" commands, right? That would be internal commands which the 
driver sends to the adapter which does not have a scsi_cmnd associated. 
If so, it gets a bit more tricky to use blk-mq support for HW queues, as 
we need to manually find a HW queue for those "reserved commands", like
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/scsi/hisi_sas/hisi_sas_main.c?h=v6.3-rc6#n532

Anyway, it's not up to me ...

Thanks,
John


