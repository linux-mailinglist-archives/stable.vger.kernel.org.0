Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D9F1F6B24
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 17:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgFKPfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 11:35:40 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50942 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728560AbgFKPfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 11:35:39 -0400
Received: from localhost.localdomain (p200300cb871f5b00895b3f12fcab1eee.dip0.t-ipconnect.de [IPv6:2003:cb:871f:5b00:895b:3f12:fcab:1eee])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dafna)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 4463F2A5093;
        Thu, 11 Jun 2020 16:35:37 +0100 (BST)
From:   Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
To:     linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Cc:     dafna.hirschfeld@collabora.com, helen.koike@collabora.com,
        ezequiel@collabora.com, hverkuil@xs4all.nl, kernel@collabora.com,
        dafna3@gmail.com, sakari.ailus@linux.intel.com,
        linux-rockchip@lists.infradead.org, mchehab@kernel.org,
        tfiga@chromium.org, stable@vger.kernel.org
Subject: [PATCH v3 4/4] media: staging: rkisp1: common: add documentation for struct rkisp1_isp_mbus_info
Date:   Thu, 11 Jun 2020 17:35:27 +0200
Message-Id: <20200611153527.24506-5-dafna.hirschfeld@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200611153527.24506-1-dafna.hirschfeld@collabora.com>
References: <20200611153527.24506-1-dafna.hirschfeld@collabora.com>
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

