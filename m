Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EED6510D00B
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 01:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfK2ABg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 19:01:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:50448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbfK2ABg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Nov 2019 19:01:36 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41CE821774;
        Fri, 29 Nov 2019 00:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574985695;
        bh=DDrt+6WXuS97tQYR/4Q/h8R5qJM3HjTiZZLEeud8OIA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=WnFb/UvEIC5pf6Fush02BNm4BqdJAh4xRlWSJsianHPHMF2WklxF2Wz4y7o5eBaBs
         mrHkfP3Fw0dmGgpdNVS2lrrD0sP4+WM/bcqqIt4Qe6a0GCwY7sZ0PwMWMfdtNvfnEc
         mJ9PStRnPDY7jkkcZ4vG4U/3pL4AQON6JCOOsJWk=
Subject: Re: [PATCH 4.14 000/211] 4.14.157-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191127203049.431810767@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <f88055c6-f0cf-fa83-c2a9-69f7e364b0b5@kernel.org>
Date:   Thu, 28 Nov 2019 17:01:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/27/19 1:28 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.157 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.157-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

rc2 doesn't boot. I am seeing a different panic. I didn't get a chance
to bisect yet.

thanks,
-- Shuah
