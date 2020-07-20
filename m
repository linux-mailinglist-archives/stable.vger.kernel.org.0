Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452BB226579
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731320AbgGTPyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:54:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730181AbgGTPyP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:54:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B20C42065E;
        Mon, 20 Jul 2020 15:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260455;
        bh=uUIeuthN7YjPK+Imy+UK5gSEQoybZoUj3NYqZ0gBz7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qcpQQLy7TC6cU48pSxTwIh8OtkH2CkRPwRjxrmg6yrh///GLJ/K26fQCA3Ex9k2mM
         TxssXqyRpZfc5U7IQ7TuJ80eBMBLrIKvh4xNXQj5+ebMx/klM5lcNMbMACS/EOs1/Q
         OS5RN+DTtVR4sNa5lVHCllF+nsoQQ5A/jePzjgnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Pedersen <limero1337@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 109/133] Input: i8042 - add Lenovo XiaoXin Air 12 to i8042 nomux list
Date:   Mon, 20 Jul 2020 17:37:36 +0200
Message-Id: <20200720152809.004851196@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Pedersen <limero1337@gmail.com>

commit 17d51429da722cd8fc77a365a112f008abf4f8b3 upstream.

This fixes two finger trackpad scroll on the Lenovo XiaoXin Air 12.
Without nomux, the trackpad behaves as if only one finger is present and
moves the cursor when trying to scroll.

Signed-off-by: David Pedersen <limero1337@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200625133754.291325-1-limero1337@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -430,6 +430,13 @@ static const struct dmi_system_id __init
 		},
 	},
 	{
+		/* Lenovo XiaoXin Air 12 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "80UN"),
+		},
+	},
+	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1360"),


