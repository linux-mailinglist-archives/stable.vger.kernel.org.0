Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC894178FB
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 18:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbhIXQnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 12:43:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233969AbhIXQnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 12:43:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7C9260EE7;
        Fri, 24 Sep 2021 16:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632501718;
        bh=H423tEhL4STBIrStMHc+PhfbtwH8UWS0A41glaA+Nl4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AD1A1IDaA7kbGa5je+K+I6q33oR96VpWsUQJmPi4SDadXyUKmTxvCX4wkaXt4Ww0s
         zcdzOXuqCsfEDdbjhiefCfK6MTXQ49HZyBWn9xERTLwIKUG9nQ+UinMez/YEy4j25j
         395etTNWCWl7s3X0+L2NOYf1LaOq1vROR6q7WyafXG9D0k5V6prMgR2mgUHBuqI+N6
         sIXFlHulGnT11e3O7BtsIZjyjuS1FdBA8XRWK1VhAl60ER8SKwqfAefbcG7S9J2rh+
         VZxpGPgJ1oNDiTiOJWbUUeEduvJ80v4DQ3RVZVuOrIJZl0ron98N8sylPrXCNecj6U
         8FBuwO8BD5pJw==
Date:   Fri, 24 Sep 2021 12:41:56 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH stable 4.9 v2 0/4] ARM: ftrace MODULE_PLTS warning
Message-ID: <YU3/1I7BfyINCb9W@sashalap>
References: <20210922170246.190499-1-f.fainelli@gmail.com>
 <YUxYV/m36iPuxdoe@kroah.com>
 <YU2769mOr3lb8jFi@sashalap>
 <bb9fde7d-3644-6d30-c238-73427ab200e6@nokia.com>
 <34ae79e3-f109-bc4b-341a-f05d95cf15e3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <34ae79e3-f109-bc4b-341a-f05d95cf15e3@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 24, 2021 at 09:11:18AM -0700, Florian Fainelli wrote:
>On 9/24/21 8:27 AM, Alexander Sverdlin wrote:
>> Hi Sasha,
>>
>> On 24/09/2021 13:52, Sasha Levin wrote:
>>>>> This patch series is present in v5.14 and fixes warnings seen at insmod
>>>>> with FTRACE and MODULE_PLTS enabled on ARM/Linux.
>>>>
>>>> All now queued up, thanks.
>>>
>>> Looks like 4.19 and older break the build:
>>>
>>> arch/arm/kernel/ftrace.c: In function 'ftrace_update_ftrace_func':
>>> arch/arm/kernel/ftrace.c:157:9: error: too few arguments to function 'ftrace_call_replace'
>>>   157 |   new = ftrace_call_replace(pc, (unsigned long)func);
>>>       |         ^~~~~~~~~~~~~~~~~~~
>>
>> in principle you can add ", true" as a third argument in all these ftrace_call_replace()
>> call-sites which still have two args.
>
>Sasha, what configuration failed to build? I build tested with
>mutli_v7_defconfig which does enable FTRACE by default and then ensured
>that CONFIG_ARM_MODULE_PLTS was enabled. From there I will re-submit,
>sorry about that.

allmodconfig seemed to have hit that.

-- 
Thanks,
Sasha
