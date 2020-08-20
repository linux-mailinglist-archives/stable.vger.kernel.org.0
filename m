Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F288024BB2B
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730077AbgHTJxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730078AbgHTJxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:53:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 295F12067C;
        Thu, 20 Aug 2020 09:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917227;
        bh=gMAJQySplqK3LODlD+yqkkSZmARBSR3jSggcw7cFqr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nRRrb8zr/3sCzTA/5YoqZpiB7zbYb2s6p6WZ4Ko26/gkn26L9yTNqjhEb/0DAG+vQ
         22/3YhMLUDlye4CTRCAcBszq9N8+xZ8OKCRbuU2fcjoFOpIYWwBKWC0B/JZF5C/kdt
         asSMhXMqGGvbOoz6U/Ys+7XRgzDk8J0PBL+23lOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Christian Eggers <ceggers@arri.de>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 4.19 18/92] dt-bindings: iio: io-channel-mux: Fix compatible string in example code
Date:   Thu, 20 Aug 2020 11:21:03 +0200
Message-Id: <20200820091538.504723836@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

commit add48ba425192c6e04ce70549129cacd01e2a09e upstream.

The correct compatible string is "gpio-mux" (see
bindings/mux/gpio-mux.txt).

Cc: stable@vger.kernel.org # v4.13+
Reviewed-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Christian Eggers <ceggers@arri.de>
Link: https://lore.kernel.org/r/20200727101605.24384-1-ceggers@arri.de
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/iio/multiplexer/io-channel-mux.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/iio/multiplexer/io-channel-mux.txt
+++ b/Documentation/devicetree/bindings/iio/multiplexer/io-channel-mux.txt
@@ -21,7 +21,7 @@ controller state. The mux controller sta
 
 Example:
 	mux: mux-controller {
-		compatible = "mux-gpio";
+		compatible = "gpio-mux";
 		#mux-control-cells = <0>;
 
 		mux-gpios = <&pioA 0 GPIO_ACTIVE_HIGH>,


