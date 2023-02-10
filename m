Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13568692835
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbjBJUX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbjBJUW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:22:56 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6FD831C9;
        Fri, 10 Feb 2023 12:22:13 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AHwfgX019274;
        Fri, 10 Feb 2023 20:20:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=QqBCW0Bt5JbyYA2UStm7LO7bdepNZRe0BKllSHzxss0=;
 b=fwPffx00yD10rogBpQVgo+UGvP1AmlgCb0FJfZ2Y8MH6wPJIoSe+eotDhTDwHJzFPAyl
 pbl0E7qFortF3QGP8n3eYlYY8WJ4suTdrgEnvVfHz5HdmxvK1JYafh7jgaYAUZvoUCOR
 1vopOaJRBlAuMvhRpoIX0pWOhrbKB2UDLzbAw+nx+UoWQruZPgc5RdiyUMRR9y7KJj4o
 xB7UYqtn1yANee+ynEw3/Iu2IlNXWrNrXvsIhSFocmLJapMMGno4nILrb8jFdj1r6tNJ
 hzXEitlx6ioUNHbIimT8MXSPibbSrwVk0SBEBzJRmVS158QG9YIbhWBq23q6tNC+Sjln rQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nheyu68ms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:20:48 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AIpDEY013624;
        Fri, 10 Feb 2023 20:20:47 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtaqmhn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:20:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOOMIoZL3XnnfMkM8v1tMWlJL0TwrkraBAb0DRRb0C72kcVnYHDbXYnId23eV+Zu2VZYAoZahrrW/4XU29QA/NCrZUOUDTDNiJMtgAd1Tim1eSk3WYugX3bxcnk1g/i9awfKj0NhoLiINYPIkSx8dwNk4Co7s+KgyVnAQuzcJF5lmu56LKyNP2t+Hd4H9K9EHTYpnJQN8prFqzAihIPvGeGbik7w8J9NO0p9VGvrP4XO1k7p9C0Z9mJya7YfIVdLo/gaUA8I38E7HL417lNnsg+PcHBU1HnF9yyoqbzp0b4zNDO/XwrNzssOieACAgIdCUVWeR2CzgBny7sdJ+6Lng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QqBCW0Bt5JbyYA2UStm7LO7bdepNZRe0BKllSHzxss0=;
 b=YNArriEPJXde6peW9uBD2gDHJbWWiGwUJ7GvDQVgA84p3pAChq5bnTUQClfi6ky158x8WaF1J9sXaJ8bRWEGRW3Y4dWLElVHTkC1NxFckllxfY9YIirSzEjGrXcxE2A3wOdPj1OhHAbb5U81q1PYPibOOlRxlSI8eEC5y0EqW9rRp/wjV9Oug4TLBzrTVZOKmpAic6c9BTkoazvCw+tDSfpe2tVXRB0wQIYWpK6EPqxJeJgVQmkJKcHI/tpk/k/OCt1qEuUJBOwz96fblmaWPPh2TVDE4RQ0Xrv6yIQ7ila7doGH2/WEv/a5oNNJx1c2ar8SE6AC0LU9B7og0cSOaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqBCW0Bt5JbyYA2UStm7LO7bdepNZRe0BKllSHzxss0=;
 b=ZkC50hRN68ttvaMEf3SFSULgNIt+zodOzKd9wGyJQiH0iM/XmtKdkfiaO8cx2Tpg7RmHcD3O6PNDP63JBmlvmWAqLhCUFBUrL3IU8KsE0YevY8YCA18yG+sJ1zwlweNoMrIpOy766ttp0VbPlrO1kr4GFQ75Kg0z6f0HtX7B67I=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CO6PR10MB5652.namprd10.prod.outlook.com (2603:10b6:303:135::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 20:20:44 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:20:44 +0000
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
Subject: [PATCH 5.4 v2 3/6] powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
Date:   Fri, 10 Feb 2023 13:20:24 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-4-v2-3-a56d1e0f5e98@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0298.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::33) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CO6PR10MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: 60c98fb4-b3be-440f-4513-08db0ba449d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RozIESzAEwyEmI7a7t6hr1nFT1qDCawzNDBVkOk/KqtZw3iu7vjxdr6dqsRZIZZWod8WbymkCIoWJWoQ6Lujyx5cwO3r/NF5exVfJR9lw+rEVT4NF94BUWQ0ipgLD9DMUYmhL/YuSOleGvv1NdshMHZDGHStuBPYHrfdJg0E4CKFyz3Wrsh+u/uuplcszcwbyjpmGBIjaOIDme8wWUNLctA4GQfHQZ0CJlTNtivdifZgSqcs1hN2Ek8Wienk+Taw7w1y1yBIZVhSs5uTLijBIy/hStYWCQKizqXE5rDc/IvUCQREVghJeNjm3ksWeMdneKAlvpg5kvoExOMWpY1o352hCzpRwvsloeUX9/+MSrkRq5fAPpOcbcBFHBCLJ7NRG+M3Le/xHCcHRfVCviPlYnHEtxeTVSKZWJZsIOgM+mQ0DSWWtZ6swOJEE9jLGoEuw9md+wx9QFV6iZupIOUIDc05ANtbaXdnteGcqRaoOalyqI1KynK29gstgZEBt2xuMKgVFr4CAAs5q6XJx8kYlZFGNY7FtTO0MDdzsKVcAuh/5Wo9n3Sv3Hm+ifr8tEQ2VBpjbMIqhRdw1N/wAs9yXHvck1JPLoOLCyupRw4fvmPEZnESYxTZLvwtjA+NDBKv0gtnisHR/URHIzpZyR8HDszCQQwreBbB9KqKjt3SZh/XHkCBAaAyRplDsuy5dW8uYsGjyKo3csbdE0E7Vz6mlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(2906002)(36756003)(966005)(6666004)(6486002)(478600001)(6512007)(86362001)(2616005)(4326008)(6506007)(6916009)(8676002)(66556008)(66946007)(66476007)(7416002)(44832011)(186003)(5660300002)(316002)(38100700002)(8936002)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QmtLNFI1MjRRK3lEUWVLVDVWSHpyM05OWTNYb2I1MytINURoQm9SSnYvMWFw?=
 =?utf-8?B?Z0wrRjVIaEVVRnRYNUlvOUJrWnVEMk9CaThubnUxcHg4NmdRRkhIanQvUlVW?=
 =?utf-8?B?VDh4SWxDQ3FhazdhQmJreVFlSXoyeG1ZQnYvYXptbTZ5aFA4c0VFMFhiMXBN?=
 =?utf-8?B?b0crd214SVNQanA4a21LdDR5VDd2bjZpL3M1bUcrWDdmR1JkT2NmU3hpYXRT?=
 =?utf-8?B?Zk5SU3lCMTh1STZmdmRnYXJxajlrT0RlM2NtLzRJTDR5TkxkSWxIajRxeDdO?=
 =?utf-8?B?TGEwb05ONzBZR0R2VUw5dnJDR0ZacHNNZlZVcGJlRkE1UXdBRGNRRjduSlBt?=
 =?utf-8?B?SGs0TWNBUEhkUnJtVG4wMm1UOEFLSEFGRFdXcG1oQVY5MVF6WjNEdjlseENQ?=
 =?utf-8?B?YUkwVDZzeXFWbEg4WVFTc1JVK2dobFg3T3NFa0kvaGd2bGR2QU5xU2pWL2lD?=
 =?utf-8?B?bjFhZE5pM21UUVpvd21SRXJsdC9iUjZ4cVN6MHZKNjE5T3dwYXRvak8wVU1y?=
 =?utf-8?B?dUQ3MkJzTTh5MERMd0p1KzFOSldaQ1Rld3NaOVMyLzlYUEVaemFNNzZmZUQ0?=
 =?utf-8?B?TERJWjhIcXdLdk5neEprV2kwSkpYUmNXS0Y3b0NsS2JmaFVBdDZJNTByaTRO?=
 =?utf-8?B?azV4c2VJMzh1ckkwVUN2QjMwNjV5U0IyTWFSRkFpNnVWRHZEcUFrTkRYZ1Rp?=
 =?utf-8?B?RFdjajV1d1RHQzVKMWlWZ1VMUVBJdGJCSktVNGNXOFZWTzZQeXk2MnBWMUxX?=
 =?utf-8?B?SW9MWVJ6RVhOeVdhZlMvZGZmUEVubWdIb3UzR2hMVU4xOXBHZTdwakg2b0hR?=
 =?utf-8?B?UFhVQ0tqTncwVEJxRWZQUlpEL1NQNW9pc0IrWm5XSWZDQUJMM3JodnZlMTBU?=
 =?utf-8?B?N2NXeDVGSXNlcVZsMGhzczdSVEo0MzNvR0JLSlBlbS9Heldsc21hRWFJd1hn?=
 =?utf-8?B?M3hWNFU2SittWEZPWm1TT1J4NG1oeEZwSCt1VUQ5UlVvQ2xxWFgwL3RUa2xt?=
 =?utf-8?B?MmFSN1NUMXdxblRFbVM4SkIzZmFUNFhScDV0WFJXNFVCMm9PdmMwT0VMREpv?=
 =?utf-8?B?Vy9tYW40cEJ0SmRqbFVKaG1yelUzb2lZRG92d0ErMWFYbHo4Q1pRM0tzdHNi?=
 =?utf-8?B?RGxaUUxsZGdiY0Q3d0xrZk8zSUNFaVJUcXVNOE1sSjQzSVpIcnRQWURteEtY?=
 =?utf-8?B?Ym01ZmRPK0toWll6VSswQ2R2WS96MTNZSks2aGxwRWtNMDFWNmR0SWQ0THI5?=
 =?utf-8?B?bHR5QStsYWpJV09WOVozclhjK3BRWUxNSEpiRmpCL0hzTkZmd2c3QUR6MXRW?=
 =?utf-8?B?Qlg2QWRqY3h6ZWhhVVZxOUZRTFZYUGRnQTBBdVMwOGNQY2J2T2J6RkdqM2VI?=
 =?utf-8?B?bnlVWmxnUDd6b0cwRWZmUXdsdE1USzVBdHV6UkE2OE5jQjk5dTFBR2JGdS82?=
 =?utf-8?B?d0cvM3NLOG5DVTVQc2M5WFdoMnVFek9mTlpYbVlpZjJzUnZBajNOaWwxZUx1?=
 =?utf-8?B?bnAyZWJIU1JMY3o2SlFBcUJMY3ZRWnhjZUFJRjV5a1E4TDJvSDArY3RWTHZj?=
 =?utf-8?B?dStqRTd5WUJWWnNPTEN4U0JCZFM2eXEwa1Rldlp6bnV2TE83TkxUTHlJTk1s?=
 =?utf-8?B?MjZGb2ZUNjYveXNyTm5kNGxIRERXUm8wdmdQL2lXL1JKS0gyZ0l4TitlUDY0?=
 =?utf-8?B?WnBhb0hRSHh5YnNVN3gyNzFmbVJRSkVGK0ZSNFBDVVR6dDNCR1YwQWVZRTV0?=
 =?utf-8?B?VUFRY2hXZ3lUN0xPUHRrWVcyajlWYlVBd01FVjg1N25VcitsdVB5QWV6bWRV?=
 =?utf-8?B?U3RMTDRRZnA4dkZpNFFOVUNPTDEwUExBRWIvL1NhVXFwbzFYc29SckpqVzNq?=
 =?utf-8?B?dHFYZTE5RnN5MGNyYlhFVXJwSXVmY0NJUnlMcWpWL2ZRZnRCSWFaWXhGbWhP?=
 =?utf-8?B?S0JTNHRXcDRRWU8vK1BwRGtlVUJxTjFISVdQcHhoUHBiU3NNZVEvT25uejg5?=
 =?utf-8?B?VzhUMWpGbXQwMU02Wkg4U2I4eVZZWmd5T0krbk1HYytHYjhHTTZIZnpIUXIx?=
 =?utf-8?B?RG1WajFxaDZRTmRKRUdRYVdzQ0FUcmY0Z1lQS2RqMjVvWUFWd3dZZUFzK0hY?=
 =?utf-8?B?QmJYNmZOa05CUStrcExDMVoyNENJZ255QnBNNnlvYU5TL3owWnRvWlY4YVZY?=
 =?utf-8?Q?KrzAT5R/72DE/58K0IJtpJc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VHMyelZmMHRrMmJvNG9YOXhxNzlpT2RFMS9iSmpYYW1nK3hpR0prMEhHU1Zt?=
 =?utf-8?B?SU42OU9BcEMwRStWNnBEcTB5Q2RNQkltSHdoTmVCQm04eERXT28zWTl1Zk4v?=
 =?utf-8?B?ODhKRkVVUHNVSzU4Z1huVHpFbXg4WEl5UnRnZ1RLb3M0YWVUZStiMmFNZklX?=
 =?utf-8?B?enFZMzdFdDlYYTlQRkpMZW90YmtNdnFlWGFRSmNqelUzdElCUXZXTEhCdXZU?=
 =?utf-8?B?RWplZWVrV0xOd0FLS1AvTVA2ZzhTay9LdWowYlplUlFYZERsbDYxbkFmZi9n?=
 =?utf-8?B?SVczOWIyL2NpeGNzd3lhenVCRFdLUm90N0lHZER1NjdLZkt1d1NVYWZvek5Z?=
 =?utf-8?B?c2pVOTlLUU9CMUdPdFE1M1FrOENLa2FVaE9vditjYVFQdmtveFNFcWc3M3N2?=
 =?utf-8?B?QXBwNGU5Y0JuLzhDRFd3OW5pQk5YRG1ralphaVlUQ0I2dFRKTzVuTzV6NDZU?=
 =?utf-8?B?bzJxOHdWUDNVbVFTdjYwUDlKa3ArQXRIOVlabEJkMjhrV1hlMmQwLyt1Z0tK?=
 =?utf-8?B?K3RKak9COWJST1JKZE9sOFp1L1RIdjYxMnhxNGM0L1o1MkJ3M1g1SjYrNHVh?=
 =?utf-8?B?UStodXR3RllEY3ROcmhZN2pPRmZCMHptdFpDSmZKTVFLVTlrdmg5NmZ4WDUx?=
 =?utf-8?B?T1Y5MDBINjJhS2pxT2IrVVUwSVlNMDB1VzZabFBXZTdCUE5iWEdybzlOTlFq?=
 =?utf-8?B?RzZ6Z3FtZTBRcFh1ekN2MFRGZ21JVDU5MWZTTXBKOVByeDI5MUNNTUpmWkM5?=
 =?utf-8?B?RUgrN3VxY3RaK2hNejI2elQ3cmJyUjVwYktyK28zNHA1czFNWDltZ2IxTzJI?=
 =?utf-8?B?U1hoY0EvcDZCaHBVWVFFM3BSZTJTTitSR29PTmpjZGtkakw3Mk8rZ2lQeFRq?=
 =?utf-8?B?NDQ0UmNIMkYrbFI4M0hBUFlqU0RqbXNJTFVOQ3lJN2dLNDNjYnI3aGR5RDVo?=
 =?utf-8?B?eEVCMFZZUmhmR0gyc1dFUy9aUzMwU2l4Tm5jZmg2ZFdDcUo5UGdEWWNCWWYr?=
 =?utf-8?B?czBYQWh5RW1MaWMvMFFZay9rdEtRMHFJbnFocjZjbGVSY3ZXak0wN1JuWm5X?=
 =?utf-8?B?cVBhKzNkSHhOQmZpSm9yNzRRNG9MMlVhOUZVVU1UTlV5d3kzMk1zRVg3alFN?=
 =?utf-8?B?N1BxSmlOaVJFdHRkUVBXTVYwK0M4Y1k1QVJaVjRsbWh6QXV4NThveTR6TUkv?=
 =?utf-8?B?LzVBSFVkRkJ0RmQ3dXo2NGtEU3NuV2JSYy9yeERLR3h6cTBXekRmcVd6UCtt?=
 =?utf-8?B?SFlIZ091bC9CVzhsUjA0R2J1VURiMDFzZWtJS0o1ck0vZlBDQldRYlFtZURF?=
 =?utf-8?B?ZlpmSzNwR1F6UnFkcDZzam1TNGpZc2o3UTdPVlVSbDJ4ay9xeFhWamo5L2JO?=
 =?utf-8?B?Y1h2dE55Zk5yWnhjR3RVaGVLM2daYWJBOFlQZHdTV0hmMzlvZkZnRkVXajNB?=
 =?utf-8?B?cXVSbnl5YTV3MFNqVFpQVUw5THJMVDYzSW50cWRZYTVuWE51UTBZVVN2U3Bs?=
 =?utf-8?B?ZTA0M1pHY1dqc04wTlRyd2FlYUppUC9FQTUvVEoxTUc4V1Jqa0ZNMy94NUtT?=
 =?utf-8?B?QWc3bHlyME9uWmhieU9PZFdWeFJ0TVZaWUlmOWlJVEdtVWlGRFBGa2t4N3lt?=
 =?utf-8?Q?yXS2mnX5UeyOhCzVm3LDWB0S4DHDh3vVrsnxNCTfIlMQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60c98fb4-b3be-440f-4513-08db0ba449d2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:20:44.6616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q2lGSjiA+A0OcCaEoYJpIT1n9g65RSNyickyqNgAGouBT4UD+d8OJniZC6OlOZVQUM6LrQPDHv/LfvBEPNuX0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100173
X-Proofpoint-GUID: g6EWzY_tPUnH7m7dRgFDI37sTa3vt1ih
X-Proofpoint-ORIG-GUID: g6EWzY_tPUnH7m7dRgFDI37sTa3vt1ih
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
index 3ea360cad337..4d5e1662a0ba 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -6,6 +6,7 @@
 #endif
 
 #define BSS_FIRST_SECTIONS *(.bss.prominit)
+#define RUNTIME_DISCARD_EXIT
 
 #include <asm/page.h>
 #include <asm-generic/vmlinux.lds.h>

-- 
2.39.1

