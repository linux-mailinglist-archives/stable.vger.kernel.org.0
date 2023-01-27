Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFB667EFB8
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 21:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbjA0UkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 15:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjA0UkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 15:40:12 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B727DBC1;
        Fri, 27 Jan 2023 12:40:09 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RESj7v022855;
        Fri, 27 Jan 2023 20:39:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=WBBeZ1vkrerG75hvnJo9bC/qCY7gF8XZ7qq80akbQT8=;
 b=CaPfL9zci57b9hNlaFf6dug8D3ACbwubH55mpbHOrzhzbCuvlY19g5rJAehJHsN6dmV1
 b+UJONCqa3L1oJcuCiEWx9OP8nX4oYVgqx3qtOYAyCD0ST+fSaP+Q/Md1/VbfAGdcGcn
 h+2xzyQOFQJakO/QbZplJhj4Bj9xJ+aV6rfMBD0nxu3hC+8ghkuD8Na17nomqnQkj1k4
 qMF1a5a4GhpQGS5REamSheWXcMK9zc6ZzmlVQVoQSGc1CdT8uFnDs8/ChW4V3lt8aLJm
 rIGyFHSBP4EwdYhLUfV621E2ioSjwbkPl/Khd7WDTi0ctCRUOUP9nGmD4dKe8qv1LlrK HA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87ntdq9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:39:42 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30RKDuQZ024025;
        Fri, 27 Jan 2023 20:39:41 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86ga2rpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:39:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcys/xgEW4J6lKG1uj7nrm8Ge2hTflKvIfzcahsr4FPZ7kevjSSopfWQE1x4Ni1b3xWLy0VLh6vrb77N5aK3l1pijXaNvgu97OefTWUhsPBj5DUO1gFtMGJKurXTPzfR3ZJJ9Bz0pV5xB7EgKyhrywXPSgwIxFCnSR3bgCrVK4KTTS6+Zu7Oy5E1APOgqfAMx/hug8H7Z9uMic9STQ6BnyTObVf5bH0uE8ExO/LFdvCba5VRBJuUQFQgie+zm7fGutGWO1yH4mO7v9j4qPtTzk91VdBP16WjwskTvM8V0PWYQitVz4V8dFncKOrAFUDI1m7X4L05caqy8SFq5Tfj9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WBBeZ1vkrerG75hvnJo9bC/qCY7gF8XZ7qq80akbQT8=;
 b=m1zxPBtrGiOTxAyDBm9CYrMt1oWXrkj68qbAN7RDtHyPn8LYjpMN+xJsCVBsbbc46bdcfi5LnAzsfK3jH748y2qIrmfPkKzHTazZyMjQDnlfKgU/qR33IrtuE7gFWEtTmdKsf2W9e1hDoUrJLFCd6DAC56dxi9PTWbG7XStB3JxnQshJSwlmOG8x6mhcMDbhrXZmz48KLPR6oGgO+w3Nnmwn5fyKyyxUeM2ZOth/m/xOuOQuq79Aw8COOWn+yUSKUg9NP3acJ71JHgFbCq56WkDF/yVlUfybhdA21MtV5zWc4+pjxX5XXI6Du1oFCTcuKh8vVozZWhAopj7N6yBtBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBBeZ1vkrerG75hvnJo9bC/qCY7gF8XZ7qq80akbQT8=;
 b=usq0/Gb86O1rADLjwsHSc/0704VFhq7ez1SeKJaYiUbPxv0EViS1TK4WJAxQWU+RUdYdtzLwaXSAR5a+VLSCGu+jF0kNdXImCzaZId2n4HL1zgL0C3Y4mUhtyXqb0mvM2ettzRoInbPXYQbLNynpkUhQQxrw3ybCw0C//gbj9p0=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SJ0PR10MB4605.namprd10.prod.outlook.com (2603:10b6:a03:2d9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 20:39:39 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 20:39:39 +0000
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
Subject: [PATCH 5.10 fix build id for arm64 2/5] powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
Date:   Fri, 27 Jan 2023 13:39:24 -0700
Message-Id: <cda163d10304b128b9bd85cf9518c89ba841f04a.1674850666.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674850666.git.tom.saeger@oracle.com>
References: <cover.1674850666.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SJ0PR10MB4605:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d61e2f1-5bee-4510-7e05-08db00a69c91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jMvjggrDM8FwqdNWbLbX4Me1m51B+DbFfaSR/U9RVQVqTllKVh/dvE/P8oH+2ngwCb7rw1MHvdRZf9pgrfH9WJJvxs9mBAYJwNAhay8HV/gsjSdyU8++PdKeb5WX9XxhiSnGROsXWMut7Ku+KcwEaQVBan9ssvy+fGZm/ntuR5xwJi+7kbh0HpFC683QYzr47KfN/OaXZO4BCpabH50JhH4xnlPTHsG1ZGNSF/WRbu9+2y3CL2j6WSrSOv7J7txeO26MCPRwfGffRzHg3aZouJZ+V/ql1kmlZpy5nnp2LP/oNRVAypHrWBujWrBNIJ3nwoknHt20eoaijIR8O2OYtbR/TqMT0p64Uo+72YF4RqYZj9EU2NTGiOfjwoothGlnutDoiAKamWcYzxNDXuyFNOzRvkpERfbLrz9V7nSiE4Ru6vVlZwYY/PFJJ/J5sPbqUkq05EcFB2/XMEoJrtAxU4bIIwyEAvY7J1mQtRaiABpUSm5iym88g9seGjjuAM+X71xFCuxYZWTR0yrwnIQhs3gmWMpLpJ6wwqdBwj8wIrJ6fn3KWI6bDso5pbyetKD6qgQs5eZW6irnVFLFb+5Sdvdcu8gRihJ3ee5fIqYDHQuTw4pd70/HwC/q8avR0JAbjaf595YKzMCHW5I/09L3pqLxuu4bRU4ji9cwlge3PggzfFqy9b77lkKRpetIrITDkiYWz2qsY6u02cd1b9ij8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199018)(2906002)(8936002)(7416002)(5660300002)(44832011)(41300700001)(6916009)(4326008)(8676002)(316002)(6666004)(54906003)(6506007)(6486002)(966005)(478600001)(6512007)(2616005)(186003)(66946007)(66476007)(66556008)(86362001)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?103YXfr9mt0KYRC4ZuZA8SGiu1eXYjef7Sfc2aoPQKMpkunyV6jsANe3Gyom?=
 =?us-ascii?Q?8RHiG597xXAPH5PGMDJdfdu3tCs+1SnhfORE8N/jWeuFijzyu+V8H8qPqz/0?=
 =?us-ascii?Q?MFVoxfoZugerrgISP3wHLClcEp0jUCoYRwOOohY3ecV7HGYg7GywYNRIZVWc?=
 =?us-ascii?Q?fXlxc7eK/DOGlRHl+aiGC2dZBX06xtYDK7KuF3aZFrDvi+rL1ifi7ddj5pJj?=
 =?us-ascii?Q?mefjFuuqVC5gYf8WW9wY7cTwbApn/rl2TpFNa/6z3Xm0GUDH7oc6sbt53Yw4?=
 =?us-ascii?Q?mZzGELUD2w/sNaAk9vBjgpUg2oudobJkxXJTZOOFlUfCPP8O2wF62R8IPcKu?=
 =?us-ascii?Q?5WvVB3tSqX/NowpnH3fllpfFaQU32IW/r7kiuOI6uUwmQLWkgbCokgCqEpEz?=
 =?us-ascii?Q?ueCkDO3/DV4daU+JPbcsvziXkNeh37PtCpQCGbY3FZc9slwOSG12qM+Q/TSl?=
 =?us-ascii?Q?tC7QvqSFEcqWCfBukQc9XPqTuWBH7Vq1EBnCF2mYe76bGnaN1O/kavWBvdCl?=
 =?us-ascii?Q?TkEJzSBm4BXB5UI55VkigYf8UdecR+pnj2V9XcUN0akhAr6asMf7WA3cz1dM?=
 =?us-ascii?Q?YkmqRYbNR6FZYj1W+3uV0kdE6+Y2g9fz+wOA6w34ND3NmbqbTL/aN6ZwjY/j?=
 =?us-ascii?Q?YvGEfWZW5JKcqqVeIFYUFgr4/4aCI0axWEDjUdxtidmf1XZZGaix7rJgFzGf?=
 =?us-ascii?Q?ykZJN8SZSCgprucH5OWi+hm8yzfoAceIO3TiOD/c4J5KwqY0tuVCODbrnJab?=
 =?us-ascii?Q?b49twwJW1v3ogxeHysfOm7j3de2PJmpZXD0sJggtveGFizWB94QyBxTnOFbE?=
 =?us-ascii?Q?hWouhsv0s2YmceHErC1LDMe5L8VsKj89HfkqA/j42C5S62BXFuemZtqiWj68?=
 =?us-ascii?Q?USrd7zNRoJ5M8Mg4A0Zn8O5O3DZqlnycsC/KYv9j0DiCnxeYenDsq3CMJ/y5?=
 =?us-ascii?Q?syv2m3AJBilYW2mRemN43OSoHWgSAHH8xbGAcT5cGnvKm+VH1k5e/ALOWNc7?=
 =?us-ascii?Q?Gc+SH6VS6UfnCd8KSjTqgYCiqUkSk4BZ/yJJgJ56Y1ktlt3saI6Ls3eSJ47L?=
 =?us-ascii?Q?KJa8PCvdOAZAde3mW6LkFJcMV9qSYKg7KZ66GyNepqGDVbz7oAd3Ft/50BTW?=
 =?us-ascii?Q?zuVqlM8SoHExZljVWg6WbpPJyDrpyKYKD/KPxpAnU702bZBI2nZtLSVzXZWs?=
 =?us-ascii?Q?eRmIuTYy0Xl9mKDjuWy/RbZChW5zELHFDFSNUjOLnRA0grTHPqPCv6IYv9l2?=
 =?us-ascii?Q?JmQfnvZJ6nQ/SLRAAX+CQjmAEStQY/TH7Hd9+nLUHScqIGN0i/VQU3MRg9bg?=
 =?us-ascii?Q?U7rZDuJ+Umo/9Ei6RLE69pIuLdtbun+mCryue8l8luYrt8femtb/eESRiBYL?=
 =?us-ascii?Q?PkT3rI97dT/N3ifPwUdhTCegd2jpjDOXRvvJvZHyKlDsrYwxER6pbYnjtYZX?=
 =?us-ascii?Q?1HIu10ttoxC3Ol/yyQHja93M7WnA2AeDJy0rACK7lh8LfgKYATl6e9LXDl+x?=
 =?us-ascii?Q?eVhhxHo2LYs7uGYqzCG4nskh/1JPw8rDtMCjjNRu0niLKkH8wr/7JM1hAgO3?=
 =?us-ascii?Q?pX83mEmRuGv9kIFX6nKmgtg+oUwwXhE8H6OvxXCoJRfl9AUOaRpfBxYROg+X?=
 =?us-ascii?Q?1bnqizJyIbKhWfanc32WzPs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?I9x/bPi3i6kF0hQcNI7faCZu2pEQD9p2+yEfAczga+nlU1XNmM+OMerVNIqN?=
 =?us-ascii?Q?D8Oj/ZwW9lBPeiTeHoXrfT946PDfQRz9RrmNF/E61220yMTVkYayzcMKn0aR?=
 =?us-ascii?Q?nV94S4+bZ09DktXE8DM9SOwMhfZlHiVadHos2rappCuMyF1E2CVY/87jnhLP?=
 =?us-ascii?Q?2KAOuTo+JoB3a/3h1yu8A+/tUXn8r/4ZWgKWxodA3uOqW0wL8pqLXfPL5C3d?=
 =?us-ascii?Q?Gdj+jTk2sLL2YYLOQ9F8y0HU3EctznttO4dOXBGnIrh7UGIAwLHgZM4LlKBC?=
 =?us-ascii?Q?9VmAOnu4eBcUFd43yeUzyEX6//s3SyBqi8/7S3ydx/RNwqTelprzhQYOU2cJ?=
 =?us-ascii?Q?f7QHpxO86O524y8fCMx9d67yznfuBtWwqYhaF22kh5VIFajdLWdwumVNnJtJ?=
 =?us-ascii?Q?3XFwGBRSNqegH+xBKKRcMYMCPpXK06gG1q8NohxdHY9XGy9Et0qAMuf9bm2j?=
 =?us-ascii?Q?gHZHL6Xq228I7Rtu4e6Gp0g8jLJsPT80DHWVjSKHPf/hyadW9TvlShpNhDXW?=
 =?us-ascii?Q?pwHLF5tGvGkqERG6Y6QXrCNaaIUQQ7IK3ylbSsQHCE75ev/+e04rDTgFzDLa?=
 =?us-ascii?Q?Ka/xIWnKVQ1O4AAfisFZh/CmsTivWgbiaaFgW21ocW3k8hNcHpE4GCWMbSZr?=
 =?us-ascii?Q?HXgH7RyPRovg1i6pxFmVjY2EeE7X+ebk5Lt+ZDtUp0IaTa4Xzj8uGKLWpUb0?=
 =?us-ascii?Q?zJ9GnrKQSzKzXhnEagx9+JcXY5FMK/VMf8WyIm6QmTvv8mDrOxxJsE8pSh7d?=
 =?us-ascii?Q?gidPWugfSv47Aw9nW0mGAThPrHAHdCiAMiJfRLeSgdFzkjV9qxlIWEAAwam4?=
 =?us-ascii?Q?4iJT8JRzrTaXh+QndHgH0JSF9RCigLhfHOFY78dm0Y95OlTF3C+33LTegtnW?=
 =?us-ascii?Q?tkgNgiSpD3Sb5UmdI65dFXwl94fVt1CTaOYSLZpwL2SjM5nsiTOUsVQc3Ozv?=
 =?us-ascii?Q?jqEKUi2mpU8sw3O0bYsmABmE7VjpBc+TsdKp4MsLUiWLxJBvIDHf/vPUcZv8?=
 =?us-ascii?Q?d6bdljphFaVkN93uxz7K9DCGUh/4/7vfNAJRvf6+RbMuZD89Hi+gAm6utAtF?=
 =?us-ascii?Q?skKhqCgwc8HjewGUiiUopWI9XM4rvg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d61e2f1-5bee-4510-7e05-08db00a69c91
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 20:39:39.6752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QIPW0ZIQvn0ooAqvcZY7wY7orscwSJC2NOTr3gdcoLH9Ed18TFD/6MkXBGTQXVxoAn7pOr4hwQldgCVOYtUQQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4605
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301270190
X-Proofpoint-ORIG-GUID: g4K-odHXXrPLifIY0uiLAfzuCIs3I7p9
X-Proofpoint-GUID: g4K-odHXXrPLifIY0uiLAfzuCIs3I7p9
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
index 4a1f494ef03f..e3984389f8ef 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -8,6 +8,7 @@
 #define BSS_FIRST_SECTIONS *(.bss.prominit)
 #define EMITS_PT_NOTE
 #define RO_EXCEPTION_TABLE_ALIGN	0
+#define RUNTIME_DISCARD_EXIT
 
 #include <asm/page.h>
 #include <asm-generic/vmlinux.lds.h>
-- 
2.39.1

