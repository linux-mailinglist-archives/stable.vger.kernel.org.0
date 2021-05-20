Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF91438A503
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235593AbhETKL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:11:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235913AbhETKJz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:09:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F234613E3;
        Thu, 20 May 2021 09:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503773;
        bh=WrI+BCzS+lxYW5JuQKhpA7sNTSyr76SGtrKGfIQYZLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7E8FVeV0ggXxVyJjPb75uto7S/BtUw1vWQFzD6quNDTvqCQeohhyYNN0U9nystEl
         G1Dz1Rg4OCnAG78iP0AZOfZbBNtmDpq7N11kfvt2z62PqG5Do5Kk4O0N/sAD8GbhJD
         BSe1LUYgrv1KaRfRgoOCxJf6bMtY9edb0Cyzg38A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ferry Toth <ftoth@exalondelft.nl>
Subject: [PATCH 4.19 374/425] usb: dwc3: pci: Enable usb2-gadget-lpm-disable for Intel Merrifield
Date:   Thu, 20 May 2021 11:22:23 +0200
Message-Id: <20210520092143.688422126@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ferry Toth <ftoth@exalondelft.nl>

commit 04357fafea9c7ed34525eb9680c760245c3bb958 upstream.

On Intel Merrifield LPM is causing host to reset port after a timeout.
By disabling LPM entirely this is prevented.

Fixes: 066c09593454 ("usb: dwc3: pci: Enable extcon driver for Intel Merrifield")
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210425150947.5862-1-ftoth@exalondelft.nl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -133,6 +133,7 @@ static const struct property_entry dwc3_
 	PROPERTY_ENTRY_BOOL("snps,disable_scramble_quirk"),
 	PROPERTY_ENTRY_BOOL("snps,dis_u3_susphy_quirk"),
 	PROPERTY_ENTRY_BOOL("snps,dis_u2_susphy_quirk"),
+	PROPERTY_ENTRY_BOOL("snps,usb2-gadget-lpm-disable"),
 	PROPERTY_ENTRY_BOOL("linux,sysdev_is_parent"),
 	{}
 };


