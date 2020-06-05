Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F761EFDBF
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbgFEQ1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727960AbgFEQ0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:26:30 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF578C08C5C3;
        Fri,  5 Jun 2020 09:26:29 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id r10so5335733pgv.8;
        Fri, 05 Jun 2020 09:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+N3kHSDVqsZFY1+BCJ77exstXC1iacuDolQw5ImyaQI=;
        b=kVNXoR7jUWvZV/msL11C9fbekmco3642TFubX0dWjh6lDrDHirKHkcY6dO19O56c+h
         RtjFWh9cjQf00mWUUc8xslHZNWdQQIMi9Mjoh/BN143lUNMN+pTRZHAqIB9tabqCbuaZ
         tJzNhAUfnJAg/VmNAH178wr4lqs3rvXlM/c2pqk0GBze5R+3o1kwKtPuhPCF9Z8OaRZa
         aIItA4fJEDhQ6wYSllzILB5GsAIIv82A+Yj86tCvHOvDfWrEOOT3Hs4AHa2eNErnkkQA
         kbaMFEuWLrMdIY/hm08P+WxEkfhwe0OLoVha79XxrrgIzVOQV9W20ph1gF3up0E/BRMp
         79Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+N3kHSDVqsZFY1+BCJ77exstXC1iacuDolQw5ImyaQI=;
        b=gS3Jb7/lHoPpneQc6pc71DtRbfgnBhf7eOV+khoxE+Tktnk8BFmGJvqaT0xZluPddt
         DxC0XXMwfdm7q+Zlalq4vbMt9mU6zW1thrhj9JGAJYcoELRgjkXA/wHftSS+RRmGU/nW
         wRMTXdnBB9VLXthqZ4KdqffPohl6WVJRm0Gi2t5A10reWq7Elzl4PBGzpf1cr3S9ibwl
         +1ntNb4Yf2n1+byCfPQikfU2tMHDu9FzRQ6XvNVyIpCUUvSZIpEnWQ9xynZ445OSnBQz
         38NrLzK47vbGTTGKzfGlYctAOe0wxPAlqBAQDJiE37gAzbHus9AUi1L5TyEG9mjI4Vk1
         mlOA==
X-Gm-Message-State: AOAM533DKg6HMHAF++DHNxS9bvwbOH/ytXCsA/gd2O9TwaMhrP6bitfh
        wAesygXblAB+bDIj1vnxCq5ngct7
X-Google-Smtp-Source: ABdhPJyk+hTQeHsRrR7Z4Qwxfy7FC+HeakH0C66nlgKJ0BthdauidvpXSGEw06q35gNh5jA6XnCTlA==
X-Received: by 2002:a62:4e83:: with SMTP id c125mr11030510pfb.165.1591374388926;
        Fri, 05 Jun 2020 09:26:28 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:26:28 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
X-Google-Original-From: Florian Fainelli <florian.fainelli@broadcom.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE
        (V4L/DVB)),
        linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and
        infrastructure))
Subject: [PATCH stable 4.9 15/21] media: dvb_frontend: dtv_property_process_set() cleanups
Date:   Fri,  5 Jun 2020 09:25:12 -0700
Message-Id: <20200605162518.28099-16-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Satendra Singh Thakur <satendra.t@samsung.com>

commit media: dvb_frontend: dtv_property_process_set() cleanups upstream

Since all properties in the func dtv_property_process_set() use
at most 4 bytes arguments, change the code to pass
u32 cmd and u32 data as function arguments, instead of passing a
pointer to the entire struct dtv_property *tvp.

Instead of having a generic dtv_property_dump(), added its own
properties debug logic in the dtv_property_process_set().

Signed-off-by: Satendra Singh Thakur <satendra.t@samsung.com>
Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 125 +++++++++++++++-----------
 1 file changed, 72 insertions(+), 53 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index ca4959bbb6c2..a9ae9e509205 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1088,22 +1088,19 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
 	_DTV_CMD(DTV_STAT_TOTAL_BLOCK_COUNT, 0, 0),
 };
 
-static void dtv_property_dump(struct dvb_frontend *fe,
-			      bool is_set,
+static void dtv_get_property_dump(struct dvb_frontend *fe,
 			      struct dtv_property *tvp)
 {
 	int i;
 
 	if (tvp->cmd <= 0 || tvp->cmd > DTV_MAX_COMMAND) {
-		dev_warn(fe->dvb->device, "%s: %s tvp.cmd = 0x%08x undefined\n",
-				__func__,
-				is_set ? "SET" : "GET",
+		dev_warn(fe->dvb->device, "%s: GET tvp.cmd = 0x%08x undefined\n"
+				, __func__,
 				tvp->cmd);
 		return;
 	}
 
-	dev_dbg(fe->dvb->device, "%s: %s tvp.cmd    = 0x%08x (%s)\n", __func__,
-		is_set ? "SET" : "GET",
+	dev_dbg(fe->dvb->device, "%s: GET tvp.cmd    = 0x%08x (%s)\n", __func__,
 		tvp->cmd,
 		dtv_cmds[tvp->cmd].name);
 
@@ -1513,7 +1510,7 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 		return -EINVAL;
 	}
 
-	dtv_property_dump(fe, false, tvp);
+	dtv_get_property_dump(fe, tvp);
 
 	return 0;
 }
@@ -1740,16 +1737,36 @@ static int dvbv3_set_delivery_system(struct dvb_frontend *fe)
 	return emulate_delivery_system(fe, delsys);
 }
 
+/**
+ * dtv_property_process_set -  Sets a single DTV property
+ * @fe:		Pointer to &struct dvb_frontend
+ * @file:	Pointer to &struct file
+ * @cmd:	Digital TV command
+ * @data:	An unsigned 32-bits number
+ *
+ * This routine assigns the property
+ * value to the corresponding member of
+ * &struct dtv_frontend_properties
+ *
+ * Returns:
+ * Zero on success, negative errno on failure.
+ */
 static int dtv_property_process_set(struct dvb_frontend *fe,
-				    struct dtv_property *tvp,
-				    struct file *file)
+					struct file *file,
+					u32 cmd, u32 data)
 {
 	int r = 0;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	dtv_property_dump(fe, true, tvp);
-
-	switch(tvp->cmd) {
+	/** Dump DTV command name and value*/
+	if (!cmd || cmd > DTV_MAX_COMMAND)
+		dev_warn(fe->dvb->device, "%s: SET cmd 0x%08x undefined\n",
+				 __func__, cmd);
+	else
+		dev_dbg(fe->dvb->device,
+				"%s: SET cmd 0x%08x (%s) to 0x%08x\n",
+				__func__, cmd, dtv_cmds[cmd].name, data);
+	switch (cmd) {
 	case DTV_CLEAR:
 		/*
 		 * Reset a cache of data specific to the frontend here. This does
@@ -1769,133 +1786,133 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		r = dtv_set_frontend(fe);
 		break;
 	case DTV_FREQUENCY:
-		c->frequency = tvp->u.data;
+		c->frequency = data;
 		break;
 	case DTV_MODULATION:
-		c->modulation = tvp->u.data;
+		c->modulation = data;
 		break;
 	case DTV_BANDWIDTH_HZ:
-		c->bandwidth_hz = tvp->u.data;
+		c->bandwidth_hz = data;
 		break;
 	case DTV_INVERSION:
-		c->inversion = tvp->u.data;
+		c->inversion = data;
 		break;
 	case DTV_SYMBOL_RATE:
-		c->symbol_rate = tvp->u.data;
+		c->symbol_rate = data;
 		break;
 	case DTV_INNER_FEC:
-		c->fec_inner = tvp->u.data;
+		c->fec_inner = data;
 		break;
 	case DTV_PILOT:
-		c->pilot = tvp->u.data;
+		c->pilot = data;
 		break;
 	case DTV_ROLLOFF:
-		c->rolloff = tvp->u.data;
+		c->rolloff = data;
 		break;
 	case DTV_DELIVERY_SYSTEM:
-		r = dvbv5_set_delivery_system(fe, tvp->u.data);
+		r = dvbv5_set_delivery_system(fe, data);
 		break;
 	case DTV_VOLTAGE:
-		c->voltage = tvp->u.data;
+		c->voltage = data;
 		r = dvb_frontend_handle_ioctl(file, FE_SET_VOLTAGE,
 			(void *)c->voltage);
 		break;
 	case DTV_TONE:
-		c->sectone = tvp->u.data;
+		c->sectone = data;
 		r = dvb_frontend_handle_ioctl(file, FE_SET_TONE,
 			(void *)c->sectone);
 		break;
 	case DTV_CODE_RATE_HP:
-		c->code_rate_HP = tvp->u.data;
+		c->code_rate_HP = data;
 		break;
 	case DTV_CODE_RATE_LP:
-		c->code_rate_LP = tvp->u.data;
+		c->code_rate_LP = data;
 		break;
 	case DTV_GUARD_INTERVAL:
-		c->guard_interval = tvp->u.data;
+		c->guard_interval = data;
 		break;
 	case DTV_TRANSMISSION_MODE:
-		c->transmission_mode = tvp->u.data;
+		c->transmission_mode = data;
 		break;
 	case DTV_HIERARCHY:
-		c->hierarchy = tvp->u.data;
+		c->hierarchy = data;
 		break;
 	case DTV_INTERLEAVING:
-		c->interleaving = tvp->u.data;
+		c->interleaving = data;
 		break;
 
 	/* ISDB-T Support here */
 	case DTV_ISDBT_PARTIAL_RECEPTION:
-		c->isdbt_partial_reception = tvp->u.data;
+		c->isdbt_partial_reception = data;
 		break;
 	case DTV_ISDBT_SOUND_BROADCASTING:
-		c->isdbt_sb_mode = tvp->u.data;
+		c->isdbt_sb_mode = data;
 		break;
 	case DTV_ISDBT_SB_SUBCHANNEL_ID:
-		c->isdbt_sb_subchannel = tvp->u.data;
+		c->isdbt_sb_subchannel = data;
 		break;
 	case DTV_ISDBT_SB_SEGMENT_IDX:
-		c->isdbt_sb_segment_idx = tvp->u.data;
+		c->isdbt_sb_segment_idx = data;
 		break;
 	case DTV_ISDBT_SB_SEGMENT_COUNT:
-		c->isdbt_sb_segment_count = tvp->u.data;
+		c->isdbt_sb_segment_count = data;
 		break;
 	case DTV_ISDBT_LAYER_ENABLED:
-		c->isdbt_layer_enabled = tvp->u.data;
+		c->isdbt_layer_enabled = data;
 		break;
 	case DTV_ISDBT_LAYERA_FEC:
-		c->layer[0].fec = tvp->u.data;
+		c->layer[0].fec = data;
 		break;
 	case DTV_ISDBT_LAYERA_MODULATION:
-		c->layer[0].modulation = tvp->u.data;
+		c->layer[0].modulation = data;
 		break;
 	case DTV_ISDBT_LAYERA_SEGMENT_COUNT:
-		c->layer[0].segment_count = tvp->u.data;
+		c->layer[0].segment_count = data;
 		break;
 	case DTV_ISDBT_LAYERA_TIME_INTERLEAVING:
-		c->layer[0].interleaving = tvp->u.data;
+		c->layer[0].interleaving = data;
 		break;
 	case DTV_ISDBT_LAYERB_FEC:
-		c->layer[1].fec = tvp->u.data;
+		c->layer[1].fec = data;
 		break;
 	case DTV_ISDBT_LAYERB_MODULATION:
-		c->layer[1].modulation = tvp->u.data;
+		c->layer[1].modulation = data;
 		break;
 	case DTV_ISDBT_LAYERB_SEGMENT_COUNT:
-		c->layer[1].segment_count = tvp->u.data;
+		c->layer[1].segment_count = data;
 		break;
 	case DTV_ISDBT_LAYERB_TIME_INTERLEAVING:
-		c->layer[1].interleaving = tvp->u.data;
+		c->layer[1].interleaving = data;
 		break;
 	case DTV_ISDBT_LAYERC_FEC:
-		c->layer[2].fec = tvp->u.data;
+		c->layer[2].fec = data;
 		break;
 	case DTV_ISDBT_LAYERC_MODULATION:
-		c->layer[2].modulation = tvp->u.data;
+		c->layer[2].modulation = data;
 		break;
 	case DTV_ISDBT_LAYERC_SEGMENT_COUNT:
-		c->layer[2].segment_count = tvp->u.data;
+		c->layer[2].segment_count = data;
 		break;
 	case DTV_ISDBT_LAYERC_TIME_INTERLEAVING:
-		c->layer[2].interleaving = tvp->u.data;
+		c->layer[2].interleaving = data;
 		break;
 
 	/* Multistream support */
 	case DTV_STREAM_ID:
 	case DTV_DVBT2_PLP_ID_LEGACY:
-		c->stream_id = tvp->u.data;
+		c->stream_id = data;
 		break;
 
 	/* ATSC-MH */
 	case DTV_ATSCMH_PARADE_ID:
-		fe->dtv_property_cache.atscmh_parade_id = tvp->u.data;
+		fe->dtv_property_cache.atscmh_parade_id = data;
 		break;
 	case DTV_ATSCMH_RS_FRAME_ENSEMBLE:
-		fe->dtv_property_cache.atscmh_rs_frame_ensemble = tvp->u.data;
+		fe->dtv_property_cache.atscmh_rs_frame_ensemble = data;
 		break;
 
 	case DTV_LNA:
-		c->lna = tvp->u.data;
+		c->lna = data;
 		if (fe->ops.set_lna)
 			r = fe->ops.set_lna(fe);
 		if (r < 0)
@@ -2122,7 +2139,9 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 			return PTR_ERR(tvp);
 
 		for (i = 0; i < tvps->num; i++) {
-			err = dtv_property_process_set(fe, tvp + i, file);
+			err = dtv_property_process_set(fe, file,
+							(tvp + i)->cmd,
+							(tvp + i)->u.data);
 			if (err < 0) {
 				kfree(tvp);
 				return err;
-- 
2.17.1

