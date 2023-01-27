Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC45267EFBA
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 21:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbjA0UkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 15:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbjA0UkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 15:40:12 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0C11A943;
        Fri, 27 Jan 2023 12:40:09 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RESewG005537;
        Fri, 27 Jan 2023 20:39:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=xIUsBirrL5Kfe1bDAFvgWxEdoiuKMaEYj1158bxLS4w=;
 b=wjE1DFFph0M/C/XmPjExAeCGJYxC7AEOdhW9I/wsRuZ+ORJ2WEkKkz0nFYXdt0W74Bz1
 a5yUepf/GdiDfxAYXQpvtIZH/42RyoIsgMYrGxluwdIcJFPPB8ITfd/9FIhq4lJNGq+b
 olEikrgcVPHdjO+sGR9ijXrYkEesw+mo7g0rO2nNsAmmbtyzzmxq1EmblwUR4oCtWwDZ
 wmyBGrYiIjNYcZ7HULXkObznG3Dy02VlVZ07nSLqhXaXAJIn3HzOYgHg/mD3J5ikW1Yp
 Tl6/W7/L/tIbb0WORtmLd2CMpkS7lpSlBdl1pLGJvEVhXqfq5mO9vhtBkmHwlKK+Ynp1 cQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86u35rax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:39:36 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30RKHZEw023950;
        Fri, 27 Jan 2023 20:39:35 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86ga2rjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:39:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BrwLbP0AcvmEe+Frf5Xx6u58ZQllClqHa3UEms+utkhPRnQF+ZjaHJHuqvLvD4eBBbOXqdSG6LwI+8ucVmcphpWtT6sZm/cG5lMaHZ93jDxnXVnm9GkQOWa3wtW2Dwl+mdtPedhj8ao5c7cdHhW8Lan25NsyiJ6T5dzK6Dd3Rko0P/xfugGtkorvGsy9N5e4u8yjVHhQti+5BzV6AxbNRpsPlSmj0t/uUIwv5nLydepF7OsaXEwe3sxMy2oo4TJH3Nn71B6oLSSZN3uO2MIRYHvt7+aUlm73IwwnajV+4NAzec6T8+W+CzsKUZPa8NhT8K1wyw0QJRawknKAakEiWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xIUsBirrL5Kfe1bDAFvgWxEdoiuKMaEYj1158bxLS4w=;
 b=ZpOjzfHa/rQm86qnt/y5dWC7S/wirew+h8bJhkvuMdjg+itR8t3Kl3QDQmh59iwPlrkmxcF0Os2msDhJY5VjJOQmDTzlx8cL5YYStiA65hj5uuFDsarFCpjv5h4xS1NEv0Q0cl3P87de7fLaXQ5Yyu6v3bE0mFQcTjX9dkVRyuO+DSsmqUuYkqNmeExPU0ZxLvXwH3GeWl63eVhAnpWdq/eqWgTLvPu5UkOVlZYAxqqY8JRfVt6qujzOf5PF+w2wn9wkb7XYIYIPSSDk8IrY56RD6/rkpxjdtLXophBUrzjNvhQDVawLqaTk5PL5K/KvR7LzRBZieZljO25cidK/Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xIUsBirrL5Kfe1bDAFvgWxEdoiuKMaEYj1158bxLS4w=;
 b=KvurxXECau3OWnmq2GiOHozy21TsNQXYQS4berkLbuwGcw4mQmNtQwOOhzowBoXKHLEfmQRRqfkCsumPH2yzYsV5/NMlDcTDEQLwL0WGXl1C6mhyuoAZ2n8q2dh+RMPeQt1kqoyv5WY0D8/R+X7VOx1IBwxBLGhxHHY2kuHN0AQ=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SJ0PR10MB4605.namprd10.prod.outlook.com (2603:10b6:a03:2d9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 20:39:33 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 20:39:33 +0000
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
Subject: [PATCH 5.10 fix build id for arm64 0/5]
Date:   Fri, 27 Jan 2023 13:39:22 -0700
Message-Id: <cover.1674850666.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0042.namprd11.prod.outlook.com
 (2603:10b6:a03:80::19) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SJ0PR10MB4605:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f07f2bc-fe53-49d1-1ea0-08db00a698d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BV3znz8kW5i1RqQjBavGR4Of1O91Zscr6ms0cv8cs0CK+xZE3+KC/iR1Agmm18udQE3fYr7xsRClj+wk+squb9TaSFHHSHB+sXhoZj33VC7tY+JeUsQk4+XEX8aO2tcZwcU8KmBBFfr8n2d3BWVQTGPD+J6lFnsbcqK/2V3JlD4Wb8QZVAFjPnTQq0e/hl9/Zam1QpdWBWwfCMJrt+28siTuBDF3QAIurt1u9aepQeZPnvZh0aPcEooVfS1Qz9JaczuY50vvrA7gMp4YTy/ThMIeJoTINCQRKmGS3vwaZLQO9CBf/nUanFczbx7SWtt87RmyWK2bVQvinEn9CK52QL0fVB6X2QSjVVsbz0WOCmpOM2Lf6c5kjT3UnTRiGA8La7QCZf01dL/hivn9r8rAhdFNxrhPM+63+ll3WFbNdgLizGd/8XWE8ReKI5QvdiGSFfcMOv5lrgTxylsgABr8k4I+NY9Yap6uxwR1NKSCZBvQChQbTgbrPFaeYWTaXhvaJUNJ8jq4e5FVclRv8Aa3AabpfeGIoAFVNvTlrN85gKJnifZjjWoxQQIvNwzBa/QpVEiMKO9ZwzPNFYTI7nWcJQUbISfVCKNaLoo/L5gIoBm+Rg0mbLDKDQsXxsdPZKhSRhutGvz1zW0E4ohER9VIqrcREMKYI3kmkhGJRovJ9b4GWFnsLwy1omuEvDJgFXJT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199018)(2906002)(8936002)(7416002)(5660300002)(44832011)(41300700001)(6916009)(4326008)(8676002)(316002)(6666004)(54906003)(6506007)(6486002)(966005)(478600001)(83380400001)(6512007)(2616005)(186003)(66946007)(66476007)(66556008)(86362001)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qm3x6zUjg2LyVPkOY2rxcNYih5alnUx5dNXLSmXktYEedUQBAM9bEM1rUeqS?=
 =?us-ascii?Q?0yxWAGKSqv1ugeFpQvvv38IuOOkLnfBUalQjhTz8dYMYuZQUzJuZ9Ce2rnxe?=
 =?us-ascii?Q?UG0IVOsR3gZ7TIA8/TSNpiW2BYR1l6Nb7b5IH+nP1M7JnGt2ADFElnY7st82?=
 =?us-ascii?Q?Ie0vbE9vcZyn1l3OOKoTCIg2K4HXFKpB7waQ1fHDkXmGmWUPk79UT42Q2sKN?=
 =?us-ascii?Q?+V2toDfJ4YKNLThabw2vx3c0eiEaFgddEs7hfTJkSRju1uZ2X6LUsMaAgcer?=
 =?us-ascii?Q?Ig6FLPUDjA8UgF7gRojzsMTsuwmqP+Qg47xTA+bQS2oW9jZl+a9KYAD7km5B?=
 =?us-ascii?Q?Zl1jTQUnPpWDn2lKlmcdzKQlHxvHuXHhl+6rE9VKcTqG0NutaKSYj3oLfee0?=
 =?us-ascii?Q?Zj1uJA5CpWi1CdyO/g5c35iBXGJYa4IppXvrlaDB7SW6WwLzUnsqeEevA4Fd?=
 =?us-ascii?Q?37g0rYNlvbJKplhYFgkwhadS4KIe4WuW3Nb6d+5UUpofmrzEAAdIpMGxdft3?=
 =?us-ascii?Q?aCIwKJ6uoc8ALJPXL9+gB9bzu8P2mM2/maQT8+iHRC2ZRKu1OVsknc+crieV?=
 =?us-ascii?Q?8qCa3l00+nhiCZBovVnrX6oAGgQpbRpPRiD02clh+uJITtdQgQmhL7nw0kJp?=
 =?us-ascii?Q?boCEQccyC+EJgaQuct/3Kb1Rc5TaxfxrzDZ6catLjDjqF2C6LT+xK6IRPpk/?=
 =?us-ascii?Q?yM07tORuptF+Dn8meDAk0z0Mm9paBET9d7ZV95T3RUx/B1xv71jD7QLpUB3d?=
 =?us-ascii?Q?vezV8UO4Qcq/HJ+HLAZWVys+gpnRpN6rIkdGuuPwoseHp5qyCb47KF2ryFLh?=
 =?us-ascii?Q?xJzUm/YlVIwQc+cmizxZYH79o/PfUlatAnBmUmxkwbvzwF4fjYFcQfseddrI?=
 =?us-ascii?Q?HYKrY63u1Tx7TGwgCwYRwQx6a1lW0IQ3V5SP9s/qOK2euHc3aVe4/mJPg7z3?=
 =?us-ascii?Q?PiuiINYRKRd7rwhJoyO4XGVehg6XPjFmOTlHo+NhN7A50sbz7BgoZHxHZWqg?=
 =?us-ascii?Q?5vH8aXNhMp8XW/GZhh+dHKCs03C3Vn061bXQBrYfT6a8gREwVdm5Q+TTXByZ?=
 =?us-ascii?Q?s3EoHXFpORbVa6qvtYpdfRdQpdJZLdzC+cEV8t8f+L5elaynmaPh+R9+xITF?=
 =?us-ascii?Q?Ba6zwBb+6yI1WpdtN4gr5C/4iZAfCPivmU6aZusqQ/N6R96JWGUJNjLvEZke?=
 =?us-ascii?Q?lK9pefN+Gl265EkfhdG1nGI0ipt/OrMYMXCfnxfBNb1aQNuTCZ8RLNGFWOYo?=
 =?us-ascii?Q?dUfOAuZlHy71xP2izygn67Iz4K+u7QpUNBzdyRewcM/7iZC7bAIJ/f+1hFlp?=
 =?us-ascii?Q?bIVhFvO7nJ4wgd5L3OZxN7u338Xm5lRI4BA6etR3X0xmBtLRePp8A4dgM5I9?=
 =?us-ascii?Q?usSNx7NcqaI1QTDT8TVjp2sccrlRuNPwcYr471uGQiVylakfnsHkq8GlZVTx?=
 =?us-ascii?Q?gsqxA0UUuMSYYbNHGviqWoO/PmOQ5GFORrmHBlAfc8uDrkGYIkx1JPxTt0xD?=
 =?us-ascii?Q?OYAhZxjqK4YD8SaAqsC+nAdq4/AMyCSGCVu+AoXfVxPZVKn4YcNHFTU0gIsS?=
 =?us-ascii?Q?g7ippylYyNQnJgEAWtfAqI1mWyYSfOjZkoG857+THpZjQNAv9UHbZnNGkkSA?=
 =?us-ascii?Q?d8oi7uMPDXkftwWnenwdM4c=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?8K1RBeIBWHs2LIczG0lkKa8IBiH95AokeGpC38zRyVGUDWKP6iDEPtWWI5Fs?=
 =?us-ascii?Q?1zxTDTWrWtnRDWswAOv9NMVdK730HCjc7HMOiTa6Wp2pbWgHjKe/fJIU0r8O?=
 =?us-ascii?Q?Va/UFDTNhIVxCja2BEC3NSK5qYdP+8SoWpKJ3EMoZqrV8OqzkMu8XJFNBVNY?=
 =?us-ascii?Q?6mnYAhXGXKX3Wm1fYiii6gFDGnKjLF0yjhY9Veh7+wPiYzBWVLnz+vAIWT9B?=
 =?us-ascii?Q?/hPHfecerPUiI7cuSABsNuY/1RbdCj+v0UryRJgbWnOM6QtlucgwOg2AX2DT?=
 =?us-ascii?Q?FRY0TE/AJI92ioMoyKileZzPeJrQXQaM0pLiWNYVNDwz4/5CjGnl33cDPwc9?=
 =?us-ascii?Q?9Axcr8X7pd/ol+mi8ATUQK1cJ3WzFgodK8B/qPrgcQg2187jyvgUb/sefR2e?=
 =?us-ascii?Q?qMEkVxc0a/ARFSWypnDbnKCCqZvfHEdHmRdnJDE45agE8bBuKJBKwfnZrrZ1?=
 =?us-ascii?Q?bpiUcv0UDkNNU0uAfF3ng2HZ2yqD77cWEPXeyp8WNfUoQL6d4d4Lay7/MpQC?=
 =?us-ascii?Q?R1eBA/qKLp9EF3Mn8bndxgaQtOO8SYBxff+puuwl+ktRdBzb2atH26kp/7wa?=
 =?us-ascii?Q?Bh/NUjApqSWjR3rFsZ1R0qlGNbNN12ZNaiQ4ASuk/Q3myEnzcOCCdBqMNovo?=
 =?us-ascii?Q?OAY+Zu7qr6Hc3aoPKZdoCK+b1f++FwlOvDKLxAIS3CAd0d1bcKS0rpAyyoQt?=
 =?us-ascii?Q?KxG7gT3DXKBmD/PhkK4n33GLkju3ilgYhiWKdFv+URZOXvHm9BtEVoh00dc/?=
 =?us-ascii?Q?GC6NJL+4s9Wi/i4YcmYVcCPT2CIy0g6NbMGnb8gXei7ghBiHUOPj8Oq1g7IJ?=
 =?us-ascii?Q?9PgC0rsnEuiuT/t/LwVCgeE0Vp0U8w5DCk0Z8s09CUpt2EejY0MuKFQiYieU?=
 =?us-ascii?Q?yL7/z+nqMAZQWAY8tCogBsSk3s+UExya62nGVY3+vGBXonUexUf33pqbxBuu?=
 =?us-ascii?Q?vIRtVqbZ5vtu2wU3HMm7znmBW5sXm/Ym2MWzkwWXrsBNHqJxlN0FoUlqUa5r?=
 =?us-ascii?Q?LRvu7rfB4oIWH32PdMmHTzSvr49uceJC02Li1MG0WDV+zL4sJdJqiMKgA08y?=
 =?us-ascii?Q?qKRIy8bpA8RK99A3IkO3N0pGD3g87A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f07f2bc-fe53-49d1-1ea0-08db00a698d3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 20:39:33.4100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mP0dHxlXYz0ibPsK2jxaqXtuI7ZfqDo3uKaXVSKdaizi9mcDjbTN1JJw+wfHRnJTi/OAEBJjkT7Qjl1Z59T0Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4605
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=883 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301270190
X-Proofpoint-GUID: Hhcjxan441NS84g0AO8Tjr4FB4XiahlC
X-Proofpoint-ORIG-GUID: Hhcjxan441NS84g0AO8Tjr4FB4XiahlC
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Build ID on arm64 is broken if CONFIG_MODVERSIONS=y
on 5.4, 5.10, and 5.15

I've build tested on {x86_64, arm64, riscv, powerpc, s390, sh}

Without these patches Build ID is missing for arm64 (ld >= 2.36):

  $ readelf -n vmlinux | grep "Build ID"

*NOTE* to following is not in mainline, yet:
[PATCH 5.10 fix build id for arm64 5/5] sh: define RUNTIME_DISCARD_EXIT
https://lore.kernel.org/all/9166a8abdc0f979e50377e61780a4bba1dfa2f52.1674518464.git.tom.saeger@oracle.com/

Masahiro Yamada (2):
  arch: fix broken BuildID for arm64 and riscv
  s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36

Michael Ellerman (2):
  powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
  powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds

Tom Saeger (1):
  sh: define RUNTIME_DISCARD_EXIT

 arch/powerpc/kernel/vmlinux.lds.S | 6 +++++-
 arch/s390/kernel/vmlinux.lds.S    | 2 ++
 arch/sh/kernel/vmlinux.lds.S      | 2 ++
 include/asm-generic/vmlinux.lds.h | 5 +++++
 4 files changed, 14 insertions(+), 1 deletion(-)


base-commit: 179624a57b78c02de833370b7bdf0b0f4a27ca31
-- 
2.39.1

