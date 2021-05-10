Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E396E3788EA
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbhEJLY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:24:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233578AbhEJLMP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:12:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 864BF611F1;
        Mon, 10 May 2021 11:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645005;
        bh=pFhRQrlO6G29XQ8XJDynC8FnDL/QHlsBEskqkIHGPbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5I1gcZBEZ4HZx5pdvcNVnsthAscSeihwI7IC8LaRUMnQUameFL8cwsE+ABdufQTd
         yMUXOD+wzPe55BzrphyvWn6xJMcNVODwUVdFP8/XPwGj7oCgb0Nzmsp9J0fgSLvJNZ
         QOEvZGAX9z5sN58RcKgZ99uEG9QvT4LuhiCdKsGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.12 313/384] intel_th: pci: Add Alder Lake-M support
Date:   Mon, 10 May 2021 12:21:42 +0200
Message-Id: <20210510102025.113284543@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
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
@@ -274,6 +274,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Alder Lake-M */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x54a6),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


