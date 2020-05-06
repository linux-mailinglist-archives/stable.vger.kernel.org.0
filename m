Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1FD1C7E03
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 01:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbgEFXmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 19:42:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728105AbgEFXmI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 19:42:08 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 847C620735;
        Wed,  6 May 2020 23:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588808527;
        bh=rODOhhP48oDvPlU2Gdll8Paz0KB3qB8SejLcL6MQODo=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=cZEpJTdE/o3XHZfJSi111Npy6pcpzRu7Fk2gN4AedfhpMy2XqVluah8ZsFN7FmtDn
         j+riWhmpHy8NPbuZUGe1Xcfl7pFbAiR+ZUoD3Po31e04y0p5VTHBNo3QoQbihRBMmG
         OZP0X+Gol3yUC5vuMrxB6YET5D86kGk4Cs0iTW0Y=
Date:   Wed, 06 May 2020 23:42:06 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Julian Sax <jsbc@gmx.de>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-input@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] HID: i2c-hid: add Schneider SCL142ALM to descriptor override
In-Reply-To: <20200505151042.122157-1-jsbc@gmx.de>
References: <20200505151042.122157-1-jsbc@gmx.de>
Message-Id: <20200506234207.847C620735@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.10, v5.4.38, v4.19.120, v4.14.178, v4.9.221, v4.4.221.

v5.6.10: Build OK!
v5.4.38: Build OK!
v4.19.120: Failed to apply! Possible dependencies:
    eb6964fa6509 ("HID: i2c-hid: add iBall Aer3 to descriptor override")

v4.14.178: Failed to apply! Possible dependencies:
    eb6964fa6509 ("HID: i2c-hid: add iBall Aer3 to descriptor override")

v4.9.221: Failed to apply! Possible dependencies:
    eb6964fa6509 ("HID: i2c-hid: add iBall Aer3 to descriptor override")

v4.4.221: Failed to apply! Possible dependencies:
    00f7fea5da49 ("HID: i2c-hid: force the IRQ level trigger only when not set")
    01714a6f5fa5 ("HID: i2c-hid: Fix suspend/resume when already runtime suspended")
    070b9637dd8f ("HID: i2c-hid: Add RESEND_REPORT_DESCR quirk for Toshiba Click Mini L9W-B")
    2dcc8197fefc ("HID: i2c-hid: Silently fail probe for CHPN0001 touchscreen")
    3e83eda46705 ("HID: i2c-hid: Fix resume issue on Raydium touchscreen device")
    402946a8ef71 ("HID: i2c-hid: Add no-irq-after-reset quirk for 0911:5288 device")
    572d3c644497 ("HID: i2c-hid: support regulator power on/off")
    71af01a8c85a ("HID: i2c-hid: add a simple quirk to fix device defects")
    85ae91133152 ("HID: i2c-hid: remove custom locking from i2c_hid_open/close")
    8cd16166b000 ("HID: fix missing irq field")
    91b9ae48aadd ("HID: i2c-hid: move header file out of I2C realm")
    94116f8126de ("ACPI: Switch to use generic guid_t in acpi_evaluate_dsm()")
    9a327405014f ("HID: i2c-hid: Prevent sending reports from racing with device reset")
    9ee3e06610fd ("HID: i2c-hid: override HID descriptors for certain devices")
    b59dfdaef173 ("i2c-hid: properly terminate i2c_hid_dmi_desc_override_table[] array")
    b7fe92999a98 ("ACPI / extlog: Switch to use new generic UUID API")
    ba1660f1791f ("HID: i2c-hid: fix build")
    ba18a9314a94 ("Revert "HID: i2c-hid: Add support for ACPI GPIO interrupts"")
    d46ddc593f4d ("HID: i2c-hid: Disable IRQ before freeing buffers")
    eb6964fa6509 ("HID: i2c-hid: add iBall Aer3 to descriptor override")
    f8f807441eef ("HID: i2c-hid: Add Odys Winbook 13 to descriptor override")
    fc2237a724a9 ("HID: introduce hid_is_using_ll_driver")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
