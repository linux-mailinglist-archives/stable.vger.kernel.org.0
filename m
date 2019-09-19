Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81FE6B70C6
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 03:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387812AbfISB02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 21:26:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387790AbfISB01 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 21:26:27 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75DFE21929;
        Thu, 19 Sep 2019 01:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568856387;
        bh=ZfiDspvJOuCGtSRwcP0HLJfYq04A5tt/6W88lsnxT34=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=r33y8fA4h5SG6PL6g15ar+nL6jQ3x3Je6k68k1xRemGhL4gJUzZStGUrJKsAt1jwa
         4MuQ+8PmtsTR2e/ojhEYnO9nlmlst8hccvrISWUyESK0cj5q3FIVkPKHDo/+4MbqmD
         +7Oi9/6lic26m7OgBRRIODrv7Dl6bdiWya07SYgY=
Subject: Re: [PATCH 4.14 00/45] 4.14.145-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190918061222.854132812@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <330b4273-2ca1-b437-0ff0-c458ba31f88b@kernel.org>
Date:   Wed, 18 Sep 2019 19:26:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190918061222.854132812@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/18/19 12:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.145 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 20 Sep 2019 06:09:47 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.145-rc1.gz
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
