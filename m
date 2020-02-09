Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB7DA156B48
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 16:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgBIP7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 10:59:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:56008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727320AbgBIP7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 10:59:52 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA19320715;
        Sun,  9 Feb 2020 15:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581263992;
        bh=cQBfy4GCjY8E5o8iakmgJQQkXfQE+XOW0EJTfoE3lh8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qdc9XtB0MAQ56Y4qzlwHXn4jzJ+o31320PL5fM/fmZmLyv08j/l4zQtqQ/U9rMgNx
         G8lVA+QhP6/UrIdyXqXgq7CcRUymDckwjvlZWX4qXby2YMWjSI4E9mirFg/cMyh/7a
         h7wL7TwpHLO9+6iGMSu69oGjGVH4IjPFsl0Wwel4=
Date:   Sun, 9 Feb 2020 10:59:50 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jslaby@suse.cz>, josef@toxicpanda.com,
        dsterba@suse.com, martin@lichtvoll.de, wqu@suse.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: do not zero f_bavail if we have
 available space" failed to apply to 5.5-stable tree
Message-ID: <20200209155950.GD3584@sasha-vm>
References: <158124801131151@kroah.com>
 <45d4c547-7e27-3c59-e2f7-19f4e7b3548c@suse.cz>
 <20200209132640.GA2059551@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200209132640.GA2059551@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 02:26:40PM +0100, Greg KH wrote:
>On Sun, Feb 09, 2020 at 02:04:21PM +0100, Jiri Slaby wrote:
>> On 09. 02. 20, 12:33, gregkh@linuxfoundation.org wrote:
>> >
>> > The patch below does not apply to the 5.5-stable tree.
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
>> > From d55966c4279bfc6a0cf0b32bf13f5df228a1eeb6 Mon Sep 17 00:00:00 2001
>> > From: Josef Bacik <josef@toxicpanda.com>
>> > Date: Fri, 31 Jan 2020 09:31:05 -0500
>> > Subject: [PATCH] btrfs: do not zero f_bavail if we have available space
>>
>> 5.5.2 was already released with this patch:
>> commit 165387a9c90152f35976d82feca6eff5f0d5ac02
>> Author: Josef Bacik <josef@toxicpanda.com>
>> Date:   Fri Jan 31 09:31:05 2020 -0500
>>
>>     btrfs: do not zero f_bavail if we have available space
>>
>>     commit d55966c4279bfc6a0cf0b32bf13f5df228a1eeb6 upstream.
>>
>> It cannot be applied twice :).
>
>Oops, Sasha beat me too it, sorry for the noise :)

I've grabbed it for the fixes: tag, sorry :)

-- 
Thanks,
Sasha
