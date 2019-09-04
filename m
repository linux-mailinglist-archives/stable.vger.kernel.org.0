Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3AB2A9009
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389613AbfIDSHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:07:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389610AbfIDSHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:07:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2A0B2087E;
        Wed,  4 Sep 2019 18:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620438;
        bh=xcdhgxoSN0I3e+GsI5uIN78iRb9bKshDfuoPcsJaGWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1PSBGlGh6kNfexU2G/hgc6kjgJIAFlgCzE5VQWO/H6i6u+ajhc0v9MO5Ble6wGHqs
         FzIm1Kd0DFwdaQ1EtWtXs8P2T/7Sh39iIUyX409cdcsZI0rZ9i+SaW5HMtX+6FM+D4
         DKhUbJM9ZwqTNEZp/HJ6BNE9VXekafRP70uM3b+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 4.19 59/93] usb: host: xhci: rcar: Fix typo in compatible string matching
Date:   Wed,  4 Sep 2019 19:54:01 +0200
Message-Id: <20190904175308.191206248@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 636bd02a7ba9025ff851d0cfb92768c8fa865859 upstream.

It's spelled "renesas", not "renensas".

Due to this typo, RZ/G1M and RZ/G1N were not covered by the check.

Fixes: 2dc240a3308b ("usb: host: xhci: rcar: retire use of xhci_plat_type_is()")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20190827125112.12192-1-geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-rcar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-rcar.c
+++ b/drivers/usb/host/xhci-rcar.c
@@ -104,7 +104,7 @@ static int xhci_rcar_is_gen2(struct devi
 	return of_device_is_compatible(node, "renesas,xhci-r8a7790") ||
 		of_device_is_compatible(node, "renesas,xhci-r8a7791") ||
 		of_device_is_compatible(node, "renesas,xhci-r8a7793") ||
-		of_device_is_compatible(node, "renensas,rcar-gen2-xhci");
+		of_device_is_compatible(node, "renesas,rcar-gen2-xhci");
 }
 
 static int xhci_rcar_is_gen3(struct device *dev)


