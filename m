Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC102355888
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 17:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346057AbhDFPvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 11:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346058AbhDFPvP (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 6 Apr 2021 11:51:15 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2B1C06174A
        for <Stable@vger.kernel.org>; Tue,  6 Apr 2021 08:51:06 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id x7so14754961wrw.10
        for <Stable@vger.kernel.org>; Tue, 06 Apr 2021 08:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sB3uhrWUFIlrWgy3IF7Nx3Gf9L0Og2hG6FUTVqjECC8=;
        b=tHX73a8vNPTfaQY7sFB1l3hrQY55fIJXZDM2yOdUujC5sIVP74fXzUx4WtcKD7ElOl
         vaLYQTMmYAhe00Wv8kciqCcWgKdHxWsVtTJERs1Pz0x1FZ7JiBtbWTFQW1lJgDtMQtfq
         9/hcmd7ahuRgSevBbIFaU2XTW1h7tUwl7LdDj1yk7ThAhAkBKhdvX6WLDJeUhexbAdzi
         +Ee5nBR8+qFVO48+l1AD/e4XsRZDQa01/13S873otsqhIwn/y4EleiWOXOAjaEXlfWDJ
         9YeRwOvm2i95jK0FK05LguoGCqp5lCSLvGOBz6Dglnwgog6OYnEvvSgpZUYCiC/9MMrc
         o1jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sB3uhrWUFIlrWgy3IF7Nx3Gf9L0Og2hG6FUTVqjECC8=;
        b=DZPOAwhzMbzEp+JVXLe0du8JAlcBxfkyAWkmjQwCGlUnZNhCRw1xFQXocBwRDsc/Yj
         khjbxH14KVjH/FSYZQC6lOw8DRP/l6zvyw6sdygbxyxTyeEfdNpa6FY2Mp0OYxdIN1nz
         RECWmXb7zSagjmK1k+ew4hTGljYL+tzAD+dwsxc/XzIoXbpajsJHeAtxwmLEa2W4OMom
         ouypJeG1q9pn0oIy9JaM3fPnAdhUMo/l8UybKbRLIeXk5l3CZkHkqTv4mNSotCtdK1hB
         G4XfencEcP9pyB54SLUUJPHVR4jSTkKIHPHWtxdREs1ECDllv82dhCstAq6Rs3esn0Kj
         FzQg==
X-Gm-Message-State: AOAM532ZVSeATBHUOZA8bI7qGvUhF1CxJMpXPGFZthrK3GH26VbXmleb
        AVznrOhvP/vPnXreyIwCrBQ=
X-Google-Smtp-Source: ABdhPJxiOd9h9AnYrLNHa6WZCmwzo3kXI18kGKKj6aYiniJVbGlZ+iZwjfrZ6/Gft4skr+7n/qQNsQ==
X-Received: by 2002:adf:f645:: with SMTP id x5mr13791040wrp.314.1617724265478;
        Tue, 06 Apr 2021 08:51:05 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id k16sm12919703wrl.47.2021.04.06.08.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 08:51:05 -0700 (PDT)
Date:   Tue, 6 Apr 2021 16:51:03 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     xiang.ye@intel.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: hid-sensor-prox: Fix scale not
 correct issue" failed to apply to 4.9-stable tree
Message-ID: <YGyDZ/jeAXqypWSa@debian>
References: <16164044805955@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="anw0q34835k+/tsM"
Content-Disposition: inline
In-Reply-To: <16164044805955@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--anw0q34835k+/tsM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Mar 22, 2021 at 10:14:40AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will also apply to 4.4-stable.


--
Regards
Sudip

--anw0q34835k+/tsM
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-iio-hid-sensor-prox-Fix-scale-not-correct-issue.patch"

From 35b0c1a113b0126dbb762cb9204f4590c0851cff Mon Sep 17 00:00:00 2001
From: Ye Xiang <xiang.ye@intel.com>
Date: Sat, 30 Jan 2021 18:25:30 +0800
Subject: [PATCH] iio: hid-sensor-prox: Fix scale not correct issue

commit d68c592e02f6f49a88e705f13dfc1883432cf300 upstream

Currently, the proxy sensor scale is zero because it just return the
exponent directly. To fix this issue, this patch use
hid_sensor_format_scale to process the scale first then return the
output.

Fixes: 39a3a0138f61 ("iio: hid-sensors: Added Proximity Sensor Driver")
Signed-off-by: Ye Xiang <xiang.ye@intel.com>
Link: https://lore.kernel.org/r/20210130102530.31064-1-xiang.ye@intel.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/iio/light/hid-sensor-prox.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/light/hid-sensor-prox.c b/drivers/iio/light/hid-sensor-prox.c
index 45ca056f019e..63041dcec7af 100644
--- a/drivers/iio/light/hid-sensor-prox.c
+++ b/drivers/iio/light/hid-sensor-prox.c
@@ -37,6 +37,9 @@ struct prox_state {
 	struct hid_sensor_common common_attributes;
 	struct hid_sensor_hub_attribute_info prox_attr;
 	u32 human_presence;
+	int scale_pre_decml;
+	int scale_post_decml;
+	int scale_precision;
 };
 
 /* Channel definitions */
@@ -105,8 +108,9 @@ static int prox_read_raw(struct iio_dev *indio_dev,
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
@@ -240,6 +244,12 @@ static int prox_parse_report(struct platform_device *pdev,
 			st->common_attributes.sensitivity.index,
 			st->common_attributes.sensitivity.report_id);
 	}
+
+	st->scale_precision = hid_sensor_format_scale(
+				hsdev->usage,
+				&st->prox_attr,
+				&st->scale_pre_decml, &st->scale_post_decml);
+
 	return ret;
 }
 
-- 
2.30.2


--anw0q34835k+/tsM--
