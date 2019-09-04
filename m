Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABA9DA8F75
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388390AbfIDSDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:03:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388995AbfIDSDq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:03:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD6CA22CEA;
        Wed,  4 Sep 2019 18:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620225;
        bh=iXbFIJf6QaO+qi3Exye0+Fd0r+llpYzfwwi0AggCSPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thzrtZSYTR9QEb+LAMfmO7C4KekPJ4TF1KgA0M6JC4K0CYV/qMlBvi4tJNzA+yiGh
         Dlliazp28UAPsprMEKYOUrSGmNozOSygYX49Ztoj6X1+Yz0sgBVJD1/oF/jI3D8g4m
         g+EVtpYxddlq4v0yec2SLh5uPnks/M2SIJerXcTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 4.14 35/57] usb: host: xhci: rcar: Fix typo in compatible string matching
Date:   Wed,  4 Sep 2019 19:54:03 +0200
Message-Id: <20190904175305.541999221@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
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
@@ -113,7 +113,7 @@ static int xhci_rcar_is_gen2(struct devi
 	return of_device_is_compatible(node, "renesas,xhci-r8a7790") ||
 		of_device_is_compatible(node, "renesas,xhci-r8a7791") ||
 		of_device_is_compatible(node, "renesas,xhci-r8a7793") ||
-		of_device_is_compatible(node, "renensas,rcar-gen2-xhci");
+		of_device_is_compatible(node, "renesas,rcar-gen2-xhci");
 }
 
 static int xhci_rcar_is_gen3(struct device *dev)


