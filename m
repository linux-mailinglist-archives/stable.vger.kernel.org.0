Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDDA18FA00
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 17:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbgCWQhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 12:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727491AbgCWQhy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Mar 2020 12:37:54 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA12F20658;
        Mon, 23 Mar 2020 16:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584981474;
        bh=Jt5JuMiyVi9dnUGvUKFjt0oKs6/jjrV4SQpHwbkHJw0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pz04NQh3GMIPzJnPY2AyGTZIQ0ioarP4Gt0ZwewfL9s3p6xNACgGe4KKSmeI7oaDQ
         G+/q1KGPGvSgwwuVJ/sV2tNfjBEYJyVtbG3HG5PmuScdfOgeGa8cal/T8+qQ1K4N9r
         +PE0rK5xX4DROJ8OtaYhBRffq2v/lvrX96AhNOUk=
Date:   Mon, 23 Mar 2020 12:37:52 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     gregkh@linuxfoundation.org, asml.silence@gmail.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: NULL-deref for
 IOSQE_{ASYNC,DRAIN}" failed to apply to 5.5-stable tree
Message-ID: <20200323163752.GX4189@sasha-vm>
References: <158497417567105@kroah.com>
 <c2b8bb83-3b0e-1061-5966-00ac52a4dccd@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c2b8bb83-3b0e-1061-5966-00ac52a4dccd@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 23, 2020 at 08:59:09AM -0600, Jens Axboe wrote:
>On 3/23/20 8:36 AM, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 5.5-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>
>Here's a tested backport, thanks for letting us know!

Queued up, thanks!

-- 
Thanks,
Sasha
