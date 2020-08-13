Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC39243D4B
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 18:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgHMQZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 12:25:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbgHMQZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Aug 2020 12:25:52 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69EC12087D;
        Thu, 13 Aug 2020 16:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597335952;
        bh=JAPpfRZXLNdYBKvtao6PPB6CJd8HYtzRsEOKYgD2+JU=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=ODMDu4OF7ml+423x/0nw9fjic7PhdJZSdXT9HZFt0APOX0cbMwRf2/VYn7a5uZPaZ
         yN6EzX69Zv7x/1/zip2fpJWL2FTbqMiR9jk59VWacubTPQ2zRaswEwyDfcLk0SmTUf
         kJ+09bpNisBxmlrZUjWV16W8To1Fve7LBvzf2MDw=
Date:   Thu, 13 Aug 2020 16:25:51 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] HID: i2c-hid: Always sleep 1ms after I2C_HID_PWR_ON commands
In-Reply-To: <20200805083011.5752-1-hdegoede@redhat.com>
References: <20200805083011.5752-1-hdegoede@redhat.com>
Message-Id: <20200813162552.69EC12087D@mail.kernel.org>
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
v5.7.14: Build OK!
v5.4.57: Build OK!
v4.19.138: Build OK!
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
