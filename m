Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBFD67EFD9
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 21:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbjA0Ul7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 15:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbjA0Ulq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 15:41:46 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8607E6A8;
        Fri, 27 Jan 2023 12:41:17 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RETMaQ001589;
        Fri, 27 Jan 2023 20:40:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ICGy+aFUPgIKkWoxiB5uCpdn79qzigNUQy70xbk2kIY=;
 b=S1HLcyOQiEDyAEbBAiNmsPOS2/bpMgb5za6hNo6X8vv1cjlcOBrDHz+/AXZKmTewxlic
 GmUYunLguSnVVj0dOH9y+ktn7rcdnRLaZxVbM/LKYK6HZQDRqjSkN5txVZXmdFV76N+i
 ArQxzHTRfU93JGce4r4K9v9pujHlpnKXtRx8yO3uGJJmvYlSbL30LSyWs8dCbDBAfa8J
 BuFy5H9BOj8HPXtRzNM570K4BP2KTKBOFnUl4GJsl6yDQUOkyXNJRSCUvUCZ+rSLDYzR
 5g3Mxw1KmwoDgZzxIutRowfYlXDKAjJfnCrQHHgGByqyxzvhrYYklbQ20fCRuGei3zul AQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86n15uaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:40:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30RKAAPF018184;
        Fri, 27 Jan 2023 20:40:22 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gg2rmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:40:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+QxjSe/CrWLe03RUtOBRr2VSeerlST0hWvKz1F6oaUigSlltRgh2DfvkCXGS0DPoKST5eM7F0GtQyJDpGsPolobcjCB6kSMEjKshuwk/dlroc+yWLHKwIqu7/Ei7shBtIFptvrpvaXsvyJaskrErROYJuFdjtcVWGgN8g0Cug/NnKpYH1IyqdRqluQS5B7YWHmmEKBp0KclKL3kleAwp0dB+Su5PFmhV3w9gvpOdoCgYoZa/Q9+qHm95aqtXFJO80zAobR8q0HBR4aNshVdvff+pdxNsGlJWFAUM5DsdF3rxkD1iU+IOPCTTXL+ciHk7yYa1CvAxzjS7pYsrP5PgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ICGy+aFUPgIKkWoxiB5uCpdn79qzigNUQy70xbk2kIY=;
 b=CrHUpQ8zRgy+IbyxUODeUMyauvip2Lc0l5Er2QjvFC0DgcMzCtKOuu4W0kaZOizp0ySFU27hJV620zvHjbnnUHpFxjgv55iBixzXqsOPIXTeBEkU5e7i5dtXVFoSp4i2RaFyazC5aLmt6aEaccc9kyVVsxjY6JO4YUOMsjKrMA/A7b3RVPS0F8svNOm21oIyiQ+2LIJWIZwE3KFtSEuiQEWD1rbkwdzDcpWMOFhyPf0aepuDPu9bvbAVw8AxfyptAuWZyH3VyRuYnD62TzrjEfD6cEXPm6DjSpSHpRaXvWAHq4CclSKIjSVfj5xG0NztKSU2pNdCGCkAUnTdL40bIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ICGy+aFUPgIKkWoxiB5uCpdn79qzigNUQy70xbk2kIY=;
 b=oJXSqPzQRrgTVhlhbW50tQuog55NeusAoCoegSsd2j/8OeLLPFzQxFm3E/4k7ukWvEsA8/aQw/Ih6/v6Mlq5T5Kg0/VT5gavTnkwRisTGjH1kszDn1e8gZ/QfF/RN9l2kIfNQMYmqcp8f5rYrja91CsBakIo5YEZDOZKGdVkMbw=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SJ0PR10MB4605.namprd10.prod.outlook.com (2603:10b6:a03:2d9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 20:40:20 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 20:40:20 +0000
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
Subject: [PATCH 5.15 fix build id for arm64 1/5] arch: fix broken BuildID for arm64 and riscv
Date:   Fri, 27 Jan 2023 13:40:07 -0700
Message-Id: <16ff34ba4cf621f03d0ab4f5ec2c0a8a6ab5afd8.1674851705.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674851705.git.tom.saeger@oracle.com>
References: <cover.1674851705.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::40) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SJ0PR10MB4605:EE_
X-MS-Office365-Filtering-Correlation-Id: 09f99a8f-eb08-42c0-2584-08db00a6b4e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ShuJdLtJplgq3R0sV8ItPlr0ITBzhSfqICMYUHURG8cL6yOUNuvju/KgVZHcgw17RB3GHXCmKOuRZaie6xqj2AwF6MqQbuSDVC5YjK4NOuxBCuqBBaJvvypSLyCDkzpvCe4hGoBPVi6Cm6zf2eOQMbwTBJ5Wn5IS9vNy66UNu2C7unUSbUCSamRb0JYHzx3g/pERv3SZWNkEJiFZVGE4i/6dPRCpuwC2GqOjBiPh97FL8yJz87LstkXRaccSbXHqwsHWAVo7PWaUemPk9Watyq202we4/vBSyqe83x6LfQGbzT1pVMXx1mO/zxZMUF3OPsxJ4M1Ji7b0c951Y8EJuDU6XwoojN4EM8A5bKKEDz/o/VvL0/n6hkJ4uyOXfFin4WAV8BQ1R6FOlsedQ1grwS+YnlgZk6mXeEC69fgtjvk2+vJkYokYPFXsRcSlYMU0Hq8aOtd0iawUn6f3M0u80ecG/0UAujD4apneXjentWrGLJZIHY+6CGDEROuqLXJc5eFGR+WKYF26tMwDxyp1jB2XZKDNMZP1qqVzTLaaiBCbgrVfo+WRJRe/tNs8j33KrnGfrhqFkcCf3tLzJGSAnY+ZQZ2YmOjapOKEv2VdUVDbJf5z+T1L52lF+7+8Vgl0DAIstB8LQXji7qXOxqF1PQNPgC6MQOU57CG6FWWl48hjnEC8wIGbShsiI07xW/29
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199018)(2906002)(8936002)(7416002)(5660300002)(44832011)(41300700001)(6916009)(4326008)(8676002)(316002)(6666004)(54906003)(6506007)(6486002)(966005)(478600001)(83380400001)(6512007)(2616005)(186003)(66946007)(66476007)(66556008)(86362001)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QZVSVBacx8ki7obQxazZSctvsUKObqTadCmYrGGmJdTtcX77YYCbzXn6FSab?=
 =?us-ascii?Q?dfKgOeyV6742n8w4cOwBGYYscj0N/Lr51JvQkTMq/Q11eFudcPfsXdWFWPhB?=
 =?us-ascii?Q?XyAsQ/HaQ4abQTAUKM9px5i0nuT5IjqZJ2wI3dE9mVtjEsGEeaMqR37fpLE4?=
 =?us-ascii?Q?2Hk12WhJd4VS4AD1H7/2SAkUiN+CjESAgo8S70IibAjHSfuroU0XRZ5iAWi3?=
 =?us-ascii?Q?HhAUztuoJUjMB8EiTBanAoZWDFYz1yh95lmXFfjfiImoXZOFj4OwLpHc7Eqr?=
 =?us-ascii?Q?2mllJsxk2ZzzeDL1AHuqQ4RVU/ngzu24gQ8u/UxlMQdV+yl3wR1NUH/2Mubv?=
 =?us-ascii?Q?Vms3Wle/z5Kr8i/Dlq0kNSq1mUcLnhJe4LXxcU+kVtBebQweuz6QrO1de4Vt?=
 =?us-ascii?Q?jIvgHPCD7FDjJysIyLMIR5ZySDqzW1QQY4ueAX/BHOXuNkRBUQ/gbAXlvpro?=
 =?us-ascii?Q?0wWQAjDIGKOtHTr4I5/xbtD45du3/JSV1HL1kzmgxl+V3ua8x3mHHMFlp0uF?=
 =?us-ascii?Q?5zJQ15TcbCIyYUOZJJ98ItlbKso6e18EaDzSGHsuU9Cy74zWs3Y2Fu8WaEJ6?=
 =?us-ascii?Q?nnbN3/jpm38VN9MFL1hW3SJZvtyhEbilVHFndgvquPEvIT2f4tl1LV9NI4Ts?=
 =?us-ascii?Q?lhcNYk5wLXnxvHit9dG+ByDE9OTBcUGn0OqKk0xOZgiHLb1bATDQpycMg8hB?=
 =?us-ascii?Q?7uXac4k62x+sk+EqMl0jRgzfXTn7J+hJG7qkE1Shqvd3AmLRgDqlveYCy8Ws?=
 =?us-ascii?Q?VZCpF1zNC4Kxl6S9q9kasusfGq+9q8TgXpy0umVE9R/sdoDasJlzTamWFcDX?=
 =?us-ascii?Q?dPcZDbCT2dV1LtuD+TBGXD9RzzUbkjc5ijkaTy0OBET7IuUmz7AsU9JXmKwZ?=
 =?us-ascii?Q?Tj4iUeFDass0moDT9ilt98XsZGGtuUUuwhGNj0wwBuorXLzeFd1r+AB1TTHv?=
 =?us-ascii?Q?85mlGMAFc3JIPaeGVbWHGueuuU7BY0PL/jR9m5eNqlsKGsPv5h05ku+uwZEr?=
 =?us-ascii?Q?7O33I5LBCKYNudKKSKDuMlgAMnUTDWJ/C7BifME2zMgyqaN/vLVSjkx4sPVM?=
 =?us-ascii?Q?bBB3J8+134ftnd2H/TqhDiaHbWAwox3NVVqkQju8R2gDws675HSLUy8U7bew?=
 =?us-ascii?Q?uCs9LA5IYT+Oz9cgcx6uiqCqnz5U/hfMuFUqKsQaHiZvjLVHoJwT9Slz6k9A?=
 =?us-ascii?Q?dw2Dfa+ve8BsIZYhtLnwyWRt/wFCN+xF1ogmEurSu314QBI6/3Qj2q+1GknD?=
 =?us-ascii?Q?NEuIPumINmTezYcxNNOawk6IWnjTTm2F9JbyaJSTxy+PbeJrwd2cjxqEfIyg?=
 =?us-ascii?Q?ogS6dOZWgLOXOz2xp8NtnMF9D04cq2uwRx8UHdpHqoxvG8fm/BLoWeq/iNJ7?=
 =?us-ascii?Q?+6wKdh/uOH+3XaA613Z3s55v8A4drB9avDpqll3ZnNwxc66YuTuB13sBvKnv?=
 =?us-ascii?Q?qXE+cZY/6YiwXvu3qscnJ4ggnB8S1xoxhEUsWh9xyXYKM7p9IRmO2RGTWYUZ?=
 =?us-ascii?Q?D4AgfphNb18wALkdx4ntjnBuluZCEvI+GyEg6ZS1k9KJ2/u07aHb1lQCeaX3?=
 =?us-ascii?Q?gaFeOJh6A5fOE9VLXQt3zNyPDnSbB5riWbGzeUr9bSK3PzmhEbZ/nD0AIzrr?=
 =?us-ascii?Q?iVYkD9dFSV/w9bJgQMyWFF8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?q44uAj4QcZ8yn87+fja9qwluIH5Ywx9pSwDdznaNLExfEworosUdcPCdWDGs?=
 =?us-ascii?Q?mPluqvOZBoCi+J80dDWK4ZhOxjSjgqBd0pXJnpjhAZbn9+d/LE3ApLYJlUMI?=
 =?us-ascii?Q?f93pRTv04rfL9QVK+mjT4QvwLRoUbiNltFijETMIlY+yMEAvCAUnV/8QZyIN?=
 =?us-ascii?Q?0xTPDZvNTErpx8qCP81BWbk3AWhvgCLcRQEoGP9UxkjueUSKJxILKfk1YzMo?=
 =?us-ascii?Q?yoga8QKvTF0qLJkouwxZaPlZXkRWIREGZ/Tkfa6MAp3mWF677bixhU5oqGDt?=
 =?us-ascii?Q?xnCv3MVbZo4QR9uPazOI+binH+kFSDbgjUoHJJPKdq1GVsPnq2qDWoQgysmh?=
 =?us-ascii?Q?69JHcEu4/t34IZ3xf/SrpJO0Jj99RgF1LT04PiKB+6Eu9TazQdFERftFEfIQ?=
 =?us-ascii?Q?rt/dFto3daEvOxDTRHdq6a65W1BtkEy/T7lqBfc1Z6pfktfsJKrxXAbyTWX7?=
 =?us-ascii?Q?zqcXGqnNbeBVVAgrQRG1D1/QNTpPl/UFaKoJnDVVMrq21ZUNxta4OXhdZAdw?=
 =?us-ascii?Q?yAcC/bOMKHu82ARR06okkMt1GJv4HPSHyfrb3nN4p+YrEpLlfA2/1Yhtk8wP?=
 =?us-ascii?Q?nFEwFpozFjWJdZsIz7LqOoY8m0X8kla5Eb/Y0jUR+yiTHQ8GWF6a2D38p/GW?=
 =?us-ascii?Q?g+J9GAICpGQcIWdc61htlAGd6gmmytstoLyWvIVj630VA7XWhgyrB0gMmlbA?=
 =?us-ascii?Q?yGaN7TzVhu9Mt61fn/MTDcEWP3kLDRfs02kznFcUQDq3G/DhKlPMMNBFDmn3?=
 =?us-ascii?Q?j6lN90Jr1GuEwiZ2Q1ZGyNzdf0+VCPuK95YGzJhZMs9XI/rL2w8RvaDFWSq/?=
 =?us-ascii?Q?LA1iIX5zCcf5ykcX0BnNtXCXCvYSKXxtTYs3s13oksNQj9Pn7SOckHyqgOFc?=
 =?us-ascii?Q?HmSwQXfR+hs70hCKcdQI1hMfHy8OFMVzs0seQIack2K+Oi/Yc3FgyxvrzPmP?=
 =?us-ascii?Q?Avg7pxFofKTFptzBfrGXvCzvWLkR0XJd6hhaaBGoG7VarATZElzFkCPfpVhe?=
 =?us-ascii?Q?jbpxJ7giwF3ov35ik2Av309wjRGJJItDzJoiZj6/vOBUfdGYpg0vyAmOverM?=
 =?us-ascii?Q?JjIy5KM6N1EUw/UQnBTkKhEkysjRYQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09f99a8f-eb08-42c0-2584-08db00a6b4e2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 20:40:20.4066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IRxzeM/4tWMkuNAtwGW5juoIkKxg1SoWfz/Hso9LdUKGnKGrmOFdNMbujPLAjOhD6YL2u+7X01fl+rOD8PsBaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4605
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301270190
X-Proofpoint-GUID: vYgmbGUY1cQ6BRIxJ4721fltJHS32ecD
X-Proofpoint-ORIG-GUID: vYgmbGUY1cQ6BRIxJ4721fltJHS32ecD
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

commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.

Dennis Gilmore reports that the BuildID is missing in the arm64 vmlinux
since commit 994b7ac1697b ("arm64: remove special treatment for the
link order of head.o").

The issue is that the type of .notes section, which contains the BuildID,
changed from NOTES to PROGBITS.

Ard Biesheuvel figured out that whichever object gets linked first gets
to decide the type of a section. The PROGBITS type is the result of the
compiler emitting .note.GNU-stack as PROGBITS rather than NOTE.

While Ard provided a fix for arm64, I want to fix this globally because
the same issue is happening on riscv since commit 2348e6bf4421 ("riscv:
remove special treatment for the link order of head.o"). This problem
will happen in general for other architectures if they start to drop
unneeded entries from scripts/head-object-list.txt.

Discard .note.GNU-stack in include/asm-generic/vmlinux.lds.h.

Link: https://lore.kernel.org/lkml/CAABkxwuQoz1CTbyb57n0ZX65eSYiTonFCU8-LCQc=74D=xE=rA@mail.gmail.com/
Fixes: 994b7ac1697b ("arm64: remove special treatment for the link order of head.o")
Fixes: 2348e6bf4421 ("riscv: remove special treatment for the link order of head.o")
Reported-by: Dennis Gilmore <dennis@ausil.us>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 include/asm-generic/vmlinux.lds.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index e28792ca25a1..8471717c5085 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -903,7 +903,12 @@
 #define PRINTK_INDEX
 #endif
 
+/*
+ * Discard .note.GNU-stack, which is emitted as PROGBITS by the compiler.
+ * Otherwise, the type of .notes section would become PROGBITS instead of NOTES.
+ */
 #define NOTES								\
+	/DISCARD/ : { *(.note.GNU-stack) }				\
 	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
 		__start_notes = .;					\
 		KEEP(*(.note.*))					\
-- 
2.39.1

