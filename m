Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9333BE7CC
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 14:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhGGM3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 08:29:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231535AbhGGM2k (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Jul 2021 08:28:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DF9561C7C;
        Wed,  7 Jul 2021 12:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625660751;
        bh=4+E6IRgEw+Frz4EywbVTL+aJHAUP2YxLdlhixR5dFsg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CDdiDce6NJuwMVlRBmR5jbspcXj/O25Ug/ZZoCTMizT6r4/sFA02nQIww2Lg6S+zN
         203dn0rpTSyf44QXFdtkmgW4T136icD7BVQiNXYSfXzRkVfg34oLV6HbvbHy6tvQoD
         m9iyfR2eUcA8csaYMJUWGpD/ZASqHmj5oSo6dXQsqkYW1KxZzK9oNiMzea95R0xmvj
         /7Em4brPxq0rOyr8GaH3BXrPFzbFxvYSxt2SEiYoIlGpgr/MfnJ/odk0A2Xtw17Kzz
         sQYxOsUyYh4KQFDaCWtT79lqyv6ZvRjUSJ3ByOOopA3yB5lAjniO7sD1RhI+kaAMe4
         r3CLNU6Frlfow==
Date:   Wed, 7 Jul 2021 08:25:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.13 0/2] 5.13.1-rc1 review
Message-ID: <YOWdTpGb86UKV/1f@sashalap>
References: <20210705105656.1512997-1-sashal@kernel.org>
 <CA+G9fYvETgFUefSkrsZ5DaBomzZm5dzrh8HHLJJWX6egTPvhwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvETgFUefSkrsZ5DaBomzZm5dzrh8HHLJJWX6egTPvhwQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 06, 2021 at 10:19:14AM +0530, Naresh Kamboju wrote:
>On Mon, 5 Jul 2021 at 16:27, Sasha Levin <sashal@kernel.org> wrote:
>>
>>
>> This is the start of the stable review cycle for the 5.13.1 release.
>> There are 2 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed 07 Jul 2021 10:49:46 AM UTC.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.13.y&id2=v5.13
>> or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
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
