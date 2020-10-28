Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D0829DB1B
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 00:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733136AbgJ1XnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 19:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732872AbgJ1Wvr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:51:47 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CEF120731;
        Wed, 28 Oct 2020 22:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603925506;
        bh=ymrmNnOouzRnAoLQjS8qfIB8n1aY6tlzaesK4lunTLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZqNRjmYztxEwod6JKcPZYJlkNHCMcTZ4CHk2TAmaTIJVgcdQicSpUvvaQAnEQW/jF
         L/VMxubYOqPAxYQaElpiqIRPUCtWR8zLwXCSmaQS1gHdS0/aR8MT3MGbDByo5Db7E1
         ukWljJ8Xs+DiIYsgVlg5EHVAEE8i7kQyX10qBOVg=
Date:   Wed, 28 Oct 2020 18:51:44 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/264] 4.19.153-rc1 review
Message-ID: <20201028225144.GD87646@sasha-vm>
References: <20201027135430.632029009@linuxfoundation.org>
 <20201028171035.GD118534@roeck-us.net>
 <20201028195619.GC124982@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201028195619.GC124982@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 28, 2020 at 12:56:19PM -0700, Guenter Roeck wrote:
>Retry.
>
>On Wed, Oct 28, 2020 at 10:10:35AM -0700, Guenter Roeck wrote:
>> On Tue, Oct 27, 2020 at 02:50:58PM +0100, Greg Kroah-Hartman wrote:
>> > This is the start of the stable review cycle for the 4.19.153 release.
>> > There are 264 patches in this series, all will be posted as a response
>> > to this one.  If anyone has any issues with these being applied, please
>> > let me know.
>> >
>> > Responses should be made by Thu, 29 Oct 2020 13:53:47 +0000.
>> > Anything received after that time might be too late.
>> >
>>
>> Build results:
>> 	total: 155 pass: 152 fail: 3
>> Failed builds:
>> 	i386:tools/perf
>> 	powerpc:ppc6xx_defconfig
>> 	x86_64:tools/perf
>> Qemu test results:
>> 	total: 417 pass: 417 fail: 0
>>
>> perf failures are as usual. powerpc:
>>
>> arch/powerpc/kernel/tau_6xx.c: In function 'TAU_init':
>> include/linux/workqueue.h:427:24: error: too many arguments for format

Right, we don't have 69de8bda87b ("kernel/workqueue: Use dynamic lockdep
keys for workqueues") on 4.19. I've fixed up the patch, thanks!

-- 
Thanks,
Sasha
