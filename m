Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1596137816B
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbhEJK0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230165AbhEJK0D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:26:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E468A6147E;
        Mon, 10 May 2021 10:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642291;
        bh=qotJ9bGvvB5uZYTl5OgySsTK/dqf66GaIiQwD/bRa9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZVnu6o5e/Chi5/EyuTlcua+luziH3zJOLdYc2BEe8+ZIg9INgzQRtFSmOEtBVWVj
         g4DjaB66lm2XeCGT8aFI5IxToRDki15em7jln+Olg4PpvHjJxJ0mPEE8sn0iDTEx/X
         167bCFD7UKux1mLusVkFSTvyAdOq5ZVviGZo7bIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 035/184] intel_th: pci: Add Rocket Lake CPU support
Date:   Mon, 10 May 2021 12:18:49 +0200
Message-Id: <20210510101951.372246586@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 9f7f2a5e01ab4ee56b6d9c0572536fe5fd56e376 upstream.

This adds support for the Trace Hub in Rocket Lake CPUs.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable <stable@vger.kernel.org> # v4.14+
Link: https://lore.kernel.org/r/20210414171251.14672-7-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -268,6 +268,11 @@ static const struct pci_device_id intel_
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x1bcc),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
+	{
+		/* Rocket Lake CPU */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4c19),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
 	{ 0 },
 };
 


