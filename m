Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55791145D57
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 21:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgAVUxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 15:53:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbgAVUxe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 15:53:34 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 605EA2087E;
        Wed, 22 Jan 2020 20:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579726413;
        bh=rKLtHT8h5JDqC6ZYUnmVyuld6JG6lU5zosUdYC3Vuig=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=adG6B7LlrmtkWvzEWO4JukouKSm4bkBM9ZYrpGZVHaWw2M45fMEJ/a9xQ/3lmqi3y
         pyI+/a3jrn5wrc6LeBI4rvkFSUcdU/YkuQPTZqJ4vFwSlU6/5ToYq0Cb/ZwTqBeXQc
         5CGKr0fPqtKkRaRiWGTD5D0rn6ExlEN/NXb8DDD8=
Subject: Re: [PATCH 4.14 00/65] 4.14.167-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200122092750.976732974@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <ef8ca639-e0ae-359d-eca9-70a8034115bd@kernel.org>
Date:   Wed, 22 Jan 2020 13:53:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200122092750.976732974@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/22/20 2:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.167 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.167-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
