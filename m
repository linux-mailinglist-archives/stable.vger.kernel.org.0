Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E44F215CFC
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 19:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbgGFRXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 13:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729589AbgGFRXI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jul 2020 13:23:08 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73CDC2070C;
        Mon,  6 Jul 2020 17:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594056187;
        bh=WzuSRRW6Dd1J+/4CpL3y7fqjck6dSncSdSfhtXlFnpc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jZWvzzzgdhMYyXbBwPLA8s+ur9A/opQliO9kiOjoB2Iy5XCOoyyESatFw+Ew+mBUK
         9B9+QPvXhtXoay9iPeQD9m8pZMp2H0/ELmaQ3NgqbLraKFZX7RD2w5xbZB/aA/+0ff
         ZSWEeUnK7OPJ87FM/JvDll37/Fb7e++lQ2jt9+V4=
Date:   Mon, 6 Jul 2020 13:23:06 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: Patch "io_uring: use signal based task_work running" has been
 added to the 5.7-stable tree
Message-ID: <20200706172306.GL2722994@sasha-vm>
References: <20200705134847.6A6AF20747@mail.kernel.org>
 <3aa74884-9e39-b018-05b0-ab2575c0681a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3aa74884-9e39-b018-05b0-ab2575c0681a@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 05, 2020 at 02:57:11PM -0600, Jens Axboe wrote:
>On 7/5/20 7:48 AM, Sasha Levin wrote:
>> This is a note to let you know that I've just added the patch titled
>>
>>     io_uring: use signal based task_work running
>>
>> to the 5.7-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>      io_uring-use-signal-based-task_work-running.patch
>> and it can be found in the queue-5.7 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>
>Thanks for queueing this up, can you also add the fix for it? It's in
>Linus's tree:
>
>commit b7db41c9e03b5189bc94993bd50e4506ac9e34c1 (tag: io_uring-5.8-2020-07-05, origin/io_uring-5.8, io_uring-5.8)
>Author: Jens Axboe <axboe@kernel.dk>
>Date:   Sat Jul 4 08:55:50 2020 -0600
>
>    io_uring: fix regression with always ignoring signals in io_cqring_wait()
>
>Thanks!

Its been queued up too, thank you.

-- 
Thanks,
Sasha
