Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4116927E5
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbjBJUT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:19:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbjBJUTw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:19:52 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B00B7FEFF;
        Fri, 10 Feb 2023 12:19:18 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AHwebP007747;
        Fri, 10 Feb 2023 20:18:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=VL5ggjV7l8uquv3Cdfin43ZELlq/Zxr4naWQDZOYm1Y=;
 b=W/GIc7nrI7MFIc9JUnL9+Tvb4IO2bi/RXJTUE+34zqwcmvt1CWJbMm1f5q0A0g76OgEW
 ukFC0K7HSpOFCjxgGgI7wgFDieBoKfKI4wBwHR+AX44CTQ7mW0b0Tvfhxm1sMgkTR1bM
 NUD0jJPRlXlKQXFiyAZW1VHjV90GLa9TpNukli5jkyBK/7ZHIe70xxQlzY4DO+IliKUV
 ggJRSkIrPVbBIg7E31VVZETGdw/9CYY5NfYfL011n6xHHuM6nnqOwgk+QbEKhzBNdbqZ
 rMd3T0ccMnuLmXhQd+dTzLqnJJGhzSveFC+IxGjG32t3Bl8CLmZViHaTDOP9p82nS1Fa bA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdsdx4jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:18:15 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJwtH1025741;
        Fri, 10 Feb 2023 20:18:14 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdthtdft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:18:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rs406FphfbBeoHtKIwaljwBA1gveOQlHqduv5uyJRNH5lTq+daFpGFIsMsxpNVpbSzBabeGrmYMIrmZ/zIoi/tQMyBCSGq5nX2mb14slOFAdRRT/OLRQ7gTxiGMkk01u7lh0OzlxMAxLJtN5HX8i7/jC+wOM+JQPUZW62lDrrJtTCUtIk9t67tK8aqWax9AalJ3DrsX5Sh5kJDY0TiqZQNAfK6FAs4sR08+wZuzLaYKaKUt32cAQK9xRZOkiep2iZ9wQfxZ7PIYOHlHYafCgFktp/FZOK9WVM5IyZRMguz6wnnsD3ADPp4ANuEaJkNLOZlzxTmvKhDz9fnxtosglTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VL5ggjV7l8uquv3Cdfin43ZELlq/Zxr4naWQDZOYm1Y=;
 b=keZW9umlV2pnhC7ghCjEPymRVFgoqf+4AshCM2jM+SnT/hH+uedcSBF8ugDU5fUfWw+YuhUsUBLFAm/4HiouXMZ0Zs94s/rgltE+Gk64Fn3cCuB1ED11fzJLSJkn7qf2xzWfqO4aLLA4h6pdzVCxgg3FJCMio6Hk9Sn2cR37KaWIcy/NXaw7Ii4JLw/ChgRJvCfKj051u1fAjP4LxY6JH8uTw9zo8neLHAhfSjnoEp7lAMq3hp2EIaAvV5YpueskQlv6bIxXqRKq5bLvwB7ISOkRA4JfB64cZ6/cu/6BJL4CRLAuoiSIug0W4bmqkcKYeiwcVj6CwVDX9C9CTaT/TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VL5ggjV7l8uquv3Cdfin43ZELlq/Zxr4naWQDZOYm1Y=;
 b=QJoMNft35VilAROmw9MrlREJiwjwTLabuHTIuXHEi+KwVj9WPSgaSjlP9kCG0/vFrdjfHhrklBJyVqBFZmuTGoRWG8R7RpHKQqCz4Gq2Mx2sScUQI28N4btLnUgTqr06rmRaZgMIfjxz2O09EQ7xEvUrK+a+k2MHmO3YbEsqSgo=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SA3PR10MB7093.namprd10.prod.outlook.com (2603:10b6:806:304::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Fri, 10 Feb
 2023 20:17:54 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:17:54 +0000
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
Subject: [PATCH 6.1 v2 7/7] sh: define RUNTIME_DISCARD_EXIT
Date:   Fri, 10 Feb 2023 13:17:22 -0700
Message-Id: <20230210-tsaeger-upstream-linux-6-1-y-v2-7-3689d04e29fc@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-6-1-y-v2-0-3689d04e29fc@oracle.com>
References: <20230210-tsaeger-upstream-linux-6-1-y-v2-0-3689d04e29fc@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0364.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::9) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SA3PR10MB7093:EE_
X-MS-Office365-Filtering-Correlation-Id: 81e5d8b2-aafe-41c8-6002-08db0ba3e40b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8AqdQ8XPfS7krPaG9CSNVLKOGHOFzjubzURgCtwMUieAHdT/h7/IBsV2aHfHkItHzSmXpmH+JA0d1bptcaBdOo4oXZCOITXXEu6gzQtxaQ6P/caXuG8exCTswpoVVVfBsPlXl7AJmRECVP0f1O2K6Nc6WJ8nM5jf1Lh1a3L2N8M8dKjHRuraf0/jDvVXGDyX8EmW1UsWEfKkLnOXzfBsfUXxipljWuXYaCKvE8Ea8gnAfllKIM31xg3L06p5GoH8DlgiHyxpN/livR+Zm0BL87Q9vf5s3wiiyjGrzashLVXHIGx93LZeFMarYvWXR/JlTc+QaG/ut+44N+837siMMvx0XwRveTRlcOjGSWTlVkueqQC9PGLNDST48GR7yTucfZsQ43DyEJ2n3g8d7gfIH40jMvUJ60DfvBKWnoQ8gUq4+dDa/hswT+pl7JsHq1/uE7Xj8+oOmVSL+QsscOgu6oLEhCfyAD0/0KOWrdZwhCLHD9YctiY3yi7ecstn2kLd0g/GfuMCJBmbPhzL98suetCBxNGvptaRJhTHYjWKIjomoJlW+CUx+veIkr3Z5a9KR+7E0gLN8IAa3jAyxP781CpFUkF9fwK8P34599rFH+0djSxwHjb9m9wljpag/jPDOiqnc5f1+OqWp2ziKygW6Q1W3qig+vxV896bkPqL5XWZnmT7UJlIuVpUP7aglF+ouh4z6E9mkgvkUhEn15cAfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199018)(44832011)(6506007)(5660300002)(7416002)(186003)(6512007)(8936002)(36756003)(86362001)(38100700002)(2616005)(2906002)(316002)(54906003)(6486002)(966005)(478600001)(66899018)(41300700001)(6666004)(66476007)(4326008)(66946007)(8676002)(6916009)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cHloSGxteHBtWlp5dFlYSWs0WHMwemVtdFdtTERyc0k2Ykc1T3FWcHZnSXhp?=
 =?utf-8?B?bFY4RVo2SkZQREJ0SmgxS0ljbDdTSUwzeXpzcW93Szd5MGxZUCt1aXAwemUr?=
 =?utf-8?B?OEExc1RWZ3I0YkxKREd3SXVjWE5GaXpjMHBJWVJjNTBnNXdlSzZsYnZ5VmM4?=
 =?utf-8?B?aktsbFhpNVpYZndRVy9RbjJUTTV1SVNtU1lrcWIvOTBpaFNMTlYrMk1nMFQ3?=
 =?utf-8?B?MU5tRkEySDYvbWRITFpLNFFSNEUzZmgyK1FSbzYxWG9EWEt6N2M0NlprNXNP?=
 =?utf-8?B?Q25UVlh3UVk3MEhuSGNLYVFic3lZZzY4TUdsQitWSEhTT3R2eGdJT0lFdDd5?=
 =?utf-8?B?YmN1WVJQRlFLS2liTjNZcWpiUFhaWjhNenFQR1BTTVp0a0lCSllxTlVUZml2?=
 =?utf-8?B?eWN3d2NjY01oR1R5ZHZNSWZKY0N0Rk4yQ3BNbm9RenU2Tncza25MUkxNSjlx?=
 =?utf-8?B?ZWJXM2FyNnVPTUI1dk5razM5ZlFtZ2xQd1JDQmxCWXR5aVVGbmR5UEhzT2Na?=
 =?utf-8?B?c1A1SGUvUEhveHJxQ2pUQm1vMEVCZUtQRmFuU1Q3bTRyMXN1enVUc2Rva3NP?=
 =?utf-8?B?b3hVWi8rMlhFYjRndTg2RHlmUFYzeDd6dzQ3dnEvWTdBYlMvb1pyTUxKYVkr?=
 =?utf-8?B?ODRlbXR5YS9PWE1meEVmRVQ0SERSYnFKVE9KRzRsT1cxajhMbWhabHZNRUdV?=
 =?utf-8?B?U29zYVd2bXVYWGhlK1lvUTIwL1F6SW0zRzdURmEwTEZXdmVqeTJudWptUnpY?=
 =?utf-8?B?Q08vaU8xL0xNamF6a0ZhQUZvb1VGOGNCSHBRYVpRaVJ2SWlsaHhVdFQwUUNW?=
 =?utf-8?B?UEh1Y28wdWphTGVGL3RwTzBpYWRXUzlpQmNFMG5OR09tMDE3WHhRVlVoTUs3?=
 =?utf-8?B?TWZ6MEpRVE9rNnI3UWl5c2J5eVQxSy9zWFV4SVdkSThZUEJWQzNsTmpKS3By?=
 =?utf-8?B?NXZWelduempEMUZUM1RIVlBPTFB4UDVPdytjWTlNNENQcUhqSnFPWGplY01P?=
 =?utf-8?B?dnhzUGdxNzQ3QllSNkcxOGYzRnlUL2djaHpkTmdra29ERGJ2ZkdjZ3VTVE1z?=
 =?utf-8?B?VFlEUkh5SDY3dGEvczI4dm9Ud1ZjM2xOT3hFbXlXUE1qS0UwOXVjSUNjQkVV?=
 =?utf-8?B?ZnoxYWNQcWhKK2NjVjdMNldTWmNMZ1pRNXBiZGR0Q2NmWDBFVnlERC94TGZM?=
 =?utf-8?B?WEtLaWJOZHRPSkVsdFVyVzRPY1dyU2NCcG1veklNVUVpSVhCWG5xQzVsOEF5?=
 =?utf-8?B?OWN5Y0grdVhCbGRHWkpDeExtcHJOaGRVOGVibzBoYmhwOEEvUERsL1dOb0pw?=
 =?utf-8?B?RVVobG1mVWRxUHZkUUYwY2xsRlZWU3AzZGt3cUhaeTNDekxMQ3NDWFFkczcy?=
 =?utf-8?B?NjNqbzhHRm9jbFVHaU8vcGpyRVltdHM1T2dKV01UOHZDcm92N08zSFdKdW91?=
 =?utf-8?B?cE5TRGJQSUhHRnlOSU5kRHNjWGhRMGJjWTdObTVrQWlZUzVpeVZlMnNvUVJE?=
 =?utf-8?B?V3UyakFhb2h6SGxFVUl3Q2Z4WCtyOXlydWlkbzZwVG14dDlQTVJSOHArdlh1?=
 =?utf-8?B?YmdYRm5LRzBkZUN3eVBKckVTRFh4NXJKK1NLVDd6Y3lQMWRWUXdPQzBrRFhQ?=
 =?utf-8?B?MTFwYjNRdklSWGQ3OUpmUXUwUGE3dWhJeGs5M2NIeDRwTFhBUElGcUxUemU3?=
 =?utf-8?B?OWdTSkxZTGVYekdZUDdka3BuNXNPazRzNCtwUFRHYjBoNFFBV1RPOE5lcnc1?=
 =?utf-8?B?bWR2MzlBZHpwWE5meEJ3cGhQY2pYVllLSFBiS1BlSHkyZjBBWnZQbDFSMStD?=
 =?utf-8?B?L2NzODljbG53QUpVNEw3TFNUQ0tpSlFqQmNlUEc2ODRkemVJYStSaS9VNU1l?=
 =?utf-8?B?anpWTFA0bVdOL3FCdjFqTnAyMjR4TGNKc0l5YzVHZC9ncGpscFdZSXR1YnFi?=
 =?utf-8?B?UjBMRWMwTGNwNkcxbGdUeElPSDE0Y1hsN0RDclpWZ1loY0Q5MTNhYVJ5dnZ2?=
 =?utf-8?B?eTRVdEhiOW84ekc2WWgvN25rTm5uazd3MDJac2x1V0UyblZtZkFNU0FXamtx?=
 =?utf-8?B?VytzSG9FVE5qV1dqa3N4dUpaYXB6UktVVW1sQmFGUEYwcVJFNi81SHZIUHVH?=
 =?utf-8?B?V3hBWTYxY0J2ajFkT2JiYVJzdkNVWm5vWDhuamZjdzVqVkVNbExwQjM3M1kr?=
 =?utf-8?Q?dvMvCZDRIk8UTZAcSu+ImWw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TVZYUzhtamIwRkdxMHBsNlpkdzlZNEQ4WVpDTDVXWWNsUXIrNnRpbkxicjE0?=
 =?utf-8?B?TGJXemEyQUZLK3VRUHgvMTFiTlpJSGlaT3RSTzF3V3c4UGd1MzBmalZpL3dK?=
 =?utf-8?B?VU9XVWsxRjBrNXM5TGlrNi9CUFJsUUpTc2oydmlETHFxa2NIUWtKclV2Wjgr?=
 =?utf-8?B?MHNrRkFCTXYxVmI3LzhMZjR4RWc1NkpPUnZxeUlKc0RkbXgyZ2F4MEg4V1pD?=
 =?utf-8?B?dnpnZ204K2NpZysvMGpHdTFudURzUjc4NnB2UzRseVVkL1JURTNrZXYweUlM?=
 =?utf-8?B?dUF5N1FkYWlwYy9SY0hpaUlTUm5qTkdSelhPUG5FYXJVVUF1ei9Gc0t2R1ox?=
 =?utf-8?B?WGFNdWtlUUEyeUt2WTNxdjcxODY0bHJxV0hJbE9PMjRMZU1WYVBpdHBkb1do?=
 =?utf-8?B?V3ZUdTg3WU9ueUlHdFN6YndhV3d5TG5JMzlVOWFvdThOUXBRbW5IUE1PVTU1?=
 =?utf-8?B?bDQyL3hRNnJ1TysvUzZGcVMzVlNsQjgrTm02Y0hNS1hKY2puMnB1TVQ1cURk?=
 =?utf-8?B?TlRTcGZXUkZIVXN6Sm1POUhXUzVFZUo2RmZOcTRtWVVnSC9JcXY1MEtFSWY4?=
 =?utf-8?B?T2x6MzhjRWMxY205YjZKcjNQYzZyVFhQOGZ0NzJJaE5pdUJiVnFOcUttY01m?=
 =?utf-8?B?aW1CTTJxV0wwdmhRSkZvK1Y1VFF0dktWSzFmek41TmF2Y1ZxdE1KN2RSdTAw?=
 =?utf-8?B?M0dlTG0wMVhtVmZJc1RuV0xoS1dnaTRoMEZXK2FIeHh3ZVp0bWlTOHJPdFk5?=
 =?utf-8?B?d3phK2lmZy9YN3YrUyt4TENFKzc0OGNkODZKb08rRVZDMnQ0ekNZS1hNN01D?=
 =?utf-8?B?Y2tIZzhXN01Wa05yMnhEY2M0ZzFpcG9odDNubGptR0NJWFZLVXdqNDdhVGVF?=
 =?utf-8?B?S2ZIMkRmcGd5aFFDOHJCL2N4MlJHaitjelB6dzJwVzNQMEhqVEl1V3JPYjVR?=
 =?utf-8?B?VmFxa3F5WVU4cEErQ3ZkWUVyRDJhRk5Wb2R6ZFI4MGlodWEvYzd1dUg5d1pY?=
 =?utf-8?B?SER3RXJWNVFnR2p5dzZpb1FkSFBVTVVqSkxDSFZ3UFpJTThQak1vU2UyeGhs?=
 =?utf-8?B?a0lIODRlYkFyeXdDTzRLK2N1ZG5Yak1hWURseXpCZi96WmhtSFhXSHdld2dG?=
 =?utf-8?B?UUhwdVEvNWJpNlVmODVLMUVDOHpoZ1JCd3ZwRFZTdkdrTlZjTTJGV3J4SXM3?=
 =?utf-8?B?VkRKSkhtSUtWVlJ0WWJaaFpCOFJXazV4ZGxmMUZKeXNPT3pWMnplYytaS2kx?=
 =?utf-8?B?aGlnSWZDWHBoSUZrVnNDdkIvbHBnSEFQYW5ISmY2L09GeUcxUHdrOGRwdzF4?=
 =?utf-8?B?ZFFjcy9oQnZvbFlXRkJUUldGKy80Y3hBQ0g2RTFSdkZUT29tVHdjdUcyQmJE?=
 =?utf-8?B?YzVRNTZlV2RsbmVvcEpENFdTbFR4QmZHNUo0QXE3bGhsSlNUYk84bXB1N0JZ?=
 =?utf-8?B?b0FWRGVoRHlsTUQ5TjJoaTNnUXZreUNqc1pSRyt6UG1rNjlIQTFJQ0E2TzJj?=
 =?utf-8?B?clFKbGlvbWpETU5rc1hZa1VSTko1a3ZEeStmdzRBK01uSHI5dmNvL1ROQzFw?=
 =?utf-8?B?Rksvb3FyRmh6TDlJUXMzQnFLdXQzUFY5Q1NEWGJ3Sk5xbXJRRXN0ZkhNQkpP?=
 =?utf-8?B?Wk9VSmk5cUQ1Z3RaRVpFcEx5bnlWUlQ0TFhtYUJGbEVDTUJ4VUkwemU5VUFL?=
 =?utf-8?Q?lru2EVH3B7CfLrfJR7zD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81e5d8b2-aafe-41c8-6002-08db0ba3e40b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:17:54.1269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PvhofjoCTUxVVtFMXXMnIzzcz+Q+NIrFmHYU56+IClmAz27nfnJgTePkvzRZ9zuyeLw/uO86BoNne3fmloTkPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7093
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100173
X-Proofpoint-ORIG-GUID: sv4GhC7MkmmbobO4rVyUlYEkkaiEfDvn
X-Proofpoint-GUID: sv4GhC7MkmmbobO4rVyUlYEkkaiEfDvn
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

