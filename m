Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBD467EFD7
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 21:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbjA0UmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 15:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjA0Ul7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 15:41:59 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED36F7DBC1;
        Fri, 27 Jan 2023 12:41:28 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RESdEX015335;
        Fri, 27 Jan 2023 20:40:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=cYJee/xls/lCay/kHB+RuxWv0HqYfjh5QMHJ+MCMjYs=;
 b=uuc1031MKmaaB+/+Mf72zYtP1EeQhtbeGq8obcuerFgJF4yUm7CRkYXfBFuQpc6Yez35
 lIFamWKktQXo8+/oAXPTBSweJXBmqwfidMF+0dPJRZLjsS84TPRhcOjl0k2apO6OuZ1n
 T60Scwkqh8A0TNk8w3ihbZUWclWUDl1ygu988B1btDLtqkHYS75A7lrFsePX5Oe2YGKN
 gKBWzShMAxTylforJVbpLO8ucKrDmJEEEM7jmpGxw0D3qp0fCKl4rNCNiA3Nrt+8u6w5
 kPUNosEBeSYKkZ6SKFIzxS1qUExf6oQbvfvmoWHRjEKyvbm/OJMyF3QnVFkBaOz0WnIe 2A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86ybnr1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:40:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30RK6HIT038095;
        Fri, 27 Jan 2023 20:40:29 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g9pr02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:40:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oSH7X+ODw9U42R6N/7tpLMdihmMkLbqik3yJSnHp7lDLCnbJ3Efz5UB6JNErJnNPri3JRcJbkfC03h0G37HX8lIjG+o0x5VylYxUOk7z1A/k2+mwnCJ4RiUxAM7ghY4WkXGrk+D712wuUWRRbvrvn7MNxD+qW9AtiRWmOzkMC8Gr5j2CEvshFJ0I9cjAx0bhOsjQSWzHhJk5M+17T3KFePadfW1ZSCoIXZ+9WZM942Laut3tWKlym+4+yj36gc/vYk/tAskHUX5rCPzUb4IqIRurhO+5raABmgaLZXtxql7DD34TYC7VO5YpRiO6ghrFcZbEOxCxcumt9baW+ACbQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cYJee/xls/lCay/kHB+RuxWv0HqYfjh5QMHJ+MCMjYs=;
 b=hnHZWx6ZoBZTNkbHwS6/NwAvurO4FLFh08O9UiDkAOgUB+8DD4rdrvn3QEiozN2BWkMPVnJ8gR33TJHf2rXRbVBSJ/0dcVa86njvR7RctHRWd3P7OdxD5wcfvTlVPFmAbdZgjGWA1xO+ED8AuYK1ZL18UKSSl4l/XOFSfl/yiegGPZdHRSbCbCYbgQm0erUhkXycvFAH8pdzNKyp/NGunHH/QoNzc8qp7jOENh1l8CXqmg6iB/6fGttX41m0UWcdtJpmqwZ2O1eSJYblKZy7bJ0VnjCeEC96GdugsW3X7G+ltujzp1kew5S6conavyVu1y/a4HUrndA1gP0AYesh0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cYJee/xls/lCay/kHB+RuxWv0HqYfjh5QMHJ+MCMjYs=;
 b=yDFvw2YnZJ76tsM8YFMbuBZB3JtMVs5MTyTGFagBJr6HKSN6icYnGwKeiaAm/PeZadEV6qKt2wzKx6s5p6vTQx1Rx5vhG/4wnMRlsiOhUDENSYBT93BGdKCKae4hv+F6/JLHN6sFKugnvo810vhUr4cmhWxxoGrDuL0DaV+Hw9Q=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CH0PR10MB5019.namprd10.prod.outlook.com (2603:10b6:610:c8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.13; Fri, 27 Jan
 2023 20:40:27 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 20:40:26 +0000
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
Subject: [PATCH 5.15 fix build id for arm64 3/5] powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds
Date:   Fri, 27 Jan 2023 13:40:09 -0700
Message-Id: <85e425f77ec54a89db740f8e22e763e401eec4f1.1674851705.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674851705.git.tom.saeger@oracle.com>
References: <cover.1674851705.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0016.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::29) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CH0PR10MB5019:EE_
X-MS-Office365-Filtering-Correlation-Id: c391b969-ce3a-4ff9-7076-08db00a6b8ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mPctN6PQ3swNKT5iuPPm8L9JOKD8Zd9rKhlFg4V53RdQC3vkNv3Q/KjeaA3DVM/F+ULrJXejf2ixcgd0kInDMq26Y/PqDlQoj9hLGyH8je9m03Z2jk4qIxAY10CD/7OCIsPt3CPzcruYNT21j4+at5POWh0mwCsyNqVX3Vning2ii85lvdw48q2w6VMAoK/DIDw1f7OKksNnQZQpKxcZ2Kqd9T1R1+rYlX0YAtzZ3Un+fn5zn7EENwTmLvcgyWupDlt3pCFiGXqefjY+msD1qtQdnIiL7lzbbMg70hz45fv8w2lEM47CxjX5t7n9qcuGxbAE6pU/AJjfE0AgJCr88vv9w9+LmAOp674yeRu1GS0qzlGjtZAs0RSY/FMcRznOKpLapRBJAGi3DL2b2m6PvtxfEzyJxU5f1L9OHy1MY6uihBKJGamoMYpVKvCXABm9UHllCqGC7XmBNqptjZSv80U98ddWdiq+AMuaZPRcd7/U/VgUh2cULKea8GTdHmgtA8xomfvu49oDnx1HviQA0LEnBD3IAzMpGs62d1M38yOIy2BVTPClfRsoVd1T8wD3GSu+iyKblMNIQeZ7PdgSe174yhmwS8g1GVbPoBJE8UXBfPPdTsPM5fEInd+Evjv4T33ZVYfPeMzx4hX+l5l6sIZJbDNqbq+6jLCXpuWUlJNN9/r6VZrb45GY64N0yvWw8UWbM9ufWAnbureNUiFmbuZrftB8EwNRXQYW27vmj4k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(136003)(346002)(396003)(39860400002)(451199018)(44832011)(2906002)(7416002)(5660300002)(8936002)(38100700002)(41300700001)(86362001)(6666004)(966005)(6486002)(478600001)(83380400001)(36756003)(54906003)(316002)(66476007)(2616005)(66556008)(8676002)(4326008)(66946007)(6916009)(6506007)(186003)(6512007)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C9P0B2KyPsza7HzFat0unMVFMekQQ+ZghMv0HjIf4n3+Pg8EwqOWw9ibJLyP?=
 =?us-ascii?Q?gBNjP0FJvntv3A0ObFn94N/nbJ5mBLy7aS7wHLaoDT/50LJSim6ZV47jCzah?=
 =?us-ascii?Q?GYbOjWL6/ReWvGvmAYPvMCivMg/h332qlPgYVv7NMxPaYvbf2CtLjwjuPoCb?=
 =?us-ascii?Q?ttj6x3pqklU4yYf4DSBE/VMdxifFjo8dJTBu8iUqyYwVoetYTjNen6tSmpJE?=
 =?us-ascii?Q?XM/nvdVbqDwtdRzrAh9f1Cbxqj6grVWzBFqOH5FsHEG3uGMm2o1pslrIpe88?=
 =?us-ascii?Q?8MggIfccmbZGu3jR35yqtKF7Vvm+gVc0wx3qHtb+U+Mx+o3lDhJ0Sw9N7rzu?=
 =?us-ascii?Q?sAdWNoI6RA44GiENv6ODbfbmAA5fz4z6dxRbkYR0K01yhK01e1Lefajch1Xm?=
 =?us-ascii?Q?aps0HfZZc71r/jY+xOsJjiKdXba9RtV5vp6H51wCY5x+ZscZuj7JhrZ5z0SA?=
 =?us-ascii?Q?pjCMa41fNOjyDO9Xmv5StJGB0oopgkVQ78xIIbPpV0osuS79ofKPfk+mzeGc?=
 =?us-ascii?Q?k8ldULsL+VlZ3amX4McebbW3pWkLe6b2kuFqAzguFXHF9HrIfxvj3xUdZ2KA?=
 =?us-ascii?Q?KCKntu60bfNCy2xZ+YCBCJU6pF06oJfTixJuSRCP4BPXoEA0xIyMMCirloMO?=
 =?us-ascii?Q?n09bdKlW7F0v8K9CC9y93hxT4YfaOSkTGDLn00b5qUHOwhpTsobn9nnyyuce?=
 =?us-ascii?Q?tIzegUkVYoL5Ee1yhWHhS4u8FxBpN2MQwadVxdv+RRYqKSm92Z0qQvPa3xBs?=
 =?us-ascii?Q?hlaXJ/ImlMDCdMFCPDOYy5HX4i4QulMjpLWCCaR/YV73t06GjKRtwgnm2Wtj?=
 =?us-ascii?Q?cAJsgKbJ/HQ7AX324yJ39qgxtyw+q/FBQcCi46Sr80og/4DG5Dpv4Hf4SvdM?=
 =?us-ascii?Q?A8l5SFAPPLAOzZQ783+44TQ6dOfLZSQUvwcn9M0Vstx/vGNqxziYLqKW44jP?=
 =?us-ascii?Q?mfZmZkcexkWXQ/2qBOVqYtcNebzqBe/jroiZmRE+5/bS0Yc9DicXtVRnEJjh?=
 =?us-ascii?Q?K+8b+ag0uukeXiY0Dvu2xKQJ9+mb21i4ZdopvUEYNpqKsdw6AMqeCdQfHYmb?=
 =?us-ascii?Q?a1HGLxVyI41yKGMDu6dNGMCT5MDFXlaHRdjMB6yBKM7Y8ytcjpiQpUn0kHMW?=
 =?us-ascii?Q?22FZsFD0lqe+5PV9Hw/ARMMaOtS8Ej2rL8inNokM1aMywa0hHzmIyw1XBHLB?=
 =?us-ascii?Q?ydVqtM17ovyr/PAbpn8pDVAwolCU01rowCHExp3zydGmXsg1YC39ZRYv+4/5?=
 =?us-ascii?Q?OzJENu6Q40kbUGtzRXM5bJedVElQQFctVOZF0frxSi6FYDmikIUUAB4Wl5O2?=
 =?us-ascii?Q?rjOWTgWHibZyO41AYvDG9stCkh92i717ubvq+QEDbTwtXS2tmzZZc7tg6g3Y?=
 =?us-ascii?Q?UaGiPMtDNXC2QyjLwwKwgUJM3DPyLuVC4BQFnt79hEQ/cgnrQmiEF3XE3Siq?=
 =?us-ascii?Q?qIdxJXHmQB1S9uWftwle3srbRiIpg5gsNEZUNz4F3Ju0rIlocxf/O6GNa7BY?=
 =?us-ascii?Q?bz7AnGhU+UwCyyUgPzHXK1gMquKh+WiYtvATAGYI52FPq1WfC8VWVtdBA0YJ?=
 =?us-ascii?Q?puO8bD1FyBiafR9y97t0z7BRm6AbKQyCU+lthEyx8PRXq7eXOMyXvUIDfKjo?=
 =?us-ascii?Q?wbufA+nHTAzJ1Gs8n12TW3o=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?2wMhZPJcZPKv15UoTPtFpEnXHtv4WvOQ+nRe9+Fe3YGNlU9m3aIs8BZUPPIV?=
 =?us-ascii?Q?wIKXkq8GqjUrnVwRMC2Ol1iy3B/N+imIO74mlEfqBJbcNmaZjXM83s64a/Hg?=
 =?us-ascii?Q?88ECL0o1vROfKxEbR+8hyyfemmDTh83XTyTxo74VPVsFEaTQ2cHE68mTnFpV?=
 =?us-ascii?Q?LCNcpj3JFzG8walEZGkarftrcYUA0DI+IRIKIPGu0sXnaCkf9mnK89FSoUuQ?=
 =?us-ascii?Q?b4J5IFfBFKQW7SBH9l580qPsK0YhmslQLmnU6bnbwhDB5Wtci3IPyoeZSuNl?=
 =?us-ascii?Q?ThOCRUcz4n5dvtLDshT/4Idc+Ifq1lpueHGQEeJPdHLA4hPoAhYIWRovv9l7?=
 =?us-ascii?Q?SNJByYiHVwfByvla4oVo1+RP/95Ff7MxCoIIrPjw4BIdsg0DazPLZckmY3RQ?=
 =?us-ascii?Q?GiQHeAXvpKXo236HiT68hx5gTF6iPQJh9DT61BIjsaL0/fRHHyn/84ChKsRN?=
 =?us-ascii?Q?fBJjq7d7FEDjw+rXxHWilhuef4SVE+mqnvi+xoGXx1eZFRgcSh64lclDxnnr?=
 =?us-ascii?Q?3inqsMTOR0hzALVLrat7bxZi36WHBmVtEESV5TEOJrKCvAKPnIP/PWlMltwi?=
 =?us-ascii?Q?deNdmW1tpJc+G4KZag8W+hMxIKnrwqs9J4srgX3OUdsBXGVro9J3Vy/VJO0l?=
 =?us-ascii?Q?M04PMi6jS4KUPGxdan1KvKVg3xSoj7GmDkec4PoWDG7Fk60pzDC2dUO2JLGa?=
 =?us-ascii?Q?x44Cx7Fsu0yePM2xxn5HpqYaFYV0TgNIkRr0/Z9u1eX/wMTuqMDviEtXXpih?=
 =?us-ascii?Q?xqd0YpuDPvsS50R3Za2nmVpPSqggiJ+DmDghav6O0zDUfnFw6G89Thrtrx59?=
 =?us-ascii?Q?SH5c6NiH1LXo8ufrs3sLvTSd7GoEL7DGErbIVdgIErvRm2fKsWd8oE3b5tYi?=
 =?us-ascii?Q?L8YK+YZ922UJVOVJPhwV4Fu587KhwzRioJh02WJIYVugb35zY5CTalseiMab?=
 =?us-ascii?Q?82Z6UjbSgJo4c/zRKxihewcC/sIIqmTB3TO/OvIDuWmOKFW7zBvS55iB0xkD?=
 =?us-ascii?Q?O6ZDLZLYdCoI3YafnRl1AtPCIJwbC5TKV1zychdyyWIsU151n7PUjjgH9hRQ?=
 =?us-ascii?Q?z7ybVDwa2FrAorcen2XhgqZMALj0OA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c391b969-ce3a-4ff9-7076-08db00a6b8ac
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 20:40:26.8124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U7pMP9oclyLaSiiv7/ehoQ1vj6+jACyj9rOZyitXGksXW69R+a9gaEqz9fOLePhqS/vjAMDgm+CbZALcwR+nCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5019
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301270190
X-Proofpoint-GUID: jAxoqUftqFYLmuwFsIrGvTH6k7cpVh8U
X-Proofpoint-ORIG-GUID: jAxoqUftqFYLmuwFsIrGvTH6k7cpVh8U
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
index 2cfb1b52d123..e1252bff67d8 100644
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

