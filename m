Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCBB2A4818
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbgKCO2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:28:47 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:43239 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729341AbgKCO1i (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 3 Nov 2020 09:27:38 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 336C3CBC;
        Tue,  3 Nov 2020 09:27:37 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 09:27:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=iiILx2
        6cndAOwW5lbPXWCL9pPyXsFB3m1FMzgUXR8rI=; b=ARCQRQP8WLlbAXxOs1/j6i
        SIVm18cNDAEqzHCheiH1bNRCK8gHnLqhL6cA45Sq3hvdNOf9Ct54nbn09UlZC+fs
        u4hkjL/KjhsdDXMZepVnwtkLJIwJDAriqE+HCt2s7d8oKWN7O5eFsqFkTs2QOM1K
        ZXtfzqTv0Awn1yGmG9JLrrsucq4FiL2ITVZWIh7wIJmrvOIrbksfttohT/cRmpkU
        DoHz4B+T4IzCcEpj5iUBzwn8gEPgLM2RWB4FONMVNkWamFqBcXwVKhrw172ylQlF
        5aSc/GCOEF2+XOiErmtcTodjXmGm/DsFf8g1TQLLYhyWFGtQimRjgqx9iGWSMHfg
        ==
X-ME-Sender: <xms:2GihX7zQOs0rKMcutXdr-8CR4ARlIebfGF6f_L83iGUN0SxxKXUpGQ>
    <xme:2GihXzTk2fZXyIBKZI0O7_M13lO-cQjlMekKosg9_JmaggLu8oZZ7eyK1JlMrbmPE
    qIUFwU4vkP_Fg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:2GihX1U6HU0VKRDDBWpTeHoD_12Qa4bCv6Flvc_AM94gswJ6xNSoQA>
    <xmx:2GihX1igGdmMDspDxv11J0HHt-QG4zfsipfGUB52MIWMMutA8PYpJQ>
    <xmx:2GihX9AZXNOvh8WGFgxkJGAhzN3BxQu9XgV2D2EF2lNXj50oZvMLMw>
    <xmx:2GihXwptlXmF8WAeXt_lrXEmmpn9fVTcWeDqJrOaqVTL9QRbnLMsEJQ95wo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6DD733064610;
        Tue,  3 Nov 2020 09:27:36 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio: adc: gyroadc: fix leak of device node iterator" failed to apply to 4.14-stable tree
To:     kernel@cdqe.de, Jonathan.Cameron@huawei.com, Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 15:28:20 +0100
Message-ID: <16044137009175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From da4410d4078ba4ead9d6f1027d6db77c5a74ecee Mon Sep 17 00:00:00 2001
From: Tobias Jordan <kernel@cdqe.de>
Date: Sat, 26 Sep 2020 18:19:46 +0200
Subject: [PATCH] iio: adc: gyroadc: fix leak of device node iterator

Add missing of_node_put calls when exiting the for_each_child_of_node
loop in rcar_gyroadc_parse_subdevs early.

Also add goto-exception handling for the error paths in that loop.

Fixes: 059c53b32329 ("iio: adc: Add Renesas GyroADC driver")
Signed-off-by: Tobias Jordan <kernel@cdqe.de>
Link: https://lore.kernel.org/r/20200926161946.GA10240@agrajag.zerfleddert.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/adc/rcar-gyroadc.c b/drivers/iio/adc/rcar-gyroadc.c
index dcaefc108ff6..9f38cf3c7dc2 100644
--- a/drivers/iio/adc/rcar-gyroadc.c
+++ b/drivers/iio/adc/rcar-gyroadc.c
@@ -357,7 +357,7 @@ static int rcar_gyroadc_parse_subdevs(struct iio_dev *indio_dev)
 			num_channels = ARRAY_SIZE(rcar_gyroadc_iio_channels_3);
 			break;
 		default:
-			return -EINVAL;
+			goto err_e_inval;
 		}
 
 		/*
@@ -374,7 +374,7 @@ static int rcar_gyroadc_parse_subdevs(struct iio_dev *indio_dev)
 				dev_err(dev,
 					"Failed to get child reg property of ADC \"%pOFn\".\n",
 					child);
-				return ret;
+				goto err_of_node_put;
 			}
 
 			/* Channel number is too high. */
@@ -382,7 +382,7 @@ static int rcar_gyroadc_parse_subdevs(struct iio_dev *indio_dev)
 				dev_err(dev,
 					"Only %i channels supported with %pOFn, but reg = <%i>.\n",
 					num_channels, child, reg);
-				return -EINVAL;
+				goto err_e_inval;
 			}
 		}
 
@@ -391,7 +391,7 @@ static int rcar_gyroadc_parse_subdevs(struct iio_dev *indio_dev)
 			dev_err(dev,
 				"Channel %i uses different ADC mode than the rest.\n",
 				reg);
-			return -EINVAL;
+			goto err_e_inval;
 		}
 
 		/* Channel is valid, grab the regulator. */
@@ -401,7 +401,8 @@ static int rcar_gyroadc_parse_subdevs(struct iio_dev *indio_dev)
 		if (IS_ERR(vref)) {
 			dev_dbg(dev, "Channel %i 'vref' supply not connected.\n",
 				reg);
-			return PTR_ERR(vref);
+			ret = PTR_ERR(vref);
+			goto err_of_node_put;
 		}
 
 		priv->vref[reg] = vref;
@@ -425,8 +426,10 @@ static int rcar_gyroadc_parse_subdevs(struct iio_dev *indio_dev)
 		 * attached to the GyroADC at a time, so if we found it,
 		 * we can stop parsing here.
 		 */
-		if (childmode == RCAR_GYROADC_MODE_SELECT_1_MB88101A)
+		if (childmode == RCAR_GYROADC_MODE_SELECT_1_MB88101A) {
+			of_node_put(child);
 			break;
+		}
 	}
 
 	if (first) {
@@ -435,6 +438,12 @@ static int rcar_gyroadc_parse_subdevs(struct iio_dev *indio_dev)
 	}
 
 	return 0;
+
+err_e_inval:
+	ret = -EINVAL;
+err_of_node_put:
+	of_node_put(child);
+	return ret;
 }
 
 static void rcar_gyroadc_deinit_supplies(struct iio_dev *indio_dev)

