Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47E93BE7C4
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 14:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhGGM2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 08:28:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231490AbhGGMZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Jul 2021 08:25:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C498861C7C;
        Wed,  7 Jul 2021 12:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625660569;
        bh=FgydnXf66Ffvi5ZvS3F+GWvF3EJtX6o9wgasRJCgi3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zm5SP/ODlAaVW7JafHeUJ9dFVYj1klJ7Qi2vvDe/BkQcLPNIpmzdb6dg98NY/6WVK
         +cL1Aeb05LINNLP1MtW8lO00GhRqLAbXNO3MfEyeyi6uRZ4QaCQra9cfgkzir42n5z
         sLCE3CcQ0WzmxVoE9uDihioxs4Bg8E6OURmYSIhAx0lRgMUhlgIyFgTPSfcEH67J/c
         zxihK/ktJ1EICAfC1Pf2kDIqneqBbvzcUySwTMTqmNrgTvt4P58jGJUaVt+WYD3Wzy
         hdnUYEI8u1B5xqVNL5dZfsBKe04qIfekTBASz2FlEP51dZVdXzwGuJ84JhpwtGvMm2
         swXplRIFs/jug==
Date:   Wed, 7 Jul 2021 08:22:47 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Fox Chen <foxhlchen@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.13 0/2] 5.13.1-rc1 review
Message-ID: <YOWclyfwF0XxTkad@sashalap>
References: <20210705105656.1512997-1-sashal@kernel.org>
 <60e3539b.1c69fb81.e1511.17c0@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <60e3539b.1c69fb81.e1511.17c0@mx.google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 05, 2021 at 11:46:51AM -0700, Fox Chen wrote:
>On Mon,  5 Jul 2021 06:56:54 -0400, Sasha Levin <sashal@kernel.org> wrote:
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
>>
>
>5.13.1-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
>
>Tested-by: Fox Chen <foxhlchen@gmail.com>

Thanks for testing Fox!

-- 
Thanks,
Sasha
