Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41ED86927FE
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbjBJUU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbjBJUUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:20:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B7681CD4;
        Fri, 10 Feb 2023 12:20:07 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AI0G4R029930;
        Fri, 10 Feb 2023 20:19:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=l5/FqJUxQ+bSBl23Eq3ijhenIiQb+5heRXvcO0/i0ow=;
 b=ESw/ReZ4mNPC2u9fUPFrkRSUTZV3SuDHWuhkVQebyyJtIwnQCHIqCWPOMBMCowKbwvZJ
 j/jaiAHL2Itxaic7cGbzSA1Uw/YHk5InszbS2NezxCqwTfPMc3/ZFkxDoblYdOVUgYKo
 uCxolux9zrdDh19tOXfnOpVr/OERELAXV7xkDa/LzW89QLS12iwYObJws7y3IGQsYw8G
 K5xSX/rd8W6apMVAySAnr4IDYRkFlmbNoTq/4IwAypwP3k4h1m1PuRSNyQUtCz9m+ZyE
 xvCgsa+zrYQSulvUitMxsFEercEVEKQEfFFucfV7SSoaPFBjxG+Bo2uaf6ugq2TppHHf Bw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdy1ea13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:19:03 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJkndH002644;
        Fri, 10 Feb 2023 20:19:02 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdth9p0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:19:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OE89CSfR71RpDWR1Hs2EtP2KSlaMyuAzkIZJIkxMjORSN7bc7Qsy1T+edKHCz+5HwqWqZnE8Djv2kdv+F1qc5sx+4BLpFG2N5h8Z1ioJXjptEYuCd56S7PA6BooYjC3/X1YPFjaTEN9m3cSyeIS6wKaax5TbJOAubXly56Jqs2w8wbx/UDMlNxVXl3v/bPDGjs4UQADF7kwmAooA2VJXrlSRYbpeZHNbDF96w5SaeGG83wcaaC/RYx+Kd3tKTB4PXYW7Iqd6UOCVsQlpr5SoTLLlbCDtLT43weqAIUB5malXDggkD4NHc2Qj1zoghfry6BfcnuljIQ5Lq0p0qkcVdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5/FqJUxQ+bSBl23Eq3ijhenIiQb+5heRXvcO0/i0ow=;
 b=MdGrCo+8clQz6pxpAsMusC9FZR8VXAFe2HK3LHk4yFmjSxfxP33EhZKAubdp04TxxiRU5cm3CdKsRPGJLnMBuoqDc2TDere0X2LeSOyKEOpm5Fe4t/CtSgomw/cmjdNfGCDYddiBSqSz3SW3uPy3kAleUKKRaBUF3oCcuzAuubjHDS2Qe0a/wPmYlBpqCaImZzrT0GcCRS3gpSlUJDgrbK3o5cLMWCcLMUNT0rTP4r8rKQSk4/sQj1QpDh50tvBXe9MYIm/Gjx8qvwW785frxi93aF2MmaCEyoPYE7zKq7n/pISESt8IXtQ9fr3RLYnnNjxqJxsVRhe7M4uMkDsKrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5/FqJUxQ+bSBl23Eq3ijhenIiQb+5heRXvcO0/i0ow=;
 b=YWCIMyzQUoOYrzDpReuVhUlHjhe4cWL9kwnzYfbFM8VbOdl1gRDgvhB+2zPs9IvsM5Hcckwj88nqHyTJVr8j9UWTGUINSeLW9CMRoRga+foQ6/WqIXUJ3Ff57jljMs0FTB8lCDquyUDFJzAjxvtEkLC8JzupIDFTifalQLoFKxw=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CO6PR10MB5652.namprd10.prod.outlook.com (2603:10b6:303:135::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 20:19:00 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:19:00 +0000
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
Subject: [PATCH 5.15 v2 3/5] powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds
Date:   Fri, 10 Feb 2023 13:18:42 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-15-v2-3-6c68622745e9@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:806:130::31) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CO6PR10MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: e5acecf9-a644-4ccd-d38a-08db0ba40b82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wVE7i3PEl0eu2UTmKuoxMgb978Hb55hcouSB+DwK60NIf5Q1/z240TOjb0QpEJlBSht8q+FmR4fzDXz/FLK10y82g15QK+SHAUwFfTNFQKkndSq14MgKZhCkzJbYVRMYGS/npQxqdDvg0q6eajirJ7pIZ0ci4ANAoq5LkrnEis4fatecV8qyPH7eL7r7wjoaOu8qvrmVrCb5HXABYX/JPpXqVUUbzXhDl3Xti5rOHH4PeOrHEega8aIC/v9jXJ1RWbLFMFsmT0hyMpKOPCk6fHyMu2yL1+fTG/s2IJtzz56n25g55InV709OIBF88yXcwhsRxNcGuVCm9n4Y03UOeJJG1qxtjZLdyk9iAVomguYp9hT2+wQOmasWtUkaQI4NUFX8I8mFXx51XPAXioMt32rbvO/23PH8KwnN0QviUW/L9gKujjIkfhy/6JHgb/dJAoiuLATFE4JwMkbYbpFDDVXzShhIUel7dexU0ttUbh94xO3J3in0kMOTvzgZN6fACf0LoJc62GNgJy5MLvJBQu8TwUVZVTS6wdGnCnjL4IBmkw2pSeP5YnXuO8MnYw9AqbNWRhYT5ZfGNtcx2GTb2Vx8zs4PpR+lUrReyo0Z3U3zsrGU334SsA6V+Av1qLvT1OfT0ebPLQN3e2EgcxJeVSrI67KYsK0Jr8eTMPviRzxYsbn2MWFXpRcZa5FTdlUTZrPLJp9DwV9EUjkNY4o5Rko//LP62Aksh3r5EsT7unw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(2906002)(36756003)(966005)(6666004)(6486002)(478600001)(6512007)(86362001)(2616005)(4326008)(83380400001)(6506007)(6916009)(8676002)(66556008)(66946007)(66476007)(7416002)(44832011)(186003)(5660300002)(316002)(38100700002)(8936002)(41300700001)(54906003)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QUc0dDZ6dGNaMGFham9FSm1OWmsvSFUyOXpMRWc1N0x5cnRGMU5hVnRYUUIx?=
 =?utf-8?B?L281WXc1b2RyVUpxbVV2MHZjNnVTZ2hlekEvSXRhaCtZNDdIeXRMdW1qeXdp?=
 =?utf-8?B?QU5sUDIzcDQrMVltdS9KSUtUK0JRYkdZTlZhbEVlYUgwcjBIaHluUnZzNWFh?=
 =?utf-8?B?aGZuU2pDUmMyd3hya0p3Rng0MDA0S05YWVFaOVpRTlYxeVNvVUt2ek5FOGtM?=
 =?utf-8?B?SkNiaWJOWHAvenBQSjZ2OVYxa3E3QkdTcXRmRm56U011dE94elEyTzhydW9q?=
 =?utf-8?B?UXdmenR5UmRLa3pxVC9IZjZRMnFVaXUySTBBeVY4NFBaRmlyWGNQZk9IMUc0?=
 =?utf-8?B?bW9HZURJSGpmOHhyVjJwMkxiUjB4endJRXMrVk1kNjd4RFFaNTlNd1hLVzJ5?=
 =?utf-8?B?RGNWYkhyQ1RYK0FRc0pjNmM0amlBeDdvZkxUL2h4enB2WTZkT1B3aVRxem1h?=
 =?utf-8?B?RHgyMS9kSmNPWnM5eVRVR0twS25rMFpNdDlpaE5UaGxIUTRGZllTazZkRHQr?=
 =?utf-8?B?elkwMHZJczY2anVLR1ZMWFhuWmo5ZXlYTXBObzZ3UjhUZ3Bnd0c5YVZXYmFL?=
 =?utf-8?B?Y1ZPbWlrUDQrc0twMmI3T2RWZnJLOFo1R1dHNWhsNUd0NTc0TFZZQndZT2hC?=
 =?utf-8?B?U0FaOTM4Tzh0eXk2UGQvTG9pWis1RjhxaWlVVzJ6RmhJK2dYamdPOW9xQ2VE?=
 =?utf-8?B?UVRtcDV2STFKWHZ5RjNNeHJYWFJYdlJBRUFFcWFmdWkxUDJEUGo3UElWNTdv?=
 =?utf-8?B?NUdXc05QMnZmWjlkQ2NWVHNkTWltOU1LVmxPRmxnTkg3Tll2dmZHd1VaUUxH?=
 =?utf-8?B?bEZlcHM3Vi8wZG5yM1h3cFcyc1prV09XdTdVcVJsUzQyRWxMVnF1OGs0bnJU?=
 =?utf-8?B?QVMvNUhkS09CWkh1S1RDMGtFYkRZalZsWUFRZ3NGUmJpOTlTVHRWbFgxYTdW?=
 =?utf-8?B?WEswanNRbVM2dERnYUhNaHJWTXlSR2dkOXE1MEVMU21tQU16K3J1YTBHMDB3?=
 =?utf-8?B?ZnhXWEI2U2E2SUtCcTZNRGQyUkFUQlFwc3BZMzNMN1VxUGNGcXpJMlp5Z2Ew?=
 =?utf-8?B?dVZjL01wYnIzSy9rTHFTL2FxaVhIQUlxNDdYOG9UWDM5SklBZFE1TmdOcVVT?=
 =?utf-8?B?cnlXMUlTeXd5TTFqc0p1bHVaRkc2Wll4NElzTWJMZ0dKQ3NvZjc1cDZNZFFu?=
 =?utf-8?B?WmtYSHVzVVRVNXZQaDlqbU5CM0greW9BWmdoWk16b0F6ZFZGUTVLT1p4TUVG?=
 =?utf-8?B?TUtYaXFJaHltRkNLRVFmYmxZQ2lINUQycnUxMGlIWE53bldPb3NxemJIUks2?=
 =?utf-8?B?ZVF5Y1JEUDFoblExMmVtWkU1VVovaDBNZkttTUxiMmxOQUtZR3Nwc0dxN05C?=
 =?utf-8?B?M3pPUEd4aG9LM0NQb245NlU3eEloZmFUSjZqRk05NzNPbDBUOTBFWGNMQ2Ur?=
 =?utf-8?B?aXBvVXhVS1Vlc0ZaMmN5Vno1RHp6WDY2b0g3S2s5RDFYdHpzdHlDSXVpdzc1?=
 =?utf-8?B?NVREQS9OUlVyb1Z5dEs3cXRTVkdnMVdWUG1OUWpSSDluZjBxcm1sZ3Z2S0tI?=
 =?utf-8?B?anN4VDNJanhwL3B3OFcyWmIzZUU4U1JaODhWNDd0aE1IeDBHcWUzc2RSWVc5?=
 =?utf-8?B?L0xlVWR5UFM0dklhQ0F0Y29oVFp2SDd4cisrZk5xZ2VaQXdpdVVCc0ZsY1po?=
 =?utf-8?B?dFdFZkNHTUlDTmpaUldsOXo0SitPOFJuUGdDSDdpSkU3eng2YnJVQzFGYUxG?=
 =?utf-8?B?S2tjUmVTRmlLcE9VNmF1V2tLbjNFUmhrQ3lYZE4vVitZcklmdW5ZSStmMU1J?=
 =?utf-8?B?TGdmazZLWFlQVnpzMXE1VjFaRHRGNGkwbWg2dlRLNmVCMTJYS0xRNTcwa3Fj?=
 =?utf-8?B?VXBRRmtHZCs1ZnhLeDV0RnQ2eVpKUTlEbUI2WnJnV3h4OU9vbllBUGdOSVh6?=
 =?utf-8?B?dGRDSjVPNGwyVC9McjdUcXMxZ0tZcWtXbjd6K21zSXE2dFBvUEFVeFcveS8r?=
 =?utf-8?B?S3dOTFhwMm9CSkQwQlZ3dmxyODA2MnE4YjFpd2RyU1lMdXdpL3dJZ1h0dmxK?=
 =?utf-8?B?YkZOZkZHTmVCZEVDckEwL29YRUtLTXpaSk5CMmxtbHlYbUZ2VnNxZzgvVkJh?=
 =?utf-8?B?ZDd1MzJ5cEY1enhkNG80dWVTdEM0V2lEeGlWaTdPWkl5T1hkOENrOHhFMWRi?=
 =?utf-8?Q?XZyz73aO3aLADYonLBpJhmA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?L0FqVjhsWnQrSSszWG81Z3N2VUp6cVNQY2hhNm9aWEZ1WWZIZGJ1QXRmT3k2?=
 =?utf-8?B?MG9HYXpqRzJ1cnhlRHhmU3Y5QStTUkxFanU5N1JVR1lIUkFMY1Q5NW9RZi9M?=
 =?utf-8?B?QnRjQ3JBT0lkOHEzM2plL2dublhTTnIvbk1vakdvdG8xMVA2MkFneGpPODNw?=
 =?utf-8?B?OXhacjkycFJqVmord2E4QmVSTnQwVUNiQzVVTDNnSGZ3Z1V5aXBWRnhqVFR5?=
 =?utf-8?B?RDV2RmE1NmY1Y0U2eWRKODJYVjk0T0tHZ1ZHcmNFdVY0QmFRS2R0bzhOWWRw?=
 =?utf-8?B?U3hkSGExMFY3RzF4dVZNZ1J0d0dVOW5Ra04zKy9iYUtGUWl6Skh1eGhtUDFC?=
 =?utf-8?B?NE0zaUpCSXpCaFh1bjE5Smhxb0xPOUtZTnM4S1pIZnVkY0loVC9JMWtMTXJ3?=
 =?utf-8?B?ZmtHREIrSHIrUWZOM0Y3RjFhWkNzSTRQeWl1eHVqMVU4V05KeXRQcnpOQ05J?=
 =?utf-8?B?cGR3bVBNUkczTGVkRDRNSG9Qb2RhSlZCSGdJZUt6MEpjSmExbVBQMVRwa2x5?=
 =?utf-8?B?MzArNUova0RibFpwaXVPQmcwV083TUViWTdiYXBMUzUzcDFhS1N0cHRoSGlr?=
 =?utf-8?B?ZGpPT2UyUDhGUWdtRWZzdzVaMDkzT2NtMFdQTW8yRStmZkpIaWZSU2NYazVq?=
 =?utf-8?B?UjlDUjFRc2VkWm5Ib0szNTN2QUxaVTJVY0V3WFROSTVwTFVkc0FLSVpQeTNm?=
 =?utf-8?B?MTlZTEhxMm9GanN1ZXg5eUZmTW5FRXpTZnZyb1JvYXdnK0g0TjV3bElFbWNV?=
 =?utf-8?B?ZmNySG1zVHoyU2VMRTBRM1pDSWNLNE92cDRkZEVrZlBFZThHcEVuRWtMbFkx?=
 =?utf-8?B?RnBHVHY1YW9XVVFNbEhscU1LbFI1bDIweGtQRU5VUklldG9wZmJNd2xBYjhE?=
 =?utf-8?B?TWtNcUJXbkYyczdydU1OVjZDdFBFQVlRWDNYTFFTckM0a29BSlRxOUNxZGpu?=
 =?utf-8?B?TnV3ZnkyNmIrTWFlM080elBKUThobEVoRkt6WUJFN2lyOHdReVJETWdiczVL?=
 =?utf-8?B?aE1jb0Rnc1pHNHd6TGI3aDZ4ZEtxb2hpck5pZU9ka1hrOGM3SHE5cDR1WFpU?=
 =?utf-8?B?ai9nVWp6Q21sZFlhZEVObk5GM3hscGJ4dE54aDBTUFU3Wjk4azlQQjFzZXQw?=
 =?utf-8?B?a3c2Q2N6TzJFbmExS2NkcjFOYnlzN2ZzaHdEakwzY3dpYzE4YStpWTJLM3NP?=
 =?utf-8?B?T2hGalQ2dHI0dEgzb1JLTW5WclowcWw0ME9vVDVPOU9qZmJ1RUEwMnlKdzEr?=
 =?utf-8?B?WjJxaGRKeHA2bWdKSi82T0RsVXIySzhZV0NRRm1oSmdxUkdTOXNLM2d4cEp5?=
 =?utf-8?B?SEQrOXYwdkhXdVRGd1pTczhJTk1qbWNHbERiOEhQRkpXV2FzTXFvRFRMcVVE?=
 =?utf-8?B?c3BMcUM0VGtsVm5iN2phSkQveDJtbTNjUXFGNnQ5MTJHMUNFYk0wZU14d2ho?=
 =?utf-8?B?TFdVejk2VWZ4Y0Nmc1Uxc09jV2M4UGZVODJJV0hob2dFeDIrbWdFQUZUa1Q5?=
 =?utf-8?B?ampQQUF0M0FJa0tZMUhCM1liZ2xUSFM4MS9QRm5zcWtFdWpyZ2pEejVSSUNP?=
 =?utf-8?B?REJaZDdxZHhjcEs4M0s1QnBrZHlESk4rZzhlb3BLaEIvQ0JxQkNiTzhSQ3Yx?=
 =?utf-8?Q?70Tiv+j1ycEpZNT1MbZ/Ns7FzEalhqd6nK6WV8zw6S4A=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5acecf9-a644-4ccd-d38a-08db0ba40b82
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:19:00.1378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pUR3X0yk46SSXLBOHemp09DgZNGdou4l7+Utevn1fZ+x4E8Ix3hqhIh2qWya3xsRn8leTHo8ovepmi0tXexXgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302100173
X-Proofpoint-GUID: xz22lOzeqzvHtsWxInwgogCPGm08L9jb
X-Proofpoint-ORIG-GUID: xz22lOzeqzvHtsWxInwgogCPGm08L9jb
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
index 50a04347ab05..3a3ef558244a 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -400,9 +400,12 @@ SECTIONS
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

