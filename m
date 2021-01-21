Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD852FF2A2
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 19:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389081AbhAUR7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 12:59:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:54154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389207AbhAURzw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Jan 2021 12:55:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 487C423A57;
        Thu, 21 Jan 2021 17:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611251711;
        bh=xh+ECxheZMWmqGIWzUq80foOTv9mNU+gOIPReK1I6XQ=;
        h=Subject:To:From:Date:From;
        b=WziUlmIVqqxHm2TkQnDtLSnXZreAg8U3MKGZuOniwSG4O7DiaWbDAdt7Cx5r2/N1J
         Vag3/T8Q/bJvExd1Q4f6m5q9Sh2arMeNpDIJlUATnARWCvRoRgwQhKlKYtyWgIF6HY
         sz9eQVjlqHw0gJo27SMk4QToXq5xOGrAOL6PLkD0=
Subject: patch "intel_th: pci: Add Alder Lake-P support" added to char-misc-linus
To:     alexander.shishkin@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 21 Jan 2021 18:55:01 +0100
Message-ID: <1611251701145218@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    intel_th: pci: Add Alder Lake-P support

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From cb5c681ab9037e25fcca20689c82cf034566d610 Mon Sep 17 00:00:00 2001
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Date: Fri, 15 Jan 2021 22:59:17 +0300
Subject: intel_th: pci: Add Alder Lake-P support

This adds support for the Trace Hub in Alder Lake-P.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lore.kernel.org/r/20210115195917.3184-3-alexander.shishkin@linux.intel.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwtracing/intel_th/pci.c b/drivers/hwtracing/intel_th/pci.c
index 52acd77438ed..251e75c9ba9d 100644
--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -268,6 +268,11 @@ static const struct pci_device_id intel_th_pci_id_table[] = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x7aa6),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
+	{
+		/* Alder Lake-P */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x51a6),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
 	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
-- 
2.30.0


