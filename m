Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3A524838C
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 13:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgHRLGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 07:06:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbgHRLGV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 07:06:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCE19206B5;
        Tue, 18 Aug 2020 11:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597748781;
        bh=vOIQ5i8Al6CM5Z/UN8g+pt1rWAiQEhfKG9YLwAUHeVY=;
        h=Subject:To:From:Date:From;
        b=tz72huS3QbhvwMGfN90uKt5AIVQ8G/upc278FTgT1E5IP+MN5HF63cC0/hu2IpkzL
         uKvj6qLZFY41SLgT/VThuVnPVnv40DTKHA0go8FQ6ROL55VQT6kplSh1alGOdlSbkv
         jXAFRw2sPvUhYJKqGoNcuT8xmu6sV8nwzNG6Uk8U=
Subject: patch "usb: host: xhci-tegra: fix tegra_xusb_get_phy()" added to usb-linus
To:     jckuo@nvidia.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Aug 2020 13:06:36 +0200
Message-ID: <159774879656145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: host: xhci-tegra: fix tegra_xusb_get_phy()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d54343a87732726b04ac5af873916b5ed4f52932 Mon Sep 17 00:00:00 2001
From: JC Kuo <jckuo@nvidia.com>
Date: Tue, 11 Aug 2020 17:25:53 +0800
Subject: usb: host: xhci-tegra: fix tegra_xusb_get_phy()

tegra_xusb_get_phy() should take input argument "name".

Signed-off-by: JC Kuo <jckuo@nvidia.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200811092553.657762-1-jckuo@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c
index 0489a316099a..190923d8b246 100644
--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -1136,7 +1136,7 @@ static struct phy *tegra_xusb_get_phy(struct tegra_xusb *tegra, char *name,
 	unsigned int i, phy_count = 0;
 
 	for (i = 0; i < tegra->soc->num_types; i++) {
-		if (!strncmp(tegra->soc->phy_types[i].name, "usb2",
+		if (!strncmp(tegra->soc->phy_types[i].name, name,
 							    strlen(name)))
 			return tegra->phys[phy_count+port];
 
-- 
2.28.0


