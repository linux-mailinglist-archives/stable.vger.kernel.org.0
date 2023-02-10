Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F0C6927E8
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbjBJUUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbjBJUUf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:20:35 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AE6BB80;
        Fri, 10 Feb 2023 12:20:00 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AI0GNP020903;
        Fri, 10 Feb 2023 20:18:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=aM1KW8fcv9x3Lh1wkqmDnC96s4GncSh1wfFQnGb8NXs=;
 b=pRMkbVnl9jZUPG9nsEnVyp9vQQ3J3nw0cNpjTm36nO6sA1p1lYX6kJu5ZVAVvVbVTmIp
 /OFu3uRMz347DOVJDsOb+oiLDGi7YrTiokJFXbZHi7pcekIvZfuJGilabkNfX9zQ/Z3Y
 +1ZL1vwSjPZxlXOVcn3HopLKuT5c8UUxm8XkUYHBTgn8C6PcsmVfpJTBv0c8D7AVWd7g
 Z40GECzAZs4UUj3VcqGslVTdrQEKPlm6mLy0UObVibYlPX0ouwkZBoCCC8+pw2dGvA2W
 CFEsw+wpk8eeTo3eEcjdH0r6aRH0sWOAuHtCtrBsA+yKt4Xzq9ZNVr/q5BMLST8ygutN Zg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfwue4df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:18:57 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJ4KUq003058;
        Fri, 10 Feb 2023 20:18:57 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtb7gnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:18:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xa4+iGR9JZv69PSqnm+QkarefCirF4FbelCO84BQJoqOz7wxDh1LHDIQfQMgAc+HvN6stLGQ85hC5mvEJA4MFI4IzW8nzN0Lyt3aoJsJurhFpaQNtFy0JD2dhRb3fJQ2RhchsHODd9bNRa/mHlIulLjGf77tavvpQpEeszsGqiA2kqcYKQy5ivXFVTsfZdIZt/styL/5yrGQI0bJfTQmqbgVxuzJBURH1HVojleJgIqRWd6HusR8ESOqXovVS2xEU/KWGWlVnVOk22IHVFRKfgp4MTOMILA+jFfDWq0NKocDxS181mOHr5tyxwC2nql2FDA9+ZT1fL4LvGlhPD0jGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aM1KW8fcv9x3Lh1wkqmDnC96s4GncSh1wfFQnGb8NXs=;
 b=mhGGYkSAt5PE1iAhPEmtTX9c35JGDbTnXJ7VAhe8eMz12PBY89jBxwSHhkfehlwwSlYq1OI0ihVvLFCZ55JNbVRxRNGREjWZL0f6/dhLOGkvkxl3bmtJxT5lgSdVqnoDjDjimFtuwUM6NbgpX5hWM0n2aGBrfG53iKoaLSqBgBYQpCKGFCJpKANhwSRd55+AiwgvKV4+UYUImBn0eNLlcVlcQ1hAXMwucDbpENQStF10AqrAPnKgJbqS4LzAD12BFbCqKAH9hZq8VRlhceRlo38wH61txfi5lRPgZ8ZUNOJDIewylxfdSC1qpdnGp6/Fdkk7dfIPI/ymWziw15ovTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aM1KW8fcv9x3Lh1wkqmDnC96s4GncSh1wfFQnGb8NXs=;
 b=SpGGF9i+r8cZtv8NMLUmBIVoGDrP4JMlq8brshsRW0/Asjq8wHWDwFazbyVt3g/bbV9ULb+MXBAAhXnd8hOM0PHX2JHeHWOWxN6HQceHsQKVXDcm466i4Ja/cmj2gjBl3gThih0N+72iCRPclma9UPBeynCVZpGKfLWd8ErFCg4=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by PH7PR10MB6083.namprd10.prod.outlook.com (2603:10b6:510:1f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.6; Fri, 10 Feb
 2023 20:18:54 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:18:54 +0000
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
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 5.15 v2 1/5] arch: fix broken BuildID for arm64 and riscv
Date:   Fri, 10 Feb 2023 13:18:40 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-15-v2-1-6c68622745e9@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:806:130::7) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|PH7PR10MB6083:EE_
X-MS-Office365-Filtering-Correlation-Id: f469b6a3-a479-47d7-98c6-08db0ba407ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OwsHmfP5yhXlq+yX1XGwEC4FQ4rlSzZntdZFqW24mk5F/wHbtFAycO3eeKuITm8RZ+0rIDr2uqkJxjexntk3cLxhO9Yw2l03b/495VTlSVuAB8kiqe3hp+fddxDbuQP2OT81zjpePzKdae3NuRY1/1UdRCox4vqH2bmAD3ONI99MVcj0cXSlJJd54RWFm1Ihug8alIK1TbLU1msPEDdsqBQ22KSBOGMM/pteGgl+j4ndruO+Vd8ygBKn7ujqipd3FMRf6T7egOcu2qu31yEYTlN+Nu1sTL6Sk9DEkp5B1LeYWyB6kfisMEvPNN/76gW1BYuqJ2Jj1QFTKmq7IwlWtMQXKMagCrDW/uue++bnipC0a5UJMecPIaDfRLyzsNmvR/ax8f9s3bLkjHbt/w7wsIceV7s+CjNEusWB6P3YJUiDmLKTTYKb1PnO/B6Zmpdy0GAQNqobNuUWaKKrKl88ECXJ2DL2rNWpZwTsLciE/HAiMDuyOJ0DKRMfOvGQ5rOa7OOF+T2OCZ5kOigCwjx9O0sWkLVSqF9aO/aAa0PMqNipGC2AseVm0KX7uIc82wTNCuT/Rf6N+ADgjBVkakKhjz4pg8FV8Yq3nGconDrR0MnK3saUMvB4yWczeLJHVYwt9KEFDEX8/enbKYg9Q81PZDM+TWdRHK6i9Pm8V4s6pJY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(376002)(366004)(39860400002)(136003)(451199018)(86362001)(36756003)(38100700002)(6916009)(8936002)(66556008)(8676002)(7416002)(6512007)(6506007)(66946007)(4326008)(186003)(66476007)(41300700001)(44832011)(5660300002)(6666004)(478600001)(966005)(6486002)(316002)(54906003)(83380400001)(2906002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTZCaWhYVUVIZEsvS0hUcVdWMlRiVERET0trS0E1a1BoemxyS0VncjJ6d2pT?=
 =?utf-8?B?L01oSWVTMEhsS1lFMTk5c1RFSUJsWEFtc2NkWjVNOG00QkxRSXVZRVhBYVNO?=
 =?utf-8?B?K3YvbnJYMzJ4NFR2YVVONTBLYmthTS9Idndwd0NQREpGcTRBRnQzV0l6UE9n?=
 =?utf-8?B?QkJkYjdsTlFDK0FudjVoOFlEMkNUWDRuU2F0QkRyaVVDN1RwTHpJRDlvUmZL?=
 =?utf-8?B?SkJGenNnYlovUEZkYUNJTEw4bHN3NlV4RURyT2tHTS8xWjNjdWZSZDR0djFs?=
 =?utf-8?B?K1pYQ1hLazZ2OUtoVFdpdGRZcEtiOFRlbFdZV1NycXdGVldWOWFxN1RQVzRo?=
 =?utf-8?B?QkpsWnRnMC9lbFNzbTRuc21KVEFtaGswUEx1ZjZzaUx3WEhDUVZ0VVdHZC9F?=
 =?utf-8?B?ZGVmYU11czQwV2VBRmtTa1NBMk9zWk1KSDlNTitZbjZDUWJrcWRkVUNBeHJD?=
 =?utf-8?B?NVppL1pwN1F1cUUrVGZ1VlVsVllHMDBJMkF2TThudUtmK2krb0NVcVVxL0E0?=
 =?utf-8?B?Rjdnb3dCY2JTc0w5UzNGYXZ6YXdXNW1ZQWNjUEdVeGhCNlNVbklNMnpUUjRy?=
 =?utf-8?B?M0p0cWQrNS8vNkVMbHVuMEVXZTg4d0Z6c1pvNDFLVWZ3dXJZTHRQTnFnNmhH?=
 =?utf-8?B?VVFjK0pyTEkxMHJJcWM3eHFDK3plbU1uVzhMV1VpUlRqLzhha25tbHNrWlZV?=
 =?utf-8?B?b3lxRWUyQXNTd3p3MnZHOXJvRzk5SmRsN3J5Nkd2Z3ZSQ1ZRdVZaaWNmKzB5?=
 =?utf-8?B?NzJBcG8yZ3JhYlZUTVNEdXE3Qm5tUnRNZkhCVG9Pd293dUV0cUIwUXNWRzd4?=
 =?utf-8?B?b2FIczVlT0JDRWI5Zlo5K0dMMmw2L0t6aXNxTjA2RUpVcG1abXMzcE4vaTI0?=
 =?utf-8?B?cnVTUDZNdVEwSFFRUUwrWFJqdW1PRHNEcmVHbklQWEMrTFM2aldwTDN6cFVx?=
 =?utf-8?B?U3ZZQkw4TytNUVFNQ0F1MGY0T1RkeE5UT1FKWG5hZEloVVZLTkRDNVEwZEtY?=
 =?utf-8?B?ZThsbEdGb1l1ZmZHUVM1Q3pVdThXbWhhMDdCYlZUTXpldmtJSlk4bVkrcVE5?=
 =?utf-8?B?Tkg3THB6UHJVR2MwQ1dSNitsc3M4d0ZFN1FxNFdFZklSOW8zOWNDeHpFY3A0?=
 =?utf-8?B?dnd0aHZJREEvTmo1ZGVPZVNTL0dlOG5hZ1JJTHg3S0E4ZTVIaGtEdXdXcWFt?=
 =?utf-8?B?ckthM3hRTjNWaWVWQ0p0aTNhVGFxU0ZQODJGODdoSEhGa2owVEJIUnBNY0k4?=
 =?utf-8?B?cVZkUThscXdkZ1lRdmJsRlBLbXl2UHhkMVZIcjZqZHpVRGR2UnpFVkN1V3V0?=
 =?utf-8?B?aGo3cnBxYWhlZFZzNjh6L04vdXFuTEpHVUVNa0hiejBWa3VhYjRWQnVhM2VB?=
 =?utf-8?B?bkZQMHdJb21Oek9ObTlKUW11M0NzeDBhZnR2UjBORWw2QndXaThQc0tPclVT?=
 =?utf-8?B?alkrZXA2YWJPUDNhMGlveENuR2w5OTVkVDhqMEd1L0YvS1MvazhrSE0vVWhQ?=
 =?utf-8?B?Tmg4dGVjbzRaOTJ3N0VicFRkb2NOVS9HM1Arck8rc2E5VmZmYTZkUmdhNkNL?=
 =?utf-8?B?UHg0Y1FYYVFESXdoYzhtanpoOU12MUlpTlVWM2xwYXE4Znc5WTV3aldkcXhI?=
 =?utf-8?B?VWIwY2hWZHpIbW0vVUxhZlhmeTJWUFZxTDA5WGszbXdRV2dRaWd2WjZEdUZ5?=
 =?utf-8?B?cXBDaFdpV2VYNGxKNmFrYUF3WkkrVlBIblRPUlE3QU5YNnJ6NlFkODdaaXAw?=
 =?utf-8?B?ME5Bam5QUDNTdVVnL2R4WEtJV011YXUySTVxUVUvbkF0SXp0S3o1enQvK1VE?=
 =?utf-8?B?QklDaVJ3SXJCVlp4cVpscDVCbGk4SCt6NFZvUUxuay85U1oyV0F4ak40TzVM?=
 =?utf-8?B?c3hKME52b2tjNDVSY3pWN3BWTE96ZzRHaFMvYXQwS0U4bVZvdUFORENxMjdz?=
 =?utf-8?B?RytMbEo5ckFkQ1NpZmF6UDJNSnpjZFRtR253dzFNVlFwNUQydjdqdXpTWmdM?=
 =?utf-8?B?dDRvUVhiVnYzMUFBeE9TSWtDOURwTGdFN012UEpOUjg2bDRZc2tCV2FUTjYy?=
 =?utf-8?B?NG1wVTd0RU9HMlp4NnY2UGZTYkNPZTd6V0pHNGF0YktJR3VLVTFaOE94QnpL?=
 =?utf-8?B?OEhHZnFiOEUvRFNYOUpuVS9ZYndsV0pPYmQ3M3IvaFI3K0gzVUVva2dxRkFZ?=
 =?utf-8?Q?cI5Fefnc2gVX+V3B/0H142E=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bnlLKzViTmRJTk1uRWhSMERCRFlhbmpKcFlxRmt1QTN5NDJpdDltQWZ0NmFU?=
 =?utf-8?B?ZDlnaGtuSGhiR2hQSnNHQkMxZ1ZHZ2VtOFJCUk1zYkRtZE93NlhaU3VJZytX?=
 =?utf-8?B?Z3A1WlhucnBBc1lZSk1lZWJHZ1JWTXVOMlBnYzJvVmhwMVJXaWtUYkVLb0t3?=
 =?utf-8?B?M25MMnhYQmJGOHhBSWVrclZXOE9jeWM1cHM0cndRUC8wY0Mvd1FaMndwYXU5?=
 =?utf-8?B?NXJBU3ZTazZVVXdSeExxMzhRNGI5TUl4NVRlaURFNmYreno4SXV2NkRzNHBT?=
 =?utf-8?B?UVhlb2x1dDNEQmRCUWNTR1dzZkFMVlI4TjllQnMzak5hakRHT2lKcmNSbzNT?=
 =?utf-8?B?dUQ4ZFl5RUhNZDEwYzVzS3oraDFITTFKN1lwT2oyb1h5SGttSmNVOXZTZFRl?=
 =?utf-8?B?UlVUR2R4MUxpTU9ISTZ2TXdYSXNWL1pyTkxockJFTnB5VWlPM2Q5TUpxU3Nh?=
 =?utf-8?B?b3FINzhtMlAzUnVpeUg0L0xiQjlibFhnNmROUmxVZkxzS0RLajFabzRJOWhs?=
 =?utf-8?B?bHRBSDFUT2JuOXg3MEU1Z3RzUTNJTWxxVm8vRmRHSmsyeHVtNERHSHNvZ3Jo?=
 =?utf-8?B?MjVDc1dSOGNNczhNeFNDSURtTDVBSEhTOVR0c2JCS3FsbVU1bjYyVXltaTU4?=
 =?utf-8?B?NTdWMEs2TzVCbTQxait5ZC9Kek9JSmluOTVRQ3d3Z0pGYmtjTDAxQ2FzWit1?=
 =?utf-8?B?SExacVBqRStWY0w1OEtKVUp0Z1U0NEVBd2ZNYktpcWlwTThmYzBsd0M4YTQx?=
 =?utf-8?B?NGM1SUg1TGVlZ01waVA2Z252dTk4WVZtQnUvWU8yRVlsRE13dncrTUlzNkFQ?=
 =?utf-8?B?bFBCYmRWbzFHMG1ySWFWc2hrU0JwMklwRHVyY0hvL3N1cVRRbjZKQmtac0Nt?=
 =?utf-8?B?NUI4cmxXOTRQRHoxQjNmdjViUDNyQmJuc1lNTjdjQlE3c0VaekxvTjZ0Uk4z?=
 =?utf-8?B?R2k0ejZFaGd2T1JYOEh5ZzVlVk5jbStmVEJvaVdoZGtscUNIUHhLSmpzWHN0?=
 =?utf-8?B?Nlh1K1BuMXlMQzA3bjhQUWRPUWptdjBEc3ZvWG82blNWNjludVh1VUlQa0I0?=
 =?utf-8?B?N0dNN2NiT2w5NWZTNTBNQjBnMjNTaXdhSkRLYmVqc2dKT3pEa2lYRU5jSjFI?=
 =?utf-8?B?U2VtS3g3elhEbEo4dVJxcy83a1BFdWNtT1YrTk8rQVZpc3R2SmJiclkyZU1L?=
 =?utf-8?B?enBtcGdoUTFIdG9zelR2b3F2WE9Gblc0a0FxbVplWkJHcHhJYXdnT2M1ZUpQ?=
 =?utf-8?B?UVQrT1NzdTE0S2NDY1dzSk1tNkV2aXhTRnNZMHBacWs3eXd6SmxYaXIwRE9S?=
 =?utf-8?B?enBnT2FuSmxyQmkvMEM3WmVNaDFUSkQzeXJBRzFqdlpjcElIT210emtQT2VG?=
 =?utf-8?B?b0JuaE9kRnJGdDRUN0VxaVkzVERWNDBQSkVkTjMyalFtT3pNOEdjWjdtbGo4?=
 =?utf-8?B?eTRPaERialFORW91dHBuWWN6blQ4NUlBV2pPbGdZNkw1NHpFK2lnQ1Y4ZGVP?=
 =?utf-8?B?SWRJa3dKMU1ub050UTJtZmo3Z05iZ1loRXhJUS9TcmhWNUJNMmhhZUtkaU5U?=
 =?utf-8?Q?OiBi/HBgpS+penV5CA7VbAN2Gqaik/9ugBD534IFkXsIX4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f469b6a3-a479-47d7-98c6-08db0ba407ea
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:18:54.0601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: APyFQ63QZs6gmh02jHjJY/myGbobLlDcqN59E6JJsskLesKm34dRuHFbH8nTB3sh6FZgX81ZQrtN+8d7bTeFQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6083
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100173
X-Proofpoint-GUID: wMLQTl-kvQVt7gJFxMf26em6RDdSHm-O
X-Proofpoint-ORIG-GUID: wMLQTl-kvQVt7gJFxMf26em6RDdSHm-O
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.

Dennis Gilmore reports that the BuildID is missing in the arm64 vmlinux
since commit 994b7ac1697b ("arm64: remove special treatment for the
link order of head.o").

The issue is that the type of .notes section, which contains the BuildID,
changed from NOTES to PROGBITS.

Ard Biesheuvel figured out that whichever object gets linked first gets
to decide the type of a section. The PROGBITS type is the result of the
compiler emitting .note.GNU-stack as PROGBITS rather than NOTE.

While Ard provided a fix for arm64, I want to fix this globally because
the same issue is happening on riscv since commit 2348e6bf4421 ("riscv:
remove special treatment for the link order of head.o"). This problem
will happen in general for other architectures if they start to drop
unneeded entries from scripts/head-object-list.txt.

Discard .note.GNU-stack in include/asm-generic/vmlinux.lds.h.

Link: https://lore.kernel.org/lkml/CAABkxwuQoz1CTbyb57n0ZX65eSYiTonFCU8-LCQc=74D=xE=rA@mail.gmail.com/
Fixes: 994b7ac1697b ("arm64: remove special treatment for the link order of head.o")
Fixes: 2348e6bf4421 ("riscv: remove special treatment for the link order of head.o")
Reported-by: Dennis Gilmore <dennis@ausil.us>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 include/asm-generic/vmlinux.lds.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index e28792ca25a1..8471717c5085 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -903,7 +903,12 @@
 #define PRINTK_INDEX
 #endif
 
+/*
+ * Discard .note.GNU-stack, which is emitted as PROGBITS by the compiler.
+ * Otherwise, the type of .notes section would become PROGBITS instead of NOTES.
+ */
 #define NOTES								\
+	/DISCARD/ : { *(.note.GNU-stack) }				\
 	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
 		__start_notes = .;					\
 		KEEP(*(.note.*))					\

-- 
2.39.1

