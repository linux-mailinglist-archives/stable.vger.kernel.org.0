Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3371217D4
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbfLPSjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:39:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729275AbfLPSEG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:04:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9643F20733;
        Mon, 16 Dec 2019 18:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519446;
        bh=vHsi3h0JBvPwui+hP1q2MboD+20bo/8Jko6+neK5a60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EnO2/z6CbLHaPVs8kbHaYVH4/ph+F60N7FJw6B4s1ZQvJQoio+U+umjpBYkh0Y9V8
         wNdMgaoXgGruXG99KDBv/4zDyNaTARohXZ8J6j2fygh4hKt3kpLFJLDpOhE1a9K0MP
         rxaMrpv3zZykpNetwjYAlAHthywwzILlWv6X9ODE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.19 069/140] intel_th: pci: Add Ice Lake CPU support
Date:   Mon, 16 Dec 2019 18:48:57 +0100
Message-Id: <20191216174806.479917163@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 6a1743422a7c0fda26764a544136cac13e5ae486 upstream.

This adds support for the Trace Hub in Ice Lake CPU.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191120130806.44028-3-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -186,6 +186,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Ice Lake CPU */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8a29),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Tiger Lake PCH */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xa0a6),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


