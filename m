Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C07D3B8258
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 14:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234624AbhF3MqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 08:46:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234618AbhF3MqM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 08:46:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AABE061403;
        Wed, 30 Jun 2021 12:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625057023;
        bh=6eQCqLi4UwS9ODbF08zj/ivRx1G+GVSgJA0ofTI0Tf8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S4RAUmmGsyT3AbcCGQVY/dvMQ5r3yAHjz9sPTUfwN1BbH/uo5FDL/hhhhypjfa3I3
         LfZlu2yb8tgYA2T8E0yE9LydcKDk2pWIOmeySgR98D85yCXgjE7WbMqVBdN3HFEbuA
         0f5x8wTiKqCMd0GD+zWtj7+E/jiMlXkHX2T6r1lCLXF6RuKvZaBqEjSeI5vsKVTazA
         2BlSWo4VW7PfG6CULGppSNJzb9AhSJxGPn8Z5O4g4LpPr7Ykrg4aYT+RRhpz6YKLmR
         A8vmElt9W7Vv06JDQXt+4ReVzvMLZUHrNsrQkY3PnyrQG+TfkVIrabHmN5ONw6Tt1I
         xYXR82hdAXu7w==
Date:   Wed, 30 Jun 2021 08:43:42 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Justin Forbes <jmforbes@linuxtx.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.12 000/110] 5.12.14-rc1 review
Message-ID: <YNxm/mImtMWA9vhx@sashalap>
References: <20210628141828.31757-1-sashal@kernel.org>
 <YNpTAlyLP4wbixpF@fedora64.linuxtx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YNpTAlyLP4wbixpF@fedora64.linuxtx.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 05:53:54PM -0500, Justin Forbes wrote:
>On Mon, Jun 28, 2021 at 10:16:38AM -0400, Sasha Levin wrote:
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
