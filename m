Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1521E04CB
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 04:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388448AbgEYCnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 May 2020 22:43:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388422AbgEYCnR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 May 2020 22:43:17 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44DFF2073B;
        Mon, 25 May 2020 02:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590374597;
        bh=VclR7GFxTC/UtgQvzYGLGo7CewYsZfIIsrSHIKF3uuo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z8xG84yZ1aqk0pAhrP/4aLsBgfwq+myQ4uAGVVT3vx9PFDgLzQxjPuATTU1ybW7ma
         ECFA73N65RfoAaOCSntojhQ3u/L7jrVMQKvdMpW9eVU5j6htehUcs8HLWri7c+33Fj
         4ftxJzawhwWbEGdrBvzDnXHA3QYurMe2QZrOfre8=
Date:   Sun, 24 May 2020 22:43:16 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@google.com>
Cc:     stable-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Patch "ppp: mppe: Revert "ppp: mppe: Add softdep to arc4"" has
 been added to the 4.4-stable tree
Message-ID: <20200525024316.GY33628@sasha-vm>
References: <20200524135255.8821820776@mail.kernel.org>
 <20200524171105.GA56504@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200524171105.GA56504@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 24, 2020 at 10:11:05AM -0700, Eric Biggers wrote:
>On Sun, May 24, 2020 at 09:52:54AM -0400, Sasha Levin wrote:
>> This is a note to let you know that I've just added the patch titled
>>
>>     ppp: mppe: Revert "ppp: mppe: Add softdep to arc4"
>>
>> to the 4.4-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>      ppp-mppe-revert-ppp-mppe-add-softdep-to-arc4.patch
>> and it can be found in the queue-4.4 subdirectory.
>
>I already explained last time that this shouldn't be backported:
>https://lore.kernel.org/stable/20190905161642.GA5659@google.com/
>
>The commit message explains it too.
>
>Is there something I could have done last time around to properly prevent this
>from being backported, or do I have to continue to be ready to respond to these
>emails which can come at arbitrary times forever?

Appologies, I had to revert back to (older) backups for some of my data
and sadly forgot it can cause this type of issues. I'll drop the patch.

>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>
>Hard for "anyone else" to object to it when you didn't Cc any real mailing lists
>(stable-commits doesn't count) and just sent this to me.  Lucky I saw this.

This is just the "added to the queue" mail, you would see another mail
when this release goes to -rc1. No reason for too much spam...

-- 
Thanks,
Sasha
