Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D8A6E1D05
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 09:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjDNHU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 03:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjDNHU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 03:20:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D03A4C0A;
        Fri, 14 Apr 2023 00:20:56 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33DN3gek014982;
        Fri, 14 Apr 2023 07:20:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=qjNbGLuzsh0y/1PX1JmGwA+ff4x/3BJdrWvy3OqxJIQ=;
 b=ikWsNUiqbWaQoHWfuNM+v4gTJ70BLASUuz5pgd6qrAUA8/N7HHuU1Ci7vpzwjXmp4XGL
 8WcXiCD439le++XVBOfEF2XqYHS1Yh3Jhmq5YLh4TAtnugxHjiE1MjFeKXBb9pWWYOvN
 oRoBgdCYkkjygNEs5Zl5HuDAYoJSiVebmFLA8J1dxnJG1/uJc5VuREF94hCDU4MwzyCt
 t7guJ//sspZNMczlbdJ3URA/bHLYHh6tPVFs0oqzEmNIHc0SNZXzeL2qNp75udtXgP9n
 d26Rz920oHuwUcigotfAoHyrii3bHosB+S9Kgk89/jSYpvRzS20Edr/jQpnosA2oNuMg 6g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0b35c9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Apr 2023 07:20:53 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33E7Ib9i026998;
        Fri, 14 Apr 2023 07:20:53 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwebv7xf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Apr 2023 07:20:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gukw0xQK7fEeWqqhWW9oKMCOrk3hjJOajV1gI48fv43r4MKapIt1sw0Z6o9vJarmomyesVlwssMLISEZpBtxvt1PZO9GRmzXx79lv0sCbuZqTvg2dqb3Fsomi+26F51K6lQyVdI8DFQikcwVQSHlg+ksslQR120FOQU011/YkcjbZTcF/+0oQVOS4rCK/10rpqjeX2VAhf6J/CmdgKc1slOC0i3Bn1lglLWyZN68TgaF5nEA8KLlj4qw8ygIpJjFdiWJJm3aKlkRBGXy3VJdqYbib7Ib8kGVUynvtGfn94pHfq6RwORZDMMZ2x5W4r+Jp84CwZcOiqciqMKE+NwvfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qjNbGLuzsh0y/1PX1JmGwA+ff4x/3BJdrWvy3OqxJIQ=;
 b=B0nEd99JQGdYnRMHjeP1H63g4nkOjE2ZTVrgIngaFnmJWhs1rcR6ijLyuKbJVrm7oaDqJt+7GENrR10vwY6RMLOtoQF2SHgcTWPiIKqpI4XbjM+xXPhuT9vHcltNM5nBOWonnXY5jOY8uytXZ5zK4geIMRZEBTI9XTu4u3DuU6jBhDGK/3vJo57opMJQq7/0JBTPDqO8Lxzjz1xG3xqXvVHStve2djFFH9cgYBfXNar6L99nBfFiZPxIXc/SbnvWiAbfZUcuUz4fXV65MwU+uSUShkpvfOTvff+/8yudIyrQXLGEKTddzWL0Ahbn0S1lz38kzUuV7OUpTvueh+bnXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qjNbGLuzsh0y/1PX1JmGwA+ff4x/3BJdrWvy3OqxJIQ=;
 b=qkEqPkhzY32BcOBTob3gySarQzU1gqjlOeYhZtiNn+TrRhOvu0zB67sU2J4MaeP2GidR9ClPhbkCwn0B3N2QooQBqpNdiMxf6qEODsheO5w5pANXJQWCMdDi/QZ1KxA68CCMhFdfMBSSp1CUflo4MW9psv8vmeitT1miD8qgefw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB7297.namprd10.prod.outlook.com (2603:10b6:8:d8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Fri, 14 Apr
 2023 07:20:51 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8456:ba59:80ec:d804]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8456:ba59:80ec:d804%6]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 07:20:51 +0000
Message-ID: <b4650194-0f2f-8850-fb98-962354c1ff9f@oracle.com>
Date:   Fri, 14 Apr 2023 08:20:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
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
 <d7abc010-4d02-c04d-64d5-5fa857b0e690@oracle.com>
 <BYAPR11MB36066650D56088B1B7EB1D75FA9B9@BYAPR11MB3606.namprd11.prod.outlook.com>
 <BYAPR11MB3606A019F9557536CB0D47C9FA989@BYAPR11MB3606.namprd11.prod.outlook.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <BYAPR11MB3606A019F9557536CB0D47C9FA989@BYAPR11MB3606.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P123CA0010.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB7297:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dc52f6f-3999-4ff2-72ec-08db3cb8c719
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xpU1+A4YNSNmFD/k0u3KJPwoBpHhNzAe9a880mk+fNzDFp6zxPy1oln4VzAOKGzzryTiu4DU4t+IQGXvbukTscQXxbVyyxM+I5OVkMVda0QQlUcP+uec5uHTX16fJ2/z42QtZ92OuVGYOSJPE32vckwtkm/qKAacjFvQCAT+KQyGupqbk1WJ0t8AQGeldog9cbc4c8e2gEChmP3zh/Jq7eYJkpDNMV7mMDJaOAs7fngpOgydJH18cbWQrdQz3e2ip1k4uYh0uhEj589VyTT0Ho/H1cPrIb4QFiZ01xzPp76VvSpsSBfzBsh/WtOs4vkwnshLkNCwyT2qc8fi+jHVpZXeZYZobPFW+HvXs3IgsqedfnTwtc/EPv6tYd61Z53w7akWGGvmvB/qoV0KAuseNRXBjQ+Vn0ACb1pjDG+mPJzJWAQt+H5dVwdl3sS6RwdmyzhTDFCFKSEqLnN2gU9zSDZZIiwZ1kNMwmWJMR/1BX02LJzuPunM5J1lPGsusEswcZ2SOdUAhjfDTl53olo6dib6YivmHwttMI2s77otqtM7LrP75JTwQqKE/Ma9/G5WwhKeDlI8tKAc9yAvVi0tpkNVH+DQ5Qt20/pthhT5eMA0twcs/PwkKY+YikjzhPEraLB0YJysPq7vqeRisLlXFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(366004)(346002)(39860400002)(396003)(451199021)(66476007)(66946007)(316002)(478600001)(38100700002)(5660300002)(41300700001)(8676002)(2906002)(66556008)(8936002)(31686004)(6512007)(26005)(6506007)(53546011)(186003)(6486002)(36916002)(6666004)(966005)(31696002)(2616005)(36756003)(83380400001)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEI3TEk4ZEZTSWgxOGFsVFBrVHZuQzJZUDYyaFEra1NDOUhOMTd3cUovaTR3?=
 =?utf-8?B?MVh6SUg2aG5vZnEyK250Q0F2OG12b0xoRTJFajVvY0tPYkNvNHVYTVlJWG1x?=
 =?utf-8?B?UldRd0VUMmUrK3N5WkRnY2lMbm1rMVN5WjhrT0I3Wnd5N3paVklxbDRKYjN4?=
 =?utf-8?B?a2Nwa1FlT0FIK2lmYXdQTzlNWEtYRlR6QldIY21tQ3c4dWVLMGZtekhsT1Q3?=
 =?utf-8?B?b1dGdFFRMDhWWUFGUWVjOGZITzlReW1PRmJxQldaWXNpTjR5Ykc3dGFhaUps?=
 =?utf-8?B?aXBMako3dEZOa3VTb2JOeC8xbHZXUmhZd0JUSHNQODRxcXBnVzhGWWZqbElR?=
 =?utf-8?B?dEs2RkUycS9QY2NOTkFTQVJLeWNxelBiOHh5UlB1a2tZNm9QQUxtNm15ajlJ?=
 =?utf-8?B?RkgwV1hSRmlwREpWdEJrK2ZMZ0s3eU92MURYcTFrMmFZZVNmSTN4NnlhTW5N?=
 =?utf-8?B?dXpRQ0FsR1JyN21wQnlwamI1N3grZU5ESjN1eUE2TXl5ZzdmaWdIejUrOFNK?=
 =?utf-8?B?bG9QWFBXeE51WjMzSFZSSjB4VTFZSGkzT1BHeWdoamtwbmpVdkl0amJOVFZz?=
 =?utf-8?B?RXg1NktmeHRqd1hQalY4MzN1QkpsbXBKMm5oM3hDMld5YmNSNnBHSktrSDJj?=
 =?utf-8?B?TDFQZnlwQ3VNVHBJRE1ldzJjNWxSSmFzSlZFMGtrTGNkc2l3d1JxVnNGTGti?=
 =?utf-8?B?bE1wbjNYTzBiS08yVUhUNWhWcVBpTGhXeXUvY29uZnlxUTJwaUwrOXVHenBj?=
 =?utf-8?B?RWtkclhwdEphbVVhbzRIcUVQQTJiOFd4RUJmUXp0cFFCR3hTY2ZuYzZXTFZX?=
 =?utf-8?B?dlRLRFNQeUVlMElCOWVTdThXWG9ydE9QOTQ5OHRvb0FhT1pMZ2c1cmZqZVd0?=
 =?utf-8?B?TmNFZ0c4MEo2SmhtaUZmUGprbWs4M0c5Z1BmUlRpV2NVb29abXREZUpYZDRl?=
 =?utf-8?B?YTc4NkxZK3NxTXM5TXBCdWZXbHovaGpiV1l3RE0vRnZGZm9wTkRBVng4Q0lW?=
 =?utf-8?B?a1p4Qm5jWktOOG9NRlBGbmg4NXlMQnVJZFh3aFdUREYwZU1zWldxUTJra1BZ?=
 =?utf-8?B?bGFCWS9BWHNxdXc5TnlDNWozRXMxbFBNcVVianJGY2ZVUkxISFNOZG5La1E0?=
 =?utf-8?B?Z1RVb3hiZ2FYQ3d0c2plWUtkZmRiY0tJTjJYUjBsUlZvNmxrZ05hQURIUDNl?=
 =?utf-8?B?VkVnQWw3ZU5rVXRoVXg2c0NmM2djZ005KzFWRFRsaDNTMlc2eGFkeHFRSVQz?=
 =?utf-8?B?bDlSNUJWV3ZYWUJSaFZtb3ZNeUxiUlRQVVZzb1NsS1JxNlNjR1VJNU5id1Nn?=
 =?utf-8?B?ZzhlczNFWXZzR0s2QXg2bE84eGc2MTVnbzN3eGNnVlBvVjBqeHNpRjlnQXBk?=
 =?utf-8?B?ZmRnYmhOODdMRXhrT1NTVklwaURjQ3daOXhnUUJnV09ZNGVuYmNOUE4zL0w0?=
 =?utf-8?B?NGRMRHkvME1kZCtXNjZhZXgwcWpkdTZaeXVOSUNaYTg1T3FKNUlqV2N4V1pB?=
 =?utf-8?B?czVoZ2t1ZFYwOGxlNVRoODdwdEZsOURPSkVWWERWbUZWOGwyb2kxbUx3UnY4?=
 =?utf-8?B?RVRjSEROSlRyRnVCbVh1SXl1djRLd2taRUxJRFNOdEE5NEUrTEw1alRvQ1d5?=
 =?utf-8?B?VWJmVlBaMmEyQjB5cEp5YzkyMkhKblhDcTZ1WDhFMlRweXY3SlZLZWNqZTJO?=
 =?utf-8?B?L1V2dmZuemJnV0Z0VDRZb0F4Z0Iwak5jWFJ1eFE2QkY3YWozY1ZMTzVpa09H?=
 =?utf-8?B?RnlNV0F4eFpxTWNCR0kzU1Y4NC84RTQ1L1owZElyQ1VRbWJOZkJxVlFoQTNm?=
 =?utf-8?B?VFRiUEFpRmNhcThnZDQ0NmdqbVQrWmduQ1lpdDN0bTFSb3FreDdPYVUxTWJW?=
 =?utf-8?B?SlZQZkxOMWEwY3ViUktLRm9COGJzK2NQMTBlci9qZVZJemdvU3dYNFNNYXpP?=
 =?utf-8?B?UjhGNHVhRlNHejcrcTQ4MmFhZVErRUZtV0FNRXdWOCtzdTdjM1N0MC9zY2ZF?=
 =?utf-8?B?c01HenlrazJzWWNwa1hzekRKUzI3bGl2QndmMFVQQmpMdWRvUHJNQ3pvczRP?=
 =?utf-8?B?dlZoQWFLc1NNblM3MVV4UEM5c1Z3T21kS1BKQUFEVmlyMzA0Sng3T2l0a0t1?=
 =?utf-8?Q?e8/bwSr+DMPrqSpH/m07j//k/?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 6wcJTw4HPM5d6Lbz4K+KlMVfuj6yzJvGv1wfNE+Aksrlq2Ee9orjsxCeoUCPyOdXDquiVZbkxrZNV8N4j0W/V1+XLYb/RM/Q5/5shk1rJoGIXMzaJASfvsxZqAsCk0GlkB7O8OJ69S3CYcvpFh/Miz18OAct5lSkSd9n2TWahRXZLkJ8GovtwE40nUDSTCZBxyRGP2AVHWyDtBqTpwKJnWSTW6Qvh4MBobEBJKz5AJ3EvBSLEr4AVrrAQILtQVl91h7UmTHrmCkNe71WGCE1QL/fWDvc9lIpvdD8wfUtfjaFklgBOYwgNjKLqSTD5PZ/6bgS3XKaNkDz/f8A2OwOVoJwdav+7alNGJUQ49KA5txy9k5KkYy7fBwQ12FoHaSXffVEtCUSPwPdia1A2tXnP2WH2KoOOh99MuqSlG7i5pyVdhP7AXJZpjrxOr1mge0f2V5WhwIR/ZwajuNHw4hh1Rbu1SwwRDRL8FONKGC9d5wWcER96SBb8c5IXTlQ9DCgNrVpmxO3dvy7pSAXcfe8RrNezvFAp7XWzWO33HCP8RSoparEbbnlaXBXlIfFet7N8WBNY2OnEuAJZoRgIShYQq0LdU7xlnclgILoMq+v01JXFA2OgQnm2jdu4ztWNl5iH/PWBnHTebstN1g6OwxrvnLJIv//Wc47lClVmdp7FhSSi6EZjMTangydMrrqzyxQBHfZcuabBQJjEgxaHzD0xHn0xpPqW9vZWtPy7jNqLFMNPxHcFPTADoHAJfXDbXo7ITW0XiqdJvKnUN8huQDJeHL0KTowtI/dyhXeRbotuzWd4IAZFalU4bT2nnDWzb1GHFid3+UQCF+y42UY/4jyU3lht2dR/1oEZWovUh/gL40C+zv97xn2RS7JiFRc8xY4
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dc52f6f-3999-4ff2-72ec-08db3cb8c719
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 07:20:51.7511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A8qkPRwSDeEtAmGS2Afj7irw6kfCrPtJvuW1AI/NgAZMWuPcEoz0Z7z9An/FSpEEWcbVgSc7WUfCohoiH4a99A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7297
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-14_02,2023-04-13_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304140065
X-Proofpoint-GUID: jYTJ4NhvaTGALf4cylAsTTYevUiwesYJ
X-Proofpoint-ORIG-GUID: jYTJ4NhvaTGALf4cylAsTTYevUiwesYJ
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13/04/2023 22:52, Sagar.Biradar@microchip.com wrote:

[snip]

> Yes we have reserved commands, that originate from within the driver.
> We rely on the reply_map mechanism (from the original patch) to get interrupt vector for the reserved commands too.
> 
> 
> Thanks
> Sagar
> 
> 
> 
> 
> Also, there is this patch which addresses the concerns John Garry raised.
> https://urldefense.com/v3/__https://lore.kernel.org/lkml/20220929033428.25948-1-mj0123.lee@samsung.com/T/__;!!ACWV5N9M2RV99hQ!Jjh5jXadoTBK0R4UONFNOssLSRfzaOA9yV2ENIlArRzHEe6ylDxDEIwIzs9nzUOkLmgVC-B2Nfd_sjeho995VACy5O0qoA$  
> 
> This patch explains how the coordination happens when a CPU goes offline.
> IPI can be read InterProcessor Interrupt.
> The request shall be completed from the CPU where it is running when the original CPU goes offline.
> 
> Thanks
> Sagar

Can you please use standard mailing list practices in your replies, i.e. 
quote original mail in the reply here? I don't know what was added to 
the thread in this latest reply.

Thanks,
John

