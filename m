Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589996927F4
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbjBJUUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233690AbjBJUUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:20:47 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA86E81CC7;
        Fri, 10 Feb 2023 12:20:06 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AHwlMI001695;
        Fri, 10 Feb 2023 20:19:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=cXu8P8jFOr5SfPBGxXeFFA6K9ABsuFEG4QqyuNZVVno=;
 b=ASKP5NiRUUbSixoNDs8SytIT8AkbqEdjUIlACTTXfi2RXNG68LFgkr30tF3BXDTA8id3
 iOJmm/cOmyb/E/l7oVJKlE1sARsXLP3SnXVV2Z9JmcvQ9BA116Xq4sU6l+3CQqOmFh43
 sBb8RwzXH6YRz56H7zgiMhDU/GNLMxFDxZoCGz75TCWX6iG5m9NEAakC3HODWLom+x50
 SLuICeMAnJWO+g1JyX3THBbz1w6OeC9582CgxCssY8bvleJF0Ehdr232haj3+JuxwIEu
 j/odbwJCBEAS21Nbe8Yuc01a1GP3QmT6Ib5NsAAXoHFXoD9NTnzxE+80HK/qD/kP7gOk Kw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfdcp8xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:19:06 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJXlHM036113;
        Fri, 10 Feb 2023 20:19:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdth2bfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:19:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HTsrX46bn3HT4yTtJVxkxHkpze/7P4JDUuLdGX5DlLirAVDnBvR0POIXo5FvdqmsdNNeQfrWi4JGna/eD2L4eewo/Iw3fEqMZjxqn9EXeYXVYXdFoP8qJw3Y8omHTfJjfsij1aaI2Nt9BVFgbHxvPnVyMPmRe7aTtbBKfb2fXHCiZnHiCf6fsBAy/5EnqE9UT20PF9tFo4DEWGp68foXnL4PwCVu51G9wk6E7LkcEXBug9yTJA4plMIurzr9UsfYuAQbhAwtM9xURuZ4B1HhcegMeKPAPWqu5goZ5VJfFeQHdZG/eFtEZ9Z2JXVEX/RIn82zceTOey0ITIzcWPjv9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cXu8P8jFOr5SfPBGxXeFFA6K9ABsuFEG4QqyuNZVVno=;
 b=Z9zjwH8TSHASo1h7nSE04IE6YInCft7RrhGFq/mO2cZYQhNC4r1b5OyzXRYw5hdXmUAJ+GoLcvtHwsbrixtZb3kT0nUAyfy8zIGsYUarqhzQWcpSkitgDvxBc6vzYljp80SphwJ37wdIB/vNTxoithAfM+Zb1Tle213x1X5nfn/tdYRUkGq+rwSsYcHHnaXtb+s+sm7+ydpgbvHrud24A4mMyI8MqqDoZNlVw1i8c8FrwkCn43zmMfA7rdxLDuFbpl+91Cu43WUqdbo+/LQRH3tCkeiwhgQ5nB4BC2bMkf+lPqj9LE+V2LrSz1RI8gkTUddzIKgXvltkIudhwyJOKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cXu8P8jFOr5SfPBGxXeFFA6K9ABsuFEG4QqyuNZVVno=;
 b=RAqTW+VojSpuhOutFRlpbq6N+FTaWh2qlexnyiltKdnrYRWNiDe0Fv8GfAxCitf2WmJ3+VFunEztGXie+e1XHknsobCwfaEbseu1cWxPKGtj2pghgJ3GnqIQPLa76jand1B73ZphRpr2XWwx1DU4+m7QODLtzXJ5RtF/Y5FjNLA=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CO6PR10MB5652.namprd10.prod.outlook.com (2603:10b6:303:135::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 20:19:03 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:19:03 +0000
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
Subject: [PATCH 5.15 v2 4/5] s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36
Date:   Fri, 10 Feb 2023 13:18:43 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-15-v2-4-6c68622745e9@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::25) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CO6PR10MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e57d538-29b7-4891-c7f8-08db0ba40d66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UBkuRLuUNKagC90vb+oMsqjSzsILdcNZfqX3PRRxqi4IYwqShf9SktI90DA4uap7SgHavFnUNgio73Zw6sSHqJbiMSDfMthNUOqNa5qxI5l7xSo1IGYaxtq3ak+KrTa+F9W5t2KT0vHP9l/wKId9axAZ9BHS1oivy/SXL6FqsY18YddULAmZ5uE6RBukEzs6WqVnZ3i0dexwOkjRRk2maabqV8Lx88jaySeuyymDWnAWXJZsl0IX4n3luCh8oAFpTzbK19WHcjf3ZEeOwxxYjQYrrNIFhIVi6pmqH/2DYPVW/i1QgSthUpk9J31+31NQu0wxeq4F7epH5lngXXW67Ygi2RH3cZJmYuq3eonjZPJY7HBmj5UJ4/Z/XZGwXJh9BcfyEsFuzvVntKTkFC0AH3JWaIAajq+K/YaWEt+FDJwDeQdhduj7Wkn5jH5OpJ9SLMWtQhAJoFnKFmEIaiVhKjxKLWqLc8iarif+bfmJuKApOENgewNgBlRrjupybdo6At+u4nZ4VjDg5W8hEQImKzVFA7qeJyYEzMJ+UmoRXPPsVuiIijI25Y4Rw3MGT/TR2f8uc7iVfwOCiQRDq8+vQ9NlYzZ+m8hGjjgxZR+azEjOMq3t51N+neld+qC4S2Ae+9HnLZca3ommCjKSLWFwF3BTgkl+xted8D8AscuMLavP1R85p5zPJHX4vtDz1kbOdwEWjS6+BHn42JlBlT2m3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(2906002)(36756003)(966005)(6666004)(6486002)(478600001)(6512007)(86362001)(2616005)(4326008)(6506007)(6916009)(8676002)(66556008)(66946007)(66476007)(7416002)(44832011)(186003)(5660300002)(316002)(38100700002)(8936002)(41300700001)(54906003)(66899018);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0dYSU04Q3cyWDF0bEVJM0ViUEVMOFhCOUxJTjIzZWM0VFZYVnFwVU95d1h1?=
 =?utf-8?B?RlBkdkdpamhBQ1VmZ1RtTWNsRVkyeXdWa0xpWEY3Z0NJRHc5THRPTXZaZlRZ?=
 =?utf-8?B?TmxoZWxpVEhYMW9qYTFMUWN5L2MwNEpoTGtrbUFadUY1eE1EckNEYXRadXYx?=
 =?utf-8?B?d0hhSUo2QVNvZEVWZzhSQ3VXM25xRFZ0dS81NjhLSy8yUHlrTURMVVpFUE9C?=
 =?utf-8?B?R09PVWVYdmlGaXBHMzU0Q25OV2gwV2RBOHlVa09VcUNWeGlUZE9LeHlibWs1?=
 =?utf-8?B?T3BOaGtIWWlCbDlMVFh3Sk56Wk5mMDl2T3hDZ3ZiTFF4aWthUjhGZmFtTXRP?=
 =?utf-8?B?d2xiTFJ5UG1VdFdVdjNrWms4YlB0dTZRLzRaOEQ2OFdSMXVDY1lUeHY1d3k5?=
 =?utf-8?B?bm81QUUyZVZobk1PajdrajdnTGtBMHlzNkc1MG1ObEx0Vlpyb1hqVnFoeUdB?=
 =?utf-8?B?MU9MWThGUGwxQ2g5b2F0em5qRnBsVitJbXFwYjBONjNON0hBY1VZSzhHTVNx?=
 =?utf-8?B?SmxQNzVFSUpCRWsvU0lXM2ZNZjdCTFZQK0s0Vi9takpRcEpyY3Rrdkdnc3BH?=
 =?utf-8?B?ZVY0Z3gzeHNhTDdQa2NqUnVVb3lMR0I5TGR0UU93K2R2amI1YjRkbDdWRjBG?=
 =?utf-8?B?Mnh4d296Q1dFdSs0bnJuQnZINU8xUmg2RTU4ZExodENTcm9uRUVkZFpiWm5a?=
 =?utf-8?B?NUtuYjUxYVJQRXQvR0c3Nmx0YzNKQ1FVUVNQYlViWGRVWUNXUlpqZGdKamlu?=
 =?utf-8?B?OTFaYVZGYWVreXVOKzdkT05rNjIwVVo2enRTQW5xK29lT3RHWEFUL1NoWGcr?=
 =?utf-8?B?c2t1Q2Y2VWFqbjZXVU10Q1g4TXF5SHQzWndxQWtGNlFVa3Ara051UXJwUnhz?=
 =?utf-8?B?ME1SZE1TakFrSWFnMVl5V3ZkNE5qQzV5Mi8xdTBHcDNKdlRsVDQ3REtLVnd0?=
 =?utf-8?B?MWNzUTk1d01HZStuMCtmRnZ3ZUlGZG5lVW4wZkI5d0VPSjNqM2tGUm0ySFVj?=
 =?utf-8?B?Z0tVVEdmYlhwc1pkQmJJaDBWcXoyczRxZVBUUzJ4SGpBTXR4czBDelFCdlE4?=
 =?utf-8?B?Q3Nhc2czUDN6M0xXVThocjZ1cDZ4TjREUVUvZUtBRHZ4L3IyR3ROK3JrRmtG?=
 =?utf-8?B?RlRYand5LzBZVmptQ25VOFRIQUc1VXVjNSs1a3lrS1lZYnFsbHpFZTBkVFNG?=
 =?utf-8?B?UCtxSWd4YTl1QjBhVDRPQmgvVGRXa0pQeFIybWlOcEUvVS9NWFdKM1E1S1VK?=
 =?utf-8?B?cC96TURjeWNBNEJjeU9ta2tUVlpPQU1nWGM1WVlJL2U5T1pjZ2EvdVdtN1oz?=
 =?utf-8?B?RGRMWDhjQXN0VUtJK1RIQjMyZHY0ekl5VFVybDFXVEswTGVHeE1lSGdoay8y?=
 =?utf-8?B?SjVRQmNUME1XWTRCcXR3ZXRJWWhWSXJYTkYzKzFoekJGMHlnZFBPRXAzYllT?=
 =?utf-8?B?TUk5UmpqSG50TW5CUnpDYXVXZXpmYkQwMmlvTXVUcUJUcDI4SFZNbFJ4bThi?=
 =?utf-8?B?TDU5L3ZsWTJwUzVwVTZib3EzeE9YeUZHVzhTM29TdVgySEh0VkZMTHRWUm5C?=
 =?utf-8?B?WFphM2RPWnMvdkxtSnN5c1VWaG1MTy82ZlJrazcxRlo5MjF0dmYrSWJjQ2J2?=
 =?utf-8?B?NHlaa0VUbCsrc1YvSkpidmNSMkZsU2MzK0l1WEpSeS8vVkNRdy9yU21NN3A3?=
 =?utf-8?B?amd3M1Jpc1BxUHFOMVZiUXYyTHFMeVhGU3ZqN0tCVGNuclBVOVR2UENWNWdX?=
 =?utf-8?B?aWFnT0VIb2lMZ05nVkJqSUx6ZkdmTGh1SFN3dTcrSWlSMXR5OWp4M0RsWUF6?=
 =?utf-8?B?d1pCRVBkQ3hLWGJZaWg2dS96eWxKakFVTkpXdjlMaEFtWFF0ZWhlZ3QzSHVM?=
 =?utf-8?B?SGxlblUzVFdxdjBQajN5VG95MEllT1oyOGlMRlJ2SzZ0M0RYY3dkdFJ4SDJw?=
 =?utf-8?B?U3cyOHhDUWNyTk1zNHA3eGprazhjbFBxRWJrVHM3V0pPS2RoSi96dmJmOFg3?=
 =?utf-8?B?anhUZVlVbzdwMW92cXJCdGdZaldINkRub0Y0YWVWWnl5d3o1K0dzZFVNRTk5?=
 =?utf-8?B?SDI5d21GcE8rQnU4aE1hRURmeHVoWndJY1k4d2dhcm9LZUJVVlhLYkM5QWU5?=
 =?utf-8?B?bko1aERvRnFid2w1R25LTGlwQnpzdExMeEJPN1dURWxLMW1DdDc2c3huTG9z?=
 =?utf-8?Q?of5w9U4p2snv9hyPxqr0vPo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?T2trbUdKd1hHbFJwMjN3RFVpb3hVVEdtRkxUNWVLZndKTmU5YUUvcEZtVGNy?=
 =?utf-8?B?clAzMUhJeTR5TXNTK09qOWZvYmdSempRK210RUlGV053RnNNL3dMS2hRMEhH?=
 =?utf-8?B?eGRRUUlYMUNVeGJVQVFGbXd6ckFXZXkvSGlLU3JJa3UxanUzSW9FeEpsZVNj?=
 =?utf-8?B?TURuMkU3ZEZqcTJzK3N0cVZFWDNVK2FtamplckwzVWtHeU9YUmF0Sm5rNWxr?=
 =?utf-8?B?Wkl1ZE9acENaWkVaTTZTbkpVQ1lpaGtNTTNDTitvWDVvVndsT01KRzlBaFFZ?=
 =?utf-8?B?b3lOV0dQTWdhamlhWER1UkU1ZkZCL3ZRZ0FWMUdMb0hwYTN4UlptanhBMTlr?=
 =?utf-8?B?Z3FiT0R4Ym9abllYWDNWamlzOXdjY0V2anRKY2l1WndpZDJwQkxUYlJCWnZE?=
 =?utf-8?B?TkRIQjRDNzFzVEt4eXh4NUZCUE5YcW1aOEwrWUFhbjBVV3ZvTGFMQ0lqREpj?=
 =?utf-8?B?QlhPM0U0RlNXRFlYSXBFdWJRSlhWMElkS3ZzdGpjVkUra2VKdjUyK2Y0Unp6?=
 =?utf-8?B?TURrMVpUWXpCbzJqUkVrb2tMMUQ5RmUvTzNpaE81cUlxY2NiZlVOTGpxb3Nh?=
 =?utf-8?B?S2RjM2JxVTRwQmlIa1dRanlMQTJXc21Rc2tjWExjM2RnUFFBbkV3VlJJMUZN?=
 =?utf-8?B?NXl0OWsyS0phZ2xlNmRNTFpmeGdNV28vUkpnZ0lQTmYwbHZ2YVRYTUpIak1i?=
 =?utf-8?B?TUhPV0VQVHFBdVd1WnlzU2RFRUpoWFBsTWlHaWQvdnNjQ1BONC9ubXhJVzk0?=
 =?utf-8?B?UXRGaDNncG5PcExHU3JwYklHTFB6aFo0Y3NRdGU3Mk5maGVqalpiYXUvcDZR?=
 =?utf-8?B?L29MeE1sRzUvVS9FdWhCV3lmMjdsOEFWMzcvRnMzUFRwOWNEYW05NUFZVjEw?=
 =?utf-8?B?RytlQnErWUloOFFtR25KRy9vdFdvZVJ1RzRvREdManJZbCsrV0dwRy9ENm16?=
 =?utf-8?B?UkkzREpNY096bGhtTDdsZ0YzcjBVZmtUOUxWYUxaSDI2ejNQOVltSE1DbnFq?=
 =?utf-8?B?NjhLcnRoemFGcnh6S3kwSE1GN2ZBSEZ6YkZJYkp2M2l0Ym0xaGFVQ2pNbEdy?=
 =?utf-8?B?TmJPZXBLL0VsbnFNTCtuc21XMDdmTkNibzB6THp0MWJiaWVTaFZzYThYWC9J?=
 =?utf-8?B?dHlGdGRvdmZxQXNJREt3OTFKTEFsZXI4Zk9idmJBNDFOZ0QzaDNnN2NhUFVk?=
 =?utf-8?B?MlM2c3A2Y3ZRL1VHZDJCN00yV0xEenhrTXIra3NlY3I0OCtiZ25hRmdnZXlL?=
 =?utf-8?B?Uy9RcmNyeFR3K3dJNnNGOXo2SWxGRWJYNldaTldoenJlSDNOOGx6MXZSMTRT?=
 =?utf-8?B?MHZxTVBZNjFWbzBXMkhVNkdhTlJEdWN5ZlFPaWlFWG9RbDBNT1RTaGsrR0NH?=
 =?utf-8?B?eklpZHJRMXVFTHB0UXEvNnczZkFRRHpFa1NyU0xEL3ZtNzhtOUxIbDZHRlhU?=
 =?utf-8?B?MXZhYldHNzBGcVMzZTdjTTdwYlBQV3VlSENhdXVIWjd3UkF6YUJKRW1uL08v?=
 =?utf-8?B?c29ycW5Db3hMa0VaWWt1a0NQVE4xbGpKVkpRRlc3MHZnZ0U0bHQwVEZybDdB?=
 =?utf-8?B?U0JpSVBoK1R0RTNvbk8zbk4rTERwRzNnQ1c0bjU2UGlGU3NpUk9OWWJtMGNx?=
 =?utf-8?B?VVJGNjZiRGUxbjcvSGdLbHZxOWdOWlE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e57d538-29b7-4891-c7f8-08db0ba40d66
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:19:03.3563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YsiX8whf0dW9Sg2rrigKGKAHms0/Gw7CwusbS0CJeCh6qiA+8VMUNNHWQ38HIwUW6kqdJIKYRD+BnL0DhM1DoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302100173
X-Proofpoint-GUID: bEow438rYqIWrn5vyHohVDiNcm9q_omq
X-Proofpoint-ORIG-GUID: bEow438rYqIWrn5vyHohVDiNcm9q_omq
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
index 8ce1615c1046..cdc8b84b2db4 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -17,6 +17,8 @@
 /* Handle ro_after_init data on our own. */
 #define RO_AFTER_INIT_DATA
 
+#define RUNTIME_DISCARD_EXIT
+
 #define EMITS_PT_NOTE
 
 #include <asm-generic/vmlinux.lds.h>

-- 
2.39.1

