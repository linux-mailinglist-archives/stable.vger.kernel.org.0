Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4954A28F5B0
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 17:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388601AbgJOPR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 11:17:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388086AbgJOPR7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Oct 2020 11:17:59 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F77D2222E;
        Thu, 15 Oct 2020 15:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602775079;
        bh=roeoQvCJe5dIoCjeds8tyYhRyPq2dSZuCaj8jY51M/4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XvAlIluGQggpHtpPfSSi9yo/FL5vQyDCO0x993E272BCvxp68e5KVv2CtEWRYP58y
         YVJ6MR94W1v5oQo2yuHKllWbrYYFRoq/j3LVkYscEqU1ybi6oF9mjEBvNxBR5LcLkU
         llixTaA1Srx9QLGtVEZNbDTBHYtkMp6G2CmftJyw=
Date:   Thu, 15 Oct 2020 11:17:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        stable@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 5.8+ regression fix 0/1] i2c: core: Restore
 acpi_walk_dep_device_list() getting called after registering the ACPI i2c
 devs
Message-ID: <20201015151757.GS2415204@sasha-vm>
References: <20201014144158.18036-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201014144158.18036-1-hdegoede@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 14, 2020 at 04:41:57PM +0200, Hans de Goede wrote:
>Wolfram, can we get this queued up to go to Linus
>soonish ?
>
>Greg, in essence this is a partial revert of the trouble
>some commit. With the 2 combined acpi_walk_dep_device_list()
>is called last again, while still doing the
>acpi_install_address_space_handler() call earlier.
>
>Since this is a somewhat nasty regression and since the poor
>timing wrt the merge-window, I was hoping that you would be
>willing to make an exception and pick up this fix before
>it hits Linus' tree?

I don't think the merge window plays any role here: this fix can go into
Linus's tree immediately and once it's there we can pick it up for
-stable right away.

-- 
Thanks,
Sasha
