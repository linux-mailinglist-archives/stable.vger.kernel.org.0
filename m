Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812BC37B8A9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhELIyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:54:40 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:57269 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230145AbhELIyj (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 12 May 2021 04:54:39 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id C0E7013AC;
        Wed, 12 May 2021 04:53:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 12 May 2021 04:53:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=FQ17hz
        Wv+kSyuMg24Q6MuhcruY5hHV47OJvVuZLIss8=; b=e07vxR37pz5Z1rxnPfYCF4
        /S51vt+6+DUyEKU3q6aUbTaOr2RIP8q+tBJltQeN5Z34YD6nHPSqpEKK4lgeoUhD
        mo7H+rXs3PpgnSd/c/tJuOWmtsZBbfttLrICxSPS/fWGyKHsV9j/ocPQ04ojHN/i
        wYHK9nEOWmo7JhFEk5z8wk1Z11Suqg5SGMDnNwbUqY8Sw1QdqG7lz8PlApuN1ccH
        xT3h30yxBuEatkODzZDTQIXmaNnS0PzUGXXm+1JOkaiZxUw9s4xPfdSzPNnaOnPJ
        RdhWFE54P+eBQ1M8XZ8ruw3UXRdJ/NRLWQYAIw0s7hpJupyIqPJ1VLbuJCaEosNA
        ==
X-ME-Sender: <xms:i5ebYKfQ-r18ELy0EJISXG5vVGfpKKCUGKRQGeBbWmOTjUwTZ1qRtA>
    <xme:i5ebYEP9Kq_tKqiryhiLnitBSa-SY8vd10oyig_Fu4NALedc78oHT1EeHiobWlXEu
    rflrwcjAz_RFA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:i5ebYLhf_L8wXG3eQt4kvePkNssCQP8Tz-apR4FLKPzPUY-FCjDX2w>
    <xmx:i5ebYH99944n9JwUKnMdwyl8bK77089wndBXXTLd404Ix94ciXFnjQ>
    <xmx:i5ebYGtNeEnsjTflzkBqSuC73w7U5-czKyl8Sqqp78yDT9gONqLo-A>
    <xmx:i5ebYLUZi0TsDu5K4XT8FcATMTUWjU2EijcSWcPJpTWXOsZ_DkolCuK_9cE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:53:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: hid-sensor-rotation: Fix quaternion data not correct" failed to apply to 4.19-stable tree
To:     xiang.ye@intel.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:53:18 +0200
Message-ID: <162080959879222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6c3b615379d7cd90d2f70b3cf9860c5a4910546a Mon Sep 17 00:00:00 2001
From: Ye Xiang <xiang.ye@intel.com>
Date: Sat, 30 Jan 2021 18:25:46 +0800
Subject: [PATCH] iio: hid-sensor-rotation: Fix quaternion data not correct

Because the data of HID_USAGE_SENSOR_ORIENT_QUATERNION defined by ISH FW
is s16, but quaternion data type is in_rot_quaternion_type(le:s16/32X4>>0),
need to transform data type from s16 to s32

May require manual backporting.

Fixes: fc18dddc0625 ("iio: hid-sensors: Added device rotation support")
Signed-off-by: Ye Xiang <xiang.ye@intel.com>
Link: https://lore.kernel.org/r/20210130102546.31397-1-xiang.ye@intel.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/orientation/hid-sensor-rotation.c b/drivers/iio/orientation/hid-sensor-rotation.c
index 18e4ef060096..c087d8f72a54 100644
--- a/drivers/iio/orientation/hid-sensor-rotation.c
+++ b/drivers/iio/orientation/hid-sensor-rotation.c
@@ -21,7 +21,7 @@ struct dev_rot_state {
 	struct hid_sensor_common common_attributes;
 	struct hid_sensor_hub_attribute_info quaternion;
 	struct {
-		u32 sampled_vals[4] __aligned(16);
+		s32 sampled_vals[4] __aligned(16);
 		u64 timestamp __aligned(8);
 	} scan;
 	int scale_pre_decml;
@@ -170,8 +170,15 @@ static int dev_rot_capture_sample(struct hid_sensor_hub_device *hsdev,
 	struct dev_rot_state *rot_state = iio_priv(indio_dev);
 
 	if (usage_id == HID_USAGE_SENSOR_ORIENT_QUATERNION) {
-		memcpy(&rot_state->scan.sampled_vals, raw_data,
-		       sizeof(rot_state->scan.sampled_vals));
+		if (raw_len / 4 == sizeof(s16)) {
+			rot_state->scan.sampled_vals[0] = ((s16 *)raw_data)[0];
+			rot_state->scan.sampled_vals[1] = ((s16 *)raw_data)[1];
+			rot_state->scan.sampled_vals[2] = ((s16 *)raw_data)[2];
+			rot_state->scan.sampled_vals[3] = ((s16 *)raw_data)[3];
+		} else {
+			memcpy(&rot_state->scan.sampled_vals, raw_data,
+			       sizeof(rot_state->scan.sampled_vals));
+		}
 
 		dev_dbg(&indio_dev->dev, "Recd Quat len:%zu::%zu\n", raw_len,
 			sizeof(rot_state->scan.sampled_vals));

