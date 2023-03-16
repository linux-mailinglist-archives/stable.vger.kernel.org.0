Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0E96BDB38
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 23:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjCPWBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 18:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjCPWBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 18:01:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12266A07D;
        Thu, 16 Mar 2023 15:01:22 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GKnTsP015102;
        Thu, 16 Mar 2023 22:00:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=YADyUdvNkzTC+VQ1nxE/x8YrLcZda4BxcovfPb9XDsA=;
 b=CHKQ31L7LNT1nwovKjn7TCaLnGGcmc8CY+F71pIsuK/PqOwCsiMEZVXL1fNzJqOM0R9m
 lLrj55a8lmyk43Xm+9Jd8WGNq92BtNHUcbpqSdjgj+Zwwi95cvda6mLp/tK1TNdU/T5g
 mwxH6P6d66HRgbTe3HQ3HEf2xPkBi/TvVUQvgkod0xf+dzv22QJyW4qj6/X2bNn2vX2n
 fbTfg6+5ZXr660JiC+jxuZc013SJ4g3ndAyzDMUrdyFpcQdUtdWMJU4HatlUjrU8oSV7
 jHK6FaLr+2qIMNa90SsdlD4G0gFAjggD1RYc5mU3KBNhMVkI4uZLr1ss7N5MoFIJ4sid Zw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs29ac6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 22:00:54 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32GL4YXH036943;
        Thu, 16 Mar 2023 22:00:53 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pc01qe9wv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 22:00:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fgX1Hq3NP8gd/vNXuoiNJhQM315Gshmg+E9s04ntJ6LxgvC8vFh9Mr4DShPF8JBmSqQP3g1NH4r6fy2YFV1cPBLyXgYFQqQ9pe3kg018JtJ3K4sWs4K2eUwPLqoDhYLvyGuYnXOnaqzIemw85l/D4i0tU0uCaMFho58eC9WI+jBFn3ai0yIWI/rWJr+jhCC3xVKI9Wdcv+IWAiDUyWMR6CEeDeKNgVWPJUPbRqtzAPcuGUmGkBb/mPeqx3X5iEtaphKk5q07pv14L4llJcovsK67D3AiWE9Ehf5Rhf3FSblBkiO7BeQTsa1KuYGMkjGbNvN0r6vo+QfQ0YnGJWJ0Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YADyUdvNkzTC+VQ1nxE/x8YrLcZda4BxcovfPb9XDsA=;
 b=EQMqKcAYxkauyM/nSW5g7j6BTd5cLviSSzVytCPtGXQJ0t0Nh6naqGoZjFVhctjjJZzrb47yJZINDV0FUr2iQVy3qGCaCqBypEVQX6x0p4nP+PUfXjO3yMm6v5HvX+RS4urn0rgncCpwjfrGx3BezwGC5sHQJ4jxfU82Mv2snvMLzx1K89b4UClUbuvy2tdXxU1TsS7eQM5N3kGCBNbthHAjp5D3pLL51vNUS0qwpDbmW0eYv6WJsKNx/jx+IN9pKqBkXbu629XU/OCIEUVClfLgA/tYgrKHnkCHbqKH/y5vyDD95TdJ9FVyx6Wod+0xhuEcceAGZbndh/762+JK4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YADyUdvNkzTC+VQ1nxE/x8YrLcZda4BxcovfPb9XDsA=;
 b=Bs46m4jnu24kbhFFa/qX/qcKbHgIIaeilCsuZeXavUEW+Up0vqlm3tNvZ7Rt1QwV6bbjvGFs2wahL6nk3mEIWHmNsmNv+OmxLXGUaYYVTCFQLSXdzcxvKnIq9B7o1jRTDKZK0z3VaiiGBcjPPcdY5RCFMk2pHUt+UlWYEYGCJ/c=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CH0PR10MB5051.namprd10.prod.outlook.com (2603:10b6:610:c5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 22:00:51 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6178.026; Thu, 16 Mar 2023
 22:00:51 +0000
Date:   Thu, 16 Mar 2023 16:00:45 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/91] 5.10.175-rc2 review
Message-ID: <20230316220045.uk3zhjpm7wfd6ni3@oracle.com>
References: <20230316083430.973448646@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230316083430.973448646@linuxfoundation.org>
X-ClientProxiedBy: SN1PR12CA0114.namprd12.prod.outlook.com
 (2603:10b6:802:21::49) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CH0PR10MB5051:EE_
X-MS-Office365-Filtering-Correlation-Id: e5348a78-0ab0-44c1-ef26-08db2669e74f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3fcIw/okcgKezsHFTwhEWRuZDiGxwvS07H9h11pf0PYJJVopllIGFQlc3diQQYR1OIX1owBhFQibDc4FlRPXYZgPOZvV3wQBQpGus1i1UFT5qRD1q67lsS6y18++Jn6nVZbpTvR4LeSwHbqIG0YCYH8jwQVdc8mfdMGaJjxUsSXaDcv6B3QW0jr7zonf1t10wL0BA/306v6xfevppK3mEVJ3whh9ffKoJh/OwCcv1UgaRHlpy1Oypy97/7pcwV+ZLlRTe8TCZpQg8licSG7hG0dQexuP/c4Elj4iDQqW7WsMR0VaX8pYEJ8g0zMdX2Y2PllRB126AfoX8KNhCSlZbBmmfRF6C4M0fBT5rOGrKvTAKrUyfpyoUTPwOaFLAgDaiDLwjROGypLSvwySE+JFHWy3DYVlfXIiMYroCDrOUf605NPZWupEtAooNtKX95RITXGbjRbYcbluTaRvfTjzJJYjtxGrT2GkKHjWDFJw2yzvbaU5/c1VRuManYefFpXT21+UC8d6PDxuXIj6uTONr2f9EH8Le4QE5L4tNDy6P/yCuTqaOP+31xat+91mclFov1Xxa0re4fJRPibnS0aPnfj6pEF7Z3VeLDbwMiCpsMEPelNIfW2NhtPzIvQkstka
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199018)(7416002)(66946007)(41300700001)(6916009)(4326008)(8676002)(66476007)(66556008)(8936002)(5660300002)(4744005)(2906002)(44832011)(36756003)(86362001)(38100700002)(26005)(186003)(6666004)(6506007)(316002)(1076003)(6512007)(6486002)(478600001)(966005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eGdObU9YSlpicXJqMWZxNkpqb1ZJSnBzaWNJeGxsWDVSUUNXY1RQa1I0M1Y0?=
 =?utf-8?B?WDB1QzAvNTRLWVdrdTdjSFNYUjJwNXdFQkZySzU5SmNQUGI4cWVVbVpNbnRU?=
 =?utf-8?B?Y0dOelJ0aFFlQXVZWGNkMXFxOFhSMC9iTjgwcFJNRmZ2SHpQcjhicFlQdFJh?=
 =?utf-8?B?bXhlM1hqbEJ5ckxBUVRSZFBzWWRXUGxOaDl1Vi85bWJiSlpLejlHb3psNXNn?=
 =?utf-8?B?OFZCZzdUbHowb2pvRU51RWxvWjdMWXR6V3NnemJYSFpaS28xcFpwYi9JNUVJ?=
 =?utf-8?B?eU1rM3pHVkdrQjJXeU1qK3NydkorS29uN3VVZmVmZkhDeDhZQUxsVWMzNXYx?=
 =?utf-8?B?dUYvTmFHVDFXWWNkYmIrUE1ReklwNWNvWXJOMURFWGJaZmVFM3FpVTRCNUUw?=
 =?utf-8?B?Vko4TlpGR1RGWWxwamdyV0VPNnRrWkJZeVVzL3d5MzRQcVBJZDBQczVYeGNU?=
 =?utf-8?B?SVF1YTNnOEFLTkRuZDJ2dU5TWGYzVEU4enF5NUNlWnN1aXA4WGVQUmtxODVy?=
 =?utf-8?B?ekp1U2hTVmZFUzArMFZGdm91SHZ6aEp0WWRzSWxhSkI0WXhiTjJNajJYWkV4?=
 =?utf-8?B?TEJCeWZiUGoxZUlMYk5PNEN1M2FUalhpQjRpVGtqSG9jZGxZOWFVSXpXL1cx?=
 =?utf-8?B?Y2VKdUxRdHRXcndyckgvZDVjQ2poVlF2V1RlMzhON3JHUFEvUDdXOHJ2dHZC?=
 =?utf-8?B?RER0Q0Qra2lkenR6KzlQSEc3V1AvNUVneWNMU1FNR0lVbTNzS2VGS0N6Vktu?=
 =?utf-8?B?T1l0TTlQTjkzL1k1ZGU1bkNNTS84SVJ5LzZrb1JaUDhEaXRSUkdoSlRXMFFq?=
 =?utf-8?B?enBIYS91WGVIRnFWVGd2bnI5UTBnR01QODRETFRwelZWZ0taWHZscTBvbjVv?=
 =?utf-8?B?T3R3VnQvTXUybmFabStCL3ZVaWdKb2JDeEdoMlYxVHZpd1gyUTZvYmN2bXY5?=
 =?utf-8?B?dys0M3J0MFNac2NGY0hIbUhKOHpabDA0S0dObWFRQWRuM1FjMmFjLzlsSGto?=
 =?utf-8?B?bkJNYWs4WFpUWThrT0FoNFQ4RlpnNXZseWthbjgwYzBIbG5SSldCRjh4Zm5j?=
 =?utf-8?B?OUR5WGdZZEJXNG1UTDUyaG42TnAyQmh5bW00d2NlMVhieTIyd01zN3NJR0Nk?=
 =?utf-8?B?dGdXcUsyYTZ4RWw3bzJURHRPUi9UN0JhTGN4Z2dBVExmU2VLV0ZKN3RBZ05W?=
 =?utf-8?B?K2xMZ1dBOFVZU3JjU1RZbFg2Zlg2RkhDZU1ucHJNV0ZnbXlRMGY0Wkd4RkpG?=
 =?utf-8?B?V3ovc1NNenFCa0taR2ZkRFkwaEVHTTA1ZkM0MElQZjVRb05MbmVjZEVzbmpY?=
 =?utf-8?B?cDJKcEN0WmpDSCtGU1B0c0h0eGl3Y2VJUVRkQzRrMmtKVWF2QUxBclZTZXAv?=
 =?utf-8?B?ekFpU1phYm1TRGM4UnUyYzkrdWk4d2FpQXJzdWlNaFpGbGtPYjhvMGEvWDNl?=
 =?utf-8?B?a0NkRU5na2Vyc1ZUeHByd05jN092enozNHdVREhTc3RzWmVCVGp4VkFyMllZ?=
 =?utf-8?B?OUZLejlZZ2tnb0lOZlV3TnJoTW1BMFJBL1ZBM2RUQWduenFRQjY2dGl6QUJn?=
 =?utf-8?B?UHdiR3hsQjY3aHFzazdyTXFwQXlCaWhuNEpUZHFrNzVuQ3liR21vNjNpSyth?=
 =?utf-8?B?VVNBSkJuY3RaV0hKZUthdjlycnYvSWdDVVBqajJvd3lrQzhSTU9nZ092b2VN?=
 =?utf-8?B?aVBJODYxZE9WTEhvWkk5RVpsZ0o5NnhHYzg3dU1zbEhsYmNYOEpJQzdxQnBJ?=
 =?utf-8?B?ZEsyM1Z3cXJjMzZPdVlQZWthODgxZmROd2hjZ2Y1clRoNHp5eGhJRkhFM0pR?=
 =?utf-8?B?LzhxTmFDblFudmFiM0JFV1lPSThiQVFRRjBxTWpWNXRsblEvVExBWDQybFA2?=
 =?utf-8?B?eUgvZmtUQk5MMUJ2WkZZZzBiTER1d2Y2dXR4Rk5TS2VXR0tYTjMyL0twTmlO?=
 =?utf-8?B?cHJ2MU5rOU05QWZtVk4zRi9xNlVEOGRFWUJrS0kyNVdudTNSdDlZYVR3VDk1?=
 =?utf-8?B?eHMzWFlRWnF3YmRVT0JaODhLTURLdVVacW5lMzVPTGR3T1NZTU1GTk0zVTBW?=
 =?utf-8?B?NHVkRW1HNWFLeUlmanExeDFCRzV1QjBEQ2RUL0FjOWpxa3hxd2h4UUwxeEIy?=
 =?utf-8?Q?VFnGgPRdkJB6pFyZ6pBbu2a5g?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VEc5Z09kK3UxK1dhYTZzOVRERklEMWFOZFVkRXZIWHRjSU16Zld1cmNicVhx?=
 =?utf-8?B?VUg4cjN3UnluUGJLUVpFaHMyVUFpVU9KR2RmZFR4M3gyVnYveEM3SFBsOXRQ?=
 =?utf-8?B?dy9LM1hlUkZuTFR5RDAvZGxJR3g4NThxTkRJSnJqTVpxZ3NCd2Z1WmpoblE3?=
 =?utf-8?B?bGJiUmNHMVNhakRVYXYrT3RWU3hVdkxZSE9MbHhxTncwYUhHY0QwN1V3ZjR6?=
 =?utf-8?B?RStwYWd1WHlybEQ1L0lrV2tzS1NsSjVxTUk1UStKbWpXTXhrbE9DWDFUN0ht?=
 =?utf-8?B?Rjh5Zmp5OGxTS3pTaFZ3SW5jdUdOWGRnL3BOYjRhN2FRRm5RK2hjUXNmazZO?=
 =?utf-8?B?NllJS2RUc1BQQkJGSnI1dEZpcDMvODRyMllaNUR3WGdRQnV3eTJNbC9qUDV4?=
 =?utf-8?B?ekZrYWRCTmlkUCtNQVVTcTAvM0VGYWMxcGhyS1Y3MVI4UkkyTkRTTUk2SDR4?=
 =?utf-8?B?OUYwR0RjL1d5YVlZVXRDQ24rckFDbTIzdE9tR2xiK2NvU3hlKzhSck15UGwv?=
 =?utf-8?B?TExQMXYzcFBjTHl5YlNPZXcxY3cvQzZUeU5yd3IxcGJYSUJobnJqWVNqY0l6?=
 =?utf-8?B?T2UyUE1ocEM2VnR0MGdtVXR4Rk5wWnFiZ0M5cVAvY1NPWUU4a2xjcDZUM1lu?=
 =?utf-8?B?SWZueHE2YnBzNW1NK3RGK1V6UmthMmFvb3FibEIwc2p3RUZqdWVRaHMxZUwz?=
 =?utf-8?B?aGZ5WkRCbHdTdlhGRUp2aktDVWE5WVUwdnIwU2dDSWxRQ204eGJvVWw3aHFP?=
 =?utf-8?B?Vm9QY2J6UzNlcVptL3N1VGpzWUJCdXRoRUhwdmRvOWc0ZTUxb3dzcGlyajhn?=
 =?utf-8?B?M2tnWkpkSkFjb0FZRUNCWW1NRitBTWR1VHJEeUR2em5tc2drZE1aRzZWVjRL?=
 =?utf-8?B?WWFaK01hMlc4cWFyaXhGVkJmWTRlRHRMSnVOS0RTVzFGVjhMNkJMZnBOeUxw?=
 =?utf-8?B?NHI3b2p6emc3RHRJSW5GTXJnWW1sOEZVVk1pWUJPYm5icVl4cDZnNTlZeHVr?=
 =?utf-8?B?U1Y2bFNLYks0bXJ0MFpMUnlTQTJBRXBkNURmNGFiYmdVd1haVVczcSs4ZUlC?=
 =?utf-8?B?cTRvRVh6a1FUcjgzT2NMTUJDN2o4VE5ySXJUaFA0UmMxM1R1M2ZIY0k0c214?=
 =?utf-8?B?T0FkRkgxQWozaHJFT3NsUk4zU0tFSmhZd0U5ekwzSm5VcGMwcXVOdHZDMUZn?=
 =?utf-8?B?MXlPUmVYeEhiMUd2SGtTYTlaWDFaek16cTE4VUNta1BobWFLRU1ONnhveU1R?=
 =?utf-8?B?bDBxTjBoQUFuS0hwSm4yWHhPVElDMkordHJqcVhiWkdnNDhrVmlsNTJMSXda?=
 =?utf-8?B?SkExQkJiV2d6NUxtdk1iYlJybTExZXN2SnRiaUw1RHVEOWRPTzBGTXlDMjh1?=
 =?utf-8?B?UU1LQWhsMDNjc0Z5Y2ozSFFiSWllcGpmTUZhUHlkZ2FhN1FGbWplVXZvVFd6?=
 =?utf-8?B?V3cxQXFtazFGVHl3dnVuSTJwV3FTL0NRTVdHcFNDVkxwaklzSnpNSjl1K0M5?=
 =?utf-8?B?dW4wNXBrRklZQzkvYjBPeGx1QlZza29GcG5Zd0hCYVB6ZzJhS0YxaGdGVHI4?=
 =?utf-8?Q?E0e4vta1I35cd4DLa1/QDjq2oB3QmfQGwtbBIs9OxpXbRT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5348a78-0ab0-44c1-ef26-08db2669e74f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 22:00:50.8815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +/7irKD5Vs7WiYS49Hjpx5EvZcGn0lHEyUmzjLiORi+aIOaMLvdrVp74wKnGXMi46hKrZ9wwmn1PkNSUl1hgVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5051
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_14,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=961 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303160164
X-Proofpoint-GUID: 8DPtN_53w7UzPKRDzD26kWlIjSJ7a-_M
X-Proofpoint-ORIG-GUID: 8DPtN_53w7UzPKRDzD26kWlIjSJ7a-_M
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 16, 2023 at 09:50:03AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.175 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.175-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
Build ID for arm64 is back with CONFIG_MODVERSIONS=y
Hooray!

Tested-by: Tom Saeger <tom.saeger@oracle.com>
