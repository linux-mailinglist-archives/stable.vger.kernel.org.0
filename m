Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6367667F496
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 05:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbjA1ELg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 23:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232878AbjA1ELP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 23:11:15 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7237BE5E;
        Fri, 27 Jan 2023 20:11:13 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30S3COJp018126;
        Sat, 28 Jan 2023 04:10:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=PMJHbJUV9TsNLR1TxLp2Qc8kSGvFdolfal06baWnJ9M=;
 b=BwOwmEQ3vPq7H2k5L+ldVVNlGL8GDQX81Uc0xuSJBrckNxpIHXDuE5xZzligGjq2Z0zJ
 EuJOmduWTYpP3QGgrwO8et4sUXnl3wCVlljLxBVAleAU635j58AvP0qTceHHAcvJpHKM
 6qG6Ppa3MsY6zZo5iKp/PWPL/E/nRS52hMQkw0bHYeusjUBvCQkqz+EuH3M/L3rj8d/J
 XKb8MGE1igyaLdNIWmPSIQwLSWXTZGIFHP0TmmWGVMiTjs/MJ4fIia4vxvQZhJbCViw2
 GUTZkv0y5NsrtHgrIZV1jLGWIYExTmbc1yUmhvr/DTf5CsB3hZmjeyg03eWhONp2tN14 vQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncuka8157-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Jan 2023 04:10:44 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30S1XAF1024972;
        Sat, 28 Jan 2023 04:10:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct52b2rm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Jan 2023 04:10:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkQixqObNmHl+AUJXfMydjdn8jHK69SKjyj+19mo4b3PoFsUis+DB9mjYkHKLDO1R6cjJngXDgJ2orD0lSSxvX63KwK6a3jhN+Zt92WaGOJ8mLQVNJ8uy9qhWTinBxJjCGaP/2eKR1SoEr6EE79EzUzEDTLPseJw+JLURTl48I2hb0lzF2D1nqtJmovo4AwMQkit7+PaaHnF+rxXnBiG67w9BVJzyWqeZymh3S85JVAF7CEVD0fSUo9lVH0tpgyHbK5q1pdqNxMPfMFlCRidl9HHzN+BfxdlVrBwww9PHidZOZ06jx7g4hCeN3YVG+GUHxmQ0Tr1A/yLash+OO8PpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PMJHbJUV9TsNLR1TxLp2Qc8kSGvFdolfal06baWnJ9M=;
 b=hOlBsstKXZYVAAqbvqXQsWx16lWE0pgh8cYPLGk5kv3Frg6+8wiVttgKKWP2ndQ1u9ams775Qko+GlhhqytkoM9AN+1YUDwKIyNu0aY1JJAIKvp61gAYRcHY8+Z5fFmCrafR4Sj7olBNMvERnDL1EuCpg7uN3AA2GvGY7KADlu06FxDcIRRVDvhbu3vPbOCar5BD6mxrkXNQEonD95hA+sVsvlp8+1HrI6r8h4THSRkmYdCk0jx7MIujHC956he/iR3F2NjB4Wxgx4dvrDQHlz6aiW7z2ir4BcMshs0QpQC1dPINQaoqoyqtufKZVcQ+gRGlJzEUAsGXviDii9T6fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMJHbJUV9TsNLR1TxLp2Qc8kSGvFdolfal06baWnJ9M=;
 b=X25hVZDq/Ya//r39ypNB8b0x3EYw3j6A9pqc5mte1C4oXDwqp5tQfw8mI8tQPJ+CkJtt5+nsbrSR/+tZRGbj4JMuWUkZvg3MFjZXobaNl9Nvmxh0BudT0RO/M9+1vD/ITrsGPe/Ah+242EY6jhX9aA7wA40x0kn/sGZSuRNIc+A=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CY8PR10MB7124.namprd10.prod.outlook.com (2603:10b6:930:75::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Sat, 28 Jan
 2023 04:10:41 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.022; Sat, 28 Jan 2023
 04:10:41 +0000
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
Subject: [PATCH 6.1 fix build id for arm64 4/5] s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36
Date:   Fri, 27 Jan 2023 21:10:21 -0700
Message-Id: <533aea4983992ceb623d012cde18410867f0878b.1674876902.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674876902.git.tom.saeger@oracle.com>
References: <cover.1674876902.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:806:20::16) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CY8PR10MB7124:EE_
X-MS-Office365-Filtering-Correlation-Id: 17f2c412-6643-46d5-2229-08db00e59e90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ni1Xzv2KKc6EKM4JnW3stx9GTWavoGjKSUI3iKg6T7AMdQ7CqKXibTGt57qhHYEm1NKjo2KsLd+8P21vPvp018Y/MUXshcaQZOstvT/IociWCs+fWG/+tcPSeIkXCTuD1g/bjvfG0ohT43hfOs3aaHvorL7QRKrWYEmlu8vgRi4zmrHeRaE/f/QdiyIC455Uthm4dFjbSD2fDsxV2Hy2S9dy0MVnpNyDW8yLxsTgfNN2JYkUOrVegTPeTaKsG4QwEawng/4rLXkVSfTNvzu42ODHSyg5BKD5I4uGvk2ZZEJuDp7pXgK/9wLKgL1DzavwcRaVwBhUI5CHwSz5vRatsK8s9D1hN9vZFGLvB6K/V1z5bRo0qoFAG10NkWnNHPfxpcxrM6hvZRQv4ORU0pO59o8dF+J1SMjW+06PAQs/3Eoxxdpfrvg0umicNwpuPrPdDRyuqQbxHKNXP5rN4Ntosa/SbPkpBivdYghKvh/itM5gl/45ejuek683c012Q3yJaaHICwiS3KgXrF093/1sBEg4SLBdWCVWL/BQvHg9SXRAbEBaUUe9em5aa0XnaWl37JmJjm41qcpLTleighqcjVacZoY8WEr6TubyAuiSLrqIjaNOgTuj4gUjwo93xahURqLncuAEJaO+vRi1qoPkGP1QtYD8R031rmmDSrzeoEl3sXMTmUNrqv4RqEfHKeVx7QY9L4Ch6DyzZ8biJl5HGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199018)(6666004)(186003)(8936002)(6512007)(6506007)(7416002)(54906003)(5660300002)(2906002)(36756003)(44832011)(86362001)(966005)(6486002)(478600001)(316002)(6916009)(8676002)(66556008)(66946007)(4326008)(66476007)(66899018)(41300700001)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pRvPllddHArOOgl0adt0q/X/hN/OLsG0wc/Pr/Pm+x9x1mEZu7mVJZWcR9Yy?=
 =?us-ascii?Q?cevsoK83BvvUcz7Tq0RhOpMZUab26s4MaMUwlJLAfhqZBUaKJeVagtHubqtA?=
 =?us-ascii?Q?prtL6qtoxvv4jS9fmM9OB+NkWz9/OEVY0lD0Y2RxAsqtxFZye7lW0MhlTvrW?=
 =?us-ascii?Q?1yktJa7OQnTfTIHwmQq/LIjRBF4vrS8/3axwEMRAsYh7nUgqWojt3S3DYWy5?=
 =?us-ascii?Q?Suu6ICJ+M9f66LNAQTKDZHsBDhPsi5R00zEoTvcE/W0pdFB8DJdXXexrGF5u?=
 =?us-ascii?Q?1QtS/ARC7omER/2lQgQSURSd7AzD7Knjf9LYf/TNw/nGqXnAKbpwF5gfVZoc?=
 =?us-ascii?Q?h4Bb+GdKnf7WG8X0iPyB9v8BGGz97MgjVYaBFKi8urvwgIGwbeaJAHM23MZe?=
 =?us-ascii?Q?gWbaRukK1TWA18kgu4SG7+CCmFezXcobXRaLR6Y9g3T9UwEKpHmVztuTdOzs?=
 =?us-ascii?Q?rgLJDYE5ur12SJX4UvGvX2JOl2F3YMuqNzq9+sx/zTxOUM+XIe814Q7lY5Fo?=
 =?us-ascii?Q?aFi+IXpOGoD3epfYntHozVh0wH+EMnSwYnPz8W0yS2mh8az0KPrg3aFFArYL?=
 =?us-ascii?Q?oaYlTv65Rnk964RMLTDZN26VhZmNWjJdywGHwVEiJsQP2PUFbpzUxK9kJFHZ?=
 =?us-ascii?Q?wQ+Cv300lN8g+NenKduduvuSBL9OGGmNtfqwNZ+hkllZxflm8Kou3ApxFjRe?=
 =?us-ascii?Q?GEX5LVkeo3fWymVndNfqQHVeXRv/iIWYeqAVD81hllxQrLM8APeZ5RljQ+PN?=
 =?us-ascii?Q?huZ2ySxdUvDQk5c8Cz8lGGzQiQAooO5PWDJPXr34NaFEMoXCcX1Jo4r5UeYz?=
 =?us-ascii?Q?x94WvVsXpJ6gG0UiBC2LVK3/NrMsXZfZk+udBsHQh/XzODuhdWQql5LC35IL?=
 =?us-ascii?Q?2ODV1BZtwddwI9kdAm8dKXq2mby5kQLzczPH3K+l0ak/Fn6HS9gNUE3CT2pR?=
 =?us-ascii?Q?IemJhrM9VFE8e2LFdGZOlGBzfQPNW4lmt9wdIGDQlsRgrpTyLbAgjaXV/Cv9?=
 =?us-ascii?Q?JvCfZOHDv88XWicPxoydRFa4xHPv/N7x0XUNpEozYJdK3cZlOC0/qlA4aecx?=
 =?us-ascii?Q?O2Licc3/6Welvb+Qi+c49+/a48Z6+XwYHEWD5gFqcOWudCOrN+9JxBuE2atc?=
 =?us-ascii?Q?ZO2hU4855JlTkfw5mMWp9cBOSWtY1oCv5SWojHq+sU/CnlJNgo0ot1YNqNtM?=
 =?us-ascii?Q?689tOTL1deP3rLLSS2tskrhGg/2Cg5kULuEZM1oTvBtyjSWQXflBVTT/l8Wk?=
 =?us-ascii?Q?Rf2dVMprp9Dhg9z0Jjb1Rzk3S8JwgXPguEd3lQYMDwc6nAak/vmq1001qDmS?=
 =?us-ascii?Q?Abnjw2H1+dUSv+l+XkjyB/pIKy+o1mRfvgYlE8U+wW5VvV4sy16cV3oZS5NY?=
 =?us-ascii?Q?IRP7dtfr+Mdf9XzK/h302gRgaRLSvZqEKGQU29W0PvvVpHTzSfoXW8SYhdJ9?=
 =?us-ascii?Q?al89pxTr0Gj/S7ekSybYz6aPOLrWSuZYe6z/0neeAGLUqujEsm7EyJyBECqa?=
 =?us-ascii?Q?Ej859lm93AWs0oKdDDInV+0DteC4bO5dyNI8sqPhTDLnpzz1ih05IBfKMEmh?=
 =?us-ascii?Q?cmg6VCajnzgel+KGoZzmNYgM5zxYaSmpuieb7mUgAVltKz6xQO0BG/IroiHp?=
 =?us-ascii?Q?0Vij8aGkTG97kYvA6MvMsKY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?6ls+sacQ8SL0PEfW9kjctYDdD5J6t/FoEBePLEu6s0jE8AF/DEkzjxWeU78+?=
 =?us-ascii?Q?FcvXHrBKGWZhuXwWorGtuD9U/YnD1socbB/5lnjZdel2E9DgvxC26hv8jVaB?=
 =?us-ascii?Q?T8jvV4k3LmTIlZTKuWWfwIqGTqo8hP4LDrGe/DLBjJuqYK6XuGC5Lrd8X4AQ?=
 =?us-ascii?Q?aTH9eQHeVonQDYj+keJiXR0LbX91o4+/iyPGo+DYIcd5eyueHPMhASIwSgcU?=
 =?us-ascii?Q?9AJUYNxfyUZBqYbrPX65FBR344aT+DcT3z9VMO9icfmO6V9l5umxzjVPl9uS?=
 =?us-ascii?Q?TfDUYWtaIcxh69c1Its8cLqpf0qmfr3pAlPJV6uIh0MFvyeA9EGBJ5jmj+Zw?=
 =?us-ascii?Q?bv4SOA5Z8bPJwYZuSM2/4ddOFKEJLuivCddxnj2LyBPttZ64DIR+njpR9xRl?=
 =?us-ascii?Q?6Hnwju6yxeBO6TIuCt5mSGCNY7fWYkMHdM5mDfM44TxIW6UH87d5NSWryDID?=
 =?us-ascii?Q?NEHO9+yBEhmk4tDs6P36YlPpFpQ3erxWr0PKV/FRCwo7DVSzshKdUSnMYS9o?=
 =?us-ascii?Q?S15Oz06iVad2ENZeF++Bp/N74M1F//0tLUpTKq4Hbav91qUcx64AgF2HFhKf?=
 =?us-ascii?Q?wUvPo1qXy7zvUZ9pvre7JD+bGEM4D7iqEoB9vRpJysahg9WShG0MHneVSMQV?=
 =?us-ascii?Q?BvX8rrtnkx2XDYMpmox0DrUgKPhApeDONVjb52yGeB7j7H+njUF7anH4qHC5?=
 =?us-ascii?Q?glg7lH/EmhNkeJ1s1d7B1rRQoWe6g7pQZh0Duui3aobOFweWPmn9EEHARBqW?=
 =?us-ascii?Q?zESeLCcG5FUVRzIcTYC884uayKfc6pDruhQBya6jdheTbOM4YTtPHA4s02Ic?=
 =?us-ascii?Q?1nXWAB2a3thuRpPkAJdzeQH8f0b2sGMY2biadwhNXeGvxgFxFcdwojre6hbF?=
 =?us-ascii?Q?3EtmrIOloyuM2io39rs0r50tvxH4rCATLLFQCrKVNthQm1IrkVCaX3W7G8La?=
 =?us-ascii?Q?+lGg08xepgoK9dkYJ057x1UIbKG/Sq60PSYqGpcCb72Vy+8mNfnvODgEh2Q6?=
 =?us-ascii?Q?HzOm9g8ny0F26PbyrUgFjiHfQptraJI2lut2TD4jLeAQMcXDTy6solpoqaxv?=
 =?us-ascii?Q?s2JYI8EDH0JhoRScyqzGSzF6Xo1iLw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17f2c412-6643-46d5-2229-08db00e59e90
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 04:10:41.2376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pRYAkYwQrlJdUDaG3BI5Nalqh8a7+Rtht8bV6vaR4Q7zGM51oZHLPFJv7RBjvXWrnQ3dhFehEBmSxzuemxySzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7124
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-28_01,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301280039
X-Proofpoint-GUID: qkjyVUIni74klMffuIRpR5CHLtEonpd2
X-Proofpoint-ORIG-GUID: qkjyVUIni74klMffuIRpR5CHLtEonpd2
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
index 5ea3830af0cc..6e101e6f499d 100644
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

