Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228D41EB407
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 05:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgFBD6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 23:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFBD6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 23:58:40 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D70020734;
        Tue,  2 Jun 2020 03:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591070320;
        bh=gIVAg1AYe2UoKUxx7CBWqurwzLCMENcvYb9p2RxgdVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ICUBCfzHiyOUU7Irooy2E+FAGhbnIjcpgvqP945TO4wIQCw/YIzGghED4GMggHhsd
         6JbL/2J50P90vC8ReqISPr/C3EbORCNDVKb8FAJ9+mfc7YfhqR383D1QMJfx0ZMufS
         ucpYOuPcZ10h97CgW8CZjJHGb+6fXklI0MmtPfk8=
Date:   Mon, 1 Jun 2020 23:58:39 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: List of patches to apply to stable releases (5/26)
Message-ID: <20200602035839.GP1407771@sasha-vm>
References: <20200527045828.GA2874@roeck-us.net>
 <20200601165835.GC1037203@kroah.com>
 <20200601192254.GA31870@roeck-us.net>
 <20200602033032.GO1407771@sasha-vm>
 <2177ee1f-2603-d570-e80c-902fcab5e989@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2177ee1f-2603-d570-e80c-902fcab5e989@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 01, 2020 at 08:45:19PM -0700, Guenter Roeck wrote:
>On 6/1/20 8:30 PM, Sasha Levin wrote:
>> On Mon, Jun 01, 2020 at 12:22:54PM -0700, Guenter Roeck wrote:
>>> Anyway, my script also tells me:
>>>
>>> Upstream commit a33a5d2d16cb ("genirq/generic_pending: Do not lose pending affinity update")
>>>  upstream: v4.18-rc1
>>>    Fixes: 98229aa36caa ("x86/irq: Plug vector cleanup race")
>>>      in linux-4.4.y: 996c591227d9
>>>      upstream: v4.5-rc2
>>>    Affected branches:
>>>      linux-4.4.y (queued)
>>>      linux-4.9.y (queued)
>>>      linux-4.14.y
>>>
>>> and, indeed, it looks like a33a5d2d16cb is missing in v4.14.y-queue.
>>
>> I think that Greg's script didn't like a33a5d2d16cb pointing to the
>> wrong "fixes:" commit - 996c591227d9 rather than 98229aa36caa.
>>
>
>Interesting. Makes me wonder how my script found the correct reference.

FWIW, my scripts always try translating any commit id pointed to by a
tag into an "upstream commit id". This is mostly helpful with tags
pointing to linux-next commits or commits in private trees, but I
suppose it's also useful for cases such as the above :)

>But then why did his script pick it up for 4.4.y and 4.9.y ?

I can try and guess: Greg's to-do list has an item named "Figure out why
I had to apply a33a5d2d16cb manually" :)

-- 
Thanks,
Sasha
