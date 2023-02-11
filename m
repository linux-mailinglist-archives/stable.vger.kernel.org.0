Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A006F692F54
	for <lists+stable@lfdr.de>; Sat, 11 Feb 2023 09:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjBKIVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Feb 2023 03:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjBKIVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Feb 2023 03:21:09 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830B1311E1;
        Sat, 11 Feb 2023 00:21:06 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31B6qf4h011780;
        Sat, 11 Feb 2023 08:21:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=mB3bSG1jxiBZamXHWRHjs/MDOuMCIbm/VmyyRuW4ZQE=;
 b=pC3hP+zytcMM1xVVJWXHUWUilecR2AWrlI9Vf4XNVGif+j2t2WOEYlq0DykYFDVI/xwn
 fbE0Yw3QVev3dh5bGqJb7tcXqX091DNWZVhdRfzyKqfUpcEBuXSZugK1LCZGIgDFdVM/
 uVHu/ccedDh8u1eY/OOKUZxNLgkiM6nn71QFc/1PtMfjasaUbQfesRCaI15cRf/LY/lI
 N9uAxW93YVxjIR3w2AK5ADno2DnKHvqJxT5YC3Fn5aA4xq7NYVA9IVH7OnNordkUyPCn
 GDMwimrq06a68Qe+j/+gm9yp2csaEreLizoNuranoF/5WRaZsV/fCQj9zsyC+nlQiKL8 LA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1m0r6q6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Feb 2023 08:21:05 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31B6ZCMw028868;
        Sat, 11 Feb 2023 08:21:03 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f281rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Feb 2023 08:21:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RsY5HA/MtLUO7sW9+Udqhtnt+/15d4e+egsuBFzFMeWbSuKYiDUdq41n231c9Pq2BDBMvT7dMj/rfG/CEQAEFAFG4mpuW3IYacZnRNYa5UkWESHXO5g8HXayUsvAbIIVkTxNseHbtGQTUI+SW/dEZtWqiUv92mvW9JR3TwKM1o1jabfF60VxoIAEb6UtVK5pmIsOb5vi2c802K2wZ0zaeKZExjOB9sp1Utcf6b/xMsRlpTwYsHS4sDCi2QLCQs3A47aRO/ETd+U1V1Zp+NM+st72XK/dYFm8m+7RoHRROY+f8zB0l3Fu+/FXvSefJ2PaACPdyYLgFAb02aahuA9NHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mB3bSG1jxiBZamXHWRHjs/MDOuMCIbm/VmyyRuW4ZQE=;
 b=VohvKdUGt0cYQaH+bu7xxElSkIzs54TwyhL9sY+vlQ12Nb4IBhR+1kc59eGuE/vBLcD/zozhK0GCyEV+hjIEr8VEVeVFDyZR4y350gkBmmNSHa0Tn9fQ1XHrec8ai/DlxgQe+Jwp4HRX2kak55jaFFgSaUHhXxg3lkdlmO5q6jyID9bMyOPjTdn8817bKFpx81lRcNl1qzncgwkwawiT3WeYiPNhUsHRU6sJ2rVphDEtfCz3L81Eu8hoO8RkUT4UvWVMeNl43g/E6JV0rYoPQoltTU87BkcAugjievHjElr6p0ln2Q37sAGQOCZW+NM3dwpxHU/s+nvH1FJZLwF6Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mB3bSG1jxiBZamXHWRHjs/MDOuMCIbm/VmyyRuW4ZQE=;
 b=e9K2WO+cx1hu6HDO9ZXRyX/PTxQ014DTkXJyq78ncdQlpGnNGAysW0eoZ3wiiu0RzfMzfPWRiYUsusbJOxx19b38dkknrhqLpVrQzKZFQD7VLxE5EOnDUDe886KdLNuPQElsL7fgCSQfSFxfKBThv6KRA2+Vjlb29+/PpYRc+Wc=
Received: from PH0PR10MB4581.namprd10.prod.outlook.com (2603:10b6:510:42::16)
 by DM4PR10MB6741.namprd10.prod.outlook.com (2603:10b6:8:10f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Sat, 11 Feb
 2023 08:21:01 +0000
Received: from PH0PR10MB4581.namprd10.prod.outlook.com
 ([fe80::9013:b768:5177:564a]) by PH0PR10MB4581.namprd10.prod.outlook.com
 ([fe80::9013:b768:5177:564a%5]) with mapi id 15.20.6111.008; Sat, 11 Feb 2023
 08:21:01 +0000
Message-ID: <19b4a1e2-c8f8-dad1-51eb-c565fee405ee@oracle.com>
Date:   Sat, 11 Feb 2023 13:50:50 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] scsi: target: core: Added a blank line after
 target_remove_from_tmr_list()
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-scsi@vger.kernel.org, darren.kenny@oracle.com,
        michael.christie@oracle.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, martin.petersen@oracle.com,
        d.bogdanov@yadro.com, r.bolshakov@yadro.com,
        target-devel@vger.kernel.org
References: <20230210175521.1469826-1-alok.a.tiwari@oracle.com>
 <Y+dINRZ9ZKLhvT94@kroah.com>
From:   ALOK TIWARI <alok.a.tiwari@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Y+dINRZ9ZKLhvT94@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0103.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:af::17) To PH0PR10MB4581.namprd10.prod.outlook.com
 (2603:10b6:510:42::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4581:EE_|DM4PR10MB6741:EE_
X-MS-Office365-Filtering-Correlation-Id: 02cd2822-a738-413a-c073-08db0c08e87e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VW06zDwzo7RB1okSDF15JuSYWt7zsW26T6PGYpU7BAbn/vUW1ZkoOzq+GWv29B04qDGkT3XNFjm4YOWZcEILF29U24Q1PbodkiPAo88psaDAD7dfVpvJt1TxzssBE8q91oTjYGzSh/3qI4xlqXcum6fuXpKlz/F2HtornGjSUNQwNJDs12QtXrqxWktHu9N1dNUOCWp6SLHCUJEIM2F2da+qXZ/3j3L65aB+oFxgBZEOz+7wW0eb7AN+RuueGzu1nxGalp/7N29q9vgsKp9f3qjpnOVP6ReeReEG3IkWRp6hmKUvH7arVvcARA5jSrjypoChP/zUvPcBuqLkM3Ssw9wIrIKttRDoFPl9U0nrI7ZqBiPwh0aS3YEERjT+C8y6sNIgd4t2DbbU1wmduHbqJ6MsQ2tSEXMzeLIat08hk+V8QQyPdcMeb3PfK7bMCjmufmdyqeVS34Iq5G2gDiSdcxz+PrCmCGOZ5cGQExCIMohsj/xNpEd9R2ichwFB7skkpR2ClYLBhZuIkc+W83/G8nu0dKXfOuBmtOZcJIaa0htXYXGQXahi3N6NDGX+IsO4aHJhEM3DJY87XZDf2svhsO84ibkRC6tTV5rvMzqD3NqdAJHufUehlCWEvm0hS+2aL8ki65lUhdlVgRCW+e1PRl6+DQEaf0xBzoVcbIctIKZDMGtkCWAbuYexro/GIBEwNeAMQMBNkKzrWcteiupJdQGnWH7CHlJ7eq4P8VZn8UU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4581.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199018)(83380400001)(316002)(36916002)(186003)(26005)(6506007)(6666004)(53546011)(6512007)(6486002)(2616005)(478600001)(2906002)(86362001)(31686004)(36756003)(31696002)(8676002)(66556008)(6916009)(66476007)(4326008)(66946007)(38100700002)(8936002)(5660300002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXM0UjZQNnZxL0h1ZjgwUXp5Q3hmQ2VucmZCMDlRZXlpNGVlamZLY1NVSUZT?=
 =?utf-8?B?VkFTY2JjT2Jqc1g5dENDbENuR2ZUMnVCaFpaSmpCblhLckhVcjhjeVc5WHpq?=
 =?utf-8?B?Q2lHUnpBSEduWHRuZk5GTkpOc0VNbllNNjJWVHVFZiswWDIvS01TcW0xSERI?=
 =?utf-8?B?WEcrYlNxQnkxbnd2WU5XSmtINzJGRnAxdW15ZndNa0t4VlJMY2UxamtnNU1F?=
 =?utf-8?B?SFZvSklxeXpYc1Y4RWtDT3VObTdPazZXNXFFdWJ4SlZsTlRrNXV6U1VKa2tl?=
 =?utf-8?B?UnI0ODI1TEdqNDZFMFVwVjRiNS9UaXhsZUMxNysraTNrT3FNbUJ6RGluVFl1?=
 =?utf-8?B?MzN3Zys1dWxiK3ByUUtzWkE2alJuTmk2NGhERGNvOTVUM0o0VENKc0wvcWhT?=
 =?utf-8?B?RStXOUFJbGlJWEZrbmJZTUFLMEM4MlRzMTJNV0ZqbytmWTMzalZlMncwL1JO?=
 =?utf-8?B?SXdncTNNbWhvdFNrNU5YdmhIK0VKOXNMMk9pbzJiS3VVZmhUbkwxUGZRRkRP?=
 =?utf-8?B?ZStkY1ZyZU1QK2Frc0dWOG1lWFRkbTA2V2VxMGFrR0lhYkpSQ1I2WlBTUlJM?=
 =?utf-8?B?dWtFcS8yUEpWSUc5U0FxNEpjamFTUDdIc21pcGFubWh4T3llNmsxZ3RhczJa?=
 =?utf-8?B?QXFCTnVRdEgwYlF4ZHh4TzdkekZTYXZtM3dSanRXS1BnamVXaXpzN0o5MUw4?=
 =?utf-8?B?dEl3ZUJVTTl2djhabVo1QU1LRDRrcjZOMTh0TlpoT2RKUWxlMko5bkI3SExB?=
 =?utf-8?B?SkVha1JpUjAxWDBHYU9QekhhYXdtZmk3M0hPak96dEtJK2NHeGI5cVdPWUwr?=
 =?utf-8?B?MmVOYzl3MDN5L29FczhqTWlVbFlFd1k3dDljSkxJSGw0azk4cE5GN2xKeGZk?=
 =?utf-8?B?TkZTNFNjbHFOWFNaamRvR3Z4bFhtVHRUcXhXaTZmR3kwTzAxK3VEcjd3b2hN?=
 =?utf-8?B?Z1BDTzltbExvU3drTHo3NHFRY29vbDBnZlE4VVIxZk9zVWx1a3FaQml5RC9V?=
 =?utf-8?B?ajMvZ1BwNDVzNi9ybTlGeGlNM0tTVlpTWFU3UlY4ejZ4Y0d5NWpCZDRBTkJN?=
 =?utf-8?B?RWhVM01ER1Fkalc0ZlFPdnhOeGpVVTcxdTdCTWhDdE50SlVEd3EybC9hWjBs?=
 =?utf-8?B?YTBkdWhsVTJDUGJEMVhybG12eVROSGwzZW42cUdVOTBwTWsyZmk5N2FMWWNI?=
 =?utf-8?B?cnN2Nmw5K0hMUFdmdjFSd2ZyaWVoSXN6RVBTTEl1ZGx5RjZxRHk1UlQ0VUJV?=
 =?utf-8?B?UU5Hd21KQVRrdjA4SUlJampMSnFtTjFQRTBKZDYwUkFXRUpjZldsZVA0d2Z4?=
 =?utf-8?B?ZWJQMDNzeFU1UXptSlc1cXZ2bFhHaEtjRGFIVXd6b2RjWkN2UUJ4Z0pHL2tC?=
 =?utf-8?B?dGxlcXlScEgxSjFkcDhmRGNQbXBhWEVGYURFNzVxY0FKT2ZYS1hOWk9Mb2NY?=
 =?utf-8?B?ZXplODdZa3F2dTZlM1FReitVVkZvRlBsb21pR05weEpNNGZXMmgvRmxsZENB?=
 =?utf-8?B?U1NmNGs3UVZ2enhlUEY4cHFhTldpQW9zd0V3aW9GeXA0NXFEVWx3ZTB5VVFY?=
 =?utf-8?B?NXkrMXE3NUNnRGlxVVc1eWIyTGI4S2tOMVBKOEd2STFVMGxTZXR2Zm5ITHVj?=
 =?utf-8?B?R29GTHFMVzJubHEvZW5XVTZuSjhjUFlmVlVYU3JLR28yRXgrdDh1SStBZXpD?=
 =?utf-8?B?WWV3cjRRdVA0blo4SXVLYU82ZFdIWjgvV0wyRjFLa05XbjY5WTZKM0xQUWhv?=
 =?utf-8?B?UW9zWkg1RUlXSzEvWW5kN1B5VmxwdmhhY1VzYlRYbjlwanp6ejJzcmhlQUIz?=
 =?utf-8?B?dm1PT3lrYVIrdkpHQ3JiMWx6NE9wL2VpMDJ2QVFUbzltSjFkaWF3S1dlSDZm?=
 =?utf-8?B?MEkzbFlJUFZHNEtwWkhUTnRmRTgxQ1ltb2NmNnZjYkNVZUZUc0dkTEZGK3NZ?=
 =?utf-8?B?bFgrWXJqMTY1eFNVT2VuRmFwZURqOS9RMzEzWC80bkcyY0hXOVBELzU3d1dF?=
 =?utf-8?B?b1lwdFRMMmJndVk0RDhsNnRRaG54MmFnL09pblI2ekY1dXhpalYzRjVieWdF?=
 =?utf-8?B?YWs3cFRia3MzeE1HMG4wejdXUVoxOHlyb01LOXFoMUJiQzF2WkxpWFVZZXg0?=
 =?utf-8?B?Y0RPRWdjclMzUWx3SzA1RU1LNXZpT3ROYWNaUk90UytpdHdsekxPSnllcERG?=
 =?utf-8?B?RVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 2fFdBmUgKe9fERKMskRIMDC/p+H4vVFQes5TWuD7xs2aYV8Oc5wMAhfgaPMQNXaCDPTMNUhJMH2f/d+Pu1TCo4WaqieUPx0CLmjfDost+Vuwi2g3t8z7hzB5rZKL89CPieOzJgGRE/lZ6l0jADf3CrHK5LbYPyuAvnsJP06Og2XDAJaNKlIEN02XHFL8v65DUfEtY8LLoQklSrQfx7hT5BMppC2Yqd1IvZGdxSTsvA2cNFT2g5jpUNHA21A2jiK5CePizpQRUCi2q/0e0Qf1yY7zlj01vQ7PnZckim5VFGP4j+jpMjkqGT3d5bSgN02Xtx/+rmFnXZkIWDXdq0XEySNniZVJQvv4OdfKtvRJdVP/i/16cZKrqws1hk9/GV5rOrsVGi4waW02BZFBk9PvmnKsLokLGdFCwWoPsF5Rq8+YmNLXrGnY9kiwvYCObU29lk/HpaYep+058SXPOhBWP8U+z6+uP4dvYXbyWRSnCe5tEpV+3qMKjF0Lr+h+Xeg23kCUwtB8Z8d4UZW/s1YtunyBZCt1fUbkRAqgxmY+BWBC5zvp/jVKsizmy58tH9LUgIF6Dcyr1d/N+Cy4WxfAmM4uRO5JGejI/caE+vvgalozOnTqS/xRgns2cuULJG9Dxh1J0lO3GxbhsDQsdYmAVM57lduKPqdu9ATR0ujNJTo2ecGki0NciKxGxofNshk4E9hInLsUvgop9gNU7WxxeQqhdAWTPLWUGaif0nKhx9h6qo1xjJcrtemydPTg58+XtTgyKIs+3QiEP1HM2nlG1EwtPUmFKlFpqMejMGfD98ba2fhTj7+Z+X9gjPZTkaODWiwxMKug3fStwohzm1SH0g==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02cd2822-a738-413a-c073-08db0c08e87e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4581.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2023 08:21:00.7949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Acalmk2tRcwZFJ4I5TUaoTkCK0+xKiDk4rnX+ZVj8KD7gBclorkJmLw780rjJLHvPycgVtYmkEK3UHeJAGBO02CvHY60RqPMrSnyitaXhE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6741
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-11_04,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302110073
X-Proofpoint-GUID: Gw4kFvpBu-W7AY7XfabGsP9Sua91TIp0
X-Proofpoint-ORIG-GUID: Gw4kFvpBu-W7AY7XfabGsP9Sua91TIp0
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit "Fixes: 12b6fcd0ea7f" introduce that change in source code.
that's reason we are using "fixes:". back-porting that change is creating awkward manual conflict resolution.

Thanks,
Alok

On 2/11/2023 1:18 PM, Greg KH wrote:
> On Fri, Feb 10, 2023 at 09:55:22AM -0800, Alok Tiwari wrote:
>> There is no separate blank line between target_remove_from_tmr_list() and
>> transport_cmd_check_stop_to_fabric
>> As per coding-style, it is require to separate functions with one blank line.
>>
>> Fixes: 12b6fcd0ea7f ("scsi: target: core: Remove from tmr_list during LUN unlink")
>> Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
>> ---
>>   drivers/target/target_core_transport.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
>> index 5926316252eb..f1cdf78fc5ef 100644
>> --- a/drivers/target/target_core_transport.c
>> +++ b/drivers/target/target_core_transport.c
>> @@ -691,6 +691,7 @@ static void target_remove_from_tmr_list(struct se_cmd *cmd)
>>   		spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
>>   	}
>>   }
>> +
>>   /*
>>    * This function is called by the target core after the target core has
>>    * finished processing a SCSI command or SCSI TMF. Both the regular command
>> -- 
>> 2.39.1
>>
> Why is a coding style change tagged with a "fixes:" line and cc: stable?
>
> thanks,
>
> greg k-h
