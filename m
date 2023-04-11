Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D612A6DDF38
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjDKPNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbjDKPMY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:12:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CCF5BA9;
        Tue, 11 Apr 2023 08:12:03 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BF0rEO016812;
        Tue, 11 Apr 2023 15:11:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=CVmYIVax1Vnyg2HtZbsYqbTA54JV61exTJipRe9E61U=;
 b=luUxPGbbpuRX552nvf1yThtYWVdj/pChiYPbs8b5VJHo20o5wbpAIxgRZIOE1jA8ivtA
 co80kO/CwpTpw4Wc/Wr5eByB+bQO9JpRL8LjCe342a+ML4RI8k2dVa91s3HkSvNOtlG7
 FBemwsW8T/niUuSrdNqIbgZx+3Si+zek3ff0YHrxHO5Huu6Cjdc5PikKmHfTLhseSDAb
 ye1cPmVOEcHXD8sXuUT5RNgri/xuC9knGpnMDWytHac1PwIvWG7s22vo99Cduv9QuVTy
 RBIyT2y5AAyfPwzogeE/KGl3MA3BcJ12UcEiNxL+JziECSHFGIqpxrMeq63x6uvdqCqk mw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0hc5qj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:45 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33BEOV7g030894;
        Tue, 11 Apr 2023 15:11:44 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puwbn8g75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJZT4b55McYl9rqwgpwkg7S28bYwKPbkDkchApmvvEO3tNRIW0SYlec3etyHZYDooXDqy0AID5LLmNgOUVokaPAnGMrqO7PAShAAisPhmCKfHUbIETgnFC5EkWIMsjfOZ7PeLIQp5yfRIMKVWCmoNY+VxBtPk/J5G+wLmzSG4D3fHFaAjRorfLuVJzu3RZDFiRRKZy83nVcUeBRpV08GLzNT6KiL1UqVMI+s7xWTkIEKp8te/ywLzEhY4rTuHY7Dtgfq048w71AEvFwohpRYzAfKfNNjJEKOoHEa2fmluZZoFU03ZGNniLpqHLx4V7SHhtcXUsziPrmuaJGxxVk+MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CVmYIVax1Vnyg2HtZbsYqbTA54JV61exTJipRe9E61U=;
 b=gqOqCYDvmKcIemq1q1NfqXkJx4N+XUFlx9vZEQV8+e/XRoRujgQ8HmEdUnPslEuF/Wi5a+wCbr3Ec2ArQsZxoawmeXrFWsEj3DilSVN3GaXGX+UJZoAVlpfp3gzqZVN3rlRL/kmb1NsG4UCj6Xe/LfdpZkU72/Lw1b+scQz7LzdChuz4/Y/T0/ef1sGfW/GsuMJ1djAxTD6p06u3u8TSqp2d4ez8YXoPNDeBAXEQ2FPLO+r7xRfCtUXqopDeCcospPkX/i4MSXeGas7Dt0LlIvSKm9zG+y1xjfOdNmS5Xshj79jv7ngiGY5uB2nTS4Iad3unak/h36Wf22QFWNFVrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVmYIVax1Vnyg2HtZbsYqbTA54JV61exTJipRe9E61U=;
 b=Y9FtvLgIn6sZbZ/rwnIMwdggsk7Ac98lyFhEfTNHs6KjiVXQZWS6JjnzyxOn5D3o9tN3uVVs4WuFsS9Yd2A5HVV87Cqy/mGxDm7gWvbxmwFUirSNXuAuHQwO7ozio5PfYa2XySfIw1cbCaiikIccguKTZkbipBAlG3kc4fT9cdU=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by CY5PR10MB6120.namprd10.prod.outlook.com (2603:10b6:930:34::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Tue, 11 Apr
 2023 15:11:42 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6277.035; Tue, 11 Apr 2023
 15:11:42 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Stable@vger.kernel.org, Liam Howlett <Liam.Howlett@oracle.com>
Subject: [PATCH 6.1 09/14] maple_tree: detect dead nodes in mas_start()
Date:   Tue, 11 Apr 2023 11:10:50 -0400
Message-Id: <20230411151055.2910579-10-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
References: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0263.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10f::15) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|CY5PR10MB6120:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fdfc090-8307-4fb4-751a-08db3a9f0eca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199021)(38100700002)(36756003)(86362001)(316002)(26005)(6506007)(8936002)(5660300002)(6512007)(186003)(41300700001)(478600001)(6666004)(1076003)(2906002)(107886003)(66556008)(66946007)(54906003)(8676002)(6486002)(966005)(2616005)(83380400001)(4326008)(66476007);DIR:OUT;SFP:1101;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fdfc090-8307-4fb4-751a-08db3a9f0eca
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:11:42.6729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6kiPgRT5xvy3yqAcIrLwkzFaytAPC17enL/cPAIOob1njuO0wpUZCWOIAD98SBX3qFo/Z6SJEuqb27SNGVmy2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6120
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_10,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110138
X-Proofpoint-GUID: XOPPqxTTTKZt4G8uS5PLnlRUiHAk71GF
X-Proofpoint-ORIG-GUID: XOPPqxTTTKZt4G8uS5PLnlRUiHAk71GF
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

commit a7b92d59c885018cb7bb88539892278e4fd64b29 upstream.

When initially starting a search, the root node may already be in the
process of being replaced in RCU mode.  Detect and restart the walk if
this is the case.  This is necessary for RCU mode of the maple tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-3-surenb@google.com
Cc: <Stable@vger.kernel.org>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 194963149c2d..6fcf08dbdbf9 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1352,12 +1352,16 @@ static inline struct maple_enode *mas_start(struct ma_state *mas)
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

