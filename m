Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F92F272EBD
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbgIUQub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:50:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728281AbgIUQuJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:50:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F00C32388B;
        Mon, 21 Sep 2020 16:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600707008;
        bh=dBCgVmzrvsbF1tx3duVFTA0bIAr5Uw/A6TKgbxt3XVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gB0CYOrpeCuXvyvGc0GOv4/ydHBaOS83vt3fPxJe9YwFAdTaJzOiFnuAfIom0bsLt
         apwd1Aad0+54HucyJAWoN55DxOXdadIYhQ49VFpCbAliuKN4Ton5r5ntxT/5zqYCgw
         oqWk/O58Jsej+MDZdV4gL75pIvfBpWHZyRV+qRpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 62/72] Input: i8042 - add Entroware Proteus EL07R4 to nomux and reset lists
Date:   Mon, 21 Sep 2020 18:31:41 +0200
Message-Id: <20200921163124.819089703@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit c4440b8a457779adeec42c5e181cb4016f19ce0f upstream.

The keyboard drops keypresses early during boot unless both the nomux
and reset quirks are set. Add DMI table entries for this.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1806085
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20200907095656.13155-1-hdegoede@redhat.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/serio/i8042-x86ia64io.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -548,6 +548,14 @@ static const struct dmi_system_id __init
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5738"),
 		},
 	},
+	{
+		/* Entroware Proteus */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Entroware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Proteus"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "EL07R4"),
+		},
+	},
 	{ }
 };
 
@@ -676,6 +684,14 @@ static const struct dmi_system_id __init
 			DMI_MATCH(DMI_PRODUCT_NAME, "33474HU"),
 		},
 	},
+	{
+		/* Entroware Proteus */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Entroware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Proteus"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "EL07R4"),
+		},
+	},
 	{ }
 };
 


