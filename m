Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0810B692811
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbjBJUVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233779AbjBJUV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:21:26 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B32C653;
        Fri, 10 Feb 2023 12:20:31 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AHwrY9007089;
        Fri, 10 Feb 2023 20:19:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=AhQSONNbupqVH4rRfSwGHzzv1jtMgpIdW7W9Pkq82J4=;
 b=LbQ3sKng8CxtAVNnUJmXoS7P6xlEAPh6qVNC85dyzfmLlz4U2qQ/0P3uVlt09RRijgWf
 Oc65ojX6i9/Tk2xwYqqb5JPoW5Tg9VnHdnwSEhHqDAKCScJJgLp+9FJjjmihDfuUjd4a
 jy10w4BigopFUOMgxF5eFRr9fCE6wn33MwYEsvzKRnqtHZo/TLa9p3eh9QkQVa7rwn5b
 ku+lizEFIASA90pAyHpZLNvk2ioJEfyJfN8qCAQ/RjeYkaEAw1xJB3IfP4Y1P4SRGx1W
 k61JOEuzU0pfkb3+876/QwS2SMuWYMz0BNOpsKOA2ccaw/gh/pWlWHzk3sIwdtKCZVYn OQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhe53p6df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:19:56 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJ6w6x025750;
        Fri, 10 Feb 2023 20:19:55 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdthtf2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:19:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZsPwwBWvbqUKIDQlGXJZkk+WEix4QZ3DNI5+C4yCdxWbYKZRAKD6Q/8vBEe3J5o8C1/9rk/ft87YmskS6NTJVRK2fAKYmDDQ7vQZvg8TcTFVzYXA0aEiO3Mst72U1FPmXBh90ro2UReBcSone3OuTySrSTCYxQZUt1Flt3/hN6ANTcu7JSx1x2OVuNnvKGPclZfvUDgzUv0uFl+bbYOJ/Q9VnYuyWTrdhXEZ/LPb78wdnRLrTWwRjaemkkKYnjCIAHhWKfEiytykH8B9AhjIVQksp/3rLStLyWbVGNl/iVCVdYg6rv2DbL4Pq7y70wcBsjEeEBQjwN+ik6yTJPu7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AhQSONNbupqVH4rRfSwGHzzv1jtMgpIdW7W9Pkq82J4=;
 b=LHQlcUMnavrUYq2Mu4gbmxcn2NnsIFGbU0Om3JVGsElnoHNtidP/NrXmHRfduMIlqIRHWwTJVf4eQ4OfL1AmpxBTiK0yvU/YM8uFlirNJkdUR6alBjw6HI3Aaj3CpJwerKXa02O5vbt0B1lJuJNfSu9bzkmq78rBZrJJPRhm7mLk5/EuDv9Fb3FI6ZAwpKu5nDF1Lr+dLNCVnijFYXgw0nS0r/SEBFgb3H42zEjcNzfjtT3JdY9YiNo9r0a7IR118ozlvaUAzH1K0TrMwYwgJ1O8r8qIZhJfcVPvLJXjDBy5N2AxKuCA2UCJ+eAuwqZB6G5OiVmGNqzJx6lsNtttPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AhQSONNbupqVH4rRfSwGHzzv1jtMgpIdW7W9Pkq82J4=;
 b=Y5ucjTmvKUfyBwHZEtYfyaC0SyyayTv/dTCEldgOz5CkMJMZXmDMgLcXDikbzyxCBUymr+ook3XMHr3I5d8fjQ2t8+08HtlWBxM9sZV3f5LBmWXwzHq4zbe8ruUMWAB9GSc1JHcFijpu3A4frAaRxFarhcwGZkE9Z9B5WzChxEM=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CO6PR10MB5652.namprd10.prod.outlook.com (2603:10b6:303:135::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 20:19:53 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:19:53 +0000
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
Subject: [PATCH 5.10 v2 3/5] powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds
Date:   Fri, 10 Feb 2023 13:19:37 -0700
Message-Id: <20230210-tsaeger-upstream-linux-5-10-y-v2-3-ada7b8d36096@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-5-10-y-v2-0-ada7b8d36096@oracle.com>
References: <20230210-tsaeger-upstream-linux-5-10-y-v2-0-ada7b8d36096@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::32) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CO6PR10MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: fa645596-0984-4327-1795-08db0ba42b2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t/YPNq1DB7KPNYhxpzHuUakrfMAbymNsgeQeoTrviyYv990dhLfGyjJjfW3qGYfCbebjts7uhHW9gJNgcydWL61ck5cse9mr/8o48FEUxf50kEFVXvqfLTbw5DIImz97l6jJH3x6u4XS0NEb4qKdoIhz7O56dhROV5OkRGUrT8AsfTj/hmhzxqPYA+x+it/bSbZcFSd6YiN5m6gXcss8rFb0KzPVFXsSMmr33yl45DYPj59kDhGcVruJc7QwcPIOfh5KdNMEay1H5im5THXDiYGeAf2FhYlcAP4CmsgJsvpRVRPDLGqKkoYZuAyb70/Gm4l3YHXlm0BZhyPFdcYN84pBXGorRudyc26pa6i+C8NomiJjvrtPwNHG1B7iun/o1V1tnIiUGrW8RQ8sA/u/v/NHvzv9JNIvRk2pq9QKGoXE7kOprn7pHvRmjshJ+UZl3D8XerzXSF0lHZRqGR5ZpIiHRprqX/cmN+ToMcfwSVV/HxDIOuI9EidUp5wQDVNRRyanCeDrfDmsFmM+TQVT3exAEO0IWiLs9HIzzKodf/Ylnk0C/Zm2OpoTXh8GXOXcVTG8gQL22beQqN905oM3hs8WpwBqIK/WBGhSGtGHUh2w+M9nwUOqmW6FelTb5rcoBqaRFADNsNqxDD85/gMFw1rAW/5VftsWBlxQmwwP1Mk2G9S/I3hTjCHAvLA1QDRUE3HiDyr1++bptDjD3jCKda6la+MBLBYrlAVBFylMVls=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(2906002)(36756003)(966005)(6666004)(6486002)(478600001)(6512007)(86362001)(2616005)(4326008)(83380400001)(6506007)(6916009)(8676002)(66556008)(66946007)(66476007)(7416002)(44832011)(186003)(5660300002)(316002)(38100700002)(8936002)(41300700001)(54906003)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzFFS2NHeENwcmdGTXZjOG1OKzRiMmlsaVlFVFVkNlYxVVJaeGorY3lIL2pz?=
 =?utf-8?B?ZnFDN3NoaThNOFJnckNQOUxWelRmbUo0ZktHMG0wSVo5UDVqeFhDS2l0bFFF?=
 =?utf-8?B?K0ZVYUhwcURJR09qR012YnAvUzJ1NnYrRytmckxiY0ZNQ1g1UldaK0RaNlZC?=
 =?utf-8?B?K1IwS0creDdmS2tuTCtDNEpkUERUTGcvSTJ5MFZ2dmthU0NiWjZ2T1luOElN?=
 =?utf-8?B?azFjc05taC82d3NvVVBjcEtPK2d3V0hreGExWFpUK3hkVkl1aThuY1BVa29W?=
 =?utf-8?B?ZTZYQ3B2SzhveEV6ZHFIUEpPeENFUmQyenhJSDcxQUJjMGpQRjdYMXVHaHVU?=
 =?utf-8?B?cWxVVXNNRXZrZzZNbGRCaGtFY3QwNFdEaUhoWDFMZStNbU41d1pseHpOam5R?=
 =?utf-8?B?NzNRSDJXbnlETDFJUnFLVkpEMnVpcFFPTkUzclIxc2F2WUNoRW5kNkVIVk5O?=
 =?utf-8?B?U1d0Znhad1h0RGRqY0xnUDgzMnlBVkZma3o5WmxiblRwUkdFNmlyQkxFc3VF?=
 =?utf-8?B?UTYxRHJoSmtuR3dOcFN2dUJxay9uRWRMazIxcDkxaDBGa21LemVCMGNyZ3lk?=
 =?utf-8?B?aWV5UFhFcjBNc25CQTlQUFQxMXdlcmpidWpDcHdSWDdwSmNBcFB4bGdxWkxV?=
 =?utf-8?B?OGdvZWJYSHgxd1JvRWxLTyt3WUhXQUlremVNZml4YzE3cEdhN0d2eExCUmFw?=
 =?utf-8?B?TmRmVU52eHJreGtvVlpkZi9vdjRBL051U1pVcWI5ZnhHTGtzSTUyRE11OFNV?=
 =?utf-8?B?dzkwZndtM3BiZHRQRUhuaVhseEN2dm4wTU81QUg5SHE0eXVTYmNWQ3BVM1R1?=
 =?utf-8?B?VHBhM3ZQMW1sVEVUd1dwcTRQeWFLNjU0Zzg1N0JqbCs4MXJqWWlvRjMzZisz?=
 =?utf-8?B?NDRuSjVlMkJkNHQ3VEtkd1d4dUw3Q0ZnbU0xUmxMeExoRlFhSUJleHNFZ2Z2?=
 =?utf-8?B?UzdNVXNNRGZjVFUzRU1MK0pPMnZmc2pacXRpVFBwWnJuL0hWb3lxRVpqdFdz?=
 =?utf-8?B?TVZDcW9OdjBPeU1SaStwdzgybmZ5T3pGRmtlTWlCV1NUSXlId1cveW5WMXlK?=
 =?utf-8?B?anIraFlyRml0TThPRy9aNzE3aDJTT3FwRUUwUTZJV0hXeDVPUytONUxYdGtj?=
 =?utf-8?B?aHhRQUR1dDV0bHJpaFRKVmhsdVMzVmlaQUhLRGM0SDJJalE0Y1A3RnRRWHNW?=
 =?utf-8?B?eHBkYVVHM0N1VFQ0RWg0VGNTNWtNYVc3Z2JHdElxNDhxK3VGcmxDOFF1bjlZ?=
 =?utf-8?B?VHpJYU11Yi9CQ042VHlDQ04yamRWQ0o1SC9rTUppMnJnUCtwSVRCNlNkSlkr?=
 =?utf-8?B?VmUwMXp5UXgwUitncW1wbVd3OWZkbjJtS1ZqRVViQmdmZGl2cUsvWGdJU0VD?=
 =?utf-8?B?b0tCOVYwZnVXWjB6UHRTR3BwMFo1TitoNStmeUxyL0N5em5VZ2VoTURhbkhK?=
 =?utf-8?B?MzJVanA1TjlLOU1LemJESnB5RnByRnArQThDbFY1MTJuSUM1MjdwanFxRm9L?=
 =?utf-8?B?TklEYXpNNVF1K1lnZ290OU8yZ0k5NDd5R09YeERuaXk5aHJha2Y4em92aHhK?=
 =?utf-8?B?UGJYeHorTkFVdlN6OEpKdm9OdWhQRzFtWFZMbHhFemFkeUJUMXpFRk83WnBX?=
 =?utf-8?B?ZDRoVFA1ci8yZjFUK0xrWG1BdDRLRmgrdnQwazJrQncyOU9Ka0NhQVlYeUlu?=
 =?utf-8?B?TkM5WUtsdXFaekd6aGRLdDFqV2RCcENkMEJCZklrUmdRWjY3K3oweXRmOElG?=
 =?utf-8?B?QmU2c0hHamtTNStvaVlmaFM4cHlEQmVneFBIV3NLRi9EVU9oYmVLWE5QY3E2?=
 =?utf-8?B?NkhYeS9KaXVLcFhXZUp5UGNxRUErWWNhTExueUZSU0YxVk53VnZvOWxKS3Jk?=
 =?utf-8?B?b00zL05xRTNVTjFXS3BEOCt3M09XMGxUT3VmNTlJQzgxSUEwNmQwUTNncEw0?=
 =?utf-8?B?Sk95S1lFUm5YdXI1TU9MYVA5cVdmUUlxa09xc3c0Z3VkSG93aHUzaFV3K0Jp?=
 =?utf-8?B?SGNKQ09qSkltM1pSL0REVmpWazhwWjFZQlFsaVZkeEM3cDBhVzRkeC93VEYz?=
 =?utf-8?B?TlQvZytiaVBwMkRXZzlxbDRKTkxDbW5XbnJkbEV2ckl4Vld5MzR5MWoxa1RG?=
 =?utf-8?B?ZVpNNHFjcXVielUzUlA1K3p2SnBvOUFFbnNYMEdubkhSUjdPQnhjekdqQ0Zs?=
 =?utf-8?Q?lhQi9eUAwILKeHXNdOPbQ7k=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MWxYd2diMlUzTVBzeGU4dW5oSVNFc0JpcWJyU0xpeXVBTnpCdE5DWjZEUVJK?=
 =?utf-8?B?a0EwcndyVkYvcWdJRklTNWtMVDROM2czQWQvTkVtTXJMRU1uOXhSRk1sVWZi?=
 =?utf-8?B?Ukpvcy9ReHBRZk9ZZk1kdkdmSVJWd2RicXhkd2kvL0pHWnoyNDBkeGhab3kv?=
 =?utf-8?B?S1NuWDBUY2NyZXNzNmF1bFhhMXVTRnFlczE3d01ZQVJVa0NXU2w2dWxLVDdU?=
 =?utf-8?B?NDJKTGhNZ0VWSHgyTG4rR3JBNlRGczRvOWlVR3hacHZweXBaUytRV3BzNFVQ?=
 =?utf-8?B?aWdISmZFUkttV3VXajh6RDlHcFBYMU0wMklPSERlK1E3RjZNMlRQM05uVFV1?=
 =?utf-8?B?OUZaOWkrYlhuQmVDQTV3NDhYT0N4YlpjVEdNMEdHSmJvT0tyV0JiQUJtcXcz?=
 =?utf-8?B?SDE5eUllb2tDa0FUUFdzZUhBRzU3TWhyTDVKeDBxTmNBN3dTd25XcXZQcWt0?=
 =?utf-8?B?eFM4VTF6T3Rscnh1RjlVQVEwRTQ1MUtKNzF6ZUhoQW95bTNKYmtIeUVJTUZw?=
 =?utf-8?B?Tjk3UmdRN3YxZk5LeXI2NFFCSXZ6a3o1UzI3MGIvTDBOeERwY2RHc2ZvN1kv?=
 =?utf-8?B?bFJUN2JrajJENU42RFoxSUthMFFzLzh3R0dIejlWSXp3a0tEOXVIWEI0RWVU?=
 =?utf-8?B?dkJaR2k4RlZyalRJZkhDcGtXc0V2dW43U0dka2R4N01qYmhyU2ZhSGJybURm?=
 =?utf-8?B?b2U2Vmt0dkJxZENrckI4TVdJUXd3N0xqKzYwN2JTMWsxWHpqRVpTU2YvTHRI?=
 =?utf-8?B?bzUyaXFIaGdCTDdvLzFMbC9xVWpEZ3gveUsvNU4xQ1d5a3NsaVlJL0VFRkpQ?=
 =?utf-8?B?RzZ0U2JtSVltN2hoSmREeVQ0K3BTc1A5azVFL28ybUpIL1hwb3B2Vk9PV1Zt?=
 =?utf-8?B?S0M4djQ1eWxxQWp4ZWEvL0JFTmxhT0FELzNidDdNMXU3cGdybE9rQkZzWGkv?=
 =?utf-8?B?OFk4Znp0SEswVVNJcnRqYWV6YjcyMnAvOTMzTFhobml4UkJXYTR1ZGpNcnVp?=
 =?utf-8?B?QXljRTlmbnFjYzRGRk9rbFArOG4rTDVOd1dsMGVRMVRNdGhCNGd4Y3dsZUdk?=
 =?utf-8?B?MDRaend0TGlzd2hxdVNJcmlmNjk5d3p6TTljZGE1Vm9OTytLdGlTY3NETGNM?=
 =?utf-8?B?M3RTYzEwRm9NeGFqbHdMTkl5ZXo4VXh6RHJFd3hOT0RCQUV0WWo4NUowNkY3?=
 =?utf-8?B?VzJxWFo1MjFPeWphbFVwbzNBWDdadXV4WTRVWExoYlhRY1FuSG42VEMwNXlO?=
 =?utf-8?B?YWs3RTNRM2NmTXd2LzVPUlZPUE1EUmZraXBmZ1pQd2YreUdabDNIMzZ4ZzJH?=
 =?utf-8?B?NC9ZOFBVcVlmcitnMEN3cEZhWFRPektDOU80R3lFdTN6bTBIaVVkcTBjMWZP?=
 =?utf-8?B?ZjlCc2tQZEt6ak1SaXpoRzlFTUpjbnMxWFc2WkxMblU5bDZxU0tqSnlrdnZ1?=
 =?utf-8?B?eUd4NTY0NEZYU0dSelFLS0RHcUtnR2kvQkg4N21LL2t1U3NHN0pxSTlGUEtS?=
 =?utf-8?B?SEVpeU83cTZmdWhiRVFEQ1diZHBoNGRqa1RFTVFWUmdvNmFWR1RlVktDVmVT?=
 =?utf-8?B?U0I3VUhQTjN3emdyT3VJRDh4Z2NFQUZFaEJ3WUNoRkRneDdrVFovSlJKczF3?=
 =?utf-8?Q?+MdkYaS0jOErhvv/lhiLGS+ZaV0T/6aJ73Ep91Qd6b28=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa645596-0984-4327-1795-08db0ba42b2a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:19:53.2434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KPh6LnLnzVffKPIsQlO+kxrzNptvl+m+011RAxl/RJuhNB9S3lF8w/xdfqa2RmFyNWFU1B6yTKbRgQ5XcTBrQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100173
X-Proofpoint-ORIG-GUID: BrvnppJUZZxvUUU6RiWKYwdEpinEMZwl
X-Proofpoint-GUID: BrvnppJUZZxvUUU6RiWKYwdEpinEMZwl
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
index e3984389f8ef..fabe6cf10bd2 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -379,9 +379,12 @@ SECTIONS
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

