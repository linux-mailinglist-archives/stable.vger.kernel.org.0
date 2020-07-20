Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF332267CB
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388305AbgGTQOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:14:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387909AbgGTQOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:14:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0042520684;
        Mon, 20 Jul 2020 16:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261680;
        bh=Rsssxhr5ZDxVKD9RnrovIRqJwtyh3+qcK/WyD3wN0Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSaoo7ta+ib9FPBqSOLGP7lJhyL/SjDfbXCCDYk+bS90c1ff/Or/tMaaaHUnrBH3G
         f6Zed94NOTYCFb9QmkzzFyzZfcbROl/IjoHLCfr7IDhnYXZqiUu75+YnCCZJ3wfgQY
         9lrwDtQzQjS5FXJS7fbnR85u7kPDcJ7CEueIJA/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.7 202/244] intel_th: pci: Add Tiger Lake PCH-H support
Date:   Mon, 20 Jul 2020 17:37:53 +0200
Message-Id: <20200720152835.460662100@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 6227585dc7b6a5405fc08dc322f98cb95e2f0eb4 upstream.

This adds support for the Trace Hub in Tiger Lake PCH-H.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@vger.kernel.org # v4.14+
Link: https://lore.kernel.org/r/20200706161339.55468-3-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -234,6 +234,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Tiger Lake PCH-H */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x43a6),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Jasper Lake PCH */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4da6),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


