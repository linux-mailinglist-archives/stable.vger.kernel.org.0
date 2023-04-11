Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F2E6DDF2E
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbjDKPMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbjDKPML (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:12:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E4F5270;
        Tue, 11 Apr 2023 08:11:57 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BF1Vjc017666;
        Tue, 11 Apr 2023 15:11:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=PDBjrlh+TRcUjgAfuYBeZMR5kawflhtWx3wWP5Go75U=;
 b=zt4XAEDBnVEWTynpnx97DZ+4ylr9Wel0ZljRe+WnAZFdMR4B48fwAvMmT9JFCj6s+P/l
 ucEADgct55u6mKi0m+3cSEJoRDZMWGniwxA1hjSkY7I/bEOniRniEiyxZeY+8R3qdo0n
 3HjiI1VVo36cY8YSnYU2G0YNcPIPPvhdoVDY9M0ZntPF57M82GqAuueXUf6pNkjcLs12
 CVmzXKOTKdwGFPb8YCSSJib5TKERcRsagUzKl1Gtkp/XLL1mtnAzyB7a391KCdjI7beB
 2gypuTJb6O8uGWsi635ie3IQMXcZBQCfUcmD5ajj454OTrxgsRKmfaVQoTwb1jUjHFOZ ZQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bvwr61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:34 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33BEUx3C010013;
        Tue, 11 Apr 2023 15:11:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw870rgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gYPcxgtWbMhNpMI2n1zT3yGxYzBGQm9wTwTWadBEDwE55Vvq1+jVQL90pblXLWxgdvkoikdu9EZYOuDsHkIaQA73A4d/2jYRtxspN0Y0ekdD7hhwpPq43rINyBOyFQyyjomawEl7ROfMZztg6SntvSK1akYzxJcaCH9KUKLaU2bLv7lapVaTYkS2FxvTqov8ov3jH9Ek49X/+qS6rkE/m80GtS6BRYt9DnxNSOp/v3ndaZNuHn0L9R54fw+6Sm6MB2mc/KabcudXD7e99kPk+VahvGKpDuK6vItliDavHjaeYnnyfi7stLyBB8Qw2JAtociiKKGZcKWpfxf7N2ETGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PDBjrlh+TRcUjgAfuYBeZMR5kawflhtWx3wWP5Go75U=;
 b=c50Y4P/778kxbtKCACYg28hKpfJJtWa9CBluhSyF/R1aCiCYSOl312PO2DURq9WX3xL6LaBwuCqYUoqCdn4XDaOEQ0Drf0aV/DXmaT3fNibYk9vqjA21h9tl9mH1I9lWoE7hPSEdIUQ9z/rTrvzTgIX2QFuXH0IICJIlLyjxB6Zi8+JdEeUYfh25IYAxoXfPdm/JptBMz619CM6HE8VTGxCgfGgfmUGgCcykIPcQm+Xq8mwVJCAqdhFYKBkzzoiyzI/kRDec+CW0QFdINslZovzeRo0ccDmj7uWKqda1WXpWw+zh5/wvelvtswglTmPpa/3JcM2DUWiRRvX/ZmBWaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDBjrlh+TRcUjgAfuYBeZMR5kawflhtWx3wWP5Go75U=;
 b=cMEBvDmaRjgeBZ4t0a2zauL3sggH/4Ba33xJQMio/aRRoPk1Cw7qBiiO67Jjxhv/4k+4krCH4MJ0BBV1WF3QSDAdXEKwPyWyhSqKbfYrlyCBgOEFXZETzSYWNb6eqVVkxP9vW2mVrjJPvAG75nj5XotIBLNlYdR5RWc9MCsxmHE=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by CY5PR10MB6120.namprd10.prod.outlook.com (2603:10b6:930:34::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Tue, 11 Apr
 2023 15:11:30 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6277.035; Tue, 11 Apr 2023
 15:11:30 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Stable@vger.kernel.org,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        SeongJae Park <sj@kernel.org>
Subject: [PATCH 6.1 04/14] maple_tree: fix handle of invalidated state in mas_wr_store_setup()
Date:   Tue, 11 Apr 2023 11:10:45 -0400
Message-Id: <20230411151055.2910579-5-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
References: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0146.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::14) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|CY5PR10MB6120:EE_
X-MS-Office365-Filtering-Correlation-Id: 454e380b-c764-4b7a-1017-08db3a9f07ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199021)(38100700002)(36756003)(86362001)(316002)(26005)(6506007)(8936002)(5660300002)(6512007)(186003)(41300700001)(478600001)(6666004)(1076003)(2906002)(66556008)(66946007)(54906003)(8676002)(6486002)(966005)(2616005)(83380400001)(4326008)(66476007);DIR:OUT;SFP:1101;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 454e380b-c764-4b7a-1017-08db3a9f07ad
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:11:30.7287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w3/WrxyfXldYwPOb/KCUgzBsytFG7UcQOQnPGFn60kEoYCYxPMvwG4kI+pgj7eaVRtjIjTnRuOoXAlQZjr+qDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6120
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_10,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110138
X-Proofpoint-GUID: jmBk5keeSC1_cc_XWtuJN3rKRZzm0NgA
X-Proofpoint-ORIG-GUID: jmBk5keeSC1_cc_XWtuJN3rKRZzm0NgA
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

commit 1202700c3f8cc5f7e4646c3cf05ee6f7c8bc6ccf upstream.

If an invalidated maple state is encountered during write, reset the maple
state to MAS_START.  This will result in a re-walk of the tree to the
correct location for the write.

Link: https://lore.kernel.org/all/20230107020126.1627-1-sj@kernel.org/
Link: https://lkml.kernel.org/r/20230120162650.984577-6-Liam.Howlett@oracle.com
Cc: <Stable@vger.kernel.org>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: SeongJae Park <sj@kernel.org>
---
 lib/maple_tree.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 819ba692940e..50604fecd476 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5614,6 +5614,9 @@ static inline void mte_destroy_walk(struct maple_enode *enode,
 
 static void mas_wr_store_setup(struct ma_wr_state *wr_mas)
 {
+	if (unlikely(mas_is_paused(wr_mas->mas)))
+		mas_reset(wr_mas->mas);
+
 	if (!mas_is_start(wr_mas->mas)) {
 		if (mas_is_none(wr_mas->mas)) {
 			mas_reset(wr_mas->mas);
-- 
2.39.2

