Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0AD125405
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 22:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfLRVAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 16:00:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:42806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbfLRVAZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 16:00:25 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD27F21582;
        Wed, 18 Dec 2019 21:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576702825;
        bh=ZNJraewX/i31LpNaURIQAkN2DiYLTRgEHkAUTtmT1H4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=YNikuLqKHLwdudaWg4x2OkKj0HtoyhAF75eqIJkPUFiI9YDynEKF3aE6T2RUhMT+B
         USCUGGDPbbJ02fHeEZNKdPfnkttfVcQkbgWmtVf2fJqOza7Jv3YR6WhXj9vkc2/Qnv
         d8CzXtzLkn17rE/PDNFtmUEWUwI/qeD3Drl4nvLk=
Subject: Re: [PATCH 5.3 00/25] 5.3.18-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191217200903.179327435@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <45d3dbe7-fb86-e937-3da6-27d12c5de832@kernel.org>
Date:   Wed, 18 Dec 2019 14:00:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191217200903.179327435@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/17/19 1:15 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.18 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Note, this is the LAST 5.3.y kernel to be released, after this one, it
> will be end-of-life.  You should have moved to the 5.4.y series already
> by now.
> 
> Responses should be made by Thu, 19 Dec 2019 20:08:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

