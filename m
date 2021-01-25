Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BAF304A77
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730954AbhAZFEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:04:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731274AbhAYSxq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70CA820E65;
        Mon, 25 Jan 2021 18:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600809;
        bh=V3jvimEv/SzdcERTYMsKtFLi/kXY/gP2gUQhU6JEvKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rh4vMBq5/0qFynFeuBAhGH26fEI2OwfLvEmoG3MNfPuxgyGQhRhFESoqvelB2vfUe
         bWv2AmN7wtu0Lu6i/4srOFIdf/0nXIDAvhVVAL+mFNE1geU8j8uGB5xvdidnd9OOGq
         azX4RmltMdP3KoGGFcr8mkl7d3+wl8wrUAa6JDzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH 5.10 129/199] intel_th: pci: Add Alder Lake-P support
Date:   Mon, 25 Jan 2021 19:39:11 +0100
Message-Id: <20210125183221.660049189@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
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
@@ -269,6 +269,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Alder Lake-P */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x51a6),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


