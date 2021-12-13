Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA66C472897
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240430AbhLMKOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:14:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235301AbhLMJ4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:56:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5025BC08EAFF;
        Mon, 13 Dec 2021 01:46:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C8594CE0E63;
        Mon, 13 Dec 2021 09:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7259FC00446;
        Mon, 13 Dec 2021 09:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388807;
        bh=BL8UCNDsToxhgqdU3WZVvx6uh+7CR4dOf+rqlEMrwS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOVDNS3dQ2+kpTVaEgsq3C8FGmfJ6OA4y6V6ayQxvPVMlybXcaYPSvpHPIZMc9yf2
         OabHo5Jkgn3QvFW4qPFxq0JBpO+cL6ej62C4Sx7BF6g/8YJqOaQAt4pUIja5ZkxEhA
         tIlWarsnippIQTySz/E89ID/sJ4B3m7vzc5SrUoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.10 008/132] HID: add USB_HID dependancy to hid-chicony
Date:   Mon, 13 Dec 2021 10:29:09 +0100
Message-Id: <20211213092939.363415972@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
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


