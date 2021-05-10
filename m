Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD6A378E6D
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241034AbhEJN3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:29:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345702AbhEJMox (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 08:44:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76AA2611CA;
        Mon, 10 May 2021 12:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620650627;
        bh=VJ/xKku7Po9qW41lpcWan+5+iYeNZH40O7WSkXzICCs=;
        h=Subject:To:From:Date:From;
        b=iu2lFtk2zqru/v7edIvbrvgQaUtFfz/TXj7pbeUJw7CgUdPVLZgc0wFALBR8wkB2z
         RREP8ql8S3F+iF2jA9sB2qcoWzuIFHioHD92NpPq2UZPBTHAyjxwfrebXGymZpIKMw
         u2WlGOc3wCTtfFF33Kkf5iXDBo7tQdIo+JxgeZ00=
Subject: patch "usb: dwc3: pci: Enable usb2-gadget-lpm-disable for Intel Merrifield" added to usb-linus
To:     ftoth@exalondelft.nl, andy.shevchenko@gmail.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 14:43:36 +0200
Message-ID: <1620650616241133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: pci: Enable usb2-gadget-lpm-disable for Intel Merrifield

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 04357fafea9c7ed34525eb9680c760245c3bb958 Mon Sep 17 00:00:00 2001
From: Ferry Toth <ftoth@exalondelft.nl>
Date: Sun, 25 Apr 2021 17:09:47 +0200
Subject: usb: dwc3: pci: Enable usb2-gadget-lpm-disable for Intel Merrifield

On Intel Merrifield LPM is causing host to reset port after a timeout.
By disabling LPM entirely this is prevented.

Fixes: 066c09593454 ("usb: dwc3: pci: Enable extcon driver for Intel Merrifield")
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210425150947.5862-1-ftoth@exalondelft.nl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index e7b932dcbf82..1e51460938b8 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -123,6 +123,7 @@ static const struct property_entry dwc3_pci_mrfld_properties[] = {
 	PROPERTY_ENTRY_STRING("linux,extcon-name", "mrfld_bcove_pwrsrc"),
 	PROPERTY_ENTRY_BOOL("snps,dis_u3_susphy_quirk"),
 	PROPERTY_ENTRY_BOOL("snps,dis_u2_susphy_quirk"),
+	PROPERTY_ENTRY_BOOL("snps,usb2-gadget-lpm-disable"),
 	PROPERTY_ENTRY_BOOL("linux,sysdev_is_parent"),
 	{}
 };
-- 
2.31.1


