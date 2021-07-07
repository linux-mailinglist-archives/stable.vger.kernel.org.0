Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799953BE7D5
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 14:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhGGMaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 08:30:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231683AbhGGM3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Jul 2021 08:29:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1569861C82;
        Wed,  7 Jul 2021 12:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625660834;
        bh=eh7CePvQmxyFz8jXmVrTvteJpXfCq8titXSEHEgtFTs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BWGSsE5kFJGUojHjZuAX5HdDNcZUkPbkAMibsJe0NVhM6bBFSDqJeX0j8Nat5vqQj
         LyHiTM9cFv1DTpJwiWjs/dU0MVluvB5u1KZ9sF1o/x7fvw+r0ianoy/uUpqjRsZIBk
         udT0OxJvyCQST4sC010unPw4jW3blec+uZNeHK3sT33d/evwhYGdRo3xspKTOW3eCP
         8E4Ne4Jq0h2lGES4+YOSK/wN8+IHhOq5BioMgqu6RM35b2uJlhIPVgtO9sR23sgbce
         wIYmRSot6QihoHcj6Ukv32SomYCdsL0PSfu1iXcot5IZqjYZji2/49Stmo+/egd018
         sQnQ4PllPI68g==
Date:   Wed, 7 Jul 2021 08:27:13 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Justin Forbes <jmforbes@linuxtx.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.12 0/7] 5.12.15-rc1 review
Message-ID: <YOWdoZ4CmVwCPN1K@sashalap>
References: <20210705105934.1513188-1-sashal@kernel.org>
 <YOTWGzxh0XpYLlmT@fedora64.linuxtx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YOTWGzxh0XpYLlmT@fedora64.linuxtx.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 06, 2021 at 05:15:55PM -0500, Justin Forbes wrote:
>On Mon, Jul 05, 2021 at 06:59:27AM -0400, Sasha Levin wrote:
>>
>> This is the start of the stable review cycle for the 5.12.15 release.
>> There are 7 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed 07 Jul 2021 10:59:20 AM UTC.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.12.y&id2=v5.12.14
>> or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
>> and the diffstat can be found below.
>>
>> Thanks,
>> Sasha
>>
>
>Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
>s390x, x86_64), and boot tested x86_64. No regressions noted.
>
>Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>

Thanks for testing Justin!

-- 
Thanks,
Sasha
