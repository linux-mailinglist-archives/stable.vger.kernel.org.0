Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D542A481A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgKCO2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:28:47 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:45069 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729286AbgKCO11 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 3 Nov 2020 09:27:27 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 428E1D1B;
        Tue,  3 Nov 2020 09:27:26 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 09:27:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=de+CZi
        DqVeVKaa8e+AmgaxcZV/zIb1RfK0dlopmOX90=; b=Egfvuu37yCw9PwuDXC4A4r
        uEIn7rAFmOZi6fpti430qMfIAk97jjxD+xYNHKJkXQXsrnvtm+9ycgWkKVlywkmP
        TjAPbLjTwxb9qzzhpJUH7gkCCEjLAYd8u5iVF2YrPgVQT1LLEBfLjk6Fye4/Nq/P
        MuwyHnryDghx6TjXmB/jBxX7kaCPmhPmi4tfSN/JvCNGXiYu53+PXq/OQDrHGwn3
        RXWx0JnyeiaTdMaeAqCCdduCz5aS6/Inmx9mjDXnjIKd7q0Tb6+pL9dFwd82L/Xl
        HEbWFsKUw+ynHlYUPTK4wZ6OAvuXBDkahVEJmgYTcLXbU0/4EwY+U2tFx2WE65jg
        ==
X-ME-Sender: <xms:zWihXwxOY6Q5NYHhu8KvTCd1SFJd0p3VmW8cCbpBhMrQYkgqEuTtEg>
    <xme:zWihX0QfbdnhqMCDSbnM-6i9xZAfRkAecV9IdxP626zoNNV7AjcpXjfpz7_f_kLuL
    rsJdbf5UaIWIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:zWihXyXAnV_EC8ZSgIszaU5Qd2enVahViW1aZ1VmelB_Tt2KB49HXg>
    <xmx:zWihX-h5y-1PHL6zaEOwhQOpsiIK5UPOdkqY2qNxlmKqKXv2tm2QkQ>
    <xmx:zWihXyAcTd04fQ1QeQMoRPKv68zLM-q4T7xl6LAECmm4fW9ZzOh9eQ>
    <xmx:zWihX9rcUjZ5RFsyK8Qiao25Ea_C5x2SDD3PXCcMQ3jFr5TcbSOTtS5rbxM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5EE9D3280060;
        Tue,  3 Nov 2020 09:27:25 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio: adc: gyroadc: fix leak of device node iterator" failed to apply to 4.19-stable tree
To:     kernel@cdqe.de, Jonathan.Cameron@huawei.com, Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 15:28:19 +0100
Message-ID: <16044136997174@kroah.com>
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

