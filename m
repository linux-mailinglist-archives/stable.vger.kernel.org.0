Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC703B825A
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 14:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbhF3Mr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 08:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234455AbhF3Mrz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 08:47:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF1C161414;
        Wed, 30 Jun 2021 12:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625057126;
        bh=hIOaW6QVozJJ6hKxXGvvM+iqqH3lTzXYXLkr6TWQ7oM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qwuG0vdpwcSGWDSsDmaHYPq5ZYfhAPTwZWmbTrZlFz3G1S8bv/6UaI40Cua+c+IZO
         rG/GhNwCd7bRBDIMBdazTv2TqTuqTwJ7dSGSnOi4hOVhwWbiiL+7lHwSBcssKw1UDv
         jJkaWJgfcv6o17l/L5JJ8NmSWH/prZAa5Z7xgbk47jqCqOx9MWdYhno/U8HHX75LYF
         XnonKQqh/+JlfxPOPgBcug5FjL4a0xPrGM52ZUh3j/zfXp2+VdutdIyenu980+a3RW
         chhldY63mhbz5lfyI+Ib11tBP1407oSYUmHNggGQkFC2RbeLxyqW7jv8Zawj9uEU4L
         t8BClbGZgmNKw==
Date:   Wed, 30 Jun 2021 08:45:25 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.12 000/110] 5.12.14-rc1 review
Message-ID: <YNxnZYrOwOO7Jg/G@sashalap>
References: <20210628141828.31757-1-sashal@kernel.org>
 <CA+G9fYu+8dNjrqdt-c0M60DYZchN5vom-A4NdJSR-R6i7JWYrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYu+8dNjrqdt-c0M60DYZchN5vom-A4NdJSR-R6i7JWYrw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 29, 2021 at 11:40:47AM +0530, Naresh Kamboju wrote:
>On Mon, 28 Jun 2021 at 19:48, Sasha Levin <sashal@kernel.org> wrote:
>>
>>
>> This is the start of the stable review cycle for the 5.12.14 release.
>> There are 110 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed 30 Jun 2021 02:18:05 PM UTC.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.12.y&id2=v5.12.13
>> or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
>> and the diffstat can be found below.
>>
>> Thanks,
>> Sasha
>
>Results from Linaro’s test farm.
>No regressions on arm64, arm, x86_64, and i386.
>
>Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for testing Naresh!

-- 
Thanks,
Sasha
