Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36AA05BD59A
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 22:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiISUR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 16:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiISURz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 16:17:55 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE7E4A130
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 13:17:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kbLjnK1SImNHI2ONYnutDy3hY6mz9M1Aovb9GbjnMIKDzFcxR4PsSd91FR0+zSyYma8jDXx07Y1Ba/OzDBpGegZse7S8oxVYiHKNcVVglKca14AtQk7UtDCNIo3sibipmvXKIAzrBNuN6KEIXyRS+CHTSJTUx8d5HmYjmSz5+MoflST6Yhd2zbYZKRhkcT4YTwl8/tLpaB4UCvLTnqZcZfjjie8414HsAj5TJIevj/2n4EQpLt1+9Uh9IJS/b42RKflovHvBmK+UyKhWgv8DUyJUWu75wAen/9/UN7cmGR0FczfUQXBhzRmW9OYl0KV9Z2OfgV/SNd/fB6xFZWwsEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mXvQPcZ99tJ9yuwCWCzg0xdOREDikeRuXi85CRO6R3w=;
 b=SMyl9SnLoVa9YH4SERfTrx1F/NIhkpp0FSZi8isa4lVEhnoYgVObeWcI+zXi8aF1dHOY52oADt0WmCBQSMtiIHu+c2ovQmSY+utkIAWtGHuf1gSvpYbAJG2a0yipk63CdtIkzVkd3ThqyhmjLzbq8zK+VHRlvFDjEWHFJHe+NzbUj9HTLOOYHEKo+gobclnOaMh++usatj3AD9r0aR9QoaRcsJbWvbAHUQ8189h/4jbz0EtJOLEyua6flGnUGnKpDd0UoiqdCjbQr2qY17Pf+fRpHwY386ulCMRkQId+h3DhIjA+p8Iz3OTA6dAKvUV7sKvf4gi4Kl0F1Pc6QZpvRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXvQPcZ99tJ9yuwCWCzg0xdOREDikeRuXi85CRO6R3w=;
 b=KaJ8D/jeMQq6k6DUEPfzSEGQWaEt95G9YsDRP926g8TOvpIU9g0JZduWR5EPCmBeh+XdLWAB8NMM384W5qzbPQZw2byAO9BluNjBNdxvamw4fgG0Oxmxnl2Ly2JdWbdXsDg4/CDA/hTxUqfWnjMnD3WjJgNL7mrLJeTyXZzrhcI=
Received: from MW4PR04CA0214.namprd04.prod.outlook.com (2603:10b6:303:87::9)
 by PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Mon, 19 Sep
 2022 20:17:50 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::4b) by MW4PR04CA0214.outlook.office365.com
 (2603:10b6:303:87::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21 via Frontend
 Transport; Mon, 19 Sep 2022 20:17:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5632.12 via Frontend Transport; Mon, 19 Sep 2022 20:17:50 +0000
Received: from ethanolx27d8host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 19 Sep
 2022 15:17:49 -0500
From:   Avadhut Naik <avadnaik@amd.com>
To:     <avadnaik@amd.com>
CC:     Pavel Begunkov <asml.silence@gmail.com>, <stable@vger.kernel.org>,
        "Beld Zhang" <beldzhang@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/rw: fix short rw error handling
Date:   Mon, 19 Sep 2022 20:17:41 +0000
Message-ID: <20220919201741.18519-1-avadnaik@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT015:EE_|PH7PR12MB5712:EE_
X-MS-Office365-Filtering-Correlation-Id: 90411ec8-4403-46c5-9d3e-08da9a7c06a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zelaWiTuubQnsZdW18SJPPy3eyIfqFhLhPduE+7HvVG8WCO+zhMWA9WPHuEaP6nZM45QEUt2DaEAVFapIiCdT+1nBvURPbEU34LvazuJVpUJxcS7GxLFV6jvaZWRrpERQlb736jXEqXGj4880XpRPPNS/otM6h4HE0EzqriRwoTNCN6PAbpShoOBW/oje9Xg59MlUJowiFm5k3oCBzUSNwjpMXn0dF6C1YAz2M/NukerrbOAqebN+WN2/G3IMntZulkWWh7WZ3vqrl49wmhTrdrkgidDJwSOVHNzUncPL0FHL3J6J/cTcczlJX3BBG7N2y2PCIA7m3k4gJsOcAPr3Z6VAJSLz5xiMGnaMUiPF8022exDSnkeJeWLZGDJ2lrErf/XBLMCBUjaO1ZLgssW9nnw+U1Zj4cStOw7uToCgX+Pn1E+creZEljKvpPX7GCAhvW8fLwGvx8CL6VSL6Of/nThlC8AqyLIZWETEdgyqYw1JtDg8S42LL+gQJofTJoDzJuFJbFXZGoaVnDtydQleZ7aVe1TLEJo8lfRMZQPVqnmG9SjbwlmX/BdToVXKmYVREBuzPxQ+aoaoQ296KGJzZ/03m/NKusmHD8qT2mdczFz/Hn1fcDIiyCTmoeFDNLaWWiKNSf9rfYaxhZVrYIHIqAFrMb1DpoQcLOliyazVN0KBg+H+in2FGaj8lFBrIiihkVSlp+hmNdHsSwAs5X9fP2vgefaHnGLmdUzth+L/OdO01/EXCmC7SHxrbeurEZPKwsZCPTLbtr+aS2/lJdtk85flaHQBjjhFLSm0mZHi+H1YNTUetS+vNrIgkamo47lEoC/gwIS76GvotoTZdO0WQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(136003)(451199015)(46966006)(40470700004)(36840700001)(356005)(70586007)(7049001)(186003)(82740400003)(8936002)(70206006)(40460700003)(83380400001)(5660300002)(81166007)(2906002)(82310400005)(1076003)(336012)(16526019)(41300700001)(2616005)(40480700001)(8676002)(478600001)(26005)(54906003)(966005)(6200100001)(7696005)(6666004)(4326008)(6862004)(36860700001)(426003)(47076005)(37006003)(36756003)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2022 20:17:50.2676
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90411ec8-4403-46c5-9d3e-08da9a7c06a6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5712
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

We have a couple of problems, first reports of unexpected link breakage
for reads when cqe->res indicates that the IO was done in full. The
reason here is partial IO with retries.

TL;DR; we compare the result in __io_complete_rw_common() against
req->cqe.res, but req->cqe.res doesn't store the full length but rather
the length left to be done. So, when we pass the full corrected result
via kiocb_done() -> __io_complete_rw_common(), it fails.

The second problem is that we don't try to correct res in
io_complete_rw(), which, for instance, might be a problem for O_DIRECT
but when a prefix of data was cached in the page cache. We also
definitely don't want to pass a corrected result into io_rw_done().

The fix here is to leave __io_complete_rw_common() alone, always pass
not corrected result into it and fix it up as the last step just before
actually finishing the I/O.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://github.com/axboe/liburing/issues/643
Reported-by: Beld Zhang <beldzhang@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1babd77da79c..1e18a44adcf5 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -206,6 +206,20 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 	return false;
 }
 
+static inline unsigned io_fixup_rw_res(struct io_kiocb *req, unsigned res)
+{
+	struct io_async_rw *io = req->async_data;
+
+	/* add previously done IO, if any */
+	if (req_has_async_data(req) && io->bytes_done > 0) {
+		if (res < 0)
+			res = io->bytes_done;
+		else
+			res += io->bytes_done;
+	}
+	return res;
+}
+
 static void io_complete_rw(struct kiocb *kiocb, long res)
 {
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
@@ -213,7 +227,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 
 	if (__io_complete_rw_common(req, res))
 		return;
-	io_req_set_res(req, res, 0);
+	io_req_set_res(req, io_fixup_rw_res(req, res), 0);
 	req->io_task_work.func = io_req_task_complete;
 	io_req_task_work_add(req);
 }
@@ -240,22 +254,14 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 		       unsigned int issue_flags)
 {
-	struct io_async_rw *io = req->async_data;
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-
-	/* add previously done IO, if any */
-	if (req_has_async_data(req) && io->bytes_done > 0) {
-		if (ret < 0)
-			ret = io->bytes_done;
-		else
-			ret += io->bytes_done;
-	}
+	unsigned final_ret = io_fixup_rw_res(req, ret);
 
 	if (req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = rw->kiocb.ki_pos;
 	if (ret >= 0 && (rw->kiocb.ki_complete == io_complete_rw)) {
 		if (!__io_complete_rw_common(req, ret)) {
-			io_req_set_res(req, req->cqe.res,
+			io_req_set_res(req, final_ret,
 				       io_put_kbuf(req, issue_flags));
 			return IOU_OK;
 		}
@@ -268,7 +274,7 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 		if (io_resubmit_prep(req))
 			io_req_task_queue_reissue(req);
 		else
-			io_req_task_queue_fail(req, ret);
+			io_req_task_queue_fail(req, final_ret);
 	}
 	return IOU_ISSUE_SKIP_COMPLETE;
 }
-- 
2.34.1

