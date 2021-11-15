Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD93452154
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347476AbhKPBDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:03:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245594AbhKOTUs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE14A63571;
        Mon, 15 Nov 2021 18:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001468;
        bh=z9+zTo2KDsQT9EvYNzUHie5CjB31QngDZuv/O0seETA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O48uAeUHUOEH8zHU2OfCoki5UZofEU42gUAOruPMezIRY//1xOoB8tcP5Am8OXCGS
         +p4k7Kj0HHjAuLPORGaSPfIgSZk5czQczvzFE4HB538K8KB6ZPVFVq4WeD/q+iIqb8
         UmxkbZNHoP7DqOrHrB541YazEu2ve8S1hmsMytL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mihail Chindris <mihail.chindris@analog.com>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 170/917] Documentation:devicetree:bindings:iio:dac: Fix val
Date:   Mon, 15 Nov 2021 17:54:25 +0100
Message-Id: <20211115165434.537257141@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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


