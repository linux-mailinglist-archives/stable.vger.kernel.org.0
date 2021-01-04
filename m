Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6C82E971D
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 15:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbhADOVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 09:21:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726685AbhADOVn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 09:21:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6BB6207BC;
        Mon,  4 Jan 2021 14:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609770063;
        bh=tsMKIDjmoUzgR1bptC6pCG0Pztx8eeE2sjessSaPVko=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i2kYhPizQZ3698zJNG/hbLbkozhzCS/YY6n6vw4yullXW5ffnXe3l0KrixuRJ77LE
         AgldrW2/itJ0mBFerCr2hJ7+A7GzLUSoP9NvD1VT5L1eNO95qiowgpTtEAy7dB117q
         lbHjEZ7wqpgJkQd2E5AJamcwlUkRhourFo4YLNYc+jAVMusRNHlAR6xvs7OWRiGJ6A
         06P090F67sSpI5oSF+F1oPzzDWIImhRDTPxHzhLcokSoPOeY5vNzPniYs7mVIzXH9v
         kF/JyD6xrtIpIIUIV5O6Qs/3Lg+m69KShysSSdh1/hq+m2VpOwdSg6UsPJV/ikbCtB
         u5fnXDAGbW4QQ==
Date:   Mon, 4 Jan 2021 09:21:00 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        linux-um@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.10 20/31] um: allocate a guard page to helper
 threads
Message-ID: <20210104142100.GB3665355@sasha-vm>
References: <20201230130314.3636961-1-sashal@kernel.org>
 <20201230130314.3636961-20-sashal@kernel.org>
 <d17899cc72a31f12da166de6223338b844ee2428.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d17899cc72a31f12da166de6223338b844ee2428.camel@sipsolutions.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 30, 2020 at 03:48:57PM +0100, Johannes Berg wrote:
>On Wed, 2020-12-30 at 08:03 -0500, Sasha Levin wrote:
>>
>> We've been running into stack overflows in helper threads
>> corrupting memory
>
>For the record, that was mostly referring to "while development", so
>while this change makes a few things a bit safer, I don't think there's
>all that much point in backporting to stable; presumably things are
>working OK there for people, and developers will (hopefully) be working
>on mainline anyway.

I'll drop it, thanks!

-- 
Thanks,
Sasha
