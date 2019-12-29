Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 741FF12C425
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbfL2R0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:26:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:48480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727948AbfL2R0v (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:26:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CFE120409;
        Sun, 29 Dec 2019 17:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640411;
        bh=R6Ol1tJA9t/eAyTIJtxwUwPUuOVNZo2foII7zEUzqv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wh4EaMv3Nbajabz2qaGK1L8PzwMKAJApRhbZfaWTmBnxqko2aqE+0brjUlL0R9Wa7
         cxo8a+Mb8DP+pSDJttEztBAwKvYN4Iatd2FEciAjgAjIj01dDgKyG2iT2i0TmFULjo
         /dPaLXYoOzZrrKrzHdsCUSM1mOJ3d+ILaiN6ByEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.14 147/161] intel_th: pci: Add Comet Lake PCH-V support
Date:   Sun, 29 Dec 2019 18:19:55 +0100
Message-Id: <20191229162445.694594735@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit e4de2a5d51f97a6e720a1c0911f93e2d8c2f1c08 upstream.

This adds Intel(R) Trace Hub PCI ID for Comet Lake PCH-V.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191217115527.74383-2-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -189,6 +189,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Comet Lake PCH-V */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xa3a6),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Ice Lake NNPI */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x45c5),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


