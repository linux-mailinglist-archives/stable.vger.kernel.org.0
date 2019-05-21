Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99826259F7
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 23:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbfEUVbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 17:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727174AbfEUVbL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 17:31:11 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 937D52173E;
        Tue, 21 May 2019 21:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558474271;
        bh=IM+0zDc6qJKlOrMcshdncbuzWANqW/e5s5/hIM/76Oc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=2dW2IO0+yuyGe7Ic0c9xu6Q3b9cTvh+VDob/BeUYABF4tVFG/ZZoiOZv5qMeRkX6Q
         +9mrhiwYOU08ia+ZVKCje5B+xyHjd/ZzqHWdpYqUm6MXIEwufKgQ9p0A1FY0rhY4G8
         KMjgtbubfT8FQb2xS+tcBjHrzUOaY5zeEeRgfo/s=
Subject: Re: [PATCH 4.19 000/105] 4.19.45-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190520115247.060821231@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <268ea792-c6dd-8c67-b669-63d5507d0ae2@kernel.org>
Date:   Tue, 21 May 2019 15:31:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/20/19 6:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.45 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 22 May 2019 11:50:49 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.45-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------


Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

