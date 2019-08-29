Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0161A286F
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 22:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfH2UwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 16:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbfH2UwL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 16:52:11 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD3A423403;
        Thu, 29 Aug 2019 20:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567111931;
        bh=sjMx+nTBCxsyH5xXtuyd5h39rKjstIxPvOykcRzy4Ts=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=omttYrtPCJZQBmsJMn9t27qVGaX5LtDYdvJY1QqQ5A5LMlWlSZeeo9pzNB+Gct86w
         g56vkjHMqhFK5AX3OB+2XLU8PTNFeNnohM6nBXa2Gof4enoa9Q6fF23YGpMk6GQKr9
         i3tDkmS8p3IU4wxDTErMkxIeXJUvP/twVuWqIx6k=
Date:   Thu, 29 Aug 2019 16:52:09 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Sean Paul <sean@poorly.run>
Cc:     Lyude Paul <lyude@redhat.com>, dri-devel@lists.freedesktop.org,
        Sean Paul <seanpaul@chromium.org>,
        Todd Previte <tprevite@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org
Subject: Re: [PATCH] drm: mst: Fix query_payload ack reply struct
Message-ID: <20190829205209.GL5281@sasha-vm>
References: <20190829165223.129662-1-sean@poorly.run>
 <9927a099fc5f0140ea92e34f017186d9ffe0bb13.camel@redhat.com>
 <20190829184415.GI218215@art_vandelay>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190829184415.GI218215@art_vandelay>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 02:44:15PM -0400, Sean Paul wrote:
>On Thu, Aug 29, 2019 at 01:06:58PM -0400, Lyude Paul wrote:
>> Is it worth actually CCing stable on this? This patch is certainly correct but
>> I don't think we use this struct for anything quite yet.
>>
>> Otherwise: Reviewed-by: Lyude Paul <lyude@redhat.com>
>
>Thanks for the review! I've stripped the cc stable tag and pushed to
>drm-misc-next. We'll have to keep an eye out for Sasha's stable AI bot, I'm
>guessing it'll try to backport this to stable regardless.

Knowing the bot, it probably will :)

I'll add a note for myself...

--
Thanks,
Sasha
