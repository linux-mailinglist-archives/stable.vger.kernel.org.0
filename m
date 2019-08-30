Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0E27A36AA
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 14:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfH3MUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Aug 2019 08:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727417AbfH3MUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Aug 2019 08:20:40 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B20E422CE9;
        Fri, 30 Aug 2019 12:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567167639;
        bh=chwrNReYbzAQ75VXfpSzUlQkVX9x3CekuKCIWXzvKAA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=expnwnreTiqTVqIUVWpiDi4V2/zlCBsxklt1aWgEOVz37njXebBQTZ4hY+rrtiBIj
         d7L1gnPHSjXYAIqv/8ossuGD/KcG2mVnoILDHOC9y4zR7w/bQZKkspgZuXSEbCK9tm
         Us3dPHgEqC3EGmUF6qgjUOQZcH07zyiXQLva/TBM=
Date:   Fri, 30 Aug 2019 08:20:37 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Oleksandr Natalenko <oleksandr@redhat.com>
Cc:     stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Backport 2a92b08b1855 ("mt76: usb: fix rx A-MSDU support")
Message-ID: <20190830122037.GX5281@sasha-vm>
References: <20190815090359.eevqqk3vt4dcrw3k@butterfly.localdomain>
 <20190830065953.nsye4cq2eisyqcko@butterfly.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190830065953.nsye4cq2eisyqcko@butterfly.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 30, 2019 at 08:59:53AM +0200, Oleksandr Natalenko wrote:
>On Thu, Aug 15, 2019 at 11:03:59AM +0200, Oleksandr Natalenko wrote:
>> I'd like to get 2a92b08b1855 squeezed into a stable tree since it fixes
>> the following splat in the kernel log when using an MTK-based Wi-Fi
>> access point:
>>
>> [135577.311588] usb 1-3: rx data too big 2044
>> [135577.311689] usb 1-3: rx data too big 2044
>> [135578.166351] usb 1-3: rx data too big 2044
>>
>> See also: https://bugzilla.kernel.org/show_bug.cgi?id=203789
>>
>> The patch applies to the v5.2.x series without conficts.
>>
>> Lorenzo, are you fine with this?
>
>Gentle ping.

I've queued it up for 5.2, thank you.

--
Thanks,
Sasha
