Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3526543FA
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 16:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235450AbiLVPLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 10:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbiLVPKz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 10:10:55 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2075.outbound.protection.outlook.com [40.107.96.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FB03135A
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 07:08:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8aRoTQxjbZvv3GP+VDLDGEqf31ZsB4MJPxzXQ6YTf+RGe8phEyeOPUPzLWUE1YD1UxzuIK8eNJ2s+1ZlwMOu8bGQY0Bgj5elweuk3TT/xFvvJq/W3Qra1j4niqUbC+ba/yo0GMAmDYS3SI/u8BnHvRiowq6Owwwwkqc7o4ZYouhEDufuIX0MZdtLaa4NR7liDf85HubScVrIfwIE+TjvAgkkW3m4G8D5yhMvEVNW7QuV3k/eq1TZUVQ4K6E+IoHeTWT7xpiWbvQ5VQ5gHPpIDl3zAd1Blw85h//Xx3+c0uvoOy6yVTZbmbMBrjoxClp5rEFm5NVddN+KolKVmG67Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Fv9lbjlWVnd8mejVrUVkRCAb+utyy/tipa8k5aWjSg=;
 b=jFdS7hPHaAmM1RBI5Mgd2KqqddmEdqOwjwe2hRNC3c4hiJxwmpseXWwSM6Rj37sGWfHUsryMgBhVpRzmO3lpWoKmuSvsIvwRrMIk4eqLx6NrMVUIZc06b4o4JjkwLOSMhQVb24WJpGPsfcYfRr6hAlRUXdJF7EQsb2Cig2jvXJMEzH5qgAU5fE3YwxGoHF4H649GBf/I2mEyImCHwKpLY7H6sH9TkjgSYJ+arIhTB7HdpksQ52SWQqjDqwl0F+tv51JHLY3QyviTKR0cX8M2MKLt7f4Io9ms47UpQDW1IFDSGd1ILc6wqLJpqeDwKd5VSiX+5Zxf/1JNaw6Lz5yTRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Fv9lbjlWVnd8mejVrUVkRCAb+utyy/tipa8k5aWjSg=;
 b=GWtwr0swFFcIbiSg7GCryyK9OzhDZIWjOLFGYrlQYrweJBwFJvP0Gy6WrPFnEOUcCYyTuDiLbd4eFVznHi5kvLNDYyc24YwQx5UF4zYulZZTaosYqlsX02XQm6Nax8yxCiaCpp3NdqY/ZTeIFUG8uPRbnFbHfpArf3jGCkW1/vI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by MW4PR12MB7016.namprd12.prod.outlook.com (2603:10b6:303:218::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Thu, 22 Dec
 2022 15:08:50 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a%4]) with mapi id 15.20.5924.016; Thu, 22 Dec 2022
 15:08:50 +0000
Message-ID: <5e38dcba-aba7-d461-6027-20cb346508bc@amd.com>
Date:   Thu, 22 Dec 2022 09:08:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   Mario Limonciello <mario.limonciello@amd.com>
Subject: Fix for W6400 hang
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0058.namprd13.prod.outlook.com
 (2603:10b6:806:22::33) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|MW4PR12MB7016:EE_
X-MS-Office365-Filtering-Correlation-Id: 9781dfdb-b343-46f3-1e08-08dae42e6ec0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YO/sWKExcBI3GCvoEC309SfumpLBnElnDbodZ0DKi/MTjkuZFcclbkg8xh1DoPQQ9oUXUIxkbVTebs8+42Yb+T4CQW7bMh5OOM7p3qOUA05gh/YIaZ3sQkV182DjUkU2rTSajc1i0akGHMuM5Z+XEPxkEtea4RmInE4MIlSeTTj4k8E/QlxOa+aDA+4Xi9DxeyrgJ4VRbXsIaSmko1E8A0NLMY+FMoWXBkzty7b7KnhnnvCXvgxQR5opDT0mQgm22/YcxHCZyDUVEqRB3E55GNRj3M71+EboPgx564GcbCvCj/ddLEm09BTV749c6cIX9EW+dzXWpwP5SogkosurhueP+YsQLi52v5Q5kUj4jFnWV/jxGCmVDqpqupsWvOtnCr7YSTx5M6Bly89ar0spkTGIVwZpQrSaQcNfNcb89Brtht35m1lgcvcmQ6JKotfcr0VKQ7VceI4XyO9YIyQvCa4MWFaHDiEdJEJxKlHUX8kfediOIuWt+gPsZ5ljb7SmEx31qkXQ3IWccw0+VXnIR8rGydi95zPLM0mdAm13QnTTBOUEFJWhoeXE9QdvnIbfbvfsAkmAhvYzvXCDvvOk3VyPW3UvUSSbIrTDRnqS7MWgMnZzPKYzMZIK5PmJU3+6bWAwrtN/6Ifq7AfnaxWme66Z0xPx7ZBFc+2SZsezTcW4g/6ldyxEPkfyPQRWdM63c+4AdyLMCGxobOFjSMTV5PwchgYnZMHtW4zqgm3Fto6v+vLNs1Vr6x56HWjq/rrynPscq8y0FjqAy2/8IY71uA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(451199015)(8676002)(83380400001)(4744005)(44832011)(8936002)(2906002)(5660300002)(38100700002)(41300700001)(6506007)(36756003)(478600001)(6486002)(966005)(6916009)(316002)(86362001)(31696002)(2616005)(66946007)(66476007)(31686004)(66556008)(6512007)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXFLdmY4ZUVnOEZab3lDTEN1Z0x6VHNGcTFxWUNMemdISm1rdklZVVFxL1RT?=
 =?utf-8?B?cWEyL0QvUUlIcitDZGNPRGR4eC8xV3M1NS93VnF0U3FRS2xPWTYyMFF1VW5E?=
 =?utf-8?B?c0ovalFBbTYvdlp3YVEwZ2hIL21jck5yaDVhcVkwcVNsRWJaV1dYSmJXK25I?=
 =?utf-8?B?MjJ2akxkcFRUM2h2ZHRJeXF2V0IrSzhLdElFV0JlRlk3QmZYU3haVnhUZm5X?=
 =?utf-8?B?QXRkVlNRaTN6WVQ3dkF5U2FjUWdhM2s4YlpubTlYUXBoRGFNOFdmN2JFa3dq?=
 =?utf-8?B?UTk2RDF0U0hMMGt6TUFuU1UvOVZhTnFTeTF4WStDZjZMMnJZcURYOXVXSElT?=
 =?utf-8?B?dHJ6SHo1L3c4amxZZmFFSWFKbEZoYi9DN0pYYlBrSmFtUFJ6QnhPTUxGZld2?=
 =?utf-8?B?TnYyZWs3U3kvcUxuSGFHaDk2VUpVQ1c3dktFQW1BUVg4cmppR1dxZHhReWZD?=
 =?utf-8?B?cmJuVnFZMFE1aGdWMFZJTDZoaFk2RXBrbXNxMGNvLzFJNmk3OEpwQVNSUU1v?=
 =?utf-8?B?USs0eDNlaFM1eU1qTWI0S2dvY01jTm1hUzFqWTVuYU1aM2NkY2RpYlVEcUY4?=
 =?utf-8?B?SDhqVFFqcmc0bzNUM1Y5NWZRZTJKbHAxVS9HRlRHQmxMUDBmNW44Y0pHQUZr?=
 =?utf-8?B?dXdJcUcwZUlMakE0VnA1dWRTY3o3d0x4LzkvK1E4NWpUOWFHNmdLNVFTak5R?=
 =?utf-8?B?L0hVY3pEVmx1WndLeDNsaUp4UGx5KzV5eUpwSytQRHNmSWc2YWM4OTlUWUNE?=
 =?utf-8?B?WTdnd3dSRGUyRW5NemNwd3huOEtDM1JpM3AwR1UzRXV2NTlmcUcwTDltWlJH?=
 =?utf-8?B?ZkY3TEozUWliZmV1VWJQR0txME1kRzVsWm1yVVdscFZHNjVzV3daVkNmckNE?=
 =?utf-8?B?czZ0Wk5pd1Btbnp4SWFpNDZ0TTFySVhPRENFMnltZnpPOHVGajdxcjJpVEE1?=
 =?utf-8?B?QzVvQnZtMGJweGlha3NZaFVEVTBGWG1kSUJkVGtsOTNHcm5zZXh6REJZRVdY?=
 =?utf-8?B?L1lQem9WU2dmZU5iU3MvdkVoN2JDTzN5MlBvNlo3eUdUM0NBYlpTRWtzejU2?=
 =?utf-8?B?WDV0OWM1aTRpalMrQmYrU2lBcE0vcWdMWFdZQUNYVHBXN0k4UDFKWmt3TDhC?=
 =?utf-8?B?UE9wM2VPTTBKU1RTcjZXMkk3aTV3ZHUwNkZud1JpTStPWWtZbW85U3FXRFRZ?=
 =?utf-8?B?UENTeDRNRFBGcTZYWWtYRU4zOEQ3MWFqSnRGNDJZbjNXYURWcXhzeFBmc01P?=
 =?utf-8?B?RDZZUTRIT3RicWhweVNUam5nQ3AxaEJLU1IvRFNyM1c2b3kzWGpiZ1Q0QTZl?=
 =?utf-8?B?OEJKN1l3QjY4NzQxUktlMDBlb2lCcHFobEFHSEJJOC81dlhmMUtSSFpOdXYx?=
 =?utf-8?B?TFN3ZW16ZER4dDRGRWgyRWdOSnRVTVRuUGxnOS9hVXNkaWtmVU9wMEY2SmZC?=
 =?utf-8?B?cXdEeUNTbk55TStNTnpybGJIdzJ2aUJKNkJyY21LK0hNYU5zbUNFVi9hRVpn?=
 =?utf-8?B?dEUrTWlWdWJSVmpNaXJrRklQczVOVnRGQWszdm9CeHM4Ni9nVWFrOEJMN2ZJ?=
 =?utf-8?B?RFJadnpFMFk4Ym04L2VCYUdtRnYyVnBiNjg1UU1XWnJVakI5dng3Wjk0STV1?=
 =?utf-8?B?WXlkK3o0WWJFcVJKRVI1WG1LeWJYQ011emIxZS9YMHZTNmJ4OUJjUWJ6SkRT?=
 =?utf-8?B?T21nTVFvVFdDU3hBc09YM051emxScGplVW1mWk9zNXFRMGhwQUNHaitjSHls?=
 =?utf-8?B?V3Q3MCtjNEY5dmxENXRWeC9KY3JOK1R4UzVRdERpdDdjRkpwRGNXdmFxZmRj?=
 =?utf-8?B?dCtXK1lBZFpGdE9QYVB4WW13czlJcXJ1MnlFeEorUFdWZGRqYzJjOWEyV2NK?=
 =?utf-8?B?bjVlbnZJUUg3bUZEb3VJeFdCSmtPVjVZVGQzckd5Rk5nZlRyL1FWcHJ3V3U5?=
 =?utf-8?B?c1BNYXVIaXJjVXZQaTBvMWJUT3VIaGIwM3BoQ0dGdW4yZmg1UXZCeDZEbVdS?=
 =?utf-8?B?cEdLRWVwODNCSFhqM0dUcVhxNE1ORENGZDIrRnJWbWFvT25yWnh1VzhkTDJr?=
 =?utf-8?B?WkNZQnZkR1BPVWp0S3grRk1tcmV3RFIxN09DOGFyNjlVcUE3alhNTGRiRlQz?=
 =?utf-8?B?STRULzVBMVdaSzRrVE02RDBpa0U4WUlrRHM5TVhla1htTVoxdkNzZTQ4YzIw?=
 =?utf-8?Q?WlJpmwnS4SeA0+2IF0G94IGmyk3wJG1p4wJFHe06FPqc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9781dfdb-b343-46f3-1e08-08dae42e6ec0
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2022 15:08:50.5777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QSmpW2eB0JCVC+XDqmIKhu5kKXLaM1TFPBExU1lX4lBpOcnbFJ5jG5/iSEJwHFLrIzO3gB8wCc3YWoAKuSgOiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7016
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

It was reported that on 5.15.y there are problems with S3 suspend root 
caused to a W6400 problem. [1]

These are fixed by this commit:

a9a1ac44074f ("drm/amd/display: Manually adjust strobe for DCN303")

Can you please bring it to 5.15.y?

Thanks,

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2000299
