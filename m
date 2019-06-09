Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC853AA7E
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbfFIRTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:19:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731475AbfFIQtZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:49:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3390207E0;
        Sun,  9 Jun 2019 16:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098965;
        bh=E+KnZknXoK5kyDN6MFIC8hm5B3cCu9oRBgsImIgDYvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qn1Ed64TWsGjdIZv9TAF6m/2FuIPzqfSN8XSJ9H79SCANpR5Xp1EEAQoH8SMF5Dnf
         Xqz5g25AWgMfABPOOw0tAHEoiIve9AuvDPplJJTKusD3smHX5WxJrQoo8PJBf4z/f3
         JZxL2jkm1bZ5rKmDfHoRE1/ArvnWQGlap23w2Ndw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andres Rodriguez <andresx7@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 4.19 39/51] drm: add non-desktop quirk for Valve HMDs
Date:   Sun,  9 Jun 2019 18:42:20 +0200
Message-Id: <20190609164129.785862542@linuxfoundation.org>
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

From: Andres Rodriguez <andresx7@gmail.com>

commit 30d62d4453e49f85dd17b2ba60bbb68b6593dba0 upstream.

Add vendor/product pairs for the Valve Index HMDs.

Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: <stable@vger.kernel.org> # v4.15
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190502193157.15692-1-andresx7@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_edid.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -172,6 +172,25 @@ static const struct edid_quirk {
 	/* Rotel RSX-1058 forwards sink's EDID but only does HDMI 1.1*/
 	{ "ETR", 13896, EDID_QUIRK_FORCE_8BPC },
 
+	/* Valve Index Headset */
+	{ "VLV", 0x91a8, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91b0, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91b1, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91b2, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91b3, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91b4, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91b5, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91b6, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91b7, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91b8, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91b9, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91ba, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91bb, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91bc, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91bd, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91be, EDID_QUIRK_NON_DESKTOP },
+	{ "VLV", 0x91bf, EDID_QUIRK_NON_DESKTOP },
+
 	/* HTC Vive and Vive Pro VR Headsets */
 	{ "HVR", 0xaa01, EDID_QUIRK_NON_DESKTOP },
 	{ "HVR", 0xaa02, EDID_QUIRK_NON_DESKTOP },


