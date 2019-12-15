Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEA4411F9C2
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 18:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbfLORjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 12:39:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbfLORjB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 12:39:01 -0500
Received: from localhost (unknown [73.61.17.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13FA9206E0;
        Sun, 15 Dec 2019 17:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576431541;
        bh=GZougF8gjV303Hiyw8RH1wi0AhcxvSfpPPkUQMPCdS0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YiQGg1uhtuIll/ieMu5qREbQodtiV/Rg/bS+V0HgLM0o9bw1Nvg1+Vbzv9A6IFYU2
         LX9tMMi6ExXJlHHRPZDVHoRVZ+wKH53nYh49eCyvXvhK4FKh5OqM4180LooVHzwLCM
         Zo/ePfuRvWU5bnm+UKKhB/GfWc9+elmspTMiiMGU=
Date:   Sun, 15 Dec 2019 12:39:00 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     henryl@nvidia.com, mathias.nyman@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] usb: xhci: only set D3hot for pci device"
 failed to apply to 4.9-stable tree
Message-ID: <20191215173859.GF18043@sasha-vm>
References: <157640185110204@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157640185110204@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 10:24:11AM +0100, gregkh@linuxfoundation.org wrote:
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
>From f2c710f7dca8457e88b4ac9de2060f011254f9dd Mon Sep 17 00:00:00 2001
>From: Henry Lin <henryl@nvidia.com>
>Date: Wed, 11 Dec 2019 16:20:04 +0200
>Subject: [PATCH] usb: xhci: only set D3hot for pci device
>
>Xhci driver cannot call pci_set_power_state() on non-pci xhci host
>controllers. For example, NVIDIA Tegra XHCI host controller which acts
>as platform device with XHCI_SPURIOUS_WAKEUP quirk set in some platform
>hits this issue during shutdown.
>
>Cc: <stable@vger.kernel.org>
>Fixes: 638298dc66ea ("xhci: Fix spurious wakeups after S5 on Haswell")
>Signed-off-by: Henry Lin <henryl@nvidia.com>
>Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>Link: https://lore.kernel.org/r/20191211142007.8847-4-mathias.nyman@linux.intel.com
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Fixed up and queued for 4.9 and 4.4.

-- 
Thanks,
Sasha
