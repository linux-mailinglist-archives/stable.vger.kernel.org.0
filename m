Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52FDD298F1A
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 15:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780788AbgJZOWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 10:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1780745AbgJZOWA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 10:22:00 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAC9D21655;
        Mon, 26 Oct 2020 14:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603722120;
        bh=qMwX55k216JAdqAI7jPwmD5XnNj9qoOif8zLlNVzfzE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0hlAHC3IAN5fsD43BvIZssd4HiriXGhvXZsd5Kn3vKvFZGkajUKAooEQoqxcnVsI0
         resilyH1NLjiAzRQMBGz1qMQK8LgCQcMHPNR1s2PwsMChgAC7iW2D96RZdUc+SRTuW
         P9CEi7x4bX4zQge8YkxozHHjvXDdOOB3a+OpSJtU=
Date:   Mon, 26 Oct 2020 10:21:58 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jann Horn <jannh@google.com>
Cc:     stable <stable@vger.kernel.org>, stable-commits@vger.kernel.org
Subject: Re: Patch "mm/mmu_notifier: fix mmget() assert in
 __mmu_interval_notifier_insert" has been added to the 5.8-stable tree
Message-ID: <20201026142158.GI4060117@sasha-vm>
References: <20201026053052.9CB982085B@mail.kernel.org>
 <CAG48ez3gb8E34ePqSmmqhadfLMsLFiNhX=fmCRZKNfSQztXcMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAG48ez3gb8E34ePqSmmqhadfLMsLFiNhX=fmCRZKNfSQztXcMQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 26, 2020 at 10:25:08AM +0100, Jann Horn wrote:
>On Mon, Oct 26, 2020 at 6:30 AM Sasha Levin <sashal@kernel.org> wrote:
>>
>> This is a note to let you know that I've just added the patch titled
>>
>>     mm/mmu_notifier: fix mmget() assert in __mmu_interval_notifier_insert
>>
>> to the 5.8-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>      mm-mmu_notifier-fix-mmget-assert-in-__mmu_interval_n.patch
>> and it can be found in the queue-5.8 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>
>This patch has no reason to go into the stable trees. It just makes an
>assertion stricter (mm_users>0 implies mm_count>0). It only has an
>effect if your kernel is horrendously broken anyway.
>
>Please take it out of the stable queue.

Will do.

-- 
Thanks,
Sasha
