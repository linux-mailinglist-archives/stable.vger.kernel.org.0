Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E875E1F6B61
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 17:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbgFKPqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 11:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728708AbgFKPqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 11:46:03 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE88C08C5C1;
        Thu, 11 Jun 2020 08:46:02 -0700 (PDT)
Received: from localhost.localdomain (p200300cb871f5b00895b3f12fcab1eee.dip0.t-ipconnect.de [IPv6:2003:cb:871f:5b00:895b:3f12:fcab:1eee])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dafna)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 663312A50A8;
        Thu, 11 Jun 2020 16:46:01 +0100 (BST)
From:   Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
To:     linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Cc:     dafna.hirschfeld@collabora.com, helen.koike@collabora.com,
        ezequiel@collabora.com, hverkuil@xs4all.nl, kernel@collabora.com,
        dafna3@gmail.com, sakari.ailus@linux.intel.com,
        linux-rockchip@lists.infradead.org, mchehab@kernel.org,
        tfiga@chromium.org, stable@vger.kernel.org
Subject: [RESEND PATCH v3 6/6] media: staging: rkisp1: common: add documentation for struct rkisp1_isp_mbus_info
Date:   Thu, 11 Jun 2020 17:45:51 +0200
Message-Id: <20200611154551.25022-7-dafna.hirschfeld@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200611154551.25022-1-dafna.hirschfeld@collabora.com>
References: <20200611154551.25022-1-dafna.hirschfeld@collabora.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add documentation for the struct rkisp1_isp_mbus_info with
one line doc of each field

Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
---
 drivers/staging/media/rkisp1/rkisp1-common.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/staging/media/rkisp1/rkisp1-common.h b/drivers/staging/media/rkisp1/rkisp1-common.h
index 13c5eeff66f3..6104eddac0e5 100644
--- a/drivers/staging/media/rkisp1/rkisp1-common.h
+++ b/drivers/staging/media/rkisp1/rkisp1-common.h
@@ -268,6 +268,19 @@ struct rkisp1_device {
 	struct rkisp1_debug debug;
 };
 
+/*
+ * struct rkisp1_isp_mbus_info
+ *
+ * holds information about the supported isp media bus
+ * @mbus_code: the media bus code
+ * @pixel_enc: the pixel encoding
+ * @mipi_dt: the mipi data type
+ * @yuv_seq: the order of the yuv values for yuv formats
+ * @bus_width: the bus width
+ * @bayer_pat: the bayer pattern for bayer formats
+ * @isp_pads_mask: a bitmask of the pads that the format is supported on
+ */
+
 /*
  * struct rkisp1_isp_mbus_info - ISP pad format info
  *
-- 
2.17.1

