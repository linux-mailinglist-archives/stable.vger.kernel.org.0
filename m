Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4B2169BB1
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 02:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgBXBO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 20:14:58 -0500
Received: from mail.klausen.dk ([174.138.9.187]:32858 "EHLO mail.klausen.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727158AbgBXBO5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Feb 2020 20:14:57 -0500
Subject: Re: [PATCH v2] platform/x86: asus-wmi: Support laptops where the
 first battery is named BATT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=klausen.dk; s=dkim;
        t=1582506895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6cFIO25+cFryi3atUkmzmXjlocwuRKEsmDPIziFxrX0=;
        b=iab7zxFxcmHh0TT/S4PrUZXLyND1722D0+LXC23BaDjzsMpi7A9cUWpXty83RYSFQO5zNc
        +/IB5SBa4z+1VnCkWcJ4lbM9I0rNBQxw7aUw0KHLGmrTTV/Thhx9nA25MYDCs+BneJY1ji
        0/VhCBfX019r7s9F/W1WKRBEbXZ7RNA=
To:     Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20200223181832.17131-1-kristian@klausen.dk>
 <20200224011017.C5207208C4@mail.kernel.org>
From:   Kristian Klausen <kristian@klausen.dk>
Message-ID: <e700ebdc-3dce-c151-3ea5-f7ab1e4cb07f@klausen.dk>
Date:   Mon, 24 Feb 2020 02:14:54 +0100
MIME-Version: 1.0
In-Reply-To: <20200224011017.C5207208C4@mail.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: da
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24.02.2020 02.10, Sasha Levin wrote:
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.5.5, v5.4.21, v4.19.105, v4.14.171, v4.9.214, v4.4.214.
>
> v5.5.5: Build OK!
> v5.4.21: Build OK!
> v4.19.105: Failed to apply! Possible dependencies:
>      11e87702be65 ("PCI: pciehp: Differentiate between surprise and safe removal")
>      125450f81441 ("PCI: hotplug: Embed hotplug_slot")
>      5790a9c78e78 ("PCI: pciehp: Unify controller and slot structs")
>      7973353e92ee ("platform/x86: asus-wmi: Refactor charge threshold to use the battery hooking API")
>      80696f991424 ("PCI: pciehp: Tolerate Presence Detect hardwired to zero")
>      81c4b5bf30de ("PCI: hotplug: Constify hotplug_slot_ops")
>      a7da21613c4e ("PCI: hotplug: Drop hotplug_slot_info")
>      b096f626a682 ("platform/x86: asus-wmi: Switch fan boost mode")
>      eee6e273843d ("PCI: pciehp: Drop hotplug_slot_ops wrappers")
>
> v4.14.171: Failed to apply! Possible dependencies:
>      125450f81441 ("PCI: hotplug: Embed hotplug_slot")
>      4aed1cd6fb95 ("PCI: pciehp: Document struct slot and struct controller")
>      51bbf9bee34f ("PCI: hotplug: Demidlayer registration with the core")
>      5790a9c78e78 ("PCI: pciehp: Unify controller and slot structs")
>      7973353e92ee ("platform/x86: asus-wmi: Refactor charge threshold to use the battery hooking API")
>      81c4b5bf30de ("PCI: hotplug: Constify hotplug_slot_ops")
>      97c6f25d5828 ("PCI/hotplug: ppc: correct a php_slot usage after free")
>      a7da21613c4e ("PCI: hotplug: Drop hotplug_slot_info")
>      b096f626a682 ("platform/x86: asus-wmi: Switch fan boost mode")
>      c7abb2352c29 ("PCI: Remove unnecessary messages for memory allocation failures")
>      dbb3d78f61ba ("platform/x86: asus-wmi: Call led hw_changed API on kbd brightness change")
>      ed99d29b2b15 ("platform/x86: asus-wmi: Add keyboard backlight toggle support")
>
> v4.9.214: Failed to apply! Possible dependencies:
>      125450f81441 ("PCI: hotplug: Embed hotplug_slot")
>      4aed1cd6fb95 ("PCI: pciehp: Document struct slot and struct controller")
>      51bbf9bee34f ("PCI: hotplug: Demidlayer registration with the core")
>      5790a9c78e78 ("PCI: pciehp: Unify controller and slot structs")
>      7973353e92ee ("platform/x86: asus-wmi: Refactor charge threshold to use the battery hooking API")
>      81c4b5bf30de ("PCI: hotplug: Constify hotplug_slot_ops")
>      97c6f25d5828 ("PCI/hotplug: ppc: correct a php_slot usage after free")
>      a7da21613c4e ("PCI: hotplug: Drop hotplug_slot_info")
>      b096f626a682 ("platform/x86: asus-wmi: Switch fan boost mode")
>      c7abb2352c29 ("PCI: Remove unnecessary messages for memory allocation failures")
>      dbb3d78f61ba ("platform/x86: asus-wmi: Call led hw_changed API on kbd brightness change")
>      ed99d29b2b15 ("platform/x86: asus-wmi: Add keyboard backlight toggle support")
>
> v4.4.214: Failed to apply! Possible dependencies:
>      125450f81441 ("PCI: hotplug: Embed hotplug_slot")
>      2ac83cccabbc ("PCI: hotplug: Use list_for_each_entry() to simplify code")
>      51bbf9bee34f ("PCI: hotplug: Demidlayer registration with the core")
>      66725152fb9f ("PCI/hotplug: PowerPC PowerNV PCI hotplug driver")
>      7973353e92ee ("platform/x86: asus-wmi: Refactor charge threshold to use the battery hooking API")
>      89379f165a1b ("PCI/hotplug: pnv_php: export symbols and move struct types needed by cxl")
>      97c6f25d5828 ("PCI/hotplug: ppc: correct a php_slot usage after free")
>      a7da21613c4e ("PCI: hotplug: Drop hotplug_slot_info")
>      b096f626a682 ("platform/x86: asus-wmi: Switch fan boost mode")
>      dbb3d78f61ba ("platform/x86: asus-wmi: Call led hw_changed API on kbd brightness change")
>      ed99d29b2b15 ("platform/x86: asus-wmi: Add keyboard backlight toggle support")
>      ef69b03dfd32 ("MAINTAINERS: Add powerpc drivers to the powerpc section")
>      ff3ce480e8b5 ("PCI: Fix all whitespace issues")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

The patch should only be applied to the v5.4 and v5.5 trees.
- Kristian
