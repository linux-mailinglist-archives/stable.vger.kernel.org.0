Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B853032FE
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbhAZEni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:43:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727658AbhAYSms (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:42:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10C15230FD;
        Mon, 25 Jan 2021 18:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600122;
        bh=IaKj3fC56QLK2mcMufUHZh6Q1D4yKgFp8SjNdLT2Qcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnrAtg57+STRIHK3J7eLffeHBuzwUrKEHzKvlvyzgW0p62Pr/eH+Hyzw2Gdfk1ebE
         qnsacePardUW7KHqlPsP0Gw3I+MFCR2Y+HSGFYmdmn0BQmgtnb5t3BoKEIgPTSgpET
         uijhWCtA2RABkHu0TDDFKw98ceeijZd9Kgu8F3iA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Cooper <alcooperx@gmail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 4.19 40/58] usb: bdc: Make bdc pci driver depend on BROKEN
Date:   Mon, 25 Jan 2021 19:39:41 +0100
Message-Id: <20210125183158.442967149@linuxfoundation.org>
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

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

commit ef02684c4e67d8c35ac83083564135bc7b1d3445 upstream.

The bdc pci driver is going to be removed due to it not existing in the
wild. This patch turns off compilation of the driver so that stable
kernels can also pick up the change. This helps the out-of-tree
facetimehd webcam driver as the pci id conflicts with bdc.

Cc: Al Cooper <alcooperx@gmail.com>
Cc: <stable@vger.kernel.org>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://lore.kernel.org/r/20210118203615.13995-1-patrik.r.jakobsson@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/bdc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/bdc/Kconfig
+++ b/drivers/usb/gadget/udc/bdc/Kconfig
@@ -15,7 +15,7 @@ if USB_BDC_UDC
 comment "Platform Support"
 config	USB_BDC_PCI
 	tristate "BDC support for PCIe based platforms"
-	depends on USB_PCI
+	depends on USB_PCI && BROKEN
 	default USB_BDC_UDC
 	help
 		Enable support for platforms which have BDC connected through PCIe, such as Lego3 FPGA platform.


