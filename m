Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF932A9172
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390977AbfIDSPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:15:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:32882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390308AbfIDSPc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:15:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A976208E4;
        Wed,  4 Sep 2019 18:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620931;
        bh=4yx6a7IEh0MTqmhFP0HhjxBScu72cu3vWBxkRFMy+pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IpJX087eMFM6PaToE/hXB4/n4PP4jrEXGncZJk9WJS8OX4RUuLa6UKp4ib0uvY07M
         ynQCegO6uwPS+A3VmEuKoIdvS0bG9CjKcEIHxX0GsgQcxRjKWb/Zf+NYP3GFSV1Et8
         a63dMA5Gg7zUNLcjEYXmO0DbmCdu8ABOO7v5sZzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH 5.2 099/143] intel_th: pci: Add support for another Lewisburg PCH
Date:   Wed,  4 Sep 2019 19:54:02 +0200
Message-Id: <20190904175318.140464357@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 164eb56e3b64f3a816238d410c9efec7567a82ef upstream.

Add support for the Trace Hub in another Lewisburg PCH.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: stable@vger.kernel.org # v4.14+
Link: https://lore.kernel.org/r/20190821074955.3925-4-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -165,6 +165,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)0,
 	},
 	{
+		/* Lewisburg PCH */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xa226),
+		.driver_data = (kernel_ulong_t)0,
+	},
+	{
 		/* Gemini Lake */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x318e),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


