Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 428193A76B
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731482AbfFIQtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:49:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731458AbfFIQtb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:49:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A4CA2081C;
        Sun,  9 Jun 2019 16:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098971;
        bh=2fcdwPav0b+daDdMQZAj1lg9khaMKU8brF9jrKOJOdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qXmco7zxPjvkNIAV3FpFsjM4PTal0SQ48Qe2WPus5pBBgSx1DMBSqWZFjBlj+atcQ
         8rVwpi4eWo6aqUPQb94fMNt4GnKQXgXEwg7hwWWQDqfGRHkoV87OV79tUaEeKJl/yM
         Ue6Z1Zxcyf/PnN1lZzWpwYAb1t1cHBqCHcl988yM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryan Pavlik <ryan.pavlik@collabora.com>,
        Daniel Stone <daniels@collabora.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 4.19 41/51] drm: add non-desktop quirks to Sensics and OSVR headsets.
Date:   Sun,  9 Jun 2019 18:42:22 +0200
Message-Id: <20190609164129.993540122@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.123076536@linuxfoundation.org>
References: <20190609164127.123076536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryan Pavlik <ryan.pavlik@collabora.com>

commit 29054230f3e11ea818eccfa7bb4e4b3e89544164 upstream.

Add two EDID vendor/product pairs used across a variety of
Sensics products, as well as the OSVR HDK and HDK 2.

Signed-off-by: Ryan Pavlik <ryan.pavlik@collabora.com>
Signed-off-by: Daniel Stone <daniels@collabora.com>
Reviewed-by: Daniel Stone <daniels@collabora.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20181203164644.13974-1-ryan.pavlik@collabora.com
Cc: <stable@vger.kernel.org> # v4.15+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_edid.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -212,6 +212,12 @@ static const struct edid_quirk {
 
 	/* Sony PlayStation VR Headset */
 	{ "SNY", 0x0704, EDID_QUIRK_NON_DESKTOP },
+
+	/* Sensics VR Headsets */
+	{ "SEN", 0x1019, EDID_QUIRK_NON_DESKTOP },
+
+	/* OSVR HDK and HDK2 VR Headsets */
+	{ "SVR", 0x1019, EDID_QUIRK_NON_DESKTOP },
 };
 
 /*


