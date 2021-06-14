Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD82E3A6489
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235370AbhFNL0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:26:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236083AbhFNLYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:24:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87816619A4;
        Mon, 14 Jun 2021 10:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667993;
        bh=xUB+5haVyfZ6/Te4FM6aKzN6f+tae7Y4/VUJ0QdmrsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCMokc6ntJAqyix6Jmx3e2ovbt6yd0TBON7nzw3xzO72aOO/LdH4a+cX0KuCGXYTY
         8A+QE5OFUHWtZyGaAH7K9OUC8bwL4iKMYkW7VGwFL3O1AbgtnO3LrLuzjDYt/Vgm6q
         gRWEbD1d9aL3xyXsA9RomFui6Px8of0FEqdgkzC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Kyle Tso <kyletso@google.com>
Subject: [PATCH 5.12 153/173] dt-bindings: connector: Replace BIT macro with generic bit ops
Date:   Mon, 14 Jun 2021 12:28:05 +0200
Message-Id: <20210614102703.256886274@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Tso <kyletso@google.com>

commit 9257bd80b917cc7908abd27ed5a5211964563f62 upstream.

BIT macro is not defined. Replace it with generic bit operations.

Fixes: 630dce2810b9 ("dt-bindings: connector: Add SVDM VDO properties")
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Kyle Tso <kyletso@google.com>
Link: https://lore.kernel.org/r/20210527121029.583611-1-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/dt-bindings/usb/pd.h |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/include/dt-bindings/usb/pd.h
+++ b/include/dt-bindings/usb/pd.h
@@ -163,10 +163,10 @@
 #define UFP_VDO_VER1_2		2
 
 /* Device Capability */
-#define DEV_USB2_CAPABLE	BIT(0)
-#define DEV_USB2_BILLBOARD	BIT(1)
-#define DEV_USB3_CAPABLE	BIT(2)
-#define DEV_USB4_CAPABLE	BIT(3)
+#define DEV_USB2_CAPABLE	(1 << 0)
+#define DEV_USB2_BILLBOARD	(1 << 1)
+#define DEV_USB3_CAPABLE	(1 << 2)
+#define DEV_USB4_CAPABLE	(1 << 3)
 
 /* Connector Type */
 #define UFP_RECEPTACLE		2
@@ -191,9 +191,9 @@
 
 /* Alternate Modes */
 #define UFP_ALTMODE_NOT_SUPP	0
-#define UFP_ALTMODE_TBT3	BIT(0)
-#define UFP_ALTMODE_RECFG	BIT(1)
-#define UFP_ALTMODE_NO_RECFG	BIT(2)
+#define UFP_ALTMODE_TBT3	(1 << 0)
+#define UFP_ALTMODE_RECFG	(1 << 1)
+#define UFP_ALTMODE_NO_RECFG	(1 << 2)
 
 /* USB Highest Speed */
 #define UFP_USB2_ONLY		0
@@ -217,9 +217,9 @@
  * <4:0>   :: Port number
  */
 #define DFP_VDO_VER1_1		1
-#define HOST_USB2_CAPABLE	BIT(0)
-#define HOST_USB3_CAPABLE	BIT(1)
-#define HOST_USB4_CAPABLE	BIT(2)
+#define HOST_USB2_CAPABLE	(1 << 0)
+#define HOST_USB3_CAPABLE	(1 << 1)
+#define HOST_USB4_CAPABLE	(1 << 2)
 #define DFP_RECEPTACLE		2
 #define DFP_CAPTIVE		3
 


