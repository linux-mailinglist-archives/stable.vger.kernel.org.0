Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48E16927BF
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbjBJUSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233605AbjBJUSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:18:16 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFDA7290;
        Fri, 10 Feb 2023 12:18:15 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AHwhiP005533;
        Fri, 10 Feb 2023 20:17:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ey524uGXcjUpAwcDoiaooA0NVOlBB+1803iKQWrb5rk=;
 b=u9tfYc18hLaBggeuSGywGGSiMoI6SonOWbb8EleT0VKS/DQPgaVWc0DIWnbb/WDDmlRm
 JiNf4OIcT2/Nf/uUCpbKC+jVOtyA3XxK+sfx/anzBQ1t7BYZiTXCNqmYCpNgYNOaWeOr
 UBTEy90q3N0cyNsSc+Z1vqw0XM/shwqFirYeZNWGoFb7pZh8Wyk9JeRlHdR42Zm2p/YM
 iqQugBaSOKtUPKbdKl1N69rnhydIuoa3/srPqq504PH4dgsP/N3tTGL3dCR/2pBcWjz4
 q//KIW9t7BXx++quqM/HsZUNoeRktOZfnjoPKjz6L/tWB9Gow24RRTHtS8G1s0pD6nVN ig== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhe53p6ar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:17:42 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJXlTD002666;
        Fri, 10 Feb 2023 20:17:41 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdth9mry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:17:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kc9HBcICoKzR997+C3KY/ftM8kiJRJzyXU9JF/1PJgsm9wja+ZEzAaG4UTjK+HTCt3xv6cOCdbh65qOlTZS9i1jyT0X7fDelmWpWS72Wasdr696lmRhNyT3RJef7eA4/iq3IOW302Us7C4AYKQi8b4q2cfiHrHhy+E9URvoYqAsRn7ZDUFZ6ywkki+RuzxAFaJGmRPijXuK+hbIcRrUCWYCRejAp8jyYqyEUgz8GZ6emmBMkFNEzGmYC/dVfY4cpCRWIUNWjMDrO9kR3iYbGkcmSqPCzF75gFWsrYHp+ynUNz5VETYmsjx8XSsobKdE9ZmpJ7kbpYPXN66orga2XVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ey524uGXcjUpAwcDoiaooA0NVOlBB+1803iKQWrb5rk=;
 b=EfpYpdnK4IqSWrZF0ebLKKm1z0Knb5a46CO0sgM974no3cIaEqELuMUsxdtPHOP0yXO97t4fb0ENf/rv9XS94vk0L+kyDgjCf4E7/vKt2HN1nXYKRfqg3/HiNWuuh27yZO6wVk4NEWTCCF4y17Fvqxa/EvGzqmlX17JbxIbm3N9di/2W/LHW0Hoo8mjTKLVxONBir5JpKwMvru7WQbLZO7pOAmaCs/SDzU8LQNZ/Ghq4o+qG1i4N+6TeU7cyzHPMWsdSVWbxyI52IaH+QIFMzc/72Iqjk7ui2w4ZxgXhcJylITEqmAa+jSOE/NUA04AeuSG7OzkcYl1FKjB8h6Rnqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ey524uGXcjUpAwcDoiaooA0NVOlBB+1803iKQWrb5rk=;
 b=wqrtCht/9uJYBQKOItF+0Isz4WdQrrURf+kxLIBXGOPABzIWe0mNI7KN6Db6DHXjyppEwgeXSQFTrvpR211QGzidb//lhh2jpp2Rxj3wiPrDzrFuV2zndxCAp/yoWZFDra4dZnC1eZ5YpkO/3FgkoTiWpV3ivfnAaYxuaEjSAfE=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SA3PR10MB7093.namprd10.prod.outlook.com (2603:10b6:806:304::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Fri, 10 Feb
 2023 20:17:39 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:17:39 +0000
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
Subject: [PATCH 6.1 v2 3/7] arch: fix broken BuildID for arm64 and riscv
Date:   Fri, 10 Feb 2023 13:17:18 -0700
Message-Id: <20230210-tsaeger-upstream-linux-6-1-y-v2-3-3689d04e29fc@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-6-1-y-v2-0-3689d04e29fc@oracle.com>
References: <20230210-tsaeger-upstream-linux-6-1-y-v2-0-3689d04e29fc@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN1PR12CA0070.namprd12.prod.outlook.com
 (2603:10b6:802:20::41) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SA3PR10MB7093:EE_
X-MS-Office365-Filtering-Correlation-Id: b69cdc92-3058-412a-1728-08db0ba3db5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OiRHTP8XBlNFq/03v/Ztjs9YeQVscOzbg0zo9vGXySu8Xyk1eaqCTwF8Ygvl9l0LoduQz7fgkiSLTWv15B/zHHtJ3NnihHnM4hNkh74lyjWsA0M1pmjVgDkB57nt9qonfAiCeA/GEGYrEhiw4u9BDo1NtUmZEAZZJ6Vz1UaYoprQ8HPJXO2v6TPkr1OW+VXD/qgWbWIbVpbJ3KhFX8jiH0Q3CupARmFsZOLuAbM825UoPXg623eFo7x3AHneZpQCCUoqyD0Oci9F6YqihPx4quufZYOBLr+9/QbMSSKFb1vke4+ote4NLn5BQKsALIUg+7PVOZp5mssWM+xLxq+nvViy6lsXO/fsmTJig53UL0t19NK3AOiRdEx22vpiigYvUt33Au5pQcjhkaNkpTZJnSh8TPgn211r2PS61RTqb9NorDBlhne93IgSRsxSiVLHub3oLF+m0v+9s0ObB7YTJ0DDjw2v7toK6yHZh1O4fNr/If0wXiugzcAkrwGXaHyNf/tAoAq27/CyiBT/yYaqIoccvMeTv0d8+7jMBNSVbW0F/bPqdErRif1FDLG6FP6tzN95IULyw8ZMz56SMiuCNrvCWT/ohVoZSlNFGmV3gVXTTlXcUw0byiCdHuiJ8mNIIELzySbx5ejO4/i1SLoWFfXDFuOgJuMAoBSW1cBRjh4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199018)(44832011)(6506007)(5660300002)(7416002)(186003)(6512007)(8936002)(36756003)(83380400001)(86362001)(38100700002)(2616005)(2906002)(316002)(54906003)(6486002)(966005)(478600001)(41300700001)(6666004)(66476007)(4326008)(66946007)(8676002)(6916009)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFlrNnEwaFh2U1N0K3hBRFlzMFl0ZHRsSmZ6bHlzem1rNnJoVDcwVjg4VStl?=
 =?utf-8?B?bktBUDZWbjhJV2ZyaisrVTRsSFlaaktKdHE0UW5MNUMvbWdLR1VqelFDdGRC?=
 =?utf-8?B?eUIyWFJ5OGF3WnBmSGU5UmNJN2xGT3QxMFdvaWhUSXVCdENZOVd2SStiSnRu?=
 =?utf-8?B?NEg0VERieXRJMWxZNkFnYVRnWUMzSytSNk9VeFFLWWJmU3RBUVZMdXpEalRI?=
 =?utf-8?B?NzZLcEtET2NpeFlGbVVWREpKemZlN3ZTOHI3aXlvMDB6RnU1d3o4TlUwUEVU?=
 =?utf-8?B?cmh3T2FNTU9QWFJVMjMwZWlqaDBpeGpHUzUzWU11S2xkZjJ1WGR4T0s1aVZ4?=
 =?utf-8?B?MTU4cFFyb3c5ZUZON1FDWHFwT3NaeC9hS002U1cyeENlZDc5YkNiS01wandG?=
 =?utf-8?B?WVp2NldJQkdHLyszTWh2TElSTXQyUGVKSVVXc0tUMVJwV2VaR2pZeGV4NTl2?=
 =?utf-8?B?dW11bHg1bmxhTUpTK3hYQUszWXZhbkQ4WXkzaDU1S2NLa0ZUYnFEQ3lqZi9p?=
 =?utf-8?B?Vmt6bEVtM3AvdExUb012aWdkTzl1Y1ROaGtoVFJZRG94OUdsNFplNDMvVVhB?=
 =?utf-8?B?UEJid1AvMjd3b1hLNStXdVUzbDE4Z0krWmpWV1crTy9CR2tLL0xrdS8weDd6?=
 =?utf-8?B?Vk90RHBhc0x0SUFOZTdHU1hOcU5kOUZWbEI5cmxNd2pMSGVPSFZLUkdIT3Q3?=
 =?utf-8?B?eURTU0FBOGQ5ZkxTMDYydFowK2I4aVUrNHhrdHpwalFDQ3V1S0RWc2E4UkU1?=
 =?utf-8?B?L05pYzc0dXlEZWpVN1ZldEprWFE0VnM2dWtxMk9vd3dzUFpNU3JKQWFGeDFO?=
 =?utf-8?B?UWRiMHpqMFhucEZlTXYyU2RZRnpDODlaL0pTWlNPM3RMUHk0RGpFc2pvVlJO?=
 =?utf-8?B?eWxPeXhUQ2pSY1ZxMWg1aFE1eWg1UVZoWDBJdC9LZHh5L09RbURSbTlseU5o?=
 =?utf-8?B?WUxoVEtuRVJjNmNuY2IxcnUreGxZazdZVzdnV2FEMHZYZUV2ci9ZVEJ0d1Q4?=
 =?utf-8?B?bmwxeVlqMDF6aE5aRTc4bGpFN1orK1NVcThNQ3doZUh3bjdxZitpaGVBd2NM?=
 =?utf-8?B?cjNJOWJ4TU1ZVGUzM3pIbGlEWTA1NlRzTTBRUDV6QnpTMnBlTnZIY1FFKzBu?=
 =?utf-8?B?eGdwYmpJZzlEMVdOM1RLQy9EcE1XcDRLOWtmbTVaZXZ0c3FRd0U4azZYM2Y4?=
 =?utf-8?B?ekt0VXkreXdnbm9oK3BXVmZ1Vm1lNktpNjZXYVZwTjVBS0xPZGZMaHQwRTla?=
 =?utf-8?B?NGg1ZUVidmxFNkVpd3ZOWnZqUnhwMWMzOC8zSUJVL2tRR2kyeFVIT21URGkr?=
 =?utf-8?B?Y3A4SjhXbDlxWktPL05rZk43d2M2eDQ1a3JHRU1JTW1GL0hwNTBJTEMweEIz?=
 =?utf-8?B?eHl2R0plcGcrWFU1OVhTSkE3cDhsUDBtYVp2S1FsYmZRcTZYWWt6QjFqNDdE?=
 =?utf-8?B?U1B0T3RYSjY4UkxhUW5iVTV0M3ptTDE3M1FLclNEUUJyQjlHdFU0NGIxUlFQ?=
 =?utf-8?B?QS9yZHp1bnlrait3UVVMaXdBTEZla010SHdyRmFnNjFUdHhLVHZzM2c4T1ZK?=
 =?utf-8?B?RlZsTTBVSzRBdzcyaFgycjVwd1JWMlZrWkt5VkFZWHA3NXlGNzhMK2hTbVc2?=
 =?utf-8?B?ZzRVTFBDTUFZQkVjWmk1Sy9wejQ1cXJWZ2NTS3ZaU2FEeFhYb2RWTkE2aktE?=
 =?utf-8?B?K1BMVk9VSXJyVk56YXk2TURoRm5ub3ZFbm4zWG9hRUd6LzN3eVJ0cWlxUUJF?=
 =?utf-8?B?QkRLT000Y1d1YXhHM1ZsOTNidHM3c1hMRHAyVWJ5NXZRVFBQcjZHaUV3SW1N?=
 =?utf-8?B?Y3JCbmtxOGVHbEpZRVQ1NUMxMHoyVFpUWU43SjlOZlAyU1lnZmdZc2pEZmsx?=
 =?utf-8?B?a0hTV3F6Sm5RNkhnT2Y5blRXbS96SDlyTU50M2Yrb3FWWkloOVdhekxNS1pv?=
 =?utf-8?B?ZVRWWDArZXlVazEvcjh5a2dPekZBNzNsNFZoa2U0SGx6NTdENm5CWmM2OUN5?=
 =?utf-8?B?bHlDcGhkZVl6VXJIcVRHaHVKZG11QktEVm1ZTHZ6NFlyTVcxajB0VU10akZY?=
 =?utf-8?B?U3Y5Q3BhWG9IcFp1UjFaVGJBN0Z6OThUR0UrcXZXT2ZwYjJCM2hKNkV1WlFQ?=
 =?utf-8?B?R2lMMCtLbjZVVE1JODN0b1hPN1k0c2RiOS8rL2lyTHZJaCtGa3hpRlJ0VnU0?=
 =?utf-8?Q?4sTKX7NIW6OpLYI7kRJS60A=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?YWJ6NlZJK3RmbXhLMlFlbzVRMU5hem5URlBlSVh1OHFEejRBWnlXWEpjaU5n?=
 =?utf-8?B?b2xKZVk5VTIxR0dMbVdWdkFmWWljSEdpRGZWNkE1c3FINzFYbmN0Wk9PWlA1?=
 =?utf-8?B?NWpLWFFzMXZOQkNGZVArQWtVamdOWUhwTDlGZ2dKM3BqMWVIQ055dURmRFlq?=
 =?utf-8?B?aWdCRlRVY1BBbVBuelFrRzFYSWZjSkN2L2RGTkYvRGhuTG5UNzNRT1J4cEJj?=
 =?utf-8?B?eGhiby8zN0JVZkNXVlhoSTBVaHN3Rm56MkN5Ulh4YURNMEc0NE9BZVpmaVlW?=
 =?utf-8?B?TGhBb0JhZkZVY3FHRm1kOXEyU0RzdnhvbEJtK0Q3R2wrNUZuTVQwaDFTMnhS?=
 =?utf-8?B?Z3ZyaUJKdnpzS0xWMElZSHd6ZlN4SjJXZXFUMzZUa1p3ZWhtMVd4amw5MWhy?=
 =?utf-8?B?WW1KYndPbUxVNHNEZ0M2R2F5aXYxMEFQYmNoVmRmdHBHSGNFbVF4UXNjeWlS?=
 =?utf-8?B?bGpMb3kzQTFvNGR1ZWhTVkdKa3U1U2pveWMzU2F5U3lLalBoV05BbEkybVUv?=
 =?utf-8?B?dCtoQ2dpVjd3TDZLV2FvYnRFL3E0ZkprRldsV3ZKSnZIYXhOdGZUL2FBRlJS?=
 =?utf-8?B?dTRuUXROQ2xkQjh6aVp0L1RHemxoZVhPYng4eVlHcHFLRVd2QmVkN0IrRE9x?=
 =?utf-8?B?MWdUNU5PTk5GMmhwcUxtMU9acUppQnk5ZDFjdThjb0NaL3I3ZnVDQ2F3ZTRn?=
 =?utf-8?B?UTErcTZSV24zU2RheEVjNG9pTHlGNkptOXFyQzdnajl0OVU1MWVKSzkvY29u?=
 =?utf-8?B?a3JjZlpiQUx4bWpMR2xsNVY2dEFubkdiS1MvZlp1N29qU084MU96NkdFUlpo?=
 =?utf-8?B?Nzh4bWw3UjRkZkh1R3BKZVlIQUtjM3pMVDhqTC9DUmVOYVpmNEdCcHNDc1dr?=
 =?utf-8?B?L3QvY29oWHpXQzJwQmNxTnRaMmJmaDJhbW5uVnhIMWRzdWV3cDJ5eUxqbENt?=
 =?utf-8?B?OXQ0Q1hrWFRmRFdIQjVaR0xDQmsyMjRRdEZKczVmRXRic0VML2xmcWJEMmky?=
 =?utf-8?B?YmxrZ3F6eG8yUlVGeXVmOGdFQXZoeFB2dksxcDhENjlpblBvVTdFem9LSzVV?=
 =?utf-8?B?SDdjSGNSYjVWYVRFMDY3VEViVjhLTTNxWllTRjlqS0F2Rmc1ZzF3N0NqZ2xi?=
 =?utf-8?B?YkxPS2ExRXEyZDJrVEFKNldqZ2hYLzUyS21paGNWTWlXSldkU2R6ZDAzc2Rh?=
 =?utf-8?B?VVpkRE9Wa2pGaFZ6RTloNGY4Tyt4aE5IWENKd2VpK0JwMmpsN0k5Y3BUZkNj?=
 =?utf-8?B?TlQrb3ZTSGlNYUhMeVA1RnRXUktzYW9nYnFuMzYyWHZiNUg2TVp5THZ3V2J4?=
 =?utf-8?B?NFRsc20xMk1FL29CRzdsQlJxODZZcGZiNFVIaFVUMzlieDl5b0FLeWtxcWZW?=
 =?utf-8?B?MytvemJEekNCUG1TUGFnNnRLM3RiajJRM2x3Rkt4bXk3K3lHV0NqYjlETml5?=
 =?utf-8?B?eDRzSG5oVzNnRFRuemoxN1g3MEZtS1ZucTIzaHkxTkZxSFlFRlRPMWdRRThy?=
 =?utf-8?B?aUUrOVBsRG9aa3BWbkpNZ3VjeVl1b1BHQzRvTEd0aFFEcVpXRG8rVUhEQTFH?=
 =?utf-8?Q?47QTz+A4DRguMpm5PfW45STwHcDb2vsqS0YTkDXD6S1ZL3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b69cdc92-3058-412a-1728-08db0ba3db5b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:17:39.2843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yCngy7KrbrxY0j1FFJrOZu0iyrRpaglIIwGa15OEQe7PREUakCuBFqP84Lok8LDWmn+owsSIgCZs6DqLv6fj8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7093
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302100172
X-Proofpoint-ORIG-GUID: YSJ8rnnetn4me3k7T4tgpo61qa-9eLzc
X-Proofpoint-GUID: YSJ8rnnetn4me3k7T4tgpo61qa-9eLzc
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
index 3dc5824141cd..7ad6f51b3d91 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -929,7 +929,12 @@
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

