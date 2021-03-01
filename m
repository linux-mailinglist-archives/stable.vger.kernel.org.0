Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB07327CFB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 12:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhCALTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 06:19:07 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:59833 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232268AbhCALTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 06:19:01 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id CEA2A19411B2;
        Mon,  1 Mar 2021 06:18:11 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 01 Mar 2021 06:18:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=omnacb
        moN1y+wuCkPBJrfV8tLB4qxsYxf2AluUIU81Q=; b=iZ8avaN1pHcGHAgG6E5RAh
        4/OIGSOiOyraF+KdUov0FAlV5bu4EwAwrqtZLFwyFHzgZlT8YEp+1Yc803YWWe4q
        79FbteBEEiAWUNfWFiaC7BbTqs2K3eRmn3f1UWe621Bko4m2/9d0BzPtQ3DTBwOl
        x99FtP/U0vdM7j13kzekoGVlIoCiqaLRNrQi4dsuK02SpMVNnIIfu1H0VH9YRkaz
        noKpEtSLhYlsVIjdFkWHsiYyAo8iEyxpxJaudPlENW/h3gfq4xpJsVHKWRPRiNrj
        WgUel/J/X+R2GmmZXglP2rXgJALqDtFUpX0A75QLaq6TS0+8gQiZnSH41QzcpjLg
        ==
X-ME-Sender: <xms:c808YFX3bAzuEr-wgshBavWIzwmrbxzP0ojuU7xvJFmzJwQvyejx3Q>
    <xme:c808YFgubVHH7J7pDvHq-B7oL-cxoNhvfgcUnKtbpvAEEEI8Sq4BAsLbJNFeLHgeo
    OELnBS8fpJg2w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:c808YOTAZG2kO5AmUoHXI7BFqsyZtuIhxXg22KMOg_DMC0UoJDNeOA>
    <xmx:c808YAHmDWX96oWRwlZtaghByxv5uwDW3Yrl7uttWDHe3SsqqxNW9Q>
    <xmx:c808YOndenmsOsx0aVoA4sOkGWObN3Fj9asa5LjFXUV9VGoV9v_NNQ>
    <xmx:c808YNx2cg11Q_8sBhz9u1NQYdyci1K3qLarZ1imU7CN4w9ax5dF0w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id F22DF240057;
        Mon,  1 Mar 2021 06:18:10 -0500 (EST)
Subject: FAILED: patch "[PATCH] media: smipcie: fix interrupt handling and IR timeout" failed to apply to 5.4-stable tree
To:     sean@mess.org, lazlev@web.de, mchehab+huawei@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 12:18:09 +0100
Message-ID: <161459748923477@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6532923237b427ed30cc7b4486f6f1ccdee3c647 Mon Sep 17 00:00:00 2001
From: Sean Young <sean@mess.org>
Date: Fri, 29 Jan 2021 11:54:53 +0100
Subject: [PATCH] media: smipcie: fix interrupt handling and IR timeout

After the first IR message, interrupts are no longer received. In addition,
the code generates a timeout IR message of 10ms but sets the timeout value
to 100ms, so no timeout was ever generated.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=204317

Fixes: a49a7a4635de ("media: smipcie: add universal ir capability")
Tested-by: Laz Lev <lazlev@web.de>
Cc: stable@vger.kernel.org # v5.1+
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/drivers/media/pci/smipcie/smipcie-ir.c b/drivers/media/pci/smipcie/smipcie-ir.c
index e6b74e161a05..c0604d9c7011 100644
--- a/drivers/media/pci/smipcie/smipcie-ir.c
+++ b/drivers/media/pci/smipcie/smipcie-ir.c
@@ -60,38 +60,44 @@ static void smi_ir_decode(struct smi_rc *ir)
 {
 	struct smi_dev *dev = ir->dev;
 	struct rc_dev *rc_dev = ir->rc_dev;
-	u32 dwIRControl, dwIRData;
-	u8 index, ucIRCount, readLoop;
+	u32 control, data;
+	u8 index, ir_count, read_loop;
 
-	dwIRControl = smi_read(IR_Init_Reg);
+	control = smi_read(IR_Init_Reg);
 
-	if (dwIRControl & rbIRVld) {
-		ucIRCount = (u8) smi_read(IR_Data_Cnt);
+	dev_dbg(&rc_dev->dev, "ircontrol: 0x%08x\n", control);
 
-		readLoop = ucIRCount/4;
-		if (ucIRCount % 4)
-			readLoop += 1;
-		for (index = 0; index < readLoop; index++) {
-			dwIRData = smi_read(IR_DATA_BUFFER_BASE + (index * 4));
+	if (control & rbIRVld) {
+		ir_count = (u8)smi_read(IR_Data_Cnt);
 
-			ir->irData[index*4 + 0] = (u8)(dwIRData);
-			ir->irData[index*4 + 1] = (u8)(dwIRData >> 8);
-			ir->irData[index*4 + 2] = (u8)(dwIRData >> 16);
-			ir->irData[index*4 + 3] = (u8)(dwIRData >> 24);
+		dev_dbg(&rc_dev->dev, "ircount %d\n", ir_count);
+
+		read_loop = ir_count / 4;
+		if (ir_count % 4)
+			read_loop += 1;
+		for (index = 0; index < read_loop; index++) {
+			data = smi_read(IR_DATA_BUFFER_BASE + (index * 4));
+			dev_dbg(&rc_dev->dev, "IRData 0x%08x\n", data);
+
+			ir->irData[index * 4 + 0] = (u8)(data);
+			ir->irData[index * 4 + 1] = (u8)(data >> 8);
+			ir->irData[index * 4 + 2] = (u8)(data >> 16);
+			ir->irData[index * 4 + 3] = (u8)(data >> 24);
 		}
-		smi_raw_process(rc_dev, ir->irData, ucIRCount);
-		smi_set(IR_Init_Reg, rbIRVld);
+		smi_raw_process(rc_dev, ir->irData, ir_count);
 	}
 
-	if (dwIRControl & rbIRhighidle) {
+	if (control & rbIRhighidle) {
 		struct ir_raw_event rawir = {};
 
+		dev_dbg(&rc_dev->dev, "high idle\n");
+
 		rawir.pulse = 0;
 		rawir.duration = SMI_SAMPLE_PERIOD * SMI_SAMPLE_IDLEMIN;
 		ir_raw_event_store_with_filter(rc_dev, &rawir);
-		smi_set(IR_Init_Reg, rbIRhighidle);
 	}
 
+	smi_set(IR_Init_Reg, rbIRVld);
 	ir_raw_event_handle(rc_dev);
 }
 
@@ -150,7 +156,7 @@ int smi_ir_init(struct smi_dev *dev)
 	rc_dev->dev.parent = &dev->pci_dev->dev;
 
 	rc_dev->map_name = dev->info->rc_map;
-	rc_dev->timeout = MS_TO_US(100);
+	rc_dev->timeout = SMI_SAMPLE_PERIOD * SMI_SAMPLE_IDLEMIN;
 	rc_dev->rx_resolution = SMI_SAMPLE_PERIOD;
 
 	ir->rc_dev = rc_dev;
@@ -173,7 +179,7 @@ void smi_ir_exit(struct smi_dev *dev)
 	struct smi_rc *ir = &dev->ir;
 	struct rc_dev *rc_dev = ir->rc_dev;
 
-	smi_ir_stop(ir);
 	rc_unregister_device(rc_dev);
+	smi_ir_stop(ir);
 	ir->rc_dev = NULL;
 }

