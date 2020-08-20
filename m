Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8475324BE09
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgHTNRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:17:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728376AbgHTJer (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:34:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 822E722B3F;
        Thu, 20 Aug 2020 09:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916087;
        bh=hrY0NhL1R5l5ToViiwDTlNThpTbAJifen/N2VMBxI74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mAuSoCN7XPd0xYjscw9Ylur4gOBfyP2WbRCtE5PdCiaNo2Sd7LbRSXoxuGc9Ba6uz
         U/obnRDmS6PZM/C06fFg21vtVO+u+e+MMObgK8fXDY+ZOQufS8mecnVI/apiRzoEGE
         NZtbJk6KKDqw9voPjD93nUT+Payf4Rw6DEk6ChZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marius Iacob <themariusus@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.8 228/232] drm: Added orientation quirk for ASUS tablet model T103HAF
Date:   Thu, 20 Aug 2020 11:21:19 +0200
Message-Id: <20200820091623.817191872@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marius Iacob <themariusus@gmail.com>

commit b5ac98cbb8e5e30c34ebc837d1e5a3982d2b5f5c upstream.

Signed-off-by: Marius Iacob <themariusus@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20200801123445.1514567-1-themariusus@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_panel_orientation_quirks.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -121,6 +121,12 @@ static const struct dmi_system_id orient
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "T101HA"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
+	}, {	/* Asus T103HAF */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "T103HAF"),
+		},
+		.driver_data = (void *)&lcd800x1280_rightside_up,
 	}, {	/* GPD MicroPC (generic strings, also match on bios date) */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Default string"),


