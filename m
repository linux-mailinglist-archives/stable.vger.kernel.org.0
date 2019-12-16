Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B55121466
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbfLPSLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:11:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730700AbfLPSLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:11:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AE6A206B7;
        Mon, 16 Dec 2019 18:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519859;
        bh=s65DDVfEGzN6e22jq/z0By06AaK6hri5WvgzDtVjdCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+xG06h0GCA/Bjll7R2C/1/5E0OL6cnqioz+ISneBa/qUYB9b7zCFcobNvruBIoFL
         Gfxr01SDmjpWUgAo7urVRKKgrGXnDXQgagjTDLoYhzgaDjMg1rgRkPHYB89Thb1uvi
         M2xrm4KdcXMEuAHgDo6wtEe6Jyw54Hz1IVxCg/gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.3 098/180] intel_th: pci: Add Tiger Lake CPU support
Date:   Mon, 16 Dec 2019 18:48:58 +0100
Message-Id: <20191216174835.742974399@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 6e6c18bcb78c0dc0601ebe216bed12c844492d0c upstream.

This adds support for the Trace Hub in Tiger Lake CPU.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191120130806.44028-4-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -215,6 +215,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Tiger Lake CPU */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x9a33),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Tiger Lake PCH */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xa0a6),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


