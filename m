Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB39A24AA55
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 01:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgHSX54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 19:57:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726852AbgHSX4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 19:56:38 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F43920888;
        Wed, 19 Aug 2020 23:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881398;
        bh=O03PNXGiTfLlqaYLaLsLxdoHLkAATnOlbfe1GsI7Dlg=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=1i9LdluR1+hYl/pvRDp+GyXWLyUKhOxwIJYXzzjsXgwL2j0q1+YpJCTYv3/IY9Xa6
         x9t1+zpS1NUfTiYALu6io6ebeirOTLEulAa/6QSJVfrZQzE903bYbygVNekFMGDQ5l
         UOeL0DI5mtQ+JImP8Sqrjay408U9tpnI8qHGFw54=
Date:   Wed, 19 Aug 2020 23:56:37 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] HID: i2c-hid: Always sleep 1ms after I2C_HID_PWR_ON commands
In-Reply-To: <20200811125900.338705-1-hdegoede@redhat.com>
References: <20200811125900.338705-1-hdegoede@redhat.com>
Message-Id: <20200819235638.5F43920888@mail.kernel.org>
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
v5.7.15: Build OK!
v5.4.58: Build OK!
v4.19.139: Build OK!
v4.14.193: Build OK!
v4.9.232: Build OK!
v4.4.232: Failed to apply! Possible dependencies:
    71af01a8c85a ("HID: i2c-hid: add a simple quirk to fix device defects")
    9a327405014f ("HID: i2c-hid: Prevent sending reports from racing with device reset")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
