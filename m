Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72371C1428
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730386AbgEANgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:36:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730847AbgEANgS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:36:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D27B1208DB;
        Fri,  1 May 2020 13:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340178;
        bh=jjzL8dEOpPjDZCYBJmZBJB+Z4r3Jm7DlFgVrJSvOJBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2ZJLpGZ0qV4fkfsMPgZiq/fRLh7SCyUEL5xWTiRibbC62fgOems73WEPbqKYPzIO
         /u9xXHVuDLqU5fiI+uQ8ZlF1YA/2w5Aizflygfg2fv+/RBOIVARAal4G3bbwXmb7JF
         hUsQLk+bAfxBhtn8ED6UoHZDA9xss4E3Av/gpBgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Eric Anholt <eric@anholt.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 4.19 20/46] ARM: dts: bcm283x: Disable dsi0 node
Date:   Fri,  1 May 2020 15:22:45 +0200
Message-Id: <20200501131505.878175580@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131457.023036302@linuxfoundation.org>
References: <20200501131457.023036302@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

commit 90444b958461a5f8fc299ece0fe17eab15cba1e1 upstream.

Since its inception the module was meant to be disabled by default, but
the original commit failed to add the relevant property.

Fixes: 4aba4cf82054 ("ARM: dts: bcm2835: Add the DSI module nodes and clocks")
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Reviewed-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/bcm283x.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/bcm283x.dtsi
+++ b/arch/arm/boot/dts/bcm283x.dtsi
@@ -476,6 +476,7 @@
 					     "dsi0_ddr2",
 					     "dsi0_ddr";
 
+			status = "disabled";
 		};
 
 		thermal: thermal@7e212000 {


