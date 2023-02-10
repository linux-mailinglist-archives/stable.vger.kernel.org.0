Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8E3692815
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbjBJUVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbjBJUV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:21:27 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E64303C7;
        Fri, 10 Feb 2023 12:20:35 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AHwjcu007847;
        Fri, 10 Feb 2023 20:20:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=aUX1kB/TU2UHqMvgNPxPrGes/UDAzkjMcV0iXLH9KKM=;
 b=PCuPJEG00CmZdaz7eatz5rRISXUlIJ/mNRij6kNYSCF/PYHK9HSKsN4odkMvmdwTuZdB
 WE2PTRnxv38pLdx2w45ICa9KmPMIQ/NbmSDOHNrjNOgBLd+AEsJAu2P7C5jF0cqyRUUs
 YyWw1ESEyR2gpnucSc4O63iNX+tGqJHkbEPuMzhjqmIVYKo2yX0ALddJ28eAtAiqX8TG
 dBjceFJ+CM2aizEOEPp7mtWAjsch76Z076QPkXCdHMLncsyXEoRtKLVGCgaLMZjup/gW
 RTg1XDyHoatJbkFlpgdedpNJLi7Eq/a2Tc+5mix+Og93U4POLFnA47KKtGwCh3djGqOt RQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdsdx4n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:20:00 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJxsES013647;
        Fri, 10 Feb 2023 20:19:59 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtaqkny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:19:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crzC9oy+uDph46ZH2RLh4v2A1nIphzDU45U1y1ARGW6mCSUHgzBPcOegoB2Odn1jgTwKf9c9DfOaJY8KJxM+NDFsvTl1rNWfNMooaW2gUPuRz/469Xr6FcIdEewJvCo+LxcljVnYjLVzt9sZAeHPL6vi2Uz0AoRIfkPIMwkQM3WTxIk6KWCS2zcfKzBpBhbdifnPDZumtoxcVZ6chSrPoP/XBFfXd8RJgesIwhWcVsAb1m7qRuMbBOpCNjjtQFvBhVxDbnOcnFn8KRFoXZdDn2TIixN1KFKA6C/lZwgnfQaLJxjelOvmar8Fwe7OPom9BY9czwX1Uw9xf5oVBL56cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aUX1kB/TU2UHqMvgNPxPrGes/UDAzkjMcV0iXLH9KKM=;
 b=SdnI+hXfd0TAX5OcD3L3+qwbTXpx5K2MhjnS/ORIAo/K+V1r9q4DbynmKV3Q9UOtAeKkTNolfmyLAjc3Jm7Ltb/4JeYnHu3/iMxVJMhRz7BGkIGAwsx1LJYpHCStWH15eSmkQ3F7geycg6snUzLCCs3Kz5CSgWJbP8LUD/9oEwuKtttCwMMyUsNdctcz3IBKqTvEwtd7ycA61auvJ0F34+rSY83JESPH2YjaA26XBNMbcX/WxMqxzjDGVm55KaLufA1Qa0Q7V4Oerb0xO/ntwhRm/GiWw+gDYGgyBsAtyzMjOb0igjyLeNYT3vYbmJPgPZt5xa5X+eMkMNnWccCvMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUX1kB/TU2UHqMvgNPxPrGes/UDAzkjMcV0iXLH9KKM=;
 b=k0FFZZFpN6RGzG+r9cbUCr5cnr+cDCdANMOBAsrXSJs56Sls4Diyg4tIJ6IwVw2pfzGmCFmKlVUxerksZdCjO/E2YLrF4geJlXW6MIla9BfMj2tH1HfVRk3TeE3TPbB/E52yrA+U5PtNAAeY2ZXwnq0q4Lh+sMF7wMd5Q4xB+rA=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CO6PR10MB5652.namprd10.prod.outlook.com (2603:10b6:303:135::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 20:19:56 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:19:56 +0000
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
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.10 v2 4/5] s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36
Date:   Fri, 10 Feb 2023 13:19:38 -0700
Message-Id: <20230210-tsaeger-upstream-linux-5-10-y-v2-4-ada7b8d36096@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-5-10-y-v2-0-ada7b8d36096@oracle.com>
References: <20230210-tsaeger-upstream-linux-5-10-y-v2-0-ada7b8d36096@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0219.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::14) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CO6PR10MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: 0712abb9-24d6-4cae-32ff-08db0ba42d15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hoe+wSKouVUE1uRnZ9z08pA9auaAra0WaHra6NJpTKFVcehEm1Fv/SY1cCugzAMZDDHYbYrTVEFEboSOzBlI3KYS9veWHgGF0tZ6+FPeOBybobMf5v6AEjPUHpcZHRiqPobjOjx3J2NqB2b1Q5X2PjpwblIIR2v6c8F0Ofh9DkgFqgNy7zsN02Wts1Mb3j6HykHjc7B1xPEPXK4R6WgpKvBumsZDM8FgLv7msWXFhLbLG+Z0sqse5HXB29kdz0ifrirlz7NcvWhMU4P7LY8OzYxPkIqcjjen8abfB0M/uGVskxbWSdVITFHpKuRlidL1H3NyF3be5Cl8UzcZEXkLdhTc4AMj4MRUe+zQi6R3yDPO49v+hlFrbAenrTXFLpf/0qOuIAck3KNQq/Jn8zOtPMNGWs4cuZHAPkN7/aENRdu2BLG2xt6d/EZE7pvH3U+m/+B4FmEgtajupV47xUwUh5QB7p4AV07RSHw+J9vaivNEowlyYVq3V2LitvkuZCENwbOHaL2yoiA3ErKKuj3/FLYogZL1bmlzCBZ/fOyiNwmczeI+p3QmS+LDVhVFSf+/6xnIJvBbzmnmaTtlZ+uUbPlfZHC6008IrL6y4cv9cT//2df3WCOuzyBmmgKobjDf4B1hLe5DZSKLb56o83NXeKMPhIiBHYij8bbogJoVQk7ZGJScewl7gGFT7u7URFT6wzEX3gQ6s+dLz+jZ7kGnig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(2906002)(36756003)(966005)(6666004)(6486002)(478600001)(6512007)(86362001)(2616005)(4326008)(6506007)(6916009)(8676002)(66556008)(66946007)(66476007)(7416002)(44832011)(186003)(5660300002)(316002)(38100700002)(8936002)(41300700001)(54906003)(66899018);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Szg3UXk2OVlwMkFNMVJPUE9NMmZhOWxJVXhmY1h5bEJyU3RKNlhsV1hvT2Vt?=
 =?utf-8?B?YWVNMDdPNStkU1k0K3VaaHExbm55RmpQVnkyZnl1bldkSlEyQW4zUUQ5Q00y?=
 =?utf-8?B?UC93c0lIZU8rR3kxMEN0Q2c2dDQzR29CRlZwdVhFS3l3TTdkd0tqNkN4b1do?=
 =?utf-8?B?b0pXOW5vNThnUDlVUGc2YlRGemhub3Q3OG11eEpWakFlUnE3KzRDdU5oRWhY?=
 =?utf-8?B?NHJxWEdHVDVNSEs3ejh5QzFjaVhiL1hwNm9NSVJWbWllMGFHdVJpRGNlMjdH?=
 =?utf-8?B?YnZ5VG9CUVFadm1UdStabEFTZCtaNW90Q2w2MnpoSEtITmRBUk5lT3BIN1Zu?=
 =?utf-8?B?d3NPNEtIbTFoR08wSEl3VWdrbzNBQ1lpc09xZWZBSjhwMVRyQUtxMEsvL3Rh?=
 =?utf-8?B?VmRJRG45VStYQ1ZlZWJvS3BVTnFYbEhvNVVTZDZ0UXI5RnNhL0FkYzVpUHp0?=
 =?utf-8?B?Nm1vMWRtWFBCczFWUXFNcnR5K201TnFKNTZDNUVDa3FXQ3lZdkhvV3FMOUFx?=
 =?utf-8?B?VWY3L3VHQTdudStZVHZSZjFtOFh2aFhhN0pwZmdwZG02WjlzR0tJT0FGNy9t?=
 =?utf-8?B?a0d6QzNwUC94NWpWT3VhMnV2UVZKMnFqY0ZnZDJPMnkrSHFJekhvaFFibkZF?=
 =?utf-8?B?NktnL0YzU1VBMXR2amUzN1RCdjZKd0d0clZBeDVDa2ZrM1pmZlI1bGptNk5y?=
 =?utf-8?B?MlpNcjVXNUEvSXRzK2RxVFpiQTRYMGo4Q25HajB0K3RTR09xME42ZFd4Sjg3?=
 =?utf-8?B?SURGUExTZWM4dlowZzVjRTg5OWx5YmNsSlBRV3l1WFdCaEJnMFdzZU9SVkda?=
 =?utf-8?B?Vm1nZTVVY3l6ZTA4ekxuNC9oeFBPTlpyb1Zmd1pLK0hYMXJYVGYyNkRKRWpS?=
 =?utf-8?B?WlpXQ2ZiZkxqQzlGSDA2ZzVmbDN2Q05hZmx5VVhqR3lJbEs1NUpMejdGVU8v?=
 =?utf-8?B?UzJkQXhRN1FzQ0NuNU4raDdOb0pjYUJ5VnJMeDFLMnJkdzV2K0Rvb1FqUm9D?=
 =?utf-8?B?dGUrajM3bTVTKzhvMWNpdUo5bmRaeHVNYXRkTXNCeXA5M0RuTFF5VWJjSG1M?=
 =?utf-8?B?YUZESmE3S2JaT0tqUmdmM05CNkI0aHlCY1RBekxXSFFJblAwQ1lsTFB5VmtH?=
 =?utf-8?B?eGdnbVl5RU1zOXc4eXNRVncyeE9nalJnUThNTmxvcGFOUG9iRHdybTNiSUs2?=
 =?utf-8?B?S2VqMUp1bFR6UVB1dTAvWlB2bnJ2Q1BNMm12QjNMemNJZEZzV0djeDU4RGJ2?=
 =?utf-8?B?T2dHNWpMdHl6WC9kWWpvLzhta2Fvcnc4VndmaFUzYk0vVmpnSzE3MXA3RmJ0?=
 =?utf-8?B?K214RkQ2ckRwS0JMWmdYQ0MyUVFSd2pKRWRTWm1PdHFxeStFa01uWEd1dkVz?=
 =?utf-8?B?WVA5SlRHT01qYVRxQjlSRWtkb1BRVHZaNm9yNGUzUTRFb0R0RWNndFEvUnJu?=
 =?utf-8?B?cm5qb0pqQVpFd1BjNkZiMTNxaWZRNUE4VlMraFc2M1pOREQzUEQ3WmU3WlVo?=
 =?utf-8?B?elVBZjJzT2JJM1UvUUZ4Sk1OMTJLWjdOY2w0M1hvU3FZdTBySFZ6SWxSbVIx?=
 =?utf-8?B?ZkR6SHJkOVlWMkNtQVgvTHl3bXlMWUF0N1U2WUk3VWsybS9xNExLeTBHWTI1?=
 =?utf-8?B?M2xjQXRjMXVVL2ZsY1dqRXFOV293MzNvK1U4ZzNxUkFPcVhiVFRTdzltRU1D?=
 =?utf-8?B?dEJIKzNOS2RhQ0d3R3FZK1ZlMjBjQllDU3NsYU1meGR3SzM2ZTNhT2VIdkFG?=
 =?utf-8?B?WllsT2Fnbk5DRGpxZnI1Y0FkaGo5dEpXQ0pPaHBvTDR3VVVyR3ZZTGMya3RG?=
 =?utf-8?B?K1NiQ2NtWk5zQlFraGIrQWdqekZWTzlIa2orYjdLSWVkZDY4UVZxcTlkdCtl?=
 =?utf-8?B?WTMreU1ZczZ0QXNPUkNFTjFlV1pPUU1XR1lIYXhhUURpTnZ3WnJWL1ZsWUE5?=
 =?utf-8?B?UVp4KzNnenNmM3RsV2tZSzBudWhHK0ZmekwzTWNyT0Zab0pKUzFUQ2lqOStT?=
 =?utf-8?B?SzIydmZid3YreWs5Nlc1dmUxUEw2S3p0UnhQaUpIdFE5MEIrWGpxbTBGcUov?=
 =?utf-8?B?WkxZYXQvdHc3RE14Z3l6dDJ5dFJteXoxcFpNM3VoM21LQXduMlB1eEE5Tm9n?=
 =?utf-8?B?RWVGdHpPWERXdVViT0k0dnhURDNrZFhqK1BhZ0hEeERNMnJpUjNYN2huRStX?=
 =?utf-8?Q?ZY4w5UVnJcxga983juiGpQE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?L243OEtTdE80KytIYm92MXhTU05NTUxoLzYrWEd5ZnZZMWkzV3IreHNiUVp5?=
 =?utf-8?B?UkRaOFNTWEF2ODNHUGI0OWZEMmFDVjQrRXF4KzROeW1OSXhmZkN5RVpUa296?=
 =?utf-8?B?cDJnQnZkQ3pOd0JLSWdnaHpuUlBwQXlWTFhzZ201ZjR4TTk3cjlUck8wQTVn?=
 =?utf-8?B?UnFVZ3U3azlmL0MyTjNva29PMGtiMVVWekMxZmJoYUJMZldPQUFMMWl4MFZT?=
 =?utf-8?B?K1BXM2M0VzRHMW9pbVJ1R0hYenNKM3gyYXNzTGg2ZjZFbEQzQWVsQkI0Mmtj?=
 =?utf-8?B?OXdFNE5TZGx6bnI4NTFibmM3cUNFWUp0dmtyT2hKaklNdWc4YWsyS3hLR1Vw?=
 =?utf-8?B?NlQ2SzNRbHhZZDdNZXhiWDl5dmswTll2RFBxM3Y0NGNlbEFlUERIWlFlem0v?=
 =?utf-8?B?a21aUkp1VWhMblk4b1hmQTkvZUxraUcycW1oc0VUalp3ZlhjQzRtYzA0M0NJ?=
 =?utf-8?B?NTlsY3RBYlFqVFBuOTJ0MEFVb0NUM05JanIvOENzN1RvbnVpTUxCTkJHcmFC?=
 =?utf-8?B?TTROL2VlZ1BRVjllUHBMOUh0MkY3dWFkWjFjL2NnTFUzaFU1RlF0ZXU4Qm40?=
 =?utf-8?B?dnk3bkx0SzNDRStyT3pzRysyMVVUS2xkMTR0LzAvdzR0aFQ0S2dxM3VFSE03?=
 =?utf-8?B?aTBoSTN5ZlhIbUs4MHRYaTdEU1NaYW9SbWZFTzFPeGNXMS9DcTVxZi84R1FI?=
 =?utf-8?B?V0hDQTBLOUdQTTZBRmMrdlJIU1Y5dXd5UE1Lb3FMOE9RRmRQZjU2enQrVmtR?=
 =?utf-8?B?V2NKcUFWa2RrY24zUFdWUzAzWndxbjI1bTAzaVN1aXE3R0NjQTBqZmhid1U0?=
 =?utf-8?B?dzg0TFh6YUI3a1dmR3FRSktCUk9odnZaSDBaWHd4ZmEzS0V0QVRhZzMzeWpx?=
 =?utf-8?B?ckppTkpONk9teEFBL0x1d3I3WHkrSjRXaEZYVFVKS1R6TGVhdkNVaUhLTmkr?=
 =?utf-8?B?NjVQUmszWllXY2h2RjJyZmViUStpWmRvWFlwUEdqbTdxT0dGQXJZMjRobzZE?=
 =?utf-8?B?N3JJaVJIMmVyQ1AxOFBRUlFXbVJyb3ZJVlU1SkpzYVlUM3hENWxjcHl2ZGdG?=
 =?utf-8?B?L01xckljamtTSmhlNyswUjBBdlhad3ozVGVUZTBGWTdWMk1KQVFhWmw1NUdi?=
 =?utf-8?B?cG1BT242aUlnZXZVSjNzTHJFQS83WjJkY0w3OUJIQ016YVAweHBjWGFaYXZ1?=
 =?utf-8?B?NlpVRHhlUFAvR1hSSkNtSklsZUt4b2psbnIrNVNkdnZUWFZjbmJ1a1dkYVdo?=
 =?utf-8?B?dWcwUGVLSE05b0Q5WjlzWmt4Y0x4NXZpSHVlejRJZERjT1RnbTI3YS9sUHIv?=
 =?utf-8?B?QksxNzBpMExyTkxyZ01yQ21RQW1SekxKbEk1UTJTczd3YVRnWGRLckVNNkxU?=
 =?utf-8?B?cUphazdDd2FFUU51NXY5Z0pZVE9OVUxTYXhpb0RmcldXL2t4ak1RblM3Vmt6?=
 =?utf-8?B?QXNJSjJZcUk4Y0htT1pScXVHa2h4R09zN0ExN0pRWEZEdW9OSmdtZG53bklZ?=
 =?utf-8?B?dFZLZHRqS1VZQ21UWUJMS3l2aTlTWTZoN21rRy9FZk1BZzRKN0JnMjZ1Z1di?=
 =?utf-8?B?eHBMU2FuUjJNZHNBSElxRTFvNURsOEpxRStza05OdEZCY2xjOG4vR2ZFSTRZ?=
 =?utf-8?B?N1hIVmFic2FDeU1JdWFOa0R6L3AwcWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0712abb9-24d6-4cae-32ff-08db0ba42d15
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:19:56.4775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cp16qw/DsRlieq9J+1G/jfbsbIV7W4mE940LnWYHCgl1y/5CBg32EwMsOyioS67oiaAP6JxJc4g3fyviblZdEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100173
X-Proofpoint-ORIG-GUID: jWalbsQuWtNDHu-LvqlTa1rm5MQZKGpE
X-Proofpoint-GUID: jWalbsQuWtNDHu-LvqlTa1rm5MQZKGpE
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

commit a494398bde273143c2352dd373cad8211f7d94b2 upstream.

Nathan Chancellor reports that the s390 vmlinux fails to link with
GNU ld < 2.36 since commit 99cb0d917ffa ("arch: fix broken BuildID
for arm64 and riscv").

It happens for defconfig, or more specifically for CONFIG_EXPOLINE=y.

  $ s390x-linux-gnu-ld --version | head -n1
  GNU ld (GNU Binutils for Debian) 2.35.2
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- allnoconfig
  $ ./scripts/config -e CONFIG_EXPOLINE
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- olddefconfig
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu-
  `.exit.text' referenced in section `.s390_return_reg' of drivers/base/dd.o: defined in discarded section `.exit.text' of drivers/base/dd.o
  make[1]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
  make: *** [Makefile:1252: vmlinux] Error 2

arch/s390/kernel/vmlinux.lds.S wants to keep EXIT_TEXT:

        .exit.text : {
                EXIT_TEXT
        }

But, at the same time, EXIT_TEXT is thrown away by DISCARD because
s390 does not define RUNTIME_DISCARD_EXIT.

I still do not understand why the latter wins after 99cb0d917ffa,
but defining RUNTIME_DISCARD_EXIT seems correct because the comment
line in arch/s390/kernel/vmlinux.lds.S says:

        /*
         * .exit.text is discarded at runtime, not link time,
         * to deal with references from __bug_table
         */

Nathan also found that binutils commit 21401fc7bf67 ("Duplicate output
sections in scripts") cured this issue, so we cannot reproduce it with
binutils 2.36+, but it is better to not rely on it.

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Link: https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20230105031306.1455409-1-masahiroy@kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/s390/kernel/vmlinux.lds.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 9505bdb0aa54..137c805d6896 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -15,6 +15,8 @@
 /* Handle ro_after_init data on our own. */
 #define RO_AFTER_INIT_DATA
 
+#define RUNTIME_DISCARD_EXIT
+
 #define EMITS_PT_NOTE
 
 #include <asm-generic/vmlinux.lds.h>

-- 
2.39.1

