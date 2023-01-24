Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF86067A4B5
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 22:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbjAXVPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 16:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234779AbjAXVPS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 16:15:18 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3061D4A1D6;
        Tue, 24 Jan 2023 13:15:13 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30OKtQv7022131;
        Tue, 24 Jan 2023 21:14:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=/aTAwXo6n7HzhGN5ZS55fdG3GL/N1fNd+zuXprNzf1g=;
 b=WrH7ZYhiCgkUf95wk0fYqpMfHbeZxexv9lJEPDezbqa0tV/Z8eVZohHBzo4d/St1lTBo
 3oT8vqQw0ol3T7gTz9RFhA52uRZTyizSwGe8Rk6XwQ3LmiHx8VX/j6R9+JY+/q6DGWk/
 /265MR23mR1rvHKGmW4zdRsoPZVDOij4JDJ/3uY6M1rixCEGK52UkAi3/mFuSZ5LRr9z
 /7IrWK1ewGTpzR2jX7l9Q+W23+cAiF5VSLVPTRK2cghNh/q4x6qUQa/7bGalF4F0QE8G
 90f0z5lRC+C20yAkrtVm8jENo8sVhkN8Bs62la/lU7odAkmh3u5o8FSOPzPyHJ652Fil XQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87xa6f5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 21:14:43 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30OKjnK2021312;
        Tue, 24 Jan 2023 21:14:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g5hdfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 21:14:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Or7yHi87EFGq/VoeWl/qOI7qj3e9ran29jG3HrOvaRijDbnhNgA8rbIIf8MUZaO4T8Sy9X8XB1lbGXak1ggL0BXaYEUWLONdPtPCJpNKGqo+nPkxWbdGPAZkCQ9ZJHaNKx/3AVDczFk1rl/T1ZA7VjpkLGNdfNVvO0evYoBIpAVTM5ldPDR6VZxPak2Lbkj9Cv02Rw0YU6fHaW36jvCArAKEn7kmm5q+9AhZhhj66sc57ChqMWztdzhV2KYPQxbc019Sr5dzx8DNkFNrVCkwlMrLcpcmJEjx3ccvpKVRXHpzOQuQQrcNvW0mSBMWAlqwv3E0Wv98phjPqzK8PK2M9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/aTAwXo6n7HzhGN5ZS55fdG3GL/N1fNd+zuXprNzf1g=;
 b=aP9grAZDILprCJBQRDVPcJD9FhEkajdLSzdT9T3kM4S355XPgIIpCDne2qQHA9XRmgehwD6G5w5YLEogCgKXNKJV4I3W82bHryeMxG4sZXfLy6fw9A09s1L2vAgLV+Mn3NSWmRo3GMEXIFhJ9QWQRyHRaVhdpKek4PSV3r1E6jdiVSbSxp7NOHh9o0aSsoqkC5ePU4PY8H6pEI8jfbIAYlmugAnW6F+ILjxP9qwUjgK3n531yoU7NJcqCIYScTGuxpSN+6YHo0ByJan6wYEzcysBp2XdT80Ay2lUaCvMK/v30YqDXRludgzgw4Own3o1kS4nWfe1w+QFYdUyC2OvVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/aTAwXo6n7HzhGN5ZS55fdG3GL/N1fNd+zuXprNzf1g=;
 b=m9AAlMhR9oHmqnzRepnrOssedWUny+IrZwUm8Z16yLCYXBoZHGuFtjg99dzqxrLhQBIvAPuMIoXOVUz68JaFFRic7sGz+Ldjz2I18qjZC97CTHooZYU9K67zL/+1q6NqMCuzyrONz24rFhRvXppdI1ZOpyz5qDiYPgUnKQemprA=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CH3PR10MB6836.namprd10.prod.outlook.com (2603:10b6:610:14f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17; Tue, 24 Jan
 2023 21:14:40 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.014; Tue, 24 Jan 2023
 21:14:40 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 5.4 fix build id for arm64 3/6] powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
Date:   Tue, 24 Jan 2023 14:14:20 -0700
Message-Id: <c6119d17248352e62a5c76106a3d3db63bf0b065.1674588616.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674588616.git.tom.saeger@oracle.com>
References: <cover.1674588616.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0109.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::11) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CH3PR10MB6836:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e2923c9-e943-48ac-9225-08dafe50016c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MKOQMCAyqVPyl98xqpWYsCPaCl3Ku+aNjpf802BQYwfzIydFt3uwJH9kuBu1zqSsTpunfagGkDXXUu8MOXQUHpqrYXYQA3jz/ZGG6LJyHwnihVV8k1CjuF4DnvBFVm0cBL+oqSx/aOmBSoU0YanP3dtGYYNq/82Nb1wc2J+PIw5Ok5/lCwin9/B9qE4pFteuT+WNWYb5rTOtL1Yyr0IiYVyXYxLL6TdCnLJvGGP2HUXIHwf/nqUgX37pxumd60ABJkJK+C7nayD+nRRbSS/WEv7bDNZTv6G08kb5UJD3L+fky0x5R9KJDRLhlstdDnBmsRTSXwFnTfTrJsXkHrjeN1ESJ2IzSKXc3dD9sttPrwEGxXwQZ1dfY/tP/IcxiUL2bmy3Nkg5eIuhgdoBpRhwIeDDwEUx+Zmv42OV+eA0fEopL//IN0YbMP5+obBC7dS75cPbmz00uyTHKNolWwpeEFoTNlpD2ffBcisVM9ARkZ4Yc2R3O2D0V7rvft5yTNCZeAkBmP4ajgI9D+CArLKZsZPd1kTK9lKE1z+/C+T85qNnYYN119MArkSUd7ccAtRhKyH0Px6o+rMvCn9CmesV/pGWRmdKVKLdWuAB+KZ/WwNpfBm9qmMbo9nFLju0gylVrs+yfJsMleA6CkHtPKPqa5hZj/MV+Rfdfvjam+iZu+bbNagX0sVGSEsCTRCNKU7IbMJ0lJjYnjXh5YPmGYM2Iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199018)(86362001)(36756003)(478600001)(6916009)(54906003)(316002)(2906002)(5660300002)(6666004)(6486002)(7416002)(66556008)(66946007)(4326008)(8676002)(66476007)(41300700001)(8936002)(966005)(44832011)(6506007)(38100700002)(186003)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cj8rE0RL8yivAcSPdH4PDk690JNtg4frRbQ8IW5e9e+rUmO3zmVs0Ny+B7Dk?=
 =?us-ascii?Q?8jheKfkUPs71ujoGfAe+VuUy4dILE7S0DYi5fkO/CYfRZ2lE+mnflhagwhCR?=
 =?us-ascii?Q?7dRHDk+RWyuqtyvBErA5azE6F0oyP4LwPHqrtujRLwxBmk3jGam+mxIsK1Ua?=
 =?us-ascii?Q?m+CNVih44OdeRXeigrGZIhyHuH73Ay7v/oloNk8dqMvSreD+TV1vBhUUW0mK?=
 =?us-ascii?Q?eUOQdSG82MCQxjEZI4mya6btYdB05qghD9+OdbHDUWGCdkWBspgN+foHmcx4?=
 =?us-ascii?Q?HZKyvTwRsAppRceNb9G8pxRMLbGiH3KJ2xfs3c2/TAx+0ZCDs48yZVsc85Tu?=
 =?us-ascii?Q?jr8SJlNNuSpDBr4Rw040FjYjRdFCm5/hyEYjZ4eBgvR9jgTB+U6whaTce7iG?=
 =?us-ascii?Q?I9KpYhQT4i9GY/xh7FOpPk/nPj2taDeQr2u8yHPViO0LG8Zp9CL8FSUibXbV?=
 =?us-ascii?Q?HsWNA8644iQ64UMFe2MMx8AwYFGuEJyBmcIvD/lqw259vW9Y7MBXipll6kc/?=
 =?us-ascii?Q?XcT9tgjTuCOGzDu9bTKRGr6/UWuauQ67uVwckbNl3Z/6MHyC/e98yq5Y8a6m?=
 =?us-ascii?Q?DrypIk2oPDlbw8QkWMUHnoDpbiFSXPhbPZL2QS1m4k58NR7AcGTClMUtSQdg?=
 =?us-ascii?Q?BQteJlQVhVhTUi29fTa1JmWnkmqt9Z6+kYEwERHr6TMvtxWngrF72fEcOEoR?=
 =?us-ascii?Q?MY5xESUvHr4Rt9QsabjZ9FRWnb0VXsNrh0cOyh/8ixZFs7dEunMDXBqZ3o/T?=
 =?us-ascii?Q?TncBLNP274uMH6D1BvS38+ScnQnm8cffMByQMlrtISF+PsYJJzlgtKnATbR/?=
 =?us-ascii?Q?CfPHr2+WAzs27nTJ7hVQQ4qOZ8x8NLNr9lKw6Jg//AN2aZ9UNUKjxXKb51id?=
 =?us-ascii?Q?SAOSDBarcGmDvDzmDgp1LLXyqU08iumcpTLzZIEXxALHO9n48xrlQZLM8396?=
 =?us-ascii?Q?VGMQilx4CkIk4IMOTuhZT0CcXN9Kdvw6E5ceBLWcFO2TJBkagL6V5LcTMdyg?=
 =?us-ascii?Q?f0KCR3LfDqWRFCqFN+KahU2YGMxDfMsxL8TS4rakpcS6EVbJErY8YIeq439L?=
 =?us-ascii?Q?KXCo/W1Zw/yHphRvEeZv/MY/H+q4sWXdWx7jVsW4TOXm46yZnOdmGLUEQso8?=
 =?us-ascii?Q?bwKFVuQArw4Bqg2k8BEolqRzQ9Jb5RaOfCzLC75Ur0lE188rtBFcDqTyuEmh?=
 =?us-ascii?Q?Lsu0sYclMjmhz43Dey/2te6uNdb0Y6cTM2hYx+3tMOCCZmyS+jNN0v8+zT8b?=
 =?us-ascii?Q?Iy485KapYZRyHkyKYMPemboLCfnYPJz5zm0X4j+uN2cO6EoR7+zOVbbylASQ?=
 =?us-ascii?Q?h0YpHtix0Ex+jcomiQ4VHTdigwOm6OdyKWZxCdHMxsNEEJFByG4OV0TrDrY3?=
 =?us-ascii?Q?jTeV6zucUwZJ52nG8OLFMXC9KuMFsTEu9CObo2/uVCVxvAIKbHXdawZOYGPO?=
 =?us-ascii?Q?69asW4Tp4YPv5Lc+DJ+awfhUOM4Y4l8yXnMEqHVwvxZSozlv9XJQWzAnRV03?=
 =?us-ascii?Q?5A1B1rsBCAgrAGisT1A62EqszpJPRwF4zJIVgCU0+O5Y/kXbI4oxie662bAb?=
 =?us-ascii?Q?BUGBbR0xbSCU66AXF/98aqab31NDFaMjaAgok+2dyenZiupt7DGisgzKY9nL?=
 =?us-ascii?Q?6IFfcU9HVvsOukyOy98zzKU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?pAONDU5Iu1Y6FPlNoqWoOj//ia67UWloQ6itiDArKqq4qHDSTKt3M5CAWcYo?=
 =?us-ascii?Q?3J3Pes8siocikLRw6FbCNChJJZKuN98UghArZBQt1/5b7Gj42grD0d6lS6Ml?=
 =?us-ascii?Q?Hg67hj/EM4T8VPSOljH0aMIiq0m1/IRtcCOucYTtEOMYJjytXPb4MoYA2CWA?=
 =?us-ascii?Q?FeLbNpoeYSaB8JrIhsdLn7iEBa/1bUsZ4wGdPP8BdUvnyVGaiCpximgHKSvW?=
 =?us-ascii?Q?bgJUc014a2oZ8Eqjrxb2GjlQ+5FiViW/sTR0TNwQni298wnoSQmFrKMzUPuQ?=
 =?us-ascii?Q?bLbZsUfsMqwFaBV0/sitblFRZmKb9vkLzLiD5FJJRkZskRUI+31tDR6vk/cZ?=
 =?us-ascii?Q?SaHz1564ftRK9OQxKHps4cqSFudr+dswj45Zji42e0w2odoB/eTWqpsBchPa?=
 =?us-ascii?Q?tttdS+29A69PPDsoQB5nuiOz+Ed+CO/n9VreKFhqGPhkjKfNv9gvJrgi+BVW?=
 =?us-ascii?Q?oOI8KLZQO0mcn3G1jrgCopOabhOFJRapRHlruH3TDaMSPP4QpHuXHZ5vhHQL?=
 =?us-ascii?Q?/o+Upuo2l/DhzQJvkzM2Qj+h4Ipr+rDel5NtqzCzTjI/aSpoxsx1hy1ueFP1?=
 =?us-ascii?Q?LS9btqiRKO1B4K+DPhXWil0m3ClA605a0pemAraPvMWrkOCuAggCILUrKOSk?=
 =?us-ascii?Q?wQHQFGK7Bk05nDzMD5OcD/B4z8XzwV44MOsp8DU/CJituWE2zR+C1yNgycsf?=
 =?us-ascii?Q?kzq+kUWuRGrVXtAxyPuTo1f59lghPslupAGmL2Ljv1NRasZcRd6dCJ2l1s12?=
 =?us-ascii?Q?8VB1dRmAxCcMTy1b7UzvixxwCjPIKIqwKSWhhGK6GOAGXJ0riejPmrbEakr1?=
 =?us-ascii?Q?2dKLis2sGjkv4+2rPSdYbsMhsKPt7uFadjJPJ8DHuqRuOGl/2cNy5EpahIXa?=
 =?us-ascii?Q?r0Tga4lxaeJoep3EFQpJTfreupxxaOKu8HrRoMXuOr++vEdOEPS1ff9pWUr2?=
 =?us-ascii?Q?hyv7SrncEAnJlEtw+WWwlo913waLDto16mNiARFdqggq5YXeGmZ4Y3oZfPI4?=
 =?us-ascii?Q?AzOk/ZVAqbEUaJi/AYk6FITw6w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e2923c9-e943-48ac-9225-08dafe50016c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 21:14:40.2796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IcmSC4L0T6UUISW0YkjAZWG48m5pd8givE/kti0TuLz6AYMRm+CYROZVg4tKs+1p9jv2mhtbYMVG3oQqFvjPww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6836
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-24_15,2023-01-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240196
X-Proofpoint-GUID: rVdXXOuv84kIDJ9pZpqyMjU11HYRpCCe
X-Proofpoint-ORIG-GUID: rVdXXOuv84kIDJ9pZpqyMjU11HYRpCCe
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

