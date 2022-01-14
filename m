Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A727148E668
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237232AbiANI1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241085AbiANIZK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:25:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D5AC0612EA;
        Fri, 14 Jan 2022 00:23:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 413D461E2D;
        Fri, 14 Jan 2022 08:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB050C36AEA;
        Fri, 14 Jan 2022 08:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148611;
        bh=fVhb6SJem3cPcMRbUppLOuJM/saR48vtTBy79ji/cRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=is977HPpY8aHgWNRo5ghDQxF89o1DJOrC5+mqUZDpSCm0UCUg0SHyG1EkGXCYP9/A
         8u9fE8/gtQEBJkdXrHxWcOonznNb4D4tqCcNNh2JB9fojwe+iNLGGDginCoR9Ut/MZ
         qud5qd3WaaKlGr9FFbkWIwpQAZTgI0neWEldr41U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Hung <alex.hung@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.16 33/37] platform/x86/intel: hid: add quirk to support Surface Go 3
Date:   Fri, 14 Jan 2022 09:16:47 +0100
Message-Id: <20220114081545.926512782@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081544.849748488@linuxfoundation.org>
References: <20220114081544.849748488@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Hung <alex.hung@canonical.com>

commit 01e16cb67cce68afaeb9c7bed72299036dbb0bc1 upstream.

Similar to other systems Surface Go 3 requires a DMI quirk to enable
5 button array for power and volume buttons.

Buglink: https://github.com/linux-surface/linux-surface/issues/595

Cc: stable@vger.kernel.org
Signed-off-by: Alex Hung <alex.hung@canonical.com>
Link: https://lore.kernel.org/r/20211203212810.2666508-1-alex.hung@canonical.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/hid.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -106,6 +106,13 @@ static const struct dmi_system_id button
 			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 3"),
 		},
 	},
+	{
+		.ident = "Microsoft Surface Go 3",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 3"),
+		},
+	},
 	{ }
 };
 


