Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6DB71C909
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 14:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbfENMx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 08:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbfENMx4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 08:53:56 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C697D208CA;
        Tue, 14 May 2019 12:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557838436;
        bh=GonVriv2oL4uJVUjQB69hiwYL/6/yunoUldat7RWCBo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KtIAPPGtrYDCaZG1Mh81b4iZzCHkdDRpB45BzJ4OOSjC6Cnuk59et70DJl4CmZs5Y
         UjEpZDamwCG5rUonCRKDpAQ76jBrmIzrSzOLn4LsGRqCc+lArwgAwXSSW7A18up3DD
         xFUW0AWtHwOP4lpTVVnwtWs2sZrqNbw8UW2xDj6k=
Date:   Tue, 14 May 2019 08:53:53 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] USB: serial: fix unthrottle races
Message-ID: <20190514125353.GL11972@sasha-vm>
References: <20190425160540.10036-1-johan@kernel.org>
 <20190425160540.10036-2-johan@kernel.org>
 <20190513104339.GA9651@localhost>
 <20190513105606.GA21346@kroah.com>
 <20190513114601.GB9651@localhost>
 <20190513125131.GA7541@kroah.com>
 <20190513125909.GC9651@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190513125909.GC9651@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 02:59:09PM +0200, Johan Hovold wrote:
>On Mon, May 13, 2019 at 02:51:31PM +0200, Greg Kroah-Hartman wrote:
>> On Mon, May 13, 2019 at 01:46:01PM +0200, Johan Hovold wrote:
>
>> > Thanks. The issue has been there since v3.3 so I guess you could queue
>> > it for all stable trees.
>>
>> Doesn't apply cleanly for 4.4.y or 3.18.y, so if it's really worth
>> adding there (and I kind of doubt it), I would need a backport :)
>
>Ah ok, just wasn't sure why you chose 4.9+.

On 4.4 and 3.18 it just had a contextual conflict because of
3161da970d38c ("USB: serial: use variable for status"), I can queue both
3161da970d38c and 3f5edd58d040b for 4.4 and 3.18.

--
Thanks,
Sasha
