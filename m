Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265A02D2C21
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 14:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgLHNkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 08:40:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgLHNkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 08:40:12 -0500
Date:   Tue, 8 Dec 2020 08:39:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607434772;
        bh=Ruw+zqRP3jvpNkm40Z1BRZz8o3zyUj1HnSvYRp5ZjeQ=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=DVp2js//ayF60Q9K3e0tpQJlywbtk/ZV5TOQiyPr+L5vGaQC41z1cKDNOMv5QR4QE
         9xiHRJ0QinHotEKeVlzMUwglae39U3MdhWBhRtgFqFpMZlTLGq2ApWhVi6lxNotYWI
         WPu/EGXKx2jUybAG6isv106j8ajW4hWOPoraABGfGNN2QLfVU3jLs+56FPY2vbcBuB
         qVhXvd99IssBlQg0onTLhQ/vR5c6Ly1Ly56gjip7Y3YVxU+beCFwgl+6PB8w74yBzb
         9Q11N/dk5BgevJv3r4zZji58Zf3vc1BLkHwHrmv7q5sPgFbSpEps7kD/JnC/yyQUHA
         4vxO6s0y24rrA==
From:   Sasha Levin <sashal@kernel.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     gregkh@linuxfoundation.org, hdegoede@redhat.com,
        andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] pinctrl: baytrail: Fix pin being driven
 low for a while on" failed to apply to 4.9-stable tree
Message-ID: <20201208133931.GI643756@sasha-vm>
References: <159783767814665@kroah.com>
 <20201207142211.anmpfxfx4lzc5b54@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201207142211.anmpfxfx4lzc5b54@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 07, 2020 at 02:22:11PM +0000, Sudip Mukherjee wrote:
>Hi Greg,
>
>On Wed, Aug 19, 2020 at 01:47:58PM +0200, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 4.9-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>
>Here is the backport and also e2b74419e5cc ("pinctrl: baytrail: Replace
>WARN with dev_info_once when setting direct-irq pin to output") which is
>needed for the backport. This will apply from 4.9-stable to 5.4-stable.

Queued up, thanks!

-- 
Thanks,
Sasha
