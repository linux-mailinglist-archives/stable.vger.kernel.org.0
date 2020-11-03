Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAA02A47F9
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbgKCOYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:24:11 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:52297 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729286AbgKCOXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 09:23:25 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 3AF9AC6B;
        Tue,  3 Nov 2020 09:23:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 09:23:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=yzEQW/
        jFZw/zny1leIRY867Rdd3o8yUO2NoWzGreIDE=; b=UV+o+A5oEhoHxnk1ctYQD/
        iwKZzrJiSa/3VLIxSI7SpcvVqsLp5SgDBfr32h9rbIH3FSIJhYU4K44drHuZ4Ra+
        OIg7pCBh7CQ3wEJ5/A75XEijG1DB5eZb7BWmmgQLFFRnogsJrTrb4OCFHVj4jZ14
        4GnyvMO2z42rVi8M/HMgmYpztjMkZb6IRlKZy3L3GtNT2hN0755ka/PWTw6vLXOt
        jwPquEA2OlQcZJLf52ZAeFZ2fEOI7KUG5xZ4Tjaxljfb7oAWIBOCymWyhai3Wqwp
        oNLAX/mgTTLvca/60MSUJgh8EuNLFLZgEvZvcylFnVs2ZuVRG4+ByyUDQsxRsoXA
        ==
X-ME-Sender: <xms:22ehXz-A_ZFJhZlW2nfWqN5-Uaow8uuYxOGa76JWczAyeuhWmhOwfg>
    <xme:22ehX_tQMg4iarQF7G3T00jAPTNn-85-JuV_APBlwUYzgQTgHL9azlWjKbIQWDmcI
    U-d_HSiOOxCxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:22ehXxBV8oimGh5mUq77-lG-yp57OPDAzJ6i6h7o7M3SqlRZG79XQw>
    <xmx:22ehX_cDPpfWTuA2-YOqiGOP1YdBHPZVAFasCV-GtdG9dKvggeGrRA>
    <xmx:22ehX4Ne7zI6k0m0-p3HG_MqXTSGyfVwsiipYZkb26hwBize_vYOqQ>
    <xmx:22ehXyUEr41phejDkbrkw90Y3p8lI5viv1S7PZbRSJX33q6qAVMYkoJquQM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 12BE93280065;
        Tue,  3 Nov 2020 09:23:22 -0500 (EST)
Subject: FAILED: patch "[PATCH] null_blk: Fix zone reset all tracing" failed to apply to 5.9-stable tree
To:     damien.lemoal@wdc.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 15:24:07 +0100
Message-ID: <16044134474538@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f9c9104288da543cd64f186f9e2fba389f415630 Mon Sep 17 00:00:00 2001
From: Damien Le Moal <damien.lemoal@wdc.com>
Date: Thu, 29 Oct 2020 20:04:59 +0900
Subject: [PATCH] null_blk: Fix zone reset all tracing

In the cae of the REQ_OP_ZONE_RESET_ALL operation, the command sector is
ignored and the operation is applied to all sequential zones. For these
commands, tracing the effect of the command using the command sector to
determine the target zone is thus incorrect.

Fix null_zone_mgmt() zone condition tracing in the case of
REQ_OP_ZONE_RESET_ALL to apply tracing to all sequential zones that are
not already empty.

Fixes: 766c3297d7e1 ("null_blk: add trace in null_blk_zoned.c")
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
index 98056c88926b..b637b16a5f54 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -475,9 +475,14 @@ static blk_status_t null_zone_mgmt(struct nullb_cmd *cmd, enum req_opf op,
 
 	switch (op) {
 	case REQ_OP_ZONE_RESET_ALL:
-		for (i = dev->zone_nr_conv; i < dev->nr_zones; i++)
-			null_reset_zone(dev, &dev->zones[i]);
-		break;
+		for (i = dev->zone_nr_conv; i < dev->nr_zones; i++) {
+			zone = &dev->zones[i];
+			if (zone->cond != BLK_ZONE_COND_EMPTY) {
+				null_reset_zone(dev, zone);
+				trace_nullb_zone_op(cmd, i, zone->cond);
+			}
+		}
+		return BLK_STS_OK;
 	case REQ_OP_ZONE_RESET:
 		ret = null_reset_zone(dev, zone);
 		break;

