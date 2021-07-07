Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAF23BE7CF
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 14:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbhGGM3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 08:29:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231544AbhGGM3C (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Jul 2021 08:29:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57B2761C9A;
        Wed,  7 Jul 2021 12:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625660772;
        bh=11lOiGzZ8MMp6UljGklTfsKhM+XQRYH5sXa9bM4YRZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J5Qg7qpuviwAH+mgYeKrwrIYLIc7i3BuzSv1U3Vcu15ygHw8XaQbswqAB7/44JD5G
         mk/7Kx0naFUiIUzA3MniJUJgbP6nMncesippZytXKC+f0N8h7xoQarUEbeUBgQcXJg
         +wlFTJnprlBmZWGsgb/T096vT1mdWOHUm+l7Ud6fRWN4oLRemJ3KhbOh98RjXeFtJ7
         a4xTPpVOPkxeY9RW5pxd35KDk+g3Y2zK3fC7mSjGFLQKU/t+4aDB0RdLPKy0PAotK4
         pQsgdkl55x/AqNjuHG/c+If3mdhc0suXceu6hU+TeRFl3EOyR18KqiJeG97P6kKo9U
         agJjNJUQ4ZzCw==
Date:   Wed, 7 Jul 2021 08:26:11 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.13 0/2] 5.13.1-rc1 review
Message-ID: <YOWdY5d1s71ytyEm@sashalap>
References: <20210705105656.1512997-1-sashal@kernel.org>
 <41c9c1e8-f151-a8c4-2681-f8700aa6a9a5@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <41c9c1e8-f151-a8c4-2681-f8700aa6a9a5@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 06, 2021 at 04:43:30PM -0600, Shuah Khan wrote:
>On 7/5/21 4:56 AM, Sasha Levin wrote:
>>
>>This is the start of the stable review cycle for the 5.13.1 release.
>>There are 2 patches in this series, all will be posted as a response
>>to this one.  If anyone has any issues with these being applied, please
>>let me know.
>>
>>Responses should be made by Wed 07 Jul 2021 10:49:46 AM UTC.
>>Anything received after that time might be too late.
>>
>>The whole patch series can be found in one patch at:
>>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.13.y&id2=v5.13
>>or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
>>and the diffstat can be found below.
>>
>>Thanks,
>>Sasha
>>
>
>Compiled and booted on my test system. No dmesg regressions.
>
>Tested-by: Shuah Khan <skhan@linuxfoundation.org>

Thanks for testing Shuah!

-- 
Thanks,
Sasha
