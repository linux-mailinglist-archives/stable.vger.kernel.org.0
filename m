Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0481E69287B
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbjBJUj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbjBJUju (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:39:50 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB8556ED2;
        Fri, 10 Feb 2023 12:39:46 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AHwuou001750;
        Fri, 10 Feb 2023 20:38:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=VhfbtTG/NUQ7wu7lNb9jypTCgn4r0UxTOdaBvnltlAo=;
 b=a9QZ1Ek8o5STVZtd+ZLp46ykPikT8bbDK1ovF+A4PA5cCAVcQBpUBsKjcg+Kpa9+d7gc
 nym6nlFNMwQ7dmMNdxoEb4lXVbRFnhngGmPu+I56/AbKQcZiSy92Kb3v+bHBPxxGtduS
 xw3hkelckykdxgzzOoErPiiUFwDHofdiEKBaIwvOUV2UN+sXoLB7PBpPNIR646cKFsdi
 IFLeg4MO5tAXY5Cep68lJ62QzIbG1G1tNEv2mq4zFYsb7nqmGyeQEvIIWD53z1ygfyNq
 z8EP2bC3esxVhBvxQ8UY+UHX7H9lNmVO22tArIN151IwVKUVhB3+8S+z+BVNZkjUxxZG KQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfdcpa2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:38:58 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJInko013716;
        Fri, 10 Feb 2023 20:38:57 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtar8sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:38:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=npVMUFpTRP0DtnYQX6YucRZ0smMD9A/oL1FNHXb+YLLoYda2fPZEZnSiKIs+7FypCwwLRjYHiGkUr09m18DwV4hkStPJityh6gzaiV+IZ+dxV8zh/AGR893qYAxgVHVLDxv6z2fVL5zcVQVCnY0e9XZishJTx2F/FJ1NkaaFe76iF1Po8eXdV8IOmrkvgxAKyfCBiCEo5gXRht29xVayInxcPlTRBNn9gKOUsR7pqQ65pJWSVyoktKQowakciwqraOgmrwZpzRtibnqbD/LA8axV410L5sEbD5sY2fRKsibNskoHLSLOmDX1531TeUjLGr9vnX4XRoT/oCIrgjcnqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VhfbtTG/NUQ7wu7lNb9jypTCgn4r0UxTOdaBvnltlAo=;
 b=VGmOdSwMsU9wrOWUBMF/7En1BMTkhHQZFGcqv0R/k2b8uZWqeGovAUImsuMeB9q5x1PeVN4HDZ01SCQvWjLWRFOA3Bzww78ipik0U8MqHkqyYblnlJS4MvmTwVooMypxzdSXt0qSCUNMVQ1p6M1N5GV5/8Q+YzeT6kFThIBo02ABJw0naGR+S/l/HubgCLzUwmhPp30EzFQQUXea9zZi1FTxnwUWhFeaNHzPnWExAMYvR2MOF7gcMmHpk6wRCbf+IrnBXGX0RU1RcyUqrkINO2mGdKYVm6MjqQmo5gHv6h7cTSRN2Glb2/26kPIl66eCgmjMLTBEe7T9dAiO0OzzgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VhfbtTG/NUQ7wu7lNb9jypTCgn4r0UxTOdaBvnltlAo=;
 b=a6z41hhLDPAwWV9chevjLJL/Ke23AKEoDzLIwY3nkDV2g5KfNdqTzTqAR4CFEDMsJMAyzn2QeOTvDhpFdSFtF2a0jrW2ahyqeZXhzVtht8DHlIiNMh0IlGdkDG/Qgqu7zMlFXwirz/7DlaAJnnzn5+V1YotDjwU9ZbHWdsneT+Q=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DS0PR10MB7522.namprd10.prod.outlook.com (2603:10b6:8:15e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Fri, 10 Feb
 2023 20:38:53 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:38:53 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 v2 4/6] powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds
Date:   Fri, 10 Feb 2023 13:38:48 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-4-v2-4-a56d1e0f5e98@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0118.namprd05.prod.outlook.com
 (2603:10b6:a03:334::33) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DS0PR10MB7522:EE_
X-MS-Office365-Filtering-Correlation-Id: 3680ada8-9084-4584-7ce3-08db0ba6d2f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tWEXd/S5tJaabiZXxQFPbXsiMYV67Ugprs1NcMccfGxVwsYhjBSUOULNSf9o1RkQ9PIZQ2LX+WHs8fBOmxQdNE4w/esMXctxJCK0EN3UEOuqjLCZlqeVGBLTWiUFtg7U/wPpcPV+h3ompfb+5OchvEoZhIWZmIMUmDaN94kGRByqalcjQlGXQf3zY40oS5Pebugp3kdtTPQJjoSZqzTVPM5vAmwZCM/LtFYi/b3yLsbwb+GcaGqfIop9YiiwDQMQl37cGoZtk3A3UmpUbs1ch4ZLVn4Ch04BmO38kZA+OiHAGCVrWNht7t4OCiGkURvZjV72Jtex0ybFyNarY5KO915ZOm2wHIhlE3EcJDFXQ7UhmzImH4zRDDiLZAB641zUE/wJWbBhVVY4X6/Vambh4V0tJxwP4gv3SFC64pOsEwQsvxeS4FAFiJTn1mPGEsgVWsZgcN+Q+XbLdrNYGgJNOd4FtOSud8Jvac+6uXrkUejRcx0aClaDEqB8niDkKq8CYOFwk0Ul9ArsuGqe2lonjfvTS+EXrOsKfPHlklGg4r54a+pK2/l2TeS+NnBAPsgWuO1OsZF3fitQ76RHWeH7dYbnwLD2e+vSHqnJoPVGEMiYLs/VqNkdRqvTBXJHsfVbGbY3MyGxduipqH2Tg6J0oiDjysDIZLZiYwS6Mm/6BzjNmkItVZ0h3xIafBJqX+oIZPTvhKHQKpMmGGxBBLfaR92aL/dGF97myxG7iLgcR80=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(396003)(136003)(366004)(346002)(451199018)(478600001)(6486002)(966005)(316002)(6512007)(186003)(5660300002)(8936002)(54906003)(6506007)(44832011)(2616005)(2906002)(7416002)(83380400001)(38100700002)(6666004)(36756003)(4326008)(8676002)(66946007)(66556008)(6916009)(66476007)(41300700001)(86362001)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3k2K2xJSUdaYlFNTU5MQzNFRFowUUl4UWtmUVVEMkYwS3Ywdm9iOXpZbUhx?=
 =?utf-8?B?bk1mdWFzZ1d1TXh1Smt6U3Z3UWF6c0xjQlJxbjlQOTl3MTZqTU5WNXZHbDJn?=
 =?utf-8?B?bUhiRGdOeEEwcUI4Q1NYYXVkd0pDOVhFR0dreCtxdE5HUSs4OWt2eWhjNWY3?=
 =?utf-8?B?dnZUVTlrTThFWmMzZEhFRWZhaUtkSDhUcHlxTUlHVE4wdWdmTHFWeXloSkpB?=
 =?utf-8?B?MC90OEx1SCswd2JDUHp0KzRLc1NuQ2loWTRjeEVWV3FjMXZPWGlGR2xVMDFo?=
 =?utf-8?B?aDZvZlRiMEN0WDZIWFN1MWFaUS9PejN1cG5zZGpCVVdjaWRWc3UzYVF4MGVG?=
 =?utf-8?B?c1dCNjFaL056R2g5RGJjNTRrZU96WmlMME1IaFVsYytGY2syWDVFSkthZndp?=
 =?utf-8?B?djNOeHNhdEpETWF2NzBMSDVNOXBtWUdXcWpvWDJxZXZyVmxJajZDRUVFTnFF?=
 =?utf-8?B?R3I0VFU0ZjRQM3hMTWpKZitHQk0vakFRZERKRytvUVZIMDFUNjFoN045Q0hl?=
 =?utf-8?B?VytJcFFaRktRWGtBdUVvbDUwRWlKS1RpWnc5K0FEdExLUG1zR1VTeDNVRHhs?=
 =?utf-8?B?TTNkNGppREUyQjlSVEFhb0hOS2JHcm5nQkM4WGlCZThGK2FNUnYrVTQ4cXdJ?=
 =?utf-8?B?b0NuU21pL004V09GdnpRdmphWGNETWpoRGVRSXE3RVZnbmZPcXh4NFZTK1Jj?=
 =?utf-8?B?cE9vVUlCV1drMTloNytRc0NaNGJsM3NBS2ZkMkhaa2lhUm1HcmNEL0pmdXgw?=
 =?utf-8?B?ZXZ3TUVxWW1NeUtIWGNabnoyYXg2bDUrNFJuS1hORXN1UmdxanFoZ2EyMkZy?=
 =?utf-8?B?WHJaN3RycVJpMm9ZUTJrR2VPbTJOY2prdmkvSzZxU3lOUU5Ba2ZaeE1kL1RF?=
 =?utf-8?B?MVZnL0lTd3lJZEo0MndhbStFbG5qdC9zbWpIVmZJeVplejhmZXZicVpmSWtp?=
 =?utf-8?B?QXl2ZFI3UVlYMkdJcnVyL1didUJaS0hsTlh3SG90cmdNV0hXM1FKUzdjNS90?=
 =?utf-8?B?bnIxNUpUSzlmUlFTZHBrMmxtNmlqZmJKelVaWGU1dGhJNkxsckpTeGNURkpZ?=
 =?utf-8?B?Ym54S1NvNm5VZmhwNmI3L3pNWkRJWHIyL0llaC93UEJ0Z2M4UUFtcEF1RlB2?=
 =?utf-8?B?ZEpzZ0xUdEI1RWRrSmNhditaVmNMRWVITDRvYjRNMXlSQXBTQ0N4b2I0WjdP?=
 =?utf-8?B?T2E5b0JMUHpkSW1JaTlxNlArS1FycHJ2clVhU2NtWEdhOWFpRnorVWhZVWMz?=
 =?utf-8?B?eXZ2S1IzaTRwNUtLUDdZb1dnTE94b2JabEFSUVRCNGVBUEFVQ2JoTnJEb3pu?=
 =?utf-8?B?TnVIVTlwVVdmK0F3a0l5OWcwM2wzWGZmUnEzMXZSSlVDNllVZXZ2MWZIRUxt?=
 =?utf-8?B?ekl3UmwxVkxrUnRYc2pVRklITzFoL3ZKYmdTazBuNGpJcktubW94UWJ5Qk03?=
 =?utf-8?B?K1Qxb3EzcU5iazgvaDEyNm1hZTViRkdLMVlyYVZvNTF1SWw5QXoyZ294ZWE3?=
 =?utf-8?B?U3B6NUhSbGpTckdtS2F5a1ozeFBuTnhCVjF4bVNUVlY1Wk1FR0tvY0Z1UnZC?=
 =?utf-8?B?Yi9JTlRvR1ZmSCtQQVV4UEoybnRBb2JYVkNCdW50dUxCSzZFQlJPNG5lMVgx?=
 =?utf-8?B?VmJFN1F0enBaVFRuczJ1RWk1eS9xZkk4RGJDRXBYQ0tYZ3U0YVB4VzNsQkVl?=
 =?utf-8?B?WXpEakc5dTRkNHQyMkZJSGVvMlh1Q3F4b200THl6Q2c0YnBqSEwyU2RJQTJt?=
 =?utf-8?B?cURSbE9EbE1pM3lLUGdLbm1meXpLWmk5aXRpMXNRd3pFR0krTEp3QjNiWEVK?=
 =?utf-8?B?UDZ1TkptcENaM0xBbk8zcmRpMTAwRHJDSmRzOVNyLzRmZnpFOTJtUkkrVHpz?=
 =?utf-8?B?VUdZRVpBamF3anA2bjVIWjRJNm5WQ3hVSkIrZTNGbGEyaGVoTWpSak9vNmpO?=
 =?utf-8?B?SFVtSGkxOU1EYllFcWNEV0lEMnJob2V4bGxOQnpPNS9yWDg5YUl4cGRLL0Zs?=
 =?utf-8?B?MGViWTg0K2Zza1A2VGpQeHdHaEM5R0FHaUNUS1B3ZjVndnNWbmN2UWxPRVZL?=
 =?utf-8?B?SnpuN1djM3FqVTFsa2QvUEVsWEFPcW5yaUUxS1ZVYklNelh3SHNqQ2tZODM5?=
 =?utf-8?B?THNRSksrTjQ3NXlheHkyU1N5dDIwSTZya3hHZXVmdzNuazlKeEhveUI2aFU5?=
 =?utf-8?Q?LZuEdMvhK1I72MZ+BP93YLg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?aXNFRDFGODUrZkVmZnZudHViTUE0RWlLTHBGUWp1VU9VUmZKM2lsUVg1UG5r?=
 =?utf-8?B?WTBiK1VUS0ZhNFFCdDhVQnRDNnBRaWRBNlVBbmU1SDJhNnZqZzltSkZWSmhG?=
 =?utf-8?B?R25EVUpSRE5NOEhYSVh2cUNxK3Z2YmJTcElKUHVIQW1EeFoyUis5MzBaamdp?=
 =?utf-8?B?Q284Qzc0bytVNGJvbHBFamRYRXRvbTVreG1mSll5MWpBL0xPZ25Fb2k5cjVl?=
 =?utf-8?B?VitBUUZaTURIN0s4cVEvM3JiKzNVVVVOTCtlNW5EY0VMV2g5Z1FPcS9BOFV6?=
 =?utf-8?B?NXJ1aWdaSElIVmFCK2ZzajI4OFoyZlZyVGVwdno4R2RHSnpDWUd2TUFFZXBX?=
 =?utf-8?B?TkpPRnIya25qTFptakNqSTlOdFhDcXQ1UkxkY2tvU1JzMFlYdHVzZ2FYUDhJ?=
 =?utf-8?B?emhwMVo3cldtWExnQkNFUDNZdk50MlhCRVczRFQxVE5XL2lSQjFKMFBidFNV?=
 =?utf-8?B?ZE5oNGw5ajBCSzZDVFh5eGpkOFI3OVpnOGpFQjl6NG55MVB3SldqQmprUDJ2?=
 =?utf-8?B?SlNKYmJsc2xTdklsUm4xTFV1OFBXdms0MDEzdC9KWnp3Ykc1Q25wNVJiWlZ6?=
 =?utf-8?B?ZGtJcHluK1dCZ2F0UjhBcU5oaWZnSGJlN3FjTkp5UFNUUTNDL2JqSW9ZcUpI?=
 =?utf-8?B?VTlGcGh4VVpCQWYxNUhRWU5nSXVWVHZTZUYwK1MxWldQK1hyVnkzYWhVQ0lX?=
 =?utf-8?B?M1o4dlhLWklGbGtLUExBbUFTaWFObkFjVjNRTEhxQU9UblhPZlBsWlNTL0Rr?=
 =?utf-8?B?VGtQVkoxRlpHcUg5L2FKVG45YmtxN2hiVWJTMTdNMjlmTWgzbGtVYzByUGVq?=
 =?utf-8?B?QlNzdGJ0Q0JlZnpPMlhoQTFEYlpsNGE3OEh1aHR5VzJ3aXJIUlcyTzI3c0tm?=
 =?utf-8?B?REdaL1QzZHk4TVB4WFNXcUYyeWFFOTZIWkJQSUtwTms0RzQ0bCs0dmR6TE5k?=
 =?utf-8?B?Z1FaazNMTUZqOWRoSG5kRkxyWm5GSlpHV3A0bmpNOUxPalV1K2hLNFVKZGdH?=
 =?utf-8?B?YVJMUE9PMWNzVXI3eGwzRGJ0b3VOaWM0MHdXTi9UaUhUUVY5Nk1INUNvRXZp?=
 =?utf-8?B?Q0lZK2V4UkkzOFdDQ0xoTWNwM0pkU0YzZkt4OFA4Vlpmd3ViMHM4Ulg2MW41?=
 =?utf-8?B?M2hiL3BwSHJibjUxc0RqdS81MXJOVjBoUDExZXVUb0phbjN3Q2ZWclQyYVJy?=
 =?utf-8?B?RTRhK2hnMURxMWRtME9Jb3RmSDFVaTBBYTFhVVlaSU9LaEtCQkRoS1RtSkFK?=
 =?utf-8?B?dHVRWHFGVTI2REtpekNCQnhyYzEwOHNjekhYTXNFYmZpRzB5RlFidENnRlVw?=
 =?utf-8?B?WkR2eHBGR0JmMVNVUytQZldpams1YUpDbUU0WmVUQkNpWGJ0ZjVuVkFjRDY5?=
 =?utf-8?B?TUhSbTlEQVIxenBvamkzaUcrMmcra05MSFdmYld2dStReEo0QnM3TC9OelBC?=
 =?utf-8?B?ellBdjNjV2drbVAzM1RORjJJVHIrN01HSHQ4bmxwVk5HMjJEaFcrcW84VlVR?=
 =?utf-8?B?Y0tCSU9uSVNHZFNEdW14Y3pFSXhDVFB2ZlJ0bzJRcm9aOTVLY05xUCs0bjEy?=
 =?utf-8?B?U1pxTXIxeDg2U2FtNkt6TU5oT0IxLzdXWlhIcjIvK2tIN08ySVZJOVlEbnIy?=
 =?utf-8?Q?+TCNxdyAhl9th1iAjpBDnDap5x29F5tXjs+wT0z1DdnA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3680ada8-9084-4584-7ce3-08db0ba6d2f6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:38:53.7559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BAd7Lys7Xvk8DD7JFzWukvsj/UFn79UJAsiTukvs6o21bNrbohZBn44zcf1b4f+wzTYxvVf8i5SvzDqOEZbEKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7522
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100176
X-Proofpoint-GUID: H3jRyuyElL_RvEclc1z4Q61ZQXGAYvfI
X-Proofpoint-ORIG-GUID: H3jRyuyElL_RvEclc1z4Q61ZQXGAYvfI
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 07b050f9290ee012a407a0f64151db902a1520f5 upstream.

Relocatable kernels must not discard relocations, they need to be
processed at runtime. As such they are included for CONFIG_RELOCATABLE
builds in the powerpc linker script (line 340).

However they are also unconditionally discarded later in the
script (line 414). Previously that worked because the earlier inclusion
superseded the discard.

However commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and
riscv") introduced an earlier use of DISCARD as part of the RO_DATA
macro (line 137). With binutils < 2.36 that causes the DISCARD
directives later in the script to be applied earlier, causing .rela* to
actually be discarded at link time, leading to build warnings and a
kernel that doesn't boot:

  ld: warning: discarding dynamic section .rela.init.rodata

Fix it by conditionally discarding .rela* only when CONFIG_RELOCATABLE
is disabled.

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Link: https://lore.kernel.org/r/20230105132349.384666-2-mpe@ellerman.id.au
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/powerpc/kernel/vmlinux.lds.S | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 4d5e1662a0ba..46dfb3701c6e 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -395,9 +395,12 @@ SECTIONS
 	DISCARDS
 	/DISCARD/ : {
 		*(*.EMB.apuinfo)
-		*(.glink .iplt .plt .rela* .comment)
+		*(.glink .iplt .plt .comment)
 		*(.gnu.version*)
 		*(.gnu.attributes)
 		*(.eh_frame)
+#ifndef CONFIG_RELOCATABLE
+		*(.rela*)
+#endif
 	}
 }

-- 
2.39.1

