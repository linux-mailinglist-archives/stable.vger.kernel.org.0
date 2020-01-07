Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8D3F132EE4
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 19:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgAGS76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 13:59:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:60802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728358AbgAGS76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 13:59:58 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F3BA2081E;
        Tue,  7 Jan 2020 18:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578423597;
        bh=qz9yzgWaIKof6g/UrqBjqPfTL0HCjuKAAaXP3Ln0mbo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L6iw7LPYfD1X6EM4W+XthCjid8EJPPxyfMie6Hl0fcwj5joSqE2di6+5sfJoi0Kmz
         f7VIGiWla+TGUutpgsrIU05RqzwTIxOUHRA0IIfE+nZrwVJ7pVdkRXpoc3YW5MLfG2
         N0loh+LqveqK788cYZSCeo8/R3VQs3H38YpN9c2o=
Date:   Tue, 7 Jan 2020 13:59:56 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Takashi Iwai <tiwai@suse.de>, kailang@realtek.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ALSA: hda/realtek - Add Bass Speaker and
 fixed dac for bass" failed to apply to 5.4-stable tree
Message-ID: <20200107185956.GC1706@sasha-vm>
References: <1578312630193177@kroah.com>
 <s5hd0bwgwb8.wl-tiwai@suse.de>
 <20200107093912.GA1031189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200107093912.GA1031189@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 07, 2020 at 10:39:12AM +0100, Greg KH wrote:
>On Mon, Jan 06, 2020 at 09:32:43PM +0100, Takashi Iwai wrote:
>> On Mon, 06 Jan 2020 13:10:30 +0100,
>> <gregkh@linuxfoundation.org> wrote:
>> >
>> >
>> > The patch below does not apply to the 5.4-stable tree.
>> > If someone wants it applied there, or to any other stable or longterm
>> > tree, then please email the backport, including the original git commit
>> > id to <stable@vger.kernel.org>.
>>
>> Hm, I could cherry-pick the commit e79c22695abd (also commit
>> 48e01504cf53 at next) cleanly on linux-5.4.y branch.
>>
>> Could you try again?
>
>Ugh, my fault, seems Sasha already queued these patches up in the stable
>tree and I didn't notice them.  When I tried to apply them they
>rightfully complained :(
>
>sorry for the noise, all is good here.

Appologies for stepping on your toes here, I picked it up so that I
could also take 48e01504cf53 ("ALSA: hda/realtek - Enable the bass
speaker of ASUS UX431FLC") which fixes a different patch we took in the
5.4 tree.

-- 
Thanks,
Sasha
