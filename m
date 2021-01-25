Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960C4304B61
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbhAZEqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:46:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:59170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728542AbhAYSnZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:43:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EE4922D58;
        Mon, 25 Jan 2021 18:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600185;
        bh=/3IHmFBK+i9o0ZchEW+8498GZB+nRuXyVcfGyBjaUcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/CZyyqU/LoeTQnjKjASXe9gJvvuk3H0ADJ4rLqez5I0pQG9Bek8/bvfPGyODdfR+
         FIFRMFVulIFloTcpHoAOU1B3JOuj6+nCIQZPiIgy2ZbDBImjZv67FO1+diEBvYZI1M
         LQAD0c+jCPFjvNIvNwUqnD2DCHfrZ2pPxV8vt01A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH 4.19 33/58] intel_th: pci: Add Alder Lake-P support
Date:   Mon, 25 Jan 2021 19:39:34 +0100
Message-Id: <20210125183158.129415534@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit cb5c681ab9037e25fcca20689c82cf034566d610 upstream.

This adds support for the Trace Hub in Alder Lake-P.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lore.kernel.org/r/20210115195917.3184-3-alexander.shishkin@linux.intel.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -231,6 +231,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Alder Lake-P */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x51a6),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Emmitsburg PCH */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x1bcc),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


