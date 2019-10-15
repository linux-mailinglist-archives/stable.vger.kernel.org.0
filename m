Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 114ACD8332
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 00:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388788AbfJOWEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 18:04:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387411AbfJOWEl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Oct 2019 18:04:41 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32B3F21A49;
        Tue, 15 Oct 2019 22:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571177080;
        bh=bEz6VCO4JTI+Xylf3IoX+njYEaKlxKQAsOEkVTvjUNE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e1xOJVfWV9ix0vZr4g+UcrmKP4/FNC6MKcH8FDdA/I5R3HIFxIYH2YeuXEgpaxUkC
         uaRVTzg8A/NYCb+zGNG1CgFiD6dzRlLj9y7QwNE++a3RWzzsXIZZq7hDJEXkQ1wJ1O
         mHHnBfUhy9zlgXC0SbhsSnKToKFyJAWmOPnAit4c=
Date:   Tue, 15 Oct 2019 18:04:39 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     John Garry <john.garry@huawei.com>
Cc:     stable@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
        rjw@rjwysocki.net, lenb@kernel.org, sudeep.holla@arm.com,
        rrichter@marvell.com, jeremy.linton@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linuxarm@huawei.com,
        gregkh@linuxfoundation.org, guohanjun@huawei.com,
        wanghuiqiang@huawei.com
Subject: Re: [PATCH for-stable-5.3 1/2] ACPI/PPTT: Add support for ACPI 6.3
 thread flag
Message-ID: <20191015220439.GQ31224@sasha-vm>
References: <1571054162-71090-1-git-send-email-john.garry@huawei.com>
 <1571054162-71090-2-git-send-email-john.garry@huawei.com>
 <20191014232958.GC31224@sasha-vm>
 <635a839b-bc1e-37ab-bd47-a554acc9b282@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <635a839b-bc1e-37ab-bd47-a554acc9b282@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 15, 2019 at 09:16:13AM +0100, John Garry wrote:
>On 15/10/2019 00:29, Sasha Levin wrote:
>>On Mon, Oct 14, 2019 at 07:56:01PM +0800, John Garry wrote:
>>>From: Jeremy Linton <jeremy.linton@arm.com>
>>>
>>>Commit bbd1b70639f785a970d998f35155c713f975e3ac upstream.
>>>
>>>ACPI 6.3 adds a flag to the CPU node to indicate whether
>>>the given PE is a thread. Add a function to return that
>>>information for a given linux logical CPU.
>>>
>>>Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
>>>Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
>>>Reviewed-by: Robert Richter <rrichter@marvell.com>
>>>Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>Signed-off-by: Will Deacon <will@kernel.org>
>>>Signed-off-by: John Garry <john.garry@huawei.com>
>>
>>How far back should these patches be backported?
>>
>
>Hi Sasha,
>
>This patchset is for 5.3, and I sent a separate patchset for 4.19, 
>since the backport is a little different and required some hand 
>modification -
>
>https://lore.kernel.org/linux-arm-kernel/1571046986-231263-1-git-send-email-john.garry@huawei.com/. 
>4.19 is as far back as we want.
>
>Please note that the patches in this 5.3 series are relevant for 5.2 
>also, but since 5.2 is EOL, I didn't mention it. We did test 5.2, so 
>you can add there also.
>
>Please let me know if any more questions.

I've queued this and the 4.19 patches, thanks!

-- 
Thanks,
Sasha
