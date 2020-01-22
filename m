Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D990144F6A
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730200AbgAVJhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:37:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:53702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729563AbgAVJhd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:37:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AD8B2467E;
        Wed, 22 Jan 2020 09:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685852;
        bh=o5ENOhAOLvVXmvZAAxOD8ynA2Hhx+mzchRgQvihpNNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cujbSJXizy7dLwcGCYJfOZzywb9Cfqbu+iwHBmVYgeKfxuzjHRtgYfhuiwtTzSiSN
         hMX5W0J3fwFKInq+BPMUQ1aiDiUQ91KVqDPrBrJRxBcnXgy7XD5oSbDOrKbnYIuQDY
         9DQGjAWhJbArjQFh45IvX0QWAaBB458BWcEg28sU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 4.14 01/65] dt-bindings: reset: meson8b: fix duplicate reset IDs
Date:   Wed, 22 Jan 2020 10:28:46 +0100
Message-Id: <20200122092751.887956791@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092750.976732974@linuxfoundation.org>
References: <20200122092750.976732974@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

commit 4881873f4cc1460f63d85fa81363d56be328ccdc upstream.

According to the public S805 datasheet the RESET2 register uses the
following bits for the PIC_DC, PSC and NAND reset lines:
- PIC_DC is at bit 3 (meaning: RESET_VD_RMEM + 3)
- PSC is at bit 4 (meaning: RESET_VD_RMEM + 4)
- NAND is at bit 5 (meaning: RESET_VD_RMEM + 4)

Update the reset IDs of these three reset lines so they don't conflict
with PIC_DC and map to the actual hardware reset lines.

Fixes: 79795e20a184eb ("dt-bindings: reset: Add bindings for the Meson SoC Reset Controller")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/dt-bindings/reset/amlogic,meson8b-reset.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/dt-bindings/reset/amlogic,meson8b-reset.h
+++ b/include/dt-bindings/reset/amlogic,meson8b-reset.h
@@ -95,9 +95,9 @@
 #define RESET_VD_RMEM			64
 #define RESET_AUDIN			65
 #define RESET_DBLK			66
-#define RESET_PIC_DC			66
-#define RESET_PSC			66
-#define RESET_NAND			66
+#define RESET_PIC_DC			67
+#define RESET_PSC			68
+#define RESET_NAND			69
 #define RESET_GE2D			70
 #define RESET_PARSER_REG		71
 #define RESET_PARSER_FETCH		72


