Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63BC26927D9
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbjBJUSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:18:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbjBJUSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:18:39 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CDF7E8C9;
        Fri, 10 Feb 2023 12:18:25 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AHwhNH019425;
        Fri, 10 Feb 2023 20:17:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ny504gccfvL4lZKcZdaoTQ2gm72LYNb1HXOelKkx1FY=;
 b=FoQ+4ojKR7qU0pYP7ZphxQn2jY9uFBSBnR7JBIWKaGd5MBj6mNz2TrDxBG0UuBaaepjj
 YXh1ZMrkQ/POZqnb0hYXsk2GzodSS6Cua3pXDxhZ6BohKSwMdI4AiP3ab/NojSD1fa3x
 oK1Di2sHhpBcD7qlSiMvsIvWoym1xDgKPI3l8LKoejPwwD+OtI7odCW9JzYPLMSN4U6d
 GKJlbkWwzOT7hGu0WfhmIFEHSLjEtG48ZffBBzmwsj8IBg7wtZqZqdWbWDd3SZoSiBKm
 yF6l6Uu/AT+G4B96pal7pROUG2w/iFzU8j91e2GjcdnmawdLszCWJ50RnI1Ac+JVhN5w Pw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nheyu68gc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:17:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AIfR1U036187;
        Fri, 10 Feb 2023 20:17:49 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdth2aby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:17:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCELJ/4xBBrge2Lwy/NFrsEiuIg7hXPxXu/ZUG8ib60OwF2Bz7b/gBj5ajqrxXETLpLwHhAQW1aHMp5rmelHI5CJkBR9iflM2XkH+/ESt5VBLOv8Atprl6kSDfKW36DpZGLrOuiI50pdeh9I5oChltjqjAvowHHpxR0I5WcbHwYCvGY9xPavMusdHAH15f7Yizwv8hDzFxpBfnBfVo12oubh9Ia9tanSIsC2N1RX9nd/zICKRGKYi6DbyC6anPYwFREmI/5sLHXlBbEnPNPCWMW7QEju6/bvZl4EmPiZ42vMmW1UVDZ6ZNGyBzeIXYjKs1sOr1NqdHEW9qu5JGRtgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ny504gccfvL4lZKcZdaoTQ2gm72LYNb1HXOelKkx1FY=;
 b=apUTzCt7l6fyQTXwu5tEgXBTVZyTvNGWBVlZh4Z7p+ZfkPeD59y04DN/QDn6ZdWbPwcGg0KuMWQM9wTbMYW6f3U1G5zQ0prXcWB/ilnlj+yDaSqZHD4AFfOO5/xoZV6sx2juLvgdT7dfj3DQ+4s0g6u8yCmPgPGPNsuDsu/6mGsk4n4AwksJRIs8cOUm6he558HzJ3530phDojWOzzHDOtD2NAmBQtKNwRsMhDvSYkb2M0CWOisI0tni2l84paYddJBLKQt9s7P378o25Gd1D0SVm8TkzDvClrj+lnW5Z0TBD5j4a4WBtLHC5oA4YyQ6PGJZva4qjW3slsGd/Hjrfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ny504gccfvL4lZKcZdaoTQ2gm72LYNb1HXOelKkx1FY=;
 b=QTioAFNkpoepoh5Dcyj25OBW2eJxZ7qCjezSluJWHxUuy14n51jyvPufUE3QDcvejxERQwt5FOZ5+QTuG1qOGTuoxwdlcBvfr61yUClKP5X6QlDu0kO3gDyBJOFt4T5BAJvgSSv3dwYsfS1jvDuKdSU+eHq3l5McQx4amfofsKw=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SA3PR10MB7093.namprd10.prod.outlook.com (2603:10b6:806:304::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Fri, 10 Feb
 2023 20:17:47 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:17:46 +0000
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
Subject: [PATCH 6.1 v2 5/7] powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds
Date:   Fri, 10 Feb 2023 13:17:20 -0700
Message-Id: <20230210-tsaeger-upstream-linux-6-1-y-v2-5-3689d04e29fc@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-6-1-y-v2-0-3689d04e29fc@oracle.com>
References: <20230210-tsaeger-upstream-linux-6-1-y-v2-0-3689d04e29fc@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:208:32b::10) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SA3PR10MB7093:EE_
X-MS-Office365-Filtering-Correlation-Id: 9259b972-0de0-4eb0-45e1-08db0ba3dfad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oIdoJMcA7D6Rvq56I1inSNcBaiDu2LZjOGt7h/11OdbWz6YYyIy3mS5X1S/0+DrSoBh6TKVOLGzT1Kh/bXVldvO27gO2/n0IrQb7j0yawSzNPzJNKLwbWyAXfQ7D4uOg6gk4Q9NbLB9ygcTUy0BqyRG31d9EQh+b8JRcMe0mF3ncBX3DbEdeXs1UCWSOQItNIplnN7QA6tHtUXqCMCMNc14+k3617PIDpHQh/xfOWtCUgIUzuchBpQFfTAnzlfpnbgp37FkeiFBZ16uSP0u278d8VfvDhgIfZ+NUohWtvO6wApgPGrgfdM0kWOEhrlPLoYhj5v9R1dWKnZr392Az0x302RoR1hCdv76lXWv24biykxtDly7UN9nk+ISR9HaFGb1ncVtqlyDR7hOnwrsbTGIKUoJusj/6iIgKuRcqVa3rUggLslF4Ow0inQeEfcp0sYvdpRvqf+dq8d/V6SiDxsZvK54v/lsV89CEH3iZj4UXEtxw6Y5axr5ug9HaOXPJxJoMCiXs8dAC7H6qNj4zdmLd/f2OKG36GvImk2Ao9X/FpXYLNzJJNcDIJgy30/d+ghnT4WoxE0k29YDm2NfLTBtBfHNVwenoVX5Mepa3ueyl76YrPdrc70SiFOuO4iEBj4+Sw20yTEd1a6OemF/5S5PNxZMwIXEd3sifgAccaAkNEr0sTUbuenE6NpWZfeZF0W1uVwPfFjD0fqtWNrwB1YsiTNfVKtRMJKsuw6Fd0dY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199018)(44832011)(6506007)(5660300002)(7416002)(186003)(6512007)(8936002)(36756003)(83380400001)(86362001)(38100700002)(2616005)(2906002)(316002)(54906003)(6486002)(966005)(478600001)(41300700001)(6666004)(66476007)(4326008)(66946007)(8676002)(6916009)(66556008)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVFZd1FTUmxzNTQ5ZGtrc29leEV5MGlaTHNBV3pqR1NabTlmMFd6OXByUjk5?=
 =?utf-8?B?MXJoUWpLWmdzSStVNTNBRStmV2VnR1BLUEYreTlkQUpkZTVoRkQ4SVhxRTkv?=
 =?utf-8?B?T0lETXUvUnRUQWc4b3hJclk4VEwyZmEyRnZiMHNDaWg3TDJVdVB5Ykk5eHpP?=
 =?utf-8?B?ZXpVZ3F0cGxXY2kzT1ZYYVVBVUpLaEdnWUQ2MjBGSWJpUnVGa3pzenRndzJ0?=
 =?utf-8?B?alE3bVRjNXFEQ0c0VU9odlJtR3lYSFBvRUdjUDhuaWlXRzFrVVRXUk9COUZw?=
 =?utf-8?B?amdUNTNOaVBRMnpYOXY4RDY4MXpuM0hCZEF3K2V6UWc0ZGU5aWJSY29IMUg4?=
 =?utf-8?B?MWgxZGkzMlRuaGdwNWYwV0xpVFQwN2IxTVBiRC9oWnY5Z1lvdUkydkdiWE5M?=
 =?utf-8?B?R29oMHRFd3k2eFQ3RUY0VFVUS1NBbDg5bVJ2aEIrZGR0ckIwZkk1NXdPemx3?=
 =?utf-8?B?VlNBUm1rdkdxc2gzQWpIMUlkdW9ieTNMYnQwdHRCcHU2YkQrZmtaOG56aGNB?=
 =?utf-8?B?Ym5wYzdzSUFQcVJxcExQbzRIQUtsT2I3ZUI1Z2pvNU54NzJ5WFBnWTljbzRu?=
 =?utf-8?B?clNRdXJBZGZCTW8vOExiY3g0UnlzWG45RnRRaDRBVnE4NDQyUzBxdHh5YUQz?=
 =?utf-8?B?R0FnM3NvOUVBaDN3UGlCbXRmblQydmx1eUxIRDY0VExZZ0pJVHhOTkRuUlhv?=
 =?utf-8?B?ZEMzZTBGVG9FZHNCR21xdmQ5cVdXTG9lRUxEQlFKSXQxeFpPeDVlK1g2SWV3?=
 =?utf-8?B?N00wU091cVZIbW5KTVRHaE8wR2loUFBSNUVReUpjbisrNTRRSERDV1huMXlj?=
 =?utf-8?B?UXMwMU9lT0pmTUlIY0tzSnlvMjZhVko3MEE4NGI1TCtxR3RQclRLclpEcnpC?=
 =?utf-8?B?a3doUDdSOHZzaTZ4ZXh5T0dIakxqQmt0UVJzRk4xeVVtQ0dTMDFjR0M1WG1E?=
 =?utf-8?B?bDZ5QXlrbFI2aE96ZUY2djBHTUFlV1hiT29CNDRpTkhkMkkwVFM5RGRZZnNr?=
 =?utf-8?B?NnhrL3M2K1orZEltbkNKVGdCeWlKSTF0Sm85YmRTNTMyUVVMaCszQXEzTTk0?=
 =?utf-8?B?ejR0azBoc3hjMnhDcHZRSjRMNFdOZFhBQWZBdTQ4L24wSnpvNUwvcHh5Kzls?=
 =?utf-8?B?ZlBwQVJ0UzE2em5jOTYxMzk3cjZHZVlpN21FRkZSNnVMUzVFZklEcDFEYzc1?=
 =?utf-8?B?eG01MTREV1ZCbkxlNVFHbmxuZEV4YkYzekFmU044cCt0UmJaUXRpTXlnVTlj?=
 =?utf-8?B?UldSOWI3SjhMM0I2VmhyZ1lnYVNrb3o3N1VFWU9nOUVZMXMzZEcvWVJaYjZF?=
 =?utf-8?B?QkNiTXkzOWt1ZXR1RnQ0MXBSM3czQjI3UThaZlpNOVU0U0J4VEgzRlptVnVM?=
 =?utf-8?B?UWQ5UWZuNE5oSFVzMjFna2YwdVpwRUxkNnZmSytrWTZia3BlVlRBVHZPUnRM?=
 =?utf-8?B?cWcyZmZSVElmMGJFY04zN0pBZFF4YWEwRWI5a0R3MUxxVnBmblBLS0htcUF3?=
 =?utf-8?B?MlFaL01mNzQ4Zys4eGlTbVlhOFR5YnRGc0szdHVMSDRzdkNRejV3Vk5oNnlP?=
 =?utf-8?B?ek1ENExycURDNlFhSmlMVzRyQ2hNTTBQanY3b0FjU2xhYnBEVVlDSmhVMFUx?=
 =?utf-8?B?WWtWWVdmc2VuVFhVZWNEeEJNUUVuNCtucGNKV1dHYWE4Zk9lam5mZnBnTHNH?=
 =?utf-8?B?T0pjeUo3YUlpRmVNTlBWSFcyWHg3OUM1ZXB6U2tQQVBqamJocG5lckRJd0h0?=
 =?utf-8?B?dldIUVdqMXBiNUNoUDlPY05KWnJ3dWFnVzU4UitVTGU1QnRka1pwNVJrRzRY?=
 =?utf-8?B?RXRNWU1CQXRwdjd2RityQmZubEx6c1llVmRDcldKWHdoM3hIZDFyajJyd1dp?=
 =?utf-8?B?OGV5Rjk2cVUyR3VxRjJsQks3RWZPMTBxQTdWRlM5Q05HcTRXdGVlQ3VNR2VK?=
 =?utf-8?B?aFNCeTkzVnlFUFVIdCtQNWpwZUZBMi9udldOdXZEMkVHbWViWnpScGVuL3ZY?=
 =?utf-8?B?NmNlY3lrU3h3WFZaMUNMN0V4R1Z1dVhPQzZKTXdHNHlWSnhKZDhhYWZRRkJF?=
 =?utf-8?B?S2Z3dU51OGYrUjF3THllYkFhNk5mSW1QVVYzbG9RMkMzNkZEb2x2OG03ckhI?=
 =?utf-8?B?bGhlc2tSaEV2WlovQlhMVnR3VFZUZUMwbXp0c05UaEVMZ2M3TURhL2ZSVXI4?=
 =?utf-8?Q?kiR++oC813L2d+hvebj8QgA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Zm91bTBSUmZCWnI3Tkx0VHg1bkpPcDlnc0JpZXgvWTljUnlQY2ZzNVVDRnFK?=
 =?utf-8?B?d3pCTElNdWQ4SFhvakVVWnNDUzB6emdSSFEwcGtKWTNFVmw5YUlqcSs0UE1S?=
 =?utf-8?B?VDJzalU0cThnK3djemovaHppMmhtN2REb0dsZU1FTkt4RmpxTlI3U2I1VTRD?=
 =?utf-8?B?Mkk4VjViZEdUVDBxMFd2eGF1QjdsYXRHSG1EMnQzRWRUelFzc3c2ZHNGV3J3?=
 =?utf-8?B?bnlxTjFLem4vV05uT2UwK29kbzNvUndXZWFPWEdDcXMxaS9wVjN4eHV1RlVj?=
 =?utf-8?B?SWZPRkF5OVRraUMyckVieXppZ3B0clc3YThheUpkS05lVThyRkZ1bTJQZEZS?=
 =?utf-8?B?bUNVc2ZGMjAwRk5kejVFaG9nVTFoTnFyQTZHN2tMWFBTMjkva21OeEdQelc1?=
 =?utf-8?B?dlFkdTNlTHVYMFV3Q3QvdVViUmZFK1JLNWdtNG10d1lzRW9mZlBHS1kxSEQz?=
 =?utf-8?B?VEJwUEtJOGd2WFJkSXpYNUx0bTMwUjRzZFVIWmZWN25ZQWhMc3VLTmtVWldN?=
 =?utf-8?B?MklkWnN1Q2lKbW4zNWg1RlI4QVdkaU9kelpoejNMOU4xbGgvNW96K1NHZzdi?=
 =?utf-8?B?d0IwRUxRcTV1bytxSmFQR1RQMVpXWjArbEprNXRzQk5XQi9rMC93Z2Rudisv?=
 =?utf-8?B?UXZ1Z096aGphN0tNSXYvM0JDaEpZYXZmeURQYThtb2JHR2FEeEh5SEtQclFm?=
 =?utf-8?B?VHljTEVTYzdMMTdjS2tWRGF6OE9BckFvSk45bWZ4MDhaakp3UjQ5anJkc1h4?=
 =?utf-8?B?NHNRWGY0aXlwc1BOWEVRV1pRbHBhMlJQK2FEckIrSjVCVWJYTS95MVl0Wm5P?=
 =?utf-8?B?dzlwRitsMHNoTEJrZlJtU05YNkt1TVIrZUYxSFQvM0krY05iSW9wQ0Z0b3Rw?=
 =?utf-8?B?UERxZ3I2SFRGOTNRcE44K0xmZWhLcHJUNUdRR0tsSVgxQjNPTWxtMXBpelgv?=
 =?utf-8?B?SmhqZDdEWnl4UXJSS3MzdERQTXR4MkF4QjRKY2ExbXBmQUt3aWV4VWo4MG0w?=
 =?utf-8?B?SGpqZ0llNkY4d21pWHFIQXB6ZGZpZW90REpJTVROUWhzVGhrdCt6ZlF4QXhP?=
 =?utf-8?B?YWtLdW5mMkpSK3EyMWtlbFp2SkRMM2lXcTloc3p3Q1o5WWV4RWdLL21USHdx?=
 =?utf-8?B?MTRTMHRxM3ZUaWx5dHhvN1hoZWFkdUhUV1NidFlZY3V2K3RiT1c2VXpiME9L?=
 =?utf-8?B?RVdNRG9lRnd2ZWUySklwNDFQLzBINFVoVVFXb3JPNDljcUVxaWtFZ1NDTnRt?=
 =?utf-8?B?RlAzMXJ5ekpCRXFqTndrSTJFVDJscnBOOTF6MXE3TTB6Q0ZZRU1aZThpc2Mv?=
 =?utf-8?B?d3oxM0FLN3lNTnZ4VjllODhuTm11NjduMitQaWw4Sit3OEgzbkRBYXgxT1hn?=
 =?utf-8?B?TE5NcmF4T201TXUxMkRXVEdhZnRZdm54Z3pxbjJwamI1Q3RaWDVOa1Q2VUlY?=
 =?utf-8?B?Z3hQR0NUR2dlcnZLRFlIUmM5NTRzdmowL2wrRUt5Y2FockhZTG5jenE2dGFp?=
 =?utf-8?B?bCt2UE9xQXc1dzAySnF1ejVJZTNOWUp6Wjk5SDJvOFprVkh0a3pzT09Lb2Vs?=
 =?utf-8?B?c2RwenFkYXFxby9iTFZ3KzA0dGpPM2NIbXUySHVOOVJTMm5sak1FdURaQW9E?=
 =?utf-8?Q?oRgs12WNl2QuZNNkXAjaQYSrmRzCAS1v0NsVPwgAl7os=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9259b972-0de0-4eb0-45e1-08db0ba3dfad
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:17:46.6275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eEjucOjqC6pJrrUU8lEutCHzW/tcbV5+BC8rXDDtf0X88qhE56maljNgdUogTfu0EOXdZ2zgYM2lS79zM2651A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7093
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302100172
X-Proofpoint-GUID: OTca1dRXEf8Yn9NkezlEQSfaVWnM6UtD
X-Proofpoint-ORIG-GUID: OTca1dRXEf8Yn9NkezlEQSfaVWnM6UtD
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
index c5ea7d03d539..a4c6efadc90c 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -411,9 +411,12 @@ SECTIONS
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

