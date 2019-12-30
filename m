Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1842912CBDB
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 03:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfL3CSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 21:18:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbfL3CSz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 21:18:55 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04EC3206DB;
        Mon, 30 Dec 2019 02:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577672334;
        bh=+S4aITAsWobXtF7TxWN6D/spxCJq4OYxcaq0JY4M/I0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=de+UlJpyXM6C2SfNnqpG5JKC519h5f5T971ks1wIJaNZNa9O789lMA+Is63SyYFcI
         6UqoJffqlh4pRccvixtUhzXpm1h4EQnJvk0SQm93Rjl/ZFm17pineFGggZNVnZoRKa
         fxHUCZpAoGjIdjhffSkriPLHgvDzmnbeFe1rVfAY=
Subject: Re: [PATCH 5.4 000/434] 5.4.7-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191229172702.393141737@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <c61bc847-9e64-07da-169a-67964a870b12@kernel.org>
Date:   Sun, 29 Dec 2019 19:18:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/29/19 10:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.7 release.
> There are 434 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 31 Dec 2019 17:25:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
