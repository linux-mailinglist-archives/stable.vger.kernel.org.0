Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA95692803
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbjBJUVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbjBJUUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:20:49 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC722BF38;
        Fri, 10 Feb 2023 12:20:17 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AI0AqL020851;
        Fri, 10 Feb 2023 20:19:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=VL5ggjV7l8uquv3Cdfin43ZELlq/Zxr4naWQDZOYm1Y=;
 b=j+EPwyDwFbCEHnTTzD4tfzdpW0eshAUOG2DKtoPm+exkNaohC0BKHLPNdafq/hrD9UxK
 5jltnddrBV26MmcWOO8wCQLzKbQOaoKxvL3Qn++gwCQmEcW4kfsQlz/g86WQpavx5mYB
 a74a+HUiHZfxqrOgS4Cuhs5vFl7r9gDdbSIDe7bGgIrKy8CgqheIOaJxkq7vxicHjfyu
 8xs8SoCyssAdXCIp0vgRK2S3rBcMbYTudKSIiSNNefnt7Blin3xzjMROw9JcnakSxw5V
 cf6gDraO48icJa2l2NmI7SSjoAngS7illn1gGROyNpGFULrATtu+TlA8NVThD03t5kOP rw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfwue4e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:19:13 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJsANb013725;
        Fri, 10 Feb 2023 20:19:09 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2049.outbound.protection.outlook.com [104.47.74.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtaqk2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:19:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eoc56hDFXn0wPTvPa3GqCg1/Y/fi15KcnVFt6mLN985us/dUfjiM9ri2UFCf+x9/oVp8QYa33gqHhYZzYeOhDcjblFbCZZdGOLOUTm8hKq5YDjkAOLOvK0BOIWJncWEjmmMxOTBslrfBoT1+wYvn2obaaGxNaUq2H4OiXwpXtyKRAU39rbmD/vjF+ktR95zf7eeOImj+Ur5jI0cKNYQu3XWvJoMy5yqQI9AGd3fygOiE1Yt58nnpnMPuWI5dMdGvbQju67ttIT1ug+9/GD/xqza0lxEyZY3i42TB7bCakE6YCGwu/FzUaCM4oh/CMjUAF58OZG6db+eEs298CLO20A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VL5ggjV7l8uquv3Cdfin43ZELlq/Zxr4naWQDZOYm1Y=;
 b=gdfnwbBEo10d/vgyytCGLftvnRSAp+y/4t3Mbvaum7ROVx90wvobO80WNSlGgzNW8wdnEXJOKq0EUjPoYvpW+nrNvN19p6gXdlhis5kAVlxGubmNsM6PhUjcmAZXM7JLhTqg+ifMZQgE5AqVRQtPgpn/gQIGfggbCNLTZ5F+JypeQTyg2lyhouOgxOWj06zRSPjvwUdRGYfBc6iKEUkqolYqRcxoO3cEX466kYUt97bPI4YneGmceHd6QbqfU1b44vQGbpm3oANFiI8pVBu6uVpCE7zrqAJpt52HD/dC6mv0NVuXG1YQhcCjx9W9uDu46NIdFFWB7ImU9zIwImmeHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VL5ggjV7l8uquv3Cdfin43ZELlq/Zxr4naWQDZOYm1Y=;
 b=oudFEp2fnTklcLyyeB4vXZDLHcKnxVb+Y5r30CHYd3tOSLvc18hC1wy7h3z225ne7fhsuxeUvgh34WfBOC66Iex5GjD246Sv0icJyAnjE4NOqmP5XdkMPqVqAKdE2BuDScqn+O1ZCj3XWChHM79QPbU362ucSx5oVrLZc9Wo2Vk=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CO6PR10MB5652.namprd10.prod.outlook.com (2603:10b6:303:135::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 20:19:06 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:19:06 +0000
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
        Christoph Hellwig <hch@lst.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH 5.15 v2 5/5] sh: define RUNTIME_DISCARD_EXIT
Date:   Fri, 10 Feb 2023 13:18:44 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-15-v2-5-6c68622745e9@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0012.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::17) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CO6PR10MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c3ab880-33f2-45eb-9387-08db0ba40f62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mprV4hZ3EKSZ45lI1S5iJJGECoTd53KotsWaIlbR5SnxKiozy03RIR8Sm4VSnEdrlhp8sOSsDCMEf8TSRn+ywhACM93CDFiC3l+RufUc0+g7q117ep7xlcbu+ITUk7Jd/BoH0Ydszs/dnIheWZqNOXtjIXa5ygnNV9J5AOb8BALablvypx4iUw9dHkmbXseUu7dh2TY61Ju+lrUa3loPsPWt80M4cGJNNENTIdCdk5o27XPDNYunwTI7rcuHqXKbSAlVe2PEOxAPSuNOeKDj+yZLIsc1ZOBilYtLNfwLEpfA10wOPheedW7tg9mo/6k8ZvDumrUSG6Iyiy6rAG5TonhpmY5Qb26OxryIfk3R8e/Sjf794M4q0wEEFNosb8gCyQNtfzIBvFe2Kl15yVEP8EjSzdbkEA18FG7KQ4W/4RYpzk7FRMcywpgb1yJu80yoQ4E2hrdyipE8CqgGCXf4dPzlKpNgRfEV29ou8hFYwk1t2G6eGl7V6sYMANYAdLnpeZcScBGPGAO+uVakaG3sFkHyZR55mIUzYIwmy45whz69mkyDWv6AV0ZNWk4FkINKJqwNCSR8HRPF71n8y1CmCmObZSOkaXNSXMFDXkIMifVwvljwYYFFr+UYi45iGcmJZ12Ld9hR1qHtU7542O59r+dWra2M1NgENvBhlArfdb/NZ1em5BlcqfnkrQkmltOy86PxQ2KLa9BmDshr11KBzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(2906002)(36756003)(966005)(6666004)(6486002)(478600001)(6512007)(86362001)(2616005)(4326008)(6506007)(6916009)(8676002)(66556008)(66946007)(66476007)(7416002)(44832011)(186003)(5660300002)(316002)(38100700002)(8936002)(41300700001)(54906003)(66899018);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmVtMTF1RDlnZlhYQWRkcTJSUE41SGFxTVR4QlUyMkhyd1FrUk5ldUttbkx3?=
 =?utf-8?B?bG92YU10UE5SSDBqOHZDWU1wVlRTMnZOS2wwa3didUllSnRwcVBSYUtncFQx?=
 =?utf-8?B?K0w3N1hJcGFvbXJKNW01T2xrQ01pS1l6N0V5SzJ2RklSUHI1SDdWTk14MWtY?=
 =?utf-8?B?L1Fmb1RmM0Y3OTZoQkd4d0VSQmpGMkZUclE5YlFTTG1sZ2xQQVc3RmxMMDZ5?=
 =?utf-8?B?Wng5KytDZVcvalQvME1WYkNWeWJtZi90eHZzTVc4cTRBaFlycjlPSUJBOG54?=
 =?utf-8?B?NkttZW8weEVVcHFkOGxvV0Z4UDJIYmpKaXRyUDNNUmxSN25GWXdKZ0kyUnBF?=
 =?utf-8?B?d0RsaUpxWFlxaWU0R1JRUldSQ0dEUnBsU1VySUVvcE1xeVNsdDQxODl5eXVW?=
 =?utf-8?B?WklkOHVWK2VoeCtNSDBsUndnblkvdDMwVmdYdTh5dWFQVHFFUHVhTmdobE1N?=
 =?utf-8?B?amF2dVNIMkErWnVXVitQVE5kNG1FY0JqTnhLV2xmMjhBVzgxdVpCajd0VWh1?=
 =?utf-8?B?U0h1NTBEaHByb1FqUzlldVV2ZUp3aXFOZkFJSU54WTBid2ZQakdVTzhRQ3ha?=
 =?utf-8?B?KzI5UXNQSlBZcnNwbzhrZjJaOWUwMnpxekx5RW4yamo5MlBSemJWWGdZR0Yw?=
 =?utf-8?B?NjJXeU1XTkV1b2h1R3A4NUZJTkpHcDBuanhJdXJxcm1LK1F0RFN3UlYvbU54?=
 =?utf-8?B?WWNZdy9laFFkVnMybm9qcmx5YW80N3FGUUwrTHZkankxck9jdzVNUGI5SWx2?=
 =?utf-8?B?N1FPWEdsQXVzZ3dOMEFzTHdEZVNaekRrdEFZRXJVajE5b2JpbkZHdXRiWDJr?=
 =?utf-8?B?QndJVHVKR0JxUy9KVzhTY3RDWTcyKzhTSFkvZUJYWHQrM3JMNXQvZzhQT3Ju?=
 =?utf-8?B?eDl3VkxuMlorUWNuQk9ZdE1ZdUtKSGhUZFZxV0RpUkNGWjV1WmZTREUzUk5K?=
 =?utf-8?B?WG1wejgxRGlucnhGRjcvRkFaNU42UTV1aWlIYkN6YnMvb2R2dEs2SUNRZlBu?=
 =?utf-8?B?OU0vYklDKzI1VmttYnlERU5nRC9ENURNZjNIQmY4OC91RktQbXZ6aitEdHdu?=
 =?utf-8?B?dC9xdkZ5bHRnaW4ydzdsN1Jwem5tNkJtemJTTTZXeVNzbEp2bkswQlJaL1p2?=
 =?utf-8?B?V1kybXN3c2g4OW5UcjAvOEtPczluVTArVHN6ZnlBR01tL0lnZEYvTjlKQVdC?=
 =?utf-8?B?Rkt2ZFZuQncreFZVWGUxaVErZlIzZUxCRW1na1F2MWZxQ0hHUjlHZ2NnSWNJ?=
 =?utf-8?B?Tys5NzV2TEMzTzNlR2RTbzdtdk1kRTFGb2ljc25ESXhveG83a0JCWVFUSkUr?=
 =?utf-8?B?czFWSE9NTUVjbWlpcThTeUM4Tm9wd3FkT0xDVGROK2dwNWZVVjBFMHZyWGpB?=
 =?utf-8?B?d3FoeDdCeUYvVHN6WUdDMEdCZFRVU0JhTjIvN242enVpa1I2Q0IzaTdDVzBZ?=
 =?utf-8?B?dW93Lzk4RzRlU3dVcmJtV3d3ME9OOUtyS3ZuT0s3WUowVkNNUVc3V1hvd3lm?=
 =?utf-8?B?TlpUdVI0OHErdUVYbGlrQk5va1p3eWtNbDY3bWoxdGZPLzlkbU9ubVkyQkZp?=
 =?utf-8?B?cWhGNFVHYXZWcCtYb1k2bTVjTmZKa2lrZGw3aEswMlplbXV3SGpsRVc3dHBH?=
 =?utf-8?B?RDZNVFp1aFJPeHRoODF1bFBheXlDbnh3MlNHTW1yVnlDdW1RWFZRUzVFZTZo?=
 =?utf-8?B?QS9kOVIvL2RwWHA5dXNENjhyc1MyL053VmtGRmNBSXh0NXZ1NDlFUU5qRzRw?=
 =?utf-8?B?cmNhcy9Rc3ZzVTMwaWZiQzVmQnVmY3dlSmY4REtzVjFmeXVSVVdHMm1yOXJD?=
 =?utf-8?B?Z0I5b1RmRkJQamN3RnF5Q2VtWVVibjNYRVZCWW5sOHRvNUJPZEcxaWtNZ1By?=
 =?utf-8?B?b1p0WUxnemNMWE1Pdzg0SFd2eXFYU0pNSGx4UjIxQkxKSzRDRFBSL2FXRkdG?=
 =?utf-8?B?TkpzbmNqTXMrNUpHcEVOREdxMmYwUlNtanByRmJSbDlBUzdlbEh1UEJtU21h?=
 =?utf-8?B?MFlMa296TGdBdC9zYTZvTmZ3SlV5cDdxak1ia3Mzc0FuVXJTd25OR2IzLzFw?=
 =?utf-8?B?S1NXazFvbE1HN2c1aUZobmIxZU9ra2M4U1o4elNIeWEzRkNhNmU0b0YyaWtw?=
 =?utf-8?B?cjAzdFFsbW9GT0p0UVdKMEVHWlF4N0xtZnpVRktEQi93ZE5xV1ZQSnpZaGVs?=
 =?utf-8?Q?cKNl1sMExJao4rol6lTp3d4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?YThaTkEvQWNVWGdMbXVwL2Vqa2UzUWtwM1k5RUdjcE8raUZyYmJWamZjcWsz?=
 =?utf-8?B?SEFvYWNTZTR4Tjg0Y3JhcEV1UGd1a05mNE15TXNzbjlTZ1NVYzlqbVp2TlZ6?=
 =?utf-8?B?dVo0MG5XeDVHalRseVkvYlZqK1lsQW11aW1UTktKWVJPQy9ZeGExTVEybm9Z?=
 =?utf-8?B?QkFRNXYrVmtta2xGWkUxQmRUSmxQZFI1SHQ2SGc5RVRXVXlXREg3MWVmSW5R?=
 =?utf-8?B?Z0hNU2ZmczBIb2l4UVZKUWdwYnlhU2g0My9MbWh5aU4vOGJHTkhxYnFtd1BL?=
 =?utf-8?B?ZG5KMXdkKy80RFhOcEF5b3g4bFU0Z1lkZDFuWFd3Wk1teWJYU2dDRXg0WXh1?=
 =?utf-8?B?Q0NoOGZIY0JUcXV6TGdtSllvSDcwWXI4VGxqSFpNc2M3RldsdDFYVVMrdXlp?=
 =?utf-8?B?T0dickhrRDhDUk5WbjNiUEFFdjZQbm5vSWMzVmF5UnBpWi96UHQzcG5uUTN0?=
 =?utf-8?B?U2lGWEpFR2E2RDBOZ3oyMnNqMjJPMStBODNwYVRXaVJNU2pWbEhSU1RUaE0x?=
 =?utf-8?B?dEZWZFVyS1FkMXdJZGtnR29EQ01KUlFuTTd1ZGpUckpNcHdOTzk1L0FvYVBZ?=
 =?utf-8?B?cnZ2OTlaL2dNcGR4emJrbXJscHIwK2s2MnNGZmgycXIzZ3RzS2FmbFBjU01m?=
 =?utf-8?B?WDdPemo0UUVjdlJ2eGdnc3A5VHY5UVlWbkIxeUQ2am5nOVZGaFlGZkVTNE1t?=
 =?utf-8?B?akJGd2RmZ3pNNi9ZNzBQZmc4dHlOSWJmMzVHVGpERzloQ3JhSHdPdzA0M09O?=
 =?utf-8?B?QkMzaUp4UFEvNnZrNUZCWVkraUs1ckFLOXlZczRHUXljYkY1L2F1dmIxbmlB?=
 =?utf-8?B?eWhLd2VrZ0Jhc1VkNmxYcUF5WkFqeDlRTUVGWjlkL291NXh0Tm5wZ2VtNkZP?=
 =?utf-8?B?WmtSQUNtTUlXVGROcGJRV2t0akJIU1dWZ3hHQUhKWlV4WnNNWVBGd3JXU3J1?=
 =?utf-8?B?MXhvQkRCdnVOZ0pGM2h3VjJRUU1LL3N6ZWJxRHBXRWdLMVc4WXc4eE5CNlE5?=
 =?utf-8?B?bXJ5aDJZMXFQU0ZTa21zOVV1Q01EMnVsZmhMMEQ4TDJidHhLZnlTbWhtY3hV?=
 =?utf-8?B?ZTllYWZaSi9rK0s3L3hoY29ramNCTVFwdE0zNTU1WVd3UzVmN1paTXBqelI3?=
 =?utf-8?B?STQzaUZJL283NGltMEhEYlh3R3JuQTZWOFpzUEJxZ0w2bnBiQjM2d28wOWRj?=
 =?utf-8?B?R1k3K3k4bDViM0JGbHBQWnhFTGl6T0hNdnFwcDFxTS9PYWt2dmVRUnl4azZo?=
 =?utf-8?B?WXBUK3RvT0N5NTlJMUs3ZGRMM2N0NEw5MktiR09CaXdFTHVwd0l2OXp0Y04w?=
 =?utf-8?B?bStGZ09MYXFlaHJDRXViN1FJclNadS9zR1ZoOUdRL1AzNnlYb2FXWVNUdnVX?=
 =?utf-8?B?SXlaZE94RGJvVkorOEJMK3JCM3o5R243MjQxemhDcDFmVEVKdlVZY1l2MjBr?=
 =?utf-8?B?c1JLT3labFArZ0c5cWxoRFNuTXdteG1VUDhLQjVDVEdDcXZsRlV1MWFES2FY?=
 =?utf-8?B?elJMbUpOOUluV1VnYzczbU1qblFZd2tFMjI1Yk0zQmdjQ0lvZTIzb3FoclNC?=
 =?utf-8?B?YlRsTGc2MDNWVmpGOEJHNUFoQXZDUzQwbmtwKzZhV09rWERGeS9qOWtFVzFB?=
 =?utf-8?B?NnJnekg1RFRzQXlnT0VabU90UkJidDFzblRqY1J5b21zZjdxdzQ2T1lpeUt5?=
 =?utf-8?Q?OGDqb5LJFG7Qjml99tZg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c3ab880-33f2-45eb-9387-08db0ba40f62
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:19:06.6842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sR3JTlOySi8z74aZWmFC2whkLD6KaJCxwAJF2XxoPxWJlv0achEAkeOVMErSlyiDPEZQF/bjOK/C1rxadi4cmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100173
X-Proofpoint-GUID: saPtajO_tYHyOXPH73vMTbD_rROWHMd8
X-Proofpoint-ORIG-GUID: saPtajO_tYHyOXPH73vMTbD_rROWHMd8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c1c551bebf928889e7a8fef7415b44f9a64975f4 upstream.

sh vmlinux fails to link with GNU ld < 2.40 (likely < 2.36) since
commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv").

This is similar to fixes for powerpc and s390:
commit 4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT").
commit a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error
with GNU ld < 2.36").

  $ sh4-linux-gnu-ld --version | head -n1
  GNU ld (GNU Binutils for Debian) 2.35.2

  $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu- microdev_defconfig
  $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu-

  `.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
  defined in discarded section `.exit.text' of crypto/algboss.o
  `.exit.text' referenced in section `__bug_table' of
  drivers/char/hw_random/core.o: defined in discarded section
  `.exit.text' of drivers/char/hw_random/core.o
  make[2]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
  make[1]: *** [Makefile:1252: vmlinux] Error 2

arch/sh/kernel/vmlinux.lds.S keeps EXIT_TEXT:

	/*
	 * .exit.text is discarded at runtime, not link time, to deal with
	 * references from __bug_table
	 */
	.exit.text : AT(ADDR(.exit.text)) { EXIT_TEXT }

However, EXIT_TEXT is thrown away by
DISCARD(include/asm-generic/vmlinux.lds.h) because
sh does not define RUNTIME_DISCARD_EXIT.

GNU ld 2.40 does not have this issue and builds fine.
This corresponds with Masahiro's comments in a494398bde27:
"Nathan [Chancellor] also found that binutils
commit 21401fc7bf67 ("Duplicate output sections in scripts") cured this
issue, so we cannot reproduce it with binutils 2.36+, but it is better
to not rely on it."

Link: https://lkml.kernel.org/r/9166a8abdc0f979e50377e61780a4bba1dfa2f52.1674518464.git.tom.saeger@oracle.com
Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Link: https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
Link: https://lore.kernel.org/all/20230123194218.47ssfzhrpnv3xfez@oracle.com/
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dennis Gilmore <dennis@ausil.us>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/sh/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index 3161b9ccd2a5..b6276a3521d7 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -4,6 +4,7 @@
  * Written by Niibe Yutaka and Paul Mundt
  */
 OUTPUT_ARCH(sh)
+#define RUNTIME_DISCARD_EXIT
 #include <asm/thread_info.h>
 #include <asm/cache.h>
 #include <asm/vmlinux.lds.h>

-- 
2.39.1

