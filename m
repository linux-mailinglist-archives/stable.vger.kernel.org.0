Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98AC66BD963
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 20:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjCPTh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 15:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPTh5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 15:37:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5102A4B810;
        Thu, 16 Mar 2023 12:37:56 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GIiOTa004502;
        Thu, 16 Mar 2023 19:37:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=pLwOfvTcvO/oEJpqkIKGxa5hEJCPJKitMV97maf5qas=;
 b=He2MG5txsRvWActJ+v+bMoRMr0PuRB8z4Obpx82VK5V7EBzAsZRbJTH8ZRZhcJZeJmn5
 R5/lKH0sy7SaEy5B/ba77rP4qJyrLheDmx0RycJOaGQEi8fPwf8N/gMzwrVr+al4FrMK
 Acq3ZSXukC45SzQHt/4LJJJMMDzOgtqfBLZgwJIRH6FUJmoN2MpPN9CnV+9OoAZhNtzi
 TNWrdRnUEZ41xtRM6VAmqEi6/kQYkrTLCXafzFNEvRkt0N2nnfjxpN6NqmsiJIAOQrKU
 RXRIIEIOc+9kuKF8/V3YPCqOYmofCesTD3xhnaP1YJQReqM37dBv0jYLyo7Uv7rwEh87 Ww== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs2aj31k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 19:37:18 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32GHuO54020445;
        Thu, 16 Mar 2023 19:37:17 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq46t99g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 19:37:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBHD05KTRU/kGzsncq2ke3llWesj401srH/oQSDfp4bd1SHwWIiCgfGesdQR9x41rhGvA1YdAyLQcGBKsxKe/wnglbUQxFsOuZzEk0ngoRM81qegFP/XGFb44IHrE+2Fpmnksp7mbcWK5F3jiYuuzZXFOjquSmy4fbIY1xkFCI9JQL5Idc3DKu9LGa/heu/lydxq4dix6wVHmJeFnkkCehsdmWAig3FMtOwYD8mIjaR9ByjUmLp9QrmHtZ3kKlAxA/m50mzSDdSEDXxhmJrESL9l5zTFHZa4ZDnea6/zbE5k+PYWHYM6ODpDp0rfJCiQI7OO7oVsl7hvy+KhTHapYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pLwOfvTcvO/oEJpqkIKGxa5hEJCPJKitMV97maf5qas=;
 b=CEis6UUESN2n3i6jj05uZWLdmR3tcxmcU100RZ336EEbH7tUe9hWDLeVUE8yKhy0+TZjQEk0LjnOq6oV1WV0+IEFLCbhEft0tSCwBMC3d7qmeeAjorlRuAH9uvO0bfeieX7y2zHhpxSKxuJYTetrqvhC/l9aYfG0bFMkmPND/cLAIEUVk59AkSw/B1pdJ9OngziEVVWyezi85HmrJ/EVgkZeJ4/E/vsAWilsxRf4rl7sty8SfyWsBmwOEpPTFhg1lrJAkNRKAkxXiElH5LKXLBo658lJx6ZR4MrCvuays9yrm+dBffi6QfeeGhnBH0wk8yMtDjs3zEQ4n92/vxY/Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLwOfvTcvO/oEJpqkIKGxa5hEJCPJKitMV97maf5qas=;
 b=NksEh6JzsrbUEzUDFNM943fO/wVd1k4WRWfF0R5RnwKZ2sXU9ZSpnRY/XWIod1Pw18CkFFjmHnujeej6X5WJJtxrk0AH8kon8PCjqnA5YH8lahqn/uMoan00bIiSXDUI03h+RaJh7goX3sW2IYzcK9fw4Q6tDn1YJ1o8k6KU2AI=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SN7PR10MB6406.namprd10.prod.outlook.com (2603:10b6:806:26a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 19:37:15 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6178.026; Thu, 16 Mar 2023
 19:37:15 +0000
Date:   Thu, 16 Mar 2023 13:37:11 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/137] 5.15.103-rc2 review
Message-ID: <20230316193711.s4cwpbcayg24zv5l@oracle.com>
References: <20230316083443.411936182@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230316083443.411936182@linuxfoundation.org>
X-ClientProxiedBy: BYAPR05CA0099.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::40) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SN7PR10MB6406:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a4d73dc-f3b2-48e7-31db-08db2655d859
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qGHtEiuOc/N+KLCLPRgOZ0govEsP7PIru7+XJVz0NT+jlkQejNGpkCPdKh6b1ZRW4D71+AVhQ//rlJswwX+I6b4AMxaxRx1uWTxjvuYTmwDb1K5eoFTMJ5uEt5b+llMilbgREdSv4Hy652Bsa1CsXMIJwEu1co66UCQxkgtx/6EjvsjSZJeOJjlUxdN1rNXOk8TlWCfZMvZ+nADHQGrJGSTC9bkCcQFJBvTZioidu71aL7gJG9iqnLzhkL5KSW9R3kPk8pEZSqH8xte1JVHH5UHUd7aPIYqJrlYr+Y/Nvw2oHwDZ3j+FR28i5/ZSS2ipJPecY4hSaW1fY8MimAuH1TDwHwxupVvglUDlj0Wtsbv6lpqtjJl6r9WXcbytNGSYuzM3nj3nzZ/4PosZdoC3iRmX1XVr6UQp25YVo+k+tZO1IE6cr7a1U1hKuJrieWm/ro7CGk1DBvjpFp36qmBXSxhjUYlFJsU7ZvTxUK+TfSpbaLHq/jlFNhbTaCwt+V53j39uj7F8liBhf2Yf8v8MNp0hF1WKFEx1z9kT2zqCQYE1i2STPyQfpExazyf6kduwEzWqiaFxq7zwXDngYfnWQt1pP6/hFH8+HwUV02Pow4M/LPLuqorYHURoVBBLce07
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199018)(41300700001)(5660300002)(4744005)(8936002)(7416002)(2906002)(44832011)(38100700002)(86362001)(36756003)(478600001)(6916009)(8676002)(966005)(6486002)(6666004)(66476007)(66556008)(66946007)(2616005)(4326008)(316002)(186003)(6512007)(1076003)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXhybm1hdGFzV3BJaTZzcWJrUWVLdGtiU2I4eVlxQ3g2a0FMV05MbXNjNkxt?=
 =?utf-8?B?c2hFVmdnSUlQV3QwRXJ3K0wyS29oNENXczBvYnB0ZXIxWUw3NUhER3JHSW9o?=
 =?utf-8?B?UElhcUxEUmlGOEdCUnR2czRFMDE1QnRuNnErOERuMXprMHhiS3A5emZoamtz?=
 =?utf-8?B?VmFpcDZtRzBYRHI0dDltSnRxaXZzK0xNcjZaVUs4clBiNmkwQ2FjcEZtRi9I?=
 =?utf-8?B?WjA2bWZLWDhmRThpU1V3bWV5U0FOUjBnbXBQdXY2V0ZFNU51dnlHV3I3NWVI?=
 =?utf-8?B?MGx5WFFRWHRLeHduc1dIVkdMOTRUaytrcXB6RGFLWU5mbm9UbU1KUXVaQ2Yv?=
 =?utf-8?B?eExOVThvMjFkVlNVWDJvcDJTTGpMcm5QUzlhb3JBanY1VkVaZGc4b05aTkF0?=
 =?utf-8?B?cWhBYTJyWmdITGJoSWpkeFhUUk55T0RvVHhRSDk5T2thK3d3SXpuMDZzekFI?=
 =?utf-8?B?cEhQWks3SGgzQzdHci9QdWhVZ0M2NVBMV0d0QVppNEIwRVp0cjlNUXJ4SWw4?=
 =?utf-8?B?Q3p2S2hpRTlKVWpIYk9XMXR3bE9mSUR6dDBuQjVFaTUxL0VlTVQyRGdJU0c4?=
 =?utf-8?B?WWNCTDlKdmZlWStLR1hHZTZMSVRIeHdYWTUzMHg2V2dsWldOQ0thSm5pZFg4?=
 =?utf-8?B?ZEJVaG5NTldQNGZ1STA5L1VzemRmUjFVem5SOGs4V1BTNTE4eXhmSmoySGVH?=
 =?utf-8?B?RDd6MmY2Q3hUcEI4amF3RmFGaGMzeWdRVGZLWnZrYWFEcWcxUTA1WWYrTkdB?=
 =?utf-8?B?NVJ0elJrRE9KbmNXbk9Yc3dmY2dqR1dtc1l5bFNjSVl6L2Rocno5QlVmOWIv?=
 =?utf-8?B?VFJQalgwNTNyNWR4bkZEZ1AvWkJxNFdLSXY0SjBTYkp6T0lXTXlYNU9lUmdJ?=
 =?utf-8?B?blQrZGpDZ1ZxcjRETElZNFBQN09ubEwyRUxJOFBSMUN1ci9DWlVBZjBEOXZm?=
 =?utf-8?B?V0lhU3JIKytZWmhGTVVtOFowclhiZ2FnUU9WWExScUdxNm9leGlZZUhDUW5q?=
 =?utf-8?B?L3o2dS8zcUt2V3V6NHA5MWY2alJBQkh4L0xSSXk5T2JZMDlGV3AvRnpuNm85?=
 =?utf-8?B?TGtHY3lBUG0wZGFmVDhtUEpSc081aTFTOWNWajhybDlEZjcyOWNGaHNxa2pi?=
 =?utf-8?B?SWdSODlYY1d5WS9nM0ZGbXZEMktxbnRIYkE4UXQrd1Z4NFhTL3RCR01lbHZ5?=
 =?utf-8?B?bDcrOFpFazdyOXFrZFJLd1F0R3BNRlFSa0ZRWjl1NHRkdWZlN2lML2M5QXlH?=
 =?utf-8?B?VDlnNlptNEFDUE1KenAyN3FuWmxPWWFNc1paaEtSWVRmNjJOWEQxa2hNWkFE?=
 =?utf-8?B?Z3UvTk1oVStoamhMelpKbVVVTE1GeVViK05uWXMzRFUxakpxcklIQ0VkMXhj?=
 =?utf-8?B?UUc5Z3h5K3ltQnVuUG16QmVWZFQvaElNWG84RnBJb3Z4eS9IWFRWaWdsV1NS?=
 =?utf-8?B?R1UxWTgvMEsra3dRMjBqc29ERm5KTEVEbWxpSWFUWCs5V2VqY1dsS1FmMk9X?=
 =?utf-8?B?ZTRIUkd4dHdETmFQQWVYZmRLKzlJd29sVkNwejFsT0gzRzkxZnM3QXZOSzg2?=
 =?utf-8?B?bHJrK0lwR0VCQml4Q0lzSCs2cDhKbENudlFkZU85UXFhUmRJZFNaMFI0UVdR?=
 =?utf-8?B?ZDVmTWFQditLYXVTMWVQRzA5MmhVZk8xS041VTZ0YWhya0Q3VG9KaHlFWWtX?=
 =?utf-8?B?dTNlU3NnY2VsWjlCLzg5UDV6NTlNV0ZnaisyS3JJZU1KR0hXNFRUV2NRQXJM?=
 =?utf-8?B?eHdEV2hiUkpXTnlYbkIvME04MzlERFdHeWhkZ2VKV2huMi9zYUc0dW9FQzBx?=
 =?utf-8?B?V1VTWW5vWnBpQW9FNHM1dU1UQzEwQ3F0UFBIWWFtSEpoWVJRM1puM1RQQlFZ?=
 =?utf-8?B?WjRrc2xSM1lDSjdBdVBITUZLSmFyQXFiQjBwcmJ5Q1JEVHBPMitxMGJLVGdx?=
 =?utf-8?B?TmZCUjl1RS94MVRGY2Frbkh1ci9YMXJMYzdzMVRxR3pxMXcvL1M5V2dTS0o4?=
 =?utf-8?B?N1dlN1R2RDhWWGhGWHZsQmkwQ0t4YXJQMTFEcGQwWGtZaXZZUlY3VFo3Mm5t?=
 =?utf-8?B?eXFVRmNuNityY1YzMmhTMGp3UDNoNnRmR2FFYWEvSXZudUJPR0tGczdwenh5?=
 =?utf-8?Q?UKA49SVyImsYYnzeZSCo/g6vz?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?S0tOckRJNVovT2JBUEJZUUZTVDU5ZVpFUHdLbXpOWEc0ZHhUbHhTQmI0WnNw?=
 =?utf-8?B?MWc3aHRNZmNGYW95aEw0bXpPZ1RZcUN4UzhPcGxOT0RVdEFSZWpEOG94ODcw?=
 =?utf-8?B?S2JmNFEzaWJtYmMyRHpGb2RTMnZ6aGd1ZkhyMkN4UmwrYW50T3JxS2FHZnpv?=
 =?utf-8?B?RjAzTkZJRFQrTFNjb25NMzE0eXlCVHViVi9GeTExTHE5VlBJRW4rVmVVOW1k?=
 =?utf-8?B?ckJDOUFMM2NyNmlYWFJHYmNzbDgrY0V6ZnlSUmdiQTJJSlF4dEhZSkpVRjha?=
 =?utf-8?B?TkJHMUhNdjc1YmhKOEt2MW9aa1FQS0VudGhjdmNBOG9zazg3SGM3dGRXeUVF?=
 =?utf-8?B?R0xsVG1OanRGRW9vRmdQNm5ZQU1wU1ZwVXRXYmdQWVdwTmIwZTR1Vk1VUkkz?=
 =?utf-8?B?bFdRZTNIRi9YOFU3U1BFdnZGemQ4aHN2TDl5U1JCNjBKcUIxdng4L2ZHL2ZQ?=
 =?utf-8?B?Q0owWERBUnNrQjYxUytDOWxGQ3I0VTFkU2tRSHBZZmZCSmRRdnBDd3hEa2o2?=
 =?utf-8?B?M3ZrYm5ycDgrdlg4cWgyOExHT0xOczZoWU4xUUt2ZVplQWhuVTBmS0loSVpD?=
 =?utf-8?B?RnAyTVc5ckF5QW9jRDRzT2hhczhVN1YwWmVsanAzOGs5RXAwbWg2cXNzRzY1?=
 =?utf-8?B?cVBWbC9rdktJSHUxYTNFalF4VFRGMXljMmRCSGF2RnBudzNOS29tNDNGWkFZ?=
 =?utf-8?B?dVRBZXpleVllbG9PZjBENWRwYWpyTlNDNmhGYTJXdXF5UWhRbnZqSnR0eU5y?=
 =?utf-8?B?dWFSVlU4dDMvK0FNaEtnclBCRnI0SXp5ekxNOXNwby83Rk05NnFLN2J2bnpv?=
 =?utf-8?B?OW5rTi81V21XeERpdmlTUDlvdkYzR1FKS1FoT080NmdFdmZ0VlVjbG5LSTlV?=
 =?utf-8?B?eTRKSFZKRXB2NlBpRmxWY1RaclYzdXBIaVlkMThjSzUvOHVaKyt1Z01BdHBs?=
 =?utf-8?B?cmQyV0RmMXlvM1Rtc0dOdk5TQXZKS1BlSU1tMjc0Um5PZEZDVWxXNTN1SU5W?=
 =?utf-8?B?VEJ2OHBRaGRjSktLNWVHaTFJU3dFNjZadG1qd0xnUm5OS0F3UjhSMGI0TXY3?=
 =?utf-8?B?KzFGNnBlT3ZiMVk2a3VYaVcvNUFxTFkzOEpTVWpNZzhQSVdVU0s1Zmp4dXo1?=
 =?utf-8?B?MHcvRVhoeU5HRUlWc0pIa05TN25JbFd3REl4R2lkWXRjY1Q3UGFicEp4SE5k?=
 =?utf-8?B?Qm1hRU95SVZSRGI1eGFFVDZ0ZzJQYXZpNTdKVk1DcUROYW1pS25tV2ZXMXZ0?=
 =?utf-8?B?UFhsdVB1VkpaUS9UVGNNVjdva0dlR2tRWVdTckYvL1gwWEhQV1BFdGxRWmJD?=
 =?utf-8?B?ZVp0eGorR281MklrK2RBMzBtTDJFQjRqVGpHODhibTArR0g1QjdUOEd6bkt5?=
 =?utf-8?B?MWpza1VxWlR3MXNZYWNPMldRNDEremdpV1ppa1VJL0NXS3NtT2NKSWtZc0pG?=
 =?utf-8?B?Skp0VWJ0d0VBYnZsSXhYcjhZejB5c3BBL1pubHBGRWluQTVBS0ppLzJmZmJz?=
 =?utf-8?B?RHFEeHBjT0k0SjNJTWtNcUJTd0xXQTFtSEhLWEV2Q1dRTlo1QlpEU3NTcnNm?=
 =?utf-8?Q?NEJUqzgMDpxEOQS5PIENoq8Z9Qbh/mnPpy4WkXqn1xokQj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a4d73dc-f3b2-48e7-31db-08db2655d859
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 19:37:15.2012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9/wKWPmWUQTyW9yN+DmcEyyYiMoWkUbp4l7i0xZ3cbzTjk5SXIWPowPdyfBPOARzGnu26Cd9sao6xyyiGiYqTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6406
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_12,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=961 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303160148
X-Proofpoint-GUID: suPy4_ZITr9EJ741wJPN8xZrezxtS8NM
X-Proofpoint-ORIG-GUID: suPy4_ZITr9EJ741wJPN8xZrezxtS8NM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 16, 2023 at 09:50:12AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.103 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.103-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Build ID for arm64 is back with CONFIG_MODVERSIONS=y
Hooray!

Tested-by: Tom Saeger <tom.saeger@oracle.com>
