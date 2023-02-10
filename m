Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 950C46927EF
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbjBJUUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233666AbjBJUUj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:20:39 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE0C81CCB;
        Fri, 10 Feb 2023 12:20:02 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AI0Bso020866;
        Fri, 10 Feb 2023 20:19:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=cdMFz4JJXYI0K5BiGbqcUzfos2yoHBp5IakE4YK4bqg=;
 b=26vr35gHvidjqYHGVQN2LOYGvcEScR/W7fGRBb4qU3Is93w8ZDcWf8pLi/SPxkDK9Fas
 pmrTnVMYl67HKy8CRISC0xjLwaS03uK47wzmdnnNbjeWCn4zejC2QNfSt4N5UFeOuSSG
 VhJ0dKwK8xz4hKJVwmn/2T5U4FzquCZihIjq3weIr+75qMiXn3VtDPPxa0AyiqR1MFH3
 mnRljpW9UnrzT6u7PNVw8XAyBt9hcDa0lyvF2IDJNsnGv8Er/xYybgnT4rMPQ01q8JOJ
 ISw+JKLnmb+rCKGECD8AITTEG/0AS3O0HxeLKfQu6RfNijrRYREA+D7MNrHz9xlJaqVV Kg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfwue4dt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:19:01 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJbBUN025851;
        Fri, 10 Feb 2023 20:18:59 GMT
Received: from outbound.mail.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdthtecw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:18:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qp7vvrfzNU2PQ+cGS9ydmUB0x524TAUmLLAIr0qbZdep8+aiQrWeYPma18AFqllkmX66KvVZ6MjjsG0fUK+HT9KohSvniubnKhMJwglhGKwRBYEsNsOjRG4jsMgqhAsIgrPnoURIrnMcadVMAf2eCih/xr7hDG4iF+7hBKabY+VMf8AxJ7E9xZwBCQIfEShP/TkWUzWK+t9Z6QoqPIu44TylIgYU8CjxFQciSX12f6E+QSh13rcG9Yqm9lLLbUrHrG/4dbzqa37DLYvDD1yZF5XFYaCxi1xIs/g89S3+S0m5qqBsbv2GHbPhr58sH025xHuT9DjExmltSNDkoeFNGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cdMFz4JJXYI0K5BiGbqcUzfos2yoHBp5IakE4YK4bqg=;
 b=oNbC4GqsK616Wbi2qLD3evuMTLoaBQ1TGY0M0Vmhd9owsnrpnjTJz0vBTDRmT6+/L/itVu5fqt6zT8Ad4XaAE/B4VEHaSxlSpKzOsET8eCuGCfaprevmYbok8VsJLW8zulCA8TrneDPXPSPFgAR82JV3/OvgIvENRqrKg2tDUNg2MtHy8zwkWH4SgDaK+hBLRnAWz408IWBOMfyMjL4sk6rRnDVumugZ1n5l4lG4+sqf4GNztab18vtzdz+Go8H/L9ZvLZBNYVuqp1iiTRj4EB4PDEBcu4nqjB9GG3k7kFNmhxS1hW+tFALJtWfKZgJKObnxfEPfVfs0pZHY8WS0ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cdMFz4JJXYI0K5BiGbqcUzfos2yoHBp5IakE4YK4bqg=;
 b=V0Lhv49Bl28lVyzBre5cqiDBU3CGmiEF2lzlSPNgEDmEEhU5upV2Mnx5Rl/RM5rOFw0PKHGs1hZLSr+sfEllsI7pzQrG+0+CM4pYi7Pn7O84QryhBVZQNhWgg0dpmSb4WrOrOSM3s3MTgQn+UYiJfgf2Il30/Tz+pIpNRA0as2I=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CO6PR10MB5652.namprd10.prod.outlook.com (2603:10b6:303:135::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 20:18:57 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:18:57 +0000
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
Subject: [PATCH 5.15 v2 2/5] powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
Date:   Fri, 10 Feb 2023 13:18:41 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-15-v2-2-6c68622745e9@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR13CA0018.namprd13.prod.outlook.com
 (2603:10b6:806:130::23) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CO6PR10MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: 47a09f7e-52e3-4da3-caa5-08db0ba409aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cllpaNzF3a6DW6Dln68Rr+2mszEenCw7ellzEQJDC89HAPPH2lohv+OjS0W5uPOgzew0iMfL+zWQ/JV80z9r7K/1DIcMVebfuGYsvz7cVsJ5t+qX+elsNWXTmmIYZnND10nXhQMjSBOhmfLXHYdjkubzRg1iF10sfBnBD/zfyuukvrkiFkoeGThPbcubW+s3Ywt/r7hq5EZoej3KwrgOXDG2yGnHOhXdnWMrV2i54ZZdcK2xJEMGAOsiKkXSx28psGSCBgPncJDAgsbPEmfZ0xK8aek4+iqxEYJN+1XXo4lJLyXVhHR+2VFIYTitzawRVi/Td77phvK+rfI+wlithsdJF++/2UzWDrxP70bIgKfVjlWksfXbERmtdCyPGQRQGHsjhbnxlhv2GCDR9tU+N6uV9u951Y3vdrhk9TeQ2TlCxljfRy2EAjV8MM92ClH8+82LblCSaTH2wZJ2oa89/uSK6YrMkKSpgfpzPUqx8z3OdN22M3l4l7fQM25RNJREm09fcjpcjlNkoEhVSE5GlDzN8DRHpx5oOHNoYkSI1VRrXfakhQA1kQIP4eefqTobKE7fjTS/OqLY7dSS+rh1vJM/paUZNufPgYqcGfCJlax/FpzYh4UdKjusZbA/XeNwpu+uLuFfbOYqYngRtthBu8ea1uy5imF3tIHXLvAoAb8dXgtxi2U0XifpaCAmcqrOfaqG7EAh/JNtTQ7Y05PrVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(2906002)(36756003)(966005)(6666004)(6486002)(478600001)(6512007)(86362001)(2616005)(4326008)(6506007)(6916009)(8676002)(66556008)(66946007)(66476007)(7416002)(44832011)(186003)(5660300002)(316002)(38100700002)(8936002)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUJjd3ZBMEF2V3U0blg5TFFxd09nVDNqTTV2UGVXaER3RDJXbkRiZW1ENVZY?=
 =?utf-8?B?ZkVzYzV0YzNjQkt1ZGU1Q3hqL0xJeUhlZFZHUXlKQzJwc0U2SU1CSVhrSG5n?=
 =?utf-8?B?K1d2Nm1zd29jb3dLc2dseFg0Z216RGpMdnYxcG91V0VEZ25Da0tITmN4K0ll?=
 =?utf-8?B?bW5RdExGblhoWkpOZ0dFMGp3czI5SHd3YWEwTm5IdzR0UjA0T29DMU5qMVJL?=
 =?utf-8?B?OFJZd3p3UWMxMmtsaEJUZDh3eGpGNnNlQ2JXQjZhRFNMc0p1NzB5ci9UZURy?=
 =?utf-8?B?WmsyQWt0dFN4TGxNL3RWemVKZHZRNW9hVkpHZ3JwS1FHVS9jZmJPWnNCNDJD?=
 =?utf-8?B?Sm13RzlxcGFXM2IvTkdwQzZyZjBQb296MWlCUEgySERpWjhUMWdsYUx0SW9Z?=
 =?utf-8?B?MHQ2RW02elUyQUVBTlhwcmMzMEZ4TlpHRUQxRGF1dE95NzNvK3IvVDd2UlZs?=
 =?utf-8?B?MGdETW5iV09lVG5iTXgxaEFhblNOR2N4MmpBOFYrY1hQalU3WlcxMG9Rdm11?=
 =?utf-8?B?c0dUcWEzZm1MUDUrQnVYRmh5WHg1eE1QL3VIbVE5YVF1WEZxR3ZFU2tSNnJW?=
 =?utf-8?B?WWluWG8wemhlQ1NxMjU5cHMxZCtrQkNGbE5oNm55TjErK3lSM0tnUnlFVXFH?=
 =?utf-8?B?SWN4WUNiRkUwUnB1Q2R1UUlQaGl4b1Y4UnQzUkphU0hPbGxEaHJIbUNNUEVq?=
 =?utf-8?B?QWlIRnNOOGxMdldVREJ2a0pOYzN3Z1RPTU94eVY4cEo4cWpJM2Q3WDRCcncv?=
 =?utf-8?B?QmliMTJpOFVjaEduZ0o5U1dVN2IxdGVnNUlhSm1KWnQrVU9nYVBCakJxN2cz?=
 =?utf-8?B?MXBTUzJ4VXFCTUl4Q2xJYXFnd2pZcGZmSXFrWUNGWjVhNVllTW1kck1XVFRN?=
 =?utf-8?B?NWNpTTgzU1BsUzltUjdsOHlRdWtScTJlY05lZCtCMmpSaEdiaTJjNUNobEQ2?=
 =?utf-8?B?enFibnZGWnljd2JUSmhxNVJDL1Y1bkhSM0lQYVF4V0htNDk1cjdieGFlNE9k?=
 =?utf-8?B?eHA2MEFuL0plUTlVVHoxOFRFWmMwNGhBdENBUFhZNXVxWFF3bFJoQzV3VU9N?=
 =?utf-8?B?bGdJZkVMRmw4bm5ZcmpoTE9sbXdDSTVGaGRsTE1NblI3YUJPSGIzR05NRSsx?=
 =?utf-8?B?ZHFVcTV1Qmp2T05mSlp3WFBsa2dmdVBsdHhuNGNYM3RWdG1VZWgwZzllQlda?=
 =?utf-8?B?V1BKcXhlMnh6S095RXJvSzNyQTNodVhvb3dWQ0ZnaVprQ3lvdVpPbFRBWkpt?=
 =?utf-8?B?NmFJdjhCakRHNTZaRVRnOExYNDZEYWluNGRWbmdKa094eFRzZDYrdVdkK0RN?=
 =?utf-8?B?V1UraW9FSnViY01sMTFJcVRva0c2L1V4VVVOWHRnbzdwRDBObHBQQ21OVFNH?=
 =?utf-8?B?a1JxMDFBYUprV0ZaMlkwdnhaeFF4V1kvZHdndW1mMW5IVFp0YWdyQlgzU0VG?=
 =?utf-8?B?RU9wOUhwT2NqVEVMblVTa29PRFB1ajloT1JlUWozeThRVk9hOVR2aCsrM1RS?=
 =?utf-8?B?enAzcm9nVXRhWDl5VTQ5VVlBMVBRTlRnM3Rra0FReTBSTFNkOThvV2ZyK1Bw?=
 =?utf-8?B?R2lTM1ZnUmRPUUZDcTRnN0FHdkVSbElqWmM1T1diblY0Wm1iMjhpL21sdmcr?=
 =?utf-8?B?aG1idFVFUGJBOTRUTExYMjdCWVZaaXk3R3lwcDJKSVVlTWxsWHp1YlF6NWZ5?=
 =?utf-8?B?YjBlRElSWUlCWmJQc0NrMklBb0YyS3BZcUlUeTV6ZktpVWpCR1pOVHg0MW45?=
 =?utf-8?B?eDFIWm5NVVZzOUwvdGwxN3djclV3WUlYckFFSXM4RUU1V05mWG8wN1BWOWh4?=
 =?utf-8?B?eElXTzQyYjlXVXpvd0YvajJ4T3dmTjhsa0JRbEc1L2VpZWpjN0J3OHUvajZ2?=
 =?utf-8?B?TXNWOTZkd1hCNnRNNWhoTnpWSWlnNVd6b0JUak1kYUtnQ0RxZWh0RGpCNko3?=
 =?utf-8?B?NUZQNlRTNk1BaTc0ODJpQThQL2YyQTBKQktMTGpzN0N4MHd3ZW9nb292ME5T?=
 =?utf-8?B?U2t4SzhpdXNFbXVRTSttTWR4d29FeVpySEtNSXQ4K2hVZUF6ZVRLUlE5VXdV?=
 =?utf-8?B?MUl0Mm9SeWRPRm5iWWJBazlmOVluNDVmbW8yT1RVZzl0L3RYYzV2bCtGejdO?=
 =?utf-8?B?K0VZSVlMeTcrVzF2bEtOcnhqbjViSkpZWXFlTnpIbit4Z2piTndUOXduZDh0?=
 =?utf-8?Q?ZrgVLW+nfe6EWbiGLnAhaiw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SlhJekRsVTJDZjB4L0g3WWZLVWxZLzVNUkdOZzhIV0UrbCtWNFM5QjBsU1ZX?=
 =?utf-8?B?WGlyb25oNXFmTWdNVTc3ZWp2NlVheXhqa1VvcS82NTI5aXk1NDUwRmovaVJN?=
 =?utf-8?B?M2JURTU4N3JxTG5jdEw1bEI1TWpUdWljbitvYXc1K04zVnpTV0NIbXl1WEFy?=
 =?utf-8?B?QVJESC9lRFk5cWRnSmc0em5ncHV0NmpJK2hid0N6V0NHWWNURk5WK3MxRnJm?=
 =?utf-8?B?QTMvSzhiRml2V2JTanpjQ1BVaTQyOFEzekJHVENaRkhnVGh6ZDMyeDIrWmVp?=
 =?utf-8?B?S2dHaDNtZ1hWTUQvTHJPOVJLSjFEVm9uQlZNZDdjNXFwaEhaQ1hOOVhjSlk5?=
 =?utf-8?B?VFYydG00MVdFYS82aDZjZVNDNmZlTi9NbGZWNW5yN1RIaXp5YURNZXg3NmRM?=
 =?utf-8?B?Q2tYcTFlNkxIK1B5QWhldXpVYlFTa0JsZ1liM2JGd2ZuYW9VWTJEeVcyOHN5?=
 =?utf-8?B?d0ZFOEIwcjVTWVFPZm4zaWdhdzZNTGMrN1ZLbDBpNmw2Z3BaOThoRTA2cjVO?=
 =?utf-8?B?dE01N0p0UEJYd0dIYWRuNmhkT1prRzBVOE94NUEyQkR1L1Z5NytTOGFYSzFk?=
 =?utf-8?B?cU5qUUFwYUE1M3BaaG1zMGFLY0NaUU90c1JoblZVcHZFbVczRWpSa0JVNmZ0?=
 =?utf-8?B?NWxMemRDQkRNdjIvNVo3YkRJc0dDU1NzSWJ2UmZSeVdWUUZiMVFpNUZGMm0v?=
 =?utf-8?B?WEx3RU1VckhFM3VvZVp6TWVPaEl0TEZWdVJ3aU9TanZOYW52djFFc1NhZy8z?=
 =?utf-8?B?R0htSTFubjZnTTJpUk9LRjFHQXF5R1ZwMlJNK0ZYd0h1MmNPZUdmVHJNd0FD?=
 =?utf-8?B?QnJpMUl3cTVnSWVsb2xLUUFJTDc1VEFUdlhrWGtMYUZsK1V4N09DQzVDK2ln?=
 =?utf-8?B?eHo4K3VIaTFuam1KTDF0NmJYK1F1cEVBZ2MxR0FQUmQrVVZ0R2FWQmJBTmd2?=
 =?utf-8?B?OXRZckJoVVBTWUN5ZjVjL0ltT3JJTGx6MDVOdEIxNHZTanEwbExvcExkTzhF?=
 =?utf-8?B?WDFlWTNJMU5nTXk2TTM4QndvV0VHWG5BVk9pbTVNbWVZTGlYNU5qc3NaeTBm?=
 =?utf-8?B?anJSWE9ORkhiZFpjWlJIbHFxZ3V3dnBtQlp1WUo2WVhEdGdlanFnY0JORmNz?=
 =?utf-8?B?K1hmeGpxWFNLeGhIZDBabGxWeE4rb05sMDFZQ21VSzdXYWZKWm5GS3BCQ1Nt?=
 =?utf-8?B?STZjYWtJQVBIblNHUW1HOUQ5Y3NzVEFxQUYxYTZsTHBka1dON1VlYm00b0Rh?=
 =?utf-8?B?MmlTc0hsRlM2UFhZMWtZMjJlV2VBOUMxK0xtMmhMK3RqRG8vUzZiay9FK1Ri?=
 =?utf-8?B?YktjcGZEdWdoS2VjQUZ3cGNQUVdhNHA4U0hrWmRTS3JkRTFWVnJtWEg1T0lB?=
 =?utf-8?B?S0dNTjhNZkppaEhZQUVYVVExSE9mT0NNc3cyRlZpMGd1amh4eFdHZS90eGJE?=
 =?utf-8?B?R3NYRlZGZGpmcllFUEZZNzlxdSt0Ym9peFFsenZnTnVUYmRZbzRUMUcvb2VY?=
 =?utf-8?B?V3pFM1lmVklZWnhzN3JXbnJBczZZMEoxci9RSTJVaHRYUEpvMnJzRDJXaDEw?=
 =?utf-8?B?cmx1K0tvRUJzMWZqMFFIaDd6UHNlR1R2Z1hZRXVnVjJGWU5nazFDa1FaZ3F5?=
 =?utf-8?Q?RNlbh3rUvZWQd6xAvy/QID5M1XS+6EHAlNL5dNtD+xOg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47a09f7e-52e3-4da3-caa5-08db0ba409aa
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:18:57.0286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lt35p/PbvbGV15huKJAeJLsK5WxdYDvdVMdBnW+fF4Wf3ZUcVZArmbwob9Nvwqap5AflJXVxn3xxHfJiU+p/zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100173
X-Proofpoint-GUID: 9R6lUaCITpmDTPqmHX0Kh5jrdFIqbxpo
X-Proofpoint-ORIG-GUID: 9R6lUaCITpmDTPqmHX0Kh5jrdFIqbxpo
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

commit 4b9880dbf3bdba3a7c56445137c3d0e30aaa0a40 upstream.

The powerpc linker script explicitly includes .exit.text, because
otherwise the link fails due to references from __bug_table and
__ex_table. The code is freed (discarded) at runtime along with
.init.text and data.

That has worked in the past despite powerpc not defining
RUNTIME_DISCARD_EXIT because DISCARDS appears late in the powerpc linker
script (line 410), and the explicit inclusion of .exit.text
earlier (line 280) supersedes the discard.

However commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and
riscv") introduced an earlier use of DISCARD as part of the RO_DATA
macro (line 136). With binutils < 2.36 that causes the DISCARD
directives later in the script to be applied earlier [1], causing
.exit.text to actually be discarded at link time, leading to build
errors:

  '.exit.text' referenced in section '__bug_table' of crypto/algboss.o: defined in
  discarded section '.exit.text' of crypto/algboss.o
  '.exit.text' referenced in section '__ex_table' of drivers/nvdimm/core.o: defined in
  discarded section '.exit.text' of drivers/nvdimm/core.o

Fix it by defining RUNTIME_DISCARD_EXIT, which causes the generic
DISCARDS macro to not include .exit.text at all.

1: https://lore.kernel.org/lkml/87fscp2v7k.fsf@igel.home/

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230105132349.384666-1-mpe@ellerman.id.au
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/powerpc/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 1a63e37f336a..50a04347ab05 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -8,6 +8,7 @@
 #define BSS_FIRST_SECTIONS *(.bss.prominit)
 #define EMITS_PT_NOTE
 #define RO_EXCEPTION_TABLE_ALIGN	0
+#define RUNTIME_DISCARD_EXIT
 
 #define SOFT_MASK_TABLE(align)						\
 	. = ALIGN(align);						\

-- 
2.39.1

