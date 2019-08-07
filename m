Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18FE08428A
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 04:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfHGCiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 22:38:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726331AbfHGCiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 22:38:11 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B72A521743;
        Wed,  7 Aug 2019 02:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565145490;
        bh=W5nsUZDTO0AqSSaVtlsS+i6EdJob7D409bMHK7rbsMw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XOQM/dkmUt+UV3+/cGe+O7uNKBjdx/sc9Ox51IjW6WH0X8JU9QaGum/sN9BZ3b5jG
         LCSv89jjjheB9JKxCQF8VQj56HNDg/iqpf/AJOcpCPO3sVmRVOmwnFS4pOO+PElxKf
         NPKopJqW3oBLrgBwPgrmbnigvmFwrl/M1N8oNphY=
Date:   Tue, 6 Aug 2019 22:38:08 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+d952e5e28f5fb7718d23@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 5.2 03/20] ALSA: usb-audio: Sanity checks for each pipe
 and EP types
Message-ID: <20190807023808.GS17747@sasha-vm>
References: <20190802092055.131876977@linuxfoundation.org>
 <20190802092058.248343532@linuxfoundation.org>
 <20190802134828.GA797@sasha-vm>
 <20190802155154.GA28398@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190802155154.GA28398@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 02, 2019 at 05:51:54PM +0200, Greg Kroah-Hartman wrote:
>On Fri, Aug 02, 2019 at 09:48:28AM -0400, Sasha Levin wrote:
>> On Fri, Aug 02, 2019 at 11:39:57AM +0200, Greg Kroah-Hartman wrote:
>> > From: Takashi Iwai <tiwai@suse.de>
>> >
>> > commit 801ebf1043ae7b182588554cc9b9ad3c14bc2ab5 upstream.
>> >
>> > The recent USB core code performs sanity checks for the given pipe and
>> > EP types, and it can be hit by manipulated USB descriptors by syzbot.
>> > For making syzbot happier, this patch introduces a local helper for a
>> > sanity check in the driver side and calls it at each place before the
>> > message handling, so that we can avoid the WARNING splats.
>> >
>> > Reported-by: syzbot+d952e5e28f5fb7718d23@syzkaller.appspotmail.com
>> > Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> This commit has a fix: 5d78e1c2b7f4b ("ALSA: usb-audio: Fix gpf in
>> snd_usb_pipe_sanity_check") which was not pulled by Linus yet.
>>
>> I'm going to drop this commit and re-queue it together with it's fix
>> once it makes it upstream.
>
>Ah, thanks for doing that.

Now queued these two commits for 5.2.

--
Thanks,
Sasha
