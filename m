Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A64E38A2BA
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbhETJpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233252AbhETJmw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:42:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCA386143B;
        Thu, 20 May 2021 09:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503155;
        bh=1Vhk8uB4OpjbHtLw6k7IkFDXRt+v6+fAf1BeKvuDOjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=np8I4EN6GzAJdXUgyFD/4Txcz6UZpRcP/UsCMGgdirVW8aoEe+t626xFCEOo5QYHw
         8BQzhiW2r7Irx0f+hTV1xTOg4Tw1JzfyJf1bJ9I6S59Va2ncVSshNDQG4lec+xzh6y
         odUONa2Fpso0L7tR1toldBRgNB4uJdtgzDVIGdHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.19 093/425] intel_th: pci: Add Alder Lake-M support
Date:   Thu, 20 May 2021 11:17:42 +0200
Message-Id: <20210520092134.514708065@linuxfoundation.org>
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

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 48cb17531b15967d9d3f34c770a25cc6c4ca6ad1 upstream.

This adds support for the Trace Hub in Alder Lake-M PCH.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@vger.kernel.org # v4.14+
Link: https://lore.kernel.org/r/20210414171251.14672-8-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -241,6 +241,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Alder Lake-M */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x54a6),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Rocket Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4c19),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


