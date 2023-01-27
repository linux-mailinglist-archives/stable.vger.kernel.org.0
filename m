Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A08E67EFCD
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 21:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbjA0Uls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 15:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbjA0Ulq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 15:41:46 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6D27E078;
        Fri, 27 Jan 2023 12:41:17 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RESgXU010166;
        Fri, 27 Jan 2023 20:40:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=4fG2HcBY5c7gqrqLnizjFcjPbGKkhPZsaABLI4qibhM=;
 b=App72n6/3DgnBcarRJ4WE+GeFrVz5J/RMOtXKyFWGkB8+umtcfCAvw41RlvCZ4TueZ63
 hblV4pJgbucAN/0UTG8Xh7exj8aSkMQG+UJjld2D6pDzmqqvBVbC9xQ13hrCSau53EQI
 MuWMyWcfP6L3PTIM83A6Wy7LEYpnitp6n739RBmLuwtJCdy1ncy8Eu5reL7H/siF+VRe
 CklDqZv2M8epllW4Rq6m9jhP98u4ycPNk+q+66eLOykr+c059BHCl1pvFoWViycU3kPe
 7zdNRV+qF6Cd/Ysj/NBuHmkcQW1Ce7tE/XjN60nyeROWVGyoTEDIvQJ3swKZ41SKrHN2 JQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86fcnsd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:40:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30RK8jKN005033;
        Fri, 27 Jan 2023 20:40:26 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86ggjemc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:40:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kAIl+y3ph/52t9fCuNQWbgQbeA2XJ7J9h7kpywQgnHazusHKKkLDLozfcyfE3WtgfVsEpuDd7QlodLVpu4fAJMlOpjARsUUi0cEEZXevpGx+ayu++an+XOIRxMgY/+Wf+ZA6/fXkuhC9SgD5vZmR+EyxijJ0qcYloj/uMfB+vg23rb3BkrwZ4SX0QnF1M80tl4fTa/g8v/EcDEbH/EdMJx7OY6Tvr+o5UXKrMX4uPBdkAU1/IcQJnWXjuiEou/WvvJjUb0YY8rGxNKZfRGkZnai56xrgcIwBSYwurbgylqmmjWn/jHWd6TaiB1XMC+IakGeaaHogsNNXroFP9+1ZAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4fG2HcBY5c7gqrqLnizjFcjPbGKkhPZsaABLI4qibhM=;
 b=nnStUNu54VT9QncmELcDVtOdxz7TlME2Px7LL8BaJta+8+baet2mkfFOSUQexURStI3xVbiVrznzUu3Mo8YFrQgv/dRJUsZmUaTh4JMa8HKfLpkXldh3YELB/XGH5DafJdwsP7tVu7DZZQSg6T5ft1kOdmackHw3Yd3skg4Zq1de0cW+RsJ99m7eFV5F53VJjv6vf6kKeszTjd/asXgUMR2qMGuOhXc9Gu7Wmp3tW7d8OsppQg7z6OWzRj+S4zeNRiYxym5Rd5YQ06WxRuhG3d1Hm55RDP86ByETRPYGV0PWdQq4w4ccROsoGs8Ufz84w5HRN90yXkc274JjRGQ46w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fG2HcBY5c7gqrqLnizjFcjPbGKkhPZsaABLI4qibhM=;
 b=XGVnDoVhSWQhZTG6nJA392qd2ngvFY4VSIoUijN2uzc5dWx7N7g+uq3J/9/vuSFtn7FFLUsmqmrFCf350D99mFESijmnwSaYkpXptzjM3rlrS/pN1Qd8dqDXNq1GFhXU/GrOL+8FCIB1n1taUO+2Ghe8tzp2RkeZzgKXnA5fbaU=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CH0PR10MB5019.namprd10.prod.outlook.com (2603:10b6:610:c8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.13; Fri, 27 Jan
 2023 20:40:24 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 20:40:24 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
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
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 5.15 fix build id for arm64 2/5] powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
Date:   Fri, 27 Jan 2023 13:40:08 -0700
Message-Id: <53aa41078473a9e5475cb4607e5a8c890658dfd0.1674851705.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674851705.git.tom.saeger@oracle.com>
References: <cover.1674851705.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0151.namprd03.prod.outlook.com
 (2603:10b6:a03:338::6) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CH0PR10MB5019:EE_
X-MS-Office365-Filtering-Correlation-Id: af555a53-89d2-4906-a121-08db00a6b6ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GajgoM83I7I0l92woubvPvTLtfQpLC6JZWDVTXJxjgFieQk62VKY1ENFbqc8klvjlKAZjk/ypiSuunManPeFvjOJ4M8vH2uSprpWi6cemqicpq1bwKGoHtA3sZdiaPP0b7ZS/5uFckhmQcqDQ6AT0T1m3xjswJjHiBCfjCYwG6L5G9X8kpXtDqSK+ColRkX0iSfk1kQBD8SOHpZFHH+09eLSUWauVfmagsYllKjN6stGxRz6qgojDHh0RKIvh4z5EHPh072ghQwElpn6vE5M5JPBMwhOaI0f62uiM9KBc7tqNo34Pk+tIjLYZs+9cfPyOAWZnZfzis0FFvVGIsHpo6vtBnnXk+PRcsENO05GTUhLV1mgAGQ5ibkcMMMW0s9GLL3CAGuxmXmobaDI2C2TmPEu2aM9f8p/E8e0ekcPsSRH7IDrB34Ufyu2ayN/GM0VUQ3FR8TcJuEAzz14m3xPjPwBNPsXdQeY5Rk5HKEA/H2uriHth4jVaPClY04CG6nNf6GV9d0ZYsY5Ga3elKhYpCdgw39XoyWlwgpKhzSV+b7KrAHsuyiQGa4E6AlIw7k5m84xHZ1FTfjF4ivl3Zz7VWibQRszut4vUI/bBwsSR2zpKAtywkd9yXlYHoK53upVWAH1VfUVYVuevbhRXJWUDsNhnmc9oiuVdK6fq4Al0FVB+/oYH7uNgF2T1NHXFIC/hbVN/UQJCwQdCrq9Dbf0OQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(136003)(346002)(396003)(39860400002)(451199018)(44832011)(2906002)(7416002)(5660300002)(8936002)(38100700002)(41300700001)(86362001)(6666004)(966005)(6486002)(478600001)(36756003)(54906003)(316002)(66476007)(2616005)(66556008)(8676002)(4326008)(66946007)(6916009)(6506007)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?21l4bO9HfLvdtao4YROIjr5tsax3u93RL6/WRiv8jpr/8OAbVb2evEys3kvh?=
 =?us-ascii?Q?m02xukw5Kp+DMZT2V88cmLoRsGcPNjZYIcumf0Eqk3t8bHpjDKWoAjAf6eTw?=
 =?us-ascii?Q?ENWt73KnJ4hcGPG8Pq3H5v55G3f6x9u/dZcj/KQJMtL89xAdJHyjMTLB/Stl?=
 =?us-ascii?Q?xk6akJUjHjoEBkJzzdZm5ZsPd5WbkWvObM2TKWvsT/DNG2FQzd1lfMzWXC4O?=
 =?us-ascii?Q?Q6KWAQazi4gkzkcIwLWmxbaImQVvibNPRbQjOj9VAUyunN4ognhD5N/o7qyK?=
 =?us-ascii?Q?4UrM4zm14iy8eEWqmq56G5FradqLgr/a7G6qytGAud8wKX2Z9uwbmiQ9/op6?=
 =?us-ascii?Q?4hIMi+ANTTvfnXLPFLSbQVwS2HQL93ZGjVBCgx6PAAZQjWyhoyvQ4W4aEu8+?=
 =?us-ascii?Q?QgmSeRqSt2GO0GvqgSjNvyrLzaOE0Si5Tedj6JfMeaKGCgKnGJZks7NUy7su?=
 =?us-ascii?Q?P5xwa99MI/dYU0Uu7yDqAtj7rmDlVTrXuevJ+0qNjgNm22lM/t1gMTvrPpsb?=
 =?us-ascii?Q?ELb0BYUnHtRsNFtBvw9e97yZJBuTy0JjQpLcs+/lZ61CQfWE5ZZ6yDnz1HHu?=
 =?us-ascii?Q?PLHF70uhUf54FKBNwD3fLvBUuZz/GueKWPvgsDMms0zaKHJYGadsgSp81WNa?=
 =?us-ascii?Q?FBb+llqbKWW+5hdIioIAF10PI3GZZysYZZZLGLXo6dFBbFKFxJAsUXf47Qgb?=
 =?us-ascii?Q?zw8n+8R9fyAtnMqdN4HMy1+wwbRFKiWXhW6mey8fwM6o1XG92PcqlBm0oC45?=
 =?us-ascii?Q?n4RPQzCdkm9PhdqMgLbNYT/1mKQQFifNj3BtX14BHLvlEsd6MRZUuiLL3qnz?=
 =?us-ascii?Q?84SdLzph8x4fQUnZnh+JupnaK1qbEdqPEt4nHEX7BdOYeUNGr6FtHchzTF8Z?=
 =?us-ascii?Q?AAFFAKRF38zT3LpTs01QNYeDqh/LShtjX93RUfSnprxz46/Zmuw7w89P8imr?=
 =?us-ascii?Q?JtTtkyCPnqIBgckbb8XxWElVRdE+hkJTWpsNGBy7Wd8LK40QBUCpGsG0JufS?=
 =?us-ascii?Q?XJTDuqgz4eOGXXSGJpnT8Li7WCvgUOOiIIA+vJdTICBZGLXePS/1FPDfMifK?=
 =?us-ascii?Q?w3cMTxOXXVrQ8/OYl2FUD6ak7NcS6BCDkrhxwNYxIrXqP/45XaMh6ZQUEqeh?=
 =?us-ascii?Q?+gNRJ2bRECRTl2Tw0eAhfbZZdtpEXTatloZ4dg1KtmjQr80zdte2KCZENlo3?=
 =?us-ascii?Q?FKO0Ehp7/pgrlVF9VSCLT62qg6q5FOYP1OjXHGOyFIzvIDggJLiBImD7s2/3?=
 =?us-ascii?Q?H5GhBppFv3tN7Aox1MEOtgX9LpjNpYHf8DHVAE/m93cVHdv6m4mUTRrDTerQ?=
 =?us-ascii?Q?t+SbPe7YNplq/MLFR9qY1z0slep1AeuxSjXyzR3oOaC0aJThsducT1H6AMQV?=
 =?us-ascii?Q?E1uzPsN/1TUfNSAAibFHcZ8XP00eltC51B6QYdTpfkJ/1jsfuvWUbtd4RjZN?=
 =?us-ascii?Q?yfar2E56OntQexd6U+13qBCdtEAMpWLjjjzsjr+bIQd5NOqZqtwQJ/NeB07Q?=
 =?us-ascii?Q?IwAluUDy4IRRBuns7IpH4iRnEMF7clEYuWE1FPGQ/TH7w4WCS5ZduUtNMS//?=
 =?us-ascii?Q?/0P8iL195A18UJSXQ9HY3AuC/EyijWiXR4bPbD8F2DHYEtJ6X5lmvy3psas9?=
 =?us-ascii?Q?J9X+mk4tcb2rPy38dVyTN0k=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?63PQ7HKeNX/2VfIbf9H/6nmZjtTxvNg6cjUkgO8cyHoTVPyq7iHVfHZWZPNR?=
 =?us-ascii?Q?Pbml8dDrLjAcIHb+kkUyi3487qC+PShUp7CdkwBb8IOkKUboEXagiElAurh8?=
 =?us-ascii?Q?zY9ZwoXQMc2EfdsOMhb/ssug2alXLeLJeQHWmbQHAU9bTiT2cWEWrW5r337O?=
 =?us-ascii?Q?QQhP9W15L3ATgj3Imwfe1H0Zc9ivSui+qzJairwY1ijUiZmdXbhBu0d/v6tC?=
 =?us-ascii?Q?ZgSNDNDkYwEtzzJhnjCsvQRyH1fdpokXM+42FTEL3KjZnNI9J+jlkINH2Tew?=
 =?us-ascii?Q?5RPqvpacEjczHz7eQn789rF7ppowZRCqFxrEq8KcoaogPsmPzrwhm2FflCIs?=
 =?us-ascii?Q?jbvx0hlkfMiaQvQEMIxrmLDhw4M+7XT0W18fDg4zfPyZ6+ZAzHB2lP/H+rso?=
 =?us-ascii?Q?40Ftn3aJkRU238VuYlWzguf5CV+Yo09BXbEOhT0pKD9sYYZw1py33mxcmojm?=
 =?us-ascii?Q?xpa0tJlFyQb0gxy1DpLnCpYpIR2UflGLgFksAk9VQE68dhmoZ0r0IHJHrEj8?=
 =?us-ascii?Q?KL6lsEnxUHwoyrOQeLuxtXKOp2NG2C0lhTNjXDnW04FP01wGLu/jEZjnJoqP?=
 =?us-ascii?Q?hqFz9S1LXS9peZwwzFgDYbRWhO8nORNqSEzoSCsGTnj1t8NJoAKZo73NLrFl?=
 =?us-ascii?Q?cCzims+iQVef+ndWo955YNbLMIapQdRKLfDD1zZLcXqCurjIIkqEaizyGZ48?=
 =?us-ascii?Q?YG+x27RW/lbI+GWyKxw2snJwtKvAdktmAntLeM7s73G3A8XlrKHdDCB/hprS?=
 =?us-ascii?Q?A6SD9HzBc8J73jHQ5m9TZw+HnsrgiQC+hmn6VwYLv0vVt64I+HD7AUXKVzPV?=
 =?us-ascii?Q?IDmenl4vLlXfEV+CciXT+VrgG8mnpFLFx9dV2m13pk8feLM+rB/W6HmYGFV9?=
 =?us-ascii?Q?21GYoUXr/V9oChaItLAAKU6yd4I1fsFqsJEXsJAYDkzPr6mkC6L6L1d/StgO?=
 =?us-ascii?Q?42DeKobHbFxbuqV7CrxEG4hN3HfJ7v1AKaoR/fRY4ytpkYev7trAvbMDTvLj?=
 =?us-ascii?Q?H2mFscoA36x7z8Mg4Mnbrp69Asx9Trs2dMrjzb+kNpIL22CUtRZWxwhUi3m1?=
 =?us-ascii?Q?CmkHsQ8SxzJ51Ae6bt3C7y73Q3AlUw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af555a53-89d2-4906-a121-08db00a6b6ee
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 20:40:23.8751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 16XXKK9AjoR4NWrHSad7yXu8zitvnrod/bRlhG2p4xz658P/gGvsvh4/50E2UhAP7cMKhTWe+yqxybMrC927kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5019
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301270190
X-Proofpoint-GUID: 9At66RkmU9ubrHUHTFUtyftKoXh9agF-
X-Proofpoint-ORIG-GUID: 9At66RkmU9ubrHUHTFUtyftKoXh9agF-
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
index 1a63e37f336a..2cfb1b52d123 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -24,6 +24,7 @@
 		KEEP(*(__restart_table))				\
 		__stop___restart_table = .;				\
 	}
+#define RUNTIME_DISCARD_EXIT
 
 #include <asm/page.h>
 #include <asm-generic/vmlinux.lds.h>
-- 
2.39.1

