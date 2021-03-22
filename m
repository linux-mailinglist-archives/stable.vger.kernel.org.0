Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4020F343C77
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 10:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhCVJPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 05:15:10 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:56247 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229548AbhCVJOw (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 22 Mar 2021 05:14:52 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 22C761569;
        Mon, 22 Mar 2021 05:14:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 22 Mar 2021 05:14:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mVvQNL
        UFXAfbZPPIT6tto3NpwMq8fIlNzEm3s8gMpFI=; b=JXtiNkF19OuMjOeIGJmbpL
        04S2HyVjwt3kHbOOQQK8yYtq7RbfuohErUcu33DAK/KTX9pkIsyEdOJ67CWRBzSL
        FbqwxZBGEsZaMpWbxubOSd2TlVse8/qvbpKgHZrz0LVNOrexmLBgiQaqBWNWriSS
        nkf+m+uGopeDy7PtV3LEmZpJRIuvByoAvBQGfAKGmBsAUdEgq8OhKx9Px2PI/srF
        FZC9XHecl6FNK95ifqW+B6UZUmVHRLv29i/hPYTcRPxQrtuj33MkUx1YwzMyvpiR
        CvjAZJd3WbzuxqF3RIP6qs4loOi95ShaUkwxsDNZyOU32k6XhUuNyZXM8B7QlC7w
        ==
X-ME-Sender: <xms:CmBYYOMkngSCnlrIZnbievdWzvq3f-SZ3ezS-oSv-RZtolYHzYB6uA>
    <xme:CmBYYM_Csy-wKKe8EfkYL79BMmKIrP6ahGtwABPVxcwgRx5s9UTsxCC41V1MoI3JS
    T1XYbjVeRG5tA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttdflne
    cuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgqeen
    ucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekgeefle
    egieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:C2BYYFRExODolWaY1EQN6oi3evTnGzA2qD6kINOVuXav0UVXwaIn5Q>
    <xmx:C2BYYOv7RyMb0MW8hSz47wAThHFwOP0RQqT1US27R-65cZ3o_l9lFg>
    <xmx:C2BYYGcp4_QfZFbvQMKqH2LtgPDoOis9zOEDkJRfIqiMm3liDjxA2g>
    <xmx:C2BYYOkXLhQ7Q8tDfpaf_uu2iBFpqtVWqC8mzv2mjgOlwOQEJORpu45_yqE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B7CE8108005F;
        Mon, 22 Mar 2021 05:14:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: hid-sensor-prox: Fix scale not correct issue" failed to apply to 4.9-stable tree
To:     xiang.ye@intel.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Mar 2021 10:14:40 +0100
Message-ID: <16164044805955@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d68c592e02f6f49a88e705f13dfc1883432cf300 Mon Sep 17 00:00:00 2001
From: Ye Xiang <xiang.ye@intel.com>
Date: Sat, 30 Jan 2021 18:25:30 +0800
Subject: [PATCH] iio: hid-sensor-prox: Fix scale not correct issue

Currently, the proxy sensor scale is zero because it just return the
exponent directly. To fix this issue, this patch use
hid_sensor_format_scale to process the scale first then return the
output.

Fixes: 39a3a0138f61 ("iio: hid-sensors: Added Proximity Sensor Driver")
Signed-off-by: Ye Xiang <xiang.ye@intel.com>
Link: https://lore.kernel.org/r/20210130102530.31064-1-xiang.ye@intel.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/light/hid-sensor-prox.c b/drivers/iio/light/hid-sensor-prox.c
index 330cf359e0b8..e9e00ce0c6d4 100644
--- a/drivers/iio/light/hid-sensor-prox.c
+++ b/drivers/iio/light/hid-sensor-prox.c
@@ -23,6 +23,9 @@ struct prox_state {
 	struct hid_sensor_common common_attributes;
 	struct hid_sensor_hub_attribute_info prox_attr;
 	u32 human_presence;
+	int scale_pre_decml;
+	int scale_post_decml;
+	int scale_precision;
 };
 
 /* Channel definitions */
@@ -93,8 +96,9 @@ static int prox_read_raw(struct iio_dev *indio_dev,
 		ret_type = IIO_VAL_INT;
 		break;
 	case IIO_CHAN_INFO_SCALE:
-		*val = prox_state->prox_attr.units;
-		ret_type = IIO_VAL_INT;
+		*val = prox_state->scale_pre_decml;
+		*val2 = prox_state->scale_post_decml;
+		ret_type = prox_state->scale_precision;
 		break;
 	case IIO_CHAN_INFO_OFFSET:
 		*val = hid_sensor_convert_exponent(
@@ -234,6 +238,11 @@ static int prox_parse_report(struct platform_device *pdev,
 			HID_USAGE_SENSOR_HUMAN_PRESENCE,
 			&st->common_attributes.sensitivity);
 
+	st->scale_precision = hid_sensor_format_scale(
+				hsdev->usage,
+				&st->prox_attr,
+				&st->scale_pre_decml, &st->scale_post_decml);
+
 	return ret;
 }
 

