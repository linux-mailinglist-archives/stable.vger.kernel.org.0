Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17FB96CADFD
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 20:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjC0S4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 14:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC0S4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 14:56:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DE919B0;
        Mon, 27 Mar 2023 11:56:09 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32RIoaUD029000;
        Mon, 27 Mar 2023 18:55:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=JfFU47Tty7dlR78n4RVrbx+u99E2UUhFZGnQs4qzgQo=;
 b=1QP6aIqMXaD7LMjiODgC+Mw98pBdr/Co9ZS9XYtkkMd6FedJ+MYGCiJwypC1WdOe0w3h
 R4s6LcIdJiTrXqtOi85ZVI7eUnt4DzCqJWOw8Em880JCwGPDq76hcVQHwuLTtfuuKFqW
 pyqEIy4XkflW+Nnl5lAqeuDvBDDE/Nd+XVHu9TOHpQkt/44XePIDFHEXVbCCBxGvIIde
 A2IlRmcBs3juDJHJq/1GtkDnb7AIQsMANrjiwo2R9PchQvb11+kVvsVxNNqSn0lKSUt3
 KQbs57Wz3yTRJfNlJpgA80CfirXo4GhH9ZOp6LZIZDH11PAqNjA08uWrXgaKgtQ9rKWf hQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pkgsa00f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 18:55:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32RHrF05032248;
        Mon, 27 Mar 2023 18:55:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdd4vub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 18:55:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPpDZIVeYU+nNrpGzCgoSyhY6fmIyWddHH+tYyqPnekK6vJ+BNTddth4alSwoZ+5lhL9Pwsk3BwtzxSGbtt0o9+lQ0SZta2Q9DgQvjN1zym3LBwrhBXneKy8dtYJOwuBHVE1ElZxpS9zkeTB0vJ2/Hnxu7bLbMQDkijghzIbSZ+UzSqlniBC3VEgxFMJ2BFpP1aBma0rvtS9ZQBuRd5WHFvFqeTSvdjR1Jx2Y78uw4LdiG3BPgtRJ1uA9owg/JAeicw/3Y7wMtYnztAUFDjjZcbkoU0sTvi3f+mhovTtjsx0cPnmRKLnpwnxFROCvSAA1BVddyAooWsAd0H+5u1+Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JfFU47Tty7dlR78n4RVrbx+u99E2UUhFZGnQs4qzgQo=;
 b=MDlcM53H6OaU7OZ7gvWGKxpZYp8BrfbC8UfA2sJA4+TLGtwgDteCzEpEbAbC+NwRCtmUemGJUuJsO/5ry9eaE8SHab/5zMbYhsy3MJh+0XjC6E/tO0lSmRYKM2CGXUoqn7GZbBRtiaLcLMbE2C8tdYlzQ4LmFlQNagWwhXG4x1Z6dNBvyBDODCfuQIMcUN/taaL0GuKANUBGluJvDpqfBdMFTq6nQ/5kYgbybTnqjnoOCGZuhW232ntkkgIiyFfGdMjlI1XJ4sLgU/ZJoVBOzLMNVj+1ZR2hUP4wqnVWBuLwyPNUiaZ6x6Eh1wYLndcBk0o54G/P65RnBLdzo1XsxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JfFU47Tty7dlR78n4RVrbx+u99E2UUhFZGnQs4qzgQo=;
 b=LTRrM+wVSkk9+PHxlnjN05toKiYcFsHlNuUJUB5xCnpnjPzAWyPTOyzke4oZ4SuPo/dB21FG5mlmEHjqrVRtf18TALhuei8jZ63/4u3cjdx42C551MNoBaRa+X+nBnbvHkVD4xYghKoxcznIG65KY6guKPep9wl03nedzWhoJHI=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by PH7PR10MB5722.namprd10.prod.outlook.com (2603:10b6:510:126::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Mon, 27 Mar
 2023 18:55:50 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::9fc8:73bb:cc29:9060]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::9fc8:73bb:cc29:9060%5]) with mapi id 15.20.6222.029; Mon, 27 Mar 2023
 18:55:50 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>
Cc:     "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        stable@vger.kernel.org,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 6/8] maple_tree: add smp_rmb() to dead node detection
Date:   Mon, 27 Mar 2023 14:55:30 -0400
Message-Id: <20230327185532.2354250-7-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327185532.2354250-1-Liam.Howlett@oracle.com>
References: <20230327185532.2354250-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0044.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::19) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|PH7PR10MB5722:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c76710f-387a-40c0-f97a-08db2ef4e229
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v4P4BwcQ59Ku060m51Neqtfwpwu5YnWQ+oFUb+VU8+ZcaEhk4M4Bzf+C2oVwk41tmXBOpbNT44wUTDUMqCjUZEugbtYl7kapWKCbXE+m5egTmfKzraMZ9DYqrzDhNtAmvs69t1osCObxmlO78js3J42ZXRy9V/piO9qZgl7WPPZQzS2FHcE3JQYhpeT16SqXALz6M7I7fx2t+JoN7/sHk0lP6SCL3nmIFoK8a2fWG5FVijln7mPikWTfTlGV98jPG/E804tNEF+aG4yLdngaUCCkwQfgG+0StJidfc5SqZbwU1KewDk05eAru9oT3h4cS72nE8tqqQLK1pZ4GNkP0g2eVW+NQiKV14pFOB3q3rffEMp+L629aCHDrEnZ+qgKF0No/GyZkdIB2+zaDyO7Xx5RW6S6dfWGvMGdXv/ksq8X0E3Hr7CYyCaRtt4mNUxFG90oqvMQuBWFkrs7eHC/wCyKiWPy3HXHl2RiHhnme7IO65fuQ9yiC/M4/c4aP1u6SzoYtwhvCXnW+7QYFrvP2MFom1cjMhJgKicqo5471iY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(396003)(346002)(39860400002)(451199021)(2906002)(38100700002)(83380400001)(36756003)(5660300002)(41300700001)(8936002)(86362001)(2616005)(6666004)(107886003)(110136005)(54906003)(6506007)(1076003)(6512007)(26005)(316002)(6486002)(966005)(478600001)(186003)(4326008)(8676002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qgPdoDjL3Vb08/IcTEjush9XtmG69m5zjcnGxtVpxE67dObCBvX+9aetB7UH?=
 =?us-ascii?Q?t13mZVaiZN+bhHVFkixbp7BXQMzHKbEogUlNfylxUEGGbdwQhcn9JF1bm8td?=
 =?us-ascii?Q?/s28pOURhuIcSNkHijEk5UyURKngLCCJ6Fkr+5JhT8L85orxX5rovGrZoYLF?=
 =?us-ascii?Q?8cwrpA18+ewlfkJ5W+GdXf5BKOkIjpQmQdR8RrTsGXJXNCJ/Jzp6i1xeykH6?=
 =?us-ascii?Q?gto1vda35jHlWde7gi0tolE0w6mbv+D8UlbAERFK17/tEuspPrHaD3D+QYkh?=
 =?us-ascii?Q?TH9CFZbnj7DguJxdSWBSkXxProzZju+p57fk40n0q3RaCOqBjCUkR3NDizNO?=
 =?us-ascii?Q?ZRXiggHZ7Coz+ZZxr72g3zWJidKyQzYe95rHvWlr6MOmu8Ft5Fe2Jtpvc4Mh?=
 =?us-ascii?Q?5dmxebQLIuzXeC6fgns46f2WPY9s5Oxg33aHUeqQPwrflDiDbFTjrYrvNUTE?=
 =?us-ascii?Q?TyQ2yJeJhd/aVcbtXh9Ifm9j4JjmxSkoVACrFIp/wOCJoL3i7Jo1tqPYlVZV?=
 =?us-ascii?Q?iiEmv1YE4v1A60tGYANGZB+WRHK84+3I8IphHzL3EZlYemmWnmLkOhMWBbLP?=
 =?us-ascii?Q?UwK+yjJHuIyzkcuf1xn/7NrtH9E8YY6+rz3m7eFg7Z9HSgQZrVbutPqp++rE?=
 =?us-ascii?Q?OCvE0f4NJERyzknWvd/eml23ufJoPlxG7AqKdEJ/bKgamIEOAX3kFqsGZVqb?=
 =?us-ascii?Q?ZBSpe+NGkW9DsjAUmXAZU0iLkmUCxe+Hv0a2pYOXV8c0k1tiguzGHUCVdhzX?=
 =?us-ascii?Q?OSpYy2Gaurl23ti4PNSqalMj+ZWVYEfe/WSgJwaNPBfKkXyEyhMlbfOcYRZm?=
 =?us-ascii?Q?akQreloab5EBYN2x8izOxwwVgvbunJcgMWQ5r4sfur95wxTBPF8/EuUvs/VB?=
 =?us-ascii?Q?gpt3e6De3sGYIOmD7TR1pg0q7Im/RSSHRWDbKj4zgbmhwqGjSBrBKDJl6OqV?=
 =?us-ascii?Q?HGOa4MJWKfQGFJQLL+ooUZYDl0YGllw+ur661RgiJ7W8dx5dxPX8FHQvnukP?=
 =?us-ascii?Q?d7QVa3yO50YYhtySTB2zlsUjwk4txg2YBTfktGE53KGafLKDy/vsTickGzcD?=
 =?us-ascii?Q?brpQBpfeW5MXizKwmhoRhYG+fdtfBFv4eML9oEAGq/BiDM2W00xc5CHO6blB?=
 =?us-ascii?Q?sg2JEiBY3CLoj9wraQSVWRyq8HrKrOAE6nVdZOSvdqj20GKfehBB51nznrZ3?=
 =?us-ascii?Q?1xfdUJn/T3xZXOGCysI/7CB2TsEDK6cO3TzOiONw8YmCaowF8XQfN4McQJy6?=
 =?us-ascii?Q?EqKnUvZ6a1tSIq9FyValGeCy8aK81fp/7oeb1EW5sOOzomIzVm4+OsIYWDgZ?=
 =?us-ascii?Q?KHQnlAnA9fny3NajO9AtZIfrxSboh/boH63s0PQiiz7VhMze8oTM3ZJeJWPv?=
 =?us-ascii?Q?P8yQOPNxYw07/Mq05pCHVSITxKxWYuvOBhFNUCEyG8t5F3mvMVW3WyBdIhXP?=
 =?us-ascii?Q?Qc7PCmyd6hdUl64lstWQurPqv6FRYVPoA9jVaZ1vegf7VnQS44Y0yXlEnKGe?=
 =?us-ascii?Q?SH2h4iE0d15bo3yrUiz5CUl8sdmofUWtMoofpcTQFRN1rKTzhAa7gztKX+Qs?=
 =?us-ascii?Q?28EanQlXvpEDX0XZJzZdqaqczx4MBToWTbyFcAXUlnJfIFuUUpCajAep1gE8?=
 =?us-ascii?Q?LQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?8ggrrtl7qbNhepSMk4wFl+WtmNB3DvZBVxbb4oo9X0X6bZUi6mFZWDI2g2J8?=
 =?us-ascii?Q?VAs7dJ6r0yO6QzNS1baOeO6n9kzL8homooU9ekTQGBGbZwrwR2eQzWkXpopZ?=
 =?us-ascii?Q?t3/2fO4f68Z1i3b7L1RSF+ec1emzfTIUKYDm9czcovyTTZiNDt0z4h12jdNY?=
 =?us-ascii?Q?K5+yGqhQkkZeIy1pUzIn3A49fbpzGHRQ7NuLM+tciVgNlg6NounxCEkWnBpR?=
 =?us-ascii?Q?xP/jJ109e0nK/uE4W9ssnlmd//qZ1c7pXzJzkpgxFeLxCbXlW3ln/47GeBx2?=
 =?us-ascii?Q?T4dhggFz5jf28sA70iWOguMwsc++08H4TfOed626VpVniQ3VQXAqThA34CAP?=
 =?us-ascii?Q?qcS2F6fNwDaqKki+59FPVbLrXEy5bGJFQ5nkdwThOU9PTFajJvCYk/D/Rf1T?=
 =?us-ascii?Q?dT059KsxvqaCNd4U33pr1PDWatDPZkbrtfWbUQwdg/TSR4IUlBaXaivQwM/+?=
 =?us-ascii?Q?8fLSZAgmOamfKdqxpPwbZTy4IZpVo/mJjbMPYcTXZA5AJ139DKhYxYvA/yIH?=
 =?us-ascii?Q?jb4pY/gMOYkxc1FBmBoQtGbw/dIXBrqQq1QrKPut63N1EkwC11RX1vAkO1P9?=
 =?us-ascii?Q?HLNDQLOl0TlgHeKQfqtbmcsz0/v48rdKhovpyq3AiVwxYAbdLfxxnOZLw56W?=
 =?us-ascii?Q?swKi7Ly+3EhxK3dXf9QGD7S/PhAJAmwAvVvSkaiMV1KxNsnHOkMZwAucTjdx?=
 =?us-ascii?Q?9MVHNWMLfrZmVUw4VRe1zEqfYQcFrOWBy/E2E/Wj+dhzVO+0A/2Ra7dn2OW0?=
 =?us-ascii?Q?w/YCouQKvUBpB9yFetK6dt2puw2LLX3xaa4TSibKiMjaOXYLkcifzumwsbB6?=
 =?us-ascii?Q?Cm7Rv4fqhLD+eahrP1/7Sm1lS2RpzZHRwIesSvEnbJtnY5hhfVrZZwa82Qt6?=
 =?us-ascii?Q?TIWI0BuzAkhP0DO669vaTOwftE6YKyzUS3hueY9179EuIdoZ9yzA5FtOj6M8?=
 =?us-ascii?Q?cCU9OunN405B5A2xjwmmuQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c76710f-387a-40c0-f97a-08db2ef4e229
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 18:55:50.5457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XlxcQ2/cq0nfCnGITXRh69FFwD5xrZkj8OXP+pk+M/kqhOiWj8/0QKePIOlx7VYhI+T7kRVvTJAB8JypeKMq3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5722
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-27_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303270155
X-Proofpoint-GUID: MYRgeADDFXDmnMbBMZ0SVXaNARkkq41C
X-Proofpoint-ORIG-GUID: MYRgeADDFXDmnMbBMZ0SVXaNARkkq41C
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

Add an smp_rmb() before reading the parent pointer to ensure that anything
read from the node prior to the parent pointer hasn't been reordered ahead
of this check.

The is necessary for RCU mode.

Link: https://lkml.kernel.org/r/20230227173632.3292573-7-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Cc: stable@vger.kernel.org
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 6b6eddadd9d2..8ad2d1669fad 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -539,9 +539,11 @@ static inline struct maple_node *mte_parent(const struct maple_enode *enode)
  */
 static inline bool ma_dead_node(const struct maple_node *node)
 {
-	struct maple_node *parent = (void *)((unsigned long)
-					     node->parent & ~MAPLE_NODE_MASK);
+	struct maple_node *parent;
 
+	/* Do not reorder reads from the node prior to the parent check */
+	smp_rmb();
+	parent = (void *)((unsigned long) node->parent & ~MAPLE_NODE_MASK);
 	return (parent == node);
 }
 
@@ -556,6 +558,8 @@ static inline bool mte_dead_node(const struct maple_enode *enode)
 	struct maple_node *parent, *node;
 
 	node = mte_to_node(enode);
+	/* Do not reorder reads from the node prior to the parent check */
+	smp_rmb();
 	parent = mte_parent(enode);
 	return (parent == node);
 }
-- 
2.39.2

