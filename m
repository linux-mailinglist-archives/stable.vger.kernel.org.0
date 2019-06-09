Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE0763AABA
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbfFIQqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729319AbfFIQqD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:46:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98CEE2081C;
        Sun,  9 Jun 2019 16:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098763;
        bh=E+KnZknXoK5kyDN6MFIC8hm5B3cCu9oRBgsImIgDYvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CVt1/ceUiefM2gT+gwMPkcuK/9GPQNoTrRw29JG7pZcfxQxXaNOaVQy/TtScU7Du3
         oZCJgvnEtK9DYNxHvkBVY4+W+KrMzyDLzge+J69FhoZcZtQ2ETCHZLhW48IFf/ECdC
         7jtaSa3HNOeqmJ+iL7xnBM5vJYgR+eWoCqIEpwW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andres Rodriguez <andresx7@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 5.1 53/70] drm: add non-desktop quirk for Valve HMDs
Date:   Sun,  9 Jun 2019 18:42:04 +0200
Message-Id: <20190609164131.900714509@linuxfoundation.org>
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


