Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7E6472863
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237639AbhLMKLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236357AbhLMKJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:09:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC3DC08ECAE;
        Mon, 13 Dec 2021 01:53:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06EE0B80E73;
        Mon, 13 Dec 2021 09:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CC3C00446;
        Mon, 13 Dec 2021 09:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389221;
        bh=BL8UCNDsToxhgqdU3WZVvx6uh+7CR4dOf+rqlEMrwS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g7JklFPlN6X9QLUVrFH3JTirGY2i8N4hYdBnZifRmQQxNWcG38ytGIQQwJNbwc3oZ
         350tdEGJs20SErpFhA5Lxbct+IRrENYI+HONYqi0tc8JGfzLY6V+p8x7a3uLF5G4kC
         zf6FcuP+TeY9GzM5KPOqDyW/Bjj8yIMQz99xeHE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.15 007/171] HID: add USB_HID dependancy to hid-chicony
Date:   Mon, 13 Dec 2021 10:28:42 +0100
Message-Id: <20211213092945.336659196@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
@@ -207,7 +207,7 @@ config HID_CHERRY
 
 config HID_CHICONY
 	tristate "Chicony devices"
-	depends on HID
+	depends on USB_HID
 	default !EXPERT
 	help
 	Support for Chicony Tactical pad and special keys on Chicony keyboards.


