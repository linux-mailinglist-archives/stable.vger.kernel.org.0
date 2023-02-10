Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1455692881
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbjBJUkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbjBJUju (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:39:50 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AF35B775;
        Fri, 10 Feb 2023 12:39:47 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AHwgvP019335;
        Fri, 10 Feb 2023 20:39:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=fteaV//kM5gvfhNkB07KGHv/UjLnACIvgHB9+7jPycA=;
 b=zhz8f/sWc/O2IbwyzeagQ3xR+hAFGpZTMUgyh2OkO4PZMNVzcBnEHIx7eYAiePEMR/Cx
 YvgqSupzdAgQwxfX2KWFbA9pKDJZA6UtP3Dhh+DTsTXf/kAgHkD3vv+KL+3k/9txUjAt
 04lxKgQL0HxH3KOBMOg+ImsPFKg+VldVka6fIIqECauGRCJsmvHyz7MVQp2Gz8vow7zL
 t4imQMICgVsOgjRcITsmmQBnqURBt2zNog19BPUgNB/tBf087bM2EexxyvXWafJTt0RL
 bwWfWFS5DKenirMtzS3jtCHzn6J9GdnN9/9NThHFLQcSxpC/gDOiAPAmlPKPVU+nVER/ aQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nheyu69pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:39:11 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJg4cE025798;
        Fri, 10 Feb 2023 20:39:11 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdthu2es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:39:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1c/mDCPOy7pVcwhW/Pajmz7VTcJb6M1puxwGEYg+vRlfME3nnvl04daUXzR9UBKQXZ95F+uzNF5yfFSCJjekGxAxsurSMo+nBWBAgTin3ZHzOTdFRhvOI7xGN8jY8YqCslx3uyJGpuKL9AwezeG7XGwR2mz8+DlB5mW02wIncxXreiLfwT0zC44aAgq0bfeia+mlaqawiT+v5qg3GsXnujfUVk4qt2O0+PRsvdB/sH4q3M7sbGB/hTtMDB1GDncw0yzsBJSoOfxYQo4zlmzUnP40+J5NsMbtHiBD7f4WMV8EKAkvb5nuEIQsgia/30lHsgoYyW4l0fQ7fKICmKqgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fteaV//kM5gvfhNkB07KGHv/UjLnACIvgHB9+7jPycA=;
 b=NoVJ9qwIkYH+5f3brpJxAtn293eZ43SP6u/786tbKqWkwUUqnXq4oqPfQ8PHvVx4CCqWJC8/IASwJAcfcurTDokOdrQWK+JehdXTbXhgatwjgQjvqdFNtNp/lvBsEb8k9s67cWSlyeKQw8DnSWVq2q608x5NS9NOfv1RNQV36BFT1I4b1FJ3uH3LhF+hdZk7Tq29jVxbZ4WMXJEJ5Ce4X6M6MoJsO4mIffdUU9M6W32dY6eO+J7Y3ExWR32bOgD+MLU64a17xGwsT8kq5UrHqtQQ/QhbFLxeJzv7KA51yLUNgwgPLVJ1sE/TnxycCBBEBfFldR4sBf9Njbt/aoaorA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fteaV//kM5gvfhNkB07KGHv/UjLnACIvgHB9+7jPycA=;
 b=e8Sgez8dIBEfZKwTfG4y/lo3pbi3xHvHXYcnY0xEFcO2izkPij+v85S/9BM2dxKMnJ10nV/u7Y+AzMLl4tzjQ90IBOYIFAipSHT0wpX5S/FhcT9rVh7UKbwHeYyJG7RWKeRS31PvNx80pFPutP7iITHXax646ZeeekV5m8hHTBs=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DS0PR10MB7522.namprd10.prod.outlook.com (2603:10b6:8:15e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Fri, 10 Feb
 2023 20:39:08 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:39:08 +0000
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
Subject: [PATCH 5.4 v2 5/6] s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36
Date:   Fri, 10 Feb 2023 13:39:04 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-4-v2-5-a56d1e0f5e98@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::27) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DS0PR10MB7522:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f1bed32-1854-4bba-4dc8-08db0ba6dbcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BGI8RDKM97Zrf9QwIg2sfa7qxjuwCKxJATGH7czOAyKGxHMTJOPXojPIsvP1QD/76L+sDFKvE9gW2z3kPJxNZRGqc5h62ORRKmykizT2+E4UHthXjzcVoGe2X6oi6TiAEyX74XslZ4liVkFE049b7HtmqVgf01nMiZK6gFWezSRaR5vnr8gXLxX/ysDUHIdqW3YPEMhLwl3q4b/nqUQxSscw/C0GZLPy/U6uFKnqeahuiGD2A+IRJ51IlTAO2y9hdU0ZpkR9DSQXFelhyjDU/F6tV7u00Rv/j2n3YQJWrH0r/iUZV7NcvfzGXWJOW2BbfrjYIz2DSWhEcYzcZRw1p2Cf6Hacpf+9IhmZoGeQ7iMIGHS5Xe05hgMAW9oWAL9W/OoqiNrQ9IF7o5yWnSASAsBhsKpur2JrbQYzOOWNpfVUxrtD5l7G9Rst8ygDCKezU6itAxBSFJj9FXzu9+jJVmMANgoNaAiQTbXn1BGiIDhZsj52xDlzX03t4PyYy1N1icDNF3lmGPD22N9Xgwyxv7qxneGEn6dkEa6v64QXnlasZMRduT3u1Ieh0wO1wp6hQ/xzPPQA4YXEGmZNJQ8gPp1Y8/pnsJs3AVG2Q9acAJsjiGXBm09qIArylYZxWEkfnYS/HojHw/m9BI9gaovlvxoUCMIlmUqRaX7JhmLs7KEMQmcWBPUycNMXz5zEtygIx+2qn1F2ePMKi55mnxIhjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(396003)(136003)(366004)(346002)(451199018)(478600001)(66899018)(6486002)(966005)(316002)(6512007)(186003)(5660300002)(8936002)(54906003)(6506007)(44832011)(2616005)(2906002)(7416002)(38100700002)(6666004)(36756003)(4326008)(8676002)(66946007)(66556008)(6916009)(66476007)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjkzZ0lYdFlyb1Y2ZDRCZW93L3M0Wnh1NncvS2xib0RxeHVqYWM0NUhTdkJ4?=
 =?utf-8?B?alVrMkw0UlVkbXQ0ZmQ2WTYvKyszcnlSTE5RcU9uUndqbnBmd0wzWXdFdjVC?=
 =?utf-8?B?azNEekhuMlJWMWhkT2o1RjlsRldYdjdBZWcrREU2THJnVU1ZbW9rYTU2OHFz?=
 =?utf-8?B?bXgvci82OXppaStXb2tzc3ZOZ1RycmUrdW5XWml6c2VTNXQzRXFVRHBBUjV3?=
 =?utf-8?B?VDE5cmZ6MW00YkRWTUw3emtaQlpwQlF4SGlYLy95MW0xZU1NcE5DNm5Jckhu?=
 =?utf-8?B?MWtWT1ZEWUlnM053MnVqZVhQenlCWmVnMmRIY1VPQytjK3NOZlF5U0R5Qmky?=
 =?utf-8?B?Uzk1VUFiMzhEejVvV1NqZU9SRndORStjc1RhdkRZbktXRUNMSTh5Y3R6V0Q0?=
 =?utf-8?B?RGd2UkxkNUhMd3NFT3lKZHhXVUpsNGJ6Y0VXSnVzd1JxbVhhUDlid25hcHVo?=
 =?utf-8?B?MnB6MVNXR3dlL09Zb3pqbmxHUGlqTWE1Nkc1c3Z0eVkvbDZ0ZWZ3ZGRvQ1lR?=
 =?utf-8?B?VzN1bFpkY1Z0SEVFd0VxTDFIWHF2cVBWNSt0YzJuNjRxRWFUTzZxdEx1bFEw?=
 =?utf-8?B?QjNFcmFBMUJzWWh6WlVkZXRXQjVWbjYzUmhpNnhZc2F6SGg1a3Q4VDNBME5v?=
 =?utf-8?B?QytaUXlocU51YXhlZExCSTFnK0J6akNuazVoK3llVmJIcjJuUkQwZ3NQTnBv?=
 =?utf-8?B?UVpJTDdhbGRXNUxLakxUc3RZeVVvT1F0RHNhaHhoZXluRnRHVEFUVDkrYzN2?=
 =?utf-8?B?TG9xNlU4WXJHWll6SXBQaW1hUkpaTTZPdFpNdEFFczBxbWpDT2dDck9TNFVY?=
 =?utf-8?B?QUJqbGtpS2tZY0xLYmJjdEpJaG5XQVBTY25ocUxwOXVyL1l2T3NyZ2YyY1VD?=
 =?utf-8?B?WHhuK2p1ZWhTd3M2YjMrb1kyd3A1WENxQ0ZoSTFqVlVKcUpCanFldW9HL2Rn?=
 =?utf-8?B?WmJQcVMwbVd1V3h4RXlHS2VWUzQwVXQvTEJUbmJjeFpGcDZiRWM1c2VQODhY?=
 =?utf-8?B?TDBRNTNBUlFneGJrVTF0akdYRURjbUtvRU1jN1J4Y3hVRG01NGVWQXhFeUdX?=
 =?utf-8?B?c1ExR2R6eHBUQ2JFTWM3cm11VEN1Mmo2UHZFMnZNallWOUVUS3BmV1RXaFI4?=
 =?utf-8?B?djAyQUdrNlNMR3VhYUpvbWRNWEI4NmVwU3M4bXdJUHFkMU1zYUhLQmpQakZB?=
 =?utf-8?B?VURjSjd4UmNESTJqWmpXaFE5U2MvZzNuNUlENXlRc2FieU5GWHY5OG12K0ht?=
 =?utf-8?B?Y1Vzc3hPZlIzVE5uT2Z6ZHUrUlpmRTloeE5lMUZ3bHovaXl0NU90Zjk4VS91?=
 =?utf-8?B?dXBua1B5a0NIS3JRZkVURFNFNHA5NkxkbjI2NHdNOW0rRFVrb2JBTnJyZVpS?=
 =?utf-8?B?b2VmMW9vQ0pGTm1aSlJNU2U4OTZuaXdtdTVtRzBoM2F1SVkwMUoxV1F5K0wy?=
 =?utf-8?B?ckwrR0JEOXhyRUhZWlhkRitRUUZsV1dScCtsMk8wS2RDd1lCSnBySFBGcXVn?=
 =?utf-8?B?N1M0N1o0S0RmNlo3M0dBZmltQU5nRmZQVGswQnNVRnhUazlUODMvTVdMVXhH?=
 =?utf-8?B?bTh3MlNCcUZPSU9NSFdHQ3lJemdWaTYyTUZzQURiUXlMNGpOeHdmSFFYMnNB?=
 =?utf-8?B?b3AyS3F5L2xPOWNDcVdZZmsvQVFYdWFGQ01LTkhzdDUrTUJzVUh0cjRyVWFS?=
 =?utf-8?B?NW5zMEJQSnpFSDN1ZFBPb3FkU0FHb2RHMDA3YWJYSmxTRDhEZFJqNVIyVTRI?=
 =?utf-8?B?c2xIT3VUZFd1TTlBK1VMYUpZUmxjSlVvOGVhNkZSZWVSWDA2M1hSRTgvWjh2?=
 =?utf-8?B?aGl4YVR3dnk3WnJPR2t4UmlxaktGc2pSWFNDeFhxczZXOWpzVmRUVHBvKzhi?=
 =?utf-8?B?K2hJVC9zK29RaitPVXJLVXJyMnZVcGtCbVp1c3Z6NVE5N1lUUXZ3VDdxaGVG?=
 =?utf-8?B?UlV4VWZxQy9iVCszenpoRUpFWmUycEZDVGcxaGdhRUZZKzZUZzZNRENFOVda?=
 =?utf-8?B?cThNQk5aWXBLbnpVTU5lNHpyU3lKR2Zkak03VDd0OWFodHVIbmQyWGpWV2JS?=
 =?utf-8?B?MGNvYm9OZUZoc05IakhndG5tM2lwVGxiTlRYcUJ2U3VvQ3pWYURUN0s2WW1W?=
 =?utf-8?B?U2R4Wjl5dTZFSVFYVmRkU3FhMmlnMmFzaVd2VXJGakJmNXFUcDdyNUcrZk5z?=
 =?utf-8?Q?fJAxMhl7RaseGJcie15Xb88=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NkVTdkdqMDZQZVNrdUlSU0NnMS9IRUE1OVptWUR5Z1JvLzA4R24xcExrdjE0?=
 =?utf-8?B?eDVRWFZwR0xvems4SmZCMUMxazBlWERjRXcyNDRVY1FXRHZ5UmRKaVBNTWp1?=
 =?utf-8?B?UzJLNnNZenVQL1Z5d2tPTmZsK2ZpbXNSSW1RL3FOVjJvbStLUjQ5SXZ3ZVVW?=
 =?utf-8?B?b2FHbGVtUTBhL2g5cVJZUDFmenl4b3FWai92K0hrUE81QzVTWjFqbzRyNmIz?=
 =?utf-8?B?MnJwWnNaQkxDcVIwWU9COFN2NE1QcklqU01JMkRXdmNnQ2dzNnE3RTFyMXFM?=
 =?utf-8?B?aXZNdFNhdlVxbWZPZVVXT2NidUJGLzBFaHoyaE9OakY4L3JHODZFeEtzTDBk?=
 =?utf-8?B?UTZCbGRxaFdmUFRlYlBycGkrZENsc0tNQnhqRFhwcUlWTnNuQXp3RUhoUFUw?=
 =?utf-8?B?azB0SlMreFFXaEJBcGtUQ2g1M2pOVGVFNEJ2TU9hR2M0WEhmOCt3ZTIzaHRS?=
 =?utf-8?B?ek56bm5lRndWK2tCejBURm15YzlOZzloMnUyRUR4TzNCdmdMWUhjRHo0cGxI?=
 =?utf-8?B?MXlJMnY3Y0FpWmQraGxwdHo1OWVid3ZrNnoyMmM0Q29zOUhjNFl1V3E2THlu?=
 =?utf-8?B?OGM2d1lid2Y0dU5PUmFlRW9PWThUWWNVbmFnc25zNlo4TzVKbC94UHBmNTda?=
 =?utf-8?B?NVk5UEUzUkJ4dHJOdVFoYWFGVDRoOTlDaWdFbStOemlSZmI0RTU3cjN0OUwy?=
 =?utf-8?B?OG1OdS9LVldVeXpkcnh5c3RVSFV5aHpSWkNic1NwdTZxZDkxcVV1eFg3L25X?=
 =?utf-8?B?dVY2RlhCSDhPZWUxd1JBLzMvczhYZFl2ZDJ5aFdHUFk2VEJDNjNjTFBEemgx?=
 =?utf-8?B?NWhqQm40YU5zSHlvRk9kRkJ2MVhOY045eTB1TjBSZjdaK2VKY0VZOXVON0lY?=
 =?utf-8?B?T09PZlh3N2l1YXpvbnlrMkx2QklxYzNYOEloZndzeUMyNGgwYVJ3dnlvK0FT?=
 =?utf-8?B?VnV4d2lpcDJQQ1JSSzJrc01TdGRoS0tiWjlERng5dzdEZUhtNTZndkhqVlJT?=
 =?utf-8?B?eHFZQ2VRNTFYb2JwdGRtb0ljeFpVbnpWTFJmeWx4Nm1BUnlTQWlmaGVzY0kv?=
 =?utf-8?B?VWNrbnFQQ0lhNXBmazhySjZKTVlVUGlKWUxiMVJBNmNKQ0FlWUxmNElVMlZW?=
 =?utf-8?B?bFpKbDBHeUp2aVpsV1RjS3V5dzluMmNEVVlSaEJ0dGROWGFZWUR1dXpwdDdy?=
 =?utf-8?B?Rmx4WEhkdk0zUUdqVXJYL1N5U0czM3VyN3ZYSjk3VFMvdk1FVDhua2w2bmc1?=
 =?utf-8?B?VHhLRWJzYmZWSFZtbGhzMy95ekx5VlkvUTdFbThDMUNMMy9VUVhJTUhnbzFE?=
 =?utf-8?B?ZnlkakdlTURQY21vNU1Qc2lmeUEvQURYcWpqbU9nRC9rbzdLdTB5eTdBQktM?=
 =?utf-8?B?NjhLdElteGYwdFBVU3ViU1I1VUJMYTVHeUEvbFNwUTNJQi9NczhPaHpDQVFS?=
 =?utf-8?B?WU9KN0F1Ti9PUk5LYXlUaGNOSlNTb2h6NWlTMk5UbVNyRVdwVEFCbDNXTXk0?=
 =?utf-8?B?VDFrVFg0bGYvL1N2bm5HekdMdDRJUDhjdElGMHlFVkFwYjl2ZTBLN2RhTS85?=
 =?utf-8?B?ZUgxRWltT3FCS1NaQ3MyaVhhdS8ya0hBdTdJUjl5UjBrcDUxWkRjaWNSR3BG?=
 =?utf-8?B?R0w0d1ptRGZPd3NteTRHVDlqcW9NUWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f1bed32-1854-4bba-4dc8-08db0ba6dbcf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:39:08.5986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VIe0KXS/+m1ky4P1FLHrPh3rZY5jBdQRDV9xzAWMN1FWFWcsIFtGoJZF0QcyWi8UNysoYBs/Q15YIH2jY6Uo3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7522
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100176
X-Proofpoint-GUID: NA9lnfuEBtObvn3zgGK87yPlviIqp8GM
X-Proofpoint-ORIG-GUID: NA9lnfuEBtObvn3zgGK87yPlviIqp8GM
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
index 4df41695caec..a471bd480397 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -15,6 +15,8 @@
 /* Handle ro_after_init data on our own. */
 #define RO_AFTER_INIT_DATA
 
+#define RUNTIME_DISCARD_EXIT
+
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/vmlinux.lds.h>
 

-- 
2.39.1

