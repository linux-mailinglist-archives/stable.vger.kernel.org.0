Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A801E2E3637
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbgL1LMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:12:05 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:52573 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727165AbgL1LMF (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 28 Dec 2020 06:12:05 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 499A1250;
        Mon, 28 Dec 2020 06:10:59 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:10:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6pyIym
        ziD8V8Fvx0ULfRah4an8JsGxBGPX5QnC3fayk=; b=Xfeyl4h/pH+0IXdUoDxmuR
        XmxqyQHQM/a/tNzyOI1kjs3UDuQ/5ph1zq8oVUcvroVZPRxJc7QesTv5V55KjDTz
        qTNDNqqsVHXcBlCyoh9kqIxRkm4mL3gKkEGldooqP30GhjE0vwX0yNagbAauYRW7
        SffVUjtkc26T5J7Qc7Gd/AYFKz0htsNcqRXNR/nnKFkVka726Hqk+IXWm6/1NGn3
        whXvwgj9GgQv2dn5XL+9Xk9XHdkht3QHn+KXw9ttSyeHiwE5UVif9T/IMbTbxpdM
        hWP5Cs+rIufe4Lusvjipwv6ZhWLvAK7ygAhI35rWom8SxURGcLezgQJ9+IFHVjng
        ==
X-ME-Sender: <xms:Qr3pX7VuvMEY8T6GFI-qZzGffHlyrYMoLJOoox9lS8vIS6ACeSnW2w>
    <xme:Qr3pXzndgxXMOQRkcd_14mxOmBOeEjDOkMFWq5TjLMW5qR0h3NOKLiDMrtqSYJz2v
    6tT2x-0i-SUkw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Qr3pX3a_0veFGBM9t4YFAjHeu3fP0oO3aY-YKp8UUwgNJFYxkmVNBQ>
    <xmx:Qr3pX2X1avZvJr5niQtNEMGk52kJeyMHDIvTb3CloTU3yDDt_oiPKw>
    <xmx:Qr3pX1n-Yg9DHRTLbdsQmv6WQo32WxYCSA6LWVA63EQqWy6HSPY7QQ>
    <xmx:Qr3pX0sVcPWDWNuwHRTfBxkqnnji1SUrhmK93IESbJXJEPLYbTT77OEkutU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E83D11080063;
        Mon, 28 Dec 2020 06:10:57 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio: buffer: Fix demux update" failed to apply to 4.4-stable tree
To:     nuno.sa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:12:20 +0100
Message-ID: <1609153940167171@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 19ef7b70ca9487773c29b449adf0c70f540a0aab Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Date: Thu, 12 Nov 2020 15:43:22 +0100
Subject: [PATCH] iio: buffer: Fix demux update
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When updating the buffer demux, we will skip a scan element from the
device in the case `in_ind != out_ind` and we enter the while loop.
in_ind should only be refreshed with `find_next_bit()` in the end of the
loop.

Note, to cause problems we need a situation where we are skippig over
an element (channel not enabled) that happens to not have the same size
as the next element.   Whilst this is a possible situation we haven't
actually identified any cases in mainline where it happens as most drivers
have consistent channel storage sizes with the exception of the timestamp
which is the last element and hence never skipped over.

Fixes: 5ada4ea9be16 ("staging:iio: add demux optionally to path from device to buffer")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20201112144323.28887-1-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index 9663dec3dcf3..2f7426a2f47c 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -853,12 +853,12 @@ static int iio_buffer_update_demux(struct iio_dev *indio_dev,
 				       indio_dev->masklength,
 				       in_ind + 1);
 		while (in_ind != out_ind) {
-			in_ind = find_next_bit(indio_dev->active_scan_mask,
-					       indio_dev->masklength,
-					       in_ind + 1);
 			length = iio_storage_bytes_for_si(indio_dev, in_ind);
 			/* Make sure we are aligned */
 			in_loc = roundup(in_loc, length) + length;
+			in_ind = find_next_bit(indio_dev->active_scan_mask,
+					       indio_dev->masklength,
+					       in_ind + 1);
 		}
 		length = iio_storage_bytes_for_si(indio_dev, in_ind);
 		out_loc = roundup(out_loc, length);

