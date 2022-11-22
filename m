Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528BC633AC2
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 12:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbiKVLIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 06:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbiKVLIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 06:08:40 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584B22EF5E
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 03:08:38 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AMAhXLm001020;
        Tue, 22 Nov 2022 03:08:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=hI9f4Q26kTZ1jkKZtB7srzA2PiAIdkvWz76omMrPmh0=;
 b=bPmPrQ7+iaJQJvvNkaviCS0+7t0coQZrKBhiysMzCUM9bBAobMR9qJRNtAilDXqfMUuP
 D/zxYxSwSOdx10MXW7pZ2saO/Z7khU9lgbF39wfDUknNIWK4oKthuefRBYfVInVqlhFV
 coMt9hTIUcRs9MfYz0BEQMq28hMA6WRwK+WtWKGE96bSUgw+YcE1lLoJKG+/QCa9mEAI
 HIHd33jwnC0loz+nY8T3Z8P0Y8CMXk2GKoLdFXA9hLMHqckt8nYxYgrvqskV3NWIgPqV
 HKREGK0MP+os8AJm/BIP9rh+O+GRB2Tfp0dMpttGwWfL0z1rr7/spe/YhvoEIXhJ4HNv Eg== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3kxyhqa7ed-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 03:08:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fjpgEqd0/8zUVLGimYPWc86g6HlgclnA5xL1HUMr0nvoJiLpHM5fE3Ri2e9j/XTBnt8PvqiABQMqjUjlZ5QSrVOjC5aU3ET+OysUhxIdS3jeWdAQdWE6i7v/SAWocJmNHzD/ZQgh9Q0q/AVJJ+oy3sRscRpWHhv/M2pFHo8EAHoWPqHFlFSdxhh6qaASSl9o5pfaLilOXfL4vInhdUvd6jQO9+9gqnlmbfw7rc8ca7LpBQyLARqMFzJXMHfcNdpWuQB6jrj6Vb769SJxK1OG9mNzM3oWuPcE0av4m238t2Mey7iE4cLP5arJcEAp8IO8mixY5WsFTkdS0uEJfstCRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hI9f4Q26kTZ1jkKZtB7srzA2PiAIdkvWz76omMrPmh0=;
 b=mR2G8cSS0Ru280PDoMeHiQPRuAo6B5ATVHDW/TBnfmZpP0SDONKaBNO+7Ifkz9s4wpoc4JAh1dDFKohS/oBLcuISTKjDwD+ruQLPoahrK4X3zE4/BQS3QuSdhyjl/G4peeo99TKRuI9OTHl43yxz3YSAWrzRFpE9UmOaMT5ZtXB6sG+lMx30Ti9z8a3FD9/85Lj5pHstrABPu5y2KgQ3klsA1Q+Px2Pq641YGezgRD+JXOTO+5P7JZvskhQ/dJiKVNAFkst/zCQjx7sZNHfkNlb8DdFNR6Mdg/OdF+pycDInd+ycXGdif+SmUgxdxJWNJJbFW5TXp7kt9Ve7jc6RXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA2PR11MB4985.namprd11.prod.outlook.com (2603:10b6:806:111::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Tue, 22 Nov
 2022 11:08:31 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99%8]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 11:08:31 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 6.0 2/2] nvme: ensure subsystem reset is single threaded
Date:   Tue, 22 Nov 2022 13:08:10 +0200
Message-Id: <20221122110810.3568811-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122110810.3568811-1-ovidiu.panait@windriver.com>
References: <20221122110810.3568811-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0157.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::11) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|SA2PR11MB4985:EE_
X-MS-Office365-Filtering-Correlation-Id: eab08408-2ddb-47a8-5d95-08dacc79e3c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MYr3q8jjRhuPs5G1HSlsFoWA3rNgDJZC0R6SwzR4ATlkIoUxnwZuanfPyKpCibrFPF2Nz/IlgIYzvaSSEg/lVyddqy8w6EMRZ3I1f2rcbp5Xt6xseixbAv4DY8w42wOEFcnkbac9VPJrHqWGbovjSr6Vl1GoXaNtILLwEvNUiBL+/vUmgL4EBleagP+5uoVRrKsNc4c+AMrWMsmuK0nQlb7Ak2Fwi7s67I9Nukm2QIieWU2WluAht9EbCpfl0i08HpBBdftpEU7eK0/sjX1xpfydnmv1Kz0gXT5uwpwUQq7TsSLhBn3NymzG1uj3JB1m37OTCbZjpL7Ufisd7nWuNk1VKSgrRKWmrSCjXrKyyABIgZIt/09X4C7FOG1UqTK8e/9aa6JiY2Xxo+mzR5oUcPKJNPJH9zLJT1OUJW8tVvEyLX0nmYfpmba/1URTJlttTjeg80VXg6EBXm/MKBKKAVRtvwYd8kejVKHBb7LdmOZuNxYMQT2+/hNqbRkHO5Iuoh5gluY7ccDuzLSGxXWUF7lO52B0wK1n7XvdxXTBjGRo9V9KzZUd7L11ipKK1B7B8xx3PSd4bBfs8HAuhgqjv0qstscNHuNDOXimLWL6Uf63Rxl+83GWjBP7kKaGLcpBUyHX/UbxSCfhQRu05ekJcJDMKrJoEXFGuI6iNC/o+x5oglmRtdMu3FPiNqc8+SkueBNGlyi+DdFm4FJK8UBkIIQcqc9QtHmEDg0jW5E6yGY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(396003)(366004)(136003)(376002)(346002)(451199015)(26005)(1076003)(6666004)(2616005)(52116002)(6512007)(6506007)(186003)(36756003)(478600001)(2906002)(966005)(107886003)(38350700002)(38100700002)(83380400001)(86362001)(6486002)(8936002)(66476007)(8676002)(66946007)(41300700001)(66556008)(44832011)(4326008)(5660300002)(6916009)(316002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tQA3v2zOHId1cMW2B0zOOIIV+ovxiyDJz7Yp5BAmUjS7i/PB/wTyytCyTq7K?=
 =?us-ascii?Q?HxU2W4ZYsE4pz6bFXPOZbkIRD4Mi+aT179YjhZoq0o4fd9rkLLZR3F93XwU5?=
 =?us-ascii?Q?16KU7CEOyvex0Wc45/V0El+gdh1aQcntDX/QYczUsRfXhR10C1OtXuVTvEaj?=
 =?us-ascii?Q?nNVV8ER4Vs10am/0U++EMVTq4kandHS1XkPxohNFicTE87YiZbbHjrB9B9wc?=
 =?us-ascii?Q?7Oy3gWRsCD4A5fcT9Z93dRy3Wu3GhR36Yv0GsG30eGMinSHUfP4adGT5Ilnm?=
 =?us-ascii?Q?RJQVXoVxLtiNbqJxS5BB8+RwcKtkbi3M+fbd6Kqn2vQKNT/h9B4VkK+GHJsO?=
 =?us-ascii?Q?OtKeZ2A25rao3VwG43ha4E+o2VNR+1gjWbMyZ4+0sG77v7F52m/V4TD+t61k?=
 =?us-ascii?Q?mUWhc2R1S+zHSa80BFpdpuTzvFNF5bzihcZo05Da0O3bP0pFPQEvyDdpRbzO?=
 =?us-ascii?Q?OCes3DVxVRggMcF24IrsxwXH5XBi7UQzU8CMiklxYzS305uNOfIgGCwzqIrI?=
 =?us-ascii?Q?N4nJXNlkevel7H1NcKnTmHK+DKuE0fLXFq0JnLoSKJmuV2q7uCXHZj9kX5tn?=
 =?us-ascii?Q?7mZC/1yeM8nBMaX41FhIPzrsDiD49wBOAsarIInoAp0zyLc6WtjTvhl2Ibjs?=
 =?us-ascii?Q?1qoa+zhA0DzjeIlwF5d72jQR4qQVvD3h7UwisTUNDIWOOo5hlKYQ4XNknM5t?=
 =?us-ascii?Q?Udaum/uJSzYaQdw9gjy7ouCsxH3o6xgq+8350mlQJR3cRO/lCoRzmYGcz6Qe?=
 =?us-ascii?Q?I1FXI1KDRF9V2Qpr86QtHNPaf7SN4Ivh3XvzUVbQ85ZJzyCqb21oI8EoSryf?=
 =?us-ascii?Q?xqp+DLfTwAWebi8Yr3bQo9BtKo3DfIMXHCd+MJOF1f3/GyRu1LWyQ/j0Gvht?=
 =?us-ascii?Q?vkPCKKiXzyhFmSmcjh9/T0XwwbRIe1tazI8LO7+DISdgj73saJ04ANLH4kMO?=
 =?us-ascii?Q?sDf8SFhtmCHW5YdqCquULFFOaxF90Ff7lblz13b+Za/4IruM9bI/m0zA4K2r?=
 =?us-ascii?Q?+0Q7EIZMZzKNx1/p8UYE+7S02qs9S4ll9Vle1sw4WiLsKgTk9qogt0yhe7+C?=
 =?us-ascii?Q?EjCqO4vv7HMc3/C8v+ps+mlOXv0q8gnTlx9nRbEq97r3jAPEyAjwtlTTMbbJ?=
 =?us-ascii?Q?0Uu6mNIJoI5ZIcfAk5ENl7beH69rh4ATmGQgliBQCpb/FCnR3oBsuTjM5hLW?=
 =?us-ascii?Q?ISMWkZMnr9wogkYRJarfIyVVmy0B1WMdP098lZMELdCWoXtBQ+FsRzd4lyqj?=
 =?us-ascii?Q?ovxnchnoOZoF1IWbggA0pkNkpy0WT3teR7sUiiJpq7xkUGXC8IyC2LamXnl9?=
 =?us-ascii?Q?2d//ASMKyrDB5BiLp3YXpCgSBXccGPBSUjjDf75e/NyHjPLOAnZ24Tj4Bf13?=
 =?us-ascii?Q?7Dt6vHRrnrFclRY0/DuGFEhCSn4C5JESqQ96OqOqtI132risakfceDa7LQEA?=
 =?us-ascii?Q?b1cHz4pHWMTCdJw+923lUHcR/chJZZJCQRSBkbbaaUXkT0MNU86vj220yn6y?=
 =?us-ascii?Q?pogqG9EvjwLN3h63/EUv+iIGExjbXZhnSDVwAYybGgtG101P42wEp9l3lm6m?=
 =?us-ascii?Q?NrFtoQNuB+KexdLFhBSL7bOy1UXa4inaePfISQ+9fGl0E3lt9VNu6x4Q0YcD?=
 =?us-ascii?Q?ng=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eab08408-2ddb-47a8-5d95-08dacc79e3c3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 11:08:31.2874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x0shDAzWSAPPDPdkNHfGahuyD/IENwphkhEy4oLw11UmlgZWlKtdrE12ZbEygpJKg+8ei3OcRYCCSmZ/RZHu8+7zdSRp9Marx/hgHsmw2d4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4985
X-Proofpoint-ORIG-GUID: rl2cdY5XggWhVGrfVVnd48xLMMQ7eGYM
X-Proofpoint-GUID: rl2cdY5XggWhVGrfVVnd48xLMMQ7eGYM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_05,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220082
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

commit 1e866afd4bcdd01a70a5eddb4371158d3035ce03 upstream.

The subsystem reset writes to a register, so we have to ensure the
device state is capable of handling that otherwise the driver may access
unmapped registers. Use the state machine to ensure the subsystem reset
doesn't try to write registers on a device already undergoing this type
of reset.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=214771
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/nvme/host/nvme.h | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index a0bf9560cf67..70555022cb44 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -602,11 +602,23 @@ static inline void nvme_fault_inject_fini(struct nvme_fault_inject *fault_inj)
 static inline void nvme_should_fail(struct request *req) {}
 #endif
 
+bool nvme_wait_reset(struct nvme_ctrl *ctrl);
+int nvme_try_sched_reset(struct nvme_ctrl *ctrl);
+
 static inline int nvme_reset_subsystem(struct nvme_ctrl *ctrl)
 {
+	int ret;
+
 	if (!ctrl->subsystem)
 		return -ENOTTY;
-	return ctrl->ops->reg_write32(ctrl, NVME_REG_NSSR, 0x4E564D65);
+	if (!nvme_wait_reset(ctrl))
+		return -EBUSY;
+
+	ret = ctrl->ops->reg_write32(ctrl, NVME_REG_NSSR, 0x4E564D65);
+	if (ret)
+		return ret;
+
+	return nvme_try_sched_reset(ctrl);
 }
 
 /*
@@ -712,7 +724,6 @@ void nvme_cancel_tagset(struct nvme_ctrl *ctrl);
 void nvme_cancel_admin_tagset(struct nvme_ctrl *ctrl);
 bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		enum nvme_ctrl_state new_state);
-bool nvme_wait_reset(struct nvme_ctrl *ctrl);
 int nvme_disable_ctrl(struct nvme_ctrl *ctrl);
 int nvme_enable_ctrl(struct nvme_ctrl *ctrl);
 int nvme_shutdown_ctrl(struct nvme_ctrl *ctrl);
@@ -802,7 +813,6 @@ int nvme_set_queue_count(struct nvme_ctrl *ctrl, int *count);
 void nvme_stop_keep_alive(struct nvme_ctrl *ctrl);
 int nvme_reset_ctrl(struct nvme_ctrl *ctrl);
 int nvme_reset_ctrl_sync(struct nvme_ctrl *ctrl);
-int nvme_try_sched_reset(struct nvme_ctrl *ctrl);
 int nvme_delete_ctrl(struct nvme_ctrl *ctrl);
 void nvme_queue_scan(struct nvme_ctrl *ctrl);
 int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp, u8 csi,
-- 
2.38.1

