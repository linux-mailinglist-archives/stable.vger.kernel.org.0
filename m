Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7611714906C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 22:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgAXVsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 16:48:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:58410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgAXVsD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 16:48:03 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42E8A2075D;
        Fri, 24 Jan 2020 21:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579902482;
        bh=VIqzuqkDa427z8G6DyUP/MArgxRcA5+5Gfd4mJu8j5s=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=CE3PYuVgjkOJL+Ry2/2aRbVwzGB9GLsuCMuLK6jwNL1wl6UxVMjBU6Q97BLyMYhlv
         9LJXO01Jwe08tsD85Q76w69rUyIuv1f4/iaVMovL4tvKi5C6ep2R13pQsByJGjP8d2
         d4Ce69beGMRmb1vh07MB0XGbU7RsZVBoNNMjNSZE=
Subject: Re: [PATCH 4.19 000/639] 4.19.99-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200124093047.008739095@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <1c4d9514-5af3-e864-3527-fa70e2cfa584@kernel.org>
Date:   Fri, 24 Jan 2020 14:48:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/20 2:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.99 release.
> There are 639 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Jan 2020 09:26:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.99-rc1.gz
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
