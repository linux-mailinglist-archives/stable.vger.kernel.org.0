Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9FE2053F4
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 15:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732821AbgFWNyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 09:54:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732833AbgFWNxo (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 23 Jun 2020 09:53:44 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D564020724;
        Tue, 23 Jun 2020 13:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592920424;
        bh=bUclb6Oe7snTcTLzYvMMxs78tXwbtfS+deEJB66mUt4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IEoAh811/sIj9QRJqkEm5/75G1qgGxF9diMuHZqKtqMEIR2yKwfLmTd+STYvxh5CW
         WpxXjeLKSSk/FgQulc8EvPB4uE69nCXDERpJasMkmBCI0WFo73MWZjzNfdf/7Z/1pf
         42gSTaGoGG+IPWYRrCpN8lYn0HlEUdodQ9EO1wVM=
Date:   Tue, 23 Jun 2020 09:53:42 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     yu.c.chen@intel.com, Stable@vger.kernel.org,
        aaron.f.brown@intel.com, andriy.shevchenko@linux.intel.com,
        jeffrey.t.kirsher@intel.com, rafael.j.wysocki@intel.com
Subject: Re: FAILED: patch "[PATCH] e1000e: Do not wake up the system via WOL
 if device wakeup is" failed to apply to 4.9-stable tree
Message-ID: <20200623135342.GZ1931@sasha-vm>
References: <15929135091516@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15929135091516@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 01:58:29PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.9-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 6bf6be1127f7e6d4bf39f84d56854e944d045d74 Mon Sep 17 00:00:00 2001
>From: Chen Yu <yu.c.chen@intel.com>
>Date: Fri, 22 May 2020 01:59:00 +0800
>Subject: [PATCH] e1000e: Do not wake up the system via WOL if device wakeup is
> disabled
>
>Currently the system will be woken up via WOL(Wake On LAN) even if the
>device wakeup ability has been disabled via sysfs:
> cat /sys/devices/pci0000:00/0000:00:1f.6/power/wakeup
> disabled
>
>The system should not be woken up if the user has explicitly
>disabled the wake up ability for this device.
>
>This patch clears the WOL ability of this network device if the
>user has disabled the wake up ability in sysfs.
>
>Fixes: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver")
>Reported-by: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>Cc: <Stable@vger.kernel.org>
>Signed-off-by: Chen Yu <yu.c.chen@intel.com>
>Tested-by: Aaron Brown <aaron.f.brown@intel.com>
>Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Conflict was because we don't have c8744f44aeae ("e1000e: Add Support
for CannonLake") on 4.9 and 4.4. I've worked around that and queued this
patch for both of those branches.

-- 
Thanks,
Sasha
