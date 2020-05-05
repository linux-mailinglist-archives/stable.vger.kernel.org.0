Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9CDD1C542E
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 13:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgEELPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 07:15:10 -0400
Received: from www.linuxtv.org ([130.149.80.248]:54120 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728565AbgEELPJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 07:15:09 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1jVvUK-00CdoV-NI; Tue, 05 May 2020 11:11:48 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 05 May 2020 11:12:03 +0000
Subject: [git:media_tree/master] media: staging: ipu3-imgu: Move alignment attribute to field
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1jVvUK-00CdoV-NI@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: staging: ipu3-imgu: Move alignment attribute to field
Author:  Sakari Ailus <sakari.ailus@linux.intel.com>
Date:    Wed Apr 15 17:40:09 2020 +0200

Move the alignment attribute of struct ipu3_uapi_awb_fr_config_s to the
field in struct ipu3_uapi_4a_config, the other location where the struct
is used.

Fixes: commit c9d52c114a9f ("media: staging: imgu: Address a compiler warning on alignment")
Reported-by: Tomasz Figa <tfiga@chromium.org>
Tested-by: Bingbu Cao <bingbu.cao@intel.com>
Cc: stable@vger.kernel.org # for v5.3 and up
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/staging/media/ipu3/include/intel-ipu3.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

---

diff --git a/drivers/staging/media/ipu3/include/intel-ipu3.h b/drivers/staging/media/ipu3/include/intel-ipu3.h
index 5f43f631cf62..a607b0158c81 100644
--- a/drivers/staging/media/ipu3/include/intel-ipu3.h
+++ b/drivers/staging/media/ipu3/include/intel-ipu3.h
@@ -450,7 +450,7 @@ struct ipu3_uapi_awb_fr_config_s {
 	__u32 bayer_sign;
 	__u8 bayer_nf;
 	__u8 reserved2[7];
-} __attribute__((aligned(32))) __packed;
+} __packed;
 
 /**
  * struct ipu3_uapi_4a_config - 4A config
@@ -466,7 +466,8 @@ struct ipu3_uapi_4a_config {
 	struct ipu3_uapi_ae_grid_config ae_grd_config;
 	__u8 padding[20];
 	struct ipu3_uapi_af_config_s af_config;
-	struct ipu3_uapi_awb_fr_config_s awb_fr_config;
+	struct ipu3_uapi_awb_fr_config_s awb_fr_config
+		__attribute__((aligned(32)));
 } __packed;
 
 /**
