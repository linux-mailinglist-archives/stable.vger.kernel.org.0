Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDC11FA11D
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 22:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731461AbgFOUQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 16:16:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731456AbgFOUQM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 16:16:12 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A4C920756;
        Mon, 15 Jun 2020 20:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592252171;
        bh=6LbtN5JNBwd1hnecz5hzaaaiv83q3/UFo1YZ5dgSZxM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JSuR6+Ro796J2rtokN87zxcx0mdb9tjByhto9FcLKXzQdtHZxWg7aP38fv6V3c5Fg
         3KbHbKf9nYp4ZriviE6ePLcE062HZcDH0RvAxJ4SGYpNpLKPvm0AryKNhTZsBOTinL
         vXMnuU4JK/YfCc6otKBiw2I0kzzOvYYAlyjzvEUM=
Date:   Mon, 15 Jun 2020 16:16:10 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     gregkh@linuxfoundation.org, asml.silence@gmail.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: fix flush req->refs underflow"
 failed to apply to 5.6-stable tree
Message-ID: <20200615201610.GA1931@sasha-vm>
References: <159222954019964@kroah.com>
 <a4ac1fdd-576c-9cff-bc54-4d090f2bad2c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a4ac1fdd-576c-9cff-bc54-4d090f2bad2c@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 09:18:29AM -0600, Jens Axboe wrote:
>On 6/15/20 7:59 AM, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 5.6-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>
>Greg, if you could cherry pick this one:
>
>commit d8f1b9716cfd1a1f74c0fedad40c5f65a25aa208
>Author: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>Date:   Sun Apr 26 15:54:43 2020 +0800
>
>    io_uring: fix mismatched finish_wait() calls in io_uring_cancel_files()
>
>first (which should also go into stable), the below will apply without
>conflicts after that.

I've grabbed both, thanks!

-- 
Thanks,
Sasha
