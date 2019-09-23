Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACF17BB56C
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 15:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408043AbfIWNfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 09:35:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404581AbfIWNfC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Sep 2019 09:35:02 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45C0920820;
        Mon, 23 Sep 2019 13:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569245701;
        bh=hXQkKliC0S2X43voVjhiTVkMxCC4tIPV9acNAETqUso=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FeeJhFEYpa8NQNgnmMZ03oC875vWZGIk2sDIDJW6viNc1wFklKbOaxWAIJZiDv3z9
         VPL+5mYyMBGkryM57asvTYICU4x115rVu0DFVAjBJvQeXxR61BtdSSXkhiv2dR+/em
         4ofSqLwfC02dVakvOgrS63rQNTOJczJ7yNnUIGkc=
Date:   Mon, 23 Sep 2019 09:35:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Sakari Ailus <sakari.ailus@iki.fi>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.3 084/203] media: omap3isp: Don't set streaming
 state on random subdevs
Message-ID: <20190923133500.GF8171@sasha-vm>
References: <20190922184350.30563-1-sashal@kernel.org>
 <20190922184350.30563-84-sashal@kernel.org>
 <20190923071942.GJ5525@valkosipuli.retiisi.org.uk>
 <20190923072503.GA5056@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190923072503.GA5056@pendragon.ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 23, 2019 at 10:25:03AM +0300, Laurent Pinchart wrote:
>On Mon, Sep 23, 2019 at 10:19:42AM +0300, Sakari Ailus wrote:
>> Hi Sasha,
>>
>> On Sun, Sep 22, 2019 at 02:41:50PM -0400, Sasha Levin wrote:
>> > From: Sakari Ailus <sakari.ailus@linux.intel.com>
>> >
>> > [ Upstream commit 7ef57be07ac146e70535747797ef4aee0f06e9f9 ]
>> >
>> > The streaming state should be set to the first upstream sub-device only,
>> > not everywhere, for a sub-device driver itself knows how to best control
>> > the streaming state of its own upstream sub-devices.
>> >
>> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
>> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>> I don't disagree with this going to the stable trees as well, but in that
>> case it *must* be accompanied by commit e9eb103f0277 ("media: omap3isp: Set
>> device on omap3isp subdevs") or the driver will mostly cease to work.
>>
>> Could you pick that up as well?
>
>While I don't disagree either, I also think there's no requirement to
>get this commit backported to stable branches. It seems to be the result
>of a too aggressive auto-selection.

I'd very much agree that AUTOSEL is trying to be aggressive with it's
patch selection (it's actually sort of like a "dial" I can adjust and
now it's adjusted pretty high).

However, please don't see it as something that is forced on you; if the
maintainers disagree with patch selection please just let me know and it
will dropped. The only reason I'm being aggressive with AUTOSEL is that
I'm hopefull it will provide better experience for our users.

--
Thanks,
Sasha
