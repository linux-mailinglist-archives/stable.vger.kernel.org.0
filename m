Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7BA3E2E5C
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 18:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbhHFQgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 12:36:22 -0400
Received: from mail-mw2nam10on2056.outbound.protection.outlook.com ([40.107.94.56]:28001
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231682AbhHFQgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 12:36:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AkzrPuGZ/cWujWwtMJMIv6nTECGhmfROKizpl+/O24NY4yQJ7a6lVjdQfssFfvonhqbva/hsacbotv0qUNqY8a7GGphaXU4gIPcWGufNBK7U2pLUqa9UslNUY1exK//pNUvQzbGfojmxA+H/GLnGpKp5VXJhqR5eI3lvsPpLdLEPLlliokZ6zTFf4oxZNRslVTEbQC9psCZ5DRMxASPyjnmnK5p2XjFYjy2obc4d9vdh5v5Klx9NJ6lQt03SNRCGLeVhA5g8K/hGYWVz8l0/nXy+X2UEUILBI4eAohxOaQY1OxOpZH1C5m1tr5qG3M4ybOvpro+43Q791JBjDzMLBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YBGYmrdzDdhyoqLwY6SyiWwTlghfG5reIB/laAzTosk=;
 b=memR6zwrq0fZLhjd8fT90IZqhNHYOjR0AIvvVeSYxWx5+1T9VmX/w95MXXKxOwuUFR/cf7TuH6fqWA4sGdE/F7rwTXn3s6tfuWTLc0rmg9ykRK9Js9PtLPwsD/Tfri/YeVhGGqELKZsDNExymlEDuqpM7s3AqOTlVwsHliBxzb1Ohxpw1+nE9AuksSKeS3HOjT9ZwDxzpWo9BNeCMCJDeBVCxvUbEjYUqjdwySwQRsNIMrY44fxk3JHMHEopWJRbM4QoTyYwsaSEXEbwptlcemTXvoU8+DrOZhFIz1iu3gAZe8gzsnXY6TTel+VdoPBAzUHO0+wBxsblsJDsKFP9kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YBGYmrdzDdhyoqLwY6SyiWwTlghfG5reIB/laAzTosk=;
 b=Iyi0Yamez7YGLer3e07ixLGqr1ca0X6WUIqMrUlzwF3awNhVAdfZ1sbWe7pBYFvcy2718NCyaRDrxV5VXIyhnKhXvbmnzdcAxoXNK0dp0460Wq8JU4F1JcvBeyMW+35DwcUf2t3i1+to2ANEKiwFykvEfyP4XBimYZm8QYtNSOs=
Received: from MWHPR1201CA0005.namprd12.prod.outlook.com
 (2603:10b6:301:4a::15) by BYAPR12MB3399.namprd12.prod.outlook.com
 (2603:10b6:a03:ad::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Fri, 6 Aug
 2021 16:36:04 +0000
Received: from CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4a:cafe::cb) by MWHPR1201CA0005.outlook.office365.com
 (2603:10b6:301:4a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend
 Transport; Fri, 6 Aug 2021 16:36:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT021.mail.protection.outlook.com (10.13.175.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4394.16 via Frontend Transport; Fri, 6 Aug 2021 16:36:03 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.12; Fri, 6 Aug
 2021 11:36:02 -0500
Received: from Bumblebee.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2242.12 via Frontend
 Transport; Fri, 6 Aug 2021 11:36:00 -0500
From:   Anson Jacob <Anson.Jacob@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <Qingqing.Zhuo@amd.com>,
        <Eryk.Brol@amd.com>, <bindu.r@amd.com>, <Anson.Jacob@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 13/13] drm/amd/display: use GFP_ATOMIC in amdgpu_dm_irq_schedule_work
Date:   Fri, 6 Aug 2021 12:34:49 -0400
Message-ID: <20210806163449.349757-14-Anson.Jacob@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210806163449.349757-1-Anson.Jacob@amd.com>
References: <20210806163449.349757-1-Anson.Jacob@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: febef03c-07b6-40d4-c577-08d958f84882
X-MS-TrafficTypeDiagnostic: BYAPR12MB3399:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3399BFA2E0B7149787DC2400EBF39@BYAPR12MB3399.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G25/yZXoi9U0IXo6XOrZWL+PDp+3B/jkw+B7jJvp/XfabRF2Eu680kAbD+Zdi3ywkAQgcOX3StZVDOJ4m4mEsxQUYjg69uE8oEd416mCMf8yBbXB9FT+mzE8qLNaGn8UiIjRQRwiFuWH/WkuXYqiFr0/vbXySLWI1O1zL3yZSrbFcRuQuOXApO6Clly5fa0vGg68qCuoE+twukJSA6RyV8cq6HDg5ouTzDbchZlTO5U1BtWOlzPfGYk5KyE4HBf8CoregZV0ioQ2l9VLZd4p4M6DKpBoK2qUPsS25EM+XsEXEFBxmxyAkrrFjDakIE0mlT2WtYrp4mpe37e45rfVQnjEFHMoHaobli/aCcGJ9vWlmsliuzQ03PQC9ZXjzAzKYlxMwpzYsiW/3Yts6iWg/tRyr9A8lPx8HJ6ovwjo6yZaVUoGYNJ/BOvS/fuIDGIvO7G6svVyzDapzMQU0aNFNo93j2VI3QHDv+9/fZ0qNi/Allw7ksimqbDfI9yuDy6j7F/BJJRJcb2oZvLQ8oxPkE4+jyV0zWd4uFHbioNpUgdM5RQhJWYAuAiwIFtWKYtZo6ZAhSPPyi77CHGltU7HxKe4uz0MEWdUvQLRqQwX+YtphPOlTGh9zBnp15H3pN12Ufg7sXAcoDsqGTnEzX9FqO49OcHrg5DvjyCXu4bsJn+SH6HQ1fU2hMoWvicJtOXvNWKg2+E9BaQYECEgV6PjgZDXnTfQXu5DijJfR2HvF0g=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(396003)(46966006)(36840700001)(82310400003)(54906003)(1076003)(36756003)(47076005)(478600001)(70586007)(5660300002)(2906002)(336012)(2616005)(86362001)(83380400001)(36860700001)(426003)(8676002)(356005)(82740400003)(7696005)(8936002)(186003)(70206006)(81166007)(4326008)(26005)(6666004)(6916009)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 16:36:03.9630
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: febef03c-07b6-40d4-c577-08d958f84882
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3399
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Replace GFP_KERNEL with GFP_ATOMIC as amdgpu_dm_irq_schedule_work
can't sleep.

BUG: sleeping function called from invalid context at include/linux/sched/mm.h:196
in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 253, name: kworker/6:1H
CPU: 6 PID: 253 Comm: kworker/6:1H Tainted: G        W  OE     5.11.0-promotion_2021_06_07-18_36_28_prelim_revert_retrain #8
Hardware name: System manufacturer System Product Name/PRIME X570-PRO, BIOS 3405 02/01/2021
Workqueue: events_highpri dm_irq_work_func [amdgpu]
Call Trace:
 <IRQ>
 dump_stack+0x5e/0x74
 ___might_sleep.cold+0x87/0x98
 __might_sleep+0x4b/0x80
 kmem_cache_alloc_trace+0x390/0x4f0
 amdgpu_dm_irq_handler+0x171/0x230 [amdgpu]
 amdgpu_irq_dispatch+0xc0/0x1e0 [amdgpu]
 amdgpu_ih_process+0x81/0x100 [amdgpu]
 amdgpu_irq_handler+0x26/0xa0 [amdgpu]
 __handle_irq_event_percpu+0x49/0x190
 ? __hrtimer_get_next_event+0x4d/0x80
 handle_irq_event_percpu+0x33/0x80
 handle_irq_event+0x33/0x60
 handle_edge_irq+0x82/0x190
 asm_call_irq_on_stack+0x12/0x20
 </IRQ>
 common_interrupt+0xbb/0x140
 asm_common_interrupt+0x1e/0x40
RIP: 0010:amdgpu_device_rreg.part.0+0x44/0xf0 [amdgpu]
Code: 53 48 89 fb 4c 3b af c8 08 00 00 73 6d 83 e2 02 75 0d f6 87 40 62 01 00 10 0f 85 83 00 00 00 4c 03 ab d0 08 00 00 45 8b 6d 00 <8b> 05 3e b6 52 00 85 c0 7e 62 48 8b 43 08 0f b7 70 3e 65 8b 05 e3
RSP: 0018:ffffae7740fff9e8 EFLAGS: 00000286
RAX: ffffffffc05ee610 RBX: ffff8aaf8f620000 RCX: 0000000000000006
RDX: 0000000000000000 RSI: 0000000000005430 RDI: ffff8aaf8f620000
RBP: ffffae7740fffa08 R08: 0000000000000001 R09: 000000000000000a
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000005430
R13: 0000000071000000 R14: 0000000000000001 R15: 0000000000005430
 ? amdgpu_cgs_write_register+0x20/0x20 [amdgpu]
 amdgpu_device_rreg+0x17/0x20 [amdgpu]
 amdgpu_cgs_read_register+0x14/0x20 [amdgpu]
 dm_read_reg_func+0x38/0xb0 [amdgpu]
 generic_reg_wait+0x80/0x160 [amdgpu]
 dce_aux_transfer_raw+0x324/0x7c0 [amdgpu]
 dc_link_aux_transfer_raw+0x43/0x50 [amdgpu]
 dm_dp_aux_transfer+0x87/0x110 [amdgpu]
 drm_dp_dpcd_access+0x72/0x110 [drm_kms_helper]
 drm_dp_dpcd_read+0xb7/0xf0 [drm_kms_helper]
 drm_dp_get_one_sb_msg+0x349/0x480 [drm_kms_helper]
 drm_dp_mst_hpd_irq+0xc5/0xe40 [drm_kms_helper]
 ? drm_dp_mst_hpd_irq+0xc5/0xe40 [drm_kms_helper]
 dm_handle_hpd_rx_irq+0x184/0x1a0 [amdgpu]
 ? dm_handle_hpd_rx_irq+0x184/0x1a0 [amdgpu]
 handle_hpd_rx_irq+0x195/0x240 [amdgpu]
 ? __switch_to_asm+0x42/0x70
 ? __switch_to+0x131/0x450
 dm_irq_work_func+0x19/0x20 [amdgpu]
 process_one_work+0x209/0x400
 worker_thread+0x4d/0x3e0
 ? cancel_delayed_work+0xa0/0xa0
 kthread+0x124/0x160
 ? kthread_park+0x90/0x90
 ret_from_fork+0x22/0x30

Reviewed-by: Aurabindo Jayamohanan Pillai <Aurabindo.Pillai@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Signed-off-by: Anson Jacob <Anson.Jacob@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
index 40f617bbb86f..4aba0e8c84f8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
@@ -584,7 +584,7 @@ static void amdgpu_dm_irq_schedule_work(struct amdgpu_device *adev,
 		handler_data = container_of(handler_list->next, struct amdgpu_dm_irq_handler_data, list);
 
 		/*allocate a new amdgpu_dm_irq_handler_data*/
-		handler_data_add = kzalloc(sizeof(*handler_data), GFP_KERNEL);
+		handler_data_add = kzalloc(sizeof(*handler_data), GFP_ATOMIC);
 		if (!handler_data_add) {
 			DRM_ERROR("DM_IRQ: failed to allocate irq handler!\n");
 			return;
-- 
2.25.1

