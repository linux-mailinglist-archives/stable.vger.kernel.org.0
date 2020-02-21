Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C853D168710
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 19:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbgBUSzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 13:55:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729397AbgBUSzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 13:55:50 -0500
Received: from localhost (unknown [73.61.17.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AD7020578;
        Fri, 21 Feb 2020 18:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582311349;
        bh=CzfU9GB6VhqeyGdmd1CGoDtXuLwG9/WAXjiadWDIAUs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iWvgPtC6bA708AtAM+hqQ61QxjY/3nta6lM1+YZTS8axTLr5KRCFrWvBz4RjnTrwd
         ra+O8NgmYcJ8o1tGmSgTDd++4boZXMkGqhUv93WdUApCSLr4nmtLdvnIBH+QYf1/6r
         7oAYLh9t3ttLIa5IBgQv7iJqxUKIt+9952PPTPh4=
Date:   Fri, 21 Feb 2020 13:55:46 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/344] 5.4.22-stable review
Message-ID: <20200221185546.GB1449@sasha-vm>
References: <20200221072349.335551332@linuxfoundation.org>
 <4e8cb265-4745-4249-45e4-86bd84f068ed@roeck-us.net>
 <9f719752c33321fca7280a5cc59a886e1dd0dfda.camel@codethink.co.uk>
 <20200221155507.GB11868@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200221155507.GB11868@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 21, 2020 at 07:55:07AM -0800, Guenter Roeck wrote:
>On Fri, Feb 21, 2020 at 03:21:30PM +0000, Ben Hutchings wrote:
>> On Fri, 2020-02-21 at 06:28 -0800, Guenter Roeck wrote:
>> [...]
>> > Building powerpc:defconfig ... failed
>> > Building powerpc:mpc83xx_defconfig ... failed
>> > --------------
>> > Error log:
>> > drivers/rtc/rtc-ds1307.c:1570:21: error: variable 'regmap_config' has initializer but incomplete type
>> >
>> > as well as various follow-up errors.
>> >
>> > The second problem affects both v5.4.y and v5.5.y.
>>
>> This seems to be caused by commit 34719de919af (rtc-i2c-spi-avoid-
>> inclusion-of-regmap-support-when-n.patch).  These branches will need
>> commit 578c2b661e2b "rtc: Kconfig: select REGMAP_I2C when necessary" as
>> well.
>>
>
>Yes, I recall we had the same problem before, and the offending patch
>was removed from the queue. Wonder how it made it back in without the
>context patch (which either you or someone else also reported at the time).

The first time was Greg picking it up, the second time it was me :)

My build bot is busted, and I'm working on repairing it, appologies for
the noise.

I've grabbed 578c2b661e2b for both 5.5 and 5.4.

-- 
Thanks,
Sasha
