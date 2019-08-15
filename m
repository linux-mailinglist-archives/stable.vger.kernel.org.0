Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D98F8E27E
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 03:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfHOBqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 21:46:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726865AbfHOBqn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 21:46:43 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F278206C1;
        Thu, 15 Aug 2019 01:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565833602;
        bh=zJyFOGA5S0akg6Ny72PmmFfOH+O1MxtC4ZuGnnNgBXM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FjNSvrJUDj6LPtFeOa/cUm0Z4C+Hj9wHy4T+9W8czfe36Eguuu1mhV/7s6cLRgEU4
         Orhzx6spmarQ52LefmT8mQBrNR57mw96tswsh997ThzmtiVRDSsA6Hqz0/PIJOjUl4
         TWZqNaIx32Ag2xoyQIkpiz//Q7/xbQuDBXMH9Yc4=
Date:   Wed, 14 Aug 2019 21:46:41 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org,
        Gustavo Padovan <gustavo@padovan.org>,
        intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Sean Paul <seanpaul@chromium.org>
Subject: Re: [PATCH] dma-buf/sw_sync: Synchronize signal vs syncpt free
Message-ID: <20190815014641.GB31807@sasha-vm>
References: <20190812154247.20508-1-chris@chris-wilson.co.uk>
 <20190812190548.450CF20684@mail.kernel.org>
 <20190814172415.GN7444@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190814172415.GN7444@phenom.ffwll.local>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 14, 2019 at 07:24:15PM +0200, Daniel Vetter wrote:
>Hi Sasha,
>
>On Mon, Aug 12, 2019 at 07:05:47PM +0000, Sasha Levin wrote:
>> Hi,
>>
>> [This is an automated email]
>>
>> This commit has been processed because it contains a "Fixes:" tag,
>> fixing commit: d3862e44daa7 dma-buf/sw-sync: Fix locking around sync_timeline lists.
>>
>> The bot has tested the following trees: v5.2.8, v4.19.66, v4.14.138, v4.9.189.
>>
>> v5.2.8: Build OK!
>> v4.19.66: Build OK!
>> v4.14.138: Build OK!
>> v4.9.189: Failed to apply! Possible dependencies:
>>     Unable to calculate
>>
>>
>> NOTE: The patch will not be queued to stable trees until it is upstream.
>>
>> How should we proceed with this patch?
>
>The backporting instruction has an explicit # v4.14+ in there, so failure
>to apply to older kernels is expected.
>
>Can you perhaps teach this trick to your script perhaps? Iirc we're using
>the official format even.

Hey Daniel,

The script knows how to read stable tags :)

It tested out 4.9 because the commit also has a fixes tag pointing to
d3862e44daa7 ("dma-buf/sw-sync: Fix locking around sync_timeline
lists."), which was backported to 4.9.

Should this not be backported to 4.9, even though the commit it fixes is
there?

--
Thanks,
Sasha
