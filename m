Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDD56DDF28
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbjDKPM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjDKPMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:12:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29A75BA1;
        Tue, 11 Apr 2023 08:11:47 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BEx01v023047;
        Tue, 11 Apr 2023 15:11:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=1oOOUTfb248IgqNS+xJccQHN7l3v7SvGWHgke9MYpJ4=;
 b=pg4X8opnBVAUvGweLkT+OuQx/6hjXDOdAUsmQ9WQABfyzT4EOxyhpuF3fydyV62je8Vf
 0MPXxj51m09E9FU6M0zbyjybqNCdAE3LZxOYyA/KncqpffN10BMiJmcZeseWzZxQkkkB
 G7QE+5H6xiWokZL1YfHRCuBNbsA31bR5WibdgToorZ1VHH5F9r18bIxHQg6Bh/boLJXd
 VMeFY3+F5NK8GV/42s0n3uGfZm+5/fHIwYXjQd4X7UQEVvmpRh5X7SSynhrbxDR3A4GB
 Zq0O2S2RHVVrCevxpAUM5ENXBKkUl4AyWdBc4gBI7vnuv0ntt0jfJLEIXgUH4UOAto9H 7g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bwdrvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:28 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33BEV8xL030604;
        Tue, 11 Apr 2023 15:11:28 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw918d1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mtJrRe9EgBHLa90AkNd07cZEmJeptKNKiYBkmPXfgTO1ODxmyIqGKzTH66TZZ7bU/ES4YDtP8ejvi4zg73/HWWJyZg0ajJ/FVmK5nmzxgTkn3uJ7UJ5sRM3Vh3RPu2QGBijbWAB5zXuIE9x6s7FQM6NZ+EUD218BCQ6OTTS5ZkwD+nd0tJJtVHG/iAKFUTLVubpK1sQ4rU7gUEqJmHKSAQHhzhAkNwW7CkQTXnSGqofAq5S45pdGZ5KoLASfzMlhlA8+Z/axAMFYzJaJdGfGc2KLc6rEWiehkUYqav2VEaxNqiKn8Glqb5PSA7WGDydMTKpVNAizkCyG6kGy8VWJEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1oOOUTfb248IgqNS+xJccQHN7l3v7SvGWHgke9MYpJ4=;
 b=M+Ybg4aQ9m9KLwTp2gt7+b745t0EraeXdj0SDpVH6YkKiSESaHGIYLeg5xyxYn2KtfRZUlWobDNYRniaAOpMY9tAYRf0Oqj70jKs27lwiFeImj/OVj7PpThuIb98VYZK5mmyn2lqEw39pXe+cdFbN/duUjKFjuC5FCQji/XVdzBsm7SlKLOB7E+upiwQnZNtVoIS138q7sKqd1RCaRpdEb0ijB2vX9gqiOT+yK7cu8wpkf4OsoAGJOX4v8BA30QKQ/fY7tX3w0lYN2GIuvEJyKmv+HEhwM/bxmtEMlrIdoJKCcmNY+2tNTbZwStw3PsvNHJ6yKOHyuAL9PGMxl7G8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1oOOUTfb248IgqNS+xJccQHN7l3v7SvGWHgke9MYpJ4=;
 b=XFIHdVvqIZp8419flTY5B0PSZx2wngseknfcrqQwelErnfWJRNf+rLIhXROsdNxGKmVnRDe5NHHUCkuJFTckZJR1CrWkRhFRp8N/ZM30GL7VgIktjEOW6PR1rMD7BP4glnLb+gizKpgnTEkf5t+g+F6DkKeHu6yFDb80Ps8sA0k=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by CY5PR10MB6120.namprd10.prod.outlook.com (2603:10b6:930:34::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Tue, 11 Apr
 2023 15:11:26 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6277.035; Tue, 11 Apr 2023
 15:11:26 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Stable@vger.kernel.org,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 6.1 02/14] maple_tree: fix potential rcu issue
Date:   Tue, 11 Apr 2023 11:10:43 -0400
Message-Id: <20230411151055.2910579-3-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
References: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0067.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:111::22) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|CY5PR10MB6120:EE_
X-MS-Office365-Filtering-Correlation-Id: 2042f5da-d54f-41af-3d4d-08db3a9f04e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199021)(38100700002)(36756003)(86362001)(316002)(26005)(6506007)(8936002)(5660300002)(6512007)(186003)(41300700001)(478600001)(6666004)(1076003)(2906002)(107886003)(66556008)(66946007)(54906003)(8676002)(6486002)(966005)(2616005)(83380400001)(4326008)(66476007);DIR:OUT;SFP:1101;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2042f5da-d54f-41af-3d4d-08db3a9f04e4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:11:26.0399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 45gvSy/vd0XjocjDxi2MetBzSansUMotXV5Lm6JhjeuosX6zIzLFvboq5z+Gn/oVf4Yw/AkzT0pG3uR8PjfWaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6120
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_10,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110138
X-Proofpoint-ORIG-GUID: pncVu0SrkRU-YFmmzaZN2TVGQq9sFiip
X-Proofpoint-GUID: pncVu0SrkRU-YFmmzaZN2TVGQq9sFiip
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

commit 65be6f058b0eba98dc6c6f197ea9f62c9b6a519f upstream.

Ensure the node isn't dead after reading the node end.

Link: https://lkml.kernel.org/r/20230120162650.984577-3-Liam.Howlett@oracle.com
Cc: <Stable@vger.kernel.org>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index fd824b065ace..1ade7748cc9b 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4656,13 +4656,13 @@ static inline void *mas_next_nentry(struct ma_state *mas,
 	pivots = ma_pivots(node, type);
 	slots = ma_slots(node, type);
 	mas->index = mas_safe_min(mas, pivots, mas->offset);
+	count = ma_data_end(node, type, pivots, mas->max);
 	if (ma_dead_node(node))
 		return NULL;
 
 	if (mas->index > max)
 		return NULL;
 
-	count = ma_data_end(node, type, pivots, mas->max);
 	if (mas->offset > count)
 		return NULL;
 
-- 
2.39.2

