Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F402F78040
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 17:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfG1Piq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 11:38:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbfG1Pip (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Jul 2019 11:38:45 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2D022075E;
        Sun, 28 Jul 2019 15:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564328325;
        bh=2O8OS/mVeg0GkWhVKPx2kspWI8Wf5ayhG+FJwWamPos=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KPFxmdKq/aklh/bQD5Y0muvUgMwaI5iVrTVwscrhmrMJ+zjqVPUCL3aBQGABCNrPq
         30+BhEBXK1aL7FexsCzazWsvnXbV3ViNYIF3WW2PzWM7XiTwpB68Z2avoOfyZyENgR
         dk7gpoRGh2pQnQ8wIhrHV93gxqAo7G2DtYffvhQU=
Date:   Sun, 28 Jul 2019 11:38:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jonathan Cameron <jic23@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Young Xiao <92siuyang@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 19/60] iio:core: Fix bug in length of event
 info_mask and catch unhandled bits set in masks.
Message-ID: <20190728153843.GH8637@sasha-vm>
References: <20190719041109.18262-1-sashal@kernel.org>
 <20190719041109.18262-19-sashal@kernel.org>
 <20190721182643.3fd0515b@archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190721182643.3fd0515b@archlinux>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 21, 2019 at 06:27:02PM +0100, Jonathan Cameron wrote:
>On Fri, 19 Jul 2019 00:10:28 -0400
>Sasha Levin <sashal@kernel.org> wrote:
>
>> From: Young Xiao <92siuyang@gmail.com>
>>
>> [ Upstream commit 936d3e536dcf88ce80d27bdb637009b13dba6d8c ]
>>
>> The incorrect limit for the for_each_set_bit loop was noticed whilst fixing
>> this other case.  Note that as we only have 3 possible entries a the moment
>> and the value was set to 4, the bug would not have any effect currently.
>> It will bite fairly soon though, so best fix it now.
>>
>> See commit ef4b4856593f ("iio:core: Fix bug in length of event info_mask and
>> catch unhandled bits set in masks.") for details.
>>
>> Signed-off-by: Young Xiao <92siuyang@gmail.com>
>> Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
>> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>As the patch states, this bug doesn't have any impact.  It would only
>be triggered by a buggy driver setting a bit in that mask that makes no
>sense.
>
>So it's good to fix in upstream, but debatable if it's worth porting back
>to stable.
>
>I don't have a strong opinion on this one and again, it should do no
>harm.

I'll drop it then, thanks!

--
Thanks,
Sasha
