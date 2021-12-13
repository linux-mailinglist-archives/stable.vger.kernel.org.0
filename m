Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16865472580
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbhLMJoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235639AbhLMJmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:42:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F497C07E5DE;
        Mon, 13 Dec 2021 01:39:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 12F37CE0E90;
        Mon, 13 Dec 2021 09:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9CEC00446;
        Mon, 13 Dec 2021 09:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388366;
        bh=eKseUwy4PituTUDkSxh5ZZP/kzzRau1QBapT5fEFCUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1sUPADRFD5GbSkHu9ckfqIbWit8Ln0ng1V8d2vUtq22S9b1RL74idrR/+/dxISFWH
         bPO+Z9cqQmpRgFlpxBItiBv5VBYAwpY6INtuv+pnwxBHiZGbQJh0GRPWB+QrocMuYP
         /OEqZQRshebxH0GTLJleU+NnkIuunEHhiAPcwm/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 4.19 04/74] HID: add USB_HID dependancy to hid-chicony
Date:   Mon, 13 Dec 2021 10:29:35 +0100
Message-Id: <20211213092930.916378753@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit d080811f27936f712f619f847389f403ac873b8f upstream.

The chicony HID driver only controls USB devices, yet did not have a
dependancy on USB_HID.  This causes build errors on some configurations
like sparc when building due to new changes to the chicony driver.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: stable@vger.kernel.org
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20211203075927.2829218-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -191,7 +191,7 @@ config HID_CHERRY
 
 config HID_CHICONY
 	tristate "Chicony devices"
-	depends on HID
+	depends on USB_HID
 	default !EXPERT
 	---help---
 	Support for Chicony Tactical pad and special keys on Chicony keyboards.


