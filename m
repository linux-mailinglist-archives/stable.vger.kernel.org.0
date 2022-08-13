Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35B0591A9B
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 15:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239464AbiHMN2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 09:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239463AbiHMN2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 09:28:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633525A3F6
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 06:28:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F16A860DDC
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 13:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0379EC433D6;
        Sat, 13 Aug 2022 13:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660397279;
        bh=Il0krGzQGe6pIlivImYXuqDKrhAnMco+Yi0uekDBpcc=;
        h=Subject:To:Cc:From:Date:From;
        b=YO+Q74Gpf8dbGQc9DLHBwi0ipu3AyA6aDgVfyBx0+mIJMjQgXYkWVVU3we1tMlK0c
         FSXAZmUsmSO919Ij0WyqvOqBIfVM1jsUoKrHwb4VXvOr1KCMdPjPFZEsFPzhdRM+lm
         Fq/oAGhX40B6a3xcqrItWOiEtGKrOSJzjA2t5Tpo=
Subject: WTF: patch "[PATCH] scsi: qla2xxx: Update manufacturer details" was seriously submitted to be applied to the 5.19-stable tree?
To:     bhazarika@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 15:27:57 +0200
Message-ID: <16603972763674@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 5.19-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1ccad27716ecad1fd58c35e579bedb81fa5e1ad5 Mon Sep 17 00:00:00 2001
From: Bikash Hazarika <bhazarika@marvell.com>
Date: Tue, 12 Jul 2022 22:20:44 -0700
Subject: [PATCH] scsi: qla2xxx: Update manufacturer details

Update manufacturer details to indicate Marvell Semiconductors.

Link: https://lore.kernel.org/r/20220713052045.10683-10-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 91c8fedc8ffa..3ec6a200942e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -78,7 +78,7 @@ typedef union {
 #include "qla_nvme.h"
 #define QLA2XXX_DRIVER_NAME	"qla2xxx"
 #define QLA2XXX_APIDEV		"ql2xapidev"
-#define QLA2XXX_MANUFACTURER	"QLogic Corporation"
+#define QLA2XXX_MANUFACTURER	"Marvell Semiconductor, Inc."
 
 /*
  * We have MAILBOX_REGISTER_COUNT sized arrays in a few places,
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 7ca734337000..64ab070b8716 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1616,7 +1616,7 @@ qla2x00_hba_attributes(scsi_qla_host_t *vha, void *entries,
 	eiter->type = cpu_to_be16(FDMI_HBA_MANUFACTURER);
 	alen = scnprintf(
 		eiter->a.manufacturer, sizeof(eiter->a.manufacturer),
-		"%s", "QLogic Corporation");
+		"%s", QLA2XXX_MANUFACTURER);
 	alen += FDMI_ATTR_ALIGNMENT(alen);
 	alen += FDMI_ATTR_TYPELEN(eiter);
 	eiter->len = cpu_to_be16(alen);

