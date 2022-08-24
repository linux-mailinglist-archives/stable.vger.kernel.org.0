Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF6159F408
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 09:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbiHXHNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 03:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235205AbiHXHNm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 03:13:42 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1B29410E;
        Wed, 24 Aug 2022 00:13:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KttTPebtXKRs3slyxYVw7WZsvEy7+TjQOgg51g0TYrOYriqevCco/cqDEIOBqtPd14HpL9PdELSPW+aPxEHUkNBQWNhVfysUJNvbI3rypr2CShkYQnrmPVVuR+UFXu2nXsU1NODNZBPW4zbW+Usm/Ft5rda3isHZVSxvX8QJFQrD1QLc5Ux04Ci38bEznMlmFClTTjMPTD3+R/0A6Hy382gfMgHj8gCO2b1YNRuel0Ycw0RCTevZeFaXze4Zb3zn7NHNV+DdmD5WPdAceeFA3zq+fBF0QT+TD+cZcjtBRUffuvwIsY95HfJ9GvXmQ2XtQyMWHm4KHTfjNRwVbjfLZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OpNjfHf3/QkGWxA6ZUBVjJJxSMxcpLHMHwM48spBnBg=;
 b=XURqOCu+FCz58a2xX6iXQlDgFvkEKe5N/rSYbT27eKHhbwJUZt0mExQOsNSVg6yGGQA1VnX4VoYFyxjkrQkKdn5Sv9JfHiIwBzRfE5nbsNZmX2Uc3ZdQnXjl3FR6xPuNdkKnS2tk+32HthdoAcljsWYUA6Wd+14otpjifv3zCiz1K18u6lQHB+W7nAu/YhCLWGg4SGR1sMlhxxS3P8qlaxX37avCZ78XUxBJp6sYNIjlBq0c25ZImwgELkFcjEQarPf989oJWb/uBQeoEbUksTOxuKt8LzhI5SbkDtm5GxhVVEJF2v1hohbdgWlXCnEGWTbCOtfX+17KbsdIDEq+Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpNjfHf3/QkGWxA6ZUBVjJJxSMxcpLHMHwM48spBnBg=;
 b=NYJs5Q3uAC1gC0RBpcKE0GXAK+xBzVMGJ63Ng4CltJ5Gj22uYno8xpGZlcdtApcS0KVUZm8crRTeogEhlAcPhhpmbO1YiWyZJ/1zmFLv+nwJLKVlnATzAOQLl8rTk94JkiZEdchTScooEatjLk6IR4mJ3xiAYmZNr3UaEkilC0s=
Received: from MW4PR04CA0068.namprd04.prod.outlook.com (2603:10b6:303:6b::13)
 by CH0PR12MB5139.namprd12.prod.outlook.com (2603:10b6:610:be::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Wed, 24 Aug
 2022 07:13:38 +0000
Received: from CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::1d) by MW4PR04CA0068.outlook.office365.com
 (2603:10b6:303:6b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14 via Frontend
 Transport; Wed, 24 Aug 2022 07:13:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT050.mail.protection.outlook.com (10.13.174.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5566.15 via Frontend Transport; Wed, 24 Aug 2022 07:13:37 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 24 Aug
 2022 02:13:33 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 24 Aug
 2022 00:13:24 -0700
Received: from xhdnavam40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Wed, 24 Aug 2022 02:13:19 -0500
From:   Piyush Mehta <piyush.mehta@amd.com>
To:     <balbi@kernel.org>, <gregkh@linuxfoundation.org>,
        <michal.simek@xilinx.com>, <michal.simek@amd.com>,
        <shubhrajyoti.datta@xilinx.com>, <lee.jones@linaro.org>,
        <christophe.jaillet@wanadoo.fr>, <szymon.heidrich@gmail.com>,
        <jakobkoschel@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <git@amd.com>, <siva.durga.prasad.paladugu@amd.com>,
        Piyush Mehta <piyush.mehta@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH V2] usb: gadget: udc-xilinx: replace memcpy with memcpy_toio
Date:   Wed, 24 Aug 2022 12:42:53 +0530
Message-ID: <20220824071253.1261096-1-piyush.mehta@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6fd50ff-d4da-4833-e585-08da85a02a00
X-MS-TrafficTypeDiagnostic: CH0PR12MB5139:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SrnR9ZGKZHWnZRvVj/i9UB0KlhCg5aXfzWRXNSivIaKBxbQJFJni9qqH5CmYg4y4FMxsH2EwAEfHrcyQRkA9tMVE+EaqQDADlnxTRlTkhcPH3DNnWDbGX00J/5M0gqEMmH37oK4cj7tVMzkAXql7OHrsN6y3Sf8FcOIyt65QJKkajLbBvVnW9aUJZfnzRu+Zr363CAlG7d0WJKa0C+fnYZqytbZq9yy401mqou0VNie95MiBMGKpMCkgnybiPGTr7xTdZzbOXhHvz5mnRBwX0TCrkdhWulhpgw9CjuacTHya5HLBYj3g4JjTx2Rm/jzX2eImyHlICgrpQfu6YUHPlV/zcwvDZgCm/S7oha6tF5meIncKZeWtJa9PGh2AW4wnSexOnMSl/CgdfpMa/6E8sy+NyDv4yMguNNTJwZgVWGWhKoJ1II1IkChfoZcNske4fG07EfFjt2sYA1BwLVUg14xe9+dASXvBnEp/vVIwq+7vNuMHwhKCFcZ2f79gU8l7nnT67zTijkbGl5gyQ50QYaWVCpXAnM7xeiKLxnmsZw8l/kbcOAV+MOQEpw/+yg2cTc5rN1+uwN4ASDxrbEvt/viAeGw62Y7M9B/D6Gw74SjIyrYd1sRNv810eMGb1GyBqnO8GQUF0FHiq7mRiqI5ERziwHlIHpRUH80aiPu8yr2XgCVI5u/1VAxmnrNXzJleos5kncBsc6xCWYgZo+47MgMv9BRkS7Dxp5cyACTh9aLmTaJ5ZyCAHLCRNRliOpfP+6dS+tk/EMbwmUnBxi+hXz+kO2jbLQVPCT9r6sLrJYv3VT7oRGwbnzfdKQ3y8CwUhlcwk7M/SJPXAFk80QwjAVWfHjtUa7Pfcncld6VNkj1dNn1+x/cspL5/PujRCW8eFwK6lWqrdmrVlZ/0HHDA/A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(396003)(40470700004)(46966006)(36840700001)(36756003)(44832011)(7416002)(2616005)(82310400005)(478600001)(83380400001)(36860700001)(8936002)(5660300002)(2906002)(86362001)(47076005)(426003)(186003)(110136005)(40480700001)(4326008)(45080400002)(40460700003)(8676002)(70586007)(70206006)(336012)(316002)(82740400003)(1076003)(54906003)(6666004)(26005)(921005)(81166007)(356005)(41300700001)(36900700001)(83996005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 07:13:37.0435
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6fd50ff-d4da-4833-e585-08da85a02a00
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5139
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For ARM processor, unaligned access to device memory is not allowed.
Method memcpy does not take care of alignment.

USB detection failure with the unaligned address of memory access, with
below kernel crash. To fix the unaligned address the kernel panic issue,
replace memcpy with memcpy_toio method.

Kernel crash:
Unable to handle kernel paging request at virtual address ffff80000c05008a
Mem abort info:
  ESR = 0x96000061
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x21: alignment fault
Data abort info:
  ISV = 0, ISS = 0x00000061
  CM = 0, WnR = 1
swapper pgtable: 4k pages, 48-bit VAs, pgdp=000000000143b000
[ffff80000c05008a] pgd=100000087ffff003, p4d=100000087ffff003,
pud=100000087fffe003, pmd=1000000800bcc003, pte=00680000a0010713
Internal error: Oops: 96000061 [#1] SMP
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.15.19-xilinx-v2022.1 #1
Hardware name: ZynqMP ZCU102 Rev1.0 (DT)
pstate: 200000c5 (nzCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __memcpy+0x30/0x260
lr : __xudc_ep0_queue+0xf0/0x110
sp : ffff800008003d00
x29: ffff800008003d00 x28: ffff800009474e80 x27: 00000000000000a0
x26: 0000000000000100 x25: 0000000000000012 x24: ffff000800bc8080
x23: 0000000000000001 x22: 0000000000000012 x21: ffff000800bc8080
x20: 0000000000000012 x19: ffff000800bc8080 x18: 0000000000000000
x17: ffff800876482000 x16: ffff800008004000 x15: 0000000000004000
x14: 00001f09785d0400 x13: 0103020101005567 x12: 0781400000000200
x11: 00000000c5672a10 x10: 00000000000008d0 x9 : ffff800009463cf0
x8 : ffff8000094757b0 x7 : 0201010055670781 x6 : 4000000002000112
x5 : ffff80000c05009a x4 : ffff000800a15012 x3 : ffff00080362ad80
x2 : 0000000000000012 x1 : ffff000800a15000 x0 : ffff80000c050088
Call trace:
 __memcpy+0x30/0x260
 xudc_ep0_queue+0x3c/0x60
 usb_ep_queue+0x38/0x44
 composite_ep0_queue.constprop.0+0x2c/0xc0
 composite_setup+0x8d0/0x185c
 configfs_composite_setup+0x74/0xb0
 xudc_irq+0x570/0xa40
 __handle_irq_event_percpu+0x58/0x170
 handle_irq_event+0x60/0x120
 handle_fasteoi_irq+0xc0/0x220
 handle_domain_irq+0x60/0x90
 gic_handle_irq+0x74/0xa0
 call_on_irq_stack+0x2c/0x60
 do_interrupt_handler+0x54/0x60
 el1_interrupt+0x30/0x50
 el1h_64_irq_handler+0x18/0x24
 el1h_64_irq+0x78/0x7c
 arch_cpu_idle+0x18/0x2c
 do_idle+0xdc/0x15c
 cpu_startup_entry+0x28/0x60
 rest_init+0xc8/0xe0
 arch_call_rest_init+0x10/0x1c
 start_kernel+0x694/0x6d4
 __primary_switched+0xa4/0xac

Cc: stable@vger.kernel.org
Fixes: 1f7c51660034 ("usb: gadget: Add xilinx usb2 device support")
Signed-off-by: Piyush Mehta <piyush.mehta@amd.com>
---
Changes in V2:
- Address Greg KH review comments:
 - Added information in the form of a Fixes: commit Id (commit message).
 - Cc stable kernel.

Link:https://lore.kernel.org/all/YwW8zE8ieLCsSxPN@kroah.com/
---
 drivers/usb/gadget/udc/udc-xilinx.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/udc/udc-xilinx.c b/drivers/usb/gadget/udc/udc-xilinx.c
index 4827e3cd3834..054b69dc2f0c 100644
--- a/drivers/usb/gadget/udc/udc-xilinx.c
+++ b/drivers/usb/gadget/udc/udc-xilinx.c
@@ -499,11 +499,11 @@ static int xudc_eptxrx(struct xusb_ep *ep, struct xusb_req *req,
 		/* Get the Buffer address and copy the transmit data.*/
 		eprambase = (u32 __force *)(udc->addr + ep->rambase);
 		if (ep->is_in) {
-			memcpy(eprambase, bufferptr, bytestosend);
+			memcpy_toio(eprambase, bufferptr, bytestosend);
 			udc->write_fn(udc->addr, ep->offset +
 				      XUSB_EP_BUF0COUNT_OFFSET, bufferlen);
 		} else {
-			memcpy(bufferptr, eprambase, bytestosend);
+			memcpy_toio(bufferptr, eprambase, bytestosend);
 		}
 		/*
 		 * Enable the buffer for transmission.
@@ -517,11 +517,11 @@ static int xudc_eptxrx(struct xusb_ep *ep, struct xusb_req *req,
 		eprambase = (u32 __force *)(udc->addr + ep->rambase +
 			     ep->ep_usb.maxpacket);
 		if (ep->is_in) {
-			memcpy(eprambase, bufferptr, bytestosend);
+			memcpy_toio(eprambase, bufferptr, bytestosend);
 			udc->write_fn(udc->addr, ep->offset +
 				      XUSB_EP_BUF1COUNT_OFFSET, bufferlen);
 		} else {
-			memcpy(bufferptr, eprambase, bytestosend);
+			memcpy_toio(bufferptr, eprambase, bytestosend);
 		}
 		/*
 		 * Enable the buffer for transmission.
@@ -1023,7 +1023,7 @@ static int __xudc_ep0_queue(struct xusb_ep *ep0, struct xusb_req *req)
 			   udc->addr);
 		length = req->usb_req.actual = min_t(u32, length,
 						     EP0_MAX_PACKET);
-		memcpy(corebuf, req->usb_req.buf, length);
+		memcpy_toio(corebuf, req->usb_req.buf, length);
 		udc->write_fn(udc->addr, XUSB_EP_BUF0COUNT_OFFSET, length);
 		udc->write_fn(udc->addr, XUSB_BUFFREADY_OFFSET, 1);
 	} else {
@@ -1752,7 +1752,7 @@ static void xudc_handle_setup(struct xusb_udc *udc)
 
 	/* Load up the chapter 9 command buffer.*/
 	ep0rambase = (u32 __force *) (udc->addr + XUSB_SETUP_PKT_ADDR_OFFSET);
-	memcpy(&setup, ep0rambase, 8);
+	memcpy_toio(&setup, ep0rambase, 8);
 
 	udc->setup = setup;
 	udc->setup.wValue = cpu_to_le16(setup.wValue);
@@ -1839,7 +1839,7 @@ static void xudc_ep0_out(struct xusb_udc *udc)
 			     (ep0->rambase << 2));
 		buffer = req->usb_req.buf + req->usb_req.actual;
 		req->usb_req.actual = req->usb_req.actual + bytes_to_rx;
-		memcpy(buffer, ep0rambase, bytes_to_rx);
+		memcpy_toio(buffer, ep0rambase, bytes_to_rx);
 
 		if (req->usb_req.length == req->usb_req.actual) {
 			/* Data transfer completed get ready for Status stage */
@@ -1915,7 +1915,7 @@ static void xudc_ep0_in(struct xusb_udc *udc)
 				     (ep0->rambase << 2));
 			buffer = req->usb_req.buf + req->usb_req.actual;
 			req->usb_req.actual = req->usb_req.actual + length;
-			memcpy(ep0rambase, buffer, length);
+			memcpy_toio(ep0rambase, buffer, length);
 		}
 		udc->write_fn(udc->addr, XUSB_EP_BUF0COUNT_OFFSET, count);
 		udc->write_fn(udc->addr, XUSB_BUFFREADY_OFFSET, 1);
-- 
2.25.1

