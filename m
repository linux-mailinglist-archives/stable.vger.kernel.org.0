Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F306CD2A3
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 09:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjC2HIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 03:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjC2HIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 03:08:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A0D2127;
        Wed, 29 Mar 2023 00:08:38 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32T5e0ut010076;
        Wed, 29 Mar 2023 07:08:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=OPzxwLGi+RTZbPVTMmgA8pTxxPjBQovkWP1daFCfFNY=;
 b=hIVY0bUQ5oXf2gdls2qRlg6mpH/UNa0f+3/+oQvPoDk2yxQYh9t+zJBQnfYQwBSJazdS
 aoBT+seyJDZ9+XxM/EUothrndPyYqQW30g/T9p84qjK9n4r5aNowCLoCVbcv7EvdjUdP
 zSXRuXJcZtoxh2nVYkphIQ7x84lNyTbPY9167gus2Who2+Xz+5FiEhvWEB7MX4S0M8Yh
 uIKY0RxNolPYJAGwyodN/v2/LTz5O6kKv1+4M0K4BpCwJK0RZPnM34IvcoLbeEVfAOXe
 7vOmfj+GK5oXfUKmJv0oZkTtAXy27Hz4bCUur8Le+CRhIEhAAd/FTgYnGZFE90RG27I1 4Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmfch85sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Mar 2023 07:08:35 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32T6B7mk005509;
        Wed, 29 Mar 2023 07:08:34 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3phqd7dtcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Mar 2023 07:08:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IK5lApYe1dboxkJglek0mDfoXm5uOyUL1r90sh1Zwwyz53i+S+QTvoMWN/ouoxVXAWbshA32ePFNkKpWE+Ln+dnUwdrcsyDrV1Ev8rWAtesGoW9D30reKP7TQpTJgNNmIZqxIsOVTliWgqSIXzMbfJVnz6qrIuymKaa3amFTZloRZuqoX0DNpaU5lXZx1tcUl/ccnNxmOAR2Xr2FlVXZjQMPK8RqMpgOm9ClLN35+8G5n/TCaYn7JBtqaVoU+E/DYymhtWy/XntZBvtldv4wyWT0BXvI8UTfFT5ymb8KZvPIRAatR1KK+nY/py0vYKVks3mho12vg49HCLTKg2S+bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OPzxwLGi+RTZbPVTMmgA8pTxxPjBQovkWP1daFCfFNY=;
 b=UWIe13ZoJHq2u/6JPJCLoZQMflvX7V7RflNuGoTqeAP5aF0eTBx3Qf9AAS0fsjmDlIte3GRqc9z324l3NimLMJRic/nRZqqhFeG0WwCbteWCZ0t8HZ4ZIgIU5pWRUwnEmvHUTde0VgrxAhiogjNVCUcFf3qPIbmWNavChVen2VJmH1wywLxWEVRfTYTtAecpvr6f+CFH/S6xZ/9eG90TBNNU/fg07ifYkHJT53YHkAecm8ZVvel3e8VA86SosPsB6itlYoEIdSIM6wj20YRWybXQ2xSp3sLXwsBSr8eewL7zHqk/lj8z7N5PDjn710+nZG+ywfrXHZSSwFAnU6Jdjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPzxwLGi+RTZbPVTMmgA8pTxxPjBQovkWP1daFCfFNY=;
 b=yQBCPLc9zrf3Nv/upXxtmAE0jPFd2k0YihyR7YR4kz647HQw8ds9etZQOuKI/A/QJ2Ah7nmACEiTFdNdboTBJwQP7fBEfhobjl1KF4KQ5aNfFk3Je6CZOYFVvGvNNiuO2HryMBaKlMUYxbxkm9HaZvB7a6wgD7LheTkeR4nqCPA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Wed, 29 Mar
 2023 07:08:18 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267%5]) with mapi id 15.20.6222.033; Wed, 29 Mar 2023
 07:08:18 +0000
Message-ID: <3bce4faf-e843-914c-4822-784188e3436e@oracle.com>
Date:   Wed, 29 Mar 2023 08:08:12 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
To:     Sagar Biradar <sagar.biradar@microchip.com>,
        Don Brace <don.brace@microchip.com>,
        Gilbert Wu <gilbert.wu@microchip.com>,
        linux-scsi@vger.kernel.org,
        Martin Petersen <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>, stable@vger.kernel.org,
        Tom White <tom.white@microchip.com>
References: <20230328214124.26419-1-sagar.biradar@microchip.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230328214124.26419-1-sagar.biradar@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0028.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: 351e82a1-28d3-43d4-7770-08db30245f6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xyc2/mAuWAFkFr29AM7uKXtSn7D21c2C4oxVmH3yoQsTz6v4xNehqPi9zIE+W43CGUJ6PpMT/iM9gwHcS5I4M6Lyqw0fmoJFaN8HdCW68jWgFLYMqAkR4haNC6kVG9F/93PVlcl1CbbAsJ4jYSF60Cm5EWghZmeoSCPRjwKJzjWupaSJRZ8RPGzm6AGXkV7BTqDzPXX4kz8iN1ZY+6zJrODhC4xyyLuRO4ePGhZ30P81qu8qL0Ghigxp52B6u36e/WpG8VB4TD0EiQUwQQ43PRXNWbQ5xSCEZ6rMdtUyFFw350gCyw5UKhz/AS5kKl1J6YIbiAkkd5vdmOqwx9wtSQW6CyxcTaUkDmD+MxYnNLNGaZfV/cjKIaywLMqoE0yDzFpihuKG7VJU2rHGtnYYkfXkFtwFms0iyOOMyMgEcK7hTSeF1k56or/e71ZrvHWSAeQErztczq57MaQaxbW9sWk9s1mt+kLTOt/ZeBcKx69cvuOYgJmBZMhBlJElsU8s+t/ycnwgnD5pGhE6SkHH+BWNRqSDBLoFoR900xltxT+rdNWl5NlVWKMqBTMwU4NDdEYWWVjgO+RZ8IYuzigSl/DN/55eX6u76cprgffZtiZr0XE0mgWuXVJPalVbSuT3/UyGyWMRZeIlBVSly4s5pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199021)(83380400001)(2906002)(6486002)(31696002)(86362001)(2616005)(186003)(66476007)(36756003)(53546011)(8936002)(66556008)(66946007)(26005)(41300700001)(8676002)(5660300002)(38100700002)(110136005)(6506007)(316002)(6512007)(6666004)(478600001)(31686004)(36916002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YjV3a0did3FpL1FRQTNBVTJIQzU5dG1VTU43SXplN01aaVRhbUxkY2ZmTFU1?=
 =?utf-8?B?b2t4OUI4ZzRVNllvdHh4QTBLWlA2YkZpVDRBY3Q3L0FjQ2J0RXhEWTZVQmVE?=
 =?utf-8?B?ZjdSTDY3V3kxSk8reTJLQlFPVmsxQUxZdWJoV3pBK2cySWtnWDFKSDNCUVM2?=
 =?utf-8?B?bXhyZkxiZjUreWVNSFdRbmU3R1oxZVdhd2trdExrUFloLzE5ZzVuZ2tKMWsr?=
 =?utf-8?B?MHRWM3NVYVVWMUg5eit4UzZBWnJOTmcvL3BLeWFlRWxaZ3NjR2IvS2MzMkUr?=
 =?utf-8?B?VWlEams0bjhiQndpRnR3M3lDdDAxU0xHMHhyQk5TUUNIYkxVZ0gvS0NZYWZE?=
 =?utf-8?B?TEFIOEhDN0VFYTVIUW80Y09lQit4Y1ZUcjZRakVZZGMyU1E1Z0dHYm1EM0tk?=
 =?utf-8?B?bEYyaitKUHVtNUpxWWY4QUpmQkNJSDgyd3BRNnMzWUtPQi9nLzUzblB5TmVG?=
 =?utf-8?B?bG1NcGtQYVFGOU05QXZ3SjlYakREbytzMmpsRTI2dFhaMkc0cStveFpXaDVB?=
 =?utf-8?B?YVhaeHpUN1NreTJxL1F5L1FTMkJSTWtJbUcrTUtXejVYZzByUExiakdXUWRy?=
 =?utf-8?B?a20vS1BvS3FQampXZExxRExuamZYOXoxN2ZoN2dXWStUa09IMHhoUTYyc3hx?=
 =?utf-8?B?S29KMXRVKzZjUU1sUVVKVTNhOHFKNGU2UDFCY09IR2pXQVZTcUxUcFFEckJR?=
 =?utf-8?B?RnhhQTJKc3RzQmo5dVFtcWk4amxtZEdoK0hWNGN5bTBBLzIvYUtuRmV4K2cr?=
 =?utf-8?B?L253VFJMZzFrT3NaVW1uekVtVmZ4aVg2MW9kdG9aZzBIRytCVXVtYlF0Nmtq?=
 =?utf-8?B?MncrbVZ2aE5US1U5ZWw1U3ZyUkFnTXl6eEwyUWl6NjRJam9NdVRWRmN6U0c3?=
 =?utf-8?B?cWdaVlZMWE95WkxsWStnMlJITFczWFZpNVpQYzdYMURxQjRINFZYa3BDNFZx?=
 =?utf-8?B?MUc3b0RmUm5GV2ZZdUc2MEhGOUFtWitTQ0U3NW50d2dtWVpDYXQ4Mm0xbDZT?=
 =?utf-8?B?QlA3U0V4Um1DZWdpMUZBTlE4Q1hWaHdiWUlRNU9qT1dkZG82MU1JMklmSS9r?=
 =?utf-8?B?RXRXVkVIN0RXVlpROFEvUDZwWHRabFJTSEhoRDNINWpjQWY5d1FUN0dTRnVW?=
 =?utf-8?B?My9TUWxCbllCU2t0YUk2TS9WSlplMzU3UmdKVVhEOVAzZ1VXdnY2ZG41cHZF?=
 =?utf-8?B?Y01iRzlraUpCZVoxdEI5eXlxNnhGU3NrRW1lcktnb3hCQWV2dG96bDBRalph?=
 =?utf-8?B?QThPcE45UU5Tc3NiMDE0cE4wWCtmRWRhRnJMK2RteG5aN0wvbWlSajFjQnM1?=
 =?utf-8?B?MU5UMlZMS2FkbmtSUEtFS2FHbGdJdTFhTlgxTVkzaW1SeGw1WkdqVFQ1dkRw?=
 =?utf-8?B?aHJwMXgxbWRLVGJpbTQxeGtOb3MyeW5sM2w5NmdlaFBNOGhVYnpxWWo2MDNz?=
 =?utf-8?B?bHJFN0hDUFkyQzVZY3FvOExwb0hhKzQ3aGNYdW5SeUN1ZFZDK1IxV2pYZ0d1?=
 =?utf-8?B?SjRwQjJqTkRoOUt2NjlsL3VFdE5NaXVONnppblBvQmEwakIyRWpXSGN6K2tZ?=
 =?utf-8?B?eXoxSUpnZW5CNUlVWjZZdHp2ZnRRcVBZVlBkM2c3NEt5SGltbW5IcnRJamNt?=
 =?utf-8?B?azdXTzlwSmRQVGhWRjIrYXZDbHJFL1NNNHRNN2FkSldoNVB4WFlCbURjTyta?=
 =?utf-8?B?SXRBOVdFbTNKT21abXdVNnFOTG9zc3N2akoyMDEzYVVwanVHY2J2WGwxM3JW?=
 =?utf-8?B?THFreWRYRGJFT1NQWG11NmlJSVViT2s2Z1U0RU1CNEIrQ0Uxd0JEc04wWlFX?=
 =?utf-8?B?cHZjemRNdkwxUEl1MERsUlFoQjdJais3alpldEt4b29senlINEl3KzdLNjFG?=
 =?utf-8?B?OHRhNGxFZmZ3MnFySjljSkc3UkVCNnNUL0cxMFYvT2hIS0hIV1NsMHFpQ2Iy?=
 =?utf-8?B?RUpmYlNlYzcxekxXb0JoUVhWd1k3alVIeHdwV2c1MWpCV3laekFVZHg0QTlW?=
 =?utf-8?B?SXFrOXY1cFFuK0ZiVHFKSWFnL2V3OUloZHhKblIxeTExOWVYV1BOL0dzUFFG?=
 =?utf-8?B?emFmK0toSzlkL04xN2NBTWY0WjY2L1FvaWEzc1lwWDRXMk5EV0dNNTIzT3VP?=
 =?utf-8?Q?vvEQ9GvU8q/S/iGdyZ/LuXzDQ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: CBaQ3VpXRzva6VturQQiNapCqqh/ScRvSf1SCymAuHysrMRVP57A04WI5qkU7t+/S9p/cyeDF2dJ/FHRC96YMhIHstzsGD8yhrS5ld7j7xTqyzVr77EpEtyZuRspvFO2DNclYhyp/p7L07y7Hn/Ksxs5y8HW4gOTTKvPUDG4koFSuSZ0x+yltsyaTwSksFB6VbL+onuNlX76JRLe4Z/z9CqPPF+0/XEkOjzZs1Yei9HLezNHjeSbrPztAf9Gk7/uJVUOYa/JBAZHDN/2uOdiFrYnMDzvDTAVQ2y/jJUX4x8wqLizyQt0L6r5tHyFSZmfbru08izXbB+b6Q9LGlXJKTgmEFAZQcernDyMT1zYN5ZBuLMnOZxfQniHdXmInRUflMnhP34Ci4F5roD+8mMHcJEqRJdVxbBazuN38Rfykj3QIlLlnT6LmGSgHFqV7DIaDiVUZmR1hEataorgRapzo/STBquP2YCZgqoz8hYHXtmqC9D6nRjmHehO0JfllThjV6TbdCz/ZkgqrBwWvCjkiPK8KKKQkWEWVM/7G/1vnWiO7pDzR3Zjvmvj82NvvXTsEWw2tkij/L/eVwg385HmFF4S6pyQ61CpZ6jy1PJNIuSrXokOsv5u0vK1o4cWhwu9L3M3HfjlcMoU51BbpLnyBTXznZrrrnHP+9INTy9s3tD+yQaMnGt/yoLfVWFqWxjaWUQ0Lzkrvk0RBB99y5cXY36NyzniOOs+xZB6G4rAvBvqIwtGKFc3PKSaX/UAfTcnUF+5I8bw1M9R0y4TwzA9QskQBPrRcqE8URm5nYdkAeQBf061P4J2adjCwz5oDOmqQPl5sm/+RKyp1hNfEFidUYf1aLNEC8450XxB9hHgaDYiXbxc8l1PXh+8bpdK0Rzf
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 351e82a1-28d3-43d4-7770-08db30245f6c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 07:08:18.2918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cbexRj80lgLOVhJFN/rIH7jRB94R6n+iyXQJv6XGw3JLwdlH7EI12PPgi8IEollS57ZdNyUADeqSqRVRviQ/wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_01,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303290058
X-Proofpoint-ORIG-GUID: AZE5w8a4G01VPQXWKbSarMrdNYX2iJmR
X-Proofpoint-GUID: AZE5w8a4G01VPQXWKbSarMrdNYX2iJmR
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28/03/2023 22:41, Sagar Biradar wrote:
> Fix the IO hang that arises because of MSIx vector not
> having a mapped online CPU upon receiving completion.

What about if the CPU targeted goes offline while the IO is in-flight?

> This patch sets up a reply queue mapping to CPUs based on the
> IRQ affinity retrieved using pci_irq_get_affinity() API.
> 

blk-mq already does what you want here, including handling for the case 
I mention above. It maintains a CPU -> HW queue mapping, and using a 
reply map in the LLD is the old way of doing this.

Could you instead follow the example in commit 664f0dce2058 ("scsi: 
mpt3sas: Add support for shared host tagset for CPU hotplug"), and 
expose the HW queues to the upper layer? You can alternatively check the 
example of any SCSI driver which sets shost->host_tagset for this.

Thanks,
John

> Reviewed-by: Gilbert Wu <gilbert.wu@microchip.com>
> Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>
> ---
>   drivers/scsi/aacraid/aacraid.h  |  1 +
>   drivers/scsi/aacraid/comminit.c | 25 +++++++++++++++++++++++++
>   drivers/scsi/aacraid/linit.c    | 11 +++++++++++
>   drivers/scsi/aacraid/src.c      |  2 +-
>   4 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> index 5e115e8b2ba4..4a23f9fab61f 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -1678,6 +1678,7 @@ struct aac_dev
>   	u32			handle_pci_error;
>   	bool			init_reset;
>   	u8			soft_reset_support;
> +	unsigned int *reply_map;
>   };
>   
>   #define aac_adapter_interrupt(dev) \
> diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
> index bd99c5492b7d..6fc323844a31 100644
> --- a/drivers/scsi/aacraid/comminit.c
> +++ b/drivers/scsi/aacraid/comminit.c
> @@ -33,6 +33,8 @@
>   
>   #include "aacraid.h"
>   
> +void aac_setup_reply_map(struct aac_dev *dev);
> +
>   struct aac_common aac_config = {
>   	.irq_mod = 1
>   };
> @@ -630,6 +632,9 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
>   
>   	if (aac_is_src(dev))
>   		aac_define_int_mode(dev);
> +
> +	aac_setup_reply_map(dev);
> +
>   	/*
>   	 *	Ok now init the communication subsystem
>   	 */
> @@ -658,3 +663,23 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
>   	return dev;
>   }
>   
> +void aac_setup_reply_map(struct aac_dev *dev)
> +{
> +	const struct cpumask *mask;
> +	unsigned int i, cpu = 1;
> +
> +	for (i = 1; i < dev->max_msix; i++) {
> +		mask = pci_irq_get_affinity(dev->pdev, i);
> +		if (!mask)
> +			goto fallback;
> +
> +		for_each_cpu(cpu, mask) {
> +			dev->reply_map[cpu] = i;
> +		}
> +	}
> +	return;
> +
> +fallback:
> +	for_each_possible_cpu(cpu)
> +		dev->reply_map[cpu] = 0;
> +}
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index 5ba5c18b77b4..af60c7d26407 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -1668,6 +1668,14 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>   		goto out_free_host;
>   	}
>   
> +	aac->reply_map = kzalloc(sizeof(unsigned int) * nr_cpu_ids,
> +				GFP_KERNEL);
> +	if (!aac->reply_map) {
> +		error = -ENOMEM;
> +		dev_err(&pdev->dev, "reply_map allocation failed\n");
> +		goto out_free_host;
> +	}
> +
>   	spin_lock_init(&aac->fib_lock);
>   
>   	mutex_init(&aac->ioctl_mutex);
> @@ -1797,6 +1805,8 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>   				  aac->comm_addr, aac->comm_phys);
>   	kfree(aac->queues);
>   	aac_adapter_ioremap(aac, 0);
> +	/* By now we should have configured the reply_map */
> +	kfree(aac->reply_map);
>   	kfree(aac->fibs);
>   	kfree(aac->fsa_dev);
>    out_free_host:
> @@ -1918,6 +1928,7 @@ static void aac_remove_one(struct pci_dev *pdev)
>   
>   	aac_adapter_ioremap(aac, 0);
>   
> +	kfree(aac->reply_map);
>   	kfree(aac->fibs);
>   	kfree(aac->fsa_dev);
>   
> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
> index 11ef58204e96..e84ec60a655b 100644
> --- a/drivers/scsi/aacraid/src.c
> +++ b/drivers/scsi/aacraid/src.c
> @@ -506,7 +506,7 @@ static int aac_src_deliver_message(struct fib *fib)
>   			&& dev->sa_firmware)
>   			vector_no = aac_get_vector(dev);
>   		else
> -			vector_no = fib->vector_no;
> +			vector_no = dev->reply_map[raw_smp_processor_id()];
>   
>   		if (native_hba) {
>   			if (fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF) {

