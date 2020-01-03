Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52BFA12FE7B
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 22:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgACVzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 16:55:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:41882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728549AbgACVzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 16:55:19 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43136206DB;
        Fri,  3 Jan 2020 21:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578088518;
        bh=6f58OXQtZPBgcw1mErUcU+eHTTqHlfk1YoLh4McwcVM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=dyLhKKQ1kXssBnwp/dmfDY8vccG01LAznqVSuuJAoV154c8g3uNyfIQgV+1fLNgF1
         iYDKyR2NyOdA6+r0LJa6AHoqk99BujAY3iB+SF0lZx2X/cg3yBNEWmIgQkQh0iMW+n
         VToRqxV4wcGCEjjA7UPOReS6X1g3viGWvgyYcUwU=
Subject: Re: [PATCH 4.19 000/114] 4.19.93-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200102220029.183913184@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <2ab0513c-2a61-d931-37e1-be22c47b0d9d@kernel.org>
Date:   Fri, 3 Jan 2020 14:55:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/2/20 3:06 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.93 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jan 2020 21:58:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.93-rc1.gz
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
