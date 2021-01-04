Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059862E9C49
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 18:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbhADRnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 12:43:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbhADRnt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 12:43:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C519D2068D;
        Mon,  4 Jan 2021 17:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609782189;
        bh=Tgv3wz9rAa77pSHih7ePWFj/dppL74JdZ4ehDTq8Q0w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OqTSxs9hzeQBvsrZyXywlYMRWkSnJhvI2C0nmPxXGmOXyAzJsFd1NN3+8uNk+6GQa
         K9GUOLDwoGfDMosu0ekMnxtvRdk5AqqeUTUuyu4okIDxNwunZAAQiREpvVJYerkxSl
         zyP1w9TMC1cWrE9dgitamrSPbSv5NT/jx8AuqdCMGeU1QFWajU+IV8tlpdWdbbZTJi
         UtDhaKr/xsW981yfwbK3XHj/Tm96TgbeT46/BQWzogD0+u6DV1NiMjW6BZQv14EZUs
         LxbkbnxmfMKFdAry2euikf2AUxBWvqNY7kj/+yKwxHc3hOkbGHk8rHITv6+GeoR7OG
         Rs/43AOymlMEg==
Date:   Mon, 4 Jan 2021 12:43:07 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.10 21/63] kernel/io_uring: cancel io_uring before task
 works
Message-ID: <20210104174307.GD3665355@sasha-vm>
References: <20210104155708.800470590@linuxfoundation.org>
 <20210104155709.846535201@linuxfoundation.org>
 <2e03dac2-a91c-ede1-0109-a4d4297e3efd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2e03dac2-a91c-ede1-0109-a4d4297e3efd@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 04:06:39PM +0000, Pavel Begunkov wrote:
>On 04/01/2021 15:57, Greg Kroah-Hartman wrote:
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> commit b1b6b5a30dce872f500dc43f067cba8e7f86fc7d upstream.
>>
>> For cancelling io_uring requests it needs either to be able to run
>> currently enqueued task_works or having it shut down by that moment.
>> Otherwise io_uring_cancel_files() may be waiting for requests that won't
>> ever complete.
>
>Greg, can you drop it from stable for now? I'll backport it later when
>related problems are sorted.

I've dropped it, let us know when it's good to go back in.

-- 
Thanks,
Sasha
