Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8AE243D37
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 18:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgHMQZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 12:25:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbgHMQZl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Aug 2020 12:25:41 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B320220866;
        Thu, 13 Aug 2020 16:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597335940;
        bh=XPNtycDZdrw9Y/kW3uHHmFHZ1URF9FVwzAziKr+DQ8g=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=pwQg7to3NFQyJ/gui+ui5Bp4RvxKW4CsSOFe5pcqBpQSirsAMFfFRaaBx+xlmzTsO
         fjcjg1cpdYja2mcLwC4GRrBZsTscEr6RLyrZRouDjtru4HOxPhOUMe1IaIkFos9k3t
         CRf9YvtW6uUcSq4fk7CRQ7av17/Cax3fuJHBwS6Q=
Date:   Thu, 13 Aug 2020 16:25:40 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 3/4] usb: typec: ucsi: Rework ppm_lock handling
In-Reply-To: <20200809141904.4317-4-hdegoede@redhat.com>
References: <20200809141904.4317-4-hdegoede@redhat.com>
Message-Id: <20200813162540.B320220866@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8, v5.7.14, v5.4.57, v4.19.138, v4.14.193, v4.9.232, v4.4.232.

v5.8: Build OK!
v5.7.14: Failed to apply! Possible dependencies:
    4dbc6a4ef06d ("usb: typec: ucsi: save power data objects in PD mode")
    e969b61a4e49 ("usb: typec: ucsi: Fix 2 unlocked ucsi_run_command calls")

v5.4.57: Failed to apply! Possible dependencies:
    170a6726d0e2 ("usb: typec: ucsi: add support for separate DP altmode devices")
    2ede55468ca8 ("usb: typec: ucsi: Remove the old API")
    30381171978a ("usb: typec: ucsi: Fix AB BA lock inversion")
    3cf657f07918 ("usb: typec: ucsi: Remove all bit-fields")
    470ce43a1a81 ("usb: typec: ucsi: Remove struct ucsi_control")
    4dbc6a4ef06d ("usb: typec: ucsi: save power data objects in PD mode")
    6df475f804e6 ("usb: typec: ucsi: Start using struct typec_operations")
    71a1fa0df2a3 ("usb: typec: ucsi: Store the notification mask")
    bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
    e969b61a4e49 ("usb: typec: ucsi: Fix 2 unlocked ucsi_run_command calls")

v4.19.138: Failed to apply! Possible dependencies:
    247c554a14aa ("usb: typec: ucsi: add support for Cypress CCGx")
    2ede55468ca8 ("usb: typec: ucsi: Remove the old API")
    470ce43a1a81 ("usb: typec: ucsi: Remove struct ucsi_control")
    5c9ae5a87573 ("usb: typec: ucsi: ccg: add firmware flashing support")
    5d438e200215 ("usb: typec: ucsi: ccg: add get_fw_info function")
    6df475f804e6 ("usb: typec: ucsi: Start using struct typec_operations")
    81534d5fa973 ("usb: typec: ucsi: Remove debug.h file")
    a94ecde41f7e ("usb: typec: ucsi: ccg: enable runtime pm support")
    ad74b8649bea ("usb: typec: ucsi: Preliminary support for alternate modes")
    af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
    bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
    f2372b87c386 ("usb: typec: ucsi: displayport: Fix for the mode entering routine")

v4.14.193: Failed to apply! Possible dependencies:
    0a4c005bd171 ("usb: typec: driver for TI TPS6598x USB Power Delivery controllers")
    3c4fb9f16921 ("usb: typec: wcove: start using tcpm for USB PD support")
    44262fad12a7 ("staging: typec: tcpm: Drop commented out code")
    4b4e02c83167 ("typec: tcpm: Move out of staging")
    70cd90be3300 ("staging: typec: pd: Document struct pd_message")
    76f0c53d08b9 ("usb: typec: fusb302: Move out of staging")
    81534d5fa973 ("usb: typec: ucsi: Remove debug.h file")
    956c36c297a2 ("USB: typec: add SPDX identifiers to some files")
    98076fa64a05 ("staging: typec: tcpm: Document data structures")
    ad74b8649bea ("usb: typec: ucsi: Preliminary support for alternate modes")
    bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
    cf6e06cddf29 ("usb: typec: Start using ERR_PTR")

v4.9.232: Failed to apply! Possible dependencies:
    0c744ea4f77d ("Linux 4.10-rc2")
    2bd6bf03f4c1 ("Linux 4.14-rc1")
    2ea659a9ef48 ("Linux 4.12-rc1")
    49def1853334 ("Linux 4.10-rc4")
    566cf877a1fc ("Linux 4.10-rc6")
    5771a8c08880 ("Linux v4.13-rc1")
    7089db84e356 ("Linux 4.10-rc8")
    7a308bb3016f ("Linux 4.10-rc5")
    7ce7d89f4883 ("Linux 4.10-rc1")
    81534d5fa973 ("usb: typec: ucsi: Remove debug.h file")
    a121103c9228 ("Linux 4.10-rc3")
    ad74b8649bea ("usb: typec: ucsi: Preliminary support for alternate modes")
    b24413180f56 ("License cleanup: add SPDX GPL-2.0 license identifier to files with no license")
    bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
    c1ae3cfa0e89 ("Linux 4.11-rc1")
    c1b0bc2dabfa ("usb: typec: Add support for UCSI interface")
    c470abd4fde4 ("Linux 4.10")
    d2061f9cc32d ("usb: typec: add driver for Intel Whiskey Cove PMIC USB Type-C PHY")
    d5adbfcd5f7b ("Linux 4.10-rc7")
    fab9288428ec ("usb: USB Type-C connector class")

v4.4.232: Failed to apply! Possible dependencies:
    1001354ca341 ("Linux 4.9-rc1")
    18558cae0272 ("Linux 4.5-rc4")
    1a695a905c18 ("Linux 4.7-rc1")
    29b4817d4018 ("Linux 4.8-rc1")
    2bd6bf03f4c1 ("Linux 4.14-rc1")
    2ea659a9ef48 ("Linux 4.12-rc1")
    36f90b0a2ddd ("Linux 4.5-rc2")
    388f7b1d6e8c ("Linux 4.5-rc3")
    5771a8c08880 ("Linux v4.13-rc1")
    6406c3d22637 ("usb: Kconfig: let USB_ULPI_BUS depends on USB_COMMON")
    7ce7d89f4883 ("Linux 4.10-rc1")
    81534d5fa973 ("usb: typec: ucsi: Remove debug.h file")
    81f70ba233d5 ("Linux 4.5-rc5")
    92e963f50fc7 ("Linux 4.5-rc1")
    9360575c5837 ("usbip: vudc: Add vudc to Kconfig")
    ad74b8649bea ("usb: typec: ucsi: Preliminary support for alternate modes")
    ad764c49f65a ("usb: Kconfig: move ulpi bus support out of host")
    b24413180f56 ("License cleanup: add SPDX GPL-2.0 license identifier to files with no license")
    b562e44f507e ("Linux 4.5")
    b5a2a8ecb204 ("usbip: vudc: fix Kconfig dependencies")
    bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
    c1ae3cfa0e89 ("Linux 4.11-rc1")
    c1b0bc2dabfa ("usb: typec: Add support for UCSI interface")
    cb9c1cfc8692 ("usb: Kconfig: using select for USB_COMMON dependency")
    d2061f9cc32d ("usb: typec: add driver for Intel Whiskey Cove PMIC USB Type-C PHY")
    f55532a0c0b8 ("Linux 4.6-rc1")
    f6cede5b49e8 ("Linux 4.5-rc7")
    fab9288428ec ("usb: USB Type-C connector class")
    fc77dbd34c5c ("Linux 4.5-rc6")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
