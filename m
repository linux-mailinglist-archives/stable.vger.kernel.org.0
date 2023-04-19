Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBA86E743A
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 09:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbjDSHnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 03:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbjDSHnO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 03:43:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968D99EF6;
        Wed, 19 Apr 2023 00:42:54 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33IM64oE002249;
        Wed, 19 Apr 2023 07:42:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=zu+Ur7itMQYWuOF9VyOJfr2/Uyqk9exAHjEZYgOdab0=;
 b=2j1mqwpvUIY3oviNqOfJGg7HjOgUW+aUt2/+gR7J7puJV6yPlJjzTyvPqmojI2EyVmMc
 qMTsHlbl8p943AnykZghMJjUdEDPWhfdXSdWypOR0ckphPKAkz3U4c2bf+gFMjtL5bIu
 vHKj1Gg56Ej6NkHJG9LB9z5pHXNLkMEj+8rHnYohJhqbOgvErMxuaIJqmlgo7bNxk4g5
 oXP/mN4czoh7EoUFL4h/Pb82xU13yez5bW25vkxuDCIFsRzi1NnbUoPwumgBRQdpHlJ8
 VF6zu1TsmQdlgEC+t2cbN0/1SmCupX7Vu03n7RSTULSWtlbm4VtjMeRvsCP1j7f2Fhqs qg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pykhtyjk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 07:42:49 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33J5gX1k026348;
        Wed, 19 Apr 2023 07:42:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjccumdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 07:42:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQeQ2wsvlHe1eSKZy8pNVPmuej3EYGFzCiBLNYbvKaFH8dHfHcL4iqrOFKfaQRO5RhS0aJkFmLS+6zj9yxTixrJmdJBx9GX+dSQIcc3b0vLaZPOu6cRYimNE+tWKS/YB7Ar3kDTGrFjRLwl1wh/QDn2hhASWbquUJzsce98LCjVTdM7/M6N0MlL/GBy1UVDbI62iUfhbeluQnoQEN9Ib72KYo1F0T5YyU2A6XiyhqX5rOdFgiu2/MPC/1uPs9Ikc7stv3aUP3weH3H7t8p/oIOUk4Yun2PeLzrU0VFMUYH0xexAVTuVguRwYMmrGhDYwU0oR6AsG5I69iJnNid55WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zu+Ur7itMQYWuOF9VyOJfr2/Uyqk9exAHjEZYgOdab0=;
 b=f7VaAkX5+mik51D3zYZ9KUrS+TiBgXmFSRKhdyL8JlB7rRE9Nw8LQm98upYqdpCFtZS0KSA3cwOIJT8jQCDEHf7PDSpOEBYuOzI7k+wy6yzh7T2KU+AmEsJW9V0gxmCMcCmhnwQR1H2rrqjfNhvidC2yIM6UuYdZLoxTsq+UBo8mwSn5bmWlWlcJIBEXVXnjCemQC6q1JbloIx+a8IQaY16A0fKp9s/1qhOpSWF8LVnimwNAfu2lAU2Z0JLaCYaVnjOMhqG2WGAdwJg/tHYEfCcN1RndZ2KKkROoskQqcgb5AK73wWBHiTcCqOo7QlzLN1sr2ceoEOio4/qqqvkfcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zu+Ur7itMQYWuOF9VyOJfr2/Uyqk9exAHjEZYgOdab0=;
 b=Q6TyEa1kMCZKxuvyGDBPbvqT6h/azVYXjadz4dsm8cAK2ON+QqAhWthbF1mmto2lXiAJ7ek9gPCCB++k/BG/lFPTEZ0vZL8lKqVMWyIJ6TxTNXxH3GnYMwLecUO9Eimi8ZLcGk5Pif3UylKcihGnpAhcIsTVPF1SxyIupxGh928=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH2PR10MB4343.namprd10.prod.outlook.com (2603:10b6:610:a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.21; Wed, 19 Apr
 2023 07:42:46 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8456:ba59:80ec:d804]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8456:ba59:80ec:d804%6]) with mapi id 15.20.6298.045; Wed, 19 Apr 2023
 07:42:46 +0000
Message-ID: <67baaecb-984d-cf2f-03c8-c4d8d7a650f7@oracle.com>
Date:   Wed, 19 Apr 2023 08:42:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
To:     Sagar.Biradar@microchip.com, jejb@linux.ibm.com,
        Don.Brace@microchip.com, Gilbert.Wu@microchip.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        brking@linux.vnet.ibm.com, stable@vger.kernel.org,
        Tom.White@microchip.com
References: <20230328214124.26419-1-sagar.biradar@microchip.com>
 <3bce4faf-e843-914c-4822-784188e3436e@oracle.com>
 <BYAPR11MB3606BFE903D1BBE56C89D31BFA959@BYAPR11MB3606.namprd11.prod.outlook.com>
 <c5405999615929ba304988ebe18faf3853cc9a95.camel@linux.ibm.com>
 <BYAPR11MB36062386E7B3DBE1FA69CEB4FA9D9@BYAPR11MB3606.namprd11.prod.outlook.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <BYAPR11MB36062386E7B3DBE1FA69CEB4FA9D9@BYAPR11MB3606.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0039.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH2PR10MB4343:EE_
X-MS-Office365-Filtering-Correlation-Id: 99c796dd-896a-4b84-3808-08db40a9aa95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: arJ4MrlZU1HPzdFGRHfU+RfRGCUKGo4CMtBJov7Ydxvy1Sj/fLLIU8x/ZuEF4r6z+itUrUHLFYfByt9bX8gxUAuwvK7x/YAmi2Y8479/od0nRu4HzLtt/4hwsRhknVXkzIMe0eFBwAizr4B+RiMgai1A/BS4OsKyXB80OfDm7n12QAY+ggYW0Ru2FP2aZ0qW2vR3vcqGexAHGajLe18NBHPyeYHedXteKG5HiqI6FMEcOF8Ob2X/dCwOnrpIkdY4hbcpg65yBP4XCz0HjumktcJePvTVwSGjfH8ekzE44+r5K1Nna1T/Wr8b0x97nCy8TfaQvXZrJhRTVDoxj7hAfNeBCXBxuVDJtfMuYFV+CGOexFjZBa0Krb+0T5TPPTqvEduw8K2ITiARbOzv7xyOt+px/oWg6PRWNgfKoqDHvIJi3kdMdnIWPARFIQONje1g8H8aPvHYn2jVFyYBr9EwGEH02JrRYd2FmzIwyp82gTtQWDMgXjho/yPXpfFZgOOOej900tm5jbLV5ReiIQfOBtqvNcFa7znjU+/YLd2wQI8lZXyom0gqN1FDyks96cMsaGSZc49znIW37ivH9dLoL3AQdLhXf251XxpQm/OzNixuTrBPQfuQYJ5NydAcyD/oRgBrTtO2lWDH7am70y/TRflmTXa2aBdUt4q2fzdZDWM2Jb3dUzp2F1Na88vdlPou
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(396003)(366004)(136003)(451199021)(36756003)(2616005)(83380400001)(5660300002)(31686004)(38100700002)(53546011)(8936002)(8676002)(2906002)(478600001)(6666004)(36916002)(6486002)(316002)(26005)(6506007)(6512007)(41300700001)(66946007)(66556008)(66476007)(86362001)(31696002)(186003)(966005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UkFIaC9JUzUxOXVtdkhzOGxFaW53QjhoWnN1SnVTY0ZLY0dWUDVVS2U2c1FH?=
 =?utf-8?B?S0FOZ3FieWE5QkdqdyticlYzZm4vODg4ZnhIM29ETlIwUFNxeUUwR1lkRlBy?=
 =?utf-8?B?Zi9GdXZ0YXpTVDBKQnhJTFkzWm5PclBKUUNaRUxkYitrTjBsbWE3N2hwVm9x?=
 =?utf-8?B?Q0ptRU5xVjd4dGZyQWZERUtrUDRGM1FaTG1MUkpmSi9KZVRUaHJCYnFKSEFL?=
 =?utf-8?B?djhTWDNHT3FhNVpxQm9wcC9RV0VrUU9Dd3kyaUNTNUdtTUZaN2hPcmVxaTZr?=
 =?utf-8?B?dUdVemxlTkZRT2h5Q0JCL1JoYWVKbWpGTHFOSU8rL0U1YzF3WjNRU1NiNEZU?=
 =?utf-8?B?cmJqTkx0QTMvU1RtMWlCWHBZamdZQS8yTGwrMndmbXo5c0dHMjdsRDIwWlJQ?=
 =?utf-8?B?d1pjYmNjOVVhb1VRajAzZmdRWFowdm9kZFlFTTBaUjJQV0lzYkE4eXdoaWxx?=
 =?utf-8?B?T1RVNDB5WXc1NHA2aWcvb3V1QXJyZUJDMGpEMnEyb05SdFNiSWc5U1hsRDEv?=
 =?utf-8?B?STNMZkVsbjM2amF3UDd1S2V6QkRxU3NWWDdTUGFoM1BOUDdIbEdlbzdDU0dj?=
 =?utf-8?B?Q0RiWDgxUnpKVjFzNW5xUUVLSTdGa3BWQ3UrWnJtYUVrQzZYUU5jeUNDRzdH?=
 =?utf-8?B?WDIxYTNZQjFBSm9RakRBaE9qTHZrK0hWNkwwK3llWENEMUU2Y1lybjBnUWh4?=
 =?utf-8?B?MUh1WUE2SzV0NEVhRldSMFAvV1VCZG5qSlMzZFNNRzZMVlh2dC9PcUVteGsz?=
 =?utf-8?B?d2Qxck5EUHM5WXJiS0YxcDhseHRDZTZhYitSa2sycDB3VXY3dWJzeVQxNU5i?=
 =?utf-8?B?ODNqSmNDUUUybHNybXArVXRRbVNLZ2p6dVRmQkFzekc4OVhIR1dpQjA4Q2hB?=
 =?utf-8?B?QVNhT20wa0JhL3JBN1NGaTltMlRXdTFtVFExazhETHFHL25wbEVud1RvREZq?=
 =?utf-8?B?Mkw2MDlCNXA3aUhFWEVDUE55LzQrb1ZlOE9sQ3JaSWI3SnZvbkRKWmlkY3Rt?=
 =?utf-8?B?WCtKWGVTRE5RYnR2YzFSLzFHS0t4STNDMkNRRVErWGhTQXh4OU5TWGplUkhy?=
 =?utf-8?B?MjFtM3VOYVRJdzNaUVg3bXlNc3luSDFrcXpjakFaT1BoK0w5VGdUU0ZWZi94?=
 =?utf-8?B?aTAreW1ZUXd5YVh3S3k3aktyZW9qT3pnSUhzc25nSjlqaCtGeUNaMHhIY0N4?=
 =?utf-8?B?S2FzbEpubVNYcWxOc3NJWmsyVzkwV1dzLzBuRm1OT1NlbVRVdDBOSGFsTHFo?=
 =?utf-8?B?amREckt1VjhwanBkVlBtR3NRZEZKNXdkZ2xTSUpESXk4OGxvL01NcTM5ZFB2?=
 =?utf-8?B?L01BZVgzSzR5NDAza2pSMG1MZUhtOVg3VTI3VnFiTFdrYWdtMGxHbElSQk5z?=
 =?utf-8?B?c3d0cnU4WjVFM1pWVFZlVlI3dkhLZ01vNTU0NDFGK2pPc2hweCt4TlF4N0di?=
 =?utf-8?B?d2pIaGZNUE5uSjVaa0MxSUpobmpLejR2T2l2YXdlYkNJemtNKzcrbjY0VXRx?=
 =?utf-8?B?cjB1aEpJVzBmMHlGUkt4ZVZjbmJqaW9qbE5BM2ZwNkpoVjBNNlRIcUZqaHZp?=
 =?utf-8?B?ekNEcWRkbmdQVnhOWFh2aFpFaG4yR2E4VDBkTWlRWDhQajhNMVVxYjQ2WHo3?=
 =?utf-8?B?ZUdCekZtbXR1ZUZhb2tZVmVER0NIRmZkYmd2MFpIN1E1c0dNUXJmUnM0N294?=
 =?utf-8?B?ZjJmdTIrQng5RGhCeDRzbEJFT2FvQnNjWE5rYndtanFQSnBiNk5HbDJSMU13?=
 =?utf-8?B?K2pMZ2h0Q2RxNFBUb2JiMlNiMVBPWE9rcFhXakxZSzZ2RFVySnZPWHcrL1py?=
 =?utf-8?B?dVYrRkRiQzhaMGh5Zk15WmVVeUdUVm5MOWN2U1o3TkhNcjA0cWt4UnU0WFJz?=
 =?utf-8?B?YTlhWjArQzVBaDAwVHA2emtRWEVOalhkU0hYLzNQc3hLSGtXOFg3SHlIMnZm?=
 =?utf-8?B?cjYvMEpFemUwK2tibE53T0NlVlZnRi84ODhheXdsVzIrSWprRi9JZUdjUUcy?=
 =?utf-8?B?cDVzYS9WYkppb1g3TmxlTmxHM1JUY2NRTStVbUJOWGVpSkxZV2IrRUdoL3Iv?=
 =?utf-8?B?OVEvRjFjVnZzRVpOVURtU1phRUc2TmFaZnJla0ZIYXZwS1VmWU83NzlEczhj?=
 =?utf-8?Q?/aot8V6nud6F5iwB6xe+FZT3a?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1mtXRGweu5POMrCHdOGQeLkr8dI4e5NC1FXR22Sk2y8gjaHO1hJ+a3VoZjY+EVrSn2HuqJp/ZoGnB2f7lDcEQ7nbQCSdIYE2/ZK2N2Pv5CcnoZMsBliZcIsr6ErzvRGR785Lf+b089uzMUpScxsgIaS5E0eZT5XH0HpFST5tAXCjbQ59F7VAzc9rASBJefYpne0H5IzeelihjuJwGKCGxGe6FGWp9FXz2AAYGsM5qAIdu9Tjvyo52i8C0ex+kbQ6dRoaRdRp2BTs5ll7wkXS/FuRj0bOmrA9Z8bMEOxJOVd6d63gCm87/gx1a1mUtnhk5OEjN4trJLuEMHfUoOD6Ry4kdAHxdbP4JqRGG3Js0hPcu1vLTR9Yw23jkbl5iQl1XQwaMLG+D4Xd0JVom89e5En8x/GyBrKlvjnewmFgURDYohDMEj4YW3RFKLmz17VsEr1p7yue94tO1J2lchhKtWb5RCOtH0ovEzOeZGO8NTuv/PMaC5TEOHwd5VNtUjcsKpDYJSuiP4Kq0ufQ+QFW5o8XeE8Dfd4DG9nDchSEsav78C64NxQ/aXEv4dDL9ZSC2gRpaA5MOjGesyqAKa4l6980aBBHQLR1EYYEOX9luaaWyzacIxUQLaOjV772utiSrkaBlHTSaxD6aDFq/3mn3DoT71s2ZrWrtK3MUWNhK9ZRZwJiK108oxUJrp9XBXnS1QodGLqdb6MMNLH4bdt9XKTAIawayHa+Y9fTFu4DNVf1axqMnwWacShAMG6yKiSR/JeLnt486lnGcKP96PzcVx9Lp7ZCG0f0ddH2++XAbciuN/sgl2koXayT01qXR6HRHOIsPFIhsvwtMksS5Wsi7KbH6jfVD5I/+EQ9gpCWX7s5I+nbS+Kcb3krqk4Ml6y5
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c796dd-896a-4b84-3808-08db40a9aa95
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 07:42:46.1869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QBxlGNd9/8qbnOK29ABy4sFA9F7kO7/VO8W8wLmpPV4zePpihsXp6sDwQQB06z1rqALkQLSG7CNMhcTSInXjBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4343
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_04,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304190069
X-Proofpoint-GUID: VBptDgjEFEpXeLTnetddxcj8YA-ynNr_
X-Proofpoint-ORIG-GUID: VBptDgjEFEpXeLTnetddxcj8YA-ynNr_
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19/04/2023 00:55, Sagar.Biradar@microchip.com wrote:
> [I'm with Jon: your email style makes digging information out of the emails very hard, which is why I only quote this section] On Mon, 2023-04-10 at 21:17 +0000,Sagar.Biradar@microchip.com  wrote:

I stopped replying as this wasn't fixed... and still isn't :((

>> ***blk-mq already does what you want here, including handling for the
>> case I mention above. It maintains a CPU -> HW queue mapping, and
>> using a reply map in the LLD is the old way of doing this.
>>
>> We also tried implementing the blk-mq mechanism in the driver and we
>> saw command timeouts.
>> The firmware has limitation of fixed number of queues per vector and
>> the blk-mq changes would saturate that limit.
>> That answers the possible command timeout.
> Could we have more details on this, please?  The problem is that this is a very fragile area of the kernel, so you rolling your own special snowflake implementation in the driver is going to be an ongoing maintenance problem (and the fact that you need this at all indicates you have long tail customers who will be around for a while yet).  If the only issue is limiting the number of queues per vector, we can look at getting the block layer to do that.  Although I was under the impression that you can do it yourself with the ->map_queues() callback.  Can you say a bit about why this didn't work?
> 
> [Sagar Biradar]
> Thank you for your response.
> We did venture trying into something like what you pointed to.
> We mapped the hardware queues, and we still see command timeout. This change doesn’t work for us at this stage.
> Also, we observed that the load is not balanced across all the CPUs.
> I am pasting the code snippets for better understanding.
> 
> 
> During the probe, we assigned the hardware queues.
> shost->nr_hw_queues = shost->can_queue; //inside aac_probe_one().

That is wrong - .can_queue is the number of IOs which the scsi host may 
be sent at any given time, while .nr_hw_queues should be the number of 
MSI(X) vectors returned from pci_alloc_vectors()

You should also set shost->host_tagset = 1.

Since the driver has reserved commands, the .can_queue should be reduced 
by the amount of reserved commands and the driver needs to manually 
choose which HW queue to send those reserved commands on - see example 
in other driver here: 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/scsi/hisi_sas/hisi_sas_main.c?h=v6.3-rc7#n523

JFYI, We have tried to add reserved command support to SCSI ML, but it 
still has not been finished - see 
https://lore.kernel.org/linux-scsi/20211125151048.103910-1-hare@suse.de/

> 
> We also wrote a new routine "blk_mq_pci_map_queues" (mapped to .map_queues in scsi_host_template).
> static void aac_map_queues(struct Scsi_Host *shost)
> {
>                  struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
>                  blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
>                                                        aac->pdev, 0);
> }

This looks ok.

> 
> With the above changes, we see command timeouts in the firmware space and the commands never return to the driver.
> This may need some changes in the firmware, but the firmware changes are restricted (since this is EOL product).
> Also, we saw that the load was entirely upon one CPU and it was not balanced across other CPUs.
> 
> We have had this reply_queue mechanism (patch) in our Out Of Box driver (OOB) for more than three years.
> We(vendors/customers included) have not observed any issues.

