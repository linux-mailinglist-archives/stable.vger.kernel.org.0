Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5A167F497
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 05:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbjA1ELi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 23:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbjA1ELR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 23:11:17 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570B47C33D;
        Fri, 27 Jan 2023 20:11:14 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30S1XKLI008330;
        Sat, 28 Jan 2023 04:10:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=liGK6Cfe7R3hLz9yjT29KaP2fem8h5ZkQP1LS4op+YU=;
 b=Wnrm6d8KZNWEGRLKXWvzNhzdfzjBduvIWOq6HWCeVLlDGn0dCAxnIK8vG+RuqHyLX0z6
 upF03A/bdJxUEazq88MBdFh6nyJIS7aR8QpINl2pNX7cxYQsKjGgI+zd5VnvOYLhIV5Z
 LiNn2o7Kt+sq6TUJEhJuOspp20cRkXSYPpOhBpU0DFFbQiGngUkZy6GF/Kbv2whMqvQ5
 oqacAMYe6XHjOlVYAOb7FiqaFilAzJWd6+VFMoI0qgEKLvBZ7WPEbkhuaW8e14y7APtn
 d+6mkoQUFbjAEj4B7vv0SL7yQ3pmTliSMR9ed5hSk8nJKz+wcExQaNsbt9bQm8tfltmI 9A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nct4d03ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Jan 2023 04:10:47 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30S1XEmA019074;
        Sat, 28 Jan 2023 04:10:46 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct52b29q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Jan 2023 04:10:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iGeghwGJXBMzYzzkQMdPmkNjmFFs8kj0eoZ9PmK6oci+adEgplVNsMQNhtTNNy8apyyTooqAh+NugmX70xZv1Fqbriqjf9MG1tvyMjLaLSOdePivDMZkrxL9wfmXES8ytnr2w/KKuTCe1yTyhreoGzCSPS+GyWv5stkkMpFkkitTSW0Tavc8wRtkbhricJg+Gv1vvRA8vTxNmFejo1u0u1iBMbyR3TzRQwo6nvqRFCAsBnQUupWbNQ9PsLSY/mcDtJGFN/X2WS+m3KvCXhxM0vo0sqpcMWtGKgsm1FUBw7QtTTnYk8QRKYW7jvSmMH4n7SK7ZYt4CB5OAp1L6CPfcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=liGK6Cfe7R3hLz9yjT29KaP2fem8h5ZkQP1LS4op+YU=;
 b=eSGmJWApkJF//4cniE5tN/aeycLkncaCJIazs5KDSycsaWvshxgbmTh+Yyn7S48iqZ+IGL83Ue3VnMuoqZvvZ4Hbuz8CzQNlmKDUNS3ka3kxE/rFN67Z/cMsTxoTxwTcxE2rADIzUqr4PZRCu2z+OxhW4+WQTkkPolqW0NO1BsmjQs4ejQU9+fbkdC3P/S1IEvCrHzuUmOvMgwxjd8lJAq8RtOjdCBXNnQMIElXFxPs8kReQcr+suVMHNSGDeQtznVLR/Iu+RTIs/CP67RvVokqf4qJkMkERIjiBgt9iUEBybDz5w8UauWJgXmSeWkZDxkskbxhmaJM9BflY78Mrgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=liGK6Cfe7R3hLz9yjT29KaP2fem8h5ZkQP1LS4op+YU=;
 b=IQMI+Nzxl1C/W+u0fKk44q7X0GmWrZKNX6sILDx2Hl8FJIfBbj/uqIb2+J4zu/AQJ7M68L604dBNdHHMKM3TaYUPU4pIaXjRcYapRd6Pdfr1NDMsxIK7ZoswfkZyYyAlSarWMYvyMCMEwh4uL4c2+mt8L7+TrrSaWFuvBdIZDNw=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CY8PR10MB7124.namprd10.prod.outlook.com (2603:10b6:930:75::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Sat, 28 Jan
 2023 04:10:44 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.022; Sat, 28 Jan 2023
 04:10:44 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 6.1 fix build id for arm64 5/5] sh: define RUNTIME_DISCARD_EXIT
Date:   Fri, 27 Jan 2023 21:10:22 -0700
Message-Id: <ffaafd3083a1738007a3043b698ec5ac6d8d83d6.1674876902.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674876902.git.tom.saeger@oracle.com>
References: <cover.1674876902.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:806:20::14) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CY8PR10MB7124:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a4ff290-17e4-468c-6661-08db00e5a063
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J4IJThHhD3NXQBL+Xp7Cat4ur26Ad61jOwqPU97svN16zFATStxOseejqDFgfED7B2N1+d0URkGFICOxJZGb+IOKcL9q1C/91gfojL2PkhXZ5XeAgUFSWv7vCvGG4JcI1AMpOYRiuvWEbasAX5NsNTOdcT3YJ7jCvjysS5xbFdrFagu8gDF0bnJLlHG/8Lb97Ik8CYBgQp0gu7kEv7+8Hcw8SVYEbvgaIi2nNY5I3QhhmujEy8QcnPsLwi1tNKwN04+K+4tyk/pRhGFyJoOw/c43Dv9y/z4lrwIo9ds1vv9uV7zmCBbCCTTQERZCNxMKOJB58T1w+dB37TCEj1zXmfW99XCeTO+rUjaygVi0BTeAiv8hafPqqhtkgUkNBB/8ETXGme0AAenCKuP6X0odcznV/TuFAzvq0vD1cRJPLSS5gr9Gh7x1qjg7JwoWFw08YO17R8H02HlM3KmNLVtRusUWRzAfe4W6ndMC8/rtrk31Xv3mPpWogt4GXp0AQj9DVsHPvFF9vJrdFT3F/tOqnPQQIidUflwLlt98+9SQ4zsJCPhIdm+oled8BmDgaaKrkrnKMsO7ZMCwmX8ai1nHuA00YFqDxx/5TqUPeGJddtzGl8SYuGa+kYLTwqp4/fT7nn/GYdVpzqCquzQi+OJI6oANzr30kQrig3lJNPR3SWDMsEGFH50gLegf5cBK0ett4ugjiy7VXBvrS5ssKTnv/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199018)(6666004)(186003)(8936002)(6512007)(6506007)(7416002)(54906003)(5660300002)(2906002)(36756003)(44832011)(86362001)(966005)(6486002)(478600001)(316002)(6916009)(8676002)(66556008)(66946007)(4326008)(66476007)(66899018)(41300700001)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LScoh7VaUbMhQdP6wscZfHLlqb3k3ejV8LZ2LQL0J34yj9kjtVLlcf0JJfeF?=
 =?us-ascii?Q?OCMAIP2YedDfuKGhJAJImiWshHNYAfX/zkFxLoMsXzkwebeglDv+Kj99OSpw?=
 =?us-ascii?Q?mEdVzpzzOLBkhXeH/ptodwedvOqZaCmIKly3PF3vfrEeLgGQuDww44MenaT2?=
 =?us-ascii?Q?IUzdA49/6ce4pL+OciXmVkFVkfrpqWH09kKe+5+DAxfxvmOJe8jNUkh8RtI+?=
 =?us-ascii?Q?8zOd2Pu/w5uCmGHQTjFqnLMfp4Ex9/s8KjpeKhQCLIW7fhcdSOcZRsHJ8uTK?=
 =?us-ascii?Q?8dqOPGbcs4RS5q3v8pUEbQtw1xco5Lqomz/X4wTQB/CiWHUAtd5c+geywaY2?=
 =?us-ascii?Q?0MerWXXpegrHp3A6yIPStSGfOVxZDQn+QzAUzhLxAGHIjask5tBlwjonLVmf?=
 =?us-ascii?Q?y81sOA0fy7e8nJ+DU/TTHaIJIv+hwXF8WtMYgSJuN6JOjSrlWBrKjWjnxNZP?=
 =?us-ascii?Q?wu5E1tDwYFHkTucP+wFVFph3FvIRjCTAaSgnJ5sXeaGXvB/CxbFvjKSJYPpu?=
 =?us-ascii?Q?8iH1rWvucwsA4M6jnqv1T8580iFL9EqRx23mB0kSPd03BZ/0baXalbHR0PXn?=
 =?us-ascii?Q?HXQvFJ/oMc4/8ljv0r+kXhHk/GPeJhaLClFlMpFVK8Fq2NlrH3J4M09wnCR/?=
 =?us-ascii?Q?jUSfegSbdRbvNi0DtwE3HXgdFUyE0vrD+kz7cFFSxCWFtbdk/VqPUBDrqljY?=
 =?us-ascii?Q?t+h+wQoyfJnwAoHT2BNq1pRJ8TErdXhla6y/7E3/fY+0P34RoFAmFTJwzlvA?=
 =?us-ascii?Q?JPVSVIUHuwXpgijsBb6L7mSMwiTnItUVz00HJWs0xOW7YV7W7EIrO6zIckpI?=
 =?us-ascii?Q?LvUTgUjpEKCcUE1HsJ5iyOKiczTwXInO9J/d3KyLDEQjem9SuaIto3ZznuiB?=
 =?us-ascii?Q?t5uIeEqT4W2skpaxdLc6ibXfgJ1QRBDYp5xHoqn8ddUYNgl0FE2gtvJlxZMd?=
 =?us-ascii?Q?HGMmgym2IQbCj0f7qXDbXQ5GMszKeJrFil0gJUiIZqpqsfhoUqjenTNA1CgH?=
 =?us-ascii?Q?x3z3kDRpBqPs4CJQ3b8qkghizvntR7idxyMlUcdLwZ6O/8+KhYj7MpJXw4xd?=
 =?us-ascii?Q?R3f/m5+dycKMM2S85f4JH1kH67WYJXTP9zJmwl7AaxXRo4c/5uEtTEzRXOnZ?=
 =?us-ascii?Q?gGsfbdJWtKeok/2N6n3pu81qoheXVQI3Zk8nVOQX4zs6ufgHygQo9Egu5l5K?=
 =?us-ascii?Q?I2GQKPBISMyEPbpB3kpgL88Iz+n/BJ7xcad9+vP0vTaTpLeq+HMdZ/q9KEsN?=
 =?us-ascii?Q?zUvptFNpw3n5pnBBuYmHTXCdCoXIDuD9OvT2e0/KPw7lJcT/0xdzD2uFGL/2?=
 =?us-ascii?Q?hhtqT81U7oATm2KzocOf8eL/AW9+qIf49IpOt0Lyn/MkXTWT+tP6FhOF4BCy?=
 =?us-ascii?Q?KqZhI5gUiMOD2uN4w0aTVRUHO/oApHHENHaHMiYpTt39gx2ZCSuepkl3ijbv?=
 =?us-ascii?Q?tzJYvxUMhP9aoHS4SoMljW8vol4r9/tPgpHCf1gs+IM+skjKubjhFa6MoZzs?=
 =?us-ascii?Q?0BJtxPlGJWzZypbrV5+P01msJGY+n5MLqsmZm6kZZeo/K1BpApK22YAWDaeG?=
 =?us-ascii?Q?9qQXpEM4k+/HYqOSPUzlq1+YUp/XFIvzie5e+0lhIGnpnwkZGsSBIzUuPKVx?=
 =?us-ascii?Q?0LRLSYBHvuAzIm5dcmAVc0M=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?1xsMPWja1iK6unUB/WP254kHvkJaZUcmIgT5vB92nf7MhG78w5O6bH/nhzMH?=
 =?us-ascii?Q?fM1gnKdoicspHHmSTNEr8krvLqRvIU7S7us4x6dly5xyyVq9KAsPgolNO96N?=
 =?us-ascii?Q?4EVchQPcSeYyYd65m+aYOLW8i8fbvepsos8KlpMq3EFPnGfg3+lm/akLmdTp?=
 =?us-ascii?Q?Ex9/n88LCqztHCDqoEBFcw61Q8qWmTw1O7XX77OB8Um/9vM92ixCzLzcmP5L?=
 =?us-ascii?Q?gT/CzJNfzkyEwBCswqv+scIMPmSlr7KP0usp2hxd2E3saG2VeqNhDXSt6rxC?=
 =?us-ascii?Q?hTCid/Iforp3oG0mlRsOcOxDQI0cuXCGMplbhfDj0v3SOr9+qD27PHDFW+X4?=
 =?us-ascii?Q?yola2VzlDKhJgoOimWQAcqcadAOHDPn7lPHVGlO5F3n8wkk083MSVDZVY2hE?=
 =?us-ascii?Q?8ODFGPK59hB2/BaRO2Bt13gw0KYmfBtFAcH23azPltwqNiBIbz4M13WfC29+?=
 =?us-ascii?Q?8DmUXBE9MmNwl2GXurdx+NfycU6JyghLUW/CDORGkFH6T+aX7ir8AQw1IsG0?=
 =?us-ascii?Q?P7Q7mhi8XarM6VMo1FjimLR9SqKTml5Xyv78TvxcdMFx3gDIuSpNlMQGMrmS?=
 =?us-ascii?Q?tW3Uo/EyYP6g3iPtfWVBiLKVPNiT2wekV+JaajibwmaMPS6sUtELUcMgXfkZ?=
 =?us-ascii?Q?n0jQUJ1P/AJwYrZ+Cge2/0N5SPqXGE16yaMvohvuxUOPR7SYOcOb89BT/tjr?=
 =?us-ascii?Q?+D10T5AZXZUNGPjRLtZCQiCSl80QrmZeFFkK23UBGBR4Aj1BvAX2flpYupIf?=
 =?us-ascii?Q?eVSJvDpF1XELvZ9AuUfU8+wmDebUJrFtJI8CUamCGcFbgOtMuJRfZ25LVMQK?=
 =?us-ascii?Q?nq7219AnpcRQ1Ifj8yGXkE9wnfZxW5AV5CU5HjxOtebKswEIaardQtWaToh/?=
 =?us-ascii?Q?iweP1WvL1rZlk51ZcA7pX9+Oez/wniBmX51CGrEKerW1SyxkEBEFxrhiivZe?=
 =?us-ascii?Q?5mtooiyFK51JUIsI6dJSbZeoEuXvsX+B9KynaqvDfosO26Rz6IHWtW4GBR06?=
 =?us-ascii?Q?SFtZmRsI/7wt4QTSxZKBZpo7PKDZg/wG4I+gktepVyl9/BfnXMj1diRxIeUY?=
 =?us-ascii?Q?rPMZw3f3VcE2KX8n3imPE2Ahehz8XA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a4ff290-17e4-468c-6661-08db00e5a063
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 04:10:44.3155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nzo7yqXNVK6Y8INm8o9U48gfQ6bQFQcaK43TMFNa6Q2yZ8dB5162zzqQEuUTor+KT/N0ykpTBmkh4SIEPXXhBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7124
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-28_01,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301280039
X-Proofpoint-GUID: HQwOE0q3YeA2I65LaR6pD4HXMpuzmgnI
X-Proofpoint-ORIG-GUID: HQwOE0q3YeA2I65LaR6pD4HXMpuzmgnI
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Link: https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
Link: https://lore.kernel.org/all/20230123194218.47ssfzhrpnv3xfez@oracle.com/
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/sh/kernel/vmlinux.lds.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index 3161b9ccd2a5..791c06b9a54a 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -4,6 +4,8 @@
  * Written by Niibe Yutaka and Paul Mundt
  */
 OUTPUT_ARCH(sh)
+#define RUNTIME_DISCARD_EXIT
+
 #include <asm/thread_info.h>
 #include <asm/cache.h>
 #include <asm/vmlinux.lds.h>
-- 
2.39.1

