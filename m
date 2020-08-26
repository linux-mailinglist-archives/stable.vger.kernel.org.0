Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998892530AD
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730539AbgHZNzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730451AbgHZNx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 09:53:58 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D676222B47;
        Wed, 26 Aug 2020 13:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598450038;
        bh=XN/7xbmRyQzQM4W35vuJM4kB/IMClTtMi1Bbda7wrU4=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=S5SIw+6w+SEbZKsxoHj+A5KA64jL+7pd8ziJQM+l6uM12f84NAlsYNE573Oa9lLB6
         4JX49cHFAAT18Q57cQ/dU8qht5cRQyN65N+D7+yf7bCDa8HVRbfQpLdc380CfrCoNG
         51Q3lR3l1GZzl4okDLUP7BkFGqsCIQK2dEYJjKSk=
Date:   Wed, 26 Aug 2020 13:53:57 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4/4] usb: typec: ucsi: Hold con->lock for the entire duration of ucsi_register_port()
In-Reply-To: <20200809141904.4317-5-hdegoede@redhat.com>
References: <20200809141904.4317-5-hdegoede@redhat.com>
Message-Id: <20200826135357.D676222B47@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 081da1325d35 ("usb: typec: ucsi: displayport: Fix a potential race during registration").

The bot has tested the following trees: v5.8.2, v5.7.16, v5.4.59.

v5.8.2: Build OK!
v5.7.16: Failed to apply! Possible dependencies:
    4dbc6a4ef06d ("usb: typec: ucsi: save power data objects in PD mode")
    992a60ed0d5e ("usb: typec: ucsi: register with power_supply class")

v5.4.59: Failed to apply! Possible dependencies:
    2ede55468ca8 ("usb: typec: ucsi: Remove the old API")
    3cf657f07918 ("usb: typec: ucsi: Remove all bit-fields")
    470ce43a1a81 ("usb: typec: ucsi: Remove struct ucsi_control")
    4dbc6a4ef06d ("usb: typec: ucsi: save power data objects in PD mode")
    6df475f804e6 ("usb: typec: ucsi: Start using struct typec_operations")
    992a60ed0d5e ("usb: typec: ucsi: register with power_supply class")
    bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
