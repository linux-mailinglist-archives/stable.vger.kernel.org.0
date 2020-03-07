Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBF4017D08F
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 00:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgCGXUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Mar 2020 18:20:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:40880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgCGXU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Mar 2020 18:20:29 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 474822077C;
        Sat,  7 Mar 2020 23:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583623229;
        bh=/bZdMBh5mRjmqbJ5MyCS6DZ2KaCDahEtI2bnYrWSGMU=;
        h=Date:From:To:To:To:To:Cc:CC:Cc:Subject:In-Reply-To:References:
         From;
        b=nMlp4GynGC5OhNPjTG7Xlh1kvAeHfYz0jkKyqe2kRT9r+7rogngCoaqOAm2V2WSX6
         ct9bTpyiLw5S+lqo4sruUTcsosgi904bs76YW++GQU5KlbzKwqNotG1v5ap5I6CDip
         VWIGP6zEjhDSCYHE64qF4huNgHvWtLs9hPlAC1kU=
Date:   Sat, 07 Mar 2020 23:20:28 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
To:     Alberto Mattea <alberto@mattea.info>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>, Alberto Mattea <alberto@mattea.info>
CC:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/2] usb: xhci: apply XHCI_SUSPEND_DELAY to AMD XHCI controller 1022:145c
In-Reply-To: <20200306150858.21904-3-mathias.nyman@linux.intel.com>
References: <20200306150858.21904-3-mathias.nyman@linux.intel.com>
Message-Id: <20200307232029.474822077C@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.8, v5.4.24, v4.19.108, v4.14.172, v4.9.215, v4.4.215.

v5.5.8: Build OK!
v5.4.24: Build OK!
v4.19.108: Build OK!
v4.14.172: Build OK!
v4.9.215: Failed to apply! Possible dependencies:
    191edc5e2e51 ("xhci: Fix front USB ports on ASUS PRIME B350M-A")
    4750bc78efdb ("usb: host: xhci support option to disable the xHCI USB2 HW LPM")
    488dc164914f ("xhci: remove WARN_ON if dma mask is not set for platform devices")
    4c39d4b949d3 ("usb: xhci: use bus->sysdev for DMA configuration")
    621faf4f6a18 ("xhci: Fix USB ports for Dell Inspiron 5775")

v4.4.215: Failed to apply! Possible dependencies:
    191edc5e2e51 ("xhci: Fix front USB ports on ASUS PRIME B350M-A")
    21939f003ad0 ("usb: host: xhci-plat: enable BROKEN_PED quirk if platform requested")
    41135de1e7fd ("usb: xhci: add quirk flag for broken PED bits")
    4750bc78efdb ("usb: host: xhci support option to disable the xHCI USB2 HW LPM")
    488dc164914f ("xhci: remove WARN_ON if dma mask is not set for platform devices")
    4c39d4b949d3 ("usb: xhci: use bus->sysdev for DMA configuration")
    4efb2f694114 ("usb: host: xhci-plat: add struct xhci_plat_priv")
    621faf4f6a18 ("xhci: Fix USB ports for Dell Inspiron 5775")
    69307ccb9ad7 ("usb: xhci: bInterval quirk for TI TUSB73x0")
    76f9502fe761 ("xhci: plat: adapt to unified device property interface")
    9da5a1092b13 ("xhci: Bad Ethernet performance plugged in ASM1042A host")
    a3aef3793071 ("xhci: get rid of platform data")
    dec08194ffec ("xhci: Limit USB2 port wake support for AMD Promontory hosts")
    def4e6f7b419 ("xhci: refactor and cleanup endpoint initialization.")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
