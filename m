Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BABF02D66A3
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 20:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390238AbgLJTfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 14:35:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:37446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390225AbgLJO3Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:29:25 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.9 14/45] Input: i8042 - add ByteSpeed touchpad to noloop table
Date:   Thu, 10 Dec 2020 15:26:28 +0100
Message-Id: <20201210142603.066705288@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.361598591@linuxfoundation.org>
References: <20201210142602.361598591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Po-Hsu Lin <po-hsu.lin@canonical.com>

commit a48491c65b513e5cdc3e7a886a4db915f848a5f5 upstream.

It looks like the C15B laptop got another vendor: ByteSpeed LLC.

Avoid AUX loopback on this touchpad as well, thus input subsystem will
be able to recognize a Synaptics touchpad in the AUX port.

BugLink: https://bugs.launchpad.net/bugs/1906128
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Link: https://lore.kernel.org/r/20201201054723.5939-1-po-hsu.lin@canonical.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/serio/i8042-x86ia64io.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -223,6 +223,10 @@ static const struct dmi_system_id __init
 			DMI_MATCH(DMI_SYS_VENDOR, "PEGATRON CORPORATION"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "C15B"),
 		},
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ByteSpeed LLC"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ByteSpeed Laptop C15B"),
+		},
 	},
 	{ }
 };


