Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603606DDF32
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjDKPMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbjDKPMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:12:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B105FD7;
        Tue, 11 Apr 2023 08:12:02 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BEx8pG019804;
        Tue, 11 Apr 2023 15:11:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=As2pTY8AEIRrr3ZBhc3xaVfQxndlyj30QNcp40aojOg=;
 b=VUwKXmdHqSwbWwjpcuGjMoVsbDKGXNBp7Iuqxos826AmDZ+Ccs3OOey0SpsdPvGsoQUw
 MuyucYc9GBVSva/S75wUrcqcVp39ehjYCtJdnIe9tVxuqHwDFiq+3co8eGwVjtVtzRb0
 i4bHVSJOf51o8K5qHpAQcvNEROA87FRS6q+esJptg7s994jeSXZ0CP1aP0EGXpV2vplQ
 hoPhLoG9A9Kd88qHjSerwVlrCYXruq0nDLu9BHIkQnSckcQO5b4quHfwxjCuFQx75moS
 x+RTZQChtFe6rvTww03l0XPY1UeQaXZbp53FbjJmgz2J9fN/WTyfqFSGIz8jjix4ELn3 cg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0b2wpqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:40 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33BEStwi008056;
        Tue, 11 Apr 2023 15:11:40 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwc497fd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gpmwozvf59DJVdzuswDA3syUtRkIOvtR/p1exXm1My0FbTREv5ZgZhlOrJFu9sPnWchrrVGHKPGmmUKmIOInMZX1Bu2WlZtlH7jU8D7kK++8G9adcu10npGsx6E5KvtFayA2Jb3ICEXaut1S+xxiCgUp1qPU3F0lGapYfhkFZ8KbBNLoqX+vLpAJRPWb3El9P79ONEx9uDx6fciW/zEOEM3HXs5hHorGdAVt91oIQgE3ILZAqoKx7sG86Gvgfhj6f6WqEvXJvxMUGzIiO/iwDZCiVEUF9glE/b0z0TpMsJiEbfFvKHfVMdvrcb1is/CKpyLg1jjsgXzlh+x2Y0vBWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=As2pTY8AEIRrr3ZBhc3xaVfQxndlyj30QNcp40aojOg=;
 b=JEo7BVgX7zBDBBT+bZ0AN2quU0zQmWWAEdTC9V5Db+sih63KGZFQaJphj93/8TD8uJzvmg3veG5owerWnu5kmRIuS0FU8R8e3NzEKMVF7S4itQbgbjgBqemkedU3dmMSRhORw1geAQn/XTvlYQ7B3LWNzElZQKfA8Lv0WATBKb6WDXXKID2TGd6hfaMjtPfoNn/pszNaCgIoZ4Xxc/+jb+m6C86Ok/Ar6zqQ+gYDQG+xOjGKe4lydZ444uRq7BbbWBKbkyF7ZvlLaKehTfW6kJCjK/9yghIPjQacBJHfcemg2mUClY/KebM9OJ1hY+qfuMgcdZ1MfcOoune9bVY+Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=As2pTY8AEIRrr3ZBhc3xaVfQxndlyj30QNcp40aojOg=;
 b=P0OMqmse6XyimawsBv7RWjDEOo6TKDOTpXnQMyK9LzLzMJgo6CSQDAJYPVYZL6AiYDI74IMginwgjGA/ljgwCmS3P/X5fVVH92ZAnwVvLS/MrcXrWvEqn0wi6FVLw+X6TJKYdSrl3We/PxPJ22LSq0kJV+g5JdIrreFczLWcFX4=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SJ0PR10MB4718.namprd10.prod.outlook.com (2603:10b6:a03:2dd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 11 Apr
 2023 15:11:37 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6277.035; Tue, 11 Apr 2023
 15:11:37 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Stable@vger.kernel.org, Liam Howlett <Liam.Howlett@oracle.com>
Subject: [PATCH 6.1 07/14] maple_tree: be more cautious about dead nodes
Date:   Tue, 11 Apr 2023 11:10:48 -0400
Message-Id: <20230411151055.2910579-8-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
References: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0116.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d7::27) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|SJ0PR10MB4718:EE_
X-MS-Office365-Filtering-Correlation-Id: be750c4b-9fb4-4879-91e6-08db3a9f0bcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yRd/RKKg8gIqK1yRxkg+TakpD0YwDdmHMKPWBKN5Am3q2ykIFpW5ex39Y248g3TNwOHxOPtRM2nyzLZlvrzIIK5LCFr6JsyWiRaFSA+A6VZfxQTd+kB6+zXWFCn+la10r/p8BLhqb+5nSEL2prUgcILhwLhWauO/LNTPMdVAxKbia8Jb5bgFgw7puIBiPpQlVxhckRNniWy0ZPo2LiWcs/eG7c0mroTi0uFf+cDxbdsCG2xcNkxnutYZUMdlUv9rUB1VElTGOSSz8UImPwyjYQHcb55D1wXUdqF6BhdYuDqS0GqrgZpA43o/AM+Iy3134uDwfQ1xAvh6KO1ZZYt+tBM5DNr7NDnOB3rBku7md2UREm2W8rN640Tvi9hfsta66KHphxUsM3lZkcEUOhwaemWEKT3TgrnyrmJ6BeZniN8TTiVfLmZfgsCT0xWrWObHFJmr44Rb1vPDSzNUy3R9hR+v309otn6CokEEAAtEHhCkG2vjqanrBcVs1EqQixB6ntdEgbER1Mbgd0Xjs+vpsq5kWGExEZY3OR4s09E1H+tifIOFLhFolJEw6LnuNwIIw6WuLy4WLMokFL63nTK+mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199021)(38100700002)(6512007)(6506007)(186003)(6666004)(26005)(1076003)(107886003)(2616005)(8676002)(83380400001)(2906002)(6486002)(5660300002)(8936002)(966005)(36756003)(478600001)(4326008)(86362001)(316002)(66476007)(41300700001)(66556008)(54906003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FecQ8Ce4tkchlBTVOpcmyCF5T2YMFqtadKkxdjf6KCkNX/FhbRy5ZGlOFqC9?=
 =?us-ascii?Q?uef7cmNPWXBvpXCvI9FA+8nW8OSDclCRSjZPp3O0PEo/roZSlVg/aLM4yesH?=
 =?us-ascii?Q?7LRjCrXjV5EeCj7/KGD4zxqhuKRk9Mv0y/neAabW/b4g6lISE1qJ1J3W0lbq?=
 =?us-ascii?Q?USLtlEdvQaGDXInxqaqKoKFHnL28iacRhAsZCytCb1Rv7tXE/x7i637EENS2?=
 =?us-ascii?Q?s5q12nfL+7CDJnuIajNlYBy2SwiDSOhkOMmL82/G/HaeF2DJGpg1SDgU4sEg?=
 =?us-ascii?Q?DtmXjjR92PjWsJYe+r39GjbrN7dWqXmOkV78Kl+jupI97dRIKillcHnPr/Yu?=
 =?us-ascii?Q?rPmTeBTBYxfT+BsjDcJmhT3DT7WkN2oMehf9txgM4hAaYJczbDZHngluIRx2?=
 =?us-ascii?Q?uiI0ni+Whr0axo8ySou/fab+eIkrIsmwIumfh2kmp8iJoSGuH6LKsC7mYC9x?=
 =?us-ascii?Q?B7BcbChqugp70AFQ/S9kWLbY6uVjZjPrspQ9UJ9RK5EE3sBAnviIzooyE7xa?=
 =?us-ascii?Q?UVYW4pfYn7qTEkt37tOG3wyRd2dxvlWjwEsDBC0Twz47Eh0aKdupay+PtfIp?=
 =?us-ascii?Q?F3EKR8HNYSwOHNlRA7tnd6rIll/ZOhiU+/ZYmJ8gAOBsXSf2Tmbq0xJ++1Px?=
 =?us-ascii?Q?9oxdc/VQMmaNVYvK9QZLuOHZR2Tokf5hWDXSvRJqqONyZRTS0Qc4f58nfH6D?=
 =?us-ascii?Q?tOVrqrUZ0ZgXrGzcxmLVYy+h09/x0CzLv/6pkzBd+1pnamx6zRKMjIfNTL4Q?=
 =?us-ascii?Q?ROyYOZed0Xk1BG8VsAmPxYkPxxVDNHm3wFjme2OP/86gEoDzcNex1P5/Nb1l?=
 =?us-ascii?Q?nJYcEMbT8tyQvPLsu+AYSeGLRGRn65LXfOK9pITF/m87dvXHxgzhgAGB878O?=
 =?us-ascii?Q?DIsXW5uWsiYeAtBn9cOzA2ZDahKaPoMFOhpjktPlQ/XDYc9b3Z0RTiBiozSU?=
 =?us-ascii?Q?Nx+RgZ1ezW3ViYpR3yFINxBRPFNXMVBSCF03c8hLCyc0hvvzvbwk4XdkbK3s?=
 =?us-ascii?Q?a5tgQnpb52P326vq65oIP5hmbj7Wq+uVqcfC8opoZj//uVO1TQSjpy81z/EY?=
 =?us-ascii?Q?0nhHpoYaWu6PJPLXwBqfpkb93A96m2xsupETl0DCYQ1k5jxGYjSHZZXBJHCM?=
 =?us-ascii?Q?GuaNNzT6raO9jjVCq5KSO0ErbYaLZJBzBVA57fRQYK3XtjlwJVCqg48HY+8t?=
 =?us-ascii?Q?z1qpLq3zDCHmlm7uXqiqmmW39TCfdhS7AAN1t5DGZvfR5gQ2UINJDf0rmbuY?=
 =?us-ascii?Q?5a1/yIuQG1yjlshtrVJ/Df2gzrdoiUCA5VDvDQguZELXhr7Fg4Z7zXoZcrSp?=
 =?us-ascii?Q?Olya3YR5FdtSg5FwMqCgbpb0zDVWF9yRcRsFjoYRYt+IcvZFCctiz1gS4Eqi?=
 =?us-ascii?Q?gagVlWs25sIx+5CA3aHA8ysfoCA6ogV8nxitgU0wapgW7tG5oodikWLY3DvR?=
 =?us-ascii?Q?v+S2OPs6FTFKvsU6z76S+qC6WaCs9A6VU/8UvZaAAArgFX/4UTxahw1qxKwD?=
 =?us-ascii?Q?dtOepGvIC+u80QlDEQq7nUd261/+4VcEO8soEGaVcdzuEv+JGWQXgeOTb8fR?=
 =?us-ascii?Q?LB12zMqLyoJ156JuXaqBT8h8ZV8fRB+eAk4FOoWBtWXMI10ohu7FQa4YTON+?=
 =?us-ascii?Q?mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lGfIkFAcl1UOAXh3BD8NnsxnS8pxoLw16eAEqKuUv4GKyXNvybO0buBfi4A8ZIil34zuyi4XagpVceUPfK4LHe2yejrHBAn1uwwOwSFgdFj9fFvt/aa17zQF0M8B0eK8rJVjpCQ3L9g9RQh/0DuLSQALjy3KG9x9iDXVwn+jd9p9w7ggu3uEpwbnGzH+N/2OkADdThOgtScSOdcULQAv+iBAgyttpCsAg+U0zq/0/v6higCt4pNEX482OqpYwpai5VIy3BhpKYxwKTK1S4A1Df2Y2iZUt1Utib1wg4ku6vQ6L0Ndwh+o+xMhgeJqsWECb0RBrhbw/XEG8v8coh7lME9iaLR/+zICmKsx3q+zaLoMKB7L01k6UqNKGiZnhH+PTLkpvcHeGXTSurk4Ily6GMw1bSKJMB4+GL9xM6nNZEGdF2WgM+MZe4knLoCpgKDI1ugeOZgSn8AyDKQ/4+d4RmvCZHEU8cxpbwbpx+csrXE+2RInbnsc5WwwEF5BJMubiUNCdTcyZ8u6ss2noq3bQuTfAqT1mvvv73DRkq3HzIbi9YKeH55opMzeh3kt2Rxck0lg8dy93Zvm/5xY67ITrVAAnMuLw4u0r2FYP8PsUViMAIPFbjRCNuEqdVo30Z/OWGedsnX9qHb7GG/ofyzu1eFaSxr/TS2LL081qvKit6/E6Iub9oisYFd9K7n/XM4XDGtaVZSvuFs30ZrKfK2O81HYYBbQZCG3PaQtOfoA6NxzR+0eSIGm3clQ0/omU+J+iCbXqSclO/nn97EBGjvkarLSkGTIpSVr0glXi5IcrKzc+2T7RzLzJO6zjT7Ya4+Cef6SwikfRCeC9Nwb/umArYc5QSgOOL83yEV1JGdt9v7HUdljHmTYsEJb5QipJsnawyHAYaXST+RBw+snyehMsg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be750c4b-9fb4-4879-91e6-08db3a9f0bcf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:11:37.6722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dQLX95wOr5QVxT0XGWPlR7+kcOy5x16Mgg8sR8+10b32+Atc1juWXEGx1NhWYOu1AYThbjyBufxkDfwvit535Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4718
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_10,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304110138
X-Proofpoint-GUID: 9urhPGAPaAvGomgLE0kIvOYsj3za_B-o
X-Proofpoint-ORIG-GUID: 9urhPGAPaAvGomgLE0kIvOYsj3za_B-o
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

commit 39d0bd86c499ecd6abae42a9b7112056c5560691 upstream.

ma_pivots() and ma_data_end() may be called with a dead node.  Ensure to
that the node isn't dead before using the returned values.

This is necessary for RCU mode of the maple tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-1-surenb@google.com
Link: https://lkml.kernel.org/r/20230227173632.3292573-2-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Liam Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 52 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 9 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index c50646fcb8ca..7c8225e7df13 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -534,6 +534,7 @@ static inline bool ma_dead_node(const struct maple_node *node)
 
 	return (parent == node);
 }
+
 /*
  * mte_dead_node() - check if the @enode is dead.
  * @enode: The encoded maple node
@@ -615,6 +616,8 @@ static inline unsigned int mas_alloc_req(const struct ma_state *mas)
  * @node - the maple node
  * @type - the node type
  *
+ * In the event of a dead node, this array may be %NULL
+ *
  * Return: A pointer to the maple node pivots
  */
 static inline unsigned long *ma_pivots(struct maple_node *node,
@@ -1086,8 +1089,11 @@ static int mas_ascend(struct ma_state *mas)
 		a_type = mas_parent_enum(mas, p_enode);
 		a_node = mte_parent(p_enode);
 		a_slot = mte_parent_slot(p_enode);
-		pivots = ma_pivots(a_node, a_type);
 		a_enode = mt_mk_node(a_node, a_type);
+		pivots = ma_pivots(a_node, a_type);
+
+		if (unlikely(ma_dead_node(a_node)))
+			return 1;
 
 		if (!set_min && a_slot) {
 			set_min = true;
@@ -1393,6 +1399,9 @@ static inline unsigned char ma_data_end(struct maple_node *node,
 {
 	unsigned char offset;
 
+	if (!pivots)
+		return 0;
+
 	if (type == maple_arange_64)
 		return ma_meta_end(node, type);
 
@@ -1428,6 +1437,9 @@ static inline unsigned char mas_data_end(struct ma_state *mas)
 		return ma_meta_end(node, type);
 
 	pivots = ma_pivots(node, type);
+	if (unlikely(ma_dead_node(node)))
+		return 0;
+
 	offset = mt_pivots[type] - 1;
 	if (likely(!pivots[offset]))
 		return ma_meta_end(node, type);
@@ -4499,6 +4511,9 @@ static inline int mas_prev_node(struct ma_state *mas, unsigned long min)
 	node = mas_mn(mas);
 	slots = ma_slots(node, mt);
 	pivots = ma_pivots(node, mt);
+	if (unlikely(ma_dead_node(node)))
+		return 1;
+
 	mas->max = pivots[offset];
 	if (offset)
 		mas->min = pivots[offset - 1] + 1;
@@ -4520,6 +4535,9 @@ static inline int mas_prev_node(struct ma_state *mas, unsigned long min)
 		slots = ma_slots(node, mt);
 		pivots = ma_pivots(node, mt);
 		offset = ma_data_end(node, mt, pivots, mas->max);
+		if (unlikely(ma_dead_node(node)))
+			return 1;
+
 		if (offset)
 			mas->min = pivots[offset - 1] + 1;
 
@@ -4568,6 +4586,7 @@ static inline int mas_next_node(struct ma_state *mas, struct maple_node *node,
 	struct maple_enode *enode;
 	int level = 0;
 	unsigned char offset;
+	unsigned char node_end;
 	enum maple_type mt;
 	void __rcu **slots;
 
@@ -4591,7 +4610,11 @@ static inline int mas_next_node(struct ma_state *mas, struct maple_node *node,
 		node = mas_mn(mas);
 		mt = mte_node_type(mas->node);
 		pivots = ma_pivots(node, mt);
-	} while (unlikely(offset == ma_data_end(node, mt, pivots, mas->max)));
+		node_end = ma_data_end(node, mt, pivots, mas->max);
+		if (unlikely(ma_dead_node(node)))
+			return 1;
+
+	} while (unlikely(offset == node_end));
 
 	slots = ma_slots(node, mt);
 	pivot = mas_safe_pivot(mas, pivots, ++offset, mt);
@@ -4607,6 +4630,9 @@ static inline int mas_next_node(struct ma_state *mas, struct maple_node *node,
 		mt = mte_node_type(mas->node);
 		slots = ma_slots(node, mt);
 		pivots = ma_pivots(node, mt);
+		if (unlikely(ma_dead_node(node)))
+			return 1;
+
 		offset = 0;
 		pivot = pivots[0];
 	}
@@ -4653,11 +4679,14 @@ static inline void *mas_next_nentry(struct ma_state *mas,
 		return NULL;
 	}
 
-	pivots = ma_pivots(node, type);
 	slots = ma_slots(node, type);
-	mas->index = mas_safe_min(mas, pivots, mas->offset);
+	pivots = ma_pivots(node, type);
 	count = ma_data_end(node, type, pivots, mas->max);
-	if (ma_dead_node(node))
+	if (unlikely(ma_dead_node(node)))
+		return NULL;
+
+	mas->index = mas_safe_min(mas, pivots, mas->offset);
+	if (unlikely(ma_dead_node(node)))
 		return NULL;
 
 	if (mas->index > max)
@@ -4815,6 +4844,11 @@ static inline void *mas_prev_nentry(struct ma_state *mas, unsigned long limit,
 
 	slots = ma_slots(mn, mt);
 	pivots = ma_pivots(mn, mt);
+	if (unlikely(ma_dead_node(mn))) {
+		mas_rewalk(mas, index);
+		goto retry;
+	}
+
 	if (offset == mt_pivots[mt])
 		pivot = mas->max;
 	else
@@ -6617,11 +6651,11 @@ static inline void *mas_first_entry(struct ma_state *mas, struct maple_node *mn,
 	while (likely(!ma_is_leaf(mt))) {
 		MT_BUG_ON(mas->tree, mte_dead_node(mas->node));
 		slots = ma_slots(mn, mt);
-		pivots = ma_pivots(mn, mt);
-		max = pivots[0];
 		entry = mas_slot(mas, slots, 0);
+		pivots = ma_pivots(mn, mt);
 		if (unlikely(ma_dead_node(mn)))
 			return NULL;
+		max = pivots[0];
 		mas->node = entry;
 		mn = mas_mn(mas);
 		mt = mte_node_type(mas->node);
@@ -6641,13 +6675,13 @@ static inline void *mas_first_entry(struct ma_state *mas, struct maple_node *mn,
 	if (likely(entry))
 		return entry;
 
-	pivots = ma_pivots(mn, mt);
-	mas->index = pivots[0] + 1;
 	mas->offset = 1;
 	entry = mas_slot(mas, slots, 1);
+	pivots = ma_pivots(mn, mt);
 	if (unlikely(ma_dead_node(mn)))
 		return NULL;
 
+	mas->index = pivots[0] + 1;
 	if (mas->index > limit)
 		goto none;
 
-- 
2.39.2

