Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAD06DDF34
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjDKPMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbjDKPMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:12:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE765FF9;
        Tue, 11 Apr 2023 08:12:02 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BF1VMf017728;
        Tue, 11 Apr 2023 15:11:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=AUVa6sK8DhZJT+qVwPZU2lRJ/B9yuxnT+mVXgCEhor8=;
 b=Quqsb/D0SyJBaBBYwxDPbGA5b9wh/iI1Qil7fal5vfi6xXQw+gFlNogIu6jd3ScF3+Cq
 D/1ZTG4KH2XFDWexP4tz5mnGDvHzb1X9cJVY36C2qeFhiHgvL+DDZ++m0yjC3aqn7LDc
 CGWmTh6tD+u0AVUuoZlWK0q1mB8otca+pKi5m+465M+e3bdXDJS1YHWboetYg7jvYplT
 QM3XVqJGNh0wetJ5+JiOO/rzKisAqczxyXPnS/Jpa6GV14Z0YW+UaeCF1qSAP6Y66kK6
 HOWocZEPo8U94R3OKqP2EICcNo+WaWd70uBmeJAvqXU+wlaZhaRHPWO2i66d50ELG+8l aQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bvwr6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:42 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33BEQNaP009895;
        Tue, 11 Apr 2023 15:11:42 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw870rsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mCSGoHRwT9msyiUy/RnxIGOoZXsekuSvkECIpDE4NbafJCGdFugNMP39ZqKWuEYdEnP9iizcztB/FpnTpYVV9ElBtOUqCvIQe/ddEgE6EkOfd9a7o7MpYlk2nNMbSfrEb8djd5cGM1Jqw2jUzz5d2P0R7c/xd5lwWWLjhDzJ1gID3S3jNkUnezvGNKCPBEBoQ5m0iTQg4HmdqVC+GdWM8COAzidJTYmzZe/xur5IWtVxo0FOE2gh+LBMsXQS0IECIpbcOBvTqo+rd5Swv/sshYzPcSR8VvPvdf9gGEjxzztjwT2M8DktkbheJWzk7cO0OMWBgtJWJdtV5EqW2VSr2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AUVa6sK8DhZJT+qVwPZU2lRJ/B9yuxnT+mVXgCEhor8=;
 b=gWh+ueuhd4OB7jSwLY0sDIsSqOmdeUPEdlLXdxw4IApAdy7MK/TzjbZNkgnfjyyFmVVaOWmz/ey7mcLWjhkw9+7kHH9zzFT3wrq1UQSz7lSUFm364N+IMH2d1cJFb5d8Fv6oaPrLGsZdWveOOkXx68oq+IUwEf0Y5JMIe3TideBYNj1wmT8u7dj6pkshUtnqvRrVm6SgftzTRPMPrBr4t0iyWHhnTH/PBeCRI6NzyN2qMH1/UFu0j14WHB+OHoHav2ss/AgW5wpqKnyriqpKETATgM03bVb2fOeb/NwqxFxoBP+fLwUOibIGHQaBuzJcMU8mtjyNj7viGI+fvrrbtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUVa6sK8DhZJT+qVwPZU2lRJ/B9yuxnT+mVXgCEhor8=;
 b=vS0iys1JafNnszhxjZQHB/Ef1sWp0TSiGlpKdMnaaoxdKe6DFTF/GN3VAYKcsUr269zDbKcpjv/oazNtEwmV+sZuZwjI6ByyjOSBLvMhtqiB0FvkpmnINYwZ8rdGeiP1XHeOm2UO8Bip9i+tHK/vJAmZp17tO061MvU9GxRrrn0=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by CY5PR10MB6120.namprd10.prod.outlook.com (2603:10b6:930:34::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Tue, 11 Apr
 2023 15:11:40 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6277.035; Tue, 11 Apr 2023
 15:11:40 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Stable@vger.kernel.org, Vernon Yang <vernon2gm@gmail.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 6.1 08/14] maple_tree: refine ma_state init from mas_start()
Date:   Tue, 11 Apr 2023 11:10:49 -0400
Message-Id: <20230411151055.2910579-9-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
References: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0269.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::25) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|CY5PR10MB6120:EE_
X-MS-Office365-Filtering-Correlation-Id: 103fd59d-afb7-4677-15f0-08db3a9f0d60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199021)(38100700002)(36756003)(86362001)(316002)(26005)(6506007)(8936002)(5660300002)(6512007)(186003)(41300700001)(478600001)(1076003)(2906002)(107886003)(66556008)(66946007)(54906003)(8676002)(6486002)(966005)(2616005)(83380400001)(4326008)(66476007);DIR:OUT;SFP:1101;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 103fd59d-afb7-4677-15f0-08db3a9f0d60
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:11:40.2646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hdzR5p6TgTHrJZ+lMaCQLARlP3JaXafj/NSQ0pzcU56fPBIP5zySQrrSB6SLhIQcSgDII+ZmPebU110vMWsQ7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6120
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_10,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110138
X-Proofpoint-GUID: aWYkKSaky-7VOdy5vVNE1bqOSTeTrv4y
X-Proofpoint-ORIG-GUID: aWYkKSaky-7VOdy5vVNE1bqOSTeTrv4y
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

commit 46b345848261009477552d654cb2f65000c30e4d upstream.

If mas->node is an MAS_START, there are three cases, and they all assign
different values to mas->node and mas->offset.  So there is no need to set
them to a default value before updating.

Update them directly to make them easier to understand and for better
readability.

Link: https://lkml.kernel.org/r/20221221060058.609003-7-vernon2gm@gmail.com
Cc: <Stable@vger.kernel.org>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 7c8225e7df13..194963149c2d 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1334,7 +1334,7 @@ static void mas_node_count(struct ma_state *mas, int count)
  * mas_start() - Sets up maple state for operations.
  * @mas: The maple state.
  *
- * If mas->node == MAS_START, then set the min, max, depth, and offset to
+ * If mas->node == MAS_START, then set the min, max and depth to
  * defaults.
  *
  * Return:
@@ -1348,22 +1348,22 @@ static inline struct maple_enode *mas_start(struct ma_state *mas)
 	if (likely(mas_is_start(mas))) {
 		struct maple_enode *root;
 
-		mas->node = MAS_NONE;
 		mas->min = 0;
 		mas->max = ULONG_MAX;
 		mas->depth = 0;
-		mas->offset = 0;
 
 		root = mas_root(mas);
 		/* Tree with nodes */
 		if (likely(xa_is_node(root))) {
 			mas->depth = 1;
 			mas->node = mte_safe_root(root);
+			mas->offset = 0;
 			return NULL;
 		}
 
 		/* empty tree */
 		if (unlikely(!root)) {
+			mas->node = MAS_NONE;
 			mas->offset = MAPLE_NODE_SLOTS;
 			return NULL;
 		}
-- 
2.39.2

