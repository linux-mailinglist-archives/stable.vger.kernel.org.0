Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CB11F3A5F
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 14:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgFIMGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 08:06:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:32808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728005AbgFIMGR (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 9 Jun 2020 08:06:17 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82F38206A4;
        Tue,  9 Jun 2020 12:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591704376;
        bh=ankWepK0yGzyXMpKCb4jxIHWsCzXkcbMaLXNyQXub/4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mTZ3FhT0H4TaacjNdC+2V8JqWlsypjBDjFmCehRxyW2Il+8VzIrvnnFybcgMlKO51
         unuXdFPRXSBdCBCDeVrXdV9ir69YPQHtojcN6ebnBu1J5+ozvh8KvbgjZSs3sDNTRx
         8dQzS7KAWfOGRL2QymJckU38gR7U3zYU0iBj+iP0=
Date:   Tue, 9 Jun 2020 08:06:15 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     m.othacehe@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: vcnl4000: Fix i2c swapped word
 reading." failed to apply to 4.14-stable tree
Message-ID: <20200609120615.GV1407771@sasha-vm>
References: <1591619056246224@kroah.com>
 <20200608204114.GS1407771@sasha-vm>
 <20200609061057.GA498890@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200609061057.GA498890@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 08:10:57AM +0200, Greg KH wrote:
>On Mon, Jun 08, 2020 at 04:41:14PM -0400, Sasha Levin wrote:
>> On Mon, Jun 08, 2020 at 02:24:16PM +0200, gregkh@linuxfoundation.org wrote:
>> >
>> > The patch below does not apply to the 4.14-stable tree.
>> > If someone wants it applied there, or to any other stable or longterm
>> > tree, then please email the backport, including the original git commit
>> > id to <stable@vger.kernel.org>.
>> >
>> > thanks,
>> >
>> > greg k-h
>> >
>> > ------------------ original commit in Linus's tree ------------------
>> >
>> > > From 18dfb5326370991c81a6d1ed6d1aeee055cb8c05 Mon Sep 17 00:00:00 2001
>> > From: Mathieu Othacehe <m.othacehe@gmail.com>
>> > Date: Sun, 3 May 2020 11:29:55 +0200
>> > Subject: [PATCH] iio: vcnl4000: Fix i2c swapped word reading.
>> >
>> > The bytes returned by the i2c reading need to be swapped
>> > unconditionally. Otherwise, on be16 platforms, an incorrect value will be
>> > returned.
>> >
>> > Taking the slow path via next merge window as its been around a while
>> > and we have a patch set dependent on this which would be held up.
>> >
>> > Fixes: 62a1efb9f868 ("iio: add vcnl4000 combined ALS and proximity sensor")
>> > Signed-off-by: Mathieu Othacehe <m.othacehe@gmail.com>
>> > Cc: <Stable@vger.kernel.org>
>> > Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>>
>> There were some context conflicts due to renaming of the lock (and it
>> not existing on 4.4). I've fixed it and queued for 4.14-4.4.
>
>Thanks, but I think you forgot to push your local version of the queue
>to git.kernel.org :(

Oops, now pushed.

-- 
Thanks,
Sasha
