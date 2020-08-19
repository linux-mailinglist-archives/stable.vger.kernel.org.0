Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324B324AA60
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 01:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgHSX6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 19:58:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726795AbgHSX4b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 19:56:31 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BD41208DB;
        Wed, 19 Aug 2020 23:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881390;
        bh=gekwEyKHMtJHQprltV7Nfh0WsiY3eKog6KRSba047t4=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=it2q69w6vItv/6wOgJ8FHh/aO0QW9U4Xo9DmoklncExVEjTKBwDP9nRv7Gl9bpQES
         6Y2PHS8M6PRREZVjCaf/RULxJMxEfhlz3y1gzOeSYm41p/1WWzNm2COwYJnQGm4kZo
         uN2ZEePvgt2poOwDzPyiunbIkTtIM9LvpoW2cWLk=
Date:   Wed, 19 Aug 2020 23:56:29 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/4] usb: typec: ucsi: Fix 2 unlocked ucsi_run_command calls
In-Reply-To: <20200809141904.4317-3-hdegoede@redhat.com>
References: <20200809141904.4317-3-hdegoede@redhat.com>
Message-Id: <20200819235630.2BD41208DB@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.1, v5.7.15, v5.4.58, v4.19.139, v4.14.193, v4.9.232, v4.4.232.

v5.8.1: Build OK!
v5.7.15: Failed to apply! Possible dependencies:
    4dbc6a4ef06d ("usb: typec: ucsi: save power data objects in PD mode")

v5.4.58: Failed to apply! Possible dependencies:
    2ede55468ca8 ("usb: typec: ucsi: Remove the old API")
    3cf657f07918 ("usb: typec: ucsi: Remove all bit-fields")
    470ce43a1a81 ("usb: typec: ucsi: Remove struct ucsi_control")
    4dbc6a4ef06d ("usb: typec: ucsi: save power data objects in PD mode")
    6df475f804e6 ("usb: typec: ucsi: Start using struct typec_operations")
    bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")

v4.19.139: Failed to apply! Possible dependencies:
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
    247c554a14aa ("usb: typec: ucsi: add support for Cypress CCGx")
    2ede55468ca8 ("usb: typec: ucsi: Remove the old API")
    3c4fb9f16921 ("usb: typec: wcove: start using tcpm for USB PD support")
    44262fad12a7 ("staging: typec: tcpm: Drop commented out code")
    4b4e02c83167 ("typec: tcpm: Move out of staging")
    70cd90be3300 ("staging: typec: pd: Document struct pd_message")
    76f0c53d08b9 ("usb: typec: fusb302: Move out of staging")
    81534d5fa973 ("usb: typec: ucsi: Remove debug.h file")
    956c36c297a2 ("USB: typec: add SPDX identifiers to some files")
    98076fa64a05 ("staging: typec: tcpm: Document data structures")
    ad74b8649bea ("usb: typec: ucsi: Preliminary support for alternate modes")
    af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
    cf6e06cddf29 ("usb: typec: Start using ERR_PTR")

v4.9.232: Failed to apply! Possible dependencies:
    0c744ea4f77d ("Linux 4.10-rc2")
    2bd6bf03f4c1 ("Linux 4.14-rc1")
    2ea659a9ef48 ("Linux 4.12-rc1")
    2ede55468ca8 ("usb: typec: ucsi: Remove the old API")
    49def1853334 ("Linux 4.10-rc4")
    566cf877a1fc ("Linux 4.10-rc6")
    5771a8c08880 ("Linux v4.13-rc1")
    7089db84e356 ("Linux 4.10-rc8")
    7a308bb3016f ("Linux 4.10-rc5")
    7ce7d89f4883 ("Linux 4.10-rc1")
    a121103c9228 ("Linux 4.10-rc3")
    af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
    b24413180f56 ("License cleanup: add SPDX GPL-2.0 license identifier to files with no license")
    c1ae3cfa0e89 ("Linux 4.11-rc1")
    c470abd4fde4 ("Linux 4.10")
    d5adbfcd5f7b ("Linux 4.10-rc7")

v4.4.232: Failed to apply! Possible dependencies:
    1001354ca341 ("Linux 4.9-rc1")
    18558cae0272 ("Linux 4.5-rc4")
    1a695a905c18 ("Linux 4.7-rc1")
    29b4817d4018 ("Linux 4.8-rc1")
    2bd6bf03f4c1 ("Linux 4.14-rc1")
    2dcd0af568b0 ("Linux 4.6")
    2ea659a9ef48 ("Linux 4.12-rc1")
    2ede55468ca8 ("usb: typec: ucsi: Remove the old API")
    36f90b0a2ddd ("Linux 4.5-rc2")
    388f7b1d6e8c ("Linux 4.5-rc3")
    5771a8c08880 ("Linux v4.13-rc1")
    7ce7d89f4883 ("Linux 4.10-rc1")
    81f70ba233d5 ("Linux 4.5-rc5")
    92e963f50fc7 ("Linux 4.5-rc1")
    af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
    b24413180f56 ("License cleanup: add SPDX GPL-2.0 license identifier to files with no license")
    b562e44f507e ("Linux 4.5")
    c1ae3cfa0e89 ("Linux 4.11-rc1")
    f55532a0c0b8 ("Linux 4.6-rc1")
    f6cede5b49e8 ("Linux 4.5-rc7")
    fc77dbd34c5c ("Linux 4.5-rc6")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
