Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9EC1EFA11
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgFEOKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728044AbgFEOKz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:10:55 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC0B120835;
        Fri,  5 Jun 2020 14:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366255;
        bh=CNyJQpUupP1VptwAfhemfHKtKCsU3tC8MykrveY/B0I=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=h9Ksdm2RAWroIxMjOQbK5lMxFiZgCZfVJt/raTo7wckVjD2oKOgibRd2RdKIBu9Qp
         Lo/DBGUhnC+JzGPAMPxa30d5iTRMrUYzkBa3lzBLD1e491SOG0w/QhmB5kcpTAiklO
         SEhQ//2BAPUvvjU0TQLyRDOpbqYkP+jiusmcV7F8=
Date:   Fri, 05 Jun 2020 14:10:54 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] pinctrl: baytrail: Fix pin being driven low for a while on gpiod_get(..., GPIOD_OUT_HIGH)
In-Reply-To: <20200602122130.45630-1-hdegoede@redhat.com>
References: <20200602122130.45630-1-hdegoede@redhat.com>
Message-Id: <20200605141054.BC0B120835@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.15, v5.4.43, v4.19.125, v4.14.182, v4.9.225, v4.4.225.

v5.6.15: Build OK!
v5.4.43: Failed to apply! Possible dependencies:
    e2b74419e5cc ("pinctrl: baytrail: Replace WARN with dev_info_once when setting direct-irq pin to output")

v4.19.125: Failed to apply! Possible dependencies:
    e2b74419e5cc ("pinctrl: baytrail: Replace WARN with dev_info_once when setting direct-irq pin to output")

v4.14.182: Failed to apply! Possible dependencies:
    e2b74419e5cc ("pinctrl: baytrail: Replace WARN with dev_info_once when setting direct-irq pin to output")

v4.9.225: Failed to apply! Possible dependencies:
    e2b74419e5cc ("pinctrl: baytrail: Replace WARN with dev_info_once when setting direct-irq pin to output")

v4.4.225: Failed to apply! Possible dependencies:
    86e3ef812fe3 ("pinctrl: baytrail: Update gpio chip operations")
    bf9a5c96c87c ("pinctrl: baytrail: use gpiochip data pointer")
    c501d0b149de ("pinctrl: baytrail: Add pin control operations")
    c8f5c4c7c82c ("pinctrl: baytrail: Add pin control data structures")
    e2b74419e5cc ("pinctrl: baytrail: Replace WARN with dev_info_once when setting direct-irq pin to output")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
