Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C751F33BF9
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 01:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfFCXdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 19:33:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfFCXdU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 19:33:20 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83D372431A;
        Mon,  3 Jun 2019 23:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559604800;
        bh=nMbjhwrQy5ceP3p5c1t8Ef5q23oPnY223GQrWuxoQxU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=FILtyccGgJNGxf3uG8k4tNhij5FoWxrUJp7r/D9if+7ey4eAibPlpfcoMl203vnQ/
         JSPa7wHqn5ujjPAS6QH5abYvH0C9jwvzmm3Fy/2FLM8jXsM50O4pkCREtnL+wNN85n
         N62jaZmFHmaojPblMyr3DJgzIw2M5nxT7WZHqFVg=
Subject: Re: [PATCH 4.19 00/32] 4.19.48-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190603090308.472021390@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <fbbfaeb3-0126-0dbb-c282-6044c2f20f96@kernel.org>
Date:   Mon, 3 Jun 2019 17:33:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190603090308.472021390@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/3/19 3:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.48 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 05 Jun 2019 09:02:49 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.48-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

