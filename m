Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E98F0692AF8
	for <lists+stable@lfdr.de>; Sat, 11 Feb 2023 00:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjBJXGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 18:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBJXGf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 18:06:35 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED7D5D3E0;
        Fri, 10 Feb 2023 15:06:34 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AI0HPs029940;
        Fri, 10 Feb 2023 20:20:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=fteaV//kM5gvfhNkB07KGHv/UjLnACIvgHB9+7jPycA=;
 b=CxjSFyQAEKpRv2U1DDr3KpZEOAHJ+B//MfBuQzxPEhRyCfnyVmU7zm+TahKbjfoda9OQ
 0AnDA74u9iObOcdRtfHSUmd52/yflHDUP2VTOngMbNkrT9KwVfn7aQEZuuzGL/WmZ7jl
 1v9cvHmuOiMe61OIDB7kq4gaS6CuHDgRsawEr6zfCc2G+9NLpTG4VQtRg3ykByVtgtse
 rJsZCeP+jrX3JD2XDYX5xCasfgdzqAEHRewQPXUtkY7r4BXJTL7/bhFE/KROKbddkA2W
 zvRfYm5MdW+pIrzdM3BQhBqEyowMW5t22ngC5BJ4KKHJua5zLNmoGgT0YtVdBYeDWtoS UA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdy1ea5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:20:56 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJAFZL003179;
        Fri, 10 Feb 2023 20:20:55 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtb7jq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:20:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aGwGqEhMWnSc3lSn2nxheyIoZ4yJyPU0xzTQNklYxaMzFnuRKEsXQ2epM+CHfltQE2VRMAimvq5AeKXwZgsx47MrHsdCojf0ifOP2BloTWb4Gk4/pF/xemSFgnkerOIwcNKe7mwYGpBaf7sNIAylU2sKeeW1m9sshFe/WPdhOinIAf/BuRL4xKS6mygH7D0iazE3fTY80AQOERhb65PlyhNUcy1XbjY7ZfmIRWSzJJub8fu0MIYnTT61Ki6Jf3Gq7uo7FdCWUX9OQzs66rSWA7lEndX5kzjLmES+Of2ms3tgftmDj0ZSS42mvhR0WdpuRfhpjrbBse0y5nYXnKaS3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fteaV//kM5gvfhNkB07KGHv/UjLnACIvgHB9+7jPycA=;
 b=nqCOlX8EChJnPF7gLKmEy55YOz6zV7J96Mrafj01o0VqiaRyqJ8tOcvGCk1qSZ1woJU3omuCk7zc2SYTXHjBhKrZQz3seARR3vXTvKJL2uoAxpjmn+0+8wBWG0KtDFL8YaKzzWZn0pzTPfa7Qulln53AEv1xgvhrFSHJbVbERP9Ux0aSVYvmOQwwc5jIsqYoaa7aXi3Yjc6xaoF0Yu4t0tffA+3iC3Abf6UIcxV0E51YEG5CHsIce8VfHsNzxmlDNjIJQK7Sd11PkGJO1kTSB5/Q2XilFxPrfjDBIoBQeMNos7IQSpOizHeMcgmjGQvvXBUFK0xiPvKWCSWF2Dwufw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fteaV//kM5gvfhNkB07KGHv/UjLnACIvgHB9+7jPycA=;
 b=ev2/alx8OLWZqURw92fTK1LtbqqAYvLHKipZ/u9k6yKN2hzlFnb8P3gn0vTJjndhkO4ADmBoQ9f30GcjVa/4f+BOhwqDK+cj3Ylv9ZcnAjMmvkdvR17Dkoi1eRpIPF6Hk3GV2sUybK5cLbsVEHBXQlwshJww1CX0Fdl+cvTYkMQ=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SJ0PR10MB5567.namprd10.prod.outlook.com (2603:10b6:a03:3dd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Fri, 10 Feb
 2023 20:20:53 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:20:53 +0000
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
Date:   Fri, 10 Feb 2023 13:20:26 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-4-v2-5-a56d1e0f5e98@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL6PEPF00013E0B.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:10) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SJ0PR10MB5567:EE_
X-MS-Office365-Filtering-Correlation-Id: 9397c614-8cf7-4000-a559-08db0ba44eba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /XWEjnO4kLq9OZjK7GzZpWq8/2CJPer6Mbk0YlTjUdbIB7Yvq258z4Sv9Kr9aX6nIQ5T9d7oXBJiIG2go2QxT/EMLlOIg75hWbGmWESPD/LiPOrGsq2/ZMeoA/R+PnS869kEeVvgPZEIy/0pmTLGqO5SxBsN3jRhuW8Nm17Ihfq6/r3it2oHpkaGSYr9+6Q9ijGQZasmtSEaAbxNGL9j/tMnqdw4QOV06lo9qz/tl0VTfrzKS48fvwRKe9yd+v4TxGtX4snKhLfK/OKa0w+YonlnoK2GocoC6ZL4i8lvgnx8Aj1rXLFy7XQoujHn1SNmtUEeN+vscmCYfJye2iJbKnkqxiAyLq5GEtjcxL8G68bi8cfIaGneXaDLwdojAx2HBEXF5F/PhIplTrvaz2mI+SbYEtDXhIRR1AKjNlXbSuwsCIpwYwJAigbDl5F2+JDWJCTm3jCAy7YrLA4RiAbykawqNbf7p8Gb4D+Cvcc9EdPGZ/q+iodYR+wkOnYS9mCB6/hfT/TFH7kIvF26VumgBna3m6j0YUPZi1vnqMnohb+3cfpxP3T0M2vZdj6D2RCbpsXp0KUnYZIRMSi0OeuB/PN+cp7EH1o2SV4rhoYLDNROGLheG+PMbgJxQQCZSRxDwhb73rfaaJkKcLUflP+cqazNbm3Dt5GMLMLnUY7YnsNrUyJwvJ05ny0UEkUmz3eQpCRpsJ6l/wdrU+cIScyWaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(39860400002)(366004)(136003)(451199018)(86362001)(36756003)(38100700002)(6666004)(41300700001)(66946007)(8676002)(6916009)(66556008)(66476007)(6506007)(4326008)(478600001)(54906003)(6486002)(316002)(966005)(66899018)(2616005)(2906002)(6512007)(186003)(7416002)(8936002)(44832011)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUlVMXY2V2VwM3N1TFowaVVjUHVGRnFMdkJlQjN1QXF2R2JXRjlZR3ZpaXJn?=
 =?utf-8?B?ZXlHVGhJcjUrRXdnSXlVYXF0dG5FNlZMeThrc1NiVEt5M3Ura0hQY0RHQjMv?=
 =?utf-8?B?SHlmYmJSb3JoMjk0eGlRcmVieXA4RWkvWHB5K20zc0p3ZDZ1WDJXdENFNTFT?=
 =?utf-8?B?alJFY2tlb0t6bHhuYXdxOUNlMHdkZVhBeERpYUNKc3FMbDF6K016RkNYbDFa?=
 =?utf-8?B?R3hmQkxhSW44dTNWWmtWUUY0cStWSmZRdnBGQ2lkWmNFL2N2NHJVdzVUS1Zo?=
 =?utf-8?B?elRHTU9tL1ROalJlTDMrbkR3YVRJU3VlUEc1cE5rVzdNZ1FHTm9pNmZ6Z25t?=
 =?utf-8?B?cUlZcjZEMzdGYkd0TWY4SGRXcHRpZzdCZWhvK2NTU0F3bkxCQTNqTHRCNnJx?=
 =?utf-8?B?V0czcVFUNXVMdWFXemQzM0J4cWt6VURhUHNrV0FKUzB2WTgrRy9iaFhFOHpW?=
 =?utf-8?B?SVlISnFNUkk4QVQwbnVQVm1paWl1QjhGSXN3d3p0UW5pT01Ya3BrVVRBdGNF?=
 =?utf-8?B?YytqNlZ1d0JIYmoxSWdFNXJINE14bWR0bWl5L2Zkbmc3dDBjc1ZtV1NqRDNh?=
 =?utf-8?B?eTVVS1d6ODZqWkltdWxlUVBTclR2dkJxVXFMYkpaeXZ0Smd5S1V5Q0VOK1E4?=
 =?utf-8?B?bVlKSFJQejFyN09IOVdDaVRvVGlvMk0yNXRsRlFheC85Um1lSFo4Q0RuZU93?=
 =?utf-8?B?NTkxbC82K2hnYU5vd0cwR1orcGltWUg0MmR5ZTFCUnJpRGU0cFpKb094TDRB?=
 =?utf-8?B?eXJ5Yi9wMUVVT2Fvb25SdHlhNnNmb0hHWkg0R3pDc0hCNWR5aXppalprQ0hJ?=
 =?utf-8?B?dDFLcHNaeHRENWE0UFJMZ242ZXArMU5WTGdDckpYWitEVlo3cDNmVEF3VDBt?=
 =?utf-8?B?NG11Vjdab2lLVmNlZms0aE83NTRaQ3RsSFk1TVF1NU54R0ZtYmJPaTdpWG1i?=
 =?utf-8?B?dGZDY2pNVDBkaGl4aVBQdlB3ajVya1YvUUhiK0lTYXVkK1pJM2FGS3NkK0xQ?=
 =?utf-8?B?TC9FcEVrWVVXS21jR3hUM3NYWUR4dFNwbDhsK0hsbjFlZHNFVmp1eTBnVlVu?=
 =?utf-8?B?WlBOV3NhVTluSGZwMWVsZDBnbE5OYTlYeXdTUUNDY2pSWXdxbzZQK0d2TFVz?=
 =?utf-8?B?Y2srLzR5R1ZXVnpReVFJYzd3OE1lc2ozYThkNXBqa2JFRDIwWEp1VjYwMHNw?=
 =?utf-8?B?WXlvOXZFVWt1ODlEa0ZIN0J2T3RFNm1ZazNMa0htZFlZWWJqRDRhYUFHMkEx?=
 =?utf-8?B?U1NwZ2pKUUxkczBJc1UzUzBiRUlKbDE4cHlRcVBqMEhqWk1VVG9DOS82M0k3?=
 =?utf-8?B?WDBTUlBZdTJqNWw4aUVLSTJVVTNOQW9PbU5RaXlST0hpNXVXaklLalR2RmRl?=
 =?utf-8?B?TWo4d2xkZWw4QVYweXczcFlITVVJdmllYW5NaHBQSHRoZkFxRnJwTlRGMzIv?=
 =?utf-8?B?OGhHMnBIZUhDZ2N6Q2tDL3N6TTB1MWJpMXh5Um8rek16K1g0ekk0VWxaVWRp?=
 =?utf-8?B?dGRtN0FrVlc4ellNWDJMVlJhUjl0eVkvNVltVENZNTFhQ3o4MyswemcvK2hi?=
 =?utf-8?B?YmMrMERBSnF3di9iUU52VURUcFdWQUZLeTZYRGY5R3FsSDVGUnlFZ2NxOU5y?=
 =?utf-8?B?emN0Mlpvay83OUkxM3Ftc0l4bGZOaHl0cmk3czZZaXc2NDNXU0FLbGpmOUky?=
 =?utf-8?B?V0FYS0lwNDFXTUJ1by9DRjM1UFJzbUQ5dmtFcFp4M1puNFRHbHQ4Qk9NMity?=
 =?utf-8?B?ZVRWVnRKRHNqUHprRi9JRDAzeEkyZCtPdmV0K3AwRjdMZzRoa1ZNWFcyNDVQ?=
 =?utf-8?B?c01VSUdWamtGRjVNZFZ6enY0ZThNaXNDSmhnSFJaUXJLYnNzTEtoVDRlWTUr?=
 =?utf-8?B?T29FMFc4ZWwvKytJVVNFbVFkRzBtcDZUQXZDb2pFRnQrT09Qb3BsaHJ4YVpI?=
 =?utf-8?B?QzlKUzAzdzBFTncvdFI0RWJZQjZXUHlpdmNvSlJEcDZjcWNRL1c2QXpNS0JI?=
 =?utf-8?B?UlZkZGZmVDQ2NDRYTG53YjFYbkFpVlV2SE5oK0g2Z25VZ1hjNW5zSysrOE5q?=
 =?utf-8?B?bkZEcE12UGcyTEYzcGdtR204Q2VKZ0RGUHVlTm9XeVdBaWxDcXp2RmVSK2tT?=
 =?utf-8?B?aEZOb3lxYkNGWmk1WlM2elgyWlRvYW00SU9KeXZLUGpSb2VVdEloVDdxUjJ5?=
 =?utf-8?Q?Q0VaNb3XDPbTq5Ck1RL/7rg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?aXVZU0VSVk1lWE0wV0c5R0FraXlPdVZpV1hFa2NSNnYwcnhSRThvR0QvMmlw?=
 =?utf-8?B?RFFxUnpmUlZyUUZ4Qk1ndFRHQ3ZEZUlKZ05ZZkZ5YVlZb0drVGtrRFlrblJq?=
 =?utf-8?B?bmZNZVRJQnFLRnI1UDdKdXJiYkV2MGFMcllzNGFoOWRoUDFZS2VwSHVQUDdS?=
 =?utf-8?B?Ulhsb3gxQzcrNEpiZnFMUzk3YXk3RzVVL3pIa1ZHVDZDN3l1S3BUU2V4ZFNq?=
 =?utf-8?B?UE9pai9lZDhFTEV1N1o4cklZZ3U4WUdXaTRyeE1ad1l3ak8zL29aTWRYeFhr?=
 =?utf-8?B?RlpKV3ovcnFkNTcrV1RsNFA3eVQyMUg0NmVldmdKb3AwODhvQ0ZTVk9PVXRw?=
 =?utf-8?B?U1FReUJEa1p2TUhCOGJ4b0psbmMzbjdxSXZoelcwUElMdG5IbFk1SmZzdXFY?=
 =?utf-8?B?RzBjVHRWYXgwT1kxUndzbm1xWisvZjNWUHpPbXBDazJmTktKY05DdEt3SDV1?=
 =?utf-8?B?c0wyb1ZtTVFEcTExNllOVDlZa2pld3J4RGpLZldleE9LdjJGbFl0cEkvZXRn?=
 =?utf-8?B?UHZKVi9vQ0pkTXRLTDQ1ekZqVnNhK25KYVEwT0M0NDBYcmdQMnlIYllSOEdP?=
 =?utf-8?B?MHFQeEQ1ZWxwb3BWNTlJbHpPRXEzdTJ1OE9UT3g2K2pBUW1aS2taVFJsWk1U?=
 =?utf-8?B?aG9hNUxiajYzdW9LT3d0amlYcHE1MUxHMFliZ3lrZzk1UUFZbTJVWDZGWUhX?=
 =?utf-8?B?dEwzMWczbERueVZPdjk2bCtpVVc2SUpXSU8xaWRVQTlBWHdTWnlWU0NrM2Qv?=
 =?utf-8?B?cU1YcnJ2cjF4NC9yT2J4UFR0cDZKNnNFVHFmSFp5TGJBd0lGcE8zNjNqY0hK?=
 =?utf-8?B?bGltTzUzVjZoR2x4NFI2ZnBVYzA3QVE5OE11ODZmaE9nME51Uzc4ZGZGaTJD?=
 =?utf-8?B?Tm9ZanVQMklleFB2SVZObVI0aWdxU2lFdHJZdGY0eHZDWXFZOE5MeDByc0wz?=
 =?utf-8?B?TFJ3eUQ4NW4rNWpFaEpMN3NwUHJEeU44RkErTXhaT0QwTUo5Wnl1V1FPdmVZ?=
 =?utf-8?B?amExcHMzbEYzeVdkWVlZRnFpNnUzUS8wOVl5UThFdXdXbmdvVmNRSFdSTFlL?=
 =?utf-8?B?bWNOOTEzS2l2V2tQKzFHQkhCQS9YMEpjMUMvSjAxenQyUzV0cC9KQTBRbTFU?=
 =?utf-8?B?TldpaGNDa2VmVjVOc2F2eHZUQ010Ykp4TFpLTTFjSmo0M1pVcCt1akVmUlc0?=
 =?utf-8?B?dUdvZ1RISWpRSUYrS1VmQ01NV3VodXVTWmMrTzlQeUVnYThEZm5HUUlEbVZM?=
 =?utf-8?B?YmErTzFWUXFNS1lRejN1MDk5SEhwd293eFFiZ3hLcVROYlF1a3FGVUJJb2hq?=
 =?utf-8?B?SE4vV0ZSeWdnOU12cGFBKzlzMm9hdFV5cjBhQldGY2xkQlk1QVI2eHBNNXpZ?=
 =?utf-8?B?Q0ZoZzEzUGpxQSs5QWlXUnQ4bVlEMFZCOXJLekQ5aUY5cTdpOC9xVEgrVTc0?=
 =?utf-8?B?UER0eVBhRldScklVY0NLdlBTVGFZc1dKcExRZFNXWXc0bkNiZUg4Nk91UUNO?=
 =?utf-8?B?U1E1bzNlSWkwRTV6amsvMHc1UDJjbmU0MmF5bE9KelRpbWRGZXFVRVlGZlFj?=
 =?utf-8?B?KytFandJSDJVUHNaWWhoLytZT2lkcDArczYxaW5Jb25xZ1VOOGxZbTRBOVdv?=
 =?utf-8?B?UWtVV2gvUStuTzdyanZwT1FXN0oxS2c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9397c614-8cf7-4000-a559-08db0ba44eba
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:20:52.9578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 03eEH9y/69bLfboXTRVBlMr16Mxwf9dagcJUwqoF//v1v5JWgZNq/L90Dczqr88bIa+DorePWkP92633zO/ERw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5567
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100173
X-Proofpoint-GUID: aivCplTX3hyfRhQVBXXLfJ2hu9CNjWlS
X-Proofpoint-ORIG-GUID: aivCplTX3hyfRhQVBXXLfJ2hu9CNjWlS
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

