Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7252729DA25
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 00:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgJ1XPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 19:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390273AbgJ1XPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 19:15:05 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 262F6206FB;
        Wed, 28 Oct 2020 23:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603926905;
        bh=fOIDlzpAqyABbNY+P2PRe8x4YzZuz/sC9KM32cPf/5M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XPZq4sY3JCfcvIVrQAwM1oC0gWhP6h5YPUDArmR+ONvM4tynk3CEsW8qGYCASu0vh
         owY/MeP5chXdGoqazdeGOprfjWlhBpOHtLIWsjmB134vYw3q3MXsPR5Xy7Xl5lNOHB
         PAieaYoy9HIidmKLa3WUf7sH5XDVAbOjg/9KmPcM=
Date:   Wed, 28 Oct 2020 19:15:03 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/191] 4.14.203-rc1 review
Message-ID: <20201028231503.GE87646@sasha-vm>
References: <20201027134909.701581493@linuxfoundation.org>
 <20201028170853.GC118534@roeck-us.net>
 <20201028195610.GB124982@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201028195610.GB124982@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 28, 2020 at 12:56:10PM -0700, Guenter Roeck wrote:
>Retry.
>
>On Wed, Oct 28, 2020 at 10:08:53AM -0700, Guenter Roeck wrote:
>> On Tue, Oct 27, 2020 at 02:47:35PM +0100, Greg Kroah-Hartman wrote:
>> > This is the start of the stable review cycle for the 4.14.203 release.
>> > There are 191 patches in this series, all will be posted as a response
>> > to this one.  If anyone has any issues with these being applied, please
>> > let me know.
>> >
>> > Responses should be made by Thu, 29 Oct 2020 13:48:36 +0000.
>> > Anything received after that time might be too late.
>> >
>>
>> Build results:
>> 	total: 168 pass: 166 fail: 2
>> Failed builds:
>> 	powerpc:defconfig
>> 	powerpc:allmodconfig
>> Qemu test results:
>> 	total: 404 pass: 385 fail: 19
>> Failed tests:
>> 	<various powerpc64>
>>
>> Error log:
>> arch/powerpc/platforms/powernv/opal-dump.c: In function 'process_dump':
>> arch/powerpc/platforms/powernv/opal-dump.c:409:7: error: void value not ignored as it ought to be

I'll grab b29336c0e178 ("powerpc/powernv/opal-dump : Use IRQ_HANDLED
instead of numbers in interrupt handler") to fix that, thanks!

-- 
Thanks,
Sasha
