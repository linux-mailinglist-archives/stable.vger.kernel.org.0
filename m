Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0F36CAE2E
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 21:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjC0TIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 15:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjC0TIh (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 27 Mar 2023 15:08:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AB4170A;
        Mon, 27 Mar 2023 12:08:24 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32RIjPeU007133;
        Mon, 27 Mar 2023 19:08:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=TpUsjmCjRnVRG6V8IDPBzE+S5LIdsDOZXCeYop4f09M=;
 b=l3kXqQyhmneR54y8Ng6v6OGc+jA1+KR6iGyLGSv4RfTqtg2/ItMvDwgiWu7/ca8XbZ8A
 9mCTGfqFkLVNcGWRLzpdYhw3bcCBqHgUq98osGx0R/DwOGtHlJPN160S8gqEk71g2pEk
 //iSM6MbHsXkq3gNwzB2O0kdD91q9TTIIpfBjLrLc/NnDY8/ZMljCrtnSNQm3Rx3MMQA
 KewyPkkci0TpjbzbE1r0hqgdSdLMVQlOSL1rAKnYEGlYXUJLEkEuS6lcbZ1VwfEsIPf1
 iVjRKoCf4W5mW3b31OP76dtSZzroNMoz7oHaYXJe+UPEoggZjI21cdgx83FI/l4unS/Y 9Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pkgpmr42d-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 19:08:14 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32RIWiAY027552;
        Mon, 27 Mar 2023 18:55:43 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdbvyny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 18:55:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LEyzBqZ4KFGER4AlT+/nG+I70lmhfBzPTQ0bFRMEldrD+v8ddedNP2gp/wY/ZmbpFTpvlg6dZUF54NTupn/qve8+HwEX9C470nFSHrfQ97Ns/KCGiF26/yCUqW7bmFnD8YxX4d6TvMfpBPWdZ/Rr7gnbTSvRUpSp6FPT9x2V9JwuBx5l20G6GA0e0ue/Bf6b6ZD0lQsFE5/t4iqWJt7jNdjO1gJtUe0EFGEmDiMKe1KP/UoRRTVdn9FHXd6YBTvsI2Wei9yNz6uV43QTM0tP0Nbuf4aoBjXGWHBTDXkSJLTqPoPSHfYEJHdFCmoa5xZWJaZG5b86DXEiMh6GAJWjHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TpUsjmCjRnVRG6V8IDPBzE+S5LIdsDOZXCeYop4f09M=;
 b=ibAlfdhX89rBRJCBQr80ntQsM8c+TJS14T1htkqcRPVovuU88oNcQfkebrXncBj30D3IYAe3YgelOD1fglfwjlJOdpmpedXQt6wMDdcf7pT0UC3et7JBSDMkkbkkbrwsJGpzn2jB6ocC6DcJGTmq1yHQfK2bMjvadhngzGB+pGyh6aSIiYEhQTEE3tRyAEHJWYra1ZWmmpXKLERkj0XVvs2xQMvRytA5s6d/FgVMXNLfNfL45qUsyHyZ9Fi0Y/TA8kocDjtxCyxgt7GCY3ub+ANaZAISMkrnx7UPP0bWgGK2cLkkg5vAmbh9J4bP+OzWGZxFOVXHSS9uSLaGTMI94A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TpUsjmCjRnVRG6V8IDPBzE+S5LIdsDOZXCeYop4f09M=;
 b=TEyEbMpu+MDQ4C3HGF/acp7iyYVYImj8sMXvE+gkcPJ5QuBGrsbjcgSudgc9A9GwNBovZlYFaXt/nCfIEY6FOZAi8vKO4k0E8GLRvve6pMYVChz8OlTJI7xLa7T+w03F3jhr/oV2nGjtnKn0TppRyWs2sGCRz7AJPn3rNpfIUTw=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by PH7PR10MB5722.namprd10.prod.outlook.com (2603:10b6:510:126::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Mon, 27 Mar
 2023 18:55:41 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::9fc8:73bb:cc29:9060]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::9fc8:73bb:cc29:9060%5]) with mapi id 15.20.6222.029; Mon, 27 Mar 2023
 18:55:41 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>
Cc:     "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Stable@vger.kernel.org,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 2/8] maple_tree: detect dead nodes in mas_start()
Date:   Mon, 27 Mar 2023 14:55:26 -0400
Message-Id: <20230327185532.2354250-3-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327185532.2354250-1-Liam.Howlett@oracle.com>
References: <20230327185532.2354250-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1P288CA0022.CANP288.PROD.OUTLOOK.COM (2603:10b6:b01::35)
 To SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|PH7PR10MB5722:EE_
X-MS-Office365-Filtering-Correlation-Id: c7a2b980-3f92-4ed9-5406-08db2ef4dc98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3nOKyHfwgzCBvxY6vAyDTChqU40QzXUOidRXvEOl6O8qG9sud3hvi4NsY0XOGHugSQtXyAF8M+z8rbLJKhf0gSbvfm8Lu1gvJkW/0otWahOzJSkLUiCJxypR9mOdmBSHWa9ff4HwNWf8g5ZViAwbK1NocKlEIMpAQfFdepA6En8Qm6saCHrD53L34uxjdGGBuNjOf4xjzSGVFDCqI0BKWC5S8xnGMkGMsZIEmiqTFeyuAChJPc+d0Kw11Ttmf43wf7DK5nfPVG8681sdJGoAAvwVM7SChHEZLdoKlnqu/Btm+Ng5DE91W6FmZV3JN4mxMrYU3Pt4OSuvpXJ2BQiTbe+QKCL2bF+oPqqKvaAS36H6kGTUk3EtHt/iCu3j6gbV+z86sgYoLIQDhnRP+2WWgnpYkbSCsufSqPjDuMX6Hc1ocy6XoE1zBwWhGTeDiQxdyWyire5iG41WIabR87chbPWgL1Wy77D0MY1qD7uTRb11VZShJWaQ/qvkswU/zDYv2ehkYyR/16VB6JWXEJAOcU4TMmlIoyau1BNfLtbUhT0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(396003)(346002)(39860400002)(451199021)(2906002)(38100700002)(83380400001)(36756003)(5660300002)(41300700001)(8936002)(86362001)(2616005)(6666004)(107886003)(110136005)(54906003)(6506007)(1076003)(6512007)(26005)(316002)(6486002)(966005)(478600001)(186003)(4326008)(8676002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NZouSKIuXTuwvbchVIr4Ep9u2KII39NT7VX5Z7W8A8WEk3nkmJa+J/bBYFPH?=
 =?us-ascii?Q?zKrLWGVreTVnS/Yke4WmjpmvtZMGnBFZ7rDBM1VlHg1AAjhr/OAFh3F7Ezk1?=
 =?us-ascii?Q?ijOrsmXdwZVvqyvqzxgpHp0vCFA1nqul/eeWMsfxcEJs3msliF1mKYy0JhXD?=
 =?us-ascii?Q?pUpPoQ6lznqS/bzmuGlcU5CtucQLYwWsxkCJMVhfgFONBJ/GFwrRuF8iUIkO?=
 =?us-ascii?Q?Tu1Pzu1E9iJvlKJ0H8cl1uOVYqfNhC09Jcnn/qTOPnlIAxjLrvh/8YyQRL+c?=
 =?us-ascii?Q?UnvjaZN7Y8n4oLC4VzITOzpsk+2dQf8ZGOPcLApWZ27o1lOafIIMHF1So56m?=
 =?us-ascii?Q?mFbWXCXSODXqVAb+WWZkzcQp4k23uTG+IMdbc6Z7o7vOAThiAPJmKh+o9d/R?=
 =?us-ascii?Q?yx5kbsUNy53xpbYKSGuGUsPGbhG1mgLUwYJioLPaRGQQ7jEb/FGhBfwlEyqq?=
 =?us-ascii?Q?29j+4ZSMpdkUGz4UK9vKExNvPqsc4GKEw5x+CmQPnxZwMXbElf+KZW8VWfv2?=
 =?us-ascii?Q?rWDI9TVvEYl0CCS4QsLRasN1yhSEYxgsBwTWNxoKXYhisE1ID3RZLxhSsjwo?=
 =?us-ascii?Q?9aA/KQunrwbvA7r7WRmibatOeerMEZHDW7JTSLN3WoMmx6qSRplCP4xuFG6e?=
 =?us-ascii?Q?X811fL4LW3lqQY1eU6kMIPWJ2PGAtMQ9cyi3jMs6HvMO208jvMlR4NzoZ2sK?=
 =?us-ascii?Q?w1EkRCyQmxIDvflfcqqshK0VebU2OcEA0aPrhOjnKe28FLdGyVKAUNCYI6jO?=
 =?us-ascii?Q?tuM1DjJRowWIWaDp5GOBRNIM/fKPGmGyqgfbmq00tp7GruHu4XEMSSRF79H2?=
 =?us-ascii?Q?YljiY4nsbgAZZXXKLAJ+gU02/tFBwrmK3BY2u7875vWzBxMfpo8lvslBvtG6?=
 =?us-ascii?Q?bUOVHjQsakBX07KfxNVWvnEKyBKHb0YIKzMYVpTeG33/KeupBwmNh9ZxipVN?=
 =?us-ascii?Q?Yuz6dzpYpxUK23guwIyh9uA3iAyzldwfF347q9dG1gQjeqIB5KbHQ7hYUX3d?=
 =?us-ascii?Q?4YxOhFHCeY51CUqB61GKMzoW7lSRWGQaHT1n4qeXuLC79wCgcXkkJhP2Jii+?=
 =?us-ascii?Q?d7+zbvw4NYHuzVlqhBfsbZa7QNLcHBK3L1fyRIIKNcGChhM/q6C4EaXnV0Y1?=
 =?us-ascii?Q?4YhI2OHpVrA0MnNWXk2FeOLRxa4wjmCJny4tTtNXaos7Y9L4pdFm37njb+wh?=
 =?us-ascii?Q?Qgrh2+icFbj/gWZXLhpO/CczbrWfuiRYC2YHO7OFo6FRjCURHzEIkyiYCrZy?=
 =?us-ascii?Q?gaCfSPlG2fpZ3W6mnFYVgCAlNgeZJwBfWLHvulIEodsGhNYOHl2qp0MUC+HA?=
 =?us-ascii?Q?JCYVs2Vn4Yc5PlGjd3r7tyG4++UT2J8mnQNQQu+vqjch2zF00y3G/gzC2HrZ?=
 =?us-ascii?Q?toIXpfQ3nVAGamyMlKgYbgLYAoriWeZQqqQQasVLMGCPrH5gHlsBhzZWPn2f?=
 =?us-ascii?Q?tqwbghOwZoVfUIZOQIvDEt+5VNyBxazMmHaKoat1V3VLek0gD510IIDsMJWN?=
 =?us-ascii?Q?YSr82EibnnKBXkiOdbu2N9dC9yV39o1N7P6cicynQ9rYngZrWGiF0l5roTd/?=
 =?us-ascii?Q?DXUlZqT+lKuXG2kjFtumiYA+KXxTicLPhuPmCjVyTJkCwO7rqhAr1nSIqvwA?=
 =?us-ascii?Q?zA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?O666RhjskSpfdtFGNHv/p7Cg6ImDCprJjZpWlphOHv66JOwywEYB4f1fWyVE?=
 =?us-ascii?Q?Od+C8C3W7KBy5MbVIb5MARhS+u8RhIZgrRjEnb5esRxW7DTdKIK5N9ZDcFc/?=
 =?us-ascii?Q?vyH5V71KKuD/JKqApID6rvvcntLCg5E5mC6D3F1wGUzHySBdNINgo5cHvAQa?=
 =?us-ascii?Q?yjNWaHEe1E3oqA/zhU9gwu58v67squE7zhQyYikAiCt41yBgK4O8I1MXmIYn?=
 =?us-ascii?Q?dshMygJtQbteSx7qBgD06G59eTbDo9MAPHq7OcweGZiSY/EDs1ilwsDtUwjp?=
 =?us-ascii?Q?TXxbr25vUMj1A1WAWzT0Ku85/EiI0LHGZ3c3ft0jbnxEauggNhJNNqNikMQU?=
 =?us-ascii?Q?Y3GFYGSBDDyyR1T6pEz/nEKOrlEiSNaSru4dwn3QK83Ckak5H9PiWrmogNwU?=
 =?us-ascii?Q?v2pjhCFCT5cXIcgEW/8xGe/EtE26gg5RZeD+JpT1XOsLAvrk8NORltpnXB3j?=
 =?us-ascii?Q?1YgqzfVGpwyA9qB1202VynC9chffmjFt8FY/J9MilqT5jAkHB2e0nr5fKHyY?=
 =?us-ascii?Q?QEpSks+H/CfSTPpBr5H67OWJl/MBhC2b47WNuXEjIA3Zgma0lnyj5nuCSZky?=
 =?us-ascii?Q?NN222EJX+QWYcpss/1vNk0AEDtBjAJEJg0ez6+elW1JyfYpV9hOQ1/6SJwbo?=
 =?us-ascii?Q?XKl1B53i5QBLcbn7Zj6e6DIkcbg2SP0C71rC2KvVOnpOhSaZOVm+G6VfjvlM?=
 =?us-ascii?Q?7HpJPAHXM2356Usy1wKKvOiZs5A42rCdS+g3S7fdhJFISkeONtB4XaIIiNUM?=
 =?us-ascii?Q?/l3cL8IYL0QUNlYK6pE4cSm9LMluojYpbZ9fxVB9koK9oqDCiEH/ykNrhyVh?=
 =?us-ascii?Q?2DtwjpP0/cO6xrS1hFCh3b0lp3vKSkEKgqS4YM8Z9rm+5s7/RYNWCBXo1CL3?=
 =?us-ascii?Q?ZKxYg1IgLnWMSziJ31bZBV54j8gWgihedqK38ZAAU9PkAIyOJQZ+bKLh8x40?=
 =?us-ascii?Q?7XA/nDeXbzyV3cP0l6q/0A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7a2b980-3f92-4ed9-5406-08db2ef4dc98
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 18:55:41.2235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YFxtNsrMI3LtT7aDDdUXs2OXa9/aFLEG9luCk8tYIJKMGfospUCSXRox2Co+95ALLrTg6IyrXv1NZlnhndwo+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5722
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-27_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303270155
X-Proofpoint-GUID: Pfk2aUHPvirBIaIdnlN0BsjN5JGpijuI
X-Proofpoint-ORIG-GUID: Pfk2aUHPvirBIaIdnlN0BsjN5JGpijuI
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

When initially starting a search, the root node may already be in the
process of being replaced in RCU mode.  Detect and restart the walk if
this is the case.  This is necessary for RCU mode of the maple tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-3-surenb@google.com
Cc: <Stable@vger.kernel.org>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index cc356b8369ad..089cd76ec379 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1360,12 +1360,16 @@ static inline struct maple_enode *mas_start(struct ma_state *mas)
 		mas->max = ULONG_MAX;
 		mas->depth = 0;
 
+retry:
 		root = mas_root(mas);
 		/* Tree with nodes */
 		if (likely(xa_is_node(root))) {
 			mas->depth = 1;
 			mas->node = mte_safe_root(root);
 			mas->offset = 0;
+			if (mte_dead_node(mas->node))
+				goto retry;
+
 			return NULL;
 		}
 
-- 
2.39.2

