Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC02A675BDF
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 18:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjATRpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 12:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjATRpO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 12:45:14 -0500
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 20 Jan 2023 09:45:11 PST
Received: from esa3.hc3370-68.iphmx.com (esa3.hc3370-68.iphmx.com [216.71.145.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC975421B
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 09:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1674236711;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1SWVfim4bIpLHsR6gGejd5wIFwTJ3tRdmqZoP6XwXhg=;
  b=YBVwIIqXDArSOAMRXh9xPJAJ4LInLFcpdyS63e5yjdPpxvEvzFbHgOv1
   0YswQK/Db1huaATtGwnvqYE6OgNkh5VIdM3V/d74K3F+mT45xtHA/YZi6
   zjiota3j1yoxN0sgtgDmETSDKOqLQPKWOJe1WyFzcZlCW8WGMJElFMBOz
   0=;
Authentication-Results: esa3.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
X-SBRS: 4.0
X-MesageID: 93593480
X-Ironport-Server: esa3.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.123
X-Policy: $RELAYED
IronPort-Data: A9a23:Mepx866M0KMyu8CjLlaLEgxRtO3HchMFZxGqfqrLsTDasY5as4F+v
 mcfUGvUbPbfNmD3Kt8ibo/l8BsGvsXVy4BhGVM+ryA2Hi5G8cbLO4+Ufxz6V8+wwm8vb2o8t
 plDNYOQRCwQZiWBzvt4GuG59RGQ7YnRGvynTraBYnoqLeNdYH9JoQp5nOIkiZJfj9G8Agec0
 fv/uMSaM1K+s9JOGjt8B5mr9VU+45wehBtC5gZlPakR5AeE/5UoJMl3yZ+ZfiOQrrZ8RoZWd
 86bpJml82XQ+QsaC9/Nut4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5iXBYoUm9Fii3hojxE4
 I4lWapc6+seFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpdFLjoH4EweZOUlFuhL7W5m7
 t8oLTAdNjS4uaGbz6r4b/l2j/VzBZy+VG8fkikIITDxCP8nRdbIQrnQ5M8e1zA17ixMNa+AP
 YxDM2MpNUmeJUQVYT/7C7pn9AusrmP4aCYerFuaqLAo6mzX5AdwzKLsIJzefdniqcB9zx3F9
 zmarzyR7hcyHtaxlRe8tUuQlO7dwRHYRo4OMPrnz6s/6LGU7jNKU0BHPbehmtGig0G/c91FK
 kke9zAh660/nGSrRdnVWwak5nKJ1jYHR9NaF+AS9g6A0OzX7hyfC2xCSSROAPQkvco7Xnox0
 1aTg/vjHztmvLaSTDSW8bL8hTezPzUFaGkcYCIsSQoe/8KloYc9lBvDQ99vVqmvgbXdECH6x
 D2ioiJ4jLIW5eYI3big9lDvgD+2oJXNCAkv6W3qsnmNt10jItT/PsrxtAadtKwbRGqEcrWfl
 GMnq82e/LgqNq/OuSOVA8AdBriYt9/QZVUwnmVT84kdGyWFoiD8IdoLuWkudS+FIe5fJ2a3P
 Ra7VRd5ocYKYSD0NfIfj5eZUZxC8ET2KTjyuhk4hPJqa4M5SgKI9ToGiaW4jzG0yxhEfU3S1
 P6mnSeQ4ZUyU/4PIMKeHbt17FPS7nlWKZnvbZ761Q+79rGVeWSYT7wIWHPXML9ltf7f+lyLo
 ogOXydv9/m4eLSuChQ7DKZJdQxaRZTFLc6eRzNrmh6rfVM9RTBJ5w75yrI9YY1195m5Zc+Rl
 kxRrnRwkQKl7VWecFXiV5yWQO+3NXqJhS5hbHNE0JfB8yRLXLtDG49GLstnIOJ9qLA4pRO2J
 tFcE/i97j10Ymyv01wggVPV9eSOqDzDadqyAheY
IronPort-HdrOrdr: A9a23:QA2ujqikg8API7hIUEdARDyYi3BQXksji2hC6mlwRA09TyXBrb
 HUoBwavSWE6wr5K0tQ4+xoWZPwME80kKQe3WB/B8bEYOCLggqVxcRZnPPfKl7bal3DH4xmpM
 FdmsFFYbWaYDQU4/oSojPIaurIq+P3kpxA8N2uq0uFOjsaDp2IgT0YNu/RKDwKeOAPP+tEKL
 OsovNdoTyuYHIWadn+KEUkcoH41q72vaOjWAUBARE/7gmIkHeP057VVzal/jp2aUI8/V8FmV
 K15zARIp/Txs1S3HfnphDuBrpt6aXc9uc=
X-IronPort-AV: E=Sophos;i="5.97,232,1669093200"; 
   d="scan'208";a="93593480"
From:   Ross Lagerwall <ross.lagerwall@citrix.com>
To:     <linux-nvme@lists.infradead.org>
CC:     James Smart <james.smart@broadcom.com>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Ross Lagerwall <ross.lagerwall@citrix.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] nvme-fc: Fix initialization order
Date:   Fri, 20 Jan 2023 17:43:54 +0000
Message-ID: <20230120174354.3437046-1-ross.lagerwall@citrix.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ctrl->ops is used by nvme_alloc_admin_tag_set() but set by
nvme_init_ctrl() so reorder the calls to avoid a NULL pointer
dereference.

Fixes: 6dfba1c09c10 ("nvme-fc: use the tagset alloc/free helpers")
Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Cc: stable@vger.kernel.org
---
 drivers/nvme/host/fc.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 4564f16a0b20..456ee42a6133 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3521,13 +3521,6 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 
 	nvme_fc_init_queue(ctrl, 0);
 
-	ret = nvme_alloc_admin_tag_set(&ctrl->ctrl, &ctrl->admin_tag_set,
-			&nvme_fc_admin_mq_ops,
-			struct_size((struct nvme_fcp_op_w_sgl *)NULL, priv,
-				    ctrl->lport->ops->fcprqst_priv_sz));
-	if (ret)
-		goto out_free_queues;
-
 	/*
 	 * Would have been nice to init io queues tag set as well.
 	 * However, we require interaction from the controller
@@ -3537,10 +3530,17 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 
 	ret = nvme_init_ctrl(&ctrl->ctrl, dev, &nvme_fc_ctrl_ops, 0);
 	if (ret)
-		goto out_cleanup_tagset;
+		goto out_free_queues;
 
 	/* at this point, teardown path changes to ref counting on nvme ctrl */
 
+	ret = nvme_alloc_admin_tag_set(&ctrl->ctrl, &ctrl->admin_tag_set,
+			&nvme_fc_admin_mq_ops,
+			struct_size((struct nvme_fcp_op_w_sgl *)NULL, priv,
+				    ctrl->lport->ops->fcprqst_priv_sz));
+	if (ret)
+		goto fail_ctrl;
+
 	spin_lock_irqsave(&rport->lock, flags);
 	list_add_tail(&ctrl->ctrl_list, &rport->ctrl_list);
 	spin_unlock_irqrestore(&rport->lock, flags);
@@ -3592,8 +3592,6 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 
 	return ERR_PTR(-EIO);
 
-out_cleanup_tagset:
-	nvme_remove_admin_tag_set(&ctrl->ctrl);
 out_free_queues:
 	kfree(ctrl->queues);
 out_free_ida:
-- 
2.31.1

