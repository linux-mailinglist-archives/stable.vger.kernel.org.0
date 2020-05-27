Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220981E4B36
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 18:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389733AbgE0Q6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 12:58:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387913AbgE0Q6D (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 12:58:03 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACDBF20C09;
        Wed, 27 May 2020 16:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590598682;
        bh=Zgs3ccEsGbJs7QUjPvZSh9uNEyoqKDTE8+GbiCafCuw=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=BpZGYzEU29cupZ5FK7KTZC2fWtXMgxUf5U2xAX0ntrVIV7RT9cno2tuJt0keiKe+c
         VwZVwbS1nZweYAO+/GPOuEXb4H2zMckszbWYdMrfyZOnSoUNNQHSlf/PQAC5Hu+l5V
         sp+d2285PwykdpMP5lQh/M2VUUUkYIXlyYapGMjs=
Date:   Wed, 27 May 2020 16:58:01 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>, kai.heng.feng@canonical.com
Cc:     linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] HID: multitouch: enable multi-input as a quirk for some devices
In-Reply-To: <20200526150717.324783-1-benjamin.tissoires@redhat.com>
References: <20200526150717.324783-1-benjamin.tissoires@redhat.com>
Message-Id: <20200527165802.ACDBF20C09@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.14, v5.4.42, v4.19.124, v4.14.181, v4.9.224, v4.4.224.

v5.6.14: Build OK!
v5.4.42: Build OK!
v4.19.124: Failed to apply! Possible dependencies:
    69ecd44d68a7 ("HID: multitouch: add support for the Smart Tech panel")
    7ffa13be4945 ("HID: multitouch: simplify the application retrieval")

v4.14.181: Failed to apply! Possible dependencies:
    127e71bd462b ("HID: multitouch: Combine all left-button events in a frame")
    29cc309d8bf1 ("HID: hid-multitouch: forward MSC_TIMESTAMP")
    69ecd44d68a7 ("HID: multitouch: add support for the Smart Tech panel")
    7f81c8db5489 ("HID: multitouch: simplify the settings of the various features")
    abb36fe691b2 ("HID: multitouch: fix calculation of last slot field in multi-touch reports")
    af8dc4d09490 ("HID: multitouch: Properly deal with Win8 PTP reports with 0 touches")
    d9c57a7090ba ("HID: multitouch: export a quirk for the button handling of touchpads")
    f146d1c4d7ea ("HID: multitouch: Store per collection multitouch data")

v4.9.224: Failed to apply! Possible dependencies:
    0485b1ec280c ("HID: asus: ignore declared dummy usages")
    1caccc2565a8 ("HID: asus: support Republic of Gamers special keys")
    4f4001bc76fd ("HID: multitouch: fix rare Win 8 cases when the touch up event gets missing")
    69ecd44d68a7 ("HID: multitouch: add support for the Smart Tech panel")
    76dd1fbebbae ("HID: asus: Add support for T100 keyboard")
    957b8dffa4e3 ("HID: multitouch: Support Asus T304UA media keys")
    9ce12d8be12c ("HID: asus: Add i2c touchpad support")
    a93913e1496d ("HID: asus: fix and generalize ambiguous preprocessor macros")
    af22a610bc38 ("HID: asus: support backlight on USB keyboards")
    c8b1b3dd89ea ("HID: asus: Fix keyboard support")
    d9c57a7090ba ("HID: multitouch: export a quirk for the button handling of touchpads")
    e9d0a26d3481 ("HID: multitouch: change for touch height/width")
    f3287a995ac3 ("HID: multitouch: fix LG Melfas touchscreen")
    fd91189654a3 ("HID: multitouch: use BIT macro")

v4.4.224: Failed to apply! Possible dependencies:
    0485b1ec280c ("HID: asus: ignore declared dummy usages")
    1caccc2565a8 ("HID: asus: support Republic of Gamers special keys")
    69ecd44d68a7 ("HID: multitouch: add support for the Smart Tech panel")
    76dd1fbebbae ("HID: asus: Add support for T100 keyboard")
    957b8dffa4e3 ("HID: multitouch: Support Asus T304UA media keys")
    9ce12d8be12c ("HID: asus: Add i2c touchpad support")
    a93913e1496d ("HID: asus: fix and generalize ambiguous preprocessor macros")
    af22a610bc38 ("HID: asus: support backlight on USB keyboards")
    b94f7d5ddf1b ("HID: asus: add support for VivoBook E200HA")
    c8b1b3dd89ea ("HID: asus: Fix keyboard support")
    d9c57a7090ba ("HID: multitouch: export a quirk for the button handling of touchpads")
    eeb01a57921a ("HID: Asus X205TA keyboard driver")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
