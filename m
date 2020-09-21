Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78225272D7E
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbgIUQko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729347AbgIUQkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:40:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 091772067D;
        Mon, 21 Sep 2020 16:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706430;
        bh=+Hl0YBs/9utIV16UpKBcDuyGwpz2oOC/MgeEPAGwuuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YMn5b6Tq22dzL/Dd648qwd2HDPtZsj4RDU6DyaXztWrAxQLFVX1JxwN96C3lhoujj
         +Zifa9JqwFmyNcbxVCQrRK8xVMz+O5d3IfNy3Ry61ORxs+AtbLaWw+4mQ1Eu+oCp5q
         P9zodwA8Kel4YvSO4ohN2FcKVAXMiariop5/HBus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Huang <vincent.huang@tw.synaptics.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.14 89/94] Input: trackpoint - add new trackpoint variant IDs
Date:   Mon, 21 Sep 2020 18:28:16 +0200
Message-Id: <20200921162039.629237110@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Huang <vincent.huang@tw.synaptics.com>

commit 6c77545af100a72bf5e28142b510ba042a17648d upstream.

Add trackpoint variant IDs to allow supported control on Synaptics
trackpoints.

Signed-off-by: Vincent Huang <vincent.huang@tw.synaptics.com>
Link: https://lore.kernel.org/r/20200914120327.2592-1-vincent.huang@tw.synaptics.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/trackpoint.c |   10 ++++++----
 drivers/input/mouse/trackpoint.h |   10 ++++++----
 2 files changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/input/mouse/trackpoint.c
+++ b/drivers/input/mouse/trackpoint.c
@@ -20,10 +20,12 @@
 #include "trackpoint.h"
 
 static const char * const trackpoint_variants[] = {
-	[TP_VARIANT_IBM]	= "IBM",
-	[TP_VARIANT_ALPS]	= "ALPS",
-	[TP_VARIANT_ELAN]	= "Elan",
-	[TP_VARIANT_NXP]	= "NXP",
+	[TP_VARIANT_IBM]		= "IBM",
+	[TP_VARIANT_ALPS]		= "ALPS",
+	[TP_VARIANT_ELAN]		= "Elan",
+	[TP_VARIANT_NXP]		= "NXP",
+	[TP_VARIANT_JYT_SYNAPTICS]	= "JYT_Synaptics",
+	[TP_VARIANT_SYNAPTICS]		= "Synaptics",
 };
 
 /*
--- a/drivers/input/mouse/trackpoint.h
+++ b/drivers/input/mouse/trackpoint.h
@@ -27,10 +27,12 @@
  * 0x01 was the original IBM trackpoint, others implement very limited
  * subset of trackpoint features.
  */
-#define TP_VARIANT_IBM		0x01
-#define TP_VARIANT_ALPS		0x02
-#define TP_VARIANT_ELAN		0x03
-#define TP_VARIANT_NXP		0x04
+#define TP_VARIANT_IBM			0x01
+#define TP_VARIANT_ALPS			0x02
+#define TP_VARIANT_ELAN			0x03
+#define TP_VARIANT_NXP			0x04
+#define TP_VARIANT_JYT_SYNAPTICS	0x05
+#define TP_VARIANT_SYNAPTICS		0x06
 
 /*
  * Commands


