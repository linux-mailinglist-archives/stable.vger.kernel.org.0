Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19BFD6E79DF
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 14:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbjDSMkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 08:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbjDSMj6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 08:39:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E161BD2;
        Wed, 19 Apr 2023 05:39:48 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33JBcBCo024242;
        Wed, 19 Apr 2023 12:39:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=L+0kw9g+ODI/MVdcuKdtolQD97K4QzWHT2eICbn/5Ls=;
 b=25brtlW2gfp2+nBxEBYORG54yqVSS0yfhpgf3ftgEn7ijUVMepgNPKBOCIh3FAB3wfe7
 2plHnoshpKkgZdD5khATV25y+CoRpbTWmtSlYr7D49zpDn0oqCmQRV+lps2KeCYrM1x1
 AuPQZ44MZoOzKUakABJ4v+vWEV90WX1T/qJTpsjaZbcIbFxfDn+fZJ36vVeR6b9rzTla
 Rn9l8HzuJhQ5yhGBn/rNy60EBPTL8qOjvg+BJNUvKq0aHqg9hxZ8mTr3MGbDWxYYYfRH
 UcA8KlF1NDbhfz0uQ4J1VtqKFjqyPvsI+y7NjoeSz0aFS55gFTV/TNg30iaoI0LO5qdH nQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q0768y63t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 12:39:16 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33JC714P015808;
        Wed, 19 Apr 2023 12:39:16 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjccwcx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 12:39:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9Mg+geVTQAR9jRV/xCLPrpXIHZBTGfNpflXLk8RE/uRA2grw+wCSXQaGDs8IdhkqnxoeRrQmiTyhtSUKn/XIlvqOfwTfiZTzhHvIOzI5lZskQmHXJ5ARCeT5qhajRoZD4aYvYZMXtnyLzc7XZoveOrCHsZoqurkY1GmWvd9SYrYfARRZz7KthjdqR/WysfefdB52fsTdCPBGOhR0NH/iFXeX5H6uolrVkP7w4eyNK7Om7eEGrOlZU51jboxYpWJkdNmhJyFKKgBrUhorT0eHJYqZW9CbgSkKbmz+oqJKF6LlFrAvTm5ZNWogSx3Wa3NjjLfgnXe2olhPuG90j8hfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L+0kw9g+ODI/MVdcuKdtolQD97K4QzWHT2eICbn/5Ls=;
 b=hK9o/xMKh0mppCuPzQZW9+yVSHUdAvVep+FpOj/PO1b7ZqAt1NAKnZH5J0zDYGmRB1RiLZlCITDdhBXQlfBX1TPdlmGE3QgZDnhw78Dkkuzixj2jhJ9Vy7EhixsN8END3OU1IckijAZ160LhLHhUbKJvM3cYXgLUyGGgj7D07mcf26iSAOzIYyG/YVkkWC25WNmOqIf00JIPIVF+//Kdp2iktb+jVykLCiGgMzfxw4KCrHIK+QShSPHhsw2ReOgN/1Rmyv3NhGpYoidioTCB/iSqfsjkuUwMnld2StIp6nGc/5wVZG6ITIigeG/WpxqjWooG4FcNkhMJqvWkLQJEhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+0kw9g+ODI/MVdcuKdtolQD97K4QzWHT2eICbn/5Ls=;
 b=a1zn8hUEV/XhYCnH2lacRdNEWvq00GzJ0ZUo7kX56ihwfLIiRud09gYrd5t8UmFze0lDRgnseUKFApa9a5xeQfGBOpMk9MoDdrYFOlC9WhiFzN+YaG2XvK6mEAu0jH81/93Uv6lbcyhH+LyeM/6sL4E6pOr/qagOFNGASvv/ZmQ=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by MW4PR10MB6653.namprd10.prod.outlook.com (2603:10b6:303:22e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 12:39:14 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::68c5:330c:d234:3834]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::68c5:330c:d234:3834%6]) with mapi id 15.20.6319.020; Wed, 19 Apr 2023
 12:39:14 +0000
Message-ID: <8e48f8f2-0084-a32d-87b4-a42165596447@oracle.com>
Date:   Wed, 19 Apr 2023 18:09:01 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 4.14 00/37] 4.14.313-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230418120254.687480980@linuxfoundation.org>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230418120254.687480980@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYWPR01CA0042.jpnprd01.prod.outlook.com
 (2603:1096:400:17f::13) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|MW4PR10MB6653:EE_
X-MS-Office365-Filtering-Correlation-Id: 0eb38daf-9775-4d7a-ae94-08db40d31509
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lMKp0f6O8hrNRxKAFd7i4T4pZBAtibn9L372f04sIs3yluNUHwXuioaONvZZoNAVYAkuBflcWCRee+5Zzms/kl6QrDffBGhaiY3q+butKVsOQeGv9sPg3GRLxa1BsJhwz63TrXx0sTFyzrWZXsS+DcMim3ff35x52tHx7NrbQfxreLFuU/kywiaTEYNFm+7KsH6ANksleiwetZ7md/1M/qnHSdLzzd4BKDExzCjjeEAyVXr4hqT4f6uFZ2aqN6DBXV+87F/vE79RwpxBiaVuRdoz+sTyCtb49GrRSygGlMUryZ7uV3FLF/kyL3vsXvB0LPot4BsZhsEinWb2QF0Dtx3q5GjkJLgbA/7mqG7cQBQSQww7CcJxoxSkTPMxotc8vr3hPvi1ZoRe86aAUzrkefGU3+vRv3VXSHzeGg6p345WrnBVwKI2k+nT5s+0yqqDu2jp++iGanndcm+CjKoLEWhjXgFWOfiJ50JT1p8hFSZ/PxayyKCXweAjvphLkLInK2tL7mE7atpO+ATtftBtfE6669aj1B9h7l3H0OcrweRu2RVJrYl++Xu5jkvtWLFgI/ZkKMqp+InByJ0cOBjgwza1zhbVawrjlTgX7wGAAbxxbT1koUfeMZ2zcziNrA4M/5GJhuXKBZ3PN6oNyjvSFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(396003)(136003)(376002)(451199021)(8676002)(8936002)(5660300002)(41300700001)(7416002)(31686004)(4326008)(4744005)(66556008)(316002)(66946007)(66476007)(2906002)(478600001)(31696002)(86362001)(966005)(6486002)(6666004)(38100700002)(53546011)(6506007)(186003)(6512007)(26005)(36756003)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDVFZzlwYjV2TFhEWnhaZVRJdEg0RVBkenIzNDVpM3R3Z0dmVTBWL1RXem41?=
 =?utf-8?B?VnRLcXZGb0czek1HZEMwSzZxcVNNZHZpNGc0aVJ2UFcwU2RLNVlCSkt3dGlO?=
 =?utf-8?B?YnlVT0FlTzNMcjRUSXNNYjc2VjVFSElXaU9QbVhaQ3NJMjhadXdJNDlZa29F?=
 =?utf-8?B?dzRscnhDcGduajNiSmF5WTVXMUlkd1A3Ni9MaGxHUjU1b0JqSjA3ZHlORVBN?=
 =?utf-8?B?KzVKUVZwUU0yU2NYMnd3b29xSExubnVLVTFscDFrektGblJPSkkzZjlucXRo?=
 =?utf-8?B?bm9NcWR2VnA4VUJ4V05ZVWFzTDQvT2hjdU1CZy9GREovN3VuMkRxdG0rQ3lR?=
 =?utf-8?B?eXlwc0M4V1hRRTVzQ1Y5Y2pESTNlWnRCK0xGeWRubTYyWjFtMWR0MlZJZTVn?=
 =?utf-8?B?WVVmdUpIS216RFU0MldFSVFDbzFnUGNxcit0YW1xWEFuOVBZWms1RTFuK2xS?=
 =?utf-8?B?cytvaEtQQWFZdVZqb0Y5eGR4OG1NUmxsa1oxbG1kK3BqWUkycmladFVwbnZ1?=
 =?utf-8?B?N2NCQmFza01jbW44Tkp2ditLcUtiWDZoZ21TVkU1OUdua0ZGY3o1Z1lISVpy?=
 =?utf-8?B?Rmp2Y2lBdTB0MHFNTXdhaG9QVTAvbHRIUGh3L1hzOExxRVVnQWNwMWJ3bFhG?=
 =?utf-8?B?NjBUblZpUFpsRE9VdVlQZmhxZWlRaEh4d2prNEdOenkvTS9CZ05BU21NaGRw?=
 =?utf-8?B?Z3hRL05nM042NmxsSkZIQ3ltSDFqbTRNSTkySTJTRk51Z3dWRlpRU2Q3MmM4?=
 =?utf-8?B?TFdIdVg2enYxTkxmUXJibTFqMGdxalBiTzA0NEh0QkQrc1diL2hMTkVmRmVh?=
 =?utf-8?B?MGhjcjZnV05PcHMrMFN2bStSZlQyYW9FNTVBN3d3V0poSzc0M09RTnhYUXAx?=
 =?utf-8?B?RGRvc1p6RmRUdkZMTHRHTjFjWFJjdW9kSjhyTlBQczl3NFZHRWQwZlJYNUNU?=
 =?utf-8?B?cGFmRXc5ejROQVdTdkN6akMwd2d5S2RNZjk3YVhmUXJGVUFYdmpWRGtSQlpK?=
 =?utf-8?B?UHlyY0FCZkxaeW1JMWVZcmNPRVpTMTdMVGJZUXp3cHEweXdaUUZTKy8waDZq?=
 =?utf-8?B?VW1TZTVtWVdEWGxPR2RlWVJHcVhVR1RySk01dTdOcU12UWNZeUJZNTc2dDVr?=
 =?utf-8?B?VENEaVV5YkNlSWtTbE93K2FIc1JKY3NxcU1ld1NITTljVnZLVHJ3SVl6LzdN?=
 =?utf-8?B?TS9kZWxpSkVhUEcxZkd5Wlc2RWE1M1FjbVc1UWdEUlNXVHc0TFhsK2FxbVNQ?=
 =?utf-8?B?eFBRU3czRkVlOEMyVXpuVjBwa3hXcmFzQVZsVFYzakQ3V0FSRk84RnR0WHh6?=
 =?utf-8?B?bzJkRDJRdEdrOGxmbWdHSEJqSEZuVEhkS2g2d0UzNVM1VHVsVzRGMDA4dDkr?=
 =?utf-8?B?cWR1Rzk0dGtsdm9JRnU3b3B6aXlnYmcxUEFock5TelBjSy94VWhlT2J5SVkw?=
 =?utf-8?B?d0cwVGF1SERCdzVJRnNjYVE3RGw1cU9vZTh2V0NZS1ZKVlVCYzgvL2o4cnJk?=
 =?utf-8?B?a3c2S3FqTHZxeGFBeXVvbHdHaUY3SUlLYlJtRGpZdGwyZnltVUpsVWNyMWxv?=
 =?utf-8?B?UFlCSHVmT2RuNHBiMWo5MkwyVzA1R0dkMHg0UDNVY01XWUw3S0JNMkUzYmVH?=
 =?utf-8?B?STRIYUtia2QxcEthUStublFDMDAxeVUwSzV4UEcwbXcyNDFxdjNWT0NwaWVr?=
 =?utf-8?B?alNkUEtoR1NqWFZUTzh5L1E5VEduYUlZY1dwZlhtUit3L1pvMWF0VUM2R1dB?=
 =?utf-8?B?NjhYQVV5Q0RyNFpCRVZyak5ZQ1lCNkZyYkJ4UlBOaW9MaTdVdVIxNDNpbHQz?=
 =?utf-8?B?OTlubFIycnVGZGQ1RkMybWRlTzVnbW9JOHU3bURoKzJzWGdPaWt0d3puQjls?=
 =?utf-8?B?U1FEWmFoS200Z1dCdEVpWUl5aEM3aXhmdmlFNy9GVWdDbVplT1ZOWlRNQ293?=
 =?utf-8?B?OUdnTFF2eHNSNElvNG9IaFRIL0JGT211N2RwVVJWME41WXJRM0kvakplcE9Y?=
 =?utf-8?B?K29ndGR5elBtNjdIVSs2dW5UaWZxd256WHRGbEF3dWN5YUNWdGV6K2FxT09X?=
 =?utf-8?B?b2dmQlYwVUM0QjlNNXpxU1crMWwyVy9zL2NqYVQzTHNGRTlUYzZHc2dlK3Ry?=
 =?utf-8?B?MkxsV1g3WTdReXdKaGxvN3dkcjgwUG0vQkFjSUxpck8vdFZSMmc3WHlBd2tK?=
 =?utf-8?Q?WM/4Udxr4PHqi1+/RMSGYfY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?S2JmMGRQUzRZVExlN3ovQktNaEVIc09PVmIvMkE2V29ET1FLY0pjYVViejMr?=
 =?utf-8?B?STczeUlLSkRMZ1B2RmFTVUlBb0JKbU1xZ2RNZkxKY0xZS3pDcG5QMnp4TGNW?=
 =?utf-8?B?UWRyMGg5R2tsWmc4YWR2Sy9CS3BvZmlHc3BrSU1rcEZJbUx6dGJQRUFJMnJD?=
 =?utf-8?B?UXp0TkxnOGRoR3IyZTFFbktMclVsWGVQNFBLSEpqQ0xld2JpODhJMlV6ZTdC?=
 =?utf-8?B?UWZYY014UWJYOXNhUGl0SFZJeFd6WGdybDFXVzEvSW5ZRzhyWWw1R3Y3dk1J?=
 =?utf-8?B?WjJiZkVrMUxOd0JFSkpIRHNsejV1TEZsK0pnYW5wREo2c0RRZHVFcGI5QUFR?=
 =?utf-8?B?d2tndDhrOWtUdmtoeWEyaGRzZTdKazBYd3BYRUpwZlNUd3hwT2dSLytnT3Z1?=
 =?utf-8?B?YXRsR3lOWXkweW9jUXIybnhiMzVWVE9DaGhPcFljeTI3U1lvRVVrWEVZdVNu?=
 =?utf-8?B?VHluZzBJdHZBZVB6ZTRPVjNtRDVjZ2VXN3J2cFdXblJtZjlNeU94T2Q1VmVG?=
 =?utf-8?B?dmJKdHJNdkhtNjFqZWNJaTBqdXpRR3FQUldMRFM2QXpBelR1Q21tRlFYYnB2?=
 =?utf-8?B?S2phcXBxOGgyY0tNcTUzalIvVlRpVVg5VDlsVjVpUUNKSzRCSXk3MTgybkMx?=
 =?utf-8?B?cDhFZTNJQTR3MHpFdHhCbmFSMUlTTzBaVm5RV3JwQyt2bVRjSHVmSGpPTTNV?=
 =?utf-8?B?QitqeHRuNWwrTFhjWi9MVWZLNDVDRm0wK21nVGxMNnNhVUNTWWl0SmFGeXJZ?=
 =?utf-8?B?b1k4NVZ4QVhZMHJjbkw3amtDTlhyL2lCM1ltekl1Sm5XR1FzUis1VEdid01R?=
 =?utf-8?B?WUs4OE1SbVd4VGg0QzdEVE0yLy93STgxN1RtbU1BZndXYmhIbUFlRjZaeC9R?=
 =?utf-8?B?S2p3UFFBdHpoSVNUbnkxNjFwOHBEZkRjdUcySHZQVXpkU0tablRTRnEybks5?=
 =?utf-8?B?RWx0SjJrK2ZCMHdxZW1PMUNPMWxBbHZOL0lGMisvanBUcU0yTHQreVpHbm1j?=
 =?utf-8?B?R29XRlYyM2MxK0xITjhBUnNhNUVuVmREWTcrTmoxYXFadTBTQ242SUJnM3hL?=
 =?utf-8?B?OHc0cnZGQklOZDBEdDlIQVVLSTh3V0UyVEEzMkIvQktOVURpUEdjS09xV05z?=
 =?utf-8?B?QmRzMjlFbzBrVEFLRkY5OG91eHhXdm1CQUgvMDQ2NjlNNEVGZmpzamxtYnNL?=
 =?utf-8?B?QmJmd0Z0NVNxL29aSm5lZm9GV3JabnZMMGwvUG5jckh1emU5bEF4bE9VSndL?=
 =?utf-8?B?VTR0bmNBYW1mMVVvdEEzTXNoYXY3NlIxZTQ3U0hTY3UvL1ZLbk5ZdzQzbjBu?=
 =?utf-8?B?MFlKMFQ2Z1FBblRGYU5rQlk3VWl5N0VJSTdwRWlRUXVKdEQweWthT2V4MHpS?=
 =?utf-8?B?aW9tcUh3SlpKbDJGNDh4U2JWV1NNYk5yWFl0bG8ySzVrUWh0VDJmZmp6SzZG?=
 =?utf-8?B?Ull1TTFoUUF3cGpleEdvWmN2MlNkZU9ZcnU3YXRvWU00a1Jsck9ZSTJSQ29V?=
 =?utf-8?B?TTlvY2FSYnA1bW0xTWEybjJHSWF0VWU4NkZzb1ZBaHNOdS9jQVBJLzg3bkFG?=
 =?utf-8?Q?yegQJEgK/V28IAxX/bS0c6H58orzu3MCqerJWYN+7UKdO8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eb38daf-9775-4d7a-ae94-08db40d31509
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 12:39:14.0689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8krYa/HnmZh6+yry6EfR+pPdbZ7CIiqGUz8eNdCe2GvxpcpH6WRIYYiWgU5syud155xPsGlgw3vdlEBvM+aAd8MbybgsgFYgkZJTrAvkjxbna511YfemPQ1ft3pCRdT5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_08,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=967 adultscore=0
 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304190113
X-Proofpoint-ORIG-GUID: OwG0brvqYu0gp4ae8v0Svg4oGcLkfCmC
X-Proofpoint-GUID: OwG0brvqYu0gp4ae8v0Svg4oGcLkfCmC
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 18/04/23 5:51 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.313 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

No problems seen on aarch64.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.313-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
