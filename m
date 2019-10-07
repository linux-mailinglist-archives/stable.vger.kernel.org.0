Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 798A5CEC27
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 20:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbfJGSvI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 7 Oct 2019 14:51:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58305 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728860AbfJGSvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 14:51:08 -0400
Received: from mail-pf1-f198.google.com ([209.85.210.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1iHY65-0004k5-TV
        for stable@vger.kernel.org; Mon, 07 Oct 2019 18:51:06 +0000
Received: by mail-pf1-f198.google.com with SMTP id s137so11717056pfs.18
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 11:51:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=xXnK7oD0S+17LMeZ9WTl+25MN7BhkE11C6CYbaSXA0I=;
        b=IJEUbGXr9sRqsPtb+IwZRoIbzqmsPvMVnc5xjM9vB3FsVtz224VpJkmcgWIDG4TGSa
         2VnEfgRK363d4MxwKVarKuEJ3imcK6hvsXoTEgSYQpe6lzlll0S+QdkHI/lOiIYC/0Re
         abnE+BRD97ulWTtrYwQb64ie9Raada9PlLhpXcp8L0OQSUTK8woCAugGlsyZcxj871yf
         S1lsJYW1FnDvDdvbDH37qImxdGStJF2kCP64L0Vr4fj++3jQu2YQjX7ICveIwcee1iac
         7tFsHwRMqEiugl71Yg7NF9pnmt/wc8c1Xp/D3ZD56hlZL5EXHnIpOSepI9kerao02W4+
         MWIw==
X-Gm-Message-State: APjAAAXzIdRImLN90imkDFSOsYEDNPcuOM/dshL7eFWXPGnpmyV467TW
        B+8owxV7sXemVO+OP3DPl/qp+RH8XLWnbqesGL+mbaLju6mlX9MV/FWnl04hPMYnB1Ne6hxmgPb
        4Tk9u5Vy/a+36RfsPc68B1PAVDpcz6Bg9rg==
X-Received: by 2002:a17:902:a40a:: with SMTP id p10mr30871115plq.149.1570474264467;
        Mon, 07 Oct 2019 11:51:04 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxPH0vAH2jwBegkvLPOA4RhJ8Li+miRjRGaCiy/JurZoui+Ji1L1sd2xSap2ccHvWr+Kxs/YQ==
X-Received: by 2002:a17:902:a40a:: with SMTP id p10mr30871095plq.149.1570474264188;
        Mon, 07 Oct 2019 11:51:04 -0700 (PDT)
Received: from 2001-b011-380f-3c42-ecd4-c98e-b194-f9c1.dynamic-ip6.hinet.net (2001-b011-380f-3c42-ecd4-c98e-b194-f9c1.dynamic-ip6.hinet.net. [2001:b011:380f:3c42:ecd4:c98e:b194:f9c1])
        by smtp.gmail.com with ESMTPSA id ce16sm223338pjb.29.2019.10.07.11.51.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 11:51:03 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3594.4.19\))
Subject: Re: [PATCH 7/8] xhci: Increase STS_SAVE timeout in xhci_suspend()
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <20191006120750.5334F2087E@mail.kernel.org>
Date:   Tue, 8 Oct 2019 02:51:02 +0800
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <993EAB64-6D52-469C-ADC2-2331DFBCA9BD@canonical.com>
References: <1570190373-30684-8-git-send-email-mathias.nyman@linux.intel.com>
 <20191006120750.5334F2087E@mail.kernel.org>
To:     Sasha Levin <sashal@kernel.org>
X-Mailer: Apple Mail (2.3594.4.19)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

> On Oct 6, 2019, at 20:07, Sasha Levin <sashal@kernel.org> wrote:
> 
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: f7fac17ca925 xhci: Convert xhci_handshake() to use readl_poll_timeout_atomic().
> 
> The bot has tested the following trees: v5.3.2, v5.2.18, v4.19.76, v4.14.146, v4.9.194, v4.4.194.
> 
> v5.3.2: Build OK!
> v5.2.18: Build OK!
> v4.19.76: Build OK!
> v4.14.146: Build OK!
> v4.9.194: Failed to apply! Possible dependencies:
>    0b6c324c8b60 ("xhci: cleanup and refactor process_ctrl_td()")
>    0f1d832ed1fb ("usb: xhci: Add port test modes support for usb2.")
>    11644a765952 ("xhci: Add quirk to workaround the errata seen on Cavium Thunder-X2 Soc")
>    191edc5e2e51 ("xhci: Fix front USB ports on ASUS PRIME B350M-A")
>    1cc6d8617b91 ("usb: xhci: remove unnecessary second abort try")
>    2a72126de1bb ("xhci: Remove duplicate xhci urb giveback functions")
>    2d6d5769f82d ("xhci: fix non static symbol warning")
>    30a65b45bfb1 ("xhci: cleanup and refactor process_bulk_intr_td()")
>    446b31419cb1 ("xhci: refactor handle_tx_event() urb giveback")
>    4750bc78efdb ("usb: host: xhci support option to disable the xHCI USB2 HW LPM")
>    488dc164914f ("xhci: remove WARN_ON if dma mask is not set for platform devices")
>    4c39d4b949d3 ("usb: xhci: use bus->sysdev for DMA configuration")
>    505f581c48bc ("xhci: simplify if statement to make it more readable")
>    52ab86852f74 ("xhci: remove extra URB_SHORT_NOT_OK checks in xhci, core handles most cases")
>    6b7f40f71234 ("xhci: change xhci_set_link_state() to work with port structures")
>    76a35293b901 ("usb: host: xhci: simplify irq handler return")
>    9983a5fc39bf ("xhci: rename EP_HALT_PENDING to EP_STOP_CMD_PENDING")
>    9ef7fbbb4fdf ("xhci: Rename variables related to transfer descritpors")
>    a6ff6cbf1fab ("usb: xhci: Add helper function xhci_set_power_on().")
>    a7d57abcc8a5 ("xhci: workaround CSS timeout on AMD SNPS 3.0 xHC")
>    d3519b9d9606 ("xhci: Manually give back cancelled URB if we can't queue it for cancel")
>    d9f11ba9f107 ("xhci: Rework how we handle unresponsive or hoptlug removed hosts")
>    e740b019d7c6 ("xhci: xhci-hub: use new port structures to get port address instead of port array")
>    eaefcf246b56 ("xhci: change xhci_test_and_clear_bit() to use new port structure")
>    f97c08ae329b ("xhci: rename endpoint related trb variables")
>    f99265965b32 ("xhci: detect stop endpoint race using pending timer instead of counter.")
>    ffd4b4fc0b9a ("xhci: Add helper to get xhci roothub from hcd")
> 
> v4.4.194: Failed to apply! Possible dependencies:
>    11644a765952 ("xhci: Add quirk to workaround the errata seen on Cavium Thunder-X2 Soc")
>    191edc5e2e51 ("xhci: Fix front USB ports on ASUS PRIME B350M-A")
>    21939f003ad0 ("usb: host: xhci-plat: enable BROKEN_PED quirk if platform requested")
>    41135de1e7fd ("usb: xhci: add quirk flag for broken PED bits")
>    4750bc78efdb ("usb: host: xhci support option to disable the xHCI USB2 HW LPM")
>    488dc164914f ("xhci: remove WARN_ON if dma mask is not set for platform devices")
>    4c39d4b949d3 ("usb: xhci: use bus->sysdev for DMA configuration")
>    4efb2f694114 ("usb: host: xhci-plat: add struct xhci_plat_priv")
>    69307ccb9ad7 ("usb: xhci: bInterval quirk for TI TUSB73x0")
>    76f9502fe761 ("xhci: plat: adapt to unified device property interface")
>    9da5a1092b13 ("xhci: Bad Ethernet performance plugged in ASM1042A host")
>    a3aef3793071 ("xhci: get rid of platform data")
>    a7d57abcc8a5 ("xhci: workaround CSS timeout on AMD SNPS 3.0 xHC")
>    dec08194ffec ("xhci: Limit USB2 port wake support for AMD Promontory hosts")
>    def4e6f7b419 ("xhci: refactor and cleanup endpoint initialization.")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.

Where do I send backport for v4.4 and v4.9?

Kai-Heng

> 
> How should we proceed with this patch?
> 
> -- 
> Thanks,
> Sasha

