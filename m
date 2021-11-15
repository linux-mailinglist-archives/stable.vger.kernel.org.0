Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55BF450FA3
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242393AbhKOSfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:35:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:42472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241966AbhKOSbp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:31:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F62663450;
        Mon, 15 Nov 2021 17:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999158;
        bh=z9+zTo2KDsQT9EvYNzUHie5CjB31QngDZuv/O0seETA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=khwNgb37+Llh1QhvWkmb1yAL32+PIpk8w2VuaPGVsd3NPj4yRf39mg0DI78/xqriw
         UDSnVRI7dzuseXygHFqLE8hMhqVhyGP4G5XdZR92GzFjf3BhCbJMKGWFygaVM7Dswh
         TjgZdMWbBgIRz4+d5oGF3EJUafbSwS4TcsZPAPZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mihail Chindris <mihail.chindris@analog.com>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.14 197/849] Documentation:devicetree:bindings:iio:dac: Fix val
Date:   Mon, 15 Nov 2021 17:54:40 +0100
Message-Id: <20211115165426.859728130@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mihail Chindris <mihail.chindris@analog.com>

commit 8fc4f038fa832ec3543907fdcbe1334e1b0a8950 upstream.

A correct value for output-range-microvolts is -5 to 5 Volts
not -5 to 5 milivolts

Fixes: e904cc899293f ("dt-bindings: iio: dac: AD5766 yaml documentation")
Signed-off-by: Mihail Chindris <mihail.chindris@analog.com>
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Link: https://lore.kernel.org/r/20211007080035.2531-6-mihail.chindris@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/iio/dac/adi,ad5766.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/iio/dac/adi,ad5766.yaml
+++ b/Documentation/devicetree/bindings/iio/dac/adi,ad5766.yaml
@@ -54,7 +54,7 @@ examples:
 
           ad5766@0 {
               compatible = "adi,ad5766";
-              output-range-microvolts = <(-5000) 5000>;
+              output-range-microvolts = <(-5000000) 5000000>;
               reg = <0>;
               spi-cpol;
               spi-max-frequency = <1000000>;


