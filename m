Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA336633A5E
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 11:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbiKVKo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 05:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbiKVKoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 05:44:00 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D72443AC5
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 02:39:26 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM9gIxI023044;
        Tue, 22 Nov 2022 02:39:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=v7MuVAJg0P9ju9552zxZPeMxxPtU4P10rzLQb+HmDI4=;
 b=qndnnEdmJ6+jlDibKXvK7n1YwQZ8PamvfvXufSfXbDo1nXf+bUzSVHJ3/kM9UeGiMThT
 NS1n4lQky0bg3Ov4iGJClzZyv90zM2g7Z/fd3zbFTIPbDsiNFOOKsLXO9HrlvuNvj7bU
 /YCTNpczn+VN3RR7ue8jHgtInmX4dcy1FJiQjEaIzFq8nksqVk0m2gysJMMgZZIfCQca
 DyADzP/fltLdMdGpMyN/SPuin9zChXKzLxOr8xSaWHj7drPqA2A0EF3xixXiLEDsSAei
 RPB6ZCouvSNbc94AD4QSIy4hcNw/bfZoVp/3sw631K57tTmErDiJ0uOCH/aGuZD+Zi8D oQ== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3kxyhqa6vx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 02:39:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmacEbXL0eoZYiAFZcCOrpAf2ALL8D2Q+YHkoVRmwSQeZalWrLjJUyvGojCkAaMLvjoB1+JUC1XhkgMRJhpBDYkrJx3VS57aVuErZ+a2uPiy03Cf/7Z6NamWKceVApXgus+YFiDSr2YHaKAF1u66ZBgnU1vGXAsyKFl0IAaJ74k3lAR91/0bIhUNGiYfd40N+ClZlaVRAX7cPxVFiAkq/UmfQdU7hda8lm33AbyExH1ZrGvW2fKlJa525/spHJzVb+TnQL1bg0o+AxontELwBNFmppqOzwrYAjqwpcYojC1PpIt3iXnIIT0So0KXcM7TDxjxrgetJ+0QPjD0VoLxxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v7MuVAJg0P9ju9552zxZPeMxxPtU4P10rzLQb+HmDI4=;
 b=MT1PSvCXy6I5VDEaRKPibumeZg3824XJxPzxROrMnmPt+eOzTyU4fYSJERGnYCv2MmDO13FMHOJXaxECTNipPj7ISB5i0V12lVD7kZYQjqIzzOCBrZFwDxn2sap5enX/R8uM3wkAh3wdkr30bookk844k6VinLf4JGzJZ5nCzXKt407+5lDH3+dCTeae+Qpv7wV6F78ikbBv0qeDis/IppCvCZOZbm6Hx3WNtQ7N6Fyev9TdKJzw1JmDVhzI6sLlmqSSE0oDzgkv+f1Fz4rODRL322cb8Xw9e7Ub1Det9MoeHhibEtdoDOoXguFsBCz8VReSmbCN8Zdfc1jDA519lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SJ0PR11MB5167.namprd11.prod.outlook.com (2603:10b6:a03:2d9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 10:39:13 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99%8]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 10:39:13 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.15 2/2] nvme: ensure subsystem reset is single threaded
Date:   Tue, 22 Nov 2022 12:37:54 +0200
Message-Id: <20221122103754.3501162-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122103754.3501162-1-ovidiu.panait@windriver.com>
References: <20221122103754.3501162-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0049.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:1bb::7) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|SJ0PR11MB5167:EE_
X-MS-Office365-Filtering-Correlation-Id: 41245bf8-220a-45f7-e6df-08dacc75cc49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3qjpG3IxzzpJm31SL6N/sQFcdTm+mSwHOHOTSPyTOPxDKobHib9Vgqf03RFerbnobbgRd6TixZSehjuZOoulpH8MGeFhqVb3EVUUvYPach9tpMFhtEBB/rhfZJhikXPZl3ElIiIuHwD7Q0L8Zd4VrKVxOsoayN+Od2erQ+i2ShbDPDo9SWVv3fq/MphjsFvkcxQyDPawikRbPsY++EFaBvOSfbY+DRi7xcZ6tN/o11nWkFEOTGc9wpxeMv2v8AIvNS5Ojhgx0FbwDQTila64Bu4Am/VCgbo4kvzi2tGLlrD26iA2cFgt7rffq7O1LzPW9+5XDSzkU4Rm8Zq6/UrH6UrjRVyydKSgnrkNzwvCNSnXfQtTyzWMkan2gA09Zl3q/r0CH54gIVX/TiP3u/+/Yl0d+aOdM9qxb1aEqZCI1E5RnSrFajAkh+7f1/Zy171TZq0HludsrgKuHgkMwt+5WCpD0GfhVHDrhUw6OKoOAeGkJiFdJ1cxP1Wpa0L7qqCQIjCWsfj84rSWyOQ4GhLUdSw5vYckPH0Vgm7t/fPWzGBXFktGcvoradxXoT2d6exf3j6NUJL1CTxv2Qzzg4XiWkzHeN70nDDyGx9OqeoYe6vqDMZEEtuY/r/m7QBru3yy4inwoeGIN/mJZzV+Y+7DE1D5dEWxVt8VKtRN4fu9t51qsMS30HQUsp3gk1zyJUES4xHlz0VN1UZZcIJDkjlo21TLih/tSvrRnY+m/4fjM/w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39850400004)(366004)(376002)(396003)(346002)(451199015)(2906002)(1076003)(2616005)(66946007)(41300700001)(36756003)(86362001)(66556008)(4326008)(6506007)(6916009)(54906003)(83380400001)(38100700002)(38350700002)(8936002)(6486002)(107886003)(8676002)(52116002)(186003)(66476007)(5660300002)(6512007)(478600001)(44832011)(316002)(966005)(6666004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YSlD3EGoyxmz+6MnS/gI1FGr007cXZ5Jtl5+JoaJCLvShWHcT+gbvrT+URUG?=
 =?us-ascii?Q?uq20KqHy7U340tx8CJcIpxAqfimontAFAlw/D2NkfEpOeNvtlI6S8ea7XuD/?=
 =?us-ascii?Q?FVyYqIcUo9jd0CQO0Ckq5ejcSkNP2egCfJolXA4EyMsybNoKjwL8ghNPdOU6?=
 =?us-ascii?Q?MvGv/iypMd1hea/H45jUYJeyWBZdQ25dWHDgODpN3+xbx4B4BQV5FCZgMUD0?=
 =?us-ascii?Q?29Nu/4377V1vxt4cwfXqo4NTvVMp8cSJNvdVEXX36Of/QXAD8YMYkL2Mm4eD?=
 =?us-ascii?Q?1vNOVodjXDotCsrsr27SKpUBOqTL5fdrzYJunU9R+76tDXOUUQ1wmASjulfV?=
 =?us-ascii?Q?Qr9/1yebX9xfAWnVZAVJwXvX7rZMqms5lS3PalnvpTXytDksHqfoBPgmkSGS?=
 =?us-ascii?Q?x4/RUA96oayEgyISsNzcrFEidhM/AmfqoGEdHIxy8eIdeloTgRxzGqfQunCs?=
 =?us-ascii?Q?Y8toAIaWNEW+C3arZBjzPHwJZLpUPeYhiMEp8O2dYNfFbSJv+XAqSodV+j1i?=
 =?us-ascii?Q?ZIsF/31rdu/3acNEt394h6qfq41jDAD5HHoO07ptfvc5ysN7Z0y/gAeqf6oS?=
 =?us-ascii?Q?MPCEcXPJcfphvgtwXCzqov14mDD6H+gHCOfukCJ3UToPZsaUYL2AIF1sl6kC?=
 =?us-ascii?Q?BOBFXGg38uYz29ep+PUQzy12vh4bcWx4Q7B+i8uilenHE3Pvc+7n/4RhPur/?=
 =?us-ascii?Q?vY4AAFpNiDC9TiumoAqYd5RwyElR+oEqjGN/l1DTnjVgT2FWiD4qZG5EzZkd?=
 =?us-ascii?Q?SBKXGQxr1+eRMloiua9yrBbx/VR3Kka54Y7wcatpf9/RSTPAVgNwLEK2m9rs?=
 =?us-ascii?Q?tn8HZ5HXK8Cp0Uoeq7BKr+E0GIDTYPenuUbo84GMpUrwX1eZNUPzbKTQji0m?=
 =?us-ascii?Q?M1ZWbVaOB+2bnIkOc3g1c8TovksUQpQoWnmubug0j0H9fgPyFPpxA6tOoq7w?=
 =?us-ascii?Q?VTWJaIJQLQZ6+6EXO2XvqxsBIWtI3ZQL1yXjLxBITd1t5Ya0b4bRnqSYJ9tk?=
 =?us-ascii?Q?MKyE+dmWZS8plCC/mYJwNQm+fkxL08O0xd5FoytwG3GJD9r2VOsgNxs5XKOg?=
 =?us-ascii?Q?rq7KUgcY5gwXOklik8x0YcUNMy2WNrDRiLl+30m+v/WbMILBoAyrN0AP1c7k?=
 =?us-ascii?Q?BW8+SXKIdhqPFCQCA9k0xDMS6uLBtLYx2orYQY8vDAxNZbILPPCc3XJjMYjL?=
 =?us-ascii?Q?gkwt2L2S/xnS8HppAboPX6MiQBMJWw5lbiFD4aO8oMFpYsSuok0+kNsXQqZP?=
 =?us-ascii?Q?UdQ2TnfR93/2CmLlsLNwVBZtuaTjvboiaeHzy7UN8BpQ/OzywhIxIuFlml3/?=
 =?us-ascii?Q?QCCGgKkevpnIwXkrca/HFm8xgHQAX4iWM4dHirtRazw4JwDHLo0t47yysxsu?=
 =?us-ascii?Q?qsenMHK1LwZ9C3B88Y/dnceNWP1oktMi7WgX9fa8qRg3h+Kxv66MDZJ2AI3y?=
 =?us-ascii?Q?ffQWyfYK84rNEsHvsGKLyDQ+7ceueVmn5V89YJsbTFAg1+p728G2u5GBN10L?=
 =?us-ascii?Q?y+vVrZFRJLjdb2s2ahzHh4zJevn4gOCHiGjQtKzfaBCNyeqU8JhetqS3ODa9?=
 =?us-ascii?Q?wAOd4KDFCu7bJH2ulTNPTh/EoB40b0IEuhFZZ65ZA/Ih5ymKwcOIyLZpmPmp?=
 =?us-ascii?Q?MQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41245bf8-220a-45f7-e6df-08dacc75cc49
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 10:39:13.8387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vT0d4XFeinxMByXD/6/9adgz81qR7ouGwYbwy5/kVHzxstcG4GGCKjy0yK4G5XLiyHJNBwV3n9JhGi7cr5anRtB1sFzoGtoFegk96PhItm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5167
X-Proofpoint-ORIG-GUID: OkWA3h_mPv3g817WfwSlhL7M4InE6Ebh
X-Proofpoint-GUID: OkWA3h_mPv3g817WfwSlhL7M4InE6Ebh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_04,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220077
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
index 75a7e7baa1fc..7f52b2b179b8 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -558,11 +558,23 @@ static inline void nvme_fault_inject_fini(struct nvme_fault_inject *fault_inj)
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
@@ -650,7 +662,6 @@ void nvme_cancel_tagset(struct nvme_ctrl *ctrl);
 void nvme_cancel_admin_tagset(struct nvme_ctrl *ctrl);
 bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		enum nvme_ctrl_state new_state);
-bool nvme_wait_reset(struct nvme_ctrl *ctrl);
 int nvme_disable_ctrl(struct nvme_ctrl *ctrl);
 int nvme_enable_ctrl(struct nvme_ctrl *ctrl);
 int nvme_shutdown_ctrl(struct nvme_ctrl *ctrl);
@@ -734,7 +745,6 @@ int nvme_set_queue_count(struct nvme_ctrl *ctrl, int *count);
 void nvme_stop_keep_alive(struct nvme_ctrl *ctrl);
 int nvme_reset_ctrl(struct nvme_ctrl *ctrl);
 int nvme_reset_ctrl_sync(struct nvme_ctrl *ctrl);
-int nvme_try_sched_reset(struct nvme_ctrl *ctrl);
 int nvme_delete_ctrl(struct nvme_ctrl *ctrl);
 void nvme_queue_scan(struct nvme_ctrl *ctrl);
 int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp, u8 csi,
-- 
2.38.1

