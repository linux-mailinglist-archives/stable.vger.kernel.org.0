Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEE8298F17
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 15:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780603AbgJZOUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 10:20:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1780601AbgJZOUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 10:20:37 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC90921655;
        Mon, 26 Oct 2020 14:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603722037;
        bh=+jtT9Dd5gq0EQ64eWokptZ7T8YU3szAq4BeVc+N4g3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qgUNHV6WogFxqhvYP6VO/7bj2cCI5DiDh/4resdiRuKXL9RDJqwizfbdZVWV2Tepu
         n6+8vPNfjMAYusFJ5tGOAZONo64wL4JSl6JBwe0Gqo6DjmB8/iiiMN8XpAnbsITPUS
         Eoh4REu6Fm27g/35+pBEfQbJCXSqPZZbIDkYn6K0=
Date:   Mon, 26 Oct 2020 10:20:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Valentin =?utf-8?B?VmlkacSH?= <vvidic@valentin-vidic.from.hr>
Cc:     stable@vger.kernel.org
Subject: Re: Patch "net: korina: fix kfree of rx/tx descriptor array" has
 been added to the 4.4-stable tree
Message-ID: <20201026142035.GH4060117@sasha-vm>
References: <20201026055650.4235D2222C@mail.kernel.org>
 <20201026093931.GE29903@valentin-vidic.from.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201026093931.GE29903@valentin-vidic.from.hr>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 26, 2020 at 10:39:31AM +0100, Valentin Vidić wrote:
>On Mon, Oct 26, 2020 at 01:56:49AM -0400, Sasha Levin wrote:
>> This is a note to let you know that I've just added the patch titled
>>
>>     net: korina: fix kfree of rx/tx descriptor array
>>
>> to the 4.4-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>      net-korina-fix-kfree-of-rx-tx-descriptor-array.patch
>> and it can be found in the queue-4.4 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>
>A followup patch is probably required with this one:
>
>commit 3bd57b90554b4bb82dce638e0668ef9dc95d3e96
>net: korina: cast KSEG0 address to pointer in kfree
>
>Fixes gcc warning:
>
>passing argument 1 of 'kfree' makes pointer from integer without a cast
>
>Fixes: 3af5f0f ("net: korina: fix kfree of rx/tx descriptor array")
>Reported-by: kernel test robot <lkp@intel.com>
>Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
>Link: https://lore.kernel.org/r/20201018184255.28989-1-vvidic@valentin-vidic.from.hr
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

I'll grab that one too, thanks!

-- 
Thanks,
Sasha
