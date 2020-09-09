Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEF6263947
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 00:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgIIWov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 18:44:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgIIWou (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Sep 2020 18:44:50 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FFD620C09;
        Wed,  9 Sep 2020 22:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599691490;
        bh=GkFvpVIk+TosO5TEhb/X6RgmMsdEEkZC2rbTVH6v9cA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CNJH5XjB9wFkM5c5plHaGCMWckBcoffNsvZ9Fd0RFQDmPABXSQw2R+05Mkg6BVyAQ
         anQmVggtbgrviFdYFdFTvCLvo1uTEgvSZEpK3LJsdnajeXKwEoXPZuB4D9ZHyHxlZN
         H/IbeUkgDkJRns4JX0GU9V8VZdLAIK9cbvtVt6u8=
Date:   Wed, 9 Sep 2020 18:44:48 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: 5.8 stable inclusion request
Message-ID: <20200909224448.GU8670@sasha-vm>
References: <fc20c685-8cd1-37f3-8c8f-9ce70b0911c1@kernel.dk>
 <cf6761b6-2f20-9d0b-9f4c-dfde1d567beb@kernel.dk>
 <c8d92453-94e9-d3f9-70b7-a42bfa005e79@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c8d92453-94e9-d3f9-70b7-a42bfa005e79@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 08, 2020 at 07:53:47AM -0600, Jens Axboe wrote:
>On 9/8/20 7:45 AM, Jens Axboe wrote:
>> On 9/8/20 7:29 AM, Jens Axboe wrote:
>>> Hi,
>>>
>>> Can I get these two queued up, in this order:
>>>
>>> commit b7ddce3cbf010edbfac6c6d8cc708560a7bcd7a4
>>> Author: Pavel Begunkov <asml.silence@gmail.com>
>>> Date:   Sun Sep 6 00:45:14 2020 +0300
>>>
>>>     io_uring: fix cancel of deferred reqs with ->files
>>>
>>> and
>>>
>>> commit c127a2a1b7baa5eb40a7e2de4b7f0c51ccbbb2ef (tag: io_uring-5.9-2020-09-06, origin/i
>>> o_uring-5.9, io_uring-5.9)
>>> Author: Pavel Begunkov <asml.silence@gmail.com>
>>> Date:   Sun Sep 6 00:45:15 2020 +0300
>>>
>>>     io_uring: fix linked deferred ->files cancellation
>>>
>>> which should both cherry-pick cleanly into the 5.8-stable tree.
>>
>> They do pick cleanly, but missing some infrastructure... I'll send these
>> in separately.
>
>Here you go, these work and are tested.

Queued up, thanks!

-- 
Thanks,
Sasha
