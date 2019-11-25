Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31F26109210
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 17:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbfKYQne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 11:43:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:51286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728853AbfKYQne (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 11:43:34 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5D512068E;
        Mon, 25 Nov 2019 16:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574700214;
        bh=eqvMo5D7hzofPdv1JOg1eL5e1JdmP60ekoC1MW0PnQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VARZVSC00dEJD+LVX5pjDf84R+mTRjzcAUYXtfGtdrvvBm+wpX/cSuTxUAfMqN7ab
         DChKCyyxXXSQqpBqyWFCy+dmMTL6ED+/vrJfdSa+kj3AinwZkBqBQR/LmY1/P/uUOk
         AZngx9FSsvcnHoqZ0MsNgPz6sih+qJKU8wW2B7T4=
Date:   Mon, 25 Nov 2019 11:43:32 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Vinayak Menon <vinmenon@codeaurora.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, akpm@linux-foundation.org,
        hughd@google.com, mhocko@suse.com, minchan@google.com,
        minchan@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] mm/page_io.c: do not free shared swap
 slots" failed to apply to 4.19-stable tree
Message-ID: <20191125164332.GG5861@sasha-vm>
References: <1574095036140231@kroah.com>
 <20191118164038.GA595410@kroah.com>
 <0101016e834f2833-62565910-1153-4759-bed3-4779158dc514-000000@us-west-2.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <0101016e834f2833-62565910-1153-4759-bed3-4779158dc514-000000@us-west-2.amazonses.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 10:57:13AM +0000, Vinayak Menon wrote:
>
>On 11/18/2019 10:10 PM, Greg KH wrote:
>> On Mon, Nov 18, 2019 at 05:37:16PM +0100, gregkh@linuxfoundation.org wrote:
>>> The patch below does not apply to the 4.19-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>> Note, this applies, but just breaks the build, so it needs a backport
>> for 4.19 if people want to see it there.
>
>The version below fixes the build on 4.19.

I've fixed it up based on the version sent by Vinayak and queued it up
for 4.19.

-- 
Thanks,
Sasha
