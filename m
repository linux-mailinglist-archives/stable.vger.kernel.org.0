Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3422537B8A1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhELIxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:53:37 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:60649 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230411AbhELIxf (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 12 May 2021 04:53:35 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 7EA1E5DD;
        Wed, 12 May 2021 04:52:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 12 May 2021 04:52:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Q/Ov+j
        FqFj9nX4tViBzx5ZQfWS9fXbvU1iopQGii9lI=; b=C+jlYNzwjortFrTzdZ4lGi
        ELWKk+H/EdFoP4dYl3JT8Oq6VzCdEgjYwh6jS+C2dLJwwOUMiIwHSktEcuOfcTnP
        bIESj+69oQ+EtjdU6vGtwVhY3Qa3XibYCpaN3vmj8DBSENY7YWfkfWw+pcDdVcXw
        Op6F5fIx5XRN81jIkiK4HqEeiAjUE/zT/ijDZzrh6xWbYYRHZiyD/ToTaVSXNgyk
        cRvw9QGg2yh328o+1Mk1D6gwtp2g8dLy1Nbx/ynbVSbaFSjhh5fe9rYGcjEho4y7
        bKuU246V1cTtU4P6mBueIdcbptSyqKjMg6OqMLnZbWH+X3OQDXdYtS727hVW3u5w
        ==
X-ME-Sender: <xms:S5ebYOAtfSr3P_wG53G3yGyxJlRPW-q5lMFYhreJQJ6bJ3tKfcCFgA>
    <xme:S5ebYIjk-WAFWl6ZfprQKive52biKV6QkpRn4CzaXHThp-zDzC3XZxYfqvf0xdQR1
    tBNbZHEKYwkuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:S5ebYBnWeGIVTna1pWEkWr6bzTHuSg6-Q65BpQT9zvqLir55kNfv3g>
    <xmx:S5ebYMwKvc8mPhlUzZ22XLopLO-SaFp_jIWZNdkeR7yz8uAAgqgkMg>
    <xmx:S5ebYDSlhGN2ysssUUSj4Sua2AMgFma7FRerLRQo4-9d_MSzW_-zxA>
    <xmx:S5ebYE49d1991SzuADOpICKD-qyjGtkrDAp0dZYmdhhpK8tnbRRXXakStRc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:52:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio:adc:stm32-adc: Add HAS_IOMEM dependency" failed to apply to 5.12-stable tree
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:52:25 +0200
Message-ID: <1620809545112148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c03e2df6e1d51f4e1252318275007214a3bd8e85 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 24 Jan 2021 19:10:22 +0000
Subject: [PATCH] iio:adc:stm32-adc: Add HAS_IOMEM dependency

Seems that there are config combinations in which this driver gets enabled
and hence selects the MFD, but with out HAS_IOMEM getting pulled in
via some other route.  MFD is entirely contained in an
if HAS_IOMEM block, leading to the build issue in this bugzilla.

https://bugzilla.kernel.org/show_bug.cgi?id=209889

Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index bf7d22fa4be2..6605c263949c 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -923,6 +923,7 @@ config STM32_ADC_CORE
 	depends on ARCH_STM32 || COMPILE_TEST
 	depends on OF
 	depends on REGULATOR
+	depends on HAS_IOMEM
 	select IIO_BUFFER
 	select MFD_STM32_TIMERS
 	select IIO_STM32_TIMER_TRIGGER

