Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8E53A718
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730311AbfFIQqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:46:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730329AbfFIQqL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:46:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD8D620833;
        Sun,  9 Jun 2019 16:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098771;
        bh=2fcdwPav0b+daDdMQZAj1lg9khaMKU8brF9jrKOJOdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VzclyqJJfmf1JZK3njLq8G4nwSf5MZkZYW6eCCjnrpgEXikomDqT0jfuJgLHDOwyc
         tOkQhc2VwF9usHP+mIPHMbbU4gVw7h1vmuK99Wk4XoxT0sYe+GO8K7kJzLoilbin92
         bdJ0ZyNGOEX45OM5dCIVMv8B2UVk3P6uGnCkTk1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryan Pavlik <ryan.pavlik@collabora.com>,
        Daniel Stone <daniels@collabora.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 5.1 55/70] drm: add non-desktop quirks to Sensics and OSVR headsets.
Date:   Sun,  9 Jun 2019 18:42:06 +0200
Message-Id: <20190609164132.082290881@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
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


