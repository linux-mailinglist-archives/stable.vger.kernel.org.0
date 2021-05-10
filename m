Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950583783A8
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbhEJKq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:46:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232900AbhEJKor (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:44:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB05F614A7;
        Mon, 10 May 2021 10:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642840;
        bh=BF9jao7S736WrYt/+V9jCtSFeREwdDGQOz0xnp2UzLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yDkZ0HndZsU9B7yftjEvr6eis3OT6O07MN6e3pYdFzuOh6GOqXh/+4KqaJLAaPdwS
         P64Lns/yP7b0UmvUr9b1sIJtaYslIgCQ0xNgEMXAjhp9gojPzRQdZ6d5trccGt8FNY
         66bCTUFoi5imvS6icsMJ+HXyBsbTNeeqIlewabSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.10 046/299] intel_th: pci: Add Rocket Lake CPU support
Date:   Mon, 10 May 2021 12:17:23 +0200
Message-Id: <20210510102006.387754388@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
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
@@ -278,6 +278,11 @@ static const struct pci_device_id intel_
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
+	{
+		/* Rocket Lake CPU */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4c19),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
 	{ 0 },
 };
 


