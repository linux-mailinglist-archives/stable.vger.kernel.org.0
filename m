Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91BF450AA6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhKORM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:12:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236501AbhKORMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:12:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CEFA61BF8;
        Mon, 15 Nov 2021 17:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996145;
        bh=B3IL7A0G24d4lar2WCAI1FTeW7+ftwuZOZ6GG5qyeJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TN6s6gvHGE1dUNY2RWCImZr3PYC25P4SqriGc0LZuYpjGsxP7xrnd/tjEuROrfvAP
         7bpB6xa3jXjaNpee7KVbHNU+oD0hMKErg/CwzZZjN/rpXayLjiabM59YdRRj05pUsY
         C01dmXq+HfqOCgX5awAYMUSX72vs66MyOqNWKCgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neal Gompa <ngompa13@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 008/355] Input: i8042 - Add quirk for Fujitsu Lifebook T725
Date:   Mon, 15 Nov 2021 17:58:52 +0100
Message-Id: <20211115165313.825419059@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 16e28abb7290c4ca3b3a0f333ba067f34bb18c86 upstream.

Fujitsu Lifebook T725 laptop requires, like a few other similar
models, the nomux and notimeout options to probe the touchpad
properly.  This patch adds the corresponding quirk entries.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1191980
Tested-by: Neal Gompa <ngompa13@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20211103070019.13374-1-tiwai@suse.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-x86ia64io.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -273,6 +273,13 @@ static const struct dmi_system_id __init
 		},
 	},
 	{
+		/* Fujitsu Lifebook T725 laptop */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK T725"),
+		},
+	},
+	{
 		/* Fujitsu Lifebook U745 */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
@@ -841,6 +848,13 @@ static const struct dmi_system_id __init
 		},
 	},
 	{
+		/* Fujitsu Lifebook T725 laptop */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK T725"),
+		},
+	},
+	{
 		/* Fujitsu U574 laptop */
 		/* https://bugzilla.kernel.org/show_bug.cgi?id=69731 */
 		.matches = {


