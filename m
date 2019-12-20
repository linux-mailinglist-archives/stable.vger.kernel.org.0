Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF63E1274B1
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 05:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfLTEdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 23:33:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727397AbfLTEdh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 23:33:37 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD10A24680;
        Fri, 20 Dec 2019 04:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576816417;
        bh=Km/GjcwM9C/Ok0diur8EmNZoCdbZfOjmHchT1ws1QXs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=lsKVQcI9UvgCJD+Wu4efNRial7KVRFDBYb8RFRB3vpPDOwFt9M0CawMoSxSHOCPxu
         ARx0r7QKZNKhd63ScbqyW2bzejR7C2laIM3a3P6BFLCKT1de0QWIEY3oWSwJYQo5t2
         N50WCnNZbTOPuXSin/s3XF7QubQmEYYgxmUjBRMs=
Subject: Re: [PATCH 4.19 00/47] 4.19.91-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191219182857.659088743@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <452380a6-fb4a-f5f9-f929-63c87e29a3fd@kernel.org>
Date:   Thu, 19 Dec 2019 21:33:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191219182857.659088743@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/19/19 11:34 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.91 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.91-rc1.gz
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

